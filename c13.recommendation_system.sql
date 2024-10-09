Day13: recommendation_system

--recommendation system based on - product pairs most commonly purchased together

create table orders
(
order_id int,
customer_id int,
product_id int,
);

insert into orders VALUES 
(1, 1, 1),
(1, 1, 2),
(1, 1, 3),
(2, 2, 1),
(2, 2, 2),
(2, 2, 4),
(3, 1, 5);

create table products (
id int,
name varchar(10)
);
insert into products VALUES 
(1, 'A'),
(2, 'B'),
(3, 'C'),
(4, 'D'),
(5, 'E');

select * from orders;

/*NOTE: as for order_id=3 there is only one product_id, hence no combinations */

select pr1.name as p1,pr2.name as p2,count(*) as purchase_frequency --,a.product_id, b.product_id
from orders a
join orders b ON a.order_id=b.order_id  --a.customer_id=b.customer_id
join products pr1 ON pr1.id=a.product_id 
join products pr2 ON pr2.id=b.product_id
where a.product_id>b.product_id
group by pr1.name,pr2.name --,a.product_id,b.product_id

--OR--
select pr1.name +" "+ pr2.name as pair, count(1) as purchase_frequency 
from orders a
join orders b ON a.order_id=b.order_id 
join products pr1 ON pr1.id=a.product_id 
join products pr2 ON pr2.id=b.product_id
where a.product_id<b.product_id
group by pr1.name,pr2.name 
