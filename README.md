# Asus G713PV - fix crash and freeze issues 
## Workaround to BIOS ACPI bugs with Media device drivers

> [!NOTE]
>
> TIP: Based on work for Asus G713PV laptop, but may be appropriate also for other models of the same Strix product line 
> 
> ***USAGE***\
> Script .py can run in a console or .exe from the File Explorer, it will ask for UAC privilege if non admin. \
> Note that a Task will be created in Task Scheduler\
> Place the .exe in some folder, and run once the .exe . It will run automatically from this location at each reboot or when a driver is modified or updated.\
> If the location of the file changes, the script will automatically update the scheduler task location\
> A Log file is updated at each run, it stands in same folder as the .exe or script
>
> - To run for a test the source script in a terminal console: just execute script in a Terminal (if not admin, will ask for UAC privilege): 
> ```
> python fix_media_powersettings.py
> ```
> Or directly running the compiled .exe version, for installing the .exe in some folder: 
> ```
> fix_media_powersettings.exe
> ```
> - How to Compile the script to create .exe, in a simple terminal window:
> ```
> pyinstaller --onefile .\fix_media_powersettings
> ```
> A `/v` option can be used in command line to show a popup on execution.
>
> Note also that a Task Scheduler file, fix_winlogon_crash.xml, is also provided\
> This is useful in case of experience of a black logon screen (Image lost), and then nVidia icons lost after login in\
> The reason comes from a winlogon.exe crash while in modern standby. Rare, but happens sometimes\
> Simply open Task Scheduler, and import the fix_winlogon_crash.xml file\
> It will create another task, that detects such winlogon crash, and will restore the nVidia icons automatically

> [!IMPORTANT]
> **IMPORTANT INFORMATION FIRST**
>
> All following issues are fixed (see details below)
>
> - Flickers fixed bu recent AMD GPU drivers and chpset
> - Freeze on various Modern Standby combined situations with sleep or wake up, Fast Startup, Hibernation: All fixed.
> - Black logon screen fixed
> - No random reboot 
> - Enhance Modern Standby experience sleep mode to be closer to former S3 standby
> 
> A Media drivers tweak is needed to achieve this: Remove PowerSettings key subfolder for these Media class drivers in Registry to disable customized powersettings values:
> - NVidia HD Audio
> - AMD Streaming
> - Realtek HD Audio
>
> The Python script proposed in this repo executes this tweak easily.
>
> This script is to be executed at each boot (using Task Scheduler) because Realtek driver recreates the subkeys at each boot.\
> Also, it will execute when a driver is updated.

So called Random reboots, sound cracklings, Fast Flickers, all those are now wipped and this laptop demonstrates good stability on load or on Modern Standby, which can now be fully enabled, along with Hibernate or Fast Startup.

Possibly works on other models from the same brand or product range too, like G733P models for instance

Many issues combining Modern Standby with Hibernate or Fast Startup, are fixed by Media Audio drivers tweak, consisting in removine the Powersettings subkey folder in Registry, due to BIOS ACPI malfunction 

> [!NOTE]
> DRIPS state is the lowest powered mode in Modern Standby, where the computer is really sleeping. See details in [References document 1](#References).
> 
> On Asus STRIX laptop, this state can be easily identified in AC mode, by the lights on the keyboard, showing a nice red effect:
> 
> ![ezgif-608d3a39ba95bd6d](https://github.com/user-attachments/assets/2d6b0e80-a177-456c-9006-9e70241569f4)
> 

## Tweaking hibernate
Hibernate mode is not enabled nor configured by default in Windows 11

You can enable Hibernate mode, using the Legacy Configuration panel / Power options / Power buttons

Or use the Wintoys application

To set the Hibernate timeout, use a simple terminal window and command line: 

1. For AC timeout: \
   `powercfg /SETACVALUEINDEX SCHEME_CURRENT SUB_SLEEP HIBERNATEIDLE <Timeout AC value in seconds>`\
   The Timeout value is to be set in seconds in this command line
2. For DC timeout: \
   `powercfg /SETDCVALUEINDEX SCHEME_CURRENT SUB_SLEEP HIBERNATEIDLE <Timeout DC value in seconds>`\
   The Timeout value is to be set in seconds in this command line

3. To read the current Hibernate timeout values: \
   `powercfg /q SCHEME_CURRENT SUB_SLEEP HIBERNATEIDLE`\
   Note that the timeouts values are displayed in Hexadecimal


## Drivers and Firmware
The default Windows 11 25H2 drivers, and Asus drivers are used, with the exception of the followings:

1. **ASMedia 4242 Firmware**\
There's a more recent version of this Firmware available here: [www.station-drivers.com](https://www.station-drivers.com/index.php/fr/component/remository/Drivers/Asmedia/ASM-1x4x-2x4x-314x2-3242-4242--...--and--107x-2074-USB-3.x--and--USB-4.x-Controllers/Firmwares/ASM-4242-USB-4-Controller/Asmedia-ASM-4242-%28USB-4.0%29-Firmware-Version-1.02.22.00.00.11/lang,fr-fr/)\
This latest version makes use of USB-C ports more stable than with Asus firmware version (outdated)

2. **AMD Chipset and driver**\
All latest, Adrenalin 26.6.4 with its associated chipset 8.05.04.516 works fine

3. **nVidia GPU driver**\
All latest, version 610.74 recent and works well.

> [!IMPORTANT]
> **WORKAROUND TO FIX HD AUDIO DRIVERS DUE TO BIOS ACPI bug**
>
> - NVIDIA HD Audio driver (currently 1.4.5.7)
> - AMD Streaming Audio driver
> - Realtek HD Audio driver
> 
> all requires a Power settings tweak, otherwise, they might Freeze the PC when entering Modern Standby DRIPS
>
> These driver sets in Registry, a particular custom folder for energy savings: PowerSettings, containing 3 keys for Performance, Conservation, and Idle level.
> 
> They are created in this folder. Note `<XXXX>` is numbered by Windows:
> ```
> HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e96c-e325-11ce-bfc1-08002be10318}\<XXXX>\PowerSettings
> ```
>
> Probably due to BIOS (336) ACPI bug, this creates an instability with Windows
>
> The complete PowerSettings folder is to be removed, forcing default Windows settings. Safe, as this folder can be recreated each time the driver is installed.
>
> The Python script available here simply locates and removes these PowerSettings folders automatically for the abovementionned Media drivers
>
> The script is to be run at each boot or when a driver is modified. A Task Scheduler task is set automatically as System user with privileges, as the Realtek driver recreates its keys at each reboot

Execute script for test purpose in a Terminal: 
```
python fix_media_powersettings.py
```
Or directly running the compiled .exe version to install it in some folder: 
```
fix_media_powersettings.exe
```
How to Compile the script to create .exe, in a simple terminal window:
```
pyinstaller --onefile .\fix_media_powersettings.py
```
A `/v` option can be used in command line to show a popup on execution. 

The .exe version is used in a scheduled task to automatically scan and perform the needed action on reboot. 

It creates automatically the scheduled task for System user, with all elevated rights.

## References
1. [White paper on Modern Standby from DELL](https://dl.dell.com/manuals/all-products/esuprt_solutions_int/esuprt_solutions_int_solutions_resources/client-mobile-solution-resources_white-papers45_en-us.pdf)
Synthetic information relative to Modern Standby
2. [Microsoft learn - PortCls Registry Power Settings](https://learn.microsoft.com/en-us/windows-hardware/drivers/audio/portcls-registry-power-settings)
Concerns Media devices Idle timeout settings
3. [Microsoft learn - Device idle policy](https://learn.microsoft.com/en-us/windows-hardware/customize/power-settings/no-subgroup-settings-device-idle-policy)
Concerns Kernel device drivers Idle timeout management
4. [Microsoft learn - Allow networking during standby](https://learn.microsoft.com/en-us/windows-hardware/customize/power-settings/no-subgroup-settings-allow-networking-during-standby)
Concerns about Connectivity in standby, for Modern Standby. Deprecated, but turns out it is still in use.
5. [Audio Device Class Inactivity Timer Implementation](https://learn.microsoft.com/en-us/windows-hardware/drivers/audio/audio-device-class-inactivity-timer-implementation)
Explanations about PowerSettings (conservationidletime, idlepowerstate, performanceidletime) for driver devices
