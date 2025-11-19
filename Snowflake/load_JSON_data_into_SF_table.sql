--example to load JSON DATA INTO SF TABLES

--LOAD JSON FILE TO SNOWFLAKE INTERNAL STAGE WITH SNOWSQL (run this locally with snowsql)

PUT file:///C:/Users/hp/Desktop/Swapnil/00_Learnings-Projects/dummy_data/employee_json_file.json @raw_orders_stg;

list @raw_orders_stg
  
----In snowflake cloud UI create table to load raw json data with VARIANT data type----

create table employees_json(
raw_data variant 
);

---copy data from stage location to table

copy into employees_json from
@raw_orders_stg/employee_json_file.json.gz
FILE_FORMAT = (
    TYPE = 'JSON'
    STRIP_OUTER_ARRAY = TRUE
);


---check if data is loaded corectly----
select * from employees_json;

--create clean table from raw json table----

CREATE OR REPLACE TABLE employee_cleaned AS
SELECT
    raw_data:department::string     AS department,
    raw_data:id::number         AS emp_id,
    raw_data:name::string           AS name,
    raw_data:salary::number         AS salary
FROM employees_json;

--now we can use this table for further analysis...

select * from employee_cleaned;
