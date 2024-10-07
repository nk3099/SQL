Day6:  friends_marks

—Query to find person id, name, no. of friends, sum of marks of person who have friends with total score greater than 100


with cte as(select f.personid,count(f.friendid) as num_friends,sum(f.score) as friends_marks
from person p
inner join friend f ON p.personid=f.friendid
group by f.personid)

select p.personid,p.name,c.num_friends,c.friends_score
from cte c
inner join person p ON p.personid=c.personid
where c.friends_score > 100
