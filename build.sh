#!/bin/bash

# Variables
DOCKER_USER="deekshiya31"
IMAGE_NAME="react-app"

# Build the image
docker build -t $DOCKER_USER/dev:latest .

# Push to DockerHub dev repo
docker push $DOCKER_USER/dev:latest

