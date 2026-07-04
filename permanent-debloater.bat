@echo off
setlocal enabledelayedexpansion
title Windows Debloater - Permanent Removal
color 0A

:: ============================================================
:: Admin Check
:: ============================================================
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Please run this script as Administrator!
    echo Right-click the file and select "Run as administrator"
    pause
    exit /b 1
)

echo.
echo ============================================================
echo          WINDOWS PERMANENT DEBLOATER
echo          No Nvidia - All Users - No Reinstall
echo ============================================================
echo.
echo WARNING: This will permanently remove bloatware apps.
echo Press CTRL+C to cancel or...
pause

:: ============================================================
:: STEP 1 - Remove AppX Packages (Current + All Users)
:: ============================================================
echo.
echo [STEP 1] Removing AppX packages for all users...
echo.

set "apps=3DViewer BingWeather BingNews BingFinance BingSports BingTranslator Cortana FeedbackHub GetHelp Getstarted MicrosoftOfficeHub MicrosoftSolitaireCollection MixedReality Office.OneNote OneConnect People Print3D SkypeApp StickyNotes Teams Todos Whiteboard WindowsAlarms WindowsCamera windowscommunicationsapps WindowsMaps WindowsSoundRecorder Xbox ZuneMusic ZuneVideo YourPhone LinkedIn Clipchamp PowerAutomateDesktop MSPaint"

for %%A in (%apps%) do (
    echo   [-] Removing: %%A
    powershell -NoProfile -Command "Get-AppxPackage -AllUsers *%%A* | Remove-AppxPackage -AllUsers" >nul 2>&1
)

:: ============================================================
:: STEP 2 - Remove Provisioned Packages (Prevents Reinstall)
:: ============================================================
echo.
echo [STEP 2] Removing provisioned packages (prevents reinstall)...
echo.

for %%A in (%apps%) do (
    echo   [-] Deprovisioning: %%A
    powershell -NoProfile -Command "Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like '*%%A*' | Remove-AppxProvisionedPackage -Online" >nul 2>&1
)

:: ============================================================
:: STEP 3 - Disable Cortana via Registry
:: ============================================================
echo.
echo [STEP 3] Disabling Cortana via registry...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortana" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "DisableWebSearch" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "ConnectedSearchUseWeb" /t REG_DWORD /d 0 /f >nul 2>&1
echo   [OK] Cortana disabled.

:: ============================================================
:: STEP 4 - Disable Telemetry & Data Collection
:: ============================================================
echo.
echo [STEP 4] Disabling telemetry and data collection...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f >nul 2>&1
echo   [OK] Telemetry disabled.

:: ============================================================
:: STEP 5 - Disable Windows Feedback
:: ============================================================
echo.
echo [STEP 5] Disabling Windows feedback requests...
reg add "HKCU\SOFTWARE\Microsoft\Siuf\Rules" /v "NumberOfSIUFInPeriod" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "DoNotShowFeedbackNotifications" /t REG_DWORD /d 1 /f >nul 2>&1
echo   [OK] Feedback disabled.

:: ============================================================
:: STEP 6 - Disable Xbox Game Bar & DVR
:: ============================================================
echo.
echo [STEP 6] Disabling Xbox Game Bar and DVR...
reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v "AllowGameDVR" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v "AppCaptureEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
echo   [OK] Xbox Game Bar and DVR disabled.

:: ============================================================
:: STEP 7 - Disable Bing Search in Start Menu
:: ============================================================
echo.
echo [STEP 7] Disabling Bing search in Start Menu...
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "BingSearchEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "CortanaConsent" /t REG_DWORD /d 0 /f >nul 2>&1
echo   [OK] Bing search in Start Menu disabled.

:: ============================================================
:: STEP 8 - Disable Advertising ID
:: ============================================================
echo.
echo [STEP 8] Disabling Advertising ID...
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "Enabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" /v "DisabledByGroupPolicy" /t REG_DWORD /d 1 /f >nul 2>&1
echo   [OK] Advertising ID disabled.

:: ============================================================
:: STEP 9 - Disable Windows Tips and Suggestions
:: ============================================================
echo.
echo [STEP 9] Disabling Windows tips, tricks and suggestions...
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338388Enabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338389Enabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-353694Enabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-353696Enabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SoftLandingEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SystemPaneSuggestionsEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
echo   [OK] Tips and suggestions disabled.

:: ============================================================
:: STEP 10 - Disable Auto-install of Suggested Apps
:: ============================================================
echo.
echo [STEP 10] Disabling auto-install of suggested/sponsored apps...
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SilentInstalledAppsEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "PreInstalledAppsEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "OemPreInstalledAppsEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
echo   [OK] Auto-install of suggested apps disabled.

:: ============================================================
:: STEP 11 - Disable Bloat Scheduled Tasks
:: ============================================================
echo.
echo [STEP 11] Disabling bloat scheduled tasks...
schtasks /Change /TN "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Application Experience\ProgramDataUpdater" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Autochk\Proxy" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Feedback\Siuf\DmClient" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload" /Disable >nul 2>&1
schtasks /Change /TN "Microsoft\Windows\Windows Error Reporting\QueueReporting" /Disable >nul 2>&1
echo   [OK] Scheduled tasks disabled.

:: ============================================================
:: STEP 12 - Disable ALL Non-Essential Services (Permanently)
:: ============================================================
echo.
echo [STEP 12] Disabling all non-essential Windows services...

:: --- Telemetry / Diagnostics / Reporting ---
sc stop "DiagTrack"             >nul 2>&1 & sc config "DiagTrack"             start= disabled >nul 2>&1
sc stop "dmwappushservice"      >nul 2>&1 & sc config "dmwappushservice"      start= disabled >nul 2>&1
sc stop "WerSvc"                >nul 2>&1 & sc config "WerSvc"                start= disabled >nul 2>&1
sc stop "PcaSvc"                >nul 2>&1 & sc config "PcaSvc"                start= disabled >nul 2>&1
sc stop "DPS"                   >nul 2>&1 & sc config "DPS"                   start= disabled >nul 2>&1
sc stop "WdiServiceHost"        >nul 2>&1 & sc config "WdiServiceHost"        start= disabled >nul 2>&1
sc stop "WdiSystemHost"         >nul 2>&1 & sc config "WdiSystemHost"         start= disabled >nul 2>&1

:: --- Xbox / Gaming ---
sc stop "XblAuthManager"        >nul 2>&1 & sc config "XblAuthManager"        start= disabled >nul 2>&1
sc stop "XblGameSave"           >nul 2>&1 & sc config "XblGameSave"           start= disabled >nul 2>&1
sc stop "XboxNetApiSvc"         >nul 2>&1 & sc config "XboxNetApiSvc"         start= disabled >nul 2>&1
sc stop "XboxGipSvc"            >nul 2>&1 & sc config "XboxGipSvc"            start= disabled >nul 2>&1
sc stop "GamingServices"        >nul 2>&1 & sc config "GamingServices"        start= disabled >nul 2>&1
sc stop "GamingServicesNet"     >nul 2>&1 & sc config "GamingServicesNet"     start= disabled >nul 2>&1

:: --- Maps / Location ---
sc stop "MapsBroker"            >nul 2>&1 & sc config "MapsBroker"            start= disabled >nul 2>&1
sc stop "lfsvc"                 >nul 2>&1 & sc config "lfsvc"                 start= disabled >nul 2>&1

:: --- Remote Access / Assistance ---
sc stop "RemoteRegistry"        >nul 2>&1 & sc config "RemoteRegistry"        start= disabled >nul 2>&1
sc stop "RemoteAccess"          >nul 2>&1 & sc config "RemoteAccess"          start= disabled >nul 2>&1
sc stop "SessionEnv"            >nul 2>&1 & sc config "SessionEnv"            start= disabled >nul 2>&1
sc stop "TermService"           >nul 2>&1 & sc config "TermService"           start= disabled >nul 2>&1
sc stop "UmRdpService"          >nul 2>&1 & sc config "UmRdpService"          start= disabled >nul 2>&1

:: --- Fax ---
sc stop "Fax"                   >nul 2>&1 & sc config "Fax"                   start= disabled >nul 2>&1

:: --- Retail Demo / OEM ---
sc stop "RetailDemo"            >nul 2>&1 & sc config "RetailDemo"            start= disabled >nul 2>&1

:: --- Windows Media Player Network Sharing ---
sc stop "WMPNetworkSvc"         >nul 2>&1 & sc config "WMPNetworkSvc"         start= disabled >nul 2>&1

:: --- Smart Card ---
sc stop "SCardSvr"              >nul 2>&1 & sc config "SCardSvr"              start= disabled >nul 2>&1
sc stop "ScDeviceEnum"          >nul 2>&1 & sc config "ScDeviceEnum"          start= disabled >nul 2>&1

:: --- Tablet / Touch ---
sc stop "TabletInputService"    >nul 2>&1 & sc config "TabletInputService"    start= disabled >nul 2>&1

:: --- Phone / Mobile Hotspot ---
sc stop "PhoneSvc"              >nul 2>&1 & sc config "PhoneSvc"              start= disabled >nul 2>&1
sc stop "icssvc"                >nul 2>&1 & sc config "icssvc"                start= disabled >nul 2>&1

:: --- Mixed Reality ---
sc stop "perceptionsimulation"  >nul 2>&1 & sc config "perceptionsimulation"  start= disabled >nul 2>&1

:: --- Connected User Experiences (Telemetry backbone) ---
sc stop "CDPSvc"                >nul 2>&1 & sc config "CDPSvc"                start= disabled >nul 2>&1
sc stop "CDPUserSvc"            >nul 2>&1 & sc config "CDPUserSvc"            start= disabled >nul 2>&1

:: --- Push Notifications ---
sc stop "WpnService"            >nul 2>&1 & sc config "WpnService"            start= disabled >nul 2>&1
sc stop "WpnUserService"        >nul 2>&1 & sc config "WpnUserService"        start= disabled >nul 2>&1

:: --- HomeGroup ---
sc stop "HomeGroupListener"     >nul 2>&1 & sc config "HomeGroupListener"     start= disabled >nul 2>&1
sc stop "HomeGroupProvider"     >nul 2>&1 & sc config "HomeGroupProvider"     start= disabled >nul 2>&1

:: --- Peer-to-Peer / Branch Cache ---
sc stop "PeerDistSvc"           >nul 2>&1 & sc config "PeerDistSvc"           start= disabled >nul 2>&1
sc stop "p2psvc"                >nul 2>&1 & sc config "p2psvc"                start= disabled >nul 2>&1
sc stop "p2pimsvc"              >nul 2>&1 & sc config "p2pimsvc"              start= disabled >nul 2>&1
sc stop "PNRPsvc"               >nul 2>&1 & sc config "PNRPsvc"               start= disabled >nul 2>&1
sc stop "PNRPAutoReg"           >nul 2>&1 & sc config "PNRPAutoReg"           start= disabled >nul 2>&1

:: --- Secondary Logon ---
sc stop "seclogon"              >nul 2>&1 & sc config "seclogon"              start= disabled >nul 2>&1

:: --- AllJoyn Router ---
sc stop "AJRouter"              >nul 2>&1 & sc config "AJRouter"              start= disabled >nul 2>&1

:: --- Geolocation ---
sc stop "GeoSvc"                >nul 2>&1 & sc config "GeoSvc"                start= disabled >nul 2>&1

echo   [OK] All non-essential services permanently disabled.

:: ============================================================
:: STEP 13 - Group Policy Lockdowns (via Registry / LGPO)
:: ============================================================
echo.
echo [STEP 13] Applying Group Policy lockdowns...

:: --- Telemetry & Data Collection ---
echo   [GP] Telemetry and data collection...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "LimitDiagnosticLogCollection" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "DisableOneSettingsDownloads" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "DoNotShowFeedbackNotifications" /t REG_DWORD /d 1 /f >nul 2>&1

:: --- Cortana & Search ---
echo   [GP] Cortana and web search...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortana" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortanaAboveLock" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowSearchToUseLocation" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "DisableWebSearch" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "ConnectedSearchUseWeb" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "ConnectedSearchPrivacy" /t REG_DWORD /d 3 /f >nul 2>&1

:: --- OneDrive ---
echo   [GP] OneDrive...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /v "DisableFileSyncNGSC" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /v "DisableFileSync" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /v "DisableLibrariesDefaultSaveToOneDrive" /t REG_DWORD /d 1 /f >nul 2>&1

:: --- Windows Error Reporting ---
echo   [GP] Windows Error Reporting...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v "Disabled" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v "DontSendAdditionalData" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v "LoggingDisabled" /t REG_DWORD /d 1 /f >nul 2>&1

:: --- Windows Update (disable auto-reboot, disable ads in update) ---
echo   [GP] Windows Update behavior...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoRebootWithLoggedOnUsers" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "AUPowerManagement" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "DisableWindowsUpdateAccess" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "SetDisableUXWUAccess" /t REG_DWORD /d 0 /f >nul 2>&1

:: --- Advertising & Consumer Experience ---
echo   [GP] Advertising ID and consumer experience...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" /v "DisabledByGroupPolicy" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsConsumerFeatures" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableSoftLanding" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableThirdPartySuggestions" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableThirdPartySuggestions" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableTailoredExperiencesWithDiagnosticData" /t REG_DWORD /d 1 /f >nul 2>&1

:: --- Location ---
echo   [GP] Location services...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" /v "DisableLocation" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" /v "DisableLocationScripting" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" /v "DisableSensors" /t REG_DWORD /d 1 /f >nul 2>&1

:: --- Camera & Microphone (GP enforcement) ---
echo   [GP] Camera and microphone app access...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsAccessCamera" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsAccessLocation" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsAccessContacts" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsAccessCalendar" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsAccessCallHistory" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsAccessEmail" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsAccessMessaging" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsAccessRadios" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsSyncWithDevices" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsAccessAccountInfo" /t REG_DWORD /d 2 /f >nul 2>&1

:: --- Xbox & Game DVR ---
echo   [GP] Xbox and Game DVR...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v "AllowGameDVR" /t REG_DWORD /d 0 /f >nul 2>&1

:: --- Microsoft Store (block auto-updates of store apps) ---
echo   [GP] Microsoft Store app auto-updates...
reg add "HKLM\SOFTWARE\Policies\Microsoft\WindowsStore" /v "AutoDownload" /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\WindowsStore" /v "DisableStoreApps" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\WindowsStore" /v "RemoveWindowsStore" /t REG_DWORD /d 0 /f >nul 2>&1

:: --- Remote Assistance ---
echo   [GP] Remote Assistance...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" /v "fAllowToGetHelp" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" /v "fAllowUnsolicited" /t REG_DWORD /d 0 /f >nul 2>&1

:: --- AutoPlay / AutoRun (security risk) ---
echo   [GP] AutoPlay and AutoRun...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "NoAutoplayfornonVolume" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoDriveTypeAutoRun" /t REG_DWORD /d 255 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoAutorun" /t REG_DWORD /d 1 /f >nul 2>&1

:: --- Lock Screen Ads / Spotlight ---
echo   [GP] Lock screen ads and Spotlight...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsSpotlightFeatures" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsSpotlightOnActionCenter" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsSpotlightOnSettings" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsSpotlightWindowsWelcomeExperience" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableTailoredExperiencesWithDiagnosticData" /t REG_DWORD /d 1 /f >nul 2>&1

:: --- Activity History / Timeline ---
echo   [GP] Activity history and timeline...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "EnableActivityFeed" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "PublishUserActivities" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "UploadUserActivities" /t REG_DWORD /d 0 /f >nul 2>&1

:: --- Delivery Optimization (P2P Windows Update sharing) ---
echo   [GP] Delivery Optimization (P2P update sharing)...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" /v "DODownloadMode" /t REG_DWORD /d 0 /f >nul 2>&1

:: --- People Bar (taskbar contacts) ---
echo   [GP] People Bar on taskbar...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "HidePeopleBar" /t REG_DWORD /d 1 /f >nul 2>&1

:: --- News and Interests (taskbar widget) ---
echo   [GP] News and Interests widget...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds" /v "EnableFeeds" /t REG_DWORD /d 0 /f >nul 2>&1

:: --- Map Downloads (offline maps auto-update) ---
echo   [GP] Offline maps auto-download...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Maps" /v "AutoDownloadAndUpdateMapData" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Maps" /v "AllowUntriggeredNetworkTrafficOnSettingsPage" /t REG_DWORD /d 0 /f >nul 2>&1

:: --- Handwriting & Inking personalization ---
echo   [GP] Handwriting and inking data...
reg add "HKLM\SOFTWARE\Policies\Microsoft\InputPersonalization" /v "AllowInputPersonalization" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\InputPersonalization" /v "RestrictImplicitInkCollection" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\InputPersonalization" /v "RestrictImplicitTextCollection" /t REG_DWORD /d 1 /f >nul 2>&1

:: --- Speech Recognition & Personalization ---
echo   [GP] Speech personalization...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Speech" /v "AllowSpeechModelUpdate" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy" /v "HasAccepted" /t REG_DWORD /d 0 /f >nul 2>&1

:: --- Apply Group Policy immediately ---
echo   [GP] Refreshing Group Policy...
gpupdate /force >nul 2>&1
echo   [OK] Group Policy lockdowns applied.

:: ============================================================
:: DONE
:: ============================================================
echo.
echo ============================================================
echo   [COMPLETE] Windows debloat finished successfully!
echo   No Nvidia drivers were touched.
echo   Reboot recommended to apply all changes.
echo ============================================================
echo.
pause
exit /b 0