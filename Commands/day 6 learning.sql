-- JOINS --

-- GREENCYCLE DATABASE --

-- older join syntax
SELECT *
FROM customer, payment
WHERE customer.customer_id = payment.customer_id;


-- left join
-- customer table columns takes precedence
SELECT *
FROM customer
LEFT OUTER JOIN payment 
ON customer.customer_id = payment.customer_id;


-- right join
-- payment table columns takes precedence
SELECT *
FROM customer
RIGHT OUTER JOIN payment 
ON payment.customer_id = customer.customer_id;


-- inner join
-- no table columns takes precedence; only matches are returned
SELECT pa.*, first_name, last_name
FROM payment AS pa 
INNER JOIN customer AS cu
ON pa.customer_id = cu.customer_id;


-- FLIGHT DATABASE --

-- seats and flights on aircraft_code
-- seats and boarding_passes on seat_no
-- flights and boarding_passes on flight_id

-- seat sales by category (fare_conditions)
SELECT fare_conditions, COUNT(bps.seat_no) AS num_of_booking
FROM boarding_passes AS bps
INNER JOIN seats AS sts 
	ON bps.seat_no = sts.seat_no
INNER JOIN flights AS flt 
	ON bps.flight_id = flt.flight_id 
	AND sts.aircraft_code = flt.aircraft_code
GROUP BY fare_conditions
ORDER BY num_of_booking DESC;


-- old version of above query
SELECT fare_conditions, COUNT(*) AS num_of_booking
FROM boarding_passes AS bps, seats AS sts, flights AS flt
WHERE bps.seat_no = sts.seat_no
AND bps.flight_id = flt.flight_id
AND sts.aircraft_code = flt.aircraft_code
GROUP BY fare_conditions
ORDER BY num_of_booking DESC;


-- tickets without boarding pass
SELECT *
FROM tickets tks
FULL JOIN boarding_passes bps
ON tks.ticket_no = bps.ticket_no
WHERE bps.boarding_no IS null;


-- count of flights by each aircraft
SELECT acd.*, COUNT(fts.aircraft_code) AS flights_count
FROM aircrafts_data acd
LEFT JOIN flights fts
ON acd.aircraft_code = fts.aircraft_code
GROUP BY acd.aircraft_code
ORDER BY flights_count DESC;


-- aircrafts without flights
SELECT *
FROM aircrafts_data AS acd
FULL JOIN flights AS fts
ON acd.aircraft_code = fts.aircraft_code
WHERE fts.flight_id IS null;
----OR----
SELECT *
FROM aircrafts_data AS acd
LEFT JOIN flights AS fts
ON acd.aircraft_code = fts.aircraft_code
WHERE fts.flight_id IS null;


-- most booked/used seat
------with LEFT join
SELECT 
sts.seat_no AS seat_code, 
COUNT(bps.seat_no) AS usage_count
FROM seats AS sts 
LEFT JOIN boarding_passes AS bps 
ON sts.seat_no = bps.seat_no
GROUP BY seat_code 
ORDER BY usage_count DESC;
------with RIGHT join
SELECT 
sts.seat_no AS seat_code, 
COUNT(bps.seat_no) AS usage_count
FROM boarding_passes AS bps 
RIGHT JOIN seats AS sts  
ON sts.seat_no = bps.seat_no
GROUP BY seat_code 
ORDER BY usage_count DESC;


-- -- GREENCYCLE DATABASE --

-- customers from Texas
SELECT first_name, last_name, phone, district
FROM customer
INNER JOIN address 
ON customer.address_id = address.address_id
AND district = 'Texas'; 
-- Check on district above can be done with WHERE district = 'Texas'
-- But having it on the ON clause is a more performant query for large queries


-- addresses not related to a customer anymore
SELECT address.*
FROM customer
FULL JOIN address
ON customer.address_id = address.address_id
WHERE customer.customer_id IS null


-- -- FLIGHT DATABASE --

-- average amount garnered per seat number
SELECT seat_no, ROUND(AVG(amount), 2) AS avg_amount
FROM boarding_passes AS bps
LEFT JOIN ticket_flights AS tfs
ON bps.ticket_no = tfs.ticket_no 
AND bps.flight_id = tfs.flight_id
GROUP BY seat_no
ORDER BY avg_amount DESC;


-- select * from flights limit 100;
-- select * from tickets limit 100;
-- select * from bookings limit 100;
-- select * from ticket_flights limit 100;
-- select * from boarding_passes limit 100;


-- display ticket details with scheduled departure
-- `scheduled_departure` is only found in `flights` table which
-- has no direct connection with the `tickets` table. So, the 
-- `tickets_flights` table serves as the middleman connecting them
-- I also wanted to try two different join types in one query
SELECT tks.ticket_no, passenger_name, scheduled_departure
FROM tickets AS tks
INNER JOIN ticket_flights AS tfs
ON tks.ticket_no = tfs.ticket_no
LEFT JOIN flights AS fts
ON tfs.flight_id = fts.flight_id;


-- -- GREENCYCLE DATABASE --

-- get all customers from Brazil
-- requires joining of four different tables in one query
SELECT first_name, last_name, email, country
FROM customer
INNER JOIN address ON customer.address_id = address.address_id
INNER JOIN city ON address.city_id = city.city_id
INNER JOIN country ON city.country_id = country.country_id 
AND country.country = 'Brazil';
--OR--
SELECT first_name, last_name, email, country
FROM customer
LEFT JOIN address ON customer.address_id = address.address_id
LEFT JOIN city ON address.city_id = city.city_id
LEFT JOIN country ON city.country_id = country.country_id 
WHERE country.country = 'Brazil'