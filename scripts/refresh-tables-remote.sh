#!/bin/bash

# Remote Trino Tables Refresh Script
# This script refreshes tables on a remote Trino server using HTTPS authentication

echo "Starting remote Trino tables refresh..."

# Generate views (same as local since this generates SQL files)
echo "Step 1: Generating Trino views..."
python generate_trino_views.py 

# Execute DDL on remote Trino
echo "Step 2: Executing DDL on remote Trino..."
python execute_ddl_remote.py --file ./trino-ddl.sql

# Generate staging views (same as local since this generates SQL files)
echo "Step 3: Generating Trino staging views..."
python generate_trino_staging_views.py 

# Execute staging DDL on remote Trino
echo "Step 4: Executing staging DDL on remote Trino..."
python execute_ddl_staging_remote.py --file ./trino-ddl-staging.sql

# Generate sandbox views (same as local since this generates SQL files)
echo "Step 5: Generating Trino sandbox views..."
python generate_trino_sandbox_views.py 

# Execute sandbox DDL on remote Trino
echo "Step 6: Executing sandbox DDL on remote Trino..."
python execute_ddl_sandbox_remote.py --file ./trino-ddl-sandbox.sql

echo "Remote Trino tables refresh completed!"
