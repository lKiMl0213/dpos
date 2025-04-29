$hostname = "HOSTNAME" # Replace with the actual hostname
$networkPath = "\\$hostname\" # Replace with the actual network path or the location you want to save the file
$mesAtual = Get-Date -Format "MMMM"  # Month name in full
$dataAtual = Get-Date -Format "dd-MM-yyyy"  # Date in the desired format

# Create folders if they don't exist
$mesPath = Join-Path $networkPath $mesAtual
$dataPath = Join-Path $mesPath $dataAtual
if (!(Test-Path $dataPath)) {
    New-Item -ItemType Directory -Path $dataPath -Force
}

# Ask if a folder for a specific client should be created
$clienteResposta = Read-Host "Do you want to create a folder for a specific client? (Y/N)"
if ($clienteResposta -match "^[Yy]$") {
    $clienteNome = Read-Host "Enter the client's name"
    $dataPath = Join-Path $dataPath $clienteNome
    if (!(Test-Path $dataPath)) {
        New-Item -ItemType Directory -Path $dataPath -Force
    }
}

# Prompt for the file name
Write-Host "Enter the file name (without extension)" -ForegroundColor Yellow
$nomeArquivo = Read-Host
$arquivo = Join-Path $dataPath "$nomeArquivo.txt"

# Get system information
$computador = "Computer:      " + (Get-CimInstance -ClassName Win32_ComputerSystem).Model
$cpu = "CPU:           " + (Get-CimInstance -ClassName Win32_Processor).Name
$cpuClock = "               " + [math]::Round((Get-CimInstance -ClassName Win32_Processor).MaxClockSpeed / 1000, 2) + " GHz"
$motherboard = "Motherboard:   " + (Get-CimInstance -ClassName Win32_BaseBoard).Manufacturer + " " + (Get-CimInstance -ClassName Win32_BaseBoard).Product
$chipset = "Chipset:       " + ((Get-PnpDevice | Where-Object {$_.Class -eq "System"} | Select-Object -ExpandProperty FriendlyName) -match "Intel.*")
$memoria = Get-CimInstance -ClassName Win32_PhysicalMemory
$totalMemoria = "Memory:        " + [math]::Round(($memoria | Measure-Object -Property Capacity -Sum).Sum / 1GB, 0) + " MBytes"
$memoriaDetalhes = ($memoria | ForEach-Object { "               - " + [math]::Round($_.Capacity / 1GB, 0) + " MB " + $_.Speed + "MHz " + $_.Manufacturer + " " + $_.PartNumber }) -join "`n"
$gpu = Get-CimInstance -ClassName Win32_VideoController
$gpuDetalhes = ($gpu | ForEach-Object { "Graphics:      " + $_.Name + " [" + $_.PNPDeviceID.Split("\")[1] + "]" + "`n               " + $_.Name + ", " + [math]::Round($_.AdapterRAM / 1MB, 0) + " MB" }) -join "`n"
$discos = Get-CimInstance -ClassName Win32_DiskDrive
$discosDetalhes = ($discos | ForEach-Object { "Drive:         " + $_.Model + ", " + [math]::Round($_.Size / 1GB, 1) + " GB, " + $_.InterfaceType }) -join "`n"
$audio = Get-CimInstance -ClassName Win32_SoundDevice
$audioDetalhes = ($audio | ForEach-Object { "Sound:         " + $_.Name }) -join "`n"
$rede = "Network:       " + (Get-CimInstance -ClassName Win32_NetworkAdapter | Where-Object { $_.NetEnabled -eq $true } | Select-Object -ExpandProperty Name)
$sistema = "OS:            " + (Get-CimInstance -ClassName Win32_OperatingSystem).Caption + " (x64) Build " + (Get-CimInstance -ClassName Win32_OperatingSystem).BuildNumber

# Create and save the file
$conteudo = "$computador`n$cpu`n$cpuClock`n$motherboard`n$bios`n$chipset`n$totalMemoria`n$memoriaDetalhes`n$gpuDetalhes`n$discosDetalhes`n$audioDetalhes`n$rede`n$sistema"
$conteudo | Out-File -Encoding utf8 $arquivo

Write-Output "File saved at: $arquivo"
# Open the month's folder on the network after execution
Start-Process "explorer.exe" $dataPath