#!/usr/bin/env python3
"""
Execute DDL Script in Trino

Connects to Trino and executes the generated DDL statements
"""

import os
import logging
import time
from trino.dbapi import connect
from trino.auth import BasicAuthentication

def wait_for_trino(host, port, max_attempts=30):
    """Wait for Trino to be ready"""
    logger = logging.getLogger(__name__)
    username = os.getenv('TRINO_USERNAME', 'admin')
    
    logger.info(f"🔄 Waiting for Trino at {host}:{port} (user: {username})...")
    
    for attempt in range(max_attempts):
        try:
            logger.debug(f"Attempt {attempt + 1}/{max_attempts}: Connecting to Trino...")
            
            # Try to connect to Trino without auth (HTTP mode)
            conn = connect(
                host=host,
                port=port,
                user=username,
                catalog='hive',
                schema='default'
            )
            
            logger.debug("Connection established, testing with SELECT 1...")
            
            # Test the connection
            cur = conn.cursor()
            cur.execute('SELECT 1')
            result = cur.fetchone()
            cur.close()
            conn.close()
            
            if result:
                logger.info(f"✅ Trino connection successful after {attempt + 1} attempts!")
                return True
                
        except Exception as e:
            logger.warning(f"❌ Attempt {attempt + 1}/{max_attempts}: Trino not ready - {e}")
            if attempt < max_attempts - 1:
                logger.info(f"⏳ Waiting 10 seconds before retry...")
                time.sleep(10)
            else:
                logger.error(f"💥 Final attempt failed: {e}")
    
    logger.error(f"Trino failed to become ready after {max_attempts} attempts")
    return False

def execute_ddl_file(ddl_file_path, host='trino-coordinator', port=8080):
    """Execute DDL statements from file"""
    logger = logging.getLogger(__name__)
    
    logger.info(f"🚀 Starting DDL execution from: {ddl_file_path}")
    logger.info(f"📍 Target Trino: {host}:{port}")
    
    # Wait for Trino to be ready
    if not wait_for_trino(host, port):
        raise Exception("❌ Trino is not ready after maximum attempts")
    
    # Read DDL file
    logger.info(f"📄 Reading DDL file: {ddl_file_path}")
    if not os.path.exists(ddl_file_path):
        raise FileNotFoundError(f"❌ DDL file not found: {ddl_file_path}")
    
    with open(ddl_file_path, 'r') as f:
        ddl_content = f.read()
    
    logger.info(f"📊 DDL file size: {len(ddl_content)} characters")
    
    # Split into individual statements
    statements = [stmt.strip() for stmt in ddl_content.split(';') if stmt.strip()]
    
    logger.info(f"📝 Found {len(statements)} DDL statements to execute")
    
    # Connect to Trino without auth (HTTP mode)
    username = os.getenv('TRINO_USERNAME', 'admin')
    
    logger.info(f"🔌 Connecting to Trino for DDL execution (user: {username})...")
    conn = connect(
        host=host,
        port=port,
        user=username,
        catalog='hive',
        schema='default'
    )
    logger.info("✅ DDL connection established")
    
    cur = conn.cursor()
    executed_count = 0
    failed_count = 0
    
    for i, statement in enumerate(statements, 1):
        # Skip comments and empty lines
        if statement.startswith('--') or not statement.strip():
            continue
            
        try:
            logger.info(f"⚡ [{i}/{len(statements)}] Executing: {statement[:100]}{'...' if len(statement) > 100 else ''}")
            cur.execute(statement)
            executed_count += 1
            logger.info(f"✅ [{i}/{len(statements)}] Success!")
            
        except Exception as e:
            failed_count += 1
            logger.error(f"❌ [{i}/{len(statements)}] Failed: {e}")
            logger.error(f"💥 Statement: {statement}")
    
    cur.close()
    conn.close()
    
    logger.info(f"🏁 DDL execution completed: {executed_count} successful, {failed_count} failed")
    if failed_count == 0:
        logger.info("🎉 All statements executed successfully!")
    else:
        logger.warning(f"⚠️ {failed_count} statements failed out of {len(statements)} total")
    
    return executed_count, failed_count

if __name__ == "__main__":
    # Set up logging
    logging.basicConfig(
        level=logging.INFO,
        format='%(asctime)s - %(levelname)s - %(message)s'
    )
    
    logger = logging.getLogger(__name__)
    
    try:
        # Execute DDL
        ddl_file = '/output/trino-ddl.sql'
        logger.info(f"Starting DDL execution from: {ddl_file}")
        
        success, failed = execute_ddl_file(ddl_file)
        
        if failed == 0:
            logger.info("🎉 All DDL statements executed successfully!")
        else:
            logger.warning(f"⚠️ DDL execution completed with {failed} failures")
            
    except Exception as e:
        logger.error(f"💥 DDL execution failed: {e}")
        exit(1)
