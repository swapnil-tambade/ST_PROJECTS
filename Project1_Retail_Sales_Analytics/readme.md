# Retail Sales Analytics Pipeline (Snowflake + dbt + Airflow) 
## Developer: Swapnil Tambade

This project demonstrates an end-to-end ELT pipeline for retail sales example.

## Architecture

          S3/GCS Bucket(raw csv files)->
              │
          Snowpipe->
              │
          RAW Layer (Snowflake)->
              │
         dbt Transformations
   (staging → intermediate → marts)->
              │
           Airflow DAG->
              │
       Final Analytics Tables

## Features
✔ Automated ingestion using Snowpipe  
✔ dbt models (staging → intermediate → marts)  
✔ Airflow orchestration of dbt runs  
✔ Data quality tests  
✔ Incremental models  

## How to Run
1. Create Snowflake objects (scripts in /snowflake)
2. Run `dbt deps && dbt run && dbt test`
3. Deploy Airflow DAG in an Airflow environment
