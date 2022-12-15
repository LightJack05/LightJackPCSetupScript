# Intended to run the script with just a one-liner.
# Run this command:
# $Command = curl https://raw.githubusercontent.com/LightJack05/LightJackPCSetupScript/main/DownloadRun.ps1 -UseBasicParsing; Invoke-Expression $Command

Write-Host '[SetupScript - INFO] Creating temporary directory and cloning required files...' -ForegroundColor Green

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
    Write-Host '[SetupScript - ERROR] Failed to create temp directory at %temp%\SetupScript.' -ForegroundColor Red
    Write-Host '[SetupScript - ERROR] Unable to continue. Script will exit.' -ForegroundColor Red
    Pause
    Exit
}

curl https://raw.githubusercontent.com/LightJack05/LightJackPCSetupScript/main/main.ps1 -o $env:TEMP\SetupScript\main.ps1
curl https://raw.githubusercontent.com/LightJack05/LightJackPCSetupScript/main/setup.ps1 -o $env:TEMP\SetupScript\setup.ps1
curl https://raw.githubusercontent.com/LightJack05/LightJackPCSetupScript/main/RunMeAsAdmin.bat -o $env:TEMP\SetupScript\RunMeAsAdmin.bat

if ((Test-Path -Path $env:TEMP\SetupScript\main.ps1) -and (Test-Path -Path $env:TEMP\SetupScript\setup.ps1) -and (Test-Path -Path $env:TEMP\SetupScript\RunMeAsAdmin.bat)) {
    Write-Host '[SetupScript - INFO] Successfully cloned files.' -ForegroundColor Green
}
else {
    Write-Host '[SetupScript - ERROR] Failed to download one or more required files.' -ForegroundColor DarkRed
    Write-Host '[SetupScript - ERROR] Unable to continue. Script will exit.' -ForegroundColor DarkRed
    Pause
    Exit
}


Start-Process $env:TEMP\SetupScript\RunMeAsAdmin.bat

Start-Sleep 3
