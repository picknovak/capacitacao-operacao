-- Provisionamento inicial do ambiente PostGIS "labgis".
-- Execucao recomendada:
--   sudo -u postgres psql -v ON_ERROR_STOP=1 -f sql/00_provisiona_labgis.sql
--
-- Observacoes:
-- 1. Este script usa metacomandos do psql (\connect e \gexec).
-- 2. Ajuste as senhas abaixo antes da execucao.
-- 3. O role "evertonnubiato" foi mantido como SUPERUSER porque isso foi pedido,
--    mas o ideal e limitar SUPERUSER ao menor numero possivel de pessoas.

\set ON_ERROR_STOP on
-- Senhas: troque antes de executar.
\set senha_evertonnubiato '__CHANGE_ME__'
\set senha_felipepilleggi '__CHANGE_ME__'
\set senha_kevinnovak '__CHANGE_ME__'
\set senha_luizdroubi '__CHANGE_ME__'
\set senha_alexgabriel '__CHANGE_ME__'
\set senha_alicebranco '__CHANGE_ME__'
\set senha_eduardolongo '__CHANGE_ME__'
\set senha_felipepazolini '__CHANGE_ME__'
\set senha_franciscosa '__CHANGE_ME__'
\set senha_gustavomarcal '__CHANGE_ME__'
\set senha_hatanpinheiro '__CHANGE_ME__'
\set senha_joaodestro '__CHANGE_ME__'
\set senha_kariniestercio '__CHANGE_ME__'
\set senha_nataliaborges '__CHANGE_ME__'
\set senha_vitorflorentino '__CHANGE_ME__'
\set senha_vilemalm '__CHANGE_ME__'
\set senha_waldemarfilho '__CHANGE_ME__'
\set senha_yasmimfontana '__CHANGE_ME__'
\set senha_evertondasilva '__CHANGE_ME__'
\set senha_carolinesilva '__CHANGE_ME__'

-- Roles de grupo
SELECT 'CREATE ROLE labgis_admin NOLOGIN'
WHERE NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'labgis_admin') \gexec

SELECT 'CREATE ROLE labgis_editor NOLOGIN'
WHERE NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'labgis_editor') \gexec

-- Role existente, padronizada explicitamente
ALTER ROLE labfsg WITH
    NOSUPERUSER
    NOCREATEDB
    NOCREATEROLE
    INHERIT
    LOGIN
    NOREPLICATION
    NOBYPASSRLS
    CONNECTION LIMIT -1;

-- Administrador pedido explicitamente
SELECT 'CREATE ROLE evertonnubiato LOGIN'
WHERE NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'evertonnubiato') \gexec

ALTER ROLE evertonnubiato WITH
    SUPERUSER
    CREATEDB
    CREATEROLE
    INHERIT
    LOGIN
    NOREPLICATION
    NOBYPASSRLS
    CONNECTION LIMIT -1
    PASSWORD :'senha_evertonnubiato';

SELECT 'CREATE ROLE felipepilleggi LOGIN'
WHERE NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'felipepilleggi') \gexec

ALTER ROLE felipepilleggi WITH
    SUPERUSER
    CREATEDB
    CREATEROLE
    INHERIT
    LOGIN
    NOREPLICATION
    NOBYPASSRLS
    CONNECTION LIMIT -1
    PASSWORD :'senha_felipepilleggi';

SELECT 'CREATE ROLE kevinnovak LOGIN'
WHERE NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'kevinnovak') \gexec

ALTER ROLE kevinnovak WITH
    SUPERUSER
    CREATEDB
    CREATEROLE
    INHERIT
    LOGIN
    NOREPLICATION
    NOBYPASSRLS
    CONNECTION LIMIT -1
    PASSWORD :'senha_kevinnovak';

-- Usuarios de aplicacao
SELECT 'CREATE ROLE alexgabriel LOGIN PASSWORD ' || quote_literal(:'senha_alexgabriel') || ' INHERIT'
WHERE NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'alexgabriel') \gexec

SELECT 'CREATE ROLE alicebranco LOGIN PASSWORD ' || quote_literal(:'senha_alicebranco') || ' INHERIT'
WHERE NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'alicebranco') \gexec

SELECT 'CREATE ROLE eduardolongo LOGIN PASSWORD ' || quote_literal(:'senha_eduardolongo') || ' INHERIT'
WHERE NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'eduardolongo') \gexec

SELECT 'CREATE ROLE franciscosa LOGIN PASSWORD ' || quote_literal(:'senha_franciscosa') || ' INHERIT'
WHERE NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'franciscosa') \gexec

SELECT 'CREATE ROLE hatanpinheiro LOGIN PASSWORD ' || quote_literal(:'senha_hatanpinheiro') || ' INHERIT'
WHERE NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'hatanpinheiro') \gexec

SELECT 'CREATE ROLE joaodestro LOGIN PASSWORD ' || quote_literal(:'senha_joaodestro') || ' INHERIT'
WHERE NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'joaodestro') \gexec

SELECT 'CREATE ROLE kariniestercio LOGIN PASSWORD ' || quote_literal(:'senha_kariniestercio') || ' INHERIT'
WHERE NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'kariniestercio') \gexec

SELECT 'CREATE ROLE nataliaborges LOGIN PASSWORD ' || quote_literal(:'senha_nataliaborges') || ' INHERIT'
WHERE NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'nataliaborges') \gexec

SELECT 'CREATE ROLE vilemalm LOGIN PASSWORD ' || quote_literal(:'senha_vilemalm') || ' INHERIT'
WHERE NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'vilemalm') \gexec

SELECT 'CREATE ROLE waldemarfilho LOGIN PASSWORD ' || quote_literal(:'senha_waldemarfilho') || ' INHERIT'
WHERE NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'waldemarfilho') \gexec

SELECT 'CREATE ROLE yasmimfontana LOGIN PASSWORD ' || quote_literal(:'senha_yasmimfontana') || ' INHERIT'
WHERE NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'yasmimfontana') \gexec

-- Atributos explicitados para padronizar os logins comuns
ALTER ROLE alexgabriel WITH NOSUPERUSER NOCREATEDB NOCREATEROLE INHERIT LOGIN NOREPLICATION NOBYPASSRLS CONNECTION LIMIT -1;
ALTER ROLE alicebranco WITH NOSUPERUSER NOCREATEDB NOCREATEROLE INHERIT LOGIN NOREPLICATION NOBYPASSRLS CONNECTION LIMIT -1;
ALTER ROLE eduardolongo WITH NOSUPERUSER NOCREATEDB NOCREATEROLE INHERIT LOGIN NOREPLICATION NOBYPASSRLS CONNECTION LIMIT -1;
ALTER ROLE franciscosa WITH NOSUPERUSER NOCREATEDB NOCREATEROLE INHERIT LOGIN NOREPLICATION NOBYPASSRLS CONNECTION LIMIT -1;
ALTER ROLE hatanpinheiro WITH NOSUPERUSER NOCREATEDB NOCREATEROLE INHERIT LOGIN NOREPLICATION NOBYPASSRLS CONNECTION LIMIT -1;
ALTER ROLE joaodestro WITH NOSUPERUSER NOCREATEDB NOCREATEROLE INHERIT LOGIN NOREPLICATION NOBYPASSRLS CONNECTION LIMIT -1;
ALTER ROLE kariniestercio WITH NOSUPERUSER NOCREATEDB NOCREATEROLE INHERIT LOGIN NOREPLICATION NOBYPASSRLS CONNECTION LIMIT -1;
ALTER ROLE nataliaborges WITH NOSUPERUSER NOCREATEDB NOCREATEROLE INHERIT LOGIN NOREPLICATION NOBYPASSRLS CONNECTION LIMIT -1;
ALTER ROLE vilemalm WITH NOSUPERUSER NOCREATEDB NOCREATEROLE INHERIT LOGIN NOREPLICATION NOBYPASSRLS CONNECTION LIMIT -1;
ALTER ROLE waldemarfilho WITH NOSUPERUSER NOCREATEDB NOCREATEROLE INHERIT LOGIN NOREPLICATION NOBYPASSRLS CONNECTION LIMIT -1;
ALTER ROLE yasmimfontana WITH NOSUPERUSER NOCREATEDB NOCREATEROLE INHERIT LOGIN NOREPLICATION NOBYPASSRLS CONNECTION LIMIT -1;

-- Membros dos grupos
GRANT labgis_admin TO labfsg;
GRANT labgis_admin TO evertonnubiato;
GRANT labgis_admin TO felipepilleggi;
GRANT labgis_admin TO kevinnovak;
GRANT labgis_admin TO eduardolongo;
GRANT labgis_admin TO hatanpinheiro;

GRANT labgis_editor TO alexgabriel;
GRANT labgis_editor TO alicebranco;
GRANT labgis_editor TO franciscosa;
GRANT labgis_editor TO joaodestro;
GRANT labgis_editor TO kariniestercio;
GRANT labgis_editor TO nataliaborges;
GRANT labgis_editor TO vilemalm;
GRANT labgis_editor TO waldemarfilho;
GRANT labgis_editor TO yasmimfontana;

-- Administradores tambem recebem o perfil editor para herdar uso padrao dos schemas
GRANT labgis_editor TO labfsg;
GRANT labgis_editor TO evertonnubiato;
GRANT labgis_editor TO felipepilleggi;
GRANT labgis_editor TO kevinnovak;
GRANT labgis_editor TO eduardolongo;
GRANT labgis_editor TO hatanpinheiro;

-- Cria bancos se ainda nao existirem
SELECT 'CREATE DATABASE bronze OWNER labfsg TEMPLATE template1'
WHERE NOT EXISTS (SELECT 1 FROM pg_database WHERE datname = 'bronze') \gexec

SELECT 'CREATE DATABASE prata OWNER labfsg TEMPLATE template1'
WHERE NOT EXISTS (SELECT 1 FROM pg_database WHERE datname = 'prata') \gexec

SELECT 'CREATE DATABASE ouro OWNER labfsg TEMPLATE template1'
WHERE NOT EXISTS (SELECT 1 FROM pg_database WHERE datname = 'ouro') \gexec

\connect bronze

CREATE EXTENSION IF NOT EXISTS postgis;
WITH uf_schemas(schema_name) AS (
    VALUES
        ('ac'),
        ('al'),
        ('ap'),
        ('am'),
        ('ba'),
        ('ce'),
        ('df'),
        ('es'),
        ('go'),
        ('ma'),
        ('mt'),
        ('ms'),
        ('mg'),
        ('pa'),
        ('pb'),
        ('pr'),
        ('pe'),
        ('pi'),
        ('rj'),
        ('rn'),
        ('rs'),
        ('ro'),
        ('rr'),
        ('sc'),
        ('sp'),
        ('se'),
        ('to')
)
SELECT format('CREATE SCHEMA IF NOT EXISTS %I AUTHORIZATION labfsg;', schema_name)
FROM uf_schemas \gexec

REVOKE CREATE ON SCHEMA public FROM PUBLIC;
WITH target_schemas(schema_name) AS (
    VALUES
        ('public'),
        ('ac'),
        ('al'),
        ('ap'),
        ('am'),
        ('ba'),
        ('ce'),
        ('df'),
        ('es'),
        ('go'),
        ('ma'),
        ('mt'),
        ('ms'),
        ('mg'),
        ('pa'),
        ('pb'),
        ('pr'),
        ('pe'),
        ('pi'),
        ('rj'),
        ('rn'),
        ('rs'),
        ('ro'),
        ('rr'),
        ('sc'),
        ('sp'),
        ('se'),
        ('to')
)
SELECT format('GRANT USAGE, CREATE ON SCHEMA %I TO labgis_editor;', schema_name)
FROM target_schemas \gexec

WITH target_schemas(schema_name) AS (
    VALUES
        ('public'),
        ('ac'),
        ('al'),
        ('ap'),
        ('am'),
        ('ba'),
        ('ce'),
        ('df'),
        ('es'),
        ('go'),
        ('ma'),
        ('mt'),
        ('ms'),
        ('mg'),
        ('pa'),
        ('pb'),
        ('pr'),
        ('pe'),
        ('pi'),
        ('rj'),
        ('rn'),
        ('rs'),
        ('ro'),
        ('rr'),
        ('sc'),
        ('sp'),
        ('se'),
        ('to')
)
SELECT format('GRANT ALL ON SCHEMA %I TO labgis_admin;', schema_name)
FROM target_schemas \gexec
GRANT CONNECT, TEMPORARY ON DATABASE bronze TO labgis_editor, labgis_admin;
GRANT CREATE ON DATABASE bronze TO labgis_admin;

\connect prata

CREATE EXTENSION IF NOT EXISTS postgis;
WITH uf_schemas(schema_name) AS (
    VALUES
        ('ac'),
        ('al'),
        ('ap'),
        ('am'),
        ('ba'),
        ('ce'),
        ('df'),
        ('es'),
        ('go'),
        ('ma'),
        ('mt'),
        ('ms'),
        ('mg'),
        ('pa'),
        ('pb'),
        ('pr'),
        ('pe'),
        ('pi'),
        ('rj'),
        ('rn'),
        ('rs'),
        ('ro'),
        ('rr'),
        ('sc'),
        ('sp'),
        ('se'),
        ('to')
)
SELECT format('CREATE SCHEMA IF NOT EXISTS %I AUTHORIZATION labfsg;', schema_name)
FROM uf_schemas \gexec

REVOKE CREATE ON SCHEMA public FROM PUBLIC;
WITH target_schemas(schema_name) AS (
    VALUES
        ('public'),
        ('ac'),
        ('al'),
        ('ap'),
        ('am'),
        ('ba'),
        ('ce'),
        ('df'),
        ('es'),
        ('go'),
        ('ma'),
        ('mt'),
        ('ms'),
        ('mg'),
        ('pa'),
        ('pb'),
        ('pr'),
        ('pe'),
        ('pi'),
        ('rj'),
        ('rn'),
        ('rs'),
        ('ro'),
        ('rr'),
        ('sc'),
        ('sp'),
        ('se'),
        ('to')
)
SELECT format('GRANT USAGE, CREATE ON SCHEMA %I TO labgis_editor;', schema_name)
FROM target_schemas \gexec

WITH target_schemas(schema_name) AS (
    VALUES
        ('public'),
        ('ac'),
        ('al'),
        ('ap'),
        ('am'),
        ('ba'),
        ('ce'),
        ('df'),
        ('es'),
        ('go'),
        ('ma'),
        ('mt'),
        ('ms'),
        ('mg'),
        ('pa'),
        ('pb'),
        ('pr'),
        ('pe'),
        ('pi'),
        ('rj'),
        ('rn'),
        ('rs'),
        ('ro'),
        ('rr'),
        ('sc'),
        ('sp'),
        ('se'),
        ('to')
)
SELECT format('GRANT ALL ON SCHEMA %I TO labgis_admin;', schema_name)
FROM target_schemas \gexec
GRANT CONNECT, TEMPORARY ON DATABASE prata TO labgis_editor, labgis_admin;
GRANT CREATE ON DATABASE prata TO labgis_admin;

\connect ouro

CREATE EXTENSION IF NOT EXISTS postgis;
WITH uf_schemas(schema_name) AS (
    VALUES
        ('ac'),
        ('al'),
        ('ap'),
        ('am'),
        ('ba'),
        ('ce'),
        ('df'),
        ('es'),
        ('go'),
        ('ma'),
        ('mt'),
        ('ms'),
        ('mg'),
        ('pa'),
        ('pb'),
        ('pr'),
        ('pe'),
        ('pi'),
        ('rj'),
        ('rn'),
        ('rs'),
        ('ro'),
        ('rr'),
        ('sc'),
        ('sp'),
        ('se'),
        ('to')
)
SELECT format('CREATE SCHEMA IF NOT EXISTS %I AUTHORIZATION labfsg;', schema_name)
FROM uf_schemas \gexec

REVOKE CREATE ON SCHEMA public FROM PUBLIC;
WITH target_schemas(schema_name) AS (
    VALUES
        ('public'),
        ('ac'),
        ('al'),
        ('ap'),
        ('am'),
        ('ba'),
        ('ce'),
        ('df'),
        ('es'),
        ('go'),
        ('ma'),
        ('mt'),
        ('ms'),
        ('mg'),
        ('pa'),
        ('pb'),
        ('pr'),
        ('pe'),
        ('pi'),
        ('rj'),
        ('rn'),
        ('rs'),
        ('ro'),
        ('rr'),
        ('sc'),
        ('sp'),
        ('se'),
        ('to')
)
SELECT format('GRANT USAGE, CREATE ON SCHEMA %I TO labgis_editor;', schema_name)
FROM target_schemas \gexec

WITH target_schemas(schema_name) AS (
    VALUES
        ('public'),
        ('ac'),
        ('al'),
        ('ap'),
        ('am'),
        ('ba'),
        ('ce'),
        ('df'),
        ('es'),
        ('go'),
        ('ma'),
        ('mt'),
        ('ms'),
        ('mg'),
        ('pa'),
        ('pb'),
        ('pr'),
        ('pe'),
        ('pi'),
        ('rj'),
        ('rn'),
        ('rs'),
        ('ro'),
        ('rr'),
        ('sc'),
        ('sp'),
        ('se'),
        ('to')
)
SELECT format('GRANT ALL ON SCHEMA %I TO labgis_admin;', schema_name)
FROM target_schemas \gexec
GRANT CONNECT, TEMPORARY ON DATABASE ouro TO labgis_editor, labgis_admin;
GRANT CREATE ON DATABASE ouro TO labgis_admin;

-- Default privileges para que objetos novos sejam compartilhados dentro do grupo
\connect bronze
WITH creators(role_name) AS (
    VALUES
        ('labfsg'),
        ('evertonnubiato'),
        ('felipepilleggi'),
        ('kevinnovak'),
        ('eduardolongo'),
        ('hatanpinheiro'),
        ('alexgabriel'),
        ('alicebranco'),
        ('franciscosa'),
        ('joaodestro'),
        ('kariniestercio'),
        ('nataliaborges'),
        ('vilemalm'),
        ('waldemarfilho'),
        ('yasmimfontana')
),
target_schemas(schema_name) AS (
    VALUES
        ('public'),
        ('ac'),
        ('al'),
        ('ap'),
        ('am'),
        ('ba'),
        ('ce'),
        ('df'),
        ('es'),
        ('go'),
        ('ma'),
        ('mt'),
        ('ms'),
        ('mg'),
        ('pa'),
        ('pb'),
        ('pr'),
        ('pe'),
        ('pi'),
        ('rj'),
        ('rn'),
        ('rs'),
        ('ro'),
        ('rr'),
        ('sc'),
        ('sp'),
        ('se'),
        ('to')
)
SELECT format(
    'ALTER DEFAULT PRIVILEGES FOR ROLE %I IN SCHEMA %I GRANT ALL ON TABLES TO labgis_admin;',
    role_name,
    schema_name
)
FROM creators
CROSS JOIN target_schemas \gexec

-- Incrementos posteriores: schema BR, grupos tematicos e novos usuarios
SELECT 'CREATE ROLE db_superadmin NOLOGIN'
WHERE NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'db_superadmin') \gexec

SELECT 'CREATE ROLE omi_admin NOLOGIN'
WHERE NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'omi_admin') \gexec
SELECT 'CREATE ROLE omi_editor NOLOGIN'
WHERE NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'omi_editor') \gexec
SELECT 'CREATE ROLE omi_viewer NOLOGIN'
WHERE NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'omi_viewer') \gexec

SELECT 'CREATE ROLE cartografia_admin NOLOGIN'
WHERE NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'cartografia_admin') \gexec
SELECT 'CREATE ROLE cartografia_editor NOLOGIN'
WHERE NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'cartografia_editor') \gexec
SELECT 'CREATE ROLE cartografia_viewer NOLOGIN'
WHERE NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'cartografia_viewer') \gexec

SELECT 'CREATE ROLE estimacao_admin NOLOGIN'
WHERE NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'estimacao_admin') \gexec
SELECT 'CREATE ROLE estimacao_editor NOLOGIN'
WHERE NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'estimacao_editor') \gexec
SELECT 'CREATE ROLE estimacao_viewer NOLOGIN'
WHERE NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'estimacao_viewer') \gexec

SELECT 'CREATE ROLE luizdroubi LOGIN'
WHERE NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'luizdroubi') \gexec

ALTER ROLE luizdroubi WITH
    SUPERUSER
    CREATEDB
    CREATEROLE
    INHERIT
    LOGIN
    NOREPLICATION
    NOBYPASSRLS
    CONNECTION LIMIT -1
    PASSWORD :'senha_luizdroubi';

SELECT 'CREATE ROLE felipepazolini LOGIN PASSWORD ' || quote_literal(:'senha_felipepazolini') || ' INHERIT'
WHERE NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'felipepazolini') \gexec
SELECT 'CREATE ROLE gustavomarcal LOGIN PASSWORD ' || quote_literal(:'senha_gustavomarcal') || ' INHERIT'
WHERE NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'gustavomarcal') \gexec
SELECT 'CREATE ROLE vitorflorentino LOGIN PASSWORD ' || quote_literal(:'senha_vitorflorentino') || ' INHERIT'
WHERE NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'vitorflorentino') \gexec
SELECT 'CREATE ROLE evertondasilva LOGIN PASSWORD ' || quote_literal(:'senha_evertondasilva') || ' INHERIT'
WHERE NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'evertondasilva') \gexec
SELECT 'CREATE ROLE carolinesilva LOGIN PASSWORD ' || quote_literal(:'senha_carolinesilva') || ' INHERIT'
WHERE NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'carolinesilva') \gexec

ALTER ROLE felipepazolini WITH NOSUPERUSER NOCREATEDB NOCREATEROLE INHERIT LOGIN NOREPLICATION NOBYPASSRLS CONNECTION LIMIT -1;
ALTER ROLE gustavomarcal WITH NOSUPERUSER NOCREATEDB NOCREATEROLE INHERIT LOGIN NOREPLICATION NOBYPASSRLS CONNECTION LIMIT -1;
ALTER ROLE vitorflorentino WITH NOSUPERUSER NOCREATEDB NOCREATEROLE INHERIT LOGIN NOREPLICATION NOBYPASSRLS CONNECTION LIMIT -1;
ALTER ROLE evertondasilva WITH NOSUPERUSER NOCREATEDB NOCREATEROLE INHERIT LOGIN NOREPLICATION NOBYPASSRLS CONNECTION LIMIT -1;
ALTER ROLE carolinesilva WITH NOSUPERUSER NOCREATEDB NOCREATEROLE INHERIT LOGIN NOREPLICATION NOBYPASSRLS CONNECTION LIMIT -1;

GRANT labgis_admin TO luizdroubi;
GRANT labgis_editor TO luizdroubi;
GRANT db_superadmin TO kevinnovak;
GRANT db_superadmin TO evertonnubiato;
GRANT db_superadmin TO felipepilleggi;
GRANT db_superadmin TO luizdroubi;

\connect bronze
CREATE SCHEMA IF NOT EXISTS br AUTHORIZATION labfsg;
CREATE SCHEMA IF NOT EXISTS omi AUTHORIZATION labfsg;
CREATE SCHEMA IF NOT EXISTS cartografia AUTHORIZATION labfsg;
CREATE SCHEMA IF NOT EXISTS estimacao AUTHORIZATION labfsg;
GRANT USAGE, CREATE ON SCHEMA br TO labgis_editor;
GRANT ALL ON SCHEMA br TO labgis_admin;
GRANT USAGE, CREATE ON SCHEMA omi TO omi_admin;
GRANT USAGE ON SCHEMA omi TO omi_editor, omi_viewer;
GRANT USAGE, CREATE ON SCHEMA cartografia TO cartografia_admin;
GRANT USAGE ON SCHEMA cartografia TO cartografia_editor, cartografia_viewer;
GRANT USAGE, CREATE ON SCHEMA estimacao TO estimacao_admin;
GRANT USAGE ON SCHEMA estimacao TO estimacao_editor, estimacao_viewer;

GRANT ALL ON ALL TABLES IN SCHEMA omi TO omi_admin;
GRANT SELECT, INSERT, UPDATE, DELETE, TRUNCATE, REFERENCES, TRIGGER ON ALL TABLES IN SCHEMA omi TO omi_editor;
GRANT SELECT ON ALL TABLES IN SCHEMA omi TO omi_viewer;
GRANT ALL ON ALL SEQUENCES IN SCHEMA omi TO omi_admin;
GRANT USAGE, SELECT, UPDATE ON ALL SEQUENCES IN SCHEMA omi TO omi_editor;

GRANT ALL ON ALL TABLES IN SCHEMA cartografia TO cartografia_admin;
GRANT SELECT, INSERT, UPDATE, DELETE, TRUNCATE, REFERENCES, TRIGGER ON ALL TABLES IN SCHEMA cartografia TO cartografia_editor;
GRANT SELECT ON ALL TABLES IN SCHEMA cartografia TO cartografia_viewer;
GRANT ALL ON ALL SEQUENCES IN SCHEMA cartografia TO cartografia_admin;
GRANT USAGE, SELECT, UPDATE ON ALL SEQUENCES IN SCHEMA cartografia TO cartografia_editor;

GRANT ALL ON ALL TABLES IN SCHEMA estimacao TO estimacao_admin;
GRANT SELECT, INSERT, UPDATE, DELETE, TRUNCATE, REFERENCES, TRIGGER ON ALL TABLES IN SCHEMA estimacao TO estimacao_editor;
GRANT SELECT ON ALL TABLES IN SCHEMA estimacao TO estimacao_viewer;
GRANT ALL ON ALL SEQUENCES IN SCHEMA estimacao TO estimacao_admin;
GRANT USAGE, SELECT, UPDATE ON ALL SEQUENCES IN SCHEMA estimacao TO estimacao_editor;

\connect prata
CREATE SCHEMA IF NOT EXISTS br AUTHORIZATION labfsg;
CREATE SCHEMA IF NOT EXISTS omi AUTHORIZATION labfsg;
CREATE SCHEMA IF NOT EXISTS cartografia AUTHORIZATION labfsg;
CREATE SCHEMA IF NOT EXISTS estimacao AUTHORIZATION labfsg;
GRANT USAGE, CREATE ON SCHEMA br TO labgis_editor;
GRANT ALL ON SCHEMA br TO labgis_admin;
GRANT USAGE, CREATE ON SCHEMA omi TO omi_admin;
GRANT USAGE ON SCHEMA omi TO omi_editor, omi_viewer;
GRANT USAGE, CREATE ON SCHEMA cartografia TO cartografia_admin;
GRANT USAGE ON SCHEMA cartografia TO cartografia_editor, cartografia_viewer;
GRANT USAGE, CREATE ON SCHEMA estimacao TO estimacao_admin;
GRANT USAGE ON SCHEMA estimacao TO estimacao_editor, estimacao_viewer;

GRANT ALL ON ALL TABLES IN SCHEMA omi TO omi_admin;
GRANT SELECT, INSERT, UPDATE, DELETE, TRUNCATE, REFERENCES, TRIGGER ON ALL TABLES IN SCHEMA omi TO omi_editor;
GRANT SELECT ON ALL TABLES IN SCHEMA omi TO omi_viewer;
GRANT ALL ON ALL SEQUENCES IN SCHEMA omi TO omi_admin;
GRANT USAGE, SELECT, UPDATE ON ALL SEQUENCES IN SCHEMA omi TO omi_editor;

GRANT ALL ON ALL TABLES IN SCHEMA cartografia TO cartografia_admin;
GRANT SELECT, INSERT, UPDATE, DELETE, TRUNCATE, REFERENCES, TRIGGER ON ALL TABLES IN SCHEMA cartografia TO cartografia_editor;
GRANT SELECT ON ALL TABLES IN SCHEMA cartografia TO cartografia_viewer;
GRANT ALL ON ALL SEQUENCES IN SCHEMA cartografia TO cartografia_admin;
GRANT USAGE, SELECT, UPDATE ON ALL SEQUENCES IN SCHEMA cartografia TO cartografia_editor;

GRANT ALL ON ALL TABLES IN SCHEMA estimacao TO estimacao_admin;
GRANT SELECT, INSERT, UPDATE, DELETE, TRUNCATE, REFERENCES, TRIGGER ON ALL TABLES IN SCHEMA estimacao TO estimacao_editor;
GRANT SELECT ON ALL TABLES IN SCHEMA estimacao TO estimacao_viewer;
GRANT ALL ON ALL SEQUENCES IN SCHEMA estimacao TO estimacao_admin;
GRANT USAGE, SELECT, UPDATE ON ALL SEQUENCES IN SCHEMA estimacao TO estimacao_editor;

\connect ouro
CREATE SCHEMA IF NOT EXISTS br AUTHORIZATION labfsg;
CREATE SCHEMA IF NOT EXISTS omi AUTHORIZATION labfsg;
CREATE SCHEMA IF NOT EXISTS cartografia AUTHORIZATION labfsg;
CREATE SCHEMA IF NOT EXISTS estimacao AUTHORIZATION labfsg;
GRANT USAGE, CREATE ON SCHEMA br TO labgis_editor;
GRANT ALL ON SCHEMA br TO labgis_admin;
GRANT USAGE, CREATE ON SCHEMA omi TO omi_admin;
GRANT USAGE ON SCHEMA omi TO omi_editor, omi_viewer;
GRANT USAGE, CREATE ON SCHEMA cartografia TO cartografia_admin;
GRANT USAGE ON SCHEMA cartografia TO cartografia_editor, cartografia_viewer;
GRANT USAGE, CREATE ON SCHEMA estimacao TO estimacao_admin;
GRANT USAGE ON SCHEMA estimacao TO estimacao_editor, estimacao_viewer;

GRANT ALL ON ALL TABLES IN SCHEMA omi TO omi_admin;
GRANT SELECT, INSERT, UPDATE, DELETE, TRUNCATE, REFERENCES, TRIGGER ON ALL TABLES IN SCHEMA omi TO omi_editor;
GRANT SELECT ON ALL TABLES IN SCHEMA omi TO omi_viewer;
GRANT ALL ON ALL SEQUENCES IN SCHEMA omi TO omi_admin;
GRANT USAGE, SELECT, UPDATE ON ALL SEQUENCES IN SCHEMA omi TO omi_editor;

GRANT ALL ON ALL TABLES IN SCHEMA cartografia TO cartografia_admin;
GRANT SELECT, INSERT, UPDATE, DELETE, TRUNCATE, REFERENCES, TRIGGER ON ALL TABLES IN SCHEMA cartografia TO cartografia_editor;
GRANT SELECT ON ALL TABLES IN SCHEMA cartografia TO cartografia_viewer;
GRANT ALL ON ALL SEQUENCES IN SCHEMA cartografia TO cartografia_admin;
GRANT USAGE, SELECT, UPDATE ON ALL SEQUENCES IN SCHEMA cartografia TO cartografia_editor;

GRANT ALL ON ALL TABLES IN SCHEMA estimacao TO estimacao_admin;
GRANT SELECT, INSERT, UPDATE, DELETE, TRUNCATE, REFERENCES, TRIGGER ON ALL TABLES IN SCHEMA estimacao TO estimacao_editor;
GRANT SELECT ON ALL TABLES IN SCHEMA estimacao TO estimacao_viewer;
GRANT ALL ON ALL SEQUENCES IN SCHEMA estimacao TO estimacao_admin;
GRANT USAGE, SELECT, UPDATE ON ALL SEQUENCES IN SCHEMA estimacao TO estimacao_editor;

\connect bronze
WITH creators(role_name) AS (
    VALUES
        ('labfsg'),
        ('evertonnubiato'),
        ('felipepilleggi'),
        ('kevinnovak'),
        ('luizdroubi'),
        ('eduardolongo'),
        ('hatanpinheiro')
),
domain_roles(schema_name, admin_role, editor_role, viewer_role) AS (
    VALUES
        ('omi', 'omi_admin', 'omi_editor', 'omi_viewer'),
        ('cartografia', 'cartografia_admin', 'cartografia_editor', 'cartografia_viewer'),
        ('estimacao', 'estimacao_admin', 'estimacao_editor', 'estimacao_viewer')
)
SELECT format('ALTER DEFAULT PRIVILEGES FOR ROLE %I IN SCHEMA br GRANT ALL ON TABLES TO labgis_admin;', role_name)
FROM creators \gexec

WITH creators(role_name) AS (
    VALUES
        ('labfsg'),
        ('evertonnubiato'),
        ('felipepilleggi'),
        ('kevinnovak'),
        ('luizdroubi'),
        ('eduardolongo'),
        ('hatanpinheiro')
)
SELECT format('ALTER DEFAULT PRIVILEGES FOR ROLE %I IN SCHEMA br GRANT SELECT, INSERT, UPDATE, DELETE, TRUNCATE, REFERENCES, TRIGGER ON TABLES TO labgis_editor;', role_name)
FROM creators \gexec

WITH creators(role_name) AS (
    VALUES
        ('labfsg'),
        ('evertonnubiato'),
        ('felipepilleggi'),
        ('kevinnovak'),
        ('luizdroubi'),
        ('eduardolongo'),
        ('hatanpinheiro')
)
SELECT format('ALTER DEFAULT PRIVILEGES FOR ROLE %I IN SCHEMA br GRANT USAGE, SELECT, UPDATE ON SEQUENCES TO labgis_editor;', role_name)
FROM creators \gexec

WITH creators(role_name) AS (
    VALUES
        ('labfsg'),
        ('evertonnubiato'),
        ('felipepilleggi'),
        ('kevinnovak'),
        ('luizdroubi'),
        ('eduardolongo'),
        ('hatanpinheiro')
)
SELECT format('ALTER DEFAULT PRIVILEGES FOR ROLE %I IN SCHEMA br GRANT ALL ON SEQUENCES TO labgis_admin;', role_name)
FROM creators \gexec

WITH creators(role_name) AS (
    VALUES
        ('labfsg'),
        ('evertonnubiato'),
        ('felipepilleggi'),
        ('kevinnovak'),
        ('luizdroubi'),
        ('eduardolongo'),
        ('hatanpinheiro')
),
domain_roles(schema_name, admin_role, editor_role, viewer_role) AS (
    VALUES
        ('omi', 'omi_admin', 'omi_editor', 'omi_viewer'),
        ('cartografia', 'cartografia_admin', 'cartografia_editor', 'cartografia_viewer'),
        ('estimacao', 'estimacao_admin', 'estimacao_editor', 'estimacao_viewer')
)
SELECT format('ALTER DEFAULT PRIVILEGES FOR ROLE %I IN SCHEMA %I GRANT ALL ON TABLES TO %I;', role_name, schema_name, admin_role)
FROM creators CROSS JOIN domain_roles \gexec

WITH creators(role_name) AS (
    VALUES
        ('labfsg'),
        ('evertonnubiato'),
        ('felipepilleggi'),
        ('kevinnovak'),
        ('luizdroubi'),
        ('eduardolongo'),
        ('hatanpinheiro')
),
domain_roles(schema_name, admin_role, editor_role, viewer_role) AS (
    VALUES
        ('omi', 'omi_admin', 'omi_editor', 'omi_viewer'),
        ('cartografia', 'cartografia_admin', 'cartografia_editor', 'cartografia_viewer'),
        ('estimacao', 'estimacao_admin', 'estimacao_editor', 'estimacao_viewer')
)
SELECT format('ALTER DEFAULT PRIVILEGES FOR ROLE %I IN SCHEMA %I GRANT SELECT, INSERT, UPDATE, DELETE, TRUNCATE, REFERENCES, TRIGGER ON TABLES TO %I;', role_name, schema_name, editor_role)
FROM creators CROSS JOIN domain_roles \gexec

WITH creators(role_name) AS (
    VALUES
        ('labfsg'),
        ('evertonnubiato'),
        ('felipepilleggi'),
        ('kevinnovak'),
        ('luizdroubi'),
        ('eduardolongo'),
        ('hatanpinheiro')
),
domain_roles(schema_name, admin_role, editor_role, viewer_role) AS (
    VALUES
        ('omi', 'omi_admin', 'omi_editor', 'omi_viewer'),
        ('cartografia', 'cartografia_admin', 'cartografia_editor', 'cartografia_viewer'),
        ('estimacao', 'estimacao_admin', 'estimacao_editor', 'estimacao_viewer')
)
SELECT format('ALTER DEFAULT PRIVILEGES FOR ROLE %I IN SCHEMA %I GRANT SELECT ON TABLES TO %I;', role_name, schema_name, viewer_role)
FROM creators CROSS JOIN domain_roles \gexec

\connect prata
WITH creators(role_name) AS (
    VALUES
        ('labfsg'),
        ('evertonnubiato'),
        ('felipepilleggi'),
        ('kevinnovak'),
        ('luizdroubi'),
        ('eduardolongo'),
        ('hatanpinheiro')
)
SELECT format('ALTER DEFAULT PRIVILEGES FOR ROLE %I IN SCHEMA br GRANT ALL ON TABLES TO labgis_admin;', role_name)
FROM creators \gexec

WITH creators(role_name) AS (
    VALUES
        ('labfsg'),
        ('evertonnubiato'),
        ('felipepilleggi'),
        ('kevinnovak'),
        ('luizdroubi'),
        ('eduardolongo'),
        ('hatanpinheiro')
)
SELECT format('ALTER DEFAULT PRIVILEGES FOR ROLE %I IN SCHEMA br GRANT SELECT, INSERT, UPDATE, DELETE, TRUNCATE, REFERENCES, TRIGGER ON TABLES TO labgis_editor;', role_name)
FROM creators \gexec

WITH creators(role_name) AS (
    VALUES
        ('labfsg'),
        ('evertonnubiato'),
        ('felipepilleggi'),
        ('kevinnovak'),
        ('luizdroubi'),
        ('eduardolongo'),
        ('hatanpinheiro')
)
SELECT format('ALTER DEFAULT PRIVILEGES FOR ROLE %I IN SCHEMA br GRANT USAGE, SELECT, UPDATE ON SEQUENCES TO labgis_editor;', role_name)
FROM creators \gexec

WITH creators(role_name) AS (
    VALUES
        ('labfsg'),
        ('evertonnubiato'),
        ('felipepilleggi'),
        ('kevinnovak'),
        ('luizdroubi'),
        ('eduardolongo'),
        ('hatanpinheiro')
)
SELECT format('ALTER DEFAULT PRIVILEGES FOR ROLE %I IN SCHEMA br GRANT ALL ON SEQUENCES TO labgis_admin;', role_name)
FROM creators \gexec

WITH creators(role_name) AS (
    VALUES
        ('labfsg'),
        ('evertonnubiato'),
        ('felipepilleggi'),
        ('kevinnovak'),
        ('luizdroubi'),
        ('eduardolongo'),
        ('hatanpinheiro')
),
domain_roles(schema_name, admin_role, editor_role, viewer_role) AS (
    VALUES
        ('omi', 'omi_admin', 'omi_editor', 'omi_viewer'),
        ('cartografia', 'cartografia_admin', 'cartografia_editor', 'cartografia_viewer'),
        ('estimacao', 'estimacao_admin', 'estimacao_editor', 'estimacao_viewer')
)
SELECT format('ALTER DEFAULT PRIVILEGES FOR ROLE %I IN SCHEMA %I GRANT ALL ON TABLES TO %I;', role_name, schema_name, admin_role)
FROM creators CROSS JOIN domain_roles \gexec

WITH creators(role_name) AS (
    VALUES
        ('labfsg'),
        ('evertonnubiato'),
        ('felipepilleggi'),
        ('kevinnovak'),
        ('luizdroubi'),
        ('eduardolongo'),
        ('hatanpinheiro')
),
domain_roles(schema_name, admin_role, editor_role, viewer_role) AS (
    VALUES
        ('omi', 'omi_admin', 'omi_editor', 'omi_viewer'),
        ('cartografia', 'cartografia_admin', 'cartografia_editor', 'cartografia_viewer'),
        ('estimacao', 'estimacao_admin', 'estimacao_editor', 'estimacao_viewer')
)
SELECT format('ALTER DEFAULT PRIVILEGES FOR ROLE %I IN SCHEMA %I GRANT SELECT, INSERT, UPDATE, DELETE, TRUNCATE, REFERENCES, TRIGGER ON TABLES TO %I;', role_name, schema_name, editor_role)
FROM creators CROSS JOIN domain_roles \gexec

WITH creators(role_name) AS (
    VALUES
        ('labfsg'),
        ('evertonnubiato'),
        ('felipepilleggi'),
        ('kevinnovak'),
        ('luizdroubi'),
        ('eduardolongo'),
        ('hatanpinheiro')
),
domain_roles(schema_name, admin_role, editor_role, viewer_role) AS (
    VALUES
        ('omi', 'omi_admin', 'omi_editor', 'omi_viewer'),
        ('cartografia', 'cartografia_admin', 'cartografia_editor', 'cartografia_viewer'),
        ('estimacao', 'estimacao_admin', 'estimacao_editor', 'estimacao_viewer')
)
SELECT format('ALTER DEFAULT PRIVILEGES FOR ROLE %I IN SCHEMA %I GRANT SELECT ON TABLES TO %I;', role_name, schema_name, viewer_role)
FROM creators CROSS JOIN domain_roles \gexec

\connect ouro
WITH creators(role_name) AS (
    VALUES
        ('labfsg'),
        ('evertonnubiato'),
        ('felipepilleggi'),
        ('kevinnovak'),
        ('luizdroubi'),
        ('eduardolongo'),
        ('hatanpinheiro')
)
SELECT format('ALTER DEFAULT PRIVILEGES FOR ROLE %I IN SCHEMA br GRANT ALL ON TABLES TO labgis_admin;', role_name)
FROM creators \gexec

WITH creators(role_name) AS (
    VALUES
        ('labfsg'),
        ('evertonnubiato'),
        ('felipepilleggi'),
        ('kevinnovak'),
        ('luizdroubi'),
        ('eduardolongo'),
        ('hatanpinheiro')
)
SELECT format('ALTER DEFAULT PRIVILEGES FOR ROLE %I IN SCHEMA br GRANT SELECT, INSERT, UPDATE, DELETE, TRUNCATE, REFERENCES, TRIGGER ON TABLES TO labgis_editor;', role_name)
FROM creators \gexec

WITH creators(role_name) AS (
    VALUES
        ('labfsg'),
        ('evertonnubiato'),
        ('felipepilleggi'),
        ('kevinnovak'),
        ('luizdroubi'),
        ('eduardolongo'),
        ('hatanpinheiro')
)
SELECT format('ALTER DEFAULT PRIVILEGES FOR ROLE %I IN SCHEMA br GRANT USAGE, SELECT, UPDATE ON SEQUENCES TO labgis_editor;', role_name)
FROM creators \gexec

WITH creators(role_name) AS (
    VALUES
        ('labfsg'),
        ('evertonnubiato'),
        ('felipepilleggi'),
        ('kevinnovak'),
        ('luizdroubi'),
        ('eduardolongo'),
        ('hatanpinheiro')
)
SELECT format('ALTER DEFAULT PRIVILEGES FOR ROLE %I IN SCHEMA br GRANT ALL ON SEQUENCES TO labgis_admin;', role_name)
FROM creators \gexec

WITH creators(role_name) AS (
    VALUES
        ('labfsg'),
        ('evertonnubiato'),
        ('felipepilleggi'),
        ('kevinnovak'),
        ('luizdroubi'),
        ('eduardolongo'),
        ('hatanpinheiro')
),
domain_roles(schema_name, admin_role, editor_role, viewer_role) AS (
    VALUES
        ('omi', 'omi_admin', 'omi_editor', 'omi_viewer'),
        ('cartografia', 'cartografia_admin', 'cartografia_editor', 'cartografia_viewer'),
        ('estimacao', 'estimacao_admin', 'estimacao_editor', 'estimacao_viewer')
)
SELECT format('ALTER DEFAULT PRIVILEGES FOR ROLE %I IN SCHEMA %I GRANT ALL ON TABLES TO %I;', role_name, schema_name, admin_role)
FROM creators CROSS JOIN domain_roles \gexec

WITH creators(role_name) AS (
    VALUES
        ('labfsg'),
        ('evertonnubiato'),
        ('felipepilleggi'),
        ('kevinnovak'),
        ('luizdroubi'),
        ('eduardolongo'),
        ('hatanpinheiro')
),
domain_roles(schema_name, admin_role, editor_role, viewer_role) AS (
    VALUES
        ('omi', 'omi_admin', 'omi_editor', 'omi_viewer'),
        ('cartografia', 'cartografia_admin', 'cartografia_editor', 'cartografia_viewer'),
        ('estimacao', 'estimacao_admin', 'estimacao_editor', 'estimacao_viewer')
)
SELECT format('ALTER DEFAULT PRIVILEGES FOR ROLE %I IN SCHEMA %I GRANT SELECT, INSERT, UPDATE, DELETE, TRUNCATE, REFERENCES, TRIGGER ON TABLES TO %I;', role_name, schema_name, editor_role)
FROM creators CROSS JOIN domain_roles \gexec

WITH creators(role_name) AS (
    VALUES
        ('labfsg'),
        ('evertonnubiato'),
        ('felipepilleggi'),
        ('kevinnovak'),
        ('luizdroubi'),
        ('eduardolongo'),
        ('hatanpinheiro')
),
domain_roles(schema_name, admin_role, editor_role, viewer_role) AS (
    VALUES
        ('omi', 'omi_admin', 'omi_editor', 'omi_viewer'),
        ('cartografia', 'cartografia_admin', 'cartografia_editor', 'cartografia_viewer'),
        ('estimacao', 'estimacao_admin', 'estimacao_editor', 'estimacao_viewer')
)
SELECT format('ALTER DEFAULT PRIVILEGES FOR ROLE %I IN SCHEMA %I GRANT SELECT ON TABLES TO %I;', role_name, schema_name, viewer_role)
FROM creators CROSS JOIN domain_roles \gexec

WITH creators(role_name) AS (
    VALUES
        ('labfsg'),
        ('evertonnubiato'),
        ('felipepilleggi'),
        ('kevinnovak'),
        ('eduardolongo'),
        ('hatanpinheiro'),
        ('alexgabriel'),
        ('alicebranco'),
        ('franciscosa'),
        ('joaodestro'),
        ('kariniestercio'),
        ('nataliaborges'),
        ('vilemalm'),
        ('waldemarfilho'),
        ('yasmimfontana')
),
target_schemas(schema_name) AS (
    VALUES
        ('public'),
        ('ac'),
        ('al'),
        ('ap'),
        ('am'),
        ('ba'),
        ('ce'),
        ('df'),
        ('es'),
        ('go'),
        ('ma'),
        ('mt'),
        ('ms'),
        ('mg'),
        ('pa'),
        ('pb'),
        ('pr'),
        ('pe'),
        ('pi'),
        ('rj'),
        ('rn'),
        ('rs'),
        ('ro'),
        ('rr'),
        ('sc'),
        ('sp'),
        ('se'),
        ('to')
)
SELECT format(
    'ALTER DEFAULT PRIVILEGES FOR ROLE %I IN SCHEMA %I GRANT SELECT, INSERT, UPDATE, DELETE, TRUNCATE, REFERENCES, TRIGGER ON TABLES TO labgis_editor;',
    role_name,
    schema_name
)
FROM creators
CROSS JOIN target_schemas \gexec

WITH creators(role_name) AS (
    VALUES
        ('labfsg'),
        ('evertonnubiato'),
        ('felipepilleggi'),
        ('kevinnovak'),
        ('eduardolongo'),
        ('hatanpinheiro'),
        ('alexgabriel'),
        ('alicebranco'),
        ('franciscosa'),
        ('joaodestro'),
        ('kariniestercio'),
        ('nataliaborges'),
        ('vilemalm'),
        ('waldemarfilho'),
        ('yasmimfontana')
),
target_schemas(schema_name) AS (
    VALUES
        ('public'),
        ('ac'),
        ('al'),
        ('ap'),
        ('am'),
        ('ba'),
        ('ce'),
        ('df'),
        ('es'),
        ('go'),
        ('ma'),
        ('mt'),
        ('ms'),
        ('mg'),
        ('pa'),
        ('pb'),
        ('pr'),
        ('pe'),
        ('pi'),
        ('rj'),
        ('rn'),
        ('rs'),
        ('ro'),
        ('rr'),
        ('sc'),
        ('sp'),
        ('se'),
        ('to')
)
SELECT format(
    'ALTER DEFAULT PRIVILEGES FOR ROLE %I IN SCHEMA %I GRANT USAGE, SELECT, UPDATE ON SEQUENCES TO labgis_editor;',
    role_name,
    schema_name
)
FROM creators
CROSS JOIN target_schemas \gexec

WITH creators(role_name) AS (
    VALUES
        ('labfsg'),
        ('evertonnubiato'),
        ('felipepilleggi'),
        ('kevinnovak'),
        ('eduardolongo'),
        ('hatanpinheiro'),
        ('alexgabriel'),
        ('alicebranco'),
        ('franciscosa'),
        ('joaodestro'),
        ('kariniestercio'),
        ('nataliaborges'),
        ('vilemalm'),
        ('waldemarfilho'),
        ('yasmimfontana')
),
target_schemas(schema_name) AS (
    VALUES
        ('public'),
        ('ac'),
        ('al'),
        ('ap'),
        ('am'),
        ('ba'),
        ('ce'),
        ('df'),
        ('es'),
        ('go'),
        ('ma'),
        ('mt'),
        ('ms'),
        ('mg'),
        ('pa'),
        ('pb'),
        ('pr'),
        ('pe'),
        ('pi'),
        ('rj'),
        ('rn'),
        ('rs'),
        ('ro'),
        ('rr'),
        ('sc'),
        ('sp'),
        ('se'),
        ('to')
)
SELECT format(
    'ALTER DEFAULT PRIVILEGES FOR ROLE %I IN SCHEMA %I GRANT ALL ON SEQUENCES TO labgis_admin;',
    role_name,
    schema_name
)
FROM creators
CROSS JOIN target_schemas \gexec

\connect prata
WITH creators(role_name) AS (
    VALUES
        ('labfsg'),
        ('evertonnubiato'),
        ('felipepilleggi'),
        ('kevinnovak'),
        ('eduardolongo'),
        ('hatanpinheiro'),
        ('alexgabriel'),
        ('alicebranco'),
        ('franciscosa'),
        ('joaodestro'),
        ('kariniestercio'),
        ('nataliaborges'),
        ('vilemalm'),
        ('waldemarfilho'),
        ('yasmimfontana')
),
target_schemas(schema_name) AS (
    VALUES
        ('public'),
        ('ac'),
        ('al'),
        ('ap'),
        ('am'),
        ('ba'),
        ('ce'),
        ('df'),
        ('es'),
        ('go'),
        ('ma'),
        ('mt'),
        ('ms'),
        ('mg'),
        ('pa'),
        ('pb'),
        ('pr'),
        ('pe'),
        ('pi'),
        ('rj'),
        ('rn'),
        ('rs'),
        ('ro'),
        ('rr'),
        ('sc'),
        ('sp'),
        ('se'),
        ('to')
)
SELECT format(
    'ALTER DEFAULT PRIVILEGES FOR ROLE %I IN SCHEMA %I GRANT ALL ON TABLES TO labgis_admin;',
    role_name,
    schema_name
)
FROM creators
CROSS JOIN target_schemas \gexec

WITH creators(role_name) AS (
    VALUES
        ('labfsg'),
        ('evertonnubiato'),
        ('felipepilleggi'),
        ('kevinnovak'),
        ('eduardolongo'),
        ('hatanpinheiro'),
        ('alexgabriel'),
        ('alicebranco'),
        ('franciscosa'),
        ('joaodestro'),
        ('kariniestercio'),
        ('nataliaborges'),
        ('vilemalm'),
        ('waldemarfilho'),
        ('yasmimfontana')
),
target_schemas(schema_name) AS (
    VALUES
        ('public'),
        ('ac'),
        ('al'),
        ('ap'),
        ('am'),
        ('ba'),
        ('ce'),
        ('df'),
        ('es'),
        ('go'),
        ('ma'),
        ('mt'),
        ('ms'),
        ('mg'),
        ('pa'),
        ('pb'),
        ('pr'),
        ('pe'),
        ('pi'),
        ('rj'),
        ('rn'),
        ('rs'),
        ('ro'),
        ('rr'),
        ('sc'),
        ('sp'),
        ('se'),
        ('to')
)
SELECT format(
    'ALTER DEFAULT PRIVILEGES FOR ROLE %I IN SCHEMA %I GRANT SELECT, INSERT, UPDATE, DELETE, TRUNCATE, REFERENCES, TRIGGER ON TABLES TO labgis_editor;',
    role_name,
    schema_name
)
FROM creators
CROSS JOIN target_schemas \gexec

WITH creators(role_name) AS (
    VALUES
        ('labfsg'),
        ('evertonnubiato'),
        ('felipepilleggi'),
        ('kevinnovak'),
        ('eduardolongo'),
        ('hatanpinheiro'),
        ('alexgabriel'),
        ('alicebranco'),
        ('franciscosa'),
        ('joaodestro'),
        ('kariniestercio'),
        ('nataliaborges'),
        ('vilemalm'),
        ('waldemarfilho'),
        ('yasmimfontana')
),
target_schemas(schema_name) AS (
    VALUES
        ('public'),
        ('ac'),
        ('al'),
        ('ap'),
        ('am'),
        ('ba'),
        ('ce'),
        ('df'),
        ('es'),
        ('go'),
        ('ma'),
        ('mt'),
        ('ms'),
        ('mg'),
        ('pa'),
        ('pb'),
        ('pr'),
        ('pe'),
        ('pi'),
        ('rj'),
        ('rn'),
        ('rs'),
        ('ro'),
        ('rr'),
        ('sc'),
        ('sp'),
        ('se'),
        ('to')
)
SELECT format(
    'ALTER DEFAULT PRIVILEGES FOR ROLE %I IN SCHEMA %I GRANT USAGE, SELECT, UPDATE ON SEQUENCES TO labgis_editor;',
    role_name,
    schema_name
)
FROM creators
CROSS JOIN target_schemas \gexec

WITH creators(role_name) AS (
    VALUES
        ('labfsg'),
        ('evertonnubiato'),
        ('felipepilleggi'),
        ('kevinnovak'),
        ('eduardolongo'),
        ('hatanpinheiro'),
        ('alexgabriel'),
        ('alicebranco'),
        ('franciscosa'),
        ('joaodestro'),
        ('kariniestercio'),
        ('nataliaborges'),
        ('vilemalm'),
        ('waldemarfilho'),
        ('yasmimfontana')
),
target_schemas(schema_name) AS (
    VALUES
        ('public'),
        ('ac'),
        ('al'),
        ('ap'),
        ('am'),
        ('ba'),
        ('ce'),
        ('df'),
        ('es'),
        ('go'),
        ('ma'),
        ('mt'),
        ('ms'),
        ('mg'),
        ('pa'),
        ('pb'),
        ('pr'),
        ('pe'),
        ('pi'),
        ('rj'),
        ('rn'),
        ('rs'),
        ('ro'),
        ('rr'),
        ('sc'),
        ('sp'),
        ('se'),
        ('to')
)
SELECT format(
    'ALTER DEFAULT PRIVILEGES FOR ROLE %I IN SCHEMA %I GRANT ALL ON SEQUENCES TO labgis_admin;',
    role_name,
    schema_name
)
FROM creators
CROSS JOIN target_schemas \gexec

\connect ouro
WITH creators(role_name) AS (
    VALUES
        ('labfsg'),
        ('evertonnubiato'),
        ('felipepilleggi'),
        ('kevinnovak'),
        ('eduardolongo'),
        ('hatanpinheiro'),
        ('alexgabriel'),
        ('alicebranco'),
        ('franciscosa'),
        ('joaodestro'),
        ('kariniestercio'),
        ('nataliaborges'),
        ('vilemalm'),
        ('waldemarfilho'),
        ('yasmimfontana')
),
target_schemas(schema_name) AS (
    VALUES
        ('public'),
        ('ac'),
        ('al'),
        ('ap'),
        ('am'),
        ('ba'),
        ('ce'),
        ('df'),
        ('es'),
        ('go'),
        ('ma'),
        ('mt'),
        ('ms'),
        ('mg'),
        ('pa'),
        ('pb'),
        ('pr'),
        ('pe'),
        ('pi'),
        ('rj'),
        ('rn'),
        ('rs'),
        ('ro'),
        ('rr'),
        ('sc'),
        ('sp'),
        ('se'),
        ('to')
)
SELECT format(
    'ALTER DEFAULT PRIVILEGES FOR ROLE %I IN SCHEMA %I GRANT ALL ON TABLES TO labgis_admin;',
    role_name,
    schema_name
)
FROM creators
CROSS JOIN target_schemas \gexec

WITH creators(role_name) AS (
    VALUES
        ('labfsg'),
        ('evertonnubiato'),
        ('felipepilleggi'),
        ('kevinnovak'),
        ('eduardolongo'),
        ('hatanpinheiro'),
        ('alexgabriel'),
        ('alicebranco'),
        ('franciscosa'),
        ('joaodestro'),
        ('kariniestercio'),
        ('nataliaborges'),
        ('vilemalm'),
        ('waldemarfilho'),
        ('yasmimfontana')
),
target_schemas(schema_name) AS (
    VALUES
        ('public'),
        ('ac'),
        ('al'),
        ('ap'),
        ('am'),
        ('ba'),
        ('ce'),
        ('df'),
        ('es'),
        ('go'),
        ('ma'),
        ('mt'),
        ('ms'),
        ('mg'),
        ('pa'),
        ('pb'),
        ('pr'),
        ('pe'),
        ('pi'),
        ('rj'),
        ('rn'),
        ('rs'),
        ('ro'),
        ('rr'),
        ('sc'),
        ('sp'),
        ('se'),
        ('to')
)
SELECT format(
    'ALTER DEFAULT PRIVILEGES FOR ROLE %I IN SCHEMA %I GRANT SELECT, INSERT, UPDATE, DELETE, TRUNCATE, REFERENCES, TRIGGER ON TABLES TO labgis_editor;',
    role_name,
    schema_name
)
FROM creators
CROSS JOIN target_schemas \gexec

WITH creators(role_name) AS (
    VALUES
        ('labfsg'),
        ('evertonnubiato'),
        ('felipepilleggi'),
        ('kevinnovak'),
        ('eduardolongo'),
        ('hatanpinheiro'),
        ('alexgabriel'),
        ('alicebranco'),
        ('franciscosa'),
        ('joaodestro'),
        ('kariniestercio'),
        ('nataliaborges'),
        ('vilemalm'),
        ('waldemarfilho'),
        ('yasmimfontana')
),
target_schemas(schema_name) AS (
    VALUES
        ('public'),
        ('ac'),
        ('al'),
        ('ap'),
        ('am'),
        ('ba'),
        ('ce'),
        ('df'),
        ('es'),
        ('go'),
        ('ma'),
        ('mt'),
        ('ms'),
        ('mg'),
        ('pa'),
        ('pb'),
        ('pr'),
        ('pe'),
        ('pi'),
        ('rj'),
        ('rn'),
        ('rs'),
        ('ro'),
        ('rr'),
        ('sc'),
        ('sp'),
        ('se'),
        ('to')
)
SELECT format(
    'ALTER DEFAULT PRIVILEGES FOR ROLE %I IN SCHEMA %I GRANT USAGE, SELECT, UPDATE ON SEQUENCES TO labgis_editor;',
    role_name,
    schema_name
)
FROM creators
CROSS JOIN target_schemas \gexec

WITH creators(role_name) AS (
    VALUES
        ('labfsg'),
        ('evertonnubiato'),
        ('felipepilleggi'),
        ('kevinnovak'),
        ('eduardolongo'),
        ('hatanpinheiro'),
        ('alexgabriel'),
        ('alicebranco'),
        ('franciscosa'),
        ('joaodestro'),
        ('kariniestercio'),
        ('nataliaborges'),
        ('vilemalm'),
        ('waldemarfilho'),
        ('yasmimfontana')
),
target_schemas(schema_name) AS (
    VALUES
        ('public'),
        ('ac'),
        ('al'),
        ('ap'),
        ('am'),
        ('ba'),
        ('ce'),
        ('df'),
        ('es'),
        ('go'),
        ('ma'),
        ('mt'),
        ('ms'),
        ('mg'),
        ('pa'),
        ('pb'),
        ('pr'),
        ('pe'),
        ('pi'),
        ('rj'),
        ('rn'),
        ('rs'),
        ('ro'),
        ('rr'),
        ('sc'),
        ('sp'),
        ('se'),
        ('to')
)
SELECT format(
    'ALTER DEFAULT PRIVILEGES FOR ROLE %I IN SCHEMA %I GRANT ALL ON SEQUENCES TO labgis_admin;',
    role_name,
    schema_name
)
FROM creators
CROSS JOIN target_schemas \gexec
