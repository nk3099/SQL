CREATE TABLE input_table_1 (
    Market VARCHAR(50),
    Sales INT
);

INSERT INTO input_table_1 (Market, Sales) VALUES
('India', 100),
('Maharashtra', 20),
('Telangana', 18),
('Karnataka', 22),
('Gujarat', 25),
('Delhi', 12),
('Nagpur', 8),
('Mumbai', 10),
('Agra', 5),
('Hyderabad', 9),
('Bengaluru', 12),
('Hubli', 12),
('Bhopal', 5);

CREATE TABLE input_table_2 (
    Country VARCHAR(50),
    State VARCHAR(50),
    City VARCHAR(50)
);
delete from input_table_2;
INSERT INTO input_table_2 (Country, State, City) VALUES
('India', 'Maharashtra', 'Nagpur'),
('India', 'Maharashtra', 'Mumbai'),
('India', 'Maharashtra', 'Akola'),
('India', 'Telangana', 'Hyderabad'),
('India', 'Karnataka', 'Bengaluru'),
('India', 'Karnataka', 'Hubli'),
('India', 'Gujarat', 'Ahmedabad'),
('India', 'Gujarat', 'Vadodara'),
('India', 'UP', 'Agra'),
('India', 'UP', 'Mirzapur'),
('India', 'Delhi', NULL), 
('India', 'Orissa', NULL); 


select * from input_table_1;
select * from input_table_2;

with city_sales as (
select country, state, city, sales from input_table_2 t2
inner join input_table_1 t1
on t2.city=t1.Market
)
, city_level_state_sales as(
select state,sum(sales) as sales
from city_sales
group by state
)
, state_sales as (
select distinct country,state,coalesce(sales,0)  as sales--#or isnull(sales,0) also works
from input_table_2 t2
left join input_table_1 t1 on t2.state=t1.Market
)
, state_extra_sales as (
select ss.country,ss.state,ss.sales-isnull(clss.sales,0) as new_sales
from state_sales ss
left join city_level_state_sales clss
on ss.state=clss.state
where ss.sales!=isnull(clss.sales,0)
)

select * from city_sales 
union all
select country, state, null as city, new_sales
from state_extra_sales
order by country, state, city
