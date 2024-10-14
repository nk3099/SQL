Day20: 3_or_more_consecutive_empty_seats
/*
method1 -- lead lag
method 2 -- advance aggregation
method 3 -- analytical row number function
*/

create table bms (seat_no int ,is_empty varchar(10));
insert into bms values
(1,'N')
,(2,'Y')
,(3,'N')
,(4,'Y')
,(5,'Y')
,(6,'Y')
,(7,'N')
,(8,'Y')
,(9,'Y')
,(10,'Y')
,(11,'Y')
,(12,'N')
,(13,'Y')
,(14,'Y');

select * from bms;

------------------------
--method1 -- lead lag
------------------------

-- with cte as
-- (
-- select *,
-- lead(is_empty,1) over(order by seat_no) as lead1,
-- lead(is_empty,2) over(order by seat_no) as lead2
-- from bms
-- )

-- select seat_no
-- from cte 
-- where is_empty='Y' and lead1='Y' and lead2='Y'
-- union 
-- select seat_no+1
-- from cte 
-- where is_empty='Y' and lead1='Y' and lead2='Y'
-- union
-- select seat_no+2
-- from cte 
-- where is_empty='Y' and lead1='Y' and lead2='Y'

---------
--OR--
---------

--3 conditions to check when on current seat_no:
--a)prev 2 are is_empty (or)
--b)next 2 are is_empty (or)
--c)prev 1 and next 1 are is_empty 

-- with cte as (select *,
-- lag(is_empty,1) over (order by seat_no) as prev_1,
-- lag(is_empty,2) over (order by seat_no) as prev_2,
-- lead(is_empty,1) over(order by seat_no) as next_1,
-- lead(is_empty,2) over(order by seat_no) as next_2
-- from bms)

-- select seat_no
-- from cte
-- where(is_empty='Y' and prev_1='Y' and prev_2='Y') or 
-- (is_empty='Y' and prev_1='Y' and next_1='Y') or
-- (is_empty='Y' and next_1='Y' and next_2='Y')


----------------------------------------
--method 2 -- advance aggregation
----------------------------------------

-- select *,
-- sum(case when is_empty='Y' then 1 else 0 end) over (order by seat_no rows between 2 preceding and current row) as prev_2,
-- sum(case when is_empty='Y' then 1 else 0 end) over (order by seat_no rows between 1 preceding and 1 following) as prev_next_1,
-- sum(case when is_empty='Y' then 1 else 0 end) over (order by seat_no rows between current row and 2 following) as next_2
-- from bms

select seat_no from
(
select *,
sum(case when is_empty='Y' then 1 else 0 end) over (order by seat_no rows between 2 preceding and current row) as prev_2,
sum(case when is_empty='Y' then 1 else 0 end) over (order by seat_no rows between 1 preceding and 1 following) as prev_next_1,
sum(case when is_empty='Y' then 1 else 0 end) over (order by seat_no rows between current row and 2 following) as next_2
from bms
)A
where prev_2=3 or prev_next_1=3 or next_2=3;


--------------------------------------------------
--method 3 -- analytical row number function
--------------------------------------------------

--if is_empty='Y' seats are continuous then row_number()-seat_no would be same

with diff_num as
(
select *,
row_number() over (order by seat_no) as row_num,
seat_no - row_number() over (order by seat_no) as diff
from bms
where is_empty='Y'
)
,cnt as 
(
select diff,count(1) as count
from diff_num
group by diff
having count(1) >=3
)

select * 
from diff_num
where diff in (select diff from cnt)
