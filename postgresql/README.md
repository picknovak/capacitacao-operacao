# PostgreSQL do Host (separado do OpenProject)

## Papel atual

- cluster `16/main`
- escuta em `127.0.0.1:5432`
- base identificada: `labgis` (PostGIS)

## Regra de ouro

Este modulo NAO e o banco do OpenProject (que esta em container `openproject-db`).

## Objetivos de documentacao

- backup/restore de `labgis`
- manutencao de versao
- tuning basico
- verificacao de extensoes PostGIS

