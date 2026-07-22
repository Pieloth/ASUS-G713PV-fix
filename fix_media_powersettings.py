import os
import sys
import ctypes
import argparse
import winreg

# Configuration: Add any target drivers to this list (Case-Insensitive)
TARGET_DRIVERS = [
    "nVidia High Definition Audio",
    "AMD Streaming Audio Device",
    "Realtek High Definition Audio"
]

# Base Search Path (Double backslashes prevent syntax warnings)
CLASS_KEY_PATH = "SYSTEM\\CurrentControlSet\\Control\\Class"

def is_admin():
    """Checks if the script is running with administrator privileges."""
    try:
        return ctypes.windll.shell32.IsUserAnAdmin() != 0
    except:
        return False

def show_popup(title, message):
    """Displays a native Windows information popup dialog."""
    # 0x40 = MB_OK | MB_ICONINFORMATION
    ctypes.windll.user32.MessageBoxW(0, message, title, 0x40)

def find_all_power_settings_paths():
    r"""
    Iterates through the subkeys of HKLM\SYSTEM\CurrentControlSet\Control\Class.
    Maps matches to the lowercase version of the drivers listed in TARGET_DRIVERS.
    Returns a dictionary of {driver_name: power_settings_registry_path_or_None}.
    """
    # Initialize all targets as None
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
                                # Test if PowerSettings subkey physically exists
                                ps_key = winreg.OpenKey(
                                    winreg.HKEY_LOCAL_MACHINE, 
                                    power_settings_path, 
                                    0, 
                                    winreg.KEY_READ | winreg.KEY_WOW64_64KEY
                                )
                                ps_key.Close()
                                # Store the path matching the lowercase configuration item
                                results[desc_lower] = power_settings_path
                            except OSError:
                                # Found the driver, but PowerSettings is missing/already deleted
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
        description="Disable targeted audio device power restrictions to fix Modern Standby bugs.",
        prefix_chars='/-'
    )
    parser.add_argument('/v', action='store_true', help="Display a summary popup notification after processing.")
    args = parser.parse_args()

    if not is_admin():
        print("[!] Error: This script must be run as an Administrator.")
        #sys.exit(1)

    print("[*] Scanning Registry Class configurations for matching target drivers...")
    found_paths = find_all_power_settings_paths()

    popup_messages = []
    
    print("-" * 60)
    # Loop through the list of targets to process them sequentially
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

    # If verbose switch is enabled, showcase all collected outcomes in one unified window
    if args.v:
        summary_message = "Execution Status Report:\n\n" + "\n\n".join(popup_messages)
        show_popup("Modern Standby Registry Fixer", summary_message)

if __name__ == "__main__":
    main()