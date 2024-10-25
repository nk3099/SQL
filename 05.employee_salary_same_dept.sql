—Day5:
—Write a SQL to return all employee whose salary is same in same department.

CREATE TABLE [emp_salary]
(
    [emp_id] INTEGER  NOT NULL,
    [name] NVARCHAR(20)  NOT NULL,
    [salary] NVARCHAR(30),
    [dept_id] INTEGER
);


INSERT INTO emp_salary
(emp_id, name, salary, dept_id)
VALUES(101, 'sohan', '3000', '11'),
(102, 'rohan', '4000', '12'),
(103, 'mohan', '5000', '13'),
(104, 'cat', '3000', '11'),
(105, 'suresh', '4000', '12'),
(109, 'mahesh', '7000', '12'),
(108, 'kamal', '8000', '11');

select * from emp_salary
--Write a SQL to return all employee whose salary is same (and are) in same dept.

--inner join--
select es.* 
from emp_salary es 
inner join emp_salary es2 on es.dept_id=es2.dept_id
where es.salary=es2.salary and es.emp_id!=es2.emp_id
order by dept_id

--OR--
select E.*
from emp_salary E
inner join(select dept_id,salary,count(dept_id) as cnt
from emp_salary
group by dept_id,salary
having count(dept_id) > 1) as A 
on E.dept_id=A.dept_id and E.salary=A.salary

--OR-- 
--left join with table(having rows which are not matching, so we can take right table as those will not have any records, ie. NULL )

select E.*
from emp_salary E
LEFT join(select dept_id,salary,count(dept_id) as cnt
from emp_salary
group by dept_id,salary
having count(dept_id)=1 ) as A 
on E.dept_id=A.dept_id and E.salary=A.salary
where A.dept_id is NULL
