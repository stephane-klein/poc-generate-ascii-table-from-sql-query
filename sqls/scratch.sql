DELETE FROM main.contacts;

INSERT INTO main.contacts (name) VALUES('John Doe');
INSERT INTO main.contacts (name) VALUES('Alice Doe');
INSERT INTO main.contacts (name) VALUES('Bob Doe');

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
    columns;
