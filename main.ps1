# Run as Administrator

# 1. Check if Chocolatey is installed, if not, download and install
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Chocolatey..."
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((Invoke-WebRequest -UseBasicParsing -Uri 'https://chocolatey.org/install.ps1').Content)
} else {
    Write-Host "Chocolatey is already installed. Skipping..."
}

# 2. Check if Docker is installed, if not, install using Chocolatey
if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Docker Desktop via Chocolatey..."
    choco install docker-desktop -y
} else {
    Write-Host "Docker Desktop is already installed. Skipping..."
}

# Wait for a moment to ensure Docker services have started after installation
Start-Sleep -Seconds 10

# 3. Check if Athena OS RDP Docker image is pulled, if not, pull and run
if (-not (docker images athena-os-rdp -q)) {
    Write-Host "Pulling Athena OS RDP Docker image..."
    docker pull athena-os-rdp
    Write-Host "Running Athena OS RDP Docker image..."
    docker run -d -p 3389:3389 athena-os-rdp
} else {
    Write-Host "Athena OS RDP Docker image already exists. Skipping..."
}
