@echo off
start /min powershell -ExecutionPolicy Bypass -File "%~dp0script\fullscreen.ps1"
timeout /t 2 >nul
cls

set RETROBAT_PATH=%~dp0
chcp 65001 >nul

:menu
cls
echo [97m
echo.
echo                              ##     ## #### ##    ##  ######  ########  ##     ## 
echo                              ###   ###  ##  ##   ##  ##    ## ##     ## ##     ## 
echo                              #### ####  ##  ##  ##   ##       ##     ## ##     ## 
echo                              ## ### ##  ##  #####    ##       ########  ##     ## 
echo                              ##     ##  ##  ##  ##   ##       ##        ##     ## 
echo                              ##     ##  ##  ##   ##  ##    ## ##        ##     ## 
echo                              ##     ## #### ##    ##  ######  ##         #######  
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
echo [92m
echo               =================================================================================
echo               * Select the operation to perform:     *  Seleziona l'operazione da eseguire:   *
echo               * 1. Start Tool-Install installation   *  1. Avvia installazione Tool-Install   *     
echo               * 2. Start Updater installation        *  2. Avvia installazione Updater        *     
echo               * 3. Start MaximusBat theme download   *  3. Avvia scaricamento tema MaximusBat *      
echo               * e. Exit                              *  e. Uscita                             *                              
echo               =================================================================================[0m
echo.

set /p scelta="[93mEnter the number of the desired option:[0m [94m--[0m [93mInserisci il numero dell'opzione desiderata:[0m "

if "%scelta%"=="1" (
    cls
    echo [92mStart Tool-Install  installation... - Avvia installazione Tool-Install...[0m
    powershell -ExecutionPolicy Bypass -File "%~dp0script\maximusbat_install.ps1" "%~dp0"
    goto menu
)

if "%scelta%"=="2" (
    cls
    echo [92mStart Updater installation... - Avvia installazione Updater...[0m
    powershell -ExecutionPolicy Bypass -File "%~dp0script\maximusbat_update.ps1" "%~dp0"
    goto menu
)

if "%scelta%"=="3" (
    cls
    echo [92mStart MaximusBat theme download... - Avvia scaricamento tema MaximusBat...[0m
    powershell -ExecutionPolicy Bypass -File "%~dp0script\maximusbat_theme.ps1"  "%~dp0"
    goto menu
)

if "%scelta%"=="e" goto exit

echo [91mInvalid option. Please try again. - Opzione non valida. Riprova.[0m
goto menu

:exit
cls
echo [91mExit... - Uscita...[0m
echo  Exit... - Uscita...
exit
