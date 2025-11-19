-- Task to move data from stream table into a processed table daily (or frequent schedule)
--this task will only loading data from stream table to processed table to store recently loaded records

CREATE OR REPLACE TASK finance_db.raw.process_iot_stream_task
WAREHOUSE = COMPUTE_WH
SCHEDULE = 'USING CRON * 5 * * * UTC' -- runs every 5 minutes interval 
AS
INSERT INTO finance_db.raw.iot_sensor_events_processed (event_id, device_id, event_ts, temp_c, vibration)
SELECT
value:event_id::string,
value:device_id::string,
to_timestamp(value:event_ts::string),
value:data:temperature::float,
value:data:vibration::float
FROM finance_db.raw.iot_events_stream;  


