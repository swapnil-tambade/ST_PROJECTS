------------------Swapnil-tambade---------------------------------
--here we are implementing end to end stream and task example to handle incremental load set up including insert/update/delete actions---
--------------------------------------------------------------
-- END-TO-END INCREMENTAL DATA LOAD USING STREAMS AND TASKS
-- Database: FINANCE_DB | Schema: FIN_STG
--------------------------------------------------------------

USE DATABASE FINANCE_DB;
USE SCHEMA FIN_STG;
USE WAREHOUSE COMPUTE_WH;

--------------------------------------------------------------
-- STEP 1: CREATE SOURCE TABLE (Raw/Staging)
--------------------------------------------------------------
CREATE OR REPLACE TABLE FINANCE_DB.FIN_STG.RAW_ORDERS (
    ORDER_ID       INT,
    CUSTOMER_NAME  VARCHAR(100),
    PRODUCT        VARCHAR(100),
    QUANTITY       INT,
    AMOUNT         DECIMAL(10,2),
    ORDER_DATE     DATE,
    LOADED_AT      TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

--------------------------------------------------------------
-- STEP 2: CREATE TARGET TABLE (Production/Final)
--------------------------------------------------------------
CREATE OR REPLACE TABLE FINANCE_DB.FIN_STG.PROD_ORDERS (
    ORDER_ID       INT,
    CUSTOMER_NAME  VARCHAR(100),
    PRODUCT        VARCHAR(100),
    QUANTITY       INT,
    AMOUNT         DECIMAL(10,2),
    ORDER_DATE     DATE,
    LOADED_AT      TIMESTAMP_NTZ,
    INSERTED_AT    TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

--------------------------------------------------------------
-- STEP 3: CREATE A STREAM ON THE SOURCE TABLE
--------------------------------------------------------------
CREATE OR REPLACE STREAM FINANCE_DB.FIN_STG.RAW_ORDERS_STREAM
    ON TABLE FINANCE_DB.FIN_STG.RAW_ORDERS;

select * from RAW_ORDERS_STREAM;    

--------------------------------------------------------------
-- STEP 4: CREATE A TASK TO CONSUME THE STREAM
-- Runs every 1 minute, only when stream has data
--------------------------------------------------------------
CREATE OR REPLACE TASK FINANCE_DB.FIN_STG.LOAD_PROD_ORDERS_TASK
    WAREHOUSE = COMPUTE_WH
    SCHEDULE  = '1 MINUTE'
    WHEN SYSTEM$STREAM_HAS_DATA('FINANCE_DB.FIN_STG.RAW_ORDERS_STREAM')
AS
    MERGE INTO FINANCE_DB.FIN_STG.PROD_ORDERS AS TGT
    USING (
        SELECT ORDER_ID, CUSTOMER_NAME, PRODUCT, QUANTITY, AMOUNT, ORDER_DATE, LOADED_AT,
               METADATA$ACTION AS DML_TYPE,
               METADATA$ISUPDATE AS IS_UPDATE
        FROM FINANCE_DB.FIN_STG.RAW_ORDERS_STREAM
    ) AS SRC
    ON TGT.ORDER_ID = SRC.ORDER_ID
    WHEN MATCHED AND SRC.DML_TYPE = 'DELETE' AND SRC.IS_UPDATE = FALSE THEN DELETE
    WHEN MATCHED AND SRC.DML_TYPE = 'INSERT' THEN UPDATE SET
        TGT.CUSTOMER_NAME = SRC.CUSTOMER_NAME,
        TGT.PRODUCT       = SRC.PRODUCT,
        TGT.QUANTITY       = SRC.QUANTITY,
        TGT.AMOUNT         = SRC.AMOUNT,
        TGT.ORDER_DATE     = SRC.ORDER_DATE,
        TGT.LOADED_AT      = SRC.LOADED_AT,
        TGT.INSERTED_AT    = CURRENT_TIMESTAMP()
    WHEN NOT MATCHED AND SRC.DML_TYPE = 'INSERT' THEN INSERT (ORDER_ID, CUSTOMER_NAME, PRODUCT, QUANTITY, AMOUNT, ORDER_DATE, LOADED_AT, INSERTED_AT)
        VALUES (SRC.ORDER_ID, SRC.CUSTOMER_NAME, SRC.PRODUCT, SRC.QUANTITY, SRC.AMOUNT, SRC.ORDER_DATE, SRC.LOADED_AT, CURRENT_TIMESTAMP());

--------------------------------------------------------------
-- STEP 5: RESUME THE TASK (Tasks are created in suspended state)
--------------------------------------------------------------
ALTER TASK FINANCE_DB.FIN_STG.LOAD_PROD_ORDERS_TASK RESUME;

--------------------------------------------------------------
-- STEP 6: VERIFY TASK IS RUNNING
--------------------------------------------------------------
SHOW TASKS IN SCHEMA FINANCE_DB.FIN_STG;

--------------------------------------------------------------
-- STEP 7: INSERT FIRST BATCH OF DATA INTO SOURCE TABLE
--------------------------------------------------------------
INSERT INTO FINANCE_DB.FIN_STG.RAW_ORDERS (ORDER_ID, CUSTOMER_NAME, PRODUCT, QUANTITY, AMOUNT, ORDER_DATE)
VALUES
    (1,  'Alice Johnson',  'Laptop',        1, 1200.00, '2026-01-05'),
    (2,  'Bob Smith',      'Wireless Mouse', 3,  75.00, '2026-01-10'),
    (3,  'Carol Davis',    'Keyboard',       2, 110.00, '2026-02-14'),
    (4,  'David Lee',      'Monitor',        1, 450.00, '2026-02-20'),
    (5,  'Emma Wilson',    'USB Hub',        5,  60.00, '2026-03-01');


INSERT INTO FINANCE_DB.FIN_STG.RAW_ORDERS (ORDER_ID, CUSTOMER_NAME, PRODUCT, QUANTITY, AMOUNT, ORDER_DATE)
VALUES
    (11,  'rahul',  'Laptop',        1, 2200.00, '2026-01-05'),
    (15,  'jess',    'USB Hub',        5,  660.00, '2026-03-01');    

--------------------------------------------------------------
-- STEP 8: CHECK THE STREAM (should show 5 new rows)
--------------------------------------------------------------
SELECT * FROM FINANCE_DB.FIN_STG.RAW_ORDERS_STREAM;
select * from FINANCE_DB.FIN_STG.RAW_ORDERS;

--------------------------------------------------------------
-- STEP 9: CHECK IF STREAM HAS DATA
--------------------------------------------------------------
SELECT SYSTEM$STREAM_HAS_DATA('FINANCE_DB.FIN_STG.RAW_ORDERS_STREAM');

--------------------------------------------------------------
-- STEP 10: MANUALLY EXECUTE THE TASK (instead of waiting 1 min)
--------------------------------------------------------------
EXECUTE TASK FINANCE_DB.FIN_STG.LOAD_PROD_ORDERS_TASK;

--------------------------------------------------------------
-- STEP 11: WAIT ~5 SECONDS, THEN VERIFY TARGET TABLE
--------------------------------------------------------------
SELECT * FROM FINANCE_DB.FIN_STG.PROD_ORDERS ORDER BY ORDER_ID;

--------------------------------------------------------------
-- STEP 12: VERIFY STREAM IS NOW EMPTY (consumed by task)
--------------------------------------------------------------
SELECT * FROM FINANCE_DB.FIN_STG.RAW_ORDERS_STREAM;

--------------------------------------------------------------
-- STEP 13: INSERT SECOND BATCH (Incremental Load)
--------------------------------------------------------------
INSERT INTO FINANCE_DB.FIN_STG.RAW_ORDERS (ORDER_ID, CUSTOMER_NAME, PRODUCT, QUANTITY, AMOUNT, ORDER_DATE)
VALUES
    (6,  'Frank Brown',    'Headphones',  2,  160.00, '2026-03-10'),
    (7,  'Grace Kim',      'Webcam',      1,   85.00, '2026-03-15'),
    (8,  'Henry Clark',    'Laptop',      2, 2400.00, '2026-03-22');

--------------------------------------------------------------
-- STEP 14: CHECK STREAM AGAIN (should show only new 3 rows)
--------------------------------------------------------------
SELECT * FROM FINANCE_DB.FIN_STG.RAW_ORDERS_STREAM;

--------------------------------------------------------------
-- STEP 15: EXECUTE TASK AGAIN FOR INCREMENTAL LOAD
--------------------------------------------------------------
EXECUTE TASK FINANCE_DB.FIN_STG.LOAD_PROD_ORDERS_TASK;

--------------------------------------------------------------
-- STEP 16: VERIFY ALL 8 ROWS IN TARGET TABLE
--------------------------------------------------------------
SELECT * FROM FINANCE_DB.FIN_STG.PROD_ORDERS ORDER BY ORDER_ID;

--------------------------------------------------------------
-- STEP 17: TEST UPDATE SCENARIO - Update source, stream captures it
--------------------------------------------------------------
UPDATE FINANCE_DB.FIN_STG.RAW_ORDERS
SET AMOUNT = 1350.00, QUANTITY = 1
WHERE ORDER_ID = 1;

delete from  FINANCE_DB.FIN_STG.RAW_ORDERS
WHERE ORDER_ID = 2;

SELECT * FROM FINANCE_DB.FIN_STG.RAW_ORDERS_STREAM;

EXECUTE TASK FINANCE_DB.FIN_STG.LOAD_PROD_ORDERS_TASK;

SELECT * FROM FINANCE_DB.FIN_STG.PROD_ORDERS WHERE ORDER_ID = 1;

--------------------------------------------------------------
-- STEP 18: CHECK TASK EXECUTION HISTORY
--------------------------------------------------------------
SELECT *
FROM TABLE(INFORMATION_SCHEMA.TASK_HISTORY(
    TASK_NAME => 'LOAD_PROD_ORDERS_TASK',
    SCHEDULED_TIME_RANGE_START => DATEADD(HOUR, -1, CURRENT_TIMESTAMP())
))
ORDER BY SCHEDULED_TIME DESC;

--------------------------------------------------------------
-- CLEANUP (Uncomment to run)
--------------------------------------------------------------
-- ALTER TASK FINANCE_DB.FIN_STG.LOAD_PROD_ORDERS_TASK SUSPEND;
-- DROP TASK FINANCE_DB.FIN_STG.LOAD_PROD_ORDERS_TASK;
-- DROP STREAM FINANCE_DB.FIN_STG.RAW_ORDERS_STREAM;
-- DROP TABLE FINANCE_DB.FIN_STG.RAW_ORDERS;
-- DROP TABLE FINANCE_DB.FIN_STG.PROD_ORDERS;
