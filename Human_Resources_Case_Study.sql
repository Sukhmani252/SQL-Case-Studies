-- SQL Challenge Questions

-- 1. Find the longest ongoing project for each department.

SELECT d.name AS department,
       p.name AS project,
	   p.end_date - p.start_date AS days
FROM departments d
LEFT JOIN projects p ON d.id = p.department_id
ORDER BY 3 DESC;

-- 2. Find all employees who are not managers.
SELECT name 
FROM employees 
WHERE id NOT IN (SELECT manager_id FROM departments);

-- 3. Find all employees who have been hired after the start of a project in their department.
SELECT e.name, 
       d.name AS department
FROM employees e
JOIN departments d 
ON e.department_id = d.id
JOIN projects p
ON p.department_id = d.id
WHERE e.hire_date > p.start_date;

-- 4. Rank employees within each department based on their hire date (earliest hire gets the highest rank).
SELECT e.name,
       d.name AS department,
       RANK() OVER(PARTITION BY d.name ORDER BY e.hire_date DESC) AS ranking
FROM employees e
JOIN departments d
ON e.department_id = d.id;

-- 5. Find the duration between the hire date of each employee and the hire date of the next employee hired in the same department.

SELECT 
      name,
      hire_date,
      department_id,
    LEAD(hire_date) OVER (PARTITION BY department_id ORDER BY hire_date) - hire_date AS duration,
    LEAD(name) OVER (PARTITION BY department_id ORDER BY hire_date) AS next_employee_name
FROM employees;
