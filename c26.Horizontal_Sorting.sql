Day26: Horizontal_Sorting
--find total no. of messages exchanged between each person per day

CREATE TABLE subscriber (
 sms_date date ,
 sender varchar(20) ,
 receiver varchar(20) ,
 sms_no int
);
-- insert some values
INSERT INTO subscriber VALUES ('2020-4-1', 'Avinash', 'Vibhor',10);
INSERT INTO subscriber VALUES ('2020-4-1', 'Vibhor', 'Avinash',20);
INSERT INTO subscriber VALUES ('2020-4-1', 'Avinash', 'Pawan',30);
INSERT INTO subscriber VALUES ('2020-4-1', 'Pawan', 'Avinash',20);
INSERT INTO subscriber VALUES ('2020-4-1', 'Vibhor', 'Pawan',5);
INSERT INTO subscriber VALUES ('2020-4-1', 'Pawan', 'Vibhor',8);
INSERT INTO subscriber VALUES ('2020-4-1', 'Vibhor', 'Deepak',50);

select * from subscriber;

--NOTE:
--as p1 would hv sorted asc name and 
-- p2 would hv sorted desc name
--thereby, would help us to group by on p1,p2 persons!


--without CTE: 

select sms_date, sum(sms_no) as total_msgs,
case when sender < receiver then sender else receiver end as p1,
case when sender < receiver then receiver else sender end as p2
from subscriber
group by sms_date,
case when sender < receiver then sender else receiver end,
case when sender < receiver then receiver else sender end;

------------
--OR--
------------

--with CTE:

with cte as
(select sms_date,
case when sender < receiver then sender else receiver end as p1,
case when sender > receiver then sender else receiver end as p2,
sms_no
from subscriber)


select sms_date,p1,p2,sum(sms_no) as total_msgs
from cte
group by sms_date,p1,p2

