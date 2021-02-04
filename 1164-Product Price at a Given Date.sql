/* 1164. Product Price at a Given Date

Table: Products

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| product_id    | int     |
| new_price     | int     |
| change_date   | date    |
+---------------+---------+
(product_id, change_date) is the primary key of this table.
Each row of this table indicates that the price of some product was changed to a new price at some date.
 

Write an SQL query to find the prices of all products on 2019-08-16. Assume the price of all products before any change is 10.

The query result format is in the following example:

Products table:
+------------+-----------+-------------+
| product_id | new_price | change_date |
+------------+-----------+-------------+
| 1          | 20        | 2019-08-14  |
| 2          | 50        | 2019-08-14  |
| 1          | 30        | 2019-08-15  |
| 1          | 35        | 2019-08-16  |
| 2          | 65        | 2019-08-17  |
| 3          | 20        | 2019-08-18  |
+------------+-----------+-------------+

Result table:
+------------+-------+
| product_id | price |
+------------+-------+
| 2          | 50    |
| 1          | 35    |
| 3          | 10    |
+------------+-------+
*/

WITH cte1 AS (
    SELECT product_id, MAX(change_date) AS latest_date
    FROM products
    WHERE change_date <= '2019-08-16'
    GROUP BY 1
),

cte2 AS (
    SELECT *
    FROM products
    WHERE (product_id, change_date) IN (
        SELECT *
        FROM cte1
    )
)

SELECT DISTINCT a.product_id, IFNULL(b.new_price, 10) AS price
FROM products a
LEFT JOIN cte2 b
ON a.product_id = b.product_id;

