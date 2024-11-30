#!/bin/bash

FLYWAY_IMAGE="flyway/flyway:11.0"

# Run Flyway migrations
echo "Running Flyway migrations..."
docker run --rm \
  -v $(pwd)/flyway/conf:/flyway/conf \
  -v $(pwd)/flyway/sql:/flyway/sql \
  $FLYWAY_IMAGE -configFiles=conf/flyway.conf migrate
