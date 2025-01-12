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

-- -- Q1(a): Find the list of employees whose salary ranges between 2L to 3L.
-- select EmpName, Salary 
-- from Employee where salary between 200000 and 300000
-- --or--
-- select EmpName, Salary
-- from Employee where salary >=200000 and salary<=300000

-- -- Q1(b): Write a query to retrieve the list of employees from the same city.
-- select EmpName, City
-- from Employee
-- where City IN (select city from Employee group by city having count(city)>1)
-- --or--
-- select e1.Empname, e2.Empname, e1.city
-- from Employee e1
-- join Employee e2 on e1.city=e2.city and e1.Empid<e2.Empid

-- -- Q1(c): Query to find the null values in the Employee table.
-- select *
-- from Employee
-- where EmpId is null --as primarykey(EmpId) would be not null & no duplicates

--Q2(a): Query to find the cumulative sum of employee’s salary.
--cumulative total refers to the running sum of values over time(i.e. increasing or growing by successive additions)
select *
, sum(salary) over (order by EmpId asc) as running_sum
from Employee

--Q2(b): What’s the male and female employees ratio.
select
(count(case when Gender='M' then 1 end) *100 / count(*)) as males_ratio
,  count(case when Gender='F' then 1 end)*100 / count(*) as female_ratio
from Employee

--Q2(c): Write a query to fetch 50% records from the Employee table.
select *
from Employee
where EmpId <= (select count(EmpId)/2 from employee)

/*
Q3: Query to fetch the employee’s salary but replace the LAST 2 digits with ‘XX’
i.e 12345 will be 123XX

Q4: Write a query to fetch even and odd rows from Employee table.

Q5(a): Write a query to find all the Employee names whose name:
• Begin with ‘A’
• Contains ‘A’ alphabet at second place
• Contains ‘Y’ alphabet at second last place
• Ends with ‘L’ and contains 4 alphabets
• Begins with ‘V’ and ends with ‘A’

Q5(b): Write a query to find the list of Employee names which is:
• starting with vowels (a, e, i, o, or u), without duplicates
• ending with vowels (a, e, i, o, or u), without duplicates
• starting & ending with vowels (a, e, i, o, or u), without duplicates

Q6: Find Nth highest salary from employee table with and without using the
TOP/LIMIT keywords.

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



