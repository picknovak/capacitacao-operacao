# LabGIS / PostGIS

Manual resumido para governanca e operacao do PostgreSQL/PostGIS do host (separado do OpenProject).

## Escopo

- banco `labgis`
- bases relacionadas: `bronze`, `prata`, `ouro`
- governanca de acesso por roles/grupos
- modelo de schemas por UF
- scripts SQL de provisionamento

## Estado atual (coleta 2026-03-04)

- cluster host `16/main` online
- bases `labgis`, `bronze`, `prata`, `ouro` presentes
- PostGIS validado nessas quatro bases

## Material principal

- `postgresql/labgis/README.md`
- `postgresql/labgis/docs/labgis_acesso_e_governanca.md`
- `postgresql/labgis/docs/modelo_permissoes_por_uf.md`
- `postgresql/labgis/docs/wiki_estrutura_e_permissoes_labgis.md`
- `postgresql/labgis/sql/00_provisiona_labgis.sql`
- `postgresql/labgis/sql/01_remove_schemas_tematicos.sql`

## Cuidados

- o SQL `01_remove_schemas_tematicos.sql` e destrutivo (`DROP ... CASCADE`)
- validar em ambiente de teste antes de producao
- revisar senhas/placeholders e politicas de privilegio antes de executar

## Regra de separacao

O banco do OpenProject roda no container `openproject-db` e NAO deve ser operado com os mesmos scripts/padroes do `labgis` do host.
