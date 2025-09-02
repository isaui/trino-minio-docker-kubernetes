#!/usr/bin/env python3
import os
import logging
import time
from trino.dbapi import connect
from trino.auth import BasicAuthentication

def _get_auth():
    """Return (username, auth) where auth may be None if no password set."""
    username = os.getenv('TRINO_USERNAME', 'admin')
    password = os.getenv('TRINO_PASSWORD')  # ambil dari Secret/env
    auth = BasicAuthentication(username, password) if password else None
    return username, auth

def _connect_trino(host, port, catalog='hive', schema='default'):
    """Centralized connector honoring auth + scheme + TLS verify."""
    username, auth = _get_auth()
    http_scheme = os.getenv('TRINO_HTTP_SCHEME', 'http')  # 'http' (svc internal) | 'https' (Ingress)
    verify = os.getenv('TRINO_VERIFY', 'true').lower() in ('1', 'true', 'yes')
    return connect(
        host=host,
        port=int(port),
        user=username,
        catalog=catalog,
        schema=schema,
        auth=auth,
        http_scheme=http_scheme,
        verify=verify,
        source='ddl-seed'   # optional: untuk identifikasi di Trino
    )

def wait_for_trino(host, port, max_attempts=30):
    """Wait for Trino to be ready (with auth if enabled)."""
    logger = logging.getLogger(__name__)
    username, _ = _get_auth()
    logger.info(f"🔄 Waiting for Trino at {host}:{port} (user: {username})...")

    for attempt in range(max_attempts):
        try:
            conn = _connect_trino(host, port)
            cur = conn.cursor()
            cur.execute('SELECT 1')
            _ = cur.fetchone()
            cur.close()
            conn.close()
            logger.info(f"✅ Trino connection successful after attempt {attempt + 1}!")
            return True
        except Exception as e:
            logger.warning(f"❌ Attempt {attempt + 1}/{max_attempts}: Trino not ready - {e}")
            if attempt < max_attempts - 1:
                time.sleep(10)
            else:
                logger.error(f"💥 Final attempt failed: {e}")
    return False

def execute_ddl_file(ddl_file_path, host='trino-cluster-trino', port=8080):
    """Execute DDL statements from file."""
    logger = logging.getLogger(__name__)
    logger.info(f"🚀 Starting DDL execution from: {ddl_file_path}")
    logger.info(f"📍 Target Trino: {host}:{port}")

    if not wait_for_trino(host, port):
        raise Exception("❌ Trino is not ready after maximum attempts")

    if not os.path.exists(ddl_file_path):
        raise FileNotFoundError(f"❌ DDL file not found: {ddl_file_path}")

    with open(ddl_file_path, 'r') as f:
        ddl_content = f.read()

    statements = [s.strip() for s in ddl_content.split(';') if s.strip()]
    logger.info(f"📝 Found {len(statements)} DDL statements to execute")

    conn = _connect_trino(host, port)
    cur = conn.cursor()
    executed, failed = 0, 0

    for i, stmt in enumerate(statements, 1):
        if stmt.startswith('--') or not stmt:
            continue
        try:
            logger.info(f"⚡ [{i}/{len(statements)}] Executing: {stmt[:100]}{'...' if len(stmt) > 100 else ''}")
            cur.execute(stmt)
            executed += 1
        except Exception as e:
            failed += 1
            logger.error(f"❌ [{i}/{len(statements)}] Failed: {e}")
            logger.error(f"💥 Statement: {stmt}")

    cur.close()
    conn.close()
    logger.info(f"🏁 DDL execution completed: {executed} successful, {failed} failed")
    return executed, failed

if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
    ddl_file = '/output/trino-ddl.sql'
    try:
        success, failed = execute_ddl_file(ddl_file)
        if failed == 0:
            logging.info("🎉 All DDL statements executed successfully!")
        else:
            logging.warning(f"⚠️ DDL execution completed with {failed} failures")
    except Exception as e:
        logging.error(f"💥 DDL execution failed: {e}")
        exit(1)
