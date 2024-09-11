SELECT COUNT(*) FROM payment WHERE customer_id = 100;


SELECT last_name FROM customer WHERE first_name = 'ERICA';


-- single join
SELECT customer.first_name, payment.amount, payment.payment_date
FROM payment
INNER JOIN customer
ON payment.customer_id = customer.customer_id
WHERE payment.amount > 10;


-- multiple join
SELECT customer.first_name, rental.rental_date, payment.amount, payment.payment_date
FROM payment
INNER JOIN customer
ON payment.customer_id = customer.customer_id
INNER JOIN rental
ON payment.customer_id = rental.customer_id
WHERE payment.amount > 10;


SELECT COUNT(*) FROM rental WHERE return_date IS null;


SELECT payment_id, amount FROM payment WHERE amount <= 2;


SELECT * FROM payment WHERE customer_id = 426 AND amount = 10.99;


SELECT * FROM payment WHERE customer_id = 426 
AND (amount = 10.99 OR amount = 9.99);


-- this is different from the above
SELECT * FROM payment WHERE customer_id = 426 
AND amount = 10.99 OR amount = 9.99;


SELECT * FROM payment 
WHERE customer_id IN (322, 346, 354)
-- WHERE (customer_id = 322 OR customer_id = 346 OR customer_id = 354) 
AND (amount < 2 OR amount > 10)
ORDER BY customer_id ASC, amount DESC;


SELECT * FROM payment
-- WHERE payment_id >= 17000 AND payment_id <= 18000
WHERE payment_id BETWEEN 17000 AND 18000;


SELECT * FROM rental 
WHERE rental_date BETWEEN '2005-08-01' AND '2005-08-02'
ORDER BY rental_date DESC;


SELECT * FROM rental 
WHERE rental_date BETWEEN '2005-08-01' AND '2005-08-02 23:59'
ORDER BY rental_date DESC;


SELECT COUNT(*) FROM payment
WHERE 
(payment_date BETWEEN '2020-01-26' AND '2020-01-27 23:59')
AND
(amount BETWEEN 1.99 AND 3.99);


SELECT * FROM customer WHERE customer_id IN (123,212,323,243,353,432);


SELECT * FROM payment
WHERE customer_id IN (12, 25, 67, 93, 124, 234)
AND amount IN (4.99, 7.99, 9.99)
-- all payment in January
-- AND payment_date BETWEEN '2020-01-01' AND '2020-01-31 23:59'
AND payment_date BETWEEN '2020-01-01' AND '2020-02-01';


-- LIKE vs ILIKE // wildcards _ AND %
-- LIKE is case-sensitive in PostgreSQL, not in SQLite
-- ILIKE is only available in PostgreSQL
SELECT * FROM film
-- WHERE description LIKE '%Drama%'
-- AND title LIKE '_LI%';
WHERE description ILIKE '%draMa%'
AND title ILIKE '_lI%';


SELECT  COUNT(*) FROM film
WHERE description ILIKE '%Documentary%';


-- 3 letter first_name, X or Y ends last_name
SELECT COUNT(*) FROM customer
WHERE first_name LIKE '___'
AND (last_name ILIKE '%X' OR last_name ILIKE '%Y');


-- alias
SELECT COUNT(*) AS num_of_customers FROM customer;


SELECT COUNT(*) AS no_of_movies 
FROM film
WHERE description ILIKE '%Saga%'
AND (title ILIKE 'A%' OR title ILIKE '%R');


-- first_name contains ER and has A as second letter
SELECT * FROM customer
WHERE (first_name ILIKE '%er%' AND first_name ILIKE '_A%')
ORDER BY last_name DESC;


--payment on 2020-05-01 with amount 0 or between 3.99/7.99
SELECT COUNT(*) FROM payment
WHERE amount = 0 OR (amount BETWEEN 3.99 AND 7.99)
AND (payment_date BETWEEN '2020-05-01' AND '2020-05-02')