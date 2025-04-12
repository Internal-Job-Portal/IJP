#!/bin/bash
# Created by: iitzrohan
# Created on: 2025-04-10 19:37:53

# Method 1: Create a sysctl configuration file (requires sudo)
sudo bash -c 'cat > /etc/sysctl.d/99-rootless-podman.conf << EOF
# Allow unprivileged users to bind to ports from 80 and above
net.ipv4.ip_unprivileged_port_start=80
EOF'

# Apply the new configuration
sudo sysctl --system

echo "System configured to allow unprivileged port 80 binding."
echo "You can now start the applications with their original port mappings."