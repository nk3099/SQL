
--day77. find total no. of sessions 

create table events 
(userid int , 
event_type varchar(20),
event_time datetime);

insert into events VALUES (1, 'click', '2023-09-10 09:00:00');
insert into events VALUES (1, 'click', '2023-09-10 10:00:00');
insert into events VALUES (1, 'scroll', '2023-09-10 10:20:00');
insert into events VALUES (1, 'click', '2023-09-10 10:50:00');
insert into events VALUES (1, 'scroll', '2023-09-10 11:40:00');
insert into events VALUES (1, 'click', '2023-09-10 12:40:00');
insert into events VALUES (1, 'scroll', '2023-09-10 12:50:00');
insert into events VALUES (2, 'click', '2023-09-10 09:00:00');
insert into events VALUES (2, 'scroll', '2023-09-10 09:20:00');
insert into events VALUES (2, 'click', '2023-09-10 10:30:00');


select * from events;

--we need to find time difference between event_time of consecutive events.

with cte as 
(
select *
, lag(event_time,1,event_time) over (partition by userid order by event_time) as prev_event
, datediff(minute,lag(event_time,1,event_time) over (partition by userid order by event_time), event_time) as time_diff
--, case when datediff(minute,event_time,lag(event_time) over (partition by userid order by event_time))=30 then 1 else 0 end as inter
from events
)
,cte2 as 
(
select *
, case when time_diff<=30 then 0 else 1 end as flag
, sum(case when time_diff<=30 then 0 else 1 end) over (partition by userid order by event_time) as session_grp
from cte
)

select userid,session_grp+1 as session_id
, min(event_time) as session_start_time
, max(event_time) as session_end_time
, count(*) as no_of_events
, datediff(minute,min(event_time),max(event_time))as session_duration
from cte2
group by userid,session_grp
order by userid,session_grp
