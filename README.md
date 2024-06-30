# ASUS-G713PV-fix
Some tweaks to enhance (hopefully fix!) stability for laptop ASUS G713PV, possibly also other models from the same product range
## Introduction
This utility batch script sets a few parameters in Windows 11 registry, and help stabilize the ASUS G713PV laptop. 

Designed and tested on this laptop. Likely to be used also on other laptop from same model range.
## Issues covered
Summary of different G713PV laptop issues, and status after using this utility batch script.

**Solved** means here: **Not experienced this anymore** 

|Issues on G713PV | After using utility | Comments |
|-------|-------|---|
|Screen fast flickers | Solved |Core Isolation OFF still needed |
|Modern Standby with Hibernation/Fast Startup enabled freezes laptop on sleep | Solved |Bonus: Laptop now start really faster from Power Off or Hibernation!
|Laptop crash/freeze on Wake up from Modern Standby|Solved|With Power Settings registry tweaks|
|nVidia nvlddmkm.dll crash during Modern Standby|Solved| Long Graphics TDR delay needed when in deep sleep mode |
|Sound issues, especially with nVidia HDA sound driver on external HDMI monitor: sound crackling, crash, HDMI sound channel loss. Can mess also Realtek sound on switching sound|Solved|nVidia HD audio Idle timeouts driver tweaks|
|Black login screen (no *Windows Spotlight* image) after wake up from Modern Standby, with nVidia icons in taskbar disappear|Partially solved|Much less events, but need more understanding of this strange phenomenon. Not sure same root cause as freezes, might be linked to Iris Service cache issue |
|Deep sleep interruptions |Reduced|Apps like Steam client have internet activity while deep sleep, and keep interrupting it|
|Random reboots|Not seen anymore| To be confirmed if this issue is also solved|
## Hints with Microsoft Modern Standby
> [!WARNING]
> Modern Standby is not and will never be former S3 sleep. 

A new way Microsoft wants laptops to sleep, somehow like a smartphone.

Biggest difference stands in that sleep is not immediate. 

Windows 11 runs an Orchestrator at standby start, performing maintenance tasks, before letting laptop to go to sleep. 

Delay between 1 to more than 30 minutes after standby start!

Huge step ahead: mixing Modern Standby and Hibernation now possible without freeze. 

Hibernation recommended to start at least 1 hour after Modern Standby start, so that Modern Standby Orchestartor can do its duty and saves SSD lifetime too

Did set it to 3 hours like former legacy default Windows settings. 

> [!NOTE]
> Sometimes, rarely, Windows Orchestrator hang, and will not let laptop sleep at all 
>
> Situation can be checked in a Terminal admin console, with command: `powercfg /requests`
> 
> Anything showing there in a section means Windows will not yet allow laptop to sleep
>
> Simply exiting Standby, or session Logoff/Logon, solves issue. 
## Prerequisites on Modern Standby and Legacy Power Schemes to use this script
> [!IMPORTANT]
> Modern Standby should be ENABLED!
>
> If previously disabled, better to re-enable it. Should run fine now along with Hibernation 

All tweaks are applied to the **current Windows 11 Power Scheme** in use.

Normally, if Modern Standby is enabled, there should be only 1 legacy Power Scheme left: **Balanced**

Not talking here about the 3 Windows 11 Modern Power Plans: Power saving, normal, performance, in Windows 11 settings.

Current Legacy Power Scheme in use can be checked with admin command line: `powercfg /L` 

Script detects and use the GUID for the active Power Scheme, normally balanced, with GUID: 381b4222-f694-41f0-9685-ff5bb260df2e. 

But can be another one if other Legacy Power Schemes have been forced

## Software configuration used
Software configuration used for set up and tests:

| device | driver or software version |
|-------| -------|
|AMD Graphics | AMD Adrenalin 24.5.1 and 24.6.1|
|nVidia Graphics and HDA sound | Graphics 555.85, with HDA Sound 1.4.0.1 |
|G-Helper| 0.176.0|
|Modern Standby| ! ENABLED !|
|Legacy Power Scheme| Balanced mode, with GUID 381b4222-f694-41f0-9685-ff5bb260df2e|
|Windows 11 modes| All 3 modes available: Power saving, Balanced, Performance|
|Armoury Crate| Not tested |
| Windows version | Tested with latest French Windows 11 version|
## Summary of actions and tweaks performed by script
> [!CAUTION]
> Settings performed for nVidia HDA driver need to be done again each time the nVidia driver is reinstalled

|Action|Command or Registry key: all HKLM keys expand to HKLM\SYSTEM\CurrentControlSet\Control\ |Default value|Target value set by script|
|:-----|:---------------------|:-----------:|:------------------------:|
|Enable Fast Startup|HKLM\..\Control\Session Manager\Power > HiberbootEnabled (dword)|0 or 1|1|
|Show option 'Hibernation timeouts' in Advanced Power Settings|HKLM\..\Control\Power\PowerSettings\238C9FA8-0AAD-41ED-83F4-97BE242C8F20\9d7815a6-7ee4-497e-8888-515a05f02364 > Attributes (dword)| 1|2|
|Activate Hibernation/Fast Startup|Admin command line: `powercfg /h on`| On or Off| On|
|Disable Core Isolation| Either in Windows Security, or Registry key: HKLM\..\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity > Enabled (dword)|1| 0|
|IO coalescing timeout |HKLM\..\Control\Power\PowerSettings\2e601130-5351-4d9d-8e04-252966bad054\c36f0eb4-2988-4a70-8eee-0884fc2c2433\DefaultPowerSchemeValues\<Power Scheme GUID> > ACSettingIndex (dword)|0|30000 |
|Policy for devices powering down while the system is running|HKLM\..\Control\Power\PowerSettings\4faab71a-92e5-4726-b531-224559672d19\DefaultPowerSchemeValues\<Power Scheme GUID> > ACSettingIndex (dword) |0|1|
|Networking connectivity in Standby managed by Windows (reduce sleep interruptions by apps)|HKLM\..\Control\Power\PowerSettings\f15576e8-98b7-4186-b944-eafa664402d9\DefaultPowerSchemeValues\381b4222-f694-41f0-9685-ff5bb260df2e\<Power Scheme GUID> > ACSettingIndex (dword) |1|2|
|Idle Time AC for HDA nVidia driver|HKLM\..\Control\Class\{4d36e96c-e325-11ce-bfc1-08002be10318}\0003\PowerSettings > ConservationIdleTime (BINARY) |04000000|00000000|
|Idle Time DC for HDA nVidia driver|HKLM\..\Control\Class\{4d36e96c-e325-11ce-bfc1-08002be10318}\0003\PowerSettings > PerformanceIdleTime (BINARY) |04000000|00000000|
|Graphics drivers Tdr Delay|HKLM\..\Control\GraphicsDrivers > TdrDelay (dword)|2|60|
|Iris Service for Windows Spotlight|HKCU\Software\Microsoft\Windows\CurrentVersion\IrisService | | Delete key (and cache) to force recreate on next reboot|

> [!IMPORTANT]
> **REBOOT laptop to take into account changes after script is applied**

> [!IMPORTANT]
> All tweaks are needed alltogether as a whole to have effect.
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

> [!TIP]
> Parameter /q or /Q can be passed on command line. In this case, the "Hit enter to continue" will not be shown, but all actions performed by script can reviewed in the opened terminal window.
>
> In this case, reboot at the end will no be proposed
## Known issues - To be digged further
1. USB ports. Changing USB ports while in sleep mode or hibernation may lead to issues/freeze on next power up and sleep. To be analyzed further, but more or less known issue Fast Startup with USB... Best practice is to change USBs with laptop running, or reboot if done while sleeping.
2.  Black logon screen sometimes appear, less than before. Need further analysis, but difficult to reproduce. Suspicion of Windows Spotlight Iris Service...?
3.  Using G-Helper, when selecting "Optimized" mode, a long 60s timeout is hit, so G-Helper window and "Silent mode" message stay on screen, and disappear after a minute with no other impact
## Todo
1. Add a rollback procedure (ongoing), in case needed, with default Windows 11 registry values
