{{ config(
  database='finance_db',
  schema='intermediate',
  materialized='incremental',
  unique_key='event_id') }}

----------------------------reading data from stating table in CTE--------------------
with src as (
select
event_id,
device_id,
event_ts,
data
from {{ ref('stg_sensor_data') }}
)

-------------------------------------cleaning and casting as per project need-----------------------
select
event_id,
device_id,
to_timestamp(event_ts) as event_ts,
try_cast(data:temperature::float as float) as temperature_c,
try_cast(data:vibration::float as float) as vibration
from src

---------------------------------------writing incremental logic below--------------------------------
{% if is_incremental() %}
where event_ts > (select max(event_ts) from {{ this }})
{% endif %}
