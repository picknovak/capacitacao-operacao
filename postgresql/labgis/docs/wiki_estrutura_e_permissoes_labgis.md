# Wiki: Estrutura e Permissoes do LabGIS

## Visao geral

O ambiente PostgreSQL/PostGIS do LabGIS foi estruturado com tres bancos principais:

- `bronze`
- `prata`
- `ouro`

Cada banco representa uma camada do fluxo de dados.

## Estrutura de schemas

O modelo principal adotado e territorial.

Em cada banco existem:

- `public`
- `br`
- um schema para cada UF do Brasil:
  - `ac`, `al`, `ap`, `am`, `ba`, `ce`, `df`, `es`, `go`, `ma`, `mt`, `ms`, `mg`, `pa`, `pb`, `pr`, `pe`, `pi`, `rj`, `rn`, `rs`, `ro`, `rr`, `sc`, `sp`, `se`, `to`

Exemplo:

- `bronze.pr`
- `prata.sc`
- `ouro.br`

## Modelo de organizacao dos dados

O recorte principal do banco e por territorio, nao por tema.

Isso significa que os dados de cada tema ficam dentro do schema da UF correspondente.

Exemplo no schema `pr`:

- `pr.cartografia_base_rodovias`
- `pr.omi_insumo_rodovias`
- `pr.estimacao_cenario_rodovias`

Nesse modelo:

- `cartografia`, `omi` e `estimacao` nao precisam existir como schemas separados
- eles passam a existir como convencao de nomenclatura das tabelas

## Grupos de acesso

### Infraestrutura

- `db_superadmin`
  - uso: DBA e infraestrutura
  - membros previstos: `kevinnovak`, `evertonnubiato`, `felipepilleggi`, `luizdroubi`

### Grupos tematicos

- `omi_admin`
- `omi_editor`
- `omi_viewer`

- `cartografia_admin`
- `cartografia_editor`
- `cartografia_viewer`

- `estimacao_admin`
- `estimacao_editor`
- `estimacao_viewer`

Esses grupos representam funcao de acesso, nao schema proprio.

## O que os grupos fazem

### Admin

Uso esperado:

- controlar tabelas do proprio tema
- alterar estrutura quando autorizado
- conceder acesso operacional por tabela

Permissoes tipicas:

- `SELECT`
- `INSERT`
- `UPDATE`
- `DELETE`
- `TRUNCATE`
- `REFERENCES`
- `TRIGGER`
- eventualmente `ALTER TABLE`, `DROP`, `OWNER`, dependendo da governanca adotada

### Editor

Uso esperado:

- inserir
- corrigir
- atualizar
- consultar

Permissoes tipicas:

- `SELECT`
- `INSERT`
- `UPDATE`
- `DELETE`

### Viewer

Uso esperado:

- apenas leitura

Permissao tipica:

- `SELECT`

## Por que o controle por grupo nao basta sozinho

Mesmo com os grupos `omi_*`, `cartografia_*` e `estimacao_*` criados, o PostgreSQL nao controla permissao por prefixo do nome da tabela.

Exemplo:

- `pr.cartografia_base_rodovias`
- `pr.omi_insumo_rodovias`
- `pr.estimacao_cenario_rodovias`

As tres tabelas pertencem ao mesmo schema `pr`.

Para o banco, todas sao objetos do schema `pr`.

Entao, para garantir que:

- cartografia administre apenas tabelas `cartografia_*`
- omi veja ou edite apenas tabelas `omi_*`
- estimacao atue apenas sobre tabelas `estimacao_*`

o controle precisa ser dado por tabela.

## O que um script de GRANT por tabela faria na pratica

Esse script nao criaria bancos ou schemas novos.

Ele serviria para aplicar permissoes nos objetos reais que existem dentro de cada UF.

Na pratica, ele faria coisas como:

1. localizar tabelas do tema cartografia dentro de uma UF
2. dar `SELECT/INSERT/UPDATE/DELETE` para `cartografia_editor`
3. dar `SELECT` para `cartografia_viewer`
4. dar permissoes mais amplas para `cartografia_admin`
5. repetir isso para `omi_*` e `estimacao_*`
6. repetir isso para `ac`, `al`, `am`, `pr`, `br` e demais schemas

Exemplo conceitual:

```sql
GRANT SELECT, INSERT, UPDATE, DELETE
ON TABLE pr.cartografia_base_rodovias
TO cartografia_editor;

GRANT SELECT
ON TABLE pr.cartografia_base_rodovias
TO cartografia_viewer;

GRANT ALL
ON TABLE pr.cartografia_base_rodovias
TO cartografia_admin;
```

Outro exemplo:

```sql
GRANT SELECT
ON TABLE pr.omi_insumo_rodovias
TO omi_viewer;

GRANT SELECT, INSERT, UPDATE, DELETE
ON TABLE pr.omi_insumo_rodovias
TO omi_editor;
```

## Exemplo de fluxo operacional

Exemplo no schema `pr`:

1. o grupo de cartografia cria `pr.cartografia_base_rodovias`
2. o grupo de OMI consome essa tabela e cria `pr.omi_insumo_rodovias`
3. o grupo de estimacao consome esse resultado e cria `pr.estimacao_cenario_rodovias`

Para isso funcionar com seguranca, as permissoes devem ser dadas tabela a tabela.

## Exemplo de associacao de usuario aos grupos

Exemplo:

```sql
GRANT cartografia_admin TO felipepazolini;
GRANT omi_viewer TO felipepazolini;
GRANT estimacao_editor TO felipepazolini;
```

Esse comando apenas coloca o usuario nos grupos.

O acesso efetivo aos dados depende dos `GRANT`s nas tabelas.

## Recomendacao de governanca

Modelo recomendado:

- manter schemas por UF e `br`
- manter convencao rigida de nomes de tabela por tema
- manter grupos tematicos por funcao
- aplicar controle fino por tabela

Convencao sugerida:

- `cartografia_*`
- `omi_*`
- `estimacao_*`

## Estrategia recomendada de administracao

### Nivel 1: estrutura

- bancos `bronze`, `prata`, `ouro`
- schemas de UFs e `br`

### Nivel 2: grupos

- `db_superadmin`
- `cartografia_admin`, `cartografia_editor`, `cartografia_viewer`
- `omi_admin`, `omi_editor`, `omi_viewer`
- `estimacao_admin`, `estimacao_editor`, `estimacao_viewer`

### Nivel 3: permissoes reais

- `GRANT` por tabela
- `GRANT` por sequence, quando necessario
- ajuste de ownership e default privileges quando fizer sentido

## Vantagens desse modelo

- organiza os dados por territorio
- preserva a separacao funcional por grupo
- facilita o trabalho colaborativo entre cartografia, OMI e estimacao
- evita criar uma explosao de schemas por tema e por UF

## Limitacoes

- exige disciplina na nomenclatura
- exige script ou rotina de grants por tabela
- nao resolve automaticamente permissoes apenas com a existencia dos grupos

## Proximo passo recomendado

Criar um script operacional de `GRANT` por tabela que:

- percorra os schemas de UF e `br`
- identifique tabelas por prefixo
- aplique permissao para os grupos corretos
- possa ser rerodado com seguranca conforme novas tabelas forem surgindo
