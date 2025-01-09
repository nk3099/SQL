--Day61: First Name , Middle Name and Last Name of a Customer

create table customers  (customer_name varchar(30))
insert into customers values ('Ankit Bansal')
,('Vishal Pratap Singh')
,('Michael'); 

select * 
from customers;

/*
CHARINDEX(element, from where, optional:starting_search_index): 
--to find position of element in a string
--in this index start from 1
--third parameter is optional

SUBSTRING(from_which_column/where, from_start_position, how_many_characters)

LEFT(from where, how_many_characters):
--it will give left characters from the string
*/


with cte as
(
select customer_name
, len(customer_name)-len(replace(customer_name,' ','')) as no_of_spaces
, CHARINDEX(' ',customer_name) as first_space_position 
, CHARINDEX(' ',customer_name, CHARINDEX(' ',customer_name)+1) as second_space_position
--, replace(customer_name,' ','') as name_without_spaces
from customers
)

select *

,case when no_of_spaces=0 then customer_name
else left(customer_name,first_space_position-1)
-- OR -- else substring(customer_name,1,first_space_position-1)
end as firstname

, case when no_of_spaces<=1 then null  -- means, then no middle_name
else substring(customer_name,first_space_position+1,second_space_position-first_space_position-1)
end as middlename

, case when no_of_spaces=0 then null --means, then no last_name
when no_of_spaces=1 then SUBSTRING(customer_name,first_space_position+1,len(customer_name)-first_space_position)
when no_of_spaces=2 then SUBSTRING(customer_name,second_space_position+1,len(customer_name)-second_space_position)
end as lastname

from cte


/*OUTPUT:

customer_name                  no_of_spaces first_space_position second_space_position firstname                      middlename                     lastname                      
------------------------------ ------------ -------------------- --------------------- ------------------------------ ------------------------------ ------------------------------
Ankit Bansal                              1                    6                     0 Ankit                          NULL                           Bansal                        
Vishal Pratap Singh                       2                    7                    14 Vishal                         Pratap                         Singh                         
Michael                                   0                    0                     0 Michael                        NULL                           NULL                          

*/
