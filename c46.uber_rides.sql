--Day46: Uber rides
--write a query to print total rides and profit rides for each driver
--profit ride is when the end location of current ride is same as start location of next ride.

create table drivers(id varchar(10), start_time time, end_time time, start_loc varchar(10), end_loc varchar(10));
insert into drivers values('dri_1', '09:00', '09:30', 'a','b'),('dri_1', '09:30', '10:30', 'b','c'),('dri_1','11:00','11:30', 'd','e');
insert into drivers values('dri_1', '12:00', '12:30', 'f','g'),('dri_1', '13:30', '14:30', 'c','h');
insert into drivers values('dri_2', '12:15', '12:30', 'f','g'),('dri_2', '13:30', '14:30', 'c','h');

select * from drivers;

--1.lead function window

-- with cte as
-- (
-- select id,start_loc,end_loc, 
-- lead(start_loc,1) over (partition by id order by start_time asc) as next_start_loc
-- from drivers
-- )
-- select count(1) as total_rides, 
-- sum(case when end_loc=next_start_loc then 1 else 0 end) as profit_rides
-- from cte
-- group by id


--2.self join

with rides as 
(select *,
row_number() over (partition by id order by start_time) as rn
from drivers) 

select r1.id, count(1) as total_rides,
count(r2.id) as profit_rides
from rides r1
left join rides r2 
on r1.id = r2.id and r1.end_loc=r2.start_loc and r1.rn+1=r2.rn
group by r1.id

--to check consecutive rows (row_number() used with condiditon r1.rn+1=r2.rn)
--and left join as we need total_rides count also.
