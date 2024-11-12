--Day 38: write a sql to populate category values to the last not null value

create table brands 
(
category varchar(20),
brand_name varchar(20)
);
insert into brands values
('chocolates','5-star')
,(null,'dairy milk')
,(null,'perk')
,(null,'eclair')
,('Biscuits','britannia')
,(null,'good day')
,(null,'boost');

select * from brands;

-- with cte1 as
-- (select *,
-- row_number() over (order by (select null)) as rn
-- from brands
-- )
-- ,cte2 as 
-- (select *,
-- lead(rn,1,999) over (order by rn) as next_rn
-- from cte1
-- where category is not null
-- )
-- select cte2.category, cte1.brand_name
-- from cte1
-- inner join cte2 on cte1.rn >= cte2.rn and cte1.rn <= cte2.next_rn-1

-----------
--OR--
-----------

with cte1 as
(select *,
row_number() over (order by (select null)) as rn
from brands
)
,cte2 as 
(select *,
lead(rn,1) over (order by rn) as next_rn
from cte1
where category is not null
)
select cte2.category, cte1.brand_name
from cte1
inner join cte2 on cte1.rn >= cte2.rn and (cte1.rn <= cte2.next_rn-1 or cte2.next_rn-1 is null)

