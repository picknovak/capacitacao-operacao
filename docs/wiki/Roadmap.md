# Roadmap

## Concluido

- [x] Repositorio Git operacional criado
- [x] GitHub configurado e fluxo `clone -> edit -> commit -> push` validado
- [x] OpenProject identificado em Docker
- [x] Containers e versoes documentados
- [x] Porta `8080` documentada
- [x] Backup real identificado (`op-backup.timer`, `op-backup.service`, `op_backup.sh`)
- [x] Evidencias de execucao com sucesso documentadas
- [x] Falha de backup apos reboot documentada
- [x] Scripts e playbooks da pasta `Projeto` migrados para `servidor/`
- [x] Material de `BD_labserver` migrado para `postgresql/labgis/`
- [x] Coleta pos-expansao de bancos registrada (`2026-03-04`)

## Em andamento

- [ ] localizar `docker-compose.yml` / stack real
- [ ] mapear volumes Docker persistentes
- [ ] documentar localizacao do `.env` sem versionar segredos
- [ ] definir politica de retencao dos backups

## Faixa emergencial (infraestrutura de dados)

- [x] provisionamento de `bronze`, `prata`, `ouro` no PostgreSQL host
- [x] validacao de PostGIS nas novas bases
- [ ] baseline de performance/memoria apos entrada dos novos bancos
- [ ] runbook operacional das novas bases (backup, grants, manutencao)

## Observacao de priorizacao

Parte do TODO original ficou estagnada por demandas emergenciais de infra.
A prioridade atual e estabilizar operacao com os novos bancos sem perder o plano de capacitacao.

## Proximos passos

- [ ] adicionar retry/espera do banco ao backup
- [ ] testar restore em ambiente isolado
- [ ] medir RTO/RPO
- [ ] revisar UFW e exposicao de `8080`
- [ ] definir copia externa para Synology/NAS
- [ ] criar runbook de storage/RAID
- [ ] publicar wiki resumida no OpenProject com estado atual e runbooks-chave

## Janela da fase atual

- Inicio: `2026-02-28`
- Fim alvo: `2026-03-12`
