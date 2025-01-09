--Day58: write an SQL to get start city and end city of each customer
--Destination City : return the destination city, that is, the city without nay path outgoing to another city

--NOTE: Any aggregation function will ignore the NULL value.

--Approach:
/*
anything which is only in start_loc and not in end_loc 
=>then it will be the final start_loc

anything which is only in end_loc and not in start_loc 
=>then it will be the final end_loc
*/

CREATE TABLE travel_data (
    customer VARCHAR(10),
    start_loc VARCHAR(20),
    end_loc VARCHAR(20)
);

INSERT INTO travel_data (customer, start_loc, end_loc) VALUES
    ('c1', 'New York', 'Lima'),
    ('c1', 'London', 'New York'),
    ('c1', 'Lima', 'Sao Paulo'),
    ('c1', 'Sao Paulo', 'New Delhi'),
    ('c2', 'Mumbai', 'Hyderabad'),
    ('c2', 'Surat', 'Pune'),
    ('c2', 'Hyderabad', 'Surat'),
    ('c3', 'Kochi', 'Kurnool'),
    ('c3', 'Lucknow', 'Agra'),
    ('c3', 'Agra', 'Jaipur'),
    ('c3', 'Jaipur', 'Kochi');
    
select * from travel_data;


---Solution 1:----

with cte as
(
select customer, start_loc as city, 'start_loc' as flag
from travel_data
union all 
select customer, end_loc as city, 'end_loc' as flag
from travel_data
) 
, cte2 as 
(select *
, count(*) over (partition by customer,city) as cnt
from cte
--order by customer,city
)

select customer
, max(case when flag='start_loc' then city end) as  startlocation
, max(case when flag='end_loc' then city end) as endlocation
from cte2 
where cnt=1
group by customer



---Solution 2:----
select td. customer 
, max(case when td1.end_loc is null then td.start_loc end) as startinglocation
, min(case when td2.start_loc is null then td.end_loc end) as endinglocation 
from travel_data td 
left join travel_data td1 
on td.customer=td1.customer and td.start_loc=td1.end_loc 
left join travel_data td2 
on td.customer=td2.customer and td.end_loc=td2.start_Loc 
group by td.customer

