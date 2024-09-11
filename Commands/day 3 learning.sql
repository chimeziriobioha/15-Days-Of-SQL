--AGGREGATION, GROUPING--

SELECT 
COUNT(amount) AS num_of_payment, 
SUM(amount) AS total_payments, 
ROUND(AVG(amount), 2) AS payments_average, 
MIN(amount) AS largest_payment, 
MAX(amount) AS smallest_payment 
FROM payment;


SELECT
MIN(replacement_cost),
MAX(replacement_cost),
ROUND(AVG(replacement_cost), 2) AS average,
SUM(replacement_cost)
FROM film;


SELECT 
customer_id, COUNT(amount), MAX(amount), SUM(amount)
FROM payment
WHERE amount != 0  --just to show that it's possible here
GROUP BY customer_id
ORDER BY SUM(amount) DESC;


group by single column
SELECT staff_id, COUNT(staff_id), SUM(amount)
FROM payment
GROUP BY staff_id
ORDER BY SUM(amount) DESC;


SELECT staff_id, COUNT(staff_id), SUM(amount)
FROM payment
WHERE amount != 0
GROUP BY staff_id
ORDER BY SUM(amount) DESC;


-- group by multiple column
SELECT staff_id, customer_id, COUNT(staff_id), SUM(amount)
-- SELECT staff_id, customer_id, COUNT(*), SUM(amount)
FROM payment
WHERE amount != 0
GROUP BY staff_id, customer_id
ORDER BY SUM(amount) DESC;


-- staff with highest total payments on date
SELECT DATE(payment_date), staff_id, SUM(amount), COUNT(*)
FROM payment
GROUP BY DATE(payment_date), staff_id
ORDER BY 3 DESC;


SELECT DATE(payment_date), staff_id, SUM(amount), COUNT(*)
FROM payment
WHERE amount != 0
GROUP BY DATE(payment_date), staff_id
ORDER BY 4 DESC;


-- HAVING --
SELECT DATE(payment_date), staff_id, SUM(amount), COUNT(*)
FROM payment
GROUP BY DATE(payment_date), staff_id
HAVING DATE(payment_date) > '2020-04-01'; --or multiple conditions


-- uncommenting the WHERE clause below
-- and commenting out the BETWEEN check
-- seems to make the query run a bit faster
SELECT 
customer_id, 
DATE(payment_date), 
ROUND(AVG(amount), 2) AS avg_amount,
COUNT(customer_id)
FROM payment
-- WHERE DATE(payment_date) IN ('2020-04-28', '2020-04-29', '2020-04-30')
GROUP BY customer_id, DATE(payment_date)
HAVING (DATE(payment_date) BETWEEN '2020-04-28' AND '2020-05-01') 
AND COUNT(customer_id) > 1
ORDER BY AVG(amount) DESC;