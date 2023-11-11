#!/bin/bash

eins(){
# Verzeichnis mit Log-Dateien
log_dir="/var/log"

# Liste der Log-Dateien, die analysiert werden sollen
log_files=("syslog" "auth.log" "kern.log" "dpkg.log" "apache2/error.log")

# Schleife über jede Log-Datei
for log_file in "${log_files[@]}"
do
    # Überprüfe, ob die Log-Datei existiert
    if [ -e "$log_dir/$log_file" ]; then
        # Extrahiere Fehler aus der Log-Datei und zeige sie an
        echo "Fehler aus $log_file:"
        grep -i "error" "$log_dir/$log_file"
        echo "----------------------------------------"
    else
        echo "Die Log-Datei $log_file existiert nicht."
    fi
done
}

zwei(){
# Farbdefinitionen
RED='\033[0;31m'
NC='\033[0m' # No Color

# Verzeichnis mit Log-Dateien
log_dir="/var/log"

# Liste der Log-Dateien, die analysiert werden sollen
log_files=("syslog" "auth.log" "kern.log" "dpkg.log" "apache2/error.log")

# Schleife über jede Log-Datei
for log_file in "${log_files[@]}"
do
    # Überprüfe, ob die Log-Datei existiert
    if [ -e "$log_dir/$log_file" ]; then
        # Extrahiere Fehler aus der Log-Datei und zeige sie an (farblich hervorgehoben)
        echo -e "${RED}Fehler aus $log_file:${NC}"
        grep -i --color=always "error" "$log_dir/$log_file"
        echo "----------------------------------------"
    else
        echo "Die Log-Datei $log_file existiert nicht."
    fi
done
}

drei(){
# Farbdefinitionen für verschiedene Log-Dateien
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Verzeichnis mit Log-Dateien
log_dir="/var/log"

# Liste der Log-Dateien, die analysiert werden sollen
log_files=("syslog" "auth.log" "kern.log" "dpkg.log" "apache2/error.log")

# Schleife über jede Log-Datei
for ((i=0; i<${#log_files[@]}; i++))
do
    log_file="${log_files[i]}"
    
    # Überprüfe, ob die Log-Datei existiert
    if [ -e "$log_dir/$log_file" ]; then
        # Extrahiere Fehler aus der Log-Datei und zeige sie an (farblich hervorgehoben)
        case $i in
            0) COLOR=$RED;;
            1) COLOR=$GREEN;;
            2) COLOR=$YELLOW;;
            3) COLOR=$BLUE;;
            4) COLOR=$PURPLE;;
            *) COLOR=$NC;;
        esac

        echo -e "${COLOR}Fehler aus $log_file:${NC}"
        grep -i --color=always "error" "$log_dir/$log_file"
        echo "----------------------------------------"
    else
        echo "Die Log-Datei $log_file existiert nicht."
    fi
done
}

vier() {
# Farbdefinitionen für verschiedene Log-Dateien
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Verzeichnis mit Log-Dateien
log_dir="/var/log"

# Ausgabedatei für Fehler
output_file="/opt/logfehler.txt"

# Liste der Log-Dateien, die analysiert werden sollen
log_files=("syslog" "auth.log" "kern.log" "dpkg.log" "apache2/error.log")

# Schleife über jede Log-Datei
for ((i=0; i<${#log_files[@]}; i++))
do
    log_file="${log_files[i]}"
    
    # Überprüfe, ob die Log-Datei existiert
    if [ -e "$log_dir/$log_file" ]; then
        # Extrahiere Fehler aus der Log-Datei und zeige sie an (farblich hervorgehoben)
        case $i in
            0) COLOR=$RED;;
            1) COLOR=$GREEN;;
            2) COLOR=$YELLOW;;
            3) COLOR=$BLUE;;
            4) COLOR=$PURPLE;;
            *) COLOR=$NC;;
        esac

        echo -e "${COLOR}Fehler aus $log_file:${NC}"
        grep -i --color=always "error" "$log_dir/$log_file"
        echo "----------------------------------------"
        
        # Speichere Fehler in die Ausgabedatei
        grep -i "error" "$log_dir/$log_file" >> "$output_file"
    else
        echo "Die Log-Datei $log_file existiert nicht."
    fi
done

# Abschlussmeldung
echo "Fehler wurden auch in die Datei $output_file gespeichert."
}

fuenf() {
# Farbdefinitionen für verschiedene Log-Dateien
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Verzeichnis mit Log-Dateien
log_dir="/var/log"

# Ausgabedatei für Fehler
output_file="/opt/logfehler.txt"

# Liste der Log-Dateien, die analysiert werden sollen
log_files=("syslog" "auth.log" "kern.log" "dpkg.log" "apache2/error.log")

# Funktion für den Dialog mit Auswahlmöglichkeiten
select_log_file() {
    options=()
    for file in "${log_files[@]}"; do
        options+=("$file" "")
    done

    selected_file=$(dialog --clear --backtitle "Log-Datei auswählen" --menu "Wähle eine Log-Datei:" 15 40 10 "${options[@]}" 2>&1 >/dev/tty)
    clear

    if [ -n "$selected_file" ]; then
        return "$selected_file"
    else
        return 1
    fi
}

# Schleife über jede Log-Datei
for ((i=0; i<${#log_files[@]}; i++))
do
    log_file="${log_files[i]}"
    
    # Überprüfe, ob die Log-Datei existiert
    if [ -e "$log_dir/$log_file" ]; then
        # Extrahiere Fehler aus der Log-Datei und zeige sie an (farblich hervorgehoben)
        case $i in
            0) COLOR=$RED;;
            1) COLOR=$GREEN;;
            2) COLOR=$YELLOW;;
            3) COLOR=$BLUE;;
            4) COLOR=$PURPLE;;
            *) COLOR=$NC;;
        esac

        echo -e "${COLOR}Fehler aus $log_file:${NC}"
        grep -i --color=always "error" "$log_dir/$log_file"
        echo "----------------------------------------"
        
        # Speichere Fehler in die Ausgabedatei
        grep -i "error" "$log_dir/$log_file" >> "$output_file"
    else
        echo "Die Log-Datei $log_file existiert nicht."
    fi
done

# Dialog: Möchtest du die Fehler in der Datei anzeigen?
dialog --yesno "Möchtest du die Fehler in der Datei $output_file anzeigen?" 8 40

# Wenn der Benutzer "Ja" auswählt, zeige die Datei an
if [ $? -eq 0 ]; then
    dialog --textbox "$output_file" 20 60
fi
}

sechs() {
# Farbdefinitionen für verschiedene Log-Dateien
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Verzeichnis mit Log-Dateien
log_dir="/var/log"

# Ausgabedatei für Fehler (Standardname)
output_file="/opt/logfehler.txt"

# Liste der Log-Dateien, die analysiert werden sollen
log_files=("syslog" "auth.log" "kern.log" "dpkg.log" "apache2/error.log")

# Funktion für den Dialog mit Auswahlmöglichkeiten
select_log_file() {
    options=()
    for file in "${log_files[@]}"; do
        options+=("$file" "")
    done

    selected_file=$(dialog --clear --backtitle "Log-Datei auswählen" --menu "Wähle eine Log-Datei:" 15 40 10 "${options[@]}" 2>&1 >/dev/tty)
    clear

    if [ -n "$selected_file" ]; then
        return "$selected_file"
    else
        return 1
    fi
}

# Dialog: Abfrage des Dateinamens für die Fehlerdatei
output_file=$(dialog --inputbox "Gib den Dateinamen für die Fehlerdatei an:" 8 40 "$output_file" 2>&1 >/dev/tty)

# Schleife über jede Log-Datei
for ((i=0; i<${#log_files[@]}; i++))
do
    log_file="${log_files[i]}"
    
    # Überprüfe, ob die Log-Datei existiert
    if [ -e "$log_dir/$log_file" ]; then
        # Extrahiere Fehler aus der Log-Datei und zeige sie an (farblich hervorgehoben)
        case $i in
            0) COLOR=$RED;;
            1) COLOR=$GREEN;;
            2) COLOR=$YELLOW;;
            3) COLOR=$BLUE;;
            4) COLOR=$PURPLE;;
            *) COLOR=$NC;;
        esac

        echo -e "${COLOR}Fehler aus $log_file:${NC}"
        grep -i --color=always "error" "$log_dir/$log_file"
        echo "----------------------------------------"
        
        # Speichere Fehler in die Ausgabedatei
        grep -i "error" "$log_dir/$log_file" >> "$output_file"
    else
        echo "Die Log-Datei $log_file existiert nicht."
    fi
done

# Dialog: Möchtest du die Fehler in der Datei anzeigen?
dialog --yesno "Möchtest du die Fehler in der Datei $output_file anzeigen?" 8 40

# Wenn der Benutzer "Ja" auswählt, zeige die Datei an
if [ $? -eq 0 ]; then
    dialog --textbox "$output_file" 20 60
fi
}

sechs