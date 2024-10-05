Day 9: Repeat purchases on multiple days

—Distinct purchases dates on same product and user

CREATE TABLE purchases (
  user_id INT,
  product_id INT,
  quantity INT,
  purchase_date DATETIME 
);

INSERT INTO purchases (user_id, product_id, quantity, purchase_date) VALUES
(536, 3223, 6, '2022-01-11 12:33:44'), 
(536, 3223, 5, '2022-03-02 08:40:44'),
(536, 1435, 10, '2022-03-02 09:33:44'),
(827, 3585, 6, '2022-07-09 13:55:44'), 
(827, 2412, 9, '2022-01-11 14:24:44'),
(827, 2412, 3, '2022-01-11 14:24:44');

select * from purchases

SELECT count(1) as users_num
from(SELECT 
    COUNT(DISTINCT CAST(purchase_date AS DATE)) AS p_date,
    user_id,
    product_id
FROM 
    purchases
GROUP BY 
    user_id, 
    product_id
HAVING COUNT(DISTINCT CAST(purchase_date AS DATE)) > 1)A



