--day79: write an sql query that, for each experience level counts the total number of candidates 
--and how many of them got a perfect score in each category which they request to solve takss. 
--(a null means the candidate was not requestetd to solve task in that catgory)

create table assessments
(
id int,
experience int,
sql int,
algo int,
bug_fixing int
)
delete from assessments
insert into assessments values 
(1,3,100,null,50),
(2,5,null,100,100),
(3,1,100,100,100),
(4,5,100,50,null),
(5,5,100,100,100)


select * from assessments;

  
SELECT experience,
      COUNT(*) AS total_candidates,
      SUM(
          CASE 
              WHEN 
                  (CASE WHEN sql IS NULL OR sql = 100 THEN 1 ELSE 0 END + 
                    CASE WHEN algo IS NULL OR algo = 100 THEN 1 ELSE 0 END + 
                    CASE WHEN bug_fixing IS NULL OR bug_fixing = 100 THEN 1 ELSE 0 END) = 3 
              THEN 1 
              ELSE 0 
          END
      ) AS max_score_flag
FROM assessments
GROUP BY experience;

delete from assessments
insert into assessments values 
(1,2,null,null,null),
(2,20,null,null,20),
(3,7,100,null,100),
(4,3,100,50,null),
(5,2,40,100,100);

select * from assessments;

SELECT experience,
      COUNT(*) AS total_candidates,
      SUM(
          CASE 
              WHEN 
                  (CASE WHEN sql IS NULL OR sql = 100 THEN 1 ELSE 0 END + 
                    CASE WHEN algo IS NULL OR algo = 100 THEN 1 ELSE 0 END + 
                    CASE WHEN bug_fixing IS NULL OR bug_fixing = 100 THEN 1 ELSE 0 END) = 3 
              THEN 1 
              ELSE 0 
          END
      ) AS max_score_flag
FROM assessments
GROUP BY experience;

--or--

with cte as (
select id,experience, sql as score, 'sql' as subject
from assessments
union all
select id,experience, algo as score, 'algo' as subject
from assessments
union all
select id, experience, bug_fixing as score, 'bug_fixing' as subject
from assessments
)
select experience, count(*) as total_candidates
, sum(perfect_score_flag) as max_score_students
from
(
select id, experience
, case when sum(case when score is null or score=100 then 1 else 0 end)=3 then 1 else 0 end as perfect_score_flag
from cte
group by id, experience
) A
group by experience



/*to make dynamic, we can add one more unionall for new subject and use below query:
(
select id, experience
, case when 
     sum(case when score is null or score=100 then 1 else 0 end)
     = select count(distinct subject) from cte)
     then 1 else 0 end as perfect_score_flag
from cte
group by id, experience
) A
*/
