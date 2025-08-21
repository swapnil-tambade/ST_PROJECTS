{{ config(
    materialized='view',
    database='dbt_work',
    schema='finance_schema'
) }}

select
  cast(id as number)                 as customer_id,
  trim(lower(email))                 as email,
  initcap(trim(first_name))          as first_name,
  initcap(trim(last_name))           as last_name,
  to_timestamp_ntz(created_at)       as created_at
from {{ source('orders_project', 'customers') }}
