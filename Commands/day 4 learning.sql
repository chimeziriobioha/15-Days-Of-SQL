-- -- FUNCTIONS --
SELECT 
LOWER(first_name) AS first_name_lower,
LOWER(last_name) AS last_name_lower,
LOWER(email) AS email_lower
FROM customer
WHERE LENGTH(first_name) > 10 OR LENGTH(last_name) > 10;


SELECT
-- simple left/right and email
LEFT(email, 3) AS first_3_chars, 
RIGHT(email, 3) AS last_3_chars, 
email AS complete_email,
-- complex left/right
LEFT(RIGHT(email, 4), 1), -- just the last "."
LEFT(email, LENGTH(first_name)) as first_name,
RIGHT(SPLIT_PART(email, '@', 1), LENGTH(last_name)) AS last_name
FROM customer
LIMIT 20;


-- CONCATENATE with ||
SELECT initcap(first_name || ' ' || last_name) AS fullname
FROM customer
LIMIT 20;


SELECT LEFT(email, 1) || '***@' || SPLIT_PART(email, '@', -1) AS anon_email
-- SELECT LEFT(email, 1) || '***' || RIGHT(email, 19) AS anon_email
-- SELECT LEFT(email, 1) || '***' || '@sakilacustomer.org' AS anon_email
FROM customer
LIMIT 20;


-- POSITION
SELECT 
last_name || ', ' || LEFT(email, POSITION('.' IN email)-1) AS fullname
FROM customer
LIMIT 20;


SELECT SUBSTR(email, 3, 15)
-- SELECT SUBSTR(email, 3)
-- SELECT SUBSTRING(email FROM 3 FOR 7)
-- SELECT SUBSTRING(email, 3, 7)
-- SELECT SUBSTRING(email, 3)
-- SELECT SUBSTR(email, POSITION('.' IN email)+1)
FROM customer
LIMIT 20;


-- last name from email with only substring and position
SELECT 
email,
SUBSTRING(
	email
	from POSITION('.' IN email)+1
	for POSITION('@' IN email) - POSITION('.' IN email)-1
)
FROM customer
LIMIT 20;


-- anonimise email without SPLIT_PART 1
SELECT 
LEFT(email, 1)
|| '***'
|| LEFT(SUBSTRING(email, POSITION('.' IN email)), 2) 
|| '***' 
|| SUBSTRING(email, POSITION('@' IN email)) AS anonimised_email
FROM customer
LIMIT 20;


-- anonimise email without SPLIT_PART 2
SELECT 
'***'
-- || LEFT(SUBSTRING(email, POSITION('.' IN email)-1), 1)
-- || LEFT(SUBSTRING(email, POSITION('.' IN email)), 2) 
-- line below replaces the two commented lines above
|| SUBSTRING(email, POSITION('.' IN email)-1, 3)
|| '***' 
|| SUBSTRING(email, POSITION('@' IN email)) AS anonimised_email
FROM customer
LIMIT 20;


SELECT 
COUNT(*) as total_count, 
EXTRACT(day from rental_date) AS extracted_day
FROM rental
GROUP BY extracted_day
ORDER BY total_count DESC;


SELECT 
-- EXTRACT(day from payment_date) AS day_in_view,
EXTRACT(month from payment_date) AS month_in_view,
SUM(amount) AS total_sum
FROM payment
-- GROUP BY day_in_view
GROUP BY month_in_view
ORDER BY total_sum DESC;


-- highest paying customers spend in a week
SELECT 
EXTRACT(week from payment_date) AS week_in_view,
customer_id,
COUNT(*) AS num_of_payment, 
SUM(amount) AS total_spends
FROM payment
GROUP BY customer_id, week_in_view
ORDER BY total_spends DESC;


-- TO_CHAR
SELECT 
TO_CHAR(payment_date, 'Day, DDth Month, YYYY') AS blank_padded, --blank padded day/month
REPLACE(REPLACE(TO_CHAR(
	payment_date, 'Day, DDth Month, YYYY'), ' ', ''), ',', ', ') 
	AS blank_padded_partial_fix,
TO_CHAR(payment_date, 'Dy, DDth Mon, YYYY') AS nice_format,
TO_CHAR(payment_date, 'HH12:MM:SS pm') AS twelve_hrs_time,
TO_CHAR(payment_date, 'HH24:MM:SS AM') AS twenty_four_hrs_time
FROM payment
LIMIT 20;


SELECT 
TO_CHAR(payment_date, 'Dy, DD/MM/YYYY') AS period_str,
-- TO_CHAR(payment_date, 'Mon, YYYY') AS period_str,
-- TO_CHAR(payment_date, 'Dy, HH:MI') AS period_str,
SUM(amount) AS total_amount
FROM payment
GROUP BY period_str
ORDER BY total_amount ASC;


-- some play
SELECT
CURRENT_DATE,
CURRENT_TIMESTAMP,
return_date - rental_date AS dates_interval,
EXTRACT(day from return_date - rental_date) AS num_of_days,
TO_CHAR(return_date - rental_date, 'DD, HH:MI pm') AS interval_date
FROM rental
LIMIT 50;


SELECT customer_id, return_date - rental_date AS rent_duration
FROM rental WHERE customer_id = 35;


SELECT customer_id, AVG(return_date - rental_date) AS avg_rent_duration
FROM rental GROUP BY customer_id ORDER BY avg_rent_duration DESC


-- -- MATHEMATICAL FUNCTIONS --
SELECT
film_id,
rental_rate AS old_rate,
ROUND(rental_rate * 1.2, 2) AS increase_2percent, --2% increase
ROUND(rental_rate + (rental_rate * 0.4), 2) AS increase_4percent --4% increase
FROM film;


SELECT
film_id,
ROUND(rental_rate / replacement_cost * 100, 2) AS percentage
FROM film WHERE rental_rate < ROUND(replacement_cost * 0.04, 2) 
ORDER BY percentage ASC