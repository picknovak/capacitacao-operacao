# Hardening e Seguranca - OpenProject

## Prioridades (ordem)

1. reduzir superficie de exposicao
2. proteger acesso administrativo
3. garantir backup/restore confiavel
4. manter atualizacoes controladas
5. monitorar sinais de falha/ataque

## Checklist de seguranca (host + OpenProject)

- [ ] acesso SSH somente por chave para administradores
- [ ] revisar `PermitRootLogin` e `PasswordAuthentication`
- [ ] UFW com regras explicitas e documentadas
- [ ] porta `5432` do PostgreSQL host mantida apenas local
- [ ] banco do OpenProject sem exposicao externa desnecessaria
- [ ] credenciais fora do Git (`.env`, cofre, secrets)
- [ ] backups com permissao restrita
- [ ] teste de restore periodico
- [ ] revisao de usuarios admin do OpenProject
- [ ] logs e eventos de erro revisados semanalmente

## Controles especificos para estabilidade

- fixar tags de imagem (evitar `latest`)
- limitar mudancas sem janela
- documentar dependencias (compose, volumes, env)
- monitorar uso de disco e memoria
- evitar manutencao manual dentro do container sem registrar procedimento

## Verificacoes uteis

```bash
sudo ufw status verbose
ss -tulpen | egrep '(:22|:8080|:5432)\\b'
docker ps --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}'
docker inspect openproject-db | grep -i '"PortBindings"' -n
```

## Itens observados no inventario

- `8080/tcp` exposto no host
- `5432` do PostgreSQL host em `127.0.0.1` (bom)
- logs mostram eventos `UFW BLOCK` (confirmar politica e regras)

