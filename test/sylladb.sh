#!/bin/bash

# Define container names, ports, and data directories
SCYLLADB_CONTAINER_NAME="scylladb_container"
SCYLLADB_DATA_DIR="./scylladb_data"
SCYLLADB_PORT=9042
SCYLLA_MANAGER_CONTAINER_NAME="scylla_manager_container"
SCYLLA_MANAGER_PORT=5080
POSTGRES_CONTAINER_NAME="scylla_manager_db"
POSTGRES_DATA_DIR="./postgres_data"
POSTGRES_PORT=5432
POSTGRES_USER="scylla"
POSTGRES_PASSWORD="scylla_password"
POSTGRES_DB="scylla_manager"

# Create data directories if they don't exist
for DIR in "$SCYLLADB_DATA_DIR" "$POSTGRES_DATA_DIR"; do
  if [ ! -d "$DIR" ]; then
    echo "Creating data directory: $DIR..."
    mkdir -p "$DIR"
  fi
done

# Stop and remove any existing containers
for CONTAINER in $SCYLLADB_CONTAINER_NAME $SCYLLA_MANAGER_CONTAINER_NAME $POSTGRES_CONTAINER_NAME; do
  if docker ps -a | grep $CONTAINER; then
    echo "Stopping and removing existing $CONTAINER container..."
    docker stop $CONTAINER
    docker rm $CONTAINER
  fi
done

# Start PostgreSQL container
echo "Starting PostgreSQL container for Scylla Manager..."
docker run --name $POSTGRES_CONTAINER_NAME -d \
    -p $POSTGRES_PORT:5432 \
    -v $POSTGRES_DATA_DIR:/var/lib/postgresql/data \
    -e POSTGRES_USER=$POSTGRES_USER \
    -e POSTGRES_PASSWORD=$POSTGRES_PASSWORD \
    -e POSTGRES_DB=$POSTGRES_DB \
    postgres:latest

# Check if PostgreSQL container is running
if docker ps | grep $POSTGRES_CONTAINER_NAME; then
  echo "PostgreSQL container is running."
else
  echo "Failed to start PostgreSQL container."
  exit 1
fi

# Start ScyllaDB container
echo "Starting ScyllaDB container..."
docker run --name $SCYLLADB_CONTAINER_NAME -d \
    -p $SCYLLADB_PORT:9042 \
    -v $SCYLLADB_DATA_DIR:/var/lib/scylla \
    scylladb/scylla:latest

# Check if ScyllaDB container is running
if docker ps | grep $SCYLLADB_CONTAINER_NAME; then
  echo "ScyllaDB container is running."
else
  echo "Failed to start ScyllaDB container."
  exit 1
fi

# Start Scylla Manager container
echo "Starting Scylla Manager container..."
docker run --name $SCYLLA_MANAGER_CONTAINER_NAME -d \
    -p $SCYLLA_MANAGER_PORT:5080 \
    --link $POSTGRES_CONTAINER_NAME:db \
    -e SCYLLA_MANAGER_DB_HOST=db \
    -e SCYLLA_MANAGER_DB_PORT=5432 \
    -e SCYLLA_MANAGER_DB_USER=$POSTGRES_USER \
    -e SCYLLA_MANAGER_DB_PASSWORD=$POSTGRES_PASSWORD \
    -e SCYLLA_MANAGER_DB_NAME=$POSTGRES_DB \
    scylladb/scylla-manager:latest

# Check if Scylla Manager container is running
if docker ps | grep $SCYLLA_MANAGER_CONTAINER_NAME; then
  echo "Scylla Manager container is running."
  echo "Access Scylla Manager API at: http://localhost:$SCYLLA_MANAGER_PORT"
else
  echo "Failed to start Scylla Manager container."
  exit 1
fi

# Output success message
echo "ScyllaDB, Scylla Manager, and PostgreSQL setup completed successfully."
echo "ScyllaDB is running on port $SCYLLADB_PORT."
echo "PostgreSQL is running on port $POSTGRES_PORT."
echo "Scylla Manager API is running on port $SCYLLA_MANAGER_PORT."

