@echo off
setlocal

:menu
chcp 65001 >nul 2>&1
echo.        %b%╔══════════════════════════════════════════════════════════╗
echo.        %b%║                       WARNING                            ║  
echo.        %b%║WE RECOMMEND GIGABYTE MOTHERBOARD USERS TO NOT CONTINUE ON║ 
echo.        %b%║  GIGABYTE MOTHERBOARDS HAVE ISSUES WITH TOOLS LIKE THIS  ║ 
echo.        %b%║  STIX PC SERVICES IS NOT RESPONSIBLE FOR ANY HARM THAT   ║
echo.        %b%║    THAT MAY HAVE BEEN CAUSED FROM USING THIS PROGRAM     ║
echo.        %b%╚══════════════════════════════════════════════════════════╝

echo.
echo [1] Intel Motherboard
echo [2] AMD/Ryzen Motherboard
echo.

set /p input=Choose CPU type: 
if /i "%input%" == "1" goto :intel
if /i "%input%" == "2" goto :amd

:amd
cls
echo. Disabling C States...
SCEWIN_64.exe /i /ms "Global C-state Control" /qv 0x0 /lang en-US
cls
echo. Disabling TPM State...
SCEWIN_64.exe /i /ms "TPM State" /qv 0x0 /lang en-US
cls
echo. Disabling Secure Boot...
SCEWIN_64.exe /i /ms "Secure Boot" /qv 0x0 /lang en-US
cls
echo. Disabling BME DMA Mitigation...
SCEWIN_64.exe /i /ms "Secure Boot" /qv 0 /lang en-US
cls
echo. Disabling Fast Boot...
SCEWIN_64.exe /i /ms "Fast Boot" /qv 0x0 /lang en-US
cls
echo. Disabling Power On By Device...
SCEWIN_64.exe /i /ms "Power On By Mouse" /qv 0x0 /lang en-US
SCEWIN_64.exe /i /ms "Power On By Keyboard" /qv 0x0 /lang en-US
cls
echo. Disabling Wake On Lan...
SCEWIN_64.exe /i /ms "Wake on LAN" /qv 0x0 /lang en-US
cls
echo. Enabling Bootup NumLock State...
SCEWIN_64.exe /i /ms "Bootup NumLock State" /qv 0x1 /lang en-US
cls
echo. Disabling Csm Support...
SCEWIN_64.exe /i /ms "CSM Support" /qv 0x0 /lang en-US
cls
echo. Disabling Network Stack Driver...
SCEWIN_64.exe /i /ms "Network Stack Driver Support" /qv 0x0 /lang en-US
cls
echo. Disabling HD Audio Controller...
SCEWIN_64.exe /i /ms "HD Audio Controller" /qv 0x0 /lang en-US
cls
echo. Enabling XHCI Hand Off...
SCEWIN_64.exe /i /ms "XHCI Hand-Off" /qv 0x0 /lang en-US
cls
echo. Diasbling Legacy Usb Support...
SCEWIN_64.exe /i /ms "Legacy USB Support" /qv 0x0 /lang en-US
cls
echo. Disabling Resume By Alarm...
SCEWIN_64.exe /i /ms "Resume by Alarm" /qv 0x0 /lang en-US
cls
echo. Disabling Fullscreen Logo Display...
SCEWIN_64.exe /i /ms "Full Screen LOGO Show" /qv 0x0 /lang en-US
cls
echo. Disabling Security Device Support...
SCEWIN_64.exe /i /ms "Security Device Support" /qv 0x0 /lang en-US
cls
echo. Disabling CNVI Mode...
SCEWIN_64.exe /i /ms "CNVI Mode" /qv 0x0 /lang en-US
cls
echo. Disabling Energy Efficient P-state...
SCEWIN_64.exe /i /ms "Energy Efficient P-state" /qv 0x0 /lang en-US
cls
echo. Disabling Energy Performance Gain...
SCEWIN_64.exe /i /ms "Energy Performance Gain" /qv 0x0 /lang en-US
cls
echo. Disabling Energy Efficient Turbo...
SCEWIN_64.exe /i /ms "Energy Efficient Turbo" /qv 0x0 /lang en-US
cls
echo. Disabling BME DMA Mitigation...
SCEWIN_64.exe /i /ms "BME DMA Mitigation" /qv 0x0 /lang en-US
cls
echo. Disabling Enable RH Prevention...
SCEWIN_64.exe /i /ms "Enable RH Prevention" /qv 0x0 /lang en-US
cls
echo. Disabling "IOMMU" 
SCEWIN_64.exe /i /ms "IOMMU" /qv 0x0 /lang en-US
cls
echo. Disabling "AMD Cool'N'Quiet" 
SCEWIN_64.exe /i /ms "AMD Cool'N'Quiet" /qv 0x0 /lang en-US
cls
echo. Disabling "Serial / Parallel Port" 
SCEWIN_64.exe /i /ms "Serial / Parallel Port" /qv 0x0 /lang en-US
cls
echo. Disabling "TPM State" 
SCEWIN_64.exe /i /ms "TPM State" /qv 0x0 /lang en-US
cls
echo. Disabling "AMD fTPM switch" 
SCEWIN_64.exe /i /ms "AMD fTPM switch" /qv 0x0 /lang en-US
cls
echo. Disabling "Remote Display Feature" 
SCEWIN_64.exe /i /ms "Remote Display Feature" /qv 0x0 /lang en-US
cls
echo. Disabling "Security Device Support" 
SCEWIN_64.exe /i /ms "Security Device Support" /qv 0x0 /lang en-US
cls
echo. Disabling "PSS Support" 
SCEWIN_64.exe /i /ms "PSS Support" /qv 0x0 /lang en-US
cls
echo. Disabling "AB Clock Gating" 
SCEWIN_64.exe /i /ms "AB Clock Gating" /qv 0x0 /lang en-US
cls
echo. Disabling "PCIB Clock Run" 
SCEWIN_64.exe /i /ms "PCIB Clock Run" /qv 0x0 /lang en-US
cls
echo. Disabling "SR-IOV Support" 
SCEWIN_64.exe /i /ms "SR-IOV Support" /qv 0x0 /lang en-US
cls
echo. Disabling "Opcache Control" 
SCEWIN_64.exe /i /ms "Opcache Control" /qv 0x1 /lang en-US
cls
echo. Disabling "BME DMA Mitigation" 
SCEWIN_64.exe /i /ms "Opcache Control" /qv 0x0 /lang en-US
cls
echo. Disabling "Above 4G memory" 
SCEWIN_64.exe /i /ms "Above 4G memory" /qv 0x1 /lang en-US
cls
echo. Disabling "AB Clock Gating" 
SCEWIN_64.exe /i /ms "Adaptive S4" /qv 0x0 /lang en-US
cls
echo. Disabling "LAN Power Enable" 
SCEWIN_64.exe /i /ms "LAN Power Enable" /qv 0x0 /lang en-US
cls
echo. Disabling "PM L1 SS" 
SCEWIN_64.exe /i /ms "PM L1 SS" /qv 0x0 /lang en-US
cls
echo. Disabling "Win7 USB Wake Support" 
SCEWIN_64.exe /i /ms "Win7 USB Wake Support" /qv 0x0 /lang en-US
cls
echo. Disabling "AMD Cool&Quiet function" 
SCEWIN_64.exe /i /ms "AMD Cool&Quiet function" /qv 0x0 /lang en-US
cls
echo. Disabling "C6 Mode" 
SCEWIN_64.exe /i /ms "C6 Mode" /qv 0x0 /lang en-US
cls
echo. Disabling "PCIe Slot Configuration" 
SCEWIN_64.exe /i /ms "PCIe Slot Configuration" /qv 0x0 /lang en-US
cls
echo. Disabling "3DMark01 Enhancement" 
SCEWIN_64.exe /i /ms "3DMark01 Enhancement" /qv 0x0 /lang en-US
cls
echo. Disabling "Isochronous Support" 
SCEWIN_64.exe /i /ms "Isochronous Support" /qv 0x0 /lang en-US
cls
echo. Disabling "PS2 Devices Support" 
SCEWIN_64.exe /i /ms "PS2 Devices Support" /qv 0x0 /lang en-US
cls
echo. Disabling "Network Stack Driver Support" 
SCEWIN_64.exe /i /ms "Network Stack Driver Support" /qv 0x0 /lang en-US
cls
echo. Disabling "TPM State" 
SCEWIN_64.exe /i /ms "TPM State" /qv 0x0 /lang en-US
cls
echo. Disabling "Enable Hibernation" 
SCEWIN_64.exe /i /ms "Enable Hibernation" /qv 0x0 /lang en-US
cls
echo. Disabling "Onboard PCIE LAN PXE ROM" 
SCEWIN_64.exe /i /ms "Onboard PCIE LAN PXE ROM" /qv 0x0 /lang en-US
cls
echo. Disabling "CRB test" 
SCEWIN_64.exe /i /ms "CRB test" /qv 0x0 /lang en-US
cls
echo. Disabling "Integrated Graphics" 
SCEWIN_64.exe /i /ms "Integrated Graphics" /qv 0x0 /lang en-US
cls
echo. Disabling "AB Clock Gating" 
SCEWIN_64.exe /i /ms "AB Clock Gating" /qv 0x0 /lang en-US
cls
echo. Disabling "PCIB Clock Run" 
SCEWIN_64.exe /i /ms "PCIB Clock Run" /qv 0x0 /lang en-US
cls
echo. Disabling "Aggressive Link PM Capability" 
SCEWIN_64.exe /i /ms "Aggressive Link PM Capability" /qv 0x0 /lang en-US
cls
echo Successfully Optimized Your Bios Settings, Please Restart Your PC...
pause

:intel
@echo off
echo. Disabling C States...
SCEWIN_64.exe /i /ms "Global C-state Control" /qv 0x0 /lang en-US
cls
echo. Disabling Ps2 Devices...
SCEWIN_64.exe /i /ms "PS2 Devices Support" /qv 0x0 /lang en-US
cls
echo. Disabling TPM State...
SCEWIN_64.exe /i /ms "TPM State" /qv 0x0 /lang en-US
cls
echo. Disabling Secure Boot... //this so bad for windows 11
SCEWIN_64.exe /i /ms "Secure Boot" /qv 0x0 /lang en-US
cls
echo. Disabling BME DMA Mitigation...
SCEWIN_64.exe /i /ms "Secure Boot" /qv 0 /lang en-US
cls
echo. Disabling Fast Boot...
SCEWIN_64.exe /i /ms "Fast Boot" /qv 0x0 /lang en-US
cls
echo. Disabling Power On By Device...
SCEWIN_64.exe /i /ms "Power On By Mouse" /qv 0x0 /lang en-US
SCEWIN_64.exe /i /ms "Power On By Keyboard" /qv 0x0 /lang en-US
cls
echo. Disabling Wake On Lan...
SCEWIN_64.exe /i /ms "Wake on LAN" /qv 0x0 /lang en-US
cls
echo. Enabling Bootup NumLock State...
SCEWIN_64.exe /i /ms "Bootup NumLock State" /qv 0x1 /lang en-US
cls
echo. Disabling Network Stack Driver...
SCEWIN_64.exe /i /ms "Network Stack Driver Support" /qv 0x0 /lang en-US
cls
echo. disabling XHCI Hand Off...
SCEWIN_64.exe /i /ms "XHCI Hand-Off" /qv 0x0 /lang en-US
cls
echo. disabling Legacy Usb Support...
SCEWIN_64.exe /i /ms "Legacy USB Support" /qv 0x0 /lang en-US
cls
echo. Disabling Resume By Alarm...
SCEWIN_64.exe /i /ms "Resume by Alarm" /qv 0x0 /lang en-US
cls
echo. Disabling Fullscreen Logo Display...
SCEWIN_64.exe /i /ms "Full Screen LOGO Show" /qv 0x0 /lang en-US
cls
echo. Disabling Security Device Support...
SCEWIN_64.exe /i /ms "Security Device Support" /qv 0x0 /lang en-US
cls
echo. Disabling CNVI Mode...
SCEWIN_64.exe /i /ms "CNVI Mode" /qv 0x0 /lang en-US
cls
echo. Disabling Intel RMT State...
SCEWIN_64.exe /i /ms "Intel RMT State" /qv 0x0 /lang en-US
cls
echo. Disabling Intel Ready Mode Technology...
SCEWIN_64.exe /i /ms "Intel Ready Mode Technology" /qv 0x0 /lang en-US
cls
echo. Disabling Energy Efficient P-state...
SCEWIN_64.exe /i /ms "Energy Efficient P-state" /qv 0x0 /lang en-US
cls
echo. Disabling Energy Performance Gain...
SCEWIN_64.exe /i /ms "Energy Performance Gain" /qv 0x0 /lang en-US
cls
echo. Disabling Energy Efficient Turbo...
SCEWIN_64.exe /i /ms "Energy Efficient Turbo" /qv 0x0 /lang en-US
cls
echo. Disabling BME DMA Mitigation...
SCEWIN_64.exe /i /ms "BME DMA Mitigation" /qv 0x0 /lang en-US
cls
echo. Disabling Enable RH Prevention...
SCEWIN_64.exe /i /ms "Enable RH Prevention" /qv 0x0 /lang en-US
cls
echo. Disabling Per Bank Refresh...
SCEWIN_64.exe /i /ms "Per Bank Refresh" /qv 0x0 /lang en-US
cls
echo. Disabling Intel(R) SpeedStep(tm)...
SCEWIN_64.exe /i /ms "Intel(R) SpeedStep(tm)" /qv 0x0 /lang en-US
cls
echo. Disabling cpu-states
SCEWIN_64.exe /i /ms "CPU C-States" /qv 0x0 /lang en-US
cls
echo. Disabling intel speed shift technology
SCEWIN_64.exe /i /ms "Intel(R) Speed Shift Technology" /qv 0x0 /lang en-US
cls
echo. Disabling Energy Efficient P-state
SCEWIN_64.exe /i /ms "Energy Efficient P-state" /qv 0x0 /lang en-US
cls
echo. Disabling me state
SCEWIN_64.exe /i /ms "ME State" /qv 0x0 /lang en-US
cls
echo. Disabling Power Down Mode
SCEWIN_64.exe /i /ms "Power Down Mode" /qv 0x0 /lang en-US
cls
echo.Energy Efficient Turbo
CEWIN_64.exe /i /ms "Energy Efficient Turbo" /qv 0x0 /lang en-US
cls
echo. Disabling TPM State
SCEWIN_64.exe /i /ms "TPM State" /qv 0x0 /lang en-US
cls
echo. Disabling command Rate Support
SCEWIN_64.exe /i /ms "command Rate Support" /qv 0x0 /lang en-US
cls
echo. Disabling RC6(Render Standby)
SCEWIN_64.exe /i /ms "RC6(Render Standby)" /qv 0x0 /lang en-US
cls
echo. Disabling Type C Support
SCEWIN_64.exe /i /ms "Type C Support" /qv 0x0 /lang en-US
cls
echo. Disabling LAN Wake From DeepSx
SCEWIN_64.exe /i /ms "LAN Wake From DeepSx" /qv 0x0 /lang en-US
cls
echo. Disabling PCH Cross Throttling
SCEWIN_64.exe /i /ms "PCH Cross Throttling" /qv 0x0 /lang en-US
cls
echo. Disabling Power Down Unused Lanes
SCEWIN_64.exe /i /ms "Power Down Unused Lanes" /qv 0x0 /lang en-US
cls
echo. Disabling BME DMA Mitigation
SCEWIN_64.exe /i /ms "BME DMA Mitigation" /qv 0x0 /lang en-US
cls
echo. Disablling ACPI Standby State
SCEWIN_64.exe /i /ms "ACPI Standby State" /qv 0x0 /lang en-US
cls
echo. Disabling USB2 PHY Sus Well Power Gating
SCEWIN_64.exe /i /ms "USB2 PHY Sus Well Power Gating" /qv 0x0 /lang en-US
cls
echo. Disabling HW Notification
SCEWIN_64.exe /i /ms "HW Notification" /qv 0x0 /lang en-US
cls
echo. Disabling DMI Link ASPM Control
SCEWIN_64.exe /i /ms "DMI Link ASPM Control" /qv 0x0 /lang en-US
cls
echo. Disabling PCIe Spread Spectrum Clocking
SCEWIN_64.exe /i /ms "PCIe Spread Spectrum Clocking" /qv 0x0 /lang en-US
cls
echo. Disabling C6DRAM
SCEWIN_64.exe /i /ms "C6DRAM" /qv 0x0 /lang en-US
cls
echo. Disabling Intel Virtualization Tech
SCEWIN_64.exe /i /ms "Intel Virtualization Tech" /qv 0x0 /lang en-US
cls
echo. Disabling CPU AES Instructions
SCEWIN_64.exe /i /ms "CPU AES Instructions" /qv 0x0 /lang en-US
cls
echo. Disabling EIST
SCEWIN_64.exe /i /ms "EIST" /qv 0x0 /lang en-US
cls
echo. Disabling Enable RH Prevention
SCEWIN_64.exe /i /ms "Enable RH Prevention" /qv 0x0 /lang en-US
cls
echo. Disabling Race To Halt
SCEWIN_64.exe /i /ms "Race To Halt" /qv 0x0 /lang en-US
cls
echo. Disabling Intel RMT State
SCEWIN_64.exe /i /ms "Intel RMT State" /qv 0x0 /lang en-US
cls
echo. Disabling Intel Adaptive Thermal Monitor
SCEWIN_64.exe /i /ms "Intel Adaptive Thermal Monitor" /qv 0x0 /lang en-US
cls
echo. Disabling HDC Control
SCEWIN_64.exe /i /ms "HDC Control" /qv 0x0 /lang en-US
cls
echo. Disabling SMM Code Access Check
SCEWIN_64.exe /i /ms "SMM Code Access Check" /qv 0x0 /lang en-US
cls
echo. Disabling SMM Use Delay Indication
SCEWIN_64.exe /i /ms "SMM Use Delay Indication" /qv 0x0 /lang en-US
cls
echo Disabling SMM Use Block Indication
SCEWIN_64.exe /i /ms "SMM Use Block Indication" /qv 0x0 /lang en-US
cls
echo. Disabling SMM Use SMM en-US Indication
SCEWIN_64.exe /i /ms "SMM Use SMM en-US Indication" /qv 0x0 /lang en-US
cls
echo. Disabling LTR
SCEWIN_64.exe /i /ms "LTR" /qv 0x0 /lang en-US
cls
echo. Enabling I/O Resources Padding
SCEWIN_64.exe /i /ms "I/O Resources Padding" /qv 0x20 /lang en-US
cls
echo. Enabling MMIO 32 bit Resources Padding
SCEWIN_64.exe /i /ms "MMIO 32 bit Resources Padding" /qv 0x80 /lang en-US
cls
echo. Enabling PFMMIO 32 bit Resources Padding
SCEWIN_64.exe /i /ms "PFMMIO 32 bit Resources Padding" /qv 0x80 /lang en-US
cls
echo Enabling PFMMIO 64 bit Resources Padding
SCEWIN_64.exe /i /ms "PFMMIO 64 bit Resources Padding" /qv 0x2000 /lang en-US
cls
echo. Disabling CNVI MODE
SCEWIN_64.exe /i /ms "CNVI MODE" /qv 0x0 /lang en-US
cls
echo. Disabling CWIFI SAR 
SCEWIN_64.exe /i /ms "CWIFI SAR" /qv 0x0 /lang en-US
cls
echo. Disabling CNVI MODE
SCEWIN_64.exe /i /ms "CNVI MODE" /qv 0x0 /lang en-US
cls
echo. Disabling WWAN Reset Workaround
SCEWIN_64.exe /i /ms "WWAN Reset Workaround" /qv 0x0 /lang en-US
cls
echo. Disabling WWAN Device
SCEWIN_64.exe /i /ms "WWAN Device" /qv 0x0 /lang en-US
cls
echo. Disabling C6DRAM
SCEWIN_64.exe /i /ms "C6DRAM" /qv 0x0 /lang en-US
cls
echo. Disabling 1394 controller
SCEWIN_64.exe /i /ms "1394 controller" /qv 0x0 /lang en-US
cls
echo. Disabling Legacy USB support
SCEWIN_64.exe /i /ms "Legacy USB support" /qv 0x0 /lang en-US
cls
echo. Disabling CPU Spread Spectrum
SCEWIN_64.exe /i /ms "CPU Spread Spectrum" /qv 0x0 /lang en-US
cls
echo. Disabling Execute Disable Bit
SCEWIN_64.exe /i /ms "Execute Disable Bit" /qv 0x0 /lang en-US
cls
echo. Disabling iGPU Multi-Monitor
SCEWIN_64.exe /i /ms "iGPU Multi-Monitor" /qv 0x0 /lang en-US
cls
echo. Disabling Power Saving Features...
SCEWIN_64.exe /i /ms "PEP TBT RP" /qv 0x0 /lang en-US
SCEWIN_64.exe /i /ms "PEP LAN(GBE)" /qv 0x0 /lang en-US
SCEWIN_64.exe /i /ms "PEP CSME" /qv 0x0 /lang en-US
SCEWIN_64.exe /i /ms "PEP SDXCE" /qv 0x0 /lang en-US
SCEWIN_64.exe /i /ms "PEP EMMC" /qv 0x0 /lang en-US
pause
echo Successfully Optimized Your Bios Settings, Please Restart Your PC...