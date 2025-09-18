#!/bin/bash
# PostgreSQL initialization script
# Creates separate databases for production and staging metastores

set -e

# Use POSTGRES_USER from environment, default to 'admin' if not set
DB_USER=${POSTGRES_USER:-admin}

echo "Creating databases and granting permissions to user: $DB_USER"

# Create production metastore database
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE DATABASE metastore;
    CREATE DATABASE metastore_staging;
    CREATE DATABASE metastore_sandbox;
    GRANT ALL PRIVILEGES ON DATABASE metastore TO $DB_USER;
    GRANT ALL PRIVILEGES ON DATABASE metastore_staging TO $DB_USER;
    GRANT ALL PRIVILEGES ON DATABASE metastore_sandbox TO $DB_USER;
EOSQL

echo "Databases created successfully!"
