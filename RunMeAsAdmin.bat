@echo off
powershell.exe -ExecutionPolicy Bypass -File %0\..\main.ps1
rmdir -r %temp%\SetupScript
Pause