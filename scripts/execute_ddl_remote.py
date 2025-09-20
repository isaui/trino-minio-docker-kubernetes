#!/usr/bin/env python3
"""
Execute DDL Script in Remote Trino

Connects to remote Trino server and executes the generated DDL statements
"""

import os
import logging
import time
import argparse
from dotenv import load_dotenv
from trino.dbapi import connect
from trino.auth import BasicAuthentication


def wait_for_trino(host, port, username, password, max_attempts=30):
    """Wait for Trino to be ready"""
    logger = logging.getLogger(__name__)
    
    logger.info(f"Waiting for Remote Trino at {host}:{port} (user: {username})...")
    
    for attempt in range(max_attempts):
        try:
            logger.debug(f"Attempt {attempt + 1}/{max_attempts}: Connecting to Remote Trino...")
            
            # Connect to remote Trino with HTTPS and authentication
            conn = connect(
                host=host,
                port=port,
                auth=BasicAuthentication(username, password),
                catalog='dtd_dw',
                schema='default',
                http_scheme='https' if port == 443 else 'http',
                verify=True  # Disable SSL verification if needed
            )
            
            logger.debug("Remote connection established, testing with SELECT 1...")
            
            # Test the connection
            cur = conn.cursor()
            cur.execute('SELECT 1')
            result = cur.fetchone()
            cur.close()
            conn.close()
            
            if result:
                logger.info(f"Remote Trino connection successful after {attempt + 1} attempts!")
                return True
                
        except Exception as e:
            logger.warning(f"Attempt {attempt + 1}/{max_attempts}: Remote Trino not ready - {e}")
            if attempt < max_attempts - 1:
                logger.info(f"Waiting 10 seconds before retry...")
                time.sleep(10)
            else:
                logger.error(f"Final attempt failed: {e}")
    
    logger.error(f"Remote Trino failed to become ready after {max_attempts} attempts")
    return False

def execute_ddl_file(ddl_file_path, host='trino72.pusilkom.com', port=443, username='admin', password='admin123'):
    """Execute DDL statements from file"""
    logger = logging.getLogger(__name__)
    
    logger.info(f"Starting DDL execution from: {ddl_file_path}")
    logger.info(f"Target Remote Trino: {host}:{port}")
    
    # Wait for Trino to be ready
    if not wait_for_trino(host, port, username, password):
        raise Exception("Remote Trino is not ready after maximum attempts")
    
    # Read DDL file
    logger.info(f"Reading DDL file: {ddl_file_path}")
    if not os.path.exists(ddl_file_path):
        raise FileNotFoundError(f"DDL file not found: {ddl_file_path}")
    
    with open(ddl_file_path, 'r') as f:
        ddl_content = f.read()
    
    logger.info(f"DDL file size: {len(ddl_content)} characters")
    
    # Split into individual statements
    statements = [stmt.strip() for stmt in ddl_content.split(';') if stmt.strip()]
    
    logger.info(f"Found {len(statements)} DDL statements to execute")
    
    # Connect to remote Trino with HTTPS and authentication
    logger.info(f"Connecting to Remote Trino for DDL execution (user: {username})...")
    conn = connect(
        host=host,
        port=port,
        auth=BasicAuthentication(username, password),
        catalog='dtd_dw',
        schema='default',
        http_scheme='https' if port == 443 else 'http',
        verify=True  # Disable SSL verification if needed
    )
    logger.info("Remote DDL connection established")
    
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
    
    logger.info(f"Remote DDL execution completed: {executed_count} successful, {failed_count} failed")
    if failed_count == 0:
        logger.info("All statements executed successfully!")
    else:
        logger.warning(f"{failed_count} statements failed out of {len(statements)} total")
    
    return executed_count, failed_count

if __name__ == "__main__":
    # Load environment variables from .env file
    load_dotenv()
    
    # Set up argument parser
    parser = argparse.ArgumentParser(
        description='Execute DDL statements in Remote Trino',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Use defaults from environment variables
  python execute_ddl_remote.py
  
  # Specify custom host and file
  python execute_ddl_remote.py --host trino72.pusilkom.com --port 443 --file /path/to/ddl.sql
        """
    )
    
    parser.add_argument(
        '--host', 
        default=os.getenv('REMOTE_TRINO_HOST', 'trino72.pusilkom.com'),
        help='Remote Trino coordinator hostname (default: trino72.pusilkom.com or REMOTE_TRINO_HOST env var)'
    )
    
    parser.add_argument(
        '--port', 
        type=int,
        default=int(os.getenv('REMOTE_TRINO_PORT', '443')),
        help='Remote Trino coordinator port (default: 443 or REMOTE_TRINO_PORT env var)'
    )
    
    parser.add_argument(
        '--username', 
        default=os.getenv('REMOTE_TRINO_USERNAME', 'admin'),
        help='Remote Trino username (default: admin or REMOTE_TRINO_USERNAME env var)'
    )
    
    parser.add_argument(
        '--password', 
        default=os.getenv('REMOTE_TRINO_PASSWORD', 'admin123'),
        help='Remote Trino password (default: admin123 or REMOTE_TRINO_PASSWORD env var)'
    )
    
    parser.add_argument(
        '--file', 
        default=os.getenv('DDL_FILE', './trino-ddl.sql'),
        help='DDL file path (default: ./trino-ddl.sql or DDL_FILE env var)'
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
        logger.info(f"Remote DDL Execution Parameters:")
        logger.info(f"   Host: {args.host}")
        logger.info(f"   Port: {args.port}")
        logger.info(f"   Username: {args.username}")
        logger.info(f"   File: {args.file}")
        
        # Execute DDL
        success, failed = execute_ddl_file(args.file, args.host, args.port, args.username, args.password)
        
        if failed == 0:
            logger.info("All DDL statements executed successfully!")
        else:
            logger.warning(f"DDL execution completed with {failed} failures")
            exit(0)
            
    except Exception as e:
        logger.error(f"Remote DDL execution failed: {e}")
        exit(1)
