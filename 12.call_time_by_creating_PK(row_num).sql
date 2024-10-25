Day12:call_time_by_creating_PK(row_num)
    
CREATE TABLE call_start_logs
(
    phone_number VARCHAR(10),
    start_time DATETIME
);

INSERT INTO call_start_logs VALUES
('PN1', '2022-01-01 10:20:00'),
('PN1', '2022-01-01 16:25:00'),
('PN2', '2022-01-01 12:30:00'),
('PN3', '2022-01-02 10:00:00'),
('PN3', '2022-01-02 12:30:00'),
('PN3', '2022-01-03 09:20:00');

CREATE TABLE call_end_logs
(
    phone_number VARCHAR(10),
    end_time DATETIME
);

INSERT INTO call_end_logs VALUES
('PN1', '2022-01-01 10:45:00'),
('PN1', '2022-01-01 17:05:00'),
('PN2', '2022-01-01 12:55:00'),
('PN3', '2022-01-02 10:20:00'),
('PN3', '2022-01-02 12:50:00'),
('PN3', '2022-01-03 09:40:00');

Select * from call_start_logs;
Select * from call_end_logs;

-- Assuming call starting first would be ending first:
--Thereby, creating RowNumber to act as primary key with phone_number,ie. pk = {ROW_NUMBER,phone_number}
WITH startcall AS 
(SELECT *, ROW_NUMBER() OVER (PARTITION BY phone_number ORDER BY start_time) AS start_row 
FROM call_start_logs
),
endcall AS
(SELECT *, ROW_NUMBER() OVER (PARTITION BY phone_number ORDER BY end_time) AS end_row 
FROM call_end_logs
)
SELECT st.phone_number,st.start_time,ec.end_time,
DATEDIFF(minute,start_time,end_time) as duration
FROM startcall st
JOIN endcall ec ON st.phone_number=ec.phone_number and st.start_row=ec.end_row

--OR--
--using JOINS :

Select A.phone_number, A.rn, A.start_time, B.end_time,
DATEDIFF(minute,start_time,end_time) as duration
FROM
(SELECT *,ROW_NUMBER() OVER (PARTITION BY phone_number ORDER BY start_time) AS rn 
FROM call_start_logs) A
Inner Join
(SELECT *,ROW_NUMBER() OVER (PARTITION BY phone_number ORDER BY end_time) AS rn 
FROM call_end_logs) B
ON A.phone_number=B.phone_number and A.rn=B.rn


--OR--
--using UNION method:

Select phone_number, rn, min(call_time) as starttime, max(call_time) as endtime,
DATEDIFF(minute,min(call_time),max(call_time)) as duration
FROM
(SELECT phone_number,start_time as call_time, ROW_NUMBER() OVER (PARTITION BY phone_number ORDER BY start_time) AS rn 
FROM call_start_logs
UNION ALL
SELECT phone_number,end_time as call_time, ROW_NUMBER() OVER (PARTITION BY phone_number ORDER BY end_time) AS start_row 
FROM call_end_logs)A
group by phone_number,rn



