# Padrao Git para Operacao

## Principios

- `1 commit = 1 intencao operacional`
- Mensagens objetivas, com impacto e rollback
- Nao versionar segredos (senhas, tokens, chaves privadas)

## Fluxo minimo

1. Criar branch para mudanca: `git checkout -b operacao/<tema>`
2. Atualizar runbook/checklist/script
3. Commitar com contexto
4. Aplicar em janela de mudanca
5. Registrar resultado em novo commit (se necessario)

## Convencao de commit (sugestao)

- `docs(openproject): atualiza runbook de backup`
- `runbook(openproject): adiciona checklist pre-upgrade`
- `incident(openproject): registra falha de start e correcao`
- `security(openproject): endurece exposicao de porta 8080`

## O que sempre registrar

- objetivo
- comandos executados
- evidencia de validacao
- risco
- rollback

