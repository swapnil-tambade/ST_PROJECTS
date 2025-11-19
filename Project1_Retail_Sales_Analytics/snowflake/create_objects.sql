-- Create database/schema (run as ACCOUNTADMIN or appropriate role)

CREATE OR REPLACE DATABASE finance_db;
CREATE OR REPLACE SCHEMA finance_db.raw;
CREATE OR REPLACE SCHEMA finance_db.staging;
CREATE OR REPLACE SCHEMA finance_db.intermediate;
CREATE OR REPLACE SCHEMA finance_db.mart;
CREATE OR REPLACE SCHEMA finance_db.analytic;

-- RAW table for orders

CREATE OR REPLACE TABLE finance_db.raw.orders_raw (
order_id VARCHAR,
order_date TIMESTAMP_NTZ,
customer_id VARCHAR,
item_id VARCHAR,
quantity NUMBER,
unit_price NUMBER,
currency VARCHAR,
region VARCHAR
);


-- final table at mart level

CREATE OR REPLACE TABLE finance_db.analytic.daily_sales (
order_date DATE,
region VARCHAR,
total_sales NUMBER,
total_quantity NUMBER
);


--As I have account admin role giving access to my role to newly created finance_db 
--giving all PRIVILEGES on database to accountadmin role

GRANT ALL PRIVILEGES ON database finance_db TO ROLE accountadmin;

