param (
    [switch]$SAll = $false,
    [switch]$SSoftware = $false,
    [switch]$SDiscord = $false,
    [switch]$SPowerToysSettings = $false,
    [switch]$SVisualStudio = $false,
    [switch]$SUpdateStoreApps = $false,
    [switch]$SDarkMode = $false,
    [switch]$SRemoveBloat = $false,
    [switch]$SShortcutCopying = $false,
    [switch]$SRestoreOldRightClickMenu = $false,
    [switch]$SWindowsTerminal = $false,
    [switch]$SOfflineMode = $false,
    [switch]$SCareless = $false
)


function SetupMachine {
    # Change title to working
    $host.ui.RawUI.WindowTitle = "Setup Script: Working"



    #
    # IMPORTANT
    #
    # In regular operation you should disable "Careless"-mode.
    # This is intended as a temporary solution if hashes are creating problems.
    # Usually these problems are resolved within a couple hours or at most days.

    if ($SCareless) {
        # Currently unused.
        # Here you can use curl to download software that has problems with hash-checks.
        # Note that the regular winget commands will be skipped with this installation method.
        # You need to add them in here to have them run too.
        Write-Host "[SetupScript - ERROR] You are running in -Careless mode. There currently are no actions configured." -ForegroundColor DarkRed
        Write-Host '[SetupScript - INFO] Cleaning up...' -ForegroundColor Green
        Remove-Item -r $env:TEMP\SetupScript
        Write-Host '[SetupScript - INFO] Setup has been completed. Press any key to exit.' -ForegroundColor Green

    }
    else {

        Write-Host '[SetupScript - INFO] Changing Settings...' -ForegroundColor Green

        if ($SRestoreOldRightClickMenu -or $SAll) {
            # Check windows version the script is running on
            if ((Get-CimInstance Win32_OperatingSystem).version.substring(5) -gt 21999) {
                # On Windows 11 change the registry key to restore the old rightclick menu.
                Write-Host '[SetupScript - INFO] Restoring the old right-click menu...' -ForegroundColor Green
                reg add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve
            }
            else {
                # On Windows 10 skip this step with a warning
                Write-Host "[SetupScript - WARN] Restoring the old menu is not available on Windows 10." -ForegroundColor Yellow
            }
        }

        if ($SDarkMode -or $SAll) {
            Write-Host '[SetupScript - INFO] Applying dark mode...' -ForegroundColor Green
            # Apply dark theme (theme for Windows 11, App dark mode for Windows 10)
            if ((Get-CimInstance Win32_OperatingSystem).version.substring(5) -gt 21999) {
                c:\Windows\Resources\Themes\dark.theme
            }
            else {
                Set-Itemproperty -path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize' -Name 'AppsUseLightTheme' -Value 0
            }
        }


        Write-Host '[SetupScript - INFO] Installing specified Software...' -ForegroundColor Green
        if ($SSoftware -or $SAll) {

            # Install the specified software
            # Change/replace the winget.json to change the software that will be installed.
            if (Test-Path -Path $env:TEMP\SetupScript\winget.json) {
                Write-Host '[SetupScript - INFO] Importing the Winget JSON file...' -ForegroundColor Green
                winget import $env:TEMP\SetupScript\winget.json --accept-source-agreements --accept-package-agreements
            }
            else {
                Write-Host '[SetupScript - ERROR] Could not find JSON file for import. Skipping this step...' -ForegroundColor Green
            }
        }

        if ($SDiscord -or $SAll) {
            Write-Host '[SetupScript - INFO] Installing Discord...' -ForegroundColor Green
            # Installing discord separately since it requires special arguments
            winget install Discord.Discord --source winget --override "-s" --accept-source-agreements --accept-package-agreements
        }

        if ($SUpdateStoreApps -or $SAll) {
            Write-Host '[SetupScript - INFO] Kickstarting Windows Store Updates...' -ForegroundColor Green
            # Kickstart store updates
            Get-CimInstance -Namespace "Root\cimv2\mdm\dmmap" -ClassName "MDM_EnterpriseModernAppManagement_AppManagement01" | Invoke-CimMethod -MethodName UpdateScanMethod
        }

        if ($SVisualStudio -or $SAll) {

            # Visual studio
            # install Visual Studio with downloaded config
            if (Test-Path -Path $env:TEMP\SetupScript\.vsconfig) {
                Write-Host '[SetupScript - INFO] Installing Visual Studio with .vsconfig file...' -ForegroundColor Green
                winget install Microsoft.VisualStudio.2022.Community --override "--passive --config %temp%\SetupScript\.vsconfig" --accept-source-agreements --accept-package-agreements
            }
            else {
                Write-Host '[SetupScript - WARN] Could not find VSConfig file. Skipping this step...' -ForegroundColor Yellow
            }

        }


        if ($SPowerToysSettings -or $SAll) {
            if (Test-Path -Path $env:TEMP\SetupScript\powertoys.zip) {
                Write-Host '[SetupScript - INFO] Extracting PowerToys settings...' -ForegroundColor Green
                # PowerToys config copying
                # Kill PowerToys to make the files available
                taskkill /IM powertoys.exe /f
                Start-Sleep 2
                # Extract archive to appdata folder
                Expand-Archive -Path $env:TEMP\SetupScript\PowerToys.zip -DestinationPath $env:APPDATA\..\Local\Microsoft\PowerToys -Force
            }
            else {
                Write-Host '[SetupScript - WARN] Could not find PowerToys zip file. Skipping this step...' -ForegroundColor Yellow
            }
        }

        if ($SWindowsTerminal -or $SAll) {
            # Check if the Windows Terminal config exists
            if (Test-Path -Path $env:TEMP\SetupScript\settings.json) {
                # Copy the file if it exists
                Write-Host '[SetupScript - INFO] Copying Windows Terminal Settings...' -ForegroundColor Green
                Copy-Item $env:TEMP\SetupScript\settings.json $env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState

            }
            else {
                # Skip with warning if the config file is not found
                Write-Host '[SetupScript - WARN] Could not find Windows Terminal settings file. Skipping this step...' -ForegroundColor Yellow
            }
        }


        if ($SRemoveBloat -or $SAll) {

            # Remove bloatware
            Write-Host "[SetupScript - INFO] Removing bloatware..." -ForegroundColor Green
            Get-AppxPackage *skypeapp* | Remove-AppxPackage
            Get-AppxPackage *solitairecollection* | Remove-AppxPackage
        }

        if ($SShortcutCopying -or $SAll) {
            # Copy shortcuts for portable applications
            Write-Host '[SetupScript - INFO] Copying shortcuts. (Make sure onedrive has downloaded them!)' -ForegroundColor Green
            Copy-Item $env:USERPROFILE\OneDrive\Programme\*.lnk $env:USERPROFILE\AppData\Roaming\Microsoft\Windows\Start` Menu\Programs
        }

        # Delete remaining files that are no longer needed, including the temp directory
        Write-Host '[SetupScript - INFO] Cleaning up...' -ForegroundColor Green
        Remove-Item -r $env:TEMP\SetupScript
        Write-Host '[SetupScript - INFO] Setup has been completed. Press any key to exit.' -ForegroundColor Green
        Write-Host '[SetupScript - INFO] You may need to reboot for all changes to take effect.' -ForegroundColor Green
        # Change Title to completed
        $host.ui.RawUI.WindowTitle = "Setup Script: Completed"
    }
}

SetupMachine