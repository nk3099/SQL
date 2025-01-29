--day72. Acies global interview question 
/*
we have a swipe table which keeps track of employee login and logout timings. 
1.Find out the time employee person spent in office on a particular day
(office hours = last logout time - first login time)

2.Find out how productive he was at office on a particular day. 
(He might have done many swipes per day. I need to find the actual time spent at office)
*/

CREATE TABLE swipe (
    employee_id INT,
    activity_type VARCHAR(10),
    activity_time datetime
);

-- Insert sample data
INSERT INTO swipe (employee_id, activity_type, activity_time) VALUES
(1, 'login', '2024-07-23 08:00:00'),
(1, 'logout', '2024-07-23 12:00:00'),
(1, 'login', '2024-07-23 13:00:00'),
(1, 'logout', '2024-07-23 17:00:00'),
(2, 'login', '2024-07-23 09:00:00'),
(2, 'logout', '2024-07-23 11:00:00'),
(2, 'login', '2024-07-23 12:00:00'),
(2, 'logout', '2024-07-23 15:00:00'),
(1, 'login', '2024-07-24 08:30:00'),
(1, 'logout', '2024-07-24 12:30:00'),
(2, 'login', '2024-07-24 09:30:00'),
(2, 'logout', '2024-07-24 10:30:00');

select * from swipe;

/*
Please note:
could lead to wrong results if across the months:
as gives activity_day as 23, 24, 25...so on

select  *
, day(activity_time) as acitivity_day
, lead(activity_time,1) over (partition by employee_id, day(activity_time) order by activity_time) as logout_time
from swipe

Therefore:
casting timestamp to date format as below:
which results in activity_day as 2024-07-23, 2024-07-24, 2024-07-25.. so on

*/

-- with cte as (
-- select  *
-- , cast(activity_time as date) as activity_day
-- , lead(activity_time,1) over (partition by employee_id, cast(activity_time as date) order by activity_time) as logout_time
-- from swipe
-- )

-- select employee_id, activity_day, activity_time as login_time, logout_time
-- from cte
-- where activity_type='login'


with cte as (
select  *
, cast(activity_time as date) as activity_day
, lead(activity_time,1) over (partition by employee_id, cast(activity_time as date) order by activity_time) as logout_time
from swipe
)

select employee_id,activity_day,
datediff(hour,min(activity_time), max(logout_time)) as total_hrs,
sum(datediff(hour, activity_time, logout_time)) as productive_hrs
from cte
where activity_type='login'
group by employee_id, activity_day


/*sum(datediff(hour, activity_time, logout_time)) as productive_hrs
means:
datediff(hour, activity_time, logout_time) at each row level
and then doing aggregation
i.e. sum( datediff(hour, activity_time, logout_time) ) to get the productive_hrs
*/

