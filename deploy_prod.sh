#!/bin/bash

# 1. STOP the existing container (ignore errors if it's not running)
docker stop react-app || true

# 2. REMOVE the stopped container (ignore errors if it doesn't exist)
docker rm react-app || true

# --- DOCKER LOGIN FOR REMOTE PULL ---
# Use your Docker Hub Username and Password to authorize the pull
# REPLACE <YOUR_PASSWORD> with your actual Docker Hub Password
echo "Goodwork@2025" | docker login -u deekshiya31 --password-stdin
# ------------------------------------

# 3. PULL and RUN the new image
# The 'docker run' command will automatically pull the image first
docker run -d --name react-app -p 80:80 deekshiya31/prod:latest

# 4. Log out after pull/run (Good practice for security)
docker logout
