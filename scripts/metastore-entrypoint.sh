#!/bin/sh
set -e

# Environment variables
export HADOOP_HOME=/opt/hadoop-3.4.1
export HADOOP_CLASSPATH=${HADOOP_HOME}/share/hadoop/tools/lib/*
export JAVA_HOME=/usr/local/openjdk-8
export METASTORE_DB_HOSTNAME=${METASTORE_DB_HOSTNAME:-localhost}
export HADOOP_CONF_DIR=/opt/apache-hive-metastore-3.0.0-bin/conf
export HIVE_CONF_DIR=/opt/apache-hive-metastore-3.0.0-bin/conf

# Generate metastore configuration using Python
echo "Generating metastore-site.xml from environment variables..."
python3 /opt/scripts/generate_metastore_config.py

# Wait for PostgreSQL
echo "Waiting for PostgreSQL on ${METASTORE_DB_HOSTNAME}:5432..."
while ! nc -z ${METASTORE_DB_HOSTNAME} 5432; do
    sleep 1
done
echo "PostgreSQL is ready"

# # Force initialize schema (ignore errors for existing schemas)
# echo "Force initializing Hive Metastore schema..."
# /opt/apache-hive-metastore-3.0.0-bin/bin/schematool -dbType postgres -initSchema || {
#     echo "Schema already exists or init failed, trying to upgrade/validate..."
#     /opt/apache-hive-metastore-3.0.0-bin/bin/schematool -dbType postgres -validate || true
# }
# echo "Schema initialization completed (forced)"

# Start metastore as Thrift service
echo "Starting Hive Metastore Thrift service on port 9083..."
exec /opt/apache-hive-metastore-3.0.0-bin/bin/start-metastore
