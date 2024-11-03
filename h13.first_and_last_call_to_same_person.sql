--Day14: A company wants to hire new employees. The budget of the company for the salaries is $70000. 
--The company's criteria for hiring are: 
--keep hiring the senior with the smallest salary until you cannot hire any more seniors. 
--Use the remaining budget to hire the junior with the smallest salary. 
--keep hiring the junior with the smallest salary until you cannot hire any more juniors. 
--Write an SQL query to find the seniors and juniors hired under the mentioned criteria.


create table candidates (
emp_id int,
experience varchar(20),
salary int
);
delete from candidates;
insert into candidates values
(1,'Junior',10000),(2,'Junior',15000),(3,'Junior',40000),(4,'Senior',16000),(5,'Senior',20000),(6,'Senior',50000);

select * 
from candidates;

--if salary duplicates, then could be issue - therefore:

with total_sal as 
(
select *,
sum(salary) over (partition by experience order by salary asc rows between unbounded preceding and current row) as running_salary
from candidates
)
,seniors as 
(
select *
from total_sal
where experience='senior' and running_salary<=70000
)


select *
from total_sal
where experience='junior' and running_salary<=70000 - (select sum(salary) from seniors)
union all 
select * from seniors






/*WITH DUPLICATE SALARY:
emp_id      experience           salary     
----------- -------------------- -----------
          1 Junior                     10000
          2 Junior                     15000
          7 Junior                     10000
          3 Junior                     40000
          4 Senior                     16000
          5 Senior                     20000
          6 Senior                     50000
          


select *,
sum(salary) over (partition by experience order by salary asc rows between unbounded preceding and current row) as running_salary
from candidates

emp_id      experience           salary      running_salary
----------- -------------------- ----------- --------------
          7 Junior                     10000          10000
          1 Junior                     10000          20000
          2 Junior                     15000          35000
          3 Junior                     40000          75000
          4 Senior                     16000          16000
          5 Senior                     20000          36000
          6 Senior                     50000          86000
          
select *,
sum(salary) over (partition by experience order by salary asc) as running_salary
from candidates

emp_id      experience           salary      running_salary
----------- -------------------- ----------- --------------
          7 Junior                     10000          20000
          1 Junior                     10000          20000
          2 Junior                     15000          35000
          3 Junior                     40000          75000
          4 Senior                     16000          16000
          5 Senior                     20000          36000
          6 Senior                     50000          86000
          
*/
