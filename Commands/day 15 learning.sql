/* DATABASE USER MANAGEMENT */
-- direct user creation
CREATE USER sarah
WITH
	PASSWORD 'sarah123';

-- indirect user creation
CREATE ROLE alex
WITH
	LOGIN PASSWORD 'alex123';

/* New users can:
---create new tables and manage them
---see existing tables but cannot query or run
any operations on the without outright permissions
*/
/* PRIVILEGES */
-- role based privileges
CREATE ROLE read_only;

CREATE ROLE read_update;

-- usage is granted by 
-- default in public though 
GRANT USAGE ON SCHEMA public TO read_only;

-- grant select privileges
GRANT
SELECT
	ON ALL TABLES IN SCHEMA public TO read_only;

-- grant read_only to sarah
GRANT read_only TO sarah;

-- grant read_only to read_update
GRANT read_only TO read_update;

-- grant all privileges to read_update
GRANT ALL ON ALL TABLES IN SCHEMA public TO read_update;

-- revoke some privileges on read_update
REVOKE DELETE,
INSERT ON ALL TABLES IN SCHEMA public
FROM
	read_update;

-- grant read_only to sarah
GRANT read_update TO alex;

-- drop user
DROP USER sarah;

-- drop role with dependencies
DROP OWNED BY read_update;

DROP ROLE read_update;

/* INDEXES: B-tree & Bitmap */
/* when to use B-tree index:
---table is large (most important)
---column has high-cardinality
---column is frequently used to filter query
---column is not frequently updated [no frequent writes]
---column is used to retrieve small portion of the record in the table
---table that may not be large, but is often involved in subqueries, especially collerated
*/
-- indexing test case
SELECT
	(
		SELECT
			AVG(amount)
		FROM
			payment p2
		WHERE
			p1.rental_id = p2.rental_id
	)
FROM
	payment p1;

-- run above code and note the execution time
-- then create the index below on rental_id 
-- and re-run above code to see the new execution time
CREATE INDEX payment_rental_id_index ON payment (rental_id);

DROP INDEX payment_rental_id_index;

/* 
NOTE: The Explain Analyze feature in PGAdmin
can be used get realtime insight into SQL code
execution steps which can help with the decision 
on where to place indexes
*/
