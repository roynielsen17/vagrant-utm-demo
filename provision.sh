#!/bin/bash

# Update package repository and install required packages + Including Curl utility
sudo apt-get update
sudo apt-get install -y curl

# Install Docker
sudo apt-get install -y docker.io

# Start and enable Docker service
sudo systemctl start docker
sudo systemctl enable docker

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/v2.11.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Install Makefile + File Sharing Utility (davfs2)
sudo apt-get install davfs2
sudo apt-get install -y build-essential

# Install Python3 and pip3
sudo apt-get install -y python3 python3-pip

# Verify installations
docker --version
docker-compose --version
pip3 --version  # Verify pip3 installation

# Copy over the shared directory from /media/share to /home/vagrant
echo "Copying files from /media/share to /home/vagrant/"
cp -r /media/share/* /home/vagrant/

# Navigate to the /home/vagrant directory
cd /home/vagrant/
mv env .env

# Execute the Makefile target to deploy the API service
echo "Running the Makefile to deploy API services..."
make deploy_api_service_to_vagrant