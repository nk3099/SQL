--Day50: Section_Max
/*problem statement: we have a table which stores data of multiple sections, every section has 3 numbers. 
we have to find top 4 numbers from any 2 sections(2numbers each) whose addition should be maximum 
so in this case we will choose section b where we have 19(10+9) then we need to choose either C or D 
because both has sum of 18 but in D we have 10 which is big from 9 so we will give prioritiy to D*/

create table section_data ( section varchar(5), number integer ) 
insert into section_data values ('A',5),('A',7),('A',10) ,('B',7),
('B',9),('B',10) ,('C',9),('C',7),('C',9) ,('D',10),('D',3),('D',8);

select * from section_data;

with cte as 
(select *
,row_number() over (partition by section order by number desc) as rn
from section_data
)
, cte2 as
(select *
,sum(number) over (partition by section) as total
,max(number) over (partition by section) as sec_max
from cte
where rn<=2
)
select * from
(
select *,
dense_rank() over (order by total desc, sec_max desc) as rnk
from cte2
) A where rnk<=2
