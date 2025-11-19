{{ config(
    database='finance_db',
    schema='mart'
  materialized='table'
  ) }}

---reading data from intermediate incremental table and calculating total sales and total qty

  select
date_trunc('day', order_date) as order_date,
region,
sum(sales_amount) as total_sales,
sum(quantity) as total_quantity
from {{ ref('int_sales_enriched') }}
group by 1,2;
