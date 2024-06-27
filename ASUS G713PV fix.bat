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
echo                    [91m]]] Paramétrage installation ASUS G713PV [[[[0m
echo:
echo Cet installateur permet de configurer quelques paramètres afin de stabiliser 
echo au mieux le fonctionnement de ce portable
echo Utiliser également G Helper au lieu d'Armoury Crate pour plus de stabilité 
echo:
)
:: Get admin status
if exist %windir%\system32\config\systemprofile\* (
  echo  ]]] [42m[93m Droits admin ON =^> les paramétrages seront effectués[0m
  set admin=1
) else (
  echo  [7m[91m]]] Droits admin OFF =^> Aucun changement ni Paramétrage ne sera réalisé[0m
)
if not defined quiet %pausecls%
:: Hibernation enable and setup
:: set Fast Startup ON
set "Step=2.1/ Activer le démarrage rapide Fast Startup"
call :ProcessKey add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Power" "HiberbootEnabled" "reg_dword" 1 
:: show hibernate after options
set "Step=2.2/ Ajouter l'option 'Configuration du délai avant hibernation' dans les options avancées d'alimentation"
call :ProcessKey add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\238C9FA8-0AAD-41ED-83F4-97BE242C8F20\9d7815a6-7ee4-497e-8888-515a05f02364" "Attributes" "reg_dword" 2
:: Activer hibernation

echo [93m2.3/ Activer Hibernation/Fast Startup : état de veille S0, veille prolongée et démarrage rapide disponibles[0m
powercfg /h on
powercfg /a | findstr /v "^$"
if not defined quiet %pausecls%

:: Disable Core Isolation
set "Step=3/ Désactiver l'isolation du noyau. Après reboot, cliquer sur 'Ignorer' sur l'icone jaune dans 'Sécurité Windows'"
call :ProcessKey add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" "Enabled" "reg_dword" 0

:: Set 2 important Power Management registry keys
set "Step=4.1 et 4.2/ Power Management : IO coalescing timeout à 60s et policy for devices powering down while the system is running à power saving
call :ProcessKey add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\2e601130-5351-4d9d-8e04-252966bad054\c36f0eb4-2988-4a70-8eee-0884fc2c2433\DefaultPowerSchemeValues\381b4222-f694-41f0-9685-ff5bb260df2e" "ACSettingIndex" "reg_dword" 0x0000ea60
call :ProcessKey add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\4faab71a-92e5-4726-b531-224559672d19\DefaultPowerSchemeValues\381b4222-f694-41f0-9685-ff5bb260df2e" "ACSettingIndex" "reg_dword" 1

:: Reconfigure nVidia HDA audio driver for Idle Times
set "Step=6.1 et 6.2/ Modifier les Idle Time AC et DC du driver HDA nVidia"
call :ProcessKey add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4d36e96c-e325-11ce-bfc1-08002be10318}\0003\PowerSettings" "ConservationIdleTime" "REG_BINARY" 00000000 
call :ProcessKey add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4d36e96c-e325-11ce-bfc1-08002be10318}\0003\PowerSettings" "PerformanceIdleTime" "REG_BINARY" 00000000

:: Modify TDR Delay to long value to avoid Winlogon or nvlddmkm.dll crashes while in Modern Standby 
set "Step=7/ Modifier le Tdr Delay des drivers graphiques pour éviter le crash Winlogon en veille Modern Standby"
call :ProcessKey add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" "TdrDelay" "reg_dword" 60 

echo:
echo ]]]  A présent, [6m[91mil faut REDEMARRER le PC [0mpour appliquer les changements de paramétrages !
echo:
if not defined quiet %pausecls%
goto :eof

:ProcessKey   - Processes the current key
::cls
echo [93m%step%[0m
echo -------------------
echo [34mClé de registre Avant :[0m
reg query %2 /v %3 /t %4
echo:
echo [36mModification de la clé :[0m
if "%1" == "add" reg %1 %2 /v %3 /t %4 /d %5 /f
if "%1" == "delete" reg %1 %2 /v %3 /f
echo:
echo [35mClé de registre Après :[0m
reg query %2 /v %3 /t %4
echo:
if not defined quiet %pausecls%
exit /b
