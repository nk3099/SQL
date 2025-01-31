
--day75. Probo interview question: Redistributed_money

create table polls
(
user_id varchar(4),
poll_id varchar(3),
poll_option_id varchar(3),
amount int,
created_date date
)
-- Insert sample data into the investments table
INSERT INTO polls (user_id, poll_id, poll_option_id, amount, created_date) VALUES
('id1', 'p1', 'A', 200, '2021-12-01'),
('id2', 'p1', 'C', 250, '2021-12-01'),
('id3', 'p1', 'A', 200, '2021-12-01'),
('id4', 'p1', 'B', 500, '2021-12-01'),
('id5', 'p1', 'C', 50, '2021-12-01'),
('id6', 'p1', 'D', 500, '2021-12-01'),
('id7', 'p1', 'C', 200, '2021-12-01'),
('id8', 'p1', 'A', 100, '2021-12-01'),
('id9', 'p2', 'A', 300, '2023-01-10'),
('id10', 'p2', 'C', 400, '2023-01-11'),
('id11', 'p2', 'B', 250, '2023-01-12'),
('id12', 'p2', 'D', 600, '2023-01-13'),
('id13', 'p2', 'C', 150, '2023-01-14'),
('id14', 'p2', 'A', 100, '2023-01-15'),
('id15', 'p2', 'C', 200, '2023-01-16');

create table poll_answers
(
poll_id varchar(3),
correct_option_id varchar(3)
)

-- Insert sample data into the poll_answers table
INSERT INTO poll_answers (poll_id, correct_option_id) VALUES
('p1', 'C'),('p2', 'A');


select * from polls;
select * from poll_answers;

--money to be redistributed ie. (of losers) -> 1500 
--id2->250, id5->50, id7->200, total=500  (winners invested money)
--id2->50%, id5->10%, id7->40% (winners invested money% from total=500)
--id2=750, id5=150, id7=600  (therefore, % from money of losers = 1500)


with cte as 
(select p.poll_id, sum(amount) as redistribute_money
from polls p 
join poll_answers pa on p.poll_id=pa.poll_id and p.poll_option_id!=pa.correct_option_id
group by p.poll_id
)
, cte2 as 
(select p.user_id, p.poll_id, amount
, sum(p.amount) over (partition by p.poll_id) as winners_money
, amount*1.0/sum(p.amount) over (partition by p.poll_id) as proportion
from polls p 
join poll_answers pa on p.poll_id=pa.poll_id and p.poll_option_id=pa.correct_option_id
)

select cte.poll_id, cte2.user_id
, (redistribute_money*proportion) as winning_amount
from cte2
inner join cte on cte2.poll_id = cte.poll_id;


--or--

with cte3 as 
(
select p.poll_id, p.user_id, p.poll_option_id, p.amount, pa.poll_id as pa_pollid, pa.correct_option_id
, sum(case when p.poll_option_id=pa.correct_option_id then amount end) over (partition by p.poll_id) as winners_money
, sum(case when p.poll_option_id<>pa.correct_option_id then amount end) over (partition by p.poll_id) as redistributed_money
--, SUM(amount) FILTER(WHERE poll_option_id<>correct_option_id) OVER(PARTITION BY poll_id) as total_losers_amount
from polls p
left join poll_answers pa on p.poll_id=pa.poll_id
)

select  poll_id, user_id, (amount*1.0/winners_money)*redistributed_money as total
,amount*(redistributed_money/winners_money) as alsocorrect
from cte3
where poll_option_id=correct_option_id
