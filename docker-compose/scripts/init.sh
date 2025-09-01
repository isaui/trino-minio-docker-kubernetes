#!/bin/bash

echo "🚀 Starting Trino initialization..."

# Generate password database using htpasswd
echo "📝 Generating password.db with htpasswd..."
mkdir -p /etc/trino/dynamic
htpasswd -B -C 10 -b -c /etc/trino/dynamic/password.db ${TRINO_USERNAME:-admin} ${TRINO_PASSWORD:-admin123}
if [ $? -eq 0 ]; then
    echo "✅ Password database generated successfully with htpasswd"
    chmod 777 /etc/trino/dynamic/password.db
else
    echo "❌ Failed to generate password database with htpasswd"
    exit 1
fi

# Generate hive properties
echo "📝 Generating hive.properties..."
python /app/generate_hive_properties.py
if [ $? -eq 0 ]; then
    echo "✅ Hive properties generated successfully"
else
    echo "❌ Failed to generate hive properties"
    exit 1
fi

echo "🎉 Trino initialization completed successfully!"
