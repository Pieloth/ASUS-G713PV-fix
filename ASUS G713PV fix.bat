@echo off
:: ASUS ROG tweaks 

set quiet=
if "%1"=="/q" set quiet=1
if "%1"=="/Q" set quiet=1

set "pausecls=(pause & cls)"

chcp 65001 > NUL

if not defined quiet (
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
echo 
echo Use also G Helper instead of Armoury Crate for even better stability
echo:
)
:: Get admin status
if exist %windir%\system32\config\systemprofile\* (
  echo  ]]] [42m[93m Admin rights ON =^> parameters will be applied[0m
  set admin=1
) else (
  echo  [7m[91m]]] Admin rights OFF =^> No change or parameters will be saved[0m
)
if not defined quiet %pausecls%
:: Hibernation enable and setup
:: set Fast Startup ON
set "Step=1.1/ (Re)-Activate Fast Startup"
call :ProcessKey add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Power" "HiberbootEnabled" "reg_dword" 1 
:: show hibernate after options
set "Step=1.2/ Add option 'Hibernation timeout' into legacy Power Settings advanced options"
call :ProcessKey add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\238C9FA8-0AAD-41ED-83F4-97BE242C8F20\9d7815a6-7ee4-497e-8888-515a05f02364" "Attributes" "reg_dword" 2
:: Activer hibernation

echo [93m1.3/ Activate Hibernation/Fast Startup : Sleep S0, hibernation, and Fast Startup available[0m
powercfg /h on
powercfg /a | findstr /v "^$"
if not defined quiet %pausecls%

:: Disable Core Isolation
set "Step=2/ Disable Core Isolation. After reboot, clic on 'Ignore' on yellow icon in 'Windows Sécurity'"
call :ProcessKey add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" "Enabled" "reg_dword" 0

:: Set 2 important Power Management registry keys
set "Step=3.1 et 3.2/ Power Management : IO coalescing timeout set to 60s and policy for devices powering down while the system is running set to power saving
call :ProcessKey add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\2e601130-5351-4d9d-8e04-252966bad054\c36f0eb4-2988-4a70-8eee-0884fc2c2433\DefaultPowerSchemeValues\381b4222-f694-41f0-9685-ff5bb260df2e" "ACSettingIndex" "reg_dword" 0x0000ea60
call :ProcessKey add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\4faab71a-92e5-4726-b531-224559672d19\DefaultPowerSchemeValues\381b4222-f694-41f0-9685-ff5bb260df2e" "ACSettingIndex" "reg_dword" 1

:: Reconfigure nVidia HDA audio driver for Idle Times
set "Step=4.1 et 4.2/ Modify Idle Time AC et DC for HDA nVidia driver"
call :ProcessKey add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4d36e96c-e325-11ce-bfc1-08002be10318}\0003\PowerSettings" "ConservationIdleTime" "REG_BINARY" 00000000 
call :ProcessKey add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4d36e96c-e325-11ce-bfc1-08002be10318}\0003\PowerSettings" "PerformanceIdleTime" "REG_BINARY" 00000000

:: Modify TDR Delay to long value to avoid Winlogon or nvlddmkm.dll crashes while in Modern Standby 
set "Step=5/ Modify Graphics drivers Tdr Delay"
call :ProcessKey add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" "TdrDelay" "reg_dword" 60 

echo:
echo ]]]  Now, [6m[91mPlease REBOOT computer [0mto apply changes and parameters!
echo:
if not defined quiet %pausecls%
goto :eof

:ProcessKey   - Processes the current key
::cls
echo [93m%step%[0m
echo -------------------
echo [34mRegistry key BEFORE change:[0m
reg query %2 /v %3 /t %4
echo:
echo [36mRegistry key CHANGE STATUS:[0m
if "%1" == "add" reg %1 %2 /v %3 /t %4 /d %5 /f
if "%1" == "delete" reg %1 %2 /v %3 /f
echo:
echo [35mRegistry key AFTER change:[0m
reg query %2 /v %3 /t %4
echo:
if not defined quiet %pausecls%
exit /b
