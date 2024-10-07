Day2: new_and_repeat_customers

create table customer_orders (
order_id integer,
customer_id integer,
order_date date,
order_amount integer
);
--select * from customer_orders
insert into customer_orders values(1,100,cast('2022-01-01' as date),2000),(2,200,cast('2022-01-01' as date),2500),(3,300,cast('2022-01-01' as date),2100)
,(4,100,cast('2022-01-02' as date),2000),(5,400,cast('2022-01-02' as date),2200),(6,500,cast('2022-01-02' as date),2700)
,(7,100,cast('2022-01-03' as date),3000),(8,400,cast('2022-01-03' as date),1000),(9,600,cast('2022-01-03' as date),3000);
select * from customer_orders;

--output: order_date, new_customer_count, repeat_customer_count

-- with cte as(select customer_id,order_date,order_amount,
-- rank() over (partition by customer_id order by order_date) as rnk 
-- from customer_orders)

-- select order_date,
-- sum(case 
-- when rnk=1 then 1 else 0
-- end) as new_customer_count,
-- sum(case
-- when rnk>1 then 1 else 0
-- end) as repeat_customer_count,
-- sum(case 
-- when rnk=1 then order_amount else 0
-- end) as new_customer_amount_spent,
-- sum(case
-- when rnk>1 then order_amount else 0
-- end) as repeat_customer_amount_spent
-- from cte
-- group by order_date


--for calculating AMOUNT:
---------------------------

-- Select a.order_date,
-- Sum(Case when a.order_date = a.first_order_date then 1 else 0 end) as new_customer,
-- Sum(Case when a.order_date != a.first_order_date then 1 else 0 end) as repeat_customer,
-- Sum(Case when a.order_date = a.first_order_date then A.order_amount else 0 end) as new_customer_amt,
-- Sum(Case when a.order_date != a.first_order_date then A.order_amount else 0 end) as repeat_customer_amt
-- from(
-- Select customer_id, order_date,order_amount, min(order_date) over(partition by customer_id) as first_order_date from customer_orders) a 
-- group by a.order_date order by a.order_date;


--OR--

with first_visit as(select customer_id, min(order_date) as first_visit_date
from customer_orders
group by customer_id)

select co.order_date,
sum(case
when co.order_date=fv.first_visit_date then 1 else 0
end) as new_customer_count,
sum(case
when co.order_date<>first_visit_date then 1 else 0
end) as repeat_customer_count
from first_visit fv 
inner join customer_orders co ON co.customer_id=fv.customer_id
group by order_date
