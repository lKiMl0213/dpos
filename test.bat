@echo off
:: Checks if the script is being run as administrator
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Requesting elevation of privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)
:: The rest of your script comes below
echo The script will always run with administrator privileges.


:EXECUTE_ALL
cls
powershell -Command "Write-Host 'Executing all tasks...' -ForegroundColor Cyan"
powershell -Command "Write-Host 'Please wait...' -ForegroundColor Red"

:: Runs the scripts in parallel in separate windows
echo Starting processes in parallel...
start "Updating Drivers (DPS)" powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0dps.ps1"
start "Updating Windows via WINGET" powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0att_win.ps1"
start "Activating Windows" powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0get_key.ps1"
start "Creating inventory" powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0inv.ps1"

powershell -Command "Write-Host 'All processes have been started in parallel!' -ForegroundColor Green"
pause