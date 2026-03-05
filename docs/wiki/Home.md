# Wiki de Operacao

Wiki/manual para capacitar responsaveis pela operacao do ambiente, com foco em estabilidade e seguranca do OpenProject.

## Como usar esta wiki

1. Comece por `docs/wiki/Quickstart.md`.
2. Leia `docs/wiki/Ambiente.md` para entender o ambiente real.
3. Use `docs/wiki/OpenProject-Manual.md` para operacao do OpenProject.
4. Use `docs/wiki/Backup-e-Restore.md` antes de qualquer mudanca relevante.
5. Consulte `docs/wiki/Roadmap.md` para o que ja foi concluido e o que falta.

## Navegacao

- `docs/wiki/Quickstart.md`
- `docs/wiki/Status-Operacional-2026-03-04.md`
- `docs/wiki/Ambiente.md`
- `docs/wiki/Servidor-Manual.md`
- `docs/wiki/OpenProject-Manual.md`
- `docs/wiki/LabGIS-PostGIS.md`
- `docs/wiki/Backup-e-Restore.md`
- `docs/wiki/Seguranca-e-Hardening.md`
- `docs/wiki/Rotina-Operacional.md`
- `docs/wiki/Roadmap.md`

## Estado atual

- Repositorio Git operacional criado e funcionando
- Material de `Projeto` consolidado em `servidor/`
- OpenProject identificado em Docker
- Backup diario identificado e documentado
- Evidencia de falha de backup apos reboot registrada
- Material de `BD_labserver` consolidado em `postgresql/labgis/`
- Nova coleta pos-expansao de bancos registrada em `2026-03-04`

## Regra de ouro

O banco do OpenProject em container `openproject-db` NAO e o PostgreSQL 16 do host. Nunca tratar os dois como se fossem o mesmo banco.
