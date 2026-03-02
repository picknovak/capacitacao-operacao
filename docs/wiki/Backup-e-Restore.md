# Backup e Restore

## Estado atual

O OpenProject possui backup diario via:

- `op-backup.timer`
- `op-backup.service`
- script `/usr/local/sbin/op_backup.sh`

## O que o backup atual salva

- dump logico do banco `openproject`
- assets em `/srv/data/openproject/assets`
- manifesto `sha256`

Arquivos gerados:
- `openproject_db_<timestamp>.sql`
- `openproject_assets_<timestamp>.tar.gz`
- `manifest_<timestamp>.txt`

## Evidencias ja confirmadas

- backups com sucesso observados em varios dias consecutivos
- falha registrada em `2026-02-24 02:35:00 -03` porque o banco ainda estava inicializando apos reboot

## Uso operacional

Verificacao:

```bash
systemctl status op-backup.timer --no-pager
systemctl status op-backup.service --no-pager
journalctl -u op-backup.service -n 100 --no-pager
sudo ls -lh /srv/data/openproject/backups | tail -n 20
```

## O que ainda falta fechar

- politica de retencao
- teste de restore em ambiente isolado
- local do compose e `.env`
- copia externa para Synology/NAS

## Documento detalhado

Ver `openproject/operacao/backup-restore.md`.

