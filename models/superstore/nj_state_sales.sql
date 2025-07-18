{{ config(
    materialized='table'
) }}


with NJ_state_sales as (
select 
country,
state,
region,
postal_code,
city,
category,
subcategory,
sum(sales),
sum(quantity)

from STUDY_DB.SUPERSTORE_DATA.SUPERSTORE_SALES
where state='New Jersey'
group by 
country,
state,
region,
postal_code,
city,
category,
subcategory
)
  
  select * from nj_state_sales