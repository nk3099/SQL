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



/*
Q7(a): Write a query to find and remove duplicate records from a table.
Q7(b): Query to retrieve the list of employees working in same project.

Q8: Show the employee with the highest salary for each project

Q9: Query to find the total count of employees joined each year

Q10: Create 3 groups based on salary col, salary less than 1L is low, between 1 -
2L is medium and above 2L is High

BONUS: Query to pivot the data in the Employee table and retrieve the total
salary for each city.
The result should display the EmpID, EmpName, and separate columns for each city
(Mathura, Pune, Delhi), containing the corresponding total salary.
*/
