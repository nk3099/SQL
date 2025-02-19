--Rishasbh Mishra SQL

CREATE TABLE Employee (
EmpID int NOT NULL,
EmpName Varchar(10),
Gender Char,
Salary int,
City Char(20) );

INSERT INTO Employee
VALUES (1, 'Arjun', 'M', 75000, 'Pune'),
(2, 'Ekadanta', 'M', 125000, 'Bangalore'),
(3, 'Lalita', 'F', 150000 , 'Mathura'),
(4, 'Madhav', 'M', 250000 , 'Delhi'),
(5, 'Visakha', 'F', 120000 , 'Mathura');

---------------------------------------------------
CREATE TABLE EmployeeDetail (
EmpID int NOT NULL,
Project Varchar(10),
EmpPosition Char(20),
DOJ date );

INSERT INTO EmployeeDetail
VALUES 
(1, 'P1', 'Executive', '2019-01-26'),
(2, 'P2', 'Executive', '2020-05-04'),
(3, 'P1', 'Lead', '2021-10-21'),
(4, 'P3', 'Manager', '2019-11-29'),
(5, 'P2', 'Manager', '2020-08-01');

---------------------------------------------------
select * from Employee;
select * from EmployeeDetail;
---------------------------------------------------

--  Q1(a): Find the list of employees whose salary ranges between 2L to 3L.
-- select EmpName, Salary 
--  from Employee where salary between 200000 and 300000
--or--
--  select EmpName, Salary
--  from Employee where salary >=200000 and salary<=300000

--  Q1(b): Write a query to retrieve the list of employees from the same city.
--  select EmpName, City
--  from Employee
-- where City IN (select city from Employee group by city having count(city)>1)
--or--
-- select e1.Empname, e2.Empname, e1.city
--  from Employee e1
--  join Employee e2 on e1.city=e2.city and e1.Empid<e2.Empid

--  Q1(c): Query to find the null values in the Employee table.
--  select *
--- from Employee
--  where EmpId is null --as primarykey(EmpId) would be not null & no duplicates

-- Q2(a): Query to find the cumulative sum of employee’s salary.
-- cumulative total refers to the running sum of values over time(i.e. increasing or growing by successive additions)
-- select *
-- , sum(salary) over (order by EmpId asc) as running_sum
-- from Employee

-- Q2(b): What’s the male and female employees ratio.
-- select
-- (count(case when Gender='M' then 1 end) *100 / count(*)) as males_ratio
-- ,  count(case when Gender='F' then 1 end)*100 / count(*) as female_ratio
-- from Employee

-- Q2(c): Write a query to fetch 50% records from the Employee table.
-- select *
-- from Employee
-- where EmpId <= (select count(EmpId)/2 from employee)

/*
Q3: Query to fetch the employee’s salary but replace the LAST 2 digits with ‘XX’
i.e 12345 will be 123XX
*/


--Q4: Write a query to fetch even and odd rows from Employee table.
--ODD ROWS--
-- select *
-- from Employee
-- where EmpId%2!=0
--or--
select *
from 
(select *, row_number() over (order by EmpId asc) as rn from Employee) A
where A.rn%2=1
--or--
-- select * from Employee
-- where MOD(EmpId,2)

/*
-- Q5(a): Write a query to find all the Employee names whose name:
-- • Begin with ‘A’
Select * from Employee where Empname like 'A%'

-- • Contains ‘A’ alphabet at second place
Select * from Employee where Empname like '_A%'

-- • Contains ‘Y’ alphabet at second last place
Select * from Employee where Empname like '%Y_'

-- • Ends with ‘L’ and contains 4 alphabets
Select * from Employee where Empname like '____L'

-- • Begins with ‘V’ and ends with ‘A’
Select * from Employee where Empname like 'V%A'

-- Q5(b): Write a query to find the list of Employee names which is:
-- • starting with vowels (a, e, i, o, or u), without duplicates
Select Distinct Empname from Employee where 
Empname like 'A%' 
or Empname like 'E%'
or Empname like 'I%'
or Empname like 'O%'
or Empname like 'U%'
--or--
Select Distinct Empname from Employee 
where Empname like '[aieou]%'
--or using regex/rlike: --
SELECT DISTINCT Empname
FROM Employee
WHERE Empname like '^[aeiou]';


-- • ending with vowels (a, e, i, o, or u), without duplicates
Select Distinct Empname from Employee where 
Empname like '%[aeiou]'
--or using regex/rlike: --
SELECT DISTINCT Empname
FROM Employee
WHERE Empname like '[aeiou]$';


-- • starting & ending with vowels (a, e, i, o, or u), without duplicates
Select Distinct Empname from Employee where 
Empname like '[aeiou]%[aeiou]'
--or using regex/rlike: --
SELECT DISTINCT Empname
FROM Employee
WHERE Empname like '^[aeiou].*[aeiou]$';
*/

-- Q6: Find Nth highest salary from employee table with and without using the TOP/LIMIT keywords.
--assume here3rd highest salary:

select top 1 salary from Employee 
where salary <
(select top 1 salary
from Employee where salary < (select max(salary) from Employee)
order by salary desc) 
order by salary desc

--or--
/*
The LIMIT clause specifies the maximum number of rows to return. 
The OFFSET clause specifies the number of rows to skip before starting to return rows.

SELECT DISTINCT salary
FROM employees
ORDER BY salary DESC
LIMIT 1 OFFSET 2; 

*/

declare @n INT = 3;  -- can change this to any value for n-th highest salary

select TOP 1 Salary 
from 
(
select TOP (@n) salary 
from Employee 
order by salary desc
) A
order by salary asc

--finding the n-th highest salary without relying on LIMIT, OFFSET, or TOP--

--NESTED CORRELATED QUERY--as E1. salary in Inner query also--
select E1.salary from Employee E1
where  3 = (
select count(DISTINCT E2.salary) from Employee E2
where E2.Salary >= E1.Salary
)
--or--(both are same, just that in below query: N-1 and > used (not >=))
select E1.salary from Employee E1
where  2 = (
select count(DISTINCT E2.salary) from Employee E2
where E2.Salary > E1.Salary
)

--Q7(a): Write a query to find and remove duplicate records from a table.

--as considering EmpId is unique
Delete from Employee 
where EmpID IN (Select EmpID
from employee
group by EmpID
having count(*)>1
)

--or--But, best practice - to check with all the rows.
Select EmpId, EmpName, Gender, Salary, City, count(*) as duplicate_count
from Employee
group by EmpId, EmpName, Gender, Salary, City 
having count(*)>1;

--Q7(b): Query to retrieve the list of employees working in same project.
/*
Purpose: GROUP_CONCAT() (MySQL) or STRING_AGG() (PostgreSQL, SQL Server) is an aggregate function used to concatenate values of a column across multiple rows into a single string.
Scope: GROUP_CONCAT() operates across rows within each group (as defined by the GROUP BY clause). It combines the values of a column across multiple rows of a group into one string, 
with a specified separator (default is a comma in MySQL).

Purpose: The CONCAT() function is used to concatenate two or more strings into one. It can be used with literal values, columns, or any other expressions.
Scope: CONCAT() works on a row-by-row basis, meaning it will concatenate the values for a single row at a time.
*/

select ED.Project, STRING_AGG(E.EmpName,',') as emp from EmployeeDetail ED
inner join Employee E on ED.EmpID=E.EmpID
group by ED.Project
having count(*)>1
order by ED.Project;

with proj as (select ED.Project, E.EmpName, E.EmpId from EmployeeDetail ED
inner join Employee E on ED.EmpID=E.EmpID)
select * from proj p1 
join proj p2 on p1.project=p2.project
where p1.EmpId!=p2.EmpId and p1.EmpId < p2.EmpId;

--Q8: Show the employee with the highest salary for each project

select ED.Project, MAX(E.salary) as maxsal, SUM(E.salary) as totalsal
from EmployeeDetail ED
inner join Employee E on ED.EmpID=E.EmpID
group by ED.Project;


/*
Error: The column 'EmpID' was specified multiple times for 'max_salary'
on select e.EmpID,e.EmpName,e.Salary,ed.project, ed.EmpID

Solution:
Whenever you're joining tables and the same column exists in multiple tables, 
use aliases for the columns to avoid ambiguity.
ie. select e.EmpID,e.EmpName,e.Salary,ed.project, ed.EmpID as edEmployeeId
*/
with max_salary as 
(
select e.EmpID,e.EmpName,e.Salary,ed.project, ed.EmpID as edEmployeeId
, row_number() over (partition by ed.project order by e.salary desc) as rnk
from Employee e 
join EmployeeDetail ed on e.EmpID=ed.EmpID
)
select * from max_salary
where rnk=1

--Q9: Query to find the total count of employees joined each year
select DATEPART(Year,DOJ) as year,Count(EmpId) as cnt  --or--,Select YEAR(DOJ) as year--
from EmployeeDetail
GROUP by DATEPART(Year,DOJ);


--Q10: Create 3 groups based on salary col, salary less than 1L is low, 
-- between 1 -2L is medium and above 2L is High
select *,
case when salary < 100000 then 'Low' 
when salary between 100000 and 200000 then 'Medium' 
else 'High'
end as salary_groups
from Employee;

/*
BONUS: Query to pivot the data in the Employee table and retrieve the total
salary for each city.
The result should display the EmpID, EmpName, and separate columns for each city
(Mathura, Pune, Delhi), containing the corresponding total salary.
*/

select 
EmpID
, EmpName
, sum(case when city='Mathura' then salary end) as 'Mathura'
, sum(case when city='Pune' then salary end) as 'Pune'
, sum(case when city='Delhi' then salary end) as 'Delhi'
from Employee
group by EmpId, EmpName
