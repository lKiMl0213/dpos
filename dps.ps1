# Define the base directory (where the script is located)
$baseDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
$driverDir = Join-Path $baseDir "extracted"
$logDir = Join-Path $baseDir "log"

# Create the log folder if it doesn't exist
if (-not (Test-Path $logDir)) {
    New-Item -ItemType Directory -Path $logDir -Force | Out-Null
}

# Generate the log name without problematic characters
$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm"
$logPath = Join-Path $logDir "LOG-$timestamp.txt"

# Start of the log
"==== PROCESS START ($timestamp) ====" | Out-File -FilePath $logPath -Encoding UTF8

# Check if the drivers folder exists
if (-not (Test-Path $driverDir)) {
    Write-Host "Folder 'extracted' not found at: $driverDir" -ForegroundColor Red
    "ERROR: Folder 'extracted' not found." | Out-File -FilePath $logPath -Append
    pause
    exit
}

# Use DISM to add only compatible drivers
Write-Host "Adding compatible drivers using DISM..." -ForegroundColor Cyan
"Running DISM with folder: $driverDir" | Out-File -FilePath $logPath -Append

# Execute DISM and send the output to the log
$dismCmd = "dism /Online /Add-Driver /Driver:`"$driverDir`" /Recurse /LogPath:`"$logPath`""
$output = cmd.exe /c $dismCmd 2>&1

# Display and log the output
$output | Out-File -FilePath $logPath -Append -Encoding UTF8
Write-Host "`nDrivers added to the driver store (if compatible)." -ForegroundColor Green

# End of the log
"==== PROCESS END ($(Get-Date -Format "yyyy-MM-dd HH:mm:ss")) ====" | Out-File -FilePath $logPath -Append
