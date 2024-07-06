#!/bin/bash

# Define the container name and RabbitMQ version
CONTAINER_NAME="redis-container"
IMAGE="redis"
HOST_PORT=6379
CONTAINER_PORT=6379

# Check if the container already exists and stop/remove it
if docker ps -a | grep $CONTAINER_NAME; then
  echo "Stopping and removing existing $CONTAINER_NAME container..."
  docker stop $CONTAINER_NAME
  docker rm $CONTAINER_NAME
fi

# Run RabbitMQ Docker container
echo "Starting RabbitMQ container..."
docker run -d --name $CONTAINER_NAME -p $HOST_PORT:$CONTAINER_PORT $IMAGE

# Check if the container is running
if docker ps | grep $CONTAINER_NAME; then
  echo "$CONTAINER_NAME is running."
  echo "Redis is now running and exposed on port $HOST_PORT."
  echo "To access the Redis CLI, use the following command:"
  echo "docker exec -it $CONTAINER_NAME redis-cli"
else
  echo "Failed to start $CONTAINER_NAME."
fi

