{{ config(
    database='finance_db',
    schema='staging',
    materialized='view') }}

  
with raw as (
select
order_id,
to_timestamp(order_date) as order_date,
customer_id,
item_id,
quantity::INTEGER as quantity,
unit_price::FLOAT as unit_price,
currency,
region
from {{ source('raw','raw_orders_data') }}
)
select * from raw;
