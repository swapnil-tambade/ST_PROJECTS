CREATE USER Raj_Tambade
  PASSWORD = 'provide your password here'
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
  
