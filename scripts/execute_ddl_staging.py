#!/usr/bin/env python3
"""
Execute Staging DDL Script in Trino

Connects to Trino and executes the generated staging DDL statements
"""

import os
import logging
import time
import argparse
from dotenv import load_dotenv
from trino.dbapi import connect

def wait_for_trino_staging(host, port, max_attempts=30):
    """Wait for Trino staging catalog to be ready"""
    logger = logging.getLogger(__name__)
    username = os.getenv('TRINO_USERNAME', 'admin')
    
    logger.info(f"Waiting for Trino staging at {host}:{port} (user: {username})...")
    
    for attempt in range(max_attempts):
        try:
            logger.debug(f"Attempt {attempt + 1}/{max_attempts}: Connecting to Trino staging...")
            
            # Try to connect to Trino without auth (HTTP mode)
            conn = connect(
                host=host,
                port=port,
                user=username,
                catalog='dtd-dw-staging',
                schema='default'
            )
            
            logger.debug("Staging connection established, testing with SELECT 1...")
            
            # Test the connection
            cur = conn.cursor()
            cur.execute('SELECT 1')
            result = cur.fetchone()
            cur.close()
            conn.close()
            
            if result:
                logger.info(f"Trino staging connection successful after {attempt + 1} attempts!")
                return True
                
        except Exception as e:
            logger.warning(f"Attempt {attempt + 1}/{max_attempts}: Trino staging not ready - {e}")
            if attempt < max_attempts - 1:
                logger.info(f"Waiting 10 seconds before retry...")
                time.sleep(10)
            else:
                logger.error(f"Final attempt failed: {e}")
    
    logger.error(f"Trino staging failed to become ready after {max_attempts} attempts")
    return False

def execute_staging_ddl_file(ddl_file_path, host='trino-coordinator', port=8080):
    """Execute staging DDL statements from file"""
    logger = logging.getLogger(__name__)
    
    logger.info(f"Starting staging DDL execution from: {ddl_file_path}")
    logger.info(f"Target Trino: {host}:{port}")
    
    # Wait for Trino to be ready
    if not wait_for_trino_staging(host, port):
        raise Exception("Trino staging is not ready after maximum attempts")
    
    # Read DDL file
    logger.info(f"Reading staging DDL file: {ddl_file_path}")
    if not os.path.exists(ddl_file_path):
        raise FileNotFoundError(f"Staging DDL file not found: {ddl_file_path}")
    
    with open(ddl_file_path, 'r') as f:
        ddl_content = f.read()
    
    logger.info(f"Staging DDL file size: {len(ddl_content)} characters")
    
    # Split into individual statements
    statements = [stmt.strip() for stmt in ddl_content.split(';') if stmt.strip()]
    
    logger.info(f"Found {len(statements)} staging DDL statements to execute")
    
    # Connect to Trino without auth (HTTP mode)
    username = os.getenv('TRINO_USERNAME', 'admin')
    
    logger.info(f"Connecting to Trino for staging DDL execution (user: {username})...")
    conn = connect(
        host=host,
        port=port,
        user=username,
        catalog='dtd-dw-staging',
        schema='default'
    )
    logger.info("Staging DDL connection established")
    
    cur = conn.cursor()
    executed_count = 0
    failed_count = 0
    
    for i, statement in enumerate(statements, 1):
        # Skip comments and empty lines
        if statement.startswith('--') or not statement.strip():
            continue
            
        try:
            logger.info(f"[{i}/{len(statements)}] Executing: {statement[:100]}{'...' if len(statement) > 100 else ''}")
            cur.execute(statement)
            executed_count += 1
            logger.info(f"[{i}/{len(statements)}] Success!")
            
        except Exception as e:
            failed_count += 1
            logger.error(f"[{i}/{len(statements)}] Failed: {e}")
            logger.error(f"Statement: {statement}")
    
    cur.close()
    conn.close()
    
    logger.info(f"Staging DDL execution completed: {executed_count} successful, {failed_count} failed")
    if failed_count == 0:
        logger.info("All staging statements executed successfully!")
    else:
        logger.warning(f"{failed_count} staging statements failed out of {len(statements)} total")
    
    return executed_count, failed_count

if __name__ == "__main__":
    # Load environment variables from .env file
    load_dotenv()
    
    # Set up argument parser
    parser = argparse.ArgumentParser(
        description='Execute staging DDL statements in Trino',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Use defaults (trino-coordinator:8080, /output/trino-ddl-staging.sql)
  python execute_ddl_staging.py
  
  # Specify custom host and file
  python execute_ddl_staging.py --host localhost --port 8080 --file /path/to/ddl-staging.sql
        """
    )
    
    parser.add_argument(
        '--host', 
        default=os.getenv('TRINO_HOST', 'trino-coordinator'),
        help='Trino coordinator hostname (default: trino-coordinator or TRINO_HOST env var)'
    )
    
    parser.add_argument(
        '--port', 
        type=int,
        default=int(os.getenv('TRINO_PORT', '8080')),
        help='Trino coordinator port (default: 8080 or TRINO_PORT env var)'
    )
    
    parser.add_argument(
        '--file', 
        default=os.getenv('STAGING_DDL_FILE', '/output/trino-ddl-staging.sql'),
        help='Staging DDL file path (default: /output/trino-ddl-staging.sql or STAGING_DDL_FILE env var)'
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
        format='%(asctime)s - %(levelname)s - %(message)s'
    )
    
    logger = logging.getLogger(__name__)
    
    try:
        logger.info(f"Staging DDL Execution Parameters:")
        logger.info(f"   Host: {args.host}")
        logger.info(f"   Port: {args.port}")
        logger.info(f"   File: {args.file}")
        
        # Execute staging DDL
        success, failed = execute_staging_ddl_file(args.file, args.host, args.port)
        
        if failed == 0:
            logger.info("All staging DDL statements executed successfully!")
        else:
            logger.warning(f"Staging DDL execution completed with {failed} failures")
            exit(1)
            
    except Exception as e:
        logger.error(f"Staging DDL execution failed: {e}")
        exit(1)
