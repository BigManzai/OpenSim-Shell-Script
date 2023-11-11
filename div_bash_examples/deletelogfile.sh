#!/bin/bash

# Funktion zum Löschen von Log-Dateien
delete_log_files() {
    # Verzeichnis mit Log-Dateien
    log_dir="/var/log"

    # Liste der Log-Dateien, die gelöscht werden sollen
    log_files=("syslog" "auth.log" "kern.log" "dpkg.log" "apache2/error.log")

    # Überprüfe, ob der Benutzer Administratorrechte hat
    if [ "$(id -u)" != "0" ]; then
        echo "Dieses Skript benötigt Administratorrechte zum Löschen von Log-Dateien."
        exit 1
    fi

    # Schleife über jede Log-Datei und lösche sie
    for log_file in "${log_files[@]}"
    do
        # Überprüfe, ob die Log-Datei existiert
        if [ -e "$log_dir/$log_file" ]; then
            echo "Lösche Log-Datei: $log_file"
            rm "$log_dir/$log_file"
        else
            echo "Die Log-Datei $log_file existiert nicht."
        fi
    done

    echo "Löschen der Log-Dateien abgeschlossen."
}

# Aufruf der Funktion
delete_log_files
