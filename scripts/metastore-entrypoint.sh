#!/bin/sh
set -e

# Environment variables
export HADOOP_HOME=/opt/hadoop-3.2.0
export HADOOP_CLASSPATH=${HADOOP_HOME}/share/hadoop/tools/lib/aws-java-sdk-bundle-1.11.375.jar:${HADOOP_HOME}/share/hadoop/tools/lib/hadoop-aws-3.2.0.jar
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

# Initialize schema
echo "Initializing Hive Metastore schema..."
/opt/apache-hive-metastore-3.0.0-bin/bin/schematool -dbType postgres -initSchema

# Start metastore as Thrift service
echo "Starting Hive Metastore Thrift service on port 9083..."
exec /opt/apache-hive-metastore-3.0.0-bin/bin/start-metastore
