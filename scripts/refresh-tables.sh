#/bin/bash

python generate_trino_views.py 
python execute_ddl.py --file ./trino-ddl.sql --port 8080
python generate_trino_staging_views.py 
python execute_ddl_staging.py --file ./trino-ddl-staging.sql --port 8080
