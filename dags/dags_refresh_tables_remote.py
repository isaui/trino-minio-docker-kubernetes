from airflow.sdk import DAG
from airflow.operators.bash import BashOperator
from airflow.operators.empty import EmptyOperator
from datetime import datetime

with DAG(
    dag_id='dag_refresh_trino_tables_remote',
    start_date=datetime(2024, 1, 1),
    schedule='0 7 * * *',  # Daily at 7am (offset from local refresh)
    catchup=False,
    tags=['dtd', 'trino', 'remote', 'refresh', 'data_warehouse'],
    description='Refresh remote Trino table views and execute DDL statements with HTTPS authentication for production and staging catalogs'
) as dag:

    start = EmptyOperator(task_id='start')

    refresh_remote_tables = BashOperator(
        task_id='refresh_remote_trino_tables',
        bash_command='cd /opt/airflow/scripts && bash refresh-tables-remote.sh ',  # Added space to avoid template processing
        doc_md="""
        Run the complete refresh-tables-remote.sh script.
        Generates views and executes DDL for both production and staging catalogs on remote Trino server.
        Uses HTTPS authentication and remote Trino connection parameters from environment variables.
        
        Required Environment Variables:
        - REMOTE_TRINO_HOST: Remote Trino hostname
        - REMOTE_TRINO_PORT: Remote Trino port (default: 443)
        - REMOTE_TRINO_USERNAME: Remote Trino username
        - REMOTE_TRINO_PASSWORD: Remote Trino password
        """
    )

    end = EmptyOperator(task_id='end')

    start >> refresh_remote_tables >> end
