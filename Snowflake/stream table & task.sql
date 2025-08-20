-- ---LOADING DATA INTO TARGET TABLE USING STREAM TABLE -----
--   1.Create normal staging table
--   2. create staging table on staging table
--   3. load into target table from stream table using task 
--   4. create & schedule task (write code to handle insert/update/delete/new records)

USE ROLE ACCOUNTADMIN;

CREATE OR REPLACE WAREHOUSE demo_wh
  WAREHOUSE_SIZE = 'XSMALL'
  AUTO_SUSPEND = 60
  AUTO_RESUME = TRUE
  INITIALLY_SUSPENDED = TRUE;


USE WAREHOUSE demo_wh;
USE DATABASE sales_db;
USE SCHEMA finance_schema;

--create stage table in finance schema---

CREATE OR REPLACE TABLE stg_orders (
  order_id     NUMBER PRIMARY KEY,
  customer_id  NUMBER,
  status       STRING,
  amount       NUMBER(10,2),
  updated_at   TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);


--create stream table on stg orders table----
--SHOW_INITIAL_ROWS=TRUE makes the first run treat existing rows as new so you can bootstrap the target--

CREATE OR REPLACE STREAM stg_orders_stream
  ON TABLE stg_orders
  SHOW_INITIAL_ROWS = TRUE;

 select * from  stg_orders_stream 
--creating target table----

CREATE OR REPLACE TABLE con_orders (
  order_id     NUMBER PRIMARY KEY,
  customer_id  NUMBER,
  status       STRING,
  amount       NUMBER(10,2),
  updated_at   TIMESTAMP_NTZ,
  loaded_at    TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);  

---loading data into stg orders table---



INSERT INTO stg_orders (order_id, customer_id, status, amount) VALUES
  (1, 100, 'NEW',     25.00),
  (2, 101, 'NEW',     39.00),
  (3, 102, 'NEW',     12.50);



CREATE OR REPLACE TASK task_load_orders
  WAREHOUSE = demo_wh
  SCHEDULE  = '5 MINUTE'
AS
-- Delete first
DELETE FROM con_orders tgt
USING (
    SELECT DISTINCT order_id
    FROM stg_orders_stream
    WHERE METADATA$ACTION = 'DELETE'
) s
WHERE tgt.order_id = s.order_id;

-- Then merge inserts/updates
MERGE INTO con_orders tgt
USING (
    SELECT order_id, customer_id, status, amount, updated_at
    FROM stg_orders_stream
    WHERE METADATA$ACTION = 'INSERT'
) s
ON tgt.order_id = s.order_id
WHEN MATCHED THEN UPDATE SET
    customer_id = s.customer_id,
    status      = s.status,
    amount      = s.amount,
    updated_at  = s.updated_at,
    loaded_at   = CURRENT_TIMESTAMP()
WHEN NOT MATCHED THEN INSERT (
    order_id, customer_id, status, amount, updated_at, loaded_at
) VALUES (
    s.order_id, s.customer_id, s.status, s.amount, s.updated_at, CURRENT_TIMESTAMP()
);



---run task--
ALTER TASK task_load_orders RESUME;
execute task task_load_orders

select * from con_orders
--add data into stg orders table for testing---

UPDATE stg_orders
SET status = 'SHIPPED', amount = 150.00
WHERE order_id = 3;

--delete one row from stg_table

DELETE FROM stg_orders WHERE order_id = 3;

select * from stg_orders
select * from stg_orders_stream
select * from con_orders

EXECUTE TASK task_load_orders;  

SHOW PARAMETERS LIKE 'enable_execute_task';
ALTER ACCOUNT SET enable_execute_task = TRUE;

SELECT *
FROM TABLE(INFORMATION_SCHEMA.TASK_HISTORY())
WHERE NAME = 'TASK_LOAD_ORDERS'
ORDER BY SCHEDULED_TIME DESC
LIMIT 5;



CREATE OR REPLACE TASK task_load_orders1
  WAREHOUSE = demo_wh
  SCHEDULE  = '5 MINUTE'
AS
-- Delete first
INSERT INTO con_orders (order_id, customer_id, status, amount, updated_at, loaded_at)
SELECT s.order_id, s.customer_id, s.status, s.amount, s.updated_at, CURRENT_TIMESTAMP()
FROM stg_orders_stream s;


execute task task_load_orders1

 
select distinct name from SNOWFLAKE.ACCOUNT_USAGE.TASK_HISTORY where name like 'task_load_orders1'
order by COMPLETED_TIME desc 

DELETE FROM con_orders
WHERE order_id NOT IN (
    SELECT MIN(order_id)
    FROM con_orders
    GROUP BY order_id,customer_id,status
);


delete   from SALES_DB.FINANCE_SCHEMA.STG_ORDERS

select *  from  SALES_DB.FINANCE_SCHEMA.STG_ORDERS_STREAM

select *  from  SALES_DB.FINANCE_SCHEMA.CON_ORDERS

SELECT *
FROM TABLE(INFORMATION_SCHEMA.TASK_HISTORY())
WHERE NAME = 'TASK_LOAD_ORDERS'
ORDER BY SCHEDULED_TIME DESC
LIMIT 10;


INSERT INTO stg_orders (order_id, customer_id, status, amount) VALUES
  (1, 100, 'NEW',     25.00),
  (2, 101, 'NEW',     39.00),
  (3, 102, 'NEW',     12.50);

execute task task_load_orders1


ALTER TASK task_load_orders SUSPEND;
