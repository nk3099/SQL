Day14: prime_subscription_for_product

--prime subscription rate by product action
/*Given the following two tables, return the fraction of users, 
rounded to two decimal places, who accessed Amazon music 
and upgraded to prime membership within the first 30 days of signing up*/

create table users
(
user_id integer,
name varchar(20),
join_date date
);
insert into users
values (1, 'Jon', CAST('2-14-20' AS date)), 
(2, 'Jane', CAST('2-14-20' AS date)), 
(3, 'Jill', CAST('2-15-20' AS date)), 
(4, 'Josh', CAST('2-15-20' AS date)), 
(5, 'Jean', CAST('2-16-20' AS date)), 
(6, 'Justin', CAST('2-17-20' AS date)),
(7, 'Jeremy', CAST('2-18-20' AS date));

create table events
(
user_id integer,
type varchar(10),
access_date date
);

insert into events values
(1, 'Pay', CAST('3-1-20' AS date)), 
(2, 'Music', CAST('3-2-20' AS date)), 
(2, 'P', CAST('3-12-20' AS date)),
(3, 'Music', CAST('3-15-20' AS date)), 
(4, 'Music', CAST('3-15-20' AS date)), 
(1, 'P', CAST('3-16-20' AS date)), 
(3, 'P', CAST('3-22-20' AS date));



select * from users;
select * from events;


select --u.*,e.type,e.access_date,datediff(day,u.join_date,e.access_date) as difference
count(distinct u.user_id) as total_users,
count( distinct case
 when datediff(day,u.join_date,e.access_date)<=30 then u.user_id 
end) as prime_members,
1.0*count( distinct case
 when datediff(day,u.join_date,e.access_date)<=30 then u.user_id 
end) / count(distinct u.user_id) * 100 as ratio 
from users u
left join events e ON u.user_id=e.user_id and e.type='P'
where u.user_id IN (select user_id from events where type='music')

--OR--

select
sum(case when type = 'P' and 
          datediff(day,join_date,access_date) <=30 then 1 else 0 end)*1.0/sum(case when type = 'Music' then 1 else 0 end) as ratio
from users a join events b
on a.user_id = b.user_id


