# This function checks if the Microsoft App Installer is installed and updates it if necessary.
function Update-WindowsStoreInstaller {
    Write-Host "Checking if App Installer needs to be updated..." -ForegroundColor Cyan
    $storeApp = Get-AppxPackage -Name "Microsoft.DesktopAppInstaller"

    if ($storeApp) {
        # If App Installer is already installed, attempt to update it using winget.
        Write-Host "App Installer already installed, attempting to update..." -ForegroundColor Green
        winget upgrade --id Microsoft.DesktopAppInstaller --silent --accept-source-agreements
    } else {
        # If App Installer is not found, install it using winget.
        Write-Host "App Installer not found, installing..." -ForegroundColor Yellow
        winget install --id Microsoft.DesktopAppInstaller --silent --accept-source-agreements
    }
}

# This function restarts the App Installer process and triggers a winget upgrade for all packages.
function Restart-AppInstaller {
    Write-Host "Restarting App Installer..." -ForegroundColor Yellow
    # Stop the App Installer process if it is running.
    Get-Process "Microsoft.DesktopAppInstaller" -ErrorAction SilentlyContinue | Stop-Process -Force
    Start-Sleep -Seconds 2
    # Start the winget upgrade process again.
    Start-Process "winget" -ArgumentList "upgrade --all --silent --accept-source-agreements"
}

# This function performs a system-wide package update using winget.
function Update-Winget {
    Write-Host "Starting package update with winget..." -ForegroundColor Cyan
    # Ensure the App Installer is up-to-date before proceeding.
    Update-WindowsStoreInstaller

    $maxAttempts = 3
    # Attempt the update process up to a maximum number of retries.
    for ($i = 1; $i -le $maxAttempts; $i++) {
        Write-Host "Attempt $i of $maxAttempts..." -ForegroundColor Cyan

        # Perform the package upgrade using winget.
        winget upgrade --all --silent --accept-source-agreements --force
        $exitCode = $LASTEXITCODE

        if ($exitCode -eq 0) {
            # If the update is successful, exit the function.
            Write-Host "Update completed successfully!" -ForegroundColor Green
            return
        } else {
            # If an error occurs, log the error and retry after a short delay.
            Write-Host "An error occurred (code $exitCode). Retrying..." -ForegroundColor Red
            Start-Sleep -Seconds 5
            # Restart the App Installer process on the second attempt.
            if ($i -eq 2) {
                Restart-AppInstaller
            }
        }
    }

    # If all attempts fail, notify the user to restart the system and try again.
    Write-Host "Failed after multiple attempts. Try restarting the system and trying again." -ForegroundColor Red
}

# Main execution
# Start the winget update process.
Update-Winget
