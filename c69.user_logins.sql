--day69. SQL complete case study based on real interview.  
CREATE TABLE users (
    USER_ID INT PRIMARY KEY,
    USER_NAME VARCHAR(20) NOT NULL,
    USER_STATUS VARCHAR(20) NOT NULL
);

CREATE TABLE logins (
    USER_ID INT,
    LOGIN_TIMESTAMP DATETIME NOT NULL,
    SESSION_ID INT PRIMARY KEY,
    SESSION_SCORE INT,
    FOREIGN KEY (USER_ID) REFERENCES USERS(USER_ID)
);

-- Users Table
INSERT INTO USERS VALUES (1, 'Alice', 'Active');
INSERT INTO USERS VALUES (2, 'Bob', 'Inactive');
INSERT INTO USERS VALUES (3, 'Charlie', 'Active');
INSERT INTO USERS  VALUES (4, 'David', 'Active');
INSERT INTO USERS  VALUES (5, 'Eve', 'Inactive');
INSERT INTO USERS  VALUES (6, 'Frank', 'Active');
INSERT INTO USERS  VALUES (7, 'Grace', 'Inactive');
INSERT INTO USERS  VALUES (8, 'Heidi', 'Active');
INSERT INTO USERS VALUES (9, 'Ivan', 'Inactive');
INSERT INTO USERS VALUES (10, 'Judy', 'Active');

-- Logins Table 

INSERT INTO LOGINS  VALUES (1, '2023-07-15 09:30:00', 1001, 85);
INSERT INTO LOGINS VALUES (2, '2023-07-22 10:00:00', 1002, 90);
INSERT INTO LOGINS VALUES (3, '2023-08-10 11:15:00', 1003, 75);
INSERT INTO LOGINS VALUES (4, '2023-08-20 14:00:00', 1004, 88);
INSERT INTO LOGINS  VALUES (5, '2023-09-05 16:45:00', 1005, 82);

INSERT INTO LOGINS  VALUES (6, '2023-10-12 08:30:00', 1006, 77);
INSERT INTO LOGINS  VALUES (7, '2023-11-18 09:00:00', 1007, 81);
INSERT INTO LOGINS VALUES (8, '2023-12-01 10:30:00', 1008, 84);
INSERT INTO LOGINS  VALUES (9, '2023-12-15 13:15:00', 1009, 79);


-- 2024 Q1
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (1, '2024-01-10 07:45:00', 1011, 86);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (2, '2024-01-15 09:30:00', 1012, 89);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (3, '2024-02-05 11:00:00', 1013, 78);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (4, '2024-03-01 14:30:00', 1014, 91);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (5, '2024-03-15 16:00:00', 1015, 83);

INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (6, '2024-04-12 08:00:00', 1016, 80);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (7, '2024-05-18 09:15:00', 1017, 82);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (8, '2024-05-28 10:45:00', 1018, 87);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (9, '2024-06-15 13:30:00', 1019, 76);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (10, '2024-06-25 15:00:00', 1010, 92);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (10, '2024-06-26 15:45:00', 1020, 93);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (10, '2024-06-27 15:00:00', 1021, 92);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (10, '2024-06-28 15:45:00', 1022, 93);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (1, '2024-01-10 07:45:00', 1101, 86);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (3, '2024-01-25 09:30:00', 1102, 89);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (5, '2024-01-15 11:00:00', 1103, 78);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (2, '2025-01-10 07:45:00', 1201, 82);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (4, '2023-11-25 09:30:00', 1202, 84);
INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (6, '2023-11-15 11:00:00', 1203, 80);


select * from users;
select * from logins;


--1.Management wants to see all the users that did not login in past 5 months 
--return: username.

--today's date: 22nd Jan 2025
--5months back(prev.) date: 22nd August 2024 
select USER_ID,MAX(LOGIN_TIMESTAMP) as latest_login
from logins
group by USER_ID
having MAX(LOGIN_TIMESTAMP) < DATEADD(month,-5,GETDATE()) -- as prev_5month_date

--or--
select USER_ID from logins 
where USER_ID NOT IN
(select USER_ID
from logins
where LOGIN_TIMESTAMP > DATEADD(month,-5,GETDATE()) --who logged in after last 5 months inner-subquery
)


--2. For the business units' quarterly analysis, calculate how many users and 
--how many sessions were at each quarter. 
--order by quarter from newsest to oldest. 
--Return: first day of the quarter, user_cnt, session_cnt

select 
--datepart(quarter,LOGIN_TIMESTAMP) as quarter_no, 
count(*) as session_cnt
, count(distinct USER_ID) as user_cnt
--, min(LOGIN_TIMESTAMP) as quarter_first_login
, DATETRUNC(quarter, min(LOGIN_TIMESTAMP)) as first_quarter_date
from logins
group by datepart(quarter,LOGIN_TIMESTAMP)

--DATETRUNC function:  in SQL is used to truncate a date or timestamp
--to a specified unit of time (such as year, month, day, hour, etc.)
--In general, truncate means to shorten or cut off something



--3. Display user id's that Log-in in January 2023 and 
--did not Log-in on November 2023 
-- Return: User_id

select distinct USER_ID
from  logins 
where LOGIN_TIMESTAMP between '2023-01-01' and '2023-01-31'
and USER_ID NOT IN (select USER_ID
from logins
where LOGIN_TIMESTAMP between '2023-11-01' and '2023-11-30'
);



--4.Add to the query from 2 the percent change in sessions from last quarter. 
--Return : first day of the quarter, session_cnt, session_cnt_prev, session_percentage_change

with cte as(
select count(*) as session_cnt
, count(distinct USER_ID) as user_cnt
, DATETRUNC(quarter, min(LOGIN_TIMESTAMP)) as first_quarter_date
from logins
group by datepart(quarter,LOGIN_TIMESTAMP)
-- order by first_quarter_date
)

select * 
, lag(session_cnt,1) over (order by first_quarter_date) as prev_session_cnt
, (session_cnt- (lag(session_cnt,1,session_cnt) over (order by first_quarter_date))*100.0)/(lag(session_cnt,1,session_cnt) over (order by first_quarter_date)) as session_percentage_change
from cte;


--5. Display the user that had the highest session score (max) for each day. --Return: Date, username, score

with cte as(
select user_id,CAST(LOGIN_TIMESTAMP as date) as date, sum(SESSION_SCORE) as score
from logins
group by user_id, CAST(LOGIN_TIMESTAMP as date)
-- order by date, score
)
select * from
(
select *
, row_number() over (partition by date order by score desc) as rnk
from cte
) A
where rnk=1

/*as:

user_id     date             score      
----------- ---------------- -----------
 5        2024-01-15          78
 2       2024-01-15          89
 
therefore, need to print user_id having max(session score) for each day now.

user_id     date             score       rnk                 
----------- ---------------- ----------- --------------------

   2       2024-01-15          89                    1
   5       2024-01-15          78                    2
*/


--6. To identify our best users - Return the usres that had a session on every single day since their first login. 
--(make assumptions if needed). 
--Return: User_id





