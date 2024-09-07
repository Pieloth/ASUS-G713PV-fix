# Batch script New Approach: ASUS_G713PV_fix.bat 
On this branch, a good stability is obtained with:

1. In Windows Settings / Accounts. Change for: "If you’ve been away, when should Windows require you to sign in again?" option and select "Always". Strangely, this solves these 2 major issues:

   - Fast Flickers on laptop screen. No need to disable Core Isolation anymore!
   - Black logon screen due to Winlogon.exe crash during sleep. Does not happen anymore!

2. All Drivers and apps provided by ASUS. Especially, the AMD default driver, without Adrenalin application. Or at least (TBC), Adrenalin "ONLY DRIVER" installation, NOT FULL INSTALLATION (minimal install to be checked). This way, no AMD Streaming sound driver gets installed. This AMD streaming driver is a huge root cause of sound and laptop unstabilities. No need to change anything then on Realtek and nVidia drivers anymore!

3. Exception, use G-Helper instead of Armoury Crate

Apart from enabling:
- Hibernate,
- Fast Startup,
- Show option 'Hibernation timeouts' in Advanced Power Settings

Currently under test, but only 3 registry settings are still set, more testing will tell if they are still necessary  

Possibly works on other models from the same brand or product range too
## Introduction
This .bat script sets a few parameters in Windows 11 registry, to stabilize ASUS G713PV laptop. 

Designed and tested on this laptop. Likely to be used also on other laptop from same model range.
## Issues solved
Summary of different G713PV laptop issues which are 100% solved or almost, and status after using this utility batch script.

**Solved** means here: **Not experienced this anymore** 

|Issues on G713PV |  Comments |
|-------|-----|
|Laptop screen fast flickers and overall stability, black login screen (no *Windows Spotlight* image) after wake up from Modern Standby, with nVidia icons in taskbar disappear |Set to "Always" for Windows setting/Accounts: "If you’ve been away, when should Windows require you to sign in again?"|
|Modern Standby with Hibernation/Fast Startup enabled freezes laptop on sleep | Bonus: Laptop now start really faster from Power Off or Hibernation!
|Laptop crash/freeze on Wake up from Modern Standby|With Power Settings registry tweaks: Policy for devices powering down while the system is running|
|nVidia nvlddmkm.dll crash during Modern Standby|No new event |
|Sound issues, especially with nVidia HDA sound driver on external HDMI monitor: sound crackling, crash, HDMI sound channel loss. Can mess also Realtek sound on switching sound|Using AMD default ASUS driver Without Adrenalin interface and Without installation of AMS Streaming sound driver|
|Random reboots| Seen with Bluetooth LE devices : Corsair mouse and Xbox Elite 2. No new reboot with latest Mediatek Bluetooth driver|

## Hints with Microsoft Modern Standby
> [!WARNING]
> Modern Standby is not and will never be former S3 sleep. 

The way Microsoft wants laptops to sleep, somehow like a smartphone.

Biggest difference with S3 stands in that sleep is not immediate. 

Windows 11 runs an Orchestrator at standby start, performing maintenance tasks, before letting laptop to go to sleep. 

Delay between 1 to more than 30 minutes after standby start!

Huge step ahead: mixing Modern Standby and Hibernation now possible without freeze. 

Hibernation recommended to start at least 1 hour after Modern Standby start, so that Modern Standby Orchestrator can do its duty and saves SSD lifetime too

Did set it to 3 hours like former legacy default Windows settings. 

## Prerequisites on Modern Standby and Legacy Power Schemes to use this script
> [!IMPORTANT]
> Modern Standby should be ENABLED!
>
> If previously disabled, better to re-enable it. It can be used now along with Hibernation 

All tweaks are applied to the **current Windows 11 Power Scheme** in use.

Normally, if Modern Standby is enabled, there should be only 1 legacy Power Scheme left: **Balanced**

Not talking here about the 3 Windows 11 Modern Power Plans: Power saving, normal, performance, in Windows 11 settings.

Current Legacy Power Scheme in use can be checked with admin command line: `powercfg /L` 

Script detects and use the GUID for the active Power Scheme, normally balanced.

Balanced power scheme GUID: 381b4222-f694-41f0-9685-ff5bb260df2e

But can be another one if other Legacy Power Schemes are in use

> [!WARNING]
> Script currently will not work for custom Power Schemes. Only default ones can be used.

> [!TIP]
> To retreive GUID, script uses the semicolon ":" character. Should be Ok for any Windows language version, but yet to be confirmed 

## Software configuration used
> [!IMPORTANT]
> ONLY ASUS Default drivers and Software are used for set up and tests. The list can be retreived either from:
> - MyAsus, click the link "Check for previous versions on the ASUS Support site" in System Update page
> - G-Helper Updates button

| device | driver or software version |
|-------| -------|
|Mediatek Bluetooth| 1.1037.2.433 no random reboots seen due to Bluetooth LE devices use|
|AMD Graphics |31.0.14038.8002 without Adrenalin software app. TBC if Adrenalin Only Driver or Minimal installation can be used. Full Installation MUST NOT be used|
|nVidia Graphics and HDA sound | Graphics: 536.45 Official Asus version, more stable including HD audio: 1.3.40.14. Newer versions TBC but should be fine |
|G-Helper| 0.187.0 and later|
|Modern Standby| ! ENABLED !|
|Legacy Power Scheme| Balanced mode, with GUID 381b4222-f694-41f0-9685-ff5bb260df2e|
|Windows 11 modes| All 3 modes available: Power saving, Balanced, Performance, but using Power saving most of the time|
|Armoury Crate| Not tested |
| Windows version | Tested with latest French Windows 11 version|

## Summary of actions and tweaks performed by script

|Action|Command or Registry key: all HKLM keys expand to HKLM\SYSTEM\CurrentControlSet\Control\ |Windows or driver value|New tweaked value|
|:-----|:---------------------|:-----------:|:------------------------:|
|Enable Fast Startup|HKLM\...\Session Manager\Power > HiberbootEnabled (dword)|0 or 1|1|
|Show option 'Hibernation timeouts' in Advanced Power Settings|HKLM\...\Power\PowerSettings\238C9FA8-0AAD-41ED-83F4-97BE242C8F20\9d7815a6-7ee4-497e-8888-515a05f02364 > Attributes (dword)| 1|2|
|Activate Hibernation/Fast Startup|Admin command line: `powercfg /h on`| On or Off| On|
|Policy for devices powering down while the system is running|HKLM\...\Power\PowerSettings\4faab71a-92e5-4726-b531-224559672d19\DefaultPowerSchemeValues\ "Power Scheme GUID" > ACSettingIndex (dword) |0|1|
|Disable networking in standby|HKLM\...\Power\PowerSettings\f15576e8-98b7-4186-b944-eafa664402d9\DefaultPowerSchemeValues\ "Power Scheme GUID" > ACSettingIndex (dword) |1|0|
|Disconnected mode to "Aggressive"|HKLM\...\Power\PowerSettings\68afb2d9-ee95-47a8-8f50-4115088073b1\DefaultPowerSchemeValues\ "Power Scheme GUID" > ACSettingIndex and DCSettingIndex (dword) |0|1|

> [!IMPORTANT]
> **REBOOT laptop to take into account changes after script is applied**

No particular impact on performances noted 

## How to run script
> [!NOTE]
> Script behavior differs whether if it is run with or without admin level

1. **without admin level:**

   the script won't modify anything, it will only show the action and registry keys without effectively changing anything.

   This is particularly useful to perform a dry run, and see how it behaves, or to check current parameters set.

   In case of wrong registry key or error, it will be displayed

   Simply hit enter for each action shown

2. **with admin level:**

   The script will show actions as in 1. and perform the changes.

   A laptop reboot is proposed at the end.

3. **Command line options**

   Following command line options are available

   - /Q  : to run quiet. All actions are performed without pause, and logged into the script terminal window
   - /R  : Rollback procedure, to retreive default Windows 11 parameters
