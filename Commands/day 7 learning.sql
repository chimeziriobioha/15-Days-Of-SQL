-- UNION & UNION ALL --

-- GREENCYCLE DATABASE --


-- union filters out duplicates
SELECT first_name FROM actor
UNION
SELECT first_name FROM customer
ORDER BY 1 ASC;


-- union all allows duplicates
SELECT first_name FROM actor
UNION ALL
SELECT first_name FROM customer
ORDER BY 1 ASC;


-- multiple columns makes duplicates in one column irrelevant in UNION
SELECT 'actor' as origin, first_name, actor_id FROM actor
UNION
SELECT 'customer', first_name, customer_id FROM customer
UNION
SELECT 'staff', first_name, staff_id FROM staff
ORDER BY 2 ASC;


-- above query with union all delivers same result
SELECT 'actor' as origin, first_name, actor_id FROM actor
UNION ALL
SELECT 'customer', first_name, customer_id FROM customer
UNION ALL
SELECT 'staff', first_name, staff_id FROM staff
ORDER BY 2 ASC;


-- SUBQUERIES --

-- all payment with amount above AVG(amount)
SELECT *
FROM payment
WHERE amount > (
	SELECT AVG(amount) 
	FROM payment
);


-- all payment by customer with ADAM as first_name
SELECT *
FROM payment
WHERE customer_id = (
	SELECT customer_id
	FROM customer
	WHERE first_name = 'ADAM'
);


-- all payment by customers without "A" in their
-- first_name but with "A" in their last_name
-- and the customer id is above 400
SELECT *
FROM payment
WHERE customer_id IN (
	SELECT customer_id
	FROM customer
	WHERE first_name NOT ILIKE '%A%'
	AND last_name ILIKE '%A%'
	AND customer_id > 400
);

-- return all films that are available 
-- in store 2 more than 3 times
-------------------------------
-- cleaner and faster solution
SELECT film_id, title 
FROM film
WHERE film_id IN (
	SELECT film_id
	FROM inventory
	WHERE store_id = 2
	GROUP BY film_id
	HAVING COUNT(film_id) > 3
);
-- OR --
-- my first solution before coming by the HAVING clause --
-- more complex, tedious, and slower but teaches more
SELECT film.film_id, title 
FROM film
INNER JOIN inventory ON film.film_id = inventory.film_id
INNER JOIN (
	SELECT film_id AS sub_film_id, COUNT(*) AS film_counter
	FROM inventory
	WHERE store_id = 2
	GROUP BY sub_film_id
) AS subq ON film.film_id = subq.sub_film_id AND subq.film_counter > 3
GROUP BY film.film_id
ORDER BY film.film_id ASC;


-- return first and last names of all customers
-- who made a payment on '2020-01-25'
SELECT first_name, last_name
FROM customer
WHERE customer_id IN (
	SELECT customer_id
	FROM payment
	WHERE DATE(payment_date) = '2020-01-25'
);


-- return first_name and emails of all customers
-- who have spent more than $30
SELECT first_name, email
FROM customer
WHERE customer_id IN (
	SELECT customer_id
	FROM payment
	GROUP BY customer_id
	HAVING SUM(amount) > 30
);


-- return the first and last names of all customers
-- from California who have spent more than $100
SELECT first_name, last_name
FROM customer
INNER JOIN address ON customer.address_id = address.address_id
WHERE district = 'California'
AND customer_id IN (
	SELECT customer_id
	FROM payment
	GROUP BY customer_id
	HAVING SUM(amount) > 100
)
ORDER BY 1 ASC;
-- OR --
-- using two subqueries
SELECT first_name, last_name
FROM customer
WHERE customer_id IN (
	SELECT customer_id
	FROM customer
	INNER JOIN address ON customer.address_id = address.address_id
	WHERE district = 'California'
)
AND customer_id IN (
	SELECT customer_id
	FROM payment
	GROUP BY customer_id
	HAVING SUM(amount) > 100
)
ORDER BY 1 ASC;


-- average daily revenue of the company
-- subquery in the FROM clause
SELECT AVG(daily_revenue)
FROM (
	SELECT DATE(payment_date) as pdate, SUM(amount) as daily_revenue
	FROM payment
	GROUP BY pdate
) AS subquery;


-- add column that shows the difference between every
-- single payment and the overall highest payment amount
SELECT *, (SELECT MAX(amount) FROM payment) - amount AS difference
FROM payment;

-- NOTE: subqueries in SELECT clause expect a single value 
-- not multiple rows or columns


-- CORRELATED SUBQUERIES
-- can be used in the WHERE and SELECT clauses

-- display rows containing highest payment amount per customer
SELECT *
FROM payment AS pt1
WHERE amount = (
	SELECT MAX(amount)
	FROM payment AS pt2
	WHERE pt1.customer_id = pt2.customer_id
)
ORDER BY customer_id;


-- display title, film_id, replacement_cost, and rating category
-- for all movies with the lowest replacement_soct in each rating category
SELECT title, film_id, replacement_cost, rating
FROM film AS f1
WHERE replacement_cost = (
	SELECT MIN(replacement_cost)
	FROM film AS f2
	-- 	somehow, this gives correct result with or without below
	-- 	conditions. But for wholesomeness; they should be there.
	WHERE f1.rating = f2.rating
	GROUP BY rating
);


-- add a column displaying the maximun amount spent by each customer
SELECT *, (
	SELECT MAX(amount)
	FROM payment AS p1
	WHERE p1.customer_id = p2.customer_id
) as max_amount
FROM payment AS p2;


-- add columns that show all payments total and number of payments 
-- for every customer to the payment table
SELECT *, (
	SELECT SUM(amount)
	FROM payment AS p1
	WHERE p1.customer_id = p3.customer_id
) as total_amount, (
	SELECT COUNT(*)
	FROM payment AS p2
	WHERE p2.customer_id = p3.customer_id
) as num_of_payments
FROM payment AS p3;


-- display customer first_name with their 
-- highest payment amount and the payment_id
SELECT first_name, amount, payment_id
FROM payment AS p1
INNER JOIN customer 
ON p1.customer_id = customer.customer_id
WHERE amount = (
	SELECT MAX(amount)
	FROM payment AS p2
	WHERE p1.customer_id = p2.customer_id
);
-- OR --
-- if no need for the payment_id
SELECT first_name, MAX(amount)
FROM payment AS p1
INNER JOIN customer 
ON p1.customer_id = customer.customer_id
GROUP BY (first_name);
-- --
SELECT first_name, (
	SELECT MAX(amount)
	FROM customer AS c1
	INNER JOIN payment ON c1.customer_id = payment.customer_id
) AS max_amount
FROM customer AS c2;
-- NOTE: all three solutions above give different 
-- numbers of rows for reasons I'm yet to figure out
-- Last solution tallies with number of customers in db: 599

