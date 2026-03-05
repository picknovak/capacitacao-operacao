# Servidor - Manual Operacional

Manual de operacao geral do servidor (alem do OpenProject).

## Objetivo

Centralizar rotinas de auditoria, coleta, backup e envio externo em um unico repositorio Git.

## Onde esta o material

- Scripts: `servidor/scripts/`
- Playbooks/manuais: `servidor/docs/`
- Checklists gerais: `checklists/`
- Modulo OpenProject: `openproject/`

## Rotinas principais

### Auditoria e coleta

- `servidor/scripts/auditoria_sistema.sh`
- `servidor/scripts/collect_extra.sh`
- `servidor/scripts/inspect_system.sh`

### Backup e empacotamento

- `servidor/scripts/backup_postgres.sh`
- `servidor/scripts/backup_vm.sh`
- `servidor/scripts/assemble_package.sh`
- `servidor/scripts/verify_backup.sh`

### Envio externo

- `servidor/scripts/upload_to_synology.sh`

## Cuidados importantes

- revisar parametros de host/usuario/path antes de executar scripts de upload
- nao versionar artefatos de backup, relatorios e tarballs
- tratar PostgreSQL do host e banco do OpenProject como alvos diferentes

## Documentacao de apoio

- `servidor/docs/BACKUP_PLAYBOOK.md`
- `servidor/docs/MANUAL_ACESSO_POSTGRES_POSTGIS.txt`
- `servidor/docs/OPENPROJECT_ROTINA_DIARIA.md`

