#!/bin/bash

# Remove the pods and PVCs defined in podman-play.yaml
podman play kube --down podman-play.yaml

podman pod rm -fa
podman volume prune -f
podman network rm ijp-network 2>/dev/null || true

echo "Cleanup complete! All pods have been removed."