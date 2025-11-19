
--Creating external stage where our raw orders data is located (GCS/S3 bucket location)


CREATE OR REPLACE STAGE finance_db.raw.raw_orders_stg
FILE_FORMAT = (TYPE = 'CSV' FIELD_OPTIONALLY_ENCLOSED_BY='"' SKIP_HEADER = 1);






