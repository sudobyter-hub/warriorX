#!/bin/bash

# Detect the Linux distribution
OS=$(awk -F= '/^NAME/{print $2}' /etc/os-release)

# Installation steps based on detected distribution
case $OS in
    "Fedora")
        echo "Detected Fedora..."
        
        # Install Docker on Fedora
        sudo dnf -y install dnf-plugins-core
        sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
        sudo dnf -y install docker-ce docker-ce-cli containerd.io
        sudo systemctl start docker
        ;;

    "Debian GNU/Linux")
        echo "Detected Debian..."
        
        # Install Docker on Debian
        sudo apt update
        sudo apt install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -y
        curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
        sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
        sudo apt update
        sudo apt install docker-ce docker-ce-cli containerd.io -y
        ;;

    "Arch Linux")
        echo "Detected Arch Linux..."
        
        # Install Docker on Arch Linux
        sudo pacman -Syu
        sudo pacman -S docker
        sudo systemctl start docker.service
        ;;

    "Gentoo")
        echo "Detected Gentoo..."
        
        # Install Docker on Gentoo
        sudo emerge --ask app-emulation/docker
        sudo rc-update add docker default
        sudo service docker start
        ;;

    *)
        echo "This Linux distribution is not supported by this script."
        exit 1
        ;;
esac

# Check if Athena OS RDP Docker image is pulled, if not, pull and run
if ! docker images | grep -q "athena-os-rdp"; then
    echo "Running Athena OS RDP Docker image..."
    docker run -ti --name athena-rdp --cap-add CAP_SYS_ADMIN --cap-add IPC_LOCK --cap-add NET_ADMIN --cgroupns=host --device /dev/net/tun --shm-size 2G --sysctl net.ipv6.conf.all.disable_ipv6=0 --volume /sys/fs/cgroup:/sys/fs/cgroup --publish 23389:3389 --publish 8022:22 --restart unless-stopped docker.io/athenaos/rdp:latest
else
    echo "Athena OS RDP Docker image already exists. Skipping..."
fi
