-- Create database/schema (run as ACCOUNTADMIN or appropriate role)

CREATE OR REPLACE DATABASE finance_db;
CREATE OR REPLACE SCHEMA finance_db.raw;
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

--Createing internal named stage where we will put our raw order csv data file from our local machine


CREATE OR REPLACE STAGE finance_db.raw.raw_orders_stg
FILE_FORMAT = (TYPE = 'CSV' FIELD_OPTIONALLY_ENCLOSED_BY='"' SKIP_HEADER = 1);

--Now putting raw order data file from local machine  to named internal stage with snowsql PUT commmand

PUT file:///C:/Users/hp/Documents/raw_orders_data.csv @raw_orders_stg;




