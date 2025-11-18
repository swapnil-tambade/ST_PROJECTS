{{ config(
    database='dbt_work',
    schema='ecommerce',
    materialized='table'
) }}

select
    order_id,
    customer_id,
    order_date,
    status
from {{ source('ecom_raw_src', 'orders') }}
where status != 'cancelled'