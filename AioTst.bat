@echo off
:: Check if the script is being run as administrator
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Requesting elevation of privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)
:: The rest of your script comes below
echo The script will always run with administrator privileges.


title AIO Tools
mode con: cols=51 lines=13
cd /d "%~dp0"

:MENU
cls
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
"Write-Host '==================================================' -ForegroundColor Yellow; ^
 Write-Host '                AIO TOOLS' -ForegroundColor Yellow; ^
 Write-Host '==================================================' -ForegroundColor Yellow; ^
 Write-Host ''; ^
 Write-Host ' 1 - Execute All' -ForegroundColor Green; ^
 Write-Host ' 2 - Update Drivers (DPS) (Testing)' -ForegroundColor Green; ^
 Write-Host ' 3 - Update Drivers (SDI) (Not Working)' -ForegroundColor Green; ^
 Write-Host ' 4 - Update Windows (WINGET)' -ForegroundColor Green; ^
 Write-Host ' 5 - Activate Windows' -ForegroundColor Green; ^
 Write-Host ' 6 - Activate Windows (Microsoft Activation Scripts)' -ForegroundColor Green; ^
 Write-Host ' 7 - Create Inventory' -ForegroundColor Green; ^
 Write-Host ' 8 - Windows Update (This option takes a long time)' -ForegroundColor Green; ^
 Write-Host ' 9 - Exit' -ForegroundColor Green; ^
 Write-Host ''"

set /p opcao=Choose an option:

if "%opcao%"=="1" goto EXECUTE_ALL
if "%opcao%"=="2" goto UPDATE_DPS
if "%opcao%"=="3" goto UPDATE_SDI
if "%opcao%"=="4" goto UPDATE_WINDOWS
if "%opcao%"=="5" goto ACTIVATE_WINDOWS
if "%opcao%"=="6" goto MASS
if "%opcao%"=="7" goto CREATE_INVENTORY
if "%opcao%"=="8" goto WINUPDT
if "%opcao%"=="9" exit

powershell -Command "Write-Host 'Invalid option! Try again...' -ForegroundColor Red"
pause
goto MENU

:EXECUTE_ALL
cls
powershell -Command "Write-Host 'Executing all tasks...' -ForegroundColor Cyan"
powershell -Command "Write-Host 'Please wait...' -ForegroundColor Red"

powershell -Command "Write-Host 'Updating Drivers (DPS)' -ForegroundColor Cyan"
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0dps.ps1"
powershell -Command "Write-Host 'Driver installation completed!' -ForegroundColor Cyan"
powershell -Command "Write-Host 'Waiting...' -ForegroundColor Red"

powershell -Command "Write-Host 'Updating Windows via WINGET...' -ForegroundColor Cyan"
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0att_win.ps1"
powershell -Command "Write-Host 'Waiting...' -ForegroundColor Red"

powershell -Command "Write-Host 'Activating Windows...' -ForegroundColor Cyan"
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0get_key.ps1"
powershell -Command "Write-Host 'Waiting...' -ForegroundColor Red"

powershell -Command "Write-Host 'Updating Windows via WINGET...' -ForegroundColor Cyan"
powershell -Command "Write-Host 'Checking for updates...' -ForegroundColor Cyan"
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0att_win.ps1"
powershell -Command "Write-Host 'Waiting...' -ForegroundColor Red"

powershell -Command "Write-Host 'Creating inventory...' -ForegroundColor Cyan"
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0inv.ps1"
powershell -Command "Write-Host 'Waiting...' -ForegroundColor Red"

powershell -Command "Write-Host 'Processes completed!' -ForegroundColor Green"
pause
goto MENU

:UPDATE_DPS

powershell -Command "Write-Host 'Updating Drivers (DPS)' -ForegroundColor Cyan"
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0dps.ps1"
powershell -Command "Write-Host 'Driver installation completed!' -ForegroundColor Green"
pause
goto MENU

:UPDATE_SDI
cls
powershell -Command "Write-Host 'Updating Drivers (SDI)' -ForegroundColor Cyan"
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0sdi.ps1"
powershell -Command "Write-Host 'Driver installation completed!' -ForegroundColor Green"
pause
goto MENU


:UPDATE_WINDOWS
cls
powershell -Command "Write-Host 'Updating Windows via WINGET...' -ForegroundColor Cyan"
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0att_win.ps1"
powershell -Command "Write-Host 'Update completed!' -ForegroundColor Green"
pause
goto MENU

:ACTIVATE_WINDOWS
cls
powershell -Command "Write-Host 'Activating Windows...' -ForegroundColor Cyan"
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0get_key.ps1"
powershell -Command "Write-Host 'Activation process completed!'"
pause
goto MENU

:MASS
cls
powershell -Command "Write-Host 'Activating Windows...' -ForegroundColor Cyan"
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0ativ_win.ps1"
powershell -Command "Write-Host 'Process completed!' -ForegroundColor Green"
pause
goto MENU

:CREATE_INVENTORY
cls
powershell -Command "Write-Host 'Creating system inventory...' -ForegroundColor Cyan"
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0inv.ps1"
pause
goto MENU

:WINUPDT
cls
powershell -Command "Write-Host 'Updating via Windows Update...' -ForegroundColor Cyan"
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0winupdt.ps1"
pause
goto MENU
