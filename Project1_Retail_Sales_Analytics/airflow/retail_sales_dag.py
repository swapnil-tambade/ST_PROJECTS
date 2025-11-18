from airflow import DAG
from airflow.operators.bash import BashOperator
from datetime import datetime, timedelta


# Simple DAG that runs dbt commands inside an environment where dbt is configured
with DAG(
dag_id='retail_sales_dbt_daily_dag',
start_date=datetime(2025,1,1),
schedule_interval='0 1 * * *', # it will Run at 1:00 AM daily
catchup=False,
default_args={'retries':1, 'retry_delay': timedelta(minutes=5)}
) as dag:


dbt_deps = BashOperator(
task_id='dbt_deps',
bash_command='cd /path/to/ST_PROJECTS/Project1_Retail_Sales_Analytics/dbt && dbt deps'
)


dbt_run = BashOperator(
task_id='dbt_run',
bash_command='cd /path/to/ST_PROJECTS/Project1_Retail_Sales_Analytics/dbt && dbt run --profiles-dir ~/.dbt'
)


dbt_test = BashOperator(
task_id='dbt_test',
bash_command='cd /path/to/ST_PROJECTS/Project1_Retail_Sales_Analytics/dbt && dbt test --profiles-dir ~/.dbt'
)


dbt_deps >> dbt_run >> dbt_test
