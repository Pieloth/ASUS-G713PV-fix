import os
import sys
import ctypes
import argparse
import winreg

# Configuration de la recherche (Antislashs doublés pour éviter tout warning de syntaxe)
CLASS_KEY_PATH = "SYSTEM\\CurrentControlSet\\Control\\Class"
TARGET_DRIVER_NAME = "nVidia High Definition Audio"

def is_admin():
    """Vérifie si le script est exécuté avec les privilèges d'administrateur."""
    try:
        return ctypes.windll.shell32.IsUserAnAdmin() != 0
    except:
        return False

def show_popup(title, message):
    """Affiche un popup d'information natif Windows."""
    ctypes.windll.user32.MessageBoxW(0, message, title, 0x40)

def find_nvidia_audio_power_settings():
    r"""
    Parcourt les sous-clés de HKLM\SYSTEM\CurrentControlSet\Control\Class
    à la recherche du driver 'nVidia High Definition Audio' (insensible à la casse)
    et retourne le chemin de sa sous-clé 'PowerSettings'.
    """
    try:
        # Ouverture avec des antislashs valides pour l'API Windows Registry
        class_key = winreg.OpenKey(
            winreg.HKEY_LOCAL_MACHINE, 
            CLASS_KEY_PATH, 
            0, 
            winreg.KEY_READ | winreg.KEY_WOW64_64KEY
        )
    except OSError as e:
        print(f"[-] Impossible d'ouvrir la clé Class : {e}")
        return None

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
                        
                        if str(driver_desc).lower() == TARGET_DRIVER_NAME.lower():
                            power_settings_path = f"{driver_path}\\PowerSettings"
                            try:
                                # Test de présence de PowerSettings
                                ps_key = winreg.OpenKey(
                                    winreg.HKEY_LOCAL_MACHINE, 
                                    power_settings_path, 
                                    0, 
                                    winreg.KEY_READ | winreg.KEY_WOW64_64KEY
                                )
                                ps_key.Close()
                                class_key.Close()
                                sub_key.Close()
                                return power_settings_path
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
    return None

def delete_power_settings(power_settings_path):
    """
    Supprime de façon sécurisée la clé de registre PowerSettings.
    """
    try:
        # Séparation du chemin avec l'antislash
        parent_path, key_to_delete = power_settings_path.rsplit('\\', 1)
        
        parent_key = winreg.OpenKey(
            winreg.HKEY_LOCAL_MACHINE, 
            parent_path, 
            0, 
            winreg.KEY_WRITE | winreg.KEY_WOW64_64KEY
        )
        
        # Suppression de la sous-clé PowerSettings
        winreg.DeleteKey(parent_key, key_to_delete)
        parent_key.Close()
        return True
    except OSError as e:
        print(f"[-] Erreur lors de la suppression de la clé : {e}")
        return False

def main():
    parser = argparse.ArgumentParser(
        description="Désactivation des restrictions d'alimentation NVIDIA HD Audio pour Modern Standby.",
        prefix_chars='/-'
    )
    
    parser.add_argument('/v', action='store_true', help="Affiche un popup si des modifications ont été apportées.")
    args = parser.parse_args()

    if not is_admin():
        print("[!] Erreur : Ce script doit être exécuté en tant qu'Administrateur.")
        sys.exit(1)

    print("[*] Recherche de la clé active pour 'nVidia High Definition Audio'...")
    power_settings_path = find_nvidia_audio_power_settings()

    if not power_settings_path:
        print("[-] Le répertoire 'PowerSettings' de l'audio nVidia est introuvable ou déjà supprimé.")
        if args.v:
            show_popup(
                "Statut NVIDIA PowerSettings", 
                "Aucune action requise :\nLe répertoire 'PowerSettings' n'existe pas ou a déjà été supprimé."
            )
        sys.exit(0)

    print(f"[+] Clé détectée : HKLM\\{power_settings_path}")
    
    # Tentative de suppression
    success = delete_power_settings(power_settings_path)

    if success:
        log_msg = "Le répertoire 'PowerSettings' associé à l'audio nVidia a été supprimé avec succès."
        print(f"[+] {log_msg}")
        if args.v:
            show_popup("Registre NVIDIA mis à jour", log_msg)
    else:
        print("[-] Échec de la suppression de la clé de registre.")

if __name__ == "__main__":
    main()