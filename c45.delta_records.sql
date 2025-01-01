--Day 45: Delta Records
--Rule - not to use minus,union,merge,unionall.... exist and not exist can be used.
/*
tbl_orders_copy:
-----------------

order_id    order_date      
----------- ----------------
          1       2022-10-21
          2       2022-10-22
          3       2022-10-25
          4       2022-10-25
          
          
tbl_orders:
-----------------

order_id    order_date      
----------- ----------------
          2       2022-10-22
          3       2022-10-25
          4       2022-10-25
          5       2022-10-26
          6       2022-10-26

          
OUTPUT:
order_id    flag     
----------- ----------------

          1  'D' (delete)
          5  'I'
          6  'I' (insert)
*/

create table tbl_orders (
order_id integer,
order_date date
);
insert into tbl_orders
values (1,'2022-10-21'),(2,'2022-10-22'),
(3,'2022-10-25'),(4,'2022-10-25');

select * into tbl_orders_copy from  tbl_orders;

insert into tbl_orders
values (5,'2022-10-26'),(6,'2022-10-26');
delete from tbl_orders where order_id=1;


select * from tbl_orders_copy;
select * from tbl_orders;


--we would need to do FULL OUTER JOIN:

select coalesce(o.order_id, c.order_id) as order_id,
case 
 when c.order_id is NULL then 'I' 
 when o.order_id is NULL then 'D'
end as flag
from tbl_orders o 
FULL OUTER JOIN tbl_orders_copy c 
ON o.order_id = c.order_id
where c.order_id is NULL or o.order_id is NULL
