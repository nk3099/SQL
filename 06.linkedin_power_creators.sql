--Day6:
--Data Lemur: LinkedIn Power Creators (Part 2) [LinkedIn SQL Interview Question]

Select pp.profile_id
from personal_profiles pp
Join employee_company ec on pp.profile_id=ec.personal_profile_id
Join company_pages cp on cp.company_id=ec.company_id
Group by pp.profile_id, pp.name, pp.followers
Having  pp.followers > sum(cp.followers)

--Note: the HAVING clause is used to filter results after an aggregation has taken place. You can use both aggregate functions (like SUM(), COUNT(), etc.) and non-aggregated columns in the HAVING clause, but any non-aggregated columns must also be included in the GROUP BY clause.
