#!/bin/bash

# Check if the required arguments are provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <DOCKER_IMAGE> <BUILD_TAG>"
    exit 1
fi

# Assign input arguments to variables
DOCKER_IMAGE=$1
BUILD_TAG=$2

# Step 1: Build Docker Image
echo "Building Docker image: ${DOCKER_IMAGE}:${BUILD_TAG} ..."
sudo docker build -t ${DOCKER_IMAGE}:${BUILD_TAG} .

# Step 2: Push Image to Docker Hub
echo "Pushing Docker image to Docker Hub: ${DOCKER_IMAGE}:${BUILD_TAG} ..."
sudo docker push ${DOCKER_IMAGE}:${BUILD_TAG}

# Step 3: Stop existing container
echo "Stopping and removing existing container (if any) ..."
ddocker stop intuji && docker rm intuji 

# Step 4: Pull new image
echo "Pulling new Docker image: ${DOCKER_IMAGE}:${BUILD_TAG} ..."
docker pull ${DOCKER_IMAGE}:${BUILD_TAG}

# Step 5: Run new container
echo "Running new container with image: ${DOCKER_IMAGE}:${BUILD_TAG} ..."
docker run -d --name intuji -p 8080:80 ${DOCKER_IMAGE}:${BUILD_TAG}

# Deployment complete
echo "Deployment complete!"
