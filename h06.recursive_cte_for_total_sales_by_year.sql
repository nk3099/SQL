--Day12: recursive_cte_for_total_sales_by_year

--recursive cte_numbers

WITH cte_numbers
AS (
Select 1 as num -- anchor query

UNION ALL

SELECT num+1 -- recursive query
FROM cte_numbers
WHERE num<6 -- filter to stop recursion
)

SELECT num
FROM cte_numbers;

/*
Output:
num 
1
2
3
4
5
6
*/

create table sales (
product_id int,
period_start date,
period_end date,
average_daily_sales int
);

insert into sales values(1,'2019-01-25','2019-02-28',100),(2,'2018-12-01','2020-01-01',10),(3,'2019-12-01','2020-01-31',1);

select * from sales;

With r_cte as(
Select min(period_start) as dates,max(period_end) as max_date from sales
union all
select dateadd(day,1,dates) as dates, max_date from r_cte
where dates < max_date
)
select product_id, year(dates) as report_year, sum(average_daily_sales) as total_amount from r_cte
Inner join sales on dates between period_start and period_end
group by product_id, year(dates)
order by product_id, year(dates)
option (maxrecursion 1000);
