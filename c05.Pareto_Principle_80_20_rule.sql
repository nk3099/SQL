Day5:  Pareto_Principle_80_20_rule

--Pareto principle states that fo rmany outcomes, roughly 80% of consequences come from 20% of causes. 

-- 80% of your sales comes from 20% of your products or services.


--select sum(sales)*0.8 from orders
--1837760

with product_wise_sales as (select product_id, sum(sales) as product_sales
from orders
group by product_id
order by product_id, product_sales desc)
, cal_sales as (select product_id, product_sales
,sum(product_sales) over(order by product_sales desc rows between unbounded preeceding and 0 preeceding) as running_sales
,0.8*sum(product_sales) over() as total_sales
from product_wise_sales)

--select (413*1.0/1862)*100 --22.80%

--upto 413*(1.0)/1863 rows gives sum(product_sales) <= total_sales, i.e. ~0.22%
--ROWS BETWEEN UNBOUNDED PRECEDING AND 0 PRECEDING: 
--This means for each row, we calculate the 
--sum of product_sales from the very first row up to the current row (not including the current row).

select * 
from 
cal_sales
where running_sales<-total_sales

--therefore, top 20% prdts which give 80% sales
