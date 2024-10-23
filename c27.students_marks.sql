Day27: students_marks

CREATE TABLE [students](
 [studentid] [int] NULL,
 [studentname] [nvarchar](20) NULL,
 [subject] [nvarchar](20) NULL,
 [marks] [int] NULL,
 [testid] [int] NULL,
 [testdate] [date] NULL
)
data:
insert into students values (2,'Max Ruin','Subject1',63,1,'2022-01-02');
insert into students values (3,'Arnold','Subject1',95,1,'2022-01-02');
insert into students values (4,'Krish Star','Subject1',61,1,'2022-01-02');
insert into students values (5,'John Mike','Subject1',91,1,'2022-01-02');
insert into students values (4,'Krish Star','Subject2',71,1,'2022-01-02');
insert into students values (3,'Arnold','Subject2',32,1,'2022-01-02');
insert into students values (5,'John Mike','Subject2',61,2,'2022-11-02');
insert into students values (1,'John Deo','Subject2',60,1,'2022-01-02');
insert into students values (2,'Max Ruin','Subject2',84,1,'2022-01-02');
insert into students values (2,'Max Ruin','Subject3',29,3,'2022-01-03');
insert into students values (5,'John Mike','Subject3',98,2,'2022-11-02');

select * from students;

--Write an SQL query to get the list of students who scored above the average marks in each subject

select s.*
from 
students s
inner join 
(select subject,avg(marks) as avg_marks
from students
group by subject) a
on a.subject=s.subject
where s.marks>a.avg_marks;

--write an SQL query to get the percentage of students who score more than 90 in any subject amongst the total students

select
count(distinct case when marks>90 then studentid else null end) *1.0 / count(distinct studentid) * 100 as percentage
from students;

--write an SQL query to get the second highest and second-lowest marks for each subject
/*
subject. second-highest-marks.   second-lowest-marks
Subject1    91                         63
Subject2    71                        60
sucbject3   29                       98
*/


with cte as(
select subject,marks,
rank() over (partition by subject order by marks asc) as least_marks,
rank() over (partition by subject order by marks desc) as highest_marks
from students
)
select subject,
sum(case when highest_marks=2 then marks end) as second_highest_marks,
max(case when least_marks=2 then marks else null end) as second_lowest_marks
from cte
group by subject


--For each student and test, identify if their marks increased or decreased from the previous test


select *,
case when marks > prev_marks then 'inc' 
     when marks < prev_marks then 'dec' 
     else null
end as stats
from
(
select *,
lag(marks,1) over (partition by studentname order by testdate,subject) as prev_marks
from students
) A


