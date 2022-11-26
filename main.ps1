# Welcome, thank you for downloading. See the instructions below and in-line for extending the script functionality
# Please take a moment and look at the license on the Git Repo: https://github.com/LightJack05/LightJackPCSetupScript
#
# This script is intended to set up a Windows 10/11 computer for the first time after a reset.
# Feel free to modify it for your specific usecase.
# It should be run as admin to avoid interruptions by UAC prompts, but doesn't have to.
#
# It requires the winget package manager to be installed at runtime or before starting.
# You may also run it in careless mode by adding "-Careless" to the invocation command.
# See further down for instructions on how careless works.
#
# I'm a beginner in terms of PowerShell Scripting, please don't be too hard on me. ;)
#
# Setup Script by LightJack05
param (
    [switch]$Careless = $false
)

function Main {
    #Function called on execution
    Write-Host "Welcome! Please press any key to begin setup..."
    $Host.UI.RawUI.ReadKey()
    Clear-Host
    if ($Careless) {
        Write-Host 'WARNING: Running in careless mode. There is no check if the downloaded file is damaged or malicious. There is also no version checking. Please make sure software is up to date once installed.' -ForegroundColor red
        SetupMachine
    }
    else {
        # Check if winget needs to be installed
        if (CheckForWinget) {
            SetupMachine
        }
        else {
            Write-Host 'Updating store software to aquire winget...'
            KickStartUpdate
            WaitForWinget
        }
    }
}

function CheckForWinget {

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
    Write-Host 'Opening Windows Store to kickstart app-updates.'
    Write-Host 'The update to the Product should start automatically. Please hang on a minute. Otherwise, please download updates manually.'
    Start-Process ms-windows-store://pdp/?ProductId=9NBLGGH4NNS1
    Start-Sleep 8
    #Get-CimInstance -Namespace "Root\cimv2\mdm\dmmap" -ClassName "MDM_EnterpriseModernAppManagement_AppManagement01" | Invoke-CimMethod -MethodName UpdateScanMethod
}

function WaitForWinget {
    # Loop until winget is found.
    Write-Host 'The script will continue when winget is found. Please wait.'
    while ($true) {
        Start-Sleep 1
        if (CheckForWinget) {
            Clear-Host
            Write-Host 'Winget Found!'
            Write-Host 'Killing Windows Store...'
            taskkill.exe /f /IM WinStore.App.exe
            SetupMachine
            break
        }
    }
}

function SetupMachine {
    Write-Host 'Initiating Setup...'
    Write-Host 'Installing Software'
    #
    # IMPORTANT
    #
    # In regular operation you should disable "Careless"-mode.
    # This is intended as a temporary solution if hashes are creating problems.
    # Usually these problems are resolved within a couple hours or at most days.

    if ($Careless) {
        # Currently unused.
        # Here you can use curl to download software that has problems with hash-checks.
        # Note that the regular winget commands will be skipped with this installation method.
        # You need to add them in here to have them run too.
        Write-Host "You idiot are running in careless mode. Please disable that." -ForegroundColor Red
        Write-Host 'Cleaning up...'
        Remove-Item -r $env:TEMP\SetupScript
        Write-Host 'Setup has been completed. Press any key to exit.'
    }
    else {
        # I know a JSON would probably be better, but I want everything to be consolidated into one file.
        # To add/remove software simply add a line or remove it.
        # Replace the package identifier (e.g. 7zip.7zip) with software you need to add it.
        winget install 7zip.7zip --source winget --accept-source-agreements --accept-package-agreements
        winget install GIMP.GIMP --source winget --accept-source-agreements --accept-package-agreements
        winget install GitHub.GitHubDesktop --source winget --accept-source-agreements --accept-package-agreements
        winget install Git.Git --source winget --accept-source-agreements --accept-package-agreements
        winget install Microsoft.Edge --source winget --accept-source-agreements --accept-package-agreements
        winget install Microsoft.WindowsTerminal --source winget --accept-source-agreements --accept-package-agreements
        winget install Microsoft.OneDrive --source winget --accept-source-agreements --accept-package-agreements
        winget install Parsec.Parsec --source winget --accept-source-agreements --accept-package-agreements
        winget install Valve.Steam --source winget --accept-source-agreements --accept-package-agreements
        winget install Python.Python.3.11 --source winget --accept-source-agreements --accept-package-agreements
        winget install Microsoft.WindowsSDK --source winget --accept-source-agreements --accept-package-agreements
        winget install Microsoft.PowerToys --source winget --accept-source-agreements --accept-package-agreements
        winget install Microsoft.OpenJDK.17 --source winget --accept-source-agreements --accept-package-agreements
        winget install VMware.WorkstationPlayer --source winget --accept-source-agreements --accept-package-agreements
        winget install Microsoft.DotNet.DesktopRuntime.6 --source winget --accept-source-agreements --accept-package-agreements
        winget install Microsoft.VisualStudioCode --source winget --accept-source-agreements --accept-package-agreements
        winget install Discord.Discord --source winget --accept-source-agreements --accept-package-agreements
        winget install Unity.UnityHub --source winget --accept-source-agreements --accept-package-agreements

        # Visual studio
        curl https://raw.githubusercontent.com/LightJack05/LightJackPCSetupScript/main/.vsconfig -o $env:TEMP\SetupScript\.vsconfig
        winget install Microsoft.VisualStudio.2022.Community --override "--passive --config %temp%\SetupScript\.vsconfig" --accept-source-agreements --accept-package-agreements

        Write-Host "Updating currently installed software"
        winget upgrade --all

        Write-Host 'Changing Settings...'
        if ((Get-CimInstance Win32_OperatingSystem).version.substring(5) -gt 21999) {
            c:\Windows\Resources\Themes\dark.theme
        }

        Write-Host 'Copying shortcuts. (Make sure onedrive has downloaded them!)'
        Copy-Item $env:USERPROFILE\OneDrive\Programme\*.lnk $env:USERPROFILE\AppData\Roaming\Microsoft\Windows\Start` Menu\Programs

        Write-Host 'Cleaning up...'
        Remove-Item -r $env:TEMP\SetupScript
        Write-Host 'Setup has been completed. Press any key to exit.'
    }


}

Main






