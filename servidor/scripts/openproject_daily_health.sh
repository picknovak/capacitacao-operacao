#!/usr/bin/env bash
set -euo pipefail

# Rotina diária para verificar saúde do OpenProject (Docker) e auditoria de acessos.
# Uso:
#   sudo ./scripts/openproject_daily_health.sh
# Variáveis opcionais:
#   REPORT_DIR=/caminho/relatorios
#   OPENPROJECT_WEB_CONTAINER=openproject-web
#   OPENPROJECT_HOST=example.com  (para checar validade TLS)

timestamp="$(date +%Y%m%d_%H%M%S)"
report_dir="${REPORT_DIR:-./relatorios/openproject_daily}"
mkdir -p "${report_dir}"
outfile="${report_dir}/openproject_daily_${timestamp}.txt"

warn_count=0
crit_count=0

warn() {
  warn_count=$((warn_count + 1))
  printf '[WARN] %s\n' "$*"
}

crit() {
  crit_count=$((crit_count + 1))
  printf '[CRIT] %s\n' "$*"
}

have_cmd() {
  command -v "$1" >/dev/null 2>&1
}

auth_source_summary() {
  if [ -f /var/log/auth.log ]; then
    echo "/var/log/auth.log"
  elif [ -f /var/log/secure ]; then
    echo "/var/log/secure"
  else
    echo "journalctl"
  fi
}

auth_log_last_24h() {
  if [ -f /var/log/auth.log ]; then
    awk -v d1="$(date --date='1 day ago' '+%b %e')" -v d0="$(date '+%b %e')" \
      '$0 ~ d1 || $0 ~ d0' /var/log/auth.log 2>/dev/null || true
  elif [ -f /var/log/secure ]; then
    awk -v d1="$(date --date='1 day ago' '+%b %e')" -v d0="$(date '+%b %e')" \
      '$0 ~ d1 || $0 ~ d0' /var/log/secure 2>/dev/null || true
  elif have_cmd journalctl; then
    journalctl --since "24 hours ago" -u ssh -u sshd --no-pager 2>/dev/null || true
  else
    true
  fi
}

detect_openproject_containers() {
  if ! have_cmd docker; then
    return 0
  fi

  docker ps -a --format '{{.Names}}|{{.Image}}|{{.Status}}' 2>/dev/null \
    | awk -F'|' 'BEGIN{IGNORECASE=1} $1 ~ /openproject/ || $2 ~ /openproject/ {print}'
}

find_web_container() {
  if [ -n "${OPENPROJECT_WEB_CONTAINER:-}" ]; then
    echo "${OPENPROJECT_WEB_CONTAINER}"
    return 0
  fi

  detect_openproject_containers | awk -F'|' 'BEGIN{IGNORECASE=1} $1 ~ /web/ {print $1; exit}'
}

docker_health_status() {
  local c="$1"
  docker inspect --format '{{if .State.Health}}{{.State.Health.Status}}{{else}}none{{end}}' "$c" 2>/dev/null || echo "unknown"
}

docker_restart_count() {
  local c="$1"
  docker inspect --format '{{.RestartCount}}' "$c" 2>/dev/null || echo "unknown"
}

check_tls_expiry() {
  local host="$1"
  if ! have_cmd openssl; then
    echo "openssl não disponível"
    return 0
  fi

  local enddate epoch_now epoch_end days_left
  enddate="$(echo | openssl s_client -servername "$host" -connect "${host}:443" 2>/dev/null \
    | openssl x509 -noout -enddate 2>/dev/null | cut -d= -f2- || true)"

  if [ -z "$enddate" ]; then
    echo "Não foi possível obter certificado de ${host}:443"
    warn "Falha ao consultar certificado TLS de ${host}"
    return 0
  fi

  epoch_now="$(date +%s)"
  epoch_end="$(date -d "$enddate" +%s 2>/dev/null || true)"
  if [ -z "$epoch_end" ]; then
    echo "Expiração TLS (raw): ${enddate}"
    return 0
  fi

  days_left="$(( (epoch_end - epoch_now) / 86400 ))"
  echo "Expiração TLS: ${enddate} (${days_left} dias restantes)"
  if [ "$days_left" -lt 7 ]; then
    crit "Certificado TLS expira em menos de 7 dias (${days_left})"
  elif [ "$days_left" -lt 21 ]; then
    warn "Certificado TLS expira em menos de 21 dias (${days_left})"
  fi
}

{
  echo "===== META ====="
  echo "Data: $(date -Is)"
  echo "Host: $(hostname -f 2>/dev/null || hostname)"
  echo "Usuário executor: $(whoami)"
  echo "Relatório: ${outfile}"
  echo

  echo "===== SAUDE DO SISTEMA ====="
  uptime || true
  echo
  free -h || true
  echo
  df -h / /var /tmp 2>/dev/null || df -h || true
  echo
  df -ih / /var /tmp 2>/dev/null || df -ih || true
  echo
  have_cmd docker && docker system df || echo "docker não disponível"
  echo

  if have_cmd systemctl; then
    echo "===== SERVIÇOS CHAVE ====="
    systemctl is-active docker 2>/dev/null || true
    systemctl is-active ssh 2>/dev/null || systemctl is-active sshd 2>/dev/null || true
    echo
  fi

  echo "===== OPENPROJECT (DOCKER) ====="
  if have_cmd docker; then
    op_lines="$(detect_openproject_containers || true)"
    if [ -z "${op_lines:-}" ]; then
      echo "Nenhum container OpenProject detectado por nome/imagem."
      warn "OpenProject não foi detectado em containers Docker"
    else
      printf '%s\n' "$op_lines"
      echo
      printf '%s\n' "$op_lines" | while IFS='|' read -r cname cimage cstatus; do
        [ -n "$cname" ] || continue
        echo "--- ${cname} ---"
        echo "Image: ${cimage}"
        echo "Status: ${cstatus}"
        hstatus="$(docker_health_status "$cname")"
        restarts="$(docker_restart_count "$cname")"
        echo "Health: ${hstatus}"
        echo "RestartCount: ${restarts}"
        docker inspect --format 'StartedAt: {{.State.StartedAt}}' "$cname" 2>/dev/null || true
        docker inspect --format 'Ports: {{json .NetworkSettings.Ports}}' "$cname" 2>/dev/null || true
        echo "Logs (tail 60):"
        docker logs --tail 60 "$cname" 2>&1 || true
        echo

        case "$cstatus" in
          Up*) ;;
          *) crit "Container ${cname} não está em execução (${cstatus})" ;;
        esac
        case "$hstatus" in
          healthy|none) ;;
          starting) warn "Container ${cname} ainda em startup (health=starting)" ;;
          unhealthy) crit "Container ${cname} unhealthy" ;;
          *) warn "Health status incomum em ${cname}: ${hstatus}" ;;
        esac
        if [ "$restarts" != "unknown" ] && [ "$restarts" -ge 3 ] 2>/dev/null; then
          warn "Container ${cname} com restartCount alto (${restarts})"
        fi
      done
    fi
  else
    crit "Docker não está instalado/disponível"
    echo "docker não disponível"
  fi
  echo

  echo "===== OPENPROJECT WEB (CHECK LOCAL) ====="
  if have_cmd docker; then
    web_container="$(find_web_container || true)"
    if [ -n "${web_container:-}" ]; then
      echo "Container web detectado: ${web_container}"
      docker exec "$web_container" sh -lc 'if command -v curl >/dev/null 2>&1; then curl -fsS -m 5 http://127.0.0.1:8080/ >/dev/null && echo "HTTP local OK (:8080)" || echo "HTTP local FAIL (:8080)"; else echo "curl não disponível no container"; fi' 2>/dev/null || true
      docker exec "$web_container" sh -lc 'if command -v curl >/dev/null 2>&1; then curl -fsS -m 5 http://127.0.0.1/ >/dev/null && echo "HTTP local OK (:80)" || echo "HTTP local FAIL (:80)"; fi' 2>/dev/null || true
    else
      echo "Container web OpenProject não identificado automaticamente."
      echo "Defina OPENPROJECT_WEB_CONTAINER para forçar a checagem."
    fi
  fi
  echo

  echo "===== REDE / EXPOSIÇÃO ====="
  ss -tulpen 2>/dev/null || ss -tuln 2>/dev/null || true
  echo
  if have_cmd ufw; then
    ufw status verbose || true
    echo
  fi
  if have_cmd nft; then
    nft list ruleset 2>/dev/null | sed -n '1,220p' || true
    echo
  fi

  echo "===== SSH / FRAGILIDADE ====="
  echo "Fonte auth: $(auth_source_summary)"
  if have_cmd sshd; then
    sshd -T 2>/dev/null | grep -E '^(permitrootlogin|passwordauthentication|pubkeyauthentication|maxauthtries|loglevel|allowusers|allowgroups)' || true
  elif have_cmd ssh; then
    echo "sshd -T não disponível"
  fi
  echo
  echo "Tentativas falhas (24h):"
  auth_log_last_24h | grep -Ei 'Failed password|Invalid user|authentication failure|error: PAM|Disconnected from invalid user' || echo "(nenhuma encontrada)"
  echo
  echo "Sucessos SSH (24h):"
  auth_log_last_24h | grep -Ei 'Accepted (publickey|password)|session opened for user' || echo "(nenhum encontrado)"
  echo
  echo "Resumo de IPs com falha (24h):"
  auth_log_last_24h \
    | grep -Eio '([0-9]{1,3}\.){3}[0-9]{1,3}' \
    | sort | uniq -c | sort -nr | sed -n '1,20p' || true
  echo
  echo "Últimos logins:"
  last -ai 2>/dev/null | sed -n '1,25p' || true
  echo

  echo "===== DOCKER / OPENPROJECT EVENTOS (24h) ====="
  if have_cmd journalctl; then
    journalctl --since "24 hours ago" -u docker --no-pager 2>/dev/null | tail -n 200 || true
  else
    echo "journalctl não disponível"
  fi
  echo

  if [ -n "${OPENPROJECT_HOST:-}" ]; then
    echo "===== TLS (${OPENPROJECT_HOST}) ====="
    check_tls_expiry "${OPENPROJECT_HOST}"
    echo
  fi

  echo "===== REGRAS DE ALERTA (RESUMO) ====="
  root_use="$(auth_log_last_24h | grep -Ec 'Accepted .* for root|session opened for user root' || true)"
  if [ "${root_use:-0}" -gt 0 ]; then
    warn "Login/sessão SSH do root detectado nas últimas 24h (${root_use})"
  fi

  failed_count="$(auth_log_last_24h | grep -Eci 'Failed password|Invalid user|authentication failure' || true)"
  echo "Falhas de autenticação (24h): ${failed_count}"
  if [ "${failed_count:-0}" -gt 50 ]; then
    warn "Volume alto de falhas de autenticação SSH (${failed_count}/24h)"
  fi

  disk_use_root="$(df -P / 2>/dev/null | awk 'NR==2{gsub("%","",$5); print $5}')"
  if [ -n "${disk_use_root:-}" ]; then
    echo "Uso de disco /: ${disk_use_root}%"
    if [ "$disk_use_root" -ge 95 ] 2>/dev/null; then
      crit "Disco / acima de 95% (${disk_use_root}%)"
    elif [ "$disk_use_root" -ge 85 ] 2>/dev/null; then
      warn "Disco / acima de 85% (${disk_use_root}%)"
    fi
  fi

  mem_avail_mb="$(free -m 2>/dev/null | awk '/Mem:/ {print $7}')"
  if [ -n "${mem_avail_mb:-}" ]; then
    echo "Memória disponível: ${mem_avail_mb} MB"
    if [ "$mem_avail_mb" -lt 512 ] 2>/dev/null; then
      warn "Memória disponível baixa (${mem_avail_mb} MB)"
    fi
  fi

  echo
  echo "===== SCORE FINAL ====="
  echo "WARN=${warn_count}"
  echo "CRIT=${crit_count}"
  if [ "$crit_count" -gt 0 ]; then
    echo "STATUS=CRITICO"
  elif [ "$warn_count" -gt 0 ]; then
    echo "STATUS=ATENCAO"
  else
    echo "STATUS=OK"
  fi

} > "${outfile}" 2>&1

echo "Relatório salvo em: ${outfile}"
echo "Resumo: WARN=${warn_count} CRIT=${crit_count}"

if [ "$crit_count" -gt 0 ]; then
  exit 2
fi
if [ "$warn_count" -gt 0 ]; then
  exit 1
fi
exit 0
