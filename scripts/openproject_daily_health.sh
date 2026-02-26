#!/usr/bin/env bash
set -euo pipefail

# Health check read-only para OpenProject em Docker.
# Ajuste nomes dos containers se necessario.

WEB_CONTAINER="${WEB_CONTAINER:-openproject-web}"
DB_CONTAINER="${DB_CONTAINER:-openproject-db}"
URL="${URL:-http://127.0.0.1:8080}"

echo "== OpenProject Daily Health =="
date

echo
echo "-- Containers --"
docker ps --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}'

echo
echo "-- HTTP --"
curl -fsS -I "$URL" | head -n 5

echo
echo "-- Disk --"
df -hT / /var /srv/data

echo
echo "-- Backup service/timer --"
systemctl status op-backup.timer --no-pager --lines=3 || true
systemctl status op-backup.service --no-pager --lines=5 || true

echo
echo "-- App logs (tail) --"
docker logs --tail 30 "$WEB_CONTAINER" || true

echo
echo "-- DB logs (tail) --"
docker logs --tail 30 "$DB_CONTAINER" || true

