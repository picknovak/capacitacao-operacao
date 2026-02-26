# Arquitetura Atual (OpenProject)

## Estado identificado

- Aplicacao: container `openproject-web`
- Banco do OpenProject: container `openproject-db` (`postgres:17`)
- Porta observada: `8080/tcp` no host
- Processo `puma` escutando em `0.0.0.0:8080`

## Confirmacoes pendentes (preencher)

- [ ] onde esta o arquivo `docker-compose.yml` / stack
- [ ] volumes persistentes usados pelo OpenProject (`db`, `assets`, `uploads`, etc.)
- [ ] variaveis de ambiente em uso
- [ ] rede Docker da stack
- [ ] proxy reverso (se existir)
- [ ] certificado TLS (se existir)
- [ ] destino do backup (`local`, `Synology`, outro)

## Comandos de descoberta (executar e registrar)

```bash
docker ps --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}'
docker inspect openproject-web
docker inspect openproject-db
docker volume ls
docker network ls
```

## Risco principal

Confundir o `PostgreSQL 16` do host (LabGIS/PostGIS) com o banco do OpenProject (container). Os runbooks devem sempre indicar explicitamente qual alvo esta sendo operado.

