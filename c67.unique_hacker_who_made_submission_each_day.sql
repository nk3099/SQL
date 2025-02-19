/*

hackerrank: https://www.hackerrank.com/challenges/15-days-of-learning-sql/problem?isFullScreen=true

Julia conducted a  days of learning SQL contest. 
The start date of the contest was March 01, 2016 and the end date was March 15, 2016.

Write a query to print total number of unique hackers who made at least
submission each day (starting on the first day of the contest), and find the hacker_id 
and name of the hacker who made maximum number of submissions each day. 

If more than one such hacker has a maximum number of submissions, print the lowest hacker_id. 
The query should print this information for each day of the contest, sorted by the date.

*/

CREATE TABLE Submissions (
    submission_date DATE,
    submission_id INT PRIMARY KEY,
    hacker_id INT,
    score INT
);

INSERT INTO Submissions (submission_date, submission_id, hacker_id, score) VALUES
('2016-03-01', 8494, 20703, 0),
('2016-03-01', 22403, 53473, 15),
('2016-03-01', 23965, 79722, 60),
('2016-03-01', 30173, 36396, 70),
('2016-03-02', 34928, 20703, 0),
('2016-03-02', 38740, 15758, 60),
('2016-03-02', 42769, 79722, 25),
('2016-03-02', 44364, 79722, 60),
('2016-03-03', 45440, 20703, 0),
('2016-03-03', 49050, 36396, 70),
('2016-03-03', 50273, 79722, 5),
('2016-03-04', 50344, 20703, 0),
('2016-03-04', 51360, 44065, 90),
('2016-03-04', 54404, 53473, 65),
('2016-03-04', 61533, 79722, 15),
('2016-03-05', 72852, 20703, 0),
('2016-03-05', 74546, 38289, 0),
('2016-03-05', 76487, 62529, 0),
('2016-03-05', 82439, 36396, 10),
('2016-03-05', 90006, 36396, 40),
('2016-03-06', 90404, 20703, 0);

select * from Submissions;


with cte as(
select submission_date, hacker_id, count(*) as no_of_submissions
, dense_rank() over (order by submission_date) as day_number
from Submissions
group by submission_date, hacker_id
--order by submission_date, hacker_id
)

/*UNIQUE_COUNT*/
--now, to get no. of submissions the hacker has done till date.
--therefore, if till_date_submission == day_number, then those will be considered as unique_count
--ie. no of user submitting everyday!

--and

/*HACKER_ID*/
--hacker_id will be based on the hacker who has submitted max no. of submissions on that day,
--irrespective of whether he has submitted previous day or not.

, cte2 as
(select * 
, count(*) over (partition by hacker_id order by submission_date) as till_date_submission
, case when day_number=count(*) over (partition by hacker_id order by submission_date)
then 1 else 0 end as unique_flag
from cte
--order by submission_date,hacker_id;
)
,cte3 as(
select *
,sum(unique_flag) over (partition by submission_date) as unique_count
,row_number() over (partition by submission_date order by no_of_submissions desc, hacker_id) as rn
from cte2
)

select submission_date,unique_count,hacker_id 
from cte3
where rn=1
order by submission_date;

