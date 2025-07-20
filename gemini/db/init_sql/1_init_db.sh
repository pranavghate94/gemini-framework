#!/bin/bash

# Exit on error
set -e

# Check if POSTGRES_DB environment variable is set
if [ -z "${POSTGRESQL_DATABASE}" ]; then
    echo "Error: POSTGRES_DB environment variable is not set"
    exit 1
fi

echo "Database created successfully"

# Check if POSTGRESQL_USERNAME environment variable is set
if [ -z "${POSTGRESQL_USERNAME}" ]; then
    echo "Error: POSTGRESQL_USERNAME environment variable is not set"
    exit 1
fi

# Check if POSTGRESQL_PASSWORD environment variable is set
if [ -z "${POSTGRESQL_PASSWORD}" ]; then
    echo "Error: POSTGRESQL_PASSWORD environment variable is not set"
    exit 1
fi

# Check if POSTGRESQL_DATABASE environment variable is set
if [ -z "${POSTGRESQL_DATABASE}" ]; then
    echo "Error: POSTGRESQL_DATABASE environment variable is not set"
    exit 1
fi

# Use PGPASSWORD to avoid exposing the password in the process list
export PGPASSWORD="${POSTGRESQL_PASSWORD}"

# Wait for PostgreSQL to be ready
echo "Waiting for PostgreSQL to be ready..."
until psql -h localhost -U "postgres" -d "${POSTGRESQL_DATABASE}" -c '\q' &>/dev/null; do
    echo "PostgreSQL not ready yet, retrying in 5 seconds..."
    sleep 5
done

# Execute SQL with password authentication
psql -h localhost -U "postgres" -d "${POSTGRESQL_DATABASE}" <<EOSQL
    -- Create a schema for the GEMINI Database
    CREATE SCHEMA IF NOT EXISTS gemini;
    
    -- Initialize Extensions
    CREATE EXTENSION IF NOT EXISTS "uuid-ossp"; -- Used for generating UUIDs
    CREATE EXTENSION IF NOT EXISTS "pgcrypto";  -- Used for generating passwords
    CREATE EXTENSION IF NOT EXISTS columnar;    -- Used for columnar storage
    CREATE EXTENSION IF NOT EXISTS pg_ivm;
    
    -- Set default table access method
    ALTER DATABASE $POSTGRESQL_DATABASE SET default_table_access_method = 'heap';

    -- Grant Permissions
    GRANT ALL PRIVILEGES ON SCHEMA gemini TO $POSTGRESQL_USERNAME;
    GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA gemini TO $POSTGRESQL_USERNAME;    
    GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA gemini TO $POSTGRESQL_USERNAME;
    GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA gemini TO $POSTGRESQL_USERNAME;
    GRANT ALL PRIVILEGES ON DATABASE $POSTGRESQL_DATABASE TO $POSTGRESQL_USERNAME;

EOSQL


echo "Database initialization completed successfully"

export PGPASSWORD="${POSTGRESQL_PASSWORD}"

# Run all the sql scripts that are in the /docker-entrypoint-initdb.d directory
for f in /docker-entrypoint-initdb.d/scripts/*.sql; do
    echo "Running $f"
    psql -h localhost -U "${POSTGRESQL_USERNAME}" -d "${POSTGRESQL_DATABASE}" -f "$f"
done