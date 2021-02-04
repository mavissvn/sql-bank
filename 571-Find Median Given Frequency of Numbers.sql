/* 571. Find Median Given Frequency of Numbers | HARD

The Numbers table keeps the value of number and its frequency.

+----------+-------------+
|  Number  |  Frequency  |
+----------+-------------|
|  0       |  7          |
|  1       |  1          |
|  2       |  3          |
|  3       |  1          |
+----------+-------------+
In this table, the numbers are 0, 0, 0, 0, 0, 0, 0, 1, 2, 2, 2, 3, so the median is (0 + 0) / 2 = 0.

+--------+
| median |
+--------|
| 0.0000 |
+--------+
Write a query to find the median of all numbers and name the result as median. */


WITH cte1 AS (
    SELECT CEIL(SUM(Frequency)/2) AS limit1, #these 2 limits are omnipotent ways to get the indexes of the median relevant values
    CEIL(SUM(Frequency)/2 + 0.5) AS limit2 #e.g. for even, 1234, it brings 2 and 3; for odd, 12345, it brings 3 and 3; and then AVG() the values of each index to get the true median
    FROM Numbers
),

cte2 AS (
    SELECT *, SUM(Frequency) OVER(ORDER BY Number ASC) AS cum_fre
    FROM Numbers
),

cte3 AS (
    (SELECT Number
     FROM cte2
     WHERE cum_fre >= (SELECT limit1 FROM cte1) LIMIT 1)
    UNION
    (SELECT Number
     FROM cte2
     WHERE cum_fre >= (SELECT limit2 FROM cte1) LIMIT 1)
)

SELECT AVG(Number) AS median
FROM cte3;