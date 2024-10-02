# Batch script: ASUS_G713PV_fix.bat 
A few Windows 11 settings tweaks in order to fix laptop ASUS G713PV unstabilities.

Possibly works on other models from the same brand or product range too
## Introduction
This .bat script sets a few parameters in Windows 11 registry, to stabilize ASUS G713PV laptop. 

Designed and tested on this laptop. Likely to be used also on other laptop from same model range.
## Issues solved
Summary of different G713PV laptop issues which are 100% solved or almost, and status after using this utility batch script.

**Solved** means here: **Not experienced this anymore** 

|Issues on G713PV |  Comments |
|-------|-----|
|Laptop screen Fast Flickers and overall stability |Fixed with: Set to "Always" the Windows setting/Accounts: "If you’ve been away, when should Windows require you to sign in again?".</br>You have to sign in each time, but "Never" might work too. </br> Core Isolation and security can be fully enabled as per default Windows 11 setting, but 100% Flicker Free is obtained after disabling Core Isolation.|
|Black login screen (no *Windows Spotlight* image) after wake up from Modern Standby, with nVidia icons in taskbar disappear|Fixed with same Fast Flickers setting|
|Modern Standby with Hibernation/Fast Startup enabled freezes laptop on sleep | Bonus: Laptop now start really faster from Power Off or Hibernation!
|Laptop crash/freeze on Wake up from Modern Standby|Fix with Power Settings registry tweaks: Policy for devices powering down while the system is running|
|nVidia nvlddmkm.dll crash during Modern Standby|Increase TdrDelay fixes this, a common setting on dual GPU computers |
|Sound issues, especially with nVidia HDA sound driver on external HDMI monitor: sound crackling, crash, HDMI sound channel loss. Can mess also Realtek sound on switching sound|Stay with OEM ASUS official 6.0.9549.1 .  </br>For AMD Adrenalin install, remove AMD Streaming audio driver helps. </br>nVidia, Realtek HDA Audio Idle Power to D0 driver, Performance and Conservative Idlt Timeouts tweaks stops messing and stabilizes whole laptop. Also valid for AMD Streaming driver if still present|
|Random reboots| Due to misconfiguration between Chipset drivers and AsMedia Firmware. </br>IMPERATIVE to rerun AsMedia Hotfix 2006_1E EACH TIME after modifying Chipsets drivers, to align AsMedia Firmware with new Chipset drivers|

## Hints with Microsoft Modern Standby
> [!NOTE]
> A good [White paper here](https://dl.dell.com/manuals/all-products/esuprt_solutions_int/esuprt_solutions_int_solutions_resources/client-mobile-solution-resources_white-papers45_en-us.pdf) to understand all subtilities of Modern Standby

> [!WARNING]
> Modern Standby is not and will never be former S3 sleep. 
>
The way Microsoft wants laptops to sleep, somehow like a smartphone.

Biggest difference with S3 stands in that sleep is not immediate. 

Windows 11 runs an Orchestrator at standby start, performing maintenance tasks, before letting laptop to go to sleep. 

Delay between 1 to more than 30 minutes after standby start!

Huge step ahead: mixing Modern Standby and Hibernation now possible without freeze. 

Hibernation recommended to start at least 1 hour after Modern Standby start, so that Modern Standby Orchestrator can do its duty and saves SSD lifetime too

Did set it to 2 hours, similar to former legacy default Windows settings. 

## Prerequisites on Modern Standby and Legacy Power Schemes to use this script
> [!IMPORTANT]
> The intent her is to have Modern Standby ENABLED
>
> In case previously disabled, better to re-enable it. It can be used now along with Hibernation 

All tweaks are applied to the **Default Windows 11 Power Scheme, Balanced, defined in Registry for Local Machine**

Normally, if Modern Standby is enabled, there should be only 1 legacy Power Scheme left: **Balanced** (not talking here about the 3 Windows 11 Modern Power Plans: Power saving, normal, performance, in Windows 11 settings).

Current Legacy Power Scheme in use can be displayed with admin command line: `powercfg /L` . The GUID with the star at end of line is the one currently active

Script uses the GUID for the default Balanced Power Scheme, with Power scheme GUID: 381b4222-f694-41f0-9685-ff5bb260df2e

> [!WARNING]
> Script currently will not work for other Power Schemes, default one is used. But this can be modified in the script if needed for specific configurations

## Software configuration used
This software configuration is used for set up and tests. Other versions can be used, but remember to reprogram AsMedia device, in case of changing Chipset drivers. 

Also, rerun this script in case of nVidia driver change, to reapply power saving settings to nVidia HDA audio driver. 

| device | driver or software version |
|-------| -------|
|Realtek Audio|6.0.9549.1 ASUS driver. Updating this driver seems not advised, as it may create conflicts with nVidia audio| 
|Mediatek Bluetooth| 1.1037.2.433 ASUS driver|
|AMD Graphics |ASUS AMD graphics driver, or Adrenalin (24.5.1) Full, minimal, or drivers only install. </br>For Adrenalin, Better remove AMD Streaming audio driver from Device Manager / audio, video, games controllers section, which conflicts with nVidia and Realtek audio drivers. <br/>Note that chipset updates require reinstallation of ASUS Hotfix Firmware 2006_1E|
|nVidia Graphics and HDA sound | Graphics: 536.45 (Asus version, stable) or recent ones (works Ok, but sometimes less stable)</br>HD audio: 1.3.40.14 and 1.4.0.1 |
|G-Helper| 0.187.0 and later|
|Modern Standby| ! ENABLED !|
|Legacy Power Scheme| Balanced mode, with GUID: 381b4222-f694-41f0-9685-ff5bb260df2e|
|Windows 11 modes| All 3 modes available: Power saving, Balanced, Performance, but using Power saving most of the time|
|Armoury Crate| Not tested |
| Windows version | Tests done with latest French Windows 11 version|
## Summary of actions and tweaks performed by script
> [!CAUTION]
> Settings performed for nVidia HDA, Realtek HDA and for AMD Streaming Audio drivers need to be applied again each time these drivers are reinstalled, along with Adrenalin suite
>
> "nVidia audio", "AMD audio", and "Realtek audio" device numbers hereunder are automatically detected by script
>
> Just rerun the script in such case after a driver installation.

> [!CAUTION]
> REAPPLY AsMedia Hotfix Updater 2006_1E each time Chipset drivers are changed, or updated with AMD Adrenalin suite, as said before
>
> DISCONNECT ALL USB devices from laptop before running this Firmware updater 

|Action|Command or Registry key: all HKLM keys expand to HKLM\SYSTEM\CurrentControlSet\Control\ |Windows or driver value|New tweaked value|
|:-----|:---------------------|:-----------:|:------------------------:|
|Disable Core Isolation| Either in Windows Security, or Registry key: HKLM\...\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity > Enabled (dword)|1| 0|
|Enable Fast Startup|HKLM\...\Session Manager\Power > HiberbootEnabled (dword)|0 or 1|1|
|Show option 'Hibernation timeouts' in Advanced Power Settings|HKLM\...\Power\PowerSettings\238C9FA8-0AAD-41ED-83F4-97BE242C8F20\9d7815a6-7ee4-497e-8888-515a05f02364 > Attributes (dword)| 1|2|
|Activate Hibernation/Fast Startup|Admin command line: `powercfg /h on`| On or Off| On|
|Set: "If you’ve been away, when should Windows require you to sign in again?" option and select "Always"|HKCU\Control Panel\Desktop > DelayLockInterval (dword)|900|0|
|Policy for devices powering down while the system is running|HKLM\...\Power\PowerSettings\4faab71a-92e5-4726-b531-224559672d19\DefaultPowerSchemeValues\ "Power Scheme GUID" > ACSettingIndex (dword) |0|1|
|Disable networking in standby|HKLM\...\Power\PowerSettings\f15576e8-98b7-4186-b944-eafa664402d9\DefaultPowerSchemeValues\ "Power Scheme GUID" > ACSettingIndex (dword) |1|0|
|Modern Standby Disconnected mode set to "Aggressive" instead of "Normal"|HKLM\...\Power\PowerSettings\68afb2d9-ee95-47a8-8f50-4115088073b1\DefaultPowerSchemeValues\ "Power Scheme GUID" > ACSettingIndex and DCSettingIndex (dword) |0|1|
|Idle Power state D0 for nVidia HDA driver|HKLM\...\Class\\{4d36e96c-e325-11ce-bfc1-08002be10318}\ "nVidia audio" \PowerSettings > IdlePowerState (BINARY) |03000000|00000000|
|Idle Time AC for nVidia HDA driver|HKLM\..\Class\{4d36e96c-e325-11ce-bfc1-08002be10318}\ "nVidia audio" \PowerSettings > ConservationIdleTime (BINARY) |04000000|00000000|
|Idle Time DC for nVidia HDA driver|HKLM\..\Class\{4d36e96c-e325-11ce-bfc1-08002be10318}\ "nVidia audio" \PowerSettings > PerformanceIdleTime (BINARY) |04000000|00000000|
|Idle Power state D0 for Realtek HDA driver|HKLM\...\Class\\{4d36e96c-e325-11ce-bfc1-08002be10318}\ "Realtek audio" \PowerSettings > IdlePowerState (BINARY) |03000000|00000000|
|Idle Power state D0 for AMD streaming driver, if present|HKLM\...\Class\\{4d36e96c-e325-11ce-bfc1-08002be10318}\ "AMD audio" \PowerSettings > IdlePowerState (BINARY) |03000000|00000000|
> [!NOTE]
> If a device is not detected, the script will not perform any action, and will skip the tweak

> [!IMPORTANT]
> **REBOOT laptop to take into account changes after script is applied**

> [!IMPORTANT]
> Better to apply all tweaks alltogether at first and see how it goes. Then possible to rollback individualy each one to see effect, after several days of observation
>
> Some issues require several tweaks altogether 

No particular impact on performances noted, as it concerns only Idle and Sleep states. No interaction so far when drivers and devices are in use

## How to run script
> [!NOTE]
> Script behavior differs whether if it is run with or without admin level

1. **without admin level:**

   the script won't modify anything, it will only show the action and registry keys without effectively changing anything.

   This is particularly useful to perform a dry run, and see how it behaves, or to check current parameters set.

   In case of wrong registry key or error, it will be displayed

   Simply hit enter for each action shown

2. **with admin level:**

   The script will show actions as in 1. and show each individual change, and ask for each one to apply or not. Enter Y or N, or simply Return for Y

   A laptop reboot is proposed at the end.

   In cas a Registry key is not found, for any reason, no action will be performed, just skipped.

4. **Command line options**

   Following command line options are available

   - /Q  : to run quiet. All actions are performed without pause, and logged into the script terminal window. Output redirection to a log file is possible
   - /R  : Rollback procedure, to retreive default Windows 11 parameters. Same as normal mode, each tweak can be individually rollbacked

## References
1. [White paper on Modern Standby from DELL](https://dl.dell.com/manuals/all-products/esuprt_solutions_int/esuprt_solutions_int_solutions_resources/client-mobile-solution-resources_white-papers45_en-us.pdf)
Synthetic information relative to Modern Standby
2. [Microsoft learn - PortCls Registry Power Settings](https://learn.microsoft.com/en-us/windows-hardware/drivers/audio/portcls-registry-power-settings)
Concerns Media devices Idle timeout settings
3. [Microsoft learn - Device idle policy](https://learn.microsoft.com/en-us/windows-hardware/customize/power-settings/no-subgroup-settings-device-idle-policy)
Concerns Kernel device drivers Idle timeout management
4. [Microsoft learn - Allow networking during standby](https://learn.microsoft.com/en-us/windows-hardware/customize/power-settings/no-subgroup-settings-allow-networking-during-standby)
Concerns about Connectivity in standby, for Modern Standby. Deprecated, but turns out it is still in use.
