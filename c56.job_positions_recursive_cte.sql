--Day56: match job_employees with corresponding job_positions with respect to totalpost(ie. vacancies)
--we use concept of RECURSIVE CTE:

create table job_positions (id  int,
title varchar(30),
groups varchar(10),
levels varchar(10),     
payscale int, 
totalpost int );
insert into job_positions values (1, 'General manager', 'A', 'l-15', 10000, 1); 
insert into job_positions values (2, 'Manager', 'B', 'l-14', 9000, 5); 
insert into job_positions values (3, 'Asst. Manager', 'C', 'l-13', 8000, 10);  

create table job_employees ( id  int, 
name varchar(30),     
position_id  int 
);  
insert into job_employees values (1, 'John Smith', 1); 
insert into job_employees values (2, 'Jane Doe', 2);
insert into job_employees values (3, 'Michael Brown', 2);
insert into job_employees values (4, 'Emily Johnson', 2); 
insert into job_employees values (5, 'William Lee', 3); 
insert into job_employees values (6, 'Jessica Clark', 3); 
insert into job_employees values (7, 'Christopher Harris', 3);
insert into job_employees values (8, 'Olivia Wilson', 3);
insert into job_employees values (9, 'Daniel Martinez', 3);
insert into job_employees values (10, 'Sophia Miller', 3)

select *
from job_positions;

select *
from job_employees;

with cte as 
(
select id,title,groups,levels,payscale,totalpost,1 as rn from job_positions
union all
select id,title,groups,levels,payscale,totalpost,rn+1 from cte
where rn<totalpost
)
, emp as (
select *
, row_number() over (partition by position_id order by id) as rn
from job_employees
)

select c.*, coalesce(e.name,'vacant') as name
from cte c
left join emp e
on e.position_id=c.id  and e.rn=c.rn
order by c.id, c.rn;



--OR--
--can use an existing database (or) generate num_cte as below:
--instead of '16' it would be (select totalpost from job_positions) when doing with existing database
with num_cte as
(
select 1 as rn
union all
select rn+1 
from num_cte
where rn<16 
)
select rn from num_cte;

--then to expand job_positions table as below:
-- select *
-- from job_positions jp 
-- inner join num_cte nc on nc.rn <=totalpost
