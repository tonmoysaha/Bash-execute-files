#!/bin/bash

# Define the container name and RabbitMQ version
CONTAINER_NAME="mongo_container"
MONGO_DATA_DIR="./mongo_data" 

# Check if the container already exists and stop/remove it
if docker ps -a | grep $CONTAINER_NAME; then
  echo "Stopping and removing existing $CONTAINER_NAME container..."
  docker stop $CONTAINER_NAME
  docker rm $CONTAINER_NAME
fi

# Run RabbitMQ Docker container
echo "Starting Mongo container..."
docker run --name $CONTAINER_NAME -d \
    -p 27017:27017 \
    -v $MONGO_DATA_DIR:/data/db \
    mongo:latest

# Check if the container is running
if docker ps | grep $CONTAINER_NAME; then
  echo "Mongo container is running."
else
  echo "Failed to start Mongo container."
fi


