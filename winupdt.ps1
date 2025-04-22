# Set temporary execution policy to avoid restrictions
Set-ExecutionPolicy RemoteSigned -Scope Process -Force

# Ensure NuGet is installed to manage packages
Install-PackageProvider -Name NuGet -Force

# Install and import the PSWindowsUpdate module
if (!(Get-Module -ListAvailable -Name PSWindowsUpdate)) {
    Write-Host "Installing the PSWindowsUpdate module..." -ForegroundColor Yellow
    Install-Module -Name PSWindowsUpdate -Force
}
Import-Module PSWindowsUpdate -Force -Verbose

# List available updates
Write-Host "Searching for available updates..." -ForegroundColor Cyan
Get-WindowsUpdate

# Install all available updates
Write-Host "Installing updates..." -ForegroundColor Green
Install-WindowsUpdate -AcceptAll -AutoReboot