#!/bin/bash

# Funktion zum Zerlegen der Datei
zerlege_datei() {
    dialog --title "Datei zerlegen" --inputbox "Geben Sie den Dateinamen ein, der zerlegt werden soll:" 8 60 2>tempfile
    eingabe_datei=$(cat tempfile)
    rm tempfile
    if [ -z "$eingabe_datei" ]; then
        dialog --title "Fehler" --msgbox "Ungültige Eingabe. Bitte geben Sie einen Dateinamen an." 8 60
        return
    fi

    dialog --infobox "Zerlege die Datei in 1 GB große Teile..." 8 60
    split -b 1G "$eingabe_datei" "teil"
    dialog --infobox "Zerlegung abgeschlossen." 8 60
    sleep 2
}

# Funktion zum Zusammenfügen der Teile
fuege_zusammen() {
    dialog --title "Dateien zusammenfügen" --inputbox "Geben Sie den Dateinamen für die zusammengefügte Datei ein:" 8 60 2>tempfile
    ausgabe_datei=$(cat tempfile)
    rm tempfile
    if [ -z "$ausgabe_datei" ]; then
        dialog --title "Fehler" --msgbox "Ungültige Eingabe. Bitte geben Sie einen Dateinamen an." 8 60
        return
    fi

    dialog --infobox "Füge die 1 GB großen Teile zusammen..." 8 60
    cat teil* > "$ausgabe_datei"
    dialog --infobox "Zusammenfügen abgeschlossen." 8 60
    sleep 2
    rm teil*  # Entferne die temporären Teile
}

# Hauptmenü
while true; do
    auswahl=$(dialog --menu "Hauptmenü" 12 60 4 1 "Datei zerlegen" 2 "Dateien zusammenfügen" 3 "Beenden" 2>&1 >/dev/tty)

    case $auswahl in
        1)
            zerlege_datei
            ;;
        2)
            fuege_zusammen
            ;;
        3)
            dialog --infobox "Beende das Skript." 8 60
            sleep 2
            clear
            exit 0
            ;;
        *)
            dialog --infobox "Ungültige Auswahl. Bitte wählen Sie erneut." 8 60
            sleep 2
            ;;
    esac
done


# # Funktion zum Zerlegen der Datei ohne dialog
# zerlege_datei() {
#     echo "Zerlege die Datei in 1 GB große Teile..."
#     split -b 1G "$1" "teil"
#     echo "Zerlegung abgeschlossen."
# }

# # Funktion zum Zusammenfügen der Teile
# fuege_zusammen() {
#     echo "Füge die 1 GB großen Teile zusammen..."
#     cat teil* > "$1"
#     echo "Zusammenfügen abgeschlossen."
#     rm teil*  # Entferne die temporären Teile
# }

# # Hauptmenü
# auswahl=""
# while [ "$auswahl" != "3" ]; do
#     echo "1. Datei zerlegen"
#     echo "2. Datei zusammenfügen"
#     echo "3. Beenden"
#     read -r -p "Bitte wählen Sie eine Option: " auswahl

#     case $auswahl in
#         1)
#             read -r -p "Geben Sie den Dateinamen ein, der zerlegt werden soll: " eingabe_datei
#             zerlege_datei "$eingabe_datei"
#             ;;
#         2)
#             read -r -p "Geben Sie den Dateinamen für die zusammengefügte Datei ein: " ausgabe_datei
#             fuege_zusammen "$ausgabe_datei"
#             ;;
#         3)
#             echo "Beende das Skript."
#             ;;
#         *)
#             echo "Ungültige Auswahl. Bitte wählen Sie erneut."
#             ;;
#     esac
# done
