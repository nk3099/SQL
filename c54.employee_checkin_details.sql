--Day54: employee_checkin_details
CREATE TABLE employee_checkin_details (
    employeeid	INT,
    entry_details	VARCHAR(20),
    timestamp_details	datetime
);

INSERT INTO employee_checkin_details (employeeid, entry_details, timestamp_details) VALUES ('1000', 'login', '2023-06-16 01:00:15.34');
INSERT INTO employee_checkin_details (employeeid, entry_details, timestamp_details) VALUES ('1000', 'login', '2023-06-16 02:00:15.34');
INSERT INTO employee_checkin_details (employeeid, entry_details, timestamp_details) VALUES ('1000', 'login', '2023-06-16 03:00:15.34');
INSERT INTO employee_checkin_details (employeeid, entry_details, timestamp_details) VALUES ('1000', 'logout', '2023-06-16 12:00:15.34');
INSERT INTO employee_checkin_details (employeeid, entry_details, timestamp_details) VALUES ('1001', 'login', '2023-06-16 01:00:15.34');
INSERT INTO employee_checkin_details (employeeid, entry_details, timestamp_details) VALUES ('1001', 'login', '2023-06-16 02:00:15.34');
INSERT INTO employee_checkin_details (employeeid, entry_details, timestamp_details) VALUES ('1001', 'login', '2023-06-16 03:00:15.34');
INSERT INTO employee_checkin_details (employeeid, entry_details, timestamp_details) VALUES ('1001', 'logout', '2023-06-16 12:00:15.34');


CREATE TABLE employee_details (
    employeeid	INT,
    phone_number	INT,
    isdefault	VARCHAR(512)
);

INSERT INTO employee_details (employeeid, phone_number, isdefault) VALUES ('1001', '9999', 'false');
INSERT INTO employee_details (employeeid, phone_number, isdefault) VALUES ('1001', '1111', 'false');
INSERT INTO employee_details (employeeid, phone_number, isdefault) VALUES ('1001', '2222', 'true');
INSERT INTO employee_details (employeeid, phone_number, isdefault) VALUES ('1003', '3333', 'false');

select * from employee_checkin_details;
select * from employee_details;


--employeeid,totalentry,totallogin,totallogout,latestlogin,latestlogout,employee_default_phone_number

with logins as(
select employeeid,count(*) as totallogin,max(timestamp_details) as latestlogin
from employee_checkin_details
where entry_details='login'
group by employeeid
)
, logouts as(
select employeeid,count(*) as totallogout,max(timestamp_details) as latestlogout
from employee_checkin_details
where entry_details='logout'
group by employeeid
)

select a.employeeid,a.totallogin,a.latestlogin, b.totallogout, b.latestlogout
, a.totallogin + b.totallogout as total_entry
, c.phone_number
, c.isdefault
from logins a
inner join logouts b on a.employeeid=b.employeeid
left join employee_details c on a.employeeid=c.employeeid and c.isdefault='true' --performance wise this is better

--OR--
-- where c.isdefault='true' or c.isdefault is null
-- order by a.employeeid

----OR----

select  b.employeeid, count(b.employeeid) as totalentry
, e.phone_number
, sum(case when entry_details='login' then 1 else 0 end) as totallogin
--OR-- , count(case when entry_details='login' then timestamp_details else null end) as totallogin
, max(case when entry_details='login' then timestamp_details else null end) as latestlogin
, sum(case when entry_details='logout' then 1 else 0 end) as totallogout
, max(case when entry_details='logout' then timestamp_details end) as latestlogout
from employee_checkin_details b
left join employee_details e on b.employeeid=e.employeeid and e.isdefault='true' --performance wise this is better
group by b.employeeid,e.phone_number

