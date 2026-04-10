-----------------Swapnil-Tambade--------------------------------------------------------
----Here we are implementing dynamic table example to handle insert/update/delete scenario-----------
-- END-TO-END INCREMENTAL DATA LOAD USING DYNAMIC TABLES
-- Database: FINANCE_DB | Schema: FIN_STG
-- 3 Source Tables: ORDERS + CUSTOMERS + PRODUCTS
-- Dynamic Table: Joins all 3 with automatic incremental refresh
--------------------------------------------------------------

USE DATABASE FINANCE_DB;
USE SCHEMA FIN_STG;
USE WAREHOUSE COMPUTE_WH;

--------------------------------------------------------------
-- STEP 1: CREATE CUSTOMERS MASTER TABLE
--------------------------------------------------------------
CREATE OR REPLACE TABLE FINANCE_DB.FIN_STG.DT_CUSTOMERS (
    CUSTOMER_ID    INT,
    CUSTOMER_NAME  VARCHAR(100),
    EMAIL          VARCHAR(200),
    CITY           VARCHAR(100),
    CREATED_AT     TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

INSERT INTO FINANCE_DB.FIN_STG.DT_CUSTOMERS (CUSTOMER_ID, CUSTOMER_NAME, EMAIL, CITY)
VALUES
    (101, 'Alice Johnson',  'alice@example.com',  'New York'),
    (102, 'Bob Smith',      'bob@example.com',    'Chicago'),
    (103, 'Carol Davis',    'carol@example.com',  'San Francisco'),
    (104, 'David Lee',      'david@example.com',  'Austin'),
    (105, 'Emma Wilson',    'emma@example.com',   'Seattle');

--------------------------------------------------------------
-- STEP 2: CREATE PRODUCTS MASTER TABLE
--------------------------------------------------------------
CREATE OR REPLACE TABLE FINANCE_DB.FIN_STG.DT_PRODUCTS (
    PRODUCT_ID    INT,
    PRODUCT_NAME  VARCHAR(100),
    CATEGORY      VARCHAR(50),
    UNIT_PRICE    DECIMAL(10,2),
    CREATED_AT    TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

INSERT INTO FINANCE_DB.FIN_STG.DT_PRODUCTS (PRODUCT_ID, PRODUCT_NAME, CATEGORY, UNIT_PRICE)
VALUES
    (201, 'Laptop',         'Electronics', 1200.00),
    (202, 'Wireless Mouse', 'Accessories',   25.00),
    (203, 'Keyboard',       'Accessories',   55.00),
    (204, 'Monitor',        'Electronics',  450.00),
    (205, 'USB Hub',        'Accessories',   12.00),
    (206, 'Headphones',     'Audio',         80.00);

--------------------------------------------------------------
-- STEP 3: CREATE ORDERS TABLE (This is the fact/transactional table)
--------------------------------------------------------------
CREATE OR REPLACE TABLE FINANCE_DB.FIN_STG.DT_ORDERS (
    ORDER_ID       INT,
    CUSTOMER_ID    INT,
    PRODUCT_ID     INT,
    QUANTITY       INT,
    ORDER_DATE     DATE,
    LOADED_AT      TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

--------------------------------------------------------------
-- STEP 4: ENABLE CHANGE TRACKING ON ALL SOURCE TABLES
--------------------------------------------------------------
ALTER TABLE FINANCE_DB.FIN_STG.DT_CUSTOMERS SET CHANGE_TRACKING = TRUE;
ALTER TABLE FINANCE_DB.FIN_STG.DT_PRODUCTS  SET CHANGE_TRACKING = TRUE;
ALTER TABLE FINANCE_DB.FIN_STG.DT_ORDERS    SET CHANGE_TRACKING = TRUE;

--------------------------------------------------------------
-- STEP 5: CREATE DYNAMIC TABLE (Joins all 3 tables)
-- Refreshes incrementally, target lag = 1 minute
--------------------------------------------------------------
CREATE OR REPLACE DYNAMIC TABLE FINANCE_DB.FIN_STG.DT_ORDER_DETAILS
    TARGET_LAG = '5 minute'
    WAREHOUSE  = COMPUTE_WH
    REFRESH_MODE = INCREMENTAL
    INITIALIZE = ON_CREATE
AS
    SELECT
        O.ORDER_ID,
        O.ORDER_DATE,
        C.CUSTOMER_ID,
        C.CUSTOMER_NAME,
        C.EMAIL,
        C.CITY,
        P.PRODUCT_ID,
        P.PRODUCT_NAME,
        P.CATEGORY,
        P.UNIT_PRICE,
        O.QUANTITY,
        (O.QUANTITY * P.UNIT_PRICE) AS TOTAL_AMOUNT
    FROM FINANCE_DB.FIN_STG.DT_ORDERS O
    INNER JOIN FINANCE_DB.FIN_STG.DT_CUSTOMERS C ON O.CUSTOMER_ID = C.CUSTOMER_ID
    INNER JOIN FINANCE_DB.FIN_STG.DT_PRODUCTS  P ON O.PRODUCT_ID  = P.PRODUCT_ID;

--------------------------------------------------------------
-- STEP 6: VERIFY DYNAMIC TABLE WAS CREATED
--------------------------------------------------------------
SHOW DYNAMIC TABLES IN SCHEMA FINANCE_DB.FIN_STG;

--------------------------------------------------------------
-- STEP 7: DYNAMIC TABLE IS EMPTY (No orders yet)
--------------------------------------------------------------
SELECT * FROM FINANCE_DB.FIN_STG.DT_ORDER_DETAILS;

--------------------------------------------------------------
-- STEP 8: INSERT FIRST BATCH OF ORDERS
--------------------------------------------------------------
INSERT INTO FINANCE_DB.FIN_STG.DT_ORDERS (ORDER_ID, CUSTOMER_ID, PRODUCT_ID, QUANTITY, ORDER_DATE)
VALUES
    (1, 101, 201, 1, '2026-01-05'),
    (2, 102, 202, 3, '2026-01-10'),
    (3, 103, 203, 2, '2026-02-14'),
    (4, 104, 204, 1, '2026-02-20'),
    (5, 105, 205, 5, '2026-03-01');

--------------------------------------------------------------
-- STEP 9: MANUALLY REFRESH (or wait ~1 min for auto refresh)
--------------------------------------------------------------
ALTER DYNAMIC TABLE FINANCE_DB.FIN_STG.DT_ORDER_DETAILS REFRESH;

--------------------------------------------------------------
-- STEP 10: VERIFY - Should see 5 rows with full details
--------------------------------------------------------------
SELECT * FROM FINANCE_DB.FIN_STG.DT_ORDER_DETAILS ORDER BY ORDER_ID;

--------------------------------------------------------------
-- STEP 11: INSERT SECOND BATCH (Incremental - only new rows)
--------------------------------------------------------------
INSERT INTO FINANCE_DB.FIN_STG.DT_ORDERS (ORDER_ID, CUSTOMER_ID, PRODUCT_ID, QUANTITY, ORDER_DATE)
VALUES
    (6, 101, 206, 2, '2026-03-10'),
    (7, 103, 201, 1, '2026-03-15'),
    (8, 102, 204, 2, '2026-03-22');

ALTER DYNAMIC TABLE FINANCE_DB.FIN_STG.DT_ORDER_DETAILS REFRESH;

--------------------------------------------------------------
-- STEP 12: VERIFY - Should see all 8 rows now
--------------------------------------------------------------
SELECT * FROM FINANCE_DB.FIN_STG.DT_ORDER_DETAILS ORDER BY ORDER_ID;

--------------------------------------------------------------
-- STEP 13: TEST UPDATE ON MASTER TABLE
-- Update product price - dynamic table picks it up
--------------------------------------------------------------
UPDATE FINANCE_DB.FIN_STG.DT_PRODUCTS
SET UNIT_PRICE = 1350.00
WHERE PRODUCT_ID = 201;

ALTER DYNAMIC TABLE FINANCE_DB.FIN_STG.DT_ORDER_DETAILS REFRESH;

SELECT * FROM FINANCE_DB.FIN_STG.DT_ORDER_DETAILS
WHERE PRODUCT_ID = 201
ORDER BY ORDER_ID;

--------------------------------------------------------------
-- STEP 14: TEST UPDATE ON CUSTOMER TABLE
-- Customer moves to a new city
--------------------------------------------------------------
UPDATE FINANCE_DB.FIN_STG.DT_CUSTOMERS
SET CITY = 'Los Angeles'
WHERE CUSTOMER_ID = 101;

ALTER DYNAMIC TABLE FINANCE_DB.FIN_STG.DT_ORDER_DETAILS REFRESH;

SELECT * FROM FINANCE_DB.FIN_STG.DT_ORDER_DETAILS
WHERE CUSTOMER_ID = 101
ORDER BY ORDER_ID;

--------------------------------------------------------------
-- STEP 15: TEST DELETE - Delete an order from source
-- Dynamic table automatically reflects the deletion
--------------------------------------------------------------
DELETE FROM FINANCE_DB.FIN_STG.DT_ORDERS WHERE ORDER_ID = 5;

ALTER DYNAMIC TABLE FINANCE_DB.FIN_STG.DT_ORDER_DETAILS REFRESH;

SELECT * FROM FINANCE_DB.FIN_STG.DT_ORDER_DETAILS ORDER BY ORDER_ID;

--------------------------------------------------------------
-- STEP 16: ADD A NEW CUSTOMER + NEW ORDER IN ONE GO
--------------------------------------------------------------
INSERT INTO FINANCE_DB.FIN_STG.DT_CUSTOMERS (CUSTOMER_ID, CUSTOMER_NAME, EMAIL, CITY)
VALUES (106, 'Frank Brown', 'frank@example.com', 'Denver');

INSERT INTO FINANCE_DB.FIN_STG.DT_ORDERS (ORDER_ID, CUSTOMER_ID, PRODUCT_ID, QUANTITY, ORDER_DATE)
VALUES (9, 106, 203, 3, '2026-04-05');

ALTER DYNAMIC TABLE FINANCE_DB.FIN_STG.DT_ORDER_DETAILS REFRESH;

SELECT * FROM FINANCE_DB.FIN_STG.DT_ORDER_DETAILS ORDER BY ORDER_ID;

--------------------------------------------------------------
-- STEP 17: CHECK REFRESH HISTORY
--------------------------------------------------------------
SELECT *
FROM TABLE(INFORMATION_SCHEMA.DYNAMIC_TABLE_REFRESH_HISTORY(
    NAME => 'FINANCE_DB.FIN_STG.DT_ORDER_DETAILS'
))
ORDER BY REFRESH_START_TIME DESC
LIMIT 10;

--------------------------------------------------------------
-- STEP 18: CHECK DYNAMIC TABLE DETAILS
--------------------------------------------------------------
DESCRIBE DYNAMIC TABLE FINANCE_DB.FIN_STG.DT_ORDER_DETAILS;

--------------------------------------------------------------
-- CLEANUP (Uncomment to run)
--------------------------------------------------------------
-- DROP DYNAMIC TABLE FINANCE_DB.FIN_STG.DT_ORDER_DETAILS;
-- DROP TABLE FINANCE_DB.FIN_STG.DT_ORDERS;
-- DROP TABLE FINANCE_DB.FIN_STG.DT_CUSTOMERS;
-- DROP TABLE FINANCE_DB.FIN_STG.DT_PRODUCTS;
