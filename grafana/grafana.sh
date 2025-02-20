#!/bin/bash

# Define container names, ports, and data directories
GRAFANA_CONTAINER_NAME="grafana_container"
GRAFANA_DATA_DIR="./grafana_data"
GRAFANA_PORT=3000


# Run Grafana Docker container for UI
echo "Starting Grafana container..."
docker run --name $GRAFANA_CONTAINER_NAME -d \
    -p $GRAFANA_PORT:3000 \
    -v $GRAFANA_DATA_DIR:/var/lib/grafana \
    grafana/grafana:latest

# Check if the Grafana container is running
if docker ps | grep $GRAFANA_CONTAINER_NAME; then
  echo "Grafana container is running."
  echo "Access Grafana at: http://localhost:$GRAFANA_PORT"
  echo "Default login: admin / admin"
else
  echo "Failed to start Grafana container."
  exit 1
fi

# Output success message
echo "Grafana setup completed successfully."
echo "Grafana is running on port $GRAFANA_PORT for monitoring and management."

