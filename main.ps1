# Welcome, thank you for downloading. See the instructions below and in-line for extending the script functionality
# Please take a moment and look at the license on the Git Repo: [blank]
#
# This script is intended to set up a Windows 10 computer for the first time after a reset.
# It was written for Vimlark and is suited to his specific needs. Feel free to modify it for your specific usecase.
# It should be run as admin to avoid interruptions by UAC prompts, but doesn't have to.
# It requires the winget package manager to be installed at runtime or before starting.
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
    if ($AvoidHashChecks) {
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
        # Chrome
        Write-Host "Installing Chrome..."
        curl https://dl.google.com/tag/s/appguid%3D%7B8A69D345-D564-463C-AFF1-A69D9E530F96%7D%26iid%3D%7BC253142F-0FB0-E40A-E37B-336427084533%7D%26lang%3Den%26browser%3D5%26usagestats%3D0%26appname%3DGoogle%2520Chrome%26needsadmin%3Dprefers%26ap%3Dx64-stable-statsdef_1%26installdataindex%3Dempty/update2/installers/ChromeSetup.exe -o $env:TEMP\ChromeSetup.exe
        Start-Process $env:TEMP\ChromeSetup.exe


        Write-Host "Installing Chrome..."
        curl https://7-zip.org/a/7z2201-x64.msi -o $env:TEMP\7zip.msi
        Start-Process $env:TEMP\7zip.msi /quiet


        Write-Host 'Waiting 4 minutes for setups to complete to clean up...'
        Start-Sleep 240
        Remove-Item $env:TEMP\7zip.msi
        Remove-Item $env:TEMP\ChromeSetup.exe
    }
    else {
        winget install Google.Chrome --accept-source-agreements --accept-package-agreements
        winget install 7zip.7zip --source winget --accept-source-agreements --accept-package-agreements
    }




    Write-Output 'Changing Settings...'

    Write-Output 'Setup has been completed. Press any key to exit.'
}

Main






