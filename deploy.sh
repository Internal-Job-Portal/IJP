#!/bin/bash

# Set error handling and verbosity
set -eo pipefail
echo "Starting deployment process at $(date)"

# Define colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to display status messages
function log_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

function log_error() {
    echo -e "${RED}✗ $1${NC}" >&2
}

# Check if kubectl is installed
if ! command -v kubectl &> /dev/null; then
    log_error "kubectl is not installed. Please install kubectl first."
    exit 1
fi

# Check if helm is installed
if ! command -v helm &> /dev/null; then
    log_error "helm is not installed. Please install helm first."
    exit 1
fi

# Add Helm repositories
echo "Adding Helm repositories..."
helm repo add traefik https://traefik.github.io/charts && log_success "Added Traefik repository" || log_error "Failed to add Traefik repository"
helm repo add strimzi https://strimzi.io/charts/ && log_success "Added Strimzi repository" || log_error "Failed to add Strimzi repository"

# Update Helm repositories
echo "Updating Helm repositories..."
helm repo update && log_success "Updated Helm repositories" || log_error "Failed to update Helm repositories"

# Apply Traefik CRDs
echo "Applying Traefik CRDs..."
kubectl apply --server-side --force-conflicts -k https://github.com/traefik/traefik-helm-chart/traefik/crds/ && log_success "Applied Traefik CRDs" || log_error "Failed to apply Traefik CRDs"

# Create Kafka namespace if it doesn't exist
echo "Creating Kafka namespace..."
kubectl get namespace kafka &> /dev/null || kubectl create namespace kafka
log_success "Kafka namespace is ready"

# Install Strimzi operator
echo "Installing Strimzi operator in Kafka namespace..."
kubectl create -f 'https://strimzi.io/install/latest?namespace=kafka' -n kafka && log_success "Installed Strimzi operator" || log_error "Failed to install Strimzi operator"

# Check if helm directories exist
if [ ! -d "./helm/traefik" ]; then
    log_error "Directory ./helm/traefik not found"
    exit 1
fi

if [ ! -d "./helm/ijp" ]; then
    log_error "Directory ./helm/ijp not found"
    exit 1
fi

# Install Traefik chart
echo "Installing Traefik Helm chart..."
helm install traefik ./helm/traefik --wait --timeout 5m && log_success "Installed Traefik Helm chart" || log_error "Failed to install Traefik Helm chart"

# Install IJP chart
echo "Installing IJP Helm chart..."
helm install ijp ./helm/ijp --wait --timeout 5m && log_success "Installed IJP Helm chart" || log_error "Failed to install IJP Helm chart"

# Verify deployments
echo "Verifying deployments..."
kubectl get pods -l "app.kubernetes.io/name=traefik"
kubectl get pods -n kafka

log_success "Deployment completed successfully at $(date)"