#/bin/bash

. ../.venv/bin/activate
python generate_trino_views.py 
python execute_ddl.py --file ./trino-ddl.sql 
deactivate
