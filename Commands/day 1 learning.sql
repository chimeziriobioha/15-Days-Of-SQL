-- select all columns
SELECT *


-- select one column
SELECT column_name


-- select multiple (but not all) column
SELECT column_name, column_name, ...


-- order by single column
ORDER BY column_name DESC


-- order by multiple columns in same order
ORDER BY column_name, column_name


-- order by multiple columns in diff orders
ORDER BY column_name ASC, column_name DESC


-- limit display to n rows
LIMIT n  --always at the end of the commands


-- select distinct column
SELECT DISTINCT column_name


-- count all rows
SELECT COUNT(*)


-- count distinct rows
SELECT COUNT(DISTINCT column_name)