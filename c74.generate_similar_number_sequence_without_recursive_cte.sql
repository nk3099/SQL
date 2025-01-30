--day74.question is you have a table named A where the input is 1 2 3 4 5 
-- then you need to get output in following format: 
-- 1 2 2 3 3 3 4 4 4 4 5 5 5 5 5 
--please note: can use recursive cte.

create table numbers (n int);
insert into numbers values (1),(2),(3),(4),(5)
insert into numbers values (9)

select * from numbers;

--with recursive cte:
--works good with new_insert(9) also.
with cte as (
select n,1 as num_count from numbers
union all
select n, num_count+1 as num_count from cte
where num_count+1 <= n
)
select * from cte
order by n;

--OR--
--note: But this below approach would fail if new_insert(9) as 
--there are only 6rows in the table so would generate max 6 instances of number '9'

select n1.n, n2.n
from numbers n1 
inner join numbers n2 on 1=1
where n1.n >= n2.n 
order by n1.n, n2.n
--or--
--cross join:
select n1.n, n2.n
from numbers n1 
cross join numbers n2 
where n1.n >= n2.n 
order by n1.n, n2.n
--or--
select n1.n, n2.n
from numbers n1 
inner join numbers n2 on n1.n >= n2.n
order by n1.n, n2.n;

--Therefore, 2 ways solving this:
--1.we can do hybrid approach of recursive CTE & join. 
--ie. pick max number form 'numbers' table and generate that many rows of table using recursive CTE

--here, generating rows till max number (which here was '9')
with cte as (
select MAX(n) as n from numbers
union all
select n-1 as n from cte 
where n-1>=1)

select n1.n, n2.n
from numbers n1 
inner join cte n2 on n1.n >= n2.n
order by n1.n, n2.n;

--2.whatever max number in 'numbers' table 
-- pick any other exisiting table that should have rows greater than this max number 
-- and then apply the join like above on similar condition.

