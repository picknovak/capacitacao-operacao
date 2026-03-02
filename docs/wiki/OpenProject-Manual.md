# Manual do OpenProject

## O que este manual cobre

- arquitetura real
- verificacoes diarias
- backup
- restore
- atualizacao
- incidente
- seguranca basica

## Arquitetura resumida

- Aplicacao: `openproject-web`
- Banco: `openproject-db`
- Porta publicada: `8080`
- Assets: `/srv/data/openproject/assets`
- Backup: `/srv/data/openproject/backups`

## Rotina diaria

1. Rodar `scripts/openproject_daily_health.sh`.
2. Verificar status do backup.
3. Verificar logs recentes se houver anomalia.
4. Registrar qualquer incidente.

Documentos de apoio:
- `openproject/operacao/healthcheck.md`
- `checklists/daily-openproject.md`

## Antes de atualizar

1. Confirmar backup valido.
2. Ler `openproject/operacao/atualizacao.md`.
3. Registrar janela de mudanca.
4. Definir rollback.

## Se houver indisponibilidade

1. Ler `openproject/incidentes/indisponibilidade.md`.
2. Coletar evidencias.
3. Verificar containers, disco e logs.
4. Nao executar comandos destrutivos sem plano.

## Risco principal

Misturar operacao do banco do OpenProject com o PostgreSQL do host.

