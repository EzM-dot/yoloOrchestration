#!/bin/bash

# Docker Login
echo "Logging in to Docker Hub..."
docker login -u edwinme

# backend image
echo "Building yolo4-backend image..."
cd backend
docker build -t edwinme/yolo4-backend:latest .
docker push edwinme/yolo4-backend:latest
cd ..

# frontend image
echo "Building yolo4-frontend image..."
cd client
docker build -t edwinme/yolo4-frontend:latest .
docker push edwinme/yolo4-frontend:latest
cd ..

echo "All images have been built and pushed to Docker Hub!"
