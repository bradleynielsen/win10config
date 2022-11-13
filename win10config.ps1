Set-ExecutionPolicy Bypass -Force


                         
$regPathExplorer         = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer"
$regPathExplorerAdv      = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
$regPathExplorerTaskband = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband"
$regPathFeeds            = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds"
$regPathPolicies         = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies"
$regPathPoliciesExplorer = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"
$regPathSearch           = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search"

#region Taskbar 

    #show all in tray
    Set-ItemProperty -Path $regPathExplorer -Name EnableAutoTray -Value 0 

    #ShowRecent in quick access
    Set-ItemProperty -Path $regPathExplorer -Name ShowRecent -Value 0 

    #ShowFrequent in quick access
    Set-ItemProperty -Path $regPathExplorer -Name ShowFrequent -Value 0 



    #Launch explorer To this computer
    Set-ItemProperty -Path $regPathExplorerAdv -Name LaunchTo -Value 1 

    #show file extensions
    Set-ItemProperty -Path $regPathExplorerAdv -Name HideFileExt -Value 0 

    #show ControlPanel
    Set-ItemProperty -Path $regPathExplorerAdv -Name showControlPanel -Value 1 

    #Never combine Taskbar icons
    Set-ItemProperty -Path $regPathExplorerAdv -Name TaskbarGlomLevel -Value 2 

    #hide cortana
    Set-ItemProperty -Path $regPathExplorerAdv -Name ShowCortanaButton -Value 0 

    #hide TaskViewButton 
    Set-ItemProperty -Path $regPathExplorerAdv -Name ShowTaskViewButton -Value 0 


    #remove icons on taskbar
    Remove-Item -Path $regPathExplorerTaskband 


    #ShellFeedsTaskbarViewMode 
    Set-ItemProperty -Path $regPathFeeds -Name ShellFeedsTaskbarViewMode -Value 2


    #hide meet now
    New-Item -Path $regPathPolicies -Name "Explorer" -Force
    New-ItemProperty -Path $regPathPoliciesExplorer -Name "HideSCAMeetNow" -PropertyType DWord -Value "1"




    ## Restore the Classic Taskbar in Windows 11
    #New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell\Update\Packages" -Name "UndockingDisabled" -PropertyType DWord -Value "00000001";
    #Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell\Update\Packages" -Name "UndockingDisabled" -Value "00000001";

    # Disable Taskbar / Cortana Search Box on Windows 11
    New-ItemProperty -Path $regPathSearch -Name "SearchboxTaskbarMode" -PropertyType DWord -Value "00000000"
    Set-ItemProperty -Path $regPathSearch -Name "SearchboxTaskbarMode" -Value "00000000"


    Get-Process -Name explorer | Stop-Process

#endregion


#region quick access cleanup

    $pathAutomaticDestinations = "$env:APPDATA\Microsoft\Windows\Recent\AutomaticDestinations"
    Remove-Item -Path $pathAutomaticDestinations\* -Recurse -force


#endregion


 #region multitask

    #disable SnapAssist
    Set-ItemProperty -Path $regPathExplorerAdv -Name SnapAssist -Value 0


#endregion








##https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-gppref/3c837e92-016e-4148-86e5-b4f0381a757f
##https://ss64.com/nt/syntax-reghacks.html



<#

#region remove bloat

    Get-AppxPackage -Name *BingWeather*       | Remove-AppPackage
    Get-AppxPackage -Name *Microsoft3DViewer* | Remove-AppPackage
    Get-AppxPackage -Name *SkypeApp*          | Remove-AppPackage
    Get-AppxPackage -Name *ZuneMusic*         | Remove-AppPackage
    Get-AppxPackage -Name *ZuneVideo*         | Remove-AppPackage
    Get-AppxPackage -Name *YourPhone*         | Remove-AppPackage



#endregion

#region 3D Objects

    #Remove 3D Objects From This PC
    Remove-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" -ErrorAction SilentlyContinue


#endregion

# Disable Taskbar / Cortana Search Box on Windows 11
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -PropertyType DWord -Value "00000000";
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Value "00000000";


#>