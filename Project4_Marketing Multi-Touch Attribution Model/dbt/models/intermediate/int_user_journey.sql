-- This SQL is computing user sessions.
-- If a user is inactive for 30 minutes, we mark a session boundary.
-- What this part does:-- Takes your clickstream events-- Partitions them per user-- Sorts them by event time

{{ config(
	database='finance_db',
	schema='staging',
	materialized='view'
) }}

with sessions as (
select
user_id,
event_id,
event_ts,
channel,
lead(event_ts) over (partition by user_id order by event_ts) as next_ts
from {{ ref('stg_clickstream') }}
)
select *,
case when date_diff('second', event_ts, next_ts) > 1800 then 1 else 0 end as
session_boundary
from sessions;
