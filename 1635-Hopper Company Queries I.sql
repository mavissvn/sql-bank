/* 1635. Hopper Company Queries I

Table: Drivers

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| driver_id   | int     |
| join_date   | date    |
+-------------+---------+
driver_id is the primary key for this table.
Each row of this table contains the driver's ID and the date they joined the Hopper company.
 

Table: Rides

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| ride_id      | int     |
| user_id      | int     |
| requested_at | date    |
+--------------+---------+
ride_id is the primary key for this table.
Each row of this table contains the ID of a ride, the user's ID that requested it, and the day they requested it.
There may be some ride requests in this table that were not accepted.
 

Table: AcceptedRides

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| ride_id       | int     |
| driver_id     | int     |
| ride_distance | int     |
| ride_duration | int     |
+---------------+---------+
ride_id is the primary key for this table.
Each row of this table contains some information about an accepted ride.
It is guaranteed that each accepted ride exists in the Rides table. */

WITH RECURSIVE cte1 AS (
    SELECT 1 AS month
    UNION
    SELECT month+1 AS month
    FROM cte1
    WHERE month < 12
),

cte2 AS (
    SELECT driver_id,
    CASE WHEN YEAR(join_date) <2020 THEN 1 ELSE MONTH(join_date) END AS month
    FROM drivers
    WHERE YEAR(join_date) < 2021
),

cte3 AS (
    SELECT MONTH(requested_at) AS month, a.ride_id
    FROM rides a
    JOIN AcceptedRides b
    ON a.ride_id = b.ride_id
    WHERE YEAR(requested_at) = 2020
)

SELECT a.month, COUNT(DISTINCT driver_id) AS active_drivers, COUNT(DISTINCT ride_id) AS accepted_rides 
FROM cte1 a
LEFT JOIN cte2 b
ON a.month >= b.month
LEFT JOIN cte3 c
ON a.month = c.month
GROUP BY 1
ORDER BY 1;