{{ config(
    materialized='view',
    database='dbt_work',
    schema='finance_schema'
) }}

select
  cast(id as number)                 as order_id,
  cast(customer_id as number)        as customer_id,
  to_timestamp_ntz(order_ts)         as order_ts,
  cast(amount as number(12,2))       as amount,
  upper(status)                      as status
from {{ source('orders_project', 'orders') }}
where status is not null
