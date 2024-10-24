#!/bin/bash

# Exit on any error
set -e

# Step 1: Install Docker
echo "Installing Docker..."
sudo yum update
sudo yum install -y docker.io

# Enable and start Docker service
sudo systemctl enable docker
sudo systemctl start docker

# Add the current user to the Docker group (for non-root Docker usage)
sudo usermod -aG docker $USER
echo "Docker installed successfully."

# Step 2: Install kubectl
echo "Installing kubectl..."
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
kubectl version --client --output=yaml
echo "kubectl installed successfully."

# Step 3: Install eksctl
echo "Installing eksctl..."
curl --silent --location "https://github.com/weaveworks/eksctl/releases/download/$(curl -s https://api.github.com/repos/weaveworks/eksctl/releases/latest | grep tag_name | cut -d '"' -f 4)/eksctl_Linux_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
eksctl version
echo "eksctl installed successfully."

# Step 4: Install AWS CLI
echo "Installing AWS CLI..."
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws --version
echo "AWS CLI installed successfully."

# Step 5: AWS Configure using CLI input
echo "Configuring AWS CLI..."
AWS_ACCESS_KEY=$1
AWS_SECRET_KEY=$2
AWS_REGION=$3

if [ -z "$AWS_ACCESS_KEY" ] || [ -z "$AWS_SECRET_KEY" ] || [ -z "$AWS_REGION" ]; then
  echo "Usage: $0 <AWS_ACCESS_KEY> <AWS_SECRET_KEY> <AWS_REGION>"
  exit 1
fi

# Pass AWS credentials via AWS CLI configuration
aws configure set aws_access_key_id "$AWS_ACCESS_KEY"
aws configure set aws_secret_access_key "$AWS_SECRET_KEY"
aws configure set region "$AWS_REGION"
aws configure set output json

echo "AWS CLI configured successfully."

# End of Script
echo "Setup Complete: Docker, kubectl, eksctl, and AWS CLI are ready to use."
