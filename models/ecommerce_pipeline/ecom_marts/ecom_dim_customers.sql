{{ config(
    database='dbt_work',
    schema='ecommerce',
    materialized='table') }}

select
    c.customer_id,
    c.first_name || ' ' || c.last_name as full_name,
    c.email,
    c.signup_date,
    c.country
from {{ ref('ecom_stg_customers') }} c