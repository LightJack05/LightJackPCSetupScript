param (
    [switch]$All = $false,
    [switch]$Software = $false,
    [switch]$PowerToysSettings = $false,
    [switch]$VisualStudio = $false,
    [switch]$UpdateStoreApps = $false,
    [switch]$DarkMode = $false,
    [switch]$RemoveBloat = $false,
    [switch]$ShortcutCopying = $false,
    [switch]$OfflineMode = $false,
    [switch]$Careless = $false
)


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
        Write-Host "You are running in -Careless mode. There currently are no actions configured." -ForegroundColor Red
        Write-Host 'Cleaning up...'
        Remove-Item -r $env:TEMP\SetupScript
        Write-Host 'Setup has been completed. Press any key to exit.'

    }
    else {
        if (!$OfflineMode) {
            if ($Software -or $All) {
                # Install the specified software (specified directly in the script)

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
            }

            if ($UpdateStoreApps -or $All) {
                # Kickstart store updates
                Get-CimInstance -Namespace "Root\cimv2\mdm\dmmap" -ClassName "MDM_EnterpriseModernAppManagement_AppManagement01" | Invoke-CimMethod -MethodName UpdateScanMethod
            }

            if ($VisualStudio -or $All) {
                # Visual studio
                # install Visual Studio with downloaded config
                winget install Microsoft.VisualStudio.2022.Community --override "--passive --config %temp%\SetupScript\.vsconfig" --accept-source-agreements --accept-package-agreements
            }
        }

        if ($PowerToysSettings -or $All) {


            # PowerToys config copying
            # Kill PowerToys to make the files available
            taskkill /IM powertoys.exe /f
            Start-Sleep 2
            # Extract archive to appdata folder
            Expand-Archive -Path $env:TEMP\SetupScript\PowerToys.zip -DestinationPath $env:APPDATA\..\Local\Microsoft\ -Force
        }




        # Update installed desktop applications
        #Write-Host "Updating currently installed software"
        #winget upgrade --all


        Write-Host 'Changing Settings...'
        if ($DarkMode -or $All) {
            # Apply dark theme (theme for Windows 11, App dark mode for Windows 10)
            if ((Get-CimInstance Win32_OperatingSystem).version.substring(5) -gt 21999) {
                c:\Windows\Resources\Themes\dark.theme
            }
            else {
                Set-Itemproperty -path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize' -Name 'AppsUseLightTheme' -Value 0
            }
        }

        if ($RemoveBloat -or $All) {

            # Remove bloatware
            Write-Host "Removing bloatware..."
            Get-AppxPackage *skypeapp* | Remove-AppxPackage
            Get-AppxPackage *solitairecollection* | Remove-AppxPackage
        }

        if ($ShortcutCopying -or $All) {
            # Copy shortcuts for portable applications
            Write-Host 'Copying shortcuts. (Make sure onedrive has downloaded them!)'
            Copy-Item $env:USERPROFILE\OneDrive\Programme\*.lnk $env:USERPROFILE\AppData\Roaming\Microsoft\Windows\Start` Menu\Programs
        }

        # Delete remaining files that are no longer needed, including the temp directory
        Write-Host 'Cleaning up...'
        Remove-Item -r $env:TEMP\SetupScript
        Write-Host 'Setup has been completed. Press any key to exit.'


    }
}

SetupMachine