#!/bin/bash

# Set error handling and verbosity
set -eo pipefail
echo "Starting cleanup process at $(date)"

# Define colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Function to display status messages
function log_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

function log_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

function log_error() {
    echo -e "${RED}✗ $1${NC}" >&2
}

# Function to safely execute commands
function safe_execute() {
    if eval "$1"; then
        log_success "$2"
    else
        log_warning "$3"
    fi
}

# Check if kubectl and helm are installed
if ! command -v kubectl &> /dev/null; then
    log_error "kubectl is not installed. Please install kubectl first."
    exit 1
fi

if ! command -v helm &> /dev/null; then
    log_error "helm is not installed. Please install helm first."
    exit 1
fi

# Uninstall IJP Helm chart
echo "Uninstalling IJP Helm chart..."
safe_execute "helm uninstall ijp 2>/dev/null" \
    "IJP chart uninstalled" \
    "IJP chart not found or already uninstalled"

# Uninstall Traefik Helm chart
echo "Uninstalling Traefik Helm chart..."
safe_execute "helm uninstall traefik 2>/dev/null" \
    "Traefik chart uninstalled" \
    "Traefik chart not found or already uninstalled"

# Remove Strimzi resources from the Kafka namespace
echo "Removing Strimzi resources from Kafka namespace..."
safe_execute "kubectl delete -f 'https://strimzi.io/install/latest?namespace=kafka' -n kafka --ignore-not-found=true" \
    "Strimzi resources removed" \
    "Failed to remove some Strimzi resources"

# Delete Kafka namespace
echo "Deleting Kafka namespace..."
safe_execute "kubectl delete namespace kafka --ignore-not-found=true" \
    "Kafka namespace deleted" \
    "Kafka namespace not found or could not be deleted"

# Remove Traefik CRDs
echo "Removing Traefik CRDs..."
safe_execute "kubectl delete -k https://github.com/traefik/traefik-helm-chart/traefik/crds/ --ignore-not-found=true" \
    "Traefik CRDs removed" \
    "Failed to remove some Traefik CRDs"

# Remove Helm repositories
echo "Removing Helm repositories..."
safe_execute "helm repo remove traefik 2>/dev/null" \
    "Traefik repository removed" \
    "Traefik repository not found or already removed"

safe_execute "helm repo remove strimzi 2>/dev/null" \
    "Strimzi repository removed" \
    "Strimzi repository not found or already removed"

log_success "Cleanup completed successfully at $(date)"