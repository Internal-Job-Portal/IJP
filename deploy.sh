#!/bin/bash

# Clean up any existing deployment
echo "Cleaning up existing deployment..."
podman pod rm -fa
podman volume prune -f
podman network rm ijp-network 2>/dev/null || true

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

# Alternative approach: Deploy the entire file and wait for specific pods
echo "Deploying the complete Podman Play YAML file..."
podman play kube --network ijp-network --build=false podman-play.yaml

# Wait for pods in the correct order
echo "Waiting for config-pod to be ready..."
wait_for_pod config-pod 60 2

echo "Waiting for discovery-pod to be ready..."
wait_for_pod discovery-pod 60 2

echo "Waiting for messaging-pod to be ready..."
wait_for_pod messaging-pod 30 2

# Wait for database pod
echo "Waiting for db-pod to be ready..."
wait_for_pod db-pod 30 2

# Wait for service pods
for svc in login-service-pod hr-service-pod job-service-pod candidate-service-pod employee-service-pod; do
  echo "Waiting for $svc to be ready..."
  wait_for_pod $svc 30 2
done

echo "Waiting for gateway-pod to be ready..."
wait_for_pod gateway-pod 30 2

echo "Waiting for frontend-pod to be ready..."
wait_for_pod frontend-pod 30 2

# Check final status
echo "Final deployment status:"
podman pod ps

echo "All pods deployed! Your application should now be running."
echo "Frontend is available at http://localhost:80"
echo "API Gateway is available at http://localhost:8080"
echo "Eureka Server is available at http://localhost:8761"
echo "Config Server is available at http://localhost:8888"