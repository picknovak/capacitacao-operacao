#!/usr/bin/env bash
set -euo pipefail

timestamp=$(date +%Y%m%d_%H%M)
outfile="relatorio_${timestamp}.txt"

echo "WARNING: This output is designed for human readability. For machine-readable output, adapt the script." >&2

echo "Relatório gerado em ${outfile}"

{ 
  echo "===== SISTEMA ====="
  hostnamectl || true
  echo

  echo "===== UPTIME ====="
  uptime
  echo

  echo "===== CPU / MEMORIA ====="
  free -h || true
  echo
  lscpu | grep -E 'Model name|Architecture' || true
  echo

  echo "===== DISCO ====="
  lsblk -o NAME,MAJ:MIN,RM,SIZE,RO,TYPE,MOUNTPOINTS || true
  echo
  df -h || true
  echo

  echo "===== SMART STATUS (se disponível) ====="
  if command -v smartctl >/dev/null 2>&1; then
    for dev in $(lsblk -dn -o NAME); do
      if [[ -b "/dev/$dev" ]]; then
        echo "--- /dev/$dev ---"
        smartctl -H /dev/$dev 2>/dev/null || true
      fi
    done
  else
    echo "smartctl não encontrado"
  fi
  echo

  echo "===== DOCKER ====="
  if command -v docker >/dev/null 2>&1; then
    docker ps --format 'table {{.ID}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}' || true
    echo
    docker images --format 'table {{.Repository}}:{{.Tag}}\t{{.ID}}\t{{.Size}}' || true
    echo
    docker volume ls || true
  else
    echo "docker não instalado"
  fi
  echo

  echo "===== REDE ====="
  ip -br address || ip addr show || true
  echo
  echo "=== ROTEAMENTO ==="
  ip route show || true
  echo
  echo "===== PORTAS ABERTAS ====="
  ss -tuln || netstat -tuln || true
  echo

  echo "===== ESTRUTURA /opt ====="
  if [ -d /opt ]; then
    ls -la /opt | sed -n '1,200p' || true
  else
    echo "/opt não existe"
  fi
  echo

  echo "===== ESTRUTURA /home ====="
  if [ -d /home ]; then
    ls -la /home | sed -n '1,200p' || true
  else
    echo "/home não existe"
  fi

  echo
  echo "===== CONFIGS / VARIOS (resumo) ====="
  echo "Kernel:"; uname -a || true
  echo
  echo "Distribuição:"; lsb_release -a 2>/dev/null || cat /etc/os-release || true
  echo
  echo "FSTAB:"; cat /etc/fstab 2>/dev/null || echo "nofstab"
  echo
  echo "Crontabs (root + current user):"
  echo "--- root ---"; sudo crontab -l 2>/dev/null || echo "(nenhum)"
  echo "--- $(whoami) ---"; crontab -l 2>/dev/null || echo "(nenhum)"

} > "${outfile}" 2>&1

echo "Arquivo criado: ${outfile}"

exit 0
