-- Remove os schemas tematicos apos migrar para o modelo por UF.
-- Mantem os grupos/roles tematicos, mas remove os schemas:
--   omi, cartografia, estimacao
--
-- IMPORTANTE:
-- 1. Este script apaga os schemas em bronze, prata e ouro.
-- 2. Ele usa CASCADE, entao tambem apaga tabelas, views, sequences e
--    quaisquer outros objetos dentro desses schemas.
-- 3. Rode somente se tiver certeza de que nao ha dados a preservar nesses schemas.
--
-- Execucao recomendada:
--   sudo -u postgres psql -v ON_ERROR_STOP=1 -f sql/01_remove_schemas_tematicos.sql

\set ON_ERROR_STOP on

\connect bronze
DROP SCHEMA IF EXISTS omi CASCADE;
DROP SCHEMA IF EXISTS cartografia CASCADE;
DROP SCHEMA IF EXISTS estimacao CASCADE;

\connect prata
DROP SCHEMA IF EXISTS omi CASCADE;
DROP SCHEMA IF EXISTS cartografia CASCADE;
DROP SCHEMA IF EXISTS estimacao CASCADE;

\connect ouro
DROP SCHEMA IF EXISTS omi CASCADE;
DROP SCHEMA IF EXISTS cartografia CASCADE;
DROP SCHEMA IF EXISTS estimacao CASCADE;

-- Validacao rapida
\connect bronze
SELECT schema_name
FROM information_schema.schemata
WHERE schema_name IN ('omi', 'cartografia', 'estimacao')
ORDER BY schema_name;

\connect prata
SELECT schema_name
FROM information_schema.schemata
WHERE schema_name IN ('omi', 'cartografia', 'estimacao')
ORDER BY schema_name;

\connect ouro
SELECT schema_name
FROM information_schema.schemata
WHERE schema_name IN ('omi', 'cartografia', 'estimacao')
ORDER BY schema_name;
