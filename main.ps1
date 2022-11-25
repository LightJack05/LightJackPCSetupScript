# Welcome, thank you for downloading. See the instructions below and in-line for extending the script functionality
# Please take a moment and look at the license on the Git Repo: https://github.com/LightJack05/LightJackPCSetupScript
#
# This script is intended to set up a Windows 10/11 computer for the first time after a reset.
# Feel free to modify it for your specific usecase.
# It should be run as admin to avoid interruptions by UAC prompts, but doesn't have to.
#
# It requires the winget package manager to be installed at runtime or before starting.
# You may also run it in careless mode by adding "-Careless" to the invocation command.
# This is the default right now since the chrome installer hash is currently broken in winget.
#
#
# I'm a beginner in terms of PowerShell Scripting, please don't be too hard on me. ;)
#
# Setup Script by LightJack05
param (
    [switch]$Careless = $false
)

function Main {
    #Function called on execution
    Write-Output "Welcome! Please press any key to begin setup..."
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
    Write-Output 'Opening Windows Store to kickstart app-updates.'
    Write-Output 'Please click "Update" on the window that pops up.'
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
            Write-Output 'Winget Found!'
            Write-Output 'Killing Windows Store...'
            taskkill.exe /f /IM WinStore.App.exe
            SetupMachine
            break
        }
    }
}

function SetupMachine {
    Write-Output 'Initiating Setup...'
    Write-Output 'Installing Software'
    #
    # IMPORTANT
    #
    # In regular operation you should disable "AvoidHashChecks".
    # This is intended as a temporary solution if hashes are creating problems.
    # Usually these problems are resolved within a couple hours or at most days.

    if ($Careless) {
        # Currently unused.
    }
    else {
        # I know a JSON would probably be better, but I want everything to be consolidated into one file.
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
    }

    Write-Output 'Changing Settings...'

    Write-Output 'Setup has been completed. Press any key to exit.'
}

Main






