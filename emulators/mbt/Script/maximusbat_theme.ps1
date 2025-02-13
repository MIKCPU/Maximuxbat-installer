$logo = @"
M   M  III  K   K CCCCC  PPPPP U   U
MM MM   I   K  K  C      P   P U   U
M M M   I   K K   C      PPPPP U   U
M   M   I   KK    C      P     U   U
M   M  III  K  K  CCCCC  P     UUUUU
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
$destinationFolder = "$retroBatPath\emulationstation\.emulationstation\themes\Maximusbat"

if (-not (Test-Path $gitPortable)) {
    Write-Host "PortableGit not found in $gitPortable. Check the route." -ForegroundColor Red
    Write-Host "PortableGit non trovato in $gitPortable. Verifica il percorso." -ForegroundColor Red

    exit
}

& $gitPortable config --global http.postBuffer 524288000  
& $gitPortable config --global http.sslBackend openssl  

if (-Not (Test-Path $destinationFolder)) {
    Write-Host "Creating the Maximusbat folder..."
    Write-Host "Creazione della cartella Maximusbat..."

    New-Item -ItemType Directory -Path $destinationFolder

    Write-Host "Maximusbat folder created!" -ForegroundColor Green
    Write-Host "Cartella Maximusbat creata!" -ForegroundColor Green

}

if (-Not (Test-Path "$destinationFolder\.git")) {
    Write-Host "Initial repository cloning..."
    Write-Host "Clonazione iniziale del repository..."

    $cloneSuccess = $false
    $retryCount = 0
    $maxRetries = 5

    while (-Not $cloneSuccess -and $retryCount -lt $maxRetries) {
        try {
            Write-Host "Cloning attempt $($retryCount + 1)..."
            Write-Host "Tentativo di clonazione $($retryCount + 1)..."
            & $gitPortable clone --depth 1 --recurse-submodules $repoURL $destinationFolder
            if ($LASTEXITCODE -eq 0) {
                $cloneSuccess = $true
                Write-Host "Cloning completed!" -ForegroundColor Green
                Write-Host "Clonazione completata!" -ForegroundColor Green
            } else {
                throw "Errore nel comando git clone"
            }
        } catch {
            $retryCount++
            Write-Host "Error while cloning. Attempting $retryCount of $maxRetries. Error detail: $_"
            Write-Host "Errore durante il clone. Tentativo $retryCount di $maxRetries. Dettaglio errore: $_"
            Start-Sleep -Seconds 5
        }
    }

    if (-Not $cloneSuccess) {
        Write-Host "Unable to complete cloning after $maxRetries attempts."
        Write-Host "Impossibile completare la clonazione dopo $maxRetries tentativi."
    }
} else {
    Write-Host "Checking for updates in the repository..."
    Write-Host "Verificando aggiornamenti nel repository..."
    Set-Location -Path $destinationFolder

    $pullSuccess = $false
    $retryCount = 0
    $maxRetries = 5

    while (-Not $pullSuccess -and $retryCount -lt $maxRetries) {
        try {
            Write-Host "Attempting to update $($retryCount + 1)..."
            Write-Host "Tentativo di aggiornamento $($retryCount + 1)..."
            & $gitPortable pull origin main
            if ($LASTEXITCODE -eq 0) {
                $pullSuccess = $true
                Write-Host "Updated repository!" -ForegroundColor Green 
                Write-Host "Repository aggiornato!" -ForegroundColor Green   
            } else {
                throw "Errore nel comando git pull"
            }
        } catch {
            $retryCount++
            Write-Host "Error while updating. Trying $retryCount of $maxRetries. Error detail: $_"
            Write-Host "Errore durante l'aggiornamento. Tentativo $retryCount di $maxRetries. Dettaglio errore: $_"
            Start-Sleep -Seconds 5        
        }
    }

    if (-Not $pullSuccess) {
        Write-Host "Unable to complete update after $maxRetries attempts."
        Write-Host "Impossibile completare l'aggiornamento dopo $maxRetries tentativi."
    }
}

$fileToDelete = @(
    "$destinationFolder\README.md",
    "$destinationFolder\.gitattributes"
)

foreach ($file in $fileToDelete) {
    if (Test-Path $file) {
        Remove-Item -Path $file -Force
        Write-Host "$file elimined!" -ForegroundColor Red
        Write-Host "$file eliminato!" -ForegroundColor Red
    }
}

Write-Host "Operation Complete!" -ForegroundColor Green
Write-Host "Operazione completata!" -ForegroundColor Green

pause

cls
Write-Host " _____________________________________________________ " -ForegroundColor Green                                                        
Write-Host "|Thank you for downloading and installing the Theme!  |" -ForegroundColor Green
Write-Host "|Grazie per aver scaricato ed installato il Tema!     |" -ForegroundColor Green
Write-Host "|_____________________________________________________|" -ForegroundColor Green
                                                      
$logo = @"
M   M  III  K   K CCCCC  PPPPP U   U
MM MM   I   K  K  C      P   P U   U
M M M   I   K K   C      PPPPP U   U
M   M   I   KK    C      P     U   U
M   M  III  K  K  CCCCC  P     UUUUU
"@

Write-Host $logo -ForegroundColor Red   
Write-Host " _____________________________________________________ " -ForegroundColor Green                                  
Write-Host "|Download Theme complete!                             |" -ForegroundColor Green
Write-Host "|Download Tema completato!                            |" -ForegroundColor Green
Write-Host "|_____________________________________________________|" -ForegroundColor Green
Write-Host "|Press any key to close!                              |" -ForegroundColor Green
Write-Host "|Premi un tasto per chiudere!                         |" -ForegroundColor Green
Write-Host "|_____________________________________________________|" -ForegroundColor Green

$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
