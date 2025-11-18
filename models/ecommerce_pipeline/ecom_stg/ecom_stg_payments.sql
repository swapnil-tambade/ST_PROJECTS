{{ config(
    database='dbt_work',
    schema='ecommerce',
    materialized='table') }}

select
    payment_id,
    order_id,
    payment_method,
    amount
from {{ source('ecom_raw_src', 'payments') }}