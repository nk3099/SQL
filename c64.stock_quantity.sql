--day65. write a SQL query to find out supplier_id, product_id, no_of_days 
--and starting date of record_date for which stock quantity is 
--less than 50 for two or more consecutive days.

CREATE TABLE stock (
    supplier_id INT,
    product_id INT,
    stock_quantity INT,
    record_date DATE
);

-- Insert the data
delete from stock;
INSERT INTO stock (supplier_id, product_id, stock_quantity, record_date)
VALUES
  (1, 1, 60, '2022-01-01'),
  (1, 1, 40, '2022-01-02'),
  (1, 1, 35, '2022-01-03'),
  (1, 1, 45, '2022-01-04'),
  (1, 1, 51, '2022-01-06'),
  (1, 1, 55, '2022-01-09'),
  (1, 1, 25, '2022-01-10'),
  (1, 1, 48, '2022-01-11'),
  (1, 1, 45, '2022-01-15'),
  (1, 1, 38, '2022-01-16'),
  (1, 2, 45, '2022-01-08'),
  (1, 2, 40, '2022-01-09'),
  (2, 1, 45, '2022-01-06'),
  (2, 1, 55, '2022-01-07'),
  (2, 2, 45, '2022-01-08'),
  (2, 2, 48, '2022-01-09'),
  (2, 2, 35, '2022-01-10'),
  (2, 2, 52, '2022-01-15'),
  (2, 2, 23, '2022-01-16');

select * from stock



--TO DO--
