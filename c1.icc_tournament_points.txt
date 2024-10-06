Day1:  icc_tournament_points

create table icc_world_cup
(
match_no int,
team_1 Varchar(20),
team_2 Varchar(20),
winner Varchar(20)
);
INSERT INTO icc_world_cup values(1,'ENG','NZ','NZ');
INSERT INTO icc_world_cup values(2,'PAK','NED','PAK');
INSERT INTO icc_world_cup values(3,'AFG','BAN','BAN');
INSERT INTO icc_world_cup values(4,'SA','SL','SA');
INSERT INTO icc_world_cup values(5,'AUS','IND','IND');
INSERT INTO icc_world_cup values(6,'NZ','NED','NZ');
INSERT INTO icc_world_cup values(7,'ENG','BAN','ENG');
INSERT INTO icc_world_cup values(8,'SL','PAK','PAK');
INSERT INTO icc_world_cup values(9,'AFG','IND','IND');
INSERT INTO icc_world_cup values(10,'SA','AUS','SA');
INSERT INTO icc_world_cup values(11,'BAN','NZ','NZ');
INSERT INTO icc_world_cup values(12,'PAK','IND','IND');
INSERT INTO icc_world_cup values(12,'SA','IND','DRAW');

select * from icc_world_cup

select team_1 as team,
case when winner=team_1 then 1 else 0 end as win_flag,
case when winner='DRAW' then 1 else 0 end as draw_flag
from icc_world_cup

select team, count(1) as matches, sum(win_flag) as wins, count(1)-sum(win_flag) as loss,
sum(draw_flag) as drawNR, sum(win_flag)*2 as pts,sum(draw_flag)+sum(win_flag)*2 as finalpts
-- ,case 
-- when sum(draw_flag)=1 then sum(draw_flag)+sum(win_flag)*2
-- else sum(win_flag)*2
-- end as finalpts
from
(select team_1 as team,
case when winner=team_1 then 1 else 0 end as win_flag,
case when winner='DRAW' then 1 else 0 end as draw_flag
from icc_world_cup
union all
select team_2 as team,
case when winner=team_2 then 1 else 0 end as win_flag,
case when winner='DRAW' then 1 else 0 end as draw_flag
from icc_world_cup) A
group by team
order by pts desc,team asc
