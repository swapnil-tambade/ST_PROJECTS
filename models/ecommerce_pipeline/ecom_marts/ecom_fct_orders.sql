{{ config(
    database='dbt_work',
    schema='ecommerce',
    materialized='table') }}

select
    o.order_id,
    o.customer_id,
    o.order_date,
    p.amount,
    p.payment_method
from {{ ref('ecom_stg_orders') }} o
join {{ ref('ecom_stg_payments') }} p
    on o.order_id = p.order_id