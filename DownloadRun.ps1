# Intended to run the script with just a one-liner.
# Run this command:
# $Command = curl https://raw.githubusercontent.com/LightJack05/LightJackPCSetupScript/Vim-Development/DownloadRun.ps1 -UseBasicParsing; Invoke-Expression $Command

Write-Host '[SetupScript - INFO] Creating temporary directory and cloning required files...' -ForegroundColor Green

# Create temp directory. If it already exists, delete it and recreate it.
if (!(Test-Path -Path $env:TEMP\SetupScript)) {
    mkdir $env:TEMP\SetupScript
}
else {
    Write-Host '[SetupScript - WARN] %temp%\SetupScript already exists. Burning it to the ground...' -ForegroundColor Yellow
    Remove-Item -r $env:TEMP\SetupScript
    if (!(Test-Path -Path $env:TEMP\SetupScript)) {
        Write-Host '[SetupScript - INFO] Creating temporary directory...' -ForegroundColor Green
        mkdir $env:TEMP\SetupScript
    }
    else {
        # If unable to delete existing directory, error out.
        Write-Host '[SetupScript - ERROR] Failed to delete existing directory.' -ForegroundColor Red
        Write-Host '[SetupScript - ERROR] Unable to continue. Script will exit.' -ForegroundColor Red
        Pause
        Exit
    }
}

if ((Test-Path -Path $env:TEMP\SetupScript)) {
    Write-Host '[SetupScript - INFO] Successfully created directory.' -ForegroundColor Green
}
else {
    # If unable to create new directory, error out.
    Write-Host '[SetupScript - ERROR] Failed to create temp directory at %appdata%\SetupScript.' -ForegroundColor Red
    Write-Host '[SetupScript - ERROR] Unable to continue. Script will exit.' -ForegroundColor Red
    Pause
    Exit
}
# Download core script files
curl https://raw.githubusercontent.com/LightJack05/LightJackPCSetupScript/Vim-Development/main.ps1 -o $env:TEMP\SetupScript\main.ps1
curl https://raw.githubusercontent.com/LightJack05/LightJackPCSetupScript/Vim-Development/setup.ps1 -o $env:TEMP\SetupScript\setup.ps1
curl https://raw.githubusercontent.com/LightJack05/LightJackPCSetupScript/Vim-Development/RunMeAsAdmin.bat -o $env:TEMP\SetupScript\RunMeAsAdmin.bat
curl https://raw.githubusercontent.com/LightJack05/LightJackPCSetupScript/Vim-Development/Wallpaper.jpg -o $env:TEMP\SetupScript\Wallpaper.jpg

# Check if all files have been downloaded
if ((Test-Path -Path $env:TEMP\SetupScript\main.ps1) -and (Test-Path -Path $env:TEMP\SetupScript\setup.ps1) -and (Test-Path -Path $env:TEMP\SetupScript\RunMeAsAdmin.bat)) {
    Write-Host '[SetupScript - INFO] Successfully cloned files.' -ForegroundColor Green
}
else {
    Write-Host '[SetupScript - ERROR] Failed to download one or more required files.' -ForegroundColor DarkRed
    Write-Host '[SetupScript - ERROR] Unable to continue. Script will exit.' -ForegroundColor DarkRed
    Pause
    Exit
}

# Start the bat file to avoid Windows execution policy
Start-Process $env:TEMP\SetupScript\RunMeAsAdmin.bat

Start-Sleep 3
