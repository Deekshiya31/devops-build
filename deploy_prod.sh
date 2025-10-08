#!/bin/bash

# Variables
DOCKER_USER="deekshiya31"
PROD_REPO_TAG="$DOCKER_USER/prod:latest"

# Stop old container if running
docker rm -f react-app || true

# Pull latest image from DockerHub prod repo
docker pull $PROD_REPO_TAG

# Run new container
docker run -d -p 80:80 --name react-app $PROD_REPO_TAG
