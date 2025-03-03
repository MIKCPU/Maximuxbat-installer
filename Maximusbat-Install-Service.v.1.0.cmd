@echo off
setlocal

:VBSDynamicBuild
SET TempVBSFile=%temp%\~tmpSendKeysTemp.vbs
IF EXIST "%TempVBSFile%" DEL /F /Q "%TempVBSFile%"
ECHO Set WshShell = WScript.CreateObject("WScript.Shell") >>"%TempVBSFile%"
ECHO Wscript.Sleep 900                                    >>"%TempVBSFile%"
ECHO WshShell.SendKeys "{F11}"                            >>"%TempVBSFile%"
ECHO Wscript.Sleep 900                                    >>"%TempVBSFile%"

if exist "%TempVBSFile%" CSCRIPT //nologo "%TempVBSFile%"

SETLOCAL ENABLEEXTENSIONS
SETLOCAL ENABLEDELAYEDEXPANSION

set "RETROBAT_PATH=%~dp0"
chcp 65001 >nul

rem Check if retrobat.exe exists in the current directory
if not exist "%~dp0retrobat.exe" (
    color E
    echo.
    echo #########################################################
    echo #                                                       #
    echo #   PLEASE RUN THIS SCRIPT FROM YOUR RETROBAT FOLDER!   #
    echo #                                                       #
    echo #########################################################
    echo.
    echo Press any key to exit...
    pause > nul 2>&1
    exit /b
)
cls
echo [32m
echo.
echo                              ##     ## #### ##    ##  ######  ########  ##     ## 
echo                              ###   ###  ##  ##   ##  ##    ## ##     ## ##     ## 
echo                              #### ####  ##  ##  ##   ##       ##     ## ##     ## 
echo                              ## ### ##  ##  #####    ##       ########  ##     ## 
echo                              ##     ##  ##  ##  ##   ##       ##        ##     ## 
echo                              ##     ##  ##  ##   ##  ##    ## ##        ##     ## 
echo                              ##     ## #### ##    ##  ######  ##         #######[0m
echo.
echo [93m                                          PRESENT  -  PRESENTA[0m
echo.
echo.
echo [91m
echo           ##     ##    ###    ##     ## #### ##     ## ##     ##  ######  ########     ###    ######## 
echo           ###   ###   ## ##    ##   ##   ##  ###   ### ##     ## ##    ## ##     ##   ## ##      ##    
echo           #### ####  ##   ##    ## ##    ##  #### #### ##     ## ##       ##     ##  ##   ##     ##    
echo           ## ### ## ##     ##    ###     ##  ## ### ## ##     ##  ######  ########  ##     ##    ##    
echo           ##     ## #########   ## ##    ##  ##     ## ##     ##       ## ##     ## #########    ##    
echo           ##     ## ##     ##  ##   ##   ##  ##     ## ##     ## ##    ## ##     ## ##     ##    ##    
echo           ##     ## ##     ## ##     ## #### ##     ##  #######   ######  ########  ##     ##    ##    [0m           
echo.
echo.
ping -n 2 127.0.0.1 > nul

echo [34mDownloading Maximusbat Theme Configuration...  -  Scaricamento della configurazione del tema Maximusbat...[0m
echo.
ping -n 2 127.0.0.1 > nul

echo [32mDownloading 7zip and wget programs...  -  Scaricamento programmi 7zip e wget...[0m
curl -O https://raw.githubusercontent.com/MIKCPU/Maximusbat-Install-Service/main/7z.exe
curl -O https://raw.githubusercontent.com/MIKCPU/Maximusbat-Install-Service/main/7z.dll
curl -O https://raw.githubusercontent.com/MIKCPU/Maximusbat-Install-Service/main/wget.exe
echo.
echo [32mDownload Installation Package...  -  Scaricamento Pacchetto d'installazione...[0m
curl -O https://raw.githubusercontent.com/MIKCPU/Maximusbat-Install-Service/main/mbt.zip.001
curl -O https://raw.githubusercontent.com/MIKCPU/Maximusbat-Install-Service/main/mbt.zip.002
ping -n 2 127.0.0.1 > nul
echo.
if not exist "mbt.zip.001" (
    echo [91mError: mbt.zip.001 not found. Download may have failed.[0m
    echo [91mErrore: mbt.zip.001 non trovato. Il download potrebbe essere fallito.[0m
    pause
    exit /b
)
if not exist "mbt.zip.002" (
    echo [91mError: mbt.zip.002 not found. Download may have failed.[0m
    echo [91mErrore: mbt.zip.002 non trovato. Il download potrebbe essere fallito.[0m
    pause
    exit /b
)

copy /b mbt.zip.001 + mbt.zip.002 mbt.zip

echo [32mExtracting files...  -  Estrazione dei file...[0m
7z x mbt.zip -aoa -o"%RETROBAT_PATH%emulators\"
del mbt.zip mbt.zip.001 mbt.zip.002 7z.exe 7z.dll wget.exe .wget-hsts
set "MBT_BAT=%RETROBAT_PATH%emulators\mbt\Install_Maximusbat.bat"

if exist "%MBT_BAT%" (
    echo [32mRunning the BAT file: %MBT_BAT%[0m
    echo [32mEseguendo il file BAT: %MBT_BAT%[0m
    call "%MBT_BAT%"
) else (
    echo [91mError: The file Install_Maximusbat.bat was not found![0m
    echo [91mErrore: Il file Install_Maximusbat.bat non e' stato trovato![0m
    pause
    exit /b
)

