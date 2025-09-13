"""
Trino DDL Generator for Parquet Files

Generates CREATE TABLE and VIEW statements for Trino from Parquet files in MinIO
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
    
    # Join table parts
    table_name = '_'.join(table_parts)
    
    # Clean schema name
    schema_name = re.sub(r'[/\-\s]+', '_', schema_name)
    schema_name = re.sub(r'[^a-zA-Z0-9_]', '', schema_name)
    schema_name = re.sub(r'_+', '_', schema_name).strip('_')
    if schema_name and schema_name[0].isdigit():
        schema_name = 'sch_' + schema_name
    schema_name = schema_name.lower()
    
    # Clean table name
    table_name = re.sub(r'[/\-\s]+', '_', table_name)
    table_name = re.sub(r'[^a-zA-Z0-9_]', '', table_name)
    table_name = re.sub(r'_+', '_', table_name).strip('_')
    if table_name and table_name[0].isdigit():
        table_name = 'tbl_' + table_name
    table_name = table_name.lower()
    
    # Skip invalid results
    if not schema_name or not table_name:
        return None, None
    
    return schema_name, table_name


def list_latest_bucket_paths(storage_options, bucket_name, max_depth=10):
    """
    List only the latest paths in MinIO bucket that contain parquet files.
    For each base path (without date), finds the most recent date directory.
    """
    logger = logging.getLogger(__name__)
    fs = s3fs.S3FileSystem(**storage_options)
    
    # Test connection to MinIO S3 first
    logger.info(f"Testing connection to MinIO S3 bucket: {bucket_name}")
    try:
        # Try to list the bucket root to test connectivity
        bucket_contents = fs.ls(bucket_name, detail=False)
        logger.info(f"✅ Successfully connected to MinIO S3 bucket: {bucket_name}")
        logger.info(f"Bucket root contains {len(bucket_contents)} items")
        if len(bucket_contents) == 0:
            logger.warning("⚠️  Bucket appears to be empty - this might indicate connection issues or an actually empty bucket")
    except Exception as e:
        logger.error(f"❌ Failed to connect to MinIO S3 bucket '{bucket_name}': {e}")
        logger.error("Please check your S3 credentials and endpoint configuration")
        raise ConnectionError(f"Cannot connect to MinIO S3 bucket '{bucket_name}': {e}")
    
    all_paths_with_data = []
    
    def explore_directory(current_path, depth=0):
        if depth > max_depth:
            logger.warning(f"Reached maximum depth ({max_depth}) at path: {current_path}")
            return
            
        try:
            logger.debug(f"Exploring directory: {current_path} (depth: {depth})")
            contents = fs.ls(current_path)
            parquet_files = [f for f in contents if f.endswith('.parquet')]
            
            if parquet_files:
                # Remove bucket name from path to get relative path
                if current_path.startswith(bucket_name + '/'):
                    relative_path = current_path[len(bucket_name) + 1:]
                elif current_path.startswith(bucket_name):
                    relative_path = current_path[len(bucket_name):].lstrip('/')
                else:
                    relative_path = current_path
                
                all_paths_with_data.append(relative_path)
                logger.info(f"Found data path: {relative_path} ({len(parquet_files)} parquet files)")
            
            # Count directories for debugging
            directories = [item for item in contents if not item.endswith('.parquet') and fs.isdir(item)]
            if directories:
                logger.debug(f"Found {len(directories)} subdirectories in {current_path}")
            
            for item in contents:
                if not item.endswith('.parquet') and fs.isdir(item):
                    explore_directory(item, depth + 1)
                    
        except Exception as e:
            logger.warning(f"Could not explore {current_path}: {e}")
            # Don't re-raise here, just log and continue with other paths
    
    logger.info(f"Starting to explore bucket: {bucket_name}")
    explore_directory(bucket_name)
    logger.info(f"Exploration completed. Found {len(all_paths_with_data)} total paths with parquet data")
    
    if len(all_paths_with_data) == 0:
        logger.warning("⚠️  No paths with parquet files found in the bucket")
        logger.warning("This could mean:")
        logger.warning("  - The bucket is empty")
        logger.warning("  - No parquet files exist in the bucket")
        logger.warning("  - Connection issues prevented proper exploration")
        logger.warning("  - Insufficient permissions to access bucket contents")
    
    # Group paths by base path (without date) and find latest for each
    base_path_groups = {}
    
    for path in all_paths_with_data:
        path_parts = path.split('/')
        base_parts = []
        date_part = None
        
        for part in path_parts:
            if re.match(r'^\d{4}[-_]\d{2}[-_]\d{2}$', part):
                date_part = part
            else:
                base_parts.append(part)
        
        base_path = '/'.join(base_parts)
        
        if base_path not in base_path_groups:
            base_path_groups[base_path] = []
        
        base_path_groups[base_path].append({
            'full_path': path,
            'date_part': date_part
        })
    
    # Find latest path for each base path
    latest_paths = []
    
    for base_path, path_list in base_path_groups.items():
        if not path_list:
            continue
            
        latest_path_info = None
        latest_date = None
        
        for path_info in path_list:
            if path_info['date_part']:
                try:
                    date_str = path_info['date_part'].replace('_', '-')
                    current_date = datetime.strptime(date_str, '%Y-%m-%d')
                    
                    if latest_date is None or current_date > latest_date:
                        latest_date = current_date
                        latest_path_info = path_info
                except ValueError:
                    if latest_path_info is None:
                        latest_path_info = path_info
            else:
                if latest_path_info is None:
                    latest_path_info = path_info
        
        if latest_path_info:
            latest_paths.append(latest_path_info['full_path'])
    
    logger.info(f"Found {len(latest_paths)} latest paths with parquet data")
    return latest_paths


def get_parquet_schema_from_s3(fs, bucket_name, path):
    """
    Get schema from first parquet file in S3 path using PyArrow
    """
    logger = logging.getLogger(__name__)
    
    try:
        # List parquet files in the path
        full_path = f"{bucket_name}/{path}"
        files = fs.glob(f"{full_path}/*.parquet")
        
        if not files:
            logger.warning(f"No parquet files found in {full_path}")
            return None
            
        # Read schema from first file
        first_file = files[0]
        logger.info(f"Reading schema from: {first_file}")
        
        with fs.open(first_file, 'rb') as f:
            parquet_file = pq.ParquetFile(f)
            arrow_schema = parquet_file.schema.to_arrow_schema()
            
        return arrow_schema
        
    except Exception as e:
        logger.error(f"Error reading parquet schema from {path}: {e}")
        return None


def convert_arrow_to_trino_type(arrow_type):
    """
    Convert PyArrow types to Trino SQL types
    """
    type_str = str(arrow_type)
    
    # Handle primitive types
    if arrow_type == pa.bool_():
        return 'BOOLEAN'
    elif arrow_type == pa.int8():
        return 'TINYINT'
    elif arrow_type == pa.int16():
        return 'SMALLINT' 
    elif arrow_type == pa.int32():
        return 'INTEGER'
    elif arrow_type == pa.int64():
        return 'BIGINT'
    elif arrow_type == pa.float32():
        return 'REAL'
    elif arrow_type == pa.float64():
        return 'DOUBLE'
    elif arrow_type == pa.string():
        return 'VARCHAR'
    elif arrow_type == pa.binary():
        return 'VARBINARY'
    elif arrow_type == pa.date32():
        return 'DATE'
    elif arrow_type == pa.date64():
        return 'DATE'
    elif pa.types.is_timestamp(arrow_type):
        return 'TIMESTAMP'
    elif pa.types.is_decimal(arrow_type):
        precision = arrow_type.precision
        scale = arrow_type.scale
        return f'DECIMAL({precision}, {scale})'
    elif pa.types.is_list(arrow_type):
        element_type = convert_arrow_to_trino_type(arrow_type.value_type)
        return f'ARRAY({element_type})'
    elif pa.types.is_struct(arrow_type):
        field_types = []
        for field in arrow_type:
            field_type = convert_arrow_to_trino_type(field.type)
            field_types.append(f'{field.name} {field_type}')
        return f'ROW({"、".join(field_types)})'
    else:
        # Default to VARCHAR for unknown types
        logger = logging.getLogger(__name__)
        logger.warning(f"Unknown Arrow type {arrow_type}, defaulting to VARCHAR")
        return 'VARCHAR'


def generate_external_table_ddl(schema_name, table_name, arrow_schema, s3_location):
    """
    Generate CREATE TABLE DDL for Trino external table pointing to S3 parquet files
    """
    # Generate column definitions
    columns = []
    for field in arrow_schema:
        trino_type = convert_arrow_to_trino_type(field.type)
        columns.append(f"    {field.name} {trino_type}")
    
    columns_str = ',\n'.join(columns)
    ddl = f"""DROP TABLE IF EXISTS {schema_name}.{table_name};
CREATE TABLE {schema_name}.{table_name} (
{columns_str}
)
WITH (
    format = 'PARQUET',
    external_location = '{s3_location}'
);"""
    
    return ddl


def generate_trino_ddl(output_file=None):
    """
    Generate complete Trino DDL script with tables and views from Parquet files
    """
    logger = logging.getLogger(__name__)
    
    # Load environment variables from .env file in docker-compose directory
    env_file = os.path.join(os.path.dirname(__file__), '..', '.env')
    load_dotenv(env_file)
    
    # Get MinIO config from environment
    bucket_name = os.getenv('MINIO_WAREHOUSE_BUCKET')
    endpoint = os.getenv('MINIO_ENDPOINT')
    access_key = os.getenv('MINIO_ACCESS_KEY')
    secret_key = os.getenv('MINIO_SECRET_KEY')
    use_ssl = endpoint.startswith('https')
    
    logger.info(f"Using MinIO endpoint: {endpoint}")
    logger.info(f"Using bucket: {bucket_name}")
    
    # Configure s3fs storage options
    storage_options = {
        'endpoint_url': endpoint,
        'key': access_key,
        'secret': secret_key,
        'use_ssl': use_ssl
    }
    
    try:
        # Initialize s3fs
        fs = s3fs.S3FileSystem(**storage_options)
        
        # Get latest paths with parquet data
        latest_paths = list_latest_bucket_paths(storage_options, bucket_name)
        
        if not latest_paths:
            logger.warning("No paths with parquet data found in bucket")
            latest_paths = []
        
        logger.info(f"Found {len(latest_paths)} latest paths to generate DDL for")
        
        # Collect schemas and generate DDL
        schemas = set()
        
        # Generate complete DDL script header
        ddl_lines = [
            "-- Trino DDL script for Parquet files in MinIO",
            "-- Generated automatically from parquet file schemas", 
            "-- Run this script in Trino CLI after connecting to hive catalog",
            "",
            "-- Use hive catalog",
            "USE \"dtd_dw\".default;",
            ""
        ]
        
        # Process each path
        for path in latest_paths:
            schema_name, table_name = path_to_schema_and_view(path)
            
            # Skip paths with invalid names
            if not schema_name or not table_name:
                logger.warning(f"Skipping path with invalid schema/view name: {path}")
                continue
            
            logger.info(f"Processing {path} -> {schema_name}.{table_name}")
            
            # Get schema from parquet files
            arrow_schema = get_parquet_schema_from_s3(fs, bucket_name, path)
            if not arrow_schema:
                logger.warning(f"Could not read schema from {path}, skipping")
                continue
            
            schemas.add(schema_name)
            s3_location = f"s3a://{bucket_name}/{path}/"
            
            # Generate DDL statements
            external_table_ddl = generate_external_table_ddl(schema_name, table_name, arrow_schema, s3_location)
            
            ddl_lines.extend([
                external_table_ddl,
                ""
            ])
            
            logger.info(f"Generated DDL for: {schema_name}.{table_name}")
        
        logger.info(f"Discovered schemas: {sorted(schemas)}")
        
        # Create schemas first - insert at proper position
        if schemas:
            schema_ddl = ["-- Create schemas"]
            for schema in sorted(schemas):
                schema_ddl.extend([
                    f"DROP SCHEMA IF EXISTS \"dtd-dw\".{schema} CASCADE;",
                    f"CREATE SCHEMA \"dtd-dw\".{schema};",
                    ""
                ])
            
            # Insert after header, before tables
            ddl_lines = ddl_lines[:7] + schema_ddl + ddl_lines[7:]
        
        # Add test queries
        ddl_lines.extend([
            "-- Show available schemas",
            "SHOW SCHEMAS;",
            "",
            "-- Show tables in each schema"
        ])
        
        for schema in sorted(schemas):
            ddl_lines.extend([
                f"SHOW TABLES FROM \"dtd-dw\".{schema};",
                ""
            ])
        
        # Join all lines
        ddl_content = "\n".join(ddl_lines)
        
        # Output results
        if output_file:
            logger.info(f"Writing Trino DDL script to {output_file}")
            with open(output_file, 'w') as f:
                f.write(ddl_content)
            logger.info(f"Trino DDL script written to {output_file}")
        else:
            print(ddl_content)
        
        return ddl_content
        
    except Exception as e:
        logger.error(f"Failed to generate Trino DDL script: {e}")
        raise


if __name__ == "__main__":
    # Load environment variables from .env file
    load_dotenv()
    
    # Set up argument parser
    parser = argparse.ArgumentParser(
        description='Generate Trino DDL statements from MinIO parquet files',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Use default output file (trino-ddl.sql)
  python generate_trino_views.py
  
  # Specify custom output file
  python generate_trino_views.py --output /custom/path/ddl.sql
  
  # Use environment variable for output
  DDL_OUTPUT=/custom/ddl.sql python generate_trino_views.py
        """
    )
    
    parser.add_argument(
        '--output', '-o',
        default=os.getenv('DDL_OUTPUT', 'trino-ddl.sql'),
        help='Output DDL file path (default: trino-ddl.sql or DDL_OUTPUT env var)'
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
        logger.info(f"🚀 DDL Generation Parameters:")
        logger.info(f"   Output file: {args.output}")
        
        # Generate Trino DDL and save to file
        generate_trino_ddl(output_file=args.output)
        
        logger.info(f"✅ DDL generation completed successfully!")
        
    except Exception as e:
        logger.error(f"💥 DDL generation failed: {e}")
        exit(1)
