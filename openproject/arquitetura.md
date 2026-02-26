# Arquitetura Atual (OpenProject)

## Estado identificado
- Aplicacao: container `openproject-web` (`openproject/openproject:17.1.0`)
- Banco do OpenProject: container `openproject-db` (`postgres:17`)
- Porta publicada no host: `0.0.0.0:8080->80/tcp` e `[::]:8080->80/tcp`
- Processo da aplicacao observado no host: `puma` escutando em `0.0.0.0:8080`
- Banco do OpenProject roda em container e NAO e o PostgreSQL 16 do host
- Assets do OpenProject: `/srv/data/openproject/assets`
- Backups do OpenProject: `/srv/data/openproject/backups`

## Separacao de bancos (muito importante)

- OpenProject:
  - banco em container `openproject-db` (`postgres:17`)
  - base: `openproject`
  - usuario: `openproject`
- PostgreSQL do host (separado):
  - cluster `16/main` em `127.0.0.1:5432`
  - uso identificado para `labgis`/PostGIS

Esta separacao deve ser respeitada em qualquer backup, restore ou manutencao.

## Backup integrado ao ambiente

- Script: `/usr/local/sbin/op_backup.sh`
- Service: `op-backup.service`
- Timer: `op-backup.timer` (diario)

O backup atual cobre:
- dump logico do banco do OpenProject (container `openproject-db`)
- compactacao dos assets (`/srv/data/openproject/assets`)
- manifesto com checksums (`sha256`)

## Confirmacoes pendentes (preencher)

- [ ] onde esta o arquivo `docker-compose.yml` / stack
- [ ] volumes persistentes usados pelo OpenProject (`db`, `assets`, `uploads`, etc.)
- [ ] variaveis de ambiente em uso
- [ ] rede Docker da stack
- [ ] proxy reverso (se existir)
- [ ] certificado TLS (se existir)
- [ ] destino do backup (`local`, `Synology`, outro)

## Comandos de descoberta (executar e registrar)

```bash
docker ps --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}'
docker inspect openproject-web
docker inspect openproject-db
docker volume ls
docker network ls
```

## Risco principal

Confundir o `PostgreSQL 16` do host (LabGIS/PostGIS) com o banco do OpenProject (container). Os runbooks devem sempre indicar explicitamente qual alvo esta sendo operado.

