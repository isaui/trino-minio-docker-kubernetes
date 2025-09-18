#!/bin/bash

echo "🚀 Starting Trino initialization..."

# Generate password database using htpasswd
echo "📝 Generating password.db with htpasswd..."
mkdir -p /etc/trino/dynamic

# Create initial admin user
htpasswd -B -C 10 -b -c /etc/trino/dynamic/password.db ${TRINO_USERNAME:-admin} ${TRINO_PASSWORD:-admin123}
if [ $? -eq 0 ]; then
    echo "✅ Admin user created successfully: ${TRINO_USERNAME:-admin}"
else
    echo "❌ Failed to create admin user"
    exit 1
fi

# Add additional users if specified
if [ -n "$ADDITIONAL_USERS" ]; then
    echo "📝 Adding additional users..."
    IFS=',' read -ra USERS <<< "$ADDITIONAL_USERS"
    for user_pass in "${USERS[@]}"; do
        IFS=':' read -r username password <<< "$user_pass"
        if [ -n "$username" ] && [ -n "$password" ]; then
            htpasswd -B -C 10 -b /etc/trino/dynamic/password.db "$username" "$password"
            if [ $? -eq 0 ]; then
                echo "✅ Added user: $username"
            else
                echo "❌ Failed to add user: $username"
            fi
        else
            echo "⚠️ Skipping invalid user format: $user_pass"
        fi
    done
else
    echo "📝 No additional users specified"
fi

# Set permissions
chmod 777 /etc/trino/dynamic/password.db
echo "✅ Password database setup completed"

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

# Generate hive properties for sandbox
echo "📝 Generating dtd-dw-sandbox.properties..."
python /app/generate_dtd_dw_sandbox_hive_properties.py
if [ $? -eq 0 ]; then
    echo "✅ DTD-DW sandbox properties generated successfully"
else
    echo "❌ Failed to generate dtd-dw sandbox properties"
fi

