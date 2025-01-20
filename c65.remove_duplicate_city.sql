--day65.remove duplicate in case of source,destination,distance are same and keep the first value only. 
--first 2 solutions, i will not guarantee first row will come in output.

CREATE TABLE city_distance
(
    distance INT,
    source VARCHAR(10),
    destination VARCHAR(10)
);

delete from city_distance;
INSERT INTO city_distance(distance, source, destination) VALUES ('100', 'New Delhi', 'Panipat');
INSERT INTO city_distance(distance, source, destination) VALUES ('200', 'Ambala', 'New Delhi');
INSERT INTO city_distance(distance, source, destination) VALUES ('150', 'Bangalore', 'Mysore');
INSERT INTO city_distance(distance, source, destination) VALUES ('150', 'Mysore', 'Bangalore');
INSERT INTO city_distance(distance, source, destination) VALUES ('250', 'Mumbai', 'Pune');
INSERT INTO city_distance(distance, source, destination) VALUES ('250', 'Pune', 'Mumbai');
INSERT INTO city_distance(distance, source, destination) VALUES ('2500', 'Chennai', 'Bhopal');
INSERT INTO city_distance(distance, source, destination) VALUES ('2500', 'Bhopal', 'Chennai');
INSERT INTO city_distance(distance, source, destination) VALUES ('60', 'Tirupati', 'Tirumala');
INSERT INTO city_distance(distance, source, destination) VALUES ('80', 'Tirumala', 'Tirupati');

select * from city_distance;

--Solution 1: Self Join--
select A.*  
from city_distance A
left join city_distance B on A.source=B.destination and A.destination=B.source
where B.distance is NULL or A.distance!=B.distance
or A.source<A.destination;


--Solution 2--
---city with lower ASCII value comes in city1 column and other one in city2 column

with cte as (
select  *
, case when source < destination then source else destination end as city1
, case when source < destination then destination else source end as city2
from city_distance
)
, cte2 as (
select *
, count(*) over (partition by city1,city2,distance) as cnt
from cte
)

select distance, source, destination
from cte2
where cnt=1 or (source<destination);


--Solution 3--
--"row_number() over ( order by (select null)) " -->it will generate row_number in the same order as of the table.
with cte as 
(
select *
, row_number() over ( order by (select null)) as rn 
from city_distance
)

select A.*  
from cte A
left join cte B on A.source=B.destination and A.destination=B.source
where B.distance is NULL or A.distance!=B.distance
or A.rn<B.rn


