-- WINDOW FUNCTIONS --


-- GREENCYCLE DATABASE --


SELECT 
f.film_id, title, f.length, ct.name as category, 
ROUND(AVG(f.length) OVER(PARTITION BY ct.name), 2) AS avg_movie_length_in_category
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category ct ON fc.category_id = ct.category_id
ORDER BY f.film_id;


SELECT *, 
COUNT(*) OVER(PARTITION BY customer_id, amount) AS num_customer_payments_with_same_amount
FROM payment
ORDER BY payment_id;


-- running total/rolling total/partial sum 
-- of payment amount with OVER & ORDER BY
SELECT *, 
SUM(amount) OVER(ORDER BY payment_date) AS running_total
FROM payment;


-- running total/rolling total/partial sum 
-- partitioned (ie: grouped) by customer
-- OVER & PARTITION BY & ORDER BY
SELECT *, 
SUM(amount) OVER(PARTITION BY customer_id ORDER BY payment_date) AS running_total
FROM payment;
-- multiple order
SELECT *, 
SUM(amount) OVER(PARTITION BY customer_id 
				 ORDER BY payment_id, payment_date) AS running_total
FROM payment;


-- FLIGHT DATABASE --


-- running sum of gap between scheduled/actual flight arrival
SELECT flight_id, departure_airport, 
SUM(actual_arrival - scheduled_arrival) OVER(ORDER BY flight_id) AS arrival_gap
FROM flights;
-- add partition by departure_airport
SELECT flight_id, departure_airport, 
SUM(actual_arrival - scheduled_arrival) OVER(PARTITION BY departure_airport 
											 ORDER BY flight_id) AS arrival_gap
FROM flights;


-- GREENCYCLE DATABASE --


-- RANK/DENSE_RANK
select cl.name, country, amount,
dense_rank() over(order by amount desc) as amount_rank
from customer_list cl
left join payment pt on cl.id = pt.customer_id;


/* Create a ranking of the top customers with most sales for each
country. Filter the result to only the top 3 customers per country */
-- first: write the simple query to count 
-- customer payments, showing their countries
select cl.name, cl.country, count(pt.payment_id)
from customer_list cl
left join payment pt on cl.id = pt.customer_id
group by cl.name, cl.country;
-- then, 
-- main query which combines the above
select full_name, country, num_payments, customer_rank
from (
	select cl.name as full_name, country, count(pt.payment_id) as num_payments, 
	dense_rank() over(partition by cl.country 
					  order by count(pt.payment_id) desc) as customer_rank
	from customer_list cl
	left join payment pt on cl.id = pt.customer_id
	group by cl.name, cl.country
) as customers
where customer_rank in (1,2,3);
-- then,
-- incorporate the FIRST_VALUE, LEAD, LAG function


/* Calculate the revenue of a particular date and that of the 
previous; then the percentage increase between both of them */
-- first: write the simple query to sum 
-- the respective date payments, showing the date
SELECT 
  SUM(amount) AS sum_on_date, 
  DATE(payment_date) AS date_in_view,
  LAG(SUM(amount)) OVER(ORDER BY DATE(payment_date)) AS sum_on_prev_day,
  SUM(amount) - LAG(SUM(amount)) OVER(ORDER BY DATE(payment_date)) AS difference
FROM customer_list cl
LEFT JOIN payment pt ON cl.id = pt.customer_id
GROUP BY DATE(payment_date);
-- then
-- the main query that incorporates the above one
SELECT 
  sum_on_date, 
  date_in_view, 
  sum_on_prev_day,
  difference,
  ROUND(difference / sum_on_prev_day * 100, 2) AS increase_percentage
FROM (
	SELECT 
	  SUM(amount) AS sum_on_date, 
	  DATE(payment_date) AS date_in_view,
	  LAG(SUM(amount)) OVER(ORDER BY DATE(payment_date)) AS sum_on_prev_day,
	  SUM(amount) - LAG(SUM(amount)) OVER(ORDER BY DATE(payment_date)) AS difference
	FROM customer_list cl
	LEFT JOIN payment pt ON cl.id = pt.customer_id
	GROUP BY DATE(payment_date)
) AS _


