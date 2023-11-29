-- 1. Retrieve the customer names and their corresponding orders.
SELECT
      c.customer_name,
      o.order_id
FROM customers c JOIN orders o
ON c.customer_id = o.customer_id;     

-- 2. Find the total quantity and revenue generated from each product category.
SELECT 
       p.category,
       SUM(o.quantity) AS total_quantity,
       SUM(o.quantity * p.price) AS total_revenue
FROM products p JOIN orders o
ON p.product_id = o.product_id      
GROUP BY p.category;

-- 3. Retrieve the top-selling products in each category.
SELECT 
      p.category,
      p.product_name,
      SUM(o.quantity) AS total_quantity
FROM products p JOIN orders o
ON p.product_id = o.product_id
GROUP BY p.category, p.product_name
HAVING SUM(o.quantity) = (SELECT MAX(total_quantity) 
                         FROM (SELECT category,
                               SUM(quantity) AS total_quantity
                               FROM products p JOIN orders o
                               ON p.product_id = o.product_id
                               GROUP BY category
                           ) AS subquery
WHERE subquery.category = p.category
);
  
-- 4. Retrieve the average order value for each customer.
SELECT c.customer_id,
       c.customer_name,
      AVG(p.price * o.quantity) AS order_value
FROM customers c JOIN orders o
ON c.customer_id = o.customer_id
JOIN products p 
ON o.product_id = p.product_id
GROUP BY c.customer_id, c.customer_name
ORDER BY order_value DESC;

-- 5. Retrieve the customers who have made more than the average order quantity.
SELECT 
       c.customer_id,
       c.customer_name
FROM customers c JOIN (
  SELECT 
         customer_id, 
         AVG(quantity) AS avg_quantity
  FROM orders
  GROUP BY customer_id
) AS avg_orders 
 ON c.customer_id = avg_orders.customer_id
 JOIN orders o ON c.customer_id = o.customer_id
 WHERE o.quantity > avg_orders.avg_quantity;