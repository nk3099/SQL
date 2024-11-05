--Day 39: Write an SQL query to report the students(student_id,student_name) being "quiet" in ALL exams.
--A "quiet" student is the one who took atleast one exam and didn't score neither the high score
--nor the low score in any of the exam.
--Don't return the student who has never taken the exam. Return the result table ordered by student_id

create table students
(
student_id int,
student_name varchar(20)
);
insert into students values
(1,'Daniel'),(2,'Jade'),(3,'Stella'),(4,'Jonathan'),(5,'Will');

create table exams
(
exam_id int,
student_id int,
score int);

insert into exams values
(10,1,70),(10,2,80),(10,3,90),(20,1,80),(30,1,70),(30,3,80),(30,4,90),(40,1,60)
,(40,2,70),(40,4,80);

select * from students;

select * from exams;

with cte as 
(
select exam_id, min(score) as min_marks, max(score) as max_marks
from exams
group by exam_id
)

select e.student_id
--,max(case when e.score=min_marks or e.score=max_marks then 1 else 0 end) as red_flag
from exams e
join cte c
on e.exam_id=c.exam_id
group by e.student_id
having max(case when e.score=min_marks or e.score=max_marks then 1 else 0 end)=0
