{{ config(
    materialized='table',
    tags=['fact'],
    database='dbt_work',
    schema='finance_schema'
) }}

with orders as (
  select * from {{ ref('stg_orders') }}
),
customers as (
  select * from {{ ref('stg_customers') }}
)

select
  o.order_id,
  o.order_ts,
  o.amount,
  o.status,
  c.customer_id,
  c.email,
  c.first_name,
  c.last_name
from orders o
left join customers c
  on o.customer_id = c.customer_id
