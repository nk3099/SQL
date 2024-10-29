-- Day 5:  Get the second most recent activity, if there is only one activity then return that one

create table UserActivity
(
username      varchar(20) ,
activity      varchar(20),
startDate     Date   ,
endDate      Date
);

insert into UserActivity values 
('Alice','Travel','2020-02-12','2020-02-20')
,('Alice','Dancing','2020-02-21','2020-02-23')
,('Alice','Travel','2020-02-24','2020-02-28')
,('Bob','Travel','2020-02-11','2020-02-18');

select * from UserActivity;

select *
from
(
select *,
rank() over (partition by username order by endDate desc) as rnk,
count(1) over (partition by username) as cnt
from UserActivity
) A 
where cnt=1 or rnk=2
