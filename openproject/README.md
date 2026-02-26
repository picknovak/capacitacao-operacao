# OpenProject - Operacao

Foco deste modulo:

- estabilidade
- seguranca
- backup/restore
- atualizacao controlada
- resposta a incidentes

## Premissas atuais (inventario)

- OpenProject roda em Docker
- `openproject-web` exposto em `:8080`
- `openproject-db` usa `postgres:17`
- existe `op-backup.timer` e script `op_backup.sh`

## Ordem de leitura recomendada

1. `arquitetura.md`
2. `operacao/healthcheck.md`
3. `operacao/backup-restore.md`
4. `seguranca/hardening.md`
5. `operacao/atualizacao.md`
6. `incidentes/indisponibilidade.md`

