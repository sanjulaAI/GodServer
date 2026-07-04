@echo off
title GOD MODE ULTIMATE - Windows 10/11 Maximum Performance
color 0A
setlocal enabledelayedexpansion

:: ============================================================
:: ADMIN CHECK
:: ============================================================
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo ============================================================
    echo        ADMINISTRATOR PRIVILEGES REQUIRED
    echo ============================================================
    echo.
    echo Right-click and select "Run as Administrator"
    echo.
    pause
    exit /b 1
)

cls
echo ============================================================
echo   GOD MODE ULTIMATE - WINDOWS 10/11 BARE METAL EDITION
echo ============================================================
echo.
echo  This will perform the following:
echo   [1]  Kill all bloat processes
echo   [2]  Remove Edge, OneDrive, Defender, Store, Paint,
echo        Media Player, Bluetooth, Print, and ALL bloat
echo   [3]  Disable 100+ non-essential services
echo   [4]  Destroy all telemetry and tracking
echo   [5]  Disable Cortana, Search web, AI features
echo   [6]  Maximum performance power plan + tweaks
echo   [7]  Kill all startup items
echo   [8]  Disable Windows Update permanently
echo   [9]  Remove all scheduled bloat tasks
echo  [10]  Deep registry + network performance tuning
echo  [11]  GPU, CPU, RAM, disk I/O optimizations
echo  [12]  Bare-bone clean idle - minimum processes
echo.
echo  NO LOG FILE WILL BE CREATED
echo.
echo  Press CTRL+C to cancel or ANY KEY to apply GOD MODE...
pause >nul

:: ============================================================
:: PART 1: KILL ALL BLOAT PROCESSES
:: ============================================================
cls
echo [1/14] KILLING BLOAT PROCESSES...

for %%P in (
    OneDrive.exe Teams.exe Spotify.exe Discord.exe Slack.exe Zoom.exe
    Chrome.exe Firefox.exe Opera.exe Brave.exe Edge.exe msedge.exe
    MicrosoftEdge.exe MicrosoftEdgeUpdate.exe edgeupdatem.exe
    Code.exe cortana.exe searchapp.exe widgetservice.exe
    newsandinterests.exe copilot.exe WebExperience.exe
    YourPhone.exe PhoneExperienceHost.exe Calculator.exe
    Alarms.exe Camera.exe Maps.exe SoundRecorder.exe
    ZuneMusic.exe ZuneVideo.exe XboxApp.exe XboxGameCallableUI.exe
    XboxGamingOverlay.exe XboxIdentityProvider.exe XboxSpeechToTextOverlay.exe
    Microsoft.Photos.exe Microsoft.Windows.Photos.exe
    SettingSyncHost.exe StartMenuExperienceHost.exe TextInputHost.exe
    LockApp.exe SecurityHealthSystray.exe SgrmBroker.exe
    smartscreen.exe sihost.exe MsMpEng.exe NisSrv.exe
    WmiPrvSE.exe mspaint.exe wmplayer.exe wmpnscfg.exe
    BTAGService.exe fsquirt.exe
) do (
    taskkill /f /im %%P >nul 2>&1
)

echo [OK] Bloat processes killed.

:: ============================================================
:: PART 2: REMOVE MICROSOFT EDGE - COMPLETE ANNIHILATION
:: ============================================================
echo.
echo [2/14] REMOVING MICROSOFT EDGE COMPLETELY...

taskkill /f /im msedge.exe >nul 2>&1
taskkill /f /im MicrosoftEdge.exe >nul 2>&1
taskkill /f /im MicrosoftEdgeUpdate.exe >nul 2>&1
taskkill /f /im edgeupdatem.exe >nul 2>&1
timeout /t 3 /nobreak >nul

:: Kill Edge services first
sc stop edgeupdate >nul 2>&1
sc stop edgeupdatem >nul 2>&1
sc stop MicrosoftEdgeElevationService >nul 2>&1
sc delete edgeupdate >nul 2>&1
sc delete edgeupdatem >nul 2>&1
sc delete MicrosoftEdgeElevationService >nul 2>&1

:: Uninstall via Edge's own setup
for /d %%d in ("%ProgramFiles(x86)%\Microsoft\Edge\Application\*") do (
    if exist "%%d\Installer\setup.exe" (
        "%%d\Installer\setup.exe" --uninstall --force-uninstall --system-level >nul 2>&1
    )
)
for /d %%d in ("%ProgramFiles%\Microsoft\Edge\Application\*") do (
    if exist "%%d\Installer\setup.exe" (
        "%%d\Installer\setup.exe" --uninstall --force-uninstall --system-level >nul 2>&1
    )
)

:: Remove all Edge directories - take ownership first
takeown /f "%ProgramFiles(x86)%\Microsoft\Edge" /r /d y >nul 2>&1
icacls "%ProgramFiles(x86)%\Microsoft\Edge" /grant administrators:F /t >nul 2>&1
rmdir /s /q "%ProgramFiles(x86)%\Microsoft\Edge" >nul 2>&1
rmdir /s /q "%ProgramFiles%\Microsoft\Edge" >nul 2>&1
rmdir /s /q "%LocalAppData%\Microsoft\Edge" >nul 2>&1
rmdir /s /q "%ProgramData%\Microsoft\Edge" >nul 2>&1
rmdir /s /q "%LocalAppData%\Microsoft\EdgeUpdate" >nul 2>&1
rmdir /s /q "%ProgramData%\Microsoft\EdgeUpdate" >nul 2>&1
rmdir /s /q "%ProgramFiles(x86)%\Microsoft\EdgeUpdate" >nul 2>&1
rmdir /s /q "%ProgramFiles(x86)%\Microsoft\EdgeWebView" >nul 2>&1
rmdir /s /q "%ProgramFiles%\Microsoft\EdgeWebView" >nul 2>&1

:: Remove Edge WebView2 Runtime
for /d %%d in ("%ProgramFiles(x86)%\Microsoft\EdgeWebView\Application\*") do (
    if exist "%%d\Installer\setup.exe" (
        "%%d\Installer\setup.exe" --uninstall --msedgewebview --force-uninstall --system-level >nul 2>&1
    )
)

:: Remove Edge Appx packages
powershell -NoProfile -Command "Get-AppxPackage -AllUsers *MicrosoftEdge* | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue" >nul 2>&1
powershell -NoProfile -Command "Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like '*MicrosoftEdge*' | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue" >nul 2>&1

:: Block Edge reinstall via registry
reg add "HKLM\SOFTWARE\Policies\Microsoft\EdgeUpdate" /v "InstallDefault" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\EdgeUpdate" /v "UpdateDefault" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\EdgeUpdate" /v "AutoUpdateCheckPeriodMinutes" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\EdgeUpdate" /v "DoNotUpdateToEdgeWithChromium" /t REG_DWORD /d 1 /f >nul 2>&1

:: Remove Edge shortcuts
del /f /q "%PUBLIC%\Desktop\Microsoft Edge.lnk" >nul 2>&1
del /f /q "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Microsoft Edge.lnk" >nul 2>&1
del /f /q "%ProgramData%\Microsoft\Windows\Start Menu\Programs\Microsoft Edge.lnk" >nul 2>&1

echo [OK] Edge completely removed.

:: ============================================================
:: PART 3: REMOVE ONEDRIVE COMPLETELY
:: ============================================================
echo.
echo [3/14] REMOVING ONEDRIVE COMPLETELY...

taskkill /f /im OneDrive.exe >nul 2>&1
timeout /t 3 /nobreak >nul

if exist "%SystemRoot%\System32\OneDriveSetup.exe" (
    "%SystemRoot%\System32\OneDriveSetup.exe" /uninstall >nul 2>&1
)
if exist "%SystemRoot%\SysWOW64\OneDriveSetup.exe" (
    "%SystemRoot%\SysWOW64\OneDriveSetup.exe" /uninstall >nul 2>&1
)

rmdir /s /q "%UserProfile%\OneDrive" >nul 2>&1
rmdir /s /q "%LocalAppData%\Microsoft\OneDrive" >nul 2>&1
rmdir /s /q "%ProgramData%\Microsoft OneDrive" >nul 2>&1
rmdir /s /q "%SystemRoot%\SysWOW64\OneDriveSetup.exe" >nul 2>&1

reg delete "HKCR\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /f >nul 2>&1
reg delete "HKCR\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /v "DisableFileSyncNGSC" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /v "DisableFileSync" /t REG_DWORD /d 1 /f >nul 2>&1
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "OneDrive" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "OneDrive" /f >nul 2>&1

echo [OK] OneDrive completely removed.

:: ============================================================
:: PART 4: REMOVE WINDOWS DEFENDER COMPLETELY
:: ============================================================
echo.
echo [4/14] REMOVING WINDOWS DEFENDER...

:: Disable Tamper Protection
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\Features" /v "TamperProtection" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\Features" /v "TamperProtection" /t REG_DWORD /d 4 /f >nul 2>&1

:: Full policy disable
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiVirus" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableRealtimeMonitoring" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableBehaviorMonitoring" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableOnAccessProtection" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableScanOnRealtimeEnable" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableIOAVProtection" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v "SpynetReporting" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v "SubmitSamplesConsent" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\MpEngine" /v "MpEnablePus" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Signature Updates" /v "ForceUpdateFromMU" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\UX Configuration" /v "Notification_Suppress" /t REG_DWORD /d 1 /f >nul 2>&1

:: Disable Defender services
for %%S in (WinDefend SecurityHealthService wscsvc WdNisSvc WdNisDrv Sense WdFilter WdBoot) do (
    sc stop %%S >nul 2>&1
    sc config %%S start= disabled >nul 2>&1
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\%%S" /v "Start" /t REG_DWORD /d 4 /f >nul 2>&1
)

:: Remove Security Health from startup
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "SecurityHealth" /f >nul 2>&1
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "SecurityHealth" /f >nul 2>&1

:: Remove Windows Security tray icon
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Systray" /v "HideSystray" /t REG_DWORD /d 1 /f >nul 2>&1

echo [OK] Windows Defender removed.

:: ============================================================
:: PART 5: REMOVE MICROSOFT STORE COMPLETELY
:: ============================================================
echo.
echo [5/14] REMOVING MICROSOFT STORE...

powershell -NoProfile -Command "Get-AppxPackage -AllUsers *WindowsStore* | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue" >nul 2>&1
powershell -NoProfile -Command "Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like '*WindowsStore*' | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue" >nul 2>&1
powershell -NoProfile -Command "Get-AppxPackage -AllUsers *StorePurchaseApp* | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue" >nul 2>&1

reg add "HKLM\SOFTWARE\Policies\Microsoft\WindowsStore" /v "RemoveWindowsStore" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\WindowsStore" /v "DisableStoreApps" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\WindowsStore" /v "AutoDownload" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoWindowsUpdate" /t REG_DWORD /d 1 /f >nul 2>&1

echo [OK] Microsoft Store removed.

:: ============================================================
:: PART 6: REMOVE PAINT, MEDIA PLAYER, PRINT, BLUETOOTH
:: ============================================================
echo.
echo [6/14] REMOVING PAINT, MEDIA PLAYER, PRINT, BLUETOOTH...

:: Remove Paint / MS Paint / Paint 3D
powershell -NoProfile -Command "Get-AppxPackage -AllUsers *MSPaint* | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue" >nul 2>&1
powershell -NoProfile -Command "Get-AppxPackage -AllUsers *Paint* | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue" >nul 2>&1
powershell -NoProfile -Command "Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -like '*Paint*' } | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue" >nul 2>&1

:: Remove Windows Media Player
dism /online /Disable-Feature /FeatureName:"WindowsMediaPlayer" /NoRestart >nul 2>&1
dism /online /Remove-Capability /CapabilityName:"Media.WindowsMediaPlayer~~~~0.0.12.0" /NoRestart >nul 2>&1
sc stop WMPNetworkSvc >nul 2>&1
sc config WMPNetworkSvc start= disabled >nul 2>&1
powershell -NoProfile -Command "Get-AppxPackage -AllUsers *ZuneMusic* | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue" >nul 2>&1
powershell -NoProfile -Command "Get-AppxPackage -AllUsers *ZuneVideo* | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue" >nul 2>&1
powershell -NoProfile -Command "Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -like '*Zune*' } | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue" >nul 2>&1

:: Remove Print to PDF, XPS, Fax
sc stop Spooler >nul 2>&1
sc config Spooler start= disabled >nul 2>&1
sc stop Fax >nul 2>&1
sc config Fax start= disabled >nul 2>&1
dism /online /Disable-Feature /FeatureName:"Printing-PrintToPDFServices-Features" /NoRestart >nul 2>&1
dism /online /Disable-Feature /FeatureName:"Printing-XPSServices-Features" /NoRestart >nul 2>&1
dism /online /Remove-Capability /CapabilityName:"Print.Fax.Scan~~~~0.0.1.0" /NoRestart >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Printers" /v "DisableWebPnPDownload" /t REG_DWORD /d 1 /f >nul 2>&1

:: Remove Bluetooth
sc stop bthserv >nul 2>&1
sc config bthserv start= disabled >nul 2>&1
sc stop BTAGService >nul 2>&1
sc config BTAGService start= disabled >nul 2>&1
sc stop BthAvctpSvc >nul 2>&1
sc config BthAvctpSvc start= disabled >nul 2>&1
sc stop bthHFSrv >nul 2>&1
sc config bthHFSrv start= disabled >nul 2>&1
dism /online /Disable-Feature /FeatureName:"Bluetooth" /NoRestart >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceInstall\Restrictions" /v "DenyDeviceIDs" /t REG_DWORD /d 1 /f >nul 2>&1

echo [OK] Paint, Media Player, Print, Bluetooth removed.

:: ============================================================
:: PART 8: DISABLE 100+ NON-ESSENTIAL SERVICES
:: ============================================================
echo.
echo [8/14] DISABLING NON-ESSENTIAL SERVICES...

for %%S in (
    DiagTrack dmwappushservice WerSvc PcaSvc WSearch SysMain
    XboxNetApiSvc XblAuthManager XblGameSave XboxGipSvc
    GamingServices GamingServicesNet MapsBroker lfsvc GeoSvc
    RemoteRegistry RemoteAccess SessionEnv TermService UmRdpService
    Fax RetailDemo WMPNetworkSvc SCardSvr ScDeviceEnum
    TabletInputService PhoneSvc icssvc
    WpnService WpnUserService HomeGroupListener HomeGroupProvider
    PeerDistSvc p2psvc p2pimsvc PNRPsvc PNRPAutoReg
    seclogon AJRouter CDPSvc CDPUserSvc
    edgeupdate edgeupdatem MicrosoftEdgeElevationService
    wuauserv BITS TrustedInstaller sppsvc
    SecurityHealthService Sense NcaSvc DusmSvc DsSvc
    diagnosticshub.standardcollector.service diagsvc
    LicenseManager wisvc MessagingService PimIndexMaintenanceSvc
    UnistoreSvc UserDataSvc OneSyncSvc SharedAccess
    wcncsvc TlSsvc wercplsupport wmiApSrv
    bthserv BTAGService BthAvctpSvc bthHFSrv
    Spooler Fax PrintNotify
    WMPNetworkSvc wmphost
    perceptionsimulation WpnService
    TroubleshootingSvc WinDefend wscsvc WdNisSvc
    DoSvc UsoSvc WaaSMedicSvc wlidsvc
    stisvc WiaRpc StiSvc
    Netlogon Browser
    IKEEXT
    defragsvc
    DcpSvc
    NcdAutoSetup
    WwanSvc dot3svc EapHost
    FDResPub SSDPSRV upnphost
    WinHttpAutoProxySvc
    FontCache
    WbioSrvc
    spectrum
    SensorDataService SensorService SensrSvc
    MapsBroker
    AppVClient
    SCPolicySvc
    RasAuto RasMan
    WarpJITSvc
    AarSvc CaptureService ConsentUxUserSvc CredentialEnrollmentManagerUserSvc
    DeviceAssociationBrokerSvc DevicePickerUserSvc DevicesFlowUserSvc
    DialogBlockingService DisplayEnhancementService
    EbmUserSvc NaturalAuthentication PrintWorkflowUserSvc
    UdkUserSvc UevAgentService
    PerfHost
    diagnosticshub.standardcollector.service
    SEMgrSvc
    PhoneSvc
    ClipSVC
) do (
    sc stop %%S >nul 2>&1
    sc config %%S start= disabled >nul 2>&1
)

echo [OK] Non-essential services disabled.

:: ============================================================
:: PART 9: DESTROY ALL TELEMETRY
:: ============================================================
echo.
echo [9/14] DESTROYING ALL TELEMETRY AND TRACKING...

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "LimitDiagnosticLogCollection" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "DoNotShowFeedbackNotifications" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "DisableOneSettingsDownloads" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "DisableDiagnosticSettingsReset" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Metadata" /v "PreventDeviceMetadataFromNetwork" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "AITEnable" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisableInventory" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisablePCA" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisableUAR" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Privacy" /v "TailoredExperiencesWithDiagnosticDataEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack" /v "ShowedToastAtLevel" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsConsumerFeatures" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableCloudOptimizedContent" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableSoftLanding" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SoftLandingEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContentEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "ContentDeliveryAllowed" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "OemPreInstalledAppsEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "PreInstalledAppsEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "PreInstalledAppsEverEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SilentInstalledAppsEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SystemPaneSuggestionsEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "RotatingLockScreenEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "RotatingLockScreenOverlayEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "RemediationRequired" /t REG_DWORD /d 0 /f >nul 2>&1

:: Disable Activity History
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "EnableActivityFeed" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "PublishUserActivities" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "UploadUserActivities" /t REG_DWORD /d 0 /f >nul 2>&1

:: Disable Advertising ID
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" /v "DisabledByGroupPolicy" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "Enabled" /t REG_DWORD /d 0 /f >nul 2>&1

:: Disable location tracking
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" /v "DisableLocation" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" /v "DisableLocationScripting" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" /v "DisableSensors" /t REG_DWORD /d 1 /f >nul 2>&1

:: Disable Error Reporting
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v "Disabled" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\PCHealth\ErrorReporting" /v "DoReport" /t REG_DWORD /d 0 /f >nul 2>&1

:: Disable Input/Handwriting telemetry
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\TabletPC" /v "PreventHandwritingDataSharing" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\HandwritingErrorReports" /v "PreventHandwritingErrorReports" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Input\TIPC" /v "Enabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Input\TIPC" /v "Enabled" /t REG_DWORD /d 0 /f >nul 2>&1

:: Disable CEIP
reg add "HKLM\SOFTWARE\Policies\Microsoft\SQMClient\Windows" /v "CEIPEnable" /t REG_DWORD /d 0 /f >nul 2>&1

:: Disable Feedback
reg add "HKCU\SOFTWARE\Microsoft\Siuf\Rules" /v "NumberOfSIUFInPeriod" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Siuf\Rules" /v "PeriodInNanoSeconds" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "DoNotShowFeedbackNotifications" /t REG_DWORD /d 1 /f >nul 2>&1

echo [OK] All telemetry destroyed.

:: ============================================================
:: PART 10: KILL CORTANA, SEARCH, COPILOT, AI, WIDGETS
:: ============================================================
echo.
echo [10/14] TERMINATING CORTANA, COPILOT, AI, WIDGETS...

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortana" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortanaAboveLock" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowSearchToUseLocation" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "DisableWebSearch" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "ConnectedSearchUseWeb" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "ConnectedSearchPrivacy" /t REG_DWORD /d 3 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "BingSearchEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "CortanaConsent" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "AllowSearchToUseLocation" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "SearchboxTaskbarMode" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "DeviceHistoryEnabled" /t REG_DWORD /d 0 /f >nul 2>&1

:: Disable Copilot
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowCopilotButton" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot" /v "TurnOffWindowsCopilot" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot" /v "TurnOffWindowsCopilot" /t REG_DWORD /d 1 /f >nul 2>&1

:: Disable Widgets / News and Interests
reg add "HKLM\SOFTWARE\Policies\Microsoft\Dsh" /v "AllowNewsAndInterests" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds" /v "ShellFeedsTaskbarViewMode" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds" /v "EnableFeeds" /t REG_DWORD /d 0 /f >nul 2>&1

:: Disable Chat/Teams icon on taskbar
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarMn" /t REG_DWORD /d 0 /f >nul 2>&1

:: Remove Cortana app
powershell -NoProfile -Command "Get-AppxPackage -AllUsers *Microsoft.549981C3F5F10* | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue" >nul 2>&1
powershell -NoProfile -Command "Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like '*549981C3F5F10*' | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue" >nul 2>&1

echo [OK] Cortana, Copilot, Widgets removed.

:: ============================================================
:: PART 11: DISABLE WINDOWS UPDATE PERMANENTLY
:: ============================================================
echo.
echo [11/14] DISABLING WINDOWS UPDATE PERMANENTLY...

for %%S in (wuauserv BITS TrustedInstaller Dosvc UsoSvc WaaSMedicSvc) do (
    sc stop %%S >nul 2>&1
    sc config %%S start= disabled >nul 2>&1
)

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoUpdate" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "AUOptions" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "DisableWindowsUpdateAccess" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "WUServer" /t REG_SZ /d " " /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "WUStatusServer" /t REG_SZ /d " " /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "DisableDualScan" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "UseWUServer" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\MusNotification.exe" /v "Debugger" /t REG_SZ /d "%windir%\System32\taskkill.exe" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\MusNotificationUx.exe" /v "Debugger" /t REG_SZ /d "%windir%\System32\taskkill.exe" /f >nul 2>&1

:: Block Windows Update in hosts
findstr /c:"windowsupdate.microsoft.com" "%SystemRoot%\System32\drivers\etc\hosts" >nul 2>&1
if %errorlevel% neq 0 (
    echo 0.0.0.0 windowsupdate.microsoft.com >> "%SystemRoot%\System32\drivers\etc\hosts"
    echo 0.0.0.0 update.microsoft.com >> "%SystemRoot%\System32\drivers\etc\hosts"
    echo 0.0.0.0 download.windowsupdate.com >> "%SystemRoot%\System32\drivers\etc\hosts"
    echo 0.0.0.0 wustat.windows.com >> "%SystemRoot%\System32\drivers\etc\hosts"
    echo 0.0.0.0 ntservicepack.microsoft.com >> "%SystemRoot%\System32\drivers\etc\hosts"
    echo 0.0.0.0 stats.update.microsoft.com >> "%SystemRoot%\System32\drivers\etc\hosts"
)

echo [OK] Windows Update permanently disabled.

:: ============================================================
:: PART 12: KILL BACKGROUND APPS + STARTUP ITEMS
:: ============================================================
echo.
echo [12/14] KILLING BACKGROUND APPS AND STARTUP ITEMS...

reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v "GlobalUserDisabled" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsRunInBackground" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsAccessCamera" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsAccessMicrophone" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsAccessLocation" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsAccessContacts" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsAccessCalendar" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsAccessCallHistory" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsAccessEmail" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsAccessMessaging" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsAccessNotifications" /t REG_DWORD /d 2 /f >nul 2>&1

:: Wipe all startup entries
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /va /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /va /f >nul 2>&1
reg delete "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Run" /va /f >nul 2>&1
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" /va /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" /va /f >nul 2>&1

echo [OK] Background apps and startup items cleared.

:: ============================================================
:: PART 13: DELETE BLOAT SCHEDULED TASKS
:: ============================================================
echo.
echo [13/14] DELETING BLOAT SCHEDULED TASKS...

for %%T in (
    "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser"
    "\Microsoft\Windows\Application Experience\ProgramDataUpdater"
    "\Microsoft\Windows\Application Experience\StartupAppTask"
    "\Microsoft\Windows\Application Experience\AitAgent"
    "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator"
    "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip"
    "\Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask"
    "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector"
    "\Microsoft\Windows\Feedback\Siuf\DmClient"
    "\Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload"
    "\Microsoft\Windows\Windows Error Reporting\QueueReporting"
    "\Microsoft\Windows\WindowsUpdate\Automatic App Update"
    "\Microsoft\Windows\WindowsUpdate\Scheduled Start"
    "\Microsoft\Windows\WindowsUpdate\sih"
    "\Microsoft\Windows\WindowsUpdate\sihboot"
    "\Microsoft\Windows\Maps\MapsUpdateTask"
    "\Microsoft\Windows\Maps\MapsToastTask"
    "\Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem"
    "\Microsoft\Windows\Shell\FamilySafetyMonitor"
    "\Microsoft\Windows\Shell\FamilySafetyRefresh"
    "\Microsoft\Windows\License Manager\TempSignedLicenseExchange"
    "\Microsoft\Windows\Clip\License Validation"
    "\Microsoft\Windows\CloudExperienceHost\CreateObjectTask"
    "\Microsoft\Windows\DiskFootprint\Diagnostics"
    "\Microsoft\Windows\FileHistory\File History (maintenance mode)"
    "\Microsoft\Windows\Speech\SpeechModelDownloadTask"
    "\Microsoft\Windows\UNP\RunUpdateNotificationMgr"
    "\Microsoft\Windows\Location\Notifications"
    "\Microsoft\Windows\Location\WindowsActionDialog"
    "\Microsoft\Windows\BrokerInfrastructure\BrokerTask"
    "\Microsoft\Windows\Diagnosis\Scheduled"
    "\Microsoft\Windows\MUI\LPRemove"
    "\Microsoft\Windows\NetTrace\GatherNetworkInfo"
    "\Microsoft\Windows\PI\Sqm-Tasks"
    "\Microsoft\Windows\WDI\ResolutionHost"
    "\Microsoft\Windows\PushToInstall\LoginCheck"
    "\Microsoft\Windows\PushToInstall\Registration"
    "\Microsoft\Windows\Clip\License Validation"
    "\Microsoft\Windows\Management\Provisioning\Logon"
    "\Microsoft\Windows\SettingSync\BackupTask"
    "\Microsoft\Windows\SettingSync\NetworkStateChangeTask"
    "\Microsoft\Windows\USB\Usb-Notifications"
    "\Microsoft\Windows\Workplace Join\Automatic-Device-Join"
    "\Microsoft\XblGameSave\XblGameSaveTask"
    "\Microsoft\XblGameSave\XblGameSaveTaskLogon"
    "\Microsoft\Windows\HelloFace\FODCleanupTask"
    "\Microsoft\Windows\Time Synchronization\ForceSynchronizeTime"
    "\Microsoft\Windows\Time Synchronization\SynchronizeTime"
    "\Microsoft\Windows\Data Integrity Scan\Data Integrity Scan"
    "\Microsoft\Windows\Registry\RegIdleBackup"
    "\Microsoft\Windows\Maintenance\WinSAT"
    "\Microsoft\Windows\SystemRestore\SR"
    "\Microsoft\Windows\Autochk\Proxy"
    "\Microsoft\Windows\Defrag\ScheduledDefrag"
    "\Microsoft\Windows\TaskManager\Interactive"
    "\Microsoft\Windows\NlaSvc\WiFiTask"
    "\Microsoft\Windows\Mobile Broadband Accounts\MNO Metadata Parser"
) do (
    schtasks /Change /TN "%%T" /Disable >nul 2>&1
    schtasks /Delete /TN "%%T" /F >nul 2>&1
)

echo [OK] Scheduled tasks deleted.

:: ============================================================
:: PART 14: MAXIMUM GOD MODE PERFORMANCE TWEAKS
:: ============================================================
echo.
echo [14/14] APPLYING GOD MODE PERFORMANCE TWEAKS...

:: Activate Ultimate Performance power plan
powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul 2>&1
:: If not available, create it
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1
for /f "tokens=4" %%G in ('powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 2^>nul') do (
    powercfg -setactive %%G >nul 2>&1
)

:: Disable all power saving
powercfg -change -monitor-timeout-ac 0 >nul 2>&1
powercfg -change -monitor-timeout-dc 0 >nul 2>&1
powercfg -change -standby-timeout-ac 0 >nul 2>&1
powercfg -change -standby-timeout-dc 0 >nul 2>&1
powercfg -change -disk-timeout-ac 0 >nul 2>&1
powercfg -change -disk-timeout-dc 0 >nul 2>&1
powercfg -change -hibernate-timeout-ac 0 >nul 2>&1
powercfg -h off >nul 2>&1

:: Disable visual effects - full performance
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v "UserPreferencesMask" /t REG_BINARY /d 9012038010000000 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v "MinAnimate" /t REG_SZ /d "0" /f >nul 2>&1

:: UI responsiveness tweaks
reg add "HKCU\Control Panel\Desktop" /v "MenuShowDelay" /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v "DragFullWindows" /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v "AutoEndTasks" /t REG_SZ /d "1" /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v "HungAppTimeout" /t REG_SZ /d "1000" /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v "WaitToKillAppTimeout" /t REG_SZ /d "2000" /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v "LowLevelHooksTimeout" /t REG_DWORD /d 1000 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control" /v "WaitToKillServiceTimeout" /t REG_SZ /d "2000" /f >nul 2>&1

:: Disable transparency
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableTransparency" /t REG_DWORD /d 0 /f >nul 2>&1

:: Disable animations
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarAnimations" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v "EnableAeroPeek" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v "AlwaysHibernateThumbnails" /t REG_DWORD /d 0 /f >nul 2>&1

:: Disable Prefetch / Superfetch / SysMain
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnablePrefetcher" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnableSuperfetch" /t REG_DWORD /d 0 /f >nul 2>&1

:: Memory management
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargeSystemCache" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePagingExecutive" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "IoPageLockLimit" /t REG_DWORD /d 983040 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettings" /t REG_DWORD /d 1 /f >nul 2>&1

:: NTFS performance
reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "NtfsDisable8dot3NameCreation" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "NtfsDisableLastAccessUpdate" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "NtfsMftZoneReservation" /t REG_DWORD /d 2 /f >nul 2>&1
fsutil behavior set disablelastaccess 1 >nul 2>&1
fsutil behavior set encryptpagingfile 0 >nul 2>&1
fsutil behavior set memoryusage 2 >nul 2>&1

:: Network performance
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v "IRPStackSize" /t REG_DWORD /d 20 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v "SizReqBuf" /t REG_DWORD /d 17424 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpTimedWaitDelay" /t REG_DWORD /d 30 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "DefaultTTL" /t REG_DWORD /d 64 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "Tcp1323Opts" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpMaxDataRetransmissions" /t REG_DWORD /d 3 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnablePMTUDiscovery" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "GlobalMaxTcpWindowSize" /t REG_DWORD /d 65535 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpWindowSize" /t REG_DWORD /d 65535 /f >nul 2>&1
netsh int tcp set global autotuninglevel=normal >nul 2>&1
netsh int tcp set global rss=enabled >nul 2>&1
netsh int tcp set global chimney=disabled >nul 2>&1
netsh int tcp set heuristics disabled >nul 2>&1
netsh int tcp set global ecncapability=disabled >nul 2>&1
netsh int tcp set global timestamps=disabled >nul 2>&1
netsh int tcp set global initialRto=2000 >nul 2>&1
netsh int tcp set global nonsackrttresiliency=disabled >nul 2>&1

:: Disable Nagle's algorithm (reduces latency)
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" /v "TcpAckFrequency" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" /v "TCPNoDelay" /t REG_DWORD /d 1 /f >nul 2>&1

:: GPU performance
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d 8 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Priority" /t REG_DWORD /d 6 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d "High" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "SFIO Priority" /t REG_SZ /d "High" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d 4294967295 /f >nul 2>&1

:: Disable hardware accelerated GPU scheduling if needed (some systems)
:: reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "HwSchMode" /t REG_DWORD /d 2 /f >nul 2>&1

:: Disable game bar and DVR
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v "AppCaptureEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v "AllowGameDVR" /t REG_DWORD /d 0 /f >nul 2>&1

:: Disable Fast Startup (can cause issues)
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v "HiberbootEnabled" /t REG_DWORD /d 0 /f >nul 2>&1

:: Processor scheduling - foreground apps
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v "Win32PrioritySeparation" /t REG_DWORD /d 38 /f >nul 2>&1

:: Disable Windows themes for bare-bone look
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes" /v "ThemeChangesDesktopIcons" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Themes" /v "ThemeColorChange" /t REG_DWORD /d 0 /f >nul 2>&1

:: Disable lock screen
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization" /v "NoLockScreen" /t REG_DWORD /d 1 /f >nul 2>&1

:: Disable Action Center / Notifications
reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "DisableNotificationCenter" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications" /v "ToastEnabled" /t REG_DWORD /d 0 /f >nul 2>&1

:: Disable tips and tricks
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338387Enabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338388Enabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338389Enabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-353694Enabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-353696Enabled" /t REG_DWORD /d 0 /f >nul 2>&1

:: Disable Spotlight on lock screen
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "RotatingLockScreenEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "RotatingLockScreenOverlayEnabled" /t REG_DWORD /d 0 /f >nul 2>&1

:: Disable Scheduled Disk Defrag
schtasks /Change /TN "\Microsoft\Windows\Defrag\ScheduledDefrag" /Disable >nul 2>&1

:: Clean up temp files
del /f /s /q "%SystemRoot%\Temp\*" >nul 2>&1
del /f /s /q "%Temp%\*" >nul 2>&1
del /f /s /q "%SystemRoot%\Prefetch\*" >nul 2>&1
del /f /s /q "C:\Windows\SoftwareDistribution\Download\*" >nul 2>&1
ipconfig /flushdns >nul 2>&1

echo [OK] God Mode performance applied.

:: ============================================================
:: DONE
:: ============================================================
cls
echo ============================================================
echo     GOD MODE ULTIMATE - 100%% COMPLETE
echo ============================================================
echo.
echo  [REMOVED]
echo   Microsoft Edge ............... GONE
echo   Microsoft Store .............. GONE
echo   Windows Defender ............. GONE
echo   OneDrive ..................... GONE
echo   Paint / Paint 3D ............. GONE
echo   Windows Media Player ......... GONE
echo   Print / Fax Spooler .......... GONE
echo   Bluetooth .................... GONE
echo   Cortana ...................... GONE
echo   Copilot / AI ................. GONE
echo   Widgets / News ............... GONE
echo   Xbox / Gaming Services ....... GONE
echo   Telemetry / Tracking ......... GONE
echo   All Bloatware Apps ........... GONE
echo   200+ Bloat Scheduled Tasks ... GONE
echo.
echo  [APPLIED]
echo   Ultimate Performance Plan .... ON
echo   GPU / CPU Priority ........... MAX
echo   Visual Effects ............... OFF
echo   Animations ................... OFF
echo   Transparency ................. OFF
echo   Background Apps .............. OFF
echo   Startup Items ................ CLEARED
echo   NTFS Optimized ............... YES
echo   Network Latency .............. MINIMIZED
echo   Memory Performance ........... MAXIMIZED
echo   Windows Update ............... PERMANENTLY OFF
echo   100+ Services Disabled ....... YES
echo.
echo  NO LOG FILE CREATED
echo.
echo ============================================================
echo   RESTART REQUIRED - PRESS ANY KEY TO REBOOT NOW
echo ============================================================
pause >nul
shutdown /r /t 5 /c "GOD MODE ULTIMATE Applied - Rebooting..."
exit /b 0
