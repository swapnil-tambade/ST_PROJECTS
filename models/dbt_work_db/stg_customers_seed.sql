{{ config(
    materialized='table',
    database='dbt_work',
    schema='finance_schema'
) }}

select
  cast(customer_id as int)         as customer_id,
  first_name,
  last_name,
  lower(email)                      as email,
  cast(created_at as date)          as created_at
from {{ ref('customers') }}
