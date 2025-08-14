-- 1. Create a new database
CREATE DATABASE sales_db
COMMENT = 'Sales reporting and analytics database'
DATA_RETENTION_TIME_IN_DAYS = 7;

-- 2. Verify database creation
SHOW DATABASES LIKE 'sales_db';

-- 3. Use the database
USE DATABASE sales_db;

-- 4. Alter database parameter settings (optional)
ALTER DATABASE sales_db
SET DATA_RETENTION_TIME_IN_DAYS = 14;

ALTER DATABASE sales_db
SET COMMENT = 'Updated comment: Sales DB for analytics';

-- 5. Grant privileges to a role
-- First, create a role (if it doesn't exist)
CREATE ROLE IF NOT EXISTS analyst_role COMMENT = 'Role for sales analysts';

-- Grant usage on database to the role
GRANT USAGE ON DATABASE sales_db TO ROLE analyst_role;

-- Grant usage on schema and select privilege on all tables
GRANT USAGE ON SCHEMA sales_db.PUBLIC TO ROLE analyst_role;
GRANT SELECT ON ALL TABLES IN SCHEMA sales_db.PUBLIC TO ROLE analyst_role;

-- Ensure new tables also have select privilege automatically
GRANT SELECT ON FUTURE TABLES IN SCHEMA sales_db.PUBLIC TO ROLE analyst_role;

-- 6. Clone the database (zero-copy)
CREATE DATABASE sales_db_clone CLONE sales_db;

-- 7. Describe databases
DESC DATABASE sales_db;
DESC DATABASE sales_db_clone;

-- 8. Check the current database
SELECT CURRENT_DATABASE();

-- 9. Revoke privileges (cleanup example)
REVOKE SELECT ON FUTURE TABLES IN SCHEMA sales_db.PUBLIC FROM ROLE analyst_role;
REVOKE USAGE ON SCHEMA sales_db.PUBLIC FROM ROLE analyst_role;
REVOKE USAGE ON DATABASE sales_db FROM ROLE analyst_role;

-- 10. Drop databases (cleanup)
DROP DATABASE IF EXISTS sales_db_clone;
DROP DATABASE IF EXISTS sales_db;

-- 11. Drop role (cleanup)
DROP ROLE IF EXISTS analyst_role;
