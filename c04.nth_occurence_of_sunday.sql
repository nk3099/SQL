Day4: nth_occurence_of_sunday

--Query to provide the date for nth occurrence of Sunday in future from given date.
--datepart:
--sunday-1, monday-2,friday-6,saturday-7	

declare @today_date date;
declare @n int;
set @today_date = '2022-01-01'; --Saturday
set @n=3;

--for fist sunday occurence: dateadd(day,8-datepart(weekday,@today_date),@today_date) 
select dateadd(week,@n-1,dateadd(day,8-datepart(weekday,@today_date),@today_date)) as nth_sunday;


--OR--
DECLARE @first_sunday_date DATE;
set @first_sunday_date = DATEADD(DAY,8 - DATEPART(WEEKDAY,@today_date),@today_date);
select DATEADD(DAY, (@n - 1) * 7, @first_sunday_date) AS nth_sunday_date;

