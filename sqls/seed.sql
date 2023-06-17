SET client_min_messages TO WARNING;

\echo "Database cleaning..."

DROP SCHEMA IF EXISTS public CASCADE;
DROP SCHEMA IF EXISTS main CASCADE;

\echo "Database cleaned"

CREATE SCHEMA IF NOT EXISTS utils;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA utils;

\echo "'main' schema creating..."
CREATE SCHEMA IF NOT EXISTS main;

CREATE TABLE main.contacts (
    id       UUID PRIMARY KEY DEFAULT utils.uuid_generate_v4(),
    name     VARCHAR NOT NULL
);

DROP FUNCTION IF EXISTS utils.ascii_table;
CREATE FUNCTION utils.ascii_table(
    _input JSON[]
) RETURNS TEXT AS $$
BEGIN
    RAISE NOTICE 'aa = %', _input;
    RETURN 'foobar';
END;
$$ LANGUAGE PLPGSQL SECURITY DEFINER;

DROP FUNCTION IF EXISTS utils.ascii_table2;
CREATE FUNCTION utils.ascii_table2(
    _input ANYARRAY
) RETURNS TEXT AS $$
BEGIN
    RAISE NOTICE 'bb = %', _input;
    RETURN 'foobar';
END;
$$ LANGUAGE PLPGSQL SECURITY DEFINER;

DROP FUNCTION IF EXISTS utils.ascii_table3;
CREATE FUNCTION utils.ascii_table3(
    _query TEXT
) RETURNS TEXT AS $$
DECLARE
    _foo TEXT[];
BEGIN
    EXECUTE (
        WITH columns AS (
            SELECT
                JSON_OBJECT_KEYS(
                    (
                        SELECT
                            ROW_TO_JSON(c)
                        FROM
                            main.contacts AS c
                        LIMIT 1
                    )
                ) AS column
        )
        SELECT
            FORMAT(
                $query$
                SELECT ARRAY_AGG(c) FROM (
                    SELECT %s FROM main.contacts
                ) AS c
                $query$,
                STRING_AGG(
                    FORMAT(
                        'MAX(CHAR_LENGTH(%I::VARCHAR))',
                        columns.column
                    ),
                    ', '
                )
            )
        FROM
            columns
        LIMIT 1
    ) INTO _foo;
    RAISE NOTICE 'cc = %', _foo;
    RETURN 'foobar';
END;
$$ LANGUAGE PLPGSQL SECURITY DEFINER;

\echo "'main' schema created"
