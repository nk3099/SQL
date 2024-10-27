Day 34: Self Join

--Business city table has data from the day Udayan has started operation 
--Write a SQL to identify year wise count of new cities where Udaan started their operations

create table business_city (
business_date date,
city_id int
);
delete from business_city;
insert into business_city
values(cast('2020-01-02' as date),3),(cast('2020-07-01' as date),7),(cast('2021-01-01' as date),3),(cast('2021-02-03' as date),19)
,(cast('2022-12-01' as date),3),(cast('2022-12-15' as date),3),(cast('2022-02-28' as date),12);


select * from business_city;

--o/p: year, #new_cities

--METHOD 1:
with cte as(select datepart(year,business_date) as yr,city_id
from business_city)

--therefore, wherever c2.yr=NULL or c2.city_id=NULL => it's a new City for that year.
--also, there can be 2 operations for same city in same year, hence took 'distinct'.. but for this prblm data is fine.
select c1.yr,
count(distinct case 
 when c2.city_id is NULL then c1.city_id
end) as new_cities
from cte c1
left join cte c2 on c1.yr > c2.yr and c1.city_id=c2.city_id
group by c1.yr;



--METHOD 2:
-- extracting the city with the first year they started operations. 
-- with cte as
-- (
-- select min(year(business_date)) as yr,city_id
-- from business_city
-- group by city_id
-- )
-- --counting how many cities are there for each year so hence COUNT(city_id).
-- select yr,count(city_id) as new_cities
-- from cte
-- group by yr


--METHOD 3:
select year(business_date) as yr, count(city_id) as new_cities
from
(
select *,
row_number() over (partition by city_id order by business_date asc) as rn 
from business_city
)A
where rn=1
group by year(business_date)
