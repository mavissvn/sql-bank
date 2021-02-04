/* 618. Students Report By Geography | HARD

A U.S graduate school has students from Asia, Europe and America. The students' location information are stored in table student as below.
 

| name   | continent |
|--------|-----------|
| Jack   | America   |
| Pascal | Europe    |
| Xi     | Asia      |
| Jane   | America   |
 

Pivot the continent column in this table so that each name is sorted alphabetically and displayed underneath its corresponding continent. The output headers should be America, Asia and Europe respectively. It is guaranteed that the student number from America is no less than either Asia or Europe.
 

For the sample input, the output is:
 

| America | Asia | Europe |
|---------|------|--------|
| Jack    | Xi   | Pascal |
| Jane    |      |        |
 

Follow-up: If it is unknown which continent has the most students, can you write a query to generate the student report? */

WITH cte AS (
    SELECT *, ROW_NUMBER() OVER(PARTITION BY continent ORDER BY name) AS rn
    FROM student
)

SELECT 
MAX(CASE WHEN continent = 'America' THEN name END) AS America,
MAX(CASE WHEN continent = 'Asia' THEN name END) AS Asia,
MAX(CASE WHEN continent = 'Europe' THEN name END) AS Europe
FROM cte
GROUP BY rn;

/*

rn  America Asia Europe
 1   Jack     x     x
 1     x      x   Pascal 
 1     x      Xi    x
 2   Jane     x     x 

 this is the output before GROUPBY and MAX()

 why GROUPBY and MAX()? 

 1.break them to different group according to rn 

 2.use MAX() to get all non-null values out and gather them into one row as the requirement, since there is only ONE record per row per column in each group due to CASE WHEN condition, MIN() also works  

 it's a bit hard to understand in this case, but just try to think we are pull highest math score respectively for 2 classes

 in this case, 'the only name record' is 'the highest score' since it's the only record per row per column in each group

before:
class  math  english  age  height  weight
  1		98      97	   18	190	    200
  1    null    null    17   null    null
  2		95		99     19   185     170 
  2	   null     80    null  null    null

after:
 class math english age height weight
  1		98     97   18	 190	200
  2		95	   99   19   185    170 

*/