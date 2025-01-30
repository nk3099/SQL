--day73.We have a table where we have amazon prime subscription history. 
--Event can have 3 values: S-> Subscribe, R-> Renewal, C-> Cancellation. 
--Assume Athat one customer can be in only one marketplace. 
--Write a query to find number of active prime members at end of 2020 in each marketplace.

CREATE TABLE subscription_history (
    customer_id INT,
    marketplace VARCHAR(10),
    event_date DATE,
    event CHAR(1),
    subscription_period INT --is in months.
);

INSERT INTO subscription_history VALUES (1, 'India', '2020-01-05', 'S', 6);
INSERT INTO subscription_history VALUES (1, 'India', '2020-12-05', 'R', 1);
INSERT INTO subscription_history VALUES (1, 'India', '2021-02-05', 'C', null);
INSERT INTO subscription_history VALUES (2, 'India', '2020-02-15', 'S', 12);
INSERT INTO subscription_history VALUES (2, 'India', '2020-11-20', 'C', null);
INSERT INTO subscription_history VALUES (3, 'USA', '2019-12-01', 'S', 12);
INSERT INTO subscription_history VALUES (3, 'USA', '2020-12-01', 'R', 12);
INSERT INTO subscription_history VALUES (4, 'USA', '2020-01-10', 'S', 6);
INSERT INTO subscription_history VALUES (4, 'USA', '2020-09-10', 'R', 3);
INSERT INTO subscription_history VALUES (4, 'USA', '2020-12-25', 'C', null);
INSERT INTO subscription_history VALUES (5, 'UK', '2020-06-20', 'S', 12);
INSERT INTO subscription_history VALUES (5, 'UK', '2020-11-20', 'C', null);
INSERT INTO subscription_history VALUES (6, 'UK', '2020-07-05', 'S', 6);
INSERT INTO subscription_history VALUES (6, 'UK', '2021-03-05', 'R', 6);
INSERT INTO subscription_history VALUES (7, 'Canada', '2020-08-15', 'S', 12);
INSERT INTO subscription_history VALUES (8, 'Canada', '2020-09-10', 'S', 12);
INSERT INTO subscription_history VALUES (8, 'Canada', '2020-12-10', 'C', null);
INSERT INTO subscription_history VALUES (9, 'Canada', '2020-11-10', 'S', 1);

select * from subscription_history;

with cte as (
select *
, row_number() over (partition by customer_id order by event_date desc) as rn
from subscription_history 
where event_date<='2020-12-31'
)
select *
, dateadd(month,subscription_period,event_date) as valid_till_date 
from cte
where rn=1 and event!='C'
and dateadd(month,subscription_period,event_date) >= '2020-12-31'
