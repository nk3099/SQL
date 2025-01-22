--day68. --for each region find house which has won maximum no. of battles. 
--Display region, house and no. of wins.

--Create the 'king' table
CREATE TABLE king (
    k_no INT PRIMARY KEY,
    king VARCHAR(40),
    house VARCHAR(40)
);

-- Create the 'battle' table
CREATE TABLE battle (
    battle_number INT PRIMARY KEY,
    name VARCHAR(40),
    attacker_king INT,
    defender_king INT,
    attacker_outcome INT,
    region VARCHAR(40),
    FOREIGN KEY (attacker_king) REFERENCES king(k_no),
    FOREIGN KEY (defender_king) REFERENCES king(k_no)
);

delete from king;
INSERT INTO king (k_no, king, house) VALUES
(1, 'Robb Stark', 'House Stark'),
(2, 'Joffrey Baratheon', 'House Lannister'),
(3, 'Stannis Baratheon', 'House Baratheon'),
(4, 'Balon Greyjoy', 'House Greyjoy'),
(5, 'Mace Tyrell', 'House Tyrell'),
(6, 'Doran Martell', 'House Martell');

delete from battle;
-- Insert data into the 'battle' table
INSERT INTO battle (battle_number, name, attacker_king, defender_king, attacker_outcome, region) VALUES
(1, 'Battle of Oxcross', 1, 2, 1, 'The North'),
(2, 'Battle of Blackwater', 3, 4, 0, 'The North'),
(3, 'Battle of the Fords', 1, 5, 1, 'The Reach'),
(4, 'Battle of the Green Fork', 2, 6, 0, 'The Reach'),
(5, 'Battle of the Ruby Ford', 1, 3, 1, 'The Riverlands'),
(6, 'Battle of the Golden Tooth', 2, 1, 0, 'The North'),
(7, 'Battle of Riverrun', 3, 4, 1, 'The Riverlands'),
(8, 'Battle of Riverrun', 1, 3, 0, 'The Riverlands');

select * from battle;
select * from king;

with cte as(
select *
, case when attacker_outcome=1 then attacker_king else defender_king end as winner
from battle
)

select * from 
(
select region,house,count(house) as no_of_wins
, rank() over(partition by region order by count(house) desc) as rnk
from cte 
join king 
on cte.winner=king.k_no
group by region,house
-- order by region,house
) A 
where rnk=1;

----as we have to give name of subquery (ie. alias) in SQL as mandatory


--OR--
--getting all wins from attacker_king and defender_king
with wins as(
select attacker_king as king,region
from battle
where attacker_outcome=1
union all
select defender_king as king,region
from battle
where attacker_outcome=0
)

select * from
(
select w.region,k.house,count(*) as no_of_wins
, rank() over(partition by w.region order by count(*) desc) as rnk
from wins w
join king k on w.king=k.k_no
group by w.region, k.house
-- order by w.region, k.house
) A 
where rnk=1;


--OR--
-- select * battle b
-- inner join king k on k.kno = case when attacker_outcome=1 then attacker_king else defender_king end;

select * from
(
select b.region,k.house,count(*) as no_of_wins
, rank() over(partition by b.region order by count(*) desc) as rnk
from battle b
inner join king k on k.k_no = case when attacker_outcome=1 then attacker_king else defender_king end
group by b.region, k.house
-- order by b.region, k.house
) A 
where rnk=1;

