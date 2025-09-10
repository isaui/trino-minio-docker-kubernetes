from airflow.sdk import DAG
from airflow.operators.bash import BashOperator
from airflow.operators.empty import EmptyOperator
from datetime import datetime

with DAG(
    dag_id='dag_refresh_trino_tables',
    start_date=datetime(2024, 1, 1),
    schedule='0 6 * * *',  # Daily at 6am
    catchup=False,
    tags=['dtd', 'trino', 'refresh', 'data_warehouse'],
    description='Refresh Trino table views and execute DDL statements for production and staging catalogs'
) as dag:

    start = EmptyOperator(task_id='start')

    refresh_tables = BashOperator(
        task_id='refresh_trino_tables',
        bash_command='cd /opt/airflow/scripts && bash refresh-tables.sh ',  # Added space to avoid template processing
        doc_md="""
        Run the complete refresh-tables.sh script.
        Generates views and executes DDL for both production and staging catalogs.
        """
    )

    end = EmptyOperator(task_id='end')

    start >> refresh_tables >> end