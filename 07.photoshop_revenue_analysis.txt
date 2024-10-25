--Day 7: photoshop_revenue_analysis
--for every customer  that bought photoshop, return a list of customers, and the total spent on all the products except for Photoshop products


CREATE TABLE adobe_transactions (
  customer_id int,
  product varchar(20),
  revenue int
);

-- insert
INSERT INTO adobe_transactions(customer_id,product,revenue) VALUES (123, 'photoshop', 50);
INSERT INTO adobe_transactions values (123,'premier pro',100), (123,'effect',50),(234,'illustrator',200),(234,'premier pro',100);
-- fetch 

SELECT * FROM adobe_transactions;

with photoshop_customers as
(select customer_id, sum(revenue) as revenue
from adobe_transactions
where product='photoshop'
group by customer_id),
total_customers as 
(select customer_id, sum(revenue) as revenue
from adobe_transactions
group by customer_id)

select pc.customer_id,(tc.revenue-pc.revenue) as revenue
from photoshop_customers pc
join total_customers tc ON pc.customer_id=tc.customer_id
order by customer_id

--Using IN operator

-- NOTE: on 'customer_id' column will help to get product 'photoshop' customers along with all other customers for that customer_id
-- if would have used on 'product' column then only would have got product 'photoshop' customer details

select customer_id, sum(revenue) as revenue
from adobe_transactions
where customer_id IN (select customer_id from adobe_transactions where product='photoshop')
and product!='photoshop'
group by customer_id
order by customer_id

-- using Exist operator
--its works as a filter, and doesn't return anything (like join)
--ie. it returns true or false (if even 1 row is returned, and thereby those row are qualified from inner query)

--here, for each row of table 'a' it will go and check with inner query of table 'b'
SELECT customer_id, SUM(revenue) AS revenue
FROM adobe_transactions a
WHERE EXISTS (
    SELECT 1 
    FROM adobe_transactions b 
    WHERE product = 'photoshop' AND a.customer_id = b.customer_id
)
AND product != 'photoshop'
GROUP BY customer_id
ORDER BY customer_id;

