{% macro assert_positive_amount(model, column) -%}
select count(*) as failures
from {{ model }}
where {{ column }} <= 0 or {{ column }} is null
{%- endmacro %}
{% macro run_data_quality_checks() -%}
-- This macro could be invoked from a task to run multiple checks and log
results
select
'{{ this }}' as model_name,
(select count(*) from {{ this }}) as row_count
{%- endmacro %}
