-- Snowpipe to load data from S3/GCS bucket to raw SF table(Replace notification settings as required.
--external stage is already created with GCS/S3 BUCKET location (@raw.stage.raw_orders_stg)
--with the help of snowpipe we are loading csv file data(located on external stage) into raw layer SF table

CREATE OR REPLACE PIPE finance_db.raw.orders_data_pipe
AUTO_INGEST = FALSE
AS
COPY INTO finance_db.raw.raw_orders_data
FROM @raw.stage.raw_orders_stg
FILE_FORMAT = (TYPE = 'CSV' FIELD_OPTIONALLY_ENCLOSED_BY='"' SKIP_HEADER = 1)
ON_ERROR = 'CONTINUE';
