"""
Trino DDL Generator for Sandbox Parquet Files

Generates CREATE TABLE and VIEW statements for Trino from Parquet files in MinIO sandbox bucket
Uses PyArrow for automatic schema detection and s3fs for file listing
"""

from datetime import datetime
import os
import logging
import s3fs
import re
import argparse
import pyarrow.parquet as pq
import pyarrow as pa
from io import BytesIO
from dotenv import load_dotenv


def path_to_schema_and_view(path):
    """
    Convert MinIO path to schema and view name, using first part as schema.
    
    Args:
        path (str): MinIO path like 'raw/siakng/dosen/2025-07-24/'
        
    Returns:
        tuple: (schema_name, view_name) like ('raw', 'siakng_dosen')
    """
    # Remove leading/trailing slashes
    clean_path = path.strip('/')
    
    # Split path into components
    path_parts = clean_path.split('/')
    
    # Remove date-like components (YYYY-MM-DD pattern or similar)
    filtered_parts = []
    for part in path_parts:
        # Skip parts that look like dates (YYYY-MM-DD, YYYY_MM_DD, etc.)
        if not re.match(r'^\d{4}[-_]\d{2}[-_]\d{2}$', part):
            filtered_parts.append(part)
    
    if not filtered_parts:
        return None, None
    
    # First part becomes schema, rest becomes table name
    schema_name = filtered_parts[0]
    table_parts = filtered_parts[1:] if len(filtered_parts) > 1 else ['default']
    
    # Join table parts with underscore
    table_name = '_'.join(table_parts)
    
    return schema_name, table_name

def pyarrow_to_trino_type(pa_type):
    """Convert PyArrow type to Trino SQL type"""
    if pa.types.is_boolean(pa_type):
        return 'BOOLEAN'
    elif pa.types.is_int8(pa_type):
        return 'TINYINT'
    elif pa.types.is_int16(pa_type):
        return 'SMALLINT'
    elif pa.types.is_int32(pa_type):
        return 'INTEGER'
    elif pa.types.is_int64(pa_type):
        return 'BIGINT'
    elif pa.types.is_float32(pa_type):
        return 'REAL'
    elif pa.types.is_float64(pa_type):
        return 'DOUBLE'
    elif pa.types.is_string(pa_type) or pa.types.is_large_string(pa_type):
        return 'VARCHAR'
    elif pa.types.is_binary(pa_type) or pa.types.is_large_binary(pa_type):
        return 'VARBINARY'
    elif pa.types.is_date32(pa_type) or pa.types.is_date64(pa_type):
        return 'DATE'
    elif pa.types.is_timestamp(pa_type):
        return 'TIMESTAMP'
    elif pa.types.is_time32(pa_type) or pa.types.is_time64(pa_type):
        return 'TIME'
    elif pa.types.is_decimal(pa_type):
        precision = pa_type.precision
        scale = pa_type.scale
        return f'DECIMAL({precision}, {scale})'
    elif pa.types.is_list(pa_type) or pa.types.is_large_list(pa_type):
        element_type = pyarrow_to_trino_type(pa_type.value_type)
        return f'ARRAY<{element_type}>'
    elif pa.types.is_struct(pa_type):
        field_types = []
        for field in pa_type:
            field_name = field.name
            field_type = pyarrow_to_trino_type(field.type)
            field_types.append(f'{field_name} {field_type}')
        return f'ROW({", ".join(field_types)})'
    else:
        return 'VARCHAR'  # Fallback

def detect_schema_from_parquet(s3, bucket_name, parquet_path):
    """Detect schema from a parquet file using PyArrow"""
    try:
        # Read the parquet file
        with s3.open(f'{bucket_name}/{parquet_path}', 'rb') as f:
            parquet_file = pq.ParquetFile(f)
            schema = parquet_file.schema_arrow
            
        columns = []
        for field in schema:
            column_name = field.name
            trino_type = pyarrow_to_trino_type(field.type)
            columns.append(f'  {column_name} {trino_type}')
            
        return columns
    except Exception as e:
        logging.warning(f"Could not read schema from {parquet_path}: {e}")
        return None

def generate_ddl(output_file='trino-ddl-sandbox.sql'):
    """Generate DDL statements from sandbox bucket files"""
    # Load environment variables
    load_dotenv()
    
    # Get environment variables - sandbox specific
    s3_endpoint = os.getenv('MINIO_ENDPOINT')
    s3_access_key = os.getenv('MINIO_ACCESS_KEY')
    s3_secret_key = os.getenv('MINIO_SECRET_KEY')
    bucket_name = os.getenv('MINIO_SANDBOX_BUCKET', 'sandbox-warehouse')
    
    # Validate required environment variables
    if not s3_endpoint:
        raise ValueError("MINIO_ENDPOINT environment variable is required")
    if not s3_access_key:
        raise ValueError("MINIO_ACCESS_KEY environment variable is required")
    if not s3_secret_key:
        raise ValueError("MINIO_SECRET_KEY environment variable is required")
    
    # Set up logging
    logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
    logger = logging.getLogger(__name__)
    
    logger.info("Starting sandbox DDL generation...")
    logger.info(f"Target bucket: {bucket_name}")
    
    # Connect to S3 using s3fs
    s3 = s3fs.S3FileSystem(
        endpoint_url=s3_endpoint,
        key=s3_access_key,
        secret=s3_secret_key,
        use_ssl=os.getenv('MINIO_SSL_ENABLED', 'false').lower() == 'true'
    )
    
    # Check if bucket exists
    if not s3.exists(bucket_name):
        raise Exception(f"Sandbox bucket {bucket_name} does not exist")
    
    logger.info(f"Successfully connected to MinIO sandbox bucket: {bucket_name}")
    
    # Find all parquet files
    logger.info("Scanning for parquet files...")
    all_files = s3.find(bucket_name, withdirs=False)
    parquet_files = [f for f in all_files if f.endswith('.parquet')]
    
    logger.info(f"Found {len(parquet_files)} parquet files")
    
    # Group files by their path structure
    path_groups = {}
    for file_path in parquet_files:
        # Remove bucket name from path
        relative_path = file_path.replace(f'{bucket_name}/', '')
        
        # Extract directory path (remove filename)
        dir_path = '/'.join(relative_path.split('/')[:-1])
        
        if dir_path not in path_groups:
            path_groups[dir_path] = []
        path_groups[dir_path].append(relative_path)
    
    logger.info(f"Grouped into {len(path_groups)} directory structures")
    
    # Generate DDL statements
    ddl_statements = []
    ddl_statements.append("-- Generated DDL for sandbox environment")
    ddl_statements.append(f"-- Bucket: {bucket_name}")
    ddl_statements.append(f"-- Generated on: {datetime.now().isoformat()}")
    ddl_statements.append("")
    
    schemas_created = set()
    
    for dir_path, files in path_groups.items():
        schema_name, table_name = path_to_schema_and_view(dir_path)
        
        if not schema_name or not table_name:
            logger.warning(f"Skipping invalid path: {dir_path}")
            continue
            
        logger.info(f"Processing {schema_name}.{table_name} from {dir_path}")
        
        # Create schema if not exists
        if schema_name not in schemas_created:
            ddl_statements.append(f"CREATE SCHEMA IF NOT EXISTS dtd_dw_sandbox.{schema_name};")
            ddl_statements.append("")
            schemas_created.add(schema_name)
        
        # Try to detect schema from first parquet file
        sample_file = files[0]
        columns = detect_schema_from_parquet(s3, bucket_name, sample_file)
        
        if columns:
            logger.info(f"Detected {len(columns)} columns from schema")
            
            # Generate CREATE TABLE statement
            ddl_statements.append(f"CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.{schema_name}.{table_name} (")
            ddl_statements.extend(columns[:-1])  # All except last
            ddl_statements.append(columns[-1])   # Last without comma
            ddl_statements.append(") WITH (")
            ddl_statements.append("  format = 'PARQUET',")
            ddl_statements.append(f"  external_location = 's3a://{bucket_name}/{dir_path}/'")
            ddl_statements.append(");")
            ddl_statements.append("")
            
        else:
            logger.warning(f"Could not detect schema for {schema_name}.{table_name}, using generic structure")
            
            # Generate generic CREATE TABLE statement
            ddl_statements.append(f"CREATE TABLE IF NOT EXISTS dtd_dw_sandbox.{schema_name}.{table_name} (")
            ddl_statements.append("  -- Schema detection failed, please update manually")
            ddl_statements.append("  id BIGINT")
            ddl_statements.append(") WITH (")
            ddl_statements.append("  format = 'PARQUET',")
            ddl_statements.append(f"  external_location = 's3a://{bucket_name}/{dir_path}/'")
            ddl_statements.append(");")
            ddl_statements.append("")
    
    os.makedirs(os.path.dirname(output_file), exist_ok=True)
    
    with open(output_file, 'w') as f:
        for statement in ddl_statements:
            f.write(statement + '\n')
    
    logger.info(f"✅ Generated sandbox DDL with {len(schemas_created)} schemas")
    logger.info(f"📄 Output file: {output_file}")
    logger.info(f"📊 Total statements: {len([s for s in ddl_statements if s.strip() and not s.startswith('--')])}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description='Generate Trino DDL statements for sandbox environment from MinIO Parquet files'
    )
    
    parser.add_argument(
        '--output', '-o',
        default=os.getenv('SANDBOX_DDL_OUTPUT', 'trino-ddl-sandbox.sql'),
        help='Output DDL file path (default: trino-ddl-sandbox.sql or SANDBOX_DDL_OUTPUT env var)'
    )
    
    parser.add_argument(
        '--verbose', '-v',
        action='store_true',
        help='Enable verbose logging'
    )
    
    args = parser.parse_args()
    
    # Set up logging
    log_level = logging.DEBUG if args.verbose else logging.INFO
    logging.basicConfig(
        level=log_level,
        format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
    )
    
    logger = logging.getLogger(__name__)
    
    try:
        logger.info(f"🚀 Sandbox DDL Generation Parameters:")
        logger.info(f"   Output file: {args.output}")
        
        # Generate Trino Sandbox DDL and save to file
        generate_ddl(output_file=args.output)
        
        logger.info(f"✅ Sandbox DDL generation completed successfully!")
        
    except Exception as e:
        logger.error(f"💥 Sandbox DDL generation failed: {e}")
        exit(1)
