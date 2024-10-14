Day19:  Spotify case study

--the activity table shows the app-installed and app purchase activities for spotify along with country deals

CREATE table activity
(
user_id varchar(20),
event_name varchar(20),
event_date date,
country varchar(20)
);
delete from activity;
insert into activity values (1,'app-installed','2022-01-01','India')
,(1,'app-purchase','2022-01-02','India')
,(2,'app-installed','2022-01-01','USA')
,(3,'app-installed','2022-01-01','USA')
,(3,'app-purchase','2022-01-03','USA')
,(4,'app-installed','2022-01-03','India')
,(4,'app-purchase','2022-01-03','India')
,(5,'app-installed','2022-01-03','SL')
,(5,'app-purchase','2022-01-03','SL')
,(6,'app-installed','2022-01-04','Pakistan')
,(6,'app-purchase','2022-01-04','Pakistan');

select * from activity;


/*Question 1: find total active users each day

event_date total_active_users
2022-01-01     3
2022-01-02     1
2022-01-03     3
2022-01-04      1

either user have app-installed or app-purchase will be considered as active user for that given day
*/

select event_date, count(distinct user_id) as total_active_users
from activity
group by event_date


/*Question 2: find total active users each week

week_number total_active_users
1                               3
2                               5
*/

select datepart(week,event_date) as week_number,count(distinct user_id) as total_active_users
from activity
group by datepart(week,event_date)

/*Question 3: date wise total number of users who made the purchase same day they installed the app

event_date    no_of_users_same_day_purchase
2022-01-01.         0
2022-01-02          0
2022-01-03          2
2022-01-04          1
*/


--BASE APPROACH:
-- select user_id,event_date,count(distinct event_name) as no_of_events
-- from activity
-- group by user_id,event_date
-- having count(distinct event_name)=2

/*if we add this in WHERE clause: 
ie. where count(distinct event_name)=2

gives error:
Msg 147, Level 15, State 1, Server 06e272e73211, Line 67
An aggregate may not appear in the WHERE clause unless 
it is in a subquery contained in a HAVING clause or a select list, 
and the column being aggregated is an outer reference.
*/

--INTERMEDIATE:
select event_date, count(user_id) as no_of_users_same_day_purchase
from
(select user_id,event_date,count(distinct event_name) as no_of_events
from activity
group by user_id,event_date
having count(distinct event_name)=2) A
group by event_date

--But this doesn't give us the no_of_users_same_day_purchase for 2022-01-01 And 2022-01-02 as should be 0

--Therefore,
--1. We can left join above query with a table having all event_date
--2. use case stmt (and remove having clause filter as restricts the output to users who did both activities)

---FINAL SOLUTION:

-- select user_id,event_date, --count(distinct event_name) as no_of_events
-- case 
-- when count(distinct event_name)=2 then user_id else null
-- end as new_user
-- from activity
-- group by user_id,event_date

select event_date, count(new_user) as no_of_users_same_day_purchase
from
(select user_id,event_date, --count(distinct event_name) as no_of_events
case 
when count(distinct event_name)=2 then user_id else null
end as new_user
from activity
group by user_id,event_date) A
group by event_date




/*Question 4: percentage of paid users in India, USA and any other country should be tagged as others

Country.     percentage_users
India.              40
USA                 20
Others              40
*/


-- with country_users as 
-- (
-- select case when country in ('USA','India') then country else 'Others' end as new_country, count(distinct user_id) as user_cnt
-- from activity
-- where event_name='app-purchase'
-- group by case when country in ('USA','India') then country else 'Others' end)
-- ,total as 
-- (select sum(user_cnt) as total_users from country_users)
-- select new_country,user_cnt*1.0/total_users *100 as percentage_users
-- from country_users,total    --CROSS JOIN applied.


/*Question 5: Among all the users who installed the app on a given day, how many did in app purchased on the very next day—day wise result

event_date  cnt_users
2022-01-01.   0
2022-01-02.   1
2022-01-03.   1
2022-01-04.   0
*/


with prev_data as
(select *,
lag(event_name,1) over(partition by user_id order by event_date asc) as prev_event_name,
lag(event_date,1) over (partition by user_id order by event_date asc) as prev_event_date
from activity)

-- select event_date,count(distinct user_id) as users
-- from prev_data
-- where event_name='app-purchase' and prev_event_name='app-installed'
-- and datediff(day,prev_event_date,event_date)=1
-- group by event_date

select event_date,
count(case when event_name='app-purchase' and prev_event_name='app-installed' and datediff(day,prev_event_date,event_date)=1 then user_id else null end) as user_cnt
from prev_data
group by event_date
