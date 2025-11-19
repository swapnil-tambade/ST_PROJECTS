{{ config(
  database='finance_db',
  schema='staging',
  materialized='view') }}

select
event_id,
device_id,
event_ts,
data
from {{ source('raw','iot_events') }}
