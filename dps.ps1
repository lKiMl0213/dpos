# Define o diretório base (onde o script está)
$baseDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
$driverDir = Join-Path $baseDir "extracted"
$logDir = Join-Path $baseDir "log"

# Cria a pasta de log se não existir
if (-not (Test-Path $logDir)) {
    New-Item -ItemType Directory -Path $logDir -Force | Out-Null
}

# Gera o nome do log sem caracteres problemáticos
$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm"
$logPath = Join-Path $logDir "LOG-$timestamp.txt"

# Início do log
"==== PROCESS START ($timestamp) ====" | Out-File -FilePath $logPath -Encoding UTF8

# Verifica se a pasta de drivers existe
if (-not (Test-Path $driverDir)) {
    Write-Host "Pasta 'extracted' não encontrada em: $driverDir" -ForegroundColor Red
    "ERRO: Pasta 'extracted' não encontrada." | Out-File -FilePath $logPath -Append
    pause
    exit
}

# Usa DISM para adicionar apenas drivers compatíveis
Write-Host "Adicionando drivers compatíveis usando DISM..." -ForegroundColor Cyan
"Executando DISM com a pasta: $driverDir" | Out-File -FilePath $logPath -Append

# Executa o DISM e envia a saída pro log
$dismCmd = "dism /Online /Add-Driver /Driver:`"$driverDir`" /Recurse /LogPath:`"$logPath`""
$output = cmd.exe /c $dismCmd 2>&1

# Exibe e registra a saída
$output | Out-File -FilePath $logPath -Append -Encoding UTF8
Write-Host "`nDrivers adicionados à driver store (se compatíveis)." -ForegroundColor Green

# Fim do log
"==== PROCESS END ($(Get-Date -Format "yyyy-MM-dd HH:mm:ss")) ====" | Out-File -FilePath $logPath -Append
