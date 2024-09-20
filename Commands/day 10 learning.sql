-- MANAGING DATABASE --


-- GREENCYCLE DATABASE


-- change all film rental price of 0.99 to 1.99
UPDATE film
SET rental_rate = 1.99
WHERE rental_rate = 0.99;  --without a where clause; every row gets updated


-- add new column initials and poplate it with customer initial
ALTER TABLE customer
ADD COLUMN IF NOT EXISTS initials VARCHAR(4);
-- 
UPDATE customer
SET initials = LEFT(first_name, 1) || '.' || LEFT(last_name, 1) || '.';


-- DELETE
DELETE FROM payment 
WHERE payment_id IN (17064, 17067)
RETURNING *;


-- CREATE TABLE FROM THE RESULT OF A QUERY
CREATE TABLE IF NOT EXISTS customer_mini AS
SELECT 
initcap(first_name||' '||last_name) AS full_name, 
lower(email) AS email, 
address_id
FROM customer
WHERE last_name ILIKE '%Ha%';
-- delete the data inserted
DELETE FROM customer_mini
RETURNING *;
-- delete customer_test table
DROP TABLE IF EXISTS customer_test;
/* NOTE: 
the resulting table is static, will not update as info in 
the customer table changes and this makes it innapropriate when 
dynamic result is desired. VIEW solves this issue as seen below */


-- VIEW
CREATE OR REPLACE VIEW customer_spendings AS  -- (or replace) is just so I can run whole file at once
SELECT 
initcap(first_name||' '||last_name) AS full_name, 
SUM(amount) AS total_spend
FROM customer AS ct
LEFT JOIN payment AS pt ON ct.customer_id = pt.customer_id
GROUP BY full_name;
-- 
SELECT * FROM customer_spendings;
-- 
ALTER VIEW customer_spendings RENAME TO v_customer_spendings;
-- 
ALTER VIEW v_customer_spendings RENAME COLUMN total_spend TO total_spending;
-- 
SELECT * FROM v_customer_spendings;
-- 
DROP VIEW IF EXISTS v_customer_spendings;
/* NOTE: 
the simple VIEW function, while it ensures dynamic result,  */


-- MATERIALIZED VIEW
CREATE MATERIALIZED VIEW IF NOT EXISTS films_category
AS
SELECT title, ct.name AS film_name, f.length AS film_length
FROM film f
LEFT JOIN film_category fc ON f.film_id = fc.film_id
LEFT JOIN category ct ON ct.category_id = fc.category_id
WHERE name IN ('Action','Comedy')
ORDER BY f.length DESC;
-- 
SELECT * FROM films_category;
-- 
-- update film table
UPDATE film
SET length = 192
WHERE title = 'SATURN NAME';
-- 
-- refresh materialized view to incorporate film table update
REFRESH MATERIALIZED VIEW films_category;


-- IMPORTS & EXPORT DATA
CREATE TABLE IF NOT EXISTS sales (
	transaction_id SERIAL PRIMARY KEY,
	customer_id INT,
	payment_type VARCHAR(20),
	carditcard_no VARCHAR(30),
	cost NUMERIC(5, 2),
	quantity INT,
	price NUMERIC(5, 2)
);
-- 
SELECT * FROM sales;