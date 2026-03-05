#!/usr/bin/env bash
set -euo pipefail

timestamp=$(date +%Y%m%d_%H%M)
outdir="coleta_${timestamp}"
tarfile="coleta_${timestamp}.tar.gz"

mkdir -p "${outdir}"

echo "Coletando relatório existente..."
cp relatorio_*"$(date +%Y%m%d)"* "${outdir}/" 2>/dev/null || true

echo "Coletando informações PostgreSQL (resumo)..."
if command -v psql >/dev/null 2>&1; then
  sudo -u postgres bash -c "psql -c \"\dt\" 2>/dev/null" > "${outdir}/postgres_tables.txt" 2>&1 || true
  sudo -u postgres psql -c "SELECT version();" > "${outdir}/postgres_version.txt" 2>&1 || true
  sudo -u postgres psql -c "SHOW data_directory;" > "${outdir}/postgres_data_directory.txt" 2>&1 || true
else
  echo "psql não disponível" > "${outdir}/postgres_missing.txt"
fi

echo "Coletando Docker / OpenProject..."
if command -v docker >/dev/null 2>&1; then
  docker ps --no-trunc > "${outdir}/docker_ps.txt" 2>&1 || true
  docker images > "${outdir}/docker_images.txt" 2>&1 || true
  # Inspect OpenProject containers if present
  docker ps --format '{{.ID}} {{.Image}}' | grep -i openproject || true > /dev/null 2>&1
  docker inspect $(docker ps -q) > "${outdir}/docker_inspect_all.json" 2>/dev/null || true
else
  echo "docker não disponível" > "${outdir}/docker_missing.txt"
fi

echo "Coletando informações de VMs (libvirt/qemu)..."
if command -v virsh >/dev/null 2>&1; then
  virsh list --all > "${outdir}/virsh_list.txt" 2>&1 || true
  virsh dominfo --all > "${outdir}/virsh_dominfo_all.txt" 2>&1 || true
else
  echo "virsh não disponível" > "${outdir}/virsh_missing.txt"
fi

echo "Coletando principais arquivos de configuração..."
for f in /etc/postgresql /etc/postgresql/*/main/postgresql.conf /etc/postgresql/*/main/pg_hba.conf /etc/docker/daemon.json /etc/fstab /etc/hosts /etc/ssh/sshd_config; do
  if [ -e "$f" ]; then
    cp -r "$f" "${outdir}/" || true
  fi
done

echo "Inspecionando /srv/data e /opt (listagem)..."
ls -la /srv/data 2>/dev/null | sed -n '1,200p' > "${outdir}/srv_data_listing.txt" || true
ls -la /opt 2>/dev/null | sed -n '1,200p' > "${outdir}/opt_listing.txt" || true

echo "Criando tar.gz..."
tar -czf "${tarfile}" "${outdir}"

echo "Arquivo criado: ${tarfile}"

echo "Removendo diretório temporário ${outdir}"
rm -rf "${outdir}"

exit 0
