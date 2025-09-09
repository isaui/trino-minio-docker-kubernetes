#!/bin/bash
set -euo pipefail

HADOOP_VERSION="${HADOOP_VERSION:-3.4.1}"
METASTORE_VERSION="${METASTORE_VERSION:-3.0.0}"
INSTALLER_DIR="$(dirname "$0")/../installer"

# List of files to check
FILES=(
  "hadoop-${HADOOP_VERSION}.tar.gz"
  "hive-exec-${METASTORE_VERSION}.jar"
  "hive-standalone-metastore-${METASTORE_VERSION}-bin.tar.gz"
  "mysql-connector-java-8.0.19.tar.gz"
  "postgresql-42.4.0.jar"
)

echo "=== Verifying installer files in $INSTALLER_DIR ==="

for file in "${FILES[@]}"; do
  path="$INSTALLER_DIR/$file"

  if [ ! -f "$path" ]; then
    echo "[MISSING] $file not found"
    continue
  fi

  case "$file" in
    *.tar.gz|*.tgz)
      echo "[CHECK] Testing tar.gz: $file"
      if gzip -t "$path" && tar -tzf "$path" > /dev/null; then
        echo "[OK] $file is a valid gzip+tar archive"
      else
        echo "[ERROR] $file appears corrupted"
      fi
      ;;
    *.jar)
      echo "[CHECK] Testing jar: $file"
      if unzip -t "$path" > /dev/null; then
        echo "[OK] $file is a valid jar/zip archive"
      else
        echo "[ERROR] $file appears corrupted"
      fi
      # Optional: try signature verification if jarsigner is available
      if command -v jarsigner >/dev/null 2>&1; then
        echo "[INFO] Running jarsigner verification on $file"
        if jarsigner -verify -verbose -certs "$path" | grep -q 'jar verified'; then
          echo "[OK] $file signature verified"
        else
          echo "[WARN] $file not signed or verification failed"
        fi
      fi
      ;;
    *)
      echo "[SKIP] Unknown file type: $file"
      ;;
  esac
done

echo "=== Verification complete ==="
