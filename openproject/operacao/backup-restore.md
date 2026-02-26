# Runbook - Backup e Restore (OpenProject)

## Objetivo

Garantir backup confiavel e restore testado do OpenProject.

## Estado atual identificado

- `op-backup.timer` habilitado
- script `/usr/local/sbin/op_backup.sh` existente

## Prioridade imediata

- [ ] revisar conteudo de `op_backup.sh`
- [ ] confirmar destino dos backups
- [ ] confirmar retencao
- [ ] validar restore em ambiente isolado

## Itens que DEVEM estar no backup

- banco do OpenProject (`openproject-db`)
- anexos/uploads
- configuracoes da stack (`compose`, env files sem segredos em Git)
- evidencias de versao da imagem usada

## Verificacao operacional diaria

```bash
systemctl status op-backup.timer --no-pager
systemctl status op-backup.service --no-pager
journalctl -u op-backup.service -n 100 --no-pager
```

## Restore (roteiro base - ajustar apos mapear stack real)

1. Isolar ambiente de teste (host/VM/lab).
2. Restaurar mesmos containers/versoes.
3. Restaurar dump do banco.
4. Restaurar anexos/volumes.
5. Subir aplicacao.
6. Validar login, projetos, anexos e jobs.
7. Registrar tempo de restore (RTO) e ponto recuperado (RPO).

## Evidencia minima (obrigatoria)

- data do teste
- versao da imagem
- backup utilizado
- sucesso/falha
- tempo total
- ajustes necessarios no procedimento

## Riscos comuns

- backup apenas do banco (sem anexos)
- backup de volume errado
- restore em versao diferente sem procedimento de migracao
- nao testar restore periodicamente

## Implementacao real (confirmada em 2026-02-25)

### Agendamento
- `op-backup.timer` habilitado e ativo
- Execucao diaria observada por volta de `02:30` (America/Sao_Paulo)

### Service
- Unit file: `/etc/systemd/system/op-backup.service`
- `ExecStart=/usr/local/sbin/op_backup.sh`

Hardening observado no service:
- `NoNewPrivileges=true`
- `PrivateTmp=true`
- `ProtectSystem=strict`
- `ReadWritePaths=/srv/data/openproject/backups /srv/data/openproject/assets`

### Script de backup (`/usr/local/sbin/op_backup.sh`)
O script executa:
1. Validacao do container `openproject-db`
2. Validacao do diretorio de assets `/srv/data/openproject/assets`
3. Dump do banco (`pg_dump`) para arquivo `.sql`
4. Compactacao dos assets para `.tar.gz`
5. Geracao de manifesto `manifest_<timestamp>.txt` com `sha256`

Parametros observados no script:
- `DB_CONTAINER="openproject-db"`
- `DB_NAME="openproject"`
- `DB_USER="openproject"`
- `BKDIR="/srv/data/openproject/backups"`
- `ASSETSDIR="/srv/data/openproject/assets"`

Arquivos gerados por execucao:
- `openproject_db_<timestamp>.sql`
- `openproject_assets_<timestamp>.tar.gz`
- `manifest_<timestamp>.txt`

## Evidencias operacionais observadas

### Sucesso recorrente
Foram observadas multiplas execucoes com sucesso no `journalctl`, incluindo:
- `2026-02-25 02:30:42 -03`
- `2026-02-23 02:31:30 -03`
- `2026-02-22 02:30:15 -03`
- `2026-02-21 02:34:43 -03`

Saidas registradas (padrao):
- `OK: /srv/data/openproject/backups/openproject_db_<timestamp>.sql`
- `OK: /srv/data/openproject/backups/openproject_assets_<timestamp>.tar.gz`
- `OK: /srv/data/openproject/backups/manifest_<timestamp>.txt`

### Falha observada apos reboot (importante)
Em `2026-02-24 02:35:00 -03`, houve falha:
- `pg_dump: ... FATAL: the database system is starting up`

Interpretacao:
- o timer disparou enquanto o `openproject-db` ainda estava inicializando apos reboot do host.

Acao recomendada (melhoria futura):
- adicionar espera/retry para disponibilidade do banco antes do `pg_dump`
- ou revisar dependencias/ordem de inicializacao e janela do timer

## Verificacao operacional (comandos reais)

```bash
systemctl status op-backup.timer --no-pager
systemctl status op-backup.service --no-pager
journalctl -u op-backup.service -n 100 --no-pager
sudo ls -lh /srv/data/openproject/backups | tail -n 20
