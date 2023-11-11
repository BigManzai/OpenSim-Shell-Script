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
    #!/bin/bash

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

vier