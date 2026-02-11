from airflow import DAG
from airflow.providers.snowflake.operators.snowflake import SnowflakeSqlApiOperator
from datetime import datetime

with DAG(
    dag_id="airline_dwh_pipeline",
    start_date=datetime(2026, 2, 11),
    schedule="@daily", 
    catchup=False,
    tags=["snowflake", "dwh"]
) as dag:

    load_harmonized = SnowflakeSqlApiOperator(
        task_id="load_harmonized",
        snowflake_conn_id="snowflake_default",
        sql="CALL sp_load_harmonized_existing();"
    )

    load_analytics = SnowflakeSqlApiOperator(
        task_id="load_analytics",
        snowflake_conn_id="snowflake_default",
        sql="CALL sp_load_analytics();"
    )

    load_harmonized >> load_analytics
