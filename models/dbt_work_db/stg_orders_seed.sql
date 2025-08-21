{{ config(
    materialized='table',
    database='dbt_work',
    schema='finance_schema'
) }}

select
  cast(order_id as int)             as order_id,
  cast(customer_id as int)          as customer_id,
  cast(order_date as date)          as order_date,
  lower(status)                     as status,
  cast(amount as numeric(10,2))     as amount
from {{ ref('orders') }}