BEGIN;
SELECT plan(1);

SELECT has_table('main'::name, 'contacts'::name);
DELETE FROM main.contacts;

INSERT INTO main.contacts (name) VALUES('John Doe');
INSERT INTO main.contacts (name) VALUES('Alice Doe');
INSERT INTO main.contacts (name) VALUES('Bob Doe');

-- SELECT row_to_json(t) FROM (SELECT name, id FROM main.contacts) AS t;

--SELECT utils.ascii_table(
--    (SELECT ARRAY_AGG(ROW_TO_JSON(contacts)) FROM main.contacts)
--);
--SELECT utils.ascii_table2(
--    (SELECT ARRAY_AGG(contacts) FROM main.contacts)
--);
SELECT utils.ascii_table3(
    'SELECT * FROM main.contacts'
);

SELECT * FROM finish();
ROLLBACK;
