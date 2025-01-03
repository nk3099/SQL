--Day52: Hall Events pairing
--Leetcode Hard SQL: 2494. Merge Overlapping Events in the Same Hall

create table hall_events
(
hall_id integer,
start_date date,
end_date date
);
delete from hall_events
insert into hall_events values 
(1,'2023-01-13','2023-01-14')
,(1,'2023-01-14','2023-01-17')
,(1,'2023-01-15','2023-01-17')
,(1,'2023-01-18','2023-01-25')
,(2,'2022-12-09','2022-12-23')
,(2,'2022-12-13','2022-12-17')
,(3,'2022-12-01','2023-01-30');


select *
from hall_events;

with cte as (
select *
, lag (end_date,1,start_date) over (partition by hall_id order by start_date asc) as prev_date
from hall_events
)
, cte2 as (select *
,case when start_date<=prev_date then 0 else 1 end as flag
from cte
)

--select * from cte2;

select hall_id,
min(start_date) as start_date,max(end_date) as end_date
from cte2
group by hall_id,flag

/*
hall_id     start_date       end_date        
----------- ---------------- ----------------
          1       2023-01-13       2023-01-17
          2       2022-12-09       2022-12-23
          3       2022-12-01       2023-01-30
          1       2023-01-18       2023-01-25
*/
