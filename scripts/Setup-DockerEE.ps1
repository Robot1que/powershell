# Rename computer
Rename-Computer -NewName docker-host
Restart-Computer

# Allow incoming ICMPv4 requests (on VM)
Get-NetFirewallRule vm-monitoring-icmpv4 | Enable-NetFirewallRule

# Enable Windows Containers
Install-WindowsFeature Containers
Restart-Computer

# Install Docker EE
Install-Module DockerMsftProvider -Force
Install-Package Docker -ProviderName DockerMsftProvider -Force

# Expose unsecure docker API
'{
  "hosts": [
    "tcp://0.0.0.0:2375",
    "npipe://"
  ],
  "api-cors-header": "*"
}' | Out-File $env:ProgramData\docker\config\daemon.json -Encoding ascii
Restart-Service docker

# Add firewall rule
New-NetFirewallRule -DisplayName "Docker API" -Name "docker-api" -Direction Inbound -LocalPort 2375, 2376 -Protocol TCP -Action Allow

# Verify docker API works
Invoke-RestMethod -Method GET -Uri http://localhost:2375/images/json