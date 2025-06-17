-- Day6:  friends_marks
-- Query to find person id, name, no. of friends, sum of marks of person who have friends with total score greater than 100

with cte as(select f.personid,count(f.friendid) as num_friends,sum(f.score) as friends_marks
from person p
inner join friend f ON p.personid=f.friendid
group by f.personid)

select p.personid,p.name,c.num_friends,c.friends_score
from cte c
inner join person p ON p.personid=c.personid
where c.friends_score > 100


---OR---

Create table friend (pid int, fid int)
-- insert into friend (pid , fid ) values ('1','2');
-- insert into friend (pid , fid ) values ('1','3');
-- insert into friend (pid , fid ) values ('2','1');
-- insert into friend (pid , fid ) values ('2','3');
-- insert into friend (pid , fid ) values ('3','5');
-- insert into friend (pid , fid ) values ('4','2');
-- insert into friend (pid , fid ) values ('4','3');
-- insert into friend (pid , fid ) values ('4','5');

-- create table person (PersonID int,	Name varchar(50),	Score int)
-- insert into person(PersonID,Name ,Score) values('1','Alice','88')
-- insert into person(PersonID,Name ,Score) values('2','Bob','11')
-- insert into person(PersonID,Name ,Score) values('3','Devis','27')
-- insert into person(PersonID,Name ,Score) values('4','Tara','45')
-- insert into person(PersonID,Name ,Score) values('5','John','63')
-- select * from person
-- select * from friend;


-- with cte as (
-- select f.pid,p.name--,p.score, f.fid, p2.name, p2.score
-- , sum(p2.score) as totalfriendscore
-- , count(*) as numberoffriends
-- from friend f
-- join person p on f.pid=p.PersonID
-- join person p2 on f.fid=p2.PersonID
-- group by f.pid, p.name
-- )
-- select c.pid,p.name, c.numberoffriends, c.totalfriendscore
-- from cte c 
-- join person p on c.pid = p.PersonID
-- where c.totalfriendscore > 100
