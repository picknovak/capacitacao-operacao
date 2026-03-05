# Modelo por UF com grupos tematicos

Modelo recomendado:

- Manter schemas territoriais: `ac`, `al`, `am`, `ap`, `ba`, ..., `to`, `br`
- Nao usar schemas separados `omi`, `cartografia`, `estimacao`
- Manter os grupos/roles tematicos:
  - `omi_admin`, `omi_editor`, `omi_viewer`
  - `cartografia_admin`, `cartografia_editor`, `cartografia_viewer`
  - `estimacao_admin`, `estimacao_editor`, `estimacao_viewer`

Exemplo de tabelas em uma UF:

- `pr.cartografia_base_rodovias`
- `pr.omi_insumo_rodovias`
- `pr.estimacao_cenario_rodovias`

Ponto importante:

- Remover os schemas `omi`, `cartografia` e `estimacao` limpa a estrutura.
- Isso **nao garante sozinho** controle fino por tema dentro de cada UF.
- No PostgreSQL, se tudo estiver no schema `pr`, o banco nao separa permissao por prefixo de nome da tabela.

O que isso significa na pratica:

- Os grupos tematicos continuam uteis para organizar os usuarios.
- Mas as permissoes reais por tema dentro de `pr`, `sc`, `mg` etc. precisam ser dadas por tabela, view ou sequence.

Exemplo:

```sql
GRANT cartografia_admin TO felipepazolini;
GRANT omi_viewer TO felipepazolini;
GRANT estimacao_editor TO felipepazolini;
```

Esses `GRANT`s acima definem pertencimento aos grupos.
O acesso efetivo aos objetos continua dependendo dos `GRANT`s nos objetos do schema da UF.

Conclusao:

- Sim, faz sentido remover os schemas tematicos.
- Sim, faz sentido manter os grupos tematicos.
- Para garantir quem pode o que dentro de cada UF, o proximo passo correto e um script separado de grants por tabela.
