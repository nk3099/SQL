--Rishasbh Mishra SQL

--Q1) List all team matches between teams, if matches are played once:
CREATE TABLE match ( team varchar(20) ) 
INSERT INTO match (team) VALUES ('India'), ('Pak'), ('Aus'), ('Eng')

select * from match;

--As 4 team => total matches=6 by permutation & combination (4C2)

with cte as 
(
select *
, row_number() over (order by team asc) as id
from match
)
select *
from cte a
join cte b  on a.team<>b.team
where a.id<b.id;


--Q2) Write Query to output:

--NOTE: NTILE window function used to divide into groups

CREATE TABLE emp ( ID int, NAME varchar(10) ) 
INSERT INTO emp (ID, NAME) 
VALUES (1,'Emp1'), (2,'Emp2'), (3,'Emp3'), (4,'Emp4'), 
(5,'Emp5'), (6,'Emp6'), (7,'Emp7'), (8,'Emp8')

select * from emp;


with cte as 
(
select *
, concat(id,' ',name) as con  
, NTILE(4) over (order by id asc) as groups
from emp
)

select STRING_AGG(con, ', ') as result
,groups
from cte
group by groups
order by groups
