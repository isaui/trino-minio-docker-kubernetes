#!/usr/bin/env python3
import os
import sys

def generate_metastore_config():
    """Generate metastore-site.xml from environment variables"""
    
    # Get environment variables
    minio_endpoint = os.getenv('MINIO_ENDPOINT')
    minio_access_key = os.getenv('MINIO_ACCESS_KEY')
    minio_secret_key = os.getenv('MINIO_SECRET_KEY')
    minio_warehouse_bucket = os.getenv('MINIO_WAREHOUSE_BUCKET', 'warehouse')
    minio_ssl_enabled = os.getenv('MINIO_SSL_ENABLED', 'false')
    
    # PostgreSQL configuration
    postgres_host = os.getenv('POSTGRES_HOST')
    postgres_port = os.getenv('POSTGRES_PORT')
    postgres_db = os.getenv('POSTGRES_DB')
    postgres_user = os.getenv('POSTGRES_USER')
    postgres_password = os.getenv('POSTGRES_PASSWORD')
    metastore_port = os.getenv('METASTORE_PORT', '9083')
    
    # Validate required variables
    if not minio_endpoint:
        print("ERROR: MINIO_ENDPOINT environment variable is required")
        sys.exit(1)
    if not minio_access_key:
        print("ERROR: MINIO_ACCESS_KEY environment variable is required")
        sys.exit(1)
    if not minio_secret_key:
        print("ERROR: MINIO_SECRET_KEY environment variable is required")
        sys.exit(1)
    if not postgres_host:
        print("ERROR: POSTGRES_HOST environment variable is required")
        sys.exit(1)
    if not postgres_port:
        print("ERROR: POSTGRES_PORT environment variable is required")
        sys.exit(1)
    if not postgres_db:
        print("ERROR: POSTGRES_DB environment variable is required")
        sys.exit(1)
    if not postgres_user:
        print("ERROR: POSTGRES_USER environment variable is required")
        sys.exit(1)
    if not postgres_password:
        print("ERROR: POSTGRES_PASSWORD environment variable is required")
        sys.exit(1)
    
    # Generate XML configuration
    config_xml = f"""<configuration>
    <!-- CRITICAL: Forces remote metastore mode, prevents Derby fallback -->
    <property>
        <name>hive.metastore.uris</name>
        <value>thrift://hive-metastore:{metastore_port}</value>
    </property>
    <property>
        <name>metastore.thrift.uris</name>
        <value>thrift://hive-metastore:{metastore_port}</value>
    </property>
    <property>
        <name>hive.metastore.local</name>
        <value>false</value>
    </property>
    <property>
        <name>javax.jdo.option.ConnectionDriverName</name>
        <value>org.postgresql.Driver</value>
    </property>
    <property>
        <name>javax.jdo.option.ConnectionURL</name>
        <value>jdbc:postgresql://{postgres_host}:{postgres_port}/{postgres_db}</value>
    </property>
    <property>
        <name>javax.jdo.option.ConnectionUserName</name>
        <value>{postgres_user}</value>
    </property>
    <property>
        <name>javax.jdo.option.ConnectionPassword</name>
        <value>{postgres_password}</value>
    </property>

    <!-- PostgreSQL connection -->
    <property>
        <name>datanucleus.autoCreateSchema</name>
        <value>false</value>
    </property>

    <!-- Warehouse location -->
    <property>
        <name>hive.metastore.warehouse.dir</name>
        <value>s3a://{minio_warehouse_bucket}/</value>
    </property>
    
    <!-- S3 Configuration -->
    <property>
        <name>fs.s3a.access.key</name>
        <value>{minio_access_key}</value>
    </property>
    <property>
        <name>fs.s3a.secret.key</name>
        <value>{minio_secret_key}</value>
    </property>
    <property>
        <name>fs.s3a.endpoint</name>
        <value>{minio_endpoint}</value>
    </property>
    <property>
        <name>fs.s3a.path.style.access</name>
        <value>true</value>
    </property>
    <property>
        <name>fs.s3a.connection.ssl.enabled</name>
        <value>{minio_ssl_enabled}</value>
    </property>

</configuration>
"""
    
    # Write configuration to file
    config_path = os.getenv('METASTORE_CONFIG_PATH', '/opt/apache-hive-metastore-3.0.0-bin/conf/metastore-site.xml')
    
    print(f"Writing config to: {config_path}")
    
    with open(config_path, 'w') as f:
        f.write(config_xml)
    
    # Verify file was written
    if os.path.exists(config_path):
        file_size = os.path.getsize(config_path)
        print(f"✅ Generated metastore-site.xml successfully ({file_size} bytes)")
    else:
        print("❌ ERROR: Failed to write metastore-site.xml")
        sys.exit(1)
    
    print(f"MINIO_ENDPOINT={minio_endpoint}")
    print(f"MINIO_WAREHOUSE_BUCKET={minio_warehouse_bucket}")
    print(f"MINIO_SSL_ENABLED={minio_ssl_enabled}")
    
    # Show first few lines of generated config for debugging
    print("\n--- Generated config preview ---")
    with open(config_path, 'r') as f:
        lines = f.readlines()[:10]
        for i, line in enumerate(lines, 1):
            print(f"{i}: {line.rstrip()}")
    print("--- End preview ---")

if __name__ == "__main__":
    generate_metastore_config()
