-- 1. Calculate the total salary expenditure for each department and display the departments in descending order of the total salary expenditure.
WITH total_expenditure AS(
    SELECT 
       department_id,
       SUM(salary) AS total_salary
    FROM employees
    GROUP BY department_id
)
SELECT 
      d.department_name,
      te.total_salary 
FROM departments d JOIN total_expenditure te 
ON d.department_id = te.department_id
ORDER BY te.total_salary DESC;


-- 2. Retrieve the employees who have at least two subordinates.
WITH subordinate_count AS (
    SELECT 
           manager_id, 
           COUNT(*) AS num_subordinates
    FROM employees
    GROUP BY manager_id
)
SELECT        
       e.employee_name, 
       e.manager_id, 
       sc.num_subordinates
FROM employees e JOIN subordinate_count sc 
ON e.employee_id = sc.manager_id
WHERE sc.num_subordinates >= 2;


-- 3. Calculate the average salary for each department, considering only employees with a salary greater than the department average.
WITH dept_avg_salary AS(
SELECT 
      department_id,
      AVG(salary) AS avg_salary
FROM employees
GROUP BY department_id
)
SELECT 
      e.department_id,
      d.department_name,
      AVG(e.salary) AS avg_salary
FROM employees e JOIN dept_avg_salary ds
ON e.department_id = ds.department_id
JOIN departments d
ON e.department_id = d.department_id
WHERE e.salary > ds.avg_salary
GROUP BY e.department_id, d.department_name;

-- 4. Find the employees who have the highest salary in their respective departments.
WITH max_salary_per_department AS (
    SELECT 
           department_id, 
           MAX(salary) AS max_salary
    FROM employees
    GROUP BY department_id
)
SELECT e.employee_name,
       e.salary, 
       d.department_name
FROM employees e JOIN max_salary_per_department msd 
ON e.department_id = msd.department_id
JOIN departments d ON e.department_id = d.department_id
WHERE e.salary = msd.max_salary;


-- 5. Calculate the running total of salaries for each department, ordered by department ID and employee name.
WITH running_total AS(
          SELECT
                department_id,
                employee_name,
                salary,
                SUM(salary) OVER(PARTITION BY department_id ORDER BY employee_name)                 AS total_salary
           FROM employees
  )
  SELECT department_id,
         employee_name, 
         salary, 
         total_salary
FROM running_total
ORDER BY department_id, employee_name;