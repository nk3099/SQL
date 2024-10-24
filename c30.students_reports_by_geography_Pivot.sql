Day 30: student reports by geography (PIVOT)

create table players_location
(
name varchar(20),
city varchar(20)
);
delete from players_location;
insert into players_location
values ('Sachin','Mumbai'),('Virat','Delhi') , ('Rahul','Bangalore'),('Rohit','Mumbai'),('Mayank','Bangalore');

select * from players_location;


--step1:
select player_groups,city,
case when city='Bangalore' then name end as Bangalore,
case when city='Mumbai' then name end as Mumbai,
case when city='Delhi' then name else null end as Delhi
from
(select *,
row_number() over (partition by city order by name asc) as player_groups
from players_location)A 


--step2:
select --player_groups,
max(case when city='Bangalore' then name end) as Bangalore,
min(case when city='Mumbai' then name end) as Mumbai,
max(case when city='Delhi' then name else null end) as Delhi
from
(select *,
row_number() over (partition by city order by name asc) as player_groups
from players_location)A 
group by player_groups

