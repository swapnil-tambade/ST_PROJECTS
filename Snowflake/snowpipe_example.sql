-- 1. Create database & schema (if not already existing)
CREATE DATABASE IF NOT EXISTS finance_db;
CREATE SCHEMA IF NOT EXISTS finance_db.finance_schema;

-- 2. Create a file format (CSV in this case)
CREATE OR REPLACE FILE FORMAT finance_db.finance_schema.csv_format
  TYPE = 'CSV'
  FIELD_OPTIONALLY_ENCLOSED_BY = '"'
  SKIP_HEADER = 1
  NULL_IF = ('NULL', 'null');

-- 3. Create storage integration (already created earlier, included here for reference)
CREATE OR REPLACE STORAGE INTEGRATION ST_GCS_INTEGRATION
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = GCS
  ENABLED = TRUE
  STORAGE_ALLOWED_LOCATIONS = ('gcs://sales_data_st/customer_sales_data')
  COMMENT = 'Integration for GCS bucket to Snowflake';

-- Verify service account Snowflake generated (you’ll need this for GCP IAM)
DESC INTEGRATION ST_GCS_INTEGRATION;

-- 4. Create stage pointing to GCS bucket
CREATE OR REPLACE STAGE finance_db.finance_schema.gcs_stage
  URL = 'gcs://sales_data_st/customer_sales_data'
  STORAGE_INTEGRATION = ST_GCS_INTEGRATION
  FILE_FORMAT = finance_db.finance_schema.csv_format;

-- 5. Create target table
CREATE OR REPLACE TABLE finance_db.finance_schema.customer_data (
  customer_id STRING,
  name STRING,
  email STRING,
  sales_amount NUMBER,
  created_at TIMESTAMP
);

-- 6. Create Snowpipe with auto-ingest enabled
CREATE OR REPLACE PIPE finance_db.finance_schema.customer_pipe
  AUTO_INGEST = TRUE
  AS
  COPY INTO finance_db.finance_schema.customer_data
  FROM @finance_db.finance_schema.gcs_stage
  FILE_FORMAT = (FORMAT_NAME = finance_db.finance_schema.csv_format)
  ON_ERROR = 'CONTINUE';

-- 7. Verify pipe
DESC PIPE finance_db.finance_schema.customer_pipe;

-- 8. Optionally, check pipe definition and Pub/Sub details
SHOW PIPES;

----------------------------------------------------------******Needs some configurations at cloud side(in this case used GCP)********--------------------------------------
#!/bin/bash

# === CONFIG ===
PROJECT_ID="your-gcp-project-id"
BUCKET_NAME="sales_data_st"
TOPIC_NAME="sales-data-topic"
SUBSCRIPTION_NAME="sales-data-sub"
SNOWFLAKE_SA="example.sericeaccount.com"   # you get this in desc storage integration properties

# === Authenticate ===
gcloud auth login
gcloud config set project $PROJECT_ID

# === Create Pub/Sub Topic ===
gcloud pubsub topics create $TOPIC_NAME || echo "Topic already exists"

# === Create Pub/Sub Subscription ===
gcloud pubsub subscriptions create $SUBSCRIPTION_NAME \
  --topic=$TOPIC_NAME \
  --ack-deadline=600 \
  --expiration-period=never || echo "Subscription already exists"

# === Grant Snowflake Service Account permissions ===
gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$SNOWFLAKE_SA" \
  --role="roles/pubsub.subscriber"

gsutil iam ch serviceAccount:$SNOWFLAKE_SA:objectViewer gs://$BUCKET_NAME

# === Create GCS → Pub/Sub Notification ===
gsutil notification create -t $TOPIC_NAME -f json gs://$BUCKET_NAME

##--------Notification binding with pubsub and google cloud storage bucket needs to present to work auto-injest feature in snowpipe---(very important step)-----
  
# === Verify Notification Binding ===
gsutil notification list gs://$BUCKET_NAME



