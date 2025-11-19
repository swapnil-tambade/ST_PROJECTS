{{ config(
  database='finance_db',
  schema='mart',
  materialized='table'
) }}

------------------------------------final table for analysis-----------------------------------------
select
device_id,
date_trunc('hour', event_ts) as hour,
avg(temperature_c) as avg_temp_c,
max(vibration) as max_vibration,
count(*) as events
from {{ ref('int_sensor_cleaned') }}
group by 1,2;
