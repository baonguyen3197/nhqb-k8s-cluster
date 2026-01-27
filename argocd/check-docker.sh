#!/bin/bash

# ============================== #
# Check Docker
# ============================== #
echo "Fixing Docker permissions..."
sudo usermod -aG docker $USER
sudo chmod 666 /var/run/docker.sock
echo "Docker permissions fixed. Testing docker..."
docker info >/dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "Docker is running and accessible."
else
    echo "Docker is not running or not accessible. Please check your Docker installation."
    exit 1
fi
echo "Docker check completed."