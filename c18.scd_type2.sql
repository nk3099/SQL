 Day18:  SCD Type 2  — total charges as per billing rate

create table billings 
(
emp_name varchar(10),
bill_date date,
bill_rate int
);
delete from billings;
insert into billings values
('Sachin','01-JAN-1990',25)
,('Sehwag' ,'01-JAN-1989', 15)
,('Dhoni' ,'01-JAN-1989', 20)
,('Sachin' ,'05-Feb-1991', 30)
;

create table HoursWorked 
(
emp_name varchar(20),
work_date date,
bill_hrs int
);
insert into HoursWorked values
('Sachin', '01-JUL-1990' ,3)
,('Sachin', '01-AUG-1990', 5)
,('Sehwag','01-JUL-1990', 2)
,('Sachin','01-JUL-1991', 4)


select * from billings;
select * from HoursWorked;

with date_range as(select *, 
lead(dateadd(day,-1,bill_date),1,'1999-12-31') over (partition by emp_name order by bill_date asc) as bill_date_end
from billings )

--dateadd(day,-1,bill_date) : as Sachin bill_date_end and next bill_date overlapping(ie, same)

select hw.emp_name as emp_name,
sum(dr.bill_rate * hw.bill_hrs) as total_charges
from date_range dr
left join HoursWorked hw on hw.emp_name=dr.emp_name and hw.work_date between dr.bill_date and dr.bill_date_end
group by hw.emp_name

