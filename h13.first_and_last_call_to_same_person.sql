--Day 13: there is a phonelog table that has information about callers' call history. 
--write a SQL to find out callers whose first and last call was to the same person on a given day.

create table phonelog(
    Callerid int, 
    Recipientid int,
    Datecalled datetime
);

insert into phonelog(Callerid, Recipientid, Datecalled)
values(1, 2, '2019-01-01 09:00:00.000'),
       (1, 3, '2019-01-01 17:00:00.000'),
       (1, 4, '2019-01-01 23:00:00.000'),
       (2, 5, '2019-07-05 09:00:00.000'),
       (2, 3, '2019-07-05 17:00:00.000'),
       (2, 3, '2019-07-05 17:20:00.000'),
       (2, 5, '2019-07-05 23:00:00.000'),
       (2, 3, '2019-08-01 09:00:00.000'),
       (2, 3, '2019-08-01 17:00:00.000'),
       (2, 5, '2019-08-01 19:30:00.000'),
       (2, 4, '2019-08-02 09:00:00.000'),
       (2, 5, '2019-08-02 10:00:00.000'),
       (2, 5, '2019-08-02 10:45:00.000'),
       (2, 4, '2019-08-02 11:00:00.000');
       
select * from phonelog;

with calls as
(
select callerid,
cast(datecalled as date) as called_date,
min(datecalled) as firstcall,
max(datecalled) as lastcall
from phonelog
group by callerid,cast(datecalled as date)
)

select c.*,p1.Recipientid  -- as first_recipient,p2.Recipientid as last_recipient
from calls c
inner join phonelog p1 on p1.callerid=c.callerid and c.firstcall=p1.datecalled
inner join phonelog p2 on p2.callerid=c.callerid and c.lastcall=p2.datecalled
where p1.Recipientid=p2.Recipientid


------------
--OR--
------------

-- with cte AS (SELECT Callerid, Recipientid, CAST(Datecalled AS DATE) as Datecalled
-- FROM phonelog),
-- cte2 AS (SELECT *,
-- FIRST_VALUE(Recipientid) OVER(PARTITION BY Datecalled ORDER BY Datecalled) as first_value,
-- LAST_VALUE(Recipientid) OVER(PARTITION BY Datecalled ORDER BY Datecalled) as last_value
-- FROM cte)

-- SELECT Callerid, Datecalled, MAX(first_value) AS Recipientid FROM cte2
-- WHERE first_value = last_value
-- GROUP BY Callerid, Datecalled;
