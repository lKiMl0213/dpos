# Permitir acesso de convidado não autenticado (SMB inseguro)
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" -Name RequireSecuritySignature -Value 0 -Force
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" -Name AllowInsecureGuestAuth -Value 1 -Force
Start-Sleep 3

# Reinicia o serviço de compartilhamento de rede
Restart-Service lanmanworkstation
Restart-Service lanmanserver
Start-Sleep 3

# Define variáveis iniciais
$hostname = "C3PO.local"
$networkPath = "\\$hostname\inventarios\SeuNome\"
$mesAtual = Get-Date -Format "MMMM"
$dataAtual = Get-Date -Format "dd-MM-yyyy"

# Cria as pastas se não existirem
$mesPath = Join-Path $networkPath $mesAtual
$dataPath = Join-Path $mesPath $dataAtual
if (!(Test-Path $dataPath)) {
    New-Item -ItemType Directory -Path $dataPath -Force
}

# Pergunta sobre criação de pasta para cliente específico
$clienteResposta = Read-Host "Do you want to create a folder for a specific client? (Y/N)"
if ($clienteResposta -match "^[Yy]$") {
    $clienteNome = Read-Host "Enter the client's name"
    $dataPath = Join-Path $dataPath $clienteNome
    if (!(Test-Path $dataPath)) {
        New-Item -ItemType Directory -Path $dataPath -Force
    }
}

# Nome do arquivo
Write-Host "Enter the file name (without extension)" -ForegroundColor Yellow
$nomeArquivo = Read-Host
$arquivo = Join-Path $dataPath "$nomeArquivo.txt"

# Coleta informações do sistema
$computador = "Computer:      " + (Get-CimInstance -ClassName Win32_ComputerSystem).Model
$cpu = "CPU:           " + (Get-CimInstance -ClassName Win32_Processor).Name
$cpuClock = "               " + [math]::Round((Get-CimInstance -ClassName Win32_Processor).MaxClockSpeed / 1000, 2) + " GHz"
$motherboard = "Motherboard:   " + (Get-CimInstance -ClassName Win32_BaseBoard).Manufacturer + " " + (Get-CimInstance -ClassName Win32_BaseBoard).Product
$bios = "BIOS:          " + (Get-CimInstance -ClassName Win32_BIOS).SMBIOSBIOSVersion
$chipset = "Chipset:       " + ((Get-PnpDevice | Where-Object { $_.Class -eq "System" } | Select-Object -ExpandProperty FriendlyName | Where-Object { $_ -match "Intel.*" }) -join ", ")
$memoria = Get-CimInstance -ClassName Win32_PhysicalMemory
$totalMemoria = "Memory:        " + [math]::Round(($memoria | Measure-Object -Property Capacity -Sum).Sum / 1GB, 0) + " MBytes"
$memoriaDetalhes = ($memoria | ForEach-Object { "               - " + [math]::Round($_.Capacity / 1GB, 0) + " MB " + $_.Speed + "MHz " + $_.Manufacturer + " " + $_.PartNumber }) -join "`n"
$gpu = Get-CimInstance -ClassName Win32_VideoController
$gpuDetalhes = ($gpu | ForEach-Object { "Graphics:      " + $_.Name + " [" + $_.PNPDeviceID.Split("\")[1] + "]" + "`n               " + $_.Name + ", " + [math]::Round($_.AdapterRAM / 1MB, 0) + " MB" }) -join "`n"
$discos = Get-CimInstance -ClassName Win32_DiskDrive
$discosDetalhes = ($discos | ForEach-Object { "Drive:         " + $_.Model + ", " + [math]::Round($_.Size / 1GB, 1) + " GB, " + $_.InterfaceType }) -join "`n"
$audio = Get-CimInstance -ClassName Win32_SoundDevice
$audioDetalhes = ($audio | ForEach-Object { "Sound:         " + $_.Name }) -join "`n"
$rede = "Network:       " + (Get-CimInstance -ClassName Win32_NetworkAdapter | Where-Object { $_.NetEnabled -eq $true } | Select-Object -ExpandProperty Name -First 1)
$sistema = "OS:            " + (Get-CimInstance -ClassName Win32_OperatingSystem).Caption + " (x64) Build " + (Get-CimInstance -ClassName Win32_OperatingSystem).BuildNumber

# Salva o conteúdo no arquivo
$conteudo = "$computador`n$cpu`n$cpuClock`n$motherboard`n$bios`n$chipset`n$totalMemoria`n$memoriaDetalhes`n$gpuDetalhes`n$discosDetalhes`n$audioDetalhes`n$rede`n$sistema"
$conteudo | Out-File -Encoding utf8 $arquivo

Write-Output "File saved at: $arquivo"

# Abre o caminho final no explorador de arquivos
Start-Process "explorer.exe" $dataPath