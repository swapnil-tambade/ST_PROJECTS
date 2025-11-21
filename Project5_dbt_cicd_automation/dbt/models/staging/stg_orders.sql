{{ config(materialized='view') }}

select order_id, to_timestamp(order_date) as order_date, customer_id, item_id,
quantity, unit_price
from {{ source('raw','orders_raw') }}
