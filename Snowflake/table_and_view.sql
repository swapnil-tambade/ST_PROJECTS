use database sales_db;
use schema finance_schema;

--Create a table

CREATE OR REPLACE TABLE sales (
    sale_id INT AUTOINCREMENT,
    customer_id INT,
    product_id INT,
    sale_date DATE,
    amount NUMBER(10,2),
    PRIMARY KEY(sale_id)
);

-- Add a column
ALTER TABLE sales ADD COLUMN discount NUMBER(5,2);

-- Drop a column
ALTER TABLE sales DROP COLUMN discount;

-- Rename table
ALTER TABLE sales RENAME TO sales_history;

-- Change column data type
ALTER TABLE sales_history ALTER COLUMN amount SET DATA TYPE NUMBER(12,2);

--CLONE table

CREATE TABLE sales_clone CLONE sales_history;

---create view 

CREATE OR REPLACE VIEW sales_summary AS
SELECT 
    customer_id,
    COUNT(*) AS total_orders,
    SUM(amount) AS total_amount
FROM sales_history
GROUP BY customer_id;


ALTER VIEW sales_summary RENAME TO customer_sales_summary;

-- Describe view
DESC VIEW customer_sales_summary;

-- Show all views
SHOW VIEWS LIKE 'customer%';


-- Grant privileges
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE sales_history TO ROLE finance_role;
GRANT SELECT ON VIEW customer_sales_summary TO ROLE finance_role;


-- Revoke privileges
REVOKE UPDATE, DELETE ON TABLE sales FROM ROLE analyst;

