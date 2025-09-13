#!/usr/bin/env python3

import os
import sys

def generate_dtd_dw_staging_hive_properties():
    """Generate dtd-dw-staging.properties file from environment variables"""
    
    # Get environment variables
    s3_endpoint = os.getenv('MINIO_ENDPOINT')
    s3_access_key = os.getenv('MINIO_ACCESS_KEY')
    s3_secret_key = os.getenv('MINIO_SECRET_KEY')
    s3_region = os.getenv('MINIO_REGION', 'us-east-1')
    bucket_name = os.getenv('MINIO_STAGING_BUCKET', 'staging-warehouse')
    metastore_uri = os.getenv('HIVE_METASTORE_STAGING_URI', 'thrift://hive-metastore-staging:9083')
    
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
