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
|Laptop screen fast flickers and overall stability |Core Isolation OFF still needed for fast flickers and overall drivers stability|
|Modern Standby with Hibernation/Fast Startup enabled freezes laptop on sleep | Bonus: Laptop now start really faster from Power Off or Hibernation!
|Laptop crash/freeze on Wake up from Modern Standby|With Power Settings registry tweaks: Policy for devices powering down while the system is running|
|nVidia nvlddmkm.dll crash during Modern Standby|No new event |
|Sound issues, especially with nVidia HDA sound driver on external HDMI monitor: sound crackling, crash, HDMI sound channel loss. Can mess also Realtek sound on switching sound|AMD HD audio and nVidia HDA Audio Idle Power to D0 driver tweak stops messing and stabilizes whole laptop|
|Random reboots| Seen with Bluetooth LE devices : Corsair mouse and Xbox Elite 2. No new reboot with latest Mediatek Bluetooth driver|
|Black login screen (no *Windows Spotlight* image) after wake up from Modern Standby, with nVidia icons in taskbar disappear|Event happens sometimes while Windows updates are performed during sleep and if device lock ask for password is set to other than "always" or "never" in Windows settings!|

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
Software configuration used for set up and tests:

| device | driver or software version |
|-------| -------|
|Mediatek Bluetooth| 1.1037.2.433 no random reboots seen due to Bluetooth LE devices use|
|AMD Graphics | AMD Adrenalin 24.5.1 and above|
|nVidia Graphics and HDA sound | Graphics: 536.45 and 555.85 - HD audio: 1.3.40.14 and 1.4.0.1 |
|G-Helper| 0.176.0 and later|
|Modern Standby| ! ENABLED !|
|Legacy Power Scheme| Balanced mode, with GUID 381b4222-f694-41f0-9685-ff5bb260df2e|
|Windows 11 modes| All 3 modes available: Power saving, Balanced, Performance, but using Power saving most of the time|
|Armoury Crate| Not tested |
| Windows version | Tested with latest French Windows 11 version|
## Summary of actions and tweaks performed by script
> [!CAUTION]
> Settings performed for nVidia HDA, Realtek HDA and for AMD Streaming Audio drivers need to be applied again each time these drivers are reinstalled, along with Adrenalin suite
>
> "nVidia audio", "AMD audio", and "Realtek audio" device numbers hereunder are automatically detected by script
>
> Just rerun the script in such case after a driver installation.

|Action|Command or Registry key: all HKLM keys expand to HKLM\SYSTEM\CurrentControlSet\Control\ |Windows or driver value|New tweaked value|
|:-----|:---------------------|:-----------:|:------------------------:|
|Enable Fast Startup|HKLM\...\Session Manager\Power > HiberbootEnabled (dword)|0 or 1|1|
|Show option 'Hibernation timeouts' in Advanced Power Settings|HKLM\...\Power\PowerSettings\238C9FA8-0AAD-41ED-83F4-97BE242C8F20\9d7815a6-7ee4-497e-8888-515a05f02364 > Attributes (dword)| 1|2|
|Activate Hibernation/Fast Startup|Admin command line: `powercfg /h on`| On or Off| On|
|Disable Core Isolation| Either in Windows Security, or Registry key: HKLM\...\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity > Enabled (dword)|1| 0|
|Policy for devices powering down while the system is running|HKLM\...\Power\PowerSettings\4faab71a-92e5-4726-b531-224559672d19\DefaultPowerSchemeValues\ "Power Scheme GUID" > ACSettingIndex (dword) |0|1|
|Disable networking in standby|HKLM\...\Power\PowerSettings\f15576e8-98b7-4186-b944-eafa664402d9\DefaultPowerSchemeValues\ "Power Scheme GUID" > ACSettingIndex (dword) |1|0|
|Idle Power state D0 for nVidia HDA driver|HKLM\...\Class\\{4d36e96c-e325-11ce-bfc1-08002be10318}\ "nVidia audio" \PowerSettings > IdlePowerState (BINARY) |03000000|00000000|
|Idle Power state D0 for AMD streaming driver|HKLM\...\Class\\{4d36e96c-e325-11ce-bfc1-08002be10318}\ "AMD audio" \PowerSettings > IdlePowerState (BINARY) |03000000|00000000|
|Idle Power state D0 for Realtek HDA driver|HKLM\...\Class\\{4d36e96c-e325-11ce-bfc1-08002be10318}\ "Realtek audio" \PowerSettings > IdlePowerState (BINARY) |03000000|00000000|

> [!IMPORTANT]
> **REBOOT laptop to take into account changes after script is applied**

> [!IMPORTANT]
> Better to apply all tweaks alltogether at first and see how it goes. Then possible to rollback some to see effects, after several days of observation
>
> Some of the issues get solved only with several of these tweaks

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

## Known issues - To be digged further
1. USB ports. Changing USB ports while in sleep mode or hibernation may lead to issues/freeze on next power up and sleep. To be analyzed further, but more or less known issue Fast Startup with USB... Best practice is to change USBs with laptop running, or reboot if done while sleeping.
2. Windows Orchestrator. Rarely, may hang, and will not let laptop sleep at all 
Situation can be checked in a Terminal admin console, with command: `powercfg /requests` 
Anything showing there in a section means Windows will not yet allow laptop to sleep. Simply exiting Standby, or session Logoff/Logon, solves issue.
Note this issue has been seen only once 

# XML file: ASUS_G713PV_Event1002_Winlogon_crash.xml

## Purpose


When using the Windows spotlight images on logon screen

Sometimes, the logon screen does not show image, just black screen, user logo and password prompt

After loging in, the nVidia and AMD icons in taskbar are gone. This XML files is to be imported into Windows Task Scheduler, it will create a scheduled task, that will detect Winlogon crash (event 1002), and will restart the nVidia and AMD icons

> [!WARNING]
> This black screen due to Winlogon.exe crash during sleep and userinit.exe restart is due to some Windows 11 Authentification and device lock misbehavior while sleeping, and with Updates done at the same time.
>
> The easiest way to get rid and workaround this is to set the option "Device lock and ask for password" timeout to "Always" or "Never" in Windows Settings/Account/Connexion options.
> By default, it is set to 15 mn, so that lock can happen after sleep has started.
> 
> Registry options to disable Wakeup Password with Modern Standby: HKEY_CURRENT_USER\Control Panel\Desktop 32-bit DWORD value DelayLockInterval set to 0

## How to use

1. Start the Windows task scheduler

2. Select Action / Import. Choose the "ASUS G713PV Event 1002 crash explorer.xml" file.

3. You can review the Schedule task wizard, then choose OK. The Schedule task is ready to run
