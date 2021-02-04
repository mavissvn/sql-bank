/* 1225. Report Contiguous Dates
Table: Failed

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| fail_date    | date    |
+--------------+---------+
Primary key for this table is fail_date.
Failed table contains the days of failed tasks.
Table: Succeeded

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| success_date | date    |
+--------------+---------+
Primary key for this table is success_date.
Succeeded table contains the days of succeeded tasks.
 

A system is running one task every day. Every task is independent of the previous tasks. The tasks can fail or succeed.

Write an SQL query to generate a report of period_state for each continuous interval of days in the period from 2019-01-01 to 2019-12-31.

period_state is 'failed' if tasks in this interval failed or 'succeeded' if tasks in this interval succeeded. Interval of days are retrieved as start_date and end_date.

Order result by start_date.

The query result format is in the following example:

Failed table:
+-------------------+
| fail_date         |
+-------------------+
| 2018-12-28        |
| 2018-12-29        |
| 2019-01-04        |
| 2019-01-05        |
+-------------------+

Succeeded table:
+-------------------+
| success_date      |
+-------------------+
| 2018-12-30        |
| 2018-12-31        |
| 2019-01-01        |
| 2019-01-02        |
| 2019-01-03        |
| 2019-01-06        |
+-------------------+


Result table:
+--------------+--------------+--------------+
| period_state | start_date   | end_date     |
+--------------+--------------+--------------+
| succeeded    | 2019-01-01   | 2019-01-03   |
| failed       | 2019-01-04   | 2019-01-05   |
| succeeded    | 2019-01-06   | 2019-01-06   |
+--------------+--------------+--------------+

The report ignored the system state in 2018 as we care about the system in the period 2019-01-01 to 2019-12-31.
From 2019-01-01 to 2019-01-03 all tasks succeeded and the system state was "succeeded".
From 2019-01-04 to 2019-01-05 all tasks failed and system state was "failed".
From 2019-01-06 to 2019-01-06 all tasks succeeded and system state was "succeeded". */

WITH cte1 AS (
    SELECT fail_date AS `date`, 'failed' AS `status`, ROW_NUMBER() OVER(ORDER BY fail_date) AS rn
    FROM failed
    WHERE fail_date BETWEEN '2019-01-01' AND '2019-12-31'
    UNION
    SELECT success_date AS `date`, 'succeeded' AS status, ROW_NUMBER() OVER(ORDER BY success_date) AS rn
    FROM succeeded
    WHERE success_date BETWEEN '2019-01-01' AND '2019-12-31'
),

cte2 AS (
    SELECT *, 
    ROW_NUMBER() OVER(ORDER BY `date` ASC) AS total_rn,
    (ROW_NUMBER() OVER(ORDER BY `date` ASC) - rn) AS `interval`
    FROM cte1
)

SELECT `status` AS period_state, MIN(`date`) AS start_date, MAX(`date`) AS end_date
FROM cte2
GROUP BY `status`, `interval`
ORDER BY 2;

/*
why group by status & interval works?
because there is no duplicate combination of status and interval, the interval under same status will only increase due to the increaseing amount of other status date added
e.g everytime the succcess inverval will be added the amount of the last failed date 

  date | total_rn| status  | rn| interval
| 2019-01-01 | 1 | success | 1 | 0  this 0 comes from nothing is infront of this
| 2019-01-02 | 2 | success | 2 | 0
| 2019-01-03 | 3 | success | 3 | 0
| 2019-01-04 | 4 | fail    | 1 | 3  this 3 comes from the last 3 success date
| 2019-01-05 | 5 | fail    | 2 | 3
| 2019-01-06 | 6 | success | 4 | 2  this 2 comes from the last 2 fail date
| 2019-01-07 | 7 | success | 5 | 2
| 2019-01-08 | 8 | fail    | 3 | 5  this 5 comes from the last (3+2) sucess date
| 2019-01-09 | 9 | fail    | 4 | 5

*/