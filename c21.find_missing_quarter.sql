Day21: find_missing_quarter

/*
method 1: aggregation
method 2: recursive CTE 
method 3:Cross join
*/

CREATE TABLE STORES (
Store varchar(10),
Quarter varchar(10),
Amount int);

INSERT INTO STORES (Store, Quarter, Amount)
VALUES ('S1', 'Q1', 200),
('S1', 'Q2', 300),
('S1', 'Q4', 400),
('S2', 'Q1', 500),
('S2', 'Q3', 600),
('S2', 'Q4', 700),
('S3', 'Q1', 800),
('S3', 'Q2', 750),
('S3', 'Q3', 900);

select * from stores;

--method 1: aggregation
select  store,'Q'+cast(10-sum(cast(right(quarter,1) as int)) as char(2)) as qtr
from stores
group by store;

--method 2: recursive CTE 
-- find all combinations of store,quarter -> for each store we want 4 rows and then can join with current table to identify missing database

with cte as(
select distinct store,1 as q_no from stores
union all
select store, q_no+1 as q_no from cte
where q_no<4
)
,q as (select store, 'Q'+cast(q_no as char(2)) as q_no from cte)

select q.*
from q
left join stores s on q.store=s.store and q.q_no=s.quarter
where s.store is NULL


--method 3:Cross join

with cte as(
select distinct s1.store,s2.quarter
from stores s1,stores s2
)
select q.*
from cte q
left join stores s on q.store=s.store and q.quarter=s.quarter
where s.store is NULL

