#!/usr/bin/env bash
set -u

# Coleta de inventário somente leitura para Ubuntu Server.
# Objetivo: mapear ambiente (SO, serviços, VMs, PostgreSQL/PostGIS,
# OpenProject, mounts/Synology, backups, cron/timers, espaço/logs).
# Este script NÃO faz alterações no sistema.

export LC_ALL=C

section() {
  printf '\n\n===== %s =====\n' "$1"
}

cmd_exists() {
  command -v "$1" >/dev/null 2>&1
}

run_cmd() {
  local title="$1"
  shift
  printf '\n--- %s ---\n' "$title"
  if "$@" 2>/dev/null; then
    return 0
  fi
  printf '(sem saída ou sem permissão)\n'
}

run_shell() {
  local title="$1"
  local cmd="$2"
  printf '\n--- %s ---\n' "$title"
  if bash -lc "$cmd" 2>/dev/null; then
    return 0
  fi
  printf '(sem saída ou comando indisponível)\n'
}

line() {
  printf '%s\n' "$*"
}

section "META"
line "Data/Hora (UTC): $(date -u '+%Y-%m-%d %H:%M:%S UTC' 2>/dev/null || echo 'n/d')"
line "Hostname: $(hostname 2>/dev/null || echo 'n/d')"
line "Usuário executor: $(id -un 2>/dev/null || echo 'n/d')"
line "Kernel: $(uname -srmo 2>/dev/null || echo 'n/d')"

section "SISTEMA OPERACIONAL"
run_cmd "release" cat /etc/os-release
run_cmd "uptime" uptime
run_shell "últimos boots" "who -b; last reboot -n 5 | head -n 10"
run_cmd "timezone" timedatectl

section "HARDWARE / CAPACIDADE"
run_shell "CPU (lscpu)" "lscpu | sed -n '1,30p'"
run_shell "Memória" "free -h; echo; vmstat 1 3"
run_shell "Discos (lsblk)" "lsblk -e7 -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINT,MODEL"
run_cmd "uso de disco (df -hT)" df -hT
run_shell "inode usage" "df -ihT"
run_shell "top uso de disco em / (1 nível)" "du -xhd1 / 2>/dev/null | sort -h | tail -n 20"

section "REDE"
run_shell "IPs e interfaces" "ip -brief addr"
run_shell "rotas" "ip route"
run_shell "portas em escuta" "ss -tulpen | sed -n '1,200p'"
if cmd_exists ufw; then
  run_cmd "UFW status" ufw status verbose
fi

section "USUÁRIOS / SSH"
run_shell "usuários locais (UID>=1000)" "awk -F: '(\$3>=1000 && \$1!=\"nobody\"){print \$1\":\"\$3\":\"\$7}' /etc/passwd"
run_shell "grupos administrativos" "getent group sudo; getent group adm"
run_shell "SSH config efetiva (trechos relevantes)" "sshd -T 2>/dev/null | egrep '^(port|maxauthtries|passwordauthentication|permitrootlogin|pubkeyauthentication|allowusers|allowgroups|x11forwarding|clientaliveinterval|clientalivecountmax)'"
run_shell "logins recentes" "last -a -n 20"

section "SERVIÇOS E INICIALIZAÇÃO"
run_shell "serviços falhos" "systemctl --failed --no-pager --no-legend"
run_shell "serviços ativos (top 80)" "systemctl list-units --type=service --state=running --no-pager --no-legend | head -n 80"
run_shell "timers ativos" "systemctl list-timers --all --no-pager"
run_shell "cron (system)" "ls -lah /etc/cron* 2>/dev/null; echo; crontab -l 2>/dev/null || true"

section "VIRTUALIZAÇÃO / CONTAINERS"
run_shell "detecção de virtualização" "systemd-detect-virt 2>/dev/null || true; hostnamectl 2>/dev/null | grep -i 'Virtualization' || true"
if cmd_exists virsh; then
  run_shell "KVM/libvirt VMs" "virsh list --all"
fi
if cmd_exists VBoxManage; then
  run_shell "VirtualBox VMs" "VBoxManage list vms"
fi
if cmd_exists qm; then
  run_shell "Proxmox QEMU VMs" "qm list"
fi
if cmd_exists pct; then
  run_shell "Proxmox LXC" "pct list"
fi
if cmd_exists docker; then
  run_shell "Docker containers" "docker ps -a --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}'"
fi
if cmd_exists podman; then
  run_shell "Podman containers" "podman ps -a --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}'"
fi

section "POSTGRESQL / POSTGIS"
run_shell "pacotes postgres/postgis" "dpkg -l | egrep 'postgresql|postgis' | awk '{print \$1, \$2, \$3}'"
run_shell "clusters (Debian/Ubuntu)" "pg_lsclusters 2>/dev/null || true"
run_shell "processos postgres" "ps aux | egrep '[p]ostgres(:| )' | head -n 50"
run_shell "serviços postgres" "systemctl list-units 'postgresql*' --all --no-pager --no-legend"
if id postgres >/dev/null 2>&1; then
  run_shell "postgres version" "sudo -n -u postgres psql -Atqc 'select version();' || su - postgres -c \"psql -Atqc 'select version();'\""
  run_shell "bases (nome/tamanho)" "sudo -n -u postgres psql -Atqc \"select datname || E'\\t' || pg_size_pretty(pg_database_size(datname)) from pg_database order by 1;\" || su - postgres -c \"psql -Atqc \\\"select datname || E'\\\\t' || pg_size_pretty(pg_database_size(datname)) from pg_database order by 1;\\\"\""
  run_shell "PostGIS por base (se acessível)" "sudo -n -u postgres psql -Atqc \"select datname from pg_database where datallowconn and not datistemplate;\" | while read -r db; do echo \"[\$db]\"; sudo -n -u postgres psql -d \"\$db\" -Atqc \"select extname||':'||extversion from pg_extension where extname='postgis';\" || true; done"
else
  line "Usuário 'postgres' não encontrado."
fi

section "OPENPROJECT"
run_shell "pacotes OpenProject" "dpkg -l | egrep 'openproject' | awk '{print \$1, \$2, \$3}'"
run_shell "serviços OpenProject" "systemctl list-units 'openproject*' --all --no-pager --no-legend"
run_shell "processos OpenProject" "ps aux | egrep '[o]penproject|[p]uma|[s]idekiq' | head -n 50"
run_shell "containers relacionados (docker)" "docker ps -a --format '{{.Names}} {{.Image}} {{.Status}}' 2>/dev/null | egrep -i 'openproject|postgres|pg' || true"

section "ARMAZENAMENTO / MOUNTS / SYNOLOGY"
run_shell "mounts relevantes" "mount | egrep 'type (nfs|nfs4|cifs|smb3|ext4|xfs|btrfs)'"
run_shell "fstab" "sed -n '1,240p' /etc/fstab"
run_shell "NFS mounts" "findmnt -t nfs,nfs4"
run_shell "CIFS/SMB mounts" "findmnt -t cifs,smb3"
run_shell "conexões para NAS (445/2049)" "ss -tnp | egrep ':445 |:2049 ' | head -n 50"

section "BACKUPS (INDÍCIOS)"
run_shell "scripts de backup em /usr/local /opt /root (nomes)" "find /usr/local /opt /root -maxdepth 3 -type f \\( -iname '*backup*' -o -iname '*.sh' \\) 2>/dev/null | head -n 200"
run_shell "jobs agendados com palavras-chave" "grep -RHiE 'pg_dump|pg_basebackup|rsync|restic|borg|rclone|openproject|backup' /etc/cron* 2>/dev/null | head -n 200"
run_shell "timers/services com nome backup" "systemctl list-unit-files --no-pager | egrep -i 'backup|restic|borg|rclone|pg'"
run_shell "snapshots LVM (se houver)" "lvs 2>/dev/null"

section "LOGS / ALERTAS RÁPIDOS"
run_shell "journal erros últimas 24h (top 200)" "journalctl -p err --since '24 hours ago' --no-pager | tail -n 200"
run_shell "kernel warnings/erros últimas 24h" "journalctl -k --since '24 hours ago' --no-pager | egrep -i 'error|fail|warn|oom|I/O' | tail -n 200"
run_shell "auth.log últimas linhas" "tail -n 120 /var/log/auth.log"
run_shell "syslog últimas linhas" "tail -n 120 /var/log/syslog"

section "GIT (PARA OPERACIONALIZAÇÃO)"
run_shell "git instalado" "git --version"
run_shell "repositórios locais em /opt,/srv,/home (até 3 níveis)" "find /opt /srv /home -maxdepth 3 -type d -name .git 2>/dev/null | sed 's#/.git##' | head -n 100"

section "FIM"
line "Inventário concluído."
line "Observação: algumas seções podem exibir 'sem permissão' sem sudo."
