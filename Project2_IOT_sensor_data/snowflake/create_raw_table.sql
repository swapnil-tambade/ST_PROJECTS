
CREATE OR REPLACE TABLE finance_db.raw.iot_events (
event_id VARCHAR,
device_id VARCHAR,
event_ts TIMESTAMP_NTZ,
data VARIANT
);
