-- GREENCYCLES DATABASE --
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


-- FLIGHT DATABASE --
SELECT * FROM flights LIMIT 10;


SELECT
CASE
    WHEN actual_departure IS null THEN 'No yet departed'
	WHEN actual_departure - scheduled_departure < '00:05' THEN 'On time'
	WHEN actual_departure - scheduled_departure < '00:10' THEN 'Late departure'
	WHEN actual_departure - scheduled_departure < '00:20' THEN 'Very late departure'
	ELSE 'Unknown status'
END AS departure_status,
COUNT(flight_id)
FROM flights
GROUP BY departure_status;


SELECT
COUNT(*),
CASE
	WHEN total_amount < 20000 THEN 'Low price tickte'
	WHEN total_amount >= 150000 THEN 'High price tickte'
	ELSE 'Mid price ticket'
END AS ticket_price
FROM bookings
GROUP BY ticket_price;


SELECT
COUNT(*) AS flights,
CASE
	WHEN replace(TO_CHAR(scheduled_departure, 'Month'), ' ', '') in ('December', 'January', 'February') THEN 'Winter'
	WHEN replace(TO_CHAR(scheduled_departure, 'Month'), ' ', '') in ('March', 'April', 'May') THEN 'Spring'
	WHEN replace(TO_CHAR(scheduled_departure, 'Month'), ' ', '') in ('June', 'July', 'August') THEN 'Summer'
	WHEN replace(TO_CHAR(scheduled_departure, 'Month'), ' ', '') in ('September', 'October', 'November') THEN 'Fall'
	ELSE 'Unknown Season'
END AS season
FROM flights
GROUP BY season;


-- GREENCYCLES DATABASE --
SELECT
title,
CASE
	WHEN rating in ('PG', 'PG-13') or length > 210 THEN 'Great rating or very long (tier 1)'
	WHEN description ILIKE '%Drama%' and length > 90 THEN 'Long drama (tier 2)'
	WHEN description ILIKE '%Drama%' and length <= 90 THEN 'Short drama (tier 3)'
	WHEN rental_rate < 1 THEN 'Very cheap (tier 4)'
-- 	ELSE ''
END AS tier
FROM film
WHERE
(rating in ('PG', 'PG-13') or length > 210)
or (description ILIKE '%Drama%' and length > 90)
or (description ILIKE '%Drama%' and length <= 90)
or (rental_rate < 1);


-- using CASE to perfom column counting
SELECT 
SUM(CASE WHEN rating = 'G' THEN 1 ELSE 0 END) AS "G",
SUM(CASE WHEN rating = 'R' THEN 1 ELSE 0 END) AS "R",
SUM(CASE WHEN rating = 'NC-17' THEN 1 ELSE 0 END) AS "NC-17",
SUM(CASE WHEN rating = 'PG-13' THEN 1 ELSE 0 END) AS "PG-13",
SUM(CASE WHEN rating = 'PG' THEN 1 ELSE 0 END) AS "PG"
FROM film


-- from another DB but worthy of being here
-- `transactions` table has columns: | amount | category |
-- where category is either 'Income' or 'Expense' which amount represents
-- using the CASE statement to calculate TotalIncome/TotalExpenses/NetIncome
SELECT
SUM(CASE WHEN category = 'Income' THEN amount ELSE 0 END) AS TotalIncome,
SUM(CASE WHEN category = 'Expense' THEN amount ELSE 0 END) AS TotalExpenses,
SUM(CASE WHEN category = 'Income' THEN amount ELSE -amount END) AS NetIncome
FROM transactions