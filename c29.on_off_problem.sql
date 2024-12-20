Day 29: ON_OFF Problem

create table event_status
(
event_time varchar(10),
status varchar(10)
);
insert into event_status 
values
('10:01','on'),('10:02','on'),('10:03','on'),('10:04','off'),('10:07','on'),('10:08','on'),('10:09','off')
,('10:11','on'),('10:12','off');

select * from event_status;


with cte as (select *, 
lag(status,1,status) over (order by event_time) as prev_status
from event_status)
,grouped_cte as (select *,
sum(case when status='on' and prev_status='off' then 1 else 0 end) over (order by event_time) as group_key
from cte)

select min(event_time) as login, max(event_time) as logout, count(*)-1  as on_count --as we want 'on' status count itself.
from grouped_cte
group by group_key
