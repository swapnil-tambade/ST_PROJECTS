{{ config(
	database='finance_db',
	schema='staging',
	materialized='view'
) }}

select
transaction_id,
to_timestamp(transaction_ts) as transaction_ts,
customer_id,
amount::float as amount,
currency,
status
from {{ source('raw','transactions_raw') }}
