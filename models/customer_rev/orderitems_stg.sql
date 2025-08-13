{{ config(
    database='SLEEKMART_OMS',
    schema='CUST_REV_STG',
    materialized='view'
) }}

SELECT
    OrderItemID,
    OrderID,
    ProductID,
    Quantity,
    UnitPrice,
    Quantity * UnitPrice AS TotalPrice,
    Updated_at
FROM
    {{ source('landing', 'orderitems') }}