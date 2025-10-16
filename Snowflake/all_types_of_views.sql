-----create 3 types of views---------
--1. normal views
--2. materalised views
--3. secure views

--Standard View	:    Normal view; stores query logic and executes on demand
--Materialized View:	 Physically stores results for faster performance
--Secure View	:        Prevents underlying data exposure (used for data sharing or masking)


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

------creating standard view-------------------------------------------------------  
  
CREATE OR REPLACE VIEW emp_summary AS   
SELECT
  emp_id,
  name,
  department
FROM employee_hr;


select * from emp_summary

------creating materialized view-------------------------------------------------------

CREATE OR REPLACE MATERIALIZED VIEW emp_2023_onwards_hires_mat_view AS
SELECT
  emp_id,
  name,
  department,
  join_date
FROM employee_hr
WHERE year(join_date) >= 2023;

select * from emp_2023_onwards_hires_mat_view order by year(join_date) desc;

------creating secure view-------------------------------------------------------


CREATE OR REPLACE SECURE VIEW emp_secure_view AS
SELECT
  emp_id,
  name,
  CASE
    WHEN CURRENT_ROLE() IN ('HR_ROLE', 'ACCOUNTADMIN') THEN salary
    ELSE NULL
  END AS salary
FROM employee_hr;

SELECT * FROM emp_secure_view;
