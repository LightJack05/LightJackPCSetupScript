# Intended to run the script with just a one-liner.
# Run this command:
# $Command = curl https://raw.githubusercontent.com/LightJack05/LightJackPCSetupScript/separate-setup-script/DownloadRun.ps1 -UseBasicParsing; Invoke-Expression $Command

mkdir $env:TEMP\SetupScript
curl https://raw.githubusercontent.com/LightJack05/LightJackPCSetupScript/separate-setup-script/main.ps1 -o $env:TEMP\SetupScript\main.ps1
curl https://raw.githubusercontent.com/LightJack05/LightJackPCSetupScript/separate-setup-script/RunMeAsAdmin.bat -o $env:TEMP\SetupScript\setup.ps1
curl https://raw.githubusercontent.com/LightJack05/LightJackPCSetupScript/separate-setup-script/RunMeAsAdmin.bat -o $env:TEMP\SetupScript\RunMeAsAdmin.bat
Start-Process $env:TEMP\SetupScript\RunMeAsAdmin.bat

Start-Sleep 3
