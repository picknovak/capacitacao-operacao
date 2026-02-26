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

