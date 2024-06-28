# ASUS-G713PV-fix
Fixes for better stability of laptop ASUS G713PV
## Introduction
This utility batch script will set a few parameters in the Windows 11 registry to help stabilize the ASUS G713PV laptop. 

It has been designed and tested on this laptop model, but likely to be used also on other laptop from the same model range.
## Issues covered
Here is a summary of different G713PV laptop issues, and their status after using this utility batch script.

Solved means here: Did not experience this anymore 😊

|Issues on G713PV | After using utility | Comments |
|-------|-------|---|
|Screen fast flickers | Solved |  |
|Modern Standby with Hibernation/Fast Startup enabled freezes laptop on sleep | Solved |Bonus: Laptop now start really faster from Power Off or Hibernation!
|Laptop crash/freeze on Wake up from Modern Standby|Solved|
|Black login screen after wake up from Modern Standby|Partially solved|Much less events, but need more understanding of this strange phenomenon |
|nVidia nvlddmkm.dll crash during Modern Standby|Solved|
|Sound issues, especially with nVidia HDA sound driver on external HDMI monitor: sound crackling, crash, HDMI sound channel loss|Solved|
|Random reboots|Not seen anymore| To be confirmed if this issue is also solved|
## Hints with Microsoft Modern Standby
> [!WARNING]
> Modern Standby is not and will never be former S3 sleep. 

It is the new way Microsoft wants laptops to sleep, somehow like a smartphone.

Biggest difference stands in that sleep is not immediate. 

Windows 11 runs an Orchestrator when standby starts, that performs maintenance tasks, before it will decide to let laptop sleep. 

This can happen between 1 to more than 30 minutes after standby start!

So the huge step ahead, is that mixing Modern Standby and Hibernation is now possible without experiencing freeze, but hibernation is recommended to start at least 1 hour after Modern Standby start. I set it to 3 hours, as in former legacy default Windows settings, to let Modern Standby Orchestartor do its duty, and save SSD lifetime too
> [!NOTE]
> Sometimes, rarely, Windows Orchestrator may hang, and will not let laptop sleep at all 
>
> This situation can be seen in a Console admin, with command: `powercfg /requests`
> 
> Something showing there in one of the sections means Windows will not yet allow laptop to sleep
>
> Simply exiting Standby, or session Logoff/logon, solves this issue. 
## Prerequisites on Modern STandby and Legacy Power Plan to use this script
> [!IMPORTANT]
> First of all, Modern Standby should be ENABLED!
>
> If you previously disabled it, then better to re-enable it as it should run fine now along with Hibernation 

The tweaks will be applied to the current Windows 11 Power Scheme in use.

Normally, if you didn't hack and have Modern Standby enabled, then you should have only 1 legacy Power Scheme left: Balanced

Not talking here about the 3 Windows 11 Modern Power Plans: Power saving, normal, performance, that can be setup in Windows 11 settings.

You can see the current Legacy Power Scheme in use with admin command line: `powercfg /L` 

The script will detect and use the GUID for the active Power Scheme, normally, balanced with GUID: 381b4222-f694-41f0-9685-ff5bb260df2e. 

But can be another one, if you forced other Legacy Power Schemes

## Software configuration used
Here is the software configuration used for the set up and tests:

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
## Summary of the actions and tweaks performed by the script
> [!CAUTION]
> Settings performed for nVidia HDA driver need to be done again each time the nVidia driver is reinstalled

|Action|Command or Registry key: all starting by HKLM\SYSTEM\CurrentControlSet\Control\ |Default value|Target value set by script|
|:-----|:---------------------|:-----------:|:------------------------:|
|Enable Fast Startup|HKLM\..\Control\Session Manager\Power > HiberbootEnabled (dword)|0 or 1|1|
|Show option 'Hibernation timeouts' in Advanced Power Settings|HKLM\..\Control\Power\PowerSettings\238C9FA8-0AAD-41ED-83F4-97BE242C8F20\9d7815a6-7ee4-497e-8888-515a05f02364 > Attributes (dword)| 1|2|
|Activate Hibernation/Fast Startup|Admin command line: powercfg /h on| On or Off| On|
|Disable Core Isolation| Either in Windows Security, or Registry key: HKLM\..\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity > Enabled (dword)|1| 0|
|IO coalescing timeout |HKLM\..\Control\Power\PowerSettings\2e601130-5351-4d9d-8e04-252966bad054\c36f0eb4-2988-4a70-8eee-0884fc2c2433\DefaultPowerSchemeValues\<Power Scheme GUID> > ACSettingIndex (dword)|0|60000|
|Policy for devices powering down while the system is running|HKLM\..\Control\Power\PowerSettings\4faab71a-92e5-4726-b531-224559672d19\DefaultPowerSchemeValues\<Power Scheme GUID> > ACSettingIndex (dword) |0|1|
|Idle Time AC for HDA nVidia driver|HKLM\..\Control\Class\{4d36e96c-e325-11ce-bfc1-08002be10318}\0003\PowerSettings > ConservationIdleTime (BINARY) |04000000|00000000|
|Idle Time DC for HDA nVidia driver|HKLM\..\Control\Class\{4d36e96c-e325-11ce-bfc1-08002be10318}\0003\PowerSettings > PerformanceIdleTime (BINARY) |04000000|00000000|
|Graphics drivers Tdr Delay|HKLM\..\Control\GraphicsDrivers > TdrDelay (dword)|2|60|

> [!IMPORTANT]
> REBOOT laptop to take into account changes after script is applied

> [!IMPORTANT]
> All tweaks are needed alltogether as a whole to have effect.
>
> Some of the issues get solved only with several of these tweaks

No particular impact on performances noted on my side

## How to run script
Script behavior differs whether if it is run with or without admin level
1. without admin level: the script won't modify anything, it will only show the action and registry keys without effectively changing anything.

   This is particularly useful to perform a dry run, and see how it behaves.

   In case of wrong registry key or error, it will display it.

   Simply hit enter for each action shown

2. with admin level: The script will show actions as in 1. and perform the changes.

   A laptop reboot is proposed at the end.

> [!TIP]
> Parameter /q or /quiet can be passed on command line. In this case, the "Hit enter to continue" will not be shown, but you can review at the end all actions performed by script in the window.
>
> In this case, reboot at the end will no be proposed
