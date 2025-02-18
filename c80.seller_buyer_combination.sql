--day80: sql query to find the top 5 seller-buyer combinations who have had maximum transactions between them.
--1st row: seller, 2nd row: buyer 

--also, 
--condition: please disqualify the sellers who have acted as buyers and also the buyers who have acted as sellers for this condition.

CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY,
    customer_id INT,
    amount INT,
    tran_Date datetime
);

delete from Transactions;
INSERT INTO Transactions VALUES (1, 101, 500, '2025-01-01 10:00:01');
INSERT INTO Transactions VALUES (2, 201, 500, '2025-01-01 10:00:01');
INSERT INTO Transactions VALUES (3, 102, 300, '2025-01-02 00:50:01');
INSERT INTO Transactions VALUES (4, 202, 300, '2025-01-02 00:50:01');
INSERT INTO Transactions VALUES (5, 101, 700, '2025-01-03 06:00:01');
INSERT INTO Transactions VALUES (6, 202, 700, '2025-01-03 06:00:01');
INSERT INTO Transactions VALUES (7, 103, 200, '2025-01-04 03:00:01');
INSERT INTO Transactions VALUES (8, 203, 200, '2025-01-04 03:00:01');
INSERT INTO Transactions VALUES (9, 101, 400, '2025-01-05 00:10:01');
INSERT INTO Transactions VALUES (10, 201, 400, '2025-01-05 00:10:01');
INSERT INTO Transactions VALUES (11, 101, 500, '2025-01-07 10:10:01');
INSERT INTO Transactions VALUES (12, 201, 500, '2025-01-07 10:10:01');
INSERT INTO Transactions VALUES (13, 102, 200, '2025-01-03 10:50:01');
INSERT INTO Transactions VALUES (14, 202, 200, '2025-01-03 10:50:01');
INSERT INTO Transactions VALUES (15, 103, 500, '2025-01-01 11:00:01');
INSERT INTO Transactions VALUES (16, 101, 500, '2025-01-01 11:00:01');
INSERT INTO Transactions VALUES (17, 203, 200, '2025-11-01 11:00:01');
INSERT INTO Transactions VALUES (18, 201, 200, '2025-11-01 11:00:01');

select * from Transactions;


with cte as 
(select 
transaction_id, customer_id as seller_id, amount, tran_Date
, lead(customer_id,1) over (order by transaction_id) as buyer_id
from transactions 
)
, cte_combinations as(
select seller_id, buyer_id, count(*) as no_of_transactions
from cte
transaction_id%2=1
group by seller_id,buyer_id
order by no_of_transactions desc
)
--now, for 
--condition: please disqualify the sellers who have acted as buyers and also the buyers who have acted as sellers for this condition.

, fraud_customers as (
select seller_id as frauds from cte_combinations
intersect
select buyer_id from cte_combinations
)

select top 5 * from cte_combinations
where seller_id not in (select frauds from fraud_customers)
and buyer_id not in (select frauds from fraud_customers)

