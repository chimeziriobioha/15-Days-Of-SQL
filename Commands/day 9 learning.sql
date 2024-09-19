-- MANAGING DATABASE --


-- GREENCYCLE DATABASE


-- try the ANY function
SELECT * FROM film WHERE 'Behind the Scenes' = ANY(special_features);


-- ADD director TABLE TO THE database
CREATE TABLE IF NOT EXISTS director (
	director_id SERIAL PRIMARY KEY,
	director_account_name VARCHAR(20) UNIQUE,
	first_name VARCHAR(50),
	last_name VARCHAR(50) DEFAULT 'Not specified',
	date_of_birth DATE,
	address_id INT REFERENCES address(address_id)
);


/*
START OF INSERT TEST ROW, DELETE IT, ALTER COLUMNS, AND TABLE.
STOPS AT THE INITIAL director TABLE BEING AN EMPTY directors TABLE
*/
INSERT INTO director 
(director_account_name, first_name, date_of_birth)
SELECT 'Account One', 'Director', CURRENT_DATE
WHERE NOT EXISTS (
	SELECT director_id 
	FROM director 
	WHERE director.director_id = 1
);
-- 
DELETE FROM director;  -- DANGER: deletes all records
-- 
SELECT * FROM director;
/*
ALTER TABLE with the following

1. change director_account_name to VARCHAR(30)
2. drop the default on last_name
3. add not null constraint to last_name
4. add email column of data type VARCHAR(40)
5. rename the director_account_name column to account_name
6. rename the table from director to directors
*/
DROP TABLE IF EXISTS directors; --added to deal with 
-- 
ALTER TABLE director
ALTER COLUMN director_account_name TYPE VARCHAR(30),
ALTER COLUMN last_name DROP DEFAULT,
ALTER COLUMN last_name SET NOT NULL,
ADD email VARCHAR(40);
-- 
ALTER TABLE director RENAME COLUMN director_account_name TO account_name;
-- 
ALTER TABLE director RENAME TO directors;
-- 
INSERT INTO directors 
(account_name, first_name, last_name, date_of_birth)
VALUES
('Account One', 'Director', 'One', CURRENT_DATE),
('Account Two', 'Director', 'Two', CURRENT_DATE);
-- 
TRUNCATE directors; -- delete all data from table
-- 
SELECT * FROM directors;
/*
END OF INSERT TEST ROW, DELETE IT, ALTER COLUMNS, AND TABLE.
STOPPED AT THE INITIAL director TABLE BEING AN EMPTY directors TABLE
*/


-- START: songs TABLE CREATION/ALTERING --
-- ADD songs TABLE TO THE database
CREATE TABLE IF NOT EXISTS songs (
	song_id SERIAL PRIMARY KEY,
	song_name VARCHAR NOT NULL,
	genre VARCHAR DEFAULT 'Not defined',
	price NUMERIC CHECK(price >= 1.99),
	release_date DATE CONSTRAINT date_check CHECK(
		release_date BETWEEN '01-01-1950' AND CURRENT_DATE
	)
);
-- 
/* this insert will fail due 
to the constraint on price UNCOMMENT AND RUN */
-- INSERT INTO songs 
-- (song_name, price, release_date)
-- VALUES ('SQL song', 0.99, CURRENT_DATE);
-- 
-- update the constraint to allow 0.99 in price
ALTER TABLE songs
DROP CONSTRAINT IF EXISTS songs_price_check,
ADD CONSTRAINT songs_price_check CHECK(price >= 0.99);
-- 
-- insert will now pass
INSERT INTO songs 
(song_name, price, release_date)
VALUES ('SQL song', 0.99, CURRENT_DATE);
-- 
TRUNCATE songs; -- delete all data from table
-- 
SELECT * FROM songs;
-- END: songs TABLE CREATION/ALTERING --