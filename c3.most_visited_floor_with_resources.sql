Day3: most_visited_floor_with_resources

create table entries ( 
name varchar(20),
address varchar(20),
email varchar(20),
floor int,
resources varchar(10));

insert into entries 
values ('A','Bangalore','A@gmail.com',1,'CPU'),('A','Bangalore','A1@gmail.com',1,'CPU'),('A','Bangalore','A2@gmail.com',2,'DESKTOP')
,('B','Bangalore','B@gmail.com',2,'DESKTOP'),('B','Bangalore','B1@gmail.com',2,'DESKTOP'),('B','Bangalore','B2@gmail.com',1,'MONITOR')


select * from entries;
--output: name,total_visits,most_visited_floor,resources_used

with distinct_resources as(select distinct name, resources from entries)
,agg_resources as (select name, string_agg(resources,',') as resources_used from distinct_resources group by name)
,total_visits as(select name,count(*) as total_visits,string_agg(resources,',') as resources_used
from entries group by name)
,floor_visit as(select name,floor,count(*) as visits,
rank() over (partition by name
order by count(*) desc) as rnk
from entries
group by name,floor)
select fv.name, fv.floor as most_visited_floor,tv.total_visits,ar.resources_used
from floor_visit fv
inner join total_visits tv ON tv.name=fv.name
inner join agg_resources ar ON ar.name=fv.name
where rnk=1
