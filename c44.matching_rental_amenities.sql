--Day44: Matching rental amenities
/*
The airbnb booking recommendations team is trying to understand the "subsstitutability" of two rentals and whether one rental is a good substitute for another. 
They want you to write a query to determine if two Airbnb rentals have the same exact amenitites offered.

Output the count of matching rental ids.

Assumptions: 
1. If property 1 has kitchen and pool, and property 2 has kitchen and pool too, then it is a good substitute and represents a count of 1 matching rental. 
2. If property 3 has a kitchen, pool and fireplace, and property 4 only has pool and fireplace, then it is not a good substitute.
*/

select amenity_list, factorial(cnt)/(factorial(cnt-2)*factorial(2)) as matching_airbnb
from
(
select amenity_list, count(rental_id) as cnt 
from (
select rental_id, array_agg(amenity order by amenity ) as amenity_list 
from rental_amenities
group by rental_id
order by amenity_list) A 
group by amenity_list having count(rental_id) > 1 
) B


/*
combination formulat:
nCr = n! / ( (n-r)! * r!)

In our case, r=2 as we need combination of 2 
=> nC2 = n! / ((n-2)! * 2!)

and 'n' is cnt that we get
*/


--Solution (method 1):
select cast(sum(factorial(cnt)/(factorial(cnt-2)*factorial(2))) as int) as matching_airbnb
from
(
select amenity_list, count(rental_id) as cnt 
from (
select rental_id, array_agg(amenity order by amenity ) as amenity_list 
from rental_amenities
group by rental_id
order by amenity_list) A 
group by amenity_list having count(rental_id) > 1 
) B

--Solution (method 2) : Using SELF-JOIN
with cte as( 
select rental_id,array_agg(amenity ORDER BY amenity) as amenity_list from rental_amenities 
GROUP BY rental_id)

select count (c1.rental_id) as matching_airbnb from cte c1
inner join cte c2
on c1.amenity_list=c2.amenity_list and c1.rental_id >c2.rental_id

