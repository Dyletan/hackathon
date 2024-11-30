#!/bin/bash

# Configuration variables
POSTGRES_IMAGE="postgres:14"
FLYWAY_IMAGE="flyway/flyway:11.0"
FLYWAY_CONFIG_PATH="test/conf/flyway.toml"
SQL_CLIENT="psql"

# Run Flyway migrations
echo "Running Flyway migrations..."
docker run --rm --network=host -v $(pwd)/conf:/flyway/conf -v $(pwd)/sql:/flyway/sql $FLYWAY_IMAGE -configFiles=/conf/flyway.toml migrate

# Clean up
read -p "Press [Enter] to stop the PostgreSQL container and clean up..."
docker stop $DB_CONTAINER_NAME
docker rm $DB_CONTAINER_NAME
