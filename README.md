# My PC setup script.
This is the script I use for setting up my PC.
It's a simple Powershell script that you can modify for your own usecase.

## Usecase
The script is intended to make setup of a new machine or a new Windows install easier. It can install programs, change settings, change themes, start updates, etc. Basically everything you can do from powershell!

## Modifying the script
The script is intended to be used together with a Github repo. It will download itself and the required files from there.
1. Create a new Github repo or fork mine.
2. Get the raw links for the required files. (Click on the file > Raw > Copy the link)
    * RunMeAsAdmin.bat
    * main.ps1
    * Other files you might need (e.g. PowerToys.zip, .vsconfig, etc.)
3. Replace the default links with yours in the following files:
    * DownloadRun.bat (2 lines)
    * main.ps1 (2 lines)
4. Add your own software
    * Software that will be installed is specified in main.ps1 in a big block of winget commands. Change the product identifiers to the software you need.
5. By default the script will also download updates and enable dark mode, among other things. You may disable anything you don't need by deleting it or adding a comment infront of it with '#'.

## Using the script
The script contains a one-liner in the file "DownloadRun.bat" that is written as a comment. Copy that (without the '#') and put it in a powershell (admin) and hit enter. It will download the script and execute it.