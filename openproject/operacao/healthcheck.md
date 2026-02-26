# Runbook - Health Check Diario (OpenProject)

## Objetivo

Detectar rapidamente degradacao antes de indisponibilidade.

## Janela

- diariamente (inicio do expediente)
- apos mudancas
- apos reboot do host

## Checklist rapido

- [ ] containers `openproject-web` e `openproject-db` em `Up`
- [ ] porta `8080` respondendo
- [ ] login web funcional
- [ ] criacao/edicao simples de tarefa funcional (teste manual rapido)
- [ ] logs sem erros repetitivos
- [ ] espaco em disco suficiente em `/`, `/var`, `/srv/data`
- [ ] backup do dia anterior concluido

## Comandos

```bash
docker ps --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}'
curl -I http://127.0.0.1:8080
docker logs --tail 100 openproject-web
docker logs --tail 100 openproject-db
df -hT / /var /srv/data
systemctl status op-backup.timer --no-pager
systemctl status op-backup.service --no-pager
```

## Criticidade (agir imediatamente)

- container reiniciando em loop
- erro de conexao com banco no `openproject-web`
- disco > 85% em particoes criticas
- backup falhando por 2 execucoes consecutivas

## Registro no Git

Quando houver anomalia, abrir registro em `openproject/incidentes/` antes da correcao.

