# IoT Sensor Streaming Pipeline (using Snowflake Streams + Tasks + dbt)
(Simulates ingestion of IoT JSON events and near-real-time processing using Snowflake (Streams and Tasks) and dbt run)  

## Developer: Swapnil Tambade (Snowflake+DBT Data Engineer)

## Highlights
✔ Real-time ingestion with Snowpipe 
✔ Snowflake Streams for CDC  
✔ Snowflake Tasks for periodic transformation  
✔ dbt incremental modeling  

## Architecture

            JSON data → S3/GCS → Snowpipe → Snowflake RAW
                  │
            Stream table detects changes
                  │
            Task updates final raw table
                  │
            dbt models update upto marts layer
