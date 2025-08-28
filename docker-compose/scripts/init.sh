#!/bin/bash

echo "🚀 Starting Trino initialization..."

# Generate password database
echo "📝 Generating password.db..."
python /app/generate_password_db.py
if [ $? -eq 0 ]; then
    echo "✅ Password database generated successfully"
else
    echo "❌ Failed to generate password database"
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
