#!/bin/bash

# Check if Homebrew is installed, if not, install it
if ! command -v brew &>/dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Homebrew is already installed. Skipping..."
fi

# Update Homebrew and upgrade any already-installed formulae
brew update && brew upgrade

# Check if Docker is installed, if not, install using Homebrew
if ! command -v docker &>/dev/null; then
    echo "Installing Docker via Homebrew..."
    brew install --cask docker
else
    echo "Docker is already installed. Skipping..."
fi

# Assuming Docker Desktop will be started manually by the user because it requires manual intervention to start it the first time
echo "Please ensure Docker Desktop is running before proceeding."

# Check if Athena OS RDP Docker image is pulled, if not, pull and run
if ! docker images | grep -q "athena-os-rdp"; then
    echo "Running Athena OS RDP Docker image..."
    docker run -ti --name athena-rdp --cap-add CAP_SYS_ADMIN --cap-add IPC_LOCK --cap-add NET_ADMIN --cgroupns=host --device /dev/net/tun --shm-size 2G --sysctl net.ipv6.conf.all.disable_ipv6=0 --volume /sys/fs/cgroup:/sys/fs/cgroup --publish 23389:3389 --publish 8022:22 --restart unless-stopped docker.io/athenaos/rdp:latest

else
    echo "Athena OS RDP Docker image already exists. Skipping..."
fi
