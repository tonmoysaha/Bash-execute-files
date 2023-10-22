#!/bin/bash

# Define the container name and RabbitMQ version
CONTAINER_NAME="my-rabbitmq-container"
RABBITMQ_VERSION="3.9-management"

# Check if the container already exists and stop/remove it
if docker ps -a | grep $CONTAINER_NAME; then
  echo "Stopping and removing existing $CONTAINER_NAME container..."
  docker stop $CONTAINER_NAME
  docker rm $CONTAINER_NAME
fi

# Run RabbitMQ Docker container
echo "Starting RabbitMQ container..."
docker run -d --name $CONTAINER_NAME -p 5672:5672 -p 15672:15672 rabbitmq:$RABBITMQ_VERSION

# Check if the container is running
if docker ps | grep $CONTAINER_NAME; then
  echo "RabbitMQ container is running."
else
  echo "Failed to start RabbitMQ container."
fi

