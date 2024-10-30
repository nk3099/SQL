Day9: **market_analysis

/*Query to find for each seller, whether the brand of the second item (by date) 
they sold is their favourite brand. If a seller sold less than two items, 
report the answer for that seller as no o/p 
seller_id   2nd_item_fav_brand
1           yes/no
2           yes/no
*/

create table users (
user_id         int     ,
 join_date       date    ,
 favorite_brand  varchar(50));

 create table orders (
 order_id       int     ,
 order_date     date    ,
 item_id        int     ,
 buyer_id       int     ,
 seller_id      int 
 );

 create table items
 (
 item_id        int     ,
 item_brand     varchar(50)
 );


 insert into users values (1,'2019-01-01','Lenovo'),(2,'2019-02-09','Samsung'),(3,'2019-01-19','LG'),(4,'2019-05-21','HP');

 insert into items values (1,'Samsung'),(2,'Lenovo'),(3,'LG'),(4,'HP');

 insert into orders values (1,'2019-08-01',4,1,2),(2,'2019-08-02',2,1,3),(3,'2019-08-03',3,2,3),(4,'2019-08-04',1,4,2)
 ,(5,'2019-08-04',1,3,4),(6,'2019-08-05',2,2,4);
 
 
select * from users;
select * from orders;
select * from items;

with nth_time as(
select o.*,
rank() over (partition by seller_id order by order_date asc) as rnk,
count(seller_id) over (partition by seller_id) as total_cnt
from orders o
)

-- select nt.item_id,nt.seller_id, items.item_brand,users.favorite_brand,
-- case
-- when items.item_brand=users.favorite_brand then "yes" else "no"
-- end as item_fav_brand
-- from nth_time nt
-- inner join items ON items.item_id=nt.item_id
-- inner join users ON users.user_id=nt.seller_id
-- where rnk=2 --and total_cnt>=2 as was redundant as already rnk=2 means 2 items sold by user

-- -- PLEASE NOTE: {key concept to take LEFT join and placement of rnk=2 here}: -- --
--but now as we want all users status as Yes/No, the 1st user data not there as hasn't sold anything
--therefore we should do LEFT JOIN on 'users' table as consider as starting/main/driver table
--AND placement of rnk=2 (instead of where clause), we should keep with Left join  as will help filter rnk=2 records and 
--then do left join over users table (so,we get all 4 users records including user_id=1)


select users.user_id as new_seller_id, --nt.item_id,nt.seller_id, items.item_brand,users.favorite_brand,
case
when items.item_brand=users.favorite_brand then "yes" else "no"
end as item_fav_brand
from users
left join nth_time nt ON users.user_id=nt.seller_id and rnk=2
left join items ON items.item_id=nt.item_id



---------------------------
-- OR ---
---------------------------

with nth_time as(
select o.*,
rank() over (partition by seller_id order by order_date asc) as rnk,
count(seller_id) over (partition by seller_id) as total_cnt
from orders o
), finalised as (select nt.item_id,nt.seller_id, items.item_brand
from nth_time nt
inner join items ON items.item_id=nt.item_id
inner join users ON users.user_id=nt.seller_id
where rnk=2)

select u.user_id as new_seller_id, -- f.item_brand, u.favorite_brand,
case
when f.item_brand=u.favorite_brand then "yes" else "no"
end as item_fav_brand
from users u
left join finalised f ON f.seller_id=u.user_id



