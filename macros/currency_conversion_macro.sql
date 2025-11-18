{% macro convert_to_usd(amount, rate) %}
    {{ amount }} * {{ rate }}
{% endmacro %}