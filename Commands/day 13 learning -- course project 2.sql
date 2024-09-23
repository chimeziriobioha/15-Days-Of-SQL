/* GROUPING SETS */
-- GREENCYCLE DATABASE --
/* 1.a: Set up a table called employees with the following columns
emp_id, first_name, last_name, job_position, salary, start_date,
birth_date, store_id, department_id, manager_id.

Add NOT NULL constraint on: first_name, last_name, job_position,
start_date, birth_date */
CREATE TABLE
	IF NOT EXISTS employees (
		emp_id SERIAL PRIMARY KEY,
		first_name VARCHAR NOT NULL,
		last_name VARCHAR NOT NULL,
		job_position VARCHAR NOT NULL,
		salary NUMERIC(8, 2),
		start_date DATE NOT NULL,
		birth_date DATE NOT NULL,
		store_id INT,
		department_id INT,
		manager_id INT
	);

/* 1.b:  Create another table named departments with columns 
department_id, department, and division. Allow no nulls in any column */
CREATE TABLE
	IF NOT EXISTS departments (
		department_id SERIAL PRIMARY KEY,
		department VARCHAR NOT NULL,
		division VARCHAR NOT NULL
	);

/* 2: Alter the employees table with the following details:
- Set the column department_id to not null.
- Add a default value of CURRENT_DATE to the column start_date.
- Add the column end_date with an appropriate data type (one that you think makes sense).
- Add a constraint called birth_check that doesn't allow birth dates that are in the future.
- Rename the column job_position to position_title. */
ALTER TABLE employees
ALTER COLUMN department_id
SET
	NOT NULL,
ALTER COLUMN start_date
SET DEFAULT CURRENT_DATE,
ADD end_date DATE,
ADD CONSTRAINT birth_check CHECK (birth_date < CURRENT_DATE);

ALTER TABLE employees
RENAME COLUMN job_position TO position_title;

/* 3.a: Insert the data in Eployees_Data.txt into the employees 
table. There will be an error when you try to insert the values.
So, try to insert, see the error, fix it and then re-insert. 
 */
INSERT INTO
	employees (
		emp_id,
		first_name,
		last_name,
		position_title,
		salary,
		start_date,
		birth_date,
		store_id,
		department_id,
		manager_id,
		end_date
	)
VALUES
	(
		1,
		'Morrie',
		'Conaboy',
		'CTO',
		21268.94,
		'2005-04-30',
		'1983-07-10',
		1,
		1,
		NULL,
		NULL
	),
	(
		2,
		'Miller',
		'McQuarter',
		'Head of BI',
		14614.00,
		'2019-07-23',
		'1978-11-09',
		1,
		1,
		1,
		NULL
	),
	(
		3,
		'Christalle',
		'McKenny',
		'Head of Sales',
		12587.00,
		'1999-02-05',
		'1973-01-09',
		2,
		3,
		1,
		NULL
	),
	(
		4,
		'Sumner',
		'Seares',
		'SQL Analyst',
		9515.00,
		'2006-05-31',
		'1976-08-03',
		2,
		1,
		6,
		NULL
	),
	(
		5,
		'Romain',
		'Hacard',
		'BI Consultant',
		7107.00,
		'2012-09-24',
		'1984-07-14',
		1,
		1,
		6,
		NULL
	),
	(
		6,
		'Ely',
		'Luscombe',
		'Team Lead Analytics',
		12564.00,
		'2002-06-12',
		'1974-08-01',
		1,
		1,
		2,
		NULL
	),
	(
		7,
		'Clywd',
		'Filyashin',
		'Senior SQL Analyst',
		10510.00,
		'2010-04-05',
		'1989-07-23',
		2,
		1,
		2,
		NULL
	),
	(
		8,
		'Christopher',
		'Blague',
		'SQL Analyst',
		9428.00,
		'2007-09-30',
		'1990-12-07',
		2,
		2,
		6,
		NULL
	),
	(
		9,
		'Roddie',
		'Izen',
		'Software Engineer',
		4937.00,
		'2019-03-22',
		'2008-08-30',
		1,
		4,
		6,
		NULL
	),
	(
		10,
		'Ammamaria',
		'Izhak',
		'Customer Support',
		2355.00,
		'2005-03-17',
		'1974-07-27',
		2,
		5,
		3,
		'2013-04-14'
	),
	(
		11,
		'Carlyn',
		'Stripp',
		'Customer Support',
		3060.00,
		'2013-09-06',
		'1981-09-05',
		1,
		5,
		3,
		NULL
	),
	(
		12,
		'Reuben',
		'McRorie',
		'Software Engineer',
		7119.00,
		'1995-12-31',
		'1958-08-15',
		1,
		5,
		6,
		NULL
	),
	(
		13,
		'Gates',
		'Raison',
		'Marketing Specialist',
		3910.00,
		'2013-07-18',
		'1986-06-24',
		1,
		3,
		3,
		NULL
	),
	(
		14,
		'Jordanna',
		'Raitt',
		'Marketing Specialist',
		5844.00,
		'2011-10-23',
		'1993-03-16',
		2,
		3,
		3,
		NULL
	),
	(
		15,
		'Guendolen',
		'Motton',
		'BI Consultant',
		8330.00,
		'2011-01-10',
		'1980-10-22',
		2,
		3,
		6,
		NULL
	),
	(
		16,
		'Doria',
		'Turbat',
		'Senior SQL Analyst',
		9278.00,
		'2010-08-15',
		'1983-01-11',
		1,
		1,
		6,
		NULL
	),
	(
		17,
		'Cort',
		'Bewlie',
		'Project Manager',
		5463.00,
		'2013-05-26',
		'1986-10-05',
		1,
		5,
		3,
		NULL
	),
	(
		18,
		'Margarita',
		'Eaden',
		'SQL Analyst',
		5977.00,
		'2014-09-24',
		'1978-10-08',
		2,
		1,
		6,
		'2020-03-16'
	),
	(
		19,
		'Hetty',
		'Kingaby',
		'SQL Analyst',
		7541.00,
		'2009-08-17',
		'1999-04-25',
		1,
		2,
		6,
		NULL
	),
	(
		20,
		'Lief',
		'Robardley',
		'SQL Analyst',
		8981.00,
		'2002-10-23',
		'1971-01-25',
		2,
		3,
		6,
		'2016-07-01'
	),
	(
		21,
		'Zaneta',
		'Carlozzi',
		'Working Student',
		1525.00,
		'2006-08-29',
		'1995-04-16',
		1,
		3,
		6,
		'2012-02-19'
	),
	(
		22,
		'Giana',
		'Matz',
		'Working Student',
		1036.00,
		'2016-03-18',
		'1987-09-25',
		1,
		3,
		6,
		NULL
	),
	(
		23,
		'Hamil',
		'Evershed',
		'Web Developper',
		3088.00,
		'2022-02-03',
		'2012-03-30',
		1,
		4,
		2,
		NULL
	),
	(
		24,
		'Lowe',
		'Diamant',
		'Web Developper',
		6418.00,
		'2018-12-31',
		'2002-09-07',
		1,
		4,
		2,
		NULL
	),
	(
		25,
		'Jack',
		'Franklin',
		'SQL Analyst',
		6771.00,
		'2013-05-18',
		'2005-10-04',
		1,
		2,
		2,
		NULL
	),
	(
		26,
		'Jessica',
		'Brown',
		'SQL Analyst',
		8566.00,
		'2003-10-23',
		'1965-01-29',
		1,
		1,
		2,
		NULL
	);

/* 3.b: Inster data into departments table */
INSERT INTO
	departments (department_id, department, division)
VALUES
	(1, 'Analytic', 'IT'),
	(2, 'Finance', 'Administration'),
	(3, 'Sales', 'Sales'),
	(4, 'Website', 'IT'),
	(5, 'Back Office', 'Administration');

/* 4.a: Jack Franklin gets promoted to 'Senior SQL Analyst' and the salary raises to 7200.
Update the values accordingly. */
-- select * from employees where first_name = 'Jack' AND last_name = 'Franklin'
UPDATE employees
SET
	position_title = 'Senior SQL Analyst',
	salary = 7200
WHERE
	first_name = 'Jack'
	AND last_name = 'Franklin';

/* 4.b: Rename all the position_title 'Customer Support' to 'Customer Specialist'. */
-- select * from employees where position_title = 'Customer Specialist'
UPDATE employees
SET
	position_title = 'Customer Specialist'
WHERE
	position_title = 'Customer Support'

/* 4.c: All SQL Analysts including Senior SQL Analysts get a raise of 6%.
Upate the salaries accordingly. */
-- select * from employees where position_title ILIKE '%SQL Analyst%'
UPDATE employees
SET
	salary = salary * 1.06
WHERE
	position_title ILIKE '%SQL Analyst%';

/* 4.d: What is the average salary of a SQL Analyst in the 
company (excluding Senior SQL Analyst)? */
SELECT
	position_title,
	ROUND(AVG(salary), 2)
FROM
	employees
WHERE
	position_title = 'SQL Analyst'
GROUP BY
	position_title;
	

/* 5.a: Write a query that adds a column called manager that contains  
first_name and last_name (in one column) in the data output.

Secondly, add a column called is_active with 'false' if the employee 
has left the company already, otherwise the value is 'true'. */
-- select * from employees
SELECT
	*,
	(
		SELECT
			mng.first_name || ' ' || mng.last_name
		FROM
			employees emp
			LEFT JOIN employees mng ON emp.manager_id = mng.emp_id
		WHERE
			emp.emp_id = mainEmp.emp_id
	) AS manager,
	CASE
		WHEN end_date IS null THEN 'true'
		ELSE 'false'
	END AS is_active
FROM
	employees AS mainEmp;

/* 5.b: Create a view called v_employees_info from that previous query. */
CREATE VIEW v_employees_info AS
SELECT
	*,
	(
		SELECT
			mng.first_name || ' ' || mng.last_name
		FROM
			employees emp
			LEFT JOIN employees mng ON emp.manager_id = mng.emp_id
		WHERE
			emp.emp_id = mainEmp.emp_id
	) AS manager,
	CASE
		WHEN end_date IS null THEN 'true'
		ELSE 'false'
	END AS is_active
FROM
	employees AS mainEmp;


/* 6: Write a query that returns the average salaries 
for each positions with appropriate roundings. */
SELECT
	position_title,
	ROUND(AVG(salary), 2)
FROM 
	employees
GROUP BY
	position_title;


/* 7: Write a query that returns the average salaries per division. */
SELECT
	division,
	ROUND(AVG(salary), 2)
FROM
	departments dep
LEFT JOIN
	employees emp ON dep.department_id = emp.department_id
GROUP BY
	division;


/* 8.a: Write a query that returns the following:
emp_id, first_name, last_name, position_title, salary
and a column that returns the average salary for every position_title. 
Order the results by the emp_id. */
SELECT 
	emp_id, 
	first_name, 
	last_name, 
	position_title, 
	salary,
	ROUND(AVG(salary) OVER(PARTITION BY position_title), 2) AS avg_position_salary
FROM 
	employees
ORDER BY 
	emp_id


/* 8.b: How many people earn less than there avg_position_salary?
Write a query that answers that question. Ideally, the output 
just shows that number directly. */
SELECT 
	COUNT(*)
FROM 
	(
		SELECT
			salary,
			ROUND(AVG(salary) OVER(PARTITION BY position_title), 2) AS avg_position_salary
		FROM 
			employees
	) AS subquery
WHERE
	subquery.salary < subquery.avg_position_salary;


/* 9: Write a query that returns a running total of the salary 
development by the start_date.

In your calculation, you can assume their salary has not changed over 
time, and you can disregard the fact that people have left the company 
(write the query as if they were still working for the company). */
SELECT
	emp_id,
	salary,
	start_date,
	SUM(salary) OVER(ORDER BY start_date) AS running_total_of_salary
FROM employees;


/* 10: Create the same running total (like in No. 9) above 
but now consider the fact that people were leaving the company. */
-- select * from v_employees_info


/* 11.a: Write a query that outputs only the top earner per position_title. 
Show their first_name, position_title, and salary. */
SELECT
	first_name,
	position_title,
	salary
FROM
	employees mainEmp
WHERE
	salary = (
		SELECT
			MAX(salary)
		FROM
			employees subEmp
		WHERE
			mainEmp.position_title = subEmp.position_title
	)
ORDER BY
	salary DESC;

/* 11.b: Add average salary column per 
position_title to the query/result of 11.a. */
SELECT
	first_name,
	position_title,
	salary,
	(
		SELECT 
			ROUND(AVG(salary), 2)
		FROM
			employees subEmp1
		WHERE
			mainEmp.position_title = subEmp1.position_title
	) AS avg_position_salary
FROM
	employees mainEmp
WHERE
	salary = (
		SELECT
			MAX(salary)
		FROM
			employees subEmp2
		WHERE
			mainEmp.position_title = subEmp2.position_title
	)
ORDER BY
	salary DESC;

/* 11.c: Remove those employees from the output of the previous 
query that has the same salary as the average of their position_title. */
SELECT
	*
FROM
	(
		SELECT
			first_name,
			position_title,
			salary,
			ROUND(AVG(salary) OVER(PARTITION BY position_title), 2) AS avg_position_salary
		FROM
			employees
	) AS subq
WHERE
	salary != avg_position_salary
ORDER BY
	salary DESC;


/* 12: Write a query that returns all meaningful aggregations of
- sum of salary,
- number of employees,
- average salary
grouped by all meaningful combinations of
- division,
- department,
- position_title. 
Consider the levels of hierarchies in a meaningful way. */
SELECT
	division,
	department,
	position_title,
	SUM(salary) AS total_salary,
	COUNT(*) AS num_of_staff,
	ROUND(AVG(salary), 2) AS avg_salary
FROM
	employees emp
LEFT JOIN
	departments dep ON emp.department_id = dep.department_id
GROUP BY
	GROUPING SETS (
		(division, department, position_title),
		(division, department),
		(department, position_title)
	)
ORDER BY 
	1, 2, 3
-- OR: instructor solution --
SELECT 
	division,
	department,
	position_title,
	SUM(salary),
	COUNT(*),
	ROUND(AVG(salary),2)
FROM 
	employees
NATURAL JOIN 
	departments
GROUP BY 
	ROLLUP(
		division,
		department,
		position_title
	)
ORDER BY 
	1,2,3


/* 13. Write a query that returns all employees (emp_id) 
including their position_title, department, their salary, 
and the rank of that salary partitioned by department.
The highest salary per division should have rank 1. */
SELECT
	emp_id,
	position_title,
	department,
	salary,
	DENSE_RANK() OVER(PARTITION BY department ORDER BY salary DESC) AS salary_rank
FROM
	employees emp
LEFT JOIN
	departments dep ON emp.department_id = dep.department_id
-- OR: instructor solution --
SELECT
	emp_id,
	position_title,
	department,
	salary,
	RANK() OVER(PARTITION BY department ORDER BY salary DESC)
FROM 
	employees
NATURAL LEFT JOIN 
	departments


/* Write a query that returns only the top earner of each department including
their emp_id, position_title, department, and their salary. */
SELECT
	emp_id,
	position_title,
	department,
	salary
FROM 
	employees mainEmp
LEFT JOIN
	departments mainDep ON mainEmp.department_id = mainDep.department_id
WHERE salary = (
	SELECT
		MAX(salary)
	FROM
		employees subEmp
	LEFT JOIN
		departments subDep ON subEmp.department_id = subDep.department_id
	WHERE
		subDep.department = mainDep.department
)
ORDER BY
	salary DESC;
-- OR: instructor solution --
SELECT 
	* 
FROM
	(
		SELECT
			emp_id,
			position_title,
			department,
			salary,
			RANK() OVER(PARTITION BY department ORDER BY salary DESC)
		FROM 
			employees
		NATURAL LEFT JOIN 
			departments
	) _
WHERE 
	rank=1
