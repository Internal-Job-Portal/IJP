# IJP Microservices Project

This repository contains the Internal Job Portal (IJP) Microservices project, a comprehensive system built using a microservices architecture.

## Project Structure

The project consists of the following components:

- `config`: Configuration files
- `config-server`: Centralized configuration server
- `api-gateway`: API Gateway service
- `login-service`: Service for authentication and authorization
- `hr-service`: Human Resources service
- `job-service`: Job posting and management service
- `employee-service`: Service for employee-related operations
- `candidate-service`: Service for managing candidate-related operations
- `frontend`: User interface for the application

## Cloning the Repository

To clone this repository with all its submodules, use the following command:

```bash
git clone https://github.com/internal-job-portal/ijp.git
cd ijp
```

## Deployment Options

### Prerequisites

- Docker and Docker Compose (for Docker deployment)
- kubectl, Minikube/Kubernetes cluster (for Kubernetes deployment)
- Helm (for Helm deployment)

### Host Configuration

For local deployments, add the following entries to your hosts file:

- For Docker and standard Kubernetes: 
  ```
  127.0.0.1 ijp.example.com
  ```

- For Minikube:
  ```
  $(minikube ip) ijp.example.com
  ```

On Linux/macOS, edit `/etc/hosts`. On Windows, edit `C:\Windows\System32\drivers\etc\hosts`.

### Docker Deployment

Deploy the entire stack using Docker Compose:

```bash
# Build and start all services
docker compose up -d

# To rebuild services
docker compose up -d --build

# To stop all services
docker compose down
```

Access the application at http://ijp.example.com

### Kubernetes Deployment

#### Using Minikube:

```bash
# Start Minikube
minikube start

# Enable ingress controller if needed
minikube addons enable ingress

# Install helm chart
helm install ijp helm/ijp

# Get the Minikube IP and update your hosts file
echo "$(minikube ip) ijp.example.com" | sudo tee -a /etc/hosts
```

Access the application at http://ijp.example.com

### Helm Deployment

```bash
# Deploy with Helm
helm install ijp helm/ijp

# Upgrade an existing deployment
helm upgrade ijp helm/ijp

# Uninstall
helm uninstall ijp
```

## Monitoring and Logging

Once deployed, you can monitor the services:

```bash
# For Docker
docker compose logs -f

# For Kubernetes
kubectl get pods
kubectl logs -f [pod-name]
```

## Troubleshooting

If you encounter issues:

1. Verify host entries are correctly set
2. Ensure all required ports are available
3. Check service logs for specific errors
4. For Kubernetes deployments, verify all pods are running with `kubectl get pods`
