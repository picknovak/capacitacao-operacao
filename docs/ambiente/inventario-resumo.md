# Resumo do Inventario (2026-02-25)

Fonte: `coleta_inventario20260225_2147.txt`

## Host

- `sv-labfsg`
- Ubuntu `22.04.5 LTS`
- Kernel `5.15.0-170-generic`
- Timezone `America/Sao_Paulo`

## Capacidade

- CPU: 8 vCPUs/threads (`Xeon E5-1620`)
- RAM: 15 GiB
- Swap: 15 GiB
- Uso de disco baixo no momento da coleta

## Armazenamento

- SSD local com particoes separadas (`/`, `/var`, `/home`)
- RAID1 `md0` montado em `/srv/data`
- Data dir do PostgreSQL host em `/srv/data/postgres/16/main`

## Rede / Exposicao

- SSH publico (`22/tcp`)
- OpenProject exposto em `8080/tcp` (Docker/Puma)
- PostgreSQL host em `127.0.0.1:5432` (nao exposto externamente)

## Aplicacoes relevantes

- OpenProject em Docker:
  - `openproject-web` (`openproject/openproject:17.1.0`)
  - `openproject-db` (`postgres:17`)
- PostgreSQL host:
  - cluster `16/main`
  - base `labgis` (com PostGIS)

## Backups (indicios)

- `op-backup.timer` habilitado
- script `/usr/local/sbin/op_backup.sh`

## Riscos operacionais identificados

- coexistencia de dois bancos PostgreSQL (host e container do OpenProject)
- necessidade de validar backup/restore do OpenProject com teste real
- ausencia de repositorio Git operacional local detectado na coleta

