-- Guard against bad ETL casting or currency glitches
select 
order_id, 
amount
from {{ ref('stg_orders_seed') }}
where amount < 0
