# Retail Sales Analytics Pipeline (Snowflake + dbt + Airflow) (Developer: Swapnil Tambade)


This project demonstrates an end-to-end ELT pipeline for retail sales example.


## How to run (high-level)
1. Create Snowflake objects using `snowflake/*.sql` (create DB,Schema,assign roles & priviliges).
2. Place sample CSVs in the specified cloud stage (or from local machine with snowsql).
3. Install dbt-core and dbt-snowflake, set up profiles.yml with your Snowflake connection.
4. Run `dbt deps && dbt run && dbt test`.
5. Deploy `airflow/retail_sales_dag.py` to an Airflow environment to schedule runs.
