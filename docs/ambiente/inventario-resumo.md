# Resumo do Inventario (2026-03-04)

Fonte principal: `coleta_inventario/coleta_inventario_20260304_2101_pos_bancos.txt`

## Host

- `sv-labfsg`
- Ubuntu `22.04.5 LTS`
- Kernel `5.15.0-170-generic`
- Timezone `America/Sao_Paulo`

## Capacidade

- CPU: 8 vCPUs/threads (`Xeon E5-1620`)
- RAM: 15 GiB
- Swap: 15 GiB
- Memoria em uso elevada no momento da coleta (`~12 GiB` de `15 GiB`)
- Swap em uso (`~821 MiB`)

## Armazenamento

- SSD local com particoes separadas (`/`, `/var`, `/home`)
- RAID1 `md0` montado em `/srv/data`
- Data dir do PostgreSQL host em `/srv/data/postgres/16/main`
- Uso de `/srv/data` ainda baixo (~4%)

## Rede / Exposicao

- SSH publico (`22/tcp`)
- OpenProject exposto em `8080/tcp` (Docker/Puma)
- PostgreSQL host em `127.0.0.1:5432` (nao exposto externamente)
- UFW ativo com politica default `deny incoming`

## Aplicacoes relevantes

- OpenProject em Docker:
  - `openproject-web` (`openproject/openproject:17.1.0`)
  - `openproject-db` (`postgres:17`)
- PostgreSQL host:
  - cluster `16/main`
  - bases: `labgis`, `bronze`, `prata`, `ouro` (todas com PostGIS)

## Backups (indicios)

- `op-backup.timer` habilitado
- script `/usr/local/sbin/op_backup.sh`

## Riscos operacionais identificados

- coexistencia de dois bancos PostgreSQL (host e container do OpenProject)
- necessidade de validar backup/restore do OpenProject com teste real
- aumento de carga de memoria apos entrada de novos bancos (exige monitoramento)
- backlog de melhorias planejadas devido demandas emergenciais
