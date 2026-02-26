# Repositorio de Operacao - Ubuntu/OpenProject

Repositorio para capacitar e padronizar a operacao do ambiente, com foco em estabilidade e seguranca do OpenProject.

## Objetivo

- reduzir risco operacional
- padronizar rotinas e incidentes
- manter historico em Git de procedimentos e mudancas
- facilitar troca de responsavel sem perda de contexto

## Escopo atual (inventario base)

- Host: Ubuntu 22.04.5 LTS
- Virtualizacao: libvirt/KVM (`rstudio-vm`)
- Containers: Docker ativo
- OpenProject: `openproject/openproject:17.1.0` + container `postgres:17`
- PostgreSQL host: cluster `16/main` (base `labgis`, PostGIS)
- Armazenamento: RAID1 `md0` em `/srv/data`

## Estrutura

- `docs/`: padroes e contexto do ambiente
- `openproject/`: runbooks, seguranca e incidentes do OpenProject
- `postgresql/`: operacao do PostgreSQL do host (separado do OpenProject)
- `checklists/`: rotinas recorrentes
- `templates/`: modelos para novos documentos
- `scripts/`: scripts de apoio (preferencialmente read-only)
- `inventarios/`: inventarios e snapshots de ambiente

## Regras de operacao (essenciais)

- Toda mudanca operacional relevante deve virar commit.
- Antes de executar mudanca em producao, registrar plano e rollback.
- OpenProject e PostgreSQL do host devem ser tratados como componentes separados.
- Priorizar procedimentos reproduziveis (`bash`, `systemd`, `docker`) com comandos documentados.

## Proximo uso recomendado

1. Preencher `openproject/arquitetura.md` com volumes e compose real.
2. Validar e documentar `op_backup.sh` em `openproject/operacao/backup-restore.md`.
3. Testar restore em ambiente isolado e registrar evidencias.
4. Iniciar rotina usando `checklists/daily-openproject.md`.

