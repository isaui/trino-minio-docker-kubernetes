#!/usr/bin/env python3

import os
import sys

def generate_dtd_dw_staging_hive_properties():
    """Generate dtd-dw-staging.properties file from environment variables"""
    
    # Get environment variables (no defaults - must be provided)
    s3_endpoint = os.getenv('MINIO_ENDPOINT')
    s3_access_key = os.getenv('MINIO_ACCESS_KEY')
    s3_secret_key = os.getenv('MINIO_SECRET_KEY')
    s3_region = os.getenv('S3_REGION', 'us-east-1')  # This one can have default
    metastore_port = os.getenv('METASTORE_PORT', '9083')
    metastore_uri = f'thrift://hive-metastore:{metastore_port}'
    
    # Validate required environment variables
    if not s3_endpoint:
        raise ValueError("MINIO_ENDPOINT environment variable is required")
    if not s3_access_key:
        raise ValueError("MINIO_ACCESS_KEY environment variable is required") 
    if not s3_secret_key:
        raise ValueError("MINIO_SECRET_KEY environment variable is required")
    
    # Hive properties template for staging
    hive_properties_content = f"""connector.name=hive
hive.metastore.uri={metastore_uri}
fs.native-s3.enabled=true
s3.path-style-access=true
s3.endpoint={s3_endpoint}
s3.aws-access-key={s3_access_key}
s3.aws-secret-key={s3_secret_key}
s3.region={s3_region}
hive.non-managed-table-writes-enabled=true
"""
    
    # Write to docker-vol catalog directory (hidden from host)
    catalog_dir = '/etc/trino/catalog'
    os.makedirs(catalog_dir, exist_ok=True)
    
    hive_properties_path = os.path.join(catalog_dir, 'dtd-dw-staging.properties')
    
    with open(hive_properties_path, 'w') as f:
        f.write(hive_properties_content)
    
    print(f"✅ Generated dtd-dw-staging.properties at {hive_properties_path}")
    print("📝 S3 credentials are now hidden from host filesystem")

if __name__ == "__main__":
    try:
        generate_dtd_dw_staging_hive_properties()
        sys.exit(0)
    except Exception as e:
        print(f"❌ Error generating dtd-dw-staging.properties: {e}")
        sys.exit(1)
