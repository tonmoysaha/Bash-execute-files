#!/bin/bash

# Define the container name and RabbitMQ version
# don't allow any space in value and folder
# if use in folder name then we have to deal with \ like linux deal
CONTAINER_NAME="my-postgres-container"

# Check if the container already exists and stop/remove it
if docker ps -a | grep $CONTAINER_NAME; then
  echo "Stopping and removing existing $CONTAINER_NAME container..."
  docker stop $CONTAINER_NAME
  docker rm $CONTAINER_NAME
fi

