#!/bin/bash

image_version=$(cat ./version)

# 1. Input Docker image name
read -p "Docker image name: " image_name

# 2. Build Docker image
docker build -t $image_name --platform=linux/arm/v7 .
docker build -t $image_name:v$image_version --platform=linux/arm/v7 .

# 3. Login Docker Hub account
read -p "Docker Hub username: " username
read -s -p "Docker Hub password: " password
docker login -u=$username -p=$password

# 4. Push Docker image
docker push $image_name
docker push $image_name:v$image_version


# 5. Logout Docker Hub account
docker logout
