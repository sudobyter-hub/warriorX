# Run as Administrator

# 1. Download and install Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((Invoke-WebRequest -UseBasicParsing -Uri 'https://chocolatey.org/install.ps1').Content)

# 2. Install Docker using Chocolatey
choco install docker-desktop -y

# 3. Once Docker is installed, pull and run the Athena OS RDP Docker image (assuming the image name is 'athena-os-rdp')
docker pull athena-os-rdp
docker run -d -p 3389:3389 athena-os-rdp
