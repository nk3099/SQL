
Day16: customer_churn

—customer retention and churn metrics (part2)
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

select * from transactions;

select month(last_month.order_date) as month_name, count(distinct last_month.cust_id) as retained_customers 
from transactions last_month
left join transactions this_month on this_month.cust_id=last_month.cust_id and datediff(month,last_month.order_date,this_month.order_date)=1
where this_month.cust_id is NULL
group by month(last_month.order_date) --as need monthwise data

--Note: In Churn, the last_month data doesn't have any value, only next_month will hold value to identify Churn.
--Therefore, last_month table would be driving table for Churn query as (customers who ordered last_month but not this_month)

--Also can do "month(last_month.order_date)+1 as month_name" if to say its in Feb(2nd month) Churn
--But again, same thing - instead we saying as Jan(1st month). Lastly, no data for March(3rd month) so all churn.

--OR--
--using LEAD function--

select month(order_date) as month_name, sum(case when month(order_date)-month(lastdate)=0 then 1 else 0 end) as retained_customers 
from 
(
select * , lead(order_date,1,order_date) over (partition by cust_id order by order_date) as lastdate from transactions
) A 
group by month(order_date)



