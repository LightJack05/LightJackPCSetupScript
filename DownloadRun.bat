# Intended to run the script with just a one-liner.

mkdir %temp%\SetupScript
curl https://raw.githubusercontent.com/LightJack05/LightJackPCSetupScript/main/main.ps1 -o %temp%\SetupScript\main.ps1
curl https://raw.githubusercontent.com/LightJack05/LightJackPCSetupScript/main/RunMeAsAdmin.bat -o %temp%\SetupScript\RunMeAsAdmin.bat
cmd -c "%temp%\SetupScript\RunMeAsAdmin.bat"

sleep 3

rmdir -r %temp%\SetupScript