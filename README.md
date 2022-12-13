# My PC setup script.
This is the script I use for setting up my PC.
It's a simple Powershell script that you can modify for your own usecase.

## Usecase
The script is intended to make setup of a new machine or a new Windows install easier. It can install programs, change settings, change themes, start updates, etc. Basically everything you can do from powershell.

## Using the script for yourself
The script is intended to be used together with a Github repo. It will download itself and the required files from there.
1. Create a new Github repo or fork mine.
2. Get the raw links for the required files. (Click on the file > Raw > Copy the link)
    * RunMeAsAdmin.bat
    * main.ps1
    * setup.ps1
    * Other files you might need (e.g. PowerToys.zip, .vsconfig, etc.)
3. Replace the default links with yours in the following files:
    * DownloadRun.bat (4 lines, watch the commented out one-liner)
    * main.ps1 (4 lines)

## Changing the things the script does.
By default the "-All" option is enabled in "DownloadRun.bat". You may change that on your own repository and choose from these components (Add -ComponentName to the command to add it, or -All to use all.):
* Software (-Software) installs software specified in the winget.json.
* Discord (-Discord) installs Discord.
* Power Toys Settings (-PowerToysSettings) downloads a PowerToys.zip that contains powertoys settings and copies it into appdata.
* Visual Studio (-VisualStudio) downloads a .vsconfig from the repo and installs Visual Studio with that config.
* Update Store Apps (-UpdateStoreApps) kickstarts store updates upon execution.
* Dark Mode (-DarkMode) enables windows dark mode (Apps for Windows 10 and Dark Theme for Windows 11)
* Remove Bloatware (-RemoveBloat) removes Solitare and Skype
* Shortcut Copying (-ShortcutCopying) copies shortcuts from Onedrive into your start menu folder (very specific to my usecase.)
* Restore old right click menu (-RestoreOldRightClickMenu) restores the old right-click menu in Windows 11. (This step is skipped with a warning on Windows 10.)

## Additional Options
* Offline mode (-OfflineMode) will not download the files from the repo, but use the local files stored in %temp%\SetupScript\
* Careless Mode (-Careless) will run the script in a more careless manner. This is currently unused and will simply exit. This will also skip winget installation.
* All (-All) will use all components in the script.

## Using the script
The script contains a one-liner in the file "DownloadRun.bat" (note that the link has to be changed to your repo) that is written as a comment. Copy that (without the '#') and put it in a powershell (admin) and hit enter. It will download the script and execute it.
