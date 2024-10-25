Day11: highest_lowest_salary_in_each_dept
  
create table employee 
(
emp_name varchar(10),
dep_id int,
salary int
);
delete from employee;
insert into employee values 
('Siva',1,30000),('Ravi',2,40000),('Prasad',1,50000),('Sai',2,20000),('neeraj',1,50000)

select * from employee;

with deptsalary as (select *,
dense_rank() over (partition by dep_id order by salary desc) as rnk_desc,
dense_rank() over (partition by dep_id order by salary asc) as rnk_asc
from employee
),deptcount as (
select dep_id,count(dep_id) as cnt
from employee
group by dep_id)

select ds.dep_id,
max(case 
when ds.rnk_desc=1 then ds.emp_name else null
end) as emp_max_salary,
min(case
when ds.rnk_asc=1 then ds.emp_name else null
end) as emp_min_salary
from deptsalary ds
join deptcount dc on ds.dep_id=dc.dep_id
group by ds.dep_id

--OR--

with deptsalary as(
select dep_id,max(salary) as maxi, min(salary) as mini
from employee
group by dep_id)
select e.dep_id,
max(case
when salary=maxi then e.emp_name else null 
end) as max_emp_salary,
max(case
when salary=mini then e.emp_name else null
end) as min_emp_salary
from employee e
inner join deptsalary ds on e.dep_id=ds.dep_id
group by e.dep_id

--OR-- 
-- using STRING_AGG in MS-SQL-Server / GROUP_CONCAT in MS-SQL-Server

with deptsalary as(
select dep_id,max(salary) as maxi, min(salary) as mini
from employee
group by dep_id
)
select e.dep_id,
string_agg(case when e.salary=ds.maxi then e.emp_name end, ',') as max_emp_salary,
string_agg(case when e.salary=ds.mini then e.emp_name end, ',') as min_emp_salary
from employee e
inner join deptsalary ds on e.dep_id=ds.dep_id
group by e.dep_id


