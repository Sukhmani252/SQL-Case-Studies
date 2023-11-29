-- 1. Retrieve the email addresses of customers in uppercase.
SELECT UPPER(email) AS uppercaes_email FROM customers;

-- 2. Calculate the total payment amount for each customer.
SELECT 
       customer_id,
       SUM(payment_amount) AS total_payment
FROM payments
GROUP BY customer_id;

-- 3. Retrieve the customers who have made payments greater than the average payment amount.
SELECT customer_id,
       customer_name
FROM customers
WHERE customer_id IN (
SELECT 
      customer_id
FROM payments
WHERE payment_amount > (SELECT AVG(payment_amount) FROM payments));

-- 4. Retrieve the customers who have used the 'Internet' service.
SELECT *
FROM customers
WHERE service_type = "Internet";

-- 5. Segment customers based on their payment history: 'Good', 'Average', or 'Poor'.
SELECT
      customer_id,
      customer_name,
      CASE
         WHEN total_payment_amount > 100 THEN 'Good'
         WHEN total_payment_amount > 50 THEN 'Average' 
         ELSE 'Poor'
      END AS payment_history
FROM (
    SELECT c.customer_id, 
    c.customer_name, 
    SUM(p.payment_amount) AS total_payment_amount
    FROM customers c
    LEFT JOIN payments p ON c.customer_id = p.customer_id
    GROUP BY c.customer_id, c.customer_name
) AS payment_summary;