#!/bin/bash

# Clean up any existing deployment
echo "Cleaning up existing deployment..."
podman pod rm -fa
podman volume prune -f
podman network rm ijp-network 2>/dev/null || true

# Check if the .env file exists
if [ ! -f .env ]; then
    echo "Error: .env file not found!"
    exit 1
fi

# Load environment variables from .env file
set -a # automatically export all variables
source .env
set +a

# Create a fresh network
podman network create ijp-network

# Function to wait for a pod to be running
function wait_for_pod() {
  local pod_name=$1
  local max_retries=${2:-30}
  local retry_wait=${3:-2}
  
  for ((i=1; i<=max_retries; i++)); do
    if podman pod exists $pod_name 2>/dev/null; then
      local status=$(podman pod inspect $pod_name --format '{{.State}}' 2>/dev/null || echo "unknown")
      if [ "$status" == "Running" ] || [ "$status" == "Degraded" ]; then
        echo "$pod_name is running (status: $status)"
        return 0
      fi
    fi
    echo "Waiting for $pod_name to be running ($i/$max_retries)..."
    sleep $retry_wait
  done
  
  echo "WARNING: $pod_name failed to start properly"
  return 1
}

# Create a temporary file for the processed YAML
TEMP_YAML=$(mktemp)

# Process the YAML file, replacing environment variables
envsubst < podman-play.yaml > "$TEMP_YAML"

# Run podman play kube with the processed file
echo "Deploying the complete Podman Play YAML file..."
podman play kube --network ijp-network --build=false "$TEMP_YAML"

# Clean up the temporary file
rm "$TEMP_YAML"

# Wait for pods in the correct order
echo "Waiting for config-server-pod to be ready..."
wait_for_pod config-server 60 2

echo "Waiting for kafka to be ready..."
wait_for_pod kafka 30 2

echo "Waiting for zookeeper to be ready..."
wait_for_pod zookeeper 30 2

# Wait for service pods
for svc in login-service hr-service job-service candidate-service employee-service; do
  echo "Waiting for $svc to be ready..."
  wait_for_pod $svc 30 2
done

echo "Waiting for api-gateway to be ready..."
wait_for_pod api-gateway 30 2

echo "Waiting for frontend to be ready..."
wait_for_pod frontend 30 2

# Check final status
echo "Final deployment status:"
podman pod ps

echo "All pods deployed! Your application should now be running."
echo "Frontend is available at http://localhost:80"
echo "API Gateway is available at http://localhost:8080"
echo "Config Server is available at http://localhost:8888"