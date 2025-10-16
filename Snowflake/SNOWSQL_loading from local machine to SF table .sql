---example to load CSV file from local machine to SF table with snowsql
--this is helpful when you have large files to load from local machine to SF table


CREATE OR REPLACE TABLE ORDERS (
  ORDER_ID    INTEGER,
  ORDER_DATE  DATE,
  CUSTOMER_ID INTEGER,
  AMOUNT      NUMBER(10,2),
  STATUS      STRING
);

CREATE OR REPLACE FILE FORMAT FF_CSV_STD
  TYPE = CSV
  FIELD_DELIMITER = ','
  SKIP_HEADER = 1
  FIELD_OPTIONALLY_ENCLOSED_BY = '"'
  NULL_IF = ('', 'NULL');

---creating internal stage on the schema we are currently in-----

CREATE OR REPLACE STAGE STG_ORDERS;

------now from command line interface from local machine -----
--open snowsql and login to your snowflake account
--it uses snowsql installation and refers config file to get account information
--now run put command to upload data files from local machine to named stage---

PUT FILE://C:\Users\hp\Desktop\Swapnil\00_Learnings-Projects\orders_data_snowsql_load_example @STG_ORDERS; 

---above statement will only work from snowsql CLI from local machine-------

list @STG_ORDERS;  ---check if file is loaded to named stage

-----now load data from named stage to SF table---
COPY INTO ORDERS
  FROM @STG_ORDERS
  PATTERN = '.*orders.*\\.csv(\\.gz)?'
  FILE_FORMAT='FF_CSV_STD'
  ON_ERROR = 'CONTINUE';

  select * from orders;   ---check data in the table






 
