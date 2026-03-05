# LabGIS (PostgreSQL/PostGIS)

Material operacional e de governanca do ambiente LabGIS, centralizado no repositorio de `Capacitacao`.

## Conteudo

- `postgresql/labgis/docs/labgis_acesso_e_governanca.md`
- `postgresql/labgis/docs/modelo_permissoes_por_uf.md`
- `postgresql/labgis/docs/wiki_estrutura_e_permissoes_labgis.md`
- `postgresql/labgis/sql/00_provisiona_labgis.sql`
- `postgresql/labgis/sql/01_remove_schemas_tematicos.sql`

## Observacoes de seguranca

- Os SQLs contem placeholders e exemplos de senha no topo. Troque antes de executar.
- Nao execute scripts destrutivos (`DROP ... CASCADE`) sem backup e validacao.
- Sempre registrar mudancas de banco no Git antes e depois da execucao.

## Fluxo recomendado

1. Revisar docs de governanca.
2. Testar SQL em ambiente controlado.
3. Validar impacto em permissao/ownership.
4. Executar em producao em janela aprovada.

