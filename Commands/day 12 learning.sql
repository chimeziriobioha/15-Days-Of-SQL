/* GROUPING SETS */
-- GREENCYCLE DATABASE --
/* group payment by staff, month separately, 
and staff/month together */
SELECT
    TO_CHAR (payment_date, 'Month') AS _month,
    staff_id,
    SUM(amount)
FROM
    payment
GROUP BY
    GROUPING SETS ((staff_id), (_month), (staff_id, _month))
ORDER BY
    _month;

/* group payment by customer, staff separately, 
and customer/staff together */
SELECT
    first_name,
    last_name,
    staff_id,
    SUM(amount)
FROM
    payment pt
    LEFT JOIN customer ct ON pt.customer_id = ct.customer_id
GROUP BY
    GROUPING SETS (
        (first_name, last_name),
        (staff_id),
        (first_name, last_name, staff_id)
    )
ORDER BY
    first_name,
    last_name;

/* Incorporate percentage of each customer/staff payment in relation 
to the total payment by the customer to the previous query  */
SELECT
    first_name,
    last_name,
    staff_id,
    SUM(amount) AS sum_amount,
    ROUND(
        SUM(amount) / FIRST_VALUE (SUM(amount)) OVER (
            PARTITION BY
                first_name,
                last_name
        ) * 100,
        2
    ) AS _percentage
FROM
    payment pt
    LEFT JOIN customer ct ON pt.customer_id = ct.customer_id
GROUP BY
    GROUPING SETS (
        (first_name, last_name),
        (staff_id),
        (first_name, last_name, staff_id)
    )
ORDER BY
    first_name,
    last_name;

/* ROLLUP */
/* Sum payment by Year, Quater, Month, and Day in one simple query. 
There's a natural hierachy with date, that's why ROLLUP works well */
SELECT
    TO_CHAR (payment_date, 'YYYY') AS _year,
    TO_CHAR (payment_date, 'Q') AS _quater,
    TO_CHAR (payment_date, 'MM') AS _month,
    TO_CHAR (payment_date, 'DD') AS _day,
    SUM(amount) AS total
FROM
    payment
GROUP BY
    ROLLUP (
        (TO_CHAR (payment_date, 'YYYY')),
        (TO_CHAR (payment_date, 'Q')),
        (TO_CHAR (payment_date, 'MM')),
        (TO_CHAR (payment_date, 'DD'))
    )
ORDER BY
    1,
    2,
    3,
    4;

/* 
But in the absenceof a natural hierachy, we use CUBE 
*/
SELECT
    customer_id,
    staff_id,
    DATE(payment_date) AS _day,
    SUM(amount) AS total
FROM
    payment
GROUP BY
    CUBE (customer_id, staff_id, DATE(payment_date))
ORDER BY
    1,
    2,
    3;

/* SELF JOIN */
CREATE TABLE IF NOT EXISTS employee (employee_id INT, name VARCHAR(50), manager_id INT);

/*
INSERT INTO employee 
VALUES
(1, 'Liam Smith', NULL),
(2, 'Oliver Brown', 1),
(3, 'Elijah Jones', 1),
(4, 'William Miller', 1),
(5, 'James Davis', 2),
(6, 'Olivia Hernandez', 2),
(7, 'Emma Lopez', 2),
(8, 'Sophia Andersen', 2),
(9, 'Mia Lee', 3),
(10, 'Ava Robinson', 3);
*/
SELECT
    *
FROM
    employee;

/* List out each employee with their manager who 
is also on the same employee table on the same column */
SELECT
    emp.name AS employee,
    mng.name AS manager
FROM
    employee AS emp
    LEFT JOIN employee AS mng ON emp.manager_id = mng.employee_id;

/* Add a second step: manager of mangers */
SELECT
    emp.name AS employee,
    mng.name AS manager,
    mngOfmng.name AS manager_of_managers
FROM
    employee AS emp
    LEFT JOIN employee AS mng ON emp.manager_id = mng.employee_id
    LEFT JOIN employee AS mngOfmng ON mng.manager_id = mngOfmng.employee_id;

/* All films with the same length */
SELECT
    orig.title,
    pair.title,
    orig.length
FROM
    film AS orig
    LEFT JOIN film AS pair ON orig.length = pair.length
    AND orig.film_id != pair.film_id
WHERE
    pair.title IS NOT null
ORDER BY
    3 DESC;

/* CROSS JOIN */
-- all possible combination from two tables
/* NATURAL JOIN */
-- can be problematic