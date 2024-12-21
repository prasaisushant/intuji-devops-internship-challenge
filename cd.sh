#!/bin/bash

# Check if the required arguments are provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <DOCKER_IMAGE> <BUILD_TAG>"
    exit 1
fi

# Assign input arguments to variables
DOCKER_IMAGE=$1
BUILD_TAG=$2

# Building Docker Image
sudo docker build -t ${DOCKER_IMAGE}:${BUILD_TAG} .

# Pushing Image to Docker Hub

sudo docker push ${DOCKER_IMAGE}:${BUILD_TAG}

# Stoping existing container
docker stop intuji && docker rm intuji

# Pull new image
docker pull ${DOCKER_IMAGE}:${BUILD_TAG}

# Run new container
docker run -d --name intuji -p 8080:80 ${DOCKER_IMAGE}:${BUILD_TAG}

echo "Deployment complete!"
