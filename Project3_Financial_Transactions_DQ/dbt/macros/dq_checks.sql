---below macro test will confirm if output generated for provided column of the output is positive or not
--we ar checking number should be positive and not null

{% macro assert_positive_amount(model, column) -%}
select count(*) as failures
from {{ model }}
where {{ column }} <= 0 or {{ column }} is null
{%- endmacro %}

----------------below test will return number of rows output generated for provided model---
---so we can run this as posthook or separate dbt test after our main dbt model run completes and we can trigger alert if this number of rows are out of expected range

  
{% macro run_data_quality_checks() -%}
results
select
'{{ this }}' as model_name,
(select count(*) from {{ this }}) as row_count
{%- endmacro %}
