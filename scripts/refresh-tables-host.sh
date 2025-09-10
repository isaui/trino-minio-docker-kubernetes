#/bin/bash

. ../.venv/bin/activate
python generate_trino_views.py 
python execute_ddl.py --file ./trino-ddl.sql --host localhost
python generate_trino_staging_views.py 
python execute_ddl_staging.py --file ./trino-ddl-staging.sql --host localhost
deactivate
