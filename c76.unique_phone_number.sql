
--day76.
--NOTE:
/*SQL Server doesn’t have direct support 
for regular expressions like some other databases (e.g., PostgreSQL)*

In SQL Server (MSSQL), there isn't full support for POSIX regular expressions like in PostgreSQL. 
However, SQL Server does provide some basic pattern matching functionality 
through LIKE, PATINDEX, and CHARINDEX. These are limited in comparison to 
the full power of regular expressions, but they can handle many common use cases 
for pattern matching.
*/

--A column contains list of phone numbers as keyed in by users. 
--You are supposed to find only those phone numbers which don't have any repeating numbers, 
--ie. all numbers of the phone number must be unique
--Also, pls ignore the starting extension part of phone

create table phone_numbers (num varchar(20));
insert into phone_numbers values
('1234567780'),
('2234578996'),
('+1-12244567780'),
('+32-2233567889'),
('+2-23456987312'),
('+91-9087654123'),
('+23-9085761324'),
('+11-8091013345');

select * from phone_numbers;


--Method 1: in PostreSQL
-- with cte as (
-- select *
-- , case when position('-' in num)=0 then num else split_part(num,'-',2) end as new_num 
-- from phone_numbers
-- )

-- select num, new_num, count(*) as no_of_digits, count(distinct digits) as dist_digits
-- from 
-- (
-- select *, REGEXP_SPLIT_TO_TABLE(new_num,'') as digits
-- from cte
-- ) A 
-- group by num, new_num
-- having count(*)=count(distinct digits)


--Method 2: in MSSQL

with cte as (
select *,substring(num,CHARINDEX('-',num,0)+1,len(num)+1) phone
from 
phone_numbers
)
,cte1 as  --recursive cte
(
select num,phone,SUBSTRING(phone,1,1) as a,1 as b from cte
union all
select num,phone,SUBSTRING(phone,b+1,1) a,b+1 from cte1 
where len(phone)>b
)

select phone
,count(distinct(a)),len(phone) from cte1 
group by phone 
having count(distinct(a))=len(phone)


/*example for above wokring of Recursiv CTE for one phone_number:
num	         phone	a	b
123-4567890	4567890	4	1
123-4567890	4567890	5	2
123-4567890	4567890	6	3
123-4567890	4567890	7	4
123-4567890	4567890	8	5
123-4567890	4567890	9	6
123-4567890	4567890	0	7
*/
