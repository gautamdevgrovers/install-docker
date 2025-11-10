#!/bin/bash
set -e

echo "=== Updating system packages ==="
sudo apt-get update -y
sudo apt-get upgrade -y

echo "=== Removing old Docker versions (if any) ==="
sudo apt-get remove -y docker docker-engine docker.io containerd runc || true

echo "=== Installing required dependencies ==="
sudo apt-get install -y ca-certificates curl gnupg lsb-release

echo "=== Adding Docker’s official GPG key ==="
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo "=== Setting up Docker repository ==="
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "=== Installing Docker Engine, CLI, Containerd, and Compose Plugin ==="
sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "=== Enabling and starting Docker service ==="
sudo systemctl enable docker
sudo systemctl start docker

echo "=== Adding current user to docker group ==="
sudo usermod -aG docker $USER

echo "=== Docker installation complete! ==="
docker --version
docker compose version

echo
echo "⚠️  Please log out and log back in (or run 'newgrp docker') to use Docker without sudo."
