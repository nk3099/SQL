Day10: **trick_continuous_date_and_state

create table tasks (
date_value date,
state varchar(10)
);

insert into tasks  values ('2019-01-01','success'),('2019-01-02','success'),('2019-01-03','success'),('2019-01-04','fail')
,('2019-01-05','fail'),('2019-01-06','success');

select * from tasks;

/*TRICK: so whenever we have to group continous date together, we can subtract continuous number from them and then they will come to as Base day -- which we can use to group the data*/

with all_dates as( select *,
row_number() over (partition by state order by date_value) as rnk,
dateadd(day,-1*row_number() over (partition by state order by date_value),date_value) as group_date --subtracted -1,-2,-3 dates (ie, rnk) from date_value
from tasks
--order by date_value
)


/*First Query: In the first query, you're grouping by both group_date and state, but you're only selecting state, MIN(date_value), and MAX(date_value). If the values of group_date are the same for each grouping of state, the query doesn't generate an error because it effectively treats those groups as a single entity for that state. The SQL engine processes it without needing to show group_date since it isn't needed for the result output.*/

select group_date,state,min(date_value) as start_date, max(date_value) as end_date
from all_dates
group by group_date,state
order by start_date


/*Second Query: In the second query, you included group_date, which makes it clear which grouping you're referring to. Since both group_date and state are in the GROUP BY, this query is valid and will work as expected.*/

select state,min(date_value) as start_date, max(date_value) as end_date
from all_dates
group by group_date,state
order by start_date


--------------
-- OR --
--------------

with cte as (
SELECT *, lag(state, 1,state) over (order by date_value) as prev 
from tasks	
), cte2 as(
SELECT *, sum(case when prev = state then 0 else 1 end) over (order by date_value) as flag
from cte
)
SELECT min(date_value) as start, max(date_value) as endDate, min(state) as state
from cte2
GROUP BY flag

