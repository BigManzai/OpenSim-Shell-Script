#!/bin/bash
schwellenwert=80;
abfragezeit=300;

# Funktion zum Überprüfen der CPU-Auslastung und Protokollieren in Datei
check_cpu_usage() {
    cpu_threshold=$schwellenwert
    cpu_usage=$(top -b -n 1 | awk '/^%Cpu/ {print $2}' | cut -d. -f1)

    if [ "$cpu_usage" -gt "$cpu_threshold" ]; then
        message="WARNUNG: Hohe CPU-Auslastung! Aktuelle Auslastung: $cpu_usage%"
        echo "WARNUNG: Hohe CPU-Auslastung! Aktuelle Auslastung: $cpu_usage%"
        echo "$message" | tee -a /opt/systemauslastung.txt
        # Hier könntest du eine Benachrichtigungsmethode aufrufen.
    fi
}

# Funktion zum Überprüfen des Speicherverbrauchs und Protokollieren in Datei
check_memory_usage() {
    memory_threshold=$schwellenwert
    memory_usage=$(free | awk '/Mem:/ {printf("%d", $3/$2 * 100)}')

    if [ "$memory_usage" -gt "$memory_threshold" ]; then
        message="WARNUNG: Hoher Speicherverbrauch! Aktueller Verbrauch: $memory_usage%"
        echo "WARNUNG: Hoher Speicherverbrauch! Aktueller Verbrauch: $memory_usage%"
        echo "$message" | tee -a /opt/systemauslastung.txt
        # Hier könntest du eine Benachrichtigungsmethode aufrufen.
    fi
}

# Funktion zum Überprüfen des Festplattenplatzes und Protokollieren in Datei
check_disk_space() {
    disk_threshold=$schwellenwert
    disk_usage=$(df -h / | awk 'NR==2 {gsub("%",""); print $5}')

    if [ "$disk_usage" -gt "$disk_threshold" ]; then
        message="WARNUNG: Geringer Festplattenplatz! Aktuelle Auslastung: $disk_usage%"
        echo "WARNUNG: Geringer Festplattenplatz! Aktuelle Auslastung: $disk_usage%"
        echo "$message" | tee -a /opt/systemauslastung.txt
        # Hier könntest du eine Benachrichtigungsmethode aufrufen.
    fi
}

# Hauptfunktion zum Starten des Monitorings
monitor_system() {
    while true; do
        check_cpu_usage
        check_memory_usage
        check_disk_space
        sleep $abfragezeit  # Überprüfe alle xxx Sekunden (kann angepasst werden)
    done
}

# Starte das Systemmonitoring
monitor_system
