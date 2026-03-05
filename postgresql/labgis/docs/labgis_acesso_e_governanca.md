# LabGIS: acesso e governanca

Este documento organiza o acesso ao servidor PostgreSQL/PostGIS `labgis` e define uma estrutura inicial para os bancos `bronze`, `prata` e `ouro`.

## Estado atual confirmado no inventario

- O PostgreSQL 16 esta ativo no host `sv-labfsg`.
- O banco escuta apenas em `127.0.0.1:5432`.
- Os bancos existentes no inventario de 2026-02-26 sao `labgis`, `postgres`, `template0` e `template1`.
- Por escutar somente em loopback, o acesso remoto depende de tunel SSH, VPN ou tunel externo que termine no proprio host.

Referencia do inventario: `coleta_inventario_20260225_2136.txt` (arquivo historico local, fora do repositorio).

## Fluxo de acesso para usuarios

Tunel SSH:

```bash
ssh -N -L 15432:127.0.0.1:5432 admin1@150.162.76.87
```

Conexao no DBeaver:

- Host: `127.0.0.1`
- Port: `15432`
- Database: `labgis` ou outro banco autorizado
- Username: login individual do usuario
- Password: senha individual do usuario

Observacao importante:

- Evite distribuir o login compartilhado `labfsg` para a equipe.
- O ideal e cada pessoa usar seu proprio login, para rastreabilidade e revogacao individual.

## Estrutura proposta

Bancos:

- `bronze`
- `prata`
- `ouro`

Schemas em cada banco:

- `public`
- `br`
- `omi`
- `cartografia`
- `estimacao`
- Um schema para cada UF do Brasil: `ac`, `al`, `ap`, `am`, `ba`, `ce`, `df`, `es`, `go`, `ma`, `mt`, `ms`, `mg`, `pa`, `pb`, `pr`, `pe`, `pi`, `rj`, `rn`, `rs`, `ro`, `rr`, `sc`, `sp`, `se`, `to`

Extensao:

- `postgis` habilitada em cada banco

## Modelo de privilegios

Roles de grupo:

- `db_superadmin`: DBA/infra com controle do cluster e da infraestrutura do banco
- `labgis_admin`: administradores do ambiente de dados
- `labgis_editor`: usuarios que podem criar e manter conteudo nos schemas liberados
- `omi_admin`, `omi_editor`, `omi_viewer`
- `cartografia_admin`, `cartografia_editor`, `cartografia_viewer`
- `estimacao_admin`, `estimacao_editor`, `estimacao_viewer`

Administradores:

- `labfsg`
- `evertonnubiato`
- `felipepilleggi`
- `kevinnovak`
- `luizdroubi`
- `eduardolongo`
- `hatanpinheiro`

Editores:

- `alexgabriel`
- `alicebranco`
- `franciscosa`
- `joaodestro`
- `kariniestercio`
- `nataliaborges`
- `felipepazolini`
- `gustavomarcal`
- `vitorflorentino`
- `evertondasilva`
- `carolinesilva`
- `vilemalm`
- `waldemarfilho`
- `yasmimfontana`

Permissoes planejadas:

- `labgis_admin`: acesso total aos schemas, direito de criar objetos e criar bancos
- `labgis_editor`: `CONNECT` aos bancos e `USAGE, CREATE` nos schemas `public` e em todos os schemas de UF
- Objetos novos criados pelos usuarios passam a ser compartilhados por default com os grupos, para evitar bloqueio por ownership individual

## Mapeamento nome -> login

- Alex Gabriel -> `alexgabriel`
- Alice Branco -> `alicebranco`
- Eduardo Schmidt Longo -> `eduardolongo`
- Everton Leandro Nubiato -> `evertonnubiato`
- Francisco Eduardo de Mello Franco Sa -> `franciscosa`
- Hatan Pinheiro -> `hatanpinheiro`
- Joao Norberto Destro -> `joaodestro`
- Karini Estercio -> `kariniestercio`
- Luiz Droubi -> `luizdroubi`
- Felipe Pazolini -> `felipepazolini`
- Gustavo Marcal -> `gustavomarcal`
- Natalia Borges -> `nataliaborges`
- Vitor Florentino -> `vitorflorentino`
- Everton da Silva -> `evertondasilva`
- Caroline Silva -> `carolinesilva`
- Vile Malm -> `vilemalm`
- Waldemar Barbosa de Lima Filho -> `waldemarfilho`
- Yasmim Fontana -> `yasmimfontana`

## Exemplo de uso dos grupos tematicos

Observacao:

- Os logins no script seguem o padrao sem ponto, como `nataliaborges`.
- Portanto, o exemplo pratico fica assim:

```sql
GRANT omi_admin TO nataliaborges;
GRANT cartografia_viewer TO nataliaborges;
GRANT estimacao_editor TO nataliaborges;
```

## Arquivo SQL pronto

Script principal:

- `postgresql/labgis/sql/00_provisiona_labgis.sql`

Execucao recomendada no servidor:

```bash
cd /Users/picknovak/Documents/Capacitacao
sudo -u postgres psql -v ON_ERROR_STOP=1 -f postgresql/labgis/sql/00_provisiona_labgis.sql
```

Antes de rodar:

1. Edite as variaveis de senha no topo do arquivo SQL.
2. Confirme se os logins escolhidos estao corretos.
3. Valide se `evertonnubiato` deve mesmo ser `SUPERUSER`. Isso funciona, mas amplia bastante o risco operacional.

## Validacoes depois da execucao

Listar bancos:

```sql
\l
```

Listar roles:

```sql
\du
```

Listar schemas em cada banco:

```sql
\c bronze
\dn
\c prata
\dn
\c ouro
\dn
```

Testes minimos:

1. Conectar com um usuario editor e criar uma tabela em `bronze.sp`, `bronze.br` ou, conforme o grupo concedido, em `bronze.omi`.
2. Conectar com outro usuario editor e verificar se consegue ler e alterar essa tabela.
3. Conectar com um admin e verificar criacao de novo schema ou banco.

## Recomendacao operacional

Se voce quiser expor isso para acesso externo com menos atrito, o caminho mais seguro hoje e:

1. Manter o PostgreSQL ouvindo em `127.0.0.1`.
2. Exigir VPN para entrar na rede.
3. Mesmo dentro da VPN, continuar usando tunel SSH para chegar ao banco.

Assim voce evita publicar o PostgreSQL diretamente na internet e reduz bastante a superficie de ataque.
