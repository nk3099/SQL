--Day47: purchase history
--write a sql query to find users who purchased different products on different dates.
-- ie. products purchased on any given day are not repeated on any other day.

create table purchase_history
(userid int
,productid int
,purchasedate date
);
SET DATEFORMAT dmy;
insert into purchase_history values
(1,1,'23-01-2012')
,(1,2,'23-01-2012')
,(1,3,'25-01-2012')
,(2,1,'23-01-2012')
,(2,2,'23-01-2012')
,(2,2,'25-01-2012')
,(2,4,'25-01-2012')
,(3,4,'23-01-2012')
,(3,1,'23-01-2012')
,(4,1,'23-01-2012')
,(4,2,'25-01-2012')

select * from purchase_history;


with cte as
(select userid, 
count(distinct purchasedate) as no_of_dates,
count(productid) cnt_prdt,
count(distinct productid) as cnt_distinct_prdt
from purchase_history
group by userid
)
select userid
from cte
where no_of_dates>1 and
cnt_prdt=cnt_distinct_prdt

--OR--
--as filters are on aggerating values, we can directly using HAVING clause (instead of WITH clause)

select userid 
-- count(distinct purchasedate) as no_of_dates,
-- count(productid) cnt_prdt,
-- count(distinct productid) as cnt_distinct_prdt
from purchase_history
group by userid
having count(distinct purchasedate) > 1 and
count(productid) = count(distinct productid)
