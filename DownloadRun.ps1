# Intended to run the script with just a one-liner.
# Run this command:
# $Command = curl https://raw.githubusercontent.com/LightJack05/LightJackPCSetupScript/winget-script-to-json/DownloadRun.ps1 -UseBasicParsing; Invoke-Expression $Command

mkdir $env:TEMP\SetupScript
curl https://raw.githubusercontent.com/LightJack05/LightJackPCSetupScript/winget-script-to-json/main.ps1 -o $env:TEMP\SetupScript\main.ps1
curl https://raw.githubusercontent.com/LightJack05/LightJackPCSetupScript/winget-script-to-json/setup.ps1 -o $env:TEMP\SetupScript\setup.ps1
curl https://raw.githubusercontent.com/LightJack05/LightJackPCSetupScript/winget-script-to-json/RunMeAsAdmin.bat -o $env:TEMP\SetupScript\RunMeAsAdmin.bat
Start-Process $env:TEMP\SetupScript\RunMeAsAdmin.bat

Start-Sleep 3
