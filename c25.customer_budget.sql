Day 25: customer_budget

----find how many product falls into customer budget along with list of products. 
--In case of clash, choose the less costly product

create table products
(
product_id varchar(20) ,
cost int
);
insert into products values ('P1',200),('P2',300),('P3',500),('P4',800);

create table customer_budget
(
customer_id int,
budget int
);

insert into customer_budget values (100,400),(200,800),(300,1500);

select * from products;

select* from customer_budget;


with running_cost as
(select *,
sum(cost) over(order by cost asc) as r_cost
from products)

--NOTE:---
--left join as : 
--in case there is none of the product is in customer_budget then we should get 0(zero) atleast
--otherwise, if we put Inner Join - then that customer will not come in output

-- select *
-- from customer_budget cb 
-- left join running_cost rc on r_cost < budget


select customer_id,budget,count(*) as no_of_products, string_agg(product_id,',') as list_of_products
from customer_budget cb 
left join running_cost rc on r_cost < budget
group by customer_id,budget


