#!/bin/bash
## progress_end_menu
#  progress_end_menu
##
progress_end_menu() {
    # Benachrichtigung über den Abschluss
    dialog --title "Fertig" --msgbox "Vorgang abgeschlossen!" 6 40
}
## show_progress_menu
# Funktion, um Fortschrittsbalken anzuzeigen
# Beispiel für die Verwendung der Funktion
# show_progress_menu "Fortschrittsbalken" "Bitte warten..." 8 60
# Benachrichtigung über den Abschluss
# progress_end_menu
##
show_progress_menu() {
    local title="$1"
    local text="$2"
    local height="$3"
    local width="$4"

    # Funktion zum Simulieren von Fortschritt
    simulate_progress() {
        for ((i = 0; i <= 100; i += 10)); do
            echo $i
            sleep 1
        done
    }

    # Fortschrittsbalken anzeigen
    dialog --title "$title" --gauge "$text" "$height" "$width" < <(
        simulate_progress
    ) 2>&1
}

show_progress_menu "Fortschrittsbalken" "Bitte warten..." 8 60
progress_end_menu