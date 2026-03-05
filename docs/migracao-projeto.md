# Migracao da pasta `Projeto` para `Capacitacao`

## Objetivo

Manter apenas um repositorio Git operacional centralizado em `Capacitacao`.

## Conteudo migrado

Origem: `/Users/picknovak/Documents/Projeto`

Destino:
- scripts gerais -> `servidor/scripts/`
- docs operacionais -> `servidor/docs/`

Origem adicional: `/Users/picknovak/Documents/BD_labserver`

Destino:
- docs de governanca LabGIS -> `postgresql/labgis/docs/`
- scripts SQL de provisionamento -> `postgresql/labgis/sql/`

## Conteudo NAO migrado (artefatos)

- `extracted_network_check_*`
- `network_check_*.tar.gz`
- `relatorios/*.txt`

Motivo: sao saídas de execucao e podem conter dados sensiveis/temporarios.

## Proximo passo sugerido

1. Trabalhar somente no repositorio `Capacitacao`.
2. Manter a pasta `Projeto` apenas como legado/arquivo.
3. Opcional: compactar e remover `Projeto` depois de validar que nada faltou.
