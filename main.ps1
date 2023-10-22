# Run as Administrator

function RelaunchWithAdmin {
    # Relaunch the script with admin privileges
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$($MyInvocation.MyCommand.Path)`"" -Verb RunAs
    exit
}

# 1. Check if Chocolatey is installed, if not, download and install
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Chocolatey..."
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((Invoke-WebRequest -UseBasicParsing -Uri 'https://chocolatey.org/install.ps1').Content)
}

# 2. Check if Docker is installed, if not, install using Chocolatey
if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Docker Desktop via Chocolatey..."
    choco install docker-desktop -y
    Write-Host "Docker Desktop installed. Relaunching PowerShell with admin privileges to recognize Docker..."
    RelaunchWithAdmin
} 

# Wait for a moment to ensure Docker services have started after installation
Start-Sleep -Seconds 10

# 3. Check if Athena OS RDP Docker image is pulled, if not, pull and run
if (-not (docker images athena-os-rdp -q)) {
    Write-Host "Running Athena OS RDP Docker image..."
    docker run -ti --name athena-rdp --cap-add CAP_SYS_ADMIN --cap-add IPC_LOCK --cap-add NET_ADMIN --cgroupns=host --device /dev/net/tun --shm-size 2G --sysctl net.ipv6.conf.all.disable_ipv6=0 --volume /sys/fs/cgroup:/sys/fs/cgroup --publish 23389:3389 --publish 8022:22 --restart unless-stopped docker.io/athenaos/rdp:latest
} else {
    Write-Host "Athena OS RDP Docker image already exists. Skipping..."
}
