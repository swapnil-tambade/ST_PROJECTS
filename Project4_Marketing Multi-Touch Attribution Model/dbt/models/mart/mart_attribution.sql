{{ config(materialized='table') }}
-- Simplified attribution example: first-touch and last-touch per user
conversion
with conversions as (
select user_id, min(event_ts) as conversion_ts
from {{ ref('stg_clickstream') }}
where event_type = 'purchase'
group by 1
),
journeys as (
select c.user_id, c.conversion_ts, s.*
from conversions c
join {{ ref('stg_clickstream') }} s
on s.user_id = c.user_id
where s.event_ts <= c.conversion_ts
  )
select
conversion_ts::date as date,
channel,
count(distinct case when row_number() over (partition by user_id order by
event_ts) = 1 then user_id end) as first_touch_conversions,
count(distinct case when row_number() over (partition by user_id order by
event_ts desc) = 1 then user_id end) as last_touch_conversions
from journeys
group by 1,2;
