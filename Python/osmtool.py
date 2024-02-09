import os
import tkinter as tk
from tkinter import ttk
import configparser
import paramiko

# Dieses Programm enthält alle erforderlichen Funktionen, um den OpenSimulator über eine GUI zu steuern, 
# und integriert die Konfigurationsdatei, um voreingestellte Werte zu speichern und zu laden. 
# Sie können diese Konfiguration anpassen und speichern, 
# und das Programm wird beim nächsten Start die gespeicherten Werte laden.

CONFIG_FILE = 'opensim_controller.ini'

def execute_ssh_command(hostname, port, username, password, command):
    try:
        ssh = paramiko.SSHClient()
        ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        ssh.connect(hostname, port, username, password)
        stdin, stdout, stderr = ssh.exec_command(command)
        output = stdout.read().decode('utf-8')
        ssh.close()
        return output
    except Exception as e:
        return f"Fehler beim Verbinden oder Ausführen des Befehls: {str(e)}"

def start_os():
    config = load_config()
    hostname = config.get('OpenSimulator', 'hostname', fallback='remote_server_ip')
    port = int(config.get('OpenSimulator', 'port', fallback='22'))
    username = config.get('OpenSimulator', 'username', fallback='your_username')
    password = config.get('OpenSimulator', 'password', fallback='your_password')
    osstartscreen = config.get('OpenSimulator', 'osstartscreen', fallback='OSSTARTSCREEN')
    startverzeichnis = config.get('OpenSimulator', 'startverzeichnis', fallback='/STARTVERZEICHNIS')
    dotnetmodus = config.get('OpenSimulator', 'dotnetmodus', fallback='yes')
    command = f"cd {startverzeichnis}/{osstartscreen}/bin && "
    if dotnetmodus == "yes":
        command += "dotnet OpenSim.dll"
    elif dotnetmodus == "no":
        command += "mono OpenSim.exe"
    output = execute_ssh_command(hostname, port, username, password, command)
    return output

def stop_os():
    config = load_config()
    hostname = config.get('OpenSimulator', 'hostname', fallback='remote_server_ip')
    port = int(config.get('OpenSimulator', 'port', fallback='22'))
    username = config.get('OpenSimulator', 'username', fallback='your_username')
    password = config.get('OpenSimulator', 'password', fallback='your_password')
    osstopscreen = config.get('OpenSimulator', 'osstopscreen', fallback='OSSTOPSCREEN')
    stopwartezeit = int(config.get('OpenSimulator', 'stopwartezeit', fallback='10'))
    command = f"screen -S {osstopscreen} -p 0 -X eval 'stuff \"shutdown\"\015' && sleep {stopwartezeit} && screen -X -S {osstopscreen} kill"
    output = execute_ssh_command(hostname, port, username, password, command)
    return output

def restart_os():
    stop_output = stop_os()
    start_output = start_os()
    return stop_output + start_output

def save_config(config):
    with open(CONFIG_FILE, 'w') as configfile:
        config.write(configfile)

def load_config():
    config = configparser.ConfigParser()
    if os.path.exists(CONFIG_FILE):
        config.read(CONFIG_FILE)
    return config

def main():
    root = tk.Tk()
    root.title("OpenSimulator Controller")

    # Fenstergröße auf 300x300 Pixel einstellen
    root.geometry("300x300")

    config = load_config()

    hostname_label = ttk.Label(root, text="Hostname:")
    hostname_label.grid(row=0, column=0, sticky=tk.W)
    hostname_entry = ttk.Entry(root)
    hostname_entry.grid(row=0, column=1)
    hostname_entry.insert(0, config.get('OpenSimulator', 'hostname', fallback='remote_server_ip'))

    port_label = ttk.Label(root, text="Port:")
    port_label.grid(row=1, column=0, sticky=tk.W)
    port_entry = ttk.Entry(root)
    port_entry.grid(row=1, column=1)
    port_entry.insert(0, config.get('OpenSimulator', 'port', fallback='22'))

    username_label = ttk.Label(root, text="Username:")
    username_label.grid(row=2, column=0, sticky=tk.W)
    username_entry = ttk.Entry(root)
    username_entry.grid(row=2, column=1)
    username_entry.insert(0, config.get('OpenSimulator', 'username', fallback='your_username'))

    password_label = ttk.Label(root, text="Password:")
    password_label.grid(row=3, column=0, sticky=tk.W)
    password_entry = ttk.Entry(root, show="*")
    password_entry.grid(row=3, column=1)
    password_entry.insert(0, config.get('OpenSimulator', 'password', fallback='your_password'))

    osstartscreen_label = ttk.Label(root, text="OS Start Screen:")
    osstartscreen_label.grid(row=4, column=0, sticky=tk.W)
    osstartscreen_entry = ttk.Entry(root)
    osstartscreen_entry.grid(row=4, column=1)
    osstartscreen_entry.insert(0, config.get('OpenSimulator', 'osstartscreen', fallback='OSSTARTSCREEN'))

    startverzeichnis_label = ttk.Label(root, text="Start Directory:")
    startverzeichnis_label.grid(row=5, column=0, sticky=tk.W)
    startverzeichnis_entry = ttk.Entry(root)
    startverzeichnis_entry.grid(row=5, column=1)
    startverzeichnis_entry.insert(0, config.get('OpenSimulator', 'startverzeichnis', fallback='/STARTVERZEICHNIS'))

    dotnetmodus_label = ttk.Label(root, text="DotNet Modus:")
    dotnetmodus_label.grid(row=6, column=0, sticky=tk.W)
    dotnetmodus_entry = ttk.Entry(root)
    dotnetmodus_entry.grid(row=6, column=1)
    dotnetmodus_entry.insert(0, config.get('OpenSimulator', 'dotnetmodus', fallback='yes'))

    osstopscreen_label = ttk.Label(root, text="OS Stop Screen:")
    osstopscreen_label.grid(row=7, column=0, sticky=tk.W)
    osstopscreen_entry = ttk.Entry(root)
    osstopscreen_entry.grid(row=7, column=1)
    osstopscreen_entry.insert(0, config.get('OpenSimulator', 'osstopscreen', fallback='OSSTOPSCREEN'))

    stopwartezeit_label = ttk.Label(root, text="Stop Wait Time:")
    stopwartezeit_label.grid(row=8, column=0, sticky=tk.W)
    stopwartezeit_entry = ttk.Entry(root)
    stopwartezeit_entry.grid(row=8, column=1)
    stopwartezeit_entry.insert(0, config.get('OpenSimulator', 'stopwartezeit', fallback='10'))

    start_button = ttk.Button(root, text="Start OS", command=lambda: start_os())
    start_button.grid(row=9, column=0, columnspan=1, pady=5)

    stop_button = ttk.Button(root, text="Stop OS", command=lambda: stop_os())
    stop_button.grid(row=9, column=1, columnspan=1, pady=5)

    restart_button = ttk.Button(root, text="Restart OS", command=lambda: restart_os())
    restart_button.grid(row=9, column=2, columnspan=1, pady=5)

    root.mainloop()

if __name__ == "__main__":
    main()
