Day8: tournament_winners

--query to find the winner in each group:
-- the winner in each group is the player who scored the maximum total points within the group. 
-- In the case of a tie, the lowest player_id wins.

create table players
(player_id int,
group_id int)

insert into players values (15,1);
insert into players values (25,1);
insert into players values (30,1);
insert into players values (45,1);
insert into players values (10,2);
insert into players values (35,2);
insert into players values (50,2);
insert into players values (20,3);
insert into players values (40,3);

create table matches
(
match_id int,
first_player int,
second_player int,
first_score int,
second_score int)

insert into matches values (1,15,45,3,0);
insert into matches values (2,30,25,1,2);
insert into matches values (3,30,15,2,0);
insert into matches values (4,40,20,5,2);
insert into matches values (5,35,50,1,1);

select * from players;
select * from matches;


-- with cte as 
-- (
-- select A.player_id,A.group_id, sum(A.pts) as total_pts,
-- rank() over (partition by group_id order by sum(A.pts) desc, A.player_id asc) as rnk
-- from (
-- select player_id, group_id,sum(m1.first_score) as pts
-- from players
-- inner join matches m1 ON m1.first_player=players.player_id
-- group by player_id,group_id
-- union all
-- select player_id, group_id,sum(m2.second_score) as pts
-- from players
-- inner join matches m2 ON m2.second_player=players.player_id
-- group by player_id,group_id ) A
-- group by A.player_id,A.group_id
-- )

-- select player_id,group_id,total_pts
-- from cte 
-- where rnk=1

--OR--

-- with player_score as(
-- select first_player as player_id, first_score as score from matches
-- union all 
-- select second_player as player_id, second_score as score from matches
-- )
-- ,final_score as (
-- select ps.player_id, sum(ps.score) as score, p.group_id,
-- rank() over (partition by group_id order by sum(ps.score) desc, ps.player_id asc) as rnk
-- from player_score ps
-- inner join players p ON p.player_id=ps.player_id
-- group by ps.player_id,p.group_id
-- )

-- select player_id, score, group_id
-- from final_score
-- where rnk=1

