Day17: second_most_recent_activity

--get the second most recent activity, if there is only one activity then return that

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

with second_activity as (select *,
count(1) over (partition by username) as cnt,
rank() over (partition by username order by startDate desc) as rnk
from UserActivity)

select *
from second_activity
where cnt=1 or rnk=2
--where (cnt=1 and rnk=1) or (cnt>1 and rnk=2)


