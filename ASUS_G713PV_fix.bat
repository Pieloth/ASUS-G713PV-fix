@echo off
:: ASUS ROG G713PV fix 

chcp 65001 > NUL

echo [37;90m[38;5;233m@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo [38;5;234m@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo [38;5;235m@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@[38;5;124m#[38;5;203m(((((([38;5;088m\%[38;5;235m@@@@@@@@@@@@
echo [38;5;236m@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@[38;5;234m4[38;5;203m(((((((((((([38;5;236m@@@@@@@@@@@@@@@@@@@
echo [38;5;237m@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@[38;5;161m([38;5;203m(((((((((([38;5;233m@[38;5;237m@@@@@@@@@@@@@@@@@@@@@@@@
echo [38;5;238m@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@[38;5;203m(((((((([38;5;203m(([38;5;238m@@@@@@@@@@[38;5;203m((((((((([38;5;238m@@@@@@@@@@
echo [38;5;239m@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@[38;5;203m(((((((([38;5;239m@@@@@@@@[38;5;203m(((((((((([38;5;239m@@@@@@@@@@@@@@@
echo [38;5;240m@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@[38;5;203m((((((([38;5;240m@@@@@@@[38;5;203m((((((((([38;5;240m@@@@@@[38;5;203m((([38;5;240m@@@@@@@@@@@@
echo [38;5;241m@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@[38;5;124m\%[38;5;203m(((((([38;5;241m@@@@@@[38;5;203m(((((((([38;5;241m@@@@@[38;5;161m([38;5;203m((((((([38;5;241m@@@@@@@@@@@@@
echo [38;5;242m@@@@@@@@@@@@[38;5;203m(([38;5;242m@@@@@@[38;5;203m([38;5;242m@@@@@@@@@@[38;5;203m(((((([38;5;242m@@@@@[38;5;203m((((((([38;5;242m@@@@@[38;5;203m((((((((((([38;5;242m@@@@@@@@@@@@@@@
echo [38;5;243m@@@@@@@@@@@@@[38;5;203m(((([38;5;243m@@@@[38;5;203m(((((([38;5;242m@[38;5;161m([38;5;203m(((([38;5;001m\%[38;5;243m@@@@[38;5;052m4[38;5;203m((((([38;5;161m([38;5;243m@@@@[38;5;203m((([38;5;243m@@@@@@[38;5;203m(((((([38;5;243m@@@@@@@@@@@@@@@@
echo [38;5;244m@@@@@@@@@@@@@@@[38;5;001m\%[38;5;203m((([38;5;161m([38;5;244m@@@[38;5;203m((((((([38;5;244m@@@@@[38;5;203m((((([38;5;244m4[38;5;244m@@@@@@@@@@@@@@@@[38;5;203m(((((([38;5;244m@@@@@@@@@@@@@@@@@
echo [38;5;245m@@@@@@@@@@@@@@@@@@@@@@[38;5;203m([38;5;245m@[38;5;203m(((([38;5;245m@@@[38;5;203m(((([38;5;203m(([38;5;245m@@@@@@@@@@@@@@@@@@[38;5;203m(((((([38;5;245m@@@@@@@@@@@@@@@@@@@
echo [38;5;246m@@@@@@@@@@@@@@@@@@@@@@@@@@[38;5;203m(([38;5;203m([38;5;246m@@@@[38;5;088m\%[38;5;203m(((((((([38;5;246m@@@@@@@@@@[38;5;203m((((((([38;5;246m@@@@@@@@@@@@@@@@@@@@@
echo [38;5;247m@@@@@@@@@@@@@@@@@@@@@@@@@@@@@[38;5;203m(([38;5;247m@@@@@@@@@@[38;5;203m((((((((((((((([38;5;161m#[38;5;247m@@@@@@@@@@@@@@@@@@@@@@@
echo [38;5;248m@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo [38;5;249m@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo:
echo                  [91m]]] Configure parameters for ASUS G713PV [[[[0m
echo:
echo This app sets up some parameters and registries to best stabilize this laptop
echo: 
echo Use also G Helper instead of Armoury Crate for even better stability ([91mhttps://github.com/seerge/g-helper/releases[0m)
echo:

set "pausecls=(pause & cls)"
set quiet=
set rollback=

:ReadParams
if "%~1" == "" goto :EndReadParams
if /I "%~1" == "/q" set quiet=1
if /I "%~1" == "/r" set rollback=1
shift
goto :ReadParams
:EndReadParams

:: Retreive legacy active power scheme GUID from 1st line of powercfg /q
for /f "delims=" %%i in ('powercfg /q') do set actpowplan=%%i & goto :EndGUID
:EndGUID
for /f "tokens=2 delims=:" %%i in ("%actpowplan%") do set actpowplan1=%%i
for /f "tokens=1" %%i in ("%actpowplan1%") do set actpowplanguid=%%i
:: Probably wrong assumption. Boot will always use default Local Machine balanced GUID, before session is opened and active power scheme modified. 
:: So force default GUID here 
set "actpowplanguid=381b4222-f694-41f0-9685-ff5bb260df2e"

set "RegKeyHeader=HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control"

:: Retreive Media classes that need power Idle Time adjustment.
:: See https://learn.microsoft.com/en-us/windows-hardware/drivers/audio/audio-device-class-inactivity-timer-implementation
for /f "delims=" %%j in ('reg query "%RegKeyHeader%\Class\{4d36e96c-e325-11ce-bfc1-08002be10318}" /s /f "NVIDIA*Audio"') do set nVidiaHDA=%%j & goto :EndnVidiaHDA
:EndnVidiaHDA
for /f "delims=" %%j in ('reg query "%RegKeyHeader%\Class\{4d36e96c-e325-11ce-bfc1-08002be10318}" /s /f "Realtek*Audio"') do set Realtek=%%j & goto :EndRealtek
:EndRealtek
for /f "delims=" %%j in ('reg query "%RegKeyHeader%\Class\{4d36e96c-e325-11ce-bfc1-08002be10318}" /s /f "AMD Streaming Audio"') do set AMDstreaming=%%j & goto :EndAMDstreaming
:EndAMDstreaming
:: Remove spaces in strings
set nVidiaHDA=%nVidiaHDA: =%
set Realtek=%Realtek: =%
set AMDstreaming=%AMDstreaming: =%

if defined rollback (set FastStart=0) else (set FastStart=1)
if defined rollback (set HibGUI=1) else (set HibGUI=2)
if defined rollback (set hibernate=off) else (set hibernate=on)
if defined rollback (set coreisolation=1) else (set coreisolation=0)
if defined rollback (set signInTimeout=0x384) else (set signInTimeout=0)
if defined rollback (set policypwrdn=0) else (set policypwrdn=1)
if defined rollback (set netACstby=1) else (set netACstby=0)
if defined rollback (set modeStby=0) else (set modeStby=1)
if defined rollback (set TdrDelay=2) else (set TdrDelay=0x1e)
if defined rollback (set PwrIdleState=03000000) else (set PwrIdleState=00000000)
if defined rollback (set nvidletime=04000000) else (set nvidletime=00000000)
if defined rollback (set amdidletime=03000000) else (set amdidletime=00000000)
if defined rollback (set RBEX=ROLLBACK:) else (set RBEX=SETTING:)
if defined rollback echo [6m[91mROLLBACK PROCEDURE TO WINDOWS 11 DEFAULTS WILL BE APPLIED TO REGISTRY ENTRIES[0m

:: Get admin status
if exist %windir%\system32\config\systemprofile\* (
  echo  ]]] [42m[93m Run with Admin level =^> parameters will be applied[0m
  set admin=1
) else (
  echo  [7m[91m]]] Run without Admin level =^> No change or parameters will be saved, current and target parameters will be shown[0m
)
echo:
::if not defined quiet %pausecls%
if defined quiet goto :StartSettings
choice /c iq /m "Apply settings (I)nteractive or (Q)uiet"
if %errorlevel% equ 1 cls & goto :StartSettings
set quiet=1

:StartSettings
:: 1 - Hibernation, Fast Startup enable and setup
:: set Fast Startup ON
set "Step=1.1/ %RBEX% (Re)-Activate Fast Startup, possible and safe if power down policy is changed also (see later)"
call :ProcessKey add "%RegKeyHeader%\Session Manager\Power" "HiberbootEnabled" "reg_dword" %FastStart% 
:: show "hibernate after" option in the Legacy "Advanced Power Settings"
set "Step=1.2/ %RBEX% Add option 'Hibernation timeout' into legacy Power Settings advanced options &echo for easy 'Hibernate after' setting. Set also there the desired value in minutes"
call :ProcessKey add "%RegKeyHeader%\Power\PowerSettings\238C9FA8-0AAD-41ED-83F4-97BE242C8F20\9d7815a6-7ee4-497e-8888-515a05f02364" "Attributes" "REG_DWORD" %HibGUI%
:: Enable/disable hibernation. Rollback will disable also 1.1 and 1.2
echo [93m1.3/ %RBEX% Enable Hibernation and Fast Startup : Sleep S0, Hibernation, and Fast Startup will be available[0m
if not defined admin (
	echo [31mNO CHANGE performed in non Admin privilege[0m
	goto :curpwr
)
call :QueryAction "%RBEX% Enable Hibernation and Fast Startup"
if %errorlevel% equ 1 powercfg /h %hibernate%
if %errorlevel% equ 2 echo [31mSkipped, NO CHANGE performed. [0m

:curpwr
echo:
echo Current Power configuration is now:
powercfg /a | findstr /v "^$"
if not defined quiet %pausecls%

:: 2 - Disable Core Isolation
set "Step=2/ %RB% Disable Core Isolation to fix all Fast Flckers.&echo After reboot, clic on 'Ignore' on yellow icon in 'Windows Sécurity'"
call :ProcessKey add "%RegKeyHeader%\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" "Enabled" "REG_DWORD" %coreisolation%

:: 3 - Set "Request a reconnection after your absence" to "Always " after leaving. This fixes Winlogon.exe crash while sleep and black logon screen/lost nVidia icons
set "Step=3/ %RBEX% Set: 'Request a reconnection after your absence' timeout to 'Always' ,&echo to fix black logon screen and nVidia icons lost in tasbkar"
call :ProcessKey add "HKEY_CURRENT_USER\Control Panel\Desktop" "DelayLockInterval" "REG_DWORD" %signInTimeout%

:: 4 - Tweak Disconnected Standby behavior, avoid crashs, and faster DRIPS
:: Important Power Management registry key, as some device driver seem not to handle properly timeout for idle mode, leading to laptop crash on DRIPS sleep or wake up
:: https://learn.microsoft.com/en-us/windows-hardware/customize/power-settings/no-subgroup-settings-device-idle-policy
set "Step=4.1/ %RBEX% policy for devices powering down while the system is running (power saving for AC and DC).&echo Changing this key is ABSOLUTELY NECESSARY to mix Modern Standby, Hibernate and Fast Startup."
call :ProcessKey add "%RegKeyHeader%\Power\PowerSettings\4faab71a-92e5-4726-b531-224559672d19\DefaultPowerSchemeValues\%actpowplanguid%" "ACSettingIndex" "REG_DWORD" %policypwrdn%
:: NOT RECOMMENDED due to suspicious Freeze after MSO: Enhance Disconnected standby experience in Aggressive mode for faster DRIPS
:: So set it to normal. 
set "Step=4.2a and 4.2b/ %RBEX% Disconnected Standby mode in AC and DC forced to *Normal* (W11 default), Aggressive can cause a Freeze after MSO is run"
call :ProcessKey add "%RegKeyHeader%\Power\PowerSettings\68afb2d9-ee95-47a8-8f50-4115088073b1\DefaultPowerSchemeValues\%actpowplanguid%" "ACSettingIndex" "REG_DWORD" 0
call :ProcessKey add "%RegKeyHeader%\Power\PowerSettings\68afb2d9-ee95-47a8-8f50-4115088073b1\DefaultPowerSchemeValues\%actpowplanguid%" "DCSettingIndex" "REG_DWORD" 0
:: RECOMMENDED: Disable networking in standby in AC (DC should not be necessary) for more quiet Modern Standby sleep!
::set "Step=3.2/ %RBEX% Networking connectivity in Standby: Disabled for AC. Connectivity in DC will stay to: 'managed by Windows'"
::call :ProcessKey add "%RegKeyHeader%\Power\PowerSettings\f15576e8-98b7-4186-b944-eafa664402d9\DefaultPowerSchemeValues\%actpowplanguid%" "ACSettingIndex" "REG_DWORD" %netACstby%

:: Tested here with ASUS default drivers 
:: Realtek 6.0.9549.1, AMD Graphics 31.0.14038.8002, AMD Chipset 1.2.0.120, nVidia 31.0.15.3645 with HDA sound 1.3.40.14
:: AsMedia HOTFIX FIRMWARE 2006_1E : It appears NECESSARY to RE-INSTALL each time after CHANGING DRIVERS ESPECIALLY CHIPSET, if unstability is still seen

:: Increase TdrDelay to avoid nvlddmkm crashes. A well known tweak, just google for it
set "Step=5.0/ %RBEX% Increase default Windows 'TdrDelay' for Graphics drivers, to avoid nvlddmkm crashes.&echo A well known but necessary tweak"
call :ProcessKey add "%RegKeyHeader%\GraphicsDrivers" "TdrDelay" "REG_DWORD" %TdrDelay%

:: 5 - Force Idle states to D0 for nVidia HDA, AMD and Realtek audio drivers. Note Realtek forces Idle times, not Idle power state
:: Nvidia is necessary. Realtek and AMD : Uncomment lines if necessary, in case of unstability with sound
:: https://learn.microsoft.com/en-us/windows-hardware/drivers/audio/portcls-registry-power-settings
set "Step=6.1/ %RBEX% Stabilize nVidia sound device: Force Idle Power State to D0 in AC and DC for nVidia HDA driver.&echo         NOTE: RERUN this script if you change the nVidia driver!"
call :ProcessKey add "%nVidiaHDA%\PowerSettings" "IdlePowerState" "REG_BINARY" %PwrIdleState%
set "Step=6.1a and 6.1b/ %RBEX% Stabilize nVidia sound device: Disable Idle Time AC and DC for nVidia HDA driver.&echo         NOTE: RERUN this script if you change the nVidia driver!"
call :ProcessKey add "%nVidiaHDA%\PowerSettings" "ConservationIdleTime" "REG_BINARY" %nvidletime% 
call :ProcessKey add "%nVidiaHDA%\PowerSettings" "PerformanceIdleTime" "REG_BINARY" %nvidletime%
set "Step=6.2/ %RBEX% Stabilize sound devices: Force Idle Power State to D0 in AC and DC for Realtek Audio driver"
call :ProcessKey add "%Realtek%\PowerSettings" "IdlePowerState" "REG_BINARY" %PwrIdleState%
set "Step=6.3/ %RBEX% Stabilize sound devices: Force Idle Power State to D0 in AC and DC for AMD Streaming Audio driver (if exists)"
call :ProcessKey add "%AMDstreaming%\PowerSettings" "IdlePowerState" "REG_BINARY" %PwrIdleState%
:: Uncomment 3 next lines if AMD Streaming Audio driver is installed, and sound issues happen
set "Step=6.3a and 6.3b/ %RBEX% Stabilize sound devices: Disable Idle Time AC and DC for AMD Streaming Audio driver (if exists)"
call :ProcessKey add "%AMDstreaming%\PowerSettings" "ConservationIdleTime" "REG_BINARY" %amdidletime% 
call :ProcessKey add "%AMDstreaming%\PowerSettings" "PerformanceIdleTime" "REG_BINARY" %amdidletime%

if not defined admin (
	echo:
	echo [7m[91m    ---   Rerun this script in Admin mode to be able to set all these parameters   ---   [0m
	echo:
	timeout /t 10 /nobreak
	goto :eof
)

if defined quiet (
	echo ]]]  Now, [6m[91mPlease REBOOT MANUALLY computer [0mto apply changes and parameters!
	timeout /t 10 /nobreak
	goto :eof
)

set "Trbt=15"
echo:
echo ]]]  Now, [6m[91mPlease REBOOT computer [0mto apply changes and parameters!   [[[
echo:
echo [7m[91m]]]  Also, rerun the AsMedia Hotfix 2006 1E Firmware Updater, in case of Chipset driver change, or if unstability is experienced   [[[[0m
echo:
call :QueryAction "Do you want to reboot computer in %Trbt% seconds"
if %errorlevel% equ 1 (
	echo shutdown in %Trbt% seconds. ]]] SAVE ALL OPENED DOCUMENTS [[[
	shutdown /r /t %Trbt%
	timeout /t %Trbt% /nobreak
)
goto :eof

:QueryAction
if defined quiet exit /b 1
choice /c yn /m %1 
exit /b %errorlevel

:ProcessKey   - Processes the current registry key
::cls
echo [93m%step%[0m
echo -------------------
echo [34mCurrent Registry key BEFORE change:[0m
if "%3" NEQ "" ( reg query %2 /v %3 /t %4 
) else ( reg query %2 /f "*" /k )
if errorlevel 1 (
	echo [91mWARNING:
	echo DID NOT FIND THE CORRESPONDING REGISTRY KEY.
	echo THIS ACTION WILL BE SKIPPED, NOTHING WILL BE CHANGED.
	echo PLEASE CHECK MANUALLY REGISTRY FOR THIS REGISTRY KEY[0m
	if not defined quiet cls & exit /b
	goto :EndProcessKey
)
echo:
echo [35mRegistry key TARGET change:[0m
echo %1:
echo %2  
echo       %3    %4    %5[0m

echo:
echo [36mRegistry key CHANGE STATUS:[0m
if not defined admin (
	echo [31mNO CHANGE performed in non admin privilege[0m
	goto :EndProcessKey
)

call :QueryAction "Confirm apply this setting"
if %errorlevel% neq 1 (
	echo [31mSkipped, NO CHANGE performed[0m
	goto :EndProcessKey
)

if "%1" == "add" reg %1 %2 /v %3 /t %4 /d %5 /f
if "%1" == "delete" reg %1 %2 /f
echo:
echo [32mRegistry key AFTER change:[0m
if "%3" NEQ "" ( 
	reg query %2 /v %3 /t %4 
) else ( 
	reg query %2 /f "*" /k 
)

:EndProcessKey
echo:
if not defined quiet %pausecls%
exit /b
