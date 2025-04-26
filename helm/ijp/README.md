# Internal Job Portal Helm Chart

This Helm chart deploys the Internal Job Portal application in a Kubernetes cluster.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- PV provisioner support in the underlying infrastructure

## Kafka Configuration

This deployment uses Kafka in KRaft mode, which is now the recommended way to deploy Kafka.
KRaft mode combines the controller and broker roles in a single process.

## Installing the Chart

To install the chart with the release name `ijp`:

```bash
helm install ijp ./helm/ijp
```

## Configuration

The following table lists the configurable parameters of the Internal Job Portal chart and their default values.

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `global.timezone` | Timezone for all services | `"Asia/Kolkata"` |
| `global.domain` | Domain name for the application | `"ijp.example.com"` |
| `global.storageClass` | Storage class for PVCs | `"standard"` |
| `database.storageSize` | Storage size for PostgreSQL | `"10Gi"` |
| `kafka.replicaCount` | Number of Kafka replicas | `1` |
| `kafka.storageSize` | Storage size for Kafka | `"8Gi"` |
| `kafka.clusterId` | Cluster ID for Kafka KRaft mode | `"bad32baa5d2f41daa80318fecf86017b"` |
| `configServer.replicaCount` | Number of Config Server replicas | `1` |
| `apiGateway.replicaCount` | Number of API Gateway replicas | `1` |
| `loginService.replicaCount` | Number of Login Service replicas | `1` |
| `hrService.replicaCount` | Number of HR Service replicas | `1` |
| `jobService.replicaCount` | Number of Job Service replicas | `1` |
| `candidateService.replicaCount` | Number of Candidate Service replicas | `1` |
| `employeeService.replicaCount` | Number of Employee Service replicas | `1` |
| `frontend.replicaCount` | Number of Frontend replicas | `1` |

See `values.yaml` for full list of configurable parameters.

## Uninstalling the Chart

To uninstall/delete the `ijp` deployment:

```bash
helm delete ijp
```

## Notes

- Kafka is configured in KRaft mode
- The chart creates a StatefulSet for PostgreSQL with persistent storage
- All microservices are configured with readiness/liveness probes
- A ConfigMap and Secret are used to store environment variables
- An Ingress is created to expose the frontend and API Gateway

# Verifying Ingress in Minikube

To verify that your ingress is working properly in Minikube, follow these steps:

## 1. Check if the ingress addon is enabled

```bash
minikube addons list | grep ingress
```

If not enabled, enable it:

```bash
minikube addons enable ingress
```

## 2. Verify the ingress controller is running

```bash
kubectl get pods -n ingress-nginx
```

You should see the ingress-controller pod running:
