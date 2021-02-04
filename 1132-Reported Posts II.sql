/* 1132. Reported Posts II | MEDIUM

Table: Actions

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| user_id       | int     |
| post_id       | int     |
| action_date   | date    |
| action        | enum    |
| extra         | varchar |
+---------------+---------+
There is no primary key for this table, it may have duplicate rows.
The action column is an ENUM type of ('view', 'like', 'reaction', 'comment', 'report', 'share').
The extra column has optional information about the action such as a reason for report or a type of reaction. 
Table: Removals

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| post_id       | int     |
| remove_date   | date    | 
+---------------+---------+
post_id is the primary key of this table.
Each row in this table indicates that some post was removed as a result of being reported or as a result of an admin review.
 

Write an SQL query to find the average for daily percentage of posts that got removed after being reported as spam, rounded to 2 decimal places.

The query result format is in the following example:

Actions table:
+---------+---------+-------------+--------+--------+
| user_id | post_id | action_date | action | extra  |
+---------+---------+-------------+--------+--------+
| 1       | 1       | 2019-07-01  | view   | null   |
| 1       | 1       | 2019-07-01  | like   | null   |
| 1       | 1       | 2019-07-01  | share  | null   |
| 2       | 2       | 2019-07-04  | view   | null   |
| 2       | 2       | 2019-07-04  | report | spam   |
| 3       | 4       | 2019-07-04  | view   | null   |
| 3       | 4       | 2019-07-04  | report | spam   |
| 4       | 3       | 2019-07-02  | view   | null   |
| 4       | 3       | 2019-07-02  | report | spam   |
| 5       | 2       | 2019-07-03  | view   | null   |
| 5       | 2       | 2019-07-03  | report | racism |
| 5       | 5       | 2019-07-03  | view   | null   |
| 5       | 5       | 2019-07-03  | report | racism |
+---------+---------+-------------+--------+--------+

Removals table:
+---------+-------------+
| post_id | remove_date |
+---------+-------------+
| 2       | 2019-07-20  |
| 3       | 2019-07-18  |
+---------+-------------+

Result table:
+-----------------------+
| average_daily_percent |
+-----------------------+
| 75.00                 |
+-----------------------+
The percentage for 2019-07-04 is 50% because only one post of two spam reported posts was removed.
The percentage for 2019-07-02 is 100% because one post was reported as spam and it was removed.
The other days had no spam reports so the average is (50 + 100) / 2 = 75%
Note that the output is only one number and that we do not care about the remove dates. */


WITH cte AS (
SELECT action_date, COUNT(DISTINCT b.post_id) / COUNT(DISTINCT a.post_id)* 100 AS average_daily_percent 
FROM actions a
LEFT JOIN removals b
ON a.post_id = b.post_id
WHERE a.extra = 'spam' 
GROUP BY 1
)

SELECT ROUND(AVG(average_daily_percent), 2) AS average_daily_percent
FROM cte;

/*
1. we cannot use SUM(IF extra = 'spam', 1, 0) as denominator, because there could be multiple reports from multiple users for a same post, this method cannot drop duplicates
2. here we use join on + where, not join on + and, below is the difference between on + where and on + and:

mysql> select * from a left join b on a.sid=b.sid and a.sid=1;
+----+-----+------+------+--------+
| id | sid | type | sid  | remark |
+----+-----+------+------+--------+
|  1 |   1 | a    |    1 | A      |
|  2 |   1 | b    |    1 | A      |
|  3 |   2 | c    | NULL | NULL   |
|  4 |   3 | d    | NULL | NULL   |
+----+-----+------+------+--------+
mysql> select * from a left join b on a.sid=b.sid where a.sid=1;
+----+-----+------+-----+--------+
| id | sid | type | sid | remark |
+----+-----+------+-----+--------+
|  1 |   1 | a    |   1 | A      |
|  2 |   1 | b    |   1 | A      |
+----+-----+------+-----+--------+

if we use on + and here, the denominator would double, the average_daily_percent we get would be 32.50 which is in correct

*/