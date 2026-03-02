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
- `docs/wiki/Ambiente.md`
- `docs/wiki/OpenProject-Manual.md`
- `docs/wiki/Backup-e-Restore.md`
- `docs/wiki/Seguranca-e-Hardening.md`
- `docs/wiki/Rotina-Operacional.md`
- `docs/wiki/Roadmap.md`

## Estado atual

- Repositorio Git operacional criado e funcionando
- OpenProject identificado em Docker
- Backup diario identificado e documentado
- Evidencia de falha de backup apos reboot registrada

## Regra de ouro

O banco do OpenProject em container `openproject-db` NAO e o PostgreSQL 16 do host. Nunca tratar os dois como se fossem o mesmo banco.

