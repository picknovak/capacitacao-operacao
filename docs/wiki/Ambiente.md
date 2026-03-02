# Ambiente

## Visao geral

- Host: Ubuntu `22.04.5 LTS`
- Virtualizacao: `libvirt/KVM`
- Containers: `Docker`
- OpenProject: `openproject/openproject:17.1.0`
- Banco do OpenProject: `postgres:17`
- PostgreSQL do host: cluster `16/main`
- Storage principal: RAID1 `md0` em `/srv/data`

## Componentes principais

### OpenProject
- container `openproject-web`
- publicado em `0.0.0.0:8080->80/tcp`
- assets em `/srv/data/openproject/assets`

### Banco do OpenProject
- container `openproject-db`
- base `openproject`
- usuario `openproject`

### PostgreSQL do host
- cluster `16/main`
- escuta em `127.0.0.1:5432`
- separado do OpenProject

## Fonte de verdade

- `docs/ambiente/inventario-resumo.md`
- `openproject/arquitetura.md`
- `openproject/operacao/backup-restore.md`

## Confirmacoes pendentes

- local do `docker-compose.yml` real
- volumes Docker persistentes exatos
- localizacao do `.env` da stack
- uso de Synology/NAS para copia externa

