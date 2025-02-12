$logo = @"
M   M  III  K   K  CCCC  PPPP  U   U
MM MM   I   K  K  C      P   P U   U
M M M   I   K K   C      PPPP  U   U
M   M   I   KK    C      P     U   U
M   M  III  K  K  CCCC  P      UUUU
"@

Write-Host $logo -ForegroundColor Red

    Write-Host "Presents..." -ForegroundColor Blue
    Write-Host "Presenta..." -ForegroundColor Blu   
# Banner ASCII
$logo = @"
  __  __   _   __  _____ __  __ _   _ ___ ___   _ _____ 
 |  \/  | /_\  \ \/ /_ _|  \/  | | | / __| _ ) /_\_   _|
 | |\/| |/ _ \  >  < | || |\/| | |_| \__ \ _ \/ _ \| |
 |_|  |_/_/ \_\/_/\_\___|_|  |_|\___/|___/___/_/ \_\_|
"@

Write-Host $logo -ForegroundColor Red

$retroBatPath = Get-ChildItem -Path (Get-PSDrive -PSProvider FileSystem).Root -Recurse -Directory -Filter "RetroBat" -ErrorAction SilentlyContinue | Select-Object -First 1 -ExpandProperty FullName

if (-not $retroBatPath) {
    Write-Host "Error: The RetroBat folder was not found."
    Write-Host "Errore: La cartella RetroBat non è stata trovata."
    exit
}
$gitPortable = "$retroBatPath\emulators\mbt\PortableGit\bin\git.exe"
$repoURL = "https://github.com/MIKCPU/Maximusbat-theme.git"
$destinationFolder = "$retroBatPath\RetroBat\emulationstation\.emulationstation\themes\Maximusbat"

# Verifica se PortableGit esiste
if (-not (Test-Path $gitPortable)) {
    Write-Host "PortableGit non trovato in $gitPortable. Verifica il percorso." -ForegroundColor Red
    exit
}

# Configura Git
& $gitPortable config --global http.postBuffer 524288000  
& $gitPortable config --global http.sslBackend openssl  

# Crea la cartella Maximusbat se non esiste
if (-Not (Test-Path $destinationFolder)) {
    Write-Host "Creazione della cartella Maximusbat..."
    New-Item -ItemType Directory -Path $destinationFolder
    Write-Host "Cartella Maximusbat creata!" -ForegroundColor Green
}

# Se la cartella del tema esiste già, esegui un pull, altrimenti clona il repository
if (-Not (Test-Path "$destinationFolder\.git")) {
    Write-Host "Clonazione iniziale del repository..."

    $cloneSuccess = $false
    $retryCount = 0
    $maxRetries = 5

    while (-Not $cloneSuccess -and $retryCount -lt $maxRetries) {
        try {
            Write-Host "Tentativo di clonazione $($retryCount + 1)..."
            & $gitPortable clone --depth 1 --recurse-submodules $repoURL $destinationFolder
            if ($LASTEXITCODE -eq 0) {
                $cloneSuccess = $true
                Write-Host "Clonazione completata!" -ForegroundColor Green
            } else {
                throw "Errore nel comando git clone"
            }
        } catch {
            $retryCount++
            Write-Host "Errore durante il clone. Tentativo $retryCount di $maxRetries. Dettaglio errore: $_"
            Start-Sleep -Seconds 5
        }
    }

    if (-Not $cloneSuccess) {
        Write-Host "Impossibile completare la clonazione dopo $maxRetries tentativi."
    }
} else {
    Write-Host "Verificando aggiornamenti nel repository..."
    Set-Location -Path $destinationFolder

    $pullSuccess = $false
    $retryCount = 0
    $maxRetries = 5

    while (-Not $pullSuccess -and $retryCount -lt $maxRetries) {
        try {
            Write-Host "Tentativo di aggiornamento $($retryCount + 1)..."
            & $gitPortable pull origin main
            if ($LASTEXITCODE -eq 0) {
                $pullSuccess = $true
                Write-Host "Repository aggiornato!" -ForegroundColor Green  
            } else {
                throw "Errore nel comando git pull"
            }
        } catch {
            $retryCount++
            Write-Host "Errore durante l'aggiornamento. Tentativo $retryCount di $maxRetries. Dettaglio errore: $_"
            Start-Sleep -Seconds 5        
        }
    }

    if (-Not $pullSuccess) {
        Write-Host "Impossibile completare l'aggiornamento dopo $maxRetries tentativi."
    }
}

# Rimuovi file inutili
$fileToDelete = @(
    "$destinationFolder\README.md",
    "$destinationFolder\.gitattributes"
)

foreach ($file in $fileToDelete) {
    if (Test-Path $file) {
        Remove-Item -Path $file -Force
        Write-Host "$file eliminato!" -ForegroundColor Red
    }
}

Write-Host "Operazione completata!" -ForegroundColor Green

pause

cls
Write-Host "______________________________________________________" -ForegroundColor Green                                                        
Write-Host "Thank you for downloading and installing my theme!    " -ForegroundColor Green
Write-Host "Grazie per aver scaricato ed installato il mio tema!  " -ForegroundColor Green
Write-Host "______________________________________________________" -ForegroundColor Green
                                                      
$logo = @"
M   M  III  K   K  CCCC  PPPP  U   U
MM MM   I   K  K  C      P   P U   U
M M M   I   K K   C      PPPP  U   U
M   M   I   KK    C      P     U   U
M   M  III  K  K  CCCC  P      UUUU
"@

Write-Host $logo -ForegroundColor Red   
Write-Host "______________________________________________________" -ForegroundColor Green                                                        
Write-Host "Download - Updates complete!                          " -ForegroundColor Green
Write-Host "Download - Aggiornamenti completati!                  " -ForegroundColor Green
Write-Host "______________________________________________________" -ForegroundColor Green
Write-Host "Press any key to close!                               " -ForegroundColor Green    
Write-Host "Premi un tasto per chiudere!                          " -ForegroundColor Green
Write-Host "______________________________________________________" -ForegroundColor Green

$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
