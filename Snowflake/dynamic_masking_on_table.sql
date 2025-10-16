---create dynamic masking---
--used case: when you want to hide information like aadhar card, salary from the table
---you show data like ***** or ***023 

---here creating data_admin role 
--only data admin role will have access to salary data from this table all other users/role will see 0 or null value
-- in case column is text/string type then you can show data in ****012 format as * symbol is character and can not be shown for number type column like salary
--so when we want to mask number/int type column, then we mask with 0 or null
--example: aadhar or name field can be mask like this '*****012'
--and salary column like '0' or null

CREATE OR REPLACE ROLE DATA_ADMIN_SWAP_DB

GRANT ROLE DATA_ADMIN_SWAP_DB TO USER SWAPNIL;

GRANT USAGE ON DATABASE SWAP_DB TO ROLE DATA_ADMIN_SWAP_DB;

GRANT USAGE ON SCHEMA PRACTICE_SCHEMA TO ROLE DATA_ADMIN_SWAP_DB;

GRANT USAGE ON WAREHOUSE COMPUTE_WH TO ROLE DATA_ADMIN_SWAP_DB;

GRANT SELECT ON TABLE EMP_SALARY TO ROLE DATA_ADMIN_SWAP_DB;

---here using emp_salary table and masking salary field for all other role except data_admin role

SELECT * FROM SWAP_DB.PRACTICE_SCHEMA.EMP_SALARY; 


CREATE OR REPLACE MASKING POLICY EMP_SALARY_MASK AS (VAL NUMBER)
RETURNS NUMBER->
CASE WHEN CURRENT_ROLE()='DATA_ADMIN_SWAP_DB' THEN VAL   ----applying condition here
    ELSE NULL END;


SHOW MASKING POLICIES;   ---this shows all masking policies craeted in system

ALTER TABLE EMP_SALARY    ---appying masking policy to table
MODIFY COLUMN SALARY 
SET MASKING POLICY EMP_SALARY_MASK;


SELECT * FROM SWAP_DB.PRACTICE_SCHEMA.EMPLOYEES  ---select data_admin role in worksheet session and confirm if you see salary column

---in another session select any other role that you have and run select query on employees table you should see null value


------EXAMPLE 2----------------------------------


CREATE OR REPLACE MASKING POLICY TEAM_NAME_MASK AS (VAL STRING)
RETURNS STRING->
CASE 
    WHEN CURRENT_ROLE()='DATA_ADMIN_SWAP_DB' THEN VAL
    ELSE 'XXXXX'                 ---------here users will see XXXXX value this is possible for text/string columns
    END;



ALTER TABLE CRICKET_TEAMS
MODIFY COLUMN TEAM_NAME 
SET MASKING POLICY EMP_LAST_NAME_MASK;

GRANT SELECT ON TABLE CRICKET_TEAMS TO ROLE DATA_ADMIN_SWAP_DB;

SELECT * FROM CRICKET_TEAMS;



