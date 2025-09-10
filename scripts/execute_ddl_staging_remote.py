#!/usr/bin/env python3
"""
Execute Remote Staging DDL Script in Trino

Connects to remote Trino with HTTPS authentication and executes the generated staging DDL statements
"""

import os
import logging
import time
import argparse
from dotenv import load_dotenv
from trino.dbapi import connect
from trino.auth import BasicAuthentication

def wait_for_remote_trino_staging(host, port, username, password, max_attempts=30):
    """Wait for remote Trino staging catalog to be ready"""
    logger = logging.getLogger(__name__)
    
    logger.info(f"Waiting for remote Trino staging at {host}:{port} (user: {username})...")
    
    for attempt in range(max_attempts):
        try:
            logger.debug(f"Attempt {attempt + 1}/{max_attempts}: Connecting to remote Trino staging...")
            
            # Try to connect to remote Trino with HTTPS and authentication
            conn = connect(
                host=host,
                port=port,
                auth=BasicAuthentication(username, password),
                catalog='dtd-dw-staging',
                schema='default',
                http_scheme='https',
                verify=True  # Disable SSL verification if needed
            )
            
            logger.debug("Remote staging connection established, testing with SELECT 1...")
            
            # Test the connection
            cur = conn.cursor()
            cur.execute('SELECT 1')
            result = cur.fetchone()
            cur.close()
            conn.close()
            
            if result:
                logger.info(f"Remote Trino staging connection successful after {attempt + 1} attempts!")
                return True
                
        except Exception as e:
            logger.warning(f"Attempt {attempt + 1}/{max_attempts}: Remote Trino staging not ready - {e}")
            if attempt < max_attempts - 1:
                logger.info(f"Waiting 10 seconds before retry...")
                time.sleep(10)
            else:
                logger.error(f"Final attempt failed: {e}")
    
    logger.error(f"Remote Trino staging failed to become ready after {max_attempts} attempts")
    return False

def execute_remote_staging_ddl_file(ddl_file_path, host=None, port=None, username=None, password=None):
    """Execute remote staging DDL statements from file"""
    logger = logging.getLogger(__name__)
    
    # Get remote Trino connection parameters from environment variables
    if host is None:
        host = os.getenv('REMOTE_TRINO_HOST', 'trino-remote.example.com')
    if port is None:
        port = int(os.getenv('REMOTE_TRINO_PORT', '443'))
    if username is None:
        username = os.getenv('REMOTE_TRINO_USERNAME', 'admin')
    if password is None:
        password = os.getenv('REMOTE_TRINO_PASSWORD', '')
    
    logger.info(f"Starting remote staging DDL execution from: {ddl_file_path}")
    logger.info(f"Target remote Trino: {host}:{port}")
    logger.info(f"Remote user: {username}")
    
    # Validate that we have a password for remote authentication
    if not password:
        raise ValueError("Remote Trino password is required. Set REMOTE_TRINO_PASSWORD environment variable.")
    
    # Wait for remote Trino to be ready
    if not wait_for_remote_trino_staging(host, port, username, password):
        raise Exception("Remote Trino staging is not ready after maximum attempts")
    
    # Read DDL file
    logger.info(f"Reading remote staging DDL file: {ddl_file_path}")
    if not os.path.exists(ddl_file_path):
        raise FileNotFoundError(f"Remote staging DDL file not found: {ddl_file_path}")
    
    with open(ddl_file_path, 'r') as f:
        ddl_content = f.read()
    
    logger.info(f"Remote staging DDL file size: {len(ddl_content)} characters")
    
    # Split into individual statements
    statements = [stmt.strip() for stmt in ddl_content.split(';') if stmt.strip()]
    
    logger.info(f"Found {len(statements)} remote staging DDL statements to execute")
    
    # Connect to remote Trino with HTTPS and basic authentication
    logger.info(f"Connecting to remote Trino for staging DDL execution (user: {username})...")
    conn = connect(
        host=host,
        port=port,
        auth=BasicAuthentication(username, password),
        catalog='dtd-dw-staging',
        schema='default',
        http_scheme='https',
        verify=True  # Disable SSL verification if needed
    )
    logger.info("Remote staging DDL connection established")
    
    cur = conn.cursor()
    executed_count = 0
    failed_count = 0
    
    for i, statement in enumerate(statements, 1):
        # Skip comments and empty lines
        if statement.startswith('--') or not statement.strip():
            continue
            
        try:
            logger.info(f"[{i}/{len(statements)}] Executing remote staging: {statement[:100]}{'...' if len(statement) > 100 else ''}")
            cur.execute(statement)
            executed_count += 1
            logger.info(f"[{i}/{len(statements)}] Remote staging success!")
            
        except Exception as e:
            failed_count += 1
            logger.error(f"[{i}/{len(statements)}] Remote staging failed: {e}")
            logger.error(f"Statement: {statement}")
    
    cur.close()
    conn.close()
    
    logger.info(f"Remote staging DDL execution completed: {executed_count} successful, {failed_count} failed")
    if failed_count == 0:
        logger.info("All remote staging statements executed successfully!")
    else:
        logger.warning(f"{failed_count} remote staging statements failed out of {len(statements)} total")
    
    return executed_count, failed_count

if __name__ == "__main__":
    # Load environment variables from .env file
    load_dotenv()
    
    # Set up argument parser
    parser = argparse.ArgumentParser(
        description='Execute staging DDL statements in remote Trino with HTTPS authentication',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Use defaults from environment variables
  python execute_ddl_staging_remote.py
  
  # Specify custom parameters
  python execute_ddl_staging_remote.py --host remote-trino.com --port 443 --file /path/to/ddl-staging.sql
  
Environment Variables:
  REMOTE_TRINO_HOST         - Remote Trino hostname (default: trino-remote.example.com)
  REMOTE_TRINO_PORT         - Remote Trino port (default: 443)
  REMOTE_TRINO_USERNAME     - Remote Trino username (default: admin)
  REMOTE_TRINO_PASSWORD     - Remote Trino password (required)
  STAGING_DDL_FILE          - DDL file path (default: /output/trino-ddl-staging.sql)
        """
    )
    
    parser.add_argument(
        '--host', 
        default=os.getenv('REMOTE_TRINO_HOST', 'trino-remote.example.com'),
        help='Remote Trino coordinator hostname (default: trino-remote.example.com or REMOTE_TRINO_HOST env var)'
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
        default=os.getenv('REMOTE_TRINO_PASSWORD', ''),
        help='Remote Trino password (required, use REMOTE_TRINO_PASSWORD env var)'
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
        logger.info(f"Remote Staging DDL Execution Parameters:")
        logger.info(f"   Host: {args.host}")
        logger.info(f"   Port: {args.port}")
        logger.info(f"   Username: {args.username}")
        logger.info(f"   Password: {'***' if args.password else 'NOT SET'}")
        logger.info(f"   File: {args.file}")
        
        # Validate password is provided
        if not args.password:
            logger.error("Remote Trino password is required. Use --password or set REMOTE_TRINO_PASSWORD environment variable.")
            exit(1)
        
        # Execute remote staging DDL
        success, failed = execute_remote_staging_ddl_file(
            args.file, 
            args.host, 
            args.port, 
            args.username, 
            args.password
        )
        
        if failed == 0:
            logger.info("All remote staging DDL statements executed successfully!")
        else:
            logger.warning(f"Remote staging DDL execution completed with {failed} failures")
            exit(0)
            
    except Exception as e:
        logger.error(f"Remote staging DDL execution failed: {e}")
        exit(1)
