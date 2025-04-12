#!/bin/bash
# Created by: iitzrohan
# Created on: 2025-04-10 18:55:49

# Build all service images
echo "Building Config Server..."
cd ./config-server && podman build -t localhost/config-server:latest . && cd ..

echo "Building Eureka Server..."
cd ./eureka-server && podman build -t localhost/eureka-server:latest . && cd ..

echo "Building API Gateway..."
cd ./api-gateway && podman build -t localhost/api-gateway:latest . && cd ..

echo "Building Login Service..."
cd ./login-service && podman build -t localhost/login-service:latest . && cd ..

echo "Building HR Service..."
cd ./hr-service && podman build -t localhost/hr-service:latest . && cd ..

echo "Building Job Service..."
cd ./job-service && podman build -t localhost/job-service:latest . && cd ..

echo "Building Candidate Service..."
cd ./candidate-service && podman build -t localhost/candidate-service:latest . && cd ..

echo "Building Employee Service..."
cd ./employee-service && podman build -t localhost/employee-service:latest . && cd ..

echo "Building Frontend..."
cd ./frontend && podman build -t localhost/frontend:latest . && cd ..

echo "All images built successfully!"