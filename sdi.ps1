# Changes to the "SDI" subfolder inside the "new" folder
Set-Location -Path "$PSScriptRoot\SDI"

# Defines the relative path of the executable
$executablePath = ".\SDI_x64_R2503.exe"

# Checks if the file exists and executes it with the desired parameters
if (Test-Path $executablePath) {
    Start-Process -FilePath $executablePath -ArgumentList "-nogui", "-autoinstall", "-showconsole", "-autoclose" -NoNewWindow -Wait
} else {
    Write-Error "The file '$executablePath' was not found in the directory '$PWD'."
}
