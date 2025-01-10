--Rishasbh Mishra SQL
--Remove_duplicates_single_row:

create table travel (
source varchar(10),
destination varchar(10),
distance varchar(10));

insert into travel (source, destination, distance)
values
('Mumbai', 'Bangalore', 500),
('Bangalore','Mumbai', 500),
('Delhi', 'Mathura', 150),
( 'Mathura','Delhi', 150),
('Nagpur', 'Pune', 500),
( 'Pune','Nagpur', 500);

select * from travel;

/*
source     destination distance  
---------- ----------- ----------
Mumbai     Bangalore   500       
Bangalore  Mumbai      500       
Delhi      Mathura     150       
Mathura    Delhi       150       
Nagpur     Pune        500       
Pune       Nagpur      500   

OUTPUT:
source     destination distance  
---------- ----------- ----------
Mumbai     Bangalore   500       
Delhi      Mathura     150       
Pune       Nagpur      500    
*/


--Method1: Using SELF Join

with cte as
(
select *
, row_number() over(order by (select null)) as slno
from travel
)

select c1.source, c1.destination, c1.distance
from cte c1
join cte c2 on c1.source=c2.destination and c1.slno < c2.slno

--Method2: Using SUBQUERY

select  *
from travel t1 
where not exists ( select *
                   from travel t2 
                   where t1.source=t2.destination
                   and t1.destination=t2.source
                   and t1.destination > t2.destination --acting as a true/false in subquery
                   )

--Method3: Using GREATEST & LEAST function

select greatest(source,destination) as source, least(source,destination) as destination, max(distance) as distance 
from travel 
group by greatest(source,destination), least(source,destination)



--example:
select greatest(2,11,9,4); --outputs--: 11
select least(2,11,9,4); --outputs--: 2

