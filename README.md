# Batch script: ASUS_G713PV_fix.bat 
A few Windows 11 settings tweaks in order to fix laptop ASUS G713PV, G713PI unstabilities.

So called Random reboots, sound cracklings, Fast Flickers, all those are now wipped and this laptop demonstrates good stability on load or on Modern Standby, which can now be fully enabled, along with Hibernate or Fast Startup.

Possibly works on other models from the same brand or product range too, like G733P models for instance
## Introduction
This .bat script sets a few parameters in Windows 11 registry, to stabilize ASUS G713PV laptop. 

Designed and tested on this laptop. Likely to be used also on other laptop from same model range.
## Issues solved
Summary of different G713PV laptop issues which are 100% solved or almost, and status after using this utility batch script.

**Solved** means here: **Not experienced this anymore** 

|Issues on G713PV |  Comments |
|-------|-----|
|Laptop screen Fast Flickers and overall stability |Fixed with: </br> Core Isolation and security can be fully enabled as per default Windows 11 setting, but 100% Flicker Free is obtained after disabling Core Isolation.|
|Black login screen (no *Windows Spotlight* image) after wake up from Modern Standby, with nVidia icons in taskbar disappear|Fixed with:</br>Set to "Always" the Windows setting/Accounts: "If you’ve been away, when should Windows require you to sign in again?".</br>You have to sign in each time, but "Never" might work too. |
|Modern Standby with Hibernation/Fast Startup enabled freezes laptop on sleep</br></br>Laptop crash/freeze on Wake up from Modern Standby|Fix with Power Settings registry tweaks: Policy for devices powering down while the system is running.</br>Bonus: Laptop now start really faster from Power Off or Hibernation!
|nVidia nvlddmkm.dll crash during Modern Standby</br></br>Also, laptop crash/freeze on Wake up from Modern Standby|Increase TdrDelay fixes this, a common setting on dual GPU computers |
|Sound issues, especially with nVidia HDA sound driver on external HDMI monitor: sound crackling, crash, HDMI sound channel loss. Can mess also Realtek sound on switching sound|Stay with OEM ASUS official 6.0.9549.1 .  </br>For AMD Adrenalin install, remove AMD Streaming audio driver helps. </br>nVidia, Realtek HDA Audio Idle Power to D0 driver, Performance and Conservative Idlt Timeouts tweaks stops messing and stabilizes whole laptop. Also valid for AMD Streaming driver if still present|
|Random reboots</br>More a stop/start due to some internal protection triggered under different HW conditions, but subject to FALSE ALARMS in some cases|1/ Due to misconfiguration between Chipset drivers and AsMedia Firmware. </br>IMPERATIVE to rerun AsMedia Hotfix 2006_1E EACH TIME after modifying Chipsets drivers, to align AsMedia Firmware with new Chipset drivers.</br>2/ Changing Core Isolation / Memory Integrity state (On or Off) seems to mess the Mediatek Bluetooth driver. Bluetooth LE devices sometimes get laggy, and may trigger these Random reboots. Workaround is simply to reinstall the Mediatek Bluetooth driver if such situation is seen.|

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
|BIOS|Latest 334 | 
|AMD Chipset|Probably the most important and cornerstone for the full stability. </br>With time and Windows updates, original Asus chipset package (1.2.0.120) has become less stable, and difficult to avoid crashes on Wake up from Modern Standby now. <br/>Best is to use a recent Adrenalin package like 24.10.1 with its recent chipset update (1.2.0.126) </br>**Note** that AMD chipset update require **RERUN of ASUS Hotfix Firmware 2006_1E**, with laptop set without any USB, HDMI or Bluetooth device connected. This is MANDATORY to reprogram the AsMedia chip accordingly, otherwise, random reboots may appear! |
|AMD Graphics |Better to use a recent AMD Adrenalin Full, minimal, or drivers only install like 24.10.1</br>ASUS original AMD graphics driver (31.0.14038.8002) is now somehow outdated and probably more subject to unstabilities with nVidia driver cohabitation.|
|nVidia Graphics and HDA sound | As for AMD, it is now much better to use recent versions like 566.nn + HDA sound 1.4.2.6 or latest ones </br>Older Asus Graphics: 536.45 + HDA sound 1.3.40.14 are now sometimes unstable on Wake up from Modern Standby|
|Realtek Audio|6.0.9549.1 ASUS driver. Updating this driver seems not advised, this package is specific to Asus setting, other ones may create conflicts with nVidia audio| 
|Mediatek Bluetooth| 1.1037.2.433 ASUS driver or later|
|G-Helper| 0.197.0 or later|
|Modern Standby| ! ENABLED !|
|Legacy Power Scheme| Balanced mode, with GUID: 381b4222-f694-41f0-9685-ff5bb260df2e|
|Windows 11 modes| All 3 modes available: Power saving, Balanced, Performance, but using Power saving most of the time|
|Armoury Crate| Not tested |
| Windows version | Tests done with latest French Windows 11 version|

## Modifiying the drivers configuration
Laptop drivers configuration can be changed, nVidia, AMD+Chipset drivers, etc...

In such case, the way to go is as follows:
1. Upgrade nVidia driver, reboot
2. Upgrade AMD + Chipset driver, reboot
3. Check availability of Windows updates (Including advanced updates), and if any, install them and reboot
4. **MANDATORY**: If step 2. is executed and new chipset drivers are installed, then run again the Firwmare updater 2006_1E, in order to program AsMedia chip, accordingly to the newer chipset configuration. </br>
**Be sure to Disconnect any USB, Bluetooth or HDMI device before**. Laptop to be left without any connected device for running this Firmware update. </br>
A 1st reboot is asked for, then log back in, and wait 1 mn for the 2nd reboot request. After this 2nd reboot, all devices can be reconnected to the laptop.
5. Run this batch script ASUS_G713PV_fix.bat, reboot
6. Then, in case of unstability seen with Bluetooth LE devices, (weird behavior with Bluetooth mouse, Bluetooth XBOX Elite 2 controller, ...), reinstall the Mediatek Bluetooth driver, simply from the Device Manager </br>(Select Mediatek Bluetooth driver -> Update driver -> check my computer for drivers -> Choose from my computer -> reselect the same Mediatek driver and click Ok)

> [!WARNING]
> Rollbacking AMD Chipset driver is a bit tricky, AMD uninstall program does only uninstall graphics driver. </br>Uninstalling Chipset requires to remove in device Manager, one by one, the 8 devices modified:
> * Security: AMD PSP 11.0 Device
> * System: AMD GPIO Controller, AMD I2C controllers (x3), AMD Micro PEP, AMD PPM Provisionning file, AMD SMBUS
>
> Rollbacking nVidia driver requires to use nVidia cleanup tool CleanupTool_1.0.20.0.exe, just google for it on nVidia site.
> </br>Note that DDU DOES NOT CLEAN correctly the HDA sound device (WDM), which brings then unstability if installing an older driver

## Summary of actions and tweaks performed by script
> [!CAUTION]
> Settings performed for nVidia HDA, Realtek HDA and for AMD Streaming Audio drivers need to be applied again each time these drivers are reinstalled, along with Adrenalin suite
>
> "nVidia audio", "AMD audio", and "Realtek audio" device numbers hereunder are automatically detected by script
>
> JUST RERUN THE SCRIPT in such case after an AMD or nVidia driver installation.

> [!CAUTION]
> REAPPLY AsMedia Hotfix Updater 2006_1E each time AMD Chipset drivers are changed, or updated with AMD Adrenalin suite!!
>
> DISCONNECT ALL USB devices from laptop before running this Firmware updater!!

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
> If a Registry key is not detected (for instance, a particular device or driver not installed), then script will not perform any action for it, and will skip the tweak to the next one.

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

3. **Run script options after start:**
   * Quiet: all settings will be applied as a single batch
   * Interactive: Each setting can be selected individually

4. **Command line options**

   Following command line options are available

   - /Q  : to run quiet. All actions are performed without pause, and logged into the script terminal window. Output redirection to a log file is possible
   - /R  : Rollback procedure, to retreive default Windows 11 parameters. Same as normal mode, each tweak can be individually rollbacked or as a batch

## References
1. [White paper on Modern Standby from DELL](https://dl.dell.com/manuals/all-products/esuprt_solutions_int/esuprt_solutions_int_solutions_resources/client-mobile-solution-resources_white-papers45_en-us.pdf)
Synthetic information relative to Modern Standby
2. [Microsoft learn - PortCls Registry Power Settings](https://learn.microsoft.com/en-us/windows-hardware/drivers/audio/portcls-registry-power-settings)
Concerns Media devices Idle timeout settings
3. [Microsoft learn - Device idle policy](https://learn.microsoft.com/en-us/windows-hardware/customize/power-settings/no-subgroup-settings-device-idle-policy)
Concerns Kernel device drivers Idle timeout management
4. [Microsoft learn - Allow networking during standby](https://learn.microsoft.com/en-us/windows-hardware/customize/power-settings/no-subgroup-settings-allow-networking-during-standby)
Concerns about Connectivity in standby, for Modern Standby. Deprecated, but turns out it is still in use.
