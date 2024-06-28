# ASUS-G713PV-fix
Fixes for better stability of laptop ASUS G713PV
## Introduction
This little utility batch script will set a few parameters in the Windows 11 registry to help stabilize the ASUS G713PV laptop. 
It has been designed and tested on this laptop model, but likely to be used also on other laptop from the same model range.
## Issues covered
Here is a summary of different issues of G713PV laptop, and their status after using this utility batch script
Solved means: Did not experience this anymore

|Issues on G713PV | After using utility | Comments |
|-------|-------|---|
|Screen fast flickers | Solved |
|Modern Standby with Hibernation/Fast Startup enabled willfreeze laptop on sleep | Solved |Bonus: Laptop now can start faster!
|Laptop crash/freeze on Wake up from Modern Standby|Solved|
|Black login screen after wake up from Modern Standby|Partially solved|Need more understanding of this strange phenomenon |
|nvlddmkm crash during Modern Standby|Solved|
|Using nVidia HDA sound driver: sound crash, HDMI sound channel loss|Solved|
|Random reboots|Not seen anymore| To be confirmed if this issue is also solved|
## Hints with Microsoft Modern Standby
Modern Standby is not and will never be former S3 sleep. 

It is the new way Microsoft wants laptops to sleep, somehow like a smartphone.

Biggest difference stands in that sleep will not immediate. Windows 11 runs an Orchestrator when standby starts, that perform some maintenance tasks, before it will decide to let laptop sleep. 

This can be between 1 to more than 30 minutes!

So as it appears, mixing Modern Standby and Hibernation gets possible without freeze, but hibernation is recommanded to start at least after 1 hour of Modern Standby sleep. I set 3 hours, as in former legacy default Windows settings, to let Modern Standby Orchestartor do its duty, and save SSD lifetime too
> [!NOTE]
> Sometimes, rarely, this Orchestrator may hang, and will not let laptop to sleep (Logoff/logon solves this issue)
>
> This situation can be seem in a Console admin, with command: `powercfg /requests`
> 
> Something showing there in one of the sections means Windows will not yet allow sleep
## Prerequisites on Modern STandby and Legacy Power Plan to use this script
First of all, you'll need to have Modern Standby ENABLED! If you previously disabled it, then better to re-enable it as it should run fine now along with Hibernation 

The tweaks will be applied to the current Windows 11 Power Scheme in use.

Normally, if you didn't hack and have Modern Standby enabled, then you should have only 1 legacy Power Scheme left: Balanced

Not talking here about the 3 Windows 11 Modern Power Plans: Power saving, normal, performance, that can be setup in Windows 11 settings.

You can see the current Legacy Power Scheme in use with admin command line: `powercfg /L` 

The script will detect and use the GUID for the active Power Scheme, normally it is balanced with GUID: 381b4222-f694-41f0-9685-ff5bb260df2e. But can be another one if you forced other Power Schemes

## Software configuration used

| 


