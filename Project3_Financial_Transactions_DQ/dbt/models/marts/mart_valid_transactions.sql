{{ config(
	database='finance_db',
	schema='mart',
	materialized='view'
) }}
select
transaction_id,
transaction_ts,
customer_id,
amount,
currency
from {{ ref('stg_transactions') }}
where amount > 0
and status = 'COMPLETED'
