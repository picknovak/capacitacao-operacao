# Quickstart

## Objetivo

Dar ao novo responsavel um caminho curto para operar o ambiente sem improviso.

## Em 15 minutos, entenda isto

1. O OpenProject roda em Docker.
2. O banco do OpenProject roda no container `openproject-db`.
3. O PostgreSQL 16 do host e separado e hoje atende `labgis`/PostGIS.
4. O OpenProject esta exposto em `:8080`.
5. O backup diario do OpenProject roda por `systemd` via `op-backup.timer`.

## Arquivos mais importantes

- `openproject/arquitetura.md`
- `openproject/operacao/healthcheck.md`
- `openproject/operacao/backup-restore.md`
- `openproject/seguranca/hardening.md`
- `openproject/incidentes/indisponibilidade.md`

## Comandos essenciais

```bash
docker ps --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}'
systemctl status op-backup.timer --no-pager
systemctl status op-backup.service --no-pager
journalctl -u op-backup.service -n 50 --no-pager
./scripts/openproject_daily_health.sh
```

## O que fazer antes de mudar qualquer coisa

1. Ler o runbook correspondente.
2. Confirmar backup recente.
3. Registrar plano e rollback.
4. Fazer commit da documentacao antes e depois da mudanca.

