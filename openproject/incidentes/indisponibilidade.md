# Incidente - OpenProject indisponivel (runbook)

## Objetivo

Restabelecer servico com menor risco e preservar evidencias.

## Sinais comuns

- `curl http://127.0.0.1:8080` falha
- erro HTTP 5xx
- `openproject-web` em restart loop
- erro de conexao com banco
- timeout no frontend

## Passos imediatos (sem destrutivo)

1. Confirmar impacto (usuarios/servico/porta).
2. Verificar status dos containers.
3. Coletar logs recentes.
4. Verificar disco/memoria.
5. Verificar conectividade entre `openproject-web` e `openproject-db`.

## Comandos

```bash
date
docker ps -a
docker logs --tail 200 openproject-web
docker logs --tail 200 openproject-db
df -hT / /var /srv/data
free -h
ss -tulpen | egrep '(:8080|:5432)\\b'
```

## Decisao rapida

- Se for falha de processo/container: reinicio controlado da stack (registrar horario)
- Se for falha de disco/espaco: liberar espaco com criterio, sem apagar backup sem copia
- Se for falha de banco: avaliar restore somente apos coleta de evidencias e validacao de backup

## Nao fazer no calor do incidente

- `docker system prune -a` sem analise
- atualizar imagem "para testar"
- apagar volumes
- editar container manualmente sem registro

## Pos-incidente (obrigatorio)

- causa provavel
- acao aplicada
- validacao
- prevenções
- commit com runbook/checklist ajustado

