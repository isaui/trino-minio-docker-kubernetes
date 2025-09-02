#!/bin/sh

echo "Starting DDL generation seed container..."

# Wait for Trino to be healthy
echo "Waiting for Trino coordinator to be ready..."
for i in $(seq 1 30); do
    if wget --spider -q http://trino-cluster-trino:8080/v1/info 2>/dev/null; then
        echo "Trino coordinator is ready!"
        break
    fi
    echo "Attempt $i/30: Trino not ready yet, waiting 10 seconds..."
    sleep 10
done

# Check if Trino is ready
if ! wget --spider -q http://trino-cluster-trino:8080/v1/info 2>/dev/null; then
    echo "ERROR: Trino coordinator failed to become ready within 5 minutes"
    exit 1
fi

# Change to app directory
cd /app

# Generate DDL file
echo "Generating Trino DDL from parquet files..."
python3 generate_trino_views.py

# Check if DDL was generated
if [ -f "trino-ddl.sql" ]; then
    echo "DDL file generated successfully"
    
    # Copy to shared output directory
    cp trino-ddl.sql /output/trino-ddl.sql
    echo "DDL file copied to /output/trino-ddl.sql"
    
    # Show first few lines for debugging
    echo "--- DDL Preview ---"
    head -20 /output/trino-ddl.sql
    echo "--- End Preview ---"
    
    # Execute DDL in Trino
    echo "Executing DDL statements in Trino..."
    python3 execute_ddl.py
    
    if [ $? -eq 0 ]; then
        echo "DDL execution completed successfully!"
    else
        echo "DDL execution failed - check logs above"
        exit 1
    fi
else
    echo "Failed to generate DDL file"
    exit 1
fi

echo "DDL generation and execution completed. Container will exit now."
