--Day8:
--There are 2 tables, first table has 5 records and second table has 10 records. Assume any values in each of the tables.
--How many maximum and minimum records possible in case of inner join, left join, right join and full outer join.

Solution:
—————

For Inner join:
Max: 50 records
Min: 0 records

For Left join:
Max: 50 records
Min: 5 records

For Right join:
Max: 50 records
Min:  10 records

For Full outer join:
Max: 50 records
Min: 10 records
Example: 
For minimum:
if we change the table structure we only got 10 records as min output

T1: 1,2,3,4,5
T2: 1,2,3,4,5,6,7,8,9,10

Therefore, total 10 records (ie. 5 matching and 5 non matching)
