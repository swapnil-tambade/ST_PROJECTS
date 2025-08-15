-- =========================
-- 1. DATABASE ADMIN
-- =========================

-- 1.1 Create a new database
CREATE DATABASE sales_db
COMMENT = 'Sales reporting and analytics database'
DATA_RETENTION_TIME_IN_DAYS = 7;

-- 1.2 Verify database creation
SHOW DATABASES LIKE 'sales%';

-- 1.3 Use the database
USE DATABASE sales_db;

-- 1.4 Alter database settings
ALTER DATABASE sales_db
SET DATA_RETENTION_TIME_IN_DAYS = 14;

ALTER DATABASE sales_db
SET COMMENT = 'Updated comment: Sales DB for analytics';

-- 1.5 Create a role for database access
CREATE ROLE IF NOT EXISTS analyst_role COMMENT = 'Role for sales analysts';

-- 1.6 Grant database privileges
GRANT USAGE ON DATABASE sales_db TO ROLE analyst_role;
GRANT USAGE ON SCHEMA sales_db.PUBLIC TO ROLE analyst_role;
GRANT SELECT ON ALL TABLES IN SCHEMA sales_db.PUBLIC TO ROLE analyst_role;
GRANT SELECT ON FUTURE TABLES IN SCHEMA sales_db.PUBLIC TO ROLE analyst_role;

-- 1.7 Clone the database
CREATE DATABASE sales_db_clone CLONE sales_db;

-- 1.8 Describe databases
DESC DATABASE sales_db;
DESC DATABASE sales_db_clone;

-- =========================
-- 2. SCHEMA ADMIN
-- =========================

-- 2.1 Create a new schema in sales_db
CREATE SCHEMA finance_schema
COMMENT = 'Schema for finance-related tables and views'
DATA_RETENTION_TIME_IN_DAYS = 7;

-- 2.2 Verify schema creation
SHOW SCHEMAS LIKE 'finance_schema';

-- 2.3 Alter schema settings
ALTER SCHEMA finance_schema
SET COMMENT = 'Updated: Finance schema for reporting';

ALTER SCHEMA finance_schema
SET DATA_RETENTION_TIME_IN_DAYS = 14;

-- 2.4 Create a role for schema access
CREATE ROLE IF NOT EXISTS finance_role COMMENT = 'Role for finance team';

-- 2.5 Grant schema privileges
GRANT USAGE ON SCHEMA sales_db.finance_schema TO ROLE finance_role;
GRANT SELECT ON ALL TABLES IN SCHEMA sales_db.finance_schema TO ROLE finance_role;
GRANT SELECT ON FUTURE TABLES IN SCHEMA sales_db.finance_schema TO ROLE finance_role;
GRANT CREATE TABLE ON SCHEMA sales_db.finance_schema TO ROLE finance_role;
GRANT CREATE VIEW ON SCHEMA sales_db.finance_schema TO ROLE finance_role;

-- 2.6 Clone schema
CREATE SCHEMA finance_schema_clone CLONE finance_schema;

-- 2.7 Describe schema
DESC SCHEMA sales_db.finance_schema;
DESC SCHEMA sales_db.finance_schema_clone;

-- =========================
-- 3. CLEANUP SECTION
-- =========================

-- 3.1 Revoke schema privileges
REVOKE SELECT ON FUTURE TABLES IN SCHEMA sales_db.finance_schema FROM ROLE finance_role;
REVOKE USAGE ON SCHEMA sales_db.finance_schema FROM ROLE finance_role;

-- 3.2 Revoke database privileges
REVOKE SELECT ON FUTURE TABLES IN SCHEMA sales_db.PUBLIC FROM ROLE analyst_role;
REVOKE USAGE ON SCHEMA sales_db.PUBLIC FROM ROLE analyst_role;
REVOKE USAGE ON DATABASE sales_db FROM ROLE analyst_role;

-- 3.3 Drop schemas
DROP SCHEMA IF EXISTS finance_schema_clone;
DROP SCHEMA IF EXISTS finance_schema;

-- 3.4 Drop databases
DROP DATABASE IF EXISTS sales_db_clone;
DROP DATABASE IF EXISTS sales_db;

-- 3.5 Drop roles
DROP ROLE IF EXISTS finance_role;
DROP ROLE IF EXISTS analyst_role;
