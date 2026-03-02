# Seguranca e Hardening

## Prioridades

1. proteger acesso administrativo
2. reduzir superficie exposta
3. manter backup/restaure confiavel
4. padronizar mudancas

## Estado atual observado

- OpenProject exposto em `:8080`
- PostgreSQL do host restrito a `127.0.0.1:5432`
- `op-backup.service` com hardening basico (`NoNewPrivileges`, `PrivateTmp`, `ProtectSystem=strict`)
- eventos `UFW BLOCK` observados em log

## Itens de revisao

- `ufw status verbose`
- estrategia de publicacao de `8080`
- `PasswordAuthentication` e `PermitRootLogin`
- contas administrativas e chaves SSH
- revisao semanal de logs

## Documento detalhado

Ver `openproject/seguranca/hardening.md`.

