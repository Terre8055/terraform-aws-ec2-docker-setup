#!/bin/bash

# Update the package list
sudo yum update -y

# Install Docker dependencies
sudo yum install -y docker git

# Start and enable the Docker service
sudo service docker start
sudo usermod -aG docker $(whoami)
sudo chkconfig docker on

# Add the user to the docker group and start a new shell
sudo usermod -aG docker $(whoami)
newgrp docker

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Print Docker and Docker Compose versions
docker --version
docker-compose --version

echo "Docker installation complete."

echo "Running docker container"
docker run -d --name adongy -p 3000:3000 adongy/hostname-docker
