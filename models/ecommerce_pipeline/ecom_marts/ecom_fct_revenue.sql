{{ config(
    database='dbt_work',
    schema='ecommerce',
    materialized='table') }}
select
    customer_id,
    sum(amount) as total_revenue,
    count(distinct order_id) as total_orders
from {{ ref('ecom_fct_orders') }}
group by customer_id