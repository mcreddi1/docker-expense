#!/bin/bash

# Step 1: Uninstall old versions of Docker (if any)
sudo yum remove -y docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine

# Step 2: Install required packages
sudo yum install -y yum-utils

# Step 3: Set up the Docker repository
sudo yum-config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo

# Step 4: Install Docker Engine
sudo yum install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Step 5: Start Docker service
sudo systemctl start docker

# Step 6: Enable Docker to start on boot
sudo systemctl enable docker

# Step 7: Verify Docker is running
sudo systemctl status docker

# Step 8: Add your user to the Docker group (optional, so you can run Docker commands without sudo)
sudo usermod -aG docker $USER

# Step 9: Print Docker version to verify installation
docker --version

echo "Docker has been installed and started successfully."
echo "Please log out and log back in for group changes to take effect."
