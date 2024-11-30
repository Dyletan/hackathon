#!/bin/bash

# Configuration variables
POSTGRES_IMAGE="postgres:14"
FLYWAY_IMAGE="flyway/flyway:11.0"
DB_CONTAINER_NAME="postgres"
DB_PORT=5432
DB_NAME="postgres"
DB_USER="postgres"
DB_PASSWORD="postgres"
FLYWAY_CONFIG_PATH="test/conf/flyway.toml"
SQL_CLIENT="psql"

# Start the Postgres container
echo "Starting PostgreSQL Docker container..."
docker run --name $DB_CONTAINER_NAME -e POSTGRES_DB=$DB_NAME -e POSTGRES_USER=$DB_USER -e POSTGRES_PASSWORD=$DB_PASSWORD -p $DB_PORT:$DB_PORT -d $POSTGRES_IMAGE

# Wait for the database to be ready
echo "Waiting for PostgreSQL to initialize..."
sleep 5

# Run Flyway migrations
echo "Running Flyway migrations..."
docker run --rm --network=host -v $(pwd)/conf:/flyway/conf -v $(pwd)/sql:/flyway/sql $FLYWAY_IMAGE -configFiles=/flyway/conf/flyway.toml migrate

# # Validate migrations
# echo "Validating migrations were applied..."
# docker exec -it $DB_CONTAINER_NAME $SQL_CLIENT -U $DB_USER -d $DB_NAME -c "
#   -- Check functions
#   SELECT routine_name FROM information_schema.routines WHERE routine_name = 'get_recommendations_by_user_id';
#   SELECT routine_name FROM information_schema.routines WHERE routine_name = 'get_recommendations_by_device_id';

#   -- Check indexes
#   SELECT indexname FROM pg_indexes WHERE tablename = 'reaction';
#   SELECT indexname FROM pg_indexes WHERE tablename = 'movie';

#   -- Check materialized view
#   SELECT COUNT(*) FROM cached_movie_recommendations;

#   -- Check partitions
#   SELECT table_name FROM information_schema.tables WHERE table_name LIKE 'reaction_%';
#   SELECT table_name FROM information_schema.tables WHERE table_name LIKE 'movie_%';
# "

# Clean up
read -p "Press [Enter] to stop the PostgreSQL container and clean up..."
docker stop $DB_CONTAINER_NAME
docker rm $DB_CONTAINER_NAME
