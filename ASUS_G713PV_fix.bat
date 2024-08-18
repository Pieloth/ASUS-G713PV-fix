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
echo Use also G Helper instead of Armoury Crate for even better stability
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
for /f "delims=" %%i in ('powercfg /q') do set actpowplan=%%i & goto :stop
:stop
for /f "tokens=2 delims=:" %%i in ("%actpowplan%") do set actpowplan1=%%i
for /f "tokens=1" %%i in ("%actpowplan1%") do set actpowplanguid=%%i

set "RegKeyHeader=HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control"

if defined rollback (set hibernate=off) else (set hibernate=on)
if defined rollback (set coreisolation=1) else (set coreisolation=0)
if defined rollback (set policypwrdn=0) else (set policypwrdn=1)
if defined rollback (set netACstby=1) else (set netACstby=0)
::if defined rollback (set netDCstby=2) else (set netDCstby=0)
if defined rollback (set nvidletime=04000000) else (set nvidletime=00000000)
if defined rollback (set rtkidletime=05000000) else (set rtkidletime=00000000)
if defined rollback (set amdidletime=03000000) else (set amdidletime=00000000)
if defined rollback set RB=ROLLBACK
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

:: 3 - Set 3 important Power Management registry keys
set "Step=3.1/ %RB% policy for devices powering down while the system is running (power saving for AC and DC)
call :ProcessKey add "%RegKeyHeader%\Power\PowerSettings\4faab71a-92e5-4726-b531-224559672d19\DefaultPowerSchemeValues\%actpowplanguid%" "ACSettingIndex" "REG_DWORD" %policypwrdn%
:: UNDER TEST : Disable networking in standby to avoid Winlogon crashes in standby
set "Step=3.2/ %RB% Networking connectivity in Standby (Disable networking in Standby for AC.)
call :ProcessKey add "%RegKeyHeader%\Power\PowerSettings\f15576e8-98b7-4186-b944-eafa664402d9\DefaultPowerSchemeValues\%actpowplanguid%" "ACSettingIndex" "REG_DWORD" %netACstby%
::set "Step=3.3/ %RB% Networking connectivity in Standby (Disable networking in Standby for DC.). Normally, not needed in DC
::call :ProcessKey add "%RegKeyHeader%\Power\PowerSettings\f15576e8-98b7-4186-b944-eafa664402d9\DefaultPowerSchemeValues\%actpowplanguid%" "DCSettingIndex" "REG_DWORD" %netDCstby%

:: 4 - Reconfigure nVidia HDA, Realtek and AMD audio drivers for Idle Times
set "Step=4.1 et 4.2/ %RB% Modify Idle Time AC and DC for HDA nVidia driver"
call :ProcessKey add "%RegKeyHeader%\Class\{4d36e96c-e325-11ce-bfc1-08002be10318}\0003\PowerSettings" "ConservationIdleTime" "REG_BINARY" %nvidletime% 
call :ProcessKey add "%RegKeyHeader%\Class\{4d36e96c-e325-11ce-bfc1-08002be10318}\0003\PowerSettings" "PerformanceIdleTime" "REG_BINARY" %nvidletime%
set "Step=5.1 et 5.2/ %RB% Modify Idle Time AC and DC for Realtek driver"
call :ProcessKey add "%RegKeyHeader%\Class\{4d36e96c-e325-11ce-bfc1-08002be10318}\0005\PowerSettings" "ConservationIdleTime" "REG_BINARY" %rtkidletime% 
call :ProcessKey add "%RegKeyHeader%\Class\{4d36e96c-e325-11ce-bfc1-08002be10318}\0005\PowerSettings" "PerformanceIdleTime" "REG_BINARY" %rtkidletime%
set "Step=6.1 et 6.2/ %RB% Modify Idle Time AC and DC for AMD audio driver"
call :ProcessKey add "%RegKeyHeader%\Class\{4d36e96c-e325-11ce-bfc1-08002be10318}\0007\PowerSettings" "ConservationIdleTime" "REG_BINARY" %amdidletime% 
call :ProcessKey add "%RegKeyHeader%\Class\{4d36e96c-e325-11ce-bfc1-08002be10318}\0007\PowerSettings" "PerformanceIdleTime" "REG_BINARY" %amdidletime%

if defined quiet goto :eof
if not defined admin goto :eof
echo:
echo ]]]  Now, [6m[91mPlease REBOOT computer [0mto apply changes and parameters!
echo:
set /p continue="Do you want to reboot computer in 30 seconds? (y/n): "
if /I "%continue%" == "y" (
	echo shutdown in 30 seconds.
	shutdown /r
)
goto :eof

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