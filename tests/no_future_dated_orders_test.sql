-- Fails if any orders are dated in the future
select 
order_id, 
order_date
from {{ ref('stg_orders_seed') }}
where order_date > current_date
