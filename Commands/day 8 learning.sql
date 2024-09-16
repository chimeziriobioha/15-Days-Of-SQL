-- COURSE PROJECT 1 --

-- GREENCYCLE DATABASE


-- 12. CREATE A LIST THAT SHOWS THE "average customer 
-- lifetime value" PER (ie: GROUPED BY) CUSTOMER district.
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


-- 13. CREATE A LIST THAT SHOWS ALL PAYMENTS INCLUDING THE payment_id, 
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


-- 14. CREATE A LIST WITH THE TOP OVERALL REVENUE OF FILM
-- TITLE (sum of amount per title) FOR EACH category (name).

-- my first solution: delivers correct results
-- but couldn't filter down to max of the totals
-- I still believe there's a way it can done without 
-- the full duplicate query like in the second solution
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
-- THEN
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