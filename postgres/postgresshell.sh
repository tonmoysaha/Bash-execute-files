#!/bin/bash

# Define the container name and RabbitMQ version
# don't allow any space in value and folder
# if use in folder name then we have to deal with \ like linux deal
CONTAINER_NAME="my-postgres-container"
PASSWORD=112233
DB="tonmoy"
HOST_VOLUME_DIR="/home/hose2406101817a/Music/bash/postgres/pgstore"

# Check if the container already exists and stop/remove it
if docker ps -a | grep $CONTAINER_NAME; then
  echo "Stopping and removing existing $CONTAINER_NAME container..."
  docker stop $CONTAINER_NAME
  docker rm $CONTAINER_NAME
fi

# Run RabbitMQ Docker container
echo "Starting $CONTAINER_NAME container..."
docker run  --name $CONTAINER_NAME -e POSTGRES_PASSWORD="$PASSWORD" -e POSTGRES_DB=$DB -v "$HOST_VOLUME_DIR":/var/lib/postgresql/data   -p 5432:5432 -d  postgres:latest

# Check if the container is running
if docker ps | grep $CONTAINER_NAME; then
  echo "$CONTAINER_NAME container is running."
else
  echo "Failed to start $CONTAINER_NAME container."
fi

#docker run --name pg -e POSTGRES_PASSWORD=112233 -v /home/hose2406101817a/Music/bash\ file/pgs:/var/lib/postgresql/data -p 5432:5432 -d postgres
