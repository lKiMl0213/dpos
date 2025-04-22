# Function to try updating the App Installer (Microsoft Store) if necessary
function Update-WindowsStoreInstaller {
    Write-Host "Checking if the App Installer needs to be updated..." -ForegroundColor Cyan
    $storeApp = Get-AppxPackage -Name "Microsoft.DesktopAppInstaller"

    if ($storeApp) {
        Write-Host "App Installer already installed, attempting to force update..." -ForegroundColor Green
        winget upgrade --id Microsoft.DesktopAppInstaller --silent --accept-source-agreements
    } else {
        Write-Host "App Installer not found, installing..." -ForegroundColor Yellow
        winget install --id Microsoft.DesktopAppInstaller --silent --accept-source-agreements
    }
}

# Function to check and restart the App Installer
function Restart-AppInstaller {
    Write-Host "Restarting the App Installer..." -ForegroundColor Yellow

    # Terminates the App Installer process if it is running
    Get-Process "Microsoft.DesktopAppInstaller" -ErrorAction SilentlyContinue | Stop-Process -Force

    # Waits for a while to ensure the process has been terminated
    Start-Sleep -Seconds 2

    # Attempts to run the App Installer again if it was closed
    Start-Process "winget" -ArgumentList "upgrade --all --silent --accept-source-agreements --force"
}

# Function to perform updates via winget with better error handling and wait time
function Update-Winget {
    Write-Host "Starting update of all packages with winget..." -ForegroundColor Cyan

    # Updates the App Installer (if necessary)
    Update-WindowsStoreInstaller

    # Attempt to update with winget
    $attempts = 0
    $maxAttempts = 3
    $success = $false

    while ($attempts -lt $maxAttempts -and !$success) {
        try {
            Write-Host "Attempting to update all packages with winget... (Attempt $($attempts + 1) of $maxAttempts)" -ForegroundColor Cyan
            $output = winget upgrade --all --silent --accept-source-agreements --force
            Write-Host "Update completed successfully!" -ForegroundColor Green
            $success = $true
        } catch {
            Write-Host "Error during the update. Retrying..." -ForegroundColor Red
            $attempts++
            Start-Sleep -Seconds 5
        }
    }

    if (!$success) {
        Write-Host "Failed to update after multiple attempts. Please try again later." -ForegroundColor Red
    }
}

# Function to check the status of winget and restart the App Installer if necessary
function Update-WingetWithRestart {
    Write-Host "Starting update with winget..." -ForegroundColor Cyan

    $attempts = 0
    $maxAttempts = 3
    $success = $false

    while ($attempts -lt $maxAttempts -and !$success) {
        try {
            Write-Host "Attempting to update packages (Attempt $($attempts + 1) of $maxAttempts)..." -ForegroundColor Cyan
            $output = winget upgrade --all --silent --accept-source-agreements --force

            # Checks if winget completed successfully
            if ($output -match "Everything is up to date") {
                Write-Host "Update completed successfully!" -ForegroundColor Green
                $success = $true
            } else {
                Write-Host "App Installer did not complete the installation correctly. Restarting..." -ForegroundColor Yellow
                Restart-AppInstaller
            }
        } catch {
            Write-Host "Error while trying to update packages. Retrying..." -ForegroundColor Red
            $attempts++
            Start-Sleep -Seconds 5
        }
    }

    if (!$success) {
        Write-Host "Failed to update after multiple attempts. Please try again later." -ForegroundColor Red
    }
}

# Function to monitor progress and restart when necessary
function Monitor-Installation {
    Write-Host "Monitoring package installation, please wait..." -ForegroundColor Cyan

    # Starts the update process
    Update-Winget

    # If LibreOffice or other programs require a restart, you can add logic here
    Write-Host "If the installation of any package was not completed, restart the system and try again." -ForegroundColor Yellow
}

# Calls the function to start the update
Monitor-Installation
