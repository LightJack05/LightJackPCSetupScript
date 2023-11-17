# Branch of my PC Setup Script
__NOTE: This is a branch of my PC Setup Script that is customized for Vimlark. To look at the standard version, please go to the 'main' branch.__

## Instructions for Vimlark
### Command

```powershell
$Command = curl https://raw.githubusercontent.com/LightJack05/LightJackPCSetupScript/Vim/DownloadRun.ps1 -UseBasicParsing; Invoke-Expression $Command
```
(This entire thing is one line)

### Execution
- Open a new Powershell as Admin
(Right click on Start > Windows PowerShell (Admin))
- Paste the command from above into the PowerShell Window (right click or Ctrl + V)

### Setup steps
- Winget installation (MS Store should pop up)
- Dark mode
- Software (specified in winget.json)
- Completion (Title changes to "Completed")

### Cancel execution
- Hit Ctrl + C, then confirm with 'Y'


## Available modules
By default the "-All" option is enabled in "DownloadRun.bat". You may change that on your own repository and choose from these components (Add -ComponentName to the command to add it, or -All to use all.):
* Software (-Software) installs general software specified in the winget.json.
* Discord (-Discord) installs Discord.
* Power Toys Settings (-PowerToysSettings) downloads a PowerToys.zip that contains powertoys settings and copies it into appdata.
* Visual Studio (-VisualStudio) downloads a .vsconfig from the repo and installs Visual Studio with that config.
* Update Store Apps (-UpdateStoreApps) kickstarts store updates upon execution.
* Dark Mode (-DarkMode) enables windows dark mode (Apps for Windows 10 and Dark Theme for Windows 11)
* Remove Bloatware (-RemoveBloat) removes Solitare and Skype
* Shortcut Copying (-ShortcutCopying) copies shortcuts from Onedrive into your start menu folder (very specific to my usecase.)
* Restore old right click menu (-RestoreOldRightClickMenu) restores the old right-click menu in Windows 11. (This step is skipped with a warning on Windows 10.)
* Windows Terminal settings copying (-WindowsTerminal) copies a settings.json for Windows Terminal into the config folder.

## Additional options
* Offline mode (-OfflineMode) will not download the files from the repo, but use the local files stored in %temp%\SetupScript\
* Careless Mode (-Careless) will run the script in a more careless manner. This is currently unused and will simply exit. This will also skip winget installation.
* All (-All) will use all components in the script.



## Wallpaper Credit
* Credit to @Mimik on Discord for the Wallpaper