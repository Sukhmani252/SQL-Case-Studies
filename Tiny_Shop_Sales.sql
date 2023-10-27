-- Case Study Questions

--1) Which product has the highest price? Only return a single row.
SELECT product_name FROM products ORDER BY price DESC LIMIT 1;
SELECT product_name FROM products WHERE price IN (SELECT MAX(price) FROM products);

--2) Which customer has made the most orders?
WITH ranking AS (
 SELECT c.customer_id,
        CONCAT(c.first_name,' ', c.last_name) AS customer_name,
        COUNT(o.order_id) AS no_of_orders,
        DENSE_RANK() OVER(ORDER BY COUNT(o.order_id) DESC) AS rnk
 FROM customers c
 JOIN orders o 
 ON c.customer_id = o.customer_id
 GROUP BY c.customer_id
 ORDER BY 2 DESC,1
  )
 SELECT 
        customer_name,
        no_of_orders
 FROM ranking 
 WHERE rnk = 1;

--3) What’s the total revenue per product?
SELECT p.product_name, 
       CAST(SUM(p.price * o.quantity) AS DECIMAL(10)) AS revenue
FROM products p
JOIN order_items o
ON p.product_id = o.product_id
GROUP BY 1
ORDER BY 2 DESC;

--4) Find the day with the highest revenue.
SELECT o.order_date, 
       CAST(SUM(oi.quantity * p.price) AS DECIMAL(10)) AS total_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

--5) Find the first order (by date) for each customer.
SELECT 
      c.customer_id,
	  CONCAT(c.first_name,' ',c.last_name) AS customer_name,
      MIN(o.order_date) AS first_order_date
 FROM orders o
 JOIN customers c
 ON o.customer_id = c.customer_id
 GROUP BY 1
 ORDER BY 1;

--6) Find the top 3 customers who have ordered the most distinct products.
SELECT c.customer_id,
       CONCAT(first_name,' ',last_name) AS customer_name,
       COUNT(DISTINCT oi.product_id) AS distinct_product_count 
FROM customers c
JOIN orders o 
ON c.customer_id = o.customer_id
JOIN order_items oi 
ON o.order_id = oi.order_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 3;

--7) Which product has been bought the least in terms of quantity?
SELECT p.product_id,
       p.product_name,
       oi.quantity
FROM order_items oi 
JOIN products p 
ON oi.product_id = p.product_id
WHERE quantity = (SELECT MIN(quantity) FROM order_items)
GROUP BY 1,2,3;

--8) For each order, determine if it was ‘Expensive’ (total over 300), ‘Affordable’ (total over 100), or ‘Cheap’.
SELECT 
      o.order_id,
      CAST(SUM(oi.quantity*p.price) AS DECIMAL(10)) AS total_order,
      CASE 
      WHEN SUM(oi.quantity*p.price) > 300 THEN 'Expensive'
      WHEN SUM(oi.quantity*p.price) > 100 THEN 'Affordable'
      ELSE 'Cheap'
      END AS order_category
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
JOIN products p
ON oi.product_id = p.product_id
GROUP BY 1
ORDER BY 1;

--9) Find customers who have ordered the product with the highest price.
SELECT c.customer_id,
       CONCAT(first_name,' ',last_name) AS customer_name,
       p.product_name,
       CAST(p.price AS DECIMAL(10))
FROM customers c
JOIN orders o 
ON c.customer_id = o.customer_id
JOIN order_items oi
ON o.order_id = oi.order_id 
JOIN products p
ON oi.product_id = p.product_id
WHERE oi.product_id = 
(SELECT product_id FROM products WHERE price = (SELECT MAX(price) FROM products));