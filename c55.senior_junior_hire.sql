
--Day55: --an organization looking to hire employees for their junior & senior positions. 
--they have a total limit of 50000$, and have to first fill up seniro positions and then juniors.

Create table candidates(
id int primary key,
positions varchar(10) not null,
salary int not null);

--test case 1:
insert into candidates values(1,'junior',5000);
insert into candidates values(2,'junior',7000);
insert into candidates values(3,'junior',7000);
insert into candidates values(4,'senior',10000);
insert into candidates values(5,'senior',30000);
insert into candidates values(6,'senior',20000);

--test case 2:
-- insert into candidates values(20,'junior',10000);
-- insert into candidates values(30,'senior',15000);
-- insert into candidates values(40,'senior',30000);

--test case 3:
-- insert into candidates values(1,'junior',15000);
-- insert into candidates values(2,'junior',15000);
-- insert into candidates values(3,'junior',20000);
-- insert into candidates values(4,'senior',60000);

--test case 4:
-- insert into candidates values(10,'junior',10000);
-- insert into candidates values(40,'junior',10000);
-- insert into candidates values(20,'senior',15000);
-- insert into candidates values(30,'senior',30000);
-- insert into candidates values(50,'senior',15000);

select * from candidates;


-- select *
-- , sum(salary) over (partition by positions order by salary asc) as running_salary
-- from candidates;
--as while calculating running_salary - we had duplicate salary, 
/*
id          positions  salary      running_salary
----------- ---------- ----------- --------------
          1 junior            5000           5000
          2 junior            7000          19000
          3 junior            7000          19000
*/
          
--so to avoid that we order again by 'id'

/*
id          positions  salary      running_salary
----------- ---------- ----------- --------------
          1 junior            5000           5000
          2 junior            7000          12000
          3 junior            7000          19000
*/


--Solution--
with running_cte as (
select *
, sum(salary) over (partition by positions order by salary asc) as running_salary
from candidates
)
, senior_cte as (
select count(*) as seniors, sum(salary) as senior_salary
from running_cte
where positions='senior'
and running_salary <= 50000
)
, junior_cte as (
select count(*) as juniors
from running_cte
where positions = 'junior'
and running_salary <= 50000 - (select senior_salary from senior_cte)
)
 
select seniors, juniors
from senior_cte, junior_cte


--Now, if to check testcase-2: ----
delete from candidates;

insert into candidates values(20,'junior',10000);
insert into candidates values(30,'senior',15000);
insert into candidates values(40,'senior',30000);

---Solution(as above)---

with running_cte as (
select *
, sum(salary) over (partition by positions order by salary asc) as running_salary
from candidates
)
, senior_cte as (
select count(*) as seniors, sum(salary) as senior_salary
from running_cte
where positions='senior'
and running_salary <= 50000
)
, junior_cte as (
select count(*) as juniors
from running_cte
where positions = 'junior'
and running_salary <= 50000 - (select senior_salary from senior_cte)
)
 
select seniors, juniors
from senior_cte, junior_cte


---------------------------------------------------------------------------------
----------------------------NULL HANDLING (as testcase-3)------------------------
---------------------------------------------------------------------------------

--As we know, NULL cannot be compared with anything ----
delete from candidates;

insert into candidates values(1,'junior',15000);
insert into candidates values(2,'junior',15000);
insert into candidates values(3,'junior',20000);
insert into candidates values(4,'senior',60000);


with running_cte as (
select *
, sum(salary) over (partition by positions order by salary asc) as running_salary
from candidates
)
, senior_cte as (
select count(*) as seniors, sum(salary) as senior_salary
from running_cte
where positions='senior'
and running_salary <= 50000
)

select * from senior_cte


/* seniors     senior_salary
 ----------- -------------
           0          NULL

This results in senior_salary as NULL, as no matching senior for 50k
But, then this causes a problem, when we do following in junior_cte:
"running_salary <= 50000 - (select senior_salary from senior_cte)" 

and outputs (which is wrong):
seniors     juniors    
----------- -----------
          0           0
          
          
Therefore, we need to handle this NULL case scenario, 
thereby changing code:
*/

with running_cte as (
select *
, sum(salary) over (partition by positions order by salary asc) as running_salary
from candidates
)
, senior_cte as (
select count(*) as seniors, coalesce(sum(salary),0) as senior_salary
from running_cte
where positions='senior'
and running_salary <= 50000
)
/*
select * from senior_cte

seniors     senior_salary
----------- -------------
          0             0
*/

, junior_cte as (
select count(*) as juniors
from running_cte
where positions = 'junior'
and running_salary <= 50000 - (select senior_salary from senior_cte)
)
 
select seniors, juniors
from senior_cte, junior_cte

--Output (this is correct)--
/*seniors     juniors    
 ----------- -----------
         0           3
*/

---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
