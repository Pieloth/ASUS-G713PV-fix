import os
import sys
import ctypes
import argparse
import winreg

# Version Identifier
VERSION = "1.5.0"

# Requires: pip install pywin32
try:
    import win32com.client
except ImportError:
    win32com = None

# Configuration: Add any target drivers to this list (Case-Insensitive)
TARGET_DRIVERS = [
    "nVidia High Definition Audio",
    "AMD Streaming Audio Device",
    "Realtek High Definition Audio"
]

# Task Scheduler Configuration
TASK_NAME = "fix_media_powersettings"
TASK_DESCRIPTION = (
    "Compiled Python script to remove Media class PowerSettings subkeys in "
    "registry for nVidia, AMD, and Realtek drivers, due to ACPI malfunction in "
    "Asus BIOS leading to PC freeze in Modern Standby"
)

# Base Search Path (Double backslashes prevent syntax warnings)
CLASS_KEY_PATH = "SYSTEM\\CurrentControlSet\\Control\\Class"

def is_admin():
    """Checks if the script is running with administrator privileges."""
    try:
        return ctypes.windll.shell32.IsUserAnAdmin() != 0
    except:
        return False

def elevate_privileges():
    """
    Relaunches the current script or executable with Administrator privileges (UAC prompt).
    """
    if getattr(sys, 'frozen', False):
        # Executable compiled (PyInstaller / cx_Freeze)
        executable = sys.executable
        params = " ".join([f'"{arg}"' for arg in sys.argv[1:]])
    else:
        # Standard Python script (.py)
        executable = sys.executable
        script = os.path.abspath(sys.argv[0])
        params = f'"{script}" ' + " ".join([f'"{arg}"' for arg in sys.argv[1:]])

    # 1 = SW_SHOWNORMAL | "runas" triggers the Windows UAC elevation prompt
    ret = ctypes.windll.shell32.ShellExecuteW(None, "runas", executable, params, None, 1)
    
    # HINSTANCE > 32 indicates successful process creation
    if ret > 32:
        sys.exit(0)
    else:
        print("[!] Elevation request was denied by the user or failed.")
        sys.exit(1)

def show_popup(title, message):
    """Displays a native Windows information popup dialog."""
    # 0x40 = MB_OK | MB_ICONINFORMATION
    ctypes.windll.user32.MessageBoxW(0, message, title, 0x40)

def get_current_executable_path():
    """
    Returns the absolute path to the current running executable/script.
    Handles both standalone compiled .exe (PyInstaller) and standard .py execution.
    """
    if getattr(sys, 'frozen', False):
        return os.path.abspath(sys.executable)
    else:
        return os.path.abspath(sys.argv[0])

def create_or_update_scheduled_task_com():
    """
    Creates or updates the scheduled task using pywin32 (Schedule.Service COM API).
    Detects path changes and updates the task definition accordingly.
    """
    if win32com is None:
        return "Error: 'pywin32' library is not installed (run 'pip install pywin32')."

    current_exe = get_current_executable_path()

    # Task Scheduler Constants
    TASK_TRIGGER_BOOT = 8
    TASK_ACTION_EXEC = 0
    TASK_CREATE_OR_UPDATE = 6
    TASK_LOGON_SERVICE_ACCOUNT = 5
    TASK_RUNLEVEL_HIGHEST = 1

    try:
        scheduler = win32com.client.Dispatch("Schedule.Service")
        scheduler.Connect()
        root_folder = scheduler.GetFolder("\\")

        # Check existing task command path
        existing_command = None
        try:
            existing_task = root_folder.GetTask(TASK_NAME)
            task_def = existing_task.Definition
            for action in task_def.Actions:
                if action.Type == TASK_ACTION_EXEC:
                    existing_command = action.Path
                    break
        except Exception:
            # Task does not exist yet
            pass

        if existing_command:
            if os.path.normpath(existing_command).lower() == os.path.normpath(current_exe).lower():
                return "Task exists and points to current executable path. No changes needed."
            else:
                print(f"[*] Executable location change detected.")
                print(f"    Previous path: {existing_command}")
                print(f"    Current path:  {current_exe}")
                action_status = f"Updated task path from '{existing_command}' to '{current_exe}'."
        else:
            action_status = f"Task created successfully for '{current_exe}'."

        # Create new task definition
        task_def = scheduler.NewTask(0)

        # 1. Registration Info
        task_def.RegistrationInfo.Description = TASK_DESCRIPTION

        # 2. Settings
        settings = task_def.Settings
        settings.Enabled = True
        settings.StartWhenAvailable = False
        settings.DisallowStartIfOnBatteries = False
        settings.StopIfGoingOnBatteries = False
        settings.AllowHardTerminate = True
        settings.ExecutionTimeLimit = "PT72H"
        settings.Priority = 7

        # 3. Trigger (At Startup)
        trigger = task_def.Triggers.Create(TASK_TRIGGER_BOOT)
        trigger.Enabled = True

        # 4. Action (Execute binary)
        action = task_def.Actions.Create(TASK_ACTION_EXEC)
        action.Path = current_exe

        # 5. Principal (SYSTEM Account with Highest Privileges)
        principal = task_def.Principal
        principal.UserId = "S-1-5-18"  # Local SYSTEM account
        principal.RunLevel = TASK_RUNLEVEL_HIGHEST

        # Register task (Create or overwrite)
        root_folder.RegisterTaskDefinition(
            TASK_NAME,
            task_def,
            TASK_CREATE_OR_UPDATE,
            None,  # User (None for SYSTEM)
            None,  # Password
            TASK_LOGON_SERVICE_ACCOUNT
        )

        return action_status

    except Exception as e:
        return f"Failed to configure task via COM API: {str(e)}"

def find_all_power_settings_paths():
    r"""
    Iterates through the subkeys of HKLM\SYSTEM\CurrentControlSet\Control\Class.
    Maps matches to the lowercase version of the drivers listed in TARGET_DRIVERS.
    Returns a dictionary of {driver_name: power_settings_registry_path_or_None}.
    """
    results = {driver.lower(): None for driver in TARGET_DRIVERS}
    drivers_to_find = [d.lower() for d in TARGET_DRIVERS]

    try:
        class_key = winreg.OpenKey(
            winreg.HKEY_LOCAL_MACHINE, 
            CLASS_KEY_PATH, 
            0, 
            winreg.KEY_READ | winreg.KEY_WOW64_64KEY
        )
    except OSError as e:
        print(f"[-] Unable to open the Class key: {e}")
        return {}

    i = 0
    while True:
        try:
            sub_key_name = winreg.EnumKey(class_key, i)
            sub_key_path = f"{CLASS_KEY_PATH}\\{sub_key_name}"
            
            sub_key = winreg.OpenKey(
                winreg.HKEY_LOCAL_MACHINE, 
                sub_key_path, 
                0, 
                winreg.KEY_READ | winreg.KEY_WOW64_64KEY
            )
            j = 0
            while True:
                try:
                    driver_index_name = winreg.EnumKey(sub_key, j)
                    driver_path = f"{sub_key_path}\\{driver_index_name}"
                    
                    try:
                        driver_key = winreg.OpenKey(
                            winreg.HKEY_LOCAL_MACHINE, 
                            driver_path, 
                            0, 
                            winreg.KEY_READ | winreg.KEY_WOW64_64KEY
                        )
                        driver_desc, _ = winreg.QueryValueEx(driver_key, "DriverDesc")
                        driver_key.Close()
                        
                        desc_lower = str(driver_desc).lower()
                        if desc_lower in drivers_to_find:
                            power_settings_path = f"{driver_path}\\PowerSettings"
                            try:
                                ps_key = winreg.OpenKey(
                                    winreg.HKEY_LOCAL_MACHINE, 
                                    power_settings_path, 
                                    0, 
                                    winreg.KEY_READ | winreg.KEY_WOW64_64KEY
                                )
                                ps_key.Close()
                                results[desc_lower] = power_settings_path
                            except OSError:
                                pass
                    except OSError:
                        pass
                    j += 1
                except OSError:
                    break
            
            sub_key.Close()
            i += 1
        except OSError:
            break

    class_key.Close()
    return results

def delete_power_settings(power_settings_path):
    """
    Safely deletes the target PowerSettings registry key.
    """
    try:
        parent_path, key_to_delete = power_settings_path.rsplit('\\', 1)
        
        parent_key = winreg.OpenKey(
            winreg.HKEY_LOCAL_MACHINE, 
            parent_path, 
            0, 
            winreg.KEY_WRITE | winreg.KEY_WOW64_64KEY
        )
        
        winreg.DeleteKey(parent_key, key_to_delete)
        parent_key.Close()
        return True
    except OSError as e:
        print(f"[-] Error occurred while deleting the key: {e}")
        return False

def main():
    parser = argparse.ArgumentParser(
        description=f"Disable targeted audio device power restrictions to fix Modern Standby bugs (v{VERSION}).",
        prefix_chars='/-'
    )
    parser.add_argument('/v', action='store_true', help="Display a summary popup notification after processing.")
    args = parser.parse_args()

    # Display initial version banner before any execution
    print(f"=== Modern Standby Registry Fixer v{VERSION} ===")

    # Request UAC elevation if not already running as Administrator
    if not is_admin():
        print("[*] Administrator privileges required. Requesting UAC elevation...")
        elevate_privileges()

    popup_messages = []

    # --- PART 1: Task Scheduler Management (via pywin32 COM) ---
    print("[*] Checking Windows Task Scheduler configuration via COM API...")
    task_status = create_or_update_scheduled_task_com()
    print(f"[+] Task Scheduler Status: {task_status}")
    popup_messages.append(f"• Scheduled Task Status:\n  {task_status}")

    # --- PART 2: Registry Processing ---
    print("-" * 60)
    print("[*] Scanning Registry Class configurations for matching target drivers...")
    found_paths = find_all_power_settings_paths()

    for driver in TARGET_DRIVERS:
        driver_lower = driver.lower()
        path = found_paths.get(driver_lower)

        print(f"[*] Processing: {driver}")
        
        if not path:
            msg = "No 'PowerSettings' key found (already deleted or absent)."
            print(f"[-] {msg}")
            popup_messages.append(f"• {driver}:\n  {msg}")
        else:
            print(f"[+] Key detected: HKLM\\{path}")
            success = delete_power_settings(path)
            if success:
                msg = "The 'PowerSettings' directory was successfully deleted."
                print(f"[+] {msg}")
                popup_messages.append(f"• {driver}:\n  {msg}")
            else:
                msg = "Failed to delete the registry key."
                print(f"[-] {msg}")
                popup_messages.append(f"• {driver}:\n  {msg}")
        print("-" * 60)

    # --- PART 3: Summary Display ---
    if args.v:
        summary_message = f"Execution Status Report (v{VERSION}):\n\n" + "\n\n".join(popup_messages)
        show_popup(f"Modern Standby Registry Fixer v{VERSION}", summary_message)

if __name__ == "__main__":
    main()