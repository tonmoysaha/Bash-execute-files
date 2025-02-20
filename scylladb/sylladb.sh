#!/bin/bash

# Define container names, ports, and data directories
SCYLLADB_CONTAINER_NAME="scylladb_container"
SCYLLADB_DATA_DIR="./scylladb_data"
SCYLLADB_PORT=9042
SCYLLA_MANAGER_CONTAINER_NAME="scylla_manager_container"
SCYLLA_MANAGER_PORT=5080


# Create data directory for ScyllaDB if it doesn't exist
if [ ! -d "$SCYLLADB_DATA_DIR" ]; then
  echo "Creating data directory for ScyllaDB..."
  mkdir -p $SCYLLADB_DATA_DIR
fi

# Run ScyllaDB Docker container
echo "Starting ScyllaDB container..."
docker run --name $SCYLLADB_CONTAINER_NAME -d \
    -p $SCYLLADB_PORT:9042 \
    -v $SCYLLADB_DATA_DIR:/var/lib/scylla \
    scylladb/scylla:latest

# Check if the ScyllaDB container is running
if docker ps | grep $SCYLLADB_CONTAINER_NAME; then
  echo "ScyllaDB container is running."
else
  echo "Failed to start ScyllaDB container."
  exit 1
fi

# Run Scylla Manager Docker container
echo "Starting Scylla Manager container..."
docker run --name $SCYLLA_MANAGER_CONTAINER_NAME -d \
    -p $SCYLLA_MANAGER_PORT:5080 \
    scylladb/scylla-manager:latest

# Check if the Scylla Manager container is running
if docker ps | grep $SCYLLA_MANAGER_CONTAINER_NAME; then
  echo "Scylla Manager container is running."
  echo "Access Scylla Manager API at: http://localhost:$SCYLLA_MANAGER_PORT"
else
  echo "Failed to start Scylla Manager container."
  exit 1
fi

# Output success message
echo "ScyllaDB and Scylla Manager setup completed successfully."
echo "ScyllaDB is running on port $SCYLLADB_PORT."
echo "Scylla Manager API is running on port $SCYLLA_MANAGER_PORT."

