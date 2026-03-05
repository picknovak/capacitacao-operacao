# Operacao do Servidor (Centralizado)

Este diretorio centraliza scripts e manuais operacionais gerais do servidor, alem do modulo especifico de OpenProject.

## Estrutura

- `servidor/scripts/`: scripts de auditoria, coleta e backup
- `servidor/docs/`: manuais e playbooks de operacao
- `servidor/artefatos/`: saida local de execucoes (nao versionar)

## Scripts migrados de `Projeto`

- `servidor/scripts/auditoria_sistema.sh`
- `servidor/scripts/collect_extra.sh`
- `servidor/scripts/assemble_package.sh`
- `servidor/scripts/backup_postgres.sh`
- `servidor/scripts/backup_vm.sh`
- `servidor/scripts/upload_to_synology.sh`
- `servidor/scripts/verify_backup.sh`
- `servidor/scripts/inspect_system.sh`
- `servidor/scripts/openproject_daily_health.sh`

## Playbooks e manuais migrados

- `servidor/docs/BACKUP_PLAYBOOK.md`
- `servidor/docs/OPENPROJECT_ROTINA_DIARIA.md`
- `servidor/docs/MANUAL_ACESSO_POSTGRES_POSTGIS.txt`
- `servidor/docs/INSTALL_MAC.md`

## Uso recomendado

1. Ajustar variaveis de destino (Synology, paths, usuarios) antes de executar scripts.
2. Executar scripts inicialmente em modo manual e registrar resultado.
3. So depois criar automacao em `cron` ou `systemd`.
4. Registrar toda alteracao no Git.

## Observacao

Este repositorio substitui a necessidade de manter operacao separada na pasta `Projeto`.

