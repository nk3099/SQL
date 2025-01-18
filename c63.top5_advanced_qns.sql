--day63: top5_advanced_sql

create table emp(
emp_id int,
emp_name varchar(20),
department_id int,
salary int,
manager_id int,
emp_age int);

insert into emp
values (1, 'Ankit', 100,10000, 4, 39);
insert into emp
values (2, 'Mohit', 100, 15000, 5, 48);
insert into emp
values (3, 'Vikas', 100, 10000,4,37);
insert into emp
values (4, 'Rohit', 100, 5000, 2, 16);
insert into emp
values (5, 'Mudit', 200, 12000, 6,55);
insert into emp
values (6, 'Agam', 200, 12000,2, 14);
insert into emp
values (7, 'Sanjay', 200, 9000, 2,13);
insert into emp
values (8, 'Ashish', 200,5000,2,12);
insert into emp
values (10, 'Saurabh',900,12000,2,51);

select * from emp;

--Q1) top 3 products by sales, top 3 employees by salaries, withing category/department

--top 3 highest salaried
select top 3 emp_name,salary
from emp 
order by salary desc;

--but now within each department:
--then we have to use RANK() or ROW_NUMBER()
select *
from
(
select emp_name,salary, department_id
, row_number() over (partition by department_id order by salary desc) as rn 
, dense_rank() over (partition by department_id order by salary desc) as rnk
from emp
)A
where rnk<=2

--Q2) yoy growth/products with current month sales more than previous months sales 
--here: product_id, month_of_year needed^

--we have to use lead/lag functions

/*
2020 -> 100 sales ==> 0% growth (as no prev. row)
2021 -> 200 sales ==> 100% growth
2023 -> 300 sales ==> 50% growth
*/

with cte as (
select year(order_date) as year_order, sum(sales) as sales 
from orders 
group by year(order_date)
)
cte2 as (
select *
, lag(sales,1,sales) over (order by year_order) as prev_year_sales
from cte
)
select year_order
,(sales-prev_year_sales)*100/prev_year_sales as yoy
from cte2

--yoy growth within each category
--always, see the granuality at which the qn. is asked
/*
category       year_order   sales
furniture       2020
furniture       2021
furniture       2022
glass           2020
glass           2021
glass           2022
*/

with cte as (
select category,year(order_date) as year_order, sum(sales) as sales 
from orders 
group by category,year(order_date)
)
cte2 as (
select *
, lag(sales,1,sales) over (partition by category order by year_order) as prev_year_sales
from cte
)

--Q3) running/cumulative sales year wise / rolling n months sales

with cte as (
select year(order_date) as year_order, sum(sales) as sales 
from orders 
group by year(order_date)
)
select *
, sum(sales) over (order by year_order) as cumulative_sales
from cte


--rolling 3 months sales ==> (prev. 2 months + current_month) sales.
/*
month  sales  rolling_sales
jan    100       100
feb    200       300
mar    300       600
apr    400.      900
may    500.      1200

therefore, need to get data at month level also:
*/

with cte as (
select year(order_date) as year_order, month(order_date) as month_order_date, sum(sales) as sales 
from orders 
group by year(order_date),month(order_date)
)
select *
, sum(sales) over (order by year_order,month_order_date rows between 2 preceding and current row) as rolling_sales
from cte

--if want prev 3 months sales (and shouldn't include current month) then:
--sum(sales) over (order by year_order,month_order_date rows between 3 preceding and 1 preceding) as rolling_sales


--Q4) pivoting--> convert rows in to column -- year wise each category sales
--can use case-when statements

--currently:
/*
select year(order_date) as year_order, category, sum(sales) as sales 
from orders 
group by year(order_date), category

category       year_order   sales
furniture       2020
furniture       2021
furniture       2022
glass           2020
glass           2021
glass           2022
*/

--But we want to convert category rows to columns:
/*
year_order  furniture glass
2020
2021
2022
*/
select year(order_date) as year_order
, sum(case when category='furniture' then sales else 0 end) as furtnitures
, sum(case when category='glass' then sales else 0 end) as glass
from orders 
group by year(order_date)


--Q5) result of inner/left joins etc.
--i.e how many records will be there in output
