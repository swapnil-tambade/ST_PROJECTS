{{ config(
    database='SLEEKMART_OMS',
    schema='CUST_REV_STG',
    materialized='view'
) }}

SELECT
    CustomerID,
    FirstName,
    LastName,
    Email,
    Phone,
    Address,
    City,
    State,
    ZipCode,
    Updated_at,
    CONCAT(FirstName, ' ', LastName) AS CustomerName
FROM
    {{ source('landing', 'customers') }}
    