#!/usr/bin/env python3
"""
Generate password.db from environment variables

Creates Trino password database file using bcrypt hashed passwords from env vars
"""

import os
import bcrypt
import sys

def generate_password_hash(password):
    """Generate bcrypt hash for password"""
    salt = bcrypt.gensalt()
    hashed = bcrypt.hashpw(password.encode('utf-8'), salt)
    return hashed.decode('utf-8')

def generate_password_db():
    """Generate password.db file from environment variables"""
    
    # Get credentials from environment
    username = os.getenv('TRINO_USERNAME', 'admin')
    password = os.getenv('TRINO_PASSWORD', 'admin123')
    
    if not username or not password:
        print("ERROR: TRINO_USERNAME and TRINO_PASSWORD environment variables are required")
        sys.exit(1)
    
    # Generate bcrypt hash
    print(f"Generating password hash for user: {username}")
    password_hash = generate_password_hash(password)
    
    # Create password.db content
    password_db_content = f"{username}:{password_hash}\n"
    
    # Write to file
    password_db_path = '/etc/trino/dynamic/password.db'
    os.makedirs(os.path.dirname(password_db_path), exist_ok=True)
    
    with open(password_db_path, 'w') as f:
        f.write(password_db_content)
    
    # Set proper permissions
    os.chmod(password_db_path, 0o600)
    
    print(f"✅ Generated password.db at: {password_db_path}")
    print(f"User: {username}")
    return password_db_path

if __name__ == "__main__":
    generate_password_db()
