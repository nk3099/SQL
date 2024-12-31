--Day43: Monthly merchant balance:
/*
say you have access to all the transactions for a given merchant account. 
Write a query to print cumulative balance of the merchant account at the end of each day, 
with the total balance reset back to zero at the end of the month. 
Output the transaction date and cumulative balance.
*/

with cte as 
(select
transaction_date::date as transaction_date,
sum(case when type='withdrawal' then -1*amount else amount end) as amount
group by transaction_date::date
order by transaction_date::date
)

select
transaction_date
sum(amount) over (partition by extract(year from transaction_date),extract(month from transaction_date) 
order by transaction_date) as cum_sum 
from cte
