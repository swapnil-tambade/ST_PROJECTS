CREATE ROLE STUDY_ROLE

CREATE WAREHOUSE STUDY_WH
grant role study_role to user SWAPNIL 

show warehouses
describe warehouse STUDY_WH

grant warehouse STUDY_WH TO ROLE STUDY_ROLE

SHOW ROLES
DESCRIBE warehouse study_wh

GRANT ROLE STUDY_ROLE TO WAREHOUSES STUDY_WH

alter warehouse study_wh
set warehouse_size='SMALL'

grant usage on warehouse study_wh to role study_role


