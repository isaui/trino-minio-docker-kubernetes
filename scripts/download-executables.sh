#!/bin/bash
set -e

# Inputs (override here or via environment)
HADOOP_VERSION="${HADOOP_VERSION:-3.2.0}"
METASTORE_VERSION="${METASTORE_VERSION:-3.0.0}"
INSTALLER_DIR="$(dirname "$0")/../installer"
mkdir -p "$INSTALLER_DIR"

# Download Hive Standalone Metastore
curl -L "https://downloads.apache.org/hive/hive-standalone-metastore-${METASTORE_VERSION}/hive-standalone-metastore-${METASTORE_VERSION}-bin.tar.gz" \
	-o "$INSTALLER_DIR/hive-standalone-metastore-${METASTORE_VERSION}-bin.tar.gz"

# Download Hadoop
curl -L "https://archive.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz" \
	-o "$INSTALLER_DIR/hadoop-${HADOOP_VERSION}.tar.gz"

# Download MySQL Connector
curl -L "https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-8.0.19.tar.gz" \
	-o "$INSTALLER_DIR/mysql-connector-java-8.0.19.tar.gz"

# Download PostgreSQL JDBC
curl -L "https://jdbc.postgresql.org/download/postgresql-42.4.0.jar" \
	-o "$INSTALLER_DIR/postgresql-42.4.0.jar"

# Download Hive Exec Jar
curl -L "https://repo1.maven.org/maven2/org/apache/hive/hive-exec/${METASTORE_VERSION}/hive-exec-${METASTORE_VERSION}.jar" \
	-o "$INSTALLER_DIR/hive-exec-${METASTORE_VERSION}.jar"

# Add more curl commands from other Dockerfiles as needed
