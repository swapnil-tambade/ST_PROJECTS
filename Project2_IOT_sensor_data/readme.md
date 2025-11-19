# IoT Sensor Streaming Pipeline (using Snowflake Streams + Tasks + dbt)
(Simulates ingestion of IoT JSON events and near-real-time processing using Snowflake Streams and Tasks and dbt)

# Developer: Swapnil Tambade (Snowflake+DBT Data Engineer)

## Highlights
✔ Real-time ingestion  
✔ Snowflake Streams for CDC  
✔ Snowflake Tasks for periodic transformation  
✔ dbt incremental modeling  

## Architecture

Local Machine(API download) → JSON → S3/GCS → Snowflake RAW-->
                  │
            Stream detects changes-->
                  │
               Task runs-->
                  │
         dbt models update marts
