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

# Generate hive properties for production
echo "📝 Generating dtd-dw.properties..."
python /app/generate_dtd_dw_hive_properties.py
if [ $? -eq 0 ]; then
    echo "✅ DTD-DW production properties generated successfully"
else
    echo "❌ Failed to generate dtd-dw production properties"
fi

# Generate hive properties for staging
echo "📝 Generating dtd-dw-staging.properties..."
python /app/generate_dtd_dw_staging_hive_properties.py
if [ $? -eq 0 ]; then
    echo "✅ DTD-DW staging properties generated successfully"
else
    echo "❌ Failed to generate dtd-dw staging properties"
fi

echo "🎉 Trino initialization completed successfully!"
