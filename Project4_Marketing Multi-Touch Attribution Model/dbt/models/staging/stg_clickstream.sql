{{ config(
	database='finance_db',
	schema='staging',
	materialized='view'
) }}

select
cast(event_id as varchar) as event_id,
user_id,
to_timestamp(event_ts) as event_ts,
page_url,
channel
from {{ source('raw','clickstream') }}
