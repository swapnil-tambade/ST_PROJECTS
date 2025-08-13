CREATE USER Raj_Tambade
  PASSWORD = 'Raj@54321'
  LOGIN_NAME = 'raj_tambade'
  DEFAULT_ROLE = analyst
  DEFAULT_WAREHOUSE = compute_wh
  DEFAULT_NAMESPACE = study_db.cust_rev_con
  MUST_CHANGE_PASSWORD = TRUE;

  
 SHOW GRANTS TO USER raj_tambade;
  
GRANT ROLE study_role TO USER raj_tambade;

CREATE ROLE sleek_data_role;

GRANT USAGE ON DATABASE sleekmart_oms TO ROLE sleek_data_role;

GRANT ROLE sleek_data_role TO USER raj_tambade;


  SHOW GRANTS TO USER raj_tambade;
  
ALTER USER raj_tambade SET DEFAULT_ROLE = sleek_data_role;

describe user raj_tambade

-- Allow role to use a database
GRANT USAGE ON DATABASE sleekmart_oms TO ROLE sleek_data_role;

create role sleek_data_analyst_role;

-- Allow role to select data from a table
GRANT SELECT ON TABLE sleekmart_oms.cust_rev_cur.orders_fact TO ROLE sleek_data_analyst_role;

-- Allow role to create tables in a schema
GRANT CREATE TABLE ON SCHEMA sleekmart_oms.cust_rev_cur TO ROLE sleek_data_analyst_role;

--assigning newly created analyst role to ra_tambade user
GRANT ROLE sleek_data_analyst_role TO USER raj_tambade;

  
