Set-ExecutionPolicy Bypass -Force


                         
$regPathExplorer         = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer"
$regPathExplorerAdv      = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
$regPathExplorerTaskband = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband"
$regPathFeeds            = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds"
$regPathPolicies         = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies"
$regPathPoliciesExplorer = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"
$regPathSearch           = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search"


$regPathDefaultAccount   = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount"

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



#endregion


#region quick access cleanup

    $pathAutomaticDestinations = "$env:APPDATA\Microsoft\Windows\Recent\AutomaticDestinations"
    Remove-Item -Path $pathAutomaticDestinations\* -Recurse -force


#endregion


 #region multitask

    #disable SnapAssist
    Set-ItemProperty -Path $regPathExplorerAdv -Name SnapAssist -Value 0


#endregion




#region clear start menu

$START_MENU_LAYOUT = @"
<LayoutModificationTemplate xmlns:defaultlayout="http://schemas.microsoft.com/Start/2014/FullDefaultLayout" xmlns:start="http://schemas.microsoft.com/Start/2014/StartLayout" Version="1" xmlns:taskbar="http://schemas.microsoft.com/Start/2014/TaskbarLayout" xmlns="http://schemas.microsoft.com/Start/2014/LayoutModification">
    <LayoutOptions StartTileGroupCellWidth="6" />
    <DefaultLayoutOverride>
        <StartLayoutCollection>
            <defaultlayout:StartLayout GroupCellWidth="6" />
        </StartLayoutCollection>
    </DefaultLayoutOverride>
</LayoutModificationTemplate>
"@

$layoutFile="C:\Windows\StartMenuLayout.xml"

#Delete layout file if it already exists
If(Test-Path $layoutFile)
{
    Remove-Item $layoutFile
}

#Creates the blank layout file
$START_MENU_LAYOUT | Out-File $layoutFile -Encoding ASCII

$regAliases = @("HKLM", "HKCU")

#Assign the start layout and force it to apply with "LockedStartLayout" at both the machine and user level
foreach ($regAlias in $regAliases){
    $basePath = $regAlias + ":\SOFTWARE\Policies\Microsoft\Windows"
    $keyPath = $basePath + "\Explorer" 
    IF(!(Test-Path -Path $keyPath)) { 
        New-Item -Path $basePath -Name "Explorer"
    }
    Set-ItemProperty -Path $keyPath -Name "LockedStartLayout" -Value 1
    Set-ItemProperty -Path $keyPath -Name "StartLayoutFile" -Value $layoutFile
}

#Restart Explorer, open the start menu (necessary to load the new layout), and give it a few seconds to process
Stop-Process -name explorer
Start-Sleep -s 5
$wshell = New-Object -ComObject wscript.shell; $wshell.SendKeys('^{ESCAPE}')
Start-Sleep -s 5

#Enable the ability to pin items again by disabling "LockedStartLayout"
foreach ($regAlias in $regAliases){
    $basePath = $regAlias + ":\SOFTWARE\Policies\Microsoft\Windows"
    $keyPath = $basePath + "\Explorer" 
    Set-ItemProperty -Path $keyPath -Name "LockedStartLayout" -Value 0
}

#Restart Explorer and delete the layout file
Stop-Process -name explorer


#endregion



##https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-gppref/3c837e92-016e-4148-86e5-b4f0381a757f
##https://ss64.com/nt/syntax-reghacks.html



<# Optional removal

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
 
 
 
 
 Get-Process -Name explorer | Stop-Process


#>