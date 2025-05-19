#!/bin/bash
set -e

echo "Deploying MongoDB resources..."
kubectl apply -f mongodb-secret.yaml
kubectl apply -f mongodb-configmap.yaml
kubectl apply -f mongodb-statefulset.yaml

echo "Waiting for MongoDB to be ready..."
kubectl wait --for=condition=ready pod/mongodb-0 --timeout=300s

echo "Deploying application resources..."
kubectl apply -f yolo4-deployment.yaml
kubectl apply -f yolo4-service.yaml

echo "Deployment complete!"
echo "Frontend will be available at: http://<load-balancer-ip>"
echo "You can get the load balancer IP with: kubectl get svc yolo4-frontend-service"
