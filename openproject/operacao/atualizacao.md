# Runbook - Atualizacao do OpenProject (Estabilidade Primeiro)

## Objetivo

Atualizar o OpenProject com risco controlado e rollback definido.

## Regras

- sem atualizacao direta em horario de pico
- sempre com backup confirmado antes
- registrar versao atual e versao alvo
- validar compatibilidade do banco/compose

## Pre-check

- [ ] backup concluido e verificado
- [ ] espaco em disco suficiente
- [ ] janela aprovada
- [ ] rollback planejado
- [ ] release notes lidas (mudancas breaking)
- [ ] imagens atuais identificadas (`docker images`)

## Fluxo sugerido

1. Exportar estado atual (containers, imagens, compose, env).
2. Fazer backup on-demand.
3. Pull da nova imagem.
4. Subir stack controladamente.
5. Acompanhar migracoes.
6. Validar health check funcional.
7. Registrar resultado e versoes no Git.

## Rollback (modelo)

1. Parar stack atualizada.
2. Voltar para imagem/tag anterior.
3. Restaurar banco/anexos se houve migracao irreversivel.
4. Subir stack anterior.
5. Validar acesso e integridade.

## Comandos base (ajustar para compose real)

```bash
docker ps
docker images | grep openproject
docker compose pull
docker compose up -d
docker compose logs -f --tail 200
```

