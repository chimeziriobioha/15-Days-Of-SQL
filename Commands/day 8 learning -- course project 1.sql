-- COURSE PROJECT 1 --
-- move to the bottom if you're interested in the most complicated part --


-- GREENCYCLE DATABASE --


-- 1: CREATE A LIST OF ALL THE DIFFERENT 
-- (ie: distinct) replacement_cost OF THE FILMS.
SELECT DISTINCT(replacement_cost)
FROM film
ORDER BY replacement_cost ASC;


-- 2: WRITE A QUERY THAT GIVES AN OVERVIEW OF HOW MANY  
-- film HAVE replacement cost IN THE FOLLOWING COST RANGES:
-- low: 9.99 - 19.99; medium: 20.00 - 24.99; high: 25.00 - 29.99
SELECT
CASE 
	WHEN replacement_cost BETWEEN 9.99 and 19.99 THEN 'low' 
    WHEN replacement_cost BETWEEN 20.00 and 24.99 THEN 'medium'
    WHEN replacement_cost BETWEEN 25.00 and 29.99 THEN 'high' 
END AS cost_range,
COUNT(*)
FROM film
GROUP BY cost_range;
-- OR --
-- display by columns
SELECT
SUM(CASE WHEN replacement_cost BETWEEN 9.99 and 19.99 THEN 1 ELSE 0 END) AS low,
SUM(CASE WHEN replacement_cost BETWEEN 20.00 and 24.99 THEN 1 ELSE 0 END) AS medium,
SUM(CASE WHEN replacement_cost BETWEEN 25.00 and 29.99 THEN 1 ELSE 0 END) AS high
FROM film;


-- 3: CREATE A LIST OF THE film INCLUDING THEIR title, length, AND 
-- category name ORDERED DESCENDINGLY BY length. FILTER THE RESULTS 
-- TO ONLY THE MOVIES IN THE category 'DRAMA' OR 'SPORTS'.
SELECT title, film.length, category.name
FROM film
LEFT JOIN film_category AS fa ON film.film_id = fa.film_id
LEFT JOIN category ON fa.category_id = category.category_id
WHERE category.name IN ('Drama', 'Sports')
ORDER BY film.length DESC;


-- 4: CREATE AN OVERVIEW OF HOW MANY MOVIES 
-- (title) THERE ARE IN EACH CATEGORY (name).
SELECT category.name AS category_name, COUNT(*) AS num_of_movies
FROM category
LEFT JOIN film_category AS fa ON category.category_id = fa.category_id
GROUP BY category_name
ORDER BY num_of_movies DESC;


-- 5: CREATE AN OVERVIEW OF THE actors' FIRST AND 
-- LAST NAMES AND IN HOW MANY MOVIES THEY APPEAR IN.
SELECT first_name, last_name, COUNT(fa.actor_id) AS num_of_movies
FROM actor
LEFT JOIN film_actor AS fa ON actor.actor_id = fa.actor_id
GROUP BY first_name, last_name
ORDER BY num_of_movies DESC;


-- 6: LIST THE ADDRESSES THAT ARE NOT ASSOCIATED TO ANY CUSTOMER.
SELECT * 
FROM address
LEFT JOIN customer ON customer.address_id = address.address_id
WHERE customer.address_id is null;


-- 7: CREATE AN OVERVIEW OF THE payment TO DETERMINE THE CITY (WHERE
-- customer LIVES, NOT WHERE THE store IS) WHERE MOST payment OCCUR.
SELECT city, SUM(amount) AS sum_amount
FROM payment
LEFT JOIN customer ON payment.customer_id = customer.customer_id
LEFT JOIN address ON customer.address_id = address.address_id
LEFT JOIN city ON address.city_id = city.city_id
GROUP BY city
ORDER BY sum_amount DESC;


-- 8: CREATE AN OVERVIEW OF THE REVENUE (sum of amount) 
-- GROUPED BY A column IN THE FORMAT "country, city".
SELECT 
country || ', ' || city AS country_city,
SUM(amount) AS sum_of_amount
FROM payment
LEFT JOIN customer ON payment.customer_id = customer.customer_id
LEFT JOIN address ON customer.address_id = address.address_id
LEFT JOIN city ON address.city_id = city.city_id
LEFT JOIN country ON city.country_id = country.country_id
GROUP BY country, city
ORDER BY sum_of_amount ASC;


-- 9: CREATE A LIST WITH THE overall average OF 
-- payment amount EACH staff_id HAS PER CUSTOMER.
SELECT staff_id, ROUND(AVG(sum_amount), 2)
FROM (
	SELECT staff_id, customer_id, SUM(amount) as sum_amount
	FROM payment
	GROUP BY staff_id, customer_id
) AS _
GROUP BY _.staff_id;


-- 10: SHOWS AVERAGE DAILY REVENUE OF ALL Sundays.
SELECT ROUND(AVG(sunday_sum), 2) AS sunday_avearge
FROM (
	SELECT 
	DATE(payment_date) as sunday, SUM(amount) as sunday_sum
	FROM payment
	WHERE EXTRACT(DOW from payment_date) = 0
	GROUP BY sunday
) AS sunday_sums;



-- 11: CREATE A LIST OF MOVIES - WITH THEIR length and 
-- replacement cost - THAT ARE longer THAN THE average 
-- length IN EACH replacement cost GROUP.
SELECT title, replacement_cost, f1.length
FROM film AS f1
WHERE f1.length > (
	SELECT AVG(f2.length)
	FROM film AS f2
	WHERE f1.replacement_cost = f2.replacement_cost
)
ORDER BY f1.length ASC;


-- 12: CREATE A LIST THAT SHOWS THE "average customer 
-- lifetime value" PER CUSTOMER (ie: GROUPED BY) district.
SELECT district, (
	SELECT ROUND(AVG(customer_total), 2) AS average_spend
	FROM (
		SELECT c2.customer_id, SUM(amount) AS customer_total, district
		FROM customer AS c2
		INNER JOIN address AS a2 ON c2.address_id = a2.address_id
		INNER JOIN payment AS p2 ON c2.customer_id = p2.customer_id
		GROUP BY c2.customer_id, district
	) AS customer_totals
	WHERE a1.district = customer_totals.district
)
FROM payment AS p1
LEFT JOIN customer AS c1 ON p1.customer_id = c1.customer_id
LEFT JOIN address AS a1 ON c1.address_id = a1.address_id
GROUP BY district
ORDER BY average_spend DESC;
-- OR --
-- a shorter and more direct [instructor aided] solution
SELECT district, ROUND(AVG(customer_total), 2) AS average_spend
FROM (
	SELECT c2.customer_id, SUM(amount) AS customer_total, district
	FROM customer AS c2
	INNER JOIN address AS a2 ON c2.address_id = a2.address_id
	INNER JOIN payment AS p2 ON c2.customer_id = p2.customer_id
	GROUP BY c2.customer_id, district
) AS customer_totals
GROUP BY district
ORDER BY average_spend DESC;


-- 13: CREATE A LIST THAT SHOWS ALL PAYMENTS INCLUDING THE payment_id, 
-- amount, AND THE FILM category (name) PLUS THE total amount THAT 
-- WAS MADE IN THIS category. ORDER THE RESULTS ASCENDINGLY BY THE 
-- category (name) AND AS SECOND ORDER CRITERION BY THE payment_id 
-- ASCENDINGLY.
SELECT payment_id, amount, title, c1.name AS category, (
	SELECT SUM(amount)
	-- this is an exact duplicate of outer query below: very expensive
	FROM payment AS p2
	INNER JOIN rental AS r2 ON p2.rental_id = r2.rental_id
	INNER JOIN inventory AS i2 ON r2.inventory_id = i2.inventory_id
	INNER JOIN film AS f2 ON i2.film_id = f2.film_id
	INNER JOIN film_category AS fc2 ON f2.film_id = fc2.film_id
	INNER JOIN category AS c2 ON c2.category_id = fc2.category_id
	GROUP BY c2.name
	HAVING c2.name = c1.name
) as categeory_total
FROM payment AS p1
INNER JOIN rental AS r1 ON p1.rental_id = r1.rental_id
INNER JOIN inventory AS i1 ON r1.inventory_id = i1.inventory_id
INNER JOIN film AS f1 ON i1.film_id = f1.film_id
INNER JOIN film_category AS fc1 ON f1.film_id = fc1.film_id
INNER JOIN category AS c1 ON c1.category_id = fc1.category_id
ORDER BY category ASC, payment_id ASC;
-- TODO: Find a way to do this without the code dupliction


-- 14: CREATE A LIST WITH THE TOP OVERALL REVENUE OF FILM
-- TITLE (sum of amount per title) FOR EACH category (name).

-- my first solution: delivers correct results
-- but couldn't filter down to max of the totals
-- TODO: I'm thinking there can be a way to do this without 
-- the full duplicate query used in the second solution below
SELECT title, SUM(amount) as revenue, (
	SELECT c1.name 
	FROM category AS c1
	INNER JOIN film_category AS fc1 
	ON c1.category_id = fc1.category_id AND f1.film_id = fc1.film_id
) as category
FROM rental AS r1
INNER JOIN payment AS p1 ON r1.rental_id = p1.rental_id
INNER JOIN inventory AS i1 ON r1.inventory_id = i1.inventory_id
INNER JOIN film AS f1 ON i1.film_id = f1.film_id
GROUP BY title, category
ORDER BY revenue DESC;
-- THEN --
-- second solution [instructor aided]: with filter down to max totals
SELECT title, SUM(amount) AS revenue, c1.name AS category
FROM rental AS r1
INNER JOIN payment AS p1 ON r1.rental_id = p1.rental_id
INNER JOIN inventory AS i1 ON r1.inventory_id = i1.inventory_id
INNER JOIN film AS f1 ON i1.film_id = f1.film_id
INNER JOIN film_category AS fc1 ON f1.film_id = fc1.film_id
INNER JOIN category AS c1 ON c1.category_id = fc1.category_id
GROUP BY title, category
HAVING SUM(amount) = (
	SELECT MAX(revenue)
	FROM (
		-- this is an exact duplicate of outer query above: very expensive
		SELECT title, SUM(amount) AS revenue, c1.name AS category
		FROM rental AS r1
		INNER JOIN payment AS p1 ON r1.rental_id = p1.rental_id
		INNER JOIN inventory AS i1 ON r1.inventory_id = i1.inventory_id
		INNER JOIN film AS f1 ON i1.film_id = f1.film_id
		INNER JOIN film_category AS fc1 ON f1.film_id = fc1.film_id
		INNER JOIN category AS c1 ON c1.category_id = fc1.category_id
		GROUP BY title, category
	) AS max_revenues
	WHERE c1.name = max_revenues.category
)
ORDER BY revenue DESC