{{ config(
    database='dbt_work',
    schema='ecommerce',
    materialized='table') }}

select
    customer_id,
    first_name,
    last_name,
    email,
    signup_date,
    upper(country) as country
from {{ source('ecom_raw_src', 'customers') }}



