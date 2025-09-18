#!/bin/bash
set -e

echo "Initializing Hive Metastore schemas for all environments..."

# Environment variables
export HADOOP_HOME=/opt/hadoop-3.4.1
export HADOOP_CLASSPATH=${HADOOP_HOME}/share/hadoop/tools/lib/*
export JAVA_HOME=/usr/local/openjdk-8
export METASTORE_DB_HOSTNAME=${METASTORE_DB_HOSTNAME:-postgres}
export METASTORE_DB_PORT=${METASTORE_DB_PORT:-5432}
export METASTORE_DB_USER=${POSTGRES_USER:-admin}
export METASTORE_DB_PASSWORD=${POSTGRES_PASSWORD:-admin}

# Wait for PostgreSQL
echo "Waiting for PostgreSQL on ${METASTORE_DB_HOSTNAME}:${METASTORE_DB_PORT}..."
while ! nc -z ${METASTORE_DB_HOSTNAME} ${METASTORE_DB_PORT}; do
    sleep 1
done
echo "PostgreSQL is ready"

# Database configurations for all environments
declare -A DATABASES=(
    ["production"]="metastore"
    ["staging"]="metastore_staging"
    ["sandbox"]="metastore_sandbox"
)

# Initialize schema for each database
for env in "${!DATABASES[@]}"; do
    db_name="${DATABASES[$env]}"
    echo ""
    echo "Initializing $env environment schema in '$db_name' database..."
    
    # Try to validate first, if that fails then initialize
    echo "Checking if schema exists in $db_name..."
    if /opt/apache-hive-metastore-3.0.0-bin/bin/schematool -dbType postgres \
        -driver org.postgresql.Driver \
        -userName "$METASTORE_DB_USER" \
        -passWord "$METASTORE_DB_PASSWORD" \
        -url "jdbc:postgresql://$METASTORE_DB_HOSTNAME:$METASTORE_DB_PORT/$db_name" \
        -validate 2>/dev/null; then
        echo "Schema already exists and is valid in $db_name"
    else
        echo "Schema does not exist or is invalid, initializing..."
        /opt/apache-hive-metastore-3.0.0-bin/bin/schematool -dbType postgres \
            -driver org.postgresql.Driver \
            -userName "$METASTORE_DB_USER" \
            -passWord "$METASTORE_DB_PASSWORD" \
            -url "jdbc:postgresql://$METASTORE_DB_HOSTNAME:$METASTORE_DB_PORT/$db_name" \
            -initSchema --verbose || true
        
        # Check if initialization was successful
        if /opt/apache-hive-metastore-3.0.0-bin/bin/schematool -dbType postgres \
            -driver org.postgresql.Driver \
            -userName "$METASTORE_DB_USER" \
            -passWord "$METASTORE_DB_PASSWORD" \
            -url "jdbc:postgresql://$METASTORE_DB_HOSTNAME:$METASTORE_DB_PORT/$db_name" \
            -validate 2>/dev/null; then
            echo "Schema initialized successfully in $db_name"
        else
            echo "Failed to initialize schema in $db_name"
        fi
    fi
done

echo ""
echo "Hive Metastore schema initialization completed for all environments!"
echo "Databases processed: metastore, metastore_staging, metastore_sandbox"
