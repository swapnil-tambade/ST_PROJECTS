-- 🔹 Example 1: Simple Role-Based Row Access Policy

-- Let’s say you have an employees table and you want:

-- The role HR_ADMIN to see all rows

-- The role SALES_ROLE to see only employees from SALES department

-- The role IT_ROLE to see only IT department employees


CREATE OR REPLACE TABLE employee_hr (
  emp_id INT,
  name STRING,
  department STRING,
  salary NUMBER,
  join_date DATE
);

INSERT INTO employee_hr (emp_id, name, department, salary, join_date) VALUES
  (101, 'Alice Johnson', 'HR',        65000, '2022-03-15'),
  (102, 'Bob Smith',     'Finance',   72000, '2021-07-10'),
  (103, 'Charlie Davis', 'IT',        85000, '2023-01-05'),
  (104, 'Diana Lopez',   'Marketing', 58000, '2022-11-20'),
  (105, 'Ethan Brown',   'IT',        92000, '2021-09-01'),
  (106, 'Fiona Clark',   'HR',        67000, '2024-02-18'),
  (107, 'George White',  'Finance',   74000, '2023-05-30'),
  (108, 'Hannah Green',  'Sales',     56000, '2022-06-25'),
  (109, 'Ian Black',     'IT',        89000, '2023-12-10'),
  (110, 'Julia Adams',   'Marketing', 61000, '2024-04-15');


  CREATE OR REPLACE ROW ACCESS POLICY rap_emp_dept
  AS (department STRING)
  RETURNS BOOLEAN ->
    CASE
      WHEN CURRENT_ROLE() = 'HR_ADMIN' THEN TRUE
      WHEN CURRENT_ROLE() = 'FINANCE_ROLE' AND department = 'FINANCE' THEN TRUE
      WHEN CURRENT_ROLE() = 'IT_ROLE' AND department = 'IT' THEN TRUE
      WHEN CURRENT_ROLE() = 'ACCOUNTADMIN' AND department = 'Marketing' THEN TRUE
      ELSE FALSE
    END;



ALTER TABLE employee_hr
  ADD ROW ACCESS POLICY rap_emp_dept ON (department);


select * from employee_hr;  

---I could see only marketting dept employees records as i have accountadmin role

  
    
