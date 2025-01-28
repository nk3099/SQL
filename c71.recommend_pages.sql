--day71. --determine the user ids and corresponding page_ids of the pages
--liked by their friend but not by user itself yet

CREATE TABLE friends (
    user_id INT,
    friend_id INT
);

-- Insert data into friends table
INSERT INTO friends VALUES
(1, 2),
(1, 3),
(1, 4),
(2, 1),
(3, 1),
(3, 4),
(4, 1),
(4, 3);

-- Create likes table
CREATE TABLE likes (
    user_id INT,
    page_id CHAR(1)
);

-- Insert data into likes table
INSERT INTO likes VALUES
(1, 'A'),
(1, 'B'),
(1, 'C'),
(2, 'A'),
(3, 'B'),
(3, 'C'),
(4, 'B');


select * from friends;
select * from likes;

--solution 1:

with user_pages as (
select distinct f.user_id,l.page_id
from friends f 
inner join likes l on f.user_id=l.user_id
-- order by f.user_id
)
, friends_pages as (
select f.user_id,f.friend_id,l.page_id
from friends f 
inner join likes l on f.friend_id=l.user_id
-- order by f.user_id
)
--DISTINCT generally applies to all columns in the SELECT list.
select distinct fp.user_id, fp.page_id
from friends_pages fp 
left join user_pages up 
on fp.user_id=up.user_id and fp.page_id=up.page_id --means like by friends and user also
where up.user_id is null --therefore, taking where up.user_id is null (means only liked by friends)
order by fp.user_id;


--solution 2: without cte

select * from friends f 
inner join likes fp on f.friend_id=fp.user_id 
left join likes up on  f.user_id=up.user_id and fp.page_id=up.page_id 
where up.page_id is null;


--solution 3: NOT IN (on 2 columns)
select f.user_id, fp.page_id --, CONCAT(f.user_id,fp.page_id) as concat_columns 
from friends f 
inner join likes fp on f.friend_id=fp.user_id
where CONCAT(f.user_id,fp.page_id) 
NOT IN 
(
--these are user_pages:
select distinct CONCAT(f.user_id,fp.page_id) as concat_columns 
from friends f 
inner join likes fp on f.user_id=fp.user_id
)
group by f.user_id, fp.page_id; --(or) also could have done "select DISTINCT f.user_id, fp.page_id" instead of GroupBy


--solution 4: simple using NOT IN 
-- with cte as
-- (
-- select distinct f.user_id, l.page_id from friends f
-- join likes l on f.friend_id = l.user_id
-- )
-- select user_id, page_id from cte
-- where (user_id, page_id) not in (select user_id, page_id from likes);


-- from user_pages u 
-- group by u.user_id
-- having u.page_id not in (select f.page_id from friends_pages f)


