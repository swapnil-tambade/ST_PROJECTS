{{ config(
  materialized='incremental', 
  unique_key='order_id'
  ) }}

with orders as (
select * from {{ ref('stg_sales_orders') }}
)

select
order_id,
order_date,
customer_id,
item_id,
quantity,
unit_price,
quantity * unit_price as sales_amount,
currency,
region
from orders

----incremental logic ------------

  
{% if is_incremental() %}
where order_date > (select max(order_date) from {{ this }})
{% endif %}
