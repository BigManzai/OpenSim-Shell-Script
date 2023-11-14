#!/bin/bash

# Globale Variablen:
# Beispiel für eine Ziel-IP-Adresse
ziel_ip="127.0.0.1"
# Beispiel für einen externen Dienst
externer_dienst="www.google.com"

# Funktion zur Anzeige von Netzwerkinformationen
zeige_netzwerkinformationen() {
    echo "### Netzwerkinformationen ###"
    # Abfrage der IP-Adresse
    echo "Geben sie eine Ziel IP Adresse an:[$ziel_ip]"
    read -r ziel_ip

    # Anzeige der IP-Adresse(n)
    echo -n "IP-Adresse(n): "
    hostname -I

    # Anzeige der Netzwerkverbindungszustände
    echo "Netzwerkverbindungszustand:"
    ss -tulwn

    # Anzeige von Netzwerkschnittstelleninformationen
    echo "Netzwerkschnittstelleninformationen:"
    ifconfig

    # Anzeige von Routinginformationen
    echo "Routinginformationen:"
    route -n

    # Auflösung des DNS-Namens für die Ziel-IP
    echo -n "DNS-Name für $ziel_ip: "
    nslookup "$ziel_ip" | grep 'name ='
}

# Funktion für Ping-Test
ping_test() {
    # Abfrage der IP-Adresse
    echo "Geben sie eine Ziel IP Adresse an:[$ziel_ip]"
    read -r ziel_ip

    echo "### Ping-Test ###"
    ping -c 4 "$ziel_ip"
}

# Funktion für netstat
netstat_info() {
    # Überprüfe, ob netstat installiert ist
    if command -v netstat >/dev/null 2>&1; then
        echo "### Netzstatistik ###"
        netstat -s
    else
        echo "netstat ist nicht installiert."

        # Frage den Benutzer, ob netstat installiert werden soll
        echo "Möchtest du netstat installieren? (Ja/Nein): "
        read -r antwort

        if [ "$antwort" = "Ja" ] || [ "$antwort" = "ja" ]; then
            # Installiere netstat, z.B., mit dem Paketmanager deiner Distribution
            # Hier wird apt-get für Debian-basierte Systeme verwendet. Du kannst dies anpassen.
            sudo apt-get install net-tools
            echo "netstat wurde installiert."
        else
            echo "netstat wurde nicht installiert. Die Funktion ist nicht verfügbar."
        fi
    fi
}

# Funktion für Traceroute
traceroute_info() {
    # Überprüfe, ob traceroute installiert ist
    if command -v traceroute >/dev/null 2>&1; then
        # Trage die Ziel-IP-Adresse ab
        echo "Geben Sie eine Ziel-IP-Adresse an: [$ziel_ip]"
        read -r ziel_ip

        echo "### Traceroute zu $ziel_ip ###"
        traceroute "$ziel_ip"
    else
        echo "traceroute ist nicht installiert."

        # Frage den Benutzer, ob traceroute installiert werden soll
        echo "Möchten Sie traceroute installieren? (Ja/Nein): " 
        read -r antwort

        if [ "$antwort" = "Ja" ] || [ "$antwort" = "ja" ]; then
            # Installiere traceroute, z.B., mit dem Paketmanager deiner Distribution
            # Hier wird apt-get für Debian-basierte Systeme verwendet. Du kannst dies anpassen.
            sudo apt-get install traceroute
            echo "traceroute wurde installiert."
            
            # Trage erneut die Ziel-IP-Adresse ab
            echo "Geben Sie eine Ziel-IP-Adresse an: [$ziel_ip]"
            read -r ziel_ip

            echo "### Traceroute zu $ziel_ip ###"
            traceroute "$ziel_ip"
        else
            echo "traceroute wurde nicht installiert. Die Funktion ist nicht verfügbar."
        fi
    fi
}

# Funktion für Überprüfung der Verfügbarkeit externer Dienste mit nc
pruefe_dienst_nc() {
    # Abfrage des esternen Dienstes
    echo "Geben sie externen Dienst an:[[$externer_dienst]]"
    read -r externer_dienst

    echo "### Überprüfung der Verfügbarkeit externer Dienste mit nc ###"
    echo "Verfügbarkeit von $externer_dienst:"
    if nc -zv -w 2 "$externer_dienst" 80; then
        echo "$externer_dienst ist erreichbar."
    else
        echo "$externer_dienst ist nicht erreichbar."
    fi
}

# Funktion für Überprüfung der Verfügbarkeit externer Dienste mit curl
pruefe_dienst_curl() {
    # Abfrage des esternen Dienstes
    echo "Geben sie externen Dienst an:[[$externer_dienst]]"
    read -r externer_dienst
    
    echo "### Überprüfung der Verfügbarkeit externer Dienste mit curl ###"
    echo "Verfügbarkeit von $externer_dienst:"
    if curl --head --silent --fail "$externer_dienst" > /dev/null; then
        echo "$externer_dienst ist erreichbar."
    else
        echo "$externer_dienst ist nicht erreichbar."
    fi
}

# Funktion für whois
whois_info() {
    # Abfrage der IP-Adresse
    echo "Geben sie eine Ziel IP Adresse an:[$ziel_ip]"
    read -r ziel_ip

    echo "### Whois-Informationen für $ziel_ip ###"
    whois "$ziel_ip"
}

# Funktion für ss
ss_info() {
    echo "### Netzwerkverbindungszustand mit ss ###"
    ss -tulwn
}

# Funktion für dig
dig_info() {
    # Abfrage der IP-Adresse
    echo "Geben sie eine Ziel IP Adresse an:[$ziel_ip]"
    read -r ziel_ip

    echo "### DNS-Informationen für $ziel_ip ###"
    dig "$ziel_ip"
}

# Funktion für nmap
nmap_scan() {
    # Überprüfe, ob nmap installiert ist
    if command -v nmap >/dev/null 2>&1; then
        # Trage die Ziel-IP-Adresse ab
        echo "Geben Sie eine Ziel-IP-Adresse an: [$ziel_ip]"
        read -r ziel_ip

        echo "### nmap-Scan für $ziel_ip ###"
        nmap "$ziel_ip"
    else
        echo "nmap ist nicht installiert."

        # Frage den Benutzer, ob nmap installiert werden soll
        echo "Möchten Sie nmap installieren? (Ja/Nein): "
        read -r antwort

        if [ "$antwort" = "Ja" ] || [ "$antwort" = "ja" ]; then
            # Installiere nmap, z.B., mit dem Paketmanager deiner Distribution
            # Hier wird apt-get für Debian-basierte Systeme verwendet. Du kannst dies anpassen.
            sudo apt-get install nmap
            echo "nmap wurde installiert."
            
            # Trage erneut die Ziel-IP-Adresse ab
            echo "Geben Sie eine Ziel-IP-Adresse an: [$ziel_ip]"
            read -r ziel_ip

            echo "### nmap-Scan für $ziel_ip ###"
            nmap "$ziel_ip"
        else
            echo "nmap wurde nicht installiert. Die Funktion ist nicht verfügbar."
        fi
    fi
}

# Hauptfunktion für das Auswahlmenü
main_menu() {
    PS3="Wähle eine Option: "
    options=("Netzwerkinformationen" "Ping-Test" "Netzstatistik" "Traceroute" "Verfügbarkeit mit nc prüfen" "Verfügbarkeit mit curl prüfen" "Whois-Informationen" "Netzwerkverbindungszustand mit ss" "DNS-Informationen mit dig" "nmap-Scan" "Beenden")

    select choice in "${options[@]}"; do
        case $choice in
            "Netzwerkinformationen")
                zeige_netzwerkinformationen
                ;;
            "Ping-Test")
                ping_test
                ;;
            "Netzstatistik")
                netstat_info
                ;;
            "Traceroute")
                traceroute_info
                ;;
            "Verfügbarkeit mit nc prüfen")
                pruefe_dienst_nc
                ;;
            "Verfügbarkeit mit curl prüfen")
                pruefe_dienst_curl
                ;;
            "Whois-Informationen")
                whois_info
                ;;
            "Netzwerkverbindungszustand mit ss")
                ss_info
                ;;
            "DNS-Informationen mit dig")
                dig_info
                ;;
            "nmap-Scan")
                nmap_scan
                ;;
            "Beenden")
                echo "Skript wird beendet."
                exit 0
                ;;
            *)
                echo "Ungültige Option. Bitte erneut wählen."
                ;;
        esac
    done
}

# Hauptfunktion für das Auswahlmenü mit dialog
dialog_main_menu() {
    while true; do
        choice=$(dialog --clear --backtitle "Netzwerküberwachung" --menu "Wähle eine Option:" 25 50 10 \
            1 "Netzwerkinformationen" \
            2 "Ping-Test" \
            3 "Netzstatistik" \
            4 "Traceroute" \
            5 "Verfügbarkeit mit nc prüfen" \
            6 "Verfügbarkeit mit curl prüfen" \
            7 "Whois-Informationen" \
            8 "Netzwerkverbindungszustand mit ss" \
            9 "DNS-Informationen mit dig" \
            10 "nmap-Scan" \
            11 "Beenden" 3>&1 1>&2 2>&3)

            # Cancel abfrage
            antwort=$?; if [[ $antwort = 1 ]]; then exit 0; fi
        
        case $choice in
            1)
                zeige_netzwerkinformationen
                echo "Drücke Enter, um fortzufahren..."
                read -r
                ;;
            2)
                ping_test
                echo "Drücke Enter, um fortzufahren..."
                read -r
                ;;
            3)
                netstat_info
                echo "Drücke Enter, um fortzufahren..."
                read -r
                ;;
            4)
                traceroute_info
                echo "Drücke Enter, um fortzufahren..."
                read -r
                ;;
            5)
                pruefe_dienst_nc
                echo "Drücke Enter, um fortzufahren..."
                read -r
                ;;
            6)
                pruefe_dienst_curl
                echo "Drücke Enter, um fortzufahren..."
                read -r
                ;;
            7)
                whois_info
                echo "Drücke Enter, um fortzufahren..."
                read -r
                ;;
            8)
                ss_info
                echo "Drücke Enter, um fortzufahren..."
                read -r
                ;;
            9)
                dig_info
                echo "Drücke Enter, um fortzufahren..."
                read -r
                ;;
            10)
                nmap_scan
                echo "Drücke Enter, um fortzufahren..."
                read -r
                ;;
            11)
                clear
                echo "Skript wird beendet."
                exit 0
                ;;
            *)
                clear
                echo "Ungültige Option. Bitte erneut wählen."
                ;;
        esac
    done
}

# Ausführung des Hauptteils des Skripts mit oder ohne dialog.
if command -v dialog >/dev/null 2>&1; then
    dialog_main_menu
else
    main_menu
fi
