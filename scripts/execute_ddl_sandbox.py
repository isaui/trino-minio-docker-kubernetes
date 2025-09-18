#!/usr/bin/env python3
"""
Execute Sandbox DDL Script in Trino

Connects to Trino and executes the generated sandbox DDL statements
"""

import os
import logging
import time
import argparse
from dotenv import load_dotenv
from trino.dbapi import connect

def wait_for_trino_sandbox(host, port, max_attempts=30):
    """Wait for Trino sandbox catalog to be ready"""
    logger = logging.getLogger(__name__)
    username = os.getenv('TRINO_USERNAME', 'admin')
    
    logger.info(f"Waiting for Trino sandbox at {host}:{port} (user: {username})...")
    
    for attempt in range(max_attempts):
        try:
            logger.debug(f"Attempt {attempt + 1}/{max_attempts}: Connecting to Trino sandbox...")
            
            # Try to connect to Trino without auth (HTTP mode)
            conn = connect(
                host=host,
                port=port,
                user=username,
                catalog='dtd_dw_sandbox',
                schema='default'
            )
            
            logger.debug("Sandbox connection established, testing with SELECT 1...")
            
            # Test the connection
            cur = conn.cursor()
            cur.execute('SELECT 1')
            result = cur.fetchone()
            cur.close()
            conn.close()
            
            if result:
                logger.info(f"Trino sandbox connection successful after {attempt + 1} attempts!")
                return True
                
        except Exception as e:
            logger.warning(f"Attempt {attempt + 1}/{max_attempts}: Trino sandbox not ready - {e}")
            if attempt < max_attempts - 1:
                logger.info(f"Waiting 10 seconds before retry...")
                time.sleep(10)
            else:
                logger.error(f"Final attempt failed: {e}")
    
    logger.error(f"Trino sandbox failed to become ready after {max_attempts} attempts")
    return False

def execute_sandbox_ddl_file(ddl_file_path, host='trino-cluster-trino', port=8080):
    """Execute sandbox DDL statements from file"""
    logger = logging.getLogger(__name__)
    
    logger.info(f"Starting sandbox DDL execution from: {ddl_file_path}")
    logger.info(f"Target Trino: {host}:{port}")
    
    # Wait for Trino to be ready
    if not wait_for_trino_sandbox(host, port):
        raise Exception("Trino sandbox is not ready after maximum attempts")
    
    # Read DDL file
    logger.info(f"Reading sandbox DDL file: {ddl_file_path}")
    if not os.path.exists(ddl_file_path):
        raise FileNotFoundError(f"Sandbox DDL file not found: {ddl_file_path}")
    
    with open(ddl_file_path, 'r') as f:
        ddl_content = f.read()
    
    logger.info(f"Sandbox DDL file size: {len(ddl_content)} characters")
    
    # Split into individual statements
    statements = [stmt.strip() for stmt in ddl_content.split(';') if stmt.strip()]
    
    logger.info(f"Found {len(statements)} sandbox DDL statements to execute")
    
    # Connect to Trino without auth (HTTP mode)
    username = os.getenv('TRINO_USERNAME', 'admin')
    
    logger.info(f"Connecting to Trino for sandbox DDL execution (user: {username})...")
    conn = connect(
        host=host,
        port=port,
        user=username,
        catalog='dtd_dw_sandbox',
        schema='default'
    )
    logger.info("Sandbox DDL connection established")
    
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
    
    logger.info(f"Sandbox DDL execution completed: {executed_count} successful, {failed_count} failed")
    if failed_count == 0:
        logger.info("All sandbox statements executed successfully!")
    else:
        logger.warning(f"{failed_count} sandbox statements failed out of {len(statements)} total")
    
    return executed_count, failed_count

if __name__ == "__main__":
    # Load environment variables from .env file
    load_dotenv()
    
    # Set up argument parser
    parser = argparse.ArgumentParser(
        description='Execute sandbox DDL statements in Trino',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Use defaults (trino-cluster-trino:8080, /output/trino-ddl-sandbox.sql)
  python execute_ddl_sandbox.py
  
  # Specify custom host and file
  python execute_ddl_sandbox.py --host localhost --port 8080 --file /path/to/ddl-sandbox.sql
        """
    )
    
    parser.add_argument(
        '--host', 
        default=os.getenv('TRINO_HOST', 'trino-cluster-trino'),
        help='Trino coordinator hostname (default: trino-cluster-trino or TRINO_HOST env var)'
    )
    
    parser.add_argument(
        '--port', 
        type=int,
        default=int(os.getenv('TRINO_PORT', '8080')),
        help='Trino coordinator port (default: 8080 or TRINO_PORT env var)'
    )
    
    parser.add_argument(
        '--file', 
        default=os.getenv('SANDBOX_DDL_FILE', '/output/trino-ddl-sandbox.sql'),
        help='Sandbox DDL file path (default: /output/trino-ddl-sandbox.sql or SANDBOX_DDL_FILE env var)'
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
        logger.info(f"Sandbox DDL Execution Parameters:")
        logger.info(f"   Host: {args.host}")
        logger.info(f"   Port: {args.port}")
        logger.info(f"   File: {args.file}")
        
        # Execute sandbox DDL
        success, failed = execute_sandbox_ddl_file(args.file, args.host, args.port)
        
        if failed == 0:
            logger.info("All sandbox DDL statements executed successfully!")
        else:
            logger.warning(f"Sandbox DDL execution completed with {failed} failures")
            exit(0)
            
    except Exception as e:
        logger.error(f"Sandbox DDL execution failed: {e}")
        exit(1)
