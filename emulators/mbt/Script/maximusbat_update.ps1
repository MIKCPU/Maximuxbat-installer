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
$logo = @"
  __  __   _   __  _____ __  __ _   _ ___ ___   _ _____    _   _ ___ ___   _ _____ ___ ___ 
 |  \/  | /_\  \ \/ /_ _|  \/  | | | / __| _ ) /_\_   _|__| | | | _ \   \ /_\_   _| __| _ \
 | |\/| |/ _ \  >  < | || |\/| | |_| \__ \ _ \/ _ \| ||___| |_| |  _/ |) / _ \| | | _||   /
 |_|  |_/_/ \_\/_/\_\___|_|  |_|\___/|___/___/_/ \_\_|     \___/|_| |___/_/ \_\_| |___|_|_\
"@

Write-Host $logo -ForegroundColor Red

$retroBatPath = Get-ChildItem -Path (Get-PSDrive -PSProvider FileSystem).Root -Recurse -Directory -Filter "RetroBat" -ErrorAction SilentlyContinue | Select-Object -First 1 -ExpandProperty FullName

if (-not $retroBatPath) {
    Write-Host "Error: The RetroBat folder was not found."
    Write-Host "Errore: La cartella RetroBat non è stata trovata."
    exit
}
$gitPortable = "$retroBatPath\emulators\mbt\PortableGit\bin\git.exe"
$destinationFolder = "$retroBatPath\Maximusbat-Updater-main"
$repoURL = "https://github.com/MIKCPU/Maximusbat-Updater.git"
$sourceFolder = "$retroBatPath\Maximusbat-Updater-main"

& $gitPortable config --global http.postBuffer 524288000  
& $gitPortable config --global http.sslBackend openssl  

if (-Not (Test-Path $destinationFolder)) {
    Write-Host "Initial repository cloning..." -ForegroundColor Blue
    Write-Host "Clonazione iniziale del repository..." -ForegroundColor Blue  

    $cloneSuccess = $false
    $retryCount = 0
    $maxRetries = 5  # Max retries before giving up

    while (-Not $cloneSuccess -and $retryCount -lt $maxRetries) {
        try {
            Write-Host "Attempting to clone $($retryCount + 1)..."
            Write-Host "Tentativo di clonazione $($retryCount + 1)..."

            & $gitPortable clone --depth 1 --recurse-submodules $repoURL $destinationFolder
            if ($LASTEXITCODE -eq 0) {
                $cloneSuccess = $true
                Write-Host "Cloning completed!" -ForegroundColor Blue
                Write-Host "Clonazione completata!" -ForegroundColor Blue  
            } else {
                throw "Errore nel comando git clone" 
            }
        } catch {
            $retryCount++
            Write-Host "Error while clone. Attempting $retryCount of $maxRetries. Error detail: $_"
            Write-Host "Errore durante il clone. Tentativo $retryCount di $maxRetries. Dettaglio errore: $_"
            Start-Sleep -Seconds 5 
        }
    }

    if (-Not $cloneSuccess) {
        Write-Host "Failed to complete cloning after $maxRetries attempts."
        Write-Host "Impossibile completare la clonazione dopo $maxRetries tentativi."
    }
} else {
    Write-Host "Checking for updates in the repository..."
    Write-Host "Verificando se sono presenti aggiornamenti nel repository..." 
    Set-Location -Path $destinationFolder

    $pullSuccess = $false
    $retryCount = 0
    $maxRetries = 5  # Max retries before giving up

    while (-Not $pullSuccess -and $retryCount -lt $maxRetries) {
        try {
            Write-Host "Attempting to update $($retryCount + 1)..."
            Write-Host "Tentativo di aggiornamento $($retryCount + 1)..."

            & $gitPortable pull origin main
            if ($LASTEXITCODE -eq 0) {
                $pullSuccess = $true
                Write-Host "Aggiornamenti sincronizzati!" -ForegroundColor Blue  
            } else {
                throw "Errore nel comando git pull"
            }
        } catch {
            $retryCount++
            Write-Host "Error updating. Attempting $retryCount of $maxRetries. Error detail: $_"
            Write-Host "Errore durante l'aggiornamento. Tentativo $retryCount di $maxRetries. Dettaglio errore: $_"
            Start-Sleep -Seconds 5        
        }
    }

    if (-Not $pullSuccess) {
        Write-Host "Unable to complete update after $maxRetries attempts."
        Write-Host "Impossibile completare l'aggiornamento dopo $maxRetries tentativi."
    }
}

$fileToDelete1 = "$driveLetter\retrobat\Maximusbat-Updater-main\README.md"
$fileToDelete2 = "$driveLetter\retrobat\Maximusbat-Updater-main\.gitattributes"

if (Test-Path $fileToDelete1) {
    Remove-Item -Path $fileToDelete1
    Write-Host "$fileToDelete1 deleted!" -ForegroundColor Red
    Write-Host "$fileToDelete1 eliminato!" -ForegroundColor Red

}

if (Test-Path $fileToDelete2) {
    Remove-Item -Path $fileToDelete2
    Write-Host "$fileToDelete2 deleted!" -ForegroundColor Red
    Write-Host "$fileToDelete2 eliminato!" -ForegroundColor Red
}

Write-Host "Moving the files from '$sourceFolder' to '$driveLetter\retrobat'..." -ForegroundColor Green
Write-Host "Spostando i file da '$sourceFolder' a '$driveLetter\retrobat'..." -ForegroundColor Green

Copy-Item -Path "$sourceFolder\*" -Destination $driveLetter\retrobat -Recurse -Force

Remove-Item -Path $sourceFolder -Recurse -Force

$gitFolder = "$driveLetter\retrobat\.git"  
if (Test-Path $gitFolder) {
    attrib +h $gitFolder
    Write-Host "The folder $gitFolder has been hidden!" -ForegroundColor Yellow
    Write-Host "La cartella $gitFolder e' stata nascosta!" -ForegroundColor Yellow
} else {
    Write-Host "The folder $gitFolder does not exist." -ForegroundColor Yellow
    Write-Host "La cartella $gitFolder non esiste." -ForegroundColor Yellow
}

# Ottieni il percorso della cartella dell'utente corrente
$desktopPath = [System.Environment]::GetFolderPath('Desktop')

# Definisci il percorso del collegamento e dell'icona
$shortcutPath = "$desktopPath\RetroBat PIxN - RGS.lnk"
$retrobatExePath = "$driveLetter\retrobat\retrobat.exe"  # Modifica questo percorso con il corretto percorso dell'exe di RetroBat
$iconPath = "$driveLetter\retrobat\_PreRequisites -Install First-\icon.ico"  # Modifica questo percorso con il percorso dell'icona

# Crea l'oggetto COM per creare il collegamento
$shell = New-Object -ComObject WScript.Shell
$shortcut = $shell.CreateShortcut($shortcutPath)

# Imposta il percorso dell'eseguibile e l'icona
$shortcut.TargetPath = $retrobatExePath
$shortcut.IconLocation = $iconPath

# Salva il collegamento
$shortcut.Save()

# Conferma la creazione del collegamento
Write-Host "Collegamento RetroBat PIxN - RGS creato con successo sul desktop!" -ForegroundColor Green

Write-Host "Operation Complete!" -ForegroundColor Green
Write-Host "Operazione completata!" -ForegroundColor Green

pause

cls
Write-Host "______________________________________________________" -ForegroundColor Green                                                        
Write-Host "Thank you for downloading and installing my theme!    " -ForegroundColor Green
Write-Host "Grazie per aver scaricato ed installato il mio tema!  " -ForegroundColor Green
Write-Host "______________________________________________________" -ForegroundColor Green
                                                      
$logo = @"
M   M  III  K   K CCCCC  PPPPP U   U
MM MM   I   K  K  C      P   P U   U
M M M   I   K K   C      PPPPP U   U
M   M   I   KK    C      P     U   U
M   M  III  K  K  CCCCC  P     UUUUU
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
