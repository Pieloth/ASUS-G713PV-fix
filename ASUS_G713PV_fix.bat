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
echo                    [91m]]] Install parameters for ASUS G713PV [[[[0m
echo:
echo This installer sets up some parameters and registries to best stabilize this laptop
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

if defined rollback (set hibernate=off) else (set hibernate=on)
if defined rollback (set coreisolation=1) else (set coreisolation=0)
if defined rollback (set policypwrdn=0) else (set policypwrdn=1)
if defined rollback (set netACstby=1) else (set netACstby=0)
if defined rollback (set PwrIdleState=03000000) else (set PwrIdleState=00000000)
if defined rollback (set RB=ROLLBACK:) else (set RB=EXECUTE:)
if defined rollback echo [6m[91mROLLBACK PROCEDURE TO DEFAULTS WILL BE APPLIED TO REGISTRY ENTRIES[0m

:: Get admin status
if exist %windir%\system32\config\systemprofile\* (
  echo  ]]] [42m[93m Run with Admin level =^> parameters will be applied[0m
  set admin=1
) else (
  echo  [7m[91m]]] Run without Admin level =^> No change or parameters will be saved, current and target parameters will be shown[0m
)
if not defined quiet %pausecls%

:: 1 - Hibernation enable and setup
:: set Fast Startup ON (not rollbacked)
set "Step=1.1/ (Re)-Activate Fast Startup"
call :ProcessKey add "%RegKeyHeader%\Session Manager\Power" "HiberbootEnabled" "REG_DWORD" 1 
:: show hibernate after options (not rollbacked)
set "Step=1.2/ Add option 'Hibernation timeout' into legacy Power Settings advanced options"
call :ProcessKey add "%RegKeyHeader%\Power\PowerSettings\238C9FA8-0AAD-41ED-83F4-97BE242C8F20\9d7815a6-7ee4-497e-8888-515a05f02364" "Attributes" "REG_DWORD" 2
:: Enable/disable hibernation. Rollback will disable also 1.1 and 1.2
echo [93m1.3/ %RB% Enable Hibernation/Fast Startup : Sleep S0, hibernation, and Fast Startup will be available[0m
powercfg /h %hibernate%
if not defined admin echo [31mNO CHANGE performed. Current Power configuration is:[0m
powercfg /a | findstr /v "^$"
if not defined quiet %pausecls%

:: 2 - Disable Core Isolation
set "Step=2/ %RB% Disable Core Isolation. After reboot, clic on 'Ignore' on yellow icon in 'Windows Sécurity'"
call :ProcessKey add "%RegKeyHeader%\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" "Enabled" "REG_DWORD" %coreisolation%

:: 3 - Set important Power Management registry keys
set "Step=3.1/ %RB% policy for devices powering down while the system is running (power saving for AC and DC)
call :ProcessKey add "%RegKeyHeader%\Power\PowerSettings\4faab71a-92e5-4726-b531-224559672d19\DefaultPowerSchemeValues\%actpowplanguid%" "ACSettingIndex" "REG_DWORD" %policypwrdn%
:: STRONGLY RECOMMENDED: Disable networking in standby in AC and/or DC for more quiet Modern Standby sleep!
set "Step=3.2/ %RB% Networking connectivity in Standby (Disable networking in Standby for AC.)
call :ProcessKey add "%RegKeyHeader%\Power\PowerSettings\f15576e8-98b7-4186-b944-eafa664402d9\DefaultPowerSchemeValues\%actpowplanguid%" "ACSettingIndex" "REG_DWORD" %netACstby%

:: 4 - Force Idle states to D0 for nVidia HDA, AMD and Realtek audio drivers. Note Realtek forces Idle times, not Idle power state
set "Step=4.1/ %RB% Force Idle Power State to D0 in AC and DC for AMD Streaming Audio driver"
call :ProcessKey add "%AMDstreaming%\PowerSettings" "IdlePowerState" "REG_BINARY" %PwrIdleState%
set "Step=4.2/ %RB% Force Idle Power State to D0 in AC and DC for nVidia HDA driver"
call :ProcessKey add "%nVidiaHDA%\PowerSettings" "IdlePowerState" "REG_BINARY" %PwrIdleState%
set "Step=4.3/ %RB% Force Idle Power State to D0 in AC and DC for Realtek Audio driver"
call :ProcessKey add "%Realtek%\PowerSettings" "IdlePowerState" "REG_BINARY" %PwrIdleState%

if defined quiet goto :eof
if not defined admin goto :eof
echo:
echo ]]]  Now, [6m[91mPlease REBOOT computer [0mto apply changes and parameters!
echo:
set /p continue="Do you want to reboot computer in 30 seconds? (Y/n): "
if /I "%continue%" == "y" call :DoShutdown
if /I "%continue%" == "" call :DoShutdown
goto :eof

:DoShutdown
echo shutdown in 30 seconds. ]]] CLOSE ALL DOCUMENTS [[[
shutdown /r
timeout /t 30
exit /b

:ProcessKey   - Processes the current registry key
::cls
echo [93m%step%[0m
echo -------------------
echo [34mCurrent Registry key BEFORE change:[0m
if "%3" NEQ "" ( reg query %2 /v %3 /t %4 
) else ( reg query %2 /f "*" /k )
if errorlevel 1 (
	echo [91mDID NOT FIND KEY %2 value %3 type %4
	echo PLEASE CHECK MANUALLY REGISTRY FOR THIS KEY[0m
	goto :EndProcessKey
)
echo:
echo [36mRegistry key CHANGE STATUS:[0m
if not defined admin (
	echo [31mNO CHANGE performed[0m
) else (
	if "%1" == "add" reg %1 %2 /v %3 /t %4 /d %5 /f
	if "%1" == "delete" reg %1 %2 /f
)

echo:
if defined admin (
	echo [35mRegistry key AFTER change:[0m
	if "%3" NEQ "" ( reg query %2 /v %3 /t %4 
	) else ( reg query %2 /f "*" /k )
) else (
	echo [35mRegistry key TARGET change:[0m
	echo %1:
	echo %2  
	echo       %3    %4    %5[0m
)
:EndProcessKey
echo:
if not defined quiet %pausecls%
exit /b
