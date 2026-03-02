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

## Em andamento

- [ ] localizar `docker-compose.yml` / stack real
- [ ] mapear volumes Docker persistentes
- [ ] documentar localizacao do `.env` sem versionar segredos
- [ ] definir politica de retencao dos backups

## Proximos passos

- [ ] adicionar retry/espera do banco ao backup
- [ ] testar restore em ambiente isolado
- [ ] medir RTO/RPO
- [ ] revisar UFW e exposicao de `8080`
- [ ] definir copia externa para Synology/NAS
- [ ] criar runbook de storage/RAID

## Janela da fase atual

- Inicio: `2026-02-28`
- Fim alvo: `2026-03-12`

