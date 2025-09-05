#!/bin/bash
set -e

# Inputs (override here or via environment)
HADOOP_VERSION="${HADOOP_VERSION:-3.2.0}"
METASTORE_VERSION="${METASTORE_VERSION:-3.0.0}"
INSTALLER_DIR="$(dirname "$0")/../installer"
mkdir -p "$INSTALLER_DIR"

# Function to download only if file does not exist
download_if_missing() {
  local url="$1"
  local outfile="$2"
  if [ -f "$outfile" ]; then
    echo "Skipping $outfile (already exists)"
  else
    echo "Downloading $url -> $outfile"
    curl -L "$url" -o "$outfile" &
  fi
}

# Download Hive Standalone Metastore
download_if_missing \
  "https://downloads.apache.org/hive/hive-standalone-metastore-${METASTORE_VERSION}/hive-standalone-metastore-${METASTORE_VERSION}-bin.tar.gz" \
  "$INSTALLER_DIR/hive-standalone-metastore-${METASTORE_VERSION}-bin.tar.gz"

# Download Hadoop
download_if_missing \
  "https://archive.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz" \
  "$INSTALLER_DIR/hadoop-${HADOOP_VERSION}.tar.gz"

# Download MySQL Connector
download_if_missing \
  "https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-8.0.19.tar.gz" \
  "$INSTALLER_DIR/mysql-connector-java-8.0.19.tar.gz"

# Download PostgreSQL JDBC
download_if_missing \
  "https://jdbc.postgresql.org/download/postgresql-42.4.0.jar" \
  "$INSTALLER_DIR/postgresql-42.4.0.jar"

# Download Hive Exec Jar
download_if_missing \
  "https://repo1.maven.org/maven2/org/apache/hive/hive-exec/${METASTORE_VERSION}/hive-exec-${METASTORE_VERSION}.jar" \
  "$INSTALLER_DIR/hive-exec-${METASTORE_VERSION}.jar"

# Add more download_if_missing calls as needed

# Wait for all background curl jobs to finish
wait

echo "All downloads checked/completed successfully."
