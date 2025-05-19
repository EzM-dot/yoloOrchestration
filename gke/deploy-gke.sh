#!/bin/bash
set -e

# Configuration
PROJECT_ID="your-project-id"  # Replace with your GCP project ID
CLUSTER_NAME="yolo4-cluster"
REGION="us-central1"           # Or your preferred region
ZONE="${REGION}-a"
NODE_COUNT=3
MACHINE_TYPE="e2-standard-2"

# Authenticate with GCP
echo "🔑 Authenticating with GCP..."
gcloud auth login

echo "🚀 Setting up GKE cluster..."

# Enable required APIs
echo "📡 Enabling required GCP APIs..."
gcloud services enable container.googleapis.com

# Create GKE cluster
echo "🔄 Creating GKE cluster (this may take a few minutes)..."
gcloud container clusters create $CLUSTER_NAME \
  --project=$PROJECT_ID \
  --zone=$ZONE \
  --machine-type=$MACHINE_TYPE \
  --num-nodes=$NODE_COUNT \
  --enable-autoscaling \
  --min-nodes=1 \
  --max-nodes=5 \
  --enable-ip-alias \
  --create-subnetwork=name=my-subnet-1,range=10.0.0.0/16 \
  --enable-autoupgrade \
  --enable-autorepair

# Get cluster credentials
echo "🔑 Getting cluster credentials..."
gcloud container clusters get-credentials $CLUSTER_NAME --zone $ZONE --project $PROJECT_ID

# Create a namespace for the application
echo "🏷️ Creating namespace..."
kubectl create namespace yolo4 --dry-run=client -o yaml | kubectl apply -f -

# Create storage class for MongoDB
echo "💾 Creating storage class..."
cat <<EOF | kubectl apply -f -
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: standard
provisioner: kubernetes.io/gce-pd
parameters:
  type: pd-standard
  replication-type: none
volumeBindingMode: WaitForFirstConsumer
EOF

# Deploy MongoDB StatefulSet
echo "🔄 Deploying MongoDB StatefulSet..."
kubectl apply -f ../kubernetes/mongodb-secret.yaml -n yolo4
kubectl apply -f ../kubernetes/mongodb-configmap.yaml -n yolo4
kubectl apply -f mongodb-statefulset-gke.yaml -n yolo4

# Wait for MongoDB to be ready
echo "⏳ Waiting for MongoDB to be ready..."
kubectl wait --for=condition=ready pod/mongodb-0 --timeout=300s -n yolo4

# Initialize MongoDB replica set
echo "🔄 Initializing MongoDB replica set..."
kubectl exec -it mongodb-0 -n yolo4 -- mongosh --eval "rs.initiate()"

# Deploy MongoDB backup CronJob
echo "💾 Deploying MongoDB backup CronJob..."
kubectl apply -f mongodb-backup-cronjob.yaml -n yolo4

# Deploy the application
echo "🚀 Deploying application..."
kubectl apply -f ../kubernetes/yolo4-deployment.yaml -n yolo4
kubectl apply -f ../kubernetes/yolo4-service.yaml -n yolo4

# Get the external IP for the frontend
echo "🔄 Getting external IP for the frontend..."
kubectl get svc yolo4-frontend-service -n yolo4 -w

echo "✅ Deployment complete!"
echo "🌐 Access your application at: http://<EXTERNAL_IP>"
echo "🔍 Run 'kubectl get svc -n yolo4' to check the status of your services"
