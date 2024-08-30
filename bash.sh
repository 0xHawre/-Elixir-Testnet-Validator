#!/bin/bash

# Function to check if Docker is installed and install it if not
check_and_install_docker() {
    if ! command -v docker &> /dev/null; then
        echo "Docker is not installed. Installing Docker..."
        
        # Update package list and install prerequisites
        sudo apt-get update
        sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

        # Add Docker's official GPG key
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

        # Add Docker's stable repository
        sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

        # Update package list and install Docker
        sudo apt-get update
        sudo apt-get install -y docker-ce

        echo "Docker has been installed."
    else
        echo "Docker is already installed."
    fi
}

# Call the function to check and install Docker
check_and_install_docker

# Prompt the user for input
read -p "Enter STRATEGY_EXECUTOR_IP_ADDRESS: " ip_address
read -p "Enter STRATEGY_EXECUTOR_DISPLAY_NAME: " validator_name
read -p "Enter STRATEGY_EXECUTOR_BENEFICIARY: " safe_public_address
read -p "Enter SIGNER_PRIVATE_KEY: " private_key

# Replace placeholders in the environment variables and save to validator.env
cat <<EOF > validator.env
ENV=testnet-3
STRATEGY_EXECUTOR_IP_ADDRESS=${ip_address}
STRATEGY_EXECUTOR_DISPLAY_NAME=${validator_name}
STRATEGY_EXECUTOR_BENEFICIARY=${safe_public_address}
SIGNER_PRIVATE_KEY=${private_key}
EOF

echo "Environment variables have been set and saved to validator.env file."


# Pull the Docker image
docker pull elixirprotocol/validator:v3

# Run the Docker container with the environment file
docker run -it \
  --env-file validator.env \
  --name elixir \
  elixirprotocol/validator:v3


