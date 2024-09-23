/* USER DEFINED FUNCTION */
CREATE FUNCTION add_numbers(n1 integer, n2 integer) 
	RETURNS integer
	LANGUAGE plpgsql
	AS 
	$$
	BEGIN
	RETURN n1 + n2;
	END;
	$$;


CREATE FUNCTION movie_count_by_rate(
	start_rate decimal(4,2), end_rate decimal(4,2)
) 
	RETURNS integer
	LANGUAGE plpgsql
	AS 
	$$
	DECLARE
	movie_count INT;
	BEGIN
	SELECT COUNT(*)
	INTO movie_count
	FROM film
	WHERE rental_rate BETWEEN start_rate AND end_rate;
	RETURN movie_count;
	END;
	$$;


CREATE OR REPLACE FUNCTION customer_payments_by_name(
	f_name varchar, l_name varchar
) 
	RETURNS integer
	LANGUAGE plpgsql
	AS 
	$$
	DECLARE
	total_payment INT;
	BEGIN
	SELECT SUM(amount)
	INTO total_payment
	FROM payment pt
	LEFT JOIN customer ct ON pt.customer_id = ct.customer_id
	WHERE ct.first_name = f_name AND ct.last_name = l_name;
	RETURN total_payment;
	END;
	$$;


SELECT 
	first_name,
	last_name,
	customer_payments_by_name(first_name, last_name) AS payment_sum
FROM
	customer;
	

/* TRANSACTIONS */
CREATE TABLE acc_balance (
    id SERIAL PRIMARY KEY,
    first_name TEXT NOT NULL,
	last_name TEXT NOT NULL,
    amount DEC(9,2) NOT NULL    
);

INSERT INTO acc_balance
VALUES 
(1,'Tim','Brown',2500),
(2,'Sandra','Miller',1600);

SELECT * FROM acc_balance;


BEGIN TRANSACTION;
    /* Execute a body of 
	work that belong together */
	UPDATE acc_balance
	SET amount = amount - 100
	WHERE id = 1;
	
	/* set a savepoint that can be 
	reverted to if things got wrong */
	SAVEPOINT s1;
	
	UPDATE acc_balance
	SET amount = amount + 100
	WHERE id = 2;
	
	/* rolling back to a savepoint while 
	still keeping the transaction open */
	ROLLBACK TO SAVEPOINT s1;
	
	/* rollback all changes 
	and shut the transaction */
	ROLLBACK
	
	/* Running only the code above will save 
	the changes in this session but will not 
	update the database permanently until the
	COMMIT clause below is invoked */
COMMIT;


/* STORED PROCEDURE */
CREATE OR REPLACE PROCEDURE transfer_fund (
	tf_amount INT, sender_id INT, receiver_id INT
)
	LANGUAGE plpgsql
	AS 
	$$
	BEGIN
	-- 	debit sender
	UPDATE acc_balance
	SET amount = amount - tf_amount
	WHERE id = sender_id;
	
	-- 	credit receiver
	UPDATE acc_balance
	SET amount = amount + tf_amount
	WHERE id = receiver_id;
	-- 	
	COMMIT;
	END;
	$$;

CALL transfer_fund(150, 1, 2)

SELECT * FROM acc_balance;