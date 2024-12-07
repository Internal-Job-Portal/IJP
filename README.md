# IJP Microservices Project

This repository contains the Internal Job Portal (IJP) Microservices project, a comprehensive system built using a microservices architecture.

## Project Structure

The project consists of the following components:

- `config`: Configuration files
- `config-server`: Centralized configuration server
- `eureka-server`: Service discovery server
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
git clone --recursive https://github.com/Internal-Job-Portal/IJP.git
```

The `--recursive` flag ensures that all submodules are also cloned along with the main repository.

## After Cloning

If you've already cloned the repository without the `--recursive` flag, you can initialize and update the submodules with these commands:

```bash
git submodule init
git submodule update
```

## Getting Started

After cloning, run the following commands:

```bash
docker compose build
docker compose up
```

These commands will build the Docker images for your services and then start up the entire system.
