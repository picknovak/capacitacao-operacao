# Status Operacional (2026-03-04)

Atualizacao consolidada apos demandas emergenciais de infraestrutura de dados.

## Mudancas relevantes desde a coleta anterior

- Novas bases no PostgreSQL host: `bronze`, `prata`, `ouro`
- PostGIS confirmado em: `labgis`, `bronze`, `prata`, `ouro`
- OpenProject permanece estavel:
  - `openproject-web` em execucao
  - `openproject-db` healthy
- UFW ativo e com politica de entrada restritiva

## Capacidade observada no momento da coleta

- RAM: ~12 GiB em uso de 15 GiB
- Swap: ~821 MiB em uso
- Disco:
  - `/srv/data` ~4% de uso
  - sem pressao de storage no momento

## Pontos de atencao imediatos

1. Monitorar memoria/swap nas proximas semanas por conta dos novos bancos.
2. Atualizar runbooks do LabGIS para refletir operacao de `bronze`, `prata`, `ouro`.
3. Retomar TODOs pausados de backup/restore e hardening sem perder as demandas de infraestrutura.

## Acoes recomendadas para esta semana

- publicar esta pagina na wiki do OpenProject
- publicar/atualizar as paginas:
  - `Ambiente`
  - `LabGIS - PostGIS`
  - `Roadmap`
- definir janela para:
  - baseline de performance do PostgreSQL host
  - politica de retencao de backups
  - teste de restore em ambiente isolado

## Fonte

- `coleta_inventario/coleta_inventario_20260304_2101_pos_bancos.txt`

