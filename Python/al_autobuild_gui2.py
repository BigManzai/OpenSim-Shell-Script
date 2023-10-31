import tkinter as tk
import subprocess
import xml.etree.ElementTree as ET

# Funktion zum Ausführen von Befehlen und Anzeigen der Ausgabe
def run_command(command, output_text):
    try:
        result = subprocess.run(command, shell=True, text=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        output = result.stdout
        error = result.stderr
        if output:
            output_text.insert(tk.END, output)
        if error:
            output_text.insert(tk.END, error)
    except Exception as e:
        output_text.insert(tk.END, f"Fehler beim Ausführen des Befehls: {e}")

# Funktion zur Erstellung einer konfigurierbaren XML-Datei
def create_config_xml(output_text):
    try:
        # Laden der Vorlagen-XML-Datei (autobuild.xml von Firestorm Viewer)
        template_tree = ET.parse('autobuild.xml')
        template_root = template_tree.getroot()

        # Hier können Sie die Vorlage anpassen, indem Sie Elemente hinzufügen, ändern oder löschen
        # Zum Beispiel:
        # new_element = ET.Element('NewElement')
        # new_element.text = 'Inhalt des neuen Elements'
        # template_root.append(new_element)

        # Die angepasste XML-Datei speichern
        template_tree.write('my_autobuild.xml')

        output_text.insert(tk.END, "Konfigurierbare XML-Datei erstellt: my_autobuild.xml\n")
    except Exception as e:
        output_text.insert(tk.END, f"Fehler beim Erstellen der XML-Datei: {e}\n")

# Funktion zur Konfiguration des Viewers
def configure_viewer(output_text, fmodstudio, package, channel, tests, verbose):
    # Zuerst die XML-Datei erstellen
    create_config_xml(output_text)

    # Fortsetzen mit der Viewer-Konfiguration
    command = "set AUTOBUILD_CONFIG_FILE=my_autobuild.xml && c: && cd \\firestorm\\phoenix-firestorm"
    
    command += " && autobuild configure -A 64 -c ReleaseFS_open"
    
    if fmodstudio:
        command += " --fmodstudio"
    
    if package:
        command += " --package"
    
    if channel:
        command += f" --chan {channel}"
    
    if not tests:
        command += " -DLL_TESTS:BOOL=FALSE"
    
    if verbose:
        command += " -v"
    
    run_command(command, output_text)

# Funktion zum Bauen des Viewers
def build_viewer(output_text, verbose):
    # Zuerst die XML-Datei erstellen
    create_config_xml(output_text)

    # Fortsetzen mit dem Viewer-Bau
    command = "set AUTOBUILD_CONFIG_FILE=my_autobuild.xml && c: && cd \\firestorm\\phoenix-firestorm"
    
    command += " && autobuild build -A 64 -c ReleaseFS_open --no-configure"
    
    if verbose:
        command += " -v"
    
    run_command(command, output_text)


# Funktionen für die Schritte
def check_installed_properly(output_text):
    commands = [
        "cmake --version",
        "git --version",
        "python --version",
        "pip --version"
    ]

    for command in commands:
        run_command(command, output_text)

def install_autobuild(output_text):
    command = "pip install git+https://github.com/secondlife/autobuild.git#egg=autobuild"
    run_command(command, output_text)

def set_autobuild_vsver(output_text):
    command = "set AUTOBUILD_VSVER=170"
    run_command(command, output_text)

def check_autobuild_version(output_text):
    command = "autobuild --version"
    run_command(command, output_text)

def clone_firestorm_repository(output_text):
    command = "c: && cd \\firestorm && git clone https://vcs.firestormviewer.org/phoenix-firestorm"
    run_command(command, output_text)

def clone_fmodstudio_repository(output_text):
    command = "c: && cd \\firestorm && git clone https://vcs.firestormviewer.org/3p-libraries/3p-fmodstudio"
    run_command(command, output_text)

# Funktion zur Konfiguration des Viewers
def configure_viewer(output_text, fmodstudio, package, channel, tests, verbose):
    command = "set AUTOBUILD_CONFIG_FILE=my_autobuild.xml && c: && cd \\firestorm\\phoenix-firestorm"
    
    command += " && autobuild configure -A 64 -c ReleaseFS_open"
    
    if fmodstudio:
        command += " --fmodstudio"
    
    if package:
        command += " --package"
    
    if channel:
        command += f" --chan {channel}"
    
    if not tests:
        command += " -DLL_TESTS:BOOL=FALSE"
    
    if verbose:
        command += " -v"
    
    run_command(command, output_text)

# Funktion zum Bauen des Viewers
def build_viewer(output_text, verbose):
    command = "set AUTOBUILD_CONFIG_FILE=my_autobuild.xml && c: && cd \\firestorm\\phoenix-firestorm"
    
    command += " && autobuild build -A 64 -c ReleaseFS_open --no-configure"
    
    if verbose:
        command += " -v"
    
    run_command(command, output_text)

# Erstellen des Hauptfensters
root = tk.Tk()
root.title("Second Life Autobuild Tool")

# Festlegen der Mindestgröße des Fensters
root.minsize(480, 640)

# Erklärungen als Labels vor den Buttons
explanation0 = tk.Label(root, text=" ")
explanation0.pack()

# Erklärungen als Labels vor den Buttons
explanation1 = tk.Label(root, bg="lightgray", text="Schritt 1: Überprüfen Sie die Installation von CMake, Git, Python und Pip.")
explanation1.pack()
# Schaltflächen und Textfeld zum Anzeigen des Fortschritts hinzufügen
check_button = tk.Button(root, text="Schritt 1: Check Installed Properly", command=lambda: check_installed_properly(output_text))
check_button.pack()
check_button.pack(padx=10, pady=12)  # Horizontale und vertikale Abstände zwischen Label und Frame

explanation2 = tk.Label(root, bg="lightgray", text="Schritt 2: Installieren Sie Autobuild.")
explanation2.pack()
install_button = tk.Button(root, text="Schritt 2: Install Autobuild", command=lambda: install_autobuild(output_text))
install_button.pack()
install_button.pack(padx=10, pady=12)  # Horizontale und vertikale Abstände zwischen Label und Frame

explanation3 = tk.Label(root, bg="lightgray", text="Schritt 3: Setzen Sie die Umgebungsvariable AUTOBUILD_VSVER auf 170.")
explanation3.pack()
vsver_button = tk.Button(root, text="Schritt 3: Set AUTOBUILD_VSVER", command=lambda: set_autobuild_vsver(output_text))
vsver_button.pack()
vsver_button.pack(padx=10, pady=12)  # Horizontale und vertikale Abstände zwischen Label und Frame

explanation4 = tk.Label(root, bg="lightgray", text="Schritt 4: Überprüfen Sie die Autobuild-Version.")
explanation4.pack()
version_button = tk.Button(root, text="Schritt 4: Check Autobuild Version", command=lambda: check_autobuild_version(output_text))
version_button.pack()
version_button.pack(padx=10, pady=12)  # Horizontale und vertikale Abstände zwischen Label und Frame

explanation5 = tk.Label(root, bg="lightgray", text="Schritt 5: Klonen Sie das Firestorm-Repository.")
explanation5.pack()
firestorm_clone_button = tk.Button(root, text="Schritt 5: Clone Firestorm Repository", command=lambda: clone_firestorm_repository(output_text))
firestorm_clone_button.pack()
firestorm_clone_button.pack(padx=10, pady=12)  # Horizontale und vertikale Abstände zwischen Label und Frame

explanation6 = tk.Label(root, bg="lightgray", text="Schritt 6: Klonen Sie das FMOD Studio-Repository.")
explanation6.pack()
fmodstudio_clone_button = tk.Button(root, text="Schritt 6: Clone FMOD Studio Repository", command=lambda: clone_fmodstudio_repository(output_text))
fmodstudio_clone_button.pack()
fmodstudio_clone_button.pack(padx=10, pady=12)  # Horizontale und vertikale Abstände zwischen Label und Frame

explanation6 = tk.Label(root, bg="lightgray", text="Schritt 7: Das konfigurieren des Viewers.")
explanation6.pack()
configure_button = tk.Button(root, text="Schritt 7: Configure Viewer", command=lambda: configure_viewer(output_text, True, True, "MyChannel", True, True))
configure_button.pack()
configure_button.pack(padx=10, pady=12)  # Horizontale und vertikale Abstände zwischen Label und Frame

explanation6 = tk.Label(root, bg="lightgray", text="Schritt 8: Das erstellen des Viewers.")
explanation6.pack()
build_button = tk.Button(root, text="Schritt 8: Build Viewer", command=lambda: build_viewer(output_text, True))
build_button.pack()
build_button.pack(padx=10, pady=12)  # Horizontale und vertikale Abstände zwischen Label und Frame

# Das Output Fenster.
explanation6 = tk.Label(root, bg="lightgray", text="Output")
explanation6.pack()
output_text = tk.Text(root, height=10, width=80)
output_text.pack()
output_text.pack(padx=10, pady=12)  # Horizontale und vertikale Abstände zwischen Label und Frame

# Schleife starten
root.mainloop()
