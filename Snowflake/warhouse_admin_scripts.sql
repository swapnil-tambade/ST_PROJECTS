-- ==============================================
-- Snowflake Warehouse Admin Script
-- ==============================================

-- =========================
-- 1️⃣ List All Warehouses
-- =========================
SHOW WAREHOUSES;

-- View detailed info
  
select * from SNOWFLAKE.ACCOUNT_USAGE.WAREHOUSES;
select * from SNOWFLAKE.ACCOUNT_USAGE.WAREHOUSE_EVENTS_HISTORY;


-- =========================
-- 2️⃣ Create a Warehouse
-- =========================
CREATE OR REPLACE WAREHOUSE WH_ANALYTICS
WITH 
    WAREHOUSE_SIZE = 'XSMALL'           -- XS, S, M, L, XL, XXL, etc.
    WAREHOUSE_TYPE = 'STANDARD'         -- STANDARD or SNOWPARK-OPTIMIZED
    AUTO_SUSPEND = 300                  -- seconds before auto-suspend
    AUTO_RESUME = TRUE
    INITIALLY_SUSPENDED = TRUE
    COMMENT = 'Analytics warehouse for BI team';

-- =========================
-- 3️⃣ Alter a Warehouse
-- =========================
ALTER WAREHOUSE WH_ANALYTICS SET WAREHOUSE_SIZE = 'SMALL';
ALTER WAREHOUSE WH_ANALYTICS SET AUTO_SUSPEND = 60;
ALTER WAREHOUSE WH_ANALYTICS SET COMMENT = 'Upgraded to SMALL for higher concurrency';

-- =========================
-- 4️⃣ Grant/Revoke Privileges
-- =========================
show roles;
-- Grant usage & monitoring privileges to a role
GRANT USAGE ON WAREHOUSE WH_ANALYTICS TO ROLE SLEEK_DATA_ROLE;
GRANT OPERATE ON WAREHOUSE WH_ANALYTICS TO ROLE SYSADMIN;   -- start/stop privileges
GRANT MONITOR ON WAREHOUSE WH_ANALYTICS TO ROLE SLEEK_DATA_ROLE;    -- view usage

-- Revoke privileges
REVOKE USAGE ON WAREHOUSE WH_ANALYTICS FROM ROLE SLEEK_DATA_ROLE;

-- =========================
-- 5️⃣ Start / Suspend / Resume Warehouse
-- =========================
ALTER WAREHOUSE WH_ANALYTICS RESUME;    -- Start warehouse
ALTER WAREHOUSE WH_ANALYTICS SUSPEND;   -- Stop warehouse

-- =========================
-- 6️⃣ Drop Warehouse
-- =========================
DROP WAREHOUSE IF EXISTS WH_ANALYTICS;

-- =========================
-- 7️⃣ Monitor Warehouse Usage
-- =========================
SELECT 
    warehouse_name,
    start_time,
    end_time,
    credits_used,
    credits_used_compute,
    credits_used_cloud_services
FROM SNOWFLAKE.ACCOUNT_USAGE.WAREHOUSE_METERING_HISTORY
WHERE start_time >= DATEADD(DAY, -7, CURRENT_TIMESTAMP())
ORDER BY start_time DESC;

-- =========================
-- 8️⃣ Monitor Query Load by Warehouse
-- =========================
SELECT 
    warehouse_name,
    COUNT(*) AS total_queries,
    AVG(total_elapsed_time/1000) AS avg_runtime_sec
FROM SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY
WHERE start_time >= DATEADD(DAY, -7, CURRENT_TIMESTAMP())
GROUP BY warehouse_name
ORDER BY total_queries DESC;
