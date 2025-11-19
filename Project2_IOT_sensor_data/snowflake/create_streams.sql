CREATE OR REPLACE STREAM demo_db.raw.iot_events_stream 
  ON TABLE finance_db.raw.iot_events;
