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

The `docker-compose.yml` file is included for containerized deployment of the entire system.

## Cloning the Repository

To clone this repository with all its submodules, use the following command:

```bash
git clone https://github.com/internal-job-portal/ijp.git
```

## Getting Started

After cloning, run the following commands:

For Docker:

```bash
docker compose up
```

For Podman:

Set DB Configuration in .env file

```bash
podman network create ijp-network
podman play kube --network ijp-network --build=false podman-play.yaml
```

These commands will build all the services and then start up the entire system.
