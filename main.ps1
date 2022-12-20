# Welcome, thank you for downloading. See the instructions below and in-line for extending the script functionality
# Please take a moment and look at the license on the Git Repo: https://github.com/LightJack05/LightJackPCSetupScript
#
# This script is intended to set up a Windows 10/11 computer for the first time after a reset.
# Feel free to modify it for your specific usecase.
# It should be run as admin to avoid interruptions by UAC prompts, but doesn't have to.
#
# It requires the winget package manager to be installed at runtime or before starting.
# You may also run it in careless mode by adding "-Careless" to the invocation command.
# Do note that Careless-Mode also skips the normal installation steps and replaces them with more advanced solutions, should you choose to implement any.
# See further down for instructions on how careless works.
#
# I'm a beginner in terms of PowerShell scripting, please don't be too hard on me. ;)
#
# Setup Script by LightJack05
param (
    [switch]$All = $false,
    [switch]$Software = $false,
    [switch]$Discord = $false,
    [switch]$PowerToysSettings = $false,
    [switch]$VisualStudio = $false,
    [switch]$UpdateStoreApps = $false,
    [switch]$DarkMode = $false,
    [switch]$RemoveBloat = $false,
    [switch]$ShortcutCopying = $false,
    [switch]$RestoreOldRightClickMenu = $false,
    [switch]$WindowsTerminal = $false,
    [switch]$OfflineMode = $false,
    [switch]$Careless = $false
)

function Main {
    # Change title to initializing
    $host.ui.RawUI.WindowTitle = "Setup Script: Initializing"

    # Function called on execution
    Write-Host "[SetupScript - INFO] Welcome! Setup will start in 5 seconds." -ForegroundColor Green
    Write-Host "[SetupScript - INFO] To cancel, press Ctrl+C or close this window." -ForegroundColor Green
    Start-Sleep 5



    # Create temp directory should it not exist yet
    if (!(Test-Path -Path $env:TEMP\SetupScript)) {
        Write-Host '[SetupScript - INFO] Creating temporary directory and cloning required files...' -ForegroundColor Green
        mkdir $env:TEMP\SetupScript
        if ((Test-Path -Path $env:TEMP\SetupScript)) {
            Write-Host '[SetupScript - INFO] Sucessfully created directory.' -ForegroundColor Green
        }
        else {
            Write-Host '[SetupScript - ERROR] Failed to create temp directory at %appdata%\SetupScript.' -ForegroundColor DarkRed
            Write-Host '[SetupScript - ERROR] Unable to continue. Script will exit.' -ForegroundColor DarkRed
            $host.ui.RawUI.WindowTitle = "Setup Script: ERROR"
            Pause
            Exit
        }
    }
    else {
        Write-Host '[SetupScript - INFO] Using existing temp directory...' -ForegroundColor Green
    }
    Start-Sleep 3
    Clear-Host
    if (!$OfflineMode) {
        if ($Software -or $All) {
            # Download winget json file
            Write-Host '[SetupScript - INFO] Downloading Winget JSON file...' -ForegroundColor Green
            curl https://raw.githubusercontent.com/LightJack05/LightJackPCSetupScript/LightJack-Typical/winget.json -o $env:TEMP\SetupScript\winget.json
        }
        if ($PowerToysSettings -or $All) {
            # Download powertoys zip archive
            Write-Host '[SetupScript - INFO] Donwloading PowerToys Settings archive...' -ForegroundColor Green
            curl https://raw.githubusercontent.com/LightJack05/LightJackPCSetupScript/LightJack-Typical/PowerToys.zip -o $env:TEMP\SetupScript\PowerToys.zip
        }

        if ($VisualStudio -or $All) {
            # Download the vsconfig file for installation
            Write-Host '[SetupScript - INFO] Downloading Visual Studio configuration...' -ForegroundColor Green
            curl https://raw.githubusercontent.com/LightJack05/LightJackPCSetupScript/LightJack-Typical/.vsconfig -o $env:TEMP\SetupScript\.vsconfig
        }

        if ($WindowsTerminal -or $All) {
            # Download Windows Terminal configuration file
            Write-Host '[SetupScript - INFO] Downloading Windows Terminal configuration...' -ForegroundColor Green
            curl https://raw.githubusercontent.com/LightJack05/LightJackPCSetupScript/LightJack-Typical/settings.json -o $env:TEMP\SetupScript\settings.json
        }

    }


    if ($Careless) {
        # Warn the user if they are running in careless mode
        # NOTE: Careless mode skips the winget installation!
        Write-Host '[SetupScript - WARNING] Running in careless mode. There is no check if the downloaded file is damaged or malicious. There is also no version checking. Please make sure software is up to date once installed.' -ForegroundColor red
        StartSetup
    }
    else {
        # Check if winget needs to be installed
        if (CheckForWinget) {
            # If winget is found already, start setup
            StartSetup
        }
        else {
            # If winget is not found, install it.
            Write-Host '[SetupScript - INFO] Updating store software to aquire winget...' -ForegroundColor Green
            KickStartUpdate
            WaitForWinget
        }
    }

}

function CheckForWinget {

    # Check if the winget command is available. Return true if it is.
    $cmdName = "winget"
    if (Get-Command $cmdName -errorAction SilentlyContinue) {
        Return $true
    }
    else {
        Return $false
    }
}

function KickStartUpdate {
    # Open MS Store on app installer page to update it.
    Write-Host '[SetupScript - INFO] Opening Windows Store to kickstart app-updates.' -ForegroundColor Green
    Write-Host '[SetupScript - INFO] The update to the product should start automatically. Please hang on a minute. Otherwise, please download updates manually.' -ForegroundColor Green
    Start-Process ms-windows-store://pdp/?ProductId=9NBLGGH4NNS1
    Start-Sleep 8
}

function WaitForWinget {
    # Loop until winget is found.
    Write-Host '[SetupScript - INFO] The script will continue when winget is found. Please wait.' -ForegroundColor Green
    while ($true) {
        Start-Sleep 1
        if (CheckForWinget) {
            # Run once winget is found
            Clear-Host
            Write-Host '[SetupScript - INFO] Winget Found!' -ForegroundColor Green
            Write-Host '[SetupScript - INFO] Killing Windows Store...' -ForegroundColor Green
            # Kill MS Store UI since it is no longer needed
            taskkill.exe /f /IM WinStore.App.exe
            # Call setup function
            StartSetup
            break
        }
    }
}

function StartSetup {
    Write-Host '[SetupScript - INFO] Initiating Setup...' -ForegroundColor Green
    Set-Location $env:TEMP\SetupScript
    .\setup.ps1 -SAll:$All -SSoftware:$Software -SDiscord:$Discord -SPowerToysSettings:$PowerToysSettings -SVisualStudio:$VisualStudio -SUpdateStoreApps:$UpdateStoreApps -SDarkMode:$DarkMode -SRemoveBloat:$RemoveBloat -SShortcutCopying:$ShortcutCopying -SRestoreOldRightClickMenu:$RestoreOldRightClickMenu -SWindowsTerminal:$WindowsTerminal -SOfflineMode:$OfflineMode -SCareless:$Careless
}

# Call entry function "Main"
Main

Pause
