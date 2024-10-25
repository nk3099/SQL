—Day3:
—write sql to find total no of people present inside the hospital

create table hospital ( emp_id int
, action varchar(10)
, time datetime);

insert into hospital values ('1', 'in', '2019-12-22 09:00:00');
insert into hospital values ('1', 'out', '2019-12-22 09:15:00');
insert into hospital values ('2', 'in', '2019-12-22 09:00:00');
insert into hospital values ('2', 'out', '2019-12-22 09:15:00');
insert into hospital values ('2', 'in', '2019-12-22 09:30:00');
insert into hospital values ('3', 'out', '2019-12-22 09:00:00');
insert into hospital values ('3', 'in', '2019-12-22 09:15:00');
insert into hospital values ('3', 'out', '2019-12-22 09:30:00');
insert into hospital values ('3', 'in', '2019-12-22 09:45:00');
insert into hospital values ('4', 'in', '2019-12-22 09:45:00');
insert into hospital values ('5', 'out', '2019-12-22 09:40:00');

select * from hospital;

-- 1-out, 2-in, 3-in, 4-in, 5-out => total : 3 are in hospital

with max_in_time as (
select emp_id,action,max(time) as intime
from hospital
where action='in'
group by emp_id,action
),max_out_time as(
select emp_id,action,max(time) as outtime
from hospital
where action='out'
group by emp_id,action)


select count(mi.intime)
from max_in_time mi
full outer join max_out_time mo on mi.emp_id=mo.emp_id
where intime > outtime or outtime is NULL;

--OR--
--if latest max_time and max_in_time are equivalent then employee was inside
with latest_time as (select emp_id,max(time) as max_latest_time 
from hospital
group by emp_id),
[latest-in-time] as (select emp_id,max(time) as max_in_time
from hospital
where action='in'
group by emp_id)

select count(lit.emp_id)
from latest_time lt
inner join [latest-in-time] lit on lt.emp_id=lit.emp_id
where max_latest_time=max_in_time


--OR--
select count(emp_id),
max(case
when action='in' then time
end) as intime,
max(case 
when action='out' then time
end) as outtime
from hospital
group by emp_id
having max(case when action='in' then time end)  > max(case when action='outtime' then time end) or max(case when action='outtime' then time end) is NULL


--NOTE: having intime > outtime or outtime is NULL
-- this would be wrong as order of execution of SQL:
--FROM, JOIN, WHERE, GROUP BY, HAVING, SELECT, DISTINCT, ORDER BY, and finally, LIMIT/OFFSET.
