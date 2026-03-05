#!/usr/bin/env bash
set -euo pipefail

# inspect_system.sh
# Gera um relatório abrangente sobre o estado do sistema, Docker, Postgres/PostGIS (host + containers), VMs, rede e backups.
# Uso: sudo ./inspect_system.sh  (requer alguns privilégios para coletar certos artefatos)

timestamp=$(date +%Y%m%d_%H%M)
outfile="inspect_report_${timestamp}.txt"

echo "Gerando relatório em ${outfile}"

{
  echo "===== META / SISTEMA ====="
  date
  uname -a
  lsb_release -a 2>/dev/null || cat /etc/os-release || true
  echo

  echo "===== UPTIME / LOAD ====="
  uptime
  echo

  echo "===== CPU / MEMORIA ====="
  free -h || true
  lscpu || true
  echo

  echo "===== DISCO ====="
  lsblk -o NAME,MAJ:MIN,RM,SIZE,RO,TYPE,MOUNTPOINTS || true
  echo
  df -h || true
  echo

  echo "===== LISTEN PORTS / POSTGRES (HOST) ====="
  ss -ltnp 2>/dev/null | grep -E ':5432|:15432' || ss -ltnp 2>/dev/null || true
  echo
  echo "Postgres service status (host):"
  systemctl status postgresql --no-pager 2>/dev/null || true
  echo

  echo "===== DOCKER: CONTAINERS, IMAGES, VOLUMES, NETWORKS ====="
  if command -v docker >/dev/null 2>&1; then
    docker ps --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}' || true
    echo
    docker ps -a --format '{{.Names}} {{.Image}} {{.Status}}' || true
    echo
    docker images --format '{{.Repository}}:{{.Tag}}\t{{.ID}}\t{{.Size}}' || true
    echo
    docker volume ls || true
    echo
    docker network ls || true
    echo
    echo "Docker system df (disk usage):"
    docker system df || true
    echo
  else
    echo "docker não instalado"
  fi
  echo

  echo "===== POSTGRES (containers) ====="
  # List postgres-like containers
  if command -v docker >/dev/null 2>&1; then
    docker ps --filter ancestor=postgres --format 'table {{.Names}}\t{{.Image}}\t{{.Ports}}' || true
    echo
    for c in $(docker ps --filter ancestor=postgres --format '{{.Names}}' ); do
      echo "--- container: $c ---"
      docker inspect --format '{{json .Config.Env}}' "$c" 2>/dev/null | jq -r '.[]' || true
      docker exec -it "$c" psql -U postgres -c "SELECT version();" 2>/dev/null || true
      docker exec -it "$c" psql -U postgres -c "SELECT PostGIS_full_version();" 2>/dev/null || true
      echo
    done
  else
    echo "no docker"
  fi
  echo

  echo "===== POSTGIS / Postgres (host) ====="
  if command -v psql >/dev/null 2>&1; then
    psql -c 'SELECT version();' 2>/dev/null || true
    psql -c "SELECT PostGIS_full_version();" 2>/dev/null || true
  else
    echo "psql não disponível no host"
  fi
  echo

  echo "===== OPENPROJECT CONFIG (container env / logs) ====="
  if docker ps --format '{{.Names}}' | grep -q '^openproject-web$'; then
    echo "openproject-web environment:"
    docker inspect --format '{{json .Config.Env}}' openproject-web 2>/dev/null | jq -r '.[]' || true
    echo
    echo "openproject-web last 200 log lines:"
    docker logs openproject-web --tail 200 2>/dev/null || true
  else
    echo "openproject-web container not found"
  fi
  echo

  echo "===== BACKUP & ARTEFATOS (locais comuns) ====="
  for d in /srv/data /var/backups /home/*/Projeto /home/*/backups /root; do
    [ -d "$d" ] || continue
    echo "-- listing $d --"
    find "$d" -maxdepth 2 -type f -iname 'coleta_*.tar.gz' -o -iname 'Projeto_pacote_*.tar.gz' -o -iname 'relatorio_*.txt' -o -iname '*.sql*' -print 2>/dev/null | sed -n '1,200p' || true
    echo
  done
  echo

  echo "===== VMs (libvirt/qemu) ====="
  if command -v virsh >/dev/null 2>&1; then
    virsh list --all || true
    echo
    virsh version || true
  else
    echo "libvirt/virsh não disponível"
  fi
  echo

  echo "===== REDE ====="
  ip -br address || true
  echo
  ip route || true
  echo
  echo "FIREWALL (ufw)"
  if command -v ufw >/dev/null 2>&1; then
    ufw status verbose || true
  else
    echo "ufw não instalado"
  fi
  echo

  echo "===== USUÁRIOS / SSH / sudo ====="
  echo "Sudo group members:"
  getent group sudo || true
  echo
  echo "Lists of ssh keys for important users (first lines):"
  for u in admin1 tunnel_externo root; do
    homedir="/home/$u"
    [ "$u" = root ] && homedir="/root"
    if [ -d "$homedir/.ssh" ]; then
      echo "--- $u authorized_keys ---"
      sudo sed -n '1,200p' "$homedir/.ssh/authorized_keys" 2>/dev/null || echo '(empty)'
      echo
    fi
  done
  echo

  echo "===== CRON / TIMERS ====="
  echo "root crontab:"; sudo crontab -l 2>/dev/null || echo '(none)'
  echo
  echo "current user crontab:"; crontab -l 2>/dev/null || echo '(none)'
  echo
  systemctl list-timers --all || true
  echo

  echo "===== LOGS RELEVANTES (últimas linhas) ====="
  echo "syslog (tail 200):"; tail -n 200 /var/log/syslog 2>/dev/null || true
  echo
  echo "docker daemon logs (journal, tail 200):"; journalctl -u docker --no-pager -n 200 2>/dev/null || true
  echo

  echo "===== SUMMARY / SUGESTÕES RÁPIDAS ====="
  echo "- Verificar qual Postgres (host vs container) o OpenProject está configurado para usar (ver env DATABASE_HOST no container web)"
  echo "- Se OpenProject usar 127.0.0.1:15432, ajustar para nome do container DB (openproject-db) ou para host correto"
  echo "- Garantir dumps e backups dos volumes Docker em /srv/data e dos discos de VMs"
  echo

} > "${outfile}" 2>&1

echo "Relatório salvo em ${outfile}"
echo

exit 0
