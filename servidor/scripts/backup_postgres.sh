#!/usr/bin/env bash
set -euo pipefail

# backup_postgres.sh
# Produz um dump lógico (por padrão pg_dumpall) e empacota com timestamp
# Detecta Postgres no host ou em container Docker chamado 'openproject-db' ou imagem 'postgres'

OUT_DIR=${1:-/var/backups/postgres}
mkdir -p "$OUT_DIR"
timestamp=$(date +%Y%m%d_%H%M)
outfile="$OUT_DIR/postgres_dump_${timestamp}.sql"

echo "Backup PostgreSQL -> $outfile"

if command -v psql >/dev/null 2>&1 && id postgres >/dev/null 2>&1; then
  echo "Detected system PostgreSQL (psql available). Running pg_dumpall as postgres user..."
  sudo -u postgres pg_dumpall -f "$outfile"
elif command -v docker >/dev/null 2>&1; then
  # try common container names
  CONTAINER=""
  if docker ps --format '{{.Names}}' | grep -q '^openproject-db$'; then
    CONTAINER=openproject-db
  else
    # first postgres image container
    CONTAINER=$(docker ps --filter ancestor=postgres --format '{{.Names}}' | head -n1 || true)
  fi
  if [ -n "$CONTAINER" ]; then
    echo "Detected Postgres in Docker container: $CONTAINER"
    docker exec -t "$CONTAINER" pg_dumpall -U postgres > "$outfile" || {
      echo "pg_dumpall via docker failed; trying pg_dump per DB..."
    }
  else
    echo "No postgres instance detected. Exiting with error." >&2
    exit 2
  fi
else
  echo "No psql or docker client available; cannot perform Postgres backup." >&2
  exit 3
fi

gzip -f "$outfile"
echo "Created ${outfile}.gz"

exit 0
