**Backup Playbook (resumo operacional)**

Objetivo: garantir backups regulares e auditáveis para Postgres/PostGIS, OpenProject (dados/uploads), e VMs (RStudio), com cópia para Synology.

- Requisitos iniciais:
  - Synology com espaço suficiente e acesso via SSH/rsync, NFS ou SMB.
  - Usuário de backup no Synology (`backupuser`) com pasta destino configurada.
  - Scripts em `/home/<user>/Projeto/scripts` e permissões `chmod +x`.

- Rotinas principais (diário/sempre):
  1. Postgres logical dump (pg_dump/pg_dumpall) e compressão: `scripts/backup_postgres.sh`.
  2. Backup de volumes Docker (especialmente `/srv/data/docker`): snapshot do volume + rsync para Synology.
  3. VM: exportar disco ou snapshot; se VM for desligada, copiar o arquivo de disco com `scripts/backup_vm.sh`.
  4. Empacotar artefatos coletados e gerar checksum (use `assemble_package.sh` no servidor).
  5. Transferir para Synology com `scripts/upload_to_synology.sh`.
  6. Verificação: `scripts/verify_backup.sh` para checar o `.sha256`.

- Exemplo de crontab (diário às 02:10):
  - Crie um arquivo `/etc/cron.d/backup-servidor` com:

```cron
10 2 * * * root /opt/operacao/capacitacao-operacao/servidor/scripts/backup_postgres.sh /var/backups/postgres && \
  /opt/operacao/capacitacao-operacao/servidor/scripts/collect_extra.sh && \
  /opt/operacao/capacitacao-operacao/servidor/scripts/assemble_package.sh /srv/data/Projeto_pacote_$(date +\%Y\%m\%d) && \
  /opt/operacao/capacitacao-operacao/servidor/scripts/upload_to_synology.sh /srv/data/Projeto_pacote_$(date +\%Y\%m\%d).tar.gz
```

- Recomendações de retenção e ferramenta:
  - Se o projeto for 5 anos, use deduplicação + snapshots (restic ou borg) para reduzir espaço e garantir retenção. Restic com backend na Synology (SFTP) é fácil de integrar.
  - Mínimo: manter dumps diários por 30 dias, semanais por 6 meses, mensais por 5 anos (ajustar RPO/RTO conforme necessidade).

- Testes de restore
  - Agende testes trimestrais de restore: restaurar um dump Postgres em ambiente de staging e verificar integridade do OpenProject.

- Segurança & Auditabilidade
  - Transferência: usar SSH (rsync over SSH) ou Synology com HTTPS/API; crie logs de transferência e armazene checksums SHA-256.
  - Crie alertas para falhas (email ou webhook) usando simples checagem de saída do crontab ou sistema de monitoramento.

- Próximos passos práticos (posso implementar):
  - Integrar `restic` com Synology e criar script de snapshot/retention.
  - Automatizar WAL archiving para Postgres (se RPO requerido < 24h) e scripts de basebackup.
