Day23 : increasing_covid_cases

--find cities where the covid cases are increasing continuously 

create table covid(city varchar(50),days date,cases int);
delete from covid;
insert into covid values('DELHI','2022-01-01',100);
insert into covid values('DELHI','2022-01-02',200);
insert into covid values('DELHI','2022-01-03',300);

insert into covid values('MUMBAI','2022-01-01',100);
insert into covid values('MUMBAI','2022-01-02',100);
insert into covid values('MUMBAI','2022-01-03',300);

insert into covid values('CHENNAI','2022-01-01',100);
insert into covid values('CHENNAI','2022-01-02',200);
insert into covid values('CHENNAI','2022-01-03',150);

insert into covid values('BANGALORE','2022-01-01',100);
insert into covid values('BANGALORE','2022-01-02',300);
insert into covid values('BANGALORE','2022-01-03',200);
insert into covid values('BANGALORE','2022-01-04',400);

select * from covid;


with cte as
(
select *,
rank() over (partition by city order by days asc) as rnk_days,
rank() over (partition by city order by cases asc) as rnk_cases,
rank() over (partition by city order by days asc) - rank() over (partition by city order by cases asc) as diff
--as rnk_days and rnk_cases should be same, ie. their difference would be 0
from covid
)

select city
from cte
group by city
having count(distinct diff)=1 and max(diff)=0 -- can use avg(diff)=0, min(diff)=0 doesn't matter (or) first(diff)=0 i.e gives first value


-- with cte as
-- (select *,
-- lag(cases,1,0) over (partition by city order by days) as prev_day_cases
-- from covid)

-- select city
-- from cte
-- group by city
-- having sum(case when cases > prev_day_cases then 0 else 1 end)=0

