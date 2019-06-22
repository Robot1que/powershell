# Enable PS remoting
Enable-PSRemoting -Force
Set-Item WSMAN:\localhost\client\TustedHosts *
Restart-Service WinRM

# Increase maximum allowed memory usage by PowerShell remote process
Set-Item WSMan:\localhost\Shell\MaxMemoryPerShellMB 8192
Set-Item WSMan:\localhost\Plugin\microsoft.powershell\Quotas\MaxMemoryPerShellMB 8192
Restart-Service WinRM