Day22: groupby_having_same_marks

--find students with same marks in physics and chemistry
create table exams (student_id int, subject varchar(20), marks int);
delete from exams;
insert into exams values (1,'Chemistry',91),(1,'Physics',91)
,(2,'Chemistry',80),(2,'Physics',90)
,(3,'Chemistry',80)
,(4,'Chemistry',71),(4,'Physics',54);

select * from exams;

--ONLY using GroupBy and Having Clause:

select student_id
from exams
where subject IN ('Chemistry','Physics')
group by student_id
having count(distinct subject)=2 and count(distinct marks)=1;
--as if marks are same then distinct count=1 else it would be 2.

-------------
--OR--
-------------

with cte as (select student_id, sum(marks)/2 as half
from exams
group by student_id 
having count(student_id) = 2
)

select distinct c.student_id from cte c INNER JOIN exams e ON c.student_id = e.student_id
where c.half = e.marks;



