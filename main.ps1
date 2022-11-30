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
    [switch]$Careless = $false
)

function Main {
    # Function called on execution
    Write-Host "Welcome! Setup will start in 5 seconds."
    Write-Host "To cancel, press Ctrl+C or close this window."
    Start-Sleep 5

    Clear-Host
    if ($Careless) {
        # Warn the user if they are running in careless mode
        # NOTE: Careless mode skips the winget installation!
        Write-Host 'WARNING: Running in careless mode. There is no check if the downloaded file is damaged or malicious. There is also no version checking. Please make sure software is up to date once installed.' -ForegroundColor red
        SetupMachine
    }
    else {
        # Check if winget needs to be installed
        if (CheckForWinget) {
            # If winget it found already, start setup
            SetupMachine
        }
        else {
            # If winget is not found, install it.
            Write-Host 'Updating store software to aquire winget...'
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
    Write-Host 'Opening Windows Store to kickstart app-updates.'
    Write-Host 'The update to the product should start automatically. Please hang on a minute. Otherwise, please download updates manually.'
    Start-Process ms-windows-store://pdp/?ProductId=9NBLGGH4NNS1
    Start-Sleep 8
}

function WaitForWinget {
    # Loop until winget is found.
    Write-Host 'The script will continue when winget is found. Please wait.'
    while ($true) {
        Start-Sleep 1
        if (CheckForWinget) {
            # Run once winget is found
            Clear-Host
            Write-Host 'Winget Found!'
            Write-Host 'Killing Windows Store...'
            # Kill MS Store UI since it is no longer needed
            taskkill.exe /f /IM WinStore.App.exe
            # Call setup function
            SetupMachine
            break
        }
    }
}

function SetupMachine {
    # Create temp directory should it not exist yet
    if (!(Test-Path -Path $env:TEMP\SetupScript)) {
        mkdir $env:TEMP\SetupScript
    }
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

        # Install the specified software (specified directly in the script)
        # I know a JSON would probably be better, but I want everything to be consolidated into one file.
        # To add/remove software simply add a line or remove it.
        # Replace the package identifier (e.g. 7zip.7zip) with software you need to add it.
        winget install 7zip.7zip --source winget --accept-source-agreements --accept-package-agreements
        winget install GIMP.GIMP --source winget --accept-source-agreements --accept-package-agreements
        winget install GitHub.GitHubDesktop --source winget --accept-source-agreements --accept-package-agreements
        winget install Git.Git --source winget --accept-source-agreements --accept-package-agreements
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
        winget install powershell --source msstore --accept-source-agreements --accept-package-agreements
        winget install balena.etcher --source winget --accept-source-agreements --accept-package-agreements

        # PowerToys config copying
        # Kill PowerToys to make the files available
        taskkill /IM powertoys.exe /f
        Start-Sleep 2
        # Download powertoys zip archive
        curl https://raw.githubusercontent.com/LightJack05/LightJackPCSetupScript/main/PowerToys.zip -o $env:TEMP\SetupScript\PowerToys.zip
        # Extract archive to appdata folder
        Expand-Archive -Path $env:TEMP\SetupScript\PowerToys.zip -DestinationPath $env:APPDATA\..\Local\Microsoft\ -Force


        # Visual studio
        # Download the vsconfig file for installation
        curl https://raw.githubusercontent.com/LightJack05/LightJackPCSetupScript/main/.vsconfig -o $env:TEMP\SetupScript\.vsconfig
        # install Visual Studio with downloaded config
        winget install Microsoft.VisualStudio.2022.Community --override "--passive --config %temp%\SetupScript\.vsconfig" --accept-source-agreements --accept-package-agreements

        # Kickstart store updates
        Get-CimInstance -Namespace "Root\cimv2\mdm\dmmap" -ClassName "MDM_EnterpriseModernAppManagement_AppManagement01" | Invoke-CimMethod -MethodName UpdateScanMethod

        # Update installed desktop applications
        #Write-Host "Updating currently installed software"
        #winget upgrade --all


        Write-Host 'Changing Settings...'
        # Apply dark theme (theme for Windows 11, App dark mode for Windows 10)
        if ((Get-CimInstance Win32_OperatingSystem).version.substring(5) -gt 21999) {
            c:\Windows\Resources\Themes\dark.theme
        }
        else {
            Set-Itemproperty -path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize' -Name 'AppsUseLightTheme' -Value 0
        }

        # Remove bloatware
        Get-AppxPackage *skypeapp* | Remove-AppxPackage
        Get-AppxPackage *solitairecollection* | Remove-AppxPackage



        # Copy shortcuts for portable applications
        Write-Host 'Copying shortcuts. (Make sure onedrive has downloaded them!)'
        Copy-Item $env:USERPROFILE\OneDrive\Programme\*.lnk $env:USERPROFILE\AppData\Roaming\Microsoft\Windows\Start` Menu\Programs

        # Delete remaining files that are no longer needed, including the temp directory
        Write-Host 'Cleaning up...'
        Remove-Item -r $env:TEMP\SetupScript
        Write-Host 'Setup has been completed. Press any key to exit.'
        Pause

    }
}

# Call entry function "Main"
Main






