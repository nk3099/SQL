Day15: customer_retention

--customer retention and churn metrics (part1)
/*customer retention:refers to a company's ability to turn customers into repeat buyers 
and prevent them from switching to a competitor. It indicates whether your product 
and the quality of your service please your existing customers reward programs
(credit card companies) 
wallet cash back (paytm/gpay) 
zomato pro/swiggy super 
retention period */

create table transactions(
order_id int,
cust_id int,
order_date date,
amount int
);
delete from transactions;
insert into transactions values 
(1,1,'2020-01-15',150)
,(2,1,'2020-02-10',150)
,(3,2,'2020-01-16',150)
,(4,2,'2020-02-25',150)
,(5,3,'2020-01-10',150)
,(6,3,'2020-02-20',150)
,(7,4,'2020-01-20',150)
,(8,5,'2020-02-20',150);

--select * from transactions;

select month(this_month.order_date) as month_name, count(distinct last_month.cust_id) as retained_customers 
from transactions this_month
left join transactions last_month on this_month.cust_id=last_month.cust_id and datediff(month,last_month.order_date,this_month.order_date)=1
group by month(this_month.order_date) --as need monthwise data

--Note: did LEFT JOIN to get JAN month data also, else there were no repeat customer, but wanted to see output!
--count(distinct last_month.cust_id)  : as whatever customer ordered last month only for those cust_id would come, 
--and for other would be NULL as doing left join (i.e. only matching record come from right table )


--OR--
--using LAG function--

--select cust_id , month(order_date) month , lag(month(order_date)) over (partition by cust_id order by month(order_date) ) prev_month , case when month(order_date) - lag(month(order_date)) over (partition by cust_id order by month(order_date) )  = 1 then 1 else 0 end diff from transactions

select month , sum (diff)  as retained_customers
from 
(select cust_id , month(order_date) month , lag(month(order_date)) over (partition by cust_id order by month(order_date) ) prev_month , case when month(order_date) - lag(month(order_date)) over (partition by cust_id order by month(order_date) )  = 1 then 1 else 0 end diff from transactions) A 
group by month



