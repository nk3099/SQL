
Day24: both_languages

--find companies who have atleast 2 users who speak English and German - Both the languages

create table company_users 
(
company_id int,
user_id int,
language varchar(20)
);

insert into company_users values (1,1,'English')
,(1,1,'German')
,(1,2,'English')
,(1,3,'German')
,(1,3,'English')
,(1,4,'English')
,(2,5,'English')
,(2,5,'German')
,(2,5,'Spanish')
,(2,6,'German')
,(2,6,'Spanish')
,(2,7,'English');

select * from company_users;


select company_id,count(1) as total_users
from
(
select company_id,user_id --,count(1) as cnt --,count(1)  #here, count(1) not required as have put in inner query HAVING clause.
from company_users
where language IN ('English','German')
group by company_id,user_id
having count(*)=2
) A 
group by company_id
having count(1)>=2

