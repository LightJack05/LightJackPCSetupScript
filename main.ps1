# Welcome, thank you for downloading. See the instructions below and in-line for extending the script functionality
# Please take a moment and look at the license on the Git Repo: [blank]
#
# This script is intended to set up a Windows 10 computer for the first time after a reset.
# It was written for Vimlark and is suited to his specific needs. Feel free to modify it for your specific usecase.
# It should be run as admin to avoid interruptions by UAC prompts, but doesn't have to.
# It requires the winget package manager to be installed at runtime or before starting.
#
#
# Setup Script by LightJack05




function Main {
    Write-Output "Welcome! Please press any key to begin setup..."
    Clear-Host
    $Host.UI.RawUI.ReadKey()

    $cmdName = "winget"
    if (Get-Command $cmdName -errorAction SilentlyContinue) {
        Clear-Host
        Write-Output 'Winget found!'
    }
    else {
        Write-Host 'This script requires the latest version of the Windows package manager "winget", which was not found on this machine.'
        Write-Host 'To install it, please install the latest updates from the Microsoft Store.'
        Write-Host ''
        Write-Host 'Follow the appropriate instructions for your Winodws Store Version:'
        Write-Host 'Old Ms Store (Default Included Version 11910.1002.5.0):'
        Write-Host 'Go To ... > Downloads and Updates > Get Updates'
        Write-Host 'New Ms Store (Currently Version 22210.1401.6.0 or later):'
        Write-Host 'Go To Library > Get Updates'
        Write-Host ''
        Write-Host 'This script will wait until winget is found...'
        Write-Host ''
        WaitForWinget
    }
}

function WaitForWinget {
    while ($true) {
        Start-Sleep 5
        $cmdName = "winget"
        if (Get-Command $cmdName -errorAction SilentlyContinue) {
            Clear-Host
            Write-Output 'Winget Found!'
            SetupMachine
        }

    }

}

function SetupMachine {

    Write-Output 'Initiating Setup...'
    Write-Output 'Installing Software'
    winget install Google.Chrome

    Write-Output 'Changing Settings...'

}







