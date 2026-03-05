# Repositorio de Operacao - Ubuntu/OpenProject

Repositorio para capacitar e padronizar a operacao do ambiente, com foco em estabilidade e seguranca do OpenProject.

## Objetivo

- reduzir risco operacional
- padronizar rotinas e incidentes
- manter historico em Git de procedimentos e mudancas
- facilitar troca de responsavel sem perda de contexto

## Escopo atual (inventario base)

- Host: Ubuntu 22.04.5 LTS
- Virtualizacao: libvirt/KVM (`rstudio-vm`)
- Containers: Docker ativo
- OpenProject: `openproject/openproject:17.1.0` + container `postgres:17`
- PostgreSQL host: cluster `16/main` (base `labgis`, PostGIS)
- Armazenamento: RAID1 `md0` em `/srv/data`

## Estrutura

- `docs/`: padroes e contexto do ambiente
- `docs/wiki/`: wiki/manual navegavel para onboarding e operacao
- `servidor/`: operacao geral do servidor (auditoria, backup, synology, etc.)
- `openproject/`: runbooks, seguranca e incidentes do OpenProject
- `postgresql/`: operacao do PostgreSQL do host (separado do OpenProject)
- `checklists/`: rotinas recorrentes
- `templates/`: modelos para novos documentos
- `scripts/`: scripts de apoio (preferencialmente read-only)
- `inventarios/`: inventarios e snapshots de ambiente

## Regras de operacao (essenciais)

- Toda mudanca operacional relevante deve virar commit.
- Antes de executar mudanca em producao, registrar plano e rollback.
- OpenProject e PostgreSQL do host devem ser tratados como componentes separados.
- Priorizar procedimentos reproduziveis (`bash`, `systemd`, `docker`) com comandos documentados.
- Evitar manter repositorio paralelo para as mesmas rotinas de servidor.

## Proximo uso recomendado

1. Comecar por `docs/wiki/Home.md`.
2. Revisar `servidor/README.md` e `docs/wiki/Servidor-Manual.md`.
3. Preencher `openproject/arquitetura.md` com volumes e compose real.
4. Testar restore em ambiente isolado e registrar evidencias.
5. Iniciar rotina usando `checklists/daily-openproject.md`.

## Coleta de chave SSH (tunnel_externo)

Para receber chaves publicas de usuarios de forma padronizada, use os scripts em:

- `scripts/coleta_chave_ssh/coleta_chave_ssh_windows.bat`
- `scripts/coleta_chave_ssh/coleta_chave_ssh_macos.sh`
- `scripts/coleta_chave_ssh/coleta_chave_ssh_linux.sh`
- `scripts/coleta_chave_ssh/README_coleta_chave_ssh.md`

Comportamento padrao:

- gera chave `ed25519` no `~/.ssh` do usuario;
- cria `chave_publica_ssh.txt` na mesma pasta onde o script foi executado;
- o usuario deve enviar somente esse `.txt`.
