-- 1. Retrieve the sales revenue for each product, along with the cumulative revenue for each product over time.
SELECT product_id,
       sale_date,
       revenue,
       SUM(revenue) OVER(PARTITION BY product_id ORDER BY sale_date) AS cumulative_revenue
FROM sales;


-- 2. Calculate the average revenue for each product, considering only the three most recent sales for each product.
SELECT product_id,
       sale_date,
       revenue,
       AVG(revenue) OVER(PARTITION BY product_id ORDER BY sale_date DESC ROWS              BETWEEN 2 PRECEDING AND CURRENT ROW ) AS avg_revenue
FROM sales;


-- 3. Calculate the difference in revenue between each sale and the previous sale for each product, sorted by product and sale date.
SELECT product_id,
       sale_date,
       revenue,
       revenue-LAG(revenue) OVER(PARTITION BY product_id ORDER BY sale_date) AS
       revenue_diff
 FROM sales;

-- 4. Rank the sales regions based on the total revenue generated, and display the top three regions along with their respective total revenue.
   SELECT region,
          total_revenue
   FROM (
   SELECT 
         region,
         SUM(revenue) AS total_revenue,
         RANK() OVER(ORDER BY SUM(revenue) DESC) AS region_rank
   FROM sales
   GROUP BY region
   ) AS ranked_regions
 WHERE region_rank <=3;
       