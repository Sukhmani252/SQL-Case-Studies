-- How many orders were placed for each product?
SELECT p.product_name,
       COUNT(o.order_id) AS total_orders 
FROM products p JOIN orders o
ON p.product_id = o.product_id
GROUP BY p.product_name;

-- What is the total quantity sold for each product category?
SELECT p.product_category,
       SUM(o.quantity) AS total_quantity_sold
FROM products p JOIN orders o
ON p.product_id = o.product_id
GROUP BY p.product_category;

-- Which product has generated the most sales revenue?

SELECT p.product_name,
       SUM(p.product_price * o.quantity) AS revenue
FROM products p JOIN orders o
ON p.product_id = o.product_id
GROUP BY p.product_name
ORDER BY revenue DESC 
LIMIT 1;

-- Which customers have purchased 'Product A'?
SELECT o.customer_id
FROM products p JOIN orders o
ON p.product_id = o.product_id
WHERE p.product_name = 'Product A';

-- How many unique customers have made purchases?
SELECT COUNT(DISTINCT customer_id) AS unique_customers FROM orders;