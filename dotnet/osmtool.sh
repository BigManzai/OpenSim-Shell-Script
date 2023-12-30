#!/bin/bash

#──────────────────────────────────────────────────────────────────────────────────────────
#* Informationen
#──────────────────────────────────────────────────────────────────────────────────────────
#
	# ? opensimMULTITOOL Copyright (c) 2021 2023 BigManzai Manfred Zainhofer
	# osmtool.sh Basiert auf meinen Einzelscripten, für den OpenSimulator (OpenSim) von http://opensimulator.org an denen ich bereits 7 Jahre Arbeite und verbessere.
	# Da Server unterschiedlich sind, kann eine einwandfreie fuunktion nicht gewaehrleistet werden, also bitte mit bedacht verwenden.
	# Die Benutzung dieses Scriptes, oder deren Bestandteile, erfolgt auf eigene Gefahr!!!
	# Erstellt und getestet ist osmtool.sh, auf verschiedenen Ubuntu 18.04, 20.04 und 22.04 Servern, unter verschiedenen Server Anbietern (Contabo, Hetzner ...).
	#
	# ? Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal
	# in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	# copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
	#
	# ? The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
	#
	# ! THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	# ! FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	# ! LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
	#
	# * Letzte bearbeitung 30.12.2023.
	#
	# # Installieren sie bitte: #* Visual Studio Code
	#* dazu die Plugins:
	# ShellCheck #! ist eine geniale Hilfe gegen Fehler.
	# shellman #? Shell Skript Schnipsel.
	# Better Comments #* Bessere Farbliche Darstellung. Standards: #! #* #? #// #todo
	# outline map #? Navigationsleiste für Funktionen.
	# todo: eine Menge warten wir´s ab.
#

#──────────────────────────────────────────────────────────────────────────────────────────
#* Konfiguration opensimMULTITOOL
#──────────────────────────────────────────────────────────────────────────────────────────

SCRIPTNAME="opensimMULTITOOL" # opensimMULTITOOL Versionsausgabe.
VERSION="V0.9.3.0.1437" # opensimMULTITOOL Versionsausgabe angepasst an OpenSim.
tput reset # Bildschirmausgabe loeschen inklusive dem Scrollbereich.

#──────────────────────────────────────────────────────────────────────────────────────────
#* Admin Funktionen
#──────────────────────────────────────────────────────────────────────────────────────────

## * password_prompt
	# Funktion: Passwortabfrage mit Beendigung bei falscher Eingabe
	# Datum: 13.11.2023
	# Beschreibung:
	# Diese Funktion fordert den Benutzer zur Eingabe eines Passworts auf und beendet das Skript, wenn das eingegebene Passwort nicht korrekt ist.
	#? Parameter:
	#   - Keine festen Parameter.
	#? Funktionsverhalten:
	#   - Definiert das erwartete Passwort.
	#   - Fordert den Benutzer zur Eingabe des Passworts auf (ohne Anzeige der Eingabe).
	#   - Überprüft, ob das eingegebene Passwort korrekt ist.
	#   - Gibt eine Fehlermeldung aus und beendet das Skript bei falschem Passwort.
	#   - Gibt eine Bestätigung aus und ermöglicht die Ausführung des Skriptcodes nach erfolgreicher Passwortprüfung.
	#? Beispielaufruf:
	#   Die Funktion wird verwendet, um den Benutzer nach einem Passwort zu fragen.
	#   Beispiel: password_prompt
	#? Rückgabewert:
	#   - Beendet das Skript mit Exit-Code 1 bei falschem Passwort.
	#   - Ermöglicht die Ausführung des nachfolgenden Skriptcodes bei korrektem Passwort.
	#? Hinweise:
	#   - Ersetzen Sie "IhrErwartetesPasswort" durch das tatsächliche erwartete Passwort.
	#   - Dies ist eine allgemeine Passwortabfrage und sollte nicht für sicherheitskritische Anwendungen verwendet werden.
##
function password_prompt() {
    # Definieren Sie das erwartete Passwort
    expected_password="IhrErwartetesPasswort"

    # Passwort abfragen
    echo -n "Bitte geben Sie das Passwort ein: "
    read -s entered_password  # -s für die Eingabe ohne Anzeige

    # Überprüfen, ob das eingegebene Passwort korrekt ist
    if [ "$entered_password" != "$expected_password" ]; then
        echo -e "\nFalsches Passwort. Das Skript wird beendet."
        exit 1
    else
        echo -e "\nPasswort korrekt. Das Skript wird fortgesetzt."
        # Hier können Sie den eigentlichen Code des Skripts einfügen, der nach der Passwortprüfung ausgeführt wird.
    fi
}

## * isroot
	#? Beschreibung:
	# Diese Funktion überprüft, ob der aktuelle Benutzer root-Rechte (Administratorrechte) hat.
	# Sie vergleicht den effektiven Benutzer (EUID) mit 0, wobei 0 normalerweise auf den root-Benutzer hinweist.
	# Wenn der Benutzer keine root-Rechte hat, wird eine Meldung ausgegeben und die Funktion gibt den Wert 1 zurück.
	# Andernfalls wird eine Bestätigungsmeldung ausgegeben und die Funktion gibt den Wert 0 zurück.
	#? Parameter:
	# Diese Funktion erwartet keine Parameter.
	#? Rückgabewert:
	# - Erfolgreich: Wenn der Benutzer root-Rechte hat, gibt die Funktion den Wert 0 zurück.
	# - Fehler: Wenn der Benutzer keine root-Rechte hat, gibt die Funktion den Wert 1 zurück.
	#? Beispielaufruf:
	# isroot
##
function isroot() {
	# Letzte Bearbeitung 30.09.2023
	if [ "$EUID" -ne 0 ]; then
		echo "Sie haben keine root Rechte!" >&2
		return 1
	else 
		echo "Sie haben root Rechte!"
		return 0
	fi
}

## *  benutzer
	# Diese Funktion überprüft, ob der aktuelle Benutzer mit dem angegebenen
	# Benutzernamen übereinstimmt und ob der aktuelle Benutzer mit dem
	# Anmeldebenutzernamen übereinstimmt. Wenn die Bedingungen erfüllt sind,
	# wird eine Erfolgsmeldung angezeigt, andernfalls wird eine Fehlermeldung
	# ausgegeben, und das Skript wird beendet.
	#? @param Keine Parameter erforderlich.
	#? @return    0 - Erfolg: Der aktuelle Benutzer stimmt mit dem angegebenen Benutzernamen
	#? @return        überein, und der Anmeldebenutzername stimmt ebenfalls überein.
	#? @return    1 - Fehler: Der aktuelle Benutzer stimmt nicht mit dem angegebenen
	#? @return        Benutzernamen überein oder der Anmeldebenutzername ist nicht gleich
	#? @return        dem aktuellen Benutzer.
	# todo: nichts.
##
function benutzer() {
	# Letzte Bearbeitung 26.09.2023
    # Benutzername abfragen
    log rohtext "Benutzername:"
    read -r BBENUTZER

    # Überprüfen, ob der aktuelle Benutzer mit dem angegebenen Benutzernamen
    # übereinstimmt und ob der Anmeldebenutzername gleich dem aktuellen Benutzer ist
    if [ "$USER" = "$BBENUTZER" ] && [ "$USER" = "$LOGNAME" ]; then
        echo "Sie haben das Recht, das osmtool.sh zu nutzen!"
        return 0
    else
        echo "Sie haben kein Recht, das osmtool.sh zu nutzen!"
        exit 1
    fi
}

#──────────────────────────────────────────────────────────────────────────────────────────
#* Tests
#──────────────────────────────────────────────────────────────────────────────────────────

## * Funktion: dotnetubu18
#! Diese Funktion erleichtert die Installation von .NET SDK und Runtime auf einem System mit Ubuntu 18.04.
# Die Funktion führt die folgenden Schritte aus:
#? 1. **Hinzufügen des Microsoft-Paket-Repositories:**
#    - Das Deb-Paket wird von der Microsoft-Website heruntergeladen.
#    - Bei einem Downloadfehler wird eine Fehlermeldung ausgegeben, und die Funktion gibt 1 zurück.
#    - Das Deb-Paket wird installiert.
#? 2. **Installation des .NET SDK:**
#    - Das .NET SDK wird über die Paketverwaltung installiert.
#    - Bei einem Installationsfehler wird eine Fehlermeldung ausgegeben, und die Funktion gibt 1 zurück.
#? 3. **Abfrage des Benutzers bezüglich ASP.NET:**
#    - Der Benutzer wird gefragt, ob er ASP.NET installieren möchte.
#? 4. **Installation des .NET Runtimes:**
#    - Abhängig von der Benutzerantwort wird das Runtime-Paket mit oder ohne ASP.NET installiert.
#    - Bei einem Installationsfehler wird eine Fehlermeldung ausgegeben, und die Funktion gibt 1 zurück.
#? Verwendung:
# bash osmtool.sh dotnetubu18
# todo: Testen.
##
function dotnetubu18() {
    # Microsoft-Paket-Repository hinzufügen.
    wget https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
    if [ $? -ne 0 ]; then
        echo "Fehler beim Herunterladen des Microsoft-Paket-Repository-Deb-Pakets."
        return 1
    fi

    sudo dpkg -i packages-microsoft-prod.deb
    if [ $? -ne 0 ]; then
        echo "Fehler beim Installieren des Microsoft-Paket-Repository-Deb-Pakets."
        return 1
    fi
    rm packages-microsoft-prod.deb

    # Frage den Benutzer nach der Version von .NET SDK
    echo "Möchten Sie DOTNET 6 oder DOTNET 7 installieren? (6/7): "
    read -r dotnetVersion
	if [ "$dotnetVersion" = "" ]; then dotnetVersion="6"; fi
    case $dotnetVersion in
        6)
            sdkPackage="dotnet-sdk-6.0"
            ;;
        7)
            sdkPackage="dotnet-sdk-7.0"
            ;;
        *)
            echo "Ungültige Auswahl. Bitte wählen Sie 6 oder 7."
            return 1
            ;;
    esac

    # Frage den Benutzer nach der Installation von ASP.NET
    echo "Möchten Sie $dotnetVersion mit ASP.NET installieren? (j/n): "
    read -r installAspNet
    case $installAspNet in
        [jJyY])
            runtimePackage="aspnetcore-runtime-$dotnetVersion.0"
            ;;
        *)
            runtimePackage="dotnet-runtime-$dotnetVersion.0"
            ;;
    esac

    # Installation des SDK
    sudo apt-get update && sudo apt-get install -y $sdkPackage
    if [ $? -ne 0 ]; then
        echo "Fehler beim Installieren des .NET SDK."
        return 1
    fi

    # Installation des Runtimes
    sudo apt-get update && sudo apt-get install -y $runtimePackage
    if [ $? -ne 0 ]; then
        echo "Fehler beim Installieren des .NET Runtimes."
        return 1
    fi

	apt install -y libgdiplus
	apt install -y zlib1g-dev

    echo ".NET SDK und Runtime wurden erfolgreich installiert."
}

## * Funktion: dotnetubu20
#! Diese Funktion erleichtert die Installation von .NET SDK und Runtime auf einem System mit Ubuntu 20.04.
# Die Funktion führt die folgenden Schritte aus:
#? 1. **Hinzufügen des Microsoft-Paket-Repositories:**
#    - Das Deb-Paket wird von der Microsoft-Website heruntergeladen.
#    - Bei einem Downloadfehler wird eine Fehlermeldung ausgegeben, und die Funktion gibt 1 zurück.
#    - Das Deb-Paket wird installiert.
#? 2. **Installation des .NET SDK:**
#    - Das .NET SDK wird über die Paketverwaltung installiert.
#    - Bei einem Installationsfehler wird eine Fehlermeldung ausgegeben, und die Funktion gibt 1 zurück.
#? 3. **Abfrage des Benutzers bezüglich ASP.NET:**
#    - Der Benutzer wird gefragt, ob er ASP.NET installieren möchte.
#? 4. **Installation des .NET Runtimes:**
#    - Abhängig von der Benutzerantwort wird das Runtime-Paket mit oder ohne ASP.NET installiert.
#    - Bei einem Installationsfehler wird eine Fehlermeldung ausgegeben, und die Funktion gibt 1 zurück.
#? Verwendung:
# bash osmtool.sh dotnetubu20
# todo: Testen.
##
function dotnetubu20() {
    # Microsoft-Paket-Repository hinzufügen.
    wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
    if [ $? -ne 0 ]; then
        echo "Fehler beim Herunterladen des Microsoft-Paket-Repository-Deb-Pakets."
        return 1
    fi

    sudo dpkg -i packages-microsoft-prod.deb
    if [ $? -ne 0 ]; then
        echo "Fehler beim Installieren des Microsoft-Paket-Repository-Deb-Pakets."
        return 1
    fi
    rm packages-microsoft-prod.deb

    # Frage den Benutzer nach der Version von .NET SDK
    echo "Möchten Sie DOTNET 6 oder DOTNET 7 oder DOTNET 8 installieren? (6/7/8): "
    read -r dotnetVersion
	if [ "$dotnetVersion" = "" ]; then dotnetVersion="6"; fi
    case $dotnetVersion in
        6)
            sdkPackage="dotnet-sdk-6.0"
            ;;
        7)
            sdkPackage="dotnet-sdk-7.0"
            ;;
		8)
			sdkPackage="dotnet-sdk-8.0"
			;;
        *)
            echo "Ungültige Auswahl. Bitte wählen Sie 6 oder 7."
            return 1
            ;;
    esac

    # Frage den Benutzer nach der Installation von ASP.NET
    echo "Möchten Sie $dotnetVersion mit ASP.NET installieren? (j/n): "
    read -r installAspNet
    case $installAspNet in
        [jJyY])
            runtimePackage="aspnetcore-runtime-$dotnetVersion.0"
            ;;
        *)
            runtimePackage="dotnet-runtime-$dotnetVersion.0"
            ;;
    esac

    # Installation des SDK
    sudo apt-get update && sudo apt-get install -y $sdkPackage
    if [ $? -ne 0 ]; then
        echo "Fehler beim Installieren des .NET SDK."
        return 1
    fi

    # Installation des Runtimes
    sudo apt-get update && sudo apt-get install -y $runtimePackage
    if [ $? -ne 0 ]; then
        echo "Fehler beim Installieren des .NET Runtimes."
        return 1
    fi

    echo ".NET SDK und Runtime wurden erfolgreich installiert."
}

## * Funktion: dotnetubu22
#! Diese Funktion erleichtert die Installation von .NET SDK und Runtime auf einem System mit Ubuntu 22.04.
# Die Funktion führt die folgenden Schritte aus:
#? 1. **Hinzufügen des Microsoft-Paket-Repositories:**
#    - Das Deb-Paket wird von der Microsoft-Website heruntergeladen.
#    - Bei einem Downloadfehler wird eine Fehlermeldung ausgegeben, und die Funktion gibt 1 zurück.
#    - Das Deb-Paket wird installiert.
#? 2. **Installation des .NET SDK:**
#    - Das .NET SDK wird über die Paketverwaltung installiert.
#    - Bei einem Installationsfehler wird eine Fehlermeldung ausgegeben, und die Funktion gibt 1 zurück.
#? 3. **Abfrage des Benutzers bezüglich ASP.NET:**
#    - Der Benutzer wird gefragt, ob er ASP.NET installieren möchte.
#? 4. **Installation des .NET Runtimes:**
#    - Abhängig von der Benutzerantwort wird das Runtime-Paket mit oder ohne ASP.NET installiert.
#    - Bei einem Installationsfehler wird eine Fehlermeldung ausgegeben, und die Funktion gibt 1 zurück.
#? Verwendung:
# bash osmtool.sh dotnetubu18
# todo: Testen.
##
function dotnetubu22() {
    # Frage den Benutzer nach der Version von .NET SDK
    echo "Möchten Sie DOTNET 6 oder DOTNET 7 oder DOTNET 8 installieren? (6/7/8): "
    read -r dotnetVersion
	if [ "$dotnetVersion" = "" ]; then dotnetVersion="6"; fi
    case $dotnetVersion in
        6)
            sdkPackage="dotnet-sdk-6.0"
            ;;
        7)
            sdkPackage="dotnet-sdk-7.0"
            ;;
		8)
			sdkPackage="dotnet-sdk-8.0"
			;;
        *)
            echo "Ungültige Auswahl. Bitte wählen Sie 6 oder 7."
            return 1
            ;;
    esac

    # Frage den Benutzer nach der Installation von ASP.NET
    echo "Möchten Sie $dotnetVersion mit ASP.NET installieren? (j/n): "
    read -r installAspNet
    case $installAspNet in
        [jJyY])
            runtimePackage="aspnetcore-runtime-$dotnetVersion.0"
            ;;
        *)
            runtimePackage="dotnet-runtime-$dotnetVersion.0"
            ;;
    esac

    # Installation des SDK
    sudo apt-get update && sudo apt-get install -y $sdkPackage
    if [ $? -ne 0 ]; then
        echo "Fehler beim Installieren des .NET SDK."
        return 1
    fi

    # Installation des Runtimes
    sudo apt-get update && sudo apt-get install -y $runtimePackage
    if [ $? -ne 0 ]; then
        echo "Fehler beim Installieren des .NET Runtimes."
        return 1
    fi

    echo ".NET SDK und Runtime wurden erfolgreich installiert."
}

## * uninstall_mono
#? Die folgende Funktion, uninstall_mono, deinstalliert das Mono-Framework auf einem Linux-Server.
# Sie wurde für Debian-basierte Systeme wie Ubuntu entwickelt.
# Stelle sicher, dass du Administratorrechte hast, um diese Funktion auszuführen.
# Führe sie aus, indem du das Skript als Root oder mit sudo-Berechtigungen startest.
# Beachte, dass diese Funktion Mono-Pakete entfernt und Autoremove verwendet, um unnötige Abhängigkeiten zu bereinigen.
# Andere Linux-Distributionen können eine Anpassung der Paketverwaltung erfordern (z.B., yum für CentOS/RHEL).
# todo: Testen.
##
function uninstall_mono() {
    # Deinstallieren von Mono auf Debian-basierten Systemen
    if command -v apt-get &> /dev/null; then
        echo "Deinstalliere Mono auf Debian-basiertem System..."

        # Pakete entfernen
        apt-get remove --purge -y mono-runtime mono-devel mono-complete

        # Autoremove, um unnötige Abhängigkeiten zu entfernen
        apt-get autoremove -y

        echo "Mono wurde deinstalliert."

    # Füge hier weitere Distributionen hinzu, falls notwendig
    else
        echo "Deine Linux-Distribution wird nicht unterstützt oder erkannt."
        return 1
    fi
}

## * check_admin
	#? Beschreibung:
	# Überprüft, ob der Benutzer Root-Rechte hat. Beendet das Skript mit einem Fehler, falls nicht.
	#? Parameter:
	#   - Keine festen Parameter.
	#? Funktionsverhalten:
	#   - Überprüft, ob der Benutzer Root-Rechte hat.
	#   - Beendet das Skript mit einer Fehlermeldung, falls nicht.
	#? Beispielaufruf:
	#   Die Funktion wird zu Beginn eines Skripts aufgerufen, um sicherzustellen, dass es mit Root-Rechten ausgeführt wird.
	#   Beispiel: check_admin
	#? Rückgabewert:
	#   - Beendet das Skript mit einem Fehler, falls der Benutzer keine Root-Rechte hat.
##
function check_admin() {
    # Überprüfen, ob der Benutzer Root-Rechte hat
    if [ "$(id -u)" != "0" ]; then
        echo "Error: This script must be run as root."
        exit 1
    fi
}

## * admin_only_function
	#? Beschreibung:
	# Gibt eine Meldung aus, dass diese Funktion Administratorrechte erfordert. Der eigentliche Code der Funktion sollte hier eingefügt werden.
	#? Parameter:
	#   - Keine festen Parameter.
	#? Funktionsverhalten:
	#   - Gibt eine Meldung aus, dass diese Funktion Administratorrechte erfordert.
	#   - Der eigentliche Code der Funktion sollte hier eingefügt werden.
	#? Beispielaufruf:
	#   Diese Funktion wird von anderen Funktionen verwendet, die Administratorrechte benötigen.
	#   Beispiel: admin_only_function
	#? Rückgabewert:
	#   - Kein spezifischer Rückgabewert.
##
function admin_only_function() {
    echo "This function requires administrator privileges."
    # Hier können Sie den eigentlichen Code der Funktion einfügen
}

## * check_non_admin
	#? Beschreibung:
	# Überprüft, ob der Benutzer keine Root-Rechte hat. Beendet das Skript mit einem Fehler, falls doch.
	#? Parameter:
	#   - Keine festen Parameter.
	#? Funktionsverhalten:
	#   - Überprüft, ob der Benutzer keine Root-Rechte hat.
	#   - Beendet das Skript mit einer Fehlermeldung, falls doch.
	#? Beispielaufruf:
	#   Die Funktion wird verwendet, um sicherzustellen, dass das Skript nicht mit Root-Rechten ausgeführt wird.
	#   Beispiel: check_non_admin
	#? Rückgabewert:
	#   - Beendet das Skript mit einem Fehler, falls der Benutzer Root-Rechte hat.
##
function check_non_admin() {
    # Überprüfen, ob der Benutzer nicht Root-Rechte hat
    if [ "$(id -u)" == "0" ]; then
        echo "Error: This script must not be run as root."
        exit 1
    fi
}

## * non_admin_only_function
	#? Beschreibung:
	# Gibt eine Meldung aus, dass diese Funktion keine Administratorrechte erfordert. Der eigentliche Code der Funktion sollte hier eingefügt werden.
	#? Parameter:
	#   - Keine festen Parameter.
	#? Funktionsverhalten:
	#   - Gibt eine Meldung aus, dass diese Funktion keine Administratorrechte erfordert.
	#   - Der eigentliche Code der Funktion sollte hier eingefügt werden.
	#? Beispielaufruf:
	#   Diese Funktion wird von anderen Funktionen verwendet, die keine Administratorrechte benötigen.
	#   Beispiel: non_admin_only_function
	#? Rückgabewert:
	#   - Kein spezifischer Rückgabewert.
##
function non_admin_only_function() {
    echo "This function does not require administrator privileges."
    # Hier können Sie den eigentlichen Code der Funktion einfügen
}

## * check_user
	#? Beschreibung:
	# Überprüft, ob der aktuelle Benutzer dem erwarteten Benutzer entspricht. Beendet das Skript mit einem Fehler, falls nicht.
	#? Parameter:
	#   - Keine festen Parameter.
	#? Funktionsverhalten:
	#   - Überprüft, ob der aktuelle Benutzer dem erwarteten Benutzer entspricht.
	#   - Beendet das Skript mit einer Fehlermeldung, falls nicht.
	#? Beispielaufruf:
	#   Die Funktion wird verwendet, um sicherzustellen, dass das Skript von einem bestimmten Benutzer ausgeführt wird.
	#   Beispiel: check_user
	#? Rückgabewert:
	#   - Beendet das Skript mit einem Fehler, falls der Benutzer nicht dem erwarteten Benutzer entspricht.
##
function check_user() {
    expected_user="your_expected_user"

    # Überprüfen, ob der aktuelle Benutzer dem erwarteten Benutzer entspricht
    if [ "$(whoami)" != "$expected_user" ]; then
        echo "Error: This script must be run by $expected_user."
        exit 1
    fi
}

## * specific_user_function
	#? Beschreibung:
	# Gibt eine Meldung aus, dass diese Funktion nur von einem bestimmten Benutzer ausgeführt werden sollte. Der eigentliche Code der Funktion sollte hier eingefügt werden.
	#? Parameter:
	#   - Keine festen Parameter.
	#? Funktionsverhalten:
	#   - Gibt eine Meldung aus, dass diese Funktion nur von einem bestimmten Benutzer ausgeführt werden sollte.
	#   - Der eigentliche Code der Funktion sollte hier eingefügt werden.
	#? Beispielaufruf:
	#   Diese Funktion wird von anderen Funktionen verwendet, die nur von einem bestimmten Benutzer ausgeführt werden sollen.
	#   Beispiel: specific_user_function
	#? Rückgabewert:
	#   - Kein spezifischer Rückgabewert.
##
function specific_user_function() {
    echo "This function should only be executed by $expected_user."
    # Hier können Sie den eigentlichen Code der Funktion einfügen
}

## * update_and_restart
	#? Beschreibung:
	# Diese Funktion führt die Aktualisierung des Paket-Caches, das Upgrade der installierten Pakete und den Neustart des Servers durch.
	# Der Paket-Cache wird mit 'sudo apt update' aktualisiert, die installierten Pakete mit 'sudo apt upgrade -y' aktualisiert, und schließlich wird der Server mit 'sudo reboot' neu gestartet.
	# Beachten Sie, dass der Parameter '-y' verwendet wird, um automatisch mit "Ja" auf eventuelle Bestätigungsanfragen zu antworten.
	# Die Funktion gibt keine Rückmeldung über den Erfolg oder Fehler des Upgrades; dies muss separat überprüft werden.
	#? Parameter:
	# Diese Funktion erwartet keine Parameter.
	#? Rückgabewert:
	# - Erfolgreich: Die Funktion führt die Aktualisierung und das Upgrade durch und gibt keine explizite Rückmeldung.
	# - Fehler: Eventuelle Fehler während des Upgrades müssen separat überprüft werden.
	#? Beispielaufruf:
	# update_and_restart
##
function update_and_restart() {
  # Update des Paket-Caches
  sudo apt update

  # Upgrade der installierten Pakete
  sudo apt upgrade -y
  
  # Server neu starten
  sudo reboot
}

## * update_clean
	#? Beschreibung:
	# Diese Funktion führt die Bereinigung nicht mehr benötigter Paketabhängigkeiten und das Löschen der heruntergeladenen Paket-Caches durch.
	# Die Bereinigung erfolgt mit 'sudo apt autoremove -y', um nicht mehr benötigte Paketabhängigkeiten zu entfernen, und das Löschen der heruntergeladenen Paket-Caches mit 'sudo apt clean'.
	# Der Parameter '-y' wird verwendet, um automatisch mit "Ja" auf eventuelle Bestätigungsanfragen zu antworten.
	# Die Funktion gibt keine Rückmeldung über den Erfolg oder Fehler der Bereinigung; dies muss separat überprüft werden.
	#? Parameter:
	# Diese Funktion erwartet keine Parameter.
	#? Rückgabewert:
	# - Erfolgreich: Die Funktion führt die Bereinigung durch und gibt keine explizite Rückmeldung.
	# - Fehler: Eventuelle Fehler während der Bereinigung müssen separat überprüft werden.
	#? Beispielaufruf:
	# update_clean
##
function update_clean() {
  # Bereinigung von nicht mehr benötigten Paketabhängigkeiten
  sudo apt autoremove -y

  # Löschen der heruntergeladenen Paket-Caches
  sudo apt clean
}

# Globale Variablen:
# Beispiel für eine Ziel-IP-Adresse
#ziel_ip="127.0.0.1"
ziel_ip=${AKTUELLEIP}
# Beispiel für einen externen Dienst
externer_dienst="www.google.com"

## * zeige_netzwerkinformationen
	#? Beschreibung:
	# Diese Funktion zeigt umfassende Netzwerkinformationen an, einschließlich IP-Adressen, Netzwerkverbindungszuständen, Netzwerkschnittstelleninformationen, Routinginformationen und DNS-Namenauflösung für eine Ziel-IP-Adresse.
	# Der Benutzer wird aufgefordert, eine Ziel-IP-Adresse einzugeben, und die Informationen werden dann angezeigt.
	#? Parameter:
	# Diese Funktion erwartet keine Parameter.
	#? Rückgabewert:
	# Die Funktion gibt keine explizite Rückmeldung über den Erfolg oder Fehler. Überprüfen Sie die ausgegebenen Informationen.
	#? Beispielaufruf:
	# zeige_netzwerkinformationen
##
function zeige_netzwerkinformationen() {
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

## * ping_test
	#? Beschreibung:
	# Diese Funktion führt einen Ping-Test zu einer Ziel-IP-Adresse durch.
	# Der Benutzer wird aufgefordert, eine Ziel-IP-Adresse einzugeben, und der Ping-Test wird dann durchgeführt.
	#? Parameter:
	# Diese Funktion erwartet keine Parameter.
	#? Rückgabewert:
	# Die Funktion gibt keine explizite Rückmeldung über den Erfolg oder Fehler. Überprüfen Sie die ausgegebenen Ping-Ergebnisse.
	#? Beispielaufruf:
	# ping_test
##
function ping_test() {
    # Abfrage der IP-Adresse
    echo "Geben sie eine Ziel IP Adresse an:[$ziel_ip]"
    read -r ziel_ip

    echo "### Ping-Test ###"
    ping -c 4 "$ziel_ip"
}

## * netstat_info
	#? Beschreibung:
	# Diese Funktion zeigt Netzstatistiken an, einschließlich detaillierter Informationen über Netzwerkverbindungen.
	# Überprüft zuerst, ob netstat installiert ist. Wenn nicht, wird der Benutzer gefragt, ob netstat installiert werden soll.
	# Bei Zustimmung wird netstat installiert und die Statistiken werden angezeigt.
	#? Parameter:
	# Diese Funktion erwartet keine Parameter.
	#? Rückgabewert:
	# Die Funktion gibt keine explizite Rückmeldung über den Erfolg oder Fehler. Überprüfen Sie die ausgegebenen Statistiken.
	#? Beispielaufruf:
	# netstat_info
##
function netstat_info() {
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

## * traceroute_info
	#? Beschreibung:
	# Diese Funktion führt einen Traceroute zu einer Ziel-IP-Adresse durch.
	# Überprüft zuerst, ob traceroute installiert ist. Wenn nicht, wird der Benutzer gefragt, ob traceroute installiert werden soll.
	# Bei Zustimmung wird traceroute installiert und der Traceroute wird durchgeführt.
	# Der Benutzer wird aufgefordert, eine Ziel-IP-Adresse einzugeben, und der Traceroute wird dann angezeigt.
	#? Parameter:
	# Diese Funktion erwartet keine Parameter.
	#? Rückgabewert:
	# Die Funktion gibt keine explizite Rückmeldung über den Erfolg oder Fehler. Überprüfen Sie die ausgegebenen Traceroute-Ergebnisse.
	#? Beispielaufruf:
	# traceroute_info
##
function traceroute_info() {
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

## * pruefe_dienst_nc
	#? Beschreibung:
	# Diese Funktion überprüft die Verfügbarkeit eines externen Dienstes unter Verwendung von 'nc' (Netcat).
	# Der Benutzer wird aufgefordert, die IP-Adresse oder den Hostnamen des externen Dienstes einzugeben.
	# Die Verfügbarkeit des Dienstes wird durch einen Verbindungsversuch auf Port 80 überprüft.
	#? Parameter:
	# Diese Funktion erwartet keine Parameter.
	#? Rückgabewert:
	# Die Funktion gibt eine Meldung zur Verfügbarkeit des Dienstes aus.
	#? Beispielaufruf:
	# pruefe_dienst_nc
##
function pruefe_dienst_nc() {
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

## * pruefe_dienst_curl
	#? Beschreibung:
	# Diese Funktion überprüft die Verfügbarkeit eines externen Dienstes unter Verwendung von 'curl'.
	# Der Benutzer wird aufgefordert, die IP-Adresse oder den Hostnamen des externen Dienstes einzugeben.
	# Die Verfügbarkeit des Dienstes wird durch einen HTTP-HEAD-Request auf Port 80 überprüft.
	#? Parameter:
	# Diese Funktion erwartet keine Parameter.
	#? Rückgabewert:
	# Die Funktion gibt eine Meldung zur Verfügbarkeit des Dienstes aus.
	#? Beispielaufruf:
	# pruefe_dienst_curl
##
function pruefe_dienst_curl() {
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

## * whois_info
	#? Beschreibung:
	# Diese Funktion zeigt Whois-Informationen für eine Ziel-IP-Adresse an.
	# Der Benutzer wird aufgefordert, eine Ziel-IP-Adresse einzugeben, und die Whois-Informationen werden dann angezeigt.
	#? Parameter:
	# Diese Funktion erwartet keine Parameter.
	#? Rückgabewert:
	# Die Funktion gibt keine explizite Rückmeldung über den Erfolg oder Fehler. Überprüfen Sie die ausgegebenen Whois-Informationen.
	#? Beispielaufruf:
	# whois_info
##
function whois_info() {
    # Abfrage der IP-Adresse
    echo "Geben sie eine Ziel IP Adresse an:[$ziel_ip]"
    read -r ziel_ip

    echo "### Whois-Informationen für $ziel_ip ###"
    whois "$ziel_ip"
}

## * netz_ss_info
	#? Beschreibung:
	# Diese Funktion zeigt den Netzwerkverbindungszustand mit 'ss' an.
	#? Parameter:
	# Diese Funktion erwartet keine Parameter.
	#? Rückgabewert:
	# Die Funktion gibt keine explizite Rückmeldung über den Erfolg oder Fehler. Überprüfen Sie die ausgegebenen Informationen.
	#? Beispielaufruf:
	# ss_info
##
function netz_ss_info() {
    echo "### Netzwerkverbindungszustand mit ss ###"
    ss -tulwn
}

## * dns_dig_info
	#? Beschreibung:
	# Diese Funktion zeigt DNS-Informationen für eine Ziel-IP-Adresse mit 'dig' an.
	# Der Benutzer wird aufgefordert, eine Ziel-IP-Adresse einzugeben, und die DNS-Informationen werden dann angezeigt.
	#? Parameter:
	# Diese Funktion erwartet keine Parameter.
	#? Rückgabewert:
	# Die Funktion gibt keine explizite Rückmeldung über den Erfolg oder Fehler. Überprüfen Sie die ausgegebenen DNS-Informationen.
	#? Beispielaufruf:
	# dig_info
##
function dns_dig_info() {
    # Abfrage der IP-Adresse
    echo "Geben sie eine Ziel IP Adresse an:[$ziel_ip]"
    read -r ziel_ip

    echo "### DNS-Informationen für $ziel_ip ###"
    dig "$ziel_ip"
}

## * nmap_scan
	#? Beschreibung:
	# Diese Funktion führt einen nmap-Scan zu einer Ziel-IP-Adresse durch.
	# Überprüft zuerst, ob nmap installiert ist. Wenn nicht, wird der Benutzer gefragt, ob nmap installiert werden soll.
	# Bei Zustimmung wird nmap installiert und der nmap-Scan wird durchgeführt.
	# Der Benutzer wird aufgefordert, eine Ziel-IP-Adresse einzugeben, und der nmap-Scan wird dann angezeigt.
	#? Parameter:
	# Diese Funktion erwartet keine Parameter.
	#? Rückgabewert:
	# Die Funktion gibt keine explizite Rückmeldung über den Erfolg oder Fehler. Überprüfen Sie die ausgegebenen nmap-Scan-Ergebnisse.
	#? Beispielaufruf:
	# nmap_scan
##
function nmap_scan() {
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

#──────────────────────────────────────────────────────────────────────────────────────────
#* Tests Ende
#──────────────────────────────────────────────────────────────────────────────────────────

## * osmexit
	# Datum: 13.11.2023
	#? Beschreibung:
	# Diese Funktion beendet das OSM-Programm. Sie löscht den Dialog, entfernt den blauen Hintergrund und gibt eine Abschlussmeldung aus. Anschließend wird das Programm beendet.
	#? Parameter:
	#   - Keine festen Parameter.
	#? Funktionsverhalten:
	#   - Löscht den Dialog.
	#   - Entfernt den blauen Hintergrund.
	#   - Gibt eine Abschlussmeldung ("OSM wurde beendet.") aus.
	#   - Beendet das Programm.
	#? Beispielaufruf:
	#   Die Funktion wird verwendet, um das OSM-Programm zu beenden.
	#   Beispiel: osmexit
	#? Rückgabewert:
	#   - Beendet das Programm.
	#? Hinweise:
	#   - Stellen Sie sicher, dass die Funktion in einem Kontext aufgerufen wird, in dem ein Beenden des Programms angemessen ist.
##
function osmexit() {
	# Hier wird der Dialog geloescht.
	dialogclear

	# Den Blauen hintergrud restlos entfernen.
	#echo -e ""; echo -e ""; echo -e ""; echo -e ""; echo -e ""; echo -e ""; echo -e ""; echo -e ""; echo -e ""; echo -e ""
	printf '\n%.0s' {1..10}

	# Hier wird der Bildschirm gelöscht.	
	tput clear

	# Text ausgabe.
	log info "OSM wurde beendet."

	# Beenden
	exit
}

## * osmupgrade
	# Diese Funktion überprüft, ob das OpenSim-Shell-Skript auf GitHub aktualisiert wurde
	# und lädt es bei Bedarf herunter. Sie vergleicht die aktuelle installierte Version
	# mit der neuesten verfügbaren Version in einem GitHub-Repository.
	#? @param keine.
	#? @return nichts wird zurueckgegeben.
	# todo: nichts.
##
function osmupgrade() {
	# Letzte Bearbeitung 26.09.2023
    # Definiert das Repository und die Dateinamen
    repo_url="https://raw.githubusercontent.com/BigManzai/OpenSim-Shell-Script/main/osmtool.sh"
    script_name="osmtool.sh"
	current_version="$VERSION" # Verwendet die Umgebungsvariable VERSION

    # Überprüft, ob das Skript lokal existiert
    if [ ! -f "$script_name" ]; then
        echo "Das Skript wird heruntergeladen..."
        wget "$repo_url" -O "$script_name"
    else
        echo "Das Skript ist bereits vorhanden"
    fi

    # Definiert die aktuelle und neueste Version
    current_version="$(grep -o 'VERSION=\"[0-9]\{1,\}\.[0-9]\{1,\}\.[0-9]\{1,\}\"' "$script_name" | head -1 | tr -d '\;"')"
    latest_version="$(curl -s "$repo_url" | grep -o 'VERSION=\"[0-9]\{1,\}\.[0-9]\{1,\}\.[0-9]\{1,\}\"' | head -1 | tr -d '\;"')"

    # Überprüft, ob das Skript auf GitHub aktualisiert wurde
    if dpkg --compare-versions "${current_version}" lt "${latest_version}"; then
        echo "Neue Version verfügbar. Aktualisierung..."
        wget -q "$repo_url" -O "$script_name"
        echo "Aktualisierung abgeschlossen. Version ${latest_version} installiert."
    else
        echo "Keine Updates verfügbar. Aktuelle Version: $VERSION"
    fi
}

## * vardel
	# Diese Funktion löscht eine Reihe von Umgebungsvariablen, die möglicherweise aus
	# vorherigen Sitzungen oder Skripten übrig geblieben sind, um sicherzustellen, dass
	# keine alten Werte beibehalten werden.
	#? @param keine.
	#? @return nichts wird zurueckgegeben.
	# todo: nichts.
##
function vardel() {
	# Letzte Bearbeitung 14.11.2023
    # Liste der zu löschenden Variablen
    local variables=(
        STARTVERZEICHNIS
        MONEYVERZEICHNIS
        ROBUSTVERZEICHNIS
        OPENSIMVERZEICHNIS
        SCRIPTSOURCE
        SCRIPTZIP
        MONEYSOURCE
        MONEYZIP
        REGIONSNAME
        REGIONSNAMEb
        REGIONSNAMEc
        REGIONSNAMEd
        VERZEICHNISSCREEN
        NUMMER
        WARTEZEIT
        STARTWARTEZEIT
        STOPWARTEZEIT
        MONEYWARTEZEIT
        NAME
        VERZEICHNIS
        PASSWORD
        DATEI
    )

    # Lösche alle aufgeführten Variablen
    for var in "${variables[@]}"; do
        if [ -n "${!var}" ]; then
            unset "$var"
            echo "Variable $var gelöscht."
        else
            echo "Variable $var nicht vorhanden."
        fi
    done

    return 0
}

## * vardelall
	# Diese Funktion geht alle definierten Variablen in der aktuellen Shell durch
	# und löscht sie mit unset.
	#? @param keine.
	#? @return nichts wird zurueckgegeben.
	# todo: nichts.
##
function vardelall1() {
	# Letzte Bearbeitung 26.09.2023
    # Verwende `set` mit `eval` und `unset`, um alle Variablen zu durchlaufen und zu löschen.
    for var in $(set | awk -F= '{print $1}'); do
        unset "$var"
    done
}
function vardelall() {
    # Letzte Bearbeitung 14.11.2023
    local prefix="MY_PREFIX_"  # Ändere dies zu dem Präfix, das deine Variablen haben

    # Verwende `set` mit `eval` und `unset`, um Variablen mit einem bestimmten Präfix zu löschen
    for var in $(set | grep "^$prefix" | awk -F= '{print $1}'); do
        unset "$var"
        echo "Variable $var gelöscht."
    done
}

#──────────────────────────────────────────────────────────────────────────────────────────
#* Konfiguration opensimMULTITOOL
#──────────────────────────────────────────────────────────────────────────────────────────
#? Beschreibung: Dies dient dazu, wichtige Konfigurationsinformationen für das OSM-Tool zu initialisieren.

# NEUERREGIONSNAME - Der Name der neuen Region
NEUERREGIONSNAME="Welcome"

# Alias zum Anzeigen der man-Seiten auf Deutsch
alias man="LANG=de_DE.UTF-8 man"

# Das aktuelle Verzeichnis speichern
AKTUELLEVERZ=$(pwd)

# Datumsvariablen
DATUM=$(date +%d.%m.%Y)
DATEIDATUM=$(date +%d_%m_%Y)
UHRZEIT=$(date +%H:%M:%S)

# Informationen zur Ubuntu-Version
myDescription=$(lsb_release -d) #? Beispiel: Description: Ubuntu 22.04 LTS
myRelease=$(lsb_release -r)     #? Beispiel: Release: 22.04
myCodename=$(lsb_release -sc)   #? Beispiel: jammy

# Extrahieren von Ubuntu-spezifischen Informationen
ubuntuDescription=$(cut -f2 <<<"$myDescription") #? Beispiel: Ubuntu 22.04 LTS
ubuntuRelease=$(cut -f2 <<<"$myRelease")         #? Beispiel: 22.04
ubuntuCodename=$(cut -f2 <<<"$myCodename")       #? Beispiel: jammy

# Informationen zur MySQL-Version
SQLVERSIONVOLL=$(mysqld --version)
SQLVERSION=$(echo "${SQLVERSIONVOLL:0:45}")

# Den Pfad des osmtool.sh Skriptes herausfinden
SCRIPTPATH=$(cd "$(dirname "$0")" && pwd)

# Die IP des Servers herausfinden
#SYSTEMIP='"'$(curl -s ifconfig.me)'"'
#****************************************************************

## *  osmtranslateinstall
	#? Beschreibung:
	# Diese Funktion installiert das Tool 'translate-shell', das für Übersetzungen in der Befehlszeile verwendet wird.
	# Sie überprüft zunächst, ob der Benutzer Root-Rechte hat, um 'apt' auszuführen. Wenn nicht, gibt sie eine Fehlermeldung aus und gibt den Wert 1 zurück.
	# Dann überprüft sie, ob 'translate-shell' bereits installiert ist, und gibt eine entsprechende Nachricht aus.
	# Wenn 'translate-shell' nicht installiert ist, führt die Funktion 'apt update' und 'apt install' aus, um 'translate-shell' zu installieren.
	# Sie überprüft den Erfolg der Installation und gibt eine entsprechende Nachricht aus.
	#? Parameter:
	# Diese Funktion erwartet keine Parameter.
	#? Rückgabewert:
	# - Erfolgreich: Wenn 'translate-shell' erfolgreich installiert wurde, gibt die Funktion den Wert 0 zurück.
	# - Fehler: Wenn der Benutzer keine Root-Rechte hat, 'translate-shell' bereits installiert ist oder die Installation fehlschlägt, gibt die Funktion den Wert 1 zurück.
	#? Beispielaufruf:
	# osmtranslateinstall
##
function osmtranslateinstall() {
	# Letzte Bearbeitung 30.09.2023
    echo "Ich installiere nun das Tool translate-shell."

    # Prüfen Sie, ob der Benutzer Root-Rechte hat, um 'apt' auszuführen.
    if [[ $EUID -ne 0 ]]; then
        echo "Diese Funktion erfordert Root-Rechte. Bitte führen Sie sie mit 'sudo' aus."
        return 1
    fi

    # Überprüfen, ob das 'translate-shell' bereits installiert ist.
    if dpkg -l | grep -q translate-shell; then
        echo "'translate-shell' ist bereits installiert."
        return 0
    fi

    # Installation von 'translate-shell' mit 'apt'.
    apt update
    apt install translate-shell -y

    # Überprüfen, ob die Installation erfolgreich war.
    if [ $? -eq 0 ]; then
        echo "'translate-shell' wurde erfolgreich installiert."
        return 0
    else
        echo "Die Installation von 'translate-shell' ist fehlgeschlagen. Bitte überprüfen Sie Ihre Internetverbindung und versuchen Sie es erneut."
        return 1
    fi
}

## * osmtranslate 
	# Übersetzt Text mithilfe des OSM Translator-Dienstes
	# Diese Funktion verwendet den OSM Translator, um Text aus einer
	# beliebigen Quellsprache in die Zielsprache zu übersetzen. Der OSM Translator-Dienst
	# muss für die Verwendung aktiviert sein.
	#? @param Parameter:
	#? @param   "Text zum Übersetzen" - Der Text, der übersetzt werden soll.
	#? @param Um den OSM Translator-Dienst zu aktivieren, setzen Sie die Umgebungsvariable OSMTRANSLATOR auf "ON".
	#? @param Wenn OSMTRANSLATOR auf "OFF" gesetzt ist, wird der Text nicht übersetzt.
	#? Beispiele:
	#?   OSMTRANSLATOR="ON"  # Aktiviert den OSM Translator-Dienst
	#?   osmtranslate "Hello, world!"  # Übersetzt den Text ins Ziel
	#?   echo $text  # Gibt die übersetzte Zeichenfolge aus
##
function osmtranslate() {
    OSMTRANSTEXT=$1
	if [ "$OSMTRANSLATOR" = "OFF" ]; then 
	text=$OSMTRANSTEXT; 
	return 0; 
	fi

	if [ "$OSMTRANSLATOR" = "ON" ]; then
    	text=$(trans -brief -no-warn $OSMTRANS "$OSMTRANSTEXT")
	else
		text=$OSMTRANSTEXT
		return 0
	fi
}

## * osmtranslatedirekt 
	# Übersetzt Text direkt mithilfe des OSM Translator-Dienstes
	# Diese Funktion verwendet den OSM Translator, um Text aus einer beliebigen Quellsprache in eine 
	# Zielsprache zu übersetzen. Der OSM Translator-Dienst muss für die Verwendung aktiviert sein.
	#? @param Parameter:
	#? @param   "Text zum Übersetzen" - Der Text, der übersetzt werden soll.
	# Um den OSM Translator-Dienst zu aktivieren, setzen Sie die Umgebungsvariable OSMTRANSLATOR auf "ON".
	# Wenn OSMTRANSLATOR auf "OFF" gesetzt ist, wird der Text nicht übersetzt.
	#? Beispielaufruf:
	#   OSMTRANSLATOR="ON"  # Aktiviert den OSM Translator-Dienst
	#   osmtranslatedirekt "Hello, world!"  # Übersetzt den Text ins Ziel
	#   echo "Übersetzter Text: $text"  # Gibt die übersetzte Zeichenfolge aus
##
function osmtranslatedirekt() {  
    OSMTRANSTEXT=$1
	if [ "$OSMTRANSLATOR" = "OFF" ]; then text=$OSMTRANSTEXT; return 0; fi
	if [ "$OSMTRANS" = ":de" ]; then OSMTRANSLATOR="OFF"; echo "Es funktioniert nicht von der gleichen Sprache in dieselbe zu übersetzen."; fi
    #trans -show-original n -show-original-phonetics n -show-translation Y -show-translation-phonetics n -show-prompt-message n -show-languages n -show-original-dictionary N -show-dictionary n -show-alternatives n -no-warn $OSMTRANS "$OSMTRANSTEXT"
	trans -brief $OSMTRANS "$OSMTRANSTEXT"
}

## * osmnotranslate 
	# Kopiert den Text, ohne Übersetzung durchzuführen
	# Diese Funktion kopiert den angegebenen Text in eine Zielvariable. Wenn der OSM Translator-Dienst 
	# deaktiviert ist (OSMTRANSLATOR auf "OFF" gesetzt), wird der Text unverändert kopiert.
	#? @param Parameter:
	#? @param   "Text zum Kopieren" - Der Text, der kopiert werden soll.
	# Um den OSM Translator-Dienst zu aktivieren, setzen Sie die Umgebungsvariable OSMTRANSLATOR auf "ON".
	# Wenn OSMTRANSLATOR auf "OFF" gesetzt ist, wird der Text nicht übersetzt und direkt kopiert.
	#? Beispielaufruf:
	#   OSMTRANSLATOR="ON"  # Aktiviert den OSM Translator-Dienst
	#   osmnotranslate "Hello, world!"  # Kopiert den Text
	#   echo "Kopierter Text: $text"  # Gibt den kopierten Text aus
##
function osmnotranslate() {
	# Letzte Bearbeitung 26.09.2023
	text=$OSMTRANSTEXT
	if [ "$OSMTRANSLATOR" = "OFF" ]; then text=$OSMTRANSTEXT; return 0; fi
}

## * janein 
	# Übersetzt eine Eingabe in "ja" oder "nein"
	# Diese Funktion übersetzt eine Eingabe in die deutsche Sprache und gibt entweder "ja" oder "nein" zurück,
	# basierend auf der übersetzten Eingabe. Die Eingabe wird zuerst in Kleinbuchstaben umgewandelt und
	# falls leer, wird "nein" zurückgegeben.
	#? @param Parameter:
	#? @param   "Eingabe zum Übersetzen" - Die Eingabe, die übersetzt werden soll.
	#? Beispielaufruf:
	#   janein "Yes"  # Übersetzt "Yes" in "ja"
	#   echo "Antwort: $JNTRANSLATOR"  # Gibt die übersetzte Antwort aus
##
function janein() {
	# Letzte Bearbeitung 26.09.2023
    JNTRANSLATOR="$1"

    # Übersetzen Sie die Eingabe in die deutsche Sprache
    JNTRANSLATOR=$(trans -brief -no-warn :de "$JNTRANSLATOR")

    # Wenn die Übersetzung leer ist, setzen Sie die Antwort auf "nein"
    if [ -z "$JNTRANSLATOR" ]; then
        JNTRANSLATOR="nein"
    fi

    # Wandeln Sie die Übersetzung in Kleinbuchstaben um
    JNTRANSLATOR=$(echo "$JNTRANSLATOR" | tr "[:upper:]" "[:lower:]")
}

## * log 
	# Schreibt Text in eine Log-Datei und gibt ihn auf der Konsole aus
	# Diese Funktion akzeptiert zwei Parameter:
	# 1. logtype: Der Typ des Log-Eintrags (line, rohtext, text, debug, info, warn, error).
	# 2. text: Der Text, der geloggt werden soll.
	#? Beispielaufrufe:
	# log text "Das ist eine Protokollmeldung."
	# log error "Ein Fehler ist aufgetreten!"
	#? Optionale Umgebungsvariablen:
	# - LOGWRITE: Wenn LOGWRITE auf "yes" gesetzt ist, wird der Log-Eintrag in eine Log-Datei geschrieben.
	# - STARTVERZEICHNIS: Das Verzeichnis, in dem die Log-Datei erstellt werden soll.
	# - logfilename: Der Name der Log-Datei.
	#? Hinweise:
	# - Die Farben für die Log-Ausgabe werden mit tput festgelegt, um die Anzeige zu verbessern.
	# - Das Datum und die Uhrzeit werden zu jedem Log-Eintrag hinzugefügt.
##
function log() {
	local text
	local logtype
	logtype="$1"

	# Translate
	rohtext="$2"
	OSMTRANSTEXT="$2"
    osmtranslate "$rohtext"
	
	#datetime=$(date +'%F %H:%M:%S')
	DATEIDATUM=$(date +%d_%m_%Y)
	lline="──────────────────────────────────────────────────────────────────────────────────────────"

	if [ "$LOGWRITE" = "yes" ]; then
		case $logtype in
		line) echo $lline >>/$STARTVERZEICHNIS/"$DATEIDATUM""$logfilename".log ;;
		rohtext) echo "$text" >>/$STARTVERZEICHNIS/"$DATEIDATUM""$logfilename".log ;;
		text) echo "$(date +'%d.%m.%Y-%H:%M:%S') TEXT: $text" >>/$STARTVERZEICHNIS/"$DATEIDATUM""$logfilename".log ;;
		debug) echo "$(date +'%d.%m.%Y-%H:%M:%S') DEBUG: $text" >>/$STARTVERZEICHNIS/"$DATEIDATUM""$logfilename".log ;;
		info) echo "$(date +'%d.%m.%Y-%H:%M:%S') INFO: $text" >>/$STARTVERZEICHNIS/"$DATEIDATUM""$logfilename".log ;;
		warn) echo "$(date +'%d.%m.%Y-%H:%M:%S') WARNING: $text" >>/$STARTVERZEICHNIS/"$DATEIDATUM""$logfilename".log ;;
		error) echo "$(date +'%d.%m.%Y-%H:%M:%S') ERROR: $text" >>/$STARTVERZEICHNIS/"$DATEIDATUM""$logfilename".log ;;
		*) return 0 ;;
		esac
	fi
	case $logtype in
	line) echo "$(tput setaf $linefontcolor) $(tput setab $linebaggroundcolor)$lline $(tput sgr 0)" ;;
	rohtext) echo "$text" ;;
	text) echo "$(tput setaf $textfontcolor) $(tput setab $textbaggroundcolor) $(date +'%d.%m.%Y-%H:%M:%S') TEXT: $text $(tput sgr 0)" ;;
	debug) echo "$(tput setaf $debugfontcolor) $(tput setab $debugbaggroundcolor) $(date +'%d.%m.%Y-%H:%M:%S') DEBUG: $text $(tput sgr 0)" ;;
	info) echo "$(tput setaf $infofontcolor) $(tput setab $infobaggroundcolor) $(date +'%d.%m.%Y-%H:%M:%S') INFO: $text $(tput sgr 0)" ;;
	warn) echo "$(tput setaf $warnfontcolor) $(tput setab $warnbaggroundcolor) $(date +'%d.%m.%Y-%H:%M:%S') WARNING: $text $(tput sgr 0)" ;;
	error) echo "$(tput setaf $errorfontcolor) $(tput setab $errorbaggroundcolor) $(date +'%d.%m.%Y-%H:%M:%S') ERROR: $text $(tput sgr 0)" ;;
	*) return 0 ;;
	esac
	return 0
}

## * osmtoolconfig 
	# Erstellt die Konfigurationsdatei für das opensimTOOL.
	# Usage: osmtoolconfig STARTVERZEICHNIS ROBUSTVERZEICHNIS MONEYVERZEICHNIS OPENSIMVERZEICHNIS CONFIGPFAD OSTOOLINI
	#   STARTVERZEICHNIS: Das Verzeichnis für den Start von opensim (z.B., home oder opt).
	#   ROBUSTVERZEICHNIS: Das Verzeichnis für die Robust-Dienste.
	#   MONEYVERZEICHNIS: Das Verzeichnis für das Geld-Modul.
	#   OPENSIMVERZEICHNIS: Das Hauptverzeichnis von OpenSim.
	#   CONFIGPFAD: Der Pfad zur Konfigurationsdatei.
	#   OSTOOLINI: Der Ausgabepfad für die opensimTOOL-Konfigurationsdatei.
	#? Diese Funktion erstellt eine Konfigurationsdatei für das opensimTOOL.
	# Die Konfiguration enthält Pfade zu verschiedenen Verzeichnissen für die OpenSim-Installation,
	# Einstellungen für Skript-Quellen und Übersetzungsmodi.
	# Sie können diese Konfigurationsdatei später verwenden, um opensimTOOL einzurichten.
	#? Beispiele:
	#   osmtoolconfig "/opensim/start" "/opensim/robust" "/opensim/money" "/opensim/main" "/opensim/config" "/opensim/osconfig.ini"
	#   osmtoolconfig help
##
function osmtoolconfig() {
	# Letzte Bearbeitung 26.09.2023
	STARTVERZEICHNIS=$1; ROBUSTVERZEICHNIS=$2; MONEYVERZEICHNIS=$3; OPENSIMVERZEICHNIS=$4; CONFIGPFAD=$5; OSTOOLINI=$6	
    {		
		echo "#** Einstellungen $SCRIPTNAME $VERSION"
		echo "     "
		echo "#* Das Startverzeichnis home oder opt zum Beispiel."
		echo "    STARTVERZEICHNIS=\"$STARTVERZEICHNIS\""
		echo "    MONEYVERZEICHNIS=\"$MONEYVERZEICHNIS\""
		echo "    ROBUSTVERZEICHNIS=\"$ROBUSTVERZEICHNIS\""
		echo "    OPENSIMVERZEICHNIS=\"$OPENSIMVERZEICHNIS\""
		echo "    CONFIGPFAD=\"$CONFIGPFAD\""
		echo "     "
		echo '    SCRIPTSOURCE="opensim-ossl-example-scripts-main"'
		echo '    SCRIPTZIP="opensim-ossl-example-scripts-main.zip"'
		echo "     "
		echo '    MONEYSOURCE="OpenSimCurrencyServer-2023"'
		echo '    MONEYZIP="OpenSimCurrencyServer-2023.zip"'
		echo '    BULLETSOURCE="BulletSim"'
		echo '    BULLETZIP="BulletSim-main.zip"'
		echo '    #MUTELISTSOURCE="opensim-ossl-example-scripts-main"'
		echo '    #MUTELISTZIP="OpenSimCurrencyServer-2021-master.zip"'
		echo '    #OSSEARCHSOURCE="opensim-ossl-example-scripts-main"'
		echo '    #OSSEARCHZIP="OpenSimCurrencyServer-2021-master.zip"'
		echo "     "
		echo '    #DIVASOURCE="diva-distribution"'
    	echo '    #DIVAZIP="diva-distribution-master.zip"'
		echo "     "
		echo '    CONFIGURESOURCE="opensim-configuration-addon-modul-main"'
		echo '    CONFIGUREZIP="opensim-configuration-addon-modul-main.zip"'
		echo "     "
		echo '    #OSSEARCHSOURCE="OpenSimSearch"'
		echo '    #OSSEARCHSZIP="OpenSimSearch-master.zip"'
		echo "     "
		echo '    BUILDOLD="yes"'
		echo "     "
		echo "    DOTNETMODUS=\"$DOTNETMODUS\""
		echo "     "
		echo "#* Translate Konfigurationsbereich."
		echo "   OSMTRANSLATOR=\"$OSMTRANSLATOR\" # ON/OFF"
		echo "   OSMTRANS=\"$OSMTRANS\" # Sprache in der übersetzt werdn soll."
		echo "#     OSMTRANS=":fr" # Sprache in der übersetzt werdn soll."
		echo "#     OSMTRANS=":es" # Sprache in der übersetzt werdn soll."
		echo "#     OSMTRANS=":it" # Sprache in der übersetzt werdn soll."
		echo "#     OSMTRANS=":uk" # Sprache in der übersetzt werdn soll."
		echo "#     OSMTRANS=":fi" # Sprache in der übersetzt werdn soll."
		echo "#     OSMTRANS=":zh-CN" # Sprache in der übersetzt werdn soll."
		echo "#     OSMTRANS=":zh-TW" # Sprache in der übersetzt werdn soll."
		echo "# Alle Sprachen die möglich sind."
		echo "#     ┌───────────────────────┬───────────────────────┬───────────────────────┐"
		echo "#     │ Afrikaans      -   af │ Hebrew         -   he │ Portuguese     -   pt │"
		echo "#     │ Albanian       -   sq │ Hill Mari      -  mrj │ Punjabi        -   pa │"
		echo "#     │ Amharic        -   am │ Hindi          -   hi │ Querétaro Otomi-  otq │"
		echo "#     │ Arabic         -   ar │ Hmong          -  hmn │ Romanian       -   ro │"
		echo "#     │ Armenian       -   hy │ Hmong Daw      -  mww │ Russian        -   ru │"
		echo "#     │ Azerbaijani    -   az │ Hungarian      -   hu │ Samoan         -   sm │"
		echo "#     │ Bashkir        -   ba │ Icelandic      -   is │ Scots Gaelic   -   gd │"
		echo "#     │ Basque         -   eu │ Igbo           -   ig │ Serbian (Cyr...-sr-Cyrl"
		echo "#     │ Belarusian     -   be │ Indonesian     -   id │ Serbian (Latin)-sr-Latn"
		echo "#     │ Bengali        -   bn │ Irish          -   ga │ Sesotho        -   st │"
		echo "#     │ Bosnian        -   bs │ Italian        -   it │ Shona          -   sn │"
		echo "#     │ Bulgarian      -   bg │ Japanese       -   ja │ Sindhi         -   sd │"
		echo "#     │ Cantonese      -  yue │ Javanese       -   jv │ Sinhala        -   si │"
		echo "#     │ Catalan        -   ca │ Kannada        -   kn │ Slovak         -   sk │"
		echo "#     │ Cebuano        -  ceb │ Kazakh         -   kk │ Slovenian      -   sl │"
		echo "#     │ Chichewa       -   ny │ Khmer          -   km │ Somali         -   so │"
		echo "#     │ Chinese Simp...- zh-CN│ Klingon        -  tlh │ Spanish        -   es │"
		echo "#     │ Chinese Trad...- zh-TW│ Klingon (pIqaD)tlh-Qaak Sundanese      -   su │"
		echo "#     │ Corsican       -   co │ Korean         -   ko │ Swahili        -   sw │"
		echo "#     │ Croatian       -   hr │ Kurdish        -   ku │ Swedish        -   sv │"
		echo "#     │ Czech          -   cs │ Kyrgyz         -   ky │ Tahitian       -   ty │"
		echo "#     │ Danish         -   da │ Lao            -   lo │ Tajik          -   tg │"
		echo "#     │ Dutch          -   nl │ Latin          -   la │ Tamil          -   ta │"
		echo "#     │ Eastern Mari   -  mhr │ Latvian        -   lv │ Tatar          -   tt │"
		echo "#     │ Emoji          -  emj │ Lithuanian     -   lt │ Telugu         -   te │"
		echo "#     │ English        -   en │ Luxembourgish  -   lb │ Thai           -   th │"
		echo "#     │ Esperanto      -   eo │ Macedonian     -   mk │ Tongan         -   to │"
		echo "#     │ Estonian       -   et │ Malagasy       -   mg │ Turkish        -   tr │"
		echo "#     │ Fijian         -   fj │ Malay          -   ms │ Udmurt         -  udm │"
		echo "#     │ Filipino       -   tl │ Malayalam      -   ml │ Ukrainian      -   uk │"
		echo "#     │ Finnish        -   fi │ Maltese        -   mt │ Urdu           -   ur │"
		echo "#     │ French         -   fr │ Maori          -   mi │ Uzbek          -   uz │"
		echo "#     │ Frisian        -   fy │ Marathi        -   mr │ Vietnamese     -   vi │"
		echo "#     │ Galician       -   gl │ Mongolian      -   mn │ Welsh          -   cy │"
		echo "#     │ Georgian       -   ka │ Myanmar        -   my │ Xhosa          -   xh │"
		echo "#     │ German         -   de │ Nepali         -   ne │ Yiddish        -   yi │"
		echo "#     │ Greek          -   el │ Norwegian      -   no │ Yoruba         -   yo │"
		echo "#     │ Gujarati       -   gu │ Papiamento     -  pap │ Yucatec Maya   -  yua │"
		echo "#     │ Haitian Creole -   ht │ Pashto         -   ps │ Zulu           -   zu │"
		echo "#     │ Hausa          -   ha │ Persian        -   fa │                       │"
		echo "#     │ Hawaiian       -  haw │ Polish         -   pl │                       │"
		echo "#     └───────────────────────┴───────────────────────┴───────────────────────┘"
		echo "     "
		echo "#* Schrift- und Hintergrundfarben"
		echo "#*  0 – Black, 1 – Red, 2 – Green, 3 – Yellow, 4 – Blue, 5 – Magenta, 6 – Cyan, 7 – White"
		echo "    # font color;       background color;"
		echo "    textfontcolor=7;    textbaggroundcolor=0;"
		echo "    debugfontcolor=4;   debugbaggroundcolor=0;"
		echo "    infofontcolor=2;    infobaggroundcolor=0;"
		echo "    warnfontcolor=3;    warnbaggroundcolor=0;"
		echo "    errorfontcolor=1;   errorbaggroundcolor=7;"
		echo "    linefontcolor=7;    linebaggroundcolor=0;"
		echo "     "
		echo "    ScreenLogLevel=0; # ScreenLogLevel=0 nichts machen, bis ScreenLogLevel=5 Funktionsnamen ausgeben."
		echo '    LOGWRITE="no" # yes/no'
		echo '    logfilename="_multitool"'
		echo '    line="************************************************************";'
		echo "     "
		echo "#* Dateien"
		echo '    REGIONSDATEI="osmregionlist.ini"'
		echo '    SIMDATEI="osmsimlist.ini"'
		echo '    OPENSIMDOWNLOAD="http://opensimulator.org/dist/"'
		echo '    OPENSIMVERSION="opensim-0.9.3.0Dev"'
		echo '    #OPENSIMVERSION="opensim-0.9.3.0Dev"'
		echo '    SEARCHADRES="icanhazip.com" # Suchadresse'
		echo "     "
		echo '    REGIONSANZEIGE="yes"'
		echo "     "
		echo '    LOGDELETE="yes" # yes/no'
		echo '    VISITORLIST="no" # yes/no - schreibt vor dem loeschen alle Besucher samt mac in eine log Datei.'
		echo "     "
		echo '	BULLETUBUNTU1804bionic="libBulletSim-3.26-20231210-x86_64.so"'
		echo '	BULLETUBUNTU1810cosmic="libBulletSim-3.26-20231210-x86_64.so"'
		echo '	BULLETUBUNTU2004focal="libBulletSim-3.26-20231207-x86_64.so"'
		echo '	BULLETUBUNTU2010groovy="libBulletSim-3.26-20231207-x86_64.so"'
		echo '	BULLETUBUNTU2204jammy="libBulletSim-3.26-20231209-x86_64.so"'
		echo '	BULLETUBUNTU2210kinetic="libBulletSim-3.26-20231209-x86_64.so"'
		echo '	BULLETUBUNTU2304lunar="libBulletSim-3.26-20231209-x86_64.so"'
		echo '	BULLETUBUNTU2310mantic="libBulletSim-3.26-20231209-x86_64.so"'
		echo '	BULLETUBUNTU2404noble="libBulletSim-3.26-20231209-x86_64.so"'
		echo "     "
		echo "#* Inklusive"
		echo '    SCRIPTCOPY="yes"'
		echo '    MONEYCOPY="yes"'
		echo '    BULLETCOPY="yes"'
		echo '    MUTELISTCOPY="no"'
		echo '    OSSEARCHCOPY="no"'
		echo '    DIVACOPY="no"'
		echo '    PYTHONCOPY="no"'
		echo '    CHRISOSCOPY="no"'
		echo '    AUTOCONFIG="no"'
		echo "     "
		echo "#* Die unterschiedlichen wartezeiten bis die Aktion ausgefuehrt wurde."
		echo "    WARTEZEIT=60 # Ist eine allgemeine Wartezeit."
		echo "    STARTWARTEZEIT=10 # Startwartezeit ist eine Pause, damit nicht alle Simulatoren gleichzeitig starten."
		echo "    STOPWARTEZEIT=30 # Stopwartezeit ist eine Pause, damit nicht alle Simulatoren gleichzeitig herunterfahren."
		echo "    MONEYWARTEZEIT=60 # Moneywartezeit ist eine Extra Pause, weil dieser zwischen Robust und Simulatoren gestartet werden muss."
		echo "    ROBUSTWARTEZEIT=90 # Robust wartezeit ist eine Extra Pause, weil dieser komplett gestartet werden muss."
		echo "    BACKUPWARTEZEIT=180 # Backupwartezeit ist eine Pause, damit der Server nicht ueberlastet wird."
		echo "    AUTOSTOPZEIT=60 # Autostopzeit ist eine Pause, um den Simulatoren zeit zum herunterfahren gegeben wird, bevor haengende Simulatoren gekillt werden."
		echo "     "
		echo "#* Linux Einstellungen"
		echo '    SETMONOTHREADSON="yes"'
		echo "    SETMONOTHREADS=1024"
		echo '    SETULIMITON="yes"'
		echo '    SETMONOGCPARAMSON1="no"'
		echo '    SETMONOGCPARAMSON2="yes"'
		echo "     "
		echo "#* Divers"
		echo '    SETOSCOMPION="no" # Mit oder ohne log Datei kompilieren. yes oder no.'
		echo '    SETAOTON="no"'
		echo "    # opensim-0.9.3.0Dev-4-g5e9b3b4.zip"
		echo '    OSVERSION="opensim-0.9.3.0Dev-"'
		echo '    # OSVERSION="opensim-0.9.3.0Dev-"'
		echo '    insterweitert="yes"'
		echo "     "
		echo "#* Bereinigungen"
		echo '    AUTOCLEANALL="yes"'
		echo '    GRIDCACHECLEAR="yes"'
		echo '    SCRIPTCLEAR="no"'
		echo '    ASSETCACHECLEAR="yes"'
		echo '    MAPTILESCLEAR="yes"'
		echo '    RMAPTILESCLEAR="yes"'
		echo '    RBAKESCLEAR="no"'
		echo "     "
		echo "#* OpenSim Downloads"
		echo '    LINK01="http://opensimulator.org/dist/OpenSim-LastAutoBuild.zip"'
		echo '    LINK02="http://opensimulator.org/dist/opensim-0.8.2.1-source.tar.gz"'
		echo '    LINK03="http://opensimulator.org/dist/opensim-0.8.2.1-source.zip"'
		echo '    LINK04="http://opensimulator.org/dist/opensim-0.8.2.1.tar.gz"'
		echo '    LINK05="http://opensimulator.org/dist/opensim-0.8.2.1.zip"'
		echo '    LINK06="http://opensimulator.org/dist/opensim-0.9.0.0-source.tar.gz"'
		echo '    LINK07="http://opensimulator.org/dist/opensim-0.9.0.0-source.zip"'
		echo '    LINK08="http://opensimulator.org/dist/opensim-0.9.0.0.tar.gz"'
		echo '    LINK09="http://opensimulator.org/dist/opensim-0.9.0.0.zip"'
		echo '    LINK10="http://opensimulator.org/dist/opensim-0.9.0.1-source.tar.gz"'
		echo '    LINK11="http://opensimulator.org/dist/opensim-0.9.0.1-source.zip"'
		echo '    LINK12="http://opensimulator.org/dist/opensim-0.9.0.1.tar.gz"'
		echo '    LINK13="http://opensimulator.org/dist/opensim-0.9.0.1.zip"'
		echo '    LINK14="http://opensimulator.org/dist/opensim-0.9.1.0-source.tar.gz"'
		echo '    LINK15="http://opensimulator.org/dist/opensim-0.9.1.0-source.zip"'
		echo '    LINK16="http://opensimulator.org/dist/opensim-0.9.1.0.tar.gz"'
		echo '    LINK17="http://opensimulator.org/dist/opensim-0.9.1.0.zip"'
		echo '    LINK18="http://opensimulator.org/dist/opensim-0.9.1.1-source.tar.gz"'
		echo '    LINK19="http://opensimulator.org/dist/opensim-0.9.1.1-source.zip"'
		echo '    LINK20="http://opensimulator.org/dist/opensim-0.9.1.1.tar.gz"'
		echo '    LINK21="http://opensimulator.org/dist/opensim-0.9.1.1.zip"'
		echo '    LINK22="http://opensimulator.org/dist/opensim-0.9.2.0-source.tar.gz"'
		echo '    LINK23="http://opensimulator.org/dist/opensim-0.9.2.0-source.zip"'
		echo '    LINK24="http://opensimulator.org/dist/opensim-0.9.2.0.tar.gz"'
		echo '    LINK25="http://opensimulator.org/dist/opensim-0.9.2.0.zip"'
		echo '    LINK26="http://opensimulator.org/dist/opensim-0.9.2.1.zip"'
		echo "     "
		echo "#* Log Dateien"
		echo '    apache2errorlog="/var/log/apache2/error.log"'
		echo '    apache2accesslog="/var/log/apache2/access.log"'
		echo '    authlog="/var/log/auth.log"'
		echo '    ufwlog="/var/log/ufw.log"'
		echo '    mysqlmariadberor="/var/log/mysql/mariadb.err"'
		echo '    mysqlerrorlog="/var/log/mysql/error.log"'
		echo "     "
		echo "#* Liste der zu verwendende Musiklisten."
		echo '    listVar="50s 60s 70s 80s 90s Alternative Blues Classic Club Country Dance Disco EDM Easy Electronic Folk Funk Gothic Heavy Hits House Indie Jazz Metal Misc Oldies Party Pop Reggae Rock Schlager Soul Techno Top Trance industrial pop"'
    } > "$OSTOOLINI"

	echo "** Ihre neuen Konfigurationsdateien wurden geschrieben! **#"
	echo "#*******************  FERTIG  ****************************#"
}

## * osmtoolconfigabfrage 
	# Führt eine Benutzerabfrage durch und erstellt die opensimTOOL Konfigurationsdatei.
	# Diese Funktion führt eine Benutzerabfrage durch, um Einstellungen für die opensimTOOL-Konfiguration zu sammeln.
	# Anschließend wird die Konfigurationsdatei erstellt.
	# Usage: osmtoolconfigabfrage
	#? Diese Funktion erfasst die folgenden Einstellungen:
	# - Aktivierung der automatischen Übersetzung (ON oder OFF)
	# - Auswahl der Sprache (zum Beispiel: de)
	# - Verzeichnisse für Start, Robust, Money, OpenSim und Konfiguration
	# - Verwendung von dotnet 6 (yes oder no)
	#? Beispielaufruf:
	# osmtoolconfigabfrage
##
function osmtoolconfigabfrage() {
	# Letzte Bearbeitung 26.09.2023
	# Ausgabe Kopfzeilen
	VSTARTVERZEICHNIS=$(pwd); # Vorläufiges Startverzeichnis
	log rohtext "$SCRIPTNAME Version $VERSION"

	log rohtext "Do you want to enable automatic translation? ON [OFF]"
	read -r OSMTRANSLATOR
	if [ "$OSMTRANSLATOR" = "" ]; then OSMTRANSLATOR="OFF"; fi
	log rohtext "your selection: $OSMTRANSLATOR"
	log rohtext "*******************************************************************"

	log rohtext "Please select your language: [:de]"
	read -r OSMTRANS
	if [ "$OSMTRANS" = "" ]; then OSMTRANS=":de"; fi
	log rohtext "Your language $OSMTRANS"
	log rohtext "*******************************************************************"

	log rohtext " "
	log rohtext "*******************************************************************"
	log rohtext "********** ABBRUCH MIT DER TASTENKOMBINATION ********************"
	log rohtext "********************  CTRL/STRG + C  *****************************"
	log rohtext "*******************************************************************"
	log rohtext #**     Die Werte in den [Klammern] sind vorschläge              *#"
	log rohtext #**     und können mit Enter übernommen werden.                  *#"
	log rohtext "*******************************************************************"
	log rohtext #**   Daten stehen gegeben falls auch in der alten opensim.cnf   *#"
	log rohtext "*******************************************************************"
	log rohtext " "
	log rohtext "Das Verzeichnis wo sich ihr Grid befindet oder befinden soll ["${VSTARTVERZEICHNIS//\//}"]"
	read -r STARTVERZEICHNIS
	if [ "$STARTVERZEICHNIS" = "" ]; then STARTVERZEICHNIS=""${VSTARTVERZEICHNIS//\//}""; fi
	log rohtext "Ihr Gridverzeichnis ist $STARTVERZEICHNIS"
	log rohtext "*******************************************************************"

	log rohtext "Das Verzeichnis wo sich ihr Robust befindet [robust]"
	read -r ROBUSTVERZEICHNIS
	if [ "$ROBUSTVERZEICHNIS" = "" ]; then ROBUSTVERZEICHNIS="robust"; fi
	log rohtext "Ihr Robustverzeichnis ist $ROBUSTVERZEICHNIS"
	log rohtext "*******************************************************************"

	log rohtext "Das Verzeichnis wo sich ihr Moneyverzeichnis befindet [robust]"
	read -r MONEYVERZEICHNIS
	if [ "$MONEYVERZEICHNIS" = "" ]; then MONEYVERZEICHNIS="robust"; fi
	log rohtext "Ihr Moneyverzeichnis ist $MONEYVERZEICHNIS"
	log rohtext "*******************************************************************"

	log rohtext "Das Verzeichnis wo sich ihr OpenSimverzeichnis befindet [opensim]"
	read -r OPENSIMVERZEICHNIS
	if [ "$OPENSIMVERZEICHNIS" = "" ]; then OPENSIMVERZEICHNIS="opensim"; fi
	log rohtext "Ihr OpenSimverzeichnis ist $OPENSIMVERZEICHNIS"
	log rohtext "*******************************************************************"

	log rohtext "Das Verzeichnis wo sich ihre Konfigurationsdateien befindet [OpenSimConfig]"
	read -r CONFIGPFAD
	if [ "$CONFIGPFAD" = "" ]; then CONFIGPFAD="OpenSimConfig"; fi
	log rohtext "Ihr Konfigurationsdateienverzeichnis ist $CONFIGPFAD"
	log rohtext "*******************************************************************"

	log rohtext "Soll dotnet 6 benutzt werden [yes] no"
	read -r DOTNETMODUS
	if [ "$DOTNETMODUS" = "" ]; then DOTNETMODUS="yes"; fi
	log rohtext "Ihre dotnet 6 auswahl ist $DOTNETMODUS"
	log rohtext "*******************************************************************"

    # Fertig und schreiben.
    #osmtoolconfig "/$STARTVERZEICHNIS/osmtoolconfig.ini"
	osmtoolconfig $STARTVERZEICHNIS $ROBUSTVERZEICHNIS $MONEYVERZEICHNIS $OPENSIMVERZEICHNIS $CONFIGPFAD "/$SCRIPTPATH/osmtoolconfig.ini"
}

#──────────────────────────────────────────────────────────────────────────────────────────
#* Konfiguration opensimMULTITOOL
#──────────────────────────────────────────────────────────────────────────────────────────
# Nutzer mit Konfigurationsfragen quaelen
# Abfrage Konfig Einstellungen
if ! [ -f "/$SCRIPTPATH/osmtoolconfig.ini" ]; then osmtoolconfigabfrage; fi

# Variablen aus config Datei laden osmtoolconfig.ini muss sich im gleichen Verzeichnis wie osmtool.sh befinden.
# shellcheck disable=SC1091
. "$SCRIPTPATH"/osmtoolconfig.ini

# Aktuelle IP ueber Suchadresse ermitteln und Ausfuehrungszeichen anhaengen.
AKTUELLEIP='"'$(wget -O - -q $SEARCHADRES)'"'

# gibt es das Startverzeichnis wenn nicht abbruch.
cd /"$STARTVERZEICHNIS" || return 1
sleep 1

# Eingabeauswertung fuer Funktionen ohne dialog.
KOMMANDO=$1

#──────────────────────────────────────────────────────────────────────────────────────────
#* Hilfsfunktionen Funktionsgruppe
#──────────────────────────────────────────────────────────────────────────────────────────

## * dummyvar
	# Fehlermeldungen ueberlisten wegen der Konfigurationsdatei, 
	# hat sonst keinerlei Funktion und wird auch nicht aufgerufen.
	#? @param keine.
	#? @return nichts wird zurueckgegeben.
	# todo: nichts.
##
function dummyvar() {
	# shellcheck disable=SC2034
	MONEYVERZEICHNIS="robust"; ROBUSTVERZEICHNIS="robust"; OPENSIMVERZEICHNIS="opensim"; SCRIPTSOURCE="ScriptNeu"; SCRIPTZIP="opensim-ossl-example-scripts-main.zip"; MONEYSOURCE="OpenSimCurrencyServer-2023";
	BULLETSOURCE="BulletSim"; BULLETZIP="BulletSim-main.zip";
	MONEYZIP="OpenSimCurrencyServer-2021-master.zip"; REGIONSDATEI="osmregionlist.ini"; SIMDATEI="osmsimlist.ini"; WARTEZEIT=30; STARTWARTEZEIT=10; STOPWARTEZEIT=30; MONEYWARTEZEIT=60; ROBUSTWARTEZEIT=60;
	BACKUPWARTEZEIT=120; AUTOSTOPZEIT=60; SETMONOTHREADS=800; SETMONOTHREADSON="yes"; OPENSIMDOWNLOAD="http://opensimulator.org/dist/"; SEARCHADRES="icanhazip.com"; # AUTOCONFIG="no"
	CONFIGURESOURCE="opensim-configuration-addon-modul-main"; CONFIGUREZIP="opensim-configuration-addon-modul-main.zip"
	textfontcolor=7; textbaggroundcolor=0; debugfontcolor=4; debugbaggroundcolor=0	infofontcolor=2	infobaggroundcolor=0; warnfontcolor=3; warnbaggroundcolor=0;
	errorfontcolor=1; errorbaggroundcolor=0; SETMONOGCPARAMSON1="no"; SETMONOGCPARAMSON2="yes"	LOGDELETE="no"; LOGWRITE="no"; "$trimmvar"; logfilename="_multitool"
	username="username"	password="userpasswd"	databasename="grid"	linefontcolor=7	linebaggroundcolor=0; apache2errorlog="/var/log/apache2/error.log"; apache2accesslog="/var/log/apache2/access.log";
	authlog="/var/log/auth.log"	ufwlog="/var/log/ufw.log"	mysqlmariadberor="/var/log/mysql/mariadb.err"; mysqlerrorlog="/var/log/mysql/error.log"; listVar=""; ScreenLogLevel=0;
	# DIALOG_OK=0; DIALOG_HELP=2; DIALOG_EXTRA=3; DIALOG_ITEM_HELP=4; SIG_NONE=0; SIG_HUP=1; SIG_INT=2; SIG_QUIT=3; SIG_KILL=9; SIG_TERM=15
	DIALOG_CANCEL=1; DIALOG_ESC=255; DIALOG=dialog; VISITORLIST="yes"; REGIONSANZEIGE="yes"; #DELREGIONS="no";
	netversion="1946"; CONFIGPFAD="OpenSimConfig"; DOTNETMODUS="yes";
	OSVERSION="opensim-0.9.3.0Dev";
	OPENSIMVERSION="opensim-0.9.3.0.zip"; OSMTRANS=":de"; OSMTRANSLATOR="OFF";
}

## *  xhelp
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion dient dazu, die Hilfeanzeige für einzelne Funktionen anzuzeigen, wenn der entsprechende Parameter übergeben wird.
	#? Parameter:
	#   $1 (String): Der Parameter, der den Namen der Funktion enthält, für die Hilfe angezeigt werden soll.
	#? Funktionsverhalten:
	#   - Überprüft, ob der Parameter "help" ist.
	#   - Wenn "help" übergeben wird, zeigt die Funktion eine Hilfeanzeige für die angegebene Funktion an.
	#   - Beendet das Skript nach der Anzeige der Hilfe für die Funktion.
	#? Beispielaufruf:
	#   xhelp "help"
	#   xhelp "andere_funktion"
	#? Rückgabewert: Die Funktion hat keinen expliziten Rückgabewert, da sie das Skript beendet.
	#? Hinweise:
	#   - Passen Sie die Funktionalität an die Anforderungen Ihres Skripts an.
##
function xhelp() {
	if [[ $1 == "help" ]]; then	echo "Zeigt die Hilfe einzelner Funktionen an."; exit 0; fi
	exit 0;	
}

## * skriptversion
	# Diese Funktion gibt die Versionsnummer des opensimMULTITOOL-Skripts aus.
	#? Verwendung:
	#   skriptversion
	#? Argumente:
	#   Keine.
	#? Optionen:
	#   -h, --help: Zeigt die Hilfe für die Funktion an.
	#? Beispiele:
	#   skriptversion  # Zeigt die Versionsnummer des opensimMULTITOOL-Skripts an.
	#? Rückgabewerte:
	#   0 - Die Funktion wurde erfolgreich ausgeführt.
	#   1 - Die Funktion wurde mit ungültigen Argumenten aufgerufen.
##
function skriptversion() {
	# Test einer neuen Hilfe.
	if [[ $1 == "help" ]]; then	echo "Zeigt die skriptversion vom opensimMULTITOOL an."; exit 0; fi
	echo "$VERSION";
	exit 0;
}

## *  namen
	# Datum: 03.10.2023
	#? Beschreibung: Diese Funktion gibt einen zufälligen Namen aus einer vordefinierten Liste von Regionennamen aus.
	#? Parameter:
	#   $1 (optional): Wenn "help" übergeben wird, wird eine Hilfemeldung angezeigt, andernfalls wird ein zufälliger Regionsname ausgegeben.
	#? Verwendung:
	#   namen              # Gibt einen zufälligen Regionsnamen aus.
	#   namen help         # Zeigt eine Hilfemeldung an.
	#? Rückgabewert:
	#   Keiner (void)
##
function namen() {
	# Überprüfen, ob das erste Argument $1 "help" ist, und Hilfe anzeigen.
	if [[ $1 == "help" ]]; then	echo "Ein Zufallsname wird ausgegeben."; exit 0; fi

	# Liste von vordefinierten Regionennamen.
	namensarray=("Terwingen" "Angeron" "Vidivarier" "Usipeten" "Sibiner" "Ranier" "Sabalingier" "Aglier" "Aduatuker" \
	"Favonen" "Sachsen" "Karpen" "Gautigoten" "Gepiden" "Mugilonen" "Bardongavenses" "Steoringun" "Guiones" "Teutonen" \
	"Brukterer" "Omanen" "Astfalon" "Langobarden" "Frumtingas" "Eruler" "Moselfranken" "Tylangier" "Gillingas" \
	"Singulonen" "Pharodiner" "Ahelmil" "Scopingun" "Waledungun" "Rosomonen" "Peukiner" "Elbsueben" "Scharuder" \
	"Suardonen" "Suetiden" "Finnaithen" "Ambivareten" "Gegingas" "Aringon" "Anglier" "Glomman" "Raumariker" \
	"Alemannen" "Narvaler" "Sunuker" "Mattiaker" "Kasuarier" "Bastarnen" "Sahslingun" "Frisiavonen" "Skiren" \
	"Normannen" "Gambrivier" "Salfranken" "Holtsaeten" "Bergio" "Harier" "Holsten" "Lognai" "Vandalen" "Evagre" \
	"Sigambrer" "Euten" "Kaoulkoi" "Burgunden" "Bajuwaren" "Hundingas" "Ostgoten" "Nervier" "Merscware" "Sturier" \
	"Hillevionen" "Anglevarier" "Marsaker" "Schasuaren" "Otingis" "Cilternsaetan" "Falen" "Tenkterer" "Suonen" \
	"Dounoi" "Teutonoaren" "Hugones" "Amoþingas" "Kalukonen" "Ostheruler" "Rus" "Wangionen" "Háleygir" "Triboker" \
	"Markomannen" "Hordar" "Thiadmariska" "Holsten" "Gauten" "Krimgoten" "Herefinnas" "Fervir" "Hessen" "Sithonen" \
	"Nuitonen" "Hringar" "Westheruler" "Bucinobanten" "Lakringen" "Eburonen" "Boutones" "Korkonter" "Angelsachsen" \
	"Clondikus" "Donausweben" "Franken" "Nertereanen" "Barden" "Frugundionen" "Vinoviloth" "Treverer" "Elouaiones" \
	"Schamaver" "Anarten" "Leuonoi" "Westgoten" "Winiler" "Turonen" "Visburgier" "Wandalen" "Landoudioer" "Harier" \
	"Narisker" "Kimbern" "Kampen" "Semnonen" "Sugamber" "Haruden" "Colduer" "Geddingas" "Helvekonen" "Sedusier" \
	"Baetasier" "Heinir" "Endosen" "Curionen" "Urugunden" "Hadubarden" "Taetel" "Tubanten" "Wariner" "Silinger" \
	"Katten" "Marser" "Gumeningas" "Fundusier" "Levoner" "Helusii" "Sidones" "Varasker" "Manimer" "Angeln" "Daukionen" \
	"Engern" "Segner" "Visper" "Scherusker" "Tungrer" "Bainaib" "Kannanefaten" "Mimmas" "Breisgauer" "Rheinfranken" \
	"Condruser" "Batavier" "Neckarsueben" "Belger" "Gotthograikoi" "Engern" "Burgodionen" "Guddingen" "Ulmeraner" \
	"Kampsianoi" "Viktofalen" "Nemeter" "Turkilinger" "Liothida" "Routiklioi" "Hermionen" "Rygir" "Veneter" "Schaler" \
	"Zumer" "Firaesen" "Menapier" "Linzgauer" "Diduner" "Kleingoten" "Rugier" "Theusten" "Sidiner" "Amsivarier" \
	"Greutungen" "Eunixer" "Hedeninge" "Scotelingun" "Agradingun" "Granier" "Schaubi" "Dulgubiner" "Halogit" \
	"Marvingen" "Eudosen" "Halliner" "Elmetsaetan" "Kantwarier" "Dorsaetan" "Augandxer" "Gifle" "Firihsetan" \
	"Maiaten" "Goten" "Cobander" "Sulones" "Lugier" "Kugerner" "Peukmer" "Caritner" "Ubier" "Toxandrer" "Graioceler" \
	"Texuandrer" "Variner" "Elbgermanen" "Arosaetan" "Viruner" "Friesen" "Obronen" "Campsianer" "Derlingun" "Helisier" \
	"Quaden" "Myrgingas" "Buren" "Permanen" "Doelir" "Schauken" "Foser" "Taifalen" "Avionen" "Nictrenses" "Svear" \
	"Alfheim" "Anundshög" "Asgard" "Beilen" "Berne" "Bifröst" "Bilskirnir" "Blouswardt" "Breidablik" "Brenz" "Brunsbüttel" \
	"Bärhorst" "Büdingen" "Elivagar" "Emmerich" "Fanum" "Fensal" "Flögeln" "Fochteloo" "Folkwang" "Fyrisan" "Fünen" "Geltow" \
	"Ginnungagap" "Gjallarbru" "Gjöll" "Gladsheim" "Glasisvellir" "Glauberg" "Glitnir" "Gnipahellir" "Gram" "Grenaa" "Grontoft" \
	"Haldern" "Hel" "Helgeland" "Helheim" "Hemmed" "Himinbjörg" "Hjemstedt" "Hnitbjörg" "Hodde" "Hodorf" "Hohensalza" "Hojgärd" \
	"Hvergelmir" "Idafeld" "Jomsburg" "Jötunheim" "Kablow" "Kamen" "Keitum" "Kosel" "Landwidi" "Langenbek" "Ledbergsten" "Leve" \
	"Loxstedt" "Marmstorf" "Marwedel" "Midgard" "Mimirs" "Muspellsheim" "Naströnd" "Nidafelsen" "Nidawellir" "Niflheim" "Niflhel" \
	"Noatun" "Norre" "Ockenhausen" "Odoom" "Olderdige" "Omme" "Ostermoor" "Putensen" "Reidgotaland" "Reinfeld" "Rullsdorf" \
	"Schöningstedt" "Sessrumnir" "Skaerbaek" "Skalundahög" "Slidur" "Sontheim" "Speyer" "SteinvonMora" "Svartalfaheimr" "Sökkwabeck" \
	"Sörupsten" "Thrudheim" "Thrymheim" "Tibirke" "Tinnum" "Tofting" "Uppsala" "Urach" "Urdbrunnen" "Utgard" "Valaskjalf" \
	"Vanaheimr" "Vineta" "Vingolf" "Vorbasse" "Waberlohe" "Wahlitz" "Walhall" "Werder" "Westick" "Wierde" "Wigrid" "Winternheim" \
	"Wittemoor"	"Ermunduren" "Danduten")

	# Anzahl der Elemente im namensarray.
	count=${#namensarray[@]}

	# Liste von vordefinierten Namen.
	REGIONSNAMENZAHL=$(($RANDOM % $count))

	# Den ausgewählten Regionsnamen speichern.
	NEUERREGIONSNAME=${namensarray[$REGIONSNAMENZAHL]}
}

## *  vornamen
	# Datum: 03.10.2023
	#? Beschreibung: Diese Funktion gibt einen zufälligen vornamen aus einer vordefinierten Liste von vornamen aus.
	#? Parameter:
	#   $1 (optional): Wenn "help" übergeben wird, wird eine Hilfemeldung angezeigt, andernfalls wird ein zufälliger Regionsname ausgegeben.
	#? Verwendung:
	#   vornamen              # Gibt einen zufälligen vornamen aus.
	#   vornamen help         # Zeigt eine Hilfemeldung an.
	#? Rückgabewert:
	#   Keiner (void)
##
function vornamen() {
	# Überprüfen, ob das erste Argument $1 "help" ist, und Hilfe anzeigen.
	if [[ $1 == "help" ]]; then	echo "Ein Zufallsname wird ausgegeben."; exit 0; fi

	firstnamensarray=("Peter" "Rainer" "Sergej" "Karl" "Daredevil" "Relative" "Into" "Agony" "Carbon" "Wrecking" "Crazy" "Unique" "Daydreamer" "Ed" "Nickname" "Anger" "Justin" \
					"Lee" "Roman" "Yum" "House" "ObiLAN" "Anakin" "Spaghetti" "Fritzchen" "Connecto" "Lan" "Jutta" "Bertha" "Chilly" "Agata" "Regen" "Siegtraude" "Wilma" "Raging" "King" \
					"Polaroid" "Candy" "Fast" "Mike" "Savage" "Chop" "Edgar" "Cereal" "The" "KillMe" "Spicy" "Terrifying" "Smufus" "Harry" "Airport" "Chicken" "Donkey" "Bread" "Hairy" "Sillje" \
					"Weina" "Marlo" "Toffel" "Binder" "Performance" "Abyss" "Qual" "Claw" "Ball" "Turtle" "Aspirin" "Nygma" "Forgiven" "Avenger" "Time" "Eintragen" "Monade" "Ticker" \
					"Meefood" "LANister" "Kenobi" "Skyrouter" "Bolognese" "Box" "Patronum" "Solo" "Jessica" "Isberga" "Calilia" "Ehrentraud" "Frida" "Gebba" "Randy" "Kano" "Pal" "Butcher" \
					"Curious" "Tython" "Sam" "Chop" "AllenBro" "Killer" "Muffin" "NowPlease" "Chicken" "Terry" "BroCode" "Dotter" "Hobo" "Dinner" "Bong" "Pitt" "Poppins" "Thomas" "Brigitte" \
					"Peter" "Angelika" "Hans" "Sabine" "Klaus" "Monika" "Wolfgang" "Karin" "Andreas" "Marion" "Jürgen" "Petra" "Bernd" "Birgit" "Reiner" "Gabriele" "Manfred" "Susanne" "Uwe" "Barbara" \
					"Joachim" "Renate" "Dieter" "Ute" "Werner" "Jutta" "Karl" "Ursula" "Holger" "Cornelia" "Frank" "Ingrid" "Norbert" "Heike" "Ralf, Rolf" "Regina" "Ulrich" "Maria" "Jörg" "Silvia" \
					"Helmut" "Elke" "Günter" "Angela" "Gerhard" "Andrea" "Horst" "Ulrike" "Jens" "Gisela" "Harald" "Dagmar" "Martin" "Helga" "Heinz" "Christine" "Reinhard" "Eva" "Matthias" "Claudia" \
					"Stefan" "Marianne" "Detlef" "Bärbel" "Volker" "Doris" "Walter" "Beate" "Bernhard" "Rita" "Hartmut" "Gudrun" "Alexander" "Hannelore" "Christian" "Anke" "Rüdiger" "Marlis" "Georg" \
					"Heidi" "Roland" "Anette" "Axel" "Rosemarie" "Herbert" "Carmen" "Jan" "Inge" "Dirk" "Margrit" "Carsten" "Irene" "Udo" "Maren" "Siegfried" "Kerstin" "Kurt" "Olga" "Herrmann" "Anita" \
					"Lutz" "Frauke" "Johannes" "Annelise" "Hubert" "Susanne" "Heiko" "Meike" "Wilhelm" "Gertrud" "Paul" "Ina" "Arno" "Gunda" "Jochen" "Stephanie" "Heiner" "Gerlinde" "Niels" "Tamara" \
					"Henning" "Liane" "Anton" "Ursel" "Edmund" "Rosa" )

	# Anzahl der Elemente im namensarray.
	count=${#firstnamensarray[@]}

	# Liste von vordefinierten Namen.
	VORNAMENZAHL=$(($RANDOM % $count))

	# Den ausgewählten Regionsnamen speichern.
	NEUERAVATARVORNAME=${firstnamensarray[$VORNAMENZAHL]}
}

## *  randomname
	# Datum: 03.10.2023
	#? Beschreibung: Generiert einen zufälligen Vornamen, einen zufälligen Regionsnamen und gibt diese aus.
	#? Verwendung:
	#   randomname
	#? Rückgabewert:
	#   Keiner (void)
##
function randomname() {
	# Aufrufen der Funktion "vornamen", um einen zufälligen Vornamen zu generieren.
	vornamen
	# Loggt den generierten Vornamen.
	log rohtext "Neuer Vorname: $NEUERAVATARVORNAME"
	# Aufrufen der Funktion "namen", um einen zufälligen Regionsnamen zu generieren.
	namen
	# Gibt den generierten Avatar-Namen, der aus Vorname und Regionsname besteht.
	log rohtext "Neuer Avatarname: $NEUERAVATARVORNAME $NEUERREGIONSNAME"
	echo " "
	log rohtext "Neuer Regionsname: $NEUERREGIONSNAME"
}

## * functionslist 
	# Durchsucht die angegebene Bash-Datei nach Funktionen und speichert die Ergebnisse in einer Datei.
	# Dieses Skript durchsucht die Datei "$STARTVERZEICHNIS/osmtool.sh" nach Funktionen,
	# die mit dem Suchbegriff "function" beginnen, und speichert die Ergebnisse in einer
	# Textdatei mit dem Namen "osmfunktion<DATEIDATUM>.txt" im angegebenen Verzeichnis.
	#? Verwendung:
	#   $ functionslist
	#? Abhängigkeiten:
	#   - Das Skript erfordert eine Umgebungsvariable "$STARTVERZEICHNIS", die auf das
	#     Verzeichnis verweist, in dem sich die zu durchsuchende Datei befindet.
	#   - Es erfordert auch die Umgebungsvariable "$DATEIDATUM" für die Dateinamengenerierung.
	#? Beispiel:
	#   $ export STARTVERZEICHNIS="/pfad/zum/verzeichnis"
	#   $ export DATEIDATUM="20231004"
	#   $ functionslist
	# Das Skript gibt eine Erfolgsmeldung aus und speichert die Ergebnisse in der
	# Datei "osmfunktion20231004.txt" im angegebenen Verzeichnis.
##
function functionslist() {
	# Definieren der Variablen für die Datei, die Suche und das Ergebnisfile
	local file="/$STARTVERZEICHNIS/osmtool.sh"
	local suche="function"
	local ergebnisfile="$STARTVERZEICHNIS/osmfunktionen$DATEIDATUM.txt"

	# Durchführen der Suche und Speichern der Ergebnisse in "$ergebnisfile"
	ergebnisflist=$(grep -i -r "$suche " $file)
	echo "$ergebnisflist" >/$STARTVERZEICHNIS/osmfunktion"$DATEIDATUM".txt
	log info "Funktionsliste erstellt."
}

## * remarklist
	# Funktionen eines Bash Skript inklusive 8 remark-Zeilen auslesen und in eine Text Datei schreiben.
	# Hilfreich fuer Handbuch und Hilfen.
	#? @param keine.
	#? @return datediff.
	# todo: nichts.
##
function remarklist() {
	# -A Zeile nach suchwort -- -B zeile vor suchwort -- -C zeile vor und nach suchwort
	file="/$STARTVERZEICHNIS/osmtool.sh"
	suche="function"
	ergebnisflist=$(grep -B9 -i -r "$suche " $file) # B8 Acht Zeilen vor dem Funktionsnamen.
	echo "$ergebnisflist" >/$STARTVERZEICHNIS/osmRemarklist"$DATEIDATUM".txt
}

## *  createmanual
	#? Beschreibung:
	# Diese Funktion erstellt eine Markdown-Datei, die die Dokumentation für den Code enthält.
	#? Parameter:
	# Keine
	#? Verwendungsbeispiel:
	# createmanual
	#? Abhängigkeiten:
	# Diese Funktion verwendet die Umgebungsvariable STARTVERZEICHNIS und DATEIDATUM.
	#? Ausgabe:
	# Die Funktion erstellt eine Markdown-Datei mit dem Namen "Manual_YYYYMMDD.md" im STARTVERZEICHNIS.
	#? Exit-Status:
	# 0 - Die Funktion wurde erfolgreich ausgeführt.
	# 1 - Ein Fehler ist aufgetreten.
##
function createmanual() {
    local file="/$STARTVERZEICHNIS/osmtool.sh"
    
    # Extrahiere den dokumentierten Code-Abschnitt zwischen den Markierungen '##' und '()' aus der Datei.
	#ergebnisflist=$(sed -ne '/##/,/()/p' $file)
	ergebnisflist=$(sed -ne '/##/,/()/ {/{/,/}/p}' $file)
	ergebnisflist=$(echo "$ergebnisflist" | sed '/^function /d')
    
    # Erzeuge die Ausgabedatei im STARTVERZEICHNIS mit dem aktuellen Datum als Teil des Dateinamens.
    echo "$ergebnisflist" >/$STARTVERZEICHNIS/Manual_"$DATEIDATUM".md
    
    # Prüfe den Erfolg der Ausführung und gebe entsprechenden Exit-Status zurück.
    if [ $? -eq 0 ]; then
        echo "Dokumentation erfolgreich erstellt."
        return 0
    else
        echo "Fehler beim Erstellen der Dokumentation."
        return 1
    fi
}

## *  trimm
	#? Beschreibung:
	# Diese Funktion entfernt führende und abschließende Leerzeichen aus den übergebenen
	# Zeichenketten und speichert das bereinigte Ergebnis in einer Variablen.
	#? Parameter:
	# $@ - Die Zeichenketten, die bereinigt werden sollen.
	#? Beispielaufruf:
	# trimm "   Hallo, Welt!   " "   Guten Tag   "
##
function trimm() {
	set -f
	# shellcheck disable=SC2086,SC2048
	set -- $*
	trimmvar=$(printf '%s\n' "$*")
	set +f
}

## *  osgitstatus
	#? Beschreibung:
	# Diese Funktion aktualisiert den OpenSim-Quellcode aus einem Git-Repository,
	# sofern verfügbar, und gibt Informationen über den Status des Upgrades aus.
	#? Parameter:
	# Keine Parameter erforderlich.
	#? Beispielaufruf:
	# osgitstatus
##
function osgitstatus() {
	# Letzte Bearbeitung 08.10.2023
	log info "OpenSim Sourcecode wird Upgegradet."
	# Verzeichnis, in dem sich das Git-Repository für OpenSim befindet
	cd /$STARTVERZEICHNIS/opensim || return 1
	log rohtext "  OpenSim ist: $(git pull)" || log rohtext "OpenSim kann nicht upgegradet werden."
	cd /$STARTVERZEICHNIS || return 0
}

## *  ende
	#? Beschreibung:
	# Diese Funktion beendet das aktuelle Skript und gibt die zuletzt gespeicherte
	# Meldung aus.
	#? Parameter:
	# Keine Parameter erforderlich.
	#? Rückgabewert:
	# Die Funktion beendet das Skript mit dem Rückgabewert der letzten Meldung.
	#? Beispielaufruf:
	# ende
##
function ende() {
	# Letzte Bearbeitung 26.09.2023
    return
    log info "$?"  # Das Skript beenden und die letzte Meldung ausgeben.
}

## *  fehler
	#? Beschreibung:
	# Diese Funktion beendet den aufrufenden Prozess und gibt die zuletzt
	# gespeicherte Meldung aus.
	#? Parameter:
	# Keine Parameter erforderlich.
	#? Rückgabewert:
	# Die Funktion beendet den aufrufenden Prozess mit dem Rückgabewert der letzten Meldung.
	#? Beispielaufruf:
	# fehler
##
function fehler() {
	# Letzte Bearbeitung 26.09.2023
    exit "$?"
    log error "$?"  # Den aufrufenden Prozess beenden und die letzte Meldung ausgeben.
}

## * letterdel.
	# Zeichen entfernen.
	# letterdel $variable "[aAbBcCdD]" - letterdel $variable "[[:space:]]"
	#? @param $variable $variable
	#? @return nichts wird zurueckgegeben.
	# todo: nichts.
##
function letterdel() {
	# letterdel $variable "[aAbBcCdD]" - letterdel $variable "[[:space:]]"
	printf '%s\n' "${1//$2/}"
}

## *  trim_string
	#? Beschreibung:
	# Diese Funktion entfernt führende und abschließende Leerzeichen aus einer
	# Zeichenkette und gibt das bereinigte Ergebnis aus.
	#? Parameter:
	# $1 - Die Zeichenkette, aus der die Leerzeichen entfernt werden sollen.
	#? Rückgabewert:
	# Die bereinigte Zeichenkette wird auf die Standardausgabe ausgegeben.
	#? Beispielaufruf:
	# trimmed_text=$(trim_string "   Hallo, Welt!   ")
	# Ergebnis: "Hallo, Welt!"
##
function trim_string() {
    : "${1#"${1%%[![:space:]]*}"}"
    : "${_%"${_##*[![:space:]]}"}"
    printf '%s\n' "$_"
}

## * vartest - Diese Funktion überprüft, ob eine Variable einen Wert hat oder leer ist.
	#? Verwendung: vartest VARIABLE
	#   - VARIABLE: Die zu überprüfende Variable
	#? Rückgabewert:
	#   - "true", wenn die Variable einen Wert hat
	#   - "false", wenn die Variable leer ist
	#? Beispielaufruf:
	# vartest "Hello, World!"
	# Dies wird "true" zurückgeben, da die Variable einen Wert hat.
##
function vartest() {
	# Letzte Bearbeitung 26.09.2023
    # Das übergebene Argument in die Variable VARIABLE speichern
    VARIABLE="$1"

    # Überprüfen, ob die Variable leer ist
    if [ -z "$VARIABLE" ]; then
        result="false"
    else
        result="true"
    fi

    # Den Ergebniswert ausgeben
    #echo "$result"
}

## * laeuftos 
	# Diese Funktion überprüft, ob ein Prozess mit dem angegebenen Namen läuft.
	#? Verwendung: laeuftos PROZESSNAME
	#   - PROZESSNAME: Der Name des Prozesses, der überprüft werden soll.
	# Diese Funktion überprüft, ob ein Prozess mit dem angegebenen PROZESSNAME bereits läuft.
	# Es wird sowohl nach einem Prozess mit .dotnet 6 als auch mit .NET 4.8 gesucht.
	#? Rückgabewerte:
	#   - "info": Der Prozess läuft bereits (mit .dotnet 6 oder .NET 4.8).
	#   - "warn": Der Prozess läuft nicht (mit .dotnet 6 oder .NET 4.8).
	#   - "error": Es gab ein Problem bei der Prozessüberprüfung.
	# todo: Nicht wirklich funktionsfähig.
##
function laeuftos() {
	# Letzte Bearbeitung 26.09.2023
    PROZESSNAME="$1"

    # Prüfen, ob der Prozess mit .dotnet 6 läuft
    if pgrep -f "$PROZESSNAME" > /dev/null; 
	then
        log info "$PROZESSNAME läuft mit .dotnet 6."
    fi

    # Prüfen, ob der Prozess mit .NET 4.8 läuft
    if pgrep -x "$PROZESSNAME" > /dev/null; 
	then
        log info "$PROZESSNAME läuft mit .NET 4.8."
    fi
}

## * trim_all 
	# Diese Funktion entfernt führende und nachfolgende Leerzeichen aus allen Argumenten und gibt das bereinigte Ergebnis zurück.
	#? Verwendung: trim_all [ARGUMENT1] [ARGUMENT2] ...
	#   - ARGUMENT1, ARGUMENT2, ...: Die Argumente, aus denen führende und nachfolgende Leerzeichen entfernt werden sollen.
	# Diese Funktion entfernt führende und nachfolgende Leerzeichen aus allen angegebenen Argumenten und gibt die bereinigten Ergebnisse zurück,
	# wobei jedes bereinigte Argument in einer separaten Zeile ausgegeben wird.
	#? Beispiel:
	#   trim_all "   Hallo  " "  Welt  "
	#? Ausgabe:
	#   "Hallo"
	#   "Welt"
##
function trim_all() {
	# Letzte Bearbeitung 26.09.2023

    # Aktiviert Optionen zum Splitten von Argumenten
    set -f

# shellcheck disable=SC2086,SC2048
    set -- $* # Speichert alle Argumente in $* und entfernt führende und nachfolgende Leerzeichen

	# Gibt die bereinigten Argumente in separaten Zeilen aus
    printf '%s\n' "$*"

	# Deaktiviert die Optionen zum Splitten von Argumenten
    set +f
}

## * iinstall 
	# Diese Funktion überprüft, ob ein Paket bereits installiert ist, und installiert es andernfalls.
	#? Verwendung: iinstall PAKETNAME
	#   - PAKETNAME: Der Name des Pakets, das installiert werden soll.
	# Diese Funktion überprüft, ob das angegebene PAKETNAME bereits installiert ist. Wenn es bereits installiert ist, wird eine Meldung ausgegeben.
	# Andernfalls wird versucht, das Paket mit sudo apt-get zu installieren.
	#? Parameter:
	#   - PAKETNAME: Der Name des Pakets, das installiert werden soll.
	#? Beispiel:
	#   iinstall "firefox"
	#   Überprüft, ob das Paket "firefox" installiert ist, und installiert es andernfalls.
##
function iinstall() {
	installation=$1
	# Überprüfen, ob das Paket bereits installiert ist
	if dpkg-query -s "$installation" 2>/dev/null | grep -q installed; then
		log rohtext "$installation ist bereits installiert."
	else
		log rohtext "Ich installiere jetzt $installation"
		sudo apt-get -y install "$installation"
	fi
}

## * iinstallnew 
	# Diese Funktion überprüft, ob ein Paket bereits installiert ist, und installiert es andernfalls.
	#? Verwendung: iinstallnew PAKETNAME
	#   - PAKETNAME: Der Name des Pakets, das installiert werden soll.
	# Diese Funktion überprüft, ob das angegebene PAKETNAME bereits installiert ist. Wenn es bereits installiert ist, wird eine Meldung ausgegeben.
	# Andernfalls wird versucht, das Paket mit sudo apt install zu installieren.
	#? Parameter:
	#   - PAKETNAME: Der Name des Pakets, das installiert werden soll.
	#? Beispiel:
	#   iinstallnew "firefox"
	#   Überprüft, ob das Paket "firefox" installiert ist, und installiert es andernfalls.
##
function iinstallnew() {
	installation=$1
	if dpkg-query -s "$installation" 2>/dev/null | grep -q installed; then
		log rohtext "$installation ist bereits installiert."
	else
		log rohtext "Ich installiere jetzt $installation"
		sudo apt install "$installation" -y
	fi
}

## * linuxupgrade 
	# Diese Funktion führt ein Systemupdate und ein System-Upgrade auf Ubuntu durch.
	#? Verwendung: linuxupgrade
	# Diese Funktion führt die Befehle "apt update" und "apt upgrade" aus, um das System zu aktualisieren.
	# Zuerst werden die Paketlisten aktualisiert, und dann werden verfügbare Aktualisierungen installiert.
	#? Hinweis: Die Ausführung dieses Befehls erfordert Root-Berechtigungen.
	#? Beispiel:
	#   linuxupgrade
	#   Führt ein Systemupdate und System-Upgrade auf dem Ubuntu-System aus.
##
function linuxupgrade() {
	# Letzte Bearbeitung 26.09.2023
    # Überprüfen, ob die Funktion mit Root-Berechtigungen ausgeführt wird.
    if [ "$EUID" -ne 0 ]; then
        echo "Fehler: Diese Funktion erfordert Root-Berechtigungen. Bitte führen Sie sie mit 'sudo' aus."
        return 1
    fi

    echo "Systemupdate wird durchgeführt..."
    # Aktualisiere die Paketlisten
    apt update

    # Führe ein System-Upgrade durch, um verfügbare Aktualisierungen zu installieren.
    echo "System-Upgrade wird durchgeführt..."
    apt upgrade -y

    echo "Systemupdate und System-Upgrade abgeschlossen."
}

## * deladvantagetools 
	# Diese Funktion entfernt das Paket "ubuntu-advantage-tools" von Ihrem Ubuntu-System.
	#? Verwendung: deladvantagetools
	# Diese Funktion führt den Befehl "sudo apt remove ubuntu-advantage-tools" aus, um das Paket
	# "ubuntu-advantage-tools" von Ihrem System zu entfernen. Dieses Paket ist ein kommerzielles
	# Dienstprogramm zur Systemverwaltung und kann bei Bedarf deinstalliert werden.
	#? Hinweis: Die Ausführung dieses Befehls erfordert Root-Berechtigungen.
	#? Beispiel:
	#   deladvantagetools
	#   Entfernt das Paket "ubuntu-advantage-tools" von Ihrem Ubuntu-System.
##
function deladvantagetools() {
	# Letzte Bearbeitung 26.09.2023
    # Überprüfen, ob die Funktion mit Root-Berechtigungen ausgeführt wird
    if [ "$EUID" -ne 0 ]; then
        echo "Fehler: Diese Funktion erfordert Root-Berechtigungen. Bitte führen Sie sie mit 'sudo' aus."
        return 1
    fi

    echo "Entferne das Paket 'ubuntu-advantage-tools'..."
    # Entfernen des Pakets ubuntu-advantage-tools
    sudo apt remove ubuntu-advantage-tools -y

    echo "Das Paket 'ubuntu-advantage-tools' wurde entfernt."
}

## * finstall 
	# Führt eine apt-get-Installationsroutine aus einer Textdatei durch.
	# Diese Funktion liest eine Textdatei, in der Paketnamen aufgeführt sind, und überprüft,
	# ob die Pakete bereits installiert sind. Wenn ein Paket nicht installiert ist, wird es
	# mithilfe von 'apt-get' installiert.
	#? @return Diese Funktion gibt nichts zurück, sondern installiert die angegebenen Pakete aus der
	# Textdatei, sofern sie nicht bereits installiert sind.
	#? Beispiel:
	#   finstall paketliste.txt
	# todo: nichts.
##
function finstall() {
	# Letzte Bearbeitung 26.09.2023
	TXTLISTE=$1

	while read -r txtline; do
		if dpkg-query -s "$txtline" 2>/dev/null | grep -q installed; then
			log rohtext "$txtline ist bereits installiert!"
		else
			log rohtext "Ich installiere jetzt: $txtline"
			sudo apt-get -y install "$txtline"
		fi
	done <"$TXTLISTE"
}

## * menufinstall 
	# Diese Funktion installiert Pakete aus einer Textdatei unter Verwendung des Dialog-Tools (wenn verfügbar).
	#? Verwendung: menufinstall TEXTDATEI
	#   - TEXTDATEI: Der Pfad zur Textdatei, die die Namen der zu installierenden Pakete enthält, jeweils in einer Zeile.
	# Diese Funktion überprüft zunächst, ob das Dialog-Tool auf dem System installiert ist.
	# Wenn Dialog installiert ist, wird ein Dialogfeld angezeigt, um den Benutzer zur Eingabe eines Bildschirmnamens aufzufordern.
	# Anschließend werden die aus der TEXTDATEI gelesenen Paketnamen angezeigt, und der Benutzer kann die Installation bestätigen.
	# Wenn Dialog nicht installiert ist, werden die Pakete ohne Dialogfenster installiert.
	#? Parameter:
	#   - TEXTDATEI: Der Pfad zur Textdatei, die die Paketnamen enthält.
	#? Hinweis: Die Ausführung dieses Befehls erfordert Root-Berechtigungen.
	#? Beispiel:
	#   menufinstall paketliste.txt
	#   Liest die Paketnamen aus der Datei "paketliste.txt" und installiert sie mithilfe des Dialog-Tools (falls verfügbar).
	# todo: nichts.
##
function menufinstall() {
	# Letzte Bearbeitung 26.09.2023
	TXTLISTE=$1
	# Überprüfen, ob Dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then
		# Alle Aktionen mit dialog
		boxtitel="opensimMULTITOOL Eingabe"
		boxtext="Screen Name:"
		TXTLISTE=$(dialog --backtitle "opensimMULTITOOL $VERSION" --title "$boxtitel" --inputbox "$boxtext" 8 40 3>&1 1>&2 2>&3 3>&-)
		dialogclear
		ScreenLog

		while read -r line; do
			if dpkg-query -s "$line" 2>/dev/null | grep -q installed; then
				log rohtext "$line ist bereits installiert!"
			else
				log rohtext "Ich installiere jetzt: $line"
				sudo apt-get -y install "$line"
			fi
		done <"$TXTLISTE"
	else
		# Alle Aktionen ohne dialog
		while read -r line; do
			if dpkg-query -s "$line" 2>/dev/null | grep -q installed; then
				log rohtext "$line ist bereits installiert!"
			else
				log rohtext "Ich installiere jetzt: $line"
				sudo apt-get -y install "$line"
			fi
		done <"$TXTLISTE"
	fi
}

## * uncompress 
	# Ermittelt den richtigen Entpackungsbefehl basierend auf dem Dateiformat.
	# Diese Funktion analysiert eine gegebene Datei und ermittelt, welches Kompressionsformat
	# verwendet wurde. Anschließend wird der entsprechende Entpackungsbefehl erzeugt und zurückgegeben.
	#? @param $datei - Die zu entpackende Datei oder Dateien im Raum getrennt.
	# @return $uncompress - Der erzeugte Entpackungsbefehl oder ein leerer String, wenn das Dateiformat
	# nicht erkannt wurde.
	#? Beispiel:
	#   uncompress datei.tar.gz    # Gibt "tar -xf" zurück.
	#   uncompress datei.zip       # Gibt "unzip -p" zurück.
	#   uncompress datei.txt       # Gibt einen leeren String zurück, da ASCII-Dateien nicht entpackt werden müssen.
	# todo: nichts.
##
function uncompress() {
	# Letzte Bearbeitung 27.09.2023
    datei=$1

    for file in $datei; do
        case $(file "$file") in
            *ASCII*)    export uncompress=""            ;;
            *gzip*)     export uncompress="gunzip"      ;;
            *zip*)      export uncompress="unzip -p"    ;;
            *7z*)       export uncompress="7z e"        ;;          
            *rar*)      export uncompress="unrar e"     ;;
            *tar.gz*)   export uncompress="tar -xf"     ;;
            *tar.bz2*)  export uncompress="tar -xjf"    ;;
            *tar.xz*)   export uncompress="tar -xJf"    ;;
            *bz2*)      export uncompress="bunzip2"     ;;
            *xz*)       export uncompress="unxz"        ;;
        esac
    done

    return $uncompress;
}

## * makeverzeichnisliste 
	# Eine Funktion zum Erstellen einer Liste von Verzeichnissen aus einer Datei.
	#? Verwendung: makeverzeichnisliste
	# Diese Funktion liest Zeilen aus der angegebenen SIMDATEI im STARTVERZEICHNIS und erstellt eine
	# Liste von Verzeichnissen. Die Liste wird in der globalen Variable VERZEICHNISSLISTE gespeichert.
	# Die Anzahl der Einträge in der Liste wird in der globalen Variable ANZAHLVERZEICHNISSLISTE gespeichert.
	#? Argumente:
	#   STARTVERZEICHNIS - Das Verzeichnis, in dem sich die SIMDATEI befindet.
	#   SIMDATEI - Die Datei, aus der die Verzeichnisse gelesen werden sollen.
	#? Beispielaufruf
	# makeverzeichnisliste
##
function makeverzeichnisliste() {
	# Letzte Bearbeitung 27.09.2023

    # Initialisieren der Verzeichnisliste
	VERZEICHNISSLISTE=()

	 # Schleife zum Lesen der Zeilen aus der SIMDATEI und Hinzufügen zum Array
	while IFS= read -r line; do
		VERZEICHNISSLISTE+=("$line")
	done </$STARTVERZEICHNIS/$SIMDATEI

	# Anzahl der Einträge in der Verzeichnisliste
	ANZAHLVERZEICHNISSLISTE=${#VERZEICHNISSLISTE[*]}

	# Erfolgreiche Ausführung
	return 0
}

## * makeregionsliste 
	# Eine Funktion zum Erstellen einer Liste von Regionen aus einer Datei.
	#? Verwendung: makeregionsliste
	# Diese Funktion liest Zeilen aus der angegebenen REGIONSDATEI im STARTVERZEICHNIS und erstellt eine
	# Liste von Regionen. Die Liste wird in der globalen Variable REGIONSLISTE gespeichert.
	# Die Anzahl der Einträge in der Liste wird in der globalen Variable ANZAHLREGIONSLISTE gespeichert.
	#? Argumente:
	#   STARTVERZEICHNIS - Das Verzeichnis, in dem sich die REGIONSDATEI befindet.
	#   REGIONSDATEI - Die Datei, aus der die Regionen gelesen werden sollen.
	#? Beispiel:
	# makeregionsliste
##
function makeregionsliste() {
	# Letzte Bearbeitung 27.09.2023

    # Initialisieren der Regionenliste
	REGIONSLISTE=()

	# Schleife zum Lesen der Zeilen aus der REGIONSDATEI und Hinzufügen zum Array
	while IFS= read -r line; do
		REGIONSLISTE+=("$line")
	done </$STARTVERZEICHNIS/$REGIONSDATEI

	# Anzahl der Einträge in der Regionenliste
	ANZAHLREGIONSLISTE=${#REGIONSLISTE[*]} # Anzahl der Eintraege.

	# Erfolgreiche Ausführung
	return 0
}

## * mysqlrest
	# Dies funktioniert nur mit mySQL.
	# Eine Funktion zum Ausführen von MySQL-Befehlen und Erfassen des Ergebnisses.
	#? Verwendung: mysqlrest <Benutzername> <Passwort> <Datenbankname> <MySQL-Befehl>
	# Diese Funktion führt den angegebenen MySQL-Befehl in der angegebenen Datenbank aus und erfasst das Ergebnis.
	# Das Ergebnis wird in der globalen Variable result_mysqlrest gespeichert.
	#? Argumente:
	#   Benutzername - Der MySQL-Benutzername für die Datenbankverbindung.
	#   Passwort - Das Passwort für die Datenbankverbindung.
	#   Datenbankname - Der Name der Datenbank, in der der Befehl ausgeführt werden soll.
	#   MySQL-Befehl - Der zu auszuführende MySQL-Befehl.
	#? Beispiel:
	# mysqlrest myuser mypassword mydb "SELECT * FROM mytable"
##
function mysqlrest() {
	# Letzte Bearbeitung 27.09.2023

    # Überprüfen, ob mysql-Client installiert ist # TODO Testen
    if ! command -v mysql &> /dev/null; then
        echo "mySQL ist nicht installiert. Bitte installieren Sie es zuerst."
        return 1
    fi

	# Überprüfen, ob alle erforderlichen Parameter vorhanden sind # TODO Testen
    if [ "$#" -ne 4 ]; then
        echo "Usage: mysqlrest <username> <password> <databasename> <mysqlcommand>"
        return 1
    fi

    # Übergeben der Argumente an Variablen
    username="$1"
    password="$2"
    databasename="$3"
    mysqlcommand="$4"

	# Überprüfen, ob die erforderlichen Variablen nicht leer sind # TODO Testen
    if [ -z "$username" ] || [ -z "$password" ] || [ -z "$databasename" ] || [ -z "$mysqlcommand" ]; then
        echo "All parameters must be provided and not empty."
        return 1
    fi

    # Ausführen des MySQL-Befehls und Erfassen des Ergebnisses
	result_mysqlrest=$(echo "$mysqlcommand;" | MYSQL_PWD=$password mysql -u"$username" "$databasename" -N) 2>/dev/null

	# Testausgabe des MySQL-Befehls
	#echo "$result_mysqlrest"
}

## * mariarest
	# Dies funktioniert nur mit MariaDB.
	# Eine Funktion zum Ausführen von MariaDB-Befehlen und Erfassen des Ergebnisses.
	#? Verwendung: mariarest <Benutzername> <Passwort> <Datenbankname> <MariaDB-Befehl>
	# Diese Funktion führt den angegebenen MariaDB-Befehl in der angegebenen Datenbank aus und erfasst das Ergebnis.
	# Das Ergebnis wird in der globalen Variable result_mariarest gespeichert.
	#? Argumente:
	#   Benutzername - Der MariaDB-Benutzername für die Datenbankverbindung.
	#   Passwort - Das Passwort für die Datenbankverbindung.
	#   Datenbankname - Der Name der Datenbank, in der der Befehl ausgeführt werden soll.
	#   MariaDB-Befehl - Der zu auszuführende MariaDB-Befehl.
	#? Beispiel:
	# mariarest myuser mypassword mydb "SELECT UUID FROM land"
	# mariarest myuser mypassword mydb "SELECT UUID, RegionUUID, LocalLandID, Name, Description, OwnerUUID, IsGroupOwned, Area, AuctionID, Category, ClaimDate, ClaimPrice, GroupUUID FROM land"
	# TODO : Blob Daten werden mit ausgegeben
##
function mariarest() {
	# Letzte Bearbeitung 12.11.2023

	# Überprüfen, ob MariaDB-Client installiert ist # TODO Testen OK
    if ! command -v mariadb &> /dev/null; then
        echo "Der MariaDB-Client ist nicht installiert. Bitte installieren Sie ihn zuerst."
        return 1
    fi

	# Überprüfen, ob alle erforderlichen Parameter vorhanden sind # TODO Testen OK
    if [ "$#" -ne 4 ]; then
        echo "Usage: mariarest <username> <password> <databasename> <mysqlcommand>"
        return 1
    fi

	# Übergeben der Argumente an Variablen
    username="$1"
    password="$2"
    databasename="$3"
    mariacommand="$4"

	# Überprüfen, ob die erforderlichen Variablen nicht leer sind
	if [ -z "$username" ]; then echo "Verwendung: mariarest <Benutzername> <Passwort> <Datenbankname> [Kommando]"; exit 1; fi
	if [ -z "$password" ]; then echo "Verwendung: mariarest <Benutzername> <Passwort> <Datenbankname> [Kommando]"; exit 1; fi
	if [ -z "$databasename" ]; then echo "Verwendung: mariarest <Benutzername> <Passwort> <Datenbankname> [Kommando]"; exit 1; fi
	if [ -z "$mariacommand" ]; then echo "Verwendung: mariarest <Benutzername> <Passwort> <Datenbankname> [Kommando]"; exit 1; fi

	# Überprüfen, ob die erforderlichen Variablen nicht leer sind # TODO Testen OK
    if [ -z "$username" ] || [ -z "$password" ] || [ -z "$databasename" ] || [ -z "$mariacommand" ]; then
        echo "All parameters must be provided and not empty."
        return 1
    fi

    # Ausführen des MariaDB-Befehls und Erfassen des Ergebnisses
	result_mariarest=$(echo "$mariacommand;" | MYSQL_PWD=$password mariadb -u"$username" "$databasename" -N) 2>/dev/null
	
	# Testausgabe des MySQL-Befehls
	#echo "$result_mariarest"
}

## * mysqlrestnodb 
	# Eine Funktion zum Ausführen von MySQL-Befehlen ohne Angabe einer Datenbank.
	#? Verwendung: mysqlrestnodb <Benutzername> <Passwort> <MySQL-Befehl>
	# Diese Funktion führt den angegebenen MySQL-Befehl ohne Angabe einer Datenbank aus und erfasst das Ergebnis.
	# Das Ergebnis wird in der globalen Variable result_mysqlrestnodb gespeichert.
	#? Argumente:
	#   Benutzername - Der MySQL-Benutzername für die Verbindung.
	#   Passwort - Das Passwort für die Verbindung.
	#   MySQL-Befehl - Der zu auszuführende MySQL-Befehl.
	#? Beispiel:
	# mysqlrestnodb myuser mypassword "SHOW DATABASES"
	# TODO Überarbeiten oder neu erstellen und das auch für mariaDB
##
function mysqlrestnodb() {
	# Letzte Bearbeitung 12.11.2023

    # Übergeben der Argumente an Variablen
    username="$1"
    password="$2"
    restnodbcommand="$3"

	# Überprüfen, ob die erforderlichen Variablen nicht leer sind
	if [ -z "$username" ]; then echo "Verwendung: mysqlrestnodb <Benutzername> <Passwort> [Kommando]"; exit 1; fi
	if [ -z "$password" ]; then echo "Verwendung: mysqlrestnodb <Benutzername> <Passwort> [Kommando]"; exit 1; fi
	if [ -z "$restnodbcommand" ]; then echo "Verwendung: mysqlrestnodb <Benutzername> <Passwort> [Kommando]"; exit 1; fi

	# Überprüfen, welches sql installiert ist und entsprechend aufrufen # TODO Testen OK
    if ! command -v mariadb &> /dev/null; then
		# Ausführen des mySQL-Befehls und Erfassen des Ergebnisses
        result_mysqlrest=$(echo "$restnodbcommand;" | MYSQL_PWD=$password mysql -u"$username" -N) 2>/dev/null
	else
		# Ausführen des MariaDB-Befehls und Erfassen des Ergebnisses
		result_mysqlrest=$(echo "$restnodbcommand;" | MYSQL_PWD=$password mariadb -u"$username" -N) 2>/dev/null
    fi

	# Testausgabe des MySQL-Befehls
	echo "$result_mysqlrest"
}

#──────────────────────────────────────────────────────────────────────────────────────────
#* Konfigurationen Funktionsgruppe
#──────────────────────────────────────────────────────────────────────────────────────────

## * instdialog 
	# Installiert das Dialog-Programm für interaktive Shell-Dialoge.
	#? Dokumentation:
	# Diese Funktion installiert das Dialog-Programm, das zur Erstellung interaktiver
	# Dialoge in der Shell verwendet wird. Sie führt zuerst ein Systemupdate und ein
	# Upgrade durch, um sicherzustellen, dass das System auf dem neuesten Stand ist.
	# Falls bei der Installation des Dialog-Programms Abhängigkeiten fehlen, werden
	# diese nachinstalliert. Schließlich wird Dialog installiert.
	#? @param keine.
	#? Beispiel:
	#   instdialog
##
function instdialog() {
	# Letzte Bearbeitung 27.09.2023
    log rohtext "Ich installiere jetzt dialog"
    
    # Systemupdate und Upgrade ausführen.
    sudo apt-get -y update
    sudo apt-get -y upgrade
    
    # Dialog-Programm installieren (erster Versuch).
    sudo apt-get -y install dialog

	# Warscheinlich ist die Installation fehlgeschlagen da abhängigkeiten fehlen.
	log rohtext "Die Installation von dialog ist wahrscheinlich fehlgeschlagen, da Abhängigkeiten fehlen."
	
	# Abhängigkeiten nachinstallieren und erneut versuchen.
	sudo apt-get -f install
	sudo apt-get -y install dialog

    # Nachricht über die erfolgreiche Installation von Dialog anzeigen.
    dialog --title 'Die erste Dialog Nachricht' --calendar 'Dialog wurde installiert am:' 0 0
    
    # Bildschirmausgabe löschen, inklusive dem Scrollbereich, sonst verwirrt es die meisten Menschen.
    tput reset
}

## * oswriteconfig 
	# Schreibt eine Konfiguration für eine Anwendung in einem GNU Screen-Fenster.
	#? Dokumentation:
	# Diese Funktion generiert einen Befehl zum Speichern einer Konfiguration und sendet ihn an ein
	# GNU Screen-Fenster, das der Anwendung zugeordnet ist. Dies ermöglicht das Aktualisieren oder
	# Speichern von Konfigurationsdaten in Echtzeit, ohne die Anwendung neu zu starten.
	#? @param $SETSIMULATOR - Der Name oder das Kennzeichen des GNU Screen-Fensters, in dem die  Konfiguration gespeichert werden soll.
	# todo: nichts.
##
function oswriteconfig() {
	# Letzte Bearbeitung 27.09.2023
    SETSIMULATOR=$1
    CONFIGWRITE="config save /$STARTVERZEICHNIS/$SETSIMULATOR.ini"

    # Senden des Konfigurationsbefehls an das angegebene GNU Screen-Fenster
    screen -S "$SETSIMULATOR" -p 0 -X eval "stuff '$CONFIGWRITE'^M"

    # Den erzeugten Befehl zur späteren Verwendung zurückgeben
    #echo "$CONFIGWRITE"
}

## * menuoswriteconfig 
	# Schreibt eine Konfiguration für eine Anwendung in einem GNU Screen-Fenster.
	#? Dokumentation:
	# Diese Funktion generiert einen Befehl zum Speichern einer Konfiguration und sendet ihn an ein
	# GNU Screen-Fenster, das der Anwendung zugeordnet ist. Dies ermöglicht das Aktualisieren oder
	# Speichern von Konfigurationsdaten in Echtzeit, ohne die Anwendung neu zu starten.
	#? @param $SETSIMULATOR - Der Name oder das Kennzeichen des GNU Screen-Fensters, in dem die  Konfiguration gespeichert werden soll.
	# todo: nichts.
##
function menuoswriteconfig() {
	# Letzte Bearbeitung 27.09.2023
	# OpenSimulator, Verzeichnis und Screen Name
	SETSIMULATOR=$1 

	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then
		# Alle Aktionen mit dialog
		boxtitel="opensimMULTITOOL Eingabe"
		boxtext="Screen Name:"
		SETSIMULATOR=$(dialog --backtitle "opensimMULTITOOL $VERSION" --title "$boxtitel" --inputbox "$boxtext" 8 40 3>&1 1>&2 2>&3 3>&-)
		dialogclear
		ScreenLog

		if ! screen -list | grep -q "$SETSIMULATOR"; then
			# es laeuft nicht
			dialog --backtitle "opensimMULTITOOL $VERSION" --msgbox "OpenSimulator $SETSIMULATOR OFFLINE!" 5 40
			dialogclear
			ScreenLog
		else
			# es laeuft Konfig schreiben
			CONFIGWRITE="config save /$STARTVERZEICHNIS/$SETSIMULATOR.ini"			
			screen -S "$SETSIMULATOR" -p 0 -X eval "stuff '$CONFIGWRITE'^M"
			sleep 1
			CONFIGREAD=$(sed '' "$SETSIMULATOR.ini")
			# # Konfig lesen
			dialog --backtitle "opensimMULTITOOL $VERSION" --msgbox "$CONFIGREAD" 0 0
			dialogclear
			ScreenLog
		fi
	else
		# Alle Aktionen ohne dialog
		if ! screen -list | grep -q "$SETSIMULATOR"; then
			# es laeuft nicht
			log info "WORKS: $SETSIMULATOR OFFLINE!"
			return 1
		else
			# es laeuft Konfig schreiben
			CONFIGWRITE="config save /$STARTVERZEICHNIS/$SETSIMULATOR.ini"
			screen -S "$SETSIMULATOR" -p 0 -X eval "stuff '$CONFIGWRITE'^M"
			return 0
		fi
	fi
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then hauptmenu; fi
}

## * osstarteintrag
	#? Dokumentation:
	# Diese Funktion fügt einen OpenSimulator-Eintrag zur Datei osmsimlist.ini hinzu
	# und sortiert die Datei anschließend. Sie erwartet einen Parameter: den OSEINTRAG,
	# der aus Verzeichnis und Screen Name besteht. Stellen Sie sicher, dass Sie den
	# Pfad zum Verzeichnis, in dem sich die Datei osmsimlist.ini befindet, in der
	# Variablen STARTVERZEICHNIS aktualisieren. Wenn die Datei oder der OSEINTRAG
	# nicht gefunden wird, gibt die Funktion einen Fehler aus.
	# Verwenden Sie die Funktion, indem Sie sie aufrufen und den OSEINTRAG als Argument übergeben.
	#? @param $1 OSEINTRAG - Der OpenSimulator-Eintrag (Verzeichnis und Screen Name).
	#? @return nichts wird zurueckgegeben.
	# todo: nichts.
##
function osstarteintrag() {
	# Letzte Bearbeitung 27.09.2023
	OSEINTRAG=$1 # OpenSimulator, Verzeichnis und Screen Name
	log info "OpenSimulator $OSEINTRAG wird der Datei $SIMDATEI hinzugefuegt!"

	sed -i '1s/.*$/'"$OSEINTRAG"'\n&/g' /"$STARTVERZEICHNIS"/$SIMDATEI
	sort /"$STARTVERZEICHNIS"/$SIMDATEI -o /"$STARTVERZEICHNIS"/$SIMDATEI
}

## * menuosstarteintrag
	#? Dokumentation:
	# Diese Funktion fügt einen OpenSimulator-Eintrag zur Datei osmsimlist.ini hinzu
	# und sortiert die Datei anschließend. Sie erwartet einen Parameter: den OSEINTRAG,
	# der aus Verzeichnis und Screen Name besteht. Stellen Sie sicher, dass Sie den
	# Pfad zum Verzeichnis, in dem sich die Datei osmsimlist.ini befindet, in der
	# Variablen STARTVERZEICHNIS aktualisieren. Wenn die Datei oder der OSEINTRAG
	# nicht gefunden wird, gibt die Funktion einen Fehler aus.
	# Verwenden Sie die Funktion, indem Sie sie aufrufen und den OSEINTRAG als Argument übergeben.
	#? @param $1 OSEINTRAG - Der OpenSimulator-Eintrag (Verzeichnis und Screen Name).
	#? @return nichts wird zurueckgegeben.
	# todo: nichts.
##
function menuosstarteintrag() {
	# Letzte Bearbeitung 27.09.2023
	MENUOSEINTRAG=$(
		dialog --backtitle "opensimMULTITOOL $VERSION" --title "opensimMULTITOOL Eingabe" \
			--inputbox "Simulator:" 8 40 \
			3>&1 1>&2 2>&3 3>&-
	)
	dialogclear
	ScreenLog

	log info "OpenSimulator $MENUOSEINTRAG wird der Datei $SIMDATEI hinzugefuegt!"

	sed -i '1s/.*$/'"$MENUOSEINTRAG"'\n&/g' /"$STARTVERZEICHNIS"/$SIMDATEI
	sort /"$STARTVERZEICHNIS"/$SIMDATEI -o /"$STARTVERZEICHNIS"/$SIMDATEI

	dateimenu
}

## * osstarteintragdel
	#? Dokumentation:
	# Diese Funktion ermöglicht das Entfernen eines OpenSimulator-Eintrags aus der Datei osmsimlist.ini und
	# die anschließende Sortierung der Datei. Der zu löschende Eintrag, bestehend aus Verzeichnis und
	# Screen Name, muss als Parameter an die Funktion übergeben werden.
	#? Beispiel:
	# osstarteintragdel "Pfad/zum/OpenSimulator ScreenName"
	#? Die Funktion führt verschiedene Überprüfungen durch, um sicherzustellen, dass der übergebene
	# Eintrag und die Datei osmsimlist.ini vorhanden sind. Wenn eines davon fehlt, wird ein Fehler
	# ausgegeben. Andernfalls wird der Eintrag aus der Datei entfernt, und die Datei wird sortiert.
	# Stellen Sie sicher, dass Sie den tatsächlichen Pfad zur Datei osmsimlist.ini in der Variable
	# SIMDATEI angeben.
	# todo: nichts.
##
function osstarteintragdel() {
	# Letzte Bearbeitung 27.09.2023
	OSEINTRAGDEL=$1 # OpenSimulator, Verzeichnis und Screen Name
	log info "OpenSimulator $OSEINTRAGDEL wird aus der Datei $SIMDATEI entfernt!"

	sed -i '/'"$OSEINTRAGDEL"'/d' /"$STARTVERZEICHNIS"/$SIMDATEI
	sort /"$STARTVERZEICHNIS"/$SIMDATEI -o /"$STARTVERZEICHNIS"/$SIMDATEI
}

## * menuosstarteintragdel
	#? Dokumentation:
	# Diese Funktion ermöglicht das Entfernen eines OpenSimulator-Eintrags aus der Datei osmsimlist.ini und
	# die anschließende Sortierung der Datei. Der zu löschende Eintrag, bestehend aus Verzeichnis und
	# Screen Name, muss als Parameter an die Funktion übergeben werden.
	#? Beispiel:
	# osstarteintragdel "Pfad/zum/OpenSimulator ScreenName"
	#? Die Funktion führt verschiedene Überprüfungen durch, um sicherzustellen, dass der übergebene
	# Eintrag und die Datei osmsimlist.ini vorhanden sind. Wenn eines davon fehlt, wird ein Fehler
	# ausgegeben. Andernfalls wird der Eintrag aus der Datei entfernt, und die Datei wird sortiert.
	# Stellen Sie sicher, dass Sie den tatsächlichen Pfad zur Datei osmsimlist.ini in der Variable
	# SIMDATEI angeben.
	# todo: nichts.
##
function menuosstarteintragdel() {
	# Letzte Bearbeitung 27.09.2023
	MENUOSEINTRAGDEL=$(
		dialog --backtitle "opensimMULTITOOL $VERSION" --title "opensimMULTITOOL Eingabe" \
			--inputbox "Simulator:" 8 40 \
			3>&1 1>&2 2>&3 3>&-
	)

	dialogclear
	ScreenLog

	log info "OpenSimulator $MENUOSEINTRAGDEL wird aus der Datei $SIMDATEI entfernt!"
	sed -i '/'"$MENUOSEINTRAGDEL"'/d' /"$STARTVERZEICHNIS"/$SIMDATEI
	sort /"$STARTVERZEICHNIS"/$SIMDATEI -o /"$STARTVERZEICHNIS"/$SIMDATEI

	dateimenu
}

## * osdauerstop 
	# Stoppt einen OpenSimulator-Server und entfernt ihn aus der Startliste.
	# Diese Funktion stoppt einen OpenSimulator-Server, der in einem GNU Screen-Prozess
	# läuft, und entfernt ihn aus der Liste der gestarteten Server. Der Name des Screens
	# wird als Argument übergeben.
	#? Parameter:
	#   $1 - Der Name des Screens, in dem der OpenSimulator-Server läuft.
	#? Rückgabewerte:
	#   0 - Erfolgreich beendet.
	#   1 - Der Screen wurde nicht gefunden.
	#? Beispiel:
	#   osdauerstop myopensim
	# todo: nichts.
##
function osdauerstop() {
	# Letzte Bearbeitung 27.09.2023
	OSDAUERSTOPSCREEN=$1
	# Überprüfen, ob der Screen existiert
	if screen -list | grep -q "$OSDAUERSTOPSCREEN"; then
		log warn "OpenSimulator $OSDAUERSTOPSCREEN Beenden und aus der Startliste loeschen!"
		osstarteintrag "$OSDAUERSTOPSCREEN"

		# Senden des Befehls zum Herunterfahren des OpenSimulator-Servers
		screen -S "$OSDAUERSTOPSCREEN" -p 0 -X eval "stuff 'shutdown'^M"
		sleep 10

		return 0
	else
		log error "OpenSimulator $OSDAUERSTOPSCREEN nicht vorhanden"
		osstarteintrag "$OSDAUERSTOPSCREEN"

		return 1
	fi

	# Optional: Starten des Hauptmenüs, wenn das Dialog-Paket installiert ist.
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then hauptmenu; fi
}

## * menuosdauerstop 
	# Stoppt einen OpenSimulator-Server und entfernt ihn aus der Startliste.
	# Diese Funktion stoppt einen OpenSimulator-Server, der in einem GNU Screen-Prozess
	# läuft, und entfernt ihn aus der Liste der gestarteten Server. Der Name des Screens
	# wird als Argument übergeben.
	#? Parameter:
	#   $1 - Der Name des Screens, in dem der OpenSimulator-Server läuft.
	#? Rückgabewerte:
	#   0 - Erfolgreich beendet.
	#   1 - Der Screen wurde nicht gefunden.
	#? Beispiel:
	#   osdauerstop myopensim
	# todo: nichts.
##
function menuosdauerstop() {
	# Letzte Bearbeitung 27.09.2023
	IOSDAUERSTOPSCREEN=$(
		dialog --backtitle "opensimMULTITOOL $VERSION" --title "opensimMULTITOOL Eingabe" \
			--inputbox "Simulator:" 8 40 \
			3>&1 1>&2 2>&3 3>&-
	)
	dialogclear
	ScreenLog

	if screen -list | grep -q "$IOSDAUERSTOPSCREEN"; then
		DIALOG=dialog
		(
			echo "10"
			screen -S "$IOSDAUERSTOPSCREEN" -p 0 -X eval "stuff 'shutdown'^M"
			osstarteintragdel "$IOSDAUERSTOPSCREEN"
			sleep 3
			echo "100"
			sleep 1
		) |
			$DIALOG --title "$IOSDAUERSTOPSCREEN" --gauge "Stop" 8 30
		dialogclear
		
		$DIALOG --msgbox "$IOSDAUERSTOPSCREEN beendet!" 5 20
		dialogclear
		ScreenLog
		osstarteintragdel "$IOSDAUERSTOPSCREEN"
		dateimenu
	else
		osstarteintragdel "$IOSDAUERSTOPSCREEN"
		dateimenu
	fi
}

## * osdauerstart.
	# Diese Funktion startet den OpenSimulator, wenn er nicht bereits läuft.
	#? Argumente:
	# $1: Der Name des OpenSimulator-Verzeichnisses und des Screens
	#? Rückgabewerte:
	# 0: Erfolgreich gestartet
	# 1: Fehler beim Start oder Verzeichnis nicht gefunden
	#? Beispielaufruf:
	# osdauerstart "MyOpenSim"
##
function osdauerstart() {
	# Letzte Bearbeitung 28.09.2023
	OSDAUERSTARTSCREEN=$1 # OpenSimulator, Verzeichnis und Screen Name
	osstarteintrag "$OSDAUERSTARTSCREEN"

	if ! screen -list | grep -q "$OSDAUERSTARTSCREEN"; then
		if [ -d "$OSDAUERSTARTSCREEN" ]; then

			cd /$STARTVERZEICHNIS/"$OSDAUERSTARTSCREEN"/bin || return 1

			# AOT Aktiveren oder Deaktivieren.
			if [[ $SETAOTON = "yes" ]]; then
				log info "OpenSimulator $OSDAUERSTARTSCREEN Starten mit aot"
				screen -fa -S "$OSDAUERSTARTSCREEN" -d -U -m mono --desktop -O=all OpenSim.exe
				return 0
				log info "OpenSimulator $OSDAUERSTARTSCREEN Starten"
				screen -fa -S "$OSDAUERSTARTSCREEN" -d -U -m mono OpenSim.exe
				return 0
			fi
			sleep 10
		else
			log error "OpenSimulator $OSDAUERSTARTSCREEN nicht vorhanden"
			return 1
		fi

	else
		# es laeuft - work
		log warn "OpenSimulator $OSDAUERSTARTSCREEN laeuft bereits"
		return 1
	fi

	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then hauptmenu; fi
}

## * menuosdauerstart.
	# Diese Funktion zeigt ein Dialogfeld an, um den OpenSimulator mit benutzerdefinierten Einstellungen zu starten.
	# Sie erfasst den Namen des Simulators und startet diesen, sofern er nicht bereits läuft.
	#? Argumente: Keine
	#? Rückgabewerte:
	# 0: Erfolgreich gestartet
	# 1: Fehler beim Start oder Verzeichnis nicht gefunden
	#? Beispielaufruf:
	# menuosdauerstart
##
function menuosdauerstart() {
	# Letzte Bearbeitung 28.09.2023
	IOSDAUERSTARTSCREEN=$(
		dialog --backtitle "opensimMULTITOOL $VERSION" --title "opensimMULTITOOL Eingabe" \
			--inputbox "Simulator:" 8 40 \
			3>&1 1>&2 2>&3 3>&-
	)

	dialogclear
	ScreenLog

	osstarteintrag "$IOSDAUERSTARTSCREEN"
	cd /$STARTVERZEICHNIS/"$IOSDAUERSTARTSCREEN"/bin || return 1
	screen -fa -S "$IOSDAUERSTARTSCREEN" -d -U -m mono OpenSim.exe

	if ! screen -list | grep -q "$IOSDAUERSTARTSCREEN"; then
		# es laeuft nicht - not work

		if [ -d "$IOSDAUERSTARTSCREEN" ]; then

			cd /$STARTVERZEICHNIS/"$IOSDAUERSTARTSCREEN"/bin || return 1

			# AOT Aktiveren oder Deaktivieren.
			if [[ $SETAOTON = "yes" ]]; then
				DIALOG=dialog
				(
					echo "10"
					screen -fa -S "$IOSDAUERSTARTSCREEN" -d -U -m mono --desktop -O=all OpenSim.exe
					sleep 3
					echo "100"
					sleep 1
				) 
				#|
				#$DIALOG --title "$IOSDAUERSTARTSCREEN" --gauge "Start" 8 30
				#$dialogclear
				#$DIALOG --msgbox "$IOSDAUERSTARTSCREEN gestartet!" 5 20
				#$dialogclear
				ScreenLog
				return 0
			else
				DIALOG=dialog
				(
					echo "10"
					screen -fa -S "$IOSDAUERSTARTSCREEN" -d -U -m mono OpenSim.exe
					sleep 3
					echo "100"
					sleep 1
				) #|
					#$DIALOG --title "$IOSDAUERSTARTSCREEN" --gauge "Start" 8 30
				#$dialogclear
				#$DIALOG --msgbox "$IOSDAUERSTARTSCREEN gestartet!" 5 20
				#$dialogclear
				ScreenLog
				dateimenu
			fi
		else
			log rohtext "OpenSimulator $IOSDAUERSTARTSCREEN nicht vorhanden"
			dateimenu
		fi
	else
		# es laeuft - work
		log error "OpenSimulator $IOSDAUERSTARTSCREEN laeuft bereits"
		dateimenu
	fi

}

## * ossettings.
	# Diese Funktion konfiguriert verschiedene Einstellungen für die Ausführung des OpenSimulators.
	#? Argumente: Keine
	#? Rückgabewerte:
	# 0: Erfolgreich abgeschlossen
	#? Beispielaufruf:
	# ossettings
##
function ossettings() {
	# Letzte Bearbeitung 28.09.2023
	log line
	# Hier kommen alle gewuenschten Einstellungen rein.
	# ulimit
	if [[ $SETULIMITON = "yes" ]]; then
		log info "Setze die Einstellung: ulimit -s 1048576"
		ulimit -s 1048576
	fi
	# MONO_THREADS_PER_CPU
	if [[ $SETMONOTHREADSON = "yes" ]]; then
		log info "Setze die Mono Threads auf $SETMONOTHREADS"
		MONO_THREADS_PER_CPU=$SETMONOTHREADS
		# Test 30.06.2022
		export MONO_THREADS_PER_CPU=$SETMONOTHREADS
		# MonoSetEnv MONO_THREADS_PER_CPU=$SETMONOTHREADS
	fi

	# MONO_GC_PARAMS
	if [[ $SETMONOGCPARAMSON1 = "yes" ]]; then
		log info "Setze die Einstellung: minor=split,promotion-age=14,nursery-size=64m"
		export MONO_GC_PARAMS="minor=split,promotion-age=14,nursery-size=64m"
	fi
	if [[ $SETMONOGCPARAMSON2 = "yes" ]]; then
		log info "Setze die Einstellung: promotion-age=14,"
		log info "minor=split,major=marksweep,no-lazy-sweep,alloc-ratio=50,"
		log info "nursery-size=64m"

		# Test 26.02.2022
		export MONO_GC_PARAMS="promotion-age=14,minor=split,major=marksweep,no-lazy-sweep,alloc-ratio=50,nursery-size=64m"
		export MONO_GC_DEBUG=""
		export MONO_ENV_OPTIONS="--desktop"
	fi
	return 0
}

#──────────────────────────────────────────────────────────────────────────────────────────
#* Log und Cache Dateien Funktionsgruppe
#──────────────────────────────────────────────────────────────────────────────────────────

## * ScreenLog.
	# Diese Funktion steuert die Darstellung und das Löschen der Bildschirmausgabe basierend auf dem Wert von ScreenLogLevel.
	#? Argumente: Keine
	#? Rückgabewerte:
	# 0: Erfolgreich abgeschlossen
	#? Beispielaufruf:
	# ScreenLog
##
function ScreenLog() {
	# Letzte Bearbeitung 28.09.2023
	if (( ScreenLogLevel == 1 )); then
		clear # Bildschirmausgabe loeschen Scrollbereich bleibt zum ueberpruefen.
	fi	
	if (( ScreenLogLevel == 2 )); then
		reset # Bildschirmausgabe loeschen inklusive dem Scrollbereich.
	fi
	if (( ScreenLogLevel == 3 )); then
		tput reset # Bildschirmausgabe loeschen inklusive dem Scrollbereich (schneller).
	fi
	if (( ScreenLogLevel == 4 )); then
		printf '\e[3J' # Bildschirmausgabe sauber loeschen inklusive dem Scrollbereich.
	fi
	if (( ScreenLogLevel == 5 )); then
		MYFUNCNAME=${FUNCNAME[0]};
		echo "$MYFUNCNAME" # Funktionsname mit ausgeben.
	fi
	unset MYFUNCNAME
	return 0
}

## * dialogclear.
	# Diese Funktion löscht das aktuelle Dialogfeld im Terminal, um eine saubere Oberfläche für weitere Dialoge oder Ausgaben zu ermöglichen.
	#? Argumente: Keine
	#? Rückgabewerte:
	# 0: Erfolgreich abgeschlossen
	#? Beispielaufruf:
	# dialogclear
##
function dialogclear() {
	# Letzte Bearbeitung 28.09.2023
	dialog --clear
	return 0
}

## * clearuserlist.
	# Diese Funktion löscht die Besucherlisten-Protokolldateien im angegebenen Verzeichnis.
	#? Argumente: Keine
	#? Rückgabewerte: Keine
	#? Beispielaufruf:
	# clearuserlist
##
function clearuserlist() {
    # Letzte Bearbeitung 28.09.2023
    log rohtext "Lösche Besucherlisten log"
    
    # Lösche alle Dateien, die mit "_osmvisitorlist.log" enden, im angegebenen Verzeichnis.
    rm -r "/$STARTVERZEICHNIS"/*_osmvisitorlist.log

    log rohtext "Lösche Besucherlisten txt"

    # Lösche alle Dateien, die mit "_osmvisitorlist.txt" enden, im angegebenen Verzeichnis.
    rm -r "/$STARTVERZEICHNIS"/*_osmvisitorlist.txt
}

## * historylogclear.
	# Diese Funktion löscht Log-Dateien oder die Verlaufshistorie basierend auf dem übergebenen Argument.
	#? Argumente:
	# $1: Der Name des zu löschenden Logs oder der Verlaufshistorie (z. B. "history", "apache2error", "mysqlerror", "mysqlmariadb").
	#? Rückgabewerte: Keine
	#? Beispielaufruf:
	# historylogclear "history"
##
function historylogclear() {
	# Letzte Bearbeitung 28.09.2023
	hlclear=$1
	case $hlclear in
		history) 
		history -cw; history -c; history -w
		;;
		apache2error) 
			echo "" >$apache2errorlog  
		;;
		mysqlerror) 
			echo "" >$mysqlerrorlog  
		;;
		mysqlmariadb) 
			echo "" >$mysqlmariadberor  
		;;
		*) 
			log info "  Nur das loeschen von history, apache2error, mysqlerror,"
			log info "  und mysqlmariadb Error Log Dateien ist zur Zeit moeglich!"
		;;
	esac
}

#──────────────────────────────────────────────────────────────────────────────────────────
#* Bildschirmausgaben Funktionsgruppe
#──────────────────────────────────────────────────────────────────────────────────────────

## * lastrebootdatum.
	# Diese Funktion ermittelt das Datum des letzten Server-Neustarts und berechnet die Anzahl der Tage seit dem letzten Neustart.
	#? Argumente: Keine
	#? Rückgabewerte:
	# 0: Erfolgreich abgeschlossen, gibt die Anzahl der Tage seit dem letzten Neustart zurück
	#? Beispielaufruf:
	# lastrebootdatum
##
function lastrebootdatum() {
	# Letzte Bearbeitung 28.09.2023
    HEUTEDATUM=$(date +%Y-%m-%d) # Aktuelles Datum

    # Parsen: system boot  2021-11-30 14:26
    LETZTERREBOOT=$(who -b | awk -F' ' '{print $3}' | xargs) # Datum des letzten Neustarts

    # Berechnung der Differenz in Tagen zwischen heute und dem letzten Neustart
    first_date=$(date -d "$HEUTEDATUM" "+%s")
    second_date=$(date -d "$LETZTERREBOOT" "+%s")
    EINST="-d" # Manuelle Auswahl umgehen.
    case "$EINST" in
        "--seconds" | "-s") period=1 ;;
        "--minutes" | "-m") period=60 ;;
        "--hours" | "-h") period=$((60 * 60)) ;;
        "--days" | "-d" | "") period=$((60 * 60 * 24)) ;;
    esac
    datediff=$((("$first_date" - "$second_date") / "$period"))

    # Erstellen einer Meldung basierend auf der Anzahl der Tage seit dem letzten Neustart
    lastrebootdatuminfo="Sie haben vor $datediff Tag(en) Ihren Server neu gestartet"

    # Log-Meldung ausgeben, je nachdem, ob der letzte Neustart länger als 30 Tage her ist oder nicht
    if (( $(echo "${datediff} >= 30") )); then
        log warn "$lastrebootdatuminfo"
    else
        log info "$lastrebootdatuminfo"
    fi

    return $datediff
}


## * schreibeinfo.
	# Diese Funktion erstellt eine Informationsausgabe mit verschiedenen Systeminformationen und schreibt sie in eine Log-Datei, wenn die Log-Funktion aktiviert ist.
	#? Argumente: Keine
	#? Rückgabewerte: Keine
	#? Beispielaufruf:
	# schreibeinfo
##
function schreibeinfo() {
	# Letzte Bearbeitung 28.09.2023
	# Wenn die Log Datei nicht existiert muss sie erstellt werden sonst gibt es eine Fehlermeldung.
	if [ "$LOGWRITE" = "yes" ]; then
		if [ -f /$STARTVERZEICHNIS/"$DATEIDATUM""$logfilename".log ]; then
			# echo "/$STARTVERZEICHNIS/$DATEIDATUM$logfilename.log ist vorhanden!"
			echo " "
		else
			# echo "/$STARTVERZEICHNIS/$DATEIDATUM$logfilename.log ist nicht vorhanden und wird jetzt angelegt!"
			echo " " >/$STARTVERZEICHNIS/"$DATEIDATUM""$logfilename".log
		fi
	fi
		echo "   ____                        _____  _                    _         _               "
		echo "  / __ \                      / ____|(_)                  | |       | |              "
		echo " | |  | | _ __    ___  _ __  | (___   _  _ __ ___   _   _ | |  __ _ | |_  ___   _ __ "
		echo " | |  | ||  _ \  / _ \|  _ \  \___ \ | ||  _   _ \ | | | || | / _  || __|/ _ \ |  __|"
		echo " | |__| || |_) ||  __/| | | | ____) || || | | | | || |_| || || (_| || |_| (_) || |   "
		echo "  \____/ |  __/  \___||_| |_||_____/ |_||_| |_| |_| \____||_| \____| \__|\___/ |_|   "
		echo "         | |                                                                         "
		echo "         |_|                                                                         "
		echo "            $(tput setaf 0) $(tput setab 6)$SCRIPTNAME $VERSION $(tput sgr 0)"
		echo " "
		log line
		log rohtext "  $DATUM $(date +%H:%M:%S) MULTITOOL: wurde gestartet am $(date +%d.%m.%Y) um $(date +%H:%M:%S) Uhr"
		log rohtext "  $DATUM $(date +%H:%M:%S) INFO: Server Name: ${HOSTNAME}"
		log rohtext "  $DATUM $(date +%H:%M:%S) INFO: Server IP: ${AKTUELLEIP}"
		log rohtext "  $DATUM $(date +%H:%M:%S) INFO: Linux Version: $ubuntuDescription"
		log rohtext "  $DATUM $(date +%H:%M:%S) INFO: Release Nummer: $ubuntuRelease"
		log rohtext "  $DATUM $(date +%H:%M:%S) INFO: Linux Name: $ubuntuCodename"
		log rohtext "  $DATUM $(date +%H:%M:%S) INFO: Bash Version: ${BASH_VERSION}"
		log rohtext "  $DATUM $(date +%H:%M:%S) INFO: MONO THREAD Einstellung: ${MONO_THREADS_PER_CPU}"
		dotnetversion=$(dotnet --version);
		log rohtext "  $DATUM $(date +%H:%M:%S) INFO: DOTNET Version: ${dotnetversion}"
		log rohtext "  $DATUM $(date +%H:%M:%S) INFO: Spracheinstellung: ${LANG}"
		log rohtext "  $DATUM $(date +%H:%M:%S) INFO: $(screen --version)"
		SYSTEMBOOT=$(who -b);
		trimm $SYSTEMBOOT;
		log rohtext "  $DATUM $(date +%H:%M:%S) INFO: $trimmvar"
		log rohtext "  $DATUM $(date +%H:%M:%S) INFO: $SQLVERSION"
		lastrebootdatum
		log line
	return 0
}

# *Kopfzeile in die Log Datei schreiben.
schreibeinfo

## * rebootdatum
	# Ermittelt das Datum des letzten Systemneustarts und informiert den Benutzer über die vergangene Zeit seit dem letzten Neustart.
	#? Beschreibung:
	# Die Funktion rebootdatum ermittelt das Datum des letzten Systemneustarts
	# und zeigt dem Benutzer die vergangene Zeit seit dem letzten Neustart an.
	#? Parameter:
	# Es sind keine Parameter erforderlich.
	#? Rückgabe:
	# Diese Funktion gibt nichts zurück.
##
function rebootdatum() {
	# Letzte Bearbeitung 28.09.2023
	HEUTEDATUM=$(date +%Y-%m-%d) # Heute

	# Parsen: system boot  2021-11-30 14:26
	# Trim = | xargs
	LETZTERREBOOT=$(who -b | awk -F' ' '{print $3}' | xargs) # Letzter Reboot

	# Tolles Datum Script
	first_date=$(date -d "$HEUTEDATUM" "+%s")
	second_date=$(date -d "$LETZTERREBOOT" "+%s")
	EINST="-d" # Manuelle auswahl umgehen.
	case "$EINST" in
	"--seconds" | "-s") period=1 ;;
	"--minutes" | "-m") period=60 ;;
	"--hours" | "-h") period=$((60 * 60)) ;;
	"--days" | "-d" | "") period=$((60 * 60 * 24)) ;;
	esac
	datediff=$((("$first_date" - "$second_date") / ("$period")))

	dialog --args --yesno "Sie haben vor $datediff Tag(en)\nihren Server neu gestartet\n\nMoechten sie jetzt neu starten?" 10 45

	antwort=$?

	# Alles loeschen.
	dialogclear
	ScreenLog

	# Auswertung Ja / Nein
	if [ $antwort = 0 ]; then
		# Ja herunterfahren von Robust und OpenSim anschliessend ein Server Reboot ausfuehren.
		autostop
		shutdown -r now
		#reboot now -y
	else
		# Nein
		hauptmenu
	fi
	return 0
}

## *  reboot
	#? Beschreibung: 
	# Startet den Server neu.
	#? Parameter: Keine.
	#? Rückgabewert: Es wird nichts zurückgegeben.
	#? Aufgaben: 
	# 1. Loggt eine Meldung, dass der Server heruntergefahren und neu gestartet wird.
	# 2. Führt die Funktion 'autostop' aus, falls vorhanden.
	# 3. Führt den Befehl 'shutdown -r now' aus, um den Server neu zu starten.
##
function reboot() {
	# Letzte Bearbeitung 29.09.2023
    log rohtext "Server wird jetzt heruntergefahren und neu gestartet!"
    
    # Überprüfe, ob die Funktion 'autostop' vorhanden ist und führe sie aus.
    autostop

    # Starte den Server neu.
    shutdown -r now
}

## *  warnbox
	#? Beschreibung: Zeigt eine Warnmeldung in einem Dialogfeld an.
	#? Parameter:
	#   $1 (Erforderlich) - Die Warnmeldung, die im Dialogfeld angezeigt werden soll.
	#? Rückgabewert: Es wird nichts zurückgegeben.
	#? Aufgaben:
	# 1. Zeigt eine Warnmeldung im Dialogfeld an, die durch den übergebenen Parameter definiert ist.
	# 2. Die Parameter "0 0" werden verwendet, um die Größe des Dialogfelds automatisch anzupassen.
	# 3. Löscht den Dialogbildschirm, nachdem das Dialogfeld geschlossen wurde.
	# 4. Ruft die Funktion 'ScreenLog' auf, um die Bildschirmausgabe zu protokollieren.
	# 5. Ruft die Funktion 'hauptmenu' auf, um zum Hauptmenü zurückzukehren.
##
function warnbox() {
	# Letzte Bearbeitung 29.09.2023
    # Zeigt eine Warnmeldung im Dialogfeld an.
    dialog --msgbox "$1" 0 0

    # Löscht den Dialogbildschirm.
    dialogclear

    # Protokolliert die Bildschirmausgabe.
    ScreenLog

    # Ruft die Hauptmenü-Funktion auf.
    hauptmenu
}

## *  edittextbox
	#? Beschreibung: Öffnet eine Textdatei in einem Editor und ermöglicht deren Bearbeitung.
	#? Parameter:
	#   $1 (Erforderlich) - Der Pfad zur Textdatei, die bearbeitet werden soll.
	#? Rückgabewert: Es wird nichts zurückgegeben.
	#? Aufgaben:
	# 1. Öffnet die angegebene Textdatei in einem Editor-Dialogfeld zur Bearbeitung.
	# 2. Die Parameter "0 0" werden verwendet, um die Größe des Dialogfelds automatisch anzupassen.
	# 3. Löscht den Dialogbildschirm, nachdem der Editor geschlossen wurde.
	# 4. Protokolliert die Bildschirmausgabe mithilfe der Funktion 'ScreenLog'.
	# 5. Ruft die Hauptmenü-Funktion 'hauptmenu' auf, um zum Hauptmenü zurückzukehren.
##
function edittextbox() {
	# Letzte Bearbeitung 29.09.2023
    # Öffnet die angegebene Textdatei in einem Editor-Dialogfeld zur Bearbeitung.
    dialog --editbox "$1" 0 0

    # Löscht den Dialogbildschirm.
    dialogclear

    # Protokolliert die Bildschirmausgabe.
    ScreenLog

    # Ruft die Hauptmenü-Funktion auf.
    hauptmenu
}


## *  textbox
	#? Beschreibung: Zeigt den Inhalt einer Textdatei in einem Dialogfeld an.
	#? Parameter:
	#   $1 (Erforderlich) - Der Pfad zur Textdatei, deren Inhalt angezeigt werden soll.
	#? Rückgabewert: Es wird nichts zurückgegeben.
	#? Aufgaben:
	# 1. Öffnet ein Dialogfeld, um den Inhalt der angegebenen Textdatei anzuzeigen.
	# 2. Die Parameter "0 0" werden verwendet, um die Größe des Dialogfelds automatisch anzupassen.
	# 3. Löscht den Dialogbildschirm, nachdem das Dialogfeld geschlossen wurde.
	# 4. Ruft die Funktion 'ScreenLog' auf, um die Bildschirmausgabe zu protokollieren.
	# 5. Ruft die Funktion 'hauptmenu' auf, um zum Hauptmenü zurückzukehren.
##
function textbox() {
	# Letzte Bearbeitung 29.09.2023
    # Öffnet ein Dialogfeld, um den Inhalt der angegebenen Textdatei anzuzeigen.
    dialog --textbox "$1" 0 0

    # Löscht den Dialogbildschirm.
    dialogclear

    # Protokolliert die Bildschirmausgabe.
    ScreenLog

    # Ruft die Hauptmenü-Funktion auf.
    hauptmenu
}

## *  nachrichtbox
	#? Beschreibung: Zeigt eine Benachrichtigungsnachricht in einem Dialogfeld an.
	#? Parameter:
	#   $1 (Erforderlich) - Der Titel für das Benachrichtigungsfenster.
	#   $result (Erforderlich) - Der Text der Benachrichtigungsnachricht.
	#? Rückgabewert: Es wird nichts zurückgegeben.
	#? Aufgaben:
	# 1. Öffnet ein Dialogfeld mit dem angegebenen Titel und zeigt die Benachrichtigungsnachricht an.
	# 2. Verwendet die Parameter "0 0", um die Größe des Dialogfelds automatisch anzupassen und ein Kollabieren zu verhindern.
	# 3. Ruft die Hauptmenü-Funktion 'hauptmenu' auf, um zum Hauptmenü zurückzukehren.
##
function nachrichtbox() {
	# Letzte Bearbeitung 29.09.2023
    # Öffnet ein Dialogfeld mit dem angegebenen Titel und zeigt die Benachrichtigungsnachricht an.
    dialog --title "$1" --no-collapse --msgbox "$result" 0 0

    # Ruft die Hauptmenü-Funktion auf.
    hauptmenu
}

## *  apacheerror
	#? Beschreibung: Zeigt den Inhalt der Apache2-Fehlerprotokolldatei an, falls vorhanden.
	#? Parameter: Keine.
	#? Rückgabewert: Es wird nichts zurückgegeben.
	#? Aufgaben:
	# 1. Überprüft, ob die Apache2-Fehlerprotokolldatei ($apache2errorlog) vorhanden ist.
	# 2. Falls die Datei existiert, öffnet sie in einem Textbearbeitungsdialog mit der Funktion 'textbox'.
	# 3. Falls die Datei nicht gefunden wird, wird eine Warnmeldung mit 'warnbox' angezeigt.
##
function apacheerror() {
	# Letzte Bearbeitung 29.09.2023
    # Überprüft, ob die Apache2-Fehlerprotokolldatei ($apache2errorlog) vorhanden ist.
    if [ -f "$apache2errorlog" ]; then
        # Öffnet die Fehlerprotokolldatei in einem Textbearbeitungsdialog.
        textbox "$apache2errorlog"
    else
        # Zeigt eine Warnung an, wenn die Datei nicht gefunden wurde.
        warnbox "$apache2errorlog Datei nicht gefunden!"
    fi
}

## *  mysqldberror
	#? Beschreibung: Zeigt den Inhalt der MySQL-Datenbankfehlerprotokolldatei an, falls vorhanden.
	#? Parameter: Keine.
	#? Rückgabewert: Es wird nichts zurückgegeben.
	#? Aufgaben:
	# 1. Überprüft, ob die MySQL-Datenbankfehlerprotokolldatei ($mysqlerrorlog) vorhanden ist.
	# 2. Falls die Datei existiert, öffnet sie in einem Textbearbeitungsdialog mit der Funktion 'textbox'.
	# 3. Falls die Datei nicht gefunden wird, wird eine Warnmeldung mit 'warnbox' angezeigt.
##
function mysqldberror() {
	# Letzte Bearbeitung 29.09.2023
    # Überprüft, ob die MySQL-Datenbankfehlerprotokolldatei ($mysqlerrorlog) vorhanden ist.
    if [ -f "$mysqlerrorlog" ]; then
        # Öffnet die Datenbankfehlerprotokolldatei in einem Textbearbeitungsdialog.
        textbox "$mysqlerrorlog"
    else
        # Zeigt eine Warnung an, wenn die Datei nicht gefunden wurde.
        warnbox "$mysqlerrorlog Datei nicht gefunden!"
    fi
}

## *  mariadberror
	#? Beschreibung: Zeigt den Inhalt der MariaDB-/MySQL-Datenbankfehlerprotokolldatei an, falls vorhanden.
	#? Parameter: Keine.
	#? Rückgabewert: Es wird nichts zurückgegeben.
	#? Aufgaben:
	# 1. Überprüft, ob die MariaDB-/MySQL-Datenbankfehlerprotokolldatei ($mysqlmariadberor) vorhanden ist.
	# 2. Falls die Datei existiert, öffnet sie in einem Textbearbeitungsdialog mit der Funktion 'textbox'.
	# 3. Falls die Datei nicht gefunden wird, wird eine Warnmeldung mit 'warnbox' angezeigt.
##
function mariadberror() {
	# Letzte Bearbeitung 29.09.2023
    # Überprüft, ob die MariaDB-/MySQL-Datenbankfehlerprotokolldatei ($mysqlmariadberor) vorhanden ist.
    if [ -f "$mysqlmariadberor" ]; then
        # Öffnet die MariaDB-/MySQL-Datenbankfehlerprotokolldatei in einem Textbearbeitungsdialog.
        textbox "$mysqlmariadberor"
    else
        # Zeigt eine Warnung an, wenn die Datei nicht gefunden wurde.
        warnbox "$mysqlmariadberor Datei nicht gefunden!"
    fi
}

## *  ufwlog
	#? Beschreibung: Zeigt den Inhalt der UFW-Protokolldatei an, falls vorhanden.
	#? Parameter: Keine.
	#? Rückgabewert: Es wird nichts zurückgegeben.
	#? Aufgaben:
	# 1. Überprüft, ob die UFW-Protokolldatei ($ufwlog) vorhanden ist.
	# 2. Falls die Datei existiert, öffnet sie in einem Textbearbeitungsdialog mit der Funktion 'textbox'.
	# 3. Falls die Datei nicht gefunden wird, wird eine Warnmeldung mit 'warnbox' angezeigt.
##
function ufwlog() {
	# Letzte Bearbeitung 29.09.2023
    # Überprüft, ob die UFW-Protokolldatei ($ufwlog) vorhanden ist.
    if [ -f "$ufwlog" ]; then
        # Öffnet die UFW-Protokolldatei in einem Textbearbeitungsdialog.
        textbox "$ufwlog"
    else
        # Zeigt eine Warnung an, wenn die Datei nicht gefunden wurde.
        warnbox "$ufwlog Datei nicht gefunden!"
    fi
}

## *  authlog
	#? Beschreibung: Zeigt den Inhalt der Authentifizierungs-Protokolldatei an, falls vorhanden.
	#? Parameter: Keine.
	#? Rückgabewert: Es wird nichts zurückgegeben.
	#? Aufgaben:
	# 1. Überprüft, ob die Authentifizierungs-Protokolldatei ($authlog) vorhanden ist.
	# 2. Falls die Datei existiert, öffnet sie in einem Textbearbeitungsdialog mit der Funktion 'textbox'.
	# 3. Falls die Datei nicht gefunden wird, wird eine Warnmeldung mit 'warnbox' angezeigt.
##
function authlog() {
	# Letzte Bearbeitung 29.09.2023
    # Überprüft, ob die Authentifizierungs-Protokolldatei ($authlog) vorhanden ist.
    if [ -f "$authlog" ]; then
        # Öffnet die Authentifizierungs-Protokolldatei in einem Textbearbeitungsdialog.
        textbox "$authlog"
    else
        # Zeigt eine Warnung an, wenn die Datei nicht gefunden wurde.
        warnbox "$authlog Datei nicht gefunden!"
    fi
}

## *  accesslog
	#? Beschreibung: Zeigt den Inhalt des Apache2-Zugriffsprotokolls an, falls vorhanden.
	#? Parameter: Keine.
	#? Rückgabewert: Es wird nichts zurückgegeben.
	#? Aufgaben:
	# 1. Überprüft, ob das Apache2-Zugriffsprotokoll ($apache2accesslog) vorhanden ist.
	# 2. Falls die Datei existiert, öffnet sie in einem Textbearbeitungsdialog mit der Funktion 'textbox'.
	# 3. Falls die Datei nicht gefunden wird, wird eine Warnmeldung mit 'warnbox' angezeigt.
##
function accesslog() {
	# Letzte Bearbeitung 29.09.2023
    # Überprüft, ob das Apache2-Zugriffsprotokoll ($apache2accesslog) vorhanden ist.
    if [ -f "$apache2accesslog" ]; then
        # Öffnet das Apache2-Zugriffsprotokoll in einem Textbearbeitungsdialog.
        textbox "$apache2accesslog"
    else
        # Zeigt eine Warnung an, wenn die Datei nicht gefunden wurde.
        warnbox "$apache2accesslog Datei nicht gefunden!"
    fi
}

## *  fpspeicher
	#? Beschreibung: Ermittelt den verfügbaren Speicherplatz auf dem Dateisystem und zeigt ihn in einer Nachrichtenbox an.
	#? Parameter: Keine.
	#? Rückgabewert: Es wird nichts zurückgegeben.
	#? Aufgaben:
	# 1. Verwendet den Befehl 'df -h', um Informationen über den verfügbaren Speicherplatz abzurufen.
	# 2. Speichert das Ergebnis in der Variablen 'result'.
	# 3. Öffnet eine Nachrichtenbox mit dem Titel "Freier Speicher" und zeigt den gespeicherten Speicherplatz in 'result' an.
##
function fpspeicher() {
	# Letzte Bearbeitung 29.09.2023
    result=$(df -h)
    nachrichtbox "Freier Speicher"
}

## *  screenlist
	#? Beschreibung: Zeigt eine Liste aller laufenden Screen-Sitzungen an, entweder mit oder ohne die Verwendung von 'dialog'.
	#? Parameter: Keine.
	#? Rückgabewert: Es wird nichts zurückgegeben.
	#? Aufgaben:
	# 1. Protokolliert eine Informationsmeldung über das Anzeigen aller laufenden Screen-Sitzungen.
	# 2. Überprüft, ob 'dialog' installiert ist.
	# 3. Wenn 'dialog' installiert ist, wird 'screen -ls' verwendet, um die Sitzungen abzurufen, und das Ergebnis wird in 'txtscreenlist' gespeichert.
	#    Danach wird eine Warnmeldung mit 'txtscreenlist' angezeigt.
	# 4. Wenn 'dialog' nicht installiert ist, wird 'screen -ls' verwendet, um die Sitzungen abzurufen, und das Ergebnis wird in 'mynewlist' gespeichert.
	#    Danach wird das Ergebnis protokolliert.
	# 5. Die Funktion kehrt zum Hauptmenü ('hauptmenu') zurück.
##
function screenlist() {
	# Letzte Bearbeitung 29.09.2023
    log line
    log info "Alle laufenden Screens anzeigen!"
    
    # Überprüft, ob 'dialog' installiert ist.
    if dpkg-query -s dialog 2>/dev/null | grep -q installed; then
        # Alle Aktionen mit 'dialog'.
        txtscreenlist=$(screen -ls)
        warnbox "$txtscreenlist"
        hauptmenu
    else
        # Alle Aktionen ohne 'dialog'.
        mynewlist=$(screen -ls)
        log text "$mynewlist"
        return 0
    fi
}

## *  screenlistrestart
	#? Beschreibung: Zeigt eine Liste aller laufenden Screen-Sitzungen und protokolliert sie.
	#? Parameter: Keine.
	#? Rückgabewert: Es wird nichts zurückgegeben.
	#? Aufgaben:
	# 1. Protokolliert eine Informationsmeldung über das Anzeigen aller laufenden Screen-Sitzungen.
	# 2. Verwendet 'screen -ls', um die Sitzungen abzurufen, und speichert das Ergebnis in 'mynewlist'.
	# 3. Protokolliert 'mynewlist'.
	# 4. Die Funktion gibt 0 als Rückgabewert zurück.
##
function screenlistrestart() {
	# Letzte Bearbeitung 29.09.2023
    log line
    log info "Alle laufenden Screens anzeigen!"
    
    # Verwendet 'screen -ls', um die Sitzungen abzurufen, und speichert das Ergebnis in 'mynewlist'.
    mynewlist=$(screen -ls)
    
    # Protokolliert 'mynewlist'.
    log text "$mynewlist"
    
    # Gibt 0 als Rückgabewert zurück.
    return 0
}


#──────────────────────────────────────────────────────────────────────────────────────────
#* Downloads Funktionsgruppe
#──────────────────────────────────────────────────────────────────────────────────────────

## *  downloados
	#? Beschreibung: Ermöglicht das Herunterladen von Betriebssystem-Dateien über einen Menüdialog.
	#? Parameter: Keine.
	#? Rückgabewert: Es wird nichts zurückgegeben.
	#? Aufgaben:
	# 1. Öffnet einen Menüdialog mit dem Titel "Downloads" und zeigt eine Liste von Download-Optionen an.
	# 2. Die Optionen enthalten die Bezeichnung "DownloadX" gefolgt von einem Link (z.B., "Download1: " gefolgt von "$LINK01").
	# 3. Der Benutzer kann eine Option auswählen, um den gewünschten Link zum Herunterladen auszuwählen.
	# 4. Der ausgewählte Link wird mit 'wget' heruntergeladen.
	# 5. Die Funktion kehrt nach dem Herunterladen zum Hauptmenü ('hauptmenu') zurück.
##
function downloados() {
	# Letzte Bearbeitung 29.09.2023
	# Öffnet einen Menüdialog und speichert die ausgewählte Option in 'ASSETDELBOXERGEBNIS'.
	ASSETDELBOXERGEBNIS=$(dialog --menu "Downloads" 30 80 25 \
		"Download1: " "$LINK01" \
		"Download2: " "$LINK02" \
		"Download3: " "$LINK03" \
		"Download4: " "$LINK04" \
		"Download5: " "$LINK05" \
		"Download6: " "$LINK06" \
		"Download7: " "$LINK07" \
		"Download8: " "$LINK08" \
		"Download9: " "$LINK09" \
		"Download10: " "$LINK10" \
		"Download11: " "$LINK11" \
		"Download12: " "$LINK12" \
		"Download13: " "$LINK13" \
		"Download14: " "$LINK14" \
		"Download15: " "$LINK15" \
		"Download16: " "$LINK16" \
		"Download17: " "$LINK17" \
		"Download18: " "$LINK18" \
		"Download19: " "$LINK19" \
		"Download20: " "$LINK20" \
		"Download21: " "$LINK21" \
		"Download22: " "$LINK22" \
		"Download23: " "$LINK23" \
		"Download24: " "$LINK24" \
		"Download25: " "$LINK25" \
		"Download26: " "$LINK26" 3>&1 1>&2 2>&3 3>&-)

	dialogclear

	# Extrahiert die erste ausgewählte Option (z.B., "Download1: ").
	DownloadAntwort=$(echo "$ASSETDELBOXERGEBNIS" | sed -n '1p')

	if [[ $DownloadAntwort = "Download1: " ]]; then wget "$LINK01"; fi
	if [[ $DownloadAntwort = "Download2: " ]]; then wget "$LINK02"; fi
	if [[ $DownloadAntwort = "Download3: " ]]; then wget "$LINK03"; fi
	if [[ $DownloadAntwort = "Download4: " ]]; then wget "$LINK04"; fi
	if [[ $DownloadAntwort = "Download5: " ]]; then wget "$LINK05"; fi
	if [[ $DownloadAntwort = "Download6: " ]]; then wget "$LINK06"; fi
	if [[ $DownloadAntwort = "Download7: " ]]; then wget "$LINK07"; fi
	if [[ $DownloadAntwort = "Download8: " ]]; then wget "$LINK08"; fi
	if [[ $DownloadAntwort = "Download9: " ]]; then wget "$LINK09"; fi
	if [[ $DownloadAntwort = "Download10: " ]]; then wget "$LINK10"; fi

	if [[ $DownloadAntwort = "Download11: " ]]; then wget "$LINK11"; fi
	if [[ $DownloadAntwort = "Download12: " ]]; then wget "$LINK12"; fi
	if [[ $DownloadAntwort = "Download13: " ]]; then wget "$LINK13"; fi
	if [[ $DownloadAntwort = "Download14: " ]]; then wget "$LINK14"; fi
	if [[ $DownloadAntwort = "Download15: " ]]; then wget "$LINK15"; fi
	if [[ $DownloadAntwort = "Download16: " ]]; then wget "$LINK16"; fi
	if [[ $DownloadAntwort = "Download17: " ]]; then wget "$LINK17"; fi
	if [[ $DownloadAntwort = "Download18: " ]]; then wget "$LINK18"; fi
	if [[ $DownloadAntwort = "Download19: " ]]; then wget "$LINK19"; fi
	if [[ $DownloadAntwort = "Download20: " ]]; then wget "$LINK20"; fi

	if [[ $DownloadAntwort = "Download21: " ]]; then wget "$LINK21"; fi
	if [[ $DownloadAntwort = "Download22: " ]]; then wget "$LINK22"; fi
	if [[ $DownloadAntwort = "Download23: " ]]; then wget "$LINK23"; fi
	if [[ $DownloadAntwort = "Download24: " ]]; then wget "$LINK24"; fi
	if [[ $DownloadAntwort = "Download25: " ]]; then wget "$LINK25"; fi

	# Kehrt zum Hauptmenü ('hauptmenu') zurück.
	hauptmenu
}

## *  delete_emty_mark
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion durchsucht eine Eingabedatei nach Zeilen, die nur aus einem Tabulator gefolgt von einem Rautenzeichen bestehen,
	# und löscht diese Zeilen. Die verbleibenden Zeilen werden in eine Ausgabedatei geschrieben.
	#? Parameter:
	# $1 (EINGABE_DATEI): Der Name der Eingabedatei, die durchsucht werden soll.
	# $2 (AUSGABE_DATEI): Der Name der Ausgabedatei, in die die verbleibenden Zeilen geschrieben werden sollen.
	#? Rückgabewert:
	# Diese Funktion gibt keine direkten Rückgabewerte zurück, gibt jedoch eine Erfolgsmeldung aus, wenn der Vorgang abgeschlossen ist.
	#? Beispielverwendung:
	# delete_emty_mark "eingabe.txt" "ausgabe.txt"
##
function delete_emty_mark() {
	# Name des Eingabedatei
	EINGABE_DATEI=$1

	# Name des Ausgabedatei
	AUSGABE_DATEI=$2

	# Schleife durch die Zeilen der Eingabedatei
	while IFS= read -r zeile
	do
		# Überprüfen, ob die Zeile nur aus einem Tabulator gefolgt von einem Rautenzeichen besteht
		if [[ "$zeile" == "	#" ]]; then
			# Wenn ja, die Zeile überspringen (löschen)
			continue
		else
			# Wenn nicht, die Zeile zur Ausgabedatei hinzufügen
			echo "$zeile" >> "$AUSGABE_DATEI"
		fi
	done < "$EINGABE_DATEI"

	echo "Fertig."
}


## *  radiolist
	# Datum: 02.10.2023
	#? Beschreibung: Erstellt eine Liste von Internetradio-Streams basierend auf Musikgenres.
	#? Parameter: Keine.
	#? Rückgabewert: Es wird nichts zurückgegeben.
	#? Aufgaben:
	# 1. Löscht die temporäre Datei '/tmp/radio.tmp', falls sie bereits existiert.
	# 2. Erstellt das Verzeichnis '/STARTVERZEICHNIS/radiolist', falls es nicht existiert.
	# 3. Durchläuft eine Liste von Musikgenres, die in der Variable 'listVar' gespeichert sind.
	# 4. Ruft eine Liste von Internetradio-Streams für jedes Genre von 'https://dir.xiph.org/genres/' ab.
	# 5. Filtert unnötige Zeilen aus der abgerufenen Liste.
	# 6. Erstellt eine Textdatei pro Genre im Verzeichnis '/STARTVERZEICHNIS/radiolist' und speichert die Stream-Informationen darin.
	# 7. Protokolliert die Erstellung jeder Liste.
##
function radiolist() {
	# Letzte Bearbeitung 29.09.2023
    rm /tmp/radio.tmp
    mkdir -p /"$STARTVERZEICHNIS"/radiolist
    for genre in $listVar; do        
        # Link Liste holen
        lynx -listonly -nonumbers -dump https://dir.xiph.org/genres/"$genre" > /tmp/radio.tmp

        # Alles unnoetige herausfiltern.
        sed -i '/dir/d'     /tmp/radio.tmp
    
        # Ueberschrift
    echo "# $genre" > /"$STARTVERZEICHNIS"/radiolist/"$genre".txt

	log info "$genre Liste wird erstellt."

    readarray lines < /tmp/radio.tmp

    for line_no in "${!lines[@]}" 
    do
        IFS=';' read -ra values <<<"${lines[$line_no]}"
        ((line_no ++))
        for element_index in "${!values[@]}" 
        do
            url="${values[$element_index]}"

            # das Protokoll extrahieren.
            proto="$(echo "$url" | grep :// | sed -e's,^\(.*://\).*,\1,g')"

            # das Protokoll entfernen.
            # shellcheck disable=SC2001
            url=$(echo "$url" | sed -e s,"$proto",,g)

            # Host extrahieren.
            # shellcheck disable=SC2154
            host=$(echo "$url" | sed -e s,"$user"@,,g | cut -d/ -f1 | sed -e 's,:.*,,g')

            # extract the path (if any)
            path="$(echo "$url" | grep / | cut -d/ -f2-)"

            echo "$genre|$host|$path|${values[$element_index]}" >> /"$STARTVERZEICHNIS"/radiolist/"$genre".txt
        done
    done
done
}

## *  mysqlbackup
	#? Beschreibung: Erstellt ein Backup einer MySQL-Datenbank und kann optional das Backup komprimieren.
	#? Parameter:
	#   1. username: Der MySQL-Benutzername für die Datenbank.
	#   2. password: Das MySQL-Passwort für den angegebenen Benutzer.
	#   3. databasename: Der Name der zu sichernden MySQL-Datenbank.
	#   4. dbcompress: Optional, ein Flag zum Aktivieren der Komprimierung (-c) des Backups.
	#? Rückgabewert: Die Funktion gibt keinen expliziten Rückgabewert zurück.
	#? Aufgaben:
	# 1. Erstellt das Verzeichnis '/$STARTVERZEICHNIS/backup', falls es nicht existiert, oder gibt eine Meldung aus, wenn es bereits vorhanden ist.
	# 2. Wechselt in das Verzeichnis '/$STARTVERZEICHNIS/backup' oder gibt einen Fehler zurück, wenn dies nicht möglich ist.
	# 3. Überprüft, ob die Option '-c' (Komprimierung) angegeben wurde.
	# 4. Falls keine Komprimierung angefordert ist, führt die Funktion 'mysqldump' aus, um ein MySQL-Datenbankbackup zu erstellen und speichert es in einer .sql-Datei.
	# 5. Falls die Komprimierung angefordert ist, führt die Funktion 'mysqldump' aus, leitet die Ausgabe an 'zip' weiter und erstellt eine .zip-Datei für das Backup.
##
function mysqlbackup() {
	# bearbeitung noetig! # Letzte Bearbeitung 29.09.2023
	username=$1
	password=$2
	databasename=$3
	dbcompress=$4
	mkdir -p /$STARTVERZEICHNIS/backup || log rohtext "Verzeichnis vorhanden"
	cd /$STARTVERZEICHNIS/backup || return 1

	if [ "$dbcompress" = "" ]; then 
	mysqldump -u $username -p$password $databasename --single-transaction --quick > $databasename.sql
	fi
	if [ "$dbcompress" = "-c" ]; then 
	mysqldump -u $username -p$password $databasename --single-transaction --quick | zip >/$STARTVERZEICHNIS/backup/"$databasename".sql.zip;
	fi
}

#──────────────────────────────────────────────────────────────────────────────────────────
#* Sicherheitsfunktionen Funktionsgruppe
#──────────────────────────────────────────────────────────────────────────────────────────

## *  passgen
	#? Beschreibung: Generiert ein zufälliges Passwort mit der angegebenen Länge und gibt es auf der Standardausgabe aus.
	#? Parameter:
	#   1. PASSWORTLAENGE: Die gewünschte Länge des generierten Passworts.
	#? Rückgabewert: Das generierte Passwort wird auf der Standardausgabe ausgegeben.
	#? Aufgaben:
	# 1. Extrahiert die gewünschte Passwortlänge aus dem ersten Parameter 'PASSWORTLAENGE'.
	# 2. Verwendet '/dev/urandom' und den Befehl 'tr' zusammen mit einer Zeichenklasse, um zufällige Zeichen zu generieren.
	# 3. Begrenzt die Anzahl der generierten Zeichen auf die angegebene Passwortlänge.
	# 4. Gibt das generierte Passwort auf der Standardausgabe aus.
##
function passgen() {
	# Letzte Bearbeitung 29.09.2023
    # Extrahiert die gewünschte Passwortlänge aus dem ersten Parameter 'PASSWORTLAENGE'.
		PASSWORTLAENGE=$1
		# Verwendet '/dev/urandom' und den Befehl 'tr' zusammen mit einer Zeichenklasse, um zufällige Zeichen zu generieren.
		NEWPASSWD=$(tr -dc 'A-Za-z0-9!"#$%&'\''()*+,-./:;<=>?@[\]^_`{|}~' </dev/urandom | head -c "$PASSWORTLAENGE")
		# Gibt das generierte Passwort auf der Standardausgabe aus.
		echo "$NEWPASSWD"
}

## *  passwdgenerator
	#? Beschreibung: Generiert ein zufälliges Passwort mit der angegebenen Stärke und gibt es auf der Standardausgabe aus.
	#? Parameter:
	#   - Mit 'dialog' (falls verfügbar):
	#     - STARK: Die gewünschte Stärke des generierten Passworts (Länge).
	#   - Ohne 'dialog':
	#     - 1. STARK: Die gewünschte Stärke des generierten Passworts (Länge).
	#? Rückgabewert: Das generierte Passwort wird auf der Standardausgabe ausgegeben.
	#? Aufgaben:
	# 1. Überprüft, ob das Dialog-Tool 'dialog' installiert ist. Wenn ja, wird die Passwortstärke mithilfe eines Dialogs abgefragt.
	# 2. Falls 'dialog' nicht verfügbar ist oder die Passwortstärke als Argument übergeben wurde, wird die Stärke des Passworts in 'STARK' gespeichert.
	# 3. Verwendet '/dev/urandom' und den Befehl 'tr' zusammen mit einer Zeichenklasse, um zufällige Zeichen zu generieren.
	# 4. Begrenzt die Anzahl der generierten Zeichen auf die angegebene Passwortstärke.
	# 5. Gibt das generierte Passwort auf der Standardausgabe aus.
##
function passwdgenerator() {
	# Letzte Bearbeitung 29.09.2023
	#** dialog Aktionen
	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then
		# Alle Aktionen mit dialog
		boxtitel="opensimMULTITOOL Eingabe"
		boxtext="Passwortstaerke:"
		STARK=$(dialog --backtitle "opensimMULTITOOL $VERSION" --title "$boxtitel" --inputbox "$boxtext" 8 40 3>&1 1>&2 2>&3 3>&-)
		dialogclear
		ScreenLog
		PASSWD=$(tr -dc 'A-Za-z0-9!"#$%&'\''()*+,-./:;<=>?@[\]^_`{|}~' </dev/urandom | head -c "$STARK")
		echo "$PASSWD"
		unset PASSWD
		return 0
	else
		# Alle Aktionen ohne dialog
		STARK=$1
		PASSWD=$(tr -dc 'A-Za-z0-9!"#$%&'\''()*+,-./:;<=>?@[\]^_`{|}~' </dev/urandom | head -c "$STARK")
		echo "$PASSWD"
		unset PASSWD
		return 0
	fi # dialog Aktionen Ende
	return 0
}

#──────────────────────────────────────────────────────────────────────────────────────────
#* KI AI Funktionsgruppe
#──────────────────────────────────────────────────────────────────────────────────────────

## *  dalaiinstallinfos
	#? Beschreibung: Gibt Informationen zu den installierten Versionen von Python, JRE (Java Runtime Environment) und Node.js aus.
	#? Parameter: Keine.
	#? Rückgabewert: Es wird nichts zurückgegeben.
	#? Aufgaben:
	# 1. Gibt die installierte Python-Version mithilfe von 'python3 -V' aus.
	# 2. Gibt die installierte JRE-Version (Java Runtime Environment) mithilfe von 'java -version' aus.
	# 3. Gibt die installierte Node.js-Version mithilfe von 'node -v' aus.
##
function dalaiinstallinfos() {
	# Letzte Bearbeitung 29.09.2023
    # Gibt die installierte Python-Version aus.
    echo "Python Version:"
    python3 -V

    # Gibt die installierte JRE-Version (Java Runtime Environment) aus.
    echo "JRE Version:"
    java -version

    # Gibt die installierte Node.js-Version aus.
    echo "Node.js Version:"
    node -v
}

## *  dalaiserverinstall
	#? Beschreibung: Installiert erforderliche Softwarekomponenten für den Dalai-Server.
	#? Parameter: Keine.
	#? Rückgabewert: Es wird nichts zurückgegeben.
	#? Aufgaben:
	# 1. Installiert Python 3.10 mithilfe von 'sudo apt install python3.10'.
	# 2. Installiert das Java Runtime Environment (JRE) mithilfe von 'sudo apt install default-jre'.
	# 3. Installiert Node.js 18 mithilfe von 'curl' und 'sudo apt-get install'.
	# 4. Führt 'apt update' aus, um die Paketdatenbank zu aktualisieren.
	# 5. Führt 'apt upgrade' aus, um alle installierten Pakete zu aktualisieren.
##
function dalaiserverinstall() {
	# Letzte Bearbeitung 29.09.2023
    # Installiert Python 3.10.
    echo "Python 3.10 installieren"
    sudo apt install python3.10

    # Installiert das Java Runtime Environment (JRE), das für 'npm' erforderlich ist.
    echo "Ohne JRE lässt sich kein npm installieren"
    sudo apt install default-jre

    # Installiert Node.js 18.
    echo "Node.js installieren"
    curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash - &&\
    sudo apt-get install -y nodejs

    # Aktualisiert die Paketdatenbank.
    apt update

    # Aktualisiert alle installierten Pakete.
    apt upgrade
}

## *  dalaimodelinstall
	#? Beschreibung: Installiert ein Modell für Dalai basierend auf der angegebenen Modellversion (MKIVERSION).
	#? Parameter:
	#   1. MKIVERSION (optional): Die Modellversion, die installiert werden soll. Standardmäßig wird "7B" verwendet, wenn keine Version angegeben wird.
	#? Rückgabewert: Es wird nichts zurückgegeben.
	#? Aufgaben:
	# 1. Extrahiert die Modellversion aus dem ersten Parameter 'MKIVERSION' oder verwendet "7B" als Standardwert.
	# 2. Überprüft, ob das Verzeichnis '/$mdalaihome/' bereits existiert. Falls nicht, wird es erstellt.
	# 3. Je nach ausgewählter Modellversion werden die entsprechenden Dateien für das Modell heruntergeladen und in das entsprechende Verzeichnis unter '/$mdalaihome/' abgelegt.
	# Verfügbare Modellversionen:
	# - 30B: https://huggingface.co/guy1267/alpaca30B/tree/main
	# - 13B: https://huggingface.co/guy1267/alpaca13B/tree/main
	# - 7B: https://huggingface.co/guy1267/alpaca7B/tree/main
##
function dalaimodelinstall() {
	# Letzte Bearbeitung 29.09.2023
    MKIVERSION=$1
	mdalaihome="home/models/llama/models"
	mdalaimodells="dalai/llama"
	# /home/models/llama/models

    if [ "$MKIVERSION" = "" ]; then MKIVERSION="7B"; fi

	if [ ! -f "/$mdalaihome/" ]; then
		echo "Lege Verzeichnis /$mdalaihome an"
		mkdir -p /$mdalaihome
	else
		echo "Verzeichnis /$mdalaihome existiert bereits"
	fi

	#30B:  https://huggingface.co/guy1267/alpaca30B/tree/main	
	if [ "$MKIVERSION" = "30B" ]; then 
	echo "Lege Verzeichnis /$mdalaihome/30B an";
	mkdir -p /$mdalaihome/30B;
	cd /$mdalaihome/30B
	wget https://huggingface.co/guy1267/alpaca30B/resolve/main/ggml-model-q4_0.bin; 
	fi

	#13B:  https://huggingface.co/guy1267/alpaca13B/tree/main
	if [ "$MKIVERSION" = "13B" ]; then 
	echo "Lege Verzeichnis /$mdalaihome/13B an";
	mkdir -p /$mdalaihome/13B;
	cd /$mdalaihome/13B
	wget https://huggingface.co/guy1267/alpaca13B/resolve/main/ggml-model-q4_0.bin; 
	fi

	#7B:  https://huggingface.co/guy1267/alpaca7B/tree/main
	if [ "$MKIVERSION" = "7B:" ]; then 
	echo "Lege Verzeichnis /$mdalaihome/7B an";
	mkdir -p /$mdalaihome/7B;
	cd /$mdalaihome/7B
	wget https://huggingface.co/guy1267/alpaca7B/resolve/main/ggml-model-q4_0.bin; 
	fi
}

## *  dalaiinstall
	#? Beschreibung: Installiert den Dalai-Server mit der angegebenen Modellversion (KIVERSION) und legt das Dalai-Modellverzeichnis fest.
	#? Parameter:
	#   1. KIVERSION (optional): Die Modellversion, die für Dalai verwendet werden soll. Standardmäßig wird "7B" verwendet, wenn keine Version angegeben wird.
	#? Rückgabewert: Es wird nichts zurückgegeben.
	#? Aufgaben:
	# 1. Extrahiert die Modellversion aus dem ersten Parameter 'KIVERSION' oder verwendet "7B" als Standardwert.
	# 2. Überprüft, ob das Verzeichnis '/$dalaihome/$dalaimodells/' bereits existiert. Falls nicht, wird es erstellt.
	# 3. Führt die Installation des Dalai-Servers mit der ausgewählten Modellversion und dem Modellverzeichnis '/home/dalai' durch.
##
function dalaiinstall() {
	# Letzte Bearbeitung 29.09.2023
    KIVERSION=$1
	dalaihome="home"
	dalaimodells="dalai"

	# Dalai Server Version 0.3.1
	# License MIT

    if [ "$KIVERSION" = "" ]; then KIVERSION="7B"; fi

	if [ ! -f "/$dalaihome/$dalaimodells/" ]; then
		echo "Lege Verzeichnis /$dalaihome/$dalaimodells an"
		mkdir -p /$dalaihome/$dalaimodells
	else
		echo "Verzeichnis /$dalaihome/$dalaimodells existiert bereits"
	fi

	echo "Dalai installieren"

	# Führt die Installation des Dalai-Servers mit der ausgewählten Modellversion und dem Modellverzeichnis '/home/dalai' durch.
	npx dalai alpaca install 7B --home /home/dalai
}

## *  dalaisearch
	#? Beschreibung: Sucht nach der Verfügbarkeit von Node.js und npm sowie dem Dalai-Tool im System.
	#? Parameter: Keine.
	#? Rückgabewert: Es wird nichts zurückgegeben.
	#? Aufgaben:
	# 1. Verwendet den Befehl 'which' zum Suchen nach der Verfügbarkeit von 'node' im System und gibt den Pfad aus, falls gefunden.
	# 2. Verwendet den Befehl 'which' zum Suchen nach der Verfügbarkeit von 'nodejs' im System und gibt den Pfad aus, falls gefunden.
	# 3. Verwendet den Befehl 'which' zum Suchen nach der Verfügbarkeit von 'npm' im System und gibt den Pfad aus, falls gefunden.
	# 4. Verwendet den Befehl 'which' zum Suchen nach der Verfügbarkeit von 'dalai' im System und gibt den Pfad aus, falls gefunden.
##
function dalaisearch() {
	# Letzte Bearbeitung 29.09.2023
    # Sucht nach der Verfügbarkeit von 'node' im System und gibt den Pfad aus, falls gefunden.
    which node

    # Sucht nach der Verfügbarkeit von 'nodejs' im System und gibt den Pfad aus, falls gefunden.
    which nodejs

    # Sucht nach der Verfügbarkeit von 'npm' im System und gibt den Pfad aus, falls gefunden.
    which npm

    # Sucht nach der Verfügbarkeit von 'dalai' im System und gibt den Pfad aus, falls gefunden.
    which dalai
}

## *  dalaiuninstall
	#? Beschreibung: Deinstalliert Dalai-Modelle für die angegebenen Modellversionen.
	#? Parameter: Keine.
	#? Rückgabewert: Es wird nichts zurückgegeben.
	#? Aufgaben:
	# 1. Verwendet 'npx dalai llama uninstall' zum Deinstallieren der Dalai-Modelle der Modellversionen 7B, 13B und 30B für Llama.
	# 2. Verwendet 'npx dalai alpaca uninstall' zum Deinstallieren der Dalai-Modelle der Modellversionen 7B, 13B und 30B für Alpaca.
##
function dalaiuninstall() {
	# Letzte Bearbeitung 29.09.2023
    # Deinstalliert Dalai-Modelle für die angegebenen Modellversionen (7B, 13B, 30B) für Llama.
    npx dalai llama uninstall 7B 13B 30B

    # Deinstalliert Dalai-Modelle für die angegebenen Modellversionen (7B, 13B, 30B) für Alpaca.
    npx dalai alpaca uninstall 7B 13B 30B
}

## *  dalaistart
	#? Beschreibung: Startet den Dalai-Server und gibt die Serveradresse aus.
	#? Parameter: Keine.
	#? Rückgabewert: Es wird nichts zurückgegeben.
	#? Aufgaben:
	# 1. Legt die Variablen 'dalaihome' und 'dalaimodells' fest, die auf die Pfade für das Dalai-Modellverzeichnis verweisen.
	# 2. Gibt eine Meldung aus, dass die Künstliche Intelligenz (KI) gestartet wird.
	# 3. Startet den Dalai-Server mithilfe von 'npx dalai serve' im Hintergrund unter Verwendung des Modellverzeichnisses '/home/models'.
	# 4. Verwendet 'screen' zur Hintergrundausführung, um den Serverprozess laufen zu lassen.
	# 5. Listet die aktiven 'screen'-Sitzungen auf, um sicherzustellen, dass der Server gestartet wurde.
	# 6. Gibt die Serveradresse aus, auf der der Dalai-Server läuft (normalerweise auf Port 3000).
##
function dalaistart() {
	# Letzte Bearbeitung 29.09.2023
    dalaihome="home"
    dalaimodells="models"

    echo "KI starten"
    
    # Startet den Dalai-Server im Hintergrund unter Verwendung des Modellverzeichnisses '/home/models'.
    screen -fa -S "KI" -d -U -m npx dalai serve --home /home/models
    
    # Listet die aktiven 'screen'-Sitzungen auf, um sicherzustellen, dass der Server gestartet wurde.
    screen -ls
    
    # Gibt die Serveradresse aus, auf der der Dalai-Server läuft (normalerweise auf Port 3000).
    echo "Der Dalai Server läuft auf der Adresse: ${AKTUELLEIP}:3000"
}

## *  dalaistop
	#? Beschreibung: Stoppt den laufenden Dalai-Server und zeigt die aktiven 'screen'-Sitzungen an.
	#? Parameter: Keine.
	#? Rückgabewert: Es wird nichts zurückgegeben.
	#? Aufgaben:
	# 1. Gibt eine Meldung aus, dass die Künstliche Intelligenz (KI) gestoppt wird.
	# 2. Verwendet 'screen' zum Beenden der laufenden 'KI'-Sitzung, die den Dalai-Server ausführt.
	# 3. Listet die aktiven 'screen'-Sitzungen auf, um zu überprüfen, ob die KI-Sitzung erfolgreich gestoppt wurde.
##
function dalaistop() {
	# Letzte Bearbeitung 29.09.2023
    echo "KI stoppen"
    
    # Verwendet 'screen' zum Beenden der laufenden 'KI'-Sitzung, die den Dalai-Server ausführt.
    screen -X -S KI kill
    
    # Listet die aktiven 'screen'-Sitzungen auf, um zu überprüfen, ob die KI-Sitzung erfolgreich gestoppt wurde.
    screen -ls
}

## *  dalaiupgrade
	#? Beschreibung: Aktualisiert den Dalai-Server auf die angegebene Version oder die Standardversion.
	#? Parameter:
	#   1. dalaiversion (optional): Die Version von Dalai, die installiert werden soll. Standardmäßig wird "0.3.1" verwendet, wenn keine Version angegeben wird.
	#? Rückgabewert: Es wird nichts zurückgegeben.
	#? Aufgaben:
	# 1. Überprüft, ob ein Upgrade für Dalai verfügbar ist, indem die Website https://www.npmjs.com/package/dalai überprüft wird.
	# 2. Legt die Standardversion von Dalai auf "0.3.1" fest, falls keine Version im Parameter angegeben wurde.
	# 3. Führt die Aktualisierung von Dalai auf die angegebene Version oder die Standardversion durch, indem 'npx dalai@$dalaiversion setup' ausgeführt wird.
##
function dalaiupgrade() {
	# Letzte Bearbeitung 29.09.2023
    # Überprüft, ob ein Upgrade für Dalai verfügbar ist, indem die Website https://www.npmjs.com/package/dalai überprüft wird.

    # Standardversion von Dalai (falls keine Version im Parameter angegeben wurde).
	dalaiversion=$1

	if [ "$dalaiversion" = "" ]; then dalaiversion="0.3.1"; fi
	
    echo "Dalai aktualisieren"
	# Führt die Aktualisierung von Dalai auf die angegebene Version oder die Standardversion durch.
	npx dalai@$dalaiversion setup
}

#──────────────────────────────────────────────────────────────────────────────────────────
#* OpenSimulator Kommandos-Funktionen Funktionsgruppe
#──────────────────────────────────────────────────────────────────────────────────────────

## *  oscommand
	#? Beschreibung:
	# Diese Funktion sendet ein OpenSimulator-Befehl an einen laufenden 'screen'-Prozess, der mit dem OpenSimulator assoziiert ist.
	# Sie ermöglicht die Fernsteuerung des OpenSimulators durch das Senden von Befehlen an den 'screen'-Prozess.
	#? Parameter:
	# - $1: Der Name des 'screen'-Prozesses, an den der Befehl gesendet werden soll (z. B., der Name des OpenSimulator-Screens).
	# - $2: Die Region, auf die sich der Befehl bezieht.
	# - $3: Der auszuführende OpenSimulator-Befehl.
	#? Rückgabewert:
	# Diese Funktion gibt immer den Wert 0 zurück, da keine Fehlerbehandlung implementiert ist.
	#? Abhängigkeiten:
	# - Die Funktion verwendet die Befehle 'screen', 'log' und 'grep'.
	#? Beispielaufruf:
	# oscommand opensim-screen myregion "say Hello, World!"
##
function oscommand() {
	# Letzte Bearbeitung 30.09.2023
	OSCOMMANDSCREEN=$1
	REGION=$2
	COMMAND=$3
	if screen -list | grep -q "$OSCOMMANDSCREEN"; then
		log info "OSCOMMAND: $COMMAND an $OSCOMMANDSCREEN senden"
		# Befehl zum Region wechseln senden
		screen -S "$OSCOMMANDSCREEN" -p 0 -X eval "stuff 'change region ""$REGION""'^M"
		# OpenSimulator-Befehl senden
		screen -S "$OSCOMMANDSCREEN" -p 0 -X eval "stuff '$COMMAND'^M"
	else
		log error "OSCOMMAND: Der Screen $OSCOMMANDSCREEN existiert nicht"
	fi
	return 0
}

## *  oscommand
	#? Beschreibung:
	# Diese Funktion sendet ein OpenSimulator-Befehl an einen laufenden 'screen'-Prozess, der mit dem OpenSimulator assoziiert ist.
	# Sie ermöglicht die Fernsteuerung des OpenSimulators durch das Senden von Befehlen an den 'screen'-Prozess.
	#? Parameter:
	# - $1: Der Name des 'screen'-Prozesses, an den der Befehl gesendet werden soll (z. B., der Name des OpenSimulator-Screens).
	# - $2: Die Region, auf die sich der Befehl bezieht.
	# - $3: Der auszuführende OpenSimulator-Befehl.
	#? Rückgabewert:
	# Diese Funktion gibt immer den Wert 0 zurück, da keine Fehlerbehandlung implementiert ist.
	#? Abhängigkeiten:
	# - Die Funktion verwendet die Befehle 'screen', 'log' und 'grep'.
	#? Beispielaufruf:
	# oscommand opensim-screen myregion "say Hello, World!"
##
function menuoscommand() {
	# Letzte Bearbeitung 30.09.2023
	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then

		# Einstellungen
		boxbacktitel="opensimMULTITOOL"
		boxtitel="opensimMULTITOOL Eingabe"
		formtitle="Kommando an den Simulator"
		lable1="Simulator:"
		lablename1=""
		lable2="Region:"
		lablename2=""
		lable3="Befehlskette:"
		lablename3=""

		# Abfrage
		oscommandBOXERGEBNIS=$(dialog --backtitle "$boxbacktitel" --title "$boxtitel" --form "$formtitle" 25 60 16 "$lable1" 1 1 "$lablename1" 1 25 25 30 "$lable2" 2 1 "$lablename2" 2 25 25 30 "$lable3" 3 1 "$lablename3" 3 25 25 30 3>&1 1>&2 2>&3 3>&-)

		# Zeilen aus einer Variablen zerlegen und in verschiedenen Variablen schreiben.
		OSCOMMANDSCREEN=$(echo "$oscommandBOXERGEBNIS" | sed -n '1p')
		REGION=$(echo "$oscommandBOXERGEBNIS" | sed -n '2p')
		COMMAND=$(echo "$oscommandBOXERGEBNIS" | sed -n '3p')

		# Alles loeschen.
		dialogclear
		ScreenLog
	else
		# Alle Aktionen ohne dialog
		log rohtext "Keine Menuelose Funktion" | exit
	fi # dialog Aktionen Ende

	if screen -list | grep -q "$OSCOMMANDSCREEN"; then
		log info "OSCOMMAND: $COMMAND an $OSCOMMANDSCREEN senden"
		screen -S "$OSCOMMANDSCREEN" -p 0 -X eval "stuff 'change region ""$REGION""'^M" # Region wechseln
		screen -S "$OSCOMMANDSCREEN" -p 0 -X eval "stuff '$COMMAND'^M"
		return 0
	else
		log error "OSCOMMAND: Der Screen $OSCOMMANDSCREEN existiert nicht"
		return 1
	fi

	# Zum schluss alle Variablen loeschen.
	unset OSCOMMANDSCREEN REGION COMMAND
}

## *  assetdel
	#? Beschreibung:
	# Diese Funktion sendet einen Befehl an einen laufenden 'screen'-Prozess, der mit einem OpenSimulator assoziiert ist, um ein Objekt aus einer Region zu löschen.
	# Sie überprüft zunächst, ob der angegebene 'screen'-Prozess und die Region existieren, und führt dann die erforderlichen Schritte zum Löschen des Objekts aus.
	#? Parameter:
	# - $1: Der Name des 'screen'-Prozesses, an den der Befehl gesendet werden soll (z. B., der Name des OpenSimulator-Screens).
	# - $2: Die Region, aus der das Objekt gelöscht werden soll.
	# - $3: Der Name oder die ID des zu löschenden Objekts.
	#? Rückgabewert:
	# - Erfolgreich: Diese Funktion gibt den Wert 0 zurück, um anzuzeigen, dass das Löschen des Objekts erfolgreich war.
	# - Fehler: Wenn der 'screen'-Prozess oder die Region nicht gefunden wird, gibt die Funktion den Wert 1 zurück, um anzuzeigen, dass das Löschen fehlgeschlagen ist.
	#? Abhängigkeiten:
	# - Die Funktion verwendet die Befehle 'screen', 'log' und 'grep'.
	#? Beispielaufruf:
	# assetdel opensim-screen myregion MyObject
##
function assetdel() {
	# Letzte Bearbeitung 30.09.2023
	ASSDELSCREEN=$1
	REGION=$2
	OBJEKT=$3
	# Nachschauen ob der Screen und die Region existiert.
	if screen -list | grep -q "$ASSDELSCREEN"; then
		screen -S "$ASSDELSCREEN" -p 0 -X eval "stuff 'change region ""$REGION""'^M"                  # Region wechseln
		screen -S "$ASSDELSCREEN" -p 0 -X eval "stuff 'alert "Loesche: "$OBJEKT" von der Region!"'^M" # Mit einer loesch Meldung
		screen -S "$ASSDELSCREEN" -p 0 -X eval "stuff 'delete object name ""$OBJEKT""'^M"             # Objekt loeschen
		screen -S "$ASSDELSCREEN" -p 0 -X eval "stuff 'y'^M"                                          # Mit y also yes bestaetigen
		log warn "ASSETDEL: $OBJEKT Asset von der Region $REGION loeschen"
		return 0
	else
		log error "ASSETDEL: $OBJEKT Asset von der Region $REGION loeschen fehlgeschlagen"
		return 1
	fi
}

## *  menuassetdel
	#? Beschreibung:
	# Diese Funktion stellt eine dialogbasierte Benutzeroberfläche bereit, um den Benutzer nach den erforderlichen Informationen für das Löschen eines Objekts aus einer Region zu fragen.
	# Sie verwendet das 'dialog'-Tool, um die Benutzereingabe zu erleichtern, und führt dann den Löschvorgang aus, falls der 'screen'-Prozess und die Region vorhanden sind.
	#? Parameter:
	# Diese Funktion erwartet keine Parameter.
	#? Rückgabewert:
	# - Erfolgreich: Diese Funktion gibt den Wert 0 zurück, um anzuzeigen, dass das Löschen des Objekts erfolgreich war.
	# - Fehler: Wenn der 'screen'-Prozess oder die Region nicht gefunden wird oder 'dialog' nicht installiert ist, gibt die Funktion den Wert 1 zurück, um anzuzeigen, dass das Löschen fehlgeschlagen ist.
	#? Abhängigkeiten:
	# - Die Funktion verwendet die Befehle 'dpkg-query', 'dialog', 'screen', 'log' und 'grep'.
	#? Beispielaufruf:
	# menuassetdel
##
function menuassetdel() {
	# Letzte Bearbeitung 30.09.2023
	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then

		# Einstellungen
		boxbacktitel="opensimMULTITOOL"
		boxtitel="opensimMULTITOOL Eingabe"
		formtitle="Objekt von der Region entfernen"
		lable1="Simulator:"
		lablename1=""
		lable2="Region:"
		lablename2=""
		lable3="Objekt:"
		lablename3=""

		# Abfrage
		ASSETDELBOXERGEBNIS=$(dialog --backtitle "$boxbacktitel" --title "$boxtitel" --form "$formtitle" 25 60 16 "$lable1" 1 1 "$lablename1" 1 25 25 30 "$lable2" 2 1 "$lablename2" 2 25 25 30 "$lable3" 3 1 "$lablename3" 3 25 25 30 3>&1 1>&2 2>&3 3>&-)

		# Zeilen aus einer Variablen zerlegen und in verschiedenen Variablen schreiben.
		ASSETVERZEICHNISSCREEN=$(echo "$ASSETDELBOXERGEBNIS" | sed -n '1p')
		REGION=$(echo "$ASSETDELBOXERGEBNIS" | sed -n '2p')
		OBJEKT=$(echo "$ASSETDELBOXERGEBNIS" | sed -n '3p')

		# Alles loeschen.
		dialogclear
		ScreenLog
	else
		# Alle Aktionen ohne dialog
		log rohtext "Keine Menuelose Funktion" | exit
	fi # dialog Aktionen Ende

	# Nachschauen ob der Screen und die Region existiert.
	if screen -list | grep -q "$ASSETVERZEICHNISSCREEN"; then
		log warn "$OBJEKT Asset von der Region $REGION loeschen"
		screen -S "$ASSETVERZEICHNISSCREEN" -p 0 -X eval "stuff 'change region ""$REGION""'^M"                  # Region wechseln
		screen -S "$ASSETVERZEICHNISSCREEN" -p 0 -X eval "stuff 'alert "Loesche: "$OBJEKT" von der Region!"'^M" # Mit einer loesch Meldung
		screen -S "$ASSETVERZEICHNISSCREEN" -p 0 -X eval "stuff 'delete object name ""$OBJEKT""'^M"             # Objekt loeschen
		screen -S "$ASSETVERZEICHNISSCREEN" -p 0 -X eval "stuff 'y'^M"                                          # Mit y also yes bestaetigen
		return 0
	else
		log error "ASSETDEL: $OBJEKT Asset von der Region $REGION loeschen fehlgeschlagen"
		return 1
	fi
}

## *  landclear
	#? Beschreibung:
	# Diese Funktion sendet einen Befehl an einen laufenden 'screen'-Prozess, der mit einem OpenSimulator assoziiert ist, um alle Parzellen in einer Region zu löschen.
	# Sie überprüft zunächst, ob der angegebene 'screen'-Prozess und die Region existieren, und führt dann den Löschvorgang aus.
	#? Parameter:
	# - $1: Der Name des 'screen'-Prozesses, an den der Befehl gesendet werden soll (z. B., der Name des OpenSimulator-Screens).
	# - $2: Die Region, aus der alle Parzellen gelöscht werden sollen.
	#? Rückgabewert:
	# - Erfolgreich: Diese Funktion gibt den Wert 0 zurück, um anzuzeigen, dass das Löschen der Parzellen erfolgreich war.
	# - Fehler: Wenn der 'screen'-Prozess oder die Region nicht gefunden wird, gibt die Funktion den Wert 1 zurück, um anzuzeigen, dass das Löschen fehlgeschlagen ist.
	#? Abhängigkeiten:
	# - Die Funktion verwendet die Befehle 'screen', 'log' und 'grep'.
	#? Beispielaufruf:
	# landclear opensim-screen myregion
##
function landclear() {
	# Letzte Bearbeitung 30.09.2023
	LANDCLEARSCREEN=$1
	REGION=$2
	# Nachschauen ob der Screen und die Region existiert.
	if screen -list | grep -q "$LANDCLEARSCREEN"; then
		log warn "$LANDCLEARSCREEN Parzellen von der Region $REGION loeschen"
		screen -S "$LANDCLEARSCREEN" -p 0 -X eval "stuff 'change region ""$REGION""'^M"                 # Region wechseln
		screen -S "$LANDCLEARSCREEN" -p 0 -X eval "stuff 'alert "Loesche Parzellen von der Region!"'^M" # Mit einer loesch Meldung
		screen -S "$LANDCLEARSCREEN" -p 0 -X eval "stuff 'land clear'^M"                                # Objekt loeschen
		screen -S "$LANDCLEARSCREEN" -p 0 -X eval "stuff 'y'^M"                                         # Mit y also yes bestaetigen
		return 0
		log info "Bitte die Region neu starten."
	else
		log error "LANDCLEAR: $LANDCLEARSCREEN Parzellen von der Region $REGION loeschen fehlgeschlagen"
		return 1
	fi
}

## *  menulandclear
	#? Beschreibung:
	# Diese Funktion sendet einen Befehl an einen laufenden 'screen'-Prozess, der mit einem OpenSimulator assoziiert ist, um alle Parzellen in einer Region zu löschen.
	# Sie überprüft zunächst, ob der angegebene 'screen'-Prozess und die Region existieren, und führt dann den Löschvorgang aus.
	#? Parameter:
	# - $1: Der Name des 'screen'-Prozesses, an den der Befehl gesendet werden soll (z. B., der Name des OpenSimulator-Screens).
	# - $2: Die Region, aus der alle Parzellen gelöscht werden sollen.
	#? Rückgabewert:
	# - Erfolgreich: Diese Funktion gibt den Wert 0 zurück, um anzuzeigen, dass das Löschen der Parzellen erfolgreich war.
	# - Fehler: Wenn der 'screen'-Prozess oder die Region nicht gefunden wird, gibt die Funktion den Wert 1 zurück, um anzuzeigen, dass das Löschen fehlgeschlagen ist.
	#? Abhängigkeiten:
	# - Die Funktion verwendet die Befehle 'screen', 'log' und 'grep'.
	#? Beispielaufruf:
	# landclear opensim-screen myregion
##
function menulandclear() {
	# Letzte Bearbeitung 30.09.2023
	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then

		# Einstellungen
		boxbacktitel="opensimMULTITOOL"
		boxtitel="opensimMULTITOOL Eingabe"
		formtitle="Parzellen einer Region entfernen"
		lable1="Simulator:"
		lablename1="sim2"
		lable2="Regionsname:"
		lablename2="Sandbox"

		# Abfrage
		landclearBOXERGEBNIS=$(dialog --backtitle "$boxbacktitel" --title "$boxtitel" --form "$formtitle" 25 60 16 "$lable1" 1 1 "$lablename1" 1 25 25 30 "$lable2" 2 1 "$lablename2" 2 25 25 30 3>&1 1>&2 2>&3 3>&-)

		# Zeilen aus einer Variablen zerlegen und in verschiedenen Variablen schreiben.
		MLANDCLEARSCREEN=$(echo "$landclearBOXERGEBNIS" | sed -n '1p')
		REGION=$(echo "$landclearBOXERGEBNIS" | sed -n '2p')

		# Alles loeschen.
		dialogclear
		ScreenLog
	else
		# Alle Aktionen ohne dialog
		log rohtext "Keine Menuelose Funktion" | exit
	fi # dialog Aktionen Ende

	# Nachschauen ob der Screen und die Region existiert.
	if screen -list | grep -q "$MLANDCLEARSCREEN"; then
		log warn "$MLANDCLEARSCREEN Parzellen von der Region $REGION loeschen"
		screen -S "$MLANDCLEARSCREEN" -p 0 -X eval "stuff 'change region ""$REGION""'^M"                 # Region wechseln
		screen -S "$MLANDCLEARSCREEN" -p 0 -X eval "stuff 'alert "Loesche Parzellen von der Region!"'^M" # Mit einer loesch Meldung
		screen -S "$MLANDCLEARSCREEN" -p 0 -X eval "stuff 'land clear'^M"                                # Objekt loeschen
		screen -S "$MLANDCLEARSCREEN" -p 0 -X eval "stuff 'y'^M"                                         # Mit y also yes bestaetigen
		return 0
		log info "Bitte die Region neu starten."
	else
		log error "LANDCLEAR: $MLANDCLEARSCREEN Parzellen von der Region $REGION loeschen fehlgeschlagen"
		return 1
	fi
}

## *  loadinventar
	#? Beschreibung:
	# Diese Funktion sendet einen Befehl an einen laufenden 'screen'-Prozess, der mit einem OpenSimulator assoziiert ist, um ein Inventar-Archiv (IAR) in den OpenSimulator zu laden.
	# Sie überprüft zunächst, ob der angegebene 'screen'-Prozess vorhanden ist, und führt dann den Befehl zum Laden des IAR aus.
	#? Parameter:
	# - $1: Der Name des IAR (Inventar-Archivs), das geladen werden soll.
	# - $2: Das Verzeichnis, in das das IAR geladen werden soll.
	# - $3: Das Passwort für das IAR (optional).
	# - $4: Der Dateiname des IAR.
	#? Rückgabewert:
	# - Erfolgreich: Diese Funktion gibt den Wert 0 zurück, um anzuzeigen, dass das Laden des IAR erfolgreich war.
	# - Fehler: Wenn der 'screen'-Prozess nicht gefunden wird, gibt die Funktion den Wert 1 zurück, um anzuzeigen, dass das Laden fehlgeschlagen ist.
	#? Abhängigkeiten:
	# - Die Funktion verwendet die Befehle 'screen' und 'log'.
	#? Beispielaufruf:
	# loadinventar MyInventory mydirectory mypassword myinventory.iar
##
function loadinventar() {
	# Letzte Bearbeitung 30.09.2023
	LOADINVSCREEN="sim1"
	NAME=$1
	VERZEICHNIS=$2
	PASSWORD=$3
	DATEI=$4
	# Überprüfen, ob der 'screen'-Prozess existiert.
	if screen -list | grep -q "$LOADINVSCREEN"; then
		log info "OSCOMMAND: load iar $NAME $VERZEICHNIS ***** $DATEI"
		screen -S "$LOADINVSCREEN" -p 0 -X eval "stuff 'load iar $NAME $VERZEICHNIS $PASSWORD $DATEI'^M"
		return 0
	else
		log error "OSCOMMAND: Der Screen $LOADINVSCREEN existiert nicht"
		return 1
	fi
}

## *  menuloadinventar
	#? Beschreibung:
	# Diese Funktion stellt eine dialogbasierte Benutzeroberfläche bereit, um den Benutzer nach den erforderlichen Informationen zum Laden eines Inventarverzeichnisses (IAR) in den OpenSimulator zu fragen.
	# Sie verwendet das 'dialog'-Tool, um die Benutzereingabe zu erleichtern, und führt dann den Befehl zum Laden des IAR aus, wenn der 'screen'-Prozess vorhanden ist.
	#? Parameter:
	# Diese Funktion erwartet keine Parameter.
	#? Rückgabewert:
	# - Erfolgreich: Diese Funktion gibt den Wert 0 zurück, um anzuzeigen, dass das Laden des IAR erfolgreich war.
	# - Fehler: Wenn der 'screen'-Prozess nicht gefunden wird oder 'dialog' nicht installiert ist, gibt die Funktion den Wert 1 zurück, um anzuzeigen, dass das Laden fehlgeschlagen ist.
	#? Abhängigkeiten:
	# - Die Funktion verwendet die Befehle 'dpkg-query', 'dialog', 'screen', 'log' und 'grep'.
	#? Beispielaufruf:
	# menuloadinventar
##
function menuloadinventar() {
	# Letzte Bearbeitung 30.09.2023
	# Zuerst überprüfen, ob 'dialog' installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then

		# Einstellungen für das Dialog-Fenster
		boxbacktitel="opensimMULTITOOL"
		boxtitel="opensimMULTITOOL Eingabe"
		formtitle="Inventarverzeichnis laden"
		lable1="NAME:"
		lablename1="John Doe"
		lable2="VERZEICHNIS:"
		lablename2="/texture"
		lable3="PASSWORD:"
		lablename3="PASSWORD"
		lable4="DATEI:"
		lablename4="/$STARTVERZEICHNIS/texture.iar"

		# Benutzerabfrage mit 'dialog'
		loadinventarBOXERGEBNIS=$(dialog --backtitle "$boxbacktitel" --title "$boxtitel" --form "$formtitle" 25 60 16 "$lable1" 1 1 "$lablename1" 1 25 25 30 "$lable2" 2 1 "$lablename2" 2 25 25 30 "$lable3" 3 1 "$lablename3" 3 25 25 30 "$lable4" 4 1 "$lablename4" 4 25 25 30 3>&1 1>&2 2>&3 3>&-)

		# Die Zeilen aus der Benutzereingabe in verschiedene Variablen schreiben.
		NAME=$(echo "$loadinventarBOXERGEBNIS" | sed -n '1p')
		VERZEICHNIS=$(echo "$loadinventarBOXERGEBNIS" | sed -n '2p')
		PASSWORD=$(echo "$loadinventarBOXERGEBNIS" | sed -n '3p')
		DATEI=$(echo "$loadinventarBOXERGEBNIS" | sed -n '4p')

		# Dialog-Bildschirm löschen und Log aktivieren
		dialogclear
		ScreenLog
	else
		# 'dialog' ist nicht installiert - Keine Benutzeroberfläche verfügbar
		log rohtext "Keine Menuelose Funktion" | exit
	fi # Dialog-Aktionen Ende

	LOADINVSCREEN="sim1"
	if screen -list | grep -q "$LOADINVSCREEN"; then
		log info "OSCOMMAND: load iar $NAME $VERZEICHNIS ***** $DATEI"
		screen -S "$LOADINVSCREEN" -p 0 -X eval "stuff 'load iar $NAME $VERZEICHNIS $PASSWORD $DATEI'^M"
		return 0
	else
		log error "OSCOMMAND: Der Screen $LOADINVSCREEN existiert nicht"
		return 1
	fi

	# Zum schluss alle Variablen loeschen.
	unset LOADINVSCREEN NAME VERZEICHNIS PASSWORD DATEI
}

#──────────────────────────────────────────────────────────────────────────────────────────
#* Starten und Stoppen Funktionsgruppe
#──────────────────────────────────────────────────────────────────────────────────────────

## *  osstart
	#? Beschreibung:
	# Diese Funktion startet den OpenSimulator in einem 'screen'-Prozess. Sie überprüft zunächst, ob der angegebene 'screen'-Prozess bereits läuft.
	# Wenn der Prozess nicht läuft, wird überprüft, ob das Verzeichnis des OpenSimulators existiert.
	# Wenn das Verzeichnis existiert, wird der 'screen'-Prozess beendet (falls vorhanden) und der OpenSimulator gestartet.
	# Die Funktion unterstützt den Start sowohl im DOTNET- als auch im MONO-Modus, abhängig von der Konfiguration.
	#? Parameter:
	# - OSSTARTSCREEN: Der Name des 'screen'-Prozesses und das Verzeichnis des OpenSimulators.
	#? Rückgabewert:
	# - Erfolgreich: Wenn der OpenSimulator erfolgreich gestartet wurde oder bereits lief, gibt die Funktion den Wert 0 zurück.
	# - Fehler: Wenn der 'screen'-Prozess nicht gefunden wird, das Verzeichnis des OpenSimulators nicht existiert oder der Start fehlschlägt, gibt die Funktion den Wert 1 zurück.
	#? Beispielaufruf:
	# osstart "sim1"
##
function osstart() {
	# Letzte Bearbeitung 30.09.2023
	OSSTARTSCREEN=$1 # OpenSimulator, Verzeichnis und Screen Name

	log info "OpenSimulator $OSSTARTSCREEN Starten"

	if ! screen -list | grep -q "$OSSTARTSCREEN"; then

		if [ -d "$OSSTARTSCREEN" ]; then

			cd /$STARTVERZEICHNIS/"$OSSTARTSCREEN"/bin || return 1			
			# Ersteinmal Killen dann starten.
			screen -X -S "$OSSTARTSCREEN" kill

			# DOTNETMODUS="yes"
			if [[ "${DOTNETMODUS}" == "yes" ]]; then
				screen -fa -S "$OSSTARTSCREEN" -d -U -m dotnet OpenSim.dll
			fi

			# DOTNETMODUS="no"
			if [[ "${DOTNETMODUS}" == "no" ]]; then
				screen -fa -S "$SCSTARTSCREEN" -d -U -m mono OpenSim.exe
			fi

			sleep 10
		else
			log error "OpenSimulator $OSSTARTSCREEN nicht vorhanden"
			return 1
		fi

	else
		# es laeuft - work
		log warn "OpenSimulator $OSSTARTSCREEN laeuft bereits"
		return 1
	fi
}

## *  osstop
	#? Beschreibung:
	# Diese Funktion beendet den OpenSimulator in einem 'screen'-Prozess. Sie überprüft zunächst, ob der angegebene 'screen'-Prozess existiert.
	# Wenn der Prozess gefunden wird, sendet sie den Befehl "shutdown" an den 'screen'-Prozess, um den OpenSimulator zu beenden.
	# Anschließend wird eine Wartezeit abgewartet (STOPWARTEZEIT) und der 'screen'-Prozess wird gekillt.
	# Die Funktion unterstützt die Beendigung des OpenSimulators in einem 'screen'-Prozess.
	#? Parameter:
	# - OSSTOPSCREEN: Der Name des 'screen'-Prozesses und das Verzeichnis des OpenSimulators.
	#? Rückgabewert:
	# - Erfolgreich: Wenn der OpenSimulator erfolgreich beendet wurde oder der 'screen'-Prozess nicht gefunden wird, gibt die Funktion den Wert 0 zurück.
	# - Fehler: Wenn der 'screen'-Prozess nicht gefunden wird oder ein anderer Fehler auftritt, gibt die Funktion den Wert 1 zurück.
	#? Beispielaufruf:
	# osstop "sim1"
##
function osstop() {
	# Letzte Bearbeitung 30.09.2023
	OSSTOPSCREEN=$1 # OpenSimulator, Verzeichnis und Screen Name
	
	if screen -list | grep -q "$OSSTOPSCREEN"; then
		log warn "OpenSimulator $OSSTOPSCREEN Beenden"
		screen -S "$OSSTOPSCREEN" -p 0 -X eval "stuff 'shutdown'^M" || log rohtext "$OSSTOPSCREEN wurde nicht gefunden."
		sleep $STOPWARTEZEIT
		# Killen.
		screen -X -S "$OSSTOPSCREEN" kill || log rohtext "$OSSTOPSCREEN wurde korrekt heruntergefahren."
		return 0
	else
		log error "OpenSimulator $OSSTOPSCREEN nicht vorhanden"
		return 1
	fi

	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then hauptmenu; fi
}

## *  menuosstart
	#? Beschreibung:
	# Diese Funktion ermöglicht es dem Benutzer, den OpenSimulator in einem 'screen'-Prozess zu starten. Sie zeigt ein Dialogfeld an, in dem der Benutzer den Namen des Simulators eingeben kann.
	# Die Funktion überprüft zunächst, ob der angegebene 'screen'-Prozess bereits läuft. Wenn der Prozess nicht läuft und das Verzeichnis des Simulators existiert, wird der OpenSimulator gestartet.
	# Die Funktion unterstützt den Start sowohl im DOTNET- als auch im MONO-Modus, abhängig von der Konfiguration.
	#? Parameter: Keine.
	#? Rückgabewert:
	# - Erfolgreich: Die Funktion kehrt zur Hauptmenü-Ansicht zurück, nachdem der OpenSimulator gestartet wurde oder bereits lief.
	#? Beispielaufruf:
	# menuosstart
##
function menuosstart() {
	# Letzte Bearbeitung 30.09.2023
	IOSSTARTSCREEN=$(
		dialog --backtitle "opensimMULTITOOL $VERSION" --title "opensimMULTITOOL Eingabe" \
			--inputbox "Simulator:" 8 40 \
			3>&1 1>&2 2>&3 3>&-
	)

	dialogclear
	ScreenLog

	if ! screen -list | grep -q "$IOSSTARTSCREEN"; then
		# es laeuft nicht - not work

		if [ -d "$IOSSTARTSCREEN" ]; then

			cd /$STARTVERZEICHNIS/"$IOSSTARTSCREEN"/bin || return 1

			DIALOG=dialog
			(
				log rohtext "Starte: $IOSSTARTSCREEN"
				# Ersteinmal Killen dann starten.
				screen -X -S "$IOSSTARTSCREEN" kill || log rohtext "$IOSSTARTSCREEN läuft nicht."

				# DOTNETMODUS="yes"
				if [[ "${DOTNETMODUS}" == "yes" ]]; then
					screen -fa -S "$IOSSTARTSCREEN" -d -U -m dotnet OpenSim.dll
				fi

				# DOTNETMODUS="no"
				if [[ "${DOTNETMODUS}" == "no" ]]; then
					screen -fa -S "$IOSSTARTSCREEN" -d -U -m mono OpenSim.exe
				fi
				sleep 3
			)
			ScreenLog
			hauptmenu

		else
			log rohtext "OpenSimulator $IOSSTARTSCREEN nicht vorhanden"
			hauptmenu
		fi
	else
		# es laeuft - work
		log error "OpenSimulator $IOSSTARTSCREEN laeuft bereits"
		hauptmenu
	fi
	# hauptmenu
}

## *  menuosstop
	#? Beschreibung:
	# Diese Funktion ermöglicht es dem Benutzer, den OpenSimulator in einem 'screen'-Prozess zu stoppen. Sie zeigt ein Dialogfeld an, in dem der Benutzer den Namen des Simulators eingeben kann.
	# Die Funktion überprüft zunächst, ob der angegebene 'screen'-Prozess läuft. Wenn der Prozess gefunden wird, wird der Befehl "shutdown" an den 'screen'-Prozess gesendet, um den OpenSimulator zu beenden.
	# Anschließend wird eine Wartezeit abgewartet (STOPWARTEZEIT), und der 'screen'-Prozess wird gekillt.
	#? Parameter: Keine.
	#? Rückgabewert:
	# - Erfolgreich: Die Funktion kehrt zur Hauptmenü-Ansicht zurück, nachdem der OpenSimulator gestoppt wurde.
	# - Fehler: Die Funktion kehrt zur Hauptmenü-Ansicht zurück, wenn der 'screen'-Prozess nicht gefunden wurde.
	#? Beispielaufruf:
	# menuosstop
##
function menuosstop() {
	# Letzte Bearbeitung 30.09.2023
	IOSSTOPSCREEN=$(
		dialog --backtitle "opensimMULTITOOL $VERSION" --title "opensimMULTITOOL Eingabe" \
			--inputbox "Simulator:" 8 40 \
			3>&1 1>&2 2>&3 3>&-
	)
	dialogclear
	ScreenLog

	if screen -list | grep -q "$IOSSTOPSCREEN"; then
		DIALOG=dialog
		(
			log rohtext "Stoppe: $IOSSTOPSCREEN"
			screen -S "$IOSSTOPSCREEN" -p 0 -X eval "stuff 'shutdown'^M"
			sleep $STOPWARTEZEIT
			# Killen wenn noch nicht gestoppt.
			screen -X -S "$IOSSTOPSCREEN" kill
		) |
			$DIALOG --title "$IOSSTOPSCREEN" --gauge "Stop" 8 30
		dialogclear
		$DIALOG --msgbox "$IOSSTOPSCREEN beendet!" 5 20
		dialogclear
		ScreenLog
		hauptmenu
	else
		hauptmenu
	fi
}

## *  rostart
	#? Beschreibung:
	# Diese Funktion dient dazu, den Robust-Server zu starten. Sie wechselt in das Verzeichnis, in dem sich die Robust-Server-Anwendung befindet, und startet den Robust-Server entweder im DOTNET- oder MONO-Modus, abhängig von der Konfiguration (DOTNETMODUS). Anschließend wird eine Wartezeit (ROBUSTWARTEZEIT) abgewartet.
	#? Parameter: Keine.
	#? Rückgabewert:
	# - Erfolgreich: Die Funktion gibt eine Erfolgsmeldung aus und kehrt mit einem Rückgabewert 0 zurück.
	# - Fehler: Die Funktion gibt eine Fehlermeldung aus und kehrt mit einem Rückgabewert 1 zurück, wenn das Starten des Robust-Servers fehlschlägt.
	#? Beispielaufruf:
	# rostart
##
function rostart() {
	# Letzte Bearbeitung 30.09.2023
	log line
	log info "Robust wird gestartet..."
	cd /$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS/bin || return 1	

	# DOTNETMODUS="yes"
	if [[ "${DOTNETMODUS}" == "yes" ]]; then
		screen -fa -S RO -d -U -m dotnet Robust.dll
	fi
	
	# DOTNETMODUS="no"
	if [[ "${DOTNETMODUS}" == "no" ]]; then
		screen -fa -S RO -d -U -m mono Robust.exe
	fi

	sleep $ROBUSTWARTEZEIT

	log info " Robust wurde gestartet"
	return 0
}

## *  menurostart
	#? Beschreibung:
	# Diese Funktion startet den Robust-Server basierend auf der Konfiguration (DOTNETMODUS oder MONO). Sie wechselt in das Verzeichnis, in dem sich die Robust-Server-Anwendung befindet, startet den Robust-Server und wartet anschließend eine definierte Wartezeit (ROBUSTWARTEZEIT).
	#? Parameter: Keine.
	#? Rückgabewert:
	# - Erfolgreich: Die Funktion gibt eine Erfolgsmeldung aus und kehrt mit einem Rückgabewert 0 zurück.
	# - Fehler: Die Funktion gibt eine Fehlermeldung aus und kehrt mit einem Rückgabewert 1 zurück, wenn das Starten des Robust-Servers fehlschlägt.
	#? Beispielaufruf:
	# menurostart
##
function menurostart() {
	# Letzte Bearbeitung 30.09.2023
	log info "Robust wird gestartet..."
	cd /$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS/bin || return 1	

	# DOTNETMODUS="yes"
	if [[ "${DOTNETMODUS}" == "yes" ]]; then
		screen -fa -S RO -d -U -m dotnet Robust.dll
	fi

	# DOTNETMODUS="no"
	if [[ "${DOTNETMODUS}" == "no" ]]; then
		screen -fa -S RO -d -U -m mono Robust.exe
	fi

	sleep $ROBUSTWARTEZEIT

	log info " Robust wurde gestartet"
	return 0
}

## *  rostop
	#? Beschreibung:
	# Diese Funktion dient dazu, den Robust-Server zu beenden. Sie überprüft, ob ein Screen mit dem Namen "RO" existiert. Falls ja, sendet sie das Shutdown-Kommando an den Robust-Server und wartet eine definierte Wartezeit (WARTEZEIT). Wenn der Robust-Server erfolgreich beendet wurde, gibt die Funktion eine Warnmeldung aus und kehrt mit einem Rückgabewert 0 zurück. Andernfalls gibt sie eine Fehlermeldung aus und kehrt mit einem Rückgabewert 1 zurück.
	#? Parameter: Keine.
	#? Rückgabewert:
	# - Erfolgreich: Die Funktion gibt eine Warnmeldung aus und kehrt mit einem Rückgabewert 0 zurück, wenn der Robust-Server erfolgreich beendet wurde.
	# - Fehler: Die Funktion gibt eine Fehlermeldung aus und kehrt mit einem Rückgabewert 1 zurück, wenn der Robust-Server nicht vorhanden ist.
	#? Beispielaufruf:
	# rostop
##
function rostop() {
	# Letzte Bearbeitung 30.09.2023
	if screen -list | grep -q "RO"; then
		screen -S RO -p 0 -X eval "stuff 'shutdown'^M"
		log warn "Robust Beenden"
		sleep $WARTEZEIT
		return 0
	else
		log error "Robust nicht vorhanden"
		return 1
	fi
}

## *  menurostop
	#? Beschreibung:
	# Diese Funktion dient dazu, den Robust-Server zu beenden. Sie überprüft, ob ein Screen mit dem Namen "RO" existiert. Falls ja, sendet sie das Shutdown-Kommando an den Robust-Server und wartet eine definierte Wartezeit (WARTEZEIT). Wenn der Robust-Server erfolgreich beendet wurde, gibt die Funktion eine Warnmeldung aus und kehrt mit einem Rückgabewert 0 zurück. Andernfalls gibt sie eine Fehlermeldung aus und kehrt mit einem Rückgabewert 1 zurück.
	#? Parameter: Keine.
	#? Rückgabewert:
	# - Erfolgreich: Die Funktion gibt eine Warnmeldung aus und kehrt mit einem Rückgabewert 0 zurück, wenn der Robust-Server erfolgreich beendet wurde.
	# - Fehler: Die Funktion gibt eine Fehlermeldung aus und kehrt mit einem Rückgabewert 1 zurück, wenn der Robust-Server nicht vorhanden ist.
	#? Beispielaufruf:
	# menurostop
##
function menurostop() {
	# Letzte Bearbeitung 30.09.2023
	if screen -list | grep -q "RO"; then
		screen -S RO -p 0 -X eval "stuff 'shutdown'^M"
		log warn "Robust Beenden"
		sleep $WARTEZEIT
	else
		log error "Robust nicht vorhanden"
	fi
}

## *  mostart
	#? Beschreibung:
	# Diese Funktion dient dazu, den MoneyServer zu starten. Sie wechselt in das Verzeichnis, in dem sich die ausführbare Datei des MoneyServers befindet, und startet den Server im Hintergrund. Die Wahl zwischen der Ausführung mit "dotnet" oder "mono" wird anhand des Wertes der Umgebungsvariable DOTNETMODUS getroffen. Nach dem Start wird eine definierte Wartezeit (MONEYWARTEZEIT) eingehalten, um sicherzustellen, dass der Server vollständig gestartet ist. Die Funktion gibt eine Informationsmeldung aus und kehrt mit einem Rückgabewert 0 zurück.
	#? Parameter: Keine.
	#? Rückgabewert:
	# - Erfolgreich: Die Funktion gibt eine Informationsmeldung aus und kehrt mit einem Rückgabewert 0 zurück, nachdem der MoneyServer gestartet wurde.
	#? Beispielaufruf:
	# mostart
##
function mostart() {
	# Letzte Bearbeitung 30.09.2023
	log info "Money wird gestartet..."
	cd /$STARTVERZEICHNIS/$MONEYVERZEICHNIS/bin || return 1
	
	#screen -fa -S MO -d -U -m mono MoneyServer.exe
	# DOTNETMODUS="yes"
	if [[ "${DOTNETMODUS}" == "yes" ]]; then
		screen -fa -S MO -d -U -m dotnet MoneyServer.dll
	fi

	# DOTNETMODUS="no"
	if [[ "${DOTNETMODUS}" == "no" ]]; then
		screen -fa -S MO -d -U -m mono MoneyServer.exe
	fi

	sleep $MONEYWARTEZEIT
	log info " Money wurde gestartet"
	return 0
}

## *  menumostart
	#? Beschreibung:
	# Diese Funktion dient dazu, den MoneyServer zu starten. Sie wechselt in das Verzeichnis, in dem sich die ausführbare Datei des MoneyServers befindet, und startet den Server im Hintergrund. Die Wahl zwischen der Ausführung mit "dotnet" oder "mono" wird anhand des Wertes der Umgebungsvariable DOTNETMODUS getroffen. Nach dem Start wird eine definierte Wartezeit (MONEYWARTEZEIT) eingehalten, um sicherzustellen, dass der Server vollständig gestartet ist. Die Funktion gibt eine Informationsmeldung aus und kehrt mit einem Rückgabewert 0 zurück.
	#? Parameter: Keine.
	#? Rückgabewert:
	# - Erfolgreich: Die Funktion gibt eine Informationsmeldung aus und kehrt mit einem Rückgabewert 0 zurück, nachdem der MoneyServer gestartet wurde.
	#? Beispielaufruf:
	# menumostart
##
function menumostart() {
	# Letzte Bearbeitung 30.09.2023
	log info "Money wird gestartet..."
	cd /$STARTVERZEICHNIS/$MONEYVERZEICHNIS/bin || return 1
	
	# DOTNETMODUS="yes"
	if [[ "${DOTNETMODUS}" == "yes" ]]; then
		screen -fa -S MO -d -U -m dotnet MoneyServer.dll
	fi

	# DOTNETMODUS="no"
	if [[ "${DOTNETMODUS}" == "no" ]]; then
		screen -fa -S MO -d -U -m mono MoneyServer.exe
	fi

	sleep $MONEYWARTEZEIT
	log info " Money wurde gestartet"
	return 0
}

## *  mostop
	#? Beschreibung:
	# Diese Funktion dient dazu, den MoneyServer zu beenden. Sie überprüft zunächst, ob ein Bildschirm (Screen) mit dem Namen "MO" vorhanden ist, was auf einen laufenden MoneyServer hinweisen würde. Wenn der MoneyServer gefunden wird, sendet die Funktion einen Befehl zum Herunterfahren an den Bildschirm. Anschließend wird eine definierte Wartezeit (MONEYWARTEZEIT) eingehalten, um sicherzustellen, dass der Server ordnungsgemäß beendet wurde. Die Funktion gibt eine Warnmeldung aus und kehrt mit einem Rückgabewert 0 zurück, wenn der MoneyServer erfolgreich beendet wurde. Andernfalls wird eine Fehlermeldung ausgegeben, und die Funktion gibt einen Rückgabewert 1 zurück.
	#? Parameter: Keine.
	#? Rückgabewert:
	# - Erfolgreich: Die Funktion gibt eine Warnmeldung aus und kehrt mit einem Rückgabewert 0 zurück, nachdem der MoneyServer erfolgreich beendet wurde.
	# - Fehlerhaft: Die Funktion gibt eine Fehlermeldung aus und kehrt mit einem Rückgabewert 1 zurück, wenn der MoneyServer nicht gefunden wurde.
	#? Beispielaufruf:
	# mostop
##
function mostop() {
	# Letzte Bearbeitung 30.09.2023
	if screen -list | grep -q "MO"; then
		screen -S MO -p 0 -X eval "stuff 'shutdown'^M"
		log warn "Money Beenden"
		sleep $MONEYWARTEZEIT
		return 0
	else
		log error "Money nicht vorhanden"
		return 1
	fi
}

## *  menumostop
	#? Beschreibung:
	# Diese Funktion dient dazu, den MoneyServer zu beenden. Sie überprüft zunächst, ob ein Bildschirm (Screen) mit dem Namen "MO" vorhanden ist, was auf einen laufenden MoneyServer hinweisen würde. Wenn der MoneyServer gefunden wird, sendet die Funktion einen Befehl zum Herunterfahren an den Bildschirm. Anschließend wird eine definierte Wartezeit (MONEYWARTEZEIT) eingehalten, um sicherzustellen, dass der Server ordnungsgemäß beendet wurde. Die Funktion gibt eine Warnmeldung aus und kehrt mit einem Rückgabewert 0 zurück, wenn der MoneyServer erfolgreich beendet wurde. Andernfalls wird eine Fehlermeldung ausgegeben, und die Funktion gibt einen Rückgabewert 1 zurück.
	#? Parameter: Keine.
	#? Rückgabewert:
	# - Erfolgreich: Die Funktion gibt eine Warnmeldung aus und kehrt mit einem Rückgabewert 0 zurück, nachdem der MoneyServer erfolgreich beendet wurde.
	# - Fehlerhaft: Die Funktion gibt eine Fehlermeldung aus und kehrt mit einem Rückgabewert 1 zurück, wenn der MoneyServer nicht gefunden wurde.
	#? Beispielaufruf:
	# menumostop
##
function menumostop() {
	# Letzte Bearbeitung 30.09.2023
	if screen -list | grep -q "MO"; then
		screen -S MO -p 0 -X eval "stuff 'shutdown'^M"
		log warn "Money Beenden"
		sleep $MONEYWARTEZEIT
		return 0
	else
		log error "Money nicht vorhanden"
		return 1
	fi
}

## *  osscreenstop
	#? Beschreibung:
	# Diese Funktion dient dazu, einen bestimmten Screen (Bildschirm) zu beenden. Sie akzeptiert einen Parameter, der den Namen des zu beendenden Screens angibt (SCREENSTOPSCREEN). Die Funktion überprüft zunächst, ob der angegebene Screen existiert, indem sie die Liste der aktiven Screens durchsucht. Wenn der Screen gefunden wird, wird er durch den Befehl "screen -S SCREENSTOPSCREEN -X quit" beendet. Die Funktion gibt eine Erfolgsmeldung aus und kehrt mit einem Rückgabewert 0 zurück, wenn der Screen erfolgreich beendet wurde. Andernfalls wird eine Fehlermeldung ausgegeben, und die Funktion gibt einen Rückgabewert 1 zurück.
	#? Parameter:
	# - SCREENSTOPSCREEN: Der Name des zu beendenden Screens.
	#? Rückgabewert:
	# - Erfolgreich: Die Funktion gibt eine Erfolgsmeldung aus und kehrt mit einem Rückgabewert 0 zurück, nachdem der Screen erfolgreich beendet wurde.
	# - Fehlerhaft: Die Funktion gibt eine Fehlermeldung aus und kehrt mit einem Rückgabewert 1 zurück, wenn der angegebene Screen nicht gefunden wurde.
	#? Beispielaufruf:
	# osscreenstop "mein_screen"
##
function osscreenstop() {
	# Letzte Bearbeitung 30.09.2023
	SCREENSTOPSCREEN=$1
	if screen -list | grep -q "$SCREENSTOPSCREEN"; then
		log text "Screeen $SCREENSTOPSCREEN Beenden"
		screen -S "$SCREENSTOPSCREEN" -X quit
		return 0
	else
		log error "Screeen $SCREENSTOPSCREEN nicht vorhanden"
		return 1
	fi
	log text "No screen session found. Ist hier kein Fehler, sondern ein Beweis, das alles zuvor sauber heruntergefahren wurde."
}

## *  gridstart
	#? Beschreibung:
	# Die Funktion `gridstart` dient dazu, die verschiedenen Komponenten eines OpenSimulator-Grids (Robust und Money) zu starten. Zunächst werden die Einstellungen für den OpenSimulator über die Funktion `ossettings` konfiguriert. Anschließend überprüft die Funktion, ob die Screens für Robust und Money bereits laufen. Wenn eines oder beide der Screens nicht aktiv sind, werden sie gestartet, indem die Funktionen `rostart` und `mostart` aufgerufen werden. Diese Funktion ist hilfreich, um sicherzustellen, dass alle erforderlichen Komponenten des Grids aktiv sind.
	#? Parameter:
	# Diese Funktion akzeptiert keine Parameter.
	#? Rückgabewert:
	# - Erfolgreich: Die Funktion gibt einen Rückgabewert 0 zurück, nachdem sie die erforderlichen Komponenten gestartet hat.
	# - Fehlerhaft: Die Funktion gibt keine Fehlermeldungen aus, sondern protokolliert nur, wenn Robust oder Money bereits laufen. Sie gibt einen Rückgabewert 0 zurück, wenn alle Komponenten gestartet wurden.
	#? Beispielaufruf:
	# gridstart
##
function gridstart() {
	# Letzte Bearbeitung 30.09.2023
	ossettings
	if screen -list | grep -q RO; then
		log error "Robust laeuft bereits"
	else
		rostart
	fi
	if screen -list | grep -q MO; then
		log error "Money laeuft bereits"
	else
		mostart
	fi
	return 0
}

## *  menugridstart
	#? Beschreibung:
	# Die Funktion `menugridstart` dient dazu, die verschiedenen Komponenten eines OpenSimulator-Grids (Robust und Money) zu starten. Zunächst werden die Einstellungen für den OpenSimulator über die Funktion `ossettings` konfiguriert. Anschließend überprüft die Funktion, ob die Screens für Robust und Money bereits laufen. Wenn eines oder beide der Screens nicht aktiv sind, werden sie gestartet, indem die Funktionen `rostart` und `mostart` aufgerufen werden. Diese Funktion ist hilfreich, um sicherzustellen, dass alle erforderlichen Komponenten des Grids aktiv sind.
	#? Parameter:
	# Diese Funktion akzeptiert keine Parameter.
	#? Rückgabewert:
	# - Erfolgreich: Die Funktion gibt einen Rückgabewert 0 zurück, nachdem sie die erforderlichen Komponenten gestartet hat.
	# - Fehlerhaft: Die Funktion gibt keine Fehlermeldungen aus, sondern protokolliert nur, wenn Robust oder Money bereits laufen. Sie gibt einen Rückgabewert 0 zurück, wenn alle Komponenten gestartet wurden.
	#? Beispielaufruf:
	# menugridstart
##
function menugridstart() {
	# Letzte Bearbeitung 30.09.2023
	ossettings
	log line
	if screen -list | grep -q RO; then
		log error " Robust laeuft bereits"
	else
		menurostart
	fi
	if screen -list | grep -q MO; then
		log error "MoneyServer laeuft bereits"
	else
		menumostart
	fi
}

## *  icecaststart
	#? Beschreibung:
	# Die Funktion `icecaststart` dient dazu, den Icecast-Streaming-Server zu starten. Der Icecast-Server wird über das init.d-Systemdienstskript gestartet. Diese Funktion ermöglicht es, den Icecast-Server auf einfache Weise zu aktivieren, um Streaming-Dienste bereitzustellen.
	#? Parameter:
	# Diese Funktion akzeptiert keine Parameter.
	#? Rückgabewert:
	# - Erfolgreich: Wenn der Icecast-Server erfolgreich gestartet wurde, gibt die Funktion keinen expliziten Rückgabewert zurück.
	# - Fehlerhaft: Wenn ein Fehler beim Starten des Icecast-Servers auftritt, wird dies in der Regel von den Meldungen des init.d-Scripts gemeldet. Die Funktion gibt keinen eigenen Rückgabewert zurück.
	#? Beispielaufruf:
	# icecaststart
##
function icecaststart() {
	# Letzte Bearbeitung 30.09.2023
	# Starte den Icecast-Streaming-Server mit dem init.d-Systemdienstskript
	sudo /etc/init.d/icecast2 start
}

## *  icecaststop
	#? Beschreibung:
	# Die Funktion `icecaststop` dient dazu, den Icecast-Streaming-Server zu stoppen. Der Icecast-Server wird über das init.d-Systemdienstskript gestoppt. Diese Funktion ermöglicht es, den Icecast-Server auf einfache Weise zu deaktivieren.
	#? Parameter:
	# Diese Funktion akzeptiert keine Parameter.
	#? Rückgabewert:
	# - Erfolgreich: Wenn der Icecast-Server erfolgreich gestoppt wurde, gibt die Funktion keinen expliziten Rückgabewert zurück.
	# - Fehlerhaft: Wenn ein Fehler beim Stoppen des Icecast-Servers auftritt, wird dies in der Regel von den Meldungen des init.d-Scripts gemeldet. Die Funktion gibt keinen eigenen Rückgabewert zurück.
	#? Beispielaufruf:
	# icecaststop
##
function icecaststop() {
	# Letzte Bearbeitung 30.09.2023
	# Stoppe den Icecast-Streaming-Server mit dem init.d-Systemdienstskript
	sudo /etc/init.d/icecast2 stop
}

## *  icecastrestart
	#? Beschreibung:
	# Die Funktion `icecastrestart` dient dazu, den Icecast-Streaming-Server neu zu starten. Der Icecast-Server wird über das init.d-Systemdienstskript neu gestartet. Diese Funktion ermöglicht es, den Icecast-Server nach Änderungen in der Konfiguration neu zu laden oder nach einem Fehlerzustand neu zu starten.
	#? Parameter:
	# Diese Funktion akzeptiert keine Parameter.
	#? Rückgabewert:
	# - Erfolgreich: Wenn der Icecast-Server erfolgreich neu gestartet wurde, gibt die Funktion keinen expliziten Rückgabewert zurück.
	# - Fehlerhaft: Wenn ein Fehler beim Neustarten des Icecast-Servers auftritt, wird dies in der Regel von den Meldungen des init.d-Scripts gemeldet. Die Funktion gibt keinen eigenen Rückgabewert zurück.
	#? Beispielaufruf:
	# icecastrestart
##
function icecastrestart() {
	# Letzte Bearbeitung 30.09.2023
	# Starte den Icecast-Streaming-Server neu mit dem init.d-Systemdienstskript
	sudo /etc/init.d/icecast2 restart
}

## *  icecastversion
	#? Beschreibung:
	# Die Funktion `icecastversion` gibt die Version des Icecast-Streaming-Servers aus. Sie ruft das Icecast-Programm mit der Option "-v" auf, um die Version anzuzeigen, und gibt die Ausgabe auf dem Bildschirm aus.
	#? Parameter:
	# Diese Funktion akzeptiert keine Parameter.
	#? Rückgabewert:
	# Die Funktion gibt die Version des Icecast-Servers auf dem Bildschirm aus.
	#? Beispielaufruf:
	# icecastversion
##
function icecastversion() {
	# Letzte Bearbeitung 30.09.2023
	# Gibt die Version des Icecast-Servers aus
	/usr/bin/icecast2 -v
}


#──────────────────────────────────────────────────────────────────────────────────────────
#* Dateifunktionen Funktionsgruppe
#──────────────────────────────────────────────────────────────────────────────────────────

## *  saveinventar
	#? Beschreibung:
	# Diese Funktion speichert ein Inventar in einem Bildschirm (Screen) mit dem angegebenen Namen und Verzeichnis.
	#? Parameter:
	# $1 - Name des Inventars
	# $2 - Verzeichnis, in dem das Inventar gespeichert werden soll
	# $3 - Passwort (optional)
	# $4 - Dateiname, unter dem das Inventar gespeichert wird
	#? Verwendungsbeispiel:
	# saveinventar "MeinInventar" "/pfad/zum/verzeichnis" "geheimesPasswort" "inventar.txt"
##
function saveinventar() {
	# Letzte Bearbeitung 01.10.2023
	SAVEINVSCREEN="sim1"
	NAME=$1
	VERZEICHNIS=$2
	PASSWORD=$3
	DATEI=$4
	if screen -list | grep -q "$SAVEINVSCREEN"; then
		log info "OSCOMMAND: save iar $NAME $VERZEICHNIS ***** $DATEI "
		screen -S "$SAVEINVSCREEN" -p 0 -X eval "stuff 'save iar $NAME $VERZEICHNIS $PASSWORD $DATEI'^M"
		return 0
	else
		log info "OSCOMMAND: Der Screen $SAVEINVSCREEN existiert nicht"
		return 1
	fi
}

## *  menusaveinventar
	#? Beschreibung:
	# Diese Funktion ermöglicht es dem Benutzer, Eingaben über das Dialog-Programm vorzunehmen, um Informationen für das Speichern eines Inventars einzugeben. Die eingegebenen Informationen werden dann an den Icecast-Server gesendet, um das Inventar zu speichern.
	# Letzte Bearbeitung: 01.10.2023
	#? Parameter:
	# Keine Parameter, da die Funktion Benutzereingaben über das Dialog-Programm verarbeitet.
	# Abhängigkeiten:
	# - Das Dialog-Programm muss auf dem System installiert sein, da es für die Benutzereingabe verwendet wird.
	# - ScreenLog: Eine externe Funktion oder ein externes Tool zur Protokollierung von Informationen.
	# Ausgabe:
	# Die Funktion gibt Erfolgsmeldungen oder Fehlermeldungen aus, je nachdem, ob der Bildschirm existiert und das Inventar erfolgreich gespeichert wurde.
	# Exit-Status:
	# 0 - Das Inventar wurde erfolgreich gespeichert.
	# 1 - Ein Fehler ist aufgetreten (z. B. der Bildschirm existiert nicht oder Benutzereingaben wurden abgebrochen).
##
function menusaveinventar() {
	# Letzte Bearbeitung 01.10.2023
	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then

		# Einstellungen
		boxbacktitel="opensimMULTITOOL"
		boxtitel="opensimMULTITOOL Eingabe"
		formtitle="Inventarverzeichnis speichern"
		lable1="NAME:"
		lablename1="John Doe"
		lable2="VERZEICHNIS:"
		lablename2="/texture"
		lable3="PASSWORD:"
		lablename3="PASSWORD"
		lable4="DATEI:"
		lablename4="/$STARTVERZEICHNIS/texture.iar"

		# Abfrage
		saveinventarBOXERGEBNIS=$(dialog --backtitle "$boxbacktitel" --title "$boxtitel" --form "$formtitle" 25 60 16 "$lable1" 1 1 "$lablename1" 1 25 25 30 "$lable2" 2 1 "$lablename2" 2 25 25 30 "$lable3" 3 1 "$lablename3" 3 25 25 30 "$lable4" 4 1 "$lablename4" 4 25 25 30 3>&1 1>&2 2>&3 3>&-)

		# Zeilen aus einer Variablen zerlegen und in verschiedenen Variablen schreiben.
		NAME=$(echo "$saveinventarBOXERGEBNIS" | sed -n '1p')
		VERZEICHNIS=$(echo "$saveinventarBOXERGEBNIS" | sed -n '2p')
		PASSWORD=$(echo "$saveinventarBOXERGEBNIS" | sed -n '3p')
		DATEI=$(echo "$saveinventarBOXERGEBNIS" | sed -n '4p')

		# Alles loeschen.
		dialogclear
		ScreenLog
	else
		# Alle Aktionen ohne dialog
		log rohtext "Keine Menuelose Funktion" | exit
	fi # dialog Aktionen Ende

	SAVEINVSCREEN="sim1"
	if screen -list | grep -q "$SAVEINVSCREEN"; then
		log info "OSCOMMAND: save iar $NAME $VERZEICHNIS ***** $DATEI "
		screen -S "$SAVEINVSCREEN" -p 0 -X eval "stuff 'save iar $NAME $VERZEICHNIS $PASSWORD $DATEI'^M"
		return 0
	else
		log error "OSCOMMAND: Der Screen $SAVEINVSCREEN existiert nicht"
		return 1
	fi

	# Zum schluss alle Variablen loeschen.
	unset SAVEINVSCREEN NAME VERZEICHNIS PASSWORD DATEI
}

## *  menuworks
	#? Beschreibung:
	# Die Funktion `menuworks` überprüft den Status eines OpenSimulator-Screens und gibt entsprechende Meldungen aus, ob der Screen online oder offline ist. Sie kann sowohl mit als auch ohne das Dialog-Programm verwendet werden, abhängig von dessen Verfügbarkeit auf dem System.
	#? Parameter:
	# $1 - Der Name des OpenSimulator-Screens, dessen Status überprüft werden soll.
	# Abhängigkeiten:
	# - Das Dialog-Programm (optional) für Benutzereingabe und -ausgabe.
	# - ScreenLog: Eine externe Funktion oder ein externes Tool zur Protokollierung von Informationen.
	# Ausgabe:
	# Je nach Status des OpenSimulator-Screens gibt die Funktion Dialog-Meldungen oder Log-Meldungen aus.
	# Exit-Status:
	# 0 - Der Screen ist online.
	# 1 - Der Screen ist offline oder es gab Probleme bei der Überprüfung.
##
function menuworks() {
	# Letzte Bearbeitung 01.10.2023
	WORKSSCREEN=$1 # OpenSimulator, Verzeichnis und Screen Name

	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then
		# Alle Aktionen mit dialog
		boxtitel="opensimMULTITOOL Eingabe"
		boxtext="Screen Name:"
		WORKSSCREEN=$(dialog --backtitle "opensimMULTITOOL $VERSION" --title "$boxtitel" --inputbox "$boxtext" 8 40 3>&1 1>&2 2>&3 3>&-)
		dialogclear
		ScreenLog

		if ! screen -list | grep -q "$WORKSSCREEN"; then
			# es laeuft nicht - not work
			dialog --backtitle "opensimMULTITOOL $VERSION" --msgbox "OpenSimulator $WORKSSCREEN OFFLINE!" 5 40
			dialogclear
			ScreenLog
		else
			# es laeuft - work
			dialog --backtitle "opensimMULTITOOL $VERSION" --msgbox "OpenSimulator $WORKSSCREEN ONLINE!" 5 40
			dialogclear
			ScreenLog
		fi
	else
		# Alle Aktionen ohne dialog
		if ! screen -list | grep -q "$WORKSSCREEN"; then
			# es laeuft nicht - not work
			log info "WORKS: $WORKSSCREEN OFFLINE!"
			return 1
		else
			# es laeuft - work
			log info "WORKS: $WORKSSCREEN ONLINE!"
			return 0
		fi
	fi
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then hauptmenu; fi
}

## *  works
	#? Beschreibung:
	# Die Funktion `works` überprüft den Status eines OpenSimulator-Screens und gibt entsprechende Log-Meldungen aus, ob der Screen online oder offline ist.
	#? Parameter:
	# $1 - Der Name des OpenSimulator-Screens, dessen Status überprüft werden soll.
	# Abhängigkeiten:
	# Keine speziellen Abhängigkeiten, da diese Funktion keine Benutzereingabe und -ausgabe über das Dialog-Programm verwendet.
	# Ausgabe:
	# Je nach Status des OpenSimulator-Screens gibt die Funktion Log-Meldungen aus.
	# Exit-Status:
	# 0 - Der Screen ist online.
	# 1 - Der Screen ist offline oder es gab Probleme bei der Überprüfung.
##
function works() {
	# Letzte Bearbeitung 01.10.2023
	WORKSSCREEN=$1 # OpenSimulator, Verzeichnis und Screen Name

	# Alle Aktionen ohne dialog
	if ! screen -list | grep -q "$WORKSSCREEN"; then
		# es laeuft nicht - not work
		log info "WORKS: $WORKSSCREEN OFFLINE!"
		return 1
	else
		# es laeuft - work
		log info "WORKS: $WORKSSCREEN ONLINE!"
		return 0
	fi
}

## *  waslauft
	#? Beschreibung:
	# Die Funktion `waslauft` zeigt eine Liste der aktiven Screens an, die mithilfe des `screen`-Befehls ausgeführt werden. Sie bereinigt die Ausgabe und gibt eine formatierte Liste von Screen-Namen zurück.
	#? Parameter:
	# Diese Funktion akzeptiert keine Parameter.
	# Abhängigkeiten:
	# Keine speziellen Abhängigkeiten, da diese Funktion nur den `screen`-Befehl verwendet, um die Liste der aktiven Screens abzurufen.
	# Ausgabe:
	# Die Funktion gibt eine formatierte Liste von Screen-Namen auf dem Bildschirm aus.
	# Exit-Status:
	# Die Funktion gibt immer den Exit-Status 0 zurück, da keine fehlerhaften Zustände erwartet werden.
##
function waslauft() {
	# Letzte Bearbeitung 01.10.2023
	# Die screen -ls ausgabe zu einer Liste aendern.
	# sed '1d' = erste Zeile loeschen - sed '$d' letzte Zeile loeschen.
	# awk -F. alles vor dem Punkt entfernen - -F\( alles hinter dem  ( loeschen.
	ergebnis=$(screen -ls | sed '1d' | sed '$d' | awk -F. '{print $2}' | awk -F\( '{print $1}')
	echo "$ergebnis"
	return 0
}

## *  menuwaslauft
	#? Beschreibung:
	# Die Funktion `menuwaslauft` zeigt eine Liste der aktiven Screens an, die mithilfe des `screen`-Befehls ausgeführt werden. Sie bereinigt die Ausgabe und zeigt die formatierte Liste der Screen-Namen in einem Dialogfeld an.
	#? Parameter:
	# Diese Funktion akzeptiert keine Parameter.
	# Abhängigkeiten:
	# - Das Dialog-Programm muss auf dem System installiert sein, um das Dialogfeld anzuzeigen.
	# - dialogclear: Eine Funktion oder ein externes Tool zum Löschen des Dialog-Inhalts.
	# Ausgabe:
	# Die Funktion zeigt eine formatierte Liste von Screen-Namen in einem Dialogfeld an.
	# Exit-Status:
	# Die Funktion gibt immer den Exit-Status 0 zurück, da keine fehlerhaften Zustände erwartet werden.
##
function menuwaslauft() {
	# Letzte Bearbeitung 01.10.2023
	# Die screen -ls ausgabe zu einer Liste aendern.
	# sed '1d' = erste Zeile loeschen - sed '$d' letzte Zeile loeschen.
	# awk -F. alles vor dem Punkt entfernen - -F\( alles hinter dem  ( loeschen.
	ergebnis=$(screen -ls | sed '1d' | sed '$d' | awk -F. '{print $2}' | awk -F\( '{print $1}')
	echo "$ergebnis"
	# dialog --infobox      "Laufende Simulatoren: $ergebnis" $HEIGHT $WIDTH; dialogclear
	dialog --msgbox "Laufende Simulatoren:\n $ergebnis" 20 60
	dialogclear
	hauptmenu
	return 0
}

## *  checkfile
	#? Beschreibung:
	# Die Funktion `checkfile` überprüft, ob eine angegebene Datei existiert. Sie gibt den Exit-Status 0 zurück, wenn die Datei existiert, andernfalls gibt sie einen anderen Exit-Status zurück.
	#? Parameter:
	# $1 - Der vollständige Pfad zur zu überprüfenden Datei.
	# Abhängigkeiten:
	# Keine speziellen Abhängigkeiten, da diese Funktion nur die Dateiexistenz überprüft.
	# Ausgabe:
	# Diese Funktion gibt keine Ausgabe auf dem Bildschirm aus, sondern verwendet den Exit-Status, um das Ergebnis der Dateiüberprüfung anzuzeigen.
	# Exit-Status:
	# 0 - Die Datei existiert.
	# Anderer Wert (normalerweise 1) - Die Datei existiert nicht oder es gab Probleme bei der Überprüfung.
##
function checkfile() {
	# Letzte Bearbeitung 01.10.2023
	# Verwendung als Einzeiler: checkfile /pfad/zur/datei && echo "File exists" || echo "File not found!"
	DATEINAME=$1
	[ -f "$DATEINAME" ]
	return $?
}

## *  mapdel
	#? Beschreibung:
	# Die Funktion `mapdel` löscht die Kartenkacheln (maptiles) eines OpenSimulator-Verzeichnisses, sofern das Verzeichnis existiert. Sie überprüft zuerst, ob das Verzeichnis existiert, und löscht dann den Inhalt des "maptiles"-Verzeichnisses.
	#? Parameter:
	# $1 - Das Verzeichnis, dessen Kartenkacheln gelöscht werden sollen.
	# Abhängigkeiten:
	# - Das Verzeichnis, dessen Kartenkacheln gelöscht werden sollen, sollte bereits vorhanden sein.
	# - Log-Funktion: Eine Funktion oder ein externes Tool zum Protokollieren von Informationen.
	# Ausgabe:
	# Die Funktion gibt Log-Meldungen aus, um den Status des Löschvorgangs anzuzeigen.
	# Exit-Status:
	# 0 - Die Kartenkacheln wurden erfolgreich gelöscht oder das Verzeichnis existiert nicht.
	# 1 - Es gab Probleme beim Löschen der Kartenkacheln oder das Verzeichnis existiert nicht.
##
function mapdel() {
	# Letzte Bearbeitung 01.10.2023
	VERZEICHNIS=$1
	if [ -d "$VERZEICHNIS" ]; then
		log info "MAPDEL: OpenSimulator maptile $VERZEICHNIS geloescht"
		cd /$STARTVERZEICHNIS/"$VERZEICHNIS"/bin || return 1
		rm -r maptiles/*
		return 0
	else
		log error "MAPDEL: maptile $VERZEICHNIS nicht gefunden"
		return 1
	fi
}

## *  logdel
	#? Beschreibung:
	# Die Funktion `logdel` löscht Log-Dateien aus einem angegebenen Verzeichnis, sofern das Verzeichnis existiert. Sie überprüft zuerst, ob das Verzeichnis existiert, und löscht dann alle Dateien mit der Erweiterung ".log" aus dem Verzeichnis.
	#? Parameter:
	# $1 - Das Verzeichnis, dessen Log-Dateien gelöscht werden sollen.
	# Abhängigkeiten:
	# - Das Verzeichnis, dessen Log-Dateien gelöscht werden sollen, sollte bereits vorhanden sein.
	# - Log-Funktion: Eine Funktion oder ein externes Tool zum Protokollieren von Informationen.
	# Ausgabe:
	# Die Funktion gibt Log-Meldungen aus, um den Status des Löschvorgangs anzuzeigen.
	# Exit-Status:
	# 0 - Die Log-Dateien wurden erfolgreich gelöscht oder das Verzeichnis existiert nicht.
	# 1 - Es gab Probleme beim Löschen der Log-Dateien oder das Verzeichnis existiert nicht.
##
function logdel() {
	# Letzte Bearbeitung 01.10.2023
	VERZEICHNIS=$1
	if [ -d "$VERZEICHNIS" ]; then
		rm /$STARTVERZEICHNIS/"$VERZEICHNIS"/bin/*.log 2>/dev/null || log rohtext "Ich habe die $VERZEICHNIS log nicht gefunden!"		
	else
		log error "LOGDEL: $VERZEICHNIS logs nicht gefunden"
		return 1
	fi
	log info "OpenSimulator log Verzeichnisse geloescht"
	return 0
}

## *  rologdel
	#? Beschreibung:
	# Die Funktion `rologdel` löscht bestimmte Log-Dateien und erstellt eine Besucherliste, sofern die entsprechenden Verzeichnisse existieren. Sie überprüft zuerst, ob die Verzeichnisse vorhanden sind, und löscht dann bestimmte Log-Dateien. Wenn die `VISITORLIST`-Variable auf "yes" gesetzt ist, werden Besucherinformationen aus der Robust-Log-Datei extrahiert und in eine separate Datei geschrieben.
	#? Parameter:
	# Keine Parameter werden von dieser Funktion akzeptiert.
	# Abhängigkeiten:
	# - Die Verzeichnisse, deren Log-Dateien gelöscht werden sollen, sollten bereits vorhanden sein.
	# - Log-Funktion: Eine Funktion oder ein externes Tool zum Protokollieren von Informationen.
	# Ausgabe:
	# Die Funktion gibt Log-Meldungen aus, um den Status des Löschvorgangs und das Erstellen der Besucherliste anzuzeigen.
	# Exit-Status:
	# 0 - Die Log-Dateien wurden erfolgreich gelöscht oder die Verzeichnisse existieren nicht.
	# Anderer Wert (normalerweise 1) - Es gab Probleme beim Löschen der Log-Dateien oder die Verzeichnisse existieren nicht.
	#? Hinweise:
	# - Die Funktion überprüft zuerst, ob die Verzeichnisse existieren (`-d`-Test) und gibt entsprechende Log-Meldungen aus.
	# - Wenn die `VISITORLIST`-Variable auf "yes" gesetzt ist, werden Besucherinformationen aus der Robust-Log-Datei extrahiert und in eine separate Datei geschrieben.
	# - Die Funktion gibt Log-Meldungen aus, um den Status des Löschvorgangs und das Erstellen der Besucherliste anzuzeigen.
##
function rologdel() {
	# Letzte Bearbeitung 01.10.2023
	if [ -d /$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS ]; then	
		if [ "$VISITORLIST" = "yes" ]; then 
			# Schreibe alle Besucher in eine Datei namens DATUM_visitorlist.log.
			sed -n -e '/'"INFO  (Thread Pool Worker)"'/p' /$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS/bin/Robust.log >> /$STARTVERZEICHNIS/"$DATEIDATUM"_osmvisitorlist.log;
			# Zeilenumgruch nach jeder Zeile.
			sed -i 's/$/\n/g' /$STARTVERZEICHNIS/"$DATEIDATUM"_osmvisitorlist.log

			# Hiermit wird das ganze etwas lesbarer.
			# Etwas umstaendlich aber was besseres faellt mir auf die schnelle nicht ein.
			text1="INFO  (Thread Pool Worker) - OpenSim.Services.LLLoginService.LLLoginService \[LLOGIN SERVICE\]: "
			text2="INFO  (Thread Pool Worker) - OpenSim.Services.HypergridService.GatekeeperService \[GATEKEEPER SERVICE\]: "
			cat /$STARTVERZEICHNIS/"$DATEIDATUM"_osmvisitorlist.log | sed -e 's/, /\n/g' -e 's/'"$text1"'/\n/g' -e 's/'"$text2"'/\n/g' -e 's/ using/\nusing/g' > /$STARTVERZEICHNIS/"$DATEIDATUM"_osmvisitorlist.txt
			log info "Besucherlisten wurden geschrieben!"; 
		fi

		# schauen ist Robust und Money da dann diese Logs auch loeschen!
		if [[ $ROBUSTVERZEICHNIS == "robust" ]]; then
			# log warn "Robust Log Dateien loeschen!"
			rm /$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS/bin/*.log 2>/dev/null || return 0
		else
			log info "Robust Log Dateien loeschen ist abgeschaltet!"
		fi

		# schauen ist Money da dann diese Logs auch loeschen!
		if [[ $MONEYVERZEICHNIS == "money" ]]; then
			log warn "Money Log Dateien loeschen!"
			rm /$STARTVERZEICHNIS/$MONEYVERZEICHNIS/bin/*.log 2>/dev/null || return 0
		else
			log info "Money Log Dateien loeschen ist abgeschaltet "
			log info "oder wurde mit der Robust.log geloescht!"
		fi

	fi	
	return 0
}

## *  menumapdel
	#? Beschreibung:
	# Die Funktion `menumapdel` ermöglicht das Löschen von Kartenkacheln (maptiles) eines OpenSimulator-Verzeichnisses. Sie kann entweder im Dialog-Modus oder im Standard-Modus (ohne Dialog) ausgeführt werden. Im Dialog-Modus wird der Benutzer nach dem zu löschenden Verzeichnis gefragt, während im Standard-Modus das Verzeichnis als Parameter übergeben wird.
	#? Parameter:
	# $1 (Optional) - Das Verzeichnis, dessen Kartenkacheln gelöscht werden sollen, wenn der Standard-Modus verwendet wird.
	# Abhängigkeiten:
	# - Das Verzeichnis, dessen Kartenkacheln gelöscht werden sollen, sollte bereits vorhanden sein.
	# - Log-Funktion: Eine Funktion oder ein externes Tool zum Protokollieren von Informationen.
	# Ausgabe:
	# Die Funktion gibt Log-Meldungen aus, um den Status des Löschvorgangs anzuzeigen.
	# Exit-Status:
	# 0 - Die Kartenkacheln wurden erfolgreich gelöscht oder das Verzeichnis existiert nicht.
	# 1 - Es gab Probleme beim Löschen der Kartenkacheln oder das Verzeichnis existiert nicht.
##
function menumapdel() {
	# Letzte Bearbeitung 01.10.2023
	#** dialog Aktionen
	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then
		# Alle Aktionen mit dialog
		boxtitel="opensimMULTITOOL Eingabe"
		boxtext="Verzeichnis:"
		VERZEICHNIS=$(dialog --backtitle "opensimMULTITOOL $VERSION" --title "$boxtitel" --inputbox "$boxtext" 8 40 3>&1 1>&2 2>&3 3>&-)
		dialogclear
		ScreenLog
	else
		# Alle Aktionen ohne dialog
		VERZEICHNIS=$1
	fi # dialog Aktionen Ende

	if [ -d "$VERZEICHNIS" ]; then
		cd /$STARTVERZEICHNIS/"$VERZEICHNIS"/bin || return 1
		rm -r maptiles/* || log line
		log info " MAPDEL: OpenSimulator maptile $VERZEICHNIS geloescht"
		return 0
	else
		log info "MAPDEL: maptile $VERZEICHNIS nicht gefunden"
		return 1
	fi
	hauptmenu
}

## *  menulogdel
	#? Beschreibung:
	# Die Funktion `menulogdel` ermöglicht das Löschen von Log-Dateien aus einem OpenSimulator-Verzeichnis. Sie kann entweder im Dialog-Modus oder im Standard-Modus (ohne Dialog) ausgeführt werden. Im Dialog-Modus wird der Benutzer nach dem zu löschenden Verzeichnis gefragt, während im Standard-Modus das Verzeichnis als Parameter übergeben wird.
	#? Parameter:
	# $1 (Optional) - Das Verzeichnis, dessen Log-Dateien gelöscht werden sollen, wenn der Standard-Modus verwendet wird.
	# Abhängigkeiten:
	# - Das Verzeichnis, dessen Log-Dateien gelöscht werden sollen, sollte bereits vorhanden sein.
	# - Log-Funktion: Eine Funktion oder ein externes Tool zum Protokollieren von Informationen.
	# Ausgabe:
	# Die Funktion gibt Log-Meldungen aus, um den Status des Löschvorgangs anzuzeigen.
	# Exit-Status:
	# 0 - Die Log-Dateien wurden erfolgreich gelöscht oder das Verzeichnis existiert nicht.
	# 1 - Es gab Probleme beim Löschen der Log-Dateien oder das Verzeichnis existiert nicht.
	#? Hinweise:
	# - Die Funktion kann im Dialog-Modus oder im Standard-Modus verwendet werden, je nachdem, ob Dialog installiert ist.
	# - Im Dialog-Modus wird der Benutzer nach dem zu löschenden Verzeichnis gefragt, während im Standard-Modus das Verzeichnis als Parameter übergeben wird.
	# - Die Funktion überprüft zuerst, ob das Verzeichnis existiert (`-d`-Test) und gibt entsprechende Log-Meldungen aus.
	# - Wenn das Verzeichnis existiert, werden alle Log-Dateien im Verzeichnis mit der Erweiterung ".log" gelöscht (`rm /$STARTVERZEICHNIS/"$VERZEICHNIS"/bin/*.log`).
	# - Die Funktion gibt Log-Meldungen aus, um den Status des Löschvorgangs anzuzeigen.
##
function menulogdel() {
	# Letzte Bearbeitung 01.10.2023
	#** dialog Aktionen
	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then
		# Alle Aktionen mit dialog
		boxtitel="opensimMULTITOOL Eingabe"
		boxtext="Verzeichnis:"
		VERZEICHNIS=$(dialog --backtitle "opensimMULTITOOL $VERSION" --title "$boxtitel" --inputbox "$boxtext" 8 40 3>&1 1>&2 2>&3 3>&-)
		dialogclear
		ScreenLog
	else
		# Alle Aktionen ohne dialog
		VERZEICHNIS=$1
	fi
	# dialog Aktionen Ende

	if [ -d "$VERZEICHNIS" ]; then
		rm /$STARTVERZEICHNIS/"$VERZEICHNIS"/bin/*.log 2>/dev/null || log line
		log info "LOGDEL: OpenSimulator log $VERZEICHNIS geloescht"
		return 0
	else
		log info "LOGDEL: logs nicht gefunden"
		return 1
	fi
	hauptmenu
}

## *  assetcachedel
	#? Beschreibung:
	# Die Funktion `assetcachedel` ermöglicht das Löschen des "assetcache"-Verzeichnisses aus einem OpenSimulator-Verzeichnis. Das Verzeichnis wird anhand des übergebenen Parameters `VERZEICHNIS` gelöscht.
	#? Parameter:
	# $1 - Das Verzeichnis, dessen "assetcache"-Verzeichnis gelöscht werden soll.
	# Abhängigkeiten:
	# - Das Verzeichnis, dessen "assetcache"-Verzeichnis gelöscht werden soll, sollte bereits vorhanden sein.
	# - Log-Funktion: Eine Funktion oder ein externes Tool zum Protokollieren von Informationen.
	# Ausgabe:
	# Die Funktion gibt Log-Meldungen aus, um den Status des Löschvorgangs anzuzeigen.
	# Exit-Status:
	# 0 - Das "assetcache"-Verzeichnis wurde erfolgreich gelöscht oder das Verzeichnis existiert nicht.
	# 1 - Es gab Probleme beim Löschen des "assetcache"-Verzeichnisses oder das Verzeichnis existiert nicht.
	#? Hinweise:
	# - Die Funktion überprüft zuerst, ob das Verzeichnis existiert (`-d`-Test) und gibt entsprechende Log-Meldungen aus.
	# - Wenn das Verzeichnis existiert, wird das "assetcache"-Verzeichnis rekursiv gelöscht (`rm -r /$STARTVERZEICHNIS/"$VERZEICHNIS"/bin/assetcache`).
	# - Die Funktion gibt Log-Meldungen aus, um den Status des Löschvorgangs anzuzeigen.
##
function assetcachedel() {
	# Letzte Bearbeitung 01.10.2023
	VERZEICHNIS=$1
	if [ -d "$VERZEICHNIS" ]; then
		rm -r /$STARTVERZEICHNIS/"$VERZEICHNIS"/bin/assetcache 2>/dev/null || log rohtext "Ich habe das $VERZEICHNIS assetcache Verzeichnis nicht gefunden!"	
	else
		log error "assetcachedel: $VERZEICHNIS assetcache Verzeichnis wurde nicht gefunden"
		return 1
	fi
	log info "OpenSimulator $VERZEICHNIS assetcache Verzeichnisse geloescht"
	return 0
}

## *  autoassetcachedel
	# Diese Funktion löscht Assetcache-Verzeichnisse in den in der "VERZEICHNISSLISTE" definierten Verzeichnissen.
	#? Parameter:
	# Keine
	#? Rückgabewert:
	# Die Funktion gibt immer 0 zurück.
	#? Beispiel:
	# autoassetcachedel
##
function autoassetcachedel() {
	# Letzte Bearbeitung 01.10.2023
	#log line
	makeverzeichnisliste
	sleep 1
	for ((i = 0; i < "$ANZAHLVERZEICHNISSLISTE"; i++)); do
		rm -r /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/assetcache 2>/dev/null | log info "OpenSimulator ${VERZEICHNISSLISTE[$i]} assetcache Verzeichnisse geloescht" || log warn "${VERZEICHNISSLISTE[$i]} assetcache Verzeichnis wurde nicht gefunden! "
		
		sleep 1
	done
	return 0
}

#──────────────────────────────────────────────────────────────────────────────────────────
#* Starten und Stoppen Funktionsgruppe
#──────────────────────────────────────────────────────────────────────────────────────────

## *  menugridstop
	# Diese Funktion überprüft, ob bestimmte Screens mit den Namen "MO" oder "RO" aktiv sind und stoppt diese, wenn sie aktiv sind.
	#? Parameter:
	# Keine
	#? Rückgabewert:
	# Die Funktion gibt immer 0 zurück.
	#? Beispiel:
	# menugridstop
##
function menugridstop() {
	# Letzte Bearbeitung 01.10.2023
	if screen -list | grep -q MO; then
		menumostop
	fi

	if screen -list | grep -q RO; then
		menurostop
	fi
	return 0
}

## *  scstart
	# Diese Funktion startet einen OpenSimulator in einem Screen mit dem angegebenen Namen und verwendet den entsprechenden Ausführungsmodus (Dotnet oder Mono) basierend auf der Konfiguration.
	#? Parameter:
	# $1 - Der Name des Screens, in dem der OpenSimulator gestartet werden soll.
	#? Rückgabewert:
	# Die Funktion gibt keinen expliziten Rückgabewert zurück, kann jedoch fehlschlagen und gibt in diesem Fall 1 zurück.
	#? Beispiel:
	# scstart "MeinOpenSim"
##
function scstart() {
	# Letzte Bearbeitung 01.10.2023
	SCSTARTSCREEN=$1 # OpenSimulator, Verzeichnis und Screen Name
	cd /$STARTVERZEICHNIS/"$SCSTARTSCREEN"/bin || return 1

	# DOTNETMODUS="yes"
	if [[ "${DOTNETMODUS}" == "yes" ]]; then
		screen -fa -S "$OSSTARTSCREEN" -d -U -m dotnet OpenSim.dll
		fi
	# DOTNETMODUS="no"
	if [[ "${DOTNETMODUS}" == "no" ]]; then
		screen -fa -S "$SCSTARTSCREEN" -d -U -m mono OpenSim.exe
	fi
}

## *  scstop
	# Diese Funktion stoppt einen OpenSimulator in einem Screen mit dem angegebenen Namen, indem sie den Befehl "shutdown" an den Screen sendet.
	#? Parameter:
	# $1 - Der Name des Screens, in dem der OpenSimulator gestoppt werden soll.
	#? Rückgabewert:
	# Die Funktion gibt keinen expliziten Rückgabewert zurück.
	#? Beispiel:
	# scstop "MeinOpenSim"
##
function scstop() {
	# Letzte Bearbeitung 01.10.2023
	SCSTOPSCREEN=$1 # OpenSimulator, Verzeichnis und Screen Name
	screen -S "$SCSTOPSCREEN" -p 0 -X eval "stuff 'shutdown'^M"
}

## *  sckill
	# Diese Funktion beendet einen Screen mit dem angegebenen Namen.
	#? Parameter:
	# $1 - Der Name des Screens, der beendet werden soll.
	#? Rückgabewert:
	# Die Funktion gibt keinen expliziten Rückgabewert zurück.
	#? Beispiel:
	# sckill "MeinOpenSim"
##
function sckill() {
	# Letzte Bearbeitung 01.10.2023
	SCKILLSCREEN=$1 # OpenSimulator, Verzeichnis und Screen Name
	screen -X -S "$SCKILLSCREEN" kill
}

## *  simstats
	# Diese Funktion zeigt die Statistiken eines OpenSimulator-Servers in einem Screen an.
	#? Parameter:
	# $1 - Der Name des Screens, in dem der OpenSimulator läuft.
	#? Rückgabewert:
	# Die Funktion gibt immer 0 zurück.
	#? Beispiel:
	# simstats "MeinOpenSim"
##
function simstats() {
	# Letzte Bearbeitung 01.10.2023
	STATSSCREEN=$1 # OpenSimulator, Verzeichnis und Screen Name
	if screen -list | grep -q "$STATSSCREEN"; then
		if checkfile /$STARTVERZEICHNIS/"$STATSSCREEN".log; then
			rm /$STARTVERZEICHNIS/"$STATSSCREEN".log
		fi
		log info "OpenSimulator $STATSSCREEN Simstatistik anzeigen"
		screen -S "$STATSSCREEN" -p 0 -X eval "stuff 'stats save /$STARTVERZEICHNIS/$STATSSCREEN.log'^M"
		sleep 1
		cat /$STARTVERZEICHNIS/"$STATSSCREEN".log
	else
		log error "Simulator $STATSSCREEN nicht vorhanden"
	fi
	return 0
}

## *  terminator
	# Diese Funktion beendet alle aktiven Screen-Sitzungen und gibt Protokollmeldungen aus.
	#? Parameter:
	# Keine
	#? Rückgabewert:
	# Die Funktion gibt immer 0 zurück.
	#? Beispiel:
	# terminator
##
function terminator() {
	# Letzte Bearbeitung 01.10.2023
	log info "hasta la vista baby"
	log warn "TERMINATOR: Alle Screens wurden durch Benutzer beendet"
	killall screen
	screen -ls
	return 0
}

function buildbullet()
{
    BuildDate=""
    BulletVersion=""

    echo "Erstelle BulettSim für den OpenSimulator!"
    # BulletSim vom Git holen
    cd /opt || exit
    git clone git://opensimulator.org/git/opensim-libs opensim-libs
    
     # Bullet3 vom Git holen
    cd /opt/opensim-libs/trunk/unmanaged/BulletSim || exit
    git clone --depth 1 --single-branch https://github.com/bulletphysics/bullet3.git

    # Anwenden aller Patches für Bullet.


    cd bullet3 || exit ; for file in ../*.patch ; do cat "$file" | patch -p1 ; done

    cd /opt/opensim-libs/trunk/unmanaged/BulletSim || exit

    # Informationen zur Versionsdatei generieren
    bash buildBulletCMake.sh
    # BulletSim erstellen
    bash buildVersionInfo.sh
    # Ausführen das BulletSim-Kompilierungs- und Link-Skript.
    bash buildBulletSim.sh
    echo "Erstellen des BulettSim beendet!"
    echo "Die Datei libBulletSim-******.so kopieren und die Konfigurationsdatei OpenSim.Region.PhysicsModule.BulletS.dll.config anpassen!"

    # BulletSimVersionInfo auslesen
    # shellcheck disable=SC1091
    . /opt/opensim-libs/trunk/unmanaged/BulletSim/BulletSimVersionInfo
    # Testausgabe
    echo "libBulletSim-$BulletVersion-$BuildDate-x86_64.so"
    # Neue Konfiguration schreiben im OpenSim/bin Verzeichnis.
    #bulletconfig libBulletSim-"$BulletVersion"-"$BuildDate"-x86_64.so

	# Konfiguration schreiben im Verzeichnis der neuen Bullet so Datei.
{
	echo "<configuration>"
	echo '  <dllmap os="windows" cpu="x86-64" dll="BulletSim" target="lib64/BulletSim-3.26-20231207-x86_64.dll" />'
	echo '  <dllmap os="osx" dll="BulletSim" target="lib64/libBulletSim.dylib" />'
	echo '  <dllmap os="!windows,osx" cpu="x86-64" dll="BulletSim" target="lib64/'$BULLETVERSION'" />'
	echo '  <dllmap os="!windows,osx" cpu="arm64" dll="BulletSim" target="lib64/libBulletSim-arm64.so" />'
	echo "</configuration>"
} > "/opt/opensim-libs/trunk/unmanaged/BulletSim/OpenSim.Region.PhysicsModule.BulletS.dll.config"
}

## *  oscompi93
	# Diese Funktion kompiliert OpenSimulator Version 0.9.3 von Git und führt einige spezifische Schritte im Kompilierungsprozess aus.
	#? Parameter:
	# Keine
	#? Rückgabewert:
	# Die Funktion gibt immer 0 zurück.
	#? Beispiel:
	# oscompi93
##
function oscompi93() {
	# Letzte Bearbeitung 01.10.2023
	# ohne log Datei.
    git clone git://opensimulator.org/git/opensim opensim93
	# https://github.com/opensim/opensim.git
    cd opensim93 || exit
    git checkout dotnet6
    ./runprebuild.sh
    dotnet build --configuration Release OpenSim.sln
    log info "Eine Besonderheit ist, der Startvorgang hat sich geaendert, es wird nicht mehr mit mono OpenSim.exe gestartet, sondern mit dotnet OpenSim.dll."

	log info "Kompilierung wurde durchgefuehrt"
	return 0
}

## *  oscompi
	# Diese Funktion führt die Kompilierung von OpenSimulator mit verschiedenen Konfigurationen und Optionen durch.
	#? Parameter:
	# Keine
	#? Rückgabewert:
	# Die Funktion gibt 0 zurück, wenn die Kompilierung erfolgreich war, andernfalls gibt sie 1 zurück.
	#? Beispiel:
	# oscompi
	# Diese Funktion führt verschiedene Kompilierungsaktionen aus, je nach den übergebenen Umgebungsvariablen und Parametern. 
	# Sie umfasst das Auswählen der richtigen Konfiguration, das Kopieren von Dateien, das Ausführen von Prebuild-Skripten, 
	# das Kompilieren von OpenSimulator und das Aktivieren oder Deaktivieren von AOT (Ahead-of-Time) Kompilierungsoptionen. 
	# Die Funktion gibt 0 zurück, wenn die Kompilierung erfolgreich war, andernfalls gibt sie 1 zurück.
##
function oscompi() {
	# Letzte Bearbeitung 07.12.2023
	log info " Kompilierungsvorgang startet"
	# In das opensim Verzeichnis wechseln wenn es das gibt ansonsten beenden.
	cd /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS || return 1

	log info " Prebuildvorgang startet"

	# Funktionierend
	# Visual Studio 2022 mit DOTNET 6
	log info " Prebuildvorgang DOTNET 6"
	# runprebuild.sh startbar machen:
	chmod +x runprebuild.sh
	# runprebuild.sh starten:
	./runprebuild.sh
	# Kompilieren
	dotnet build -c Release OpenSim.sln || return 1
	# Ausgabe das alles beendet wurde.
	log info "Kompilierung wurde durchgefuehrt"
	return 0
}

## *  opensimgitcopy
	# Diese Funktion kopiert OpenSimulator-Dateien aus einem Git-Repository in das angegebene Verzeichnis, wenn $MONEYCOPY auf "yes" gesetzt ist.
	#? Parameter:
	# Keine
	#? Rückgabewert:
	# Die Funktion gibt immer 0 zurück.
	#? Beispiel:
	# opensimgitcopy93
##
function opensimgitcopy() {
	# Letzte Bearbeitung 13.12.2023
	if [[ -z "$MONEYCOPY" || "$MONEYCOPY" = "no" ]]; then return; fi

	if [[ $MONEYCOPY = "yes" ]]; then
		log info "OpenSimulator wird vom GIT geholt"
		git clone git://opensimulator.org/git/opensim /$STARTVERZEICHNIS/opensim
		# https://github.com/opensim/opensim.git
	else
		log error "OpenSimulator nicht vorhanden"
	fi
	return 0
}

## *  moneygitcopy
	# Diese Funktion kopiert den MoneyServer und die Skripte aus einem Git-Repository in das angegebene Verzeichnis,
	# wenn $MONEYCOPY auf "yes" gesetzt ist.
	#? Parameter:
	# Keine
	#? Rückgabewert:
	# Die Funktion gibt immer 0 zurück.
	#? Beispiel:
	# moneygitcopy93
##
function moneygitcopy() {
	# Letzte Bearbeitung 13.12.2023
	if [[ -z "$MONEYCOPY" || "$MONEYCOPY" = "no" ]]; then return; fi

	if [[ $MONEYCOPY = "yes" ]]; then
		log info "MONEYSERVER: MoneyServer wird vom GIT geholt"
		git clone https://github.com/BigManzai/OpenSimCurrencyServer-2023 /$STARTVERZEICHNIS/OpenSimCurrencyServer-2023
	else
		log error "MONEYSERVER: MoneyServer nicht vorhanden"
	fi
	return 0
}

## *  moneygitcopy
	# Diese Funktion kopiert den MoneyServer und die Skripte aus einem Git-Repository in das angegebene Verzeichnis,
	# wenn $MONEYCOPY auf "yes" gesetzt ist.
	#? Parameter:
	# Keine
	#? Rückgabewert:
	# Die Funktion gibt immer 0 zurück.
	#? Beispiel:
	# moneygitcopy
##
function moneygitcopy21() {
	# Letzte Bearbeitung 13.12.2023
	if [[ -z "$MONEYCOPY" || "$MONEYCOPY" = "no" ]]; then return; fi

	if [[ $MONEYCOPY = "yes" ]]; then
		log info "MONEYSERVER: MoneyServer wird vom GIT geholt"
		git clone https://github.com/BigManzai/OpenSimCurrencyServer-2021 /$STARTVERZEICHNIS/OpenSimCurrencyServer-2021-master
	else
		#log error "MONEYSERVER: MoneyServer nicht vorhanden"
		return 0;
	fi
	return 0
}

## *  bulletgitcopy
	# Diese Funktion kopiert die Bullet Physic aus einem Git-Repository in das angegebene Verzeichnis,
	#? Parameter:
	# Keine
	#? Rückgabewert:
	# Die Funktion gibt immer 0 zurück.
	#? Beispiel:
	# bulletgitcopy
##
function bulletgitcopy() {
	# Letzte Bearbeitung 13.12.2023
	if [[ -z "$BULLETCOPY" || "$BULLETCOPY" = "no" ]]; then return; fi

	if [[ $BULLETCOPY = "yes" ]]; then
		log info "MONEYSERVER: MoneyServer wird vom GIT geholt"
		git clone https://github.com/BigManzai/BulletSim /$STARTVERZEICHNIS/BulletSim
	else
		#log error "BulletSim nicht vorhanden"
		return 0;
	fi
	return 0
}

## *  divagitcopy
	# Diese Funktion kopiert DIVA und die zugehörigen Skripte aus einem Git-Repository in das angegebene Verzeichnis,
	# wenn $DIVACOPY auf "yes" gesetzt ist.
	#? Parameter:
	# Keine
	#? Rückgabewert:
	# Die Funktion gibt immer 0 zurück.
	#? Beispiel:
	# divagitcopy
##
function divagitcopy() {
	# Letzte Bearbeitung 13.12.2023
	if [[ -z "$DIVACOPY" || "$DIVACOPY" = "no" ]]; then return; fi

	if [[ $DIVACOPY = "yes" ]]; then
		log info "DIVA wird vom GIT geholt"
		git clone https://github.com/BigManzai/diva-distribution /$STARTVERZEICHNIS/diva-distribution
	else
		log error "DIVA nicht vorhanden"
	fi
	return 0
}

## *  divacopy
	# Diese Funktion kopiert DIVA-Dateien und Add-On-Module in das OpenSimulator-Verzeichnis, wenn $DIVACOPY auf "yes" gesetzt ist.
	#? Parameter:
	# Keine
	#? Rückgabewert:
	# Die Funktion gibt immer 0 zurück.
	#? Beispiel:
	# divacopy
##
function divacopy() {
	# Letzte Bearbeitung 13.12.2023
	if [[ -z "$DIVACOPY" || "$DIVACOPY" = "no" ]]; then return; fi

	if [[ $DIVACOPY = "yes" ]]; then
		if [ -d /$STARTVERZEICHNIS/$DIVASOURCE/ ]; then
			log info "DIVA Kopiervorgang gestartet"
			#cp -r /$STARTVERZEICHNIS/$DIVASOURCE/bin /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS
			cp -r /$STARTVERZEICHNIS/$DIVASOURCE/addon-modules /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS
			log line
		else
			# Entpacken und kopieren
			log info "DIVA entpacken"
			unzip "$DIVAZIP"
			log info "DIVA Kopiervorgang gestartet"
			#cp -r /$STARTVERZEICHNIS/$DIVASOURCE/bin /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS
			cp -r /$STARTVERZEICHNIS/$DIVASOURCE/addon-modules /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS
		fi
	else
		log warn "DIVA wird nicht kopiert."
	fi
	return 0
}

## *  scriptgitcopy
	# Diese Funktion kopiert Skript-Assets aus einem Git-Repository in das angegebene Verzeichnis,
	# wenn $SCRIPTCOPY auf "yes" gesetzt ist.
	#? Parameter:
	# Keine
	#? Rückgabewert:
	# Die Funktion gibt immer 0 zurück.
	#? Beispiel:
	# scriptgitcopy
##
function scriptgitcopy() {
	# Letzte Bearbeitung 13.12.2023
	if [[ -z "$SCRIPTCOPY" || "$SCRIPTCOPY" = "no" ]]; then return; fi

	if [[ $SCRIPTCOPY = "yes" ]]; then
		log info "Script Assets werden vom GIT geholt"
		git clone https://github.com/BigManzai/opensim-ossl-example-scripts /$STARTVERZEICHNIS/opensim-ossl-example-scripts-main
	else
		log error "Script Assets sind nicht vorhanden"
	fi
	return 0
}

## *  scriptcopy
	# Diese Funktion kopiert Skript-Assets in das OpenSimulator-Verzeichnis,
	# wenn $SCRIPTCOPY auf "yes" gesetzt ist.
	#? Parameter:
	# Keine
	#? Rückgabewert:
	# Die Funktion gibt immer 0 zurück.
	#? Beispiel:
	# scriptcopy
##
function scriptcopy() {
	# Letzte Bearbeitung 13.12.2023
	if [[ -z "$SCRIPTCOPY" || "$SCRIPTCOPY" = "no" ]]; then return; fi

	if [[ $SCRIPTCOPY = "yes" ]]; then
		if [ -d /$STARTVERZEICHNIS/$SCRIPTSOURCE/ ]; then
			log info "Script Assets werden kopiert"
			cp -r /$STARTVERZEICHNIS/$SCRIPTSOURCE/assets /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/bin
			cp -r /$STARTVERZEICHNIS/$SCRIPTSOURCE/inventory /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/bin
			log line
		else
			# entpacken und kopieren
			log info "Script Assets werden entpackt"
			unzip "$SCRIPTZIP"
			log info "Script Assets werden kopiert"
			cp -r /$STARTVERZEICHNIS/$SCRIPTSOURCE/assets /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/bin
			cp -r /$STARTVERZEICHNIS/$SCRIPTSOURCE/inventory /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/bin
			log line
		fi
	else
		log warn "Skripte wurden nicht kopiert."
	fi
	return 0
}

## *  moneycopy
	# Diese Funktion kopiert den MoneyServer (Währungsserver) und die Add-On-Module in das OpenSimulator-Verzeichnis,
	# wenn $MONEYCOPY auf "yes" gesetzt ist.
	#? Parameter:
	# Keine
	#? Rückgabewert:
	# Die Funktion gibt immer 0 zurück.
	#? Beispiel:
	# moneycopy93
##
function moneycopy() {
	# Letzte Bearbeitung 13.12.2023
	if [[ -z "$MONEYCOPY" || "$MONEYCOPY" = "no" ]]; then return; fi

	if [[ $MONEYCOPY = "yes" ]]; then
	MONEYSOURCE93="OpenSimCurrencyServer-2023"
		if [ -d /$STARTVERZEICHNIS/$MONEYSOURCE93/ ]; then
			log info "Money Server Kopiervorgang gestartet"
			cp -r /$STARTVERZEICHNIS/$MONEYSOURCE93/bin /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS
			cp -r /$STARTVERZEICHNIS/$MONEYSOURCE93/addon-modules /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS
			log line
		else
			# Entpacken und kopieren
			log info "Money Server entpacken"
			unzip "$MONEYZIP"
			log info "Money Server Kopiervorgang gestartet"
			cp -r /$STARTVERZEICHNIS/$MONEYSOURCE93/bin /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS
			cp -r /$STARTVERZEICHNIS/$MONEYSOURCE93/addon-modules /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS
		fi
	else
		log warn "Money Server wird nicht kopiert."
	fi
	return 0
}

## *  moneycopy
	# Diese Funktion kopiert den MoneyServer (Währungsserver) und die Add-On-Module in das OpenSimulator-Verzeichnis,
	# wenn $MONEYCOPY auf "yes" gesetzt ist.
	#? Parameter:
	# Keine
	#? Rückgabewert:
	# Die Funktion gibt immer 0 zurück.
	#? Beispiel:
	# moneycopy
##
function moneycopyalt() {
	# Letzte Bearbeitung 13.12.2023
	if [[ -z "$MONEYCOPY" || "$MONEYCOPY" = "no" ]]; then return; fi

	if [[ $MONEYCOPY = "yes" ]]; then
		if [ -d /$STARTVERZEICHNIS/$MONEYSOURCE/ ]; then
			log info "Money Server Kopiervorgang gestartet"
			cp -r /$STARTVERZEICHNIS/$MONEYSOURCE/bin /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS
			cp -r /$STARTVERZEICHNIS/$MONEYSOURCE/addon-modules /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS
			log line
		else
			# Entpacken und kopieren
			log info "Money Server entpacken"
			unzip "$MONEYZIP"
			log info "Money Server Kopiervorgang gestartet"
			cp -r /$STARTVERZEICHNIS/$MONEYSOURCE/bin /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS
			cp -r /$STARTVERZEICHNIS/$MONEYSOURCE/addon-modules /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS
		fi
	else
		log warn "Money Server wird nicht kopiert."
	fi
	return 0
}

## *  bulletconfig
	# Diese Funktion konfiguriert die DLL-Zuordnungen für die BulletSim-Physikmodule basierend auf der übergebenen Bullet-Version.
	# Wenn $BULLETVERSION auf "no" gesetzt ist, wird die Funktion beendet. Andernfalls wird die Standardversion verwendet.
	#? Parameter:
	# $1: Die Bullet-Version (optional).
	#? Rückgabewert:
	# Die Funktion gibt keine expliziten Rückgabewerte zurück.
	#? Beispiel:
	# bulletconfig "libBulletSim-3.26-20231209-x86_64.so"
##
function bulletconfig() {
	BULLETVERSION=$1

	# Überprüfe, ob die Bullet-Version auf "no" gesetzt ist, und beende die Funktion in diesem Fall.
	if [[ "$BULLETVERSION" = "no" ]]; then return; fi

	# Wenn keine Bullet-Version übergeben wurde, setze die Standardversion.
	if [[ -z "$BULLETVERSION" ]]; then BULLETVERSION=$BULLETUBUNTU2004focal; fi

# Konfiguration schreiben.
{
	echo "<configuration>"
	echo '  <dllmap os="windows" cpu="x86-64" dll="BulletSim" target="lib64/BulletSim-3.26-20231207-x86_64.dll" />'
	echo '  <dllmap os="osx" dll="BulletSim" target="lib64/libBulletSim.dylib" />'
	echo '  <dllmap os="!windows,osx" cpu="x86-64" dll="BulletSim" target="lib64/'$BULLETVERSION'" />'
	echo '  <dllmap os="!windows,osx" cpu="arm64" dll="BulletSim" target="lib64/libBulletSim-arm64.so" />'
	echo "</configuration>"
} > "/$STARTVERZEICHNIS/opensim/bin/OpenSim.Region.PhysicsModule.BulletS.dll.config"

	return 0
}

# bulletcopy funktioniert nicht

## *  bulletcopy
	# Diese Funktion kopiert BulletSim 1.3 und Bullet Physic 3.2.6 in das OpenSimulator lib64 Verzeichnis,
	#? Parameter:
	# Keine
	#? Rückgabewert:
	# Die Funktion gibt immer 0 zurück.
	#? Beispiel:
	# bulletcopy
##
function bulletcopy() {
	# Letzte Bearbeitung 13.12.2023
	if [[ -z "$BULLETCOPY" || "$BULLETCOPY" = "no" ]]; then return; fi

	if [ "$ubuntuCodename" = "bionic" ]; then
	log info "entdeckt Ubuntu 18.04"
	BULLETSOURCE="BulletSim/Ubuntu18" 
	cp -r /$STARTVERZEICHNIS/BulletSim/* /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/bin/lib64
	bulletconfig $BULLETUBUNTU1804bionic
	fi

	if [ "$ubuntuCodename" = "cosmic" ]; then
	log info "entdeckt Ubuntu 18.10"
	BULLETSOURCE="BulletSim/Ubuntu18" 
	cp -r /$STARTVERZEICHNIS/BulletSim/* /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/bin/lib64
	bulletconfig $BULLETUBUNTU1810cosmic
	fi

	if [ "$ubuntuCodename" = "focal" ]; then
	log info "entdeckt Ubuntu 20.04"
	cp -r /$STARTVERZEICHNIS/BulletSim/* /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/bin/lib64
	bulletconfig $BULLETUBUNTU2004focal
	fi

	if [ "$ubuntuCodename" = "groovy" ]; then
	log info "entdeckt Ubuntu 20.10"
	cp -r /$STARTVERZEICHNIS/BulletSim/* /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/bin/lib64
	bulletconfig $BULLETUBUNTU2010groovy
	fi

	if [ "$ubuntuCodename" = "jammy" ]; then 
	log info "entdeckt Ubuntu 22"
	BULLETSOURCE="BulletSim/Ubuntu22" 
	cp -r /$STARTVERZEICHNIS/BulletSim/* /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/bin/lib64
	bulletconfig $BULLETUBUNTU2204jammy
	fi

	if [ "$ubuntuCodename" = "kinetic" ]; then
	log info "entdeckt Ubuntu 22.10"
	BULLETSOURCE="BulletSim/Ubuntu22" 
	cp -r /$STARTVERZEICHNIS/BulletSim/* /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/bin/lib64
	bulletconfig $BULLETUBUNTU2210kinetic
	fi

	if [ "$ubuntuCodename" = "lunar" ]; then
	log info "entdeckt Ubuntu 23.04"
	BULLETSOURCE="BulletSim/Ubuntu22" 
	cp -r /$STARTVERZEICHNIS/BulletSim/* /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/bin/lib64
	bulletconfig $BULLETUBUNTU2304lunar
	fi

	if [ "$ubuntuCodename" = "mantic" ]; then
	log info "entdeckt Ubuntu 23.10"
	BULLETSOURCE="BulletSim/Ubuntu22" 
	cp -r /$STARTVERZEICHNIS/BulletSim/* /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/bin/lib64
	bulletconfig $BULLETUBUNTU2310mantic
	fi

	if [ "$ubuntuCodename" = "noble" ]; then
	log info "entdeckt Ubuntu 24.04"
	BULLETSOURCE="BulletSim/Ubuntu22" 
	cp -r /$STARTVERZEICHNIS/BulletSim/* /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/bin/lib64
	bulletconfig $BULLETUBUNTU2404noble
	fi

	return 0
}

## *  mutelistcopy
	# Diese Funktion kopiert die Mute List (Stummschaltungsliste) und Add-On-Module in das OpenSimulator-Verzeichnis,
	# wenn $MUTELISTCOPY auf "yes" gesetzt ist.
	#? Parameter:
	# Keine
	#? Rückgabewert:
	# Die Funktion gibt immer 0 zurück.
	#? Beispiel:
	# mutelistcopy
##
function mutelistcopy() {
	# Letzte Bearbeitung 13.12.2023
	if [[ -z "$MUTELISTCOPY" || "$MUTELISTCOPY" = "no" ]]; then return; fi
	
	if [[ $MUTELISTCOPY = "yes" ]]; then
		if [ -d /$STARTVERZEICHNIS/$MUTELISTSOURCE/ ]; then
			log info "MUTELIST Server Kopiervorgang gestartet"
			cp -r /$STARTVERZEICHNIS/$MUTELISTSOURCE/bin /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS
			cp -r /$STARTVERZEICHNIS/$MUTELISTSOURCE/addon-modules /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS
			log line
		else
			# Entpacken und kopieren
			log info "Money Server entpacken"
			unzip "$MONEYZIP"
			log info "Money Server Kopiervorgang gestartet"
			cp -r /$STARTVERZEICHNIS/$MONEYSOURCE/bin /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS
			cp -r /$STARTVERZEICHNIS/$MONEYSOURCE/addon-modules /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS
		fi
	else
		log warn "Money Server wird nicht kopiert."
	fi
	return 0
}

## *  searchcopy
	# Diese Funktion kopiert den OpenSimSearch-Server und die Add-On-Module in das OpenSimulator-Verzeichnis,
	# wenn $OSSEARCHCOPY auf "yes" gesetzt ist.
	#? Parameter:
	# Keine
	#? Rückgabewert:
	# Die Funktion gibt immer 0 zurück.
	#? Beispiel:
	# searchcopy
##
function searchcopy() {
	# Letzte Bearbeitung 13.12.2023
	if [[ -z "$OSSEARCHCOPY" || "$OSSEARCHCOPY" = "no" ]]; then return; fi

	if [[ $OSSEARCHCOPY = "yes" ]]; then
		if [ -d /$STARTVERZEICHNIS/$OSSEARCHSOURCE/ ]; then
			log info "OpenSimSearch Kopiervorgang gestartet"
			cp -r /$STARTVERZEICHNIS/$OSSEARCHSOURCE/bin /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS
			cp -r /$STARTVERZEICHNIS/$OSSEARCHSOURCE/addon-modules /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS
			log line
		else
			# Entpacken und kopieren
			log info "OpenSimSearch entpacken"
			unzip "$OSSEARCHZIP"
			log info "OSSEARCH Server Kopiervorgang gestartet"
			cp -r /$STARTVERZEICHNIS/$OSSEARCHSOURCE/bin /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS
			cp -r /$STARTVERZEICHNIS/$OSSEARCHSOURCE/addon-modules /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS
		fi
	else
		log warn "OpenSimSearch wird nicht kopiert."
	fi
	return 0
}

## *  makeaot
	# Diese Funktion führt Ahead-of-Time (AOT)-Kompilierung für bestimmte DLL-Dateien und ausführbare Dateien in einem Verzeichnis durch.
	#? Parameter:
	# Keine
	#? Rückgabewert:
	# Die Funktion gibt immer 0 zurück.
	#? Beispiel:
	# makeaot
##
function makeaot() {
	# Letzte Bearbeitung 01.10.2023
	if [ ! -f "/$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/" ]; then
		cd /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/bin || exit
		mono --aot=mcpu=native,bind-to-runtime-version -O=all Nini.dll
		mono --aot=mcpu=native,bind-to-runtime-version -O=all DotNetOpen*.dll
		mono --aot=mcpu=native,bind-to-runtime-version -O=all Ionic.Zip.dll
		mono --aot=mcpu=native,bind-to-runtime-version -O=all Newtonsoft.Json.dll
		mono --aot=mcpu=native,bind-to-runtime-version -O=all C5.dll
		mono --aot=mcpu=native,bind-to-runtime-version -O=all CSJ2K.dll
		mono --aot=mcpu=native,bind-to-runtime-version -O=all Npgsql.dll
		mono --aot=mcpu=native,bind-to-runtime-version -O=all RestSharp.dll
		mono --aot=mcpu=native,bind-to-runtime-version -O=all Mono*.dll
		mono --aot=mcpu=native,bind-to-runtime-version -O=all MySql*.dll
		mono --aot=mcpu=native,bind-to-runtime-version -O=all OpenMetaverse*.dll
		mono --aot=mcpu=native,bind-to-runtime-version -O=all OpenSim*.dll
		mono --aot=mcpu=native,bind-to-runtime-version -O=all OpenSim*.exe
		mono --aot=mcpu=native,bind-to-runtime-version -O=all Robust*.exe
	else
		log error "MAKEAOT: opensim Verzeichnis existiert nicht"
	fi
	return 0
}

## *  cleanaot
	# Diese Funktion entfernt die zuvor erstellten AOT-Kompilierungsdateien (".so"-Dateien) für bestimmte DLLs und ausführbare Dateien in einem Verzeichnis.
	#? Parameter:
	# Keine
	#? Rückgabewert:
	# Die Funktion gibt immer 0 zurück.
	#? Beispiel:
	# cleanaot
##
function cleanaot() {
	# Letzte Bearbeitung 01.10.2023
	if [ ! -f "/$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/" ]; then
		cd /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/bin || exit

		rm Nini.dll.so
		rm DotNetOpen*.dll.so
		rm Ionic.Zip.dll.so
		rm Newtonsoft.Json.dll.so
		rm C5.dll.so
		rm CSJ2K.dll.so
		rm Npgsql.dll.so
		rm RestSharp.dll.so
		rm Mono*.dll.so
		rm MySql*.dll.so
		rm OpenMetaverse*.dll.so
		rm OpenSim*.dll.so
		rm OpenSim*.exe.so
		rm Robust*.exe.so

	else
		log error "MAKEAOT: opensim Verzeichnis existiert nicht"
	fi
	return 0
}

## *  setversion
	# Diese Funktion ändert die Version von OpenSim und stellt das Release auf die angegebene Nummer ein.
	#? Parameter:
	# $1 (NUMMER): Die gewünschte Versionsnummer, auf die das Release eingestellt werden soll.
	#? Rückgabewert:
	# Die Funktion gibt immer 0 zurück.
	#? Beispiel:
	# setversion 1.0.0
##
function setversion() {
	# Letzte Bearbeitung 01.10.2023
	NUMMER=$1
	log info "OpenSim Version umbenennen und Release auf $NUMMER einstellen"

	# flavour loeschen
	sed -i s/'Flavour.Dev'/'Flavour.Extended'/g /$STARTVERZEICHNIS/opensim/OpenSim/Framework/VersionInfo.cs

	# sed -i schreibt sofort - s/Suchwort/Ersatzwort/g - /Verzeichnis/Dateiname.Endung
	sed -i s/Nessie/.$NUMMER/g /$STARTVERZEICHNIS/opensim/OpenSim/Framework/VersionInfo.cs

	return 0
}

## *  versionsausgabe93
	# Diese Funktion gibt Informationen zur Version und zum Git-Status eines OpenSimulator-Repositorys aus.
	#? Parameter:
	# Keine
	#? Rückgabewert:
	# Die Funktion gibt die Informationen zur Version und zum Git-Status aus, gibt aber keinen expliziten Rückgabewert zurück.
	#? Beispiel:
	# versionsausgabe93
##
function versionsausgabe93() {
	cd /opt/opensim || exit
	log rohtext Verionsausgabe:
    git log -n 1
    git describe --abbrev=7 --always  --long --match v* master
}

## *  setversion93
	# Diese Funktion ändert die Versionsnummer in der Datei "VersionInfo.cs" im OpenSimulator-Repository.
	#? Parameter:
	# $1 (NUMMER): Die gewünschte Versionsnummer oder eine spezielle Kennzeichnung, um die Versionsnummer festzulegen.
	#               - Wenn NUMMER "d" ist, wird das aktuelle Datum (TTMMJJJJ) als Versionsnummer verwendet.
	#               - Wenn NUMMER "p" ist, wird das aktuelle Datum mit Punkten (TT.MM.JJJJ) als Versionsnummer verwendet.
	#               - Wenn NUMMER "z" ist, wird die Versionsnummer aus Git verwendet.
	#               - Andernfalls wird NUMMER als feste Versionsnummer verwendet.
	#? Rückgabewert:
	# Die Funktion gibt immer 0 zurück.
	#? Beispiel:
	# setversion93 1.0.0
	# setversion93 d
	# setversion93 p
	# setversion93 z
##
function setversion93() {
	# Letzte Bearbeitung 01.10.2023
	NUMMER=$1

	# Datum als Versionsnummer nutzen.
	if [[ "${NUMMER}" == "d" ]]; then 
		NUMMER=$(date +"%d%m%Y") 
		sed -i s/Nessie/$NUMMER/g /$STARTVERZEICHNIS/opensim/OpenSim/Framework/VersionInfo.cs
	fi

	# Datum mit Punkten als Versionsnummer nutzen.
	if [[ "${NUMMER}" == "p" ]]; then 
		NUMMER=$(date +"%d.%m.%Y") 
		sed -i s/Nessie/$NUMMER/g /$STARTVERZEICHNIS/opensim/OpenSim/Framework/VersionInfo.cs
	fi

	# Ganze Zeile austauschen gegen: 0.9.3.0Dev-676-gdd9e365e00
	if [[ "${NUMMER}" == "z" ]]; then 
		OSMASTER=$(git describe)
		sed -i -e 's/versionString =.*/versionString = "'$OSMASTER'";/' /$STARTVERZEICHNIS/opensim/OpenSim/Framework/VersionInfo.cs
	fi

	if [[ "${NUMMER}" == "" ]]; then
		# ist keine Nummer angegeben Versionnummer vom Git nutzen.
		cd /$STARTVERZEICHNIS/opensim || exit
		NUMMER=$(git describe --abbrev=7 --always  --long --match v* master)

		sed -i s/Nessie/$NUMMER/g /$STARTVERZEICHNIS/opensim/OpenSim/Framework/VersionInfo.cs
		else
		# ist eine Nummer angegeben dann diese verwenden.
		sed -i s/Nessie/V$NUMMER/g /$STARTVERZEICHNIS/opensim/OpenSim/Framework/VersionInfo.cs
	fi

	# Kontrollausgabe was gemacht wurde.
	log info "OpenSim Version umbenennen und auf $NUMMER einstellen"	

	# flavour umbenennen von Dev auf Extended.
	#sed -i s/Flavour.Dev/Flavour.Extended/g /$STARTVERZEICHNIS/opensim/OpenSim/Framework/VersionInfo.cs
	return 0
}

## *  osstruktur
	# Diese Funktion erstellt Verzeichnisstrukturen für OpenSimulator-Simulationen basierend auf den übergebenen Parametern.
	#? Parameter:
	#   $1: Startnummer (z.B., sim1)
	#   $2: Endnummer (z.B., sim10)
	#? Rückgabewert: Die Funktion gibt immer 0 zurück.
	#? Beispiel: osstruktur 1 10
	# Diese Funktion ermöglicht es Ihnen, Verzeichnisstrukturen für OpenSimulator-Simulationen zu erstellen, 
	# indem Sie die Start- und Endnummer der Simulationen übergeben. 
	# Die Verzeichnisse sim1 bis simN werden erstellt, und ihre Namen sowie die Informationen werden in eine Datei geschrieben. 
	# Beachten Sie, dass die Verwendung von "xargs" dazu dient, Leerzeichen zu entfernen, falls vorhanden.
##
function osstruktur() {
	# Letzte Bearbeitung 01.10.2023
	if [ ! -f "/$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/" ]; then
		log info "OSSTRUKTUR: Lege robust an im Verzeichnis $ROBUSTVERZEICHNIS"
		mkdir -p /$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS/bin
	else
		log error "OSSTRUKTUR: Verzeichnis $ROBUSTVERZEICHNIS existiert bereits"
	fi
	for ((i = $1; i <= $2; i++)); do
		log rohtext "Lege sim$i an"
		mkdir -p /$STARTVERZEICHNIS/sim"$i"/bin
		log rohtext "Schreibe sim$i in $SIMDATEI"
		# xargs sollte leerzeichen entfernen.
		printf 'sim'"$i"'\t%s\n' | xargs >>/$STARTVERZEICHNIS/$SIMDATEI
	done
	log info "OSSTRUKTUR: Lege robust an ,Schreibe sim$i in $SIMDATEI"
	return 0
}

## *  menuosstruktur
	# Diese Funktion erstellt Verzeichnisstrukturen für OpenSimulator-Simulationen basierend auf Benutzereingaben.
	#? Parameter: Keine
	#? Rückgabewert: Die Funktion gibt immer 0 zurück.
	#? Beispiel: menuosstruktur
	# Diese Funktion ermöglicht es dem Benutzer, Verzeichnisstrukturen für OpenSimulator-Simulationen zu erstellen, 
	# indem er den Bereich von sim1 bis simN eingibt. 
	# Beachten Sie, dass Sie Dialog auf dem System installiert haben müssen, um die Dialog-Funktion verwenden zu können. 
	# Andernfalls wird die Funktion ohne Dialog-Aktionen ausgeführt.
##
function menuosstruktur() {
	# Letzte Bearbeitung 01.10.2023
	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then

		# Einstellungen
		boxbacktitel="opensimMULTITOOL"
		boxtitel="opensimMULTITOOL Eingabe"
		formtitle="Verzeichnisstrukturen anlegen"
		lable1="Von:"
		lablename1="1"
		lable2="Bis:"
		lablename2="10"

		# Abfrage
		osstrukturBOXERGEBNIS=$(dialog --backtitle "$boxbacktitel" --title "$boxtitel" --form "$formtitle" 25 60 16 "$lable1" 1 1 "$lablename1" 1 25 25 30 "$lable2" 2 1 "$lablename2" 2 25 25 30 3>&1 1>&2 2>&3 3>&-)

		# Zeilen aus einer Variablen zerlegen und in verschiedenen Variablen schreiben.
		EINGABE=$(echo "$osstrukturBOXERGEBNIS" | sed -n '1p')
		EINGABE2=$(echo "$osstrukturBOXERGEBNIS" | sed -n '2p')

		# Alles loeschen.
		dialogclear
		ScreenLog
	else
		# Alle Aktionen ohne dialog
		log rohtext "Keine Menuelose Funktion" | exit
	fi # dialog Aktionen Ende

	if [ ! -f "/$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/" ]; then
		log info "OSSTRUKTUR: Lege robust an im Verzeichnis $ROBUSTVERZEICHNIS"
		mkdir -p /$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS/bin
	else
		log error "OSSTRUKTUR: Verzeichnis $ROBUSTVERZEICHNIS existiert bereits"
	fi
	# shellcheck disable=SC2004
	for ((i = $EINGABE; i <= $EINGABE2; i++)); do
		log rohtext "Lege sim$i an"
		mkdir -p /$STARTVERZEICHNIS/sim"$i"/bin
		log rohtext "Schreibe sim$i in $SIMDATEI"
		printf 'sim'"$i"'\t%s\n' >>/$STARTVERZEICHNIS/$SIMDATEI
	done
	log info "OSSTRUKTUR: Lege robust an ,Schreibe sim$i in $SIMDATEI"
	return 0
}

## * osdelete
	# Diese Funktion überprüft zunächst, ob das angegebene Verzeichnis vorhanden ist.
	# Wenn es existiert, wird es gelöscht und das alte Verzeichnis wird umbenannt, um es zu sichern.
	# Wenn das Verzeichnis nicht existiert, wird ein Fehler protokolliert.
	#? Parameter:
	#   - Keine
	#? Rückgabewert:
	#   - 0: Erfolgreiche Ausführung der Funktion
	#   - 1: Fehler beim Löschen des Verzeichnisses oder beim Umbenennen des alten Verzeichnisses
	#? Verwendungsbeispiel:
	#   osdelete
##
function osdelete() {
	# Letzte Bearbeitung 01.10.2023
	if [ -d /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/ ]; then
		log info "Loesche altes opensim1 Verzeichnis"
		cd /$STARTVERZEICHNIS || return 1
		rm -r /$STARTVERZEICHNIS/opensim1
		log info "Umbenennen von $OPENSIMVERZEICHNIS nach opensim1 zur sicherung"
		mv /$STARTVERZEICHNIS/opensim /$STARTVERZEICHNIS/opensim1
		log line

	else
		log error "$STARTVERZEICHNIS Verzeichnis existiert nicht"
	fi
	return 0
}

## * oscopyrobust
	# Diese Funktion wechselt in das Hauptverzeichnis ($STARTVERZEICHNIS) und überprüft, ob das
	# Robust-Verzeichnis ($ROBUSTVERZEICHNIS) vorhanden ist. Wenn es existiert, wird der Inhalt des
	# OpenSim-Verzeichnisses ($OPENSIMVERZEICHNIS/bin) in das Robust-Verzeichnis kopiert.
	#? Parameter:
	#   - Keine
	#? Rückgabewert:
	#   - 0: Erfolgreiche Ausführung der Funktion
	#   - 1: Fehler beim Wechseln des Verzeichnisses, beim Überprüfen des Robust-Verzeichnisses oder beim Kopieren der Dateien
	#? Verwendungsbeispiel:
	#   oscopyrobust
##
function oscopyrobust() {
	# Letzte Bearbeitung 01.10.2023
	cd /$STARTVERZEICHNIS || return 1
	if [ -d /$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS/ ]; then
		log line
		log info "Kopiere Robust, Money!"
		sleep 1		
		cd /$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS/bin || return 1
		cp -r /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/bin /$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS
		#log info "Robust und Money wurden kopiert"
		log line
	else
		log line
	fi
	return 0
}

## * oscopysim
	# Diese Funktion wechselt in das Hauptverzeichnis ($STARTVERZEICHNIS) und ruft die Funktion
	# `makeverzeichnisliste` auf, um eine Liste von Verzeichnissen zu erstellen, in die die
	# OpenSimulator-Instanzen kopiert werden sollen. Anschließend wird in einer Schleife durch die
	# Verzeichnisliste iteriert und für jede Instanz das OpenSim-Verzeichnis ($OPENSIMVERZEICHNIS/bin)
	# in das entsprechende Zielverzeichnis kopiert.
	#? Parameter:
	#   - Keine
	#? Rückgabewert:
	#   - 0: Erfolgreiche Ausführung der Funktion
	#   - 1: Fehler beim Wechseln des Verzeichnisses, beim Erstellen der Verzeichnisliste oder beim Kopieren der Dateien
	#? Verwendungsbeispiel:
	#   oscopysim
##
function oscopysim() {
	# Letzte Bearbeitung 01.10.2023
	cd /$STARTVERZEICHNIS || return 1 # Prüfen ob Verzeichnis vorhanden ist.
	makeverzeichnisliste
	#log info "Kopiere Simulatoren!"
	#log line
	sleep 1
	for ((i = 0; i < "$ANZAHLVERZEICHNISSLISTE"; i++)); do
		log info "OpenSimulator ${VERZEICHNISSLISTE[$i]} kopiert"
		cd /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin || return 1 # Prüfen ob Verzeichnis vorhanden ist.
		cp -r /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/bin /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"
		sleep 1
	done
	return 0
}

## * oscopy
	# Diese Funktion nimmt den Namen eines OpenSimulator-Verzeichnisses als Argument ($VERZEICHNIS)
	# entgegen. Sie wechselt in das Hauptverzeichnis ($STARTVERZEICHNIS) und kopiert den Inhalt des
	# OpenSim-Verzeichnisses ($OPENSIMVERZEICHNIS/bin) in das angegebene Zielverzeichnis ($VERZEICHNIS).
	#? Parameter:
	#   - $1: Der Name des OpenSimulator-Verzeichnisses, das kopiert werden soll.
	#? Rückgabewert:
	#   - 0: Erfolgreiche Ausführung der Funktion
	#   - 1: Fehler beim Wechseln des Verzeichnisses, beim Überprüfen des Verzeichnisses oder beim Kopieren der Dateien
	#? Verwendungsbeispiel:
	#   oscopy "MeinOpenSimVerzeichnis"
##
function oscopy() {
	# Letzte Bearbeitung 13.12.2023
	#if [[ -z "$OSCOPY" || "$OSCOPY" = "no" ]]; then return; fi

	cd /$STARTVERZEICHNIS || return 1
	VERZEICHNIS=$1
	log info "Kopiere Simulator $VERZEICHNIS "
	cd /$STARTVERZEICHNIS/"$VERZEICHNIS"/bin || return 1 # Prüfen ob Verzeichnis vorhanden ist.
	cp -r /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/bin /$STARTVERZEICHNIS/"$VERZEICHNIS"
	return 0
}

## * configlesen
	# Diese Funktion nimmt den Namen eines Verzeichnisses als Argument ($CONFIGLESENSCREEN) entgegen und
	# liest die Regionskonfigurationen aus den INI-Dateien in diesem Verzeichnis. Die gelesenen
	# Konfigurationen werden in der Variable $KONFIGLESEN gespeichert und protokolliert.
	#? Parameter:
	#   - $1: Der Name des Verzeichnisses, aus dem die Regionskonfigurationen gelesen werden sollen.
	#? Rückgabewert:
	#   - 0: Erfolgreiche Ausführung der Funktion
	#? Verwendungsbeispiel:
	#   configlesen "MeinRegionsVerzeichnis"
##
function configlesen() {
	# Letzte Bearbeitung 01.10.2023
	log info "CONFIGLESEN: Regionskonfigurationen von $CONFIGLESENSCREEN"
	CONFIGLESENSCREEN=$1
	KONFIGLESEN=$(awk -F":" '// {print $0 }' /$STARTVERZEICHNIS/"$CONFIGLESENSCREEN"/bin/Regions/*.ini) # Regionskonfigurationen aus einem Verzeichnis lesen.
	log info "$KONFIGLESEN"
	return 0
}

## * ini_get
	# Diese Funktion nimmt drei Argumente entgegen: den Dateinamen der INI-Datei ($KONFIGDATEI), den Namen der Sektion ($SECTION)
	# und den Namen des Schlüssels ($KEY), dessen Wert gelesen werden soll. Die Funktion durchsucht die INI-Datei nach der
	# angegebenen Sektion und dem Schlüssel und gibt den entsprechenden Wert zurück.
	#? Parameter:
	#   - $1: Der Dateiname der INI-Datei.
	#   - $2: Der Name der Sektion, aus der der Wert gelesen werden soll.
	#   - $3: Der Name des Schlüssels, dessen Wert gelesen werden soll.
	#? Rückgabewert:
	#   - Der Wert des angegebenen Schlüssels in der INI-Datei.
	#   - Wenn die Sektion oder der Schlüssel nicht gefunden werden, wird nichts zurückgegeben.
	#? Verwendungsbeispiel:
	#   ini_get "meine.ini" "Sektion1" "Schluessel1"
##
function ini_get() {
	# Letzte Bearbeitung 01.10.2023
    local KONFIGDATEI=$1
    local SECTION=$2
    local KEY=$3

    if [ $# != 3 ]
        then
        log rohtext "Verwendung: ini_get Dateiname SECTION KEY"
        return $?
    fi

    awk -F "[=;#]+" '/^\[[ \t]*'"$SECTION"'[ \t]*\]/{a=1}a==1&&$1~/^[ \t]*'"$KEY"'[ \t]*/{gsub(/[ \t]+/,"",$0);print $2;exit}' "$KONFIGDATEI"
    return $?
}

## * ini_set
	# Diese Funktion nimmt vier Argumente entgegen: den Dateinamen der INI-Datei ($KONFIGDATEI), den Namen der Sektion ($SECTION),
	# den Namen des Schlüssels ($KEY) und den Wert ($WERT), der in der INI-Datei gespeichert werden soll. Die Funktion sucht
	# nach der angegebenen Sektion und dem Schlüssel in der INI-Datei und setzt den Wert entsprechend.
	#? Parameter:
	#   - $1: Der Dateiname der INI-Datei.
	#   - $2: Der Name der Sektion, in der der Wert gespeichert werden soll.
	#   - $3: Der Name des Schlüssels, dessen Wert gespeichert werden soll.
	#   - $4: Der Wert, der in der INI-Datei gespeichert werden soll.
	#? Rückgabewert:
	#   - 0: Erfolgreiche Ausführung der Funktion
	#? Verwendungsbeispiel:
	#   ini_set "meine.ini" "Sektion1" "Schluessel1" "Wert1"
##
function ini_set() {
	# Letzte Bearbeitung 01.10.2023
    local KONFIGDATEI=$1
    local SECTION=$2
    local KEY=$3
    local WERT=$4

    # if [ $# != 4 ]
    #     then
    #     echo "Verwendung: ini_set Dateiname SECTION KEY WERT"
    #     return $?
    # fi

    #sed -i "/^\[[ \t]*'"$SECTION"'[ \t]*\]/,/^\[/s/^[ \t]*\('"$KEY"'[ \t]*=[ \t]*\)[^ \t;#]*/\1$WERT/" "$KONFIGDATEI"
	#sed -i "/^\[[ \t]*'"$SECTION"'[ \t]*\]/,/^\[/s/^[ \t]*\('"$KEY"'[ \t]*=[ \t]*\)[^ \t;#]*/\1'\""$WERT"\"'/" "$KONFIGDATEI"

	sed -i '/^\['$SECTION'\]$/,/^\[/ s/^'$KEY' =/'$KEY' = "'$WERT'"/' "$KONFIGDATEI"
    return $?
}

## * regionsconfigdateiliste
	# Diese Funktion nimmt zwei Argumente entgegen: den Namen des Verzeichnisses ($VERZEICHNIS), in dem nach
	# Regionskonfigurationsdateien gesucht werden soll, und optional eine Option ($2) zum Steuern des Ausgabeverhaltens.
	# Wenn die Option "-d" übergeben wird, werden die Dateinamen in eine Datei namens "RegionsDateiliste.txt" geschrieben.
	# Andernfalls werden die Dateinamen auf der Standardausgabe ausgegeben.
	#? Parameter:
	#   - $1: Der Name des Verzeichnisses, in dem nach Regionskonfigurationsdateien gesucht werden soll.
	#   - $2 (optional): Eine Option zur Steuerung des Ausgabeverhaltens. Wenn "-d" übergeben wird, werden die Dateinamen in eine Datei geschrieben.
	#? Rückgabewert:
	#   - 0: Erfolgreiche Ausführung der Funktion
	#? Verwendungsbeispiel:
	#   regionsconfigdateiliste "MeinRegionsVerzeichnis" [-d]
##
function regionsconfigdateiliste() {
	# Letzte Bearbeitung 01.10.2023
	VERZEICHNIS=$1
	declare -A Dateien # Array erstellen
	# shellcheck disable=SC2178
	Dateien=$(find /$STARTVERZEICHNIS/"$VERZEICHNIS"/bin/Regions/ -name "*.ini") # Alle Regions.ini in das Assoziative Arrays mit der Option -A schreiben oder ein indiziertes mit -a.
	for i in "${Dateien[@]}"; do                                                 # Array abarbeiten
		if [ "$2" = "-d" ]; then echo "$i" >>RegionsDateiliste.txt; fi              # In die config Datei hinzufuegen.
		if [ "$2" = "-b" ]; then echo "$i"; fi                                      # In die config Datei hinzufuegen.
	done
	return 0
}

## * meineregionen
	# Diese Funktion ruft zuerst die Funktion `makeverzeichnisliste` auf, um eine Liste von Verzeichnissen zu erstellen,
	# und gibt dann die Regionsnamen aus den Regionskonfigurationsdateien in jedem Verzeichnis aus. Die Ausgabe wird protokolliert.
	#? Parameter:
	#   - Keine
	#? Rückgabewert:
	#   - 0: Erfolgreiche Ausführung der Funktion
	#? Verwendungsbeispiel:
	#   meineregionen
##
function meineregionen() {
	# Letzte Bearbeitung 01.10.2023
	makeverzeichnisliste
	log info "MEINEREGIONEN: Regionsliste"
	sleep 1
	for ((i = 0; i < "$ANZAHLVERZEICHNISSLISTE"; i++)); do
		VERZEICHNIS="${VERZEICHNISSLISTE[$i]}"
		REGIONSAUSGABE=$(awk -F "[" '/\[/ {print $1 $2 $3}' /$STARTVERZEICHNIS/"$VERZEICHNIS"/bin/Regions/*.ini | sed s/'\]'//g) # Zeigt nur die Regionsnamen aus einer Regions.ini an
		log info "$VERZEICHNIS"
		log info "$REGIONSAUSGABE"
	done
	log info "MEINEREGIONEN: Regionsliste Ende"
	return 0
}

## * regionsinisuchen
	# Diese Funktion ruft zuerst die Funktion `makeverzeichnisliste` auf, um eine Liste von Verzeichnissen zu erstellen,
	# und sucht dann nach der Datei "Regions.ini" in jedem Verzeichnis. Die gefundenen Dateien werden analysiert, und die
	# Namen der darin enthaltenen Regionskonfigurationen werden ausgegeben.
	#? Parameter:
	#   - Keine
	#? Rückgabewert:
	#   - 0: Erfolgreiche Ausführung der Funktion
	#? Verwendungsbeispiel:
	#   regionsinisuchen
##
function regionsinisuchen() {
	# Letzte Bearbeitung 01.10.2023
	makeverzeichnisliste
	sleep 1

	for ((i = 0; i < "$ANZAHLVERZEICHNISSLISTE"; i++)); do
		VERZEICHNIS="${VERZEICHNISSLISTE[$i]}"
		REGIONSINIAUSGABE=$(find /$STARTVERZEICHNIS/"$VERZEICHNIS"/bin/Regions/ -name "Regions.ini")
		#leerzeilen=$(echo "$REGIONSINIAUSGABE" | grep -v '^$')
		while read -r; do
			[[ -z "$REPLY" ]] && continue
			AUSGABE=$(awk -F "[" '/\[/ {print $1 $2 $3}' "$REPLY" | sed s/'\]'//g)
			echo "$AUSGABE"
		done <<<"$REGIONSINIAUSGABE"
	done
	return 0
}

## * get_regionsarray
	# Diese Funktion nimmt den Dateinamen einer INI-Datei ($DATEI) entgegen und extrahiert die Regionsnamen
	# aus den Sektionsüberschriften in der Datei. Die extrahierten Regionsnamen werden in einem Array gespeichert
	# und als Ergebnis zurückgegeben.
	#? Parameter:
	#   - $1: Der Dateiname der INI-Datei, aus der die Regionsnamen extrahiert werden sollen.
	#? Rückgabewert:
	#   - Ein Array, das die extrahierten Regionsnamen enthält.
	#? Verwendungsbeispiel:
	#   regionsarray=($(get_regionsarray "MeineRegions.ini"))
##
function get_regionsarray() {
	# Letzte Bearbeitung 01.10.2023
	# Es fehlt eine pruefung ob Datei vorhanden ist.
	DATEI=$1
	# shellcheck disable=SC2207
	ARRAY=($(grep '\[.*\]' "$DATEI"))
	FIXED_ARRAY=""
	for i in "${ARRAY[@]}"; do
		FIX=$i
		FIX=$(echo "$FIX" | tr --delete "\r")
		FIX=$(echo "$FIX" | tr --delete "[")
		FIX=$(echo "$FIX" | tr --delete "]")
		FIXED_ARRAY+="${FIX} "
	done
	echo "${FIXED_ARRAY}"
	return 0
}

## * get_value_from_Region_key
	# Diese Funktion nimmt drei Argumente entgegen: den Dateinamen der INI-Datei ($RKDATEI), den Namen der Sektion ($RKSCHLUESSEL)
	# und den Namen des Schlüssels ($RKSEKTION), dessen Wert extrahiert werden soll. Die Funktion sucht nach der angegebenen
	# Sektion und dem Schlüssel in der INI-Datei und gibt den entsprechenden Wert zurück.
	#? Parameter:
	#   - $1: Der Dateiname der INI-Datei.
	#   - $2: Der Name der Sektion, in der der Wert gefunden werden soll.
	#   - $3: Der Name des Schlüssels, dessen Wert gefunden werden soll.
	#? Rückgabewert:
	#   - Der extrahierte Wert aus der INI-Datei.
	#? Verwendungsbeispiel:
	#   wert=$(get_value_from_Region_key "meine.ini" "Sektion1" "Schluessel1")
##
function get_value_from_Region_key() {
	# Letzte Bearbeitung 01.10.2023
	# RKDATEI=$1; RKSCHLUESSEL=$2; RKSEKTION=$3;
	# Es fehlt eine pruefung ob Datei vorhanden ist.
	# shellcheck disable=SC2005
	#echo "$(sed -nr "/^\[$2\]/ { :l /^$3[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" "$1")" # Nur Parameter
	echo "$(sed -nr "/^\[$2\]/ { :l /$3[ ]}*=/ { p; q;}; n; b l;}" "$1")" # Komplette eintraege
	return 0
}

## * regionsiniteilen
	# Diese Funktion nimmt drei Argumente entgegen: das Verzeichnis, aus dem die Werte gelesen werden sollen ($INIVERZEICHNIS),
	# den Namen der Region, für die die Werte gespeichert werden sollen ($RTREGIONSNAME), und den Pfad zur Haupt-Regions.ini-Datei
	# ($INI_FILE). Die Funktion überprüft, ob die Haupt-Regions.ini-Datei vorhanden ist, und wenn nicht, werden die Werte für die
	# angegebene Region in eine separate INI-Datei geschrieben.
	#? Parameter:
	#   - $1: Das Verzeichnis, aus dem die Werte gelesen werden sollen.
	#   - $2: Der Name der Region, für die die Werte gespeichert werden sollen.
	#   - $3: Der Pfad zur Haupt-Regions.ini-Datei.
	#? Rückgabewert:
	#   - 0: Erfolgreiche Ausführung der Funktion
	#? Verwendungsbeispiel:
	#   regionsiniteilen "MeinVerzeichnis" "MeineRegion" "/MeinVerzeichnis/bin/Regions/Regions.ini"
##
function regionsiniteilen() {
	# Letzte Bearbeitung 01.10.2023
	INIVERZEICHNIS=$1                                                     # Auszulesendes Verzeichnis
	RTREGIONSNAME=$2                                                      # Auszulesende Region
	INI_FILE="/$STARTVERZEICHNIS/$INIVERZEICHNIS/bin/Regions/Regions.ini" # Auszulesende Datei

	if [ ! -d "$INI_FILE" ]; then
		log info "REGIONSINITEILEN: Schreiben der Werte fuer $RTREGIONSNAME"
		# Schreiben der einzelnen Punkte nur wenn vorhanden ist.
		# shellcheck disable=SC2005
		{
			echo "[$RTREGIONSNAME]"
			echo "$(get_value_from_Region_key "${INI_FILE}" "$RTREGIONSNAME" "RegionUUID")"
			echo "$(get_value_from_Region_key "${INI_FILE}" "$RTREGIONSNAME" "Location")"
			echo "$(get_value_from_Region_key "${INI_FILE}" "$RTREGIONSNAME" "SizeX")"
			echo "$(get_value_from_Region_key "${INI_FILE}" "$RTREGIONSNAME" "SizeY")"
			echo "$(get_value_from_Region_key "${INI_FILE}" "$RTREGIONSNAME" "SizeZ")"
			echo "$(get_value_from_Region_key "${INI_FILE}" "$RTREGIONSNAME" "InternalAddress")"
			echo "$(get_value_from_Region_key "${INI_FILE}" "$RTREGIONSNAME" "InternalPort")"
			echo "$(get_value_from_Region_key "${INI_FILE}" "$RTREGIONSNAME" "AllowAlternatePorts")"
			echo "$(get_value_from_Region_key "${INI_FILE}" "$RTREGIONSNAME" "ResolveAddress")"
			echo "$(get_value_from_Region_key "${INI_FILE}" "$RTREGIONSNAME" "ExternalHostName")"
			echo "$(get_value_from_Region_key "${INI_FILE}" "$RTREGIONSNAME" "MaxPrims")"
			echo "$(get_value_from_Region_key "${INI_FILE}" "$RTREGIONSNAME" "MaxAgents")"
			echo "$(get_value_from_Region_key "${INI_FILE}" "$RTREGIONSNAME" "DefaultLanding")"
			echo "$(get_value_from_Region_key "${INI_FILE}" "$RTREGIONSNAME" "NonPhysicalPrimMax")"
			echo "$(get_value_from_Region_key "${INI_FILE}" "$RTREGIONSNAME" "PhysicalPrimMax")"
			echo "$(get_value_from_Region_key "${INI_FILE}" "$RTREGIONSNAME" "ClampPrimSize")"
			echo "$(get_value_from_Region_key "${INI_FILE}" "$RTREGIONSNAME" "MaxPrimsPerUser")"
			echo "$(get_value_from_Region_key "${INI_FILE}" "$RTREGIONSNAME" "ScopeID")"
			echo "$(get_value_from_Region_key "${INI_FILE}" "$RTREGIONSNAME" "RegionType")"
			echo "$(get_value_from_Region_key "${INI_FILE}" "$RTREGIONSNAME" "MaptileStaticUUID")"
			echo "$(get_value_from_Region_key "${INI_FILE}" "$RTREGIONSNAME" "MaptileStaticFile")"
			echo "$(get_value_from_Region_key "${INI_FILE}" "$RTREGIONSNAME" "MasterAvatarFirstName")"
			echo "$(get_value_from_Region_key "${INI_FILE}" "$RTREGIONSNAME" "MasterAvatarLastName")"
			echo "$(get_value_from_Region_key "${INI_FILE}" "$RTREGIONSNAME" "MasterAvatarSandboxPassword")"
		} >>"/$STARTVERZEICHNIS/$INIVERZEICHNIS/bin/Regions/$RTREGIONSNAME.ini"
	else
		log error "REGIONSINITEILEN: $INI_FILE wurde nicht gefunden"
	fi
	return 0
}

## * autoregionsiniteilen
	# Diese Funktion ruft zuerst die Funktion `makeverzeichnisliste` auf, um eine Liste von Verzeichnissen zu erstellen,
	# und iteriert dann über jedes Verzeichnis in der Liste. Für jedes Verzeichnis wird die Regions.ini-Datei in mehrere
	# separate INI-Dateien aufgeteilt, eine für jede Region, und die einzelnen Regionsdateien werden umbenannt. Falls die
	# Regions.ini-Datei in einem Verzeichnis nicht vorhanden ist, wird sie nicht umbenannt.
	#? Parameter:
	#   - Keine
	#? Rückgabewert:
	#   - 0: Erfolgreiche Ausführung der Funktion
	#? Verwendungsbeispiel:
	#   autoregionsiniteilen
##
function autoregionsiniteilen() {
	# Letzte Bearbeitung 01.10.2023
	makeverzeichnisliste
	sleep 1
	for ((i = 0; i < "$ANZAHLVERZEICHNISSLISTE"; i++)); do
		log info "Region.ini ${VERZEICHNISSLISTE[$i]} zerlegen"
		log line
		VERZEICHNIS="${VERZEICHNISSLISTE[$i]}"
		# Regions.ini teilen:
		echo "$VERZEICHNIS"                                                # OK geht
		INI_FILE="/$STARTVERZEICHNIS/$VERZEICHNIS/bin/Regions/Regions.ini" # Auszulesende Datei
		# shellcheck disable=SC2155
		declare -a TARGETS="$(get_regionsarray "${INI_FILE}")"
		# shellcheck disable=SC2068
		for MeineRegion in ${TARGETS[@]}; do
			regionsiniteilen "$VERZEICHNIS" "$MeineRegion"
			sleep 1
			log rohtext "regionsiniteilen $VERZEICHNIS $MeineRegion"
		done
		#  Dann umbenennen:
		# Pruefung ob Datei vorhanden ist, wenn ja umbenennen.
		if [ ! -d "$INI_FILE" ]; then
			mv /$STARTVERZEICHNIS/"$INIVERZEICHNIS"/bin/Regions/Regions.ini /$STARTVERZEICHNIS/"$INIVERZEICHNIS"/bin/Regions/"$DATUM"-Regions.ini.old
		fi
	done
	return 0
}

## * regionliste
	# Diese Funktion erstellt eine Liste von Regionsnamen aus den INI-Dateien in den angegebenen Verzeichnissen und speichert
	# sie in der Datei osmregionlist.ini. Zuvor wird die vorhandene osmregionlist.ini-Datei (falls vorhanden) gesichert und in
	# osmregionlist.ini.old umbenannt.
	#? Parameter:
	#   - Keine
	#? Rückgabewert:
	#   - 0: Erfolgreiche Ausführung der Funktion
	#? Verwendungsbeispiel:
	#   regionliste
##  
function regionliste() {
	# Letzte Bearbeitung 01.10.2023
	# Alte osmregionlist.ini sichern und in osmregionlist.ini.old umbenennen.
	if [ -f "/$STARTVERZEICHNIS/osmregionlist.ini" ]; then
		if [ -f "/$STARTVERZEICHNIS/osmregionlist.ini.old" ]; then
			rm -r /$STARTVERZEICHNIS/osmregionlist.ini.old
		fi
		mv /$STARTVERZEICHNIS/osmregionlist.ini /$STARTVERZEICHNIS/osmregionlist.ini.old
	fi
	# Die mit regionsconfigdateiliste erstellte Datei osmregionlist.ini nach sim Verzeichnis und Regionsnamen in die osmregionlist.ini speichern.
	declare -A Dateien # Array erstellen
	makeverzeichnisliste
	sleep 1
	for ((i = 0; i < "$ANZAHLVERZEICHNISSLISTE"; i++)); do
		log info "Regionnamen ${VERZEICHNISSLISTE[$i]} schreiben"
		VERZEICHNIS="${VERZEICHNISSLISTE[$i]}"
		# shellcheck disable=SC2178
		Dateien=$(find /$STARTVERZEICHNIS/"$VERZEICHNIS"/bin/Regions/ -name "*.ini")
		for i2 in "${Dateien[@]}"; do # Array abarbeiten
			echo "$i2" >>osmregionlist.ini
		done
	done
	# Ueberfluessige Zeichen entfernen
	LOESCHEN=$(sed s/'\/'$STARTVERZEICHNIS'\/'//g /$STARTVERZEICHNIS/osmregionlist.ini)
	echo "$LOESCHEN" >/$STARTVERZEICHNIS/osmregionlist.ini                           # Aenderung /$STARTVERZEICHNIS/ speichern.
	LOESCHEN=$(sed s/'\/bin\/Regions\/'/' "'/g /$STARTVERZEICHNIS/osmregionlist.ini) # /bin/Regions/ entfernen.
	echo "$LOESCHEN" >/$STARTVERZEICHNIS/osmregionlist.ini                           # Aenderung /bin/Regions/ speichern.
	LOESCHEN=$(sed s/'.ini'/'"'/g /$STARTVERZEICHNIS/osmregionlist.ini)              # Endung .ini entfernen.
	echo "$LOESCHEN" >/$STARTVERZEICHNIS/osmregionlist.ini                           # Aenderung .ini entfernen speichern.

	LOESCHEN=$(sed s/'\"'/''/g /$STARTVERZEICHNIS/osmregionlist.ini) # " entfernen.
	echo "$LOESCHEN" >/$STARTVERZEICHNIS/osmregionlist.ini                           # Aenderung " entfernen speichern.

	# Schauen ob da noch Regions.ini bei sind also Regionen mit dem Namen Regions, diese Zeilen loeschen.
	LOESCHEN=$(sed '/Regions/d' /$STARTVERZEICHNIS/osmregionlist.ini) # Alle Zeilen mit dem Eintrag Regions entfernen	.
	echo "$LOESCHEN" >/$STARTVERZEICHNIS/osmregionlist.ini            # Aenderung .ini entfernen speichern.
	return 0
}

## * makewebmaps
	# Diese Funktion kopiert Maptiles aus dem angegebenen Verzeichnis in ein Webverzeichnis, damit sie über das Web verfügbar sind.
	# Das Webverzeichnis wird zuerst erstellt, wenn es nicht bereits vorhanden ist. Die Maptiles werden dann kopiert.
	#? Parameter:
	#   - Keine
	#? Rückgabewert:
	#   - 0: Erfolgreiche Ausführung der Funktion
	#? Verwendungsbeispiel:
	#   makewebmaps
##
function makewebmaps() {
	# Letzte Bearbeitung 01.10.2023
	MAPTILEVERZEICHNIS="maptiles"
	log info "MAKEWEBMAPS: Kopiere Maptile"
	# Verzeichnis erstellen wenn es noch nicht vorhanden ist.
	mkdir -p /var/www/html/$MAPTILEVERZEICHNIS/
	# Maptiles kopieren
	find /$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS/bin/maptiles -type f -exec cp -a -t /var/www/html/$MAPTILEVERZEICHNIS/ {} +
	return 0
}

## * moneydelete
	# Diese Funktion entfernt MoneyServer-Komponenten aus den OpenSimulator-Verzeichnissen und Robust-Verzeichnis, wenn es vorhanden ist.
	# Die zu löschenden Dateien und Verzeichnisse werden spezifiziert.
	#? Parameter:
	#   - Keine
	#? Rückgabewert:
	#   - 0: Erfolgreiche Ausführung der Funktion
	#? Verwendungsbeispiel:
	#   moneydelete
##
function moneydelete() {
	# Letzte Bearbeitung 01.10.2023
	makeverzeichnisliste
	sleep 1
	# MoneyServer aus den sims entfernen
	for ((i = 0; i < "$ANZAHLVERZEICHNISSLISTE"; i++)); do
		cd /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin || return 1               # Pruefen ob Verzeichnis vorhanden ist.
		rm -r /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/MoneyServer.exe.config # Dateien loeschen.
		rm -r /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/MoneyServer.ini.example
		rm -r /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/OpenSim.Data.MySQL.MySQLMoneyDataWrapper.dll
		rm -r /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/OpenSim.Modules.Currency.dll
		log info "MONEYDELETE: MoneyServer ${VERZEICHNISSLISTE[$i]} geloescht"
		sleep 1
	done
	# MoneyServer aus Robust entfernen
	if [ -d /$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS/ ]; then
		cd /$STARTVERZEICHNIS/robust/bin || return 1
		rm -r /$STARTVERZEICHNIS/robust/bin/MoneyServer.exe.config
		rm -r /$STARTVERZEICHNIS/robust/bin/MoneyServer.ini.example
		rm -r /$STARTVERZEICHNIS/robust/bin/OpenSim.Data.MySQL.MySQLMoneyDataWrapper.dll
		rm -r /$STARTVERZEICHNIS/robust/bin/OpenSim.Modules.Currency.dll
		log info "MONEYDELETE: MoneyServer aus Robust geloescht"
	fi
	return 0
}

## * osgitholen
	# Diese Funktion klont die Entwicklungsversion des OpenSimulator aus dem Git-Repository und speichert sie im angegebenen Verzeichnis.
	# Wenn das Verzeichnis bereits vorhanden ist, wird es zuerst umbenannt, um es als Sicherung zu behalten.
	#? Parameter:
	#   - Keine
	#? Rückgabewert:
	#   - 0: Erfolgreiche Ausführung der Funktion
	#? Verwendungsbeispiel:
	#   osgitholen
##
function osgitholen() {
	# Letzte Bearbeitung 01.10.2023
	if [ -d /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/ ]; then
		log rohtext "Kopieren der Entwicklungsversion des OpenSimulator aus dem Git."
		log info "*****************************#"
		cd /$STARTVERZEICHNIS || return 1
		rm -r /$STARTVERZEICHNIS/opensim1
		mv /$STARTVERZEICHNIS/opensim /$STARTVERZEICHNIS/opensim1
		git clone git://opensimulator.org/git/opensim opensim
		log info "OPENSIMHOLEN: Git klonen"
	else
		log rohtext "Kopieren der Entwicklungsversion des OpenSimulator aus dem Git."
		log info "*****************************#"
		log info "Kopieren der Entwicklungsversion des OpenSimulator aus dem Git"
		git clone git://opensimulator.org/git/opensim opensim
	fi
	return 0
}

## * osgitholen93
	# Diese Funktion klonet die Entwicklungsversion des OpenSimulator aus dem Git-Repository und speichert sie im angegebenen Verzeichnis.
	# Wenn das Verzeichnis bereits vorhanden ist, wird es zuerst umbenannt, um es als Sicherung zu behalten. Dann wird die aktuelle Version
	# aus dem Git-Repository geklont und aktualisiert.
	#? Parameter:
	#   - Keine
	#? Rückgabewert:
	#   - 0: Erfolgreiche Ausführung der Funktion
	#? Verwendungsbeispiel:
	#   osgitholen93
##
function osgitholen93() {
	# Letzte Bearbeitung 01.10.2023
	log rohtext "Kopieren der Entwicklungsversion des OpenSimulator aus dem Git."
	log info "*****************************#"
	cd /$STARTVERZEICHNIS || return 1
	rm -r /$STARTVERZEICHNIS/opensim1
	mv /$STARTVERZEICHNIS/opensim /$STARTVERZEICHNIS/opensim1
	git clone git://opensimulator.org/git/opensim opensim
	git pull
	log info "OpenSim wurde geklont"

	# Bauen
    # cd /$STARTVERZEICHNIS/opensim || exit
    # git checkout dotnet6
    # ./runprebuild.sh
    # dotnet build --configuration Release OpenSim.sln
    log rohtext "Eine Besonderheit ist, der Startvorgang hat sich geaendert, es wird nicht mehr mit mono OpenSim.exe gestartet, sondern mit dotnet OpenSim.dll."
}

## * osbauen93
	# Diese Funktion wechselt zum OpenSimulator-Verzeichnis, stellt sicher, dass der branch 'dotnet6' ausgewählt ist, führt die notwendigen 
	# Vorverarbeitungsschritte aus, und baut das OpenSimulator-Projekt mit .NET Core. Das Ergebnis ist die Erstellung der OpenSimulator-
	# Anwendung, die mit 'dotnet OpenSim.dll' gestartet werden kann.
	#? Parameter:
	#   - Keine
	#? Rückgabewert:
	#   - 0: Erfolgreiche Ausführung der Funktion
	#? Verwendungsbeispiel:
	#   osbauen93
##
function osbauen93() {
	# Letzte Bearbeitung 01.10.2023
	# Bauen
    cd /$STARTVERZEICHNIS/opensim || exit
    git checkout dotnet6
    ./runprebuild.sh
    dotnet build --configuration Release OpenSim.sln
    log rohtext "Eine Besonderheit ist, der Startvorgang hat sich geaendert, es wird nicht mehr mit mono OpenSim.exe gestartet, sondern mit dotnet OpenSim.dll."
}

## * opensimholen
	# Diese Funktion sichert zuerst die vorhandene OpenSimulator-Installation im Verzeichnis 'opensim1' (falls vorhanden) und lädt dann die 
	# neue Version des OpenSimulator aus einem externen Quellen-Link herunter. Nach dem Herunterladen wird die neue Version entpackt und 
	# im Verzeichnis 'opensim' abgelegt.
	#? Parameter:
	#   - Keine
	#? Rückgabewert:
	#   - 0: Erfolgreiche Ausführung der Funktion
	#? Verwendungsbeispiel:
	#   opensimholen
##
function opensimholen() {
	# Letzte Bearbeitung 01.10.2023
	if [ -d /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/ ]; then
		log info "OpenSimulator im Verzeichnis opensim1 sichern und neuen OpenSimulator herunterladen."
		cd /$STARTVERZEICHNIS || return 1
		rm -r /$STARTVERZEICHNIS/opensim1
		mv /$STARTVERZEICHNIS/opensim /$STARTVERZEICHNIS/opensim1

		echo "$OPENSIMDOWNLOAD$OPENSIMVERSION"
		wget $OPENSIMDOWNLOAD$OPENSIMVERSION.zip
		echo "$OPENSIMVERSION"
		unzip $OPENSIMVERSION
		mv /$STARTVERZEICHNIS/$OPENSIMVERSION /$STARTVERZEICHNIS/opensim

		log info "OPENSIMHOLEN: Download"
	else
		log info "OpenSimulator im Verzeichnis opensim1 sichern und neuen OpenSimulator herunterladen."

		echo "$OPENSIMDOWNLOAD$OPENSIMVERSION"
		wget $OPENSIMDOWNLOAD$OPENSIMVERSION.zip
		echo "$OPENSIMVERSION"
		unzip $OPENSIMVERSION
		mv /$STARTVERZEICHNIS/$OPENSIMVERSION /$STARTVERZEICHNIS/opensim

		log info "OPENSIMHOLEN: Download"
	fi
	return 0
}

## * install_mysqltuner
	# Diese Funktion lädt das MySQLTuner-Skript und verwandte Dateien von ihren jeweiligen Quellen herunter und speichert sie im aktuellen 
	# Verzeichnis. Anschließend wird die Funktion 'mySQLmenu' aufgerufen, um den MySQLTuner zu konfigurieren und auszuführen.
	#? Parameter:
	#   - Keine
	#? Rückgabewert:
	#   - 0: Erfolgreiche Ausführung der Funktion
	#? Verwendungsbeispiel:
	#   install_mysqltuner
##
function install_mysqltuner() {
	# Letzte Bearbeitung 01.10.2023
	cd /$STARTVERZEICHNIS || return 1
	log info "mySQL Tuner Download"
	wget http://mysqltuner.pl/ -O mysqltuner.pl 2>/dev/null
	wget https://raw.githubusercontent.com/major/MySQLTuner-perl/master/basic_passwords.txt -O basic_passwords.txt 2>/dev/null
	wget https://raw.githubusercontent.com/major/MySQLTuner-perl/master/vulnerabilities.csv -O vulnerabilities.csv 2>/dev/null
	mySQLmenu
	return 0
}

## * regionbackup
	# Diese Funktion erstellt ein Backup für eine OpenSimulator-Region, indem sie OAR- und Terrain-Daten sowie Konfigurationsdateien speichert.
	# Die Region wird in den Offline-Modus versetzt, wenn sie nicht bereits offline ist, bevor das Backup erstellt wird.
	#? Parameter:
	#   1. BACKUPVERZEICHNISSCREENNAME: Der Name des Bildschirms (Screen) für das Backup.
	#   2. REGIONSNAME: Der Name der Region, die gesichert werden soll.
	#? Rückgabewert:
	#   - 0: Erfolgreiche Ausführung der Funktion
	#? Verwendungsbeispiel:
	#   regionbackup "BackupScreen" "MyRegion"
##
function regionbackup() {
	# Letzte Bearbeitung 01.10.2023
	# regionbackup "$BACKUPSCREEN" "$BACKUPREGION"
	log rohtext "Empfange: $BACKUPSCREEN $BACKUPREGION"

	sleep 1
	BACKUPVERZEICHNISSCREENNAME=$1
	REGIONSNAME=$2

	log line
	log info "Backup $BACKUPVERZEICHNISSCREENNAME der Region $REGIONSNAME"
	cd /$STARTVERZEICHNIS/"$BACKUPVERZEICHNISSCREENNAME"/bin || return 1 # Test ob Verzeichnis vorhanden.
	mkdir -p /$STARTVERZEICHNIS/backup # Backup Verzeichnis anlegen falls nicht vorhanden.
	log info "Ich kann nicht pruefen ob die Region im OpenSimulator vorhanden ist."
	log info "Sollte sie nicht vorhanden sein wird root also alle Regionen gespeichert"
	# Ist die Region Online oder Offline?
	if [ -f /$STARTVERZEICHNIS/"$BACKUPVERZEICHNISSCREENNAME"/bin/Regions/"$REGIONSNAME".ini.offline ]; then
	log rohtext "$REGIONSNAME ist heruntergefahren."
	else
	screen -S "$BACKUPVERZEICHNISSCREENNAME" -p 0 -X eval "stuff 'change region ${REGIONSNAME//\"/}'^M"
	log info "$BACKUPVERZEICHNISSCREENNAME $REGIONSNAME"
	screen -S "$BACKUPVERZEICHNISSCREENNAME" -p 0 -X eval "stuff 'save oar /$STARTVERZEICHNIS/backup/'$DATUM'-$REGIONSNAME.oar'^M"
	log info "$BACKUPVERZEICHNISSCREENNAME $DATUM-$REGIONSNAME.oar"

	# Neu xml backup
	screen -S "$BACKUPVERZEICHNISSCREENNAME" -p 0 -X eval "stuff 'save xml2 /$STARTVERZEICHNIS/backup/'$DATUM'-$REGIONSNAME.xml2'^M"
	log info "$BACKUPVERZEICHNISSCREENNAME $DATUM-$REGIONSNAME.xml2"
	# Neu xml backup ende

	screen -S "$BACKUPVERZEICHNISSCREENNAME" -p 0 -X eval "stuff 'terrain save /$STARTVERZEICHNIS/backup/'$DATUM'-$REGIONSNAME.png'^M"
	log info "$BACKUPVERZEICHNISSCREENNAME $DATUM-$REGIONSNAME.png"
	screen -S "$BACKUPVERZEICHNISSCREENNAME" -p 0 -X eval "stuff 'terrain save /$STARTVERZEICHNIS/backup/'$DATUM'-$REGIONSNAME.raw'^M"
	log info "$BACKUPVERZEICHNISSCREENNAME $DATUM-$REGIONSNAME.raw"
	log info "$BACKUPVERZEICHNISSCREENNAME Region $DATUM-$REGIONSNAME RAW und PNG Terrain werden gespeichert"
	fi
	
	sleep 10
	if [ -f /$STARTVERZEICHNIS/"$BACKUPVERZEICHNISSCREENNAME"/bin/Regions/"$REGIONSNAME".ini.offline ]; then
		cp /$STARTVERZEICHNIS/"$BACKUPVERZEICHNISSCREENNAME"/bin/Regions/"$REGIONSNAME".ini.offline /$STARTVERZEICHNIS/backup/"$DATUM"-"$REGIONSNAME".ini.offline
		log info "$BACKUPVERZEICHNISSCREENNAME Die Regions $DATUM-$REGIONSNAME.ini.offline wird gespeichert"
	fi
	if [ -f /$STARTVERZEICHNIS/"$BACKUPVERZEICHNISSCREENNAME"/bin/Regions/"$REGIONSNAME".ini ]; then
		cp /$STARTVERZEICHNIS/"$BACKUPVERZEICHNISSCREENNAME"/bin/Regions/"$REGIONSNAME".ini /$STARTVERZEICHNIS/backup/"$DATUM"-"$REGIONSNAME".ini
		log info "$BACKUPVERZEICHNISSCREENNAME Die Regions $DATUM-$REGIONSNAME.ini wird gespeichert"
	fi
	if [ -f /$STARTVERZEICHNIS/"$BACKUPVERZEICHNISSCREENNAME"/bin/Regions/"${REGIONSNAME//\"/}" ]; then
		cp /$STARTVERZEICHNIS/"$BACKUPVERZEICHNISSCREENNAME"/bin/Regions/"${REGIONSNAME//\"/}" /$STARTVERZEICHNIS/backup/"$DATUM"-"$REGIONSNAME".ini
		log info "$BACKUPVERZEICHNISSCREENNAME Die Regions $DATUM-$REGIONSNAME.ini wird gespeichert"
	fi
	# Regions.ini.example loeschen.
	# if [ ! -f /$STARTVERZEICHNIS/"$MBACKUPVERZEICHNISSCREENNAME"/bin/Regions/Regions.ini.example ]; then
	# 	rm /$STARTVERZEICHNIS/"$MBACKUPVERZEICHNISSCREENNAME"/bin/Regions/Regions.ini.example
	# fi
	# if [ ! -f /$STARTVERZEICHNIS/"$BACKUPVERZEICHNISSCREENNAME"/bin/Regions/Regions.ini ]; then
	# 	cp -r /$STARTVERZEICHNIS/"$BACKUPVERZEICHNISSCREENNAME"/bin/Regions/Regions.ini /$STARTVERZEICHNIS/backup/"$DATUM"-"$REGIONSNAME".ini
	# 	log info "Die Regions $NSDATEINAME.ini wird gespeichert"
	# fi
	log rohtext "Backup der Region $REGIONSNAME wird fertiggestellt."
	return 0
}

## * menuregionbackup
	# Diese Funktion verwendet das Dialog-Tool zur Benutzereingabe, um den Bildschirmnamen und den Regionsnamen abzurufen und dann ein Backup der angegebenen Region zu erstellen.
	# Das Backup enthält OAR- und Terrain-Daten sowie Konfigurationsdateien der Region.
	#? Parameter:
	#   Keine
	#? Rückgabewert:
	#   - 0: Erfolgreiche Ausführung der Funktion
	#? Verwendungsbeispiel:
	#   menuregionbackup
##
function menuregionbackup() {
	# Letzte Bearbeitung 01.10.2023
	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then

		# Einstellungen
		boxbacktitel="opensimMULTITOOL"
		boxtitel="opensimMULTITOOL Eingabe"
		formtitle="Backup einer Region"
		lable1="Screenname:"
		lablename1=""
		lable2="Regionsname:"
		lablename2=""

		# Abfrage
		regionbackupBOXERGEBNIS=$(dialog --backtitle "$boxbacktitel" --title "$boxtitel" --form "$formtitle" 25 60 16 "$lable1" 1 1 "$lablename1" 1 25 25 30 "$lable2" 2 1 "$lablename2" 2 25 25 30 3>&1 1>&2 2>&3 3>&-)

		# Zeilen aus einer Variablen zerlegen und in verschiedenen Variablen schreiben.
		MBACKUPVERZEICHNISSCREENNAME=$(echo "$regionbackupBOXERGEBNIS" | sed -n '1p')
		REGIONSNAME=$(echo "$regionbackupBOXERGEBNIS" | sed -n '2p')

		# Alles loeschen.
		dialogclear
		ScreenLog
	else
		# Alle Aktionen ohne dialog
		log rohtext "Keine Menuelose Funktion" | exit
	fi # dialog Aktionen Ende

	sleep 1
	log line
	log info "Backup der Region $REGIONSNAME"
	cd /$STARTVERZEICHNIS/"$MBACKUPVERZEICHNISSCREENNAME"/bin || return 1 # Test ob Verzeichnis vorhanden.
	mkdir -p /$STARTVERZEICHNIS/backup # Backup Verzeichnis anlegen falls nicht vorhanden.
	log info "Ich kann nicht pruefen ob die Region im OpenSimulator vorhanden ist."
	log info "Sollte sie nicht vorhanden sein wird root also alle Regionen gespeichert"
	screen -S "$MBACKUPVERZEICHNISSCREENNAME" -p 0 -X eval "stuff 'change region ${REGIONSNAME//\"/}'^M"
	screen -S "$MBACKUPVERZEICHNISSCREENNAME" -p 0 -X eval "stuff 'save oar /$STARTVERZEICHNIS/backup/'$DATUM'-$REGIONSNAME.oar'^M"

	# Neu xml backup
	screen -S "$BACKUPVERZEICHNISSCREENNAME" -p 0 -X eval "stuff 'save xml2 /$STARTVERZEICHNIS/backup/'$DATUM'-$REGIONSNAME.xml2'^M"
	# Neu xml backup ende

	screen -S "$MBACKUPVERZEICHNISSCREENNAME" -p 0 -X eval "stuff 'terrain save /$STARTVERZEICHNIS/backup/'$DATUM'-$REGIONSNAME.png'^M"
	screen -S "$MBACKUPVERZEICHNISSCREENNAME" -p 0 -X eval "stuff 'terrain save /$STARTVERZEICHNIS/backup/'$DATUM'-$REGIONSNAME.raw'^M"
	log info "Region $DATUM-$REGIONSNAME RAW und PNG Terrain werden gespeichert"
	
	sleep 10
	if [ -f /$STARTVERZEICHNIS/"$MBACKUPVERZEICHNISSCREENNAME"/bin/Regions/"$REGIONSNAME".ini ]; then
		cp /$STARTVERZEICHNIS/"$MBACKUPVERZEICHNISSCREENNAME"/bin/Regions/"$REGIONSNAME".ini /$STARTVERZEICHNIS/backup/"$DATUM"-"$REGIONSNAME".ini
		log info "Die Regions $DATUM-$REGIONSNAME wird gespeichert"
	fi
	if [ -f /$STARTVERZEICHNIS/"$MBACKUPVERZEICHNISSCREENNAME"/bin/Regions/"${REGIONSNAME//\"/}" ]; then
		cp /$STARTVERZEICHNIS/"$MBACKUPVERZEICHNISSCREENNAME"/bin/Regions/"${REGIONSNAME//\"/}" /$STARTVERZEICHNIS/backup/"$DATUM"-"$REGIONSNAME".ini
		log info "Die Regions $DATUM-$REGIONSNAME wird gespeichert"
	fi
	return 0
}

## * regionrestore
	# Diese Funktion stellt eine zuvor gesicherte OpenSimulator-Region aus einem OAR-Backup wieder her.
	#? Parameter:
	#   1. RESTOREVERZEICHNISSCREENNAME: Der Name des Bildschirms (Screen) für die Wiederherstellung.
	#   2. REGIONSNAME: Der Name der Region, die wiederhergestellt werden soll.
	#? Rückgabewert:
	#   - 0: Erfolgreiche Ausführung der Funktion
	#? Verwendungsbeispiel:
	#   regionrestore "RestoreScreen" "MyRegion"
##
function regionrestore() {
	# Letzte Bearbeitung 01.10.2023
	RESTOREVERZEICHNISSCREENNAME=$1
	REGIONSNAME=$2
	DATEINAME=${REGIONSNAME//\"/}
	NSDATEINAME=${DATEINAME// /}

	log info "OSRESTORE: Region $NSDATEINAME wiederherstellen"
	cd /$STARTVERZEICHNIS/"$RESTOREVERZEICHNISSCREENNAME"/bin || return 1
	log info "Ich kann nicht pruefen ob die Region im OpenSimulator vorhanden ist."
	log info "Sollte sie nicht vorhanden sein wird root also alle Regionen wiederhergestellt."
	screen -S "$RESTOREVERZEICHNISSCREENNAME" -p 0 -X eval "stuff 'change region ${REGIONSNAME//\"/}'^M"
	screen -S "$RESTOREVERZEICHNISSCREENNAME" -p 0 -X eval "stuff 'load oar /$STARTVERZEICHNIS/backup/'$DATUM'-$NSDATEINAME.oar'^M"

	log info "OSRESTORE: Region $DATUM-$NSDATEINAME wird wiederhergestellt"
	log line
	return 0
}

## * menuregionrestore
	# Diese Funktion verwendet das Dialog-Programm, um Benutzereingaben zu erhalten und die Wiederherstellung einer OpenSimulator-Region aus einem OAR-Backup durchzuführen.
	#? Parameter: Keine
	#? Rückgabewert:
	#   - 0: Erfolgreiche Ausführung der Funktion
	#? Verwendungsbeispiel:
	#   menuregionrestore
##
function menuregionrestore() {
	# Letzte Bearbeitung 01.10.2023
	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then

		# Einstellungen
		boxbacktitel="opensimMULTITOOL"
		boxtitel="opensimMULTITOOL Eingabe"
		formtitle="Restore einer Region"
		lable1="Screenname:"
		lablename1=""
		lable2="Regionsname:"
		lablename2=""

		# Abfrage
		regionrestoreBOXERGEBNIS=$(dialog --backtitle "$boxbacktitel" --title "$boxtitel" --form "$formtitle" 25 60 16 "$lable1" 1 1 "$lablename1" 1 25 25 30 "$lable2" 2 1 "$lablename2" 2 25 25 30 3>&1 1>&2 2>&3 3>&-)

		# Zeilen aus einer Variablen zerlegen und in verschiedenen Variablen schreiben.
		MRESTOREVERZEICHNISSCREENNAME=$(echo "$regionrestoreBOXERGEBNIS" | sed -n '1p')
		REGIONSNAME=$(echo "$regionrestoreBOXERGEBNIS" | sed -n '2p')

		# Alles loeschen.
		dialogclear
		ScreenLog
	else
		# Alle Aktionen ohne dialog
		log rohtext "Keine Menuelose Funktion" | exit
	fi # dialog Aktionen Ende

	DATEINAME=${REGIONSNAME//\"/}
	NSDATEINAME=${DATEINAME// /}

	log info "OSRESTORE: Region $NSDATEINAME wiederherstellen"
	cd /$STARTVERZEICHNIS/"$MRESTOREVERZEICHNISSCREENNAME"/bin || return 1
	log info "Ich kann nicht pruefen ob die Region im OpenSimulator vorhanden ist."
	log info "Sollte sie nicht vorhanden sein wird root also alle Regionen wiederhergestellt."
	screen -S "$MRESTOREVERZEICHNISSCREENNAME" -p 0 -X eval "stuff 'change region ${REGIONSNAME//\"/}'^M"
	screen -S "$MRESTOREVERZEICHNISSCREENNAME" -p 0 -X eval "stuff 'load oar /$STARTVERZEICHNIS/backup/'$DATUM'-$NSDATEINAME.oar'^M"

	log info "OSRESTORE: Region $DATUM-$NSDATEINAME wird wiederhergestellt"
	log line
	return 0
}

## * autosimstart
	# Diese Funktion startet OpenSimulator-Regionen automatisch, sofern sie nicht bereits gestartet sind.
	# Sie überprüft, ob bereits ein Bildschirm mit dem Namen 'sim' ausgeführt wird. Wenn nicht, wird jede Region aus der Verzeichnisliste gestartet.
	# Die Funktion verwendet die in den Konfigurationsvariablen festgelegten Einstellungen, wie z. B. den Regionsanzeigemodus und den AOT-Modus.
	#? Parameter: Keine
	#? Rückgabewert:
	#   - 0: Erfolgreiche Ausführung der Funktion
	#? Verwendungsbeispiel:
	#   autosimstart
##
function autosimstart() {
	# Letzte Bearbeitung 01.10.2023
	if ! screen -list | grep -q 'sim'; then
		# es laeuft kein Simulator - not work
		makeverzeichnisliste
		sleep 1
		for ((i = 0; i < "$ANZAHLVERZEICHNISSLISTE"; i++)); do
			log info "Regionen ${VERZEICHNISSLISTE[$i]} werden gestartet"
			cd /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin || return 1

			if [ "$REGIONSANZEIGE" = "yes" ]; then
				# Zeigt die Regionsnamen aus einer Regions.ini an
				STARTREGIONSAUSGABE=$(awk -F "[" '/\[/ {print $1 $2 $3}' /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/Regions/*.ini | sed s/'\]'//g);
				log info "${VERZEICHNISSLISTE[$i]} hat folgende Regionen:";
				for regionen in "${STARTREGIONSAUSGABE[@]}"; do log rohtext "$regionen"; done
			fi

			# AOT Aktiveren oder Deaktivieren.
			if [[ $SETAOTON = "yes" ]]; then
				screen -fa -S "${VERZEICHNISSLISTE[$i]}" -d -U -m mono --desktop -O=all OpenSim.exe
			else

				#screen -fa -S "${VERZEICHNISSLISTE[$i]}" -d -U -m mono OpenSim.exe
				# DOTNETMODUS="yes"
				if [[ "${DOTNETMODUS}" == "yes" ]]; then
					screen -fa -S "${VERZEICHNISSLISTE[$i]}" -d -U -m dotnet OpenSim.dll
				fi
				# DOTNETMODUS="no"
				if [[ "${DOTNETMODUS}" == "no" ]]; then
					screen -fa -S "${VERZEICHNISSLISTE[$i]}" -d -U -m mono OpenSim.exe
				fi

			fi
			sleep $STARTWARTEZEIT
		done
	else
		# es laeuft mindestens ein Simulator - work
		log text "WORKS:  Regionen laufen bereits!"
	fi
	return 0
}

## * autosimstop
	# Diese Funktion stoppt automatisch laufende OpenSimulator-Regionen. Sie überprüft, ob für jede Region ein Bildschirmprozess ausgeführt wird, und sendet das Befehl "shutdown" an jeden aktiven Bildschirm, um die Region zu beenden. Es gibt eine Wartezeit zwischen den Befehlen, um sicherzustellen, dass die Regionen ordnungsgemäß heruntergefahren werden können.
	#? Parameter: Keine
	#? Rückgabewert:
	#   - Kein expliziter Rückgabewert
	#? Verwendungsbeispiel:
	#   autosimstop
##
function autosimstop() {
	# Letzte Bearbeitung 01.10.2023
	makeverzeichnisliste
	sleep 1
	for ((i = 0; i < "$ANZAHLVERZEICHNISSLISTE"; i++)); do
		if screen -list | grep -q "${VERZEICHNISSLISTE[$i]}"; then
			log warn "Regionen ${VERZEICHNISSLISTE[$i]} Beenden"
			screen -S "${VERZEICHNISSLISTE[$i]}" -p 0 -X eval "stuff 'shutdown'^M"
			sleep $STOPWARTEZEIT
		else
			log error "${VERZEICHNISSLISTE[$i]} laeuft nicht"
		fi
	done
	return 0
}

## * menuautosimstart
	# Diese Funktion startet OpenSimulator-Regionen automatisch, basierend auf Benutzereingaben über ein Dialogfeld, wenn kein Simulator aktiv ist.
	# Sie überprüft, ob bereits ein Bildschirm mit dem Namen 'sim' ausgeführt wird. Wenn nicht, wird ein Dialogfeld angezeigt, in dem der Benutzer die gewünschten Regionen auswählen kann.
	# Dann werden die ausgewählten Regionen gestartet, unter Verwendung der in den Konfigurationsvariablen festgelegten Einstellungen, wie z. B. dem Regionsanzeigemodus und dem AOT-Modus.
	#? Parameter: Keine
	#? Rückgabewert:
	#   - Kein expliziter Rückgabewert
	#? Verwendungsbeispiel:
	#   menuautosimstart
##
function menuautosimstart() {
	# Letzte Bearbeitung 01.10.2023
	if ! screen -list | grep -q 'sim'; then
		# es laeuft kein Simulator - not work
		makeverzeichnisliste
		sleep 1
		for ((i = 0; i < "$ANZAHLVERZEICHNISSLISTE"; i++)); do
			log info "Regionen ${VERZEICHNISSLISTE[$i]} werden gestartet"
			cd /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin || return 1

			if [ "$REGIONSANZEIGE" = "yes" ]; then
				# Zeigt die Regionsnamen aus einer Regions.ini an
				STARTREGIONSAUSGABE=$(awk -F "[" '/\[/ {print $1 $2 $3}' /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/Regions/*.ini | sed s/'\]'//g);
				log info "${VERZEICHNISSLISTE[$i]} hat folgende Regionen:";
				for regionen in "${STARTREGIONSAUSGABE[@]}"; do log rohtext "$regionen"; done
			fi

			# AOT Aktiveren oder Deaktivieren.
			if [[ $SETAOTON = "yes" ]]; then
				screen -fa -S "${VERZEICHNISSLISTE[$i]}" -d -U -m mono --desktop -O=all OpenSim.exe
			else

				#screen -fa -S "${VERZEICHNISSLISTE[$i]}" -d -U -m mono OpenSim.exe
				# DOTNETMODUS="yes"
				if [[ "${DOTNETMODUS}" == "yes" ]]; then
					screen -fa -S "${VERZEICHNISSLISTE[$i]}" -d -U -m dotnet OpenSim.dll
				fi
				# DOTNETMODUS="no"
				if [[ "${DOTNETMODUS}" == "no" ]]; then
					screen -fa -S "${VERZEICHNISSLISTE[$i]}" -d -U -m mono OpenSim.exe
				fi

			fi
			sleep $STARTWARTEZEIT
		done
	else
		# es laeuft mindestens ein Simulator - work
		log text "WORKS:  Regionen laufen bereits!"
	fi
	#hauptmenu
	menuinfo
	#return 0
}

## * menuautosimstop
	# Diese Funktion stoppt automatisch laufende OpenSimulator-Regionen und zeigt einen Fortschrittsbalken während des Vorgangs an. Sie überprüft, ob für jede Region ein Bildschirmprozess ausgeführt wird, und sendet das Befehl "shutdown" an jeden aktiven Bildschirm, um die Region zu beenden. Es gibt eine Wartezeit zwischen den Befehlen, um sicherzustellen, dass die Regionen ordnungsgemäß heruntergefahren werden können. Während des Vorgangs wird ein Fortschrittsbalken angezeigt.
	#? Parameter: Keine
	#? Rückgabewert:
	#   - Kein expliziter Rückgabewert
	#? Verwendungsbeispiel:
	#   menuautosimstop
##
function menuautosimstop() {
	# Letzte Bearbeitung 01.10.2023
	makeverzeichnisliste
	sleep 1
	for ((i = 0; i < "$ANZAHLVERZEICHNISSLISTE"; i++)); do
		if screen -list | grep -q "${VERZEICHNISSLISTE[$i]}"; then
			log text "Regionen ${VERZEICHNISSLISTE[$i]} Beenden"

			#BALKEN2=$(("$i"*5))
			#TMP2=$(("$ANZAHLVERZEICHNISSLISTE"*"$i"))
			#BALKEN2=$(("$TMP2/100"))
			#BERECHNUNG2=$((100 / "$ANZAHLVERZEICHNISSLISTE"))
			#BALKEN2=$(("$i" * "$BERECHNUNG2"))
			#BALKEN2=$(( (100/"$ANZAHLVERZEICHNISSLISTE") * "${VERZEICHNISSLISTE[$i]}"))

			screen -S "${VERZEICHNISSLISTE[$i]}" -p 0 -X eval "stuff 'shutdown'^M" | log info "${VERZEICHNISSLISTE[$i]} wurde angewiesen zu stoppen." #| dialog --gauge "Alle Simulatoren werden gestoppt!" 6 64 $BALKEN2
			#dialogclear
			sleep $STOPWARTEZEIT
		else
			log error "Regionen ${VERZEICHNISSLISTE[$i]}  laeuft nicht!"
		fi
	done
	return 0
}

## * autologdel
	# Diese Funktion löscht Log-Dateien für OpenSimulator-Regionen. Sie durchläuft alle Verzeichnisse in der Verzeichnisliste und löscht die Log-Dateien im Verzeichnis. 
	# Wenn eine Log-Datei nicht vorhanden ist, wird eine Warnung protokolliert. Nach dem Löschen der Regionen-Log-Dateien wird die Funktion rologdel aufgerufen, um Root-Log-Dateien zu löschen.
	#? Parameter: Keine
	#? Rückgabewert:
	#   - Kein expliziter Rückgabewert
	#? Verwendungsbeispiel:
	#   autologdel
##
function autologdel() {
	# Letzte Bearbeitung 01.10.2023
	log line
	makeverzeichnisliste
	sleep 1
	for ((i = 0; i < "$ANZAHLVERZEICHNISSLISTE"; i++)); do
		log info "OpenSimulator log Datei ${VERZEICHNISSLISTE[$i]} geloescht"
		rm /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/*.log 2>/dev/null || log warn "Die Log Datei ${VERZEICHNISSLISTE[$i]} ist nicht vorhanden!"		
		sleep 1
	done

	rologdel

	return 0
}

## * menuautologdel
	# Diese Funktion löscht Log-Dateien für OpenSimulator-Regionen. Sie durchläuft alle Verzeichnisse in der Verzeichnisliste und löscht die Log-Dateien im Verzeichnis. 
	# Nach dem Löschen der Regionen-Log-Dateien wird die Funktion rologdel aufgerufen, um Root-Log-Dateien zu löschen.
	#? Parameter: Keine
	#? Rückgabewert:
	#   - Kein expliziter Rückgabewert
	#? Verwendungsbeispiel:
	#   menuautologdel
##
function menuautologdel() {
	# Letzte Bearbeitung 01.10.2023
	log line
	makeverzeichnisliste
	sleep 1
	for ((i = 0; i < "$ANZAHLVERZEICHNISSLISTE"; i++)); do
		#BERECHNUNG3=$((100 / "$ANZAHLVERZEICHNISSLISTE"))
		#BALKEN3=$(("$i" * "$BERECHNUNG3"))
		rm /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/*.log #| log info "" # dialog --gauge "Auto Sim stop..." 6 64 $BALKEN3
		#dialogclear || return 0
		log info "OpenSimulator log ${VERZEICHNISSLISTE[$i]} geloescht"
		sleep 1
	done

	rologdel
}

## * automapdel
	# Diese Funktion löscht Kartenkacheln (maptiles) für OpenSimulator-Regionen. Sie durchläuft alle Verzeichnisse in der Verzeichnisliste und löscht den Inhalt des Verzeichnisses maptiles im Verzeichnis. 
	# Nach dem Löschen der Kartenkacheln für die Regionen wird die Funktion autorobustmapdel aufgerufen, um auch die Kartenkacheln für die Robust-Instanz zu löschen.
	#? Parameter: Keine
	#? Rückgabewert:
	#   - Kein expliziter Rückgabewert
	#? Verwendungsbeispiel:
	#   automapdel
##
function automapdel() {
	# Letzte Bearbeitung 01.10.2023
	autorobustmapdel
	makeverzeichnisliste
	sleep 1
	for ((i = 0; i < "$ANZAHLVERZEICHNISSLISTE"; i++)); do
		cd /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin || return 1
		rm -r maptiles/* || echo " "
		log warn "OpenSimulator maptile ${VERZEICHNISSLISTE[$i]} geloescht"
		sleep 1
	done
	# autorobustmapdel
	return 0
}

## * autorobustmapdel
	# Diese Funktion löscht die Kartenkacheln (maptiles) für die Robust-Instanz von OpenSimulator. 
	# Sie navigiert zum Verzeichnis der Robust-Instanz und löscht den Inhalt des Verzeichnisses "maptiles" im Verzeichnis.
	#? Parameter: Keine
	#? Rückgabewert:
	#   - Kein expliziter Rückgabewert
	#? Verwendungsbeispiel:
	#   autorobustmapdel
##
function autorobustmapdel() {
	# Letzte Bearbeitung 01.10.2023
	cd /$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS/bin || return 1
	rm -r maptiles/* || log line
	log warn "OpenSimulator maptile aus $ROBUSTVERZEICHNIS geloescht"
	return 0
}

## * cleaninstall
	# Diese Funktion löscht den Inhalt des Verzeichnisses addon-modules im OpenSimulator-Verzeichnis,
	# sofern dieses Verzeichnis existiert.
	#? Parameter: Keine
	#? Rückgabewert:
	#   - Kein expliziter Rückgabewert
	#? Verwendungsbeispiel:
	#   cleaninstall
##
function cleaninstall() {
	# Letzte Bearbeitung 01.10.2023

	if [ ! -f "/$STARTVERZEICHNIS/opensim/addon-modules/" ]; then
		rm -r $STARTVERZEICHNIS/opensim/addon-modules/*
	else
		log error "addon-modules Verzeichnis existiert nicht"
	fi
	return 0
}

## * cleanprebuild
	# Diese Funktion löscht bestimmte Dateien und Verzeichnisse im Verzeichnis addon-modules
	# im OpenSimulator-Verzeichnis, sofern dieses Verzeichnis existiert.
	#? Parameter: Keine
	#? Rückgabewert:
	#   - Kein expliziter Rückgabewert
	#? Verwendungsbeispiel:
	#   cleanprebuild
##
function cleanprebuild() {
	# Letzte Bearbeitung 01.10.2023
	# Die if schleife prueft nur ob das Verzeichnis vorhanden ist.
	if [ ! -f "/$STARTVERZEICHNIS/opensim/addon-modules/" ]; then
		# Verzeichnis wo geloescht werden soll.
		DIR="/$STARTVERZEICHNIS/opensim/addon-modules"
		# Dateien mit Endung csproj und user loeschen.
		find $DIR -name '*.csproj' -exec rm -rv {} \;
		find $DIR -name '*.csproj.user' -exec rm -rv {} \;
		# Verzeichnisse obj loeschen
		find $DIR -name 'obj' -exec rm -rv {} \;
	else
		log error "addon-modules Verzeichnis existiert nicht"
	fi
	return 0
}

## * allclean
	# Diese Funktion löscht bestimmte Dateien mit den angegebenen Erweiterungen in einem angegebenen Verzeichnis.
	#? Parameter:
	#   $1: Das Verzeichnis, in dem die Dateien gelöscht werden sollen.
	#? Rückgabewert:
	#   - Kein expliziter Rückgabewert
	#? Verwendungsbeispiel:
	#   allclean "/pfad/zum/verzeichnis"
##
function allclean() {
	# Letzte Bearbeitung 01.10.2023
	ALLCLEANVERZEICHNIS=$1

	if [ -d "$ALLCLEANVERZEICHNIS" ]; then
		rm /$STARTVERZEICHNIS/"$ALLCLEANVERZEICHNIS"/bin/*.log
		rm /$STARTVERZEICHNIS/"$ALLCLEANVERZEICHNIS"/bin/*.dll
		rm /$STARTVERZEICHNIS/"$ALLCLEANVERZEICHNIS"/bin/*.exe
		rm /$STARTVERZEICHNIS/"$ALLCLEANVERZEICHNIS"/bin/*.so
		rm /$STARTVERZEICHNIS/"$ALLCLEANVERZEICHNIS"/bin/*.xml
		rm /$STARTVERZEICHNIS/"$ALLCLEANVERZEICHNIS"/bin/*.dylib
		rm /$STARTVERZEICHNIS/"$ALLCLEANVERZEICHNIS"/bin/*.example
		rm /$STARTVERZEICHNIS/"$ALLCLEANVERZEICHNIS"/bin/*.sample
		rm /$STARTVERZEICHNIS/"$ALLCLEANVERZEICHNIS"/bin/*.txt
		rm /$STARTVERZEICHNIS/"$ALLCLEANVERZEICHNIS"/bin/*.config
		rm /$STARTVERZEICHNIS/"$ALLCLEANVERZEICHNIS"/bin/*.py
		rm /$STARTVERZEICHNIS/"$ALLCLEANVERZEICHNIS"/bin/*.old
		log warn "Dateien in $ALLCLEANVERZEICHNIS geloescht"
	else
		log error "Dateien in $ALLCLEANVERZEICHNIS nicht gefunden"
	fi
	return 0
}

## * getcachesinglegroesse
	# Diese Funktion zeigt die Größe der Cache-Dateien (assetcache, maptiles, ScriptEngines, MeshCache, j2kDecodeCache)
	# in einem angegebenen Verzeichnis an.
	#? Parameter:
	#   $1: Das Verzeichnis, in dem die Cache-Dateien angezeigt werden sollen.
	#? Rückgabewert:
	#   - Kein expliziter Rückgabewert
	#? Verwendungsbeispiel:
	#   getcachesinglegroesse "/pfad/zum/verzeichnis"
##
function getcachesinglegroesse() {
	# Letzte Bearbeitung 01.10.2023
	GROESSENVERZEICHNIS=$1

	log info "Zeigt Cache Dateien und die größe aus dem Simulator $GROESSENVERZEICHNIS an!"

	if [ -d "$GROESSENVERZEICHNIS" ]; then
	du -sh /$STARTVERZEICHNIS/"$GROESSENVERZEICHNIS"/bin/assetcache 2> /dev/null
	du -sh /$STARTVERZEICHNIS/"$GROESSENVERZEICHNIS"/bin/maptiles 2> /dev/null
	du -sh /$STARTVERZEICHNIS/"$GROESSENVERZEICHNIS"/bin/ScriptEngines 2> /dev/null
	du -sh /$STARTVERZEICHNIS/"$GROESSENVERZEICHNIS"/bin/MeshCache 2> /dev/null
	du -sh /$STARTVERZEICHNIS/"$GROESSENVERZEICHNIS"/bin/j2kDecodeCache 2> /dev/null
	else
		log error "Verzeichnisse in $GROESSENVERZEICHNIS nicht gefunden"
	fi
	return 0
}

## * getcachegroesse
	# Diese Funktion zeigt die Größe der Cache-Dateien (assetcache, maptiles, ScriptEngines, MeshCache, j2kDecodeCache)
	# in allen Simulatoren und im Robust Server-Verzeichnis an.
	#? Parameter:
	#   Keine Parameter erforderlich.
	#? Rückgabewert:
	#   - Kein expliziter Rückgabewert
	#? Verwendungsbeispiel:
	#   getcachegroesse
##
function getcachegroesse() {
	# Letzte Bearbeitung 01.10.2023
	log info "Zeige Cache Dateien und die größe aus dem gesamten Grid an!"
	makeverzeichnisliste
	#sleep 1

	# Simualtoren
	for ((i = 0; i < "$ANZAHLVERZEICHNISSLISTE"; i++)); do
	log info "${VERZEICHNISSLISTE[$i]}"
	du -sh /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/assetcache 2> /dev/null
	du -sh /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/maptiles 2> /dev/null
	du -sh /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/ScriptEngines 2> /dev/null
	du -sh /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/MeshCache 2> /dev/null
	du -sh /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/j2kDecodeCache 2> /dev/null
	done
	# Robust
	log info "Robust"
	du -sh /$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS/bin/maptiles 2> /dev/null
	du -sh /$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS/bin/bakes 2> /dev/null
	du -sh /$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS/bin/assetcache 2> /dev/null
	du -sh /$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS/bin/MeshCache 2> /dev/null
	du -sh /$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS/bin/j2kDecodeCache 2> /dev/null
	du -sh /$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS/bin/ScriptEngines 2> /dev/null
}

## * tastaturcachedelete
	# Diese Funktion löscht die lokale Befehlshistorie in der aktuellen Shell-Sitzung, wodurch alle zuvor eingegebenen Befehle gelöscht werden.
	#? Parameter:
	#   Keine Parameter erforderlich.
	#? Rückgabewert:
	#   - Kein expliziter Rückgabewert
	#? Verwendungsbeispiel:
	#   tastaturcachedelete
##
function tastaturcachedelete() {
	# Letzte Bearbeitung 01.10.2023
	history -cw
}

## * gridcachedelete
	# Diese Funktion löscht bestimmte Cache-Verzeichnisse aus dem Grid, basierend auf den festgelegten Konfigurationen.
	#? Parameter:
	#   Keine Parameter erforderlich.
	#? Rückgabewert:
	#   - Kein expliziter Rückgabewert
	#? Verwendungsbeispiel:
	#   gridcachedelete
##
function gridcachedelete() {
	# Letzte Bearbeitung 01.10.2023
	log line
	log warn "Lösche Cache Dateien aus dem gesamten Grid!"
	makeverzeichnisliste
	sleep 1
	# Simualtoren
	for ((i = 0; i < "$ANZAHLVERZEICHNISSLISTE"; i++)); do	
	if [ "$ASSETCACHECLEAR" = "yes" ]; then  rm -r /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/assetcache || echo " "; fi
	if [ "$MAPTILESCLEAR" = "yes" ]; then  rm -r /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/maptiles || echo " "; fi
	if [ "$SCRIPTCLEAR" = "yes" ]; then  rm -r /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/ScriptEngines || echo " "; fi
	done
	# Robust
	if [ "$RMAPTILESCLEAR" = "yes" ]; then  rm -r /$STARTVERZEICHNIS/robust/bin/maptiles || echo " "; fi
	# Ist das Verzeichnis vorhanden dann erst löschen.
	if [ ! -d "/$STARTVERZEICHNIS/robust/bin/bakes" ]; then
		if [ "$RBAKESCLEAR" = "yes" ]; then  rm -r /$STARTVERZEICHNIS/robust/bin/bakes || echo " "; fi
	fi
}

## * autoallclean.
	# loescht Log, dll, so, exe, aot Dateien fuer einen saubere neue installation, mit Robust.
	# Hierbei werden keine Datenbanken oder Konfigurationen geloescht aber opensim ist anschliessend nicht mehr startbereit.
	# Um opensim wieder Funktionsbereit zu machen muss ein Upgrade oder ein oscopy vorgang ausgefuehrt werden.
	#? @param keine.
	#? @return nichts wird zurueckgegeben.
	# todo: nichts.
##
function autoallclean() {
	# Letzte Bearbeitung 01.10.2023
	makeverzeichnisliste
	sleep 1
	for ((i = 0; i < "$ANZAHLVERZEICHNISSLISTE"; i++)); do
		# Dateien
		rm /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/*.log
		rm /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/*.dll
		rm /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/*.exe
		rm /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/*.so
		rm /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/*.xml
		rm /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/*.dylib
		rm /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/*.example
		rm /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/*.sample
		rm /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/*.txt
		rm /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/*.config
		rm /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/*.py
		rm /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/*.old
		rm /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/*.pdb

		# Verzeichnisse leeren
		rm -r /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/assetcache/*
		rm -r /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/maptiles/*
		rm -r /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/MeshCache/*
		rm -r /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/j2kDecodeCache/*
		rm -r /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/ScriptEngines/*

		if [[ $AUTOCLEANALL = "yes" ]]; then
			rm -r /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/addin-db-002/*
			rm -r /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/addon-modules/*
			rm -r /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/assets/*
			rm -r /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/bakes/*
			rm -r /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/data/*
			rm -r /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/Estates/*
			rm -r /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/inventory/*
			rm -r /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/lib/*
			rm -r /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/lib32/*
			rm -r /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/lib64/*
			rm -r /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/Library/*
			rm -r /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/openmetaverse_data/*
			rm -r /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/robust-include/*
		fi

		log warn "autoallclean: ${VERZEICHNISSLISTE[$i]} geloescht"
		sleep 1
	done
	# nochmal das gleiche mit Robust
	log warn "autoallclean: $ROBUSTVERZEICHNIS geloescht"
	rm /$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS/bin/*.log
	rm /$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS/bin/*.dll
	rm /$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS/bin/*.exe
	rm /$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS/bin/*.so
	rm /$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS/bin/*.xml
	rm /$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS/bin/*.dylib
	rm /$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS/bin/*.example
	rm /$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS/bin/*.sample
	rm /$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS/bin/*.txt
	rm /$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS/bin/*.config
	rm /$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS/bin/*.py
	rm /$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS/bin/*.old
	rm /$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS/bin/*.pdb

	rm -r /$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS/bin/assetcache/*
	rm -r /$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS/bin/maptiles/*
	rm -r /$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS/bin/MeshCache/*
	rm -r /$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS/bin/j2kDecodeCache/*
	rm -r /$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS/bin/ScriptEngines/*

	if [[ $AUTOCLEANALL = "yes" ]]; then
	rm -r /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/addin-db-002/*
	rm -r /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/addon-modules/*
	rm -r /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/assets/*
	rm -r /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/bakes/*
	rm -r /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/data/*
	rm -r /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/Estates/*
	rm -r /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/inventory/*
	rm -r /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/lib/*
	rm -r /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/lib32/*
	rm -r /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/lib64/*
	rm -r /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/Library/*
	rm -r /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/openmetaverse_data/*
	rm -r /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/robust-include/*
	fi

	return 0
}

## * autoregionbackup
	# Diese Funktion durchläuft die Regionen in Ihrem OpenSimulator-Grid und erstellt automatische Backups.
	#? Parameter:
	#   Keine Parameter erforderlich.
	#? Rückgabewert:
	#   - Kein expliziter Rückgabewert
	#? Verwendungsbeispiel:
	#   autoregionbackup
	# todo: Uebergabe Parameter Fehler. Bug Modus mit extra ausgaben. Ist keine osmregionlist.ini vorhanden muss sie erstellt werden.
##
function autoregionbackup() {
	# Letzte Bearbeitung 01.10.2023
	log info "Automatisches Backup wird gestartet."

    # Ist die osmregionlist.ini vorhanden?
    if [ ! -f "/$STARTVERZEICHNIS/osmregionlist.ini" ]; then
        log rohtext "Die osmregionlist.ini Datei ist noch nicht vorhanden und wird erstellt."
		regionliste
    else
        log rohtext "Die osmregionlist.ini Datei ist bereits vorhanden."
    fi

	makeregionsliste
	sleep 1
	for ((i = 0; i < "$ANZAHLREGIONSLISTE"; i++)); do
		BACKUPSCREEN=$(echo "${REGIONSLISTE[$i]}" | cut -d ' ' -f 1)
		BACKUPREGION=$(echo "${REGIONSLISTE[$i]}" | cut -d ' ' -f 2)
		log rohtext "Sende: " "$BACKUPSCREEN" "$BACKUPREGION" # Testausgabe
		regionbackup "$BACKUPSCREEN" "$BACKUPREGION"
		if [ -f /$STARTVERZEICHNIS/"$BACKUPSCREEN"/bin/Regions/"$BACKUPREGION".ini.offline ]; then
			log rohtext "$BACKUPREGION Region ist Offline und wird uebersprungen."
		else
			sleep $BACKUPWARTEZEIT
			log rohtext "BACKUPWARTEZEIT $BACKUPWARTEZEIT Sekunden." # Testausgabe
		fi
	done
	return 0
}

## * autoscreenstop
	# Diese Funktion stoppt die Screens für Simulatoren, Money Server und Robust Server, wenn sie ausgeführt werden.
	#? Parameter:
	#   Keine Parameter erforderlich.
	#? Rückgabewert:
	#   - Kein expliziter Rückgabewert
	#? Verwendungsbeispiel:
	#   autoscreenstop
##
function autoscreenstop() {
	# Letzte Bearbeitung 01.10.2023
	makeverzeichnisliste
	sleep 1

	# shellcheck disable=SC2022
	if ! screen -list | grep -q 'sim'; then
		log info "SIMs sind bereits OFFLINE!"
	else
		for ((i = 0; i < "$ANZAHLVERZEICHNISSLISTE"; i++)); do
			screen -S "${VERZEICHNISSLISTE[$i]}" -X quit || echo " "
		done
	fi

	if ! screen -list | grep -q "MO"; then
		log info "MONEY Server ist bereits OFFLINE!"
	else
		screen -S MO -X quit || echo " "
	fi

	if ! screen -list | grep -q "RO"; then
		log info "ROBUST Server ist bereits OFFLINE!"
	else
		screen -S RO -X quit || echo " "
	fi
	return 0
}

## * menuautoscreenstop
	# Diese Funktion zeigt ein Menü an, das es dem Benutzer ermöglicht, Screens für Simulatoren, Money Server und Robust Server zu stoppen.
	#? Parameter:
	#   Keine Parameter erforderlich.
	#? Rückgabewert:
	#   - Kein expliziter Rückgabewert
	#? Verwendungsbeispiel:
	#   menuautoscreenstop
##
function menuautoscreenstop() {
	# Letzte Bearbeitung 01.10.2023
	makeverzeichnisliste
	sleep 1

	# shellcheck disable=SC2022
	if ! screen -list | grep -q 'sim'; then
		log info "SIMs sind bereits OFFLINE!"
	else
		for ((i = 0; i < "$ANZAHLVERZEICHNISSLISTE"; i++)); do
			screen -S "${VERZEICHNISSLISTE[$i]}" -X quit
		done
	fi

	if ! screen -list | grep -q "MO"; then
		log info "MONEY Server ist bereits OFFLINE!"
	else
		screen -S MO -X quit
	fi

	if ! screen -list | grep -q "RO"; then
		log info "ROBUST Server ist bereits OFFLINE!"
	else
		screen -S RO -X quit
	fi
	return 0
}

## * autostart
	# Diese Funktion startet das Grid, indem sie zuerst den Robust Server und dann die Simulatoren startet.
	#? Parameter:
	#   Keine Parameter erforderlich.
	#? Rückgabewert:
	#   - Kein expliziter Rückgabewert
	#? Verwendungsbeispiel:
	#   autostart
##
function autostart() {
	# Letzte Bearbeitung 01.10.2023
	#log line
	#log info "Starte das Grid!"
	if [[ $ROBUSTVERZEICHNIS == "robust" ]]; then
		gridstart
	fi
	autosimstart
	log line
	screenlist
	log line
	log info "Auto Start abgeschlossen"
	return 0
}

## * gridstop
	# This function stops the Money Server (MO) and the Robust Server (RO) if they are running.
	# Parameters:
	#   None
	# Return:
	#   - No explicit return value
	# Example usage:
	#   gridstop
##  
function gridstop() {
	# Letzte Bearbeitung 01.10.2023
	if screen -list | grep -q MO; then
		mostop
	fi

	if screen -list | grep -q RO; then
		rostop
	fi
	return 0
}

## * autostop
	# This function attempts to gracefully stop the OpenSimulator regions (SIMs), the Robust Server (RO),
	# and any other related components. It first tries to stop the SIMs and the RO, and if they don't stop
	# within a specified time (AUTOSTOPZEIT), it forcibly stops them.
	# Parameters:
	#   None
	# Return:
	#   - No explicit return value
	# Example usage:
	#   autostop
##
function autostop() {
	# Letzte Bearbeitung 01.10.2023
	log warn "*** Stoppe das Grid! ***"
	# schauen ob screens laufen wenn ja beenden.
	# shellcheck disable=SC2022
	if ! screen -list | grep -q 'sim'; then
		log info "SIMs OFFLINE!"
	else
		autosimstop
	fi

	if ! screen -list | grep -q "RO"; then
		log info "ROBUST OFFLINE!"
	else
		gridstop
	fi
	# schauen ob screens laufen wenn ja warten.
	# shellcheck disable=SC2022
	if ! screen -list | grep -q 'sim'; then
		log line
	else
		sleep $AUTOSTOPZEIT
	fi
	log info "Alle noch offenen OpenSimulator bestandteile,"
	log info "die nicht innerhalb von $AUTOSTOPZEIT Sekunden"
	log info "nach Robust heruntergefahren werden konnten,"
	log info "werden jetzt zwangsbeendet!"
	autoscreenstop
	return 0
}

## * menuautostart
	# This function provides a menu for starting components of the OpenSimulator grid,
	# including the Robust Server (if configured) and the SIMs (regions).
	# Parameters:
	#   None
	# Return:
	#   - No explicit return value
	# Example usage:
	#   menuautostart
##
function menuautostart() {
	# Letzte Bearbeitung 01.10.2023
	echo ""
	if [[ $ROBUSTVERZEICHNIS == "robust" ]]; then
		log info "Bitte warten..."
		menugridstart
	fi
	menuautosimstart
	#screenlist
	log info "Auto Start abgeschlossen!"
	return 0
}

## *  menuautostop
	# Diese Funktion wird aufgerufen, um das Grid zu stoppen.
	#? Parameter: Keine
	#? Rückgabewert: Keiner
	# Funktionsweise:
	# 1. Loggt eine Warnmeldung, um den Beginn des Stoppprozesses anzukündigen.
	# 2. Überprüft, ob Screens mit dem Namen 'sim' laufen. Wenn ja, ruft die Funktion 'menuautosimstop' auf, um sie zu beenden.
	# 3. Überprüft, ob Screens mit dem Namen 'RO' laufen. Wenn ja, ruft die Funktion 'menugridstop' auf, um sie zu beenden.
	# 4. Überprüft erneut, ob Screens mit dem Namen 'sim' laufen. Wenn ja, wartet für die angegebene Zeit (AUTOSTOPZEIT) und beendet dann alle Screens.
	# 5. Ruft die Funktion 'menuautoscreenstop' auf, um weitere Screens zu beenden.
	# 6. Ruft die Funktion 'hauptmenu' auf, um zum Hauptmenü zurückzukehren.
	#? Hinweise:
	# - Diese Funktion geht davon aus, dass die Funktionen 'menuautosimstop', 'menugridstop', 'menuautoscreenstop' und 'hauptmenu' in Ihrem Code definiert sind.
	# - Die Verwendung von log-Meldungen dient der Protokollierung und ermöglicht es, den Fortschritt des Stoppprozesses nachzuvollziehen.
	#? Beispielaufruf:
	# menuautostop
##
function menuautostop() {
	# Letzte Bearbeitung 01.10.2023
	log warn "#** Stoppe das Grid! **#"
	# schauen ob screens laufen wenn ja beenden.
	if screen -list | grep -q 'sim'; then log info "Bitte warten..."; menuautosimstop; fi
	if screen -list | grep -q "RO"; then log info "Bitte warten..."; menugridstop; fi
	# schauen ob screens laufen wenn ja warten.
	if screen -list | grep -q 'sim'; then log info "Bitte warten..."; sleep $AUTOSTOPZEIT; killall screen; fi

	menuautoscreenstop
	hauptmenu
}

## *  autorestart
	# Diese Funktion führt einen automatischen Neustart des Systems durch.
	#? Parameter: Keine
	#? Rückgabewert: Gibt immer den Wert 0 zurück.
	# Funktionsweise:
	# 1. Protokolliert eine Nachricht, um den Beginn des automatischen Neustarts anzukündigen.
	# 2. Ruft die Funktion 'autostop' auf, um alle aktiven Prozesse zu stoppen.
	# 3. Überprüft, ob das Löschen von Log-Dateien (LOGDELETE) aktiviert ist und ruft gegebenenfalls 'autologdel' auf, um Log-Dateien zu löschen.
	# 4. (Auskommentiert) Überprüft, ob das Löschen von Regionen (DELREGIONS) aktiviert ist und ruft gegebenenfalls 'deleteregionfromdatabase' auf, um Regionen aus der Datenbank zu löschen.
	# 5. Ruft 'gridstart' auf, um das Grid neu zu starten.
	# 6. Ruft 'autosimstart' auf, um Simulationen automatisch neu zu starten.
	# 7. Ruft 'screenlistrestart' auf, um die Screenliste neu zu starten.
	# 8. Protokolliert eine Nachricht, um den erfolgreichen Abschluss des automatischen Neustarts anzuzeigen.
	# 9. Gibt den Wert 0 zurück, um den erfolgreichen Abschluss anzuzeigen.
	#? Hinweise:
	# - Diese Funktion geht davon aus, dass die in den Kommentaren erwähnten Funktionen ('autostop', 'autologdel', 'deleteregionfromdatabase', 'gridstart', 'autosimstart' und 'screenlistrestart') in Ihrem Code definiert sind.
	#? Beispielaufruf:
	# autorestart
##
function autorestart() {
	# Letzte Bearbeitung 01.10.2023
	log rohtext " Automatischer Restart wird ausgeführt!"
	log line
	
	# Alles stoppen.
	autostop
	if [ "$LOGDELETE" = "yes" ]; then autologdel; fi
	#if [ "$DELREGIONS" = "yes" ]; then deleteregionfromdatabase; fi

	gridstart
	autosimstart
	screenlistrestart

	log info "Auto Restart abgeschlossen."
	return 0
}

## *  menuautorestart
	# Diese Funktion führt einen automatischen Neustart des Systems aus dem Menü heraus durch.
	#? Parameter: Keine
	#? Rückgabewert: Keiner
	# Funktionsweise:
	# 1. Protokolliert eine Nachricht, um den Beginn des automatischen Neustarts anzukündigen.
	# 2. Ruft die Funktion 'autostop' auf, um alle aktiven Prozesse zu stoppen.
	# 3. Überprüft, ob das Löschen von Log-Dateien (LOGDELETE) aktiviert ist und ruft gegebenenfalls 'autologdel' auf, um Log-Dateien zu löschen.
	# 4. (Auskommentiert) Überprüft, ob das Löschen von Regionen (DELREGIONS) aktiviert ist und ruft gegebenenfalls 'deleteregionfromdatabase' auf, um Regionen aus der Datenbank zu löschen.
	# 5. Ruft 'gridstart' auf, um das Grid neu zu starten.
	# 6. Ruft 'autosimstart' auf, um Simulationen automatisch neu zu starten.
	# 7. Ruft 'screenlistrestart' auf, um die Screenliste neu zu starten.
	# 8. Ruft die Funktion 'menuinfo' auf, um Informationen über den automatischen Neustart im Menü anzuzeigen.
	#? Hinweise:
	# - Diese Funktion geht davon aus, dass die in den Kommentaren erwähnten Funktionen ('autostop', 'autologdel', 'deleteregionfromdatabase', 'gridstart', 'autosimstart' und 'screenlistrestart') in Ihrem Code definiert sind.
	#? Beispielaufruf:
	# menuautorestart
##
function menuautorestart() {
	# Letzte Bearbeitung 01.10.2023
	log rohtext " Automatischer Restart wird ausgeführt!"
	autostop
	if [ "$LOGDELETE" = "yes" ]; then autologdel; fi
	#if [ "$DELREGIONS" = "yes" ]; then deleteregionfromdatabase; fi
	gridstart
	autosimstart
	screenlistrestart

	# log info "Auto Restart abgeschlossen."
	menuinfo
}

## *  serverupgrade
	# Diese Funktion führt ein Systemupgrade auf einem Linux-Server durch.
	#? Parameter: Keine
	#? Rückgabewert: Keiner
	# Funktionsweise:
	# 1. Führt 'sudo apt-get update' aus, um die Paketlisten zu aktualisieren und Informationen über verfügbare Updates abzurufen.
	# 2. Führt 'sudo apt-get upgrade' aus, um alle verfügbaren Paketaktualisierungen auf dem System zu installieren.
	#? Hinweise:
	# - Diese Funktion erfordert Root-Berechtigungen, da die Aktualisierung von Paketen in der Regel Root-Rechte erfordert.
	# - Stellen Sie sicher, dass Ihr Server über eine Internetverbindung verfügt, um die Aktualisierung durchzuführen.
	#? Beispielaufruf:
	# serverupgrade
##
function serverupgrade() {
	# Letzte Bearbeitung 01.10.2023
	sudo apt-get update
	sudo apt-get upgrade
}

## * installmariadb18
	# Diese Funktion führt die Installation oder Migration von MariaDB auf einem Ubuntu 18-System durch.
	# Nach Abschluss des Vorgangs werden Sie aufgefordert, alle erforderlichen Dienste neu zu starten, um sicherzustellen,
	# dass die Änderungen wirksam werden.
	#? Parameter:
	#   Keine.
	#? Rückgabewert:
	#   Keiner (void).
	# Todos:
	#   Keine.
##
function installmariadb18() {
	# Letzte Bearbeitung 01.10.2023

	log info "Installation oder Migration von MariaDB 10.8.3 oder hoeher fuer Ubuntu 18"
	log info "Nach der Installation werden Fehler in den OpenSim log Dateien angezeigt bitte dann alles neustarten!"
	# MySQL stoppen:
	sudo service mysql stop

	sudo apt-get install apt-transport-https curl
	sudo curl -o /etc/apt/trusted.gpg.d/mariadb_release_signing_key.asc 'https://mariadb.org/mariadb_release_signing_key.asc'
	sudo sh -c "echo 'deb https://mirror.kumi.systems/mariadb/repo/10.8/ubuntu bionic main' >>/etc/apt/sources.list"

	# MariaDB installieren:
	sudo apt-get update
	sudo apt-get -y install mariadb-server

	mariadb --version
}

## * installmariadb22
	# Diese Funktion führt die Installation von MariaDB auf einem Ubuntu 22-System durch.
	# Falls der MySQL-Dienst bereits läuft, wird er zuerst gestoppt, um Konflikte zu vermeiden.
	#? Parameter:
	#   Keine.
	#? Rückgabewert:
	#   Keiner (void).
	# Todos:
	#   Keine.
##
function installmariadb22() {
	# Letzte Bearbeitung 01.10.2023
	# MySQL stoppen wenn es laeuft:
	sudo service mysql stop

	# MariaDB installieren:
	sudo apt-get update
	sudo apt-get -y install mariadb-server

	mariadb --version
}

## * monoinstall
	# Diese Funktion überprüft, ob Mono bereits auf dem System installiert ist. Wenn nicht, installiert sie Mono 6.x auf einem Ubuntu 18-System.
	#? Parameter:
	#   Keine.
	#? Rückgabewert:
	#   0 - Erfolgreiche Ausführung der Funktion.
	# Todos:
	#   Keine.
##
function monoinstall() {
	# Letzte Bearbeitung 01.10.2023
	if dpkg-query -s mono-complete 2>/dev/null | grep -q installed; then
		log info "mono-complete ist installiert."
	else
		log info "mono-complete ist nicht installiert."
		log info "Installation von mono 6.x fuer Ubuntu 18"

		sleep 1

		sudo apt install gnupg ca-certificates
		sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
		echo "deb https://download.mono-project.com/repo/ubuntu stable-bionic main" | sudo tee /etc/apt/sources.list.d/mono-official-stable.list
		sudo apt update
		sudo apt-get -y install mono-complete
		sudo apt-get upgrade
	fi
	return 0
}

## * monoinstall18
	# Diese Funktion überprüft, ob Mono (mono-complete) bereits auf dem System installiert ist. 
	# Wenn nicht, wird Mono 6.x auf einem Ubuntu 18-System installiert.
	#? Parameter:
	#   Keine.
	#? Rückgabewert:
	#   Keiner (void).
	# Todos:
	#   Keine.
##
function monoinstall18() {
	# Letzte Bearbeitung 01.10.2023
	if dpkg-query -s mono-complete 2>/dev/null | grep -q installed; then
		log rohtext "mono-complete ist bereits installiert."
	else
		log rohtext "Ich installiere jetzt mono-complete"
		sleep 1

		sudo apt install gnupg ca-certificates
		sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
		echo "deb https://download.mono-project.com/repo/ubuntu stable-bionic main" | sudo tee /etc/apt/sources.list.d/mono-official-stable.list

		sudo apt update
		sudo apt-get -y install mono-complete
		sudo apt-get upgrade
	fi
}

## * monoinstall20
	# Diese Funktion überprüft, ob Mono (mono-complete) bereits auf dem System installiert ist. 
	# Wenn nicht, wird Mono 6.x auf einem Ubuntu 20-System installiert.
	#? Parameter:
	#   Keine.
	#? Rückgabewert:
	#   Keiner (void).
	# Todos:
	#   Keine.
##
function monoinstall20() {
	# Letzte Bearbeitung 01.10.2023
	if dpkg-query -s mono-complete 2>/dev/null | grep -q installed; then
		log rohtext "mono-complete ist bereits installiert."
	else
		log rohtext "Ich installiere jetzt mono-complete"
		sleep 1

		sudo apt install gnupg ca-certificates
		sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
		echo "deb https://download.mono-project.com/repo/ubuntu stable-focal main" | sudo tee /etc/apt/sources.list.d/mono-official-stable.list

		sudo apt update
		sudo apt-get -y install mono-complete
		sudo apt-get upgrade
	fi
}

## * monoinstall22
	# Diese Funktion installiert Mono und zugehörige Pakete auf einem Ubuntu 22-System.
	#? Parameter:
	#   Keine.
	#? Rückgabewert:
	#   Keiner (void).
	# Todos:
	#   Keine.
##
function monoinstall22() {
	# Letzte Bearbeitung 01.10.2023
	sudo apt install mono-roslyn mono-complete mono-dbg mono-xbuild -y
}

## * icecastinstall
	# Diese Funktion führt die Installation und grundlegende Konfiguration von Icecast2 durch.
	# Sie generiert zufällige Passwörter für die Benutzer 'source', 'relay' und 'admin' und gibt diese aus.
	# Der Benutzer muss diese Passwörter für die Icecast2-Installation bereithalten.
	#? Parameter:
	#   Keine.
	#? Rückgabewert:
	#   Keiner (void).
	# Todos:
	#   Der Port für Icecast2 sollte noch konfiguriert werden, um sicherzustellen, dass er nicht mit anderen Diensten kollidiert.
##
function icecastinstall() {
	# Letzte Bearbeitung 01.10.2023
	passwortsource=$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 12)
	passwortrelay=$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 14)
	passwortadmin=$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 18)

	log rohtext "Bitte halten sie 3 Passwörter bereit für die icecast2 installation."
	log rohtext "Der hostname ist der Domainname oder die IP."
	log rohtext "Beispiele mit Zufallsgenerator erstellt:"
	log rohtext "Icecast2 Hostname: $AKTUELLEIP"
	log rohtext "Benutzername: source Passwort: $passwortsource"
	log rohtext "Benutzername: relay Passwort: $passwortrelay"
	log rohtext "Benutzername: admin Passwort: $passwortadmin"
	sudo apt-get install icecast2
	# Der Port muss noch von 8000, auf irgend etwas, was noch nicht vom OpenSimulator benutzt wird, umgestellt werden.
	icecastconfig
}

## * icecastconfig
	# Diese Funktion ändert die Konfiguration von Icecast2, um den Standardport von 8000 auf 8999 zu setzen.
	# Nach der Ausführung dieser Funktion sollte Icecast2 auf Port 8999 erreichbar sein.
	#? Parameter:
	#   Keine.
	#? Rückgabewert:
	#   Keiner (void).
	# Todos:
	#   Keine.
##
function icecastconfig() {
	# Letzte Bearbeitung 01.10.2023
	log rohtext "Icecast2 von Port 8000 auf Port 8999 setzen"
	sudo sed -i 's|8000|8999|' /etc/icecast2/icecast.xml
	log rohtext "Aufrufbeispiel: $AKTUELLEIP:8999"
}

## * sourcelist18
	# Diese Funktion gibt die Ubuntu 18.04 (Bionic Beaver) Paketquellen für APT aus.
	# Die Zeilen, die mit '#' beginnen, sind auskommentiert und können bei Bedarf aktiviert werden.
	#? Parameter:
	#   Keine.
	#? Rückgabewert:
	#   Keiner (void).
	# Todos:
	#   Keine.
##
function sourcelist18() {
	# Letzte Bearbeitung 01.10.2023
	echo "deb http://de.archive.ubuntu.com/ubuntu bionic main restricted universe multiverse"
	echo "#deb-src http://de.archive.ubuntu.com/ubuntu bionic main restricted universe multiverse"

	echo "deb http://de.archive.ubuntu.com/ubuntu bionic-updates main restricted universe multiverse"
	echo "#deb-src http://de.archive.ubuntu.com/ubuntu bionic-updates main restricted universe multiverse"

	echo "deb http://de.archive.ubuntu.com/ubuntu bionic-security main restricted universe multiverse"
	echo "#deb-src http://de.archive.ubuntu.com/ubuntu bionic-security main restricted universe multiverse"

	echo "deb http://de.archive.ubuntu.com/ubuntu bionic-backports main restricted universe multiverse"
	echo "#deb-src http://de.archive.ubuntu.com/ubuntu bionic-backports main restricted universe multiverse"

	echo "# deb http://archive.canonical.com/ubuntu bionic partner"
	echo "# deb-src http://archive.canonical.com/ubuntu bionic partner"
}

## * sourcelist22
	# Diese Funktion gibt die Ubuntu 22.04 (Jammy Jellyfish) Paketquellen für APT aus.
	# Die Zeilen, die mit '#' beginnen, sind auskommentiert und können bei Bedarf aktiviert werden.
	#? Parameter:
	#   Keine.
	#? Rückgabewert:
	#   Keiner (void).
	# Todos:
	#   Keine.
##
function sourcelist22() {
	# Letzte Bearbeitung 01.10.2023
	echo "deb http://de.archive.ubuntu.com/ubuntu jammy main restricted universe multiverse"
	echo "#deb-src http://de.archive.ubuntu.com/ubuntu impish main restricted universe multiverse"

	echo "deb http://de.archive.ubuntu.com/ubuntu jammy-updates main restricted universe multiverse"
	echo "#deb-src http://de.archive.ubuntu.com/ubuntu jammy-updates main restricted universe multiverse"

	echo "deb http://de.archive.ubuntu.com/ubuntu jammy-security main restricted universe multiverse"
	echo "#deb-src http://de.archive.ubuntu.com/ubuntu jammy-security main restricted universe multiverse"

	echo "deb http://de.archive.ubuntu.com/ubuntu jammy-backports main restricted universe multiverse"
	echo "#deb-src http://de.archive.ubuntu.com/ubuntu jammy-backports main restricted universe multiverse"

	echo "deb http://archive.canonical.com/ubuntu/ jammy partner"
	echo "deb-src http://archive.canonical.com/ubuntu/ jammy partner"
}

## * installwordpress
	# Diese Funktion führt die Installation von Paketen durch, die für die Installation und den Betrieb von WordPress benötigt werden.
	#? Parameter:
	#   Keine.
	#? Rückgabewert:
	#   Keiner (void).
	# Todos:
	#   Keine.
##
function installwordpress() {
	# Letzte Bearbeitung 01.10.2023
	#Installationen die fuer Wordpress benoetigt werden
	iinstall apache2
	iinstall ghostscript
	iinstall libapache2-mod-php
	iinstall mysql-server
	iinstall php
	iinstall php-bcmath
	iinstall php-curl
	iinstall php-imagick
	iinstall php-intl
	iinstall php-json
	iinstall php-mbstring
	iinstall php-mysql
	iinstall php-xml
	iinstall php-zip
}

## * installopensimulator
	# Diese Funktion führt die Installation von Paketen durch, die für die Installation und den Betrieb von OpenSimulator benötigt werden.
	#? Parameter:
	#   Keine.
	#? Rückgabewert:
	#   Keiner (void).
	# Todos:
	#   - Sicherheitseinstellungen für fail2ban konfigurieren.
##
function installopensimulator() {
	# Letzte Bearbeitung 01.10.2023
	#Alles fuer den OpenSimulator ausser mono
	iinstall apache2
	iinstall libapache2-mod-php
	iinstall php
	iinstall mysql-server
	iinstall php-mysql
	iinstall php-common
	iinstall php-gd
	iinstall php-pear
	iinstall php-xmlrpc
	iinstall php-curl
	iinstall php-mbstring
	iinstall php-gettext
	iinstall zip
	iinstall screen
	iinstall git
	iinstall nant
	iinstall libopenjp2-tools
	iinstall graphicsmagick
	iinstall imagemagick
	iinstall curl
	iinstall php-cli
	iinstall php-bcmath
	iinstall dialog
	iinstall at
	iinstall mysqltuner
	iinstall crudini
	# Sicherheit 2023
	iinstall iptables
	iinstall fail2ban	
	# fail2ban - In der Datei jail.local werden alle von der jail.conf abweichenden Einträge eingestellt.
	# maxfailures = 3 
	# bantime = 900 
	# findtime = 600
	iinstall apt-utils
    iinstall libgdiplus
	iinstall zlib1g-dev
    iinstall libc6-dev
	iinstall translate-shell

}

## * installubuntu22
	# Diese Funktion führt die Installation von Paketen durch, die für die Installation und den Betrieb von OpenSimulator auf einem Ubuntu 22.04-System benötigt werden.
	#? Parameter:
	#   Keine.
	#? Rückgabewert:
	#   Keiner (void).
	# Todos:
	#   - Sicherheitseinstellungen für fail2ban konfigurieren.
	#   - Optionale erweiterte Pakete installieren, wenn $insterweitert = "yes".
##
function installubuntu22() {
	# Letzte Bearbeitung 01.10.2023
	#Alles fuer den OpenSimulator ausser mono
	iinstallnew screen
	iinstallnew git
	iinstallnew nant
	iinstallnew libopenjp3d7
	iinstallnew graphicsmagick
	iinstallnew imagemagick
	iinstallnew curl
	iinstallnew php-cli
	iinstallnew php-bcmath
	iinstallnew dialog
	iinstallnew at
	iinstallnew mysqltuner
	iinstallnew php-mysql
	iinstallnew php-common
	iinstallnew php-gd
	iinstallnew php-pear
	iinstallnew php-xmlrpc
	iinstallnew php-curl
	iinstallnew php-mbstring
	iinstallnew php-gettext
	iinstallnew php-fpm php
	iinstallnew libapache2-mod-php
	iinstallnew php-xml
	iinstallnew php-imagick
	iinstallnew php-cli
	iinstallnew php-imap
	iinstallnew php-opcache
	iinstallnew php-soap
	iinstallnew php-zip
	iinstallnew php-intl
	iinstallnew php-bcmath
	iinstallnew unzip
	iinstallnew php-mail
	iinstallnew zip
	iinstallnew screen
	iinstallnew graphicsmagick
	iinstallnew git
	iinstallnew libopenjp3d7
	iinstallnew crudini
	iinstallnew iptables
	iinstallnew fail2ban
	iinstallnew apt-utils
    iinstallnew libgdiplus
	iinstallnew zlib1g-dev
    iinstallnew libc6-dev
	iinstallnew translate-shell

	if [ $insterweitert = "yes" ]; then
		iinstallnew libldns-dev
		iinstallnew libldns3
		iinstallnew libjs-jquery-ui
		iinstallnew libopenexr25
		iinstallnew libmagickcore-6.q16-6-extra
		iinstallnew libswscale-dev
		iinstallnew php-twig
		iinstallnew libavcodec58
		iinstallnew libmagickwand-6.q16-6
		iinstallnew libavutil56
		iinstallnew imagemagick-6.q16
		iinstallnew libswscale5
		iinstallnew libmagickcore-6.q16-6
		iinstallnew libavutil-dev
		iinstallnew libswresample3
		iinstallnew imagemagick-6-common
		iinstallnew libavformat58
		iinstallnew python2.7-minimal
		iinstallnew python2.7
		iinstallnew libavformat-dev
		iinstallnew libavcodec-dev
		iinstallnew libpython2.7-minimal
		iinstallnew libpython2.7-stdlib
		iinstallnew libswresample-dev
	fi
	deladvantagetools
}

## * iptablesset
	# Diese Funktion sperrt eine angegebene IP-Adresse sowohl für eingehende als auch für ausgehende Datenpakete in der iptables-Firewall.
	# Anschließend werden alle IP-Adressen zusammen mit den Zeilennummern angezeigt, die momentan in den iptables gesperrt sind.
	#? Parameter:
	#   $1 - Die IP-Adresse, die gesperrt werden soll.
	#? Rückgabewert:
	#   Keiner (void).
	# Todos:
	#   Keine.
##
function iptablesset() {
	# Letzte Bearbeitung 01.10.2023
	ipsperradresse=$1
	# Eine IP-Adresse für eingehende Datenpakete sperren
	iptables -A INPUT -s $ipsperradresse -j DROP

	# Eine IP-Adresse für ausgehende Datenpakete sperren
	iptables -A OUTPUT -s $ipsperradresse -j DROP

	# Alle IP-Adressen in den IPTABLES mitsamt Zeilennummern anzeigen, die momentan gesperrt sind
	iptables -L INPUT -n --line-numbers
}

## * fail2banset
	# Diese Funktion erstellt oder aktualisiert die Konfigurationseinstellungen für fail2ban in der jail.local-Datei.
	# Die Einstellungen beinhalten die Anzahl der zulässigen Fehlversuche (maxfailures), die Bannzeit in Sekunden (bantime)
	# und die Zeitspanne, innerhalb derer Fehlversuche gezählt werden (findtime).
	#? Parameter:
	#   Keine.
	#? Rückgabewert:
	#   Keiner (void).
	# Todos:
	#   Keine.
##
function fail2banset() {
	# Letzte Bearbeitung 01.10.2023
	echo ""
	# /etc/fail2ban/jail.local
	# fail2ban - In der Datei jail.local werden alle von der jail.conf abweichenden Eintraege eingestellt.
	# bantime = Sekunden
	# Hier nach 3 Fehlversuchen wird die IP 15 Minuten lang gebannt.
	# maxfailures = 3 
	# bantime = 900 
	# findtime = 600

	echo "maxfailures = 3 
bantime = 900 
findtime = 600" >/etc/fail2ban/jail.local
}

## * ufwset
	# Diese Funktion konfiguriert die UFW (Uncomplicated Firewall), um die erforderlichen Ports für den Betrieb von OpenSimulator zu öffnen.
	# Dazu gehören Ports für die Robust-, simX- und Money-Konfigurationen sowie weitere Ports, die von OpenSimulator benötigt werden.
	#? Parameter:
	#   Keine.
	#? Rückgabewert:
	#   Keiner (void).
	# Todos:
	#   Keine.
##
function ufwset() {
	# Letzte Bearbeitung 01.10.2023
	#** Uncomplicated Firewall
	#sudo ufw app list

	# Now we will enable Apache Full.
	sudo ufw allow OpenSSH
	sudo ufw allow 'Apache Full'
	sudo ufw enable

	# Tests
	#sudo ufw status
	# alles erlauben
	#sudo ufw default allow
	# alles verbieten
	#sudo ufw default deny

	
	# Öffnen Sie den Port (in diesem Beispiel SSH):
	# sudo ufw allow 22

	# Regeln können in einem nummerierten Format hinzugefügt werden:
	# sudo ufw insert 1 allow 80

	# Auf ähnliche Weise können Sie einen offenen Port schließen:
	# sudo ufw deny 22

	# Um eine Regel zu löschen, verwenden Sie delete:
	# sudo ufw delete deny 22

	#*************************************************

	#Nach robust Konfigurationen suchen und die eingestellten Ports mit ufw freischalten.
	# Ist im Vereichnis robust/bin irgendeine ini Datei wo etwas mit Port steht und nicht mit ; ausdokumentiert ist.

	#Nach simX Konfigurationen suchen und die eingestellten Ports mit ufw freischalten.
	# Ist im Vereichnis simX/bin irgendeine ini Datei wo etwas mit Port steht und nicht mit ; ausdokumentiert ist.

	#Nach Money Konfigurationen suchen und die eingestellten Ports mit ufw freischalten.

	# Alle gefundenen Ports in eine Variable schreiben und die doppelten Einträge entfernen.

	# Portnamen:
	# PublicPort
	# PrivatePort
	# SimulatorPort
	# port
	# ServerPort
	# MTP_SERVER_PORT
	# http_listener_port
	# http_listener_sslport
	# XmlRpcPort
	# InternalPort

	#******************************************************

	#** Nachfolgende Einstellungen sind nur, damit es irgendwie laeuft.
	# Port oeffnen robust
	sudo ufw allow 8000/tcp
	sudo ufw allow 8001/tcp
	sudo ufw allow 8002/tcp
	sudo ufw allow 8003/tcp
	sudo ufw allow 8004/tcp
	sudo ufw allow 8005/tcp
	sudo ufw allow 8006/tcp
	sudo ufw allow 8895/tcp

	# ohne udp keine Viewer kommunikation - Assets fehlen sonst.
	sudo ufw allow 8000/udp
	sudo ufw allow 8001/udp
	sudo ufw allow 8002/udp
	sudo ufw allow 8003/udp
	sudo ufw allow 8004/udp
	sudo ufw allow 8005/udp
	sudo ufw allow 8006/udp
	sudo ufw allow 8895/udp

	# Port oeffnen OpenSim
	# von 9000 bis 9250 oeffnen - zu viel ich weiss
	sudo ufw allow 9000:9250/tcp	
	sudo ufw allow 9000:9250/udp
	# MTP_SERVER_PORT
	sudo ufw allow 25/tcp	
	sudo ufw allow 25/udp

	# XmlRpcPort = 20800 bis 20999 oeffnen - zu viel ich weiss
	sudo ufw allow 20800:20999/tcp
	sudo ufw allow 20800:20999/udp

	# Money Ports ?
	sudo ufw allow 3306/tcp
	sudo ufw allow 3306/udp
	sudo ufw allow 8008/tcp
	sudo ufw allow 8008/udp

}

## * ufwport
	# Diese Funktion öffnet einen angegebenen TCP- und UDP-Port in der Uncomplicated Firewall (UFW).
	#? Parameter:
	#   $1 - Der Port, der geöffnet werden soll.
	#? Rückgabewert:
	#   Keiner (void).
	# Todos:
	#   Keine.
##
function ufwport() {
	# Letzte Bearbeitung 01.10.2023
	PORTLOCK=$1
	sudo ufw allow $PORTLOCK/tcp
	sudo ufw allow $PORTLOCK/udp
}

## * ufwoff
	# Diese Funktion deaktiviert die Uncomplicated Firewall (UFW), wodurch alle Firewall-Regeln vorübergehend deaktiviert werden.
	#? Parameter:
	#   Keine.
	#? Rückgabewert:
	#   Keiner (void).
	# Todos:
	#   Keine.
##
function ufwoff() {
	# Letzte Bearbeitung 01.10.2023
	sudo ufw disable
}

## * ufwblock
	# Diese Funktion setzt die Standardaktion der Uncomplicated Firewall (UFW) auf "deny", wodurch alle eingehenden und ausgehenden Verbindungen standardmäßig blockiert werden.
	#? Parameter:
	#   Keine.
	#? Rückgabewert:
	#   Keiner (void).
	# Todos:
	#   Keine.
##
function ufwblock() {
	# Letzte Bearbeitung 01.10.2023
	sudo ufw default deny
}

## * installphpmyadmin
	# Diese Funktion installiert das PhpMyAdmin-Tool auf dem System, das eine webbasierte Benutzeroberfläche für die Verwaltung von MySQL-Datenbanken bietet.
	#? Parameter:
	#   Keine.
	#? Rückgabewert:
	#   Keiner (void).
	# Todos:
	#   Keine.
##
function installphpmyadmin() {
	# Letzte Bearbeitung 01.10.2023
	#** Installieren von PhpMyAdmin
	sudo apt install phpmyadmin
}

## * installfinish
	# Diese Funktion führt abschließende Aktualisierungen und Wartungsarbeiten auf dem System durch, um sicherzustellen, dass alle
	# Pakete auf dem neuesten Stand sind und eventuelle Abhängigkeiten aufgelöst werden. Sie beinhaltet auch einen Neustart des Systems.
	#? Parameter:
	#   Keine.
	#? Rückgabewert:
	#   Keiner (void).
	# Todos:
	#   Keine.
##
function installfinish() {
	# Letzte Bearbeitung 01.10.2023
	# Führt ein Systemupdate durch
	apt update
	# Führt ein Systemupgrade durch
	apt upgrade
	# Behebt eventuelle Paketabhängigkeitsprobleme
	apt -f install
	# zuerst schauen das nichts mehr laeuft bevor man einfach rebootet
	#reboot now
}

## * installationhttps22
	# Diese Funktion installiert die erforderlichen Pakete, um HTTPS (SSL/TLS-Zertifikate) für eine angegebene Domain unter Ubuntu 22.04
	# mithilfe von Certbot von Let’s Encrypt zu konfigurieren. Sie erfordert die Angabe einer E-Mail-Adresse und der Domain, für die das
	# Zertifikat ausgestellt werden soll.
	#? Parameter:
	#   $1 - Die E-Mail-Adresse für Let’s Encrypt-Zertifikatsbenachrichtigungen.
	#   $2 - Die Domain, für die das SSL/TLS-Zertifikat ausgestellt werden soll.
	#? Rückgabewert:
	#   Keiner (void).
	# Todos:
	#   Keine.
##
function installationhttps22() {
	# Letzte Bearbeitung 01.10.2023
	httpsemail=$1
	httpsdomain=$2
	#** HTTPS installieren
	sudo apt install python3-certbot-apache

	# Jetzt haben wir Certbot von Let’s Encrypt fuer Ubuntu 22.04 installiert,
	# fuehren Sie diesen Befehl aus, um Ihre Zertifikate zu erhalten.
	sudo certbot --apache --agree-tos --redirect -m "$httpsemail" -d "$httpsdomain" -d www."$httpsdomain"
}

## * serverinstall22
	# Diese Funktion führt eine umfassende Serverinstallation unter Ubuntu 22.04 durch, indem sie verschiedene Schritte ausführt,
	# darunter das Aktualisieren des Systems, die Installation von Softwarepaketen, die Konfiguration von Firewalls und die Einrichtung
	# von HTTPS (SSL/TLS-Zertifikaten) für eine Domain.
	#? Parameter:
	#   Keine.
	#? Rückgabewert:
	#   Keiner (void).
	# Todos:
	#   Die Einrichtung von HTTPS (SSL/TLS-Zertifikaten) ist auskommentiert und kann bei Bedarf aktiviert werden.
##
function serverinstall22() {
	# Letzte Bearbeitung 01.10.2023
	linuxupgrade
	installubuntu22
	monoinstall20 # 22 gibt es nicht.
	monoinstall22 # Upgrade monoistall20
	installmariadb22
	installphpmyadmin
	ufwset
	#installationhttps22
	installfinish
}

## *  serverinstall
	# 
	#? Beschreibung:
	# Diese Funktion überprüft, ob das Paket 'dialog' auf dem System installiert ist, um eine interaktive Installation zu ermöglichen.
	# Wenn 'dialog' installiert ist, wird der Benutzer gefragt, ob er alle erforderlichen Ubuntu-Pakete installieren möchte. 
	# Falls ja, werden verschiedene Installationsfunktionen aufgerufen, andernfalls wird zum Hauptmenü zurückgekehrt.
	# Wenn 'dialog' nicht installiert ist, wird der Benutzer einfach nach der Installation der Ubuntu-Pakete gefragt, ohne eine grafische Oberfläche zu verwenden.
	#? Parameter:
	# Diese Funktion erwartet keine Parameter.
	#? Rückgabewert:
	# Diese Funktion gibt keinen expliziten Rückgabewert zurück.
	#? Abhängigkeiten:
	# - Die Funktion verwendet die Befehle 'dpkg-query', 'dialog', 'dialogclear', 'serverupgrade', 'installopensimulator', 'monoinstall18', 'installfinish', 'log', 'ScreenLog' und 'hauptmenu'.
	#? Beispielaufruf:
	# serverinstall
##
function serverinstall() {
	# Letzte Bearbeitung 01.10.2023
	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then
		dialog --yesno "Moechten Sie wirklich alle noetigen Ubuntu Pakete installieren?" 0 0
		# 0=ja; 1=nein
		siantwort=$?
		# Dialog-Bildschirm loeschen
		dialogclear
		# Ausgabe auf die Konsole
		if [ $siantwort = 0 ]; then
			serverupgrade
			installopensimulator
			monoinstall18
			installfinish
		fi
		if [ $siantwort = 1 ]; then
			# Nein, dann zurueck zum Hauptmenu.
			hauptmenu
		fi
		# Bildschirm loeschen
		ScreenLog
	else
		# ohne dialog erstmal einfach installieren - Test
		read -r -p "Ubuntu Pakete installieren [y]es: " yesno
		if [ "$yesno" = "y" ]; then
			serverupgrade
			installopensimulator
			monoinstall18
			installfinish
		else
			log rohtext "Abbruch"
		fi
	fi
	# dialog Aktionen Ende
}

## *  installationen
	# 
	#? Beschreibung:
	# Diese Funktion listet alle unter Linux installierten Pakete auf und speichert die Liste in einer Log-Datei.
	#? Parameter:
	# Diese Funktion erwartet keine Parameter.
	#? Rückgabewert:
	# Diese Funktion gibt immer den Wert 0 zurück, da keine Fehlerbehandlung implementiert ist.
	#? Abhängigkeiten:
	# - Die Funktion verwendet die Befehle 'log' und 'dpkg-query'.
	# - Die Funktion verwendet die Umgebungsvariablen '$STARTVERZEICHNIS', '$DATEIDATUM' und '$logfilename'.
	#? Beispielaufruf:
	# installationen
##
function installationen() {
	# Letzte Bearbeitung 01.10.2023
	log info "Liste aller Installierten Pakete unter Linux:"
	dpkg-query -Wf '${Package;-40}${Priority}\n' | sort -b -k2,2 -k1,1
	dpkg-query -Wf '${Package;-40}${Priority}\n' | sort -b -k2,2 -k1,1 >>"/$STARTVERZEICHNIS/$DATEIDATUM$logfilename.log"
	return 0
}

## *  checkupgrade93
	# 
	#? Beschreibung:
	# Diese Funktion überprüft, ob ein OpenSimulator-Upgrade verfügbar ist und bietet die Möglichkeit an, das Upgrade durchzuführen.
	#? Parameter:
	# Diese Funktion erwartet keine Parameter.
	#? Rückgabewert:
	# Diese Funktion gibt keinen expliziten Rückgabewert zurück.
	#? Abhängigkeiten:
	# - Die Funktion geht davon aus, dass das Arbeitsverzeichnis auf das OpenSimulator-Verzeichnis gesetzt ist.
	# - Die Funktion verwendet die Befehle 'git pull', 'log' und 'osbuildingupgrade93'.
	# - Die Funktion verwendet die Umgebungsvariable '$STARTVERZEICHNIS'.
	#? Beispielaufruf:
	# checkupgrade93
##
function checkupgrade93() {
	# Letzte Bearbeitung 01.10.2023
	cd /$STARTVERZEICHNIS/opensim || exit
    CHECKERGEBNIS=$(git pull)

	# Already up to date?
    if [ "$CHECKERGEBNIS" = "Already up to date." ]; then 
        log info "Der Upgrade-Check ergab, ihr OpenSimuator ist Tagesaktuell.";
    else
		log info "Es gibt einen neuen OpenSimulator.";

		log rohtext "soll ich direkt ein Upgrade machen? ja [nein]";
		read -r OSUPGRADESIX
		#janein "$OSUPGRADESIX"
		#OSUPGRADESIX="$JNTRANSLATOR"

		if [ "$OSUPGRADESIX" = "" ]; then OSUPGRADESIX="nein"; fi
		log info "Ihre Upgrade auswahl ist: $OSUPGRADESIX"
		
		if [ "$OSUPGRADESIX" = "ja" ]; then osbuildingupgrade93 p; fi
    fi
}

## *  pull
	# 
	#? Beschreibung:
	# Diese Funktion führt den Befehl 'git pull' aus, um Aktualisierungen aus dem Remote-Git-Repository in das lokale Repository zu ziehen.
	#? Parameter:
	# Diese Funktion erwartet keine Parameter.
	#? Rückgabewert:
	# Diese Funktion gibt keinen expliziten Rückgabewert zurück.
	#? Abhängigkeiten:
	# - Die Funktion verwendet den Befehl 'git pull'.
	#? Beispielaufruf:
	# pull
##
function pull() {
	# Letzte Bearbeitung 01.10.2023
	# Führt den Befehl 'git pull' aus, um Aktualisierungen aus dem Remote-Git-Repository zu ziehen
	git pull
}

## *  osbuilding93
	#? Beschreibung:
	# Diese Funktion führt den Prozess zum Aktualisieren und Kompilieren des OpenSimulator-Projekts durch.
	# Je nach Verfügbarkeit von 'dialog' wird der Benutzer nach der Versionsnummer gefragt oder die Versionsnummer wird als Parameter erwartet.
	# Dann wird der alte OpenSimulator gesichert, der neue aus dem Git-Repository geholt, vorbereitet und kompiliert.
	#? Parameter:
	# - $1 (optional): Die Versionsnummer des neuen OpenSimulator-Branches.
	#? Rückgabewert:
	# Diese Funktion gibt immer den Wert 0 zurück, da keine Fehlerbehandlung implementiert ist.
	#? Abhängigkeiten:
	# - Die Funktion verwendet die Befehle 'dpkg-query', 'dialog', 'cd', 'log', 'osdelete', 'git clone', 'git checkout', 'runprebuild.sh', 'dotnet build', 'osupgrade93', 'ScreenLog' und 'hilfemenu'.
	# - Die Funktion verwendet die Umgebungsvariablen '$STARTVERZEICHNIS' und '$VERSION'.
	#? Beispielaufruf:
	# osbuilding93 0.9.3.0Dev-4-g5e9b3b4
	# Oder (mit dialog):
	# osbuilding93
##
function osbuilding93() {
	# Letzte Bearbeitung 01.10.2023
	# dialog Aktionen
	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then
		# Alle Aktionen mit dialog
		VERSIONSNUMMER=$(dialog --backtitle "opensimMULTITOOL $VERSION" --title "opensimMULTITOOL Eingabe" --help-button --defaultno --inputbox "Versionsnummer:" 8 40 3>&1 1>&2 2>&3 3>&-)
		antwort=$?
		dialogclear
		ScreenLog

		if [[ $antwort = 2 ]]; then hilfemenu; fi
		if [[ $antwort = 1 ]]; then exit; fi
	else
		# Alle Aktionen ohne dialog
		VERSIONSNUMMER=$1
	fi
	# dialog Aktionen Ende

	cd /$STARTVERZEICHNIS || exit
	log info "Alten OpenSimulator sichern"
	osdelete

	log line

	# Neue Versionsnummer: opensim-0.9.3.0Dev-4-g5e9b3b4.zip
	log info "Neuen OpenSimulator aus dem Git holen"
	git clone git://opensimulator.org/git/opensim opensim

	log line
	sleep 3

	log info "Prebuild des neuen OpenSimulator starten"
    cd opensim || exit
    git checkout dotnet6
    ./runprebuild.sh
    
	log line

	log info "Compilieren des neuen OpenSimulator"
	dotnet build --configuration Release OpenSim.sln

	log line
	osupgrade93

	return 0
}

## *  osbuildingupgrade93
	# 
	#? Beschreibung:
	# Diese Funktion sichert den aktuellen OpenSimulator, löscht ihn, lädt einen neuen OpenSimulator vom GitHub herunter,
	# führt verschiedene Konfigurationsschritte aus und kompiliert den OpenSimulator.
	#? Parameter:
	# - $1 (optional): Die Versionsnummer des neuen OpenSimulator-Branches.
	#? Rückgabewert:
	# Diese Funktion gibt immer den Wert 0 zurück, da keine Fehlerbehandlung implementiert ist.
	#? Abhängigkeiten:
	# - Die Funktion verwendet die Befehle 'rm', 'mv', 'log', 'opensimgitcopy93', 'cd', 'git checkout', 'setversion93', 'runprebuild.sh', 'dotnet build', 'moneycopy93', 'scriptcopy', 'osupgrade93'.
	# - Die Funktion verwendet die Umgebungsvariablen '$STARTVERZEICHNIS', '$MONEYVERZEICHNIS' und '$SETOSVERSION'.
	#? Beispielaufruf:
	# osbuildingupgrade93 09052023
##
function osbuildingupgrade93() {
	# Letzte Bearbeitung 01.10.2023
	SETOSVERSION=$1
	# if [ "$SETOSVERSION" = "" ]; then SETOSVERSION=$(date +"%d%m%Y"); fi
	# Alte Versionsdatei loeschen nicht vergessen.    
    sleep 1
	# Ist opensim vorhanden?
	if [ -d "/$STARTVERZEICHNIS/opensim" ] 
	then
		log info "OpenSimulator im Verzeichnis opensim1 sichern und neuen OpenSimulator vom Github herunterladen."
		rm -r /$STARTVERZEICHNIS/opensim1
		mv /$STARTVERZEICHNIS/opensim /$STARTVERZEICHNIS/opensim1
		opensimgitcopy93
	else
		log info "OpenSim existiert nicht."
		opensimgitcopy93
	fi
	cd /$STARTVERZEICHNIS/opensim || exit
	#log info "git pull"
    #git pull

    sleep 3
	# Money kopieren
	if [ "$MONEYVERZEICHNIS" = "keins" ] || [ "$MONEYVERZEICHNIS" = "no" ] || [ "$MONEYVERZEICHNIS" = "nein" ]; then log info "MoneyServer wird nicht installiert!"; else moneycopy93; fi
	#moneycopy93
	log info "checkout dotnet6"
	git checkout dotnet6

	# Versionsnummer Datum Beisoiel: 09052023	
	setversion93 $SETOSVERSION

	sleep 3
	log info "Prebuild"
    ./runprebuild.sh

    sleep 3
	log info "Build"
    dotnet build --configuration Release OpenSim.sln

    sleep 3
    cd /$STARTVERZEICHNIS || exit

	log line
	log info "scriptcopy startet!"
    scriptcopy

	log line
	log info "osupgrade93 startet!"
    osupgrade93

	log info "Maptile werden aus robust geloescht"
	autorobustmapdel

	return 0
}

## * osbuilding.
	# Baut automatisch einen neuen OpenSimulator mit den eingestellten Plugins.
	# Beispiel Datei: opensim-0.9.3.0Dev-1187-gcf0b1b1.zip
	# bash osmtool.sh osbuilding 1187
	# 
	#? @param keine.
	#? @return nichts wird zurueckgegeben.
	# todo: nichts.
##
function osbuilding() {
	# dialog Aktionen
	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then
		# Alle Aktionen mit dialog
		VERSIONSNUMMER=$(dialog --backtitle "opensimMULTITOOL $VERSION" --title "opensimMULTITOOL Eingabe" --help-button --defaultno --inputbox "Versionsnummer:" 8 40 3>&1 1>&2 2>&3 3>&-)
		antwort=$?
		dialogclear
		ScreenLog

		if [[ $antwort = 2 ]]; then hilfemenu; fi
		if [[ $antwort = 1 ]]; then exit; fi
	else
		# Alle Aktionen ohne dialog
		VERSIONSNUMMER=$1
	fi
	# dialog Aktionen Ende

	cd /$STARTVERZEICHNIS || exit
	log info "Alten OpenSimulator sichern"
	osdelete

	log line

	# Neue Versionsnummer: opensim-0.9.3.0Dev-4-g5e9b3b4.zip
	log info "Neuen OpenSimulator entpacken"
	unzip $OSVERSION"$VERSIONSNUMMER"-*.zip

	log line

	log info "Neuen OpenSimulator umbenennen"
	mv /$STARTVERZEICHNIS/$OSVERSION"$VERSIONSNUMMER"-*/ /$STARTVERZEICHNIS/opensim/

	log line
	sleep 3

	log info "Prebuild des neuen OpenSimulator starten"
	setversion "$VERSIONSNUMMER"

	log line

	log info "Compilieren des neuen OpenSimulator"
	compilieren

	log line
	osupgrade

	return 0
}

## * createuser.
	# Erstellen eines neuen Benutzer in der Robust Konsole.
	# Mit dem Konsolenkomanndo: create user [first] [last] [passw] [RegionX] [RegionY] [Email] - creates a new user and password.
	# 
	#? @param keine.
	#? @return nichts wird zurueckgegeben.
	# todo: nichts.
##
function createuser() {
	VORNAME=$1
	NACHNAME=$2
	PASSWORT=$3
	EMAIL=$4
	userid=$5

	if [ -z "$VORNAME" ]; then log rohtext "Der VORNAME fehlt!"; fi
	if [ -z "$NACHNAME" ]; then log rohtext "Der NACHNAME fehlt!"; fi
	if [ -z "$PASSWORT" ]; then log rohtext "Das PASSWORT fehlt!"; fi
	if [ -z "$EMAIL" ]; then log rohtext "Die EMAIL Adresse fehlt!"; fi

	if screen -list | grep -q "RO"; then
		# Befehlskette
		# First name [Default]: OK
		# Last name [User]: OK
		# Passwort: OK
		# Email []: OK
		# User ID (enter for random) []: bestaetigen
		# Model name []: bestaetigen

		# Befehl starten
		screen -S RO -p 0 -X eval "stuff 'create user'^M"
		# Abfragen beantworten
		screen -S RO -p 0 -X eval "stuff '$VORNAME'^M"
		screen -S RO -p 0 -X eval "stuff '$NACHNAME'^M"
		screen -S RO -p 0 -X eval "stuff '$PASSWORT'^M"
		screen -S RO -p 0 -X eval "stuff '$EMAIL'^M"
		# User ID
		#screen -S RO -p 0 -X eval "stuff ^M" # bestaetigen
		screen -S RO -p 0 -X eval "stuff '$userid'^M"
		# Model name
		screen -S RO -p 0 -X eval "stuff ^M" # bestaetigen

	else
		log error "CREATEUSER: Robust existiert nicht"
	fi
	return 0
}

## * menucreateuser.
	# Erstellen eines neuen Benutzer in der Robust Konsole.
	# Mit dem Konsolenkomanndo: create user [first] [last] [passw] [RegionX] [RegionY] [Email] - creates a new user and password.
	# 
	#? @param dialog.
	#? @return dialog.
	# todo: nichts.
##
function menucreateuser() {
	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then

		# Einstellungen
		boxbacktitel="opensimMULTITOOL"
		boxtitel="opensimMULTITOOL Eingabe"
		formtitle="Grid Benutzer Account anlegen"
		lable1="Vorname:"
		lablename1="John"
		lable2="Nachname:"
		lablename2="Doe"
		lable3="PASSWORT:"
		lablename3="PASSWORT"
		lable4="EMAIL:"
		lablename4="EMAIL"

		# Abfrage
		createuserBOXERGEBNIS=$(dialog --backtitle "$boxbacktitel" --title "$boxtitel" --form "$formtitle" 25 60 16 "$lable1" 1 1 "$lablename1" 1 25 25 30 "$lable2" 2 1 "$lablename2" 2 25 25 30 "$lable3" 3 1 "$lablename3" 3 25 25 30 "$lable4" 4 1 "$lablename4" 4 25 25 30 3>&1 1>&2 2>&3 3>&-)

		# Zeilen aus einer Variablen zerlegen und in verschiedenen Variablen schreiben.
		VORNAME=$(echo "$createuserBOXERGEBNIS" | sed -n '1p')
		NACHNAME=$(echo "$createuserBOXERGEBNIS" | sed -n '2p')
		PASSWORT=$(echo "$createuserBOXERGEBNIS" | sed -n '3p')
		EMAIL=$(echo "$createuserBOXERGEBNIS" | sed -n '4p')

		# Alles loeschen.
		dialogclear
		ScreenLog
	else
		# Alle Aktionen ohne dialog
		log rohtext "Keine Menuelose Funktion" | exit
	fi # dialog Aktionen Ende

	if [ -z "$VORNAME" ]; then log rohtext "Der VORNAME fehlt!"; fi
	if [ -z "$NACHNAME" ]; then log rohtext "Der NACHNAME fehlt!"; fi
	if [ -z "$PASSWORT" ]; then log rohtext "Das PASSWORT fehlt!"; fi
	if [ -z "$EMAIL" ]; then log rohtext "Die EMAIL Adresse fehlt!"; fi

	if screen -list | grep -q "RO"; then
		# Befehlskette
		# First name [Default]: OK
		# Last name [User]: OK
		# Passwort: OK
		# Email []: OK
		# User ID (enter for random) []: bestaetigen
		# Model name []: bestaetigen

		# Befehl starten
		screen -S RO -p 0 -X eval "stuff 'create user'^M"
		# Abfragen beantworten
		screen -S RO -p 0 -X eval "stuff '$VORNAME'^M"
		screen -S RO -p 0 -X eval "stuff '$NACHNAME'^M"
		screen -S RO -p 0 -X eval "stuff '$PASSWORT'^M"
		screen -S RO -p 0 -X eval "stuff '$EMAIL'^M"
		screen -S RO -p 0 -X eval "stuff ^M" # bestaetigen
		screen -S RO -p 0 -X eval "stuff ^M" # bestaetigen

	else
		log error "CREATEUSER: Robust existiert nicht"
	fi

	# Zum schluss alle Variablen loeschen.
	unset VORNAME NACHNAME PASSWORT EMAIL

	hauptmenu
}

## * db_friends.
	# Listet alle internen Freunde auf, aber keine hg freunde.
	# 
	#? @param username password databasename useruuid.
	#? @return "$result_mysqlrest".
	# todo: nichts.
##
function db_friends() {
	# Letzte Bearbeitung 01.10.2023
	username=$1
	password=$2
	databasename=$3
	useruuid=$4

	log rohtext "Listet alle internen Freunde auf, aber keine hg freunde:"
	mysqlrest "$username" "$password" "$databasename" "SELECT Friends.PrincipalID, CONCAT(UserAccounts.FirstName, ' ', UserAccounts.LastName) AS 'Friend' FROM Friends,UserAccounts WHERE Friends.Friend = '$useruuid' AND UserAccounts.PrincipalID = Friends.PrincipalID UNION SELECT Friends.Friend, CONCAT(UserAccounts.FirstName, ' ', UserAccounts.LastName) AS 'Friend'  FROM Friends, UserAccounts WHERE Friends.PrincipalID ='$useruuid' AND UserAccounts.PrincipalID = Friends.Friend"
	echo "$result_mysqlrest"

	return 0
}

## * db_online.
	# Listet Online User auf.
	# 
	#? @param "$username" "$password" "$databasename".
	#? @return "$result_mysqlrest".
	# todo: nichts.
##
function db_online() {
	# Letzte Bearbeitung 01.10.2023
	username=$1
	password=$2
	databasename=$3

	log rohtext "Listet Online User auf:"
	mysqlrest "$username" "$password" "$databasename" "SELECT concat(FirstName, ' ', LastName) AS 'Online Users' FROM UserAccounts INNER JOIN GridUser ON UserAccounts.PrincipalID = GridUser.UserID WHERE GridUser.Online = 'True'"
	echo "$result_mysqlrest"

	return 0
}

## * db_region.
	# Listet die Regionen aus Ihrer Datenbank auf.
	# 
	#? @param "$username" "$password" "$databasename".
	#? @return "$result_mysqlrest".
	# todo: nichts.
##
function db_region() {
	# Letzte Bearbeitung 01.10.2023
	username=$1
	password=$2
	databasename=$3

	log rohtext "Listet die Regionen in Ihrer Datenbank auf:"
	mysqlrest "$username" "$password" "$databasename" "SELECT regionName as 'Regions' FROM regions"
	echo "$result_mysqlrest"

	return 0
}

## * db_gridlist.
	# Gridliste der Benutzer, die schon einmal im eigenen Grid waren.
	# Aufruf: bash osmtool.sh db_gridlist databaseusername databasepassword databasename
	# 
	#? @param "$username" "$password" "$databasename".
	#? @return "$mygridliste".
	# todo: nichts.
##
function db_gridlist() {
	# Letzte Bearbeitung 01.10.2023
	username=$1
	password=$2
	databasename=$3

	log rohtext "Listet die Grids aus Ihrer Datenbank auf:"
	# SELECT * FROM 'GridUser' ORDER BY 'GridUser'.'UserID' ASC 
	#mysqlrest "$username" "$password" "$databasename" "SELECT regionName as 'Regions' FROM regions"
	mysqlrest "$username" "$password" "$databasename" "SELECT * FROM GridUser ORDER BY GridUser.UserID"

	mygridliste=$( echo "$result_mysqlrest" | sed 's/.*;http:\/\/ *//;T;s/ *\/;.*//' )
	echo "$mygridliste" >/$STARTVERZEICHNIS/osmgridlist.txt
	echo "$mygridliste"
	return 0
}

## * db_inv_search 
	# Sucht nach Inventareinträgen mit einem bestimmten Namen in einer MySQL-Datenbanktabelle.
	# Diese Funktion sucht nach Inventareinträgen in einer MySQL-Datenbanktabelle, die einen bestimmten Namen haben.
	#? Parameter:
	#   $1 - Der Benutzername für die MySQL-Datenbankverbindung.
	#   $2 - Das Passwort für die MySQL-Datenbankverbindung.
	#   $3 - Der Name der Datenbanktabelle, in der nach Inventareinträgen gesucht werden soll.
	#   $4 - Der Name, nach dem in den Inventareinträgen gesucht werden soll.
	#? Rückgabewert:
	#   Keiner (void).
	# Todos:
	#   Keine.
##
function db_inv_search() {
	# Letzte Bearbeitung 01.10.2023
	username=$1
	password=$2
	databasename=$3
    invname=$4

	log rohtext "Inventareinträge mit einem bestimmten Namen auflisten:"
	mysqlrest "$username" "$password" "$databasename" "SELECT concat(inventoryName, ' - ',  replace(inventoryID, '-', '')) AS 'Inventory', concat(assets.name, ' - ', hex(assets.id)) AS 'Asset' FROM inventoryitems LEFT JOIN assets ON replace(assetID, '-', '')=hex(assets.id) WHERE inventoryName = '$invname'"
	echo "$result_mysqlrest"

	return 0
}

## * db_ungenutzteobjekte 
	# Sucht nach ungenutzten Objekten in einer MySQL-Datenbanktabelle.
	# Diese Funktion sucht nach Objekten in einer MySQL-Datenbanktabelle, die in einem bestimmten Zeitraum nicht aufgerufen wurden.
	#? Parameter:
	#   $1 - Der Benutzername für die MySQL-Datenbankverbindung.
	#   $2 - Das Passwort für die MySQL-Datenbankverbindung.
	#   $3 - Der Name der Datenbanktabelle, in der nach ungenutzten Objekten gesucht werden soll.
	#   $4 - Das Startdatum (optional), ab dem nach ungenutzten Objekten gesucht werden soll (im Format "Jahr-Monat-Tag").
	#   $5 - Das Enddatum (optional), bis zu dem nach ungenutzten Objekten gesucht werden soll (im Format "Jahr-Monat-Tag").
	#? Rückgabewert:
	#   Keiner (void).
	# Todos:
	#   Keine.
##
function db_ungenutzteobjekte() {
	# Letzte Bearbeitung 01.10.2023
	username=$1
	password=$2
	databasename=$3

	from_date=$4
	to_date=$5

	
	if [[ -z "${from_date}" ]]; then
		from_date="2000-1-01";
	fi
	if [[ -z "${to_date}" ]]; then
		to_date="2021-1-01";
	fi
	
	
	to_date="2021-1-01 0:00";
	mysqlrest "$username" "$password" "$databasename" "SELECT name, id, create_time, access_time, CreatorID FROM assets WHERE access_time BETWEEN UNIX_TIMESTAMP('$from_date 0:00') AND UNIX_TIMESTAMP('$to_date 0:00')"

	log rohtext Objektname----------UUID---------Erstellungsdatum----------Zuletzt Aufgerufen-----------Ersteller
	echo "$result_mysqlrest"
	log rohtext "Objektname----------UUID---------Erstellungsdatum----------Zuletzt Aufgerufen-----------Ersteller" >UngenutzteObjekte.txt
	echo "$result_mysqlrest" >>UngenutzteObjekte.txt
return 0
}

## * db_user_anzahl 
	# Zählt die Gesamtzahl der Benutzer in einer MySQL-Datenbank-Tabelle.
	# Diese Funktion verwendet MySQL, um die Gesamtzahl der Benutzer in einer angegebenen Datenbanktabelle zu zählen.
	#? Parameter:
	#   $1 - Der Benutzername für die MySQL-Datenbankverbindung.
	#   $2 - Das Passwort für die MySQL-Datenbankverbindung.
	#   $3 - Der Name der Datenbanktabelle, in der die Benutzer gezählt werden sollen.
	#? Rückgabewert:
	#   Keiner (void).
	# Todos:
	#   Keine.
##
function db_user_anzahl() {
	# Letzte Bearbeitung 01.10.2023
	username=$1
	password=$2
	databasename=$3

	log rohtext "Zaehlt die Gesamtzahl der Benutzer:"
	mysqlrest "$username" "$password" "$databasename" "SELECT count(PrincipalID) AS 'Users' FROM UserAccounts"
	echo "$result_mysqlrest"

	return 0
}

## * db_user_online 
	# Ermittelt die Anzahl der Benutzer, die online sind, in einer MySQL-Datenbanktabelle.
	# Diese Funktion ermittelt die Anzahl der Benutzer, die online sind, in einer MySQL-Datenbanktabelle.
	#? Parameter:
	#   $1 - Der Benutzername für die MySQL-Datenbankverbindung.
	#   $2 - Das Passwort für die MySQL-Datenbankverbindung.
	#   $3 - Der Name der Datenbanktabelle, in der die Benutzer online ermittelt werden sollen.
	#? Rückgabewert:
	#   Keiner (void).
	# Todos:
	#   Keine.
##
function db_user_online() {
	# Letzte Bearbeitung 01.10.2023
	username=$1
	password=$2
	databasename=$3

	log rohtext "Users Online:"
	mysqlrest "$username" "$password" "$databasename" "SELECT count(UserID) AS 'Online' FROM GridUser WHERE Online = 'True'"
	echo "$result_mysqlrest"

	return 0
}

## * db_region_parzelle 
	# Zählt die Anzahl der Regionen mit Parzellen in einer MySQL-Datenbanktabelle.
	# Diese Funktion zählt die Anzahl der Regionen, die Parzellen enthalten, in einer MySQL-Datenbanktabelle.
	#? Parameter:
	#   $1 - Der Benutzername für die MySQL-Datenbankverbindung.
	#   $2 - Das Passwort für die MySQL-Datenbankverbindung.
	#   $3 - Der Name der Datenbanktabelle, in der die Regionen mit Parzellen gezählt werden sollen.
	#? Rückgabewert:
	#   Keiner (void).
	# Todos:
	#   Keine.
##
function db_region_parzelle() {
	# Letzte Bearbeitung 01.10.2023
	username=$1
	password=$2
	databasename=$3

	log rohtext "Zaehlt die Regionen mit Parzellen:"
	mysqlrest "$username" "$password" "$databasename" "SELECT count(DISTINCT regionUUID) FROM parcels"
	echo "$result_mysqlrest"

	return 0
}

## * db_region_parzelle_pakete 
	# Zählt die Gesamtzahl der Pakete in einer MySQL-Datenbanktabelle.
	# Diese Funktion zählt die Gesamtzahl der Pakete in einer MySQL-Datenbanktabelle.
	#? Parameter:
	#   $1 - Der Benutzername für die MySQL-Datenbankverbindung.
	#   $2 - Das Passwort für die MySQL-Datenbankverbindung.
	#   $3 - Der Name der Datenbanktabelle, in der die Pakete gezählt werden sollen.
	#? Rückgabewert:
	#   Keiner (void).
	# Todos:
	#   Keine.
##
function db_region_parzelle_pakete() {
	# Letzte Bearbeitung 01.10.2023
	username=$1
	password=$2
	databasename=$3

	log rohtext "Zaehlt die Gesamtzahl der Pakete:"
	mysqlrest "$username" "$password" "$databasename" "SELECT count(parcelUUID) AS 'Parcels' FROM parcels"
	echo "$result_mysqlrest"

	return 0
}

## * db_region_anzahl_regionsnamen 
	# Zählt die Anzahl der eindeutigen Regionsnamen in einer MySQL-Datenbanktabelle.
	# Diese Funktion zählt die Anzahl der eindeutigen Regionsnamen in einer MySQL-Datenbanktabelle.
	#? Parameter:
	#   $1 - Der Benutzername für die MySQL-Datenbankverbindung.
	#   $2 - Das Passwort für die MySQL-Datenbankverbindung.
	#   $3 - Der Name der Datenbanktabelle, in der die eindeutigen Regionsnamen gezählt werden sollen.
	#? Rückgabewert:
	#   Keiner (void).
	# Todos:
	#   Keine.
##
function db_region_anzahl_regionsnamen() {
	# Letzte Bearbeitung 01.10.2023
	username=$1
	password=$2
	databasename=$3

	log rohtext "Zaehlt eindeutige Regionsnamen:"
	mysqlrest "$username" "$password" "$databasename" "SELECT count(DISTINCT regionName) AS 'Regions' FROM regions"
	echo "$result_mysqlrest"

	return 0
}

## * db_region_anzahl_regionsid 
	# Zählt die Anzahl der Regionen anhand ihrer RegionIDs in einer MySQL-Datenbanktabelle.
	# Diese Funktion zählt die Anzahl der Regionen in einer MySQL-Datenbanktabelle anhand ihrer RegionIDs.
	#? Parameter:
	#   $1 - Der Benutzername für die MySQL-Datenbankverbindung.
	#   $2 - Das Passwort für die MySQL-Datenbankverbindung.
	#   $3 - Der Name der Datenbanktabelle, in der die Regionen anhand ihrer RegionIDs gezählt werden sollen.
	#? Rückgabewert:
	#   Keiner (void).
	# Todos:
	#   Keine.
##
function db_region_anzahl_regionsid() {
	# Letzte Bearbeitung 01.10.2023
	username=$1
	password=$2
	databasename=$3

	log rohtext "Zaehlt RegionIDs:"
	mysqlrest "$username" "$password" "$databasename" "SELECT count(UUID) AS 'Regions' FROM regions"
	echo "$result_mysqlrest"

	return 0
}

## *  db_inventar_no_assets
	#? Beschreibung: 
	#   Diese Funktion listet alle Inventareinträge auf, die auf nicht vorhandene
	#   Assets verweisen. Sie verwendet MySQL, um Daten aus der angegebenen
	#   Datenbank abzurufen und eine Liste der entsprechenden Einträge anzuzeigen.
	#   Die Funktion nimmt Benutzername, Passwort und Datenbanknamen als Argumente.
	#? Parameter:
	#   $1 (Benutzername): Der Benutzername für die MySQL-Datenbank.
	#   $2 (Passwort): Das Passwort für die MySQL-Datenbank.
	#   $3 (Datenbankname): Der Name der MySQL-Datenbank.
	# Ausgaben:
	#   Die Funktion gibt eine Liste von Inventareinträgen aus, die auf nicht
	#   vorhandene Assets verweisen, auf der Standardausgabe aus.
	#? Rückgabewert:
	#   Die Funktion gibt 0 zurück, wenn sie erfolgreich abgeschlossen wurde.
	# Abhängigkeiten:
	#   - Diese Funktion erfordert das Vorhandensein des Befehls "mysqlrest" und
	#     "log rohtext" in der Umgebung.
	# Beispiel:
	#   db_inventar_no_assets "meinuser" "geheim" "meinedatenbank"
## 
function db_inventar_no_assets() {
	# Letzte Bearbeitung 01.10.2023
	username=$1
	password=$2
	databasename=$3

	log rohtext "Listet alle Inventareintraege auf, die auf nicht vorhandene Assets verweisen:"
	mysqlrest "$username" "$password" "$databasename" "SELECT inventoryname, inventoryID, assetID FROM inventoryitems WHERE replace(assetID, '-', '') NOT IN (SELECT hex(id) FROM assets)"
	echo "$result_mysqlrest"

	return 0
}

## *  db_anzeigen
	#? Beschreibung: 
	#   Diese Funktion zeigt eine Liste aller Datenbanken auf dem MySQL-Server an,
	#   zu dem die Verbindung mit den angegebenen Anmeldeinformationen hergestellt
	#   wird. Sie nimmt Benutzername, Passwort und den Datenbanknamen als Argumente.	#
	#? Parameter:
	#   $1 (Benutzername): Der Benutzername für die MySQL-Datenbank.
	#   $2 (Passwort): Das Passwort für die MySQL-Datenbank.
	#   $3 (Datenbankname): Der Name der MySQL-Datenbank, auf die zugegriffen wird.	#
	# Ausgaben:
	#   Die Funktion gibt eine Liste aller Datenbanken auf der Standardausgabe aus.	#
	#? Rückgabewert:
	#   Die Funktion gibt 0 zurück, wenn sie erfolgreich abgeschlossen wurde.	#
	# Abhängigkeiten:
	#   - Diese Funktion erfordert das Vorhandensein des Befehls "mysqlrest" und
	#     "log text" in der Umgebung.	#
	# Beispiel:
	#   db_anzeigen "meinuser" "geheim" "meinedatenbank"
##
function db_anzeigen() {
	# Letzte Bearbeitung 01.10.2023
	username=$1
	password=$2
	databasename=$3

	log text "PRINT DATABASE: Alle Datenbanken anzeigen."
	mysqlrest "$username" "$password" "$databasename" "show databases"
	log rohtext "$result_mysqlrest"

	return 0
}

## *  db_anzeigen_dialog
	#? Beschreibung: 
	#   Diese Funktion zeigt eine Liste aller Datenbanken auf dem MySQL-Server an,
	#   zu dem die Verbindung mit den angegebenen Anmeldeinformationen hergestellt
	#   wird. Sie verwendet das Dialog-Tool für eine interaktive Benutzereingabe von
	#   Benutzername und Passwort.	#
	#? Abhängigkeiten:
	#   - Diese Funktion erfordert das Vorhandensein des Befehls "dialog" in der
	#     Umgebung, um die Benutzereingabe zu ermöglichen.
	#   - Diese Funktion verwendet die Befehle "log rohtext", "dialogclear" und
	#     "ScreenLog" (Annahme: sie sind in Ihrem Skript definiert).
	#   - Die Funktion erwartet, dass der Benutzername und das Passwort an den
	#     MySQL-Server übergeben werden können.	#
	#? Beispiel:
	#   db_anzeigen_dialog
##
function db_anzeigen_dialog() {
	# Letzte Bearbeitung 02.10.2023
	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then

		# Einstellungen
		boxbacktitel="opensimMULTITOOL"
		boxtitel="opensimMULTITOOL Eingabe"
		formtitle="Alle erstellten Datenbanken auflisten"
		lable1="Benutzername:"
		lablename1=""
		lable2="Passwort:"
		lablename2=""

		# Abfrage
		db_menu=$(dialog --backtitle "$boxbacktitel" --title "$boxtitel" --form "$formtitle" 25 60 16 "$lable1" 1 1 "$lablename1" 1 25 25 30 "$lable2" 2 1 "$lablename2" 2 25 25 30 3>&1 1>&2 2>&3 3>&-)

		# Zeilen aus einer Variablen zerlegen und in verschiedenen Variablen schreiben.
		username=$(echo "$db_menu" | sed -n '1p')
		password=$(echo "$db_menu" | sed -n '2p')

		# Alles loeschen.
		dialogclear
		ScreenLog
	else
		# Alle Aktionen ohne dialog
		log rohtext "Keine Menuelose Funktion" | exit
	fi # dialog Aktionen Ende

	# Abfrage
	mysqlergebniss=$(echo "show databases;" | MYSQL_PWD=$password mysql -u"$username" -N) 2>/dev/null
	# Ausgabe in Box
	warnbox "$mysqlergebniss"

	return 0
}

## *  db_tables
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion führt eine Abfrage in einer MySQL-Datenbank durch, um alle Tabellen in der Datenbank aufzulisten.
	# Sie verwendet die übergebenen Benutzerdaten, um sich bei der Datenbank anzumelden, und führt dann die SHOW TABLES-Abfrage aus.
	#? Parameter:
	# $1: Benutzername für die Datenbank
	# $2: Passwort für die Datenbank
	# $3: Name der Datenbank, in der die Tabellen aufgelistet werden sollen
	#? Beispielaufruf:
	# db_tables "mein_benutzer" "geheim123" "meine_datenbank"
##
function db_tables() {
	# Letzte Bearbeitung 02.10.2023
	username=$1
	password=$2
	databasename=$3

	log text "PRINT DATABASE: tabellenabfrage, listet alle Tabellen in einer Datenbank auf."
	mysqlrest "$username" "$password" "$databasename" "SHOW TABLES FROM $databasename"
	log rohtext "$result_mysqlrest"

	return 0
}

## *  db_tables_dialog
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht es dem Benutzer, über das Dialog-Tool alle Tabellen in einer MySQL-Datenbank aufzulisten.
	# Wenn das Dialog-Tool nicht installiert ist, wird die Funktion beendet.
	#? Parameter:
	# Diese Funktion erfordert keine expliziten Parameter, da sie Benutzereingaben über das Dialog-Tool erwartet.
	#? Beispielaufruf:
	# Die Funktion wird normalerweise nicht direkt aufgerufen, sondern interaktiv über das Dialog-Tool verwendet.
##
function db_tables_dialog() {
	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then

		# Einstellungen
		boxbacktitel="opensimMULTITOOL"
		boxtitel="opensimMULTITOOL Eingabe"
		formtitle="Alle Tabellen in einer Datenbank auflisten"
		lable1="Benutzername:"
		lablename1=""
		lable2="Passwort:"
		lablename2=""
		lable3="Datenbankname:"
		lablename3=""

		# Abfrage
		ASSETDELBOXERGEBNIS=$(dialog --backtitle "$boxbacktitel" --title "$boxtitel" --form "$formtitle" 25 60 16 "$lable1" 1 1 "$lablename1" 1 25 25 30 "$lable2" 2 1 "$lablename2" 2 25 25 30 "$lable3" 3 1 "$lablename3" 3 25 25 30 3>&1 1>&2 2>&3 3>&-)

		# Zeilen aus einer Variablen zerlegen und in verschiedenen Variablen schreiben.
		username=$(echo "$ASSETDELBOXERGEBNIS" | sed -n '1p')
		password=$(echo "$ASSETDELBOXERGEBNIS" | sed -n '2p')
		databasename=$(echo "$ASSETDELBOXERGEBNIS" | sed -n '3p')

		# Alles loeschen.
		dialogclear
		ScreenLog
	else
		# Alle Aktionen ohne dialog
		log rohtext "Keine Menuelose Funktion" | exit
	fi # dialog Aktionen Ende

	mysqlrest "$username" "$password" "$databasename" "SHOW TABLES FROM $databasename"

	warnbox "$result_mysqlrest"

	return 0
}

## *  db_benutzer_anzeigen
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht es dem Benutzer, über das Dialog-Tool alle Benutzer in einer MySQL-Datenbank anzuzeigen.
	# Wenn das Dialog-Tool nicht installiert ist, können Benutzername und Passwort als Parameter übergeben werden.
	#? Parameter:
	# Diese Funktion erfordert keine expliziten Parameter, wenn das Dialog-Tool verwendet wird. Wenn das Dialog-Tool nicht installiert ist, 
	# werden die folgenden Parameter benötigt:
	# $1: Benutzername für die Datenbank
	# $2: Passwort für die Datenbank
	#? Beispielaufruf:
	# Die Funktion kann entweder über das Dialog-Tool oder mit den erforderlichen Parametern aufgerufen werden.
##
function db_benutzer_anzeigen() {
	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then

		# Einstellungen
		boxbacktitel="opensimMULTITOOL"
		boxtitel="opensimMULTITOOL Eingabe"
		formtitle="Alle angelegten Benutzer von mySQL anzeigen"
		lable1="Benutzername:"
		lablename1=""
		lable2="Passwort:"
		lablename2=""

		# Abfrage
		db_benutzer_anzeigenBOXERGEBNIS=$(dialog --backtitle "$boxbacktitel" --title "$boxtitel" --form "$formtitle" 25 60 16 "$lable1" 1 1 "$lablename1" 1 25 25 30 "$lable2" 2 1 "$lablename2" 2 25 25 30 3>&1 1>&2 2>&3 3>&-)

		# Zeilen aus einer Variablen zerlegen und in verschiedenen Variablen schreiben.
		username=$(echo "$db_benutzer_anzeigenBOXERGEBNIS" | sed -n '1p')
		password=$(echo "$db_benutzer_anzeigenBOXERGEBNIS" | sed -n '2p')

		# Alles loeschen.
		dialogclear
		ScreenLog
	else
		# Alle Aktionen ohne dialog
		username=$1
		password=$2
	fi # dialog Aktionen Ende

	log text "PRINT DATABASE USER: Alle Datenbankbenutzer anzeigen."
	result_mysqlrest=$(echo "SELECT User FROM mysql.user;" | MYSQL_PWD=$password mysql -u"$username" -N)

	# Ausgabe zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then
		warnbox "$result_mysqlrest"
	else
		log rohtext "$result_mysqlrest"
	fi

	return 0
}

## *  db_regions
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht es dem Benutzer, über das Dialog-Tool alle Regionen in einer MySQL-Datenbank aufzulisten.
	# Wenn das Dialog-Tool nicht installiert ist, können Benutzername, Passwort und Datenbankname als Parameter übergeben werden.
	#? Parameter:
	# Diese Funktion erfordert keine expliziten Parameter, wenn das Dialog-Tool verwendet wird. Wenn das Dialog-Tool nicht installiert ist, 
	# werden die folgenden Parameter benötigt:
	# $1: Benutzername für die Datenbank
	# $2: Passwort für die Datenbank
	# $3: Name der Datenbank, in der die Regionen aufgelistet werden sollen
	#? Beispielaufruf:
	# Die Funktion kann entweder über das Dialog-Tool oder mit den erforderlichen Parametern aufgerufen werden.
## 
function db_regions() {
	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then

		# Einstellungen
		boxbacktitel="opensimMULTITOOL"
		boxtitel="opensimMULTITOOL Eingabe"
		formtitle="Alle Regionen auflisten"
		lable1="Benutzername:"
		lablename1=""
		lable2="Passwort:"
		lablename2=""
		lable3="Datenbankname:"
		lablename3=""

		# Abfrage
		db_regionsBOXERGEBNIS=$(dialog --backtitle "$boxbacktitel" --title "$boxtitel" --form "$formtitle" 25 60 16 "$lable1" 1 1 "$lablename1" 1 25 25 30 "$lable2" 2 1 "$lablename2" 2 25 25 30 "$lable3" 3 1 "$lablename3" 3 25 25 30 3>&1 1>&2 2>&3 3>&-)

		# Zeilen aus einer Variablen zerlegen und in verschiedenen Variablen schreiben.
		username=$(echo "$db_regionsBOXERGEBNIS" | sed -n '1p')
		password=$(echo "$db_regionsBOXERGEBNIS" | sed -n '2p')
		databasename=$(echo "$db_regionsBOXERGEBNIS" | sed -n '3p')

		# Alles loeschen.
		dialogclear
		ScreenLog
	else
		# Alle Aktionen ohne dialog
		username=$1
		password=$2
		databasename=$3
	fi # dialog Aktionen Ende

	log text "PRINT DATABASE: Alle Regionen listen."
	mysqlrest "$username" "$password" "$databasename" "SELECT regionName FROM regions"

	# Ausgabe zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then
		warnbox "$result_mysqlrest"
	else
		log rohtext "$result_mysqlrest"
	fi

	return 0
}

## *  db_regionsuri
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht es dem Benutzer, über das Dialog-Tool alle Regionen in einer MySQL-Datenbank abzurufen und nach URI zu sortieren.
	# Wenn das Dialog-Tool nicht installiert ist, können Benutzername, Passwort und Datenbankname als Parameter übergeben werden.
	#? Parameter:
	# Diese Funktion erfordert keine expliziten Parameter, wenn das Dialog-Tool verwendet wird. Wenn das Dialog-Tool nicht installiert ist, 
	# werden die folgenden Parameter benötigt:
	# $1: Benutzername für die Datenbank
	# $2: Passwort für die Datenbank
	# $3: Name der Datenbank, in der die Regionen abgerufen werden sollen
	#? Beispielaufruf:
	# Die Funktion kann entweder über das Dialog-Tool oder mit den erforderlichen Parametern aufgerufen werden.
##
function db_regionsuri() {
	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then

		# Einstellungen
		boxbacktitel="opensimMULTITOOL"
		boxtitel="opensimMULTITOOL Eingabe"
		formtitle="Region URI pruefen sortiert nach URI"
		lable1="Benutzername:"
		lablename1=""
		lable2="Passwort:"
		lablename2=""
		lable3="Datenbankname:"
		lablename3=""

		# Abfrage
		db_regionsuriBOXERGEBNIS=$(dialog --backtitle "$boxbacktitel" --title "$boxtitel" --form "$formtitle" 25 60 16 "$lable1" 1 1 "$lablename1" 1 25 25 30 "$lable2" 2 1 "$lablename2" 2 25 25 30 "$lable3" 3 1 "$lablename3" 3 25 25 30 3>&1 1>&2 2>&3 3>&-)

		# Zeilen aus einer Variablen zerlegen und in verschiedenen Variablen schreiben.
		username=$(echo "$db_regionsuriBOXERGEBNIS" | sed -n '1p')
		password=$(echo "$db_regionsuriBOXERGEBNIS" | sed -n '2p')
		databasename=$(echo "$db_regionsuriBOXERGEBNIS" | sed -n '3p')

		# Alles loeschen.
		dialogclear
		ScreenLog
	else
		# Alle Aktionen ohne dialog
		username=$1
		password=$2
		databasename=$3
	fi # dialog Aktionen Ende

	log text "PRINT DATABASE: Region URI pruefen sortiert nach URI."
	mysqlrest "$username" "$password" "$databasename" "SELECT regionName , serverURI FROM regions ORDER BY serverURI"

	# Ausgabe zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then
		warnbox "$result_mysqlrest"
	else
		log rohtext "$result_mysqlrest"
	fi

	return 0
}

## *  db_regionsport
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht es dem Benutzer, über das Dialog-Tool alle Regionen in einer MySQL-Datenbank abzurufen und nach Ports zu sortieren.
	# Wenn das Dialog-Tool nicht installiert ist, können Benutzername, Passwort und Datenbankname als Parameter übergeben werden.
	#? Parameter:
	# - Wenn das Dialog-Tool verwendet wird:
	#   Diese Funktion erfordert keine expliziten Parameter.
	# - Wenn das Dialog-Tool nicht installiert ist:
	#   $1: Benutzername für die Datenbank
	#   $2: Passwort für die Datenbank
	#   $3: Name der Datenbank, in der die Regionen abgerufen werden sollen
	#? Beispielaufruf:
	# - Über das Dialog-Tool:
	#   Die Funktion kann einfach aufgerufen werden, und der Benutzer wird zur Eingabe der erforderlichen Informationen aufgefordert.
	# - Mit Parametern:
	#   db_regionsport "mein_benutzer" "geheim123" "meine_datenbank"
##
function db_regionsport() {
	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then

		# Einstellungen
		boxbacktitel="opensimMULTITOOL"
		boxtitel="opensimMULTITOOL Eingabe"
		formtitle="Ports pruefen sortiert nach Ports"
		lable1="Benutzername:"
		lablename1=""
		lable2="Passwort:"
		lablename2=""
		lable3="Datenbankname:"
		lablename3=""

		# Abfrage
		db_regionsportBOXERGEBNIS=$(dialog --backtitle "$boxbacktitel" --title "$boxtitel" --form "$formtitle" 25 60 16 "$lable1" 1 1 "$lablename1" 1 25 25 30 "$lable2" 2 1 "$lablename2" 2 25 25 30 "$lable3" 3 1 "$lablename3" 3 25 25 30 3>&1 1>&2 2>&3 3>&-)

		# Zeilen aus einer Variablen zerlegen und in verschiedenen Variablen schreiben.
		username=$(echo "$db_regionsportBOXERGEBNIS" | sed -n '1p')
		password=$(echo "$db_regionsportBOXERGEBNIS" | sed -n '2p')
		databasename=$(echo "$db_regionsportBOXERGEBNIS" | sed -n '3p')

		# Alles loeschen.
		dialogclear
		ScreenLog
	else
		# Alle Aktionen ohne dialog
		username=$1
		password=$2
		databasename=$3
	fi # dialog Aktionen Ende

	log text "PRINT DATABASE: Alle Datenbanken anzeigen."
	mysqlrest "$username" "$password" "$databasename" "SELECT regionName , serverPort FROM regions ORDER BY serverPort"

	# Ausgabe zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then
		warnbox "$result_mysqlrest"
	else
		log rohtext "$result_mysqlrest"
	fi

	return 0
}

## *  create_db
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht es, eine MySQL-Datenbank zu erstellen. Sie akzeptiert Benutzername, Passwort und den Namen der zu erstellenden Datenbank als Parameter.
	#? Parameter:
	# $1: Benutzername für die Datenbank
	# $2: Passwort für die Datenbank
	# $3: Name der Datenbank, die erstellt werden soll
	#? Beispielaufruf:
	# create_db "mein_benutzer" "geheim123" "meine_datenbank"
	# Hinweis:
	# - Die Funktion verwendet das `mysql`-Befehlszeilentool, um die Datenbank zu erstellen.
	# - Die Verwendung von Passwörtern auf der Befehlszeile kann unsicher sein, daher wird die Fehlerausgabe unterdrückt.
##
function create_db() {
	DBBENUTZER=$1
	DBPASSWORT=$2
	DATENBANKNAME=$3

	log info "CREATE DATABASE: Datenbanken anlegen."
	log info  "$DBBENUTZER, ********, $DATENBANKNAME"

	# 2>/dev/null verhindert die Fehlerausgabe - mysql warning using a password on the command line interface can be insecure. disable.
	mysql -u"$DBBENUTZER" -p"$DBPASSWORT" -e "CREATE DATABASE IF NOT EXISTS $DATENBANKNAME CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci" 2>/dev/null
	# utf8mb4 COLLATE utf8mb4_unicode_ci

	log info "CREATE DATABASE: Datenbanken $DATENBANKNAME wurde angelegt."

	# Eingabe Variablen loeschen
	unset DBBENUTZER
	unset DBPASSWORT
	unset DATENBANKNAME

	return 0
}

## *  create_db_user
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht es, einen neuen Datenbankbenutzer in MySQL zu erstellen und diesem Benutzer alle Berechtigungen auf allen Datenbanken zuzuweisen.
	#? Parameter:
	# $1: Benutzername für die Datenbank, mit dem die Aktionen durchgeführt werden
	# $2: Passwort für den Benutzer, um die Aktionen durchzuführen
	# $3: Name des neuen Datenbankbenutzers, der erstellt werden soll
	# $4: Passwort für den neuen Datenbankbenutzer
	#? Beispielaufruf:
	# create_db_user "mein_benutzer" "geheim123" "neuer_benutzer" "neues_geheim"
	# Hinweis:
	# - Die Funktion erstellt einen neuen Datenbankbenutzer mit dem angegebenen Namen und Passwort.
	# - Dem neuen Benutzer werden alle Berechtigungen auf allen Datenbanken zugewiesen.
	# - Nachdem die Aktionen abgeschlossen sind, werden die Eingabevariablen gelöscht, um die Sicherheit zu gewährleisten.
##
function create_db_user() {
	DBBENUTZER=$1
	DBPASSWORT=$2
	NEUERNAME=$3
	NEUESPASSWORT=$4

	log info "CREATE DATABASE USER: Datenbankbenutzer anlegen."
	log info  "$DBBENUTZER, ********, $NEUERNAME, ********"

	mysql -u"$DBBENUTZER" -p"$DBPASSWORT" -e "CREATE USER '$NEUERNAME'@'localhost' IDENTIFIED BY '$NEUESPASSWORT'"
	mysql -u"$DBBENUTZER" -p"$DBPASSWORT" -e "GRANT ALL PRIVILEGES ON * . * TO '$NEUERNAME'@'localhost'"
	mysql -u"$DBBENUTZER" -p"$DBPASSWORT" -e "flush privileges"

	# Eingabe Variablen loeschen
	unset DBBENUTZER
	unset DBPASSWORT
	unset NEUERNAME
	unset NEUESPASSWORT

	return 0
}

## *  delete_db
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht es, eine MySQL-Datenbank zu löschen. Sie akzeptiert Benutzername, Passwort und den Namen der zu löschenden Datenbank als Parameter.
	#? Parameter:
	# $1: Benutzername für die Datenbank, mit dem die Aktionen durchgeführt werden
	# $2: Passwort für den Benutzer, um die Aktionen durchzuführen
	# $3: Name der Datenbank, die gelöscht werden soll
	#? Beispielaufruf:
	# delete_db "mein_benutzer" "geheim123" "zu_loeschende_datenbank"
	# Hinweis:
	# - Die Funktion verwendet das `mysql`-Befehlszeilentool, um die Datenbank zu löschen.
	# - Die Verwendung von Passwörtern auf der Befehlszeile kann unsicher sein, daher wird die Fehlerausgabe unterdrückt.
##
function delete_db() {
	DBBENUTZER=$1
	DBPASSWORT=$2
	DATENBANKNAME=$3

	log info  "DELETE DATABASE: Datenbank loeschen"
	log info  "$DBBENUTZER, ********, $DATENBANKNAME"

	# 2>/dev/null verhindert die Fehlerausgabe - mysql warning using a password on the command line interface can be insecure. disable.
	mysql -u"$DBBENUTZER" -p"$DBPASSWORT" -e "DROP DATABASE $DATENBANKNAME" 2>/dev/null

	# Eingabe Variablen loeschen
	unset DBBENUTZER
	unset DBPASSWORT
	unset DATENBANKNAME

	return 0
}

## *  db_empty
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht es dem Benutzer, eine MySQL-Datenbank zu leeren, indem sie zuerst die Datenbank löscht und dann eine neue Datenbank mit dem gleichen Namen erstellt. 
	# Dies kann nützlich sein, um eine Datenbank schnell zurückzusetzen, ohne die Struktur zu ändern. 
	# Die Funktion akzeptiert Benutzername, Passwort und den Namen der zu leerenden Datenbank als Parameter.
	#? Parameter:
	# $1: Benutzername für die Datenbank, mit dem die Aktionen durchgeführt werden
	# $2: Passwort für den Benutzer, um die Aktionen durchzuführen
	# $3: Name der Datenbank, die geleert werden soll
	#? Beispielaufruf:
	# db_empty "mein_benutzer" "geheim123" "zu_leerende_datenbank"
	# Hinweis:
	# - Die Funktion verwendet das `mysql`-Befehlszeilentool, um die Datenbank zu leeren.
	# - Zuerst wird die Datenbank gelöscht und dann eine neue Datenbank mit dem gleichen Namen erstellt.
	# - Die Verwendung von Passwörtern auf der Befehlszeile kann unsicher sein, daher wird die Fehlerausgabe unterdrückt.
##
function db_empty() {
	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then

		# Einstellungen
		boxbacktitel="opensimMULTITOOL"
		boxtitel="opensimMULTITOOL Eingabe"
		formtitle="Datenbank leeren"
		lable1="Benutzername:"
		lablename1=""
		lable2="Passwort:"
		lablename2=""
		lable3="Datenbankname:"
		lablename3=""

		# Abfrage
		db_emptyRGEBNIS=$(dialog --backtitle "$boxbacktitel" --title "$boxtitel" --form "$formtitle" 25 60 16 "$lable1" 1 1 "$lablename1" 1 25 25 30 "$lable2" 2 1 "$lablename2" 2 25 25 30 "$lable3" 3 1 "$lablename3" 3 25 25 30 3>&1 1>&2 2>&3 3>&-)

		# Zeilen aus einer Variablen zerlegen und in verschiedenen Variablen schreiben.
		username=$(echo "$db_emptyRGEBNIS" | sed -n '1p')
		password=$(echo "$db_emptyRGEBNIS" | sed -n '2p')
		databasename=$(echo "$db_emptyRGEBNIS" | sed -n '3p')

		# Alles loeschen.
		dialogclear
		ScreenLog
	else
		# Alle Aktionen ohne dialog
		username=$1
		password=$2
		databasename=$3
	fi # dialog Aktionen Ende

	#log text "EMPTY DATABASE: Datenbank $databasename leeren."

	echo "DROP DATABASE $databasename;" | MYSQL_PWD=$password mysql -u"$username" -N
	sleep 15
	echo "CREATE DATABASE IF NOT EXISTS $databasename CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" | MYSQL_PWD=$password mysql -u"$username" -N

	#log text "EMPTY DATABASE: Datenbank $databasename wurde geleert."

	# Du solltest benutzen:
	# CREATE DATABASE mydb CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
	# Beachten Sie, dass utf8_general_ci nicht mehr als bewaehrte Methode empfohlen wird.

	# Ausgabe zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then
		warnbox "Datenbank $databasename wurde geleert"
	else
		log rohtext "Datenbank $databasename wurde geleert"
	fi

	return 0
}

## *  allrepair_db
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht es dem Benutzer, alle Datenbanken auf einem MySQL-Server zu überprüfen, zu reparieren und zu optimieren. 
	# Wenn das Dialog-Tool installiert ist, werden Benutzername und Passwort über das Dialog-Tool abgefragt. 
	# Andernfalls können Benutzername und Passwort als Parameter übergeben werden. 
	# Die Funktion verwendet die `mysqlcheck`-Befehle, um die Überprüfung, Reparatur und Optimierung durchzuführen.
	#? Parameter:
	# Diese Funktion erfordert keine expliziten Parameter, wenn das Dialog-Tool verwendet wird. 
	# Wenn das Dialog-Tool nicht installiert ist, werden die folgenden Parameter benötigt:
	# $1: Benutzername für den MySQL-Server
	# $2: Passwort für den Benutzer
	#? Beispielaufruf:
	# Die Funktion kann entweder über das Dialog-Tool oder mit den erforderlichen Parametern aufgerufen werden.
	# allrepair_db "mein_benutzer" "geheim123"
	# Hinweis:
	# - Die Funktion verwendet `mysqlcheck`, um die folgenden SQL-Statements automatisiert auszuführen: 
	#   - CHECK TABLE
	#   - REPAIR TABLE
	#   - ANALYZE TABLE
	#   - OPTIMIZE TABLE
	# - Die Verwendung von Passwörtern auf der Befehlszeile kann unsicher sein, daher wird die Fehlerausgabe unterdrückt.
##
function allrepair_db() {
	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then

		# Einstellungen
		boxbacktitel="opensimMULTITOOL"
		boxtitel="opensimMULTITOOL Eingabe"
		formtitle="Alle Datenbanken Checken, Reparieren und Optimieren"
		lable1="Benutzername:"
		lablename1=""
		lable2="Passwort:"
		lablename2=""

		# Abfrage
		landclearBOXERGEBNIS=$(dialog --backtitle "$boxbacktitel" --title "$boxtitel" --form "$formtitle" 25 60 16 "$lable1" 1 1 "$lablename1" 1 25 25 30 "$lable2" 2 1 "$lablename2" 2 25 25 30 3>&1 1>&2 2>&3 3>&-)

		# Zeilen aus einer Variablen zerlegen und in verschiedenen Variablen schreiben.
		username=$(echo "$landclearBOXERGEBNIS" | sed -n '1p')
		password=$(echo "$landclearBOXERGEBNIS" | sed -n '2p')

		# Alles loeschen.
		dialogclear
		ScreenLog
	else
		# Alle Aktionen ohne dialog
		username=$1
		password=$2
	fi # dialog Aktionen Ende

	#log text "ALL REPAIR DATABASE: Alle Datenbanken Checken, Reparieren und Optimieren"
	mysqlcheck -u"$username" -p"$password" --check --all-databases
	mysqlcheck -u"$username" -p"$password" --auto-repair --all-databases
	mysqlcheck -u"$username" -p"$password" --optimize --all-databases
	# Danach werden automatisiert folgende SQL Statements ausgefuehrt:
	# – CHECK TABLE
	# – REPAIR TABLE
	# – ANALYZE TABLE
	# – OPTIMIZE TABLE

	# Ausgabe zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then
		warnbox "ALL REPAIR DATABASE: Fertig"
	else
		log rohtext "ALL REPAIR DATABASE: Fertig"
	fi

	return 0
}

## *  mysql_neustart
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht es dem Benutzer, den MySQL-Dienst neu zu starten. Der MySQL-Dienst wird zuerst gestoppt und nach einer 
	# Verzögerung von 15 Sekunden wieder gestartet.
	#? Parameter:
	# Diese Funktion erfordert keine expliziten Parameter.
	#? Beispielaufruf:
	# Die Funktion kann ohne Parameter aufgerufen werden.
	# mysql_neustart
##
function mysql_neustart() {
	log text "MYSQL RESTART: MySQL Neu starten."

	service mysql stop
	sleep 15
	service mysql start
	log text "MYSQL RESTART: Fertig."

	return 0
}

## *  db_backup
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht es dem Benutzer, eine MySQL-Datenbank zu sichern. Die Sicherung erfolgt mithilfe des Befehls 'mysqldump',
	# und die Ausgabe wird in einer SQL-Datei gespeichert. Die Funktion erfordert Benutzername, Passwort und den Namen der zu sichernden Datenbank.
	# Die gesicherte SQL-Datei wird im Startverzeichnis gespeichert.
	#? Parameter:
	# $1: Benutzername für die Datenbank
	# $2: Passwort für die Datenbank
	# $3: Name der Datenbank, die gesichert werden soll
	#? Beispielaufruf:
	# Die Funktion sollte mit den erforderlichen Parametern aufgerufen werden.
	# db_backup "mein_benutzer" "geheim123" "meine_datenbank"
##
function db_backup() {
	username=$1
	password=$2
	databasename=$3

	log text "SAVE DATABASE: Datenbank $databasename sichern."

	mysqldump -u"$username" -p"$password" "$databasename" >/$STARTVERZEICHNIS/"$databasename".sql 2>/dev/null

	log text "SAVE DATABASE: Im Hintergrund wird die Datenbank $databasename jetzt gesichert." # Screen fehlt!

	return 0
}

## *  db_compress_backup
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht es dem Benutzer, eine MySQL-Datenbank zu sichern und die Sicherungsdatei zu komprimieren. Die Sicherung erfolgt
	# mithilfe des Befehls 'mysqldump', und die Ausgabe wird in einer gzip-komprimierten SQL-Datei gespeichert. Die Funktion erfordert
	# Benutzername, Passwort und den Namen der zu sichernden Datenbank.
	#? Parameter:
	# $1: Benutzername für die Datenbank
	# $2: Passwort für die Datenbank
	# $3: Name der Datenbank, die gesichert werden soll
	#? Beispielaufruf:
	# Die Funktion sollte mit den erforderlichen Parametern aufgerufen werden.
	# db_compress_backup "mein_benutzer" "geheim123" "meine_datenbank"
##
function db_compress_backup() {
	username=$1
	password=$2
	databasename=$3

	log text "SAVE DATABASE: Datenbank $databasename sichern."

	mysqldump -u"$username" -p"$password" "$databasename" | gzip -c >"$databasename".sql.gz

	log text "SAVE DATABASE: Im Hintergrund wird die Datenbank $databasename jetzt gesichert." # Screen fehlt!

	return 0
}

## *  db_backuptabellen
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht es dem Benutzer, alle Tabellen einer MySQL-Datenbank zu sichern und als ZIP-Archive zu speichern.
	# Die Funktion erfordert Benutzername, Passwort und den Namen der zu sichernden Datenbank.
	# Es wird ein Verzeichnis für das Backup erstellt, und für jede Tabelle wird ein separates ZIP-Archiv erstellt.
	#? Parameter:
	# $1: Benutzername für die Datenbank
	# $2: Passwort für die Datenbank
	# $3: Name der Datenbank, deren Tabellen gesichert werden sollen
	#? Beispielaufruf:
	# Die Funktion sollte mit den erforderlichen Parametern aufgerufen werden.
	# db_backuptabellen "mein_benutzer" "geheim123" "meine_datenbank"
##
function db_backuptabellen() {
	# Hier fehlt noch das die Asset Datenbank gesplittet wird.
	username=$1
	password=$2
	databasename=$3 #tabellenname=$3;
	#DATEIDATUM=$(date +%d_%m_%Y);

	# Verzeichnis erstellen:
	mkdir -p /$STARTVERZEICHNIS/backup/"$databasename" || exit
	# Tabellennamen holen.
	mysqlrest "$username" "$password" "$databasename" "SHOW TABLES FROM $databasename"
	# Tabellennamen in eine Datei schreiben.
	echo "$result_mysqlrest" >/$STARTVERZEICHNIS/backup/"$databasename"/liste.txt

	tabellenname=()
	while IFS= read -r tabellenname; do
		sleep 10
		mysqldump -u"$username" -p"$password" "$databasename" "$tabellenname" | zip >/$STARTVERZEICHNIS/backup/"$databasename"/"$tabellenname".sql.zip
		log info "Datenbank Tabelle: $databasename - $tabellenname wurde gesichert."
	done </$STARTVERZEICHNIS/backup/"$databasename"/liste.txt

	return 0
}

## *  db_backuptabelle_noassets
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht es dem Benutzer, alle Tabellen einer MySQL-Datenbank, außer der Tabelle "assets", zu sichern und als ZIP-Archive zu speichern.
	# Die Funktion erfordert Benutzername, Passwort und den Namen der zu sichernden Datenbank.
	# Es wird ein Verzeichnis für das Backup erstellt, und für jede ausgewählte Tabelle wird ein separates ZIP-Archiv erstellt.
	#? Parameter:
	# $1: Benutzername für die Datenbank
	# $2: Passwort für die Datenbank
	# $3: Name der Datenbank, deren Tabellen (außer "assets") gesichert werden sollen
	#? Beispielaufruf:
	# Die Funktion sollte mit den erforderlichen Parametern aufgerufen werden.
	# db_backuptabelle_noassets "mein_benutzer" "geheim123" "meine_datenbank"
##
function db_backuptabelle_noassets() {
	# Hier fehlt noch das die Asset Datenbank gesplittet wird.
	username=$1
	password=$2
	databasename=$3 #tabellenname=$3;
	#DATEIDATUM=$(date +%d_%m_%Y);

	# Verzeichnis erstellen:
	mkdir -p /$STARTVERZEICHNIS/backup/"$databasename" || exit
	# Tabellennamen holen.
	mysqlrest "$username" "$password" "$databasename" "SHOW TABLES FROM $databasename"
	# Tabellennamen in eine Datei schreiben.
	echo "$result_mysqlrest" >/$STARTVERZEICHNIS/backup/"$databasename"/liste.txt

	tabellenname=()
	while IFS= read -r tabellenname; do
		sleep 10

	if [[ "${tabellenname}" != "assets" ]]; then
		mysqldump -u"$username" -p"$password" "$databasename" "$tabellenname" | zip >/$STARTVERZEICHNIS/backup/"$databasename"/"$tabellenname".sql.zip
		log info "Datenbank Tabelle: $databasename - $tabellenname wurde gesichert."
	fi		
		
	done </$STARTVERZEICHNIS/backup/"$databasename"/liste.txt

	return 0
}

## *  db_backuptabellentypen
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht es dem Benutzer, verschiedene Arten von Assets aus der MySQL-Datenbank "assets" zu sichern und als ZIP-Archive zu speichern.
	# Die Funktion erfordert Benutzername, Passwort und den Namen der Datenbank, die gesichert werden soll. Sie kann auch verschiedene Asset-Typen (z.B. Texturen, Klänge, Objekte) aus der Datenbank auswählen und speichern.
	# Das Verzeichnis für das Backup wird erstellt, und für jeden ausgewählten Asset-Typ wird ein separates ZIP-Archiv erstellt.
	#? Parameter:
	# $1: Benutzername für die Datenbank
	# $2: Passwort für die Datenbank
	# $3: Name der Datenbank, die gesichert werden soll
	# $fromtable: Der Name der Tabelle, aus der die Daten gesichert werden sollen (Standardwert: "assets")
	# $fromtypes: Der Name der Spalte, die die Asset-Typen enthält (Standardwert: "assetType")
	# $dbcompress: Option zum Komprimieren der SQL-Dateien in ZIP-Archive ("ja" oder "nein", Standardwert: "ja")
	#? Beispielaufruf:
	# Die Funktion sollte mit den erforderlichen Parametern aufgerufen werden.
	# db_backuptabellentypen "mein_benutzer" "geheim123" "meine_datenbank" "assets" "assetType" "ja"
##
function db_backuptabellentypen() {
	username=$1
	password=$2
	databasename=$3
	fromtable="assets"
	fromtypes="assetType"
	dbcompress="ja"

	log info "Backup, Asset Datenbank Tabelle geteilt in Typen speichern."
	# Verzeichnis erstellen:
	mkdir -p /$STARTVERZEICHNIS/backup/"$databasename" || exit
	# Schreibrechte
	#chmod -R 777 /$STARTVERZEICHNIS/backup/"$databasename"
	cd /$STARTVERZEICHNIS/backup/"$databasename" || exit

	# Tabellen schema aus der Datenbank holen.
	#mysqldump -u"$username" -p"$password" --no-data "$databasename" "$fromtable" > /$STARTVERZEICHNIS/backup/$databasename/"$databasename".sql

	# Datenbank sichern
	# mysqldump -u"$username" -p"$password" "$databasename" '$tabellenname'" | zip >/$STARTVERZEICHNIS/backup/"$databasename"/"$tabellenname".sql.zip;

	# Asset Typen aus Datenbank holen.
	mysqlrest "$username" "$password" "$databasename" "SELECT $fromtypes FROM $fromtable WHERE $fromtypes"
	# Nächste Zeile löscht doppelte einträge und speichert dies unter $fromtypes.txt
	log info "$result_mysqlrest" | sort | uniq >/$STARTVERZEICHNIS/backup/"$databasename"/$fromtypes.txt

	tabellenname=()
	while IFS= read -r tabellenname; do
		sleep 1
		if [ "$tabellenname" = "-1" ]; then dateiname="NoneUnknown"; fi
		if [ "$tabellenname" = "-2" ]; then dateiname="LLmaterialIAR"; fi
		if [ "$tabellenname" = "0" ]; then dateiname="Texture"; fi
		if [ "$tabellenname" = "1" ]; then dateiname="Sound"; fi
		if [ "$tabellenname" = "2" ]; then dateiname="CallingCard"; fi
		if [ "$tabellenname" = "3" ]; then dateiname="Landmark"; fi
		if [ "$tabellenname" = "4" ]; then dateiname="Unknown4"; fi
		if [ "$tabellenname" = "5" ]; then dateiname="Clothing"; fi
		if [ "$tabellenname" = "6" ]; then dateiname="Object"; fi
		if [ "$tabellenname" = "7" ]; then dateiname="Notecard"; fi
		if [ "$tabellenname" = "8" ]; then dateiname="Folder"; fi
		if [ "$tabellenname" = "9" ]; then dateiname="Unknown9"; fi
		if [ "$tabellenname" = "10" ]; then dateiname="LSLText"; fi
		if [ "$tabellenname" = "11" ]; then dateiname="LSLBytecode"; fi
		if [ "$tabellenname" = "12" ]; then dateiname="TextureTGA"; fi
		if [ "$tabellenname" = "13" ]; then dateiname="Bodypart"; fi
		if [ "$tabellenname" = "14" ]; then dateiname="Unknown14"; fi
		if [ "$tabellenname" = "15" ]; then dateiname="Unknown15"; fi
		if [ "$tabellenname" = "16" ]; then dateiname="Unknown16"; fi
		if [ "$tabellenname" = "17" ]; then dateiname="SoundWAV"; fi
		if [ "$tabellenname" = "18" ]; then dateiname="ImageTGA"; fi
		if [ "$tabellenname" = "19" ]; then dateiname="ImageJPEG"; fi
		if [ "$tabellenname" = "20" ]; then dateiname="Animation"; fi
		if [ "$tabellenname" = "21" ]; then dateiname="Gesture"; fi
		if [ "$tabellenname" = "22" ]; then dateiname="Simstate"; fi
		if [ "$tabellenname" = "23" ]; then dateiname="Unknown23"; fi
		if [ "$tabellenname" = "24" ]; then dateiname="Link"; fi
		if [ "$tabellenname" = "25" ]; then dateiname="LinkFolder"; fi
		if [ "$tabellenname" = "26" ]; then dateiname="MarketplaceFolder"; fi
		if [ "$tabellenname" = "49" ]; then dateiname="Mesh"; fi
		if [ "$tabellenname" = "56" ]; then dateiname="Settings"; fi
		if [ "$tabellenname" = "57" ]; then dateiname="Material"; fi


		log info "Asset Backup aller Daten von $fromtypes=$tabellenname das sind die $dateiname assets"

		if [ "$dbcompress" = "nein" ]
		then 
		log info "Exportiere Datei $dateiname.sql";
		mysqldump -u"$username" -p"$password" "$databasename" --tables assets --where="$fromtypes = '$tabellenname'" > $dateiname.sql;
		fi

		if [ "$dbcompress" = "ja" ]
		then 
		log info "Exportiere Datei $dateiname.sql.zip";
		mysqldump -u"$username" -p"$password" "$databasename" --tables assets --where="$fromtypes = '$tabellenname'" | zip >/$STARTVERZEICHNIS/backup/"$databasename"/"$dateiname".sql.zip;
		fi

	done </$STARTVERZEICHNIS/backup/"$databasename"/$fromtypes.txt
	# Schreibrechte zurücksetzen
	#chmod -R 755 /$STARTVERZEICHNIS/backup/"$databasename"
	return 0
}

## *  db_restorebackuptabellen
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht es dem Benutzer, zuvor gesicherte Datenbanktabellen aus ZIP-Archiven in eine neue Datenbank wiederherzustellen.
	# Die Funktion erfordert Benutzername, Passwort und den Namen der Datenbank, aus der die Tabellen wiederhergestellt werden sollen, sowie den Namen der neuen Datenbank.
	# Die Funktion durchläuft die Liste der gesicherten Tabellen, extrahiert die Daten aus den ZIP-Archiven und stellt sie in der neuen Datenbank wieder her.
	#? Parameter:
	# $1: Benutzername für die Datenbank
	# $2: Passwort für die Datenbank
	# $3: Name der Datenbank, aus der die Tabellen wiederhergestellt werden sollen
	# $4: Name der neuen Datenbank, in die die Tabellen wiederhergestellt werden sollen
	#? Beispielaufruf:
	# Die Funktion sollte mit den erforderlichen Parametern aufgerufen werden.
	# db_restorebackuptabellen "mein_benutzer" "geheim123" "gesicherte_datenbank" "neue_datenbank"
##
function db_restorebackuptabellen() {
	username=$1
	password=$2
	databasename=$3
	newdatabasename=$4

	cd /$STARTVERZEICHNIS/backup/"$databasename" || exit

	tabellenname=()
	while IFS= read -r tabellenname; do
		sleep 1
		unzip -p /"$STARTVERZEICHNIS"/backup/"$databasename"/"$tabellenname".sql.zip | mysql >MYSQL_PWD="$password" -u"$username" "$newdatabasename"
		log info "Datenbank Tabelle: $newdatabasename - $tabellenname widerhergestellt."
	done </$STARTVERZEICHNIS/backup/"$databasename"/liste.txt

	return 0
}

## *  db_create
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion erstellt eine neue MySQL-Datenbank. Der Benutzer wird nach Benutzername, Passwort und dem Namen der neuen Datenbank gefragt.
	# Die Funktion prüft, ob das Dialog-Paket installiert ist, und verwendet es, um die Eingaben zu erfassen, falls verfügbar. Andernfalls werden die Parameter als Argumente erwartet.
	# Nach der Erstellung der Datenbank gibt die Funktion entsprechende Meldungen aus.
	#? Parameter:
	# $1: Benutzername für den Datenbankzugriff
	# $2: Passwort für den Datenbankzugriff
	# $3: Name der neuen Datenbank
	#? Beispielaufruf:
	# Die Funktion sollte mit den erforderlichen Parametern aufgerufen werden.
	# db_create "mein_benutzer" "geheim123" "neue_datenbank"
##
function db_create() {
	# Prüfen, ob das Dialog-Paket installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then

		# Einstellungen für den Dialog
		boxbacktitel="opensimMULTITOOL"
		boxtitel="opensimMULTITOOL Eingabe"
		formtitle="Neue Datenbank erstellen"
		lable1="Benutzername:"
		lablename1=""
		lable2="Passwort:"
		lablename2=""
		lable3="Datenbankname:"
		lablename3=""

		# Benutzereingabe abfragen
		db_regionsportBOXERGEBNIS=$(dialog --backtitle "$boxbacktitel" --title "$boxtitel" --form "$formtitle" 25 60 16 "$lable1" 1 1 "$lablename1" 1 25 25 30 "$lable2" 2 1 "$lablename2" 2 25 25 30 "$lable3" 3 1 "$lablename3" 3 25 25 30 3>&1 1>&2 2>&3 3>&-)

		# Zeilen aus der Benutzereingabe in verschiedene Variablen schreiben
		username=$(echo "$db_regionsportBOXERGEBNIS" | sed -n '1p')
		password=$(echo "$db_regionsportBOXERGEBNIS" | sed -n '2p')
		databasename=$(echo "$db_regionsportBOXERGEBNIS" | sed -n '3p')

		# Alles im Dialogfenster löschen
		dialogclear
		ScreenLog
	else
		# Falls das Dialog-Paket nicht verfügbar ist, Parameter verwenden
		username=$1
		password=$2
		databasename=$3
	fi

	log text "CREATE DATABASE: Datenbank anlegen."
	#result_mysqlrest=$("CREATE DATABASE IF NOT EXISTS $databasename CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci" | MYSQL_PWD=$password mysql -u"$username" "$databasename" -N) 2> /dev/null
	#mysqlrest "$username" "$password" "$databasename" "CREATE DATABASE IF NOT EXISTS $databasename CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci"
	echo "CREATE DATABASE IF NOT EXISTS $databasename CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" | MYSQL_PWD=$password mysql -u"$username" -N
	log text "CREATE DATABASE: Datenbank $databasename wurde angelegt."

	# Das sollte benutzt werden:
	# CREATE DATABASE mydb CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
	# Beachten Sie, dass utf8_general_ci nicht mehr als bewaehrte Methode empfohlen wird.

	# Ausgabe zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then
		warnbox "$result_mysqlrest"
	else
		log rohtext "$result_mysqlrest"
	fi

	return 0
}

## *  db_dbuser
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion zeigt alle Datenbankbenutzer in einer MySQL-Datenbank an.
	#? Parameter:
	# $1: Benutzername für den Datenbankzugriff
	# $2: Passwort für den Datenbankzugriff
	#? Beispielaufruf:
	# Die Funktion sollte mit den erforderlichen Parametern aufgerufen werden.
	# db_dbuser "mein_benutzer" "geheim123"
##
function db_dbuser() {
	username=$1
	password=$2

	log text "PRINT DATABASE: Alle Datenbankbenutzer anzeigen."
	result_mysqlrest=$(echo "select User from mysql.user;" | MYSQL_PWD=$password mysql -u"$username" -N) 2>/dev/null
	log rohtext "$result_mysqlrest"

	return 0
}

## *  db_dbuserrechte
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion listet die Rechte eines bestimmten Benutzers in einer MySQL-Datenbank auf.
	#? Parameter:
	# $1: Benutzername für den Datenbankzugriff
	# $2: Passwort für den Datenbankzugriff
	# $3: Benutzername, für den die Rechte aufgelistet werden sollen
	#? Beispielaufruf:
	# Die Funktion sollte mit den erforderlichen Parametern aufgerufen werden.
	# db_dbuserrechte "mein_benutzer" "geheim123" "ziel_benutzer"
##
function db_dbuserrechte() {
	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then

		# Einstellungen
		boxbacktitel="opensimMULTITOOL"
		boxtitel="opensimMULTITOOL Eingabe"
		formtitle="Listet alle erstellten Benutzerrechte auf"
		lable1="Benutzername:"
		lablename1=""
		lable2="Passwort:"
		lablename2=""
		lable3="Datenbankname:"
		lablename3=""

		# Abfrage
		db_dbuserrechteERGEBNIS=$(dialog --backtitle "$boxbacktitel" --title "$boxtitel" --form "$formtitle" 25 60 16 "$lable1" 1 1 "$lablename1" 1 25 25 30 "$lable2" 2 1 "$lablename2" 2 25 25 30 "$lable3" 3 1 "$lablename3" 3 25 25 30 3>&1 1>&2 2>&3 3>&-)

		# Zeilen aus einer Variablen zerlegen und in verschiedenen Variablen schreiben.
		username=$(echo "db_dbuserrechteERGEBNIS" | sed -n '1p')
		password=$(echo "$db_dbuserrechteERGEBNIS" | sed -n '2p')
		databasename=$(echo "$db_dbuserrechteERGEBNIS" | sed -n '3p')

		# Alles loeschen.
		dialogclear
		ScreenLog
	else
		# Alle Aktionen ohne dialog
		username=$1
		password=$2
		databasename=$3
	fi # dialog Aktionen Ende

	result_mysqlrest=$(echo "SHOW GRANTS FOR '$benutzer'@'localhost';" | MYSQL_PWD=$password mysql -u"$username" -N) 2>/dev/null

	# Ausgabe zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then
		warnbox "$result_mysqlrest"
	else
		log info "$result_mysqlrest"
	fi

	return 0
}

## *  db_deldbuser
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion löscht einen Datenbankbenutzer in MySQL.
	#? Parameter:
	# $1: Master-Benutzername für den Datenbankzugriff
	# $2: Master-Passwort für den Datenbankzugriff
	# $3: Benutzername, der gelöscht werden soll
	#? Beispielaufruf:
	# Die Funktion sollte mit den erforderlichen Parametern aufgerufen werden.
	# db_deldbuser "root" "geheim123" "zu_loeschender_benutzer"
##
function db_deldbuser() {
	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then

		# Einstellungen
		boxbacktitel="opensimMULTITOOL"
		boxtitel="opensimMULTITOOL Eingabe"
		formtitle="Loescht einen Datenbankbenutzer"
		lable1="Master Benutzername:"
		lablename1=""
		lable2="Master Passwort:"
		lablename2=""
		lable3="Zu loeschender Benutzer:"
		lablename3=""

		# Abfrage
		db_deldbuserERGEBNIS=$(dialog --backtitle "$boxbacktitel" --title "$boxtitel" --form "$formtitle" 25 60 16 "$lable1" 1 1 "$lablename1" 1 25 25 30 "$lable2" 2 1 "$lablename2" 2 25 25 30 "$lable3" 3 1 "$lablename3" 3 25 25 30 3>&1 1>&2 2>&3 3>&-)

		# Zeilen aus einer Variablen zerlegen und in verschiedenen Variablen schreiben.
		username=$(echo "$db_deldbuserERGEBNIS" | sed -n '1p')
		password=$(echo "$db_deldbuserERGEBNIS" | sed -n '2p')
		benutzer=$(echo "$db_deldbuserERGEBNIS" | sed -n '3p')

		# Alles loeschen.
		dialogclear
		ScreenLog
	else
		# Alle Aktionen ohne dialog
		username=$1
		password=$2
		benutzer=$3
	fi # dialog Aktionen Ende

	#echo "DROP USER '$benutzer'@'localhost';" | MYSQL_PWD=$password mysql -u"$username" -N

	if [ -z "$benutzer" ]; then
		# Variable leer dann beenden.
		mySQLmenu
		return 0
	else
		# Variable befuellt dann Befehl ausfuehren.
		echo "DROP USER '$benutzer'@'localhost';" | MYSQL_PWD=$password mysql -u"$username" -N
	fi

	# Ausgabe zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then
		warnbox "Datenbankbenutzer $benutzer geloescht"
	else
		log info "Benutzer loeschen: Datenbankbenutzer $benutzer geloescht"
	fi

	return 0
}

## *  db_create_new_dbuser
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion erstellt einen neuen Datenbankbenutzer in MySQL und gewährt ihm alle Berechtigungen für alle Datenbanken.
	#? Parameter:
	# $1: Master-Benutzername für den Datenbankzugriff
	# $2: Master-Passwort für den Datenbankzugriff
	# $3: Neuer Benutzername, der erstellt werden soll
	# $4: Passwort für den neuen Benutzer
	#? Beispielaufruf:
	# Die Funktion sollte mit den erforderlichen Parametern aufgerufen werden.
	# db_create_new_dbuser "root" "geheim123" "neuer_benutzer" "neues_passwort"
##
function db_create_new_dbuser() {
	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then

		# Einstellungen
		boxbacktitel="opensimMULTITOOL"
		boxtitel="opensimMULTITOOL Eingabe"
		formtitle="Neuen Datenbankbenutzer anlegen"
		lable1="Benutzername:"
		lablename1=""
		lable2="Passwort:"
		lablename2=""
		lable3="Neuer Benutzer:"
		lablename3=""
		lable4="Neues Passwort:"
		lablename4=""

		# Abfrage
		loadinventarBOXERGEBNIS=$(dialog --backtitle "$boxbacktitel" --title "$boxtitel" --form "$formtitle" 25 60 16 "$lable1" 1 1 "$lablename1" 1 25 25 30 "$lable2" 2 1 "$lablename2" 2 25 25 30 "$lable3" 3 1 "$lablename3" 3 25 25 30 "$lable4" 4 1 "$lablename4" 4 25 25 30 3>&1 1>&2 2>&3 3>&-)

		# Zeilen aus einer Variablen zerlegen und in verschiedenen Variablen schreiben.
		username=$(echo "$loadinventarBOXERGEBNIS" | sed -n '1p')
		password=$(echo "$loadinventarBOXERGEBNIS" | sed -n '2p')
		NEUERNAME=$(echo "$loadinventarBOXERGEBNIS" | sed -n '3p')
		NEUESPASSWORT=$(echo "$loadinventarBOXERGEBNIS" | sed -n '4p')

		# Alles loeschen.
		dialogclear
		ScreenLog
	else
		# Alle Aktionen ohne dialog
		username=$1
		password=$2
		NEUERNAME=$3
		NEUESPASSWORT=$4
	fi # dialog Aktionen Ende

	echo "CREATE USER $NEUERNAME@'localhost' IDENTIFIED BY '$NEUESPASSWORT';" | MYSQL_PWD=$password mysql -u"$username" -N
	echo "GRANT ALL PRIVILEGES ON * . * TO '$NEUERNAME'@'localhost';" | MYSQL_PWD=$password mysql -u"$username" -N
	echo "flush privileges;" | MYSQL_PWD=$password mysql -u"$username" -N

	# Ausgabe zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then
		warnbox "Datenbankbenutzer $NEUERNAME anleglegt"
	else
		log info "Datenbankbenutzer $NEUERNAME anleglegt"
	fi

	return 0
}

## *  createdatabase
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion erstellt eine neue MySQL-Datenbank mit den angegebenen Parametern.
	#? Parameter:
	# $1 (DBNAME): Der Name der zu erstellenden Datenbank.
	# $2 (DBUSER): Der Benutzername für den Datenbankzugriff.
	# $3 (DBPASSWD): Das Passwort für den Benutzerzugriff auf die Datenbank.
	#? Beispielaufruf:
	# Die Funktion sollte mit den erforderlichen Parametern aufgerufen werden.
	# createdatabase "meine_datenbank" "mein_benutzer" "geheim123"
	#? Rückgabewert:
	# Die Funktion gibt keinen expliziten Rückgabewert zurück.
	#? Hinweise:
	# - Die Funktion überprüft, ob die erforderlichen Parameter (Datenbankname, Benutzername und Passwort) angegeben wurden.
	# - Wenn einer der Parameter fehlt, wird die Funktion beendet und eine Fehlermeldung wird protokolliert.
	# - Andernfalls wird die Datenbank mit dem angegebenen Namen erstellt und verwendet.
	# - Die Funktion verwendet den MySQL-Client im nicht-interaktiven Modus und gibt keine Ausgabe auf der Konsole aus.
##
function createdatabase() {
    # Übergabeparameter
    DBNAME=$1
    DBUSER=$2
    DBPASSWD=$3

    # Abbruch bei fehlender Parameterangabe.
    if [ "$DBNAME" = "" ]; then log rohtext "Datenbankname fehlt"; exit 1; fi
    if [ "$DBUSER" = "" ]; then log rohtext "Benutzername fehlt"; exit 1; fi
    if [ "$DBPASSWD" = "" ]; then log rohtext "Datenbankpasswort fehlt"; exit 1; fi

    # Ausführung
    mysql -u "$DBUSER" -pDBPASSWD <<EOF
CREATE DATABASE ${DBNAME};
USE ${DBNAME};
EOF
    # Dadurch, dass der MySQL-Client im nicht-interaktiven Modus ausgeführt wird, 
    # kannst du die quit-Anweisung am Ende weglassen.
    return 0
}

## *  createdbuser
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion erstellt einen neuen Datenbankbenutzer und gewährt ihm alle Berechtigungen.
	#? Parameter:
	# $1 (ROOTUSER): Der Benutzername des Root-Datenbankbenutzers, der die Berechtigungen gewährt.
	# $2 (ROOTPASSWD): Das Passwort des Root-Datenbankbenutzers.
	# $3 (NEWDBUSER): Der Name des neuen Datenbankbenutzers, der erstellt werden soll.
	# $4 (NEWDBPASSWD): Das Passwort für den neuen Datenbankbenutzer.
	#? Beispielaufruf:
	# Die Funktion sollte mit den erforderlichen Parametern aufgerufen werden.
	# createdbuser "root" "geheimes_root_passwort" "neuer_benutzer" "neues_passwort"
	#? Rückgabewert:
	# Die Funktion gibt keinen expliziten Rückgabewert zurück.
	#? Hinweise:
	# - Die Funktion überprüft, ob die erforderlichen Parameter (Root-Benutzername, Root-Passwort, neuer Benutzername und neues Passwort) angegeben wurden.
	# - Wenn einer der Parameter fehlt, wird die Funktion beendet und eine Fehlermeldung wird protokolliert.
	# - Andernfalls wird ein neuer Datenbankbenutzer mit dem angegebenen Namen und Passwort erstellt und ihm alle Berechtigungen gewährt.
	# - Die Funktion verwendet den MySQL-Client im nicht-interaktiven Modus und gibt keine Ausgabe auf der Konsole aus.
##
function createdbuser() {
    # Übergabeparameter
    ROOTUSER=$1
    ROOTPASSWD=$2
    NEWDBUSER=$3
    NEWDBPASSWD=$4


    # Abbruch bei fehlender Parameterangabe.
    if [ "$ROOTUSER" = "" ]; then log rohtext "Root Datenbankbenutzername fehlt"; exit 1; fi
    if [ "$ROOTPASSWD" = "" ]; then log rohtext "Root Datenbankpasswort fehlt"; exit 1; fi
    if [ "$NEWDBUSER" = "" ]; then log rohtext "Neuer Benutzername fehlt"; exit 1; fi
    if [ "$NEWDBPASSWD" = "" ]; then log rohtext "Neues Datenbankpasswort fehlt"; exit 1; fi
    

    # Ausführung
    mysql -u "$ROOTUSER" -pROOTPASSWD <<EOF
CREATE USER "${NEWDBUSER}"@"localhost" IDENTIFIED BY "${NEWDBPASSWD}";
GRANT ALL ON *.* to "${NEWDBUSER}"@"localhost";
EOF
    # Dadurch, dass der MySQL-Client im nicht-interaktiven Modus ausgeführt wird, 
    # kannst du die quit-Anweisung am Ende weglassen.
    return 0
}

## *  db_delete
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion löscht eine Datenbank vollständig. Sie fordert den Benutzer zur Eingabe von
	# Benutzername, Passwort und Datenbankname auf und führt dann das Löschen der Datenbank aus.
	#? Parameter:
	# $1 (username): Benutzername für den Datenbankzugriff
	# $2 (password): Passwort für den Datenbankzugriff
	# $3 (databasename): Name der zu löschenden Datenbank
	#? Beispielaufruf:
	# Die Funktion kann mit den erforderlichen Parametern aufgerufen werden.
	# db_delete "mein_benutzer" "geheim123" "zu_loeschende_datenbank"
	#? Rückgabewert:
	# Die Funktion gibt keinen expliziten Rückgabewert zurück.
	#? Hinweise:
	# - Die Funktion überprüft, ob das Dialog-Programm installiert ist. Wenn ja, verwendet sie ein Dialogfeld zur Benutzereingabe, 
	#   um die erforderlichen Informationen abzurufen. Andernfalls können die Parameter direkt an die Funktion übergeben werden.
	# - Vor dem Löschen wird sichergestellt, dass die angegebene Datenbank existiert. Wenn die Datenbank nicht existiert, wird 
	#   kein Löschvorgang durchgeführt.
	# - Das Löschen der Datenbank erfolgt, indem der SQL-Befehl "DROP DATABASE" ausgeführt wird.
	# - Die Funktion gibt eine Erfolgsmeldung aus, wenn die Datenbank erfolgreich gelöscht wurde.
##
function db_delete() {
	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then

		# Einstellungen
		boxbacktitel="opensimMULTITOOL"
		boxtitel="opensimMULTITOOL Eingabe"
		formtitle="Loescht eine Datenbank komplett"
		lable1="Benutzername:"
		lablename1=""
		lable2="Passwort:"
		lablename2=""
		lable3="Datenbankname:"
		lablename3=""

		# Abfrage
		db_deleteERGEBNIS=$(dialog --backtitle "$boxbacktitel" --title "$boxtitel" --form "$formtitle" 25 60 16 "$lable1" 1 1 "$lablename1" 1 25 25 30 "$lable2" 2 1 "$lablename2" 2 25 25 30 "$lable3" 3 1 "$lablename3" 3 25 25 30 3>&1 1>&2 2>&3 3>&-)

		# Zeilen aus einer Variablen zerlegen und in verschiedenen Variablen schreiben.
		username=$(echo "$db_deleteERGEBNIS" | sed -n '1p')
		password=$(echo "$db_deleteERGEBNIS" | sed -n '2p')
		databasename=$(echo "$db_deleteERGEBNIS" | sed -n '3p')

		# Alles loeschen.
		dialogclear
		ScreenLog
	else
		# Alle Aktionen ohne dialog
		username=$1
		password=$2
		databasename=$3
	fi # dialog Aktionen Ende

	# Vor dem Loeschen sicherzustellen dass die Datenbank existiert.
	echo "DROP DATABASE IF EXISTS $databasename;" | MYSQL_PWD=$password mysql -u"$username" -N

	# Ausgabe zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then
		warnbox "Datenbank $databasename wurde geloescht"
	else
		log info "DELETE DATABASE: Datenbank $databasename wurde geloescht"
	fi

	return 0
}

## *  tabellenabfrage
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion führt eine Abfrage aus, um alle Tabellen in einer angegebenen MySQL-Datenbank anzuzeigen.
	#? Parameter:
	# $1 (DBBENUTZER): Benutzername für den Datenbankzugriff
	# $2 (DBPASSWORT): Passwort für den Datenbankzugriff
	# $3 (DATENBANKNAME): Name der Datenbank, deren Tabellen abgefragt werden sollen
	#? Beispielaufruf:
	# Die Funktion sollte mit den erforderlichen Parametern aufgerufen werden.
	# tabellenabfrage "mein_benutzer" "geheim123" "meine_datenbank"
	#? Rückgabewert:
	# Die Funktion gibt die Liste der Tabellennamen in der angegebenen Datenbank aus.
	#? Hinweise:
	# - Die Funktion verwendet die MySQL-Client-Anwendung, um eine Abfrage auszuführen.
	# - Sie stellt sicher, dass die Tabellen in der angegebenen Datenbank existieren, bevor sie die Abfrage ausführt.
##
function tabellenabfrage() {
	DBBENUTZER=$1
	DBPASSWORT=$2
	DATENBANKNAME=$3

	mysql -u"$DBBENUTZER" -p"$DBPASSWORT" <<MEINE_ABFRAGE_ENDE 2>/dev/null
USE $DATENBANKNAME
SHOW tables
MEINE_ABFRAGE_ENDE

	return 0
}

## *  regionsabfrage
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion führt eine Abfrage aus, um alle Regionen (regionName) in einer angegebenen MySQL-Datenbank anzuzeigen.
	#? Parameter:
	# $1 (DBBENUTZER): Benutzername für den Datenbankzugriff
	# $2 (DBPASSWORT): Passwort für den Datenbankzugriff
	# $3 (DATENBANKNAME): Name der Datenbank, deren Regionen abgefragt werden sollen
	#? Beispielaufruf:
	# Die Funktion sollte mit den erforderlichen Parametern aufgerufen werden.
	# regionsabfrage "mein_benutzer" "geheim123" "meine_datenbank"
	#? Rückgabewert:
	# Die Funktion gibt eine Liste der Regionen (regionName) in der angegebenen Datenbank aus.
	#? Hinweise:
	# - Die Funktion verwendet die MySQL-Client-Anwendung, um eine Abfrage auszuführen.
	# - Stellen Sie sicher, dass die Tabelle "regions" in der angegebenen Datenbank existiert, bevor Sie die Funktion aufrufen.
##
function regionsabfrage() {
	DBBENUTZER=$1
	DBPASSWORT=$2
	DATENBANKNAME=$3
	mysql -u"$DBBENUTZER" -p"$DBPASSWORT" <<MEIN_ABFRAGE_ENDE 2>/dev/null
USE $DATENBANKNAME
SELECT regionName FROM regions
MEIN_ABFRAGE_ENDE

	return 0
}

## *  regionsuri
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion führt eine Abfrage aus, um die Regionen (regionName) und ihre Server-URIs (serverURI) in einer angegebenen MySQL-Datenbank abzurufen und nach serverURI zu sortieren.
	#? Parameter:
	# $1 (DBBENUTZER): Benutzername für den Datenbankzugriff
	# $2 (DBPASSWORT): Passwort für den Datenbankzugriff
	# $3 (DATENBANKNAME): Name der Datenbank, deren Regionen und URIs abgefragt werden sollen
	#? Beispielaufruf:
	# Die Funktion sollte mit den erforderlichen Parametern aufgerufen werden.
	# regionsuri "mein_benutzer" "geheim123" "meine_datenbank"
	#? Rückgabewert:
	# Die Funktion gibt eine Liste von Regionen (regionName) und ihren Server-URIs (serverURI) aus der angegebenen Datenbank aus, sortiert nach serverURI.
	#? Hinweise:
	# - Die Funktion verwendet die MySQL-Client-Anwendung, um eine Abfrage auszuführen.
	# - Stellen Sie sicher, dass die Tabelle "regions" in der angegebenen Datenbank existiert, bevor Sie die Funktion aufrufen.
##
function regionsuri() {
	DBBENUTZER=$1
	DBPASSWORT=$2
	DATENBANKNAME=$3
	mysql -u"$DBBENUTZER" -p"$DBPASSWORT" <<MEIN_ABFRAGE_ENDE 2>/dev/null
USE $DATENBANKNAME
SELECT regionName , serverURI FROM regions ORDER BY serverURI
MEIN_ABFRAGE_ENDE

	return 0
}

## *  regionsport
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion führt eine Abfrage aus, um die Regionen (regionName) und ihre Server-Ports (serverPort) in einer angegebenen MySQL-Datenbank abzurufen und nach serverPort zu sortieren.
	#? Parameter:
	# $1 (DBBENUTZER): Benutzername für den Datenbankzugriff
	# $2 (DBPASSWORT): Passwort für den Datenbankzugriff
	# $3 (DATENBANKNAME): Name der Datenbank, deren Regionen und Ports abgefragt werden sollen
	#? Beispielaufruf:
	# Die Funktion sollte mit den erforderlichen Parametern aufgerufen werden.
	# regionsport "mein_benutzer" "geheim123" "meine_datenbank"
	#? Rückgabewert:
	# Die Funktion gibt eine Liste von Regionen (regionName) und ihren Server-Ports (serverPort) aus der angegebenen Datenbank aus, sortiert nach serverPort.
	#? Hinweise:
	# - Die Funktion verwendet die MySQL-Client-Anwendung, um eine Abfrage auszuführen.
	# - Stellen Sie sicher, dass die Tabelle "regions" in der angegebenen Datenbank existiert, bevor Sie die Funktion aufrufen.
##
function regionsport() {
	DBBENUTZER=$1
	DBPASSWORT=$2
	DATENBANKNAME=$3
	mysql -u"$DBBENUTZER" -p"$DBPASSWORT" <<MEIN_ABFRAGE_ENDE 2>/dev/null
USE $DATENBANKNAME
SELECT regionName , serverPort FROM regions ORDER BY serverPort
MEIN_ABFRAGE_ENDE

	return 0
}

## *  setpartner
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion aktualisiert den Partner eines Avatars in einer angegebenen MySQL-Datenbank.
	#? Parameter:
	# $1 (DBBENUTZER): Benutzername für den Datenbankzugriff
	# $2 (DBPASSWORT): Passwort für den Datenbankzugriff
	# $3 (DATENBANKNAME): Name der Datenbank, in der die Aktualisierung durchgeführt werden soll
	# $4 (AVATARUUID): UUID des Avatars, dessen Partner aktualisiert werden soll
	# $5 (NEUERPARTNER): UUID des neuen Partners, der zugewiesen werden soll
	#? Beispielaufruf:
	# Die Funktion sollte mit den erforderlichen Parametern aufgerufen werden.
	# setpartner "mein_benutzer" "geheim123" "meine_datenbank" "12345678-1234-5678-1234-567812345678" "87654321-5678-1234-5678-123456789012"
	#? Rückgabewert:
	# Die Funktion aktualisiert den Partner des angegebenen Avatars in der Datenbank und gibt eine Erfolgsmeldung aus.
	#? Hinweise:
	# - Stellen Sie sicher, dass die Tabelle "userprofile" in der angegebenen Datenbank existiert, bevor Sie die Funktion aufrufen.
##
function setpartner() {
	DBBENUTZER=$1
	DBPASSWORT=$2
	DATENBANKNAME=$3
	AVATARUUID=$4
	NEUERPARTNER=$5

	LEEREMPTY="00000000-0000-0000-0000-000000000000"
	echo "$LEEREMPTY"

	#  2>/dev/null
	mysql -u"$DBBENUTZER" -p"$DBPASSWORT" <<MEIN_ABFRAGE_ENDE 2>/dev/null
USE $DATENBANKNAME
UPDATE userprofile SET profilePartner = '$NEUERPARTNER' WHERE userprofile.useruuid = '$AVATARUUID'
MEIN_ABFRAGE_ENDE

	log info "SETPARTNER: $NEUERPARTNER ist jetzt Partner von $AVATARUUID."
	return 0
}

## *  db_setpartner
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion aktualisiert den Partner eines Avatars in einer MySQL-Datenbank.
	#? Parameter:
	# $1 (username): Benutzername für den Datenbankzugriff
	# $2 (password): Passwort für den Datenbankzugriff
	# $3 (databasename): Name der Datenbank, in der die Aktualisierung durchgeführt werden soll
	# $4 (AVATARUUID): UUID des Avatars, dessen Partner aktualisiert werden soll
	# $5 (NEUERPARTNER): UUID des neuen Partners, der zugewiesen werden soll
	#? Beispielaufruf:
	# Die Funktion sollte mit den erforderlichen Parametern aufgerufen werden.
	# db_setpartner "mein_benutzer" "geheim123" "meine_datenbank" "12345678-1234-5678-1234-567812345678" "87654321-5678-1234-5678-123456789012"
	#? Rückgabewert:
	# Die Funktion aktualisiert den Partner des angegebenen Avatars in der Datenbank und gibt das Ergebnis der MySQL-Anfrage aus.
	#? Hinweise:
	# - Stellen Sie sicher, dass die Tabelle "userprofile" in der angegebenen Datenbank existiert, bevor Sie die Funktion aufrufen.
##
function db_setpartner() {
	username=$1
	password=$2
	databasename=$3
	AVATARUUID=$4
	NEUERPARTNER=$5

	LEEREMPTY="00000000-0000-0000-0000-000000000000"
	log text "Leere UUID um den Partner zu loeschen: $LEEREMPTY"

	log text "SETPARTNER: $NEUERPARTNER ist jetzt Partner von $AVATARUUID."
	mysqlrest "$username" "$password" "$databasename" "UPDATE userprofile SET profilePartner = '$NEUERPARTNER' WHERE userprofile.useruuid = '$AVATARUUID'"
	log info "$result_mysqlrest"

	return 0
}

## *  db_deletepartner
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion löscht den Partner eines Avatars in einer MySQL-Datenbank, indem die Partner-UUID auf eine leere UUID gesetzt wird.
	#? Parameter:
	# $1 (username): Benutzername für den Datenbankzugriff
	# $2 (password): Passwort für den Datenbankzugriff
	# $3 (databasename): Name der Datenbank, in der die Löschung durchgeführt werden soll
	# $4 (AVATARUUID): UUID des Avatars, dessen Partner gelöscht werden soll
	#? Beispielaufruf:
	# Die Funktion sollte mit den erforderlichen Parametern aufgerufen werden.
	# db_deletepartner "mein_benutzer" "geheim123" "meine_datenbank" "12345678-1234-5678-1234-567812345678"
	#? Rückgabewert:
	# Die Funktion löscht den Partner des angegebenen Avatars in der Datenbank und gibt das Ergebnis der MySQL-Anfrage aus.
	#? Hinweise:
	# - Stellen Sie sicher, dass die Tabelle "userprofile" in der angegebenen Datenbank existiert, bevor Sie die Funktion aufrufen.
##
function db_deletepartner() {
	username=$1
	password=$2
	databasename=$3
	AVATARUUID=$4

	LEEREMPTY="00000000-0000-0000-0000-000000000000"

	log text "SETPARTNER: Leere UUID um den Partner zu loeschen von $AVATARUUID."
	mysqlrest "$username" "$password" "$databasename" "UPDATE userprofile SET profilePartner = '$LEEREMPTY' WHERE userprofile.useruuid = '$AVATARUUID'"
	log info "$result_mysqlrest"

	return 0
}

## *  db_all_user
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion zeigt alle Benutzerdaten aus der Tabelle "UserAccounts" in einer MySQL-Datenbank an.
	#? Parameter:
	# $1 (username): Benutzername für den Datenbankzugriff
	# $2 (password): Passwort für den Datenbankzugriff
	# $3 (databasename): Name der Datenbank, in der die Abfrage durchgeführt werden soll
	#? Beispielaufruf:
	# Die Funktion sollte mit den erforderlichen Parametern aufgerufen werden.
	# db_all_user "mein_benutzer" "geheim123" "meine_datenbank"
	#? Rückgabewert:
	# Die Funktion gibt die Benutzerdaten aus der Tabelle "UserAccounts" in der Datenbank zurück und gibt das Ergebnis der MySQL-Anfrage aus.
	#? Hinweise:
	# - Stellen Sie sicher, dass die Tabelle "UserAccounts" in der angegebenen Datenbank existiert, bevor Sie die Funktion aufrufen.
##
function db_all_user() {
	username=$1
	password=$2
	databasename=$3
	log rohtext "Daten von allen Benutzern anzeigen:"
	echo " "
	mysqlrest "$username" "$password" "$databasename" "SELECT * FROM UserAccounts" # Alles holen und in die Variable result_mysqlrest schreiben.
	log rohtext "$result_mysqlrest"

	return 0
}

## *  db_all_user_dialog
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion zeigt alle Benutzerdaten aus der Tabelle "UserAccounts" in einer MySQL-Datenbank an.
	#? Parameter:
	# Diese Funktion verwendet einen dialogbasierten Ansatz, um Benutzername, Passwort und Datenbankname abzurufen.
	# Es erwartet keine direkten Übergabeparameter.
	#? Beispielaufruf:
	# Die Funktion sollte über das Dialogfeld mit den erforderlichen Informationen aufgerufen werden.
	# Sie fordert den Benutzer auf, den Benutzernamen, das Passwort und den Datenbanknamen einzugeben.
	# Der Benutzer kann dann die Funktion aufrufen.
	#? Rückgabewert:
	# Die Funktion zeigt die Benutzerdaten aus der Tabelle "UserAccounts" in der Datenbank an und gibt das Ergebnis der MySQL-Anfrage aus.
	#? Hinweise:
	# - Stellen Sie sicher, dass die Tabelle "UserAccounts" in der angegebenen Datenbank existiert, bevor Sie die Funktion aufrufen.
	# - Diese Funktion verwendet das Dialog-Tool, daher muss Dialog auf Ihrem System installiert sein.
##
function db_all_user_dialog() {
	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then

		# Einstellungen
		boxbacktitel="opensimMULTITOOL"
		boxtitel="opensimMULTITOOL Eingabe"
		formtitle="Daten von allen Benutzern anzeigen"
		lable1="Benutzername:"
		lablename1=""
		lable2="Passwort:"
		lablename2=""
		lable3="Datenbankname:"
		lablename3=""

		# Abfrage
		ASSETDELBOXERGEBNIS=$(dialog --backtitle "$boxbacktitel" --title "$boxtitel" --form "$formtitle" 25 60 16 "$lable1" 1 1 "$lablename1" 1 25 25 30 "$lable2" 2 1 "$lablename2" 2 25 25 30 "$lable3" 3 1 "$lablename3" 3 25 25 30 3>&1 1>&2 2>&3 3>&-)

		# Zeilen aus einer Variablen zerlegen und in verschiedenen Variablen schreiben.
		username=$(echo "$ASSETDELBOXERGEBNIS" | sed -n '1p')
		password=$(echo "$ASSETDELBOXERGEBNIS" | sed -n '2p')
		databasename=$(echo "$ASSETDELBOXERGEBNIS" | sed -n '3p')

		# Alles loeschen.
		dialogclear
		ScreenLog
	else
		# Alle Aktionen ohne dialog
		log rohtext "Keine Menuelose Funktion" | exit
	fi # dialog Aktionen Ende

	mysqlrest "$username" "$password" "$databasename" "SELECT * FROM UserAccounts" # Alles holen und in die Variable result_mysqlrest schreiben.

	warnbox "$result_mysqlrest"

	return 0
}

## *  db_all_uuid
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion zeigt alle UUIDs (PrincipalIDs) der Benutzer aus der Tabelle "UserAccounts" in einer MySQL-Datenbank an.
	#? Parameter:
	# $1: Benutzername für den Datenbankzugriff
	# $2: Passwort für den Datenbankzugriff
	# $3: Name der Datenbank
	#? Beispielaufruf:
	# Die Funktion sollte mit den erforderlichen Parametern aufgerufen werden.
	# db_all_uuid "mein_benutzer" "geheim123" "meine_datenbank"
	#? Rückgabewert:
	# Die Funktion zeigt die UUIDs der Benutzer aus der Tabelle "UserAccounts" in der Datenbank an und gibt das Ergebnis der MySQL-Anfrage aus.
	#? Hinweise:
	# - Stellen Sie sicher, dass die Tabelle "UserAccounts" in der angegebenen Datenbank existiert, bevor Sie die Funktion aufrufen.
##
function db_all_uuid() {
	username=$1
	password=$2
	databasename=$3
	log rohtext "UUID von allen Benutzern anzeigen:"
	echo " "
	mysqlrest "$username" "$password" "$databasename" "SELECT PrincipalID FROM UserAccounts"
	log rohtext "$result_mysqlrest"

	return 0
}

## *  db_all_uuid_dialog
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion zeigt alle UUIDs (PrincipalIDs) der Benutzer aus der Tabelle "UserAccounts" in einer MySQL-Datenbank an.
	# Die Benutzereingabe erfolgt über ein Dialogfeld, sofern das Dialog-Tool installiert ist.
	#? Parameter:
	# - Keine Parameter werden direkt an die Funktion übergeben. Die Funktion verwendet ein Dialogfeld zur Eingabe der Benutzerdaten.
	#? Beispielaufruf:
	# Die Funktion sollte ohne direkte Parameter aufgerufen werden. Benutzerdaten werden über das Dialogfeld eingegeben.
	# db_all_uuid_dialog
	#? Rückgabewert:
	# Die Funktion zeigt die UUIDs der Benutzer aus der Tabelle "UserAccounts" in der Datenbank an und gibt das Ergebnis der MySQL-Anfrage aus.
	# Wenn das Dialog-Tool nicht installiert ist, wird die Funktion mit einer entsprechenden Meldung beendet.
	#? Hinweise:
	# - Stellen Sie sicher, dass die Tabelle "UserAccounts" in der Datenbank existiert, bevor Sie die Funktion aufrufen.
##
function db_all_uuid_dialog() {
	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then

		# Einstellungen
		boxbacktitel="opensimMULTITOOL"
		boxtitel="opensimMULTITOOL Eingabe"
		formtitle="UUID von allen Benutzern anzeigen"
		lable1="Benutzername:"
		lablename1=""
		lable2="Passwort:"
		lablename2=""
		lable3="Datenbankname:"
		lablename3=""

		# Abfrage
		ASSETDELBOXERGEBNIS=$(dialog --backtitle "$boxbacktitel" --title "$boxtitel" --form "$formtitle" 25 60 16 "$lable1" 1 1 "$lablename1" 1 25 25 30 "$lable2" 2 1 "$lablename2" 2 25 25 30 "$lable3" 3 1 "$lablename3" 3 25 25 30 3>&1 1>&2 2>&3 3>&-)

		# Zeilen aus einer Variablen zerlegen und in verschiedenen Variablen schreiben.
		username=$(echo "$ASSETDELBOXERGEBNIS" | sed -n '1p')
		password=$(echo "$ASSETDELBOXERGEBNIS" | sed -n '2p')
		databasename=$(echo "$ASSETDELBOXERGEBNIS" | sed -n '3p')

		# Alles loeschen.
		dialogclear
		ScreenLog
	else
		# Alle Aktionen ohne dialog
		log rohtext "Keine Menuelose Funktion" | exit
	fi # dialog Aktionen Ende

	mysqlrest "$username" "$password" "$databasename" "SELECT PrincipalID FROM UserAccounts"

	warnbox "$result_mysqlrest"

	return 0
}

## *  db_all_name
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion zeigt die Vor- und Zunamen aller Benutzer aus der Tabelle "UserAccounts" in einer MySQL-Datenbank an.
	#? Parameter:
	# - $1: Benutzername für den Datenbankzugriff
	# - $2: Passwort für den Datenbankzugriff
	# - $3: Name der Datenbank, in der die Tabelle "UserAccounts" vorhanden ist
	#? Beispielaufruf:
	# Die Funktion sollte mit den erforderlichen Parametern aufgerufen werden.
	# db_all_name "mein_benutzer" "geheim123" "meine_datenbank"
	#? Rückgabewert:
	# Die Funktion zeigt die Vor- und Zunamen aller Benutzer aus der Tabelle "UserAccounts" in der angegebenen Datenbank an.
	# Sie gibt das Ergebnis der MySQL-Anfrage aus.
	#? Hinweise:
	# - Stellen Sie sicher, dass die Tabelle "UserAccounts" in der angegebenen Datenbank vorhanden ist.
##
function db_all_name() {
	username=$1
	password=$2
	databasename=$3
	log rohtext "Vor- und Zuname von allen Benutzern anzeigen:"
	echo " "
	mysqlrest "$username" "$password" "$databasename" "SELECT FirstName, LastName FROM UserAccounts"
	log rohtext "$result_mysqlrest"

	return 0
}

## *  db_all_name_dialog
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion zeigt die Vor- und Zunamen aller Benutzer aus der Tabelle "UserAccounts" in einer MySQL-Datenbank an.
	# Sie verwendet das Dialog-Tool, um Benutzereingaben zu erhalten.
	#? Parameter: (Keine direkten Parameter, Benutzer wird zur Eingabe aufgefordert)
	#? Beispielaufruf:
	# Die Funktion wird ohne direkte Parameter aufgerufen und verwendet das Dialog-Tool zur Benutzereingabe.
	# db_all_name_dialog
	#? Rückgabewert:
	# Die Funktion zeigt die Vor- und Zunamen aller Benutzer aus der Tabelle "UserAccounts" in der angegebenen Datenbank an.
	# Sie gibt das Ergebnis der MySQL-Anfrage im Dialogfenster aus.
	#? Hinweise:
	# - Stellen Sie sicher, dass die Tabelle "UserAccounts" in der angegebenen Datenbank vorhanden ist.
	# - Das Dialog-Tool muss auf dem System installiert sein, damit diese Funktion ordnungsgemäß funktioniert.
##
function db_all_name_dialog() {
	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then

		# Einstellungen
		boxbacktitel="opensimMULTITOOL"
		boxtitel="opensimMULTITOOL Eingabe"
		formtitle="Alle Tabellen in einer Datenbank auflisten"
		lable1="Benutzername:"
		lablename1=""
		lable2="Passwort:"
		lablename2=""
		lable3="Datenbankname:"
		lablename3=""

		# Abfrage
		db_all_name=$(dialog --backtitle "$boxbacktitel" --title "$boxtitel" --form "$formtitle" 25 60 16 "$lable1" 1 1 "$lablename1" 1 25 25 30 "$lable2" 2 1 "$lablename2" 2 25 25 30 "$lable3" 3 1 "$lablename3" 3 25 25 30 3>&1 1>&2 2>&3 3>&-)

		# Zeilen aus einer Variablen zerlegen und in verschiedenen Variablen schreiben.
		username=$(echo "$db_all_name" | sed -n '1p')
		password=$(echo "$db_all_name" | sed -n '2p')
		databasename=$(echo "$db_all_name" | sed -n '3p')

		# Alles loeschen.
		dialogclear
		ScreenLog
	else
		# Alle Aktionen ohne dialog
		log rohtext "Keine Menuelose Funktion" | exit
	fi # dialog Aktionen Ende

	mysqlrest "$username" "$password" "$databasename" "SELECT FirstName, LastName FROM UserAccounts"

	warnbox "$result_mysqlrest"

	return 0
}

## *  db_user_data
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion zeigt die Daten eines Benutzers aus der Tabelle "UserAccounts" in einer MySQL-Datenbank an,
	# basierend auf seinem Vor- und Nachnamen. Es sucht nach Übereinstimmungen im Vor- und Nachnamen in der Datenbank.
	#? Parameter:
	# $1: Benutzername für den Datenbankzugriff
	# $2: Passwort für den Datenbankzugriff
	# $3: Name der Datenbank
	# $4: Vorname des Benutzers
	# $5: Nachname des Benutzers
	#? Beispielaufruf:
	# Die Funktion sollte mit den erforderlichen Parametern aufgerufen werden.
	# db_user_data "mein_benutzer" "geheim123" "meine_datenbank" "Max" "Mustermann"
	#? Rückgabewert:
	# Die Funktion zeigt die Daten des Benutzers mit Übereinstimmungen im Vor- und Nachnamen in der Tabelle "UserAccounts" an.
	# Sie gibt das Ergebnis der MySQL-Anfrage aus.
	#? Hinweise:
	# - Stellen Sie sicher, dass die Tabelle "UserAccounts" in der angegebenen Datenbank vorhanden ist.
##
function db_user_data() {
	username=$1
	password=$2
	databasename=$3
	firstname=$4
	lastname=$5
	log rohtext "Daten von einem Benutzer anzeigen:"
	echo " "
	mysqlrest "$username" "$password" "$databasename" "SELECT * FROM UserAccounts WHERE firstname='$firstname' AND lastname LIKE '$lastname'"
	log rohtext "$result_mysqlrest"

	return 0
}

## *  db_user_data_dialog
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht die interaktive Suche nach Benutzerdaten in einer MySQL-Datenbank basierend auf Vor- und Nachnamen.
	# Der Benutzer wird aufgefordert, den Benutzernamen, das Passwort, den Datenbanknamen, den Vornamen und den Nachnamen einzugeben.
	# Anschließend werden die Daten des gefundenen Benutzers aus der Tabelle "UserAccounts" angezeigt.
	#? Parameter: Keine
	#? Beispielaufruf:
	# Die Funktion wird direkt vom Benutzer aufgerufen und verwendet ein Dialogfeld für die Eingabe der erforderlichen Informationen.
	#? Rückgabewert: Keiner (Die Funktion zeigt die Benutzerdaten an.)
	#? Hinweise:
	# - Stellen Sie sicher, dass die Tabelle "UserAccounts" in der angegebenen Datenbank vorhanden ist.
	# - Die Funktion verwendet das Dialog-Tool zur Benutzerinteraktion. Stellen Sie sicher, dass Dialog installiert ist.
##
function db_user_data_dialog() {
	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then

		# Einstellungen
		boxbacktitel="opensimMULTITOOL"
		boxtitel="opensimMULTITOOL Eingabe"
		formtitle="Finde alle offensichtlich falschen E-Mail Adressen der Grid User und deaktiviere dauerhaft dessen Account"
		lable1="Benutzername:"
		lablename1=""
		lable2="Passwort:"
		lablename2=""
		lable3="Datenbankname:"
		lablename3=""
		lable4="Vorname:"
		lablename4=""
		lable5="Nachname:"
		lablename5=""

		# Abfrage
		db_user_data=$(dialog --backtitle "$boxbacktitel" --title "$boxtitel" --form "$formtitle" 25 60 16 "$lable1" 1 1 "$lablename1" 1 25 25 30 "$lable2" 2 1 "$lablename2" 2 25 25 30 "$lable3" 3 1 "$lablename3" 3 25 25 30 "$lable4" 4 1 "$lablename4" 4 25 25 30 "$lable5" 5 1 "$lablename5" 5 25 25 30 3>&1 1>&2 2>&3 3>&-)

		# Zeilen aus einer Variablen zerlegen und in verschiedenen Variablen schreiben.
		username=$(echo "$db_user_data" | sed -n '1p')
		password=$(echo "$db_user_data" | sed -n '2p')
		databasename=$(echo "$db_user_data" | sed -n '3p')
		firstname=$(echo "$db_user_data" | sed -n '4p')
		lastname=$(echo "$db_user_data" | sed -n '5p')

		# Alles loeschen.
		dialogclear
		ScreenLog
	else
		# Alle Aktionen ohne dialog
		log rohtext "Keine Menuelose Funktion" | exit
	fi # dialog Aktionen Ende

	mysqlrest "$username" "$password" "$databasename" "SELECT * FROM UserAccounts WHERE firstname='$firstname' AND lastname LIKE '$lastname'"

	warnbox "$result_mysqlrest"

	return 0
}

## *  db_user_infos
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht die Suche nach bestimmten Benutzerdaten in einer MySQL-Datenbank basierend auf Vor- und Nachnamen.
	# Der Benutzer wird aufgefordert, den Benutzernamen, das Passwort, den Datenbanknamen, den Vornamen und den Nachnamen einzugeben.
	# Anschließend werden die UUID, Vorname, Nachname und E-Mail-Adresse des gefundenen Benutzers aus der Tabelle "UserAccounts" angezeigt.
	#? Parameter: Keine
	#? Beispielaufruf:
	# Die Funktion wird direkt vom Benutzer aufgerufen und verwendet ein Dialogfeld für die Eingabe der erforderlichen Informationen.
	#? Rückgabewert: Keiner (Die Funktion zeigt die Benutzerdaten an.)
	#? Hinweise:
	# - Stellen Sie sicher, dass die Tabelle "UserAccounts" in der angegebenen Datenbank vorhanden ist.
	# - Die Funktion verwendet das Dialog-Tool zur Benutzerinteraktion. Stellen Sie sicher, dass Dialog installiert ist.
##
function db_user_infos() {
	username=$1
	password=$2
	databasename=$3
	firstname=$4
	lastname=$5
	log rohtext "UUID Vor- und Nachname sowie E-Mail Adresse von einem Benutzer anzeigen:"
	echo " "
	mysqlrest "$username" "$password" "$databasename" "SELECT PrincipalID, FirstName, LastName, Email FROM UserAccounts WHERE firstname='$firstname' AND lastname LIKE '$lastname'"
	log rohtext "$result_mysqlrest"

	return 0
}

## *  db_user_infos_dialog
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht die Suche nach bestimmten Benutzerdaten in einer MySQL-Datenbank basierend auf Vor- und Nachnamen.
	# Der Benutzer wird aufgefordert, den Benutzernamen, das Passwort, den Datenbanknamen, den Vornamen und den Nachnamen einzugeben.
	# Anschließend werden die UUID, Vorname, Nachname und E-Mail-Adresse des gefundenen Benutzers aus der Tabelle "UserAccounts" angezeigt.
	#? Parameter: Keine
	#? Beispielaufruf:
	# Die Funktion wird direkt vom Benutzer aufgerufen und verwendet ein Dialogfeld für die Eingabe der erforderlichen Informationen.
	#? Rückgabewert: Keiner (Die Funktion zeigt die Benutzerdaten an.)
	#? Hinweise:
	# - Stellen Sie sicher, dass die Tabelle "UserAccounts" in der angegebenen Datenbank vorhanden ist.
	# - Die Funktion verwendet das Dialog-Tool zur Benutzerinteraktion. Stellen Sie sicher, dass Dialog installiert ist.
##
function db_user_infos_dialog() {
	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then

		# Einstellungen
		boxbacktitel="opensimMULTITOOL"
		boxtitel="opensimMULTITOOL Eingabe"
		formtitle="Finde alle offensichtlich falschen E-Mail Adressen der Grid User und deaktiviere dauerhaft dessen Account"
		lable1="Benutzername:"
		lablename1=""
		lable2="Passwort:"
		lablename2=""
		lable3="Datenbankname:"
		lablename3=""
		lable4="Vorname:"
		lablename4=""
		lable5="Nachname:"
		lablename5=""

		# Abfrage
		db_user_infos=$(dialog --backtitle "$boxbacktitel" --title "$boxtitel" --form "$formtitle" 25 60 16 "$lable1" 1 1 "$lablename1" 1 25 25 30 "$lable2" 2 1 "$lablename2" 2 25 25 30 "$lable3" 3 1 "$lablename3" 3 25 25 30 "$lable4" 4 1 "$lablename4" 4 25 25 30 "$lable5" 5 1 "$lablename5" 5 25 25 30 3>&1 1>&2 2>&3 3>&-)

		# Zeilen aus einer Variablen zerlegen und in verschiedenen Variablen schreiben.
		username=$(echo "$db_user_infos" | sed -n '1p')
		password=$(echo "$db_user_infos" | sed -n '2p')
		databasename=$(echo "$db_user_infos" | sed -n '3p')
		firstname=$(echo "$db_user_infos" | sed -n '4p')
		lastname=$(echo "$db_user_infos" | sed -n '5p')

		# Alles loeschen.
		dialogclear
		ScreenLog
	else
		# Alle Aktionen ohne dialog
		log rohtext "Keine Menuelose Funktion" | exit
	fi # dialog Aktionen Ende

	mysqlrest "$username" "$password" "$databasename" "SELECT PrincipalID, FirstName, LastName, Email FROM UserAccounts WHERE firstname='$firstname' AND lastname LIKE '$lastname'"

	warnbox "$result_mysqlrest"

	return 0
}

## *  db_user_uuid
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht die Suche nach der UUID eines Benutzers in einer MySQL-Datenbank basierend auf Vor- und Nachnamen.
	# Der Benutzer wird aufgefordert, den Benutzernamen, das Passwort, den Datenbanknamen, den Vornamen und den Nachnamen einzugeben.
	# Anschließend wird die UUID des gefundenen Benutzers aus der Tabelle "UserAccounts" angezeigt.
	#? Parameter: Keine
	#? Beispielaufruf:
	# Die Funktion wird direkt vom Benutzer aufgerufen und verwendet ein Dialogfeld für die Eingabe der erforderlichen Informationen.
	#? Rückgabewert: Keiner (Die Funktion zeigt die UUID des Benutzers an.)
	#? Hinweise:
	# - Stellen Sie sicher, dass die Tabelle "UserAccounts" in der angegebenen Datenbank vorhanden ist.
	# - Die Funktion verwendet das Dialog-Tool zur Benutzerinteraktion. Stellen Sie sicher, dass Dialog installiert ist.
##
function db_user_uuid() {
	username=$1
	password=$2
	databasename=$3
	firstname=$4
	lastname=$5
	log rohtext "UUID von einem Benutzer anzeigen:"
	echo " "
	mysqlrest "$username" "$password" "$databasename" "SELECT PrincipalID FROM UserAccounts WHERE FirstName='$firstname' AND LastName='$lastname'"
	log rohtext "$result_mysqlrest"

	return 0
}

## *  db_user_uuid_dialog
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht die Suche nach der UUID eines Benutzers in einer MySQL-Datenbank basierend auf Vor- und Nachnamen.
	# Der Benutzer wird aufgefordert, den Benutzernamen, das Passwort, den Datenbanknamen, den Vornamen und den Nachnamen einzugeben.
	# Anschließend wird die UUID des gefundenen Benutzers aus der Tabelle "UserAccounts" angezeigt.
	# Diese Funktion verwendet das Dialog-Tool zur Benutzerinteraktion und ist für den Dialog-basierten Betrieb vorgesehen.
	#? Parameter: Keine
	#? Beispielaufruf:
	# Die Funktion wird direkt vom Benutzer aufgerufen und verwendet ein Dialogfeld für die Eingabe der erforderlichen Informationen.
	#? Rückgabewert: Keiner (Die Funktion zeigt die UUID des Benutzers an.)
	#? Hinweise:
	# - Stellen Sie sicher, dass die Tabelle "UserAccounts" in der angegebenen Datenbank vorhanden ist.
	# - Die Funktion verwendet das Dialog-Tool zur Benutzerinteraktion. Stellen Sie sicher, dass Dialog installiert ist.
##
function db_user_uuid_dialog() {
	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then

		# Einstellungen
		boxbacktitel="opensimMULTITOOL"
		boxtitel="opensimMULTITOOL Eingabe"
		formtitle="Finde alle offensichtlich falschen E-Mail Adressen der Grid User und deaktiviere dauerhaft dessen Account"
		lable1="Benutzername:"
		lablename1=""
		lable2="Passwort:"
		lablename2=""
		lable3="Datenbankname:"
		lablename3=""
		lable4="Vorname:"
		lablename4=""
		lable5="Nachname:"
		lablename5=""

		# Abfrage
		db_user_uuid=$(dialog --backtitle "$boxbacktitel" --title "$boxtitel" --form "$formtitle" 25 60 16 "$lable1" 1 1 "$lablename1" 1 25 25 30 "$lable2" 2 1 "$lablename2" 2 25 25 30 "$lable3" 3 1 "$lablename3" 3 25 25 30 "$lable4" 4 1 "$lablename4" 4 25 25 30 "$lable5" 5 1 "$lablename5" 5 25 25 30 3>&1 1>&2 2>&3 3>&-)

		# Zeilen aus einer Variablen zerlegen und in verschiedenen Variablen schreiben.
		username=$(echo "$db_user_uuid" | sed -n '1p')
		password=$(echo "$db_user_uuid" | sed -n '2p')
		databasename=$(echo "$db_user_uuid" | sed -n '3p')
		firstname=$(echo "$db_user_uuid" | sed -n '4p')
		lastname=$(echo "$db_user_uuid" | sed -n '5p')

		# Alles loeschen.
		dialogclear
		ScreenLog
	else
		# Alle Aktionen ohne dialog
		log rohtext "Keine Menuelose Funktion" | exit
	fi # dialog Aktionen Ende

	mysqlrest "$username" "$password" "$databasename" "SELECT PrincipalID FROM UserAccounts WHERE FirstName='$firstname' AND LastName='$lastname'"

	warnbox "$result_mysqlrest"

	return 0
}

## *  db_foldertyp_user
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht das Abrufen von Inventarordnern eines Benutzers in einer MySQL-Datenbank basierend auf dem Ordner-/Verzeichnistyp und den Benutzerinformationen (Vorname und Nachname).
	# Der Benutzer wird aufgefordert, den Benutzernamen, das Passwort, den Datenbanknamen, den Vornamen, den Nachnamen und den gewünschten Verzeichnistyp einzugeben.
	# Anschließend werden die passenden Ordner aus der Tabelle "inventoryfolders" abgerufen und angezeigt.
	#? Parameter:
	# - $1: Benutzername für die MySQL-Datenbank
	# - $2: Passwort für die MySQL-Datenbank
	# - $3: Name der MySQL-Datenbank
	# - $4: Vorname des Benutzers
	# - $5: Nachname des Benutzers
	# - $6: Verzeichnistyp (Text oder Zahl, z. B. "Textures" oder "0")
	#? Beispielaufruf:
	# db_foldertyp_user "db_username" "db_password" "db_database" "John" "Doe" "Textures"
	#? Rückgabewert: Keiner (Die Funktion zeigt die abgerufenen Inventarordner an.)
	#? Hinweise:
	# - Stellen Sie sicher, dass die Tabelle "inventoryfolders" in der angegebenen Datenbank vorhanden ist.
	# - Der Verzeichnistyp kann als Text (z. B. "Textures") oder als Zahl (z. B. "0") angegeben werden. Die Funktion konvertiert den Text in die entsprechende Zahl.
##
function db_foldertyp_user() {
	username=$1
	password=$2
	databasename=$3
	firstname=$4
	lastname=$5
	foldertyp=$6

	case $foldertyp in
	Textures | textures) foldertyp="0" ;;
	Sounds | sounds) foldertyp="1" ;;
	CallingCards | callingcards) foldertyp="2" ;;
	Landmarks | landmarks) foldertyp="3" ;;
	Clothing | clothing) foldertyp="5" ;;
	Objects | objects) foldertyp="6" ;;
	Notecards | notecards) foldertyp="7" ;;
	MyInventory | myinventory) foldertyp="8" ;;
	Scripts | scripts) foldertyp="10" ;;
	BodyParts | bodyparts) foldertyp="13" ;;
	Trash | trash) foldertyp="14" ;;
	PhotoAlbum | photoalbum) foldertyp="15" ;;
	LostandFound | lostandfound) foldertyp="16" ;;
	Animations | animations) foldertyp="20" ;;
	Gestures | gestures) foldertyp="21" ;;
	Favorites | favorites) foldertyp="23" ;;
	CurrentOutfit | currentoutfit) foldertyp="46" ;;
	Outfits | outfits) foldertyp="47" ;;
	Meshes | meshes) foldertyp="49" ;;
	Settings | settings) foldertyp="56" ;;
	userDefined | userdefined) foldertyp="-1" ;;
	*) $foldertyp ;;
	esac

	log rohtext "Alles vom Inventar des User, nach Verzeichnissnamen oder ID:"
	echo " "
	mysqlrest "$username" "$password" "$databasename" "SELECT PrincipalID FROM UserAccounts WHERE FirstName='$firstname' AND LastName='$lastname'"
	user_uuid="$result_mysqlrest"
	mysqlrest "$username" "$password" "$databasename" "SELECT * FROM inventoryfolders WHERE (type='$foldertyp') AND agentID='$user_uuid'"
	log rohtext "$result_mysqlrest"

	return 0
}

## *  db_all_userfailed
	# Datum: [Aktuelles Datum]
	#? Beschreibung:
	# Diese Funktion ermöglicht die Suche nach bestimmten Informationen in einer MySQL-Datenbank in Bezug auf Benutzerkonten und Inventarordner. Je nach Umgebung kann sie interaktiv oder nicht-interaktiv verwendet werden.
	#? Parameter:
	#   - username (String): Der Benutzername für die MySQL-Datenbank.
	#   - password (String): Das Passwort für die MySQL-Datenbank.
	#   - databasename (String): Der Name der MySQL-Datenbank, in der die Abfragen ausgeführt werden sollen.
	#   - firstname (String): Der Vorname des Benutzers, dessen Informationen gesucht werden sollen.
	#   - lastname (String): Der Nachname des Benutzers, dessen Informationen gesucht werden sollen.
	#? Funktionsverhalten:
	#   - Wenn das Dialog-Tool (Dialog) installiert ist, wird die Funktion in einem interaktiven Modus ausgeführt. Sie zeigt ein Dialogfeld an, in dem Benutzername, Passwort, Datenbankname, Vorname und Nachname eingegeben werden können.
	#   - Wenn das Dialog-Tool nicht installiert ist, wird die Funktion im nicht-interaktiven Modus ausgeführt. Die erforderlichen Informationen müssen als Parameter bereitgestellt werden.
	#   - Die Funktion führt eine SQL-Abfrage in der Datenbank durch, um die PrincipalID (UUID) eines Benutzers zu finden, der den angegebenen Vor- und Nachnamen hat.
	#   - Anschließend wird die PrincipalID verwendet, um weitere Informationen aus der Tabelle "inventoryfolders" abzurufen, wobei der Wert des Felds "type" nicht "-1" ist.
	#   - Die Ergebnisse werden entweder in einem Dialogfeld (wenn Dialog installiert ist) oder in den Protokolldateien (log) angezeigt.
	#? Beispielaufruf:
	#   - Interaktiver Modus:
	#     db_all_userfailed
	#   - Nicht-interaktiver Modus:
	#     db_all_userfailed "db_username" "db_password" "db_database" "John" "Doe"
	#? Rückgabewert:
	# Diese Funktion gibt keinen expliziten Rückgabewert zurück, sondern zeigt die abgerufenen Informationen in der Ausgabe an oder protokolliert sie.
	#? Hinweise:
	#   - Stellen Sie sicher, dass die Tabelle "UserAccounts" und "inventoryfolders" in der angegebenen Datenbank vorhanden ist.
	#   - Der Dialog-Modus erfordert die Installation des Dialog-Tools. Verwenden Sie "apt-get install dialog", um es zu installieren.
##
function db_all_userfailed() {
	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then

		# Einstellungen
		boxbacktitel="opensimMULTITOOL"
		boxtitel="opensimMULTITOOL Eingabe"
		formtitle="Finde alles vom inventoryfolders was type -1 des User ist"
		lable1="Benutzername:"
		lablename1=""
		lable2="Passwort:"
		lablename2=""
		lable3="Datenbankname:"
		lablename3=""
		lable4="Vorname:"
		lablename4=""
		lable5="Nachname:"
		lablename5=""

		# Abfrage
		db_all_userfailed=$(dialog --backtitle "$boxbacktitel" --title "$boxtitel" --form "$formtitle" 25 60 16 "$lable1" 1 1 "$lablename1" 1 25 25 30 "$lable2" 2 1 "$lablename2" 2 25 25 30 "$lable3" 3 1 "$lablename3" 3 25 25 30 "$lable4" 4 1 "$lablename4" 4 25 25 30 "$lable5" 5 1 "$lablename5" 5 25 25 30 3>&1 1>&2 2>&3 3>&-)

		# Zeilen aus einer Variablen zerlegen und in verschiedenen Variablen schreiben.
		username=$(echo "$db_all_userfailed" | sed -n '1p')
		password=$(echo "$db_all_userfailed" | sed -n '2p')
		databasename=$(echo "$db_all_userfailed" | sed -n '3p')
		firstname=$(echo "$db_all_userfailed" | sed -n '4p')
		lastname=$(echo "$db_all_userfailed" | sed -n '5p')

		# Alles loeschen.
		dialogclear
		ScreenLog
	else
		# Alle Aktionen ohne dialog
		log info "Finde alles vom inventoryfolders was type -1 des User ist:"
		username=$1
		password=$2
		databasename=$3
		firstname=$4
		lastname=$5
	fi # dialog Aktionen Ende

	mysqlrest "$username" "$password" "$databasename" "SELECT PrincipalID FROM UserAccounts WHERE FirstName='$firstname' AND LastName='$lastname'"
	uf_user_uuid="$result_mysqlrest"
	mysqlrest "$username" "$password" "$databasename" "SELECT * FROM inventoryfolders WHERE type != '-1' AND agentID='$uf_user_uuid'"

	# Ausgabe zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then
		warnbox "$result_mysqlrest"
	else
		log rohtext "$result_mysqlrest"
	fi

	return 0
}

## *  db_userdate
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht das Anzeigen des Erstellungsdatums eines Benutzers in einer MySQL-Datenbank basierend auf Vor- und Nachnamen.
	# Je nachdem, ob das Dialog-Tool installiert ist oder nicht, kann sie interaktiv oder nicht-interaktiv verwendet werden.
	# Der Benutzer wird aufgefordert, den Benutzernamen, das Passwort, den Datenbanknamen, den Vornamen und den Nachnamen einzugeben oder diese Informationen als Parameter bereitzustellen.
	# Anschließend wird das Erstellungsdatum des gefundenen Benutzers aus der Tabelle "UserAccounts" abgerufen und in das deutsche Datumsformat konvertiert.
	#? Parameter:
	#   - username (String): Der Benutzername für die MySQL-Datenbank.
	#   - password (String): Das Passwort für die MySQL-Datenbank.
	#   - databasename (String): Der Name der MySQL-Datenbank, in der die Abfrage ausgeführt werden soll.
	#   - firstname (String): Der Vorname des Benutzers, dessen Erstellungsdatum angezeigt werden soll.
	#   - lastname (String): Der Nachname des Benutzers, dessen Erstellungsdatum angezeigt werden soll.
	#? Funktionsverhalten:
	#   - Wenn das Dialog-Tool (Dialog) installiert ist, wird die Funktion in einem interaktiven Modus ausgeführt. Sie zeigt ein Dialogfeld an, in dem Benutzername, Passwort, Datenbankname, Vorname und Nachname eingegeben werden können.
	#   - Wenn das Dialog-Tool nicht installiert ist, wird die Funktion im nicht-interaktiven Modus ausgeführt. Die erforderlichen Informationen müssen als Parameter bereitgestellt werden.
	#   - Die Funktion führt eine SQL-Abfrage in der Datenbank durch, um das Erstellungsdatum eines Benutzers zu finden, der den angegebenen Vor- und Nachnamen hat.
	#   - Das zurückgegebene Unix-Timestamp wird in das deutsche Datumsformat (TT.MM.JJJJ) konvertiert.
	#   - Die Ergebnisse werden entweder in einem Dialogfeld (wenn Dialog installiert ist) oder in den Protokolldateien (log) angezeigt.
	#? Beispielaufruf:
	#   - Interaktiver Modus:
	#     db_userdate
	#   - Nicht-interaktiver Modus:
	#     db_userdate "db_username" "db_password" "db_database" "John" "Doe"
	#? Rückgabewert:
	# Diese Funktion gibt keinen expliziten Rückgabewert zurück, sondern zeigt das Erstellungsdatum des gefundenen Benutzers im deutschen Datumsformat in der Ausgabe an oder protokolliert es.
	#? Hinweise:
	#   - Stellen Sie sicher, dass die Tabelle "UserAccounts" in der angegebenen Datenbank vorhanden ist.
	#   - Der Dialog-Modus erfordert die Installation des Dialog-Tools. Verwenden Sie "apt-get install dialog", um es zu installieren.
##
function db_userdate() {
	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then

		# Einstellungen
		boxbacktitel="opensimMULTITOOL"
		boxtitel="opensimMULTITOOL Eingabe"
		formtitle="Zeige Erstellungsdatum eines Users an"
		lable1="Benutzername:"
		lablename1=""
		lable2="Passwort:"
		lablename2=""
		lable3="Datenbankname:"
		lablename3=""
		lable4="Vorname:"
		lablename4=""
		lable5="Nachname:"
		lablename5=""

		# Abfrage
		db_userdate=$(dialog --backtitle "$boxbacktitel" --title "$boxtitel" --form "$formtitle" 25 60 16 "$lable1" 1 1 "$lablename1" 1 25 25 30 "$lable2" 2 1 "$lablename2" 2 25 25 30 "$lable3" 3 1 "$lablename3" 3 25 25 30 "$lable4" 4 1 "$lablename4" 4 25 25 30 "$lable5" 5 1 "$lablename5" 5 25 25 30 3>&1 1>&2 2>&3 3>&-)

		# Zeilen aus einer Variablen zerlegen und in verschiedenen Variablen schreiben.
		username=$(echo "$db_userdate" | sed -n '1p')
		password=$(echo "$db_userdate" | sed -n '2p')
		databasename=$(echo "$db_userdate" | sed -n '3p')
		firstname=$(echo "$db_userdate" | sed -n '4p')
		lastname=$(echo "$db_userdate" | sed -n '5p')

		# Alles loeschen.
		dialogclear
		ScreenLog
	else
		# Alle Aktionen ohne dialog
		log info "Zeige Erstellungsdatum eines Users an:"
		username=$1
		password=$2
		databasename=$3
		firstname=$4
		lastname=$5
	fi # dialog Aktionen Ende

	mysqlrest "$username" "$password" "$databasename" "SELECT Created FROM UserAccounts WHERE firstname='$firstname' AND lastname LIKE '$lastname'"
	#unix timestamp konvertieren in das Deutsche Datumsformat.
	userdatum=$(date +%d.%m.%Y -d @"$result_mysqlrest")

	# Ausgabe zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then
		warnbox "Der Benutzer $firstname $lastname wurde am $userdatum angelegt."
	else
		log rohtext "Der Benutzer $firstname $lastname wurde am $userdatum angelegt."
	fi

	return 0
}

## *  db_false_email
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht die Suche nach offensichtlich falschen E-Mail-Adressen in einer MySQL-Datenbank für Benutzerkonten.
	# Je nachdem, ob das Dialog-Tool installiert ist oder nicht, kann sie interaktiv oder nicht-interaktiv verwendet werden.
	# Der Benutzer wird aufgefordert, den Benutzernamen, das Passwort und den Datenbanknamen einzugeben oder diese Informationen als Parameter bereitzustellen.
	# Die Funktion sucht nach E-Mail-Adressen, die offensichtlich ungültig sind (nicht im Format "name@domain.tld") und gibt die entsprechenden Benutzerinformationen aus.
	# Es gibt auch Ausnahmen für bestimmte Vor- und Nachnamen, die übersprungen werden.
	#? Parameter:
	#   - username (String): Der Benutzername für die MySQL-Datenbank.
	#   - password (String): Das Passwort für die MySQL-Datenbank.
	#   - databasename (String): Der Name der MySQL-Datenbank, in der die Abfrage ausgeführt werden soll.
	#? Funktionsverhalten:
	#   - Wenn das Dialog-Tool (Dialog) installiert ist, wird die Funktion in einem interaktiven Modus ausgeführt. Sie zeigt ein Dialogfeld an, in dem Benutzername, Passwort und Datenbankname eingegeben werden können.
	#   - Wenn das Dialog-Tool nicht installiert ist, wird die Funktion im nicht-interaktiven Modus ausgeführt. Die erforderlichen Informationen müssen als Parameter bereitgestellt werden.
	#   - Die Funktion führt eine SQL-Abfrage in der Datenbank durch, um Benutzerkonten mit offensichtlich falschen E-Mail-Adressen zu finden, die nicht dem Format "name@domain.tld" entsprechen.
	#   - Es werden auch bestimmte Vor- und Nachnamen ("GRID SERVICES") ausgeschlossen.
	#   - Die gefundenen Benutzerinformationen (PrincipalID, Vorname, Nachname und E-Mail) werden in der Ausgabe angezeigt oder protokolliert.
	#? Beispielaufruf:
	#   - Interaktiver Modus:
	#     db_false_email
	#   - Nicht-interaktiver Modus:
	#     db_false_email "db_username" "db_password" "db_database"
	#? Rückgabewert:
	# Diese Funktion gibt keinen expliziten Rückgabewert zurück, sondern zeigt die gefundenen Benutzerinformationen in der Ausgabe an oder protokolliert sie.
	#? Hinweise:
	#   - Stellen Sie sicher, dass die Tabelle "UserAccounts" in der angegebenen Datenbank vorhanden ist.
	#   - Der Dialog-Modus erfordert die Installation des Dialog-Tools. Verwenden Sie "apt-get install dialog", um es zu installieren.
##
function db_false_email() {
	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then

		# Einstellungen
		boxbacktitel="opensimMULTITOOL"
		boxtitel="opensimMULTITOOL Eingabe"
		formtitle="Finde falsche E-Mail Adressen"
		lable1="Benutzername:"
		lablename1=""
		lable2="Passwort:"
		lablename2=""
		lable3="Datenbankname:"
		lablename3=""

		# Abfrage
		db_false_emailBOXERGEBNIS=$(dialog --backtitle "$boxbacktitel" --title "$boxtitel" --form "$formtitle" 25 60 16 "$lable1" 1 1 "$lablename1" 1 25 25 30 "$lable2" 2 1 "$lablename2" 2 25 25 30 "$lable3" 3 1 "$lablename3" 3 25 25 30 3>&1 1>&2 2>&3 3>&-)

		# Zeilen aus einer Variablen zerlegen und in verschiedenen Variablen schreiben.
		username=$(echo "$db_false_emailBOXERGEBNIS" | sed -n '1p')
		password=$(echo "$db_false_emailBOXERGEBNIS" | sed -n '2p')
		databasename=$(echo "$db_false_emailBOXERGEBNIS" | sed -n '3p')

		# Alles loeschen.
		dialogclear
		ScreenLog
	else
		# Alle Aktionen ohne dialog
		log info "Finde offensichtlich falsche E-Mail Adressen der User ausser von $ausnahmefirstname $ausnahmelastname."
		username=$1
		password=$2
		databasename=$3
	fi # dialog Aktionen Ende

	# Ausnahmen
	ausnahmefirstname="GRID"
	ausnahmelastname="SERVICES"

	mysqlrest "$username" "$password" "$databasename" "SELECT PrincipalID, FirstName, LastName, Email FROM UserAccounts WHERE Email NOT LIKE '%_@__%.__%'AND NOT firstname='$ausnahmefirstname' AND NOT lastname='$ausnahmelastname'"

	# Ausgabe zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then
		warnbox "$result_mysqlrest"
	else
		log rohtext "$result_mysqlrest"
	fi

	return 0
}

## *  set_empty_user
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht das Hinzufügen eines neuen Benutzers zu einer MySQL-Datenbank mit leeren oder vordefinierten Werten.
	# Sie erfordert die Bereitstellung von Benutzernamen, Passwort, Datenbankname, Vorname, Nachname und E-Mail-Adresse als Parameter.
	# Die Funktion erstellt einen neuen Benutzer mit den angegebenen Werten in der Tabelle "UserAccounts" der Datenbank.
	# Vor der Einfügung wird die Gültigkeit der E-Mail-Adresse anhand eines regulären Ausdrucks überprüft.
	#? Parameter:
	#   - username (String): Der Benutzername für die MySQL-Datenbank.
	#   - password (String): Das Passwort für die MySQL-Datenbank.
	#   - databasename (String): Der Name der MySQL-Datenbank, in der der neue Benutzer erstellt werden soll.
	#   - firstname (String): Der Vorname des neuen Benutzers.
	#   - lastname (String): Der Nachname des neuen Benutzers.
	#   - email (String): Die E-Mail-Adresse des neuen Benutzers.
	#? Funktionsverhalten:
	#   - Die Funktion verwendet einen regulären Ausdruck, um die Gültigkeit der E-Mail-Adresse zu überprüfen. Wenn die E-Mail-Adresse das richtige Format aufweist, wird sie als "OK" betrachtet, andernfalls wird die Funktion mit einem Fehler beendet.
	#   - Ein neuer UUID (PrincipalID) wird generiert.
	#   - Andere Felder für den neuen Benutzer wie ScopeID, ServiceURLs, Created, UserLevel, UserFlags, UserTitle und active werden vordefiniert oder können angepasst werden.
	#   - Die SQL-Abfrage zum Einfügen des neuen Benutzers mit den angegebenen Werten wird in der Datenbank ausgeführt.
	#? Beispielaufruf:
	#   set_empty_user "db_username" "db_password" "db_database" "John" "Doe" "john.doe@example.com"
	#? Rückgabewert:
	# Diese Funktion gibt keinen expliziten Rückgabewert zurück, sondern fügt den neuen Benutzer in die Datenbank ein, wenn alle Bedingungen erfüllt sind.
	# Bei einer ungültigen E-Mail-Adresse wird die Funktion mit einem Fehler beendet.
	#? Hinweise:
	#   - Stellen Sie sicher, dass die Tabelle "UserAccounts" in der angegebenen Datenbank vorhanden ist.
##
function set_empty_user() {
	regex="^(([-a-zA-Z0-9\!#\$%\&\'*+/=?^_\`{\|}~]+|(\"([][,:;<>\&@a-zA-Z0-9\!#\$%\&\'*+/=?^_\`{\|}~-]|(\\\\[\\ \"]))+\"))\.)*([-a-zA-Z0-9\!#\$%\&\'*+/=?^_\`{\|}~]+|(\"([][,:;<>\&@a-zA-Z0-9\!#\$%\&\'*+/=?^_\`{\|}~-]|(\\\\[\\ \"]))+\"))@\w((-|\w)*\w)*\.(\w((-|\w)*\w)*\.)*\w{2,4}$"
	username=$1
	password=$2
	databasename=$3
	firstname=$4
	lastname=$5
	email=$6
	UUID=$(uuidgen)
	newPrincipalID="$UUID"
	newScopeID="00000000-0000-0000-0000-000000000000"
	newFirstName="$firstname"
	newLastName="$lastname"
	# regex email check
	if [[ $email =~ $regex ]]; then
		echo "E-Mail $email OK"
		newEmail="$email"
	else
		echo "E-Mail $email not OK"
		exit 1
	fi

	newServiceURLs="HomeURI= InventoryServerURI= AssetServerURI="
	newCreated=$(date +%s)
	newUserLevel="0"
	newUserFlags="0"
	newUserTitle=""
	newactive="1"
	mysqlrest "$username" "$password" "$databasename" "INSERT INTO UserAccounts (PrincipalID, ScopeID, FirstName, LastName, Email, ServiceURLs, Created, UserLevel, UserFlags, UserTitle, active) VALUES ('$newPrincipalID', '$newScopeID', '$newFirstName', '$newLastName', '$newEmail', '$newServiceURLs', '$newCreated', '$newUserLevel', '$newUserFlags', '$newUserTitle', '$newactive')"
}

## *  db_email_setincorrectuseroff
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht das Finden von Benutzern in einer MySQL-Datenbank mit offensichtlich falschen E-Mail-Adressen und deaktiviert diese Benutzer.
	# Sie erfordert die Bereitstellung von Benutzernamen, Passwort und Datenbankname als Parameter.
	# Die Funktion sucht nach Benutzern mit E-Mail-Adressen, die offensichtlich ungültig sind (nicht im Format "name@domain.tld") und deaktiviert diese Benutzerkonten.
	# Es gibt auch Ausnahmen für bestimmte Vor- und Nachnamen ("GRID SERVICES"), die übersprungen werden.
	#? Parameter:
	#   - username (String): Der Benutzername für die MySQL-Datenbank.
	#   - password (String): Das Passwort für die MySQL-Datenbank.
	#   - databasename (String): Der Name der MySQL-Datenbank, in der die Aktualisierung durchgeführt werden soll.
	#? Funktionsverhalten:
	#   - Die Funktion führt eine SQL-Abfrage in der Datenbank durch, um Benutzerkonten mit offensichtlich falschen E-Mail-Adressen zu finden, die nicht dem Format "name@domain.tld" entsprechen.
	#   - Es werden auch bestimmte Vor- und Nachnamen ("GRID SERVICES") ausgeschlossen.
	#   - Die gefundenen Benutzerkonten werden deaktiviert, indem das "active"-Feld auf -1 gesetzt wird.
	#? Beispielaufruf:
	#   db_email_setincorrectuseroff "db_username" "db_password" "db_database"
	#? Rückgabewert:
	# Diese Funktion gibt keinen expliziten Rückgabewert zurück, sondern deaktiviert die gefundenen Benutzerkonten in der Datenbank.
	#? Hinweise:
	#   - Stellen Sie sicher, dass die Tabelle "UserAccounts" in der angegebenen Datenbank vorhanden ist.
##
function db_email_setincorrectuseroff() {
	username=$1
	password=$2
	databasename=$3
	ausnahmefirstname="GRID"
	ausnahmelastname="SERVICES"

	log warn "Finde offensichtlich falsche E-Mail Adressen der User ausser von $ausnahmefirstname $ausnahmelastname und schalte diese User ab."

	mysqlrest "$username" "$password" "$databasename" "UPDATE UserAccounts SET active = -1 WHERE Email NOT LIKE '%_@__%.__%'AND NOT firstname='$ausnahmefirstname' AND NOT lastname='$ausnahmelastname';"

	return 0
}

## *  db_email_setincorrectuseroff_dialog
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht das Finden von Benutzern in einer MySQL-Datenbank mit offensichtlich falschen E-Mail-Adressen und deaktiviert diese Benutzer.
	# Sie erfordert die Bereitstellung von Benutzernamen, Passwort und Datenbankname als Parameter oder kann im Dialogmodus verwendet werden, wenn das Dialog-Tool (Dialog) installiert ist.
	# Die Funktion sucht nach Benutzern mit E-Mail-Adressen, die offensichtlich ungültig sind (nicht im Format "name@domain.tld") und deaktiviert diese Benutzerkonten.
	# Es gibt auch Ausnahmen für bestimmte Vor- und Nachnamen ("GRID SERVICES"), die übersprungen werden.
	#? Parameter:
	#   - username (String): Der Benutzername für die MySQL-Datenbank.
	#   - password (String): Das Passwort für die MySQL-Datenbank.
	#   - databasename (String): Der Name der MySQL-Datenbank, in der die Aktualisierung durchgeführt werden soll.
	#? Funktionsverhalten:
	#   - Wenn das Dialog-Tool (Dialog) installiert ist, wird die Funktion in einem interaktiven Modus ausgeführt. Sie zeigt ein Dialogfeld an, in dem Benutzername, Passwort und Datenbankname eingegeben werden können.
	#   - Wenn das Dialog-Tool nicht installiert ist, wird die Funktion im nicht-interaktiven Modus ausgeführt und zeigt eine Meldung an, dass der Dialogmodus nicht verfügbar ist.
	#   - Die Funktion führt eine SQL-Abfrage in der Datenbank durch, um Benutzerkonten mit offensichtlich falschen E-Mail-Adressen zu finden, die nicht dem Format "name@domain.tld" entsprechen.
	#   - Es werden auch bestimmte Vor- und Nachnamen ("GRID SERVICES") ausgeschlossen.
	#   - Die gefundenen Benutzerkonten werden deaktiviert, indem das "active"-Feld auf -1 gesetzt wird.
	#? Beispielaufruf:
	#   - Interaktiver Modus (Dialog):
	#     db_email_setincorrectuseroff_dialog
	#   - Nicht-interaktiver Modus:
	#     db_email_setincorrectuseroff_dialog "db_username" "db_password" "db_database"
	#? Rückgabewert:
	# Diese Funktion gibt keinen expliziten Rückgabewert zurück, sondern deaktiviert die gefundenen Benutzerkonten in der Datenbank oder zeigt eine Meldung an, dass der Dialogmodus nicht verfügbar ist.
	#? Hinweise:
	#   - Stellen Sie sicher, dass die Tabelle "UserAccounts" in der angegebenen Datenbank vorhanden ist.
	#   - Der Dialog-Modus erfordert die Installation des Dialog-Tools. Verwenden Sie "apt-get install dialog", um es zu installieren.
##
function db_email_setincorrectuseroff_dialog() {
	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then

		# Einstellungen
		boxbacktitel="opensimMULTITOOL"
		boxtitel="opensimMULTITOOL Eingabe"
		formtitle="Finde alle offensichtlich falschen E-Mail Adressen der Grid User und deaktiviere dauerhaft dessen Account"
		lable1="Benutzername:"
		lablename1=""
		lable2="Passwort:"
		lablename2=""
		lable3="Datenbankname:"
		lablename3=""

		# Abfrage
		ASSETDELBOXERGEBNIS=$(dialog --backtitle "$boxbacktitel" --title "$boxtitel" --form "$formtitle" 25 60 16 "$lable1" 1 1 "$lablename1" 1 25 25 30 "$lable2" 2 1 "$lablename2" 2 25 25 30 "$lable3" 3 1 "$lablename3" 3 25 25 30 3>&1 1>&2 2>&3 3>&-)

		# Zeilen aus einer Variablen zerlegen und in verschiedenen Variablen schreiben.
		username=$(echo "$ASSETDELBOXERGEBNIS" | sed -n '1p')
		password=$(echo "$ASSETDELBOXERGEBNIS" | sed -n '2p')
		databasename=$(echo "$ASSETDELBOXERGEBNIS" | sed -n '3p')

		# Alles loeschen.
		dialogclear
		ScreenLog
	else
		# Alle Aktionen ohne dialog
		log rohtext "Keine Menuelose Funktion" | exit
	fi # dialog Aktionen Ende

	ausnahmefirstname="GRID"
	ausnahmelastname="SERVICES"

	mysqlrest "$username" "$password" "$databasename" "UPDATE UserAccounts SET active = -1 WHERE Email NOT LIKE '%_@__%.__%'AND NOT firstname='$ausnahmefirstname' AND NOT lastname='$ausnahmelastname';"

	warnbox "Alle offensichtlich falschen E-Mail Adressen der Grid User wurden gesucht und dessen Accounts deaktiviert."

	return 0
}

## *  db_setuserofline
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion deaktiviert einen Benutzer in einer MySQL-Datenbank, um ihn offline zu setzen. Sie erfordert die Bereitstellung von Benutzernamen, Passwort, Datenbankname, Vornamen und Nachnamen als Parameter.
	# Der Benutzer mit dem angegebenen Vornamen und Nachnamen wird deaktiviert, indem das "active"-Feld auf -1 gesetzt wird.
	#? Parameter:
	#   - username (String): Der Benutzername für die MySQL-Datenbank.
	#   - password (String): Das Passwort für die MySQL-Datenbank.
	#   - databasename (String): Der Name der MySQL-Datenbank, in der die Aktualisierung durchgeführt werden soll.
	#   - firstname (String): Der Vorname des Benutzers, der offline gesetzt werden soll.
	#   - lastname (String): Der Nachname des Benutzers, der offline gesetzt werden soll.
	#? Funktionsverhalten:
	#   - Die Funktion führt eine SQL-Abfrage in der Datenbank durch, um den Benutzer mit dem angegebenen Vornamen und Nachnamen zu finden und offline zu setzen.
	#   - Der gefundene Benutzer wird deaktiviert, indem das "active"-Feld auf -1 gesetzt wird.
	#? Beispielaufruf:
	#   db_setuserofline "db_username" "db_password" "db_database" "Vorname" "Nachname"
	#? Rückgabewert:
	# Diese Funktion gibt keinen expliziten Rückgabewert zurück, sondern deaktiviert den gefundenen Benutzer in der Datenbank und zeigt das Ergebnis der SQL-Abfrage an.
	#? Hinweise:
	#   - Stellen Sie sicher, dass die Tabelle "UserAccounts" in der angegebenen Datenbank vorhanden ist.
##
function db_setuserofline() {
	username=$1
	password=$2
	databasename=$3
	firstname=$4
	lastname=$5

	log rohtext "Setze User $firstname $lastname offline."
	echo " "
	mysqlrest "$username" "$password" "$databasename" "UPDATE UserAccounts SET active='-1' WHERE FirstName='$firstname' AND LastName='$lastname'"
	echo "$result_mysqlrest"

	return 0
}

## *  db_setuserofline_dialog
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht das Deaktivieren eines Benutzers in einer MySQL-Datenbank, um ihn offline zu setzen. Sie erfordert die Bereitstellung von Benutzernamen, Passwort, Datenbankname, Vornamen und Nachnamen als Parameter oder kann im Dialogmodus verwendet werden, wenn das Dialog-Tool (Dialog) installiert ist.
	# Der Benutzer mit dem angegebenen Vornamen und Nachnamen wird deaktiviert, indem das "active"-Feld auf -1 gesetzt wird.
	#? Parameter:
	#   - username (String): Der Benutzername für die MySQL-Datenbank.
	#   - password (String): Das Passwort für die MySQL-Datenbank.
	#   - databasename (String): Der Name der MySQL-Datenbank, in der die Aktualisierung durchgeführt werden soll.
	#   - firstname (String): Der Vorname des Benutzers, der offline gesetzt werden soll.
	#   - lastname (String): Der Nachname des Benutzers, der offline gesetzt werden soll.
	#? Funktionsverhalten:
	#   - Wenn das Dialog-Tool (Dialog) installiert ist, wird die Funktion in einem interaktiven Modus ausgeführt. Sie zeigt ein Dialogfeld an, in dem Benutzername, Passwort, Datenbankname, Vorname und Nachname eingegeben werden können.
	#   - Wenn das Dialog-Tool nicht installiert ist, wird die Funktion im nicht-interaktiven Modus ausgeführt und zeigt eine Meldung an, dass der Dialogmodus nicht verfügbar ist.
	#   - Die Funktion führt eine SQL-Abfrage in der Datenbank durch, um den Benutzer mit dem angegebenen Vornamen und Nachnamen zu finden und offline zu setzen.
	#   - Der gefundene Benutzer wird deaktiviert, indem das "active"-Feld auf -1 gesetzt wird.
	#? Beispielaufruf:
	#   - Interaktiver Modus (Dialog):
	#     db_setuserofline_dialog
	#   - Nicht-interaktiver Modus:
	#     db_setuserofline_dialog "db_username" "db_password" "db_database" "Vorname" "Nachname"
	#? Rückgabewert:
	# Diese Funktion gibt keinen expliziten Rückgabewert zurück, sondern deaktiviert den gefundenen Benutzer in der Datenbank und zeigt eine Erfolgsmeldung an.
	#? Hinweise:
	#   - Stellen Sie sicher, dass die Tabelle "UserAccounts" in der angegebenen Datenbank vorhanden ist.
	#   - Der Dialog-Modus erfordert die Installation des Dialog-Tools. Verwenden Sie "apt-get install dialog", um es zu installieren.
##
function db_setuserofline_dialog() {
	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then

		# Einstellungen
		boxbacktitel="opensimMULTITOOL"
		boxtitel="opensimMULTITOOL Eingabe"
		formtitle="Finde alle offensichtlich falschen E-Mail Adressen der Grid User und deaktiviere dauerhaft dessen Account"
		lable1="Benutzername:"
		lablename1=""
		lable2="Passwort:"
		lablename2=""
		lable3="Datenbankname:"
		lablename3=""
		lable4="Vorname:"
		lablename4=""
		lable5="Nachname:"
		lablename5=""

		# Abfrage
		setuserofline=$(dialog --backtitle "$boxbacktitel" --title "$boxtitel" --form "$formtitle" 25 60 16 "$lable1" 1 1 "$lablename1" 1 25 25 30 "$lable2" 2 1 "$lablename2" 2 25 25 30 "$lable3" 3 1 "$lablename3" 3 25 25 30 "$lable4" 4 1 "$lablename4" 4 25 25 30 "$lable5" 5 1 "$lablename5" 5 25 25 30 3>&1 1>&2 2>&3 3>&-)

		# Zeilen aus einer Variablen zerlegen und in verschiedenen Variablen schreiben.
		username=$(echo "$setuserofline" | sed -n '1p')
		password=$(echo "$setuserofline" | sed -n '2p')
		databasename=$(echo "$setuserofline" | sed -n '3p')
		firstname=$(echo "$setuserofline" | sed -n '4p')
		lastname=$(echo "$setuserofline" | sed -n '5p')

		# Alles loeschen.
		dialogclear
		ScreenLog
	else
		# Alle Aktionen ohne dialog
		log rohtext "Keine Menuelose Funktion" | exit
	fi # dialog Aktionen Ende

	mysqlrest "$username" "$password" "$databasename" "UPDATE UserAccounts SET active='-1' WHERE FirstName='$firstname' AND LastName='$lastname'"

	warnbox "Benutzer $firstname $lastname wurde abgeschaltet."

	return 0
}

## *  db_setuseronline
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion aktiviert einen zuvor deaktivierten Benutzer in einer MySQL-Datenbank, um ihn online zu setzen. Sie erfordert die Bereitstellung von Benutzernamen, Passwort, Datenbankname, Vornamen und Nachnamen als Parameter.
	# Der zuvor deaktivierte Benutzer mit dem angegebenen Vornamen und Nachnamen wird aktiviert, indem das "active"-Feld auf 1 gesetzt wird.
	#? Parameter:
	#   - username (String): Der Benutzername für die MySQL-Datenbank.
	#   - password (String): Das Passwort für die MySQL-Datenbank.
	#   - databasename (String): Der Name der MySQL-Datenbank, in der die Aktualisierung durchgeführt werden soll.
	#   - firstname (String): Der Vorname des Benutzers, der online gesetzt werden soll.
	#   - lastname (String): Der Nachname des Benutzers, der online gesetzt werden soll.
	#? Funktionsverhalten:
	#   - Die Funktion führt eine SQL-Abfrage in der Datenbank durch, um den zuvor deaktivierten Benutzer mit dem angegebenen Vornamen und Nachnamen zu finden und online zu setzen.
	#   - Der zuvor deaktivierte Benutzer wird aktiviert, indem das "active"-Feld auf 1 gesetzt wird.
	#? Beispielaufruf:
	#   db_setuseronline "db_username" "db_password" "db_database" "Vorname" "Nachname"
	#? Rückgabewert:
	# Diese Funktion gibt keinen expliziten Rückgabewert zurück, sondern aktiviert den zuvor deaktivierten Benutzer in der Datenbank und zeigt das Ergebnis der SQL-Abfrage an.
	#? Hinweise:
	#   - Stellen Sie sicher, dass die Tabelle "UserAccounts" in der angegebenen Datenbank vorhanden ist.
##
function db_setuseronline() {
	username=$1
	password=$2
	databasename=$3
	firstname=$4
	lastname=$5

	log rohtext "Setze User $firstname $lastname online."
	echo " "
	mysqlrest "$username" "$password" "$databasename" "UPDATE UserAccounts SET active='1' WHERE FirstName='$firstname' AND LastName='$lastname'"
	echo "$result_mysqlrest"

	return 0
}

## *  db_setuseronline_dialog
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht es einem Benutzer, einen zuvor deaktivierten Benutzer in einer MySQL-Datenbank online zu setzen, indem sie ein Dialogfeld für die Eingabe der erforderlichen Informationen bereitstellt. Die erforderlichen Informationen umfassen Benutzernamen, Passwort, Datenbankname, Vornamen und Nachnamen.
	# Der zuvor deaktivierte Benutzer mit dem angegebenen Vornamen und Nachnamen wird aktiviert, indem das "active"-Feld auf 1 gesetzt wird.
	#? Parameter: Keine
	#? Funktionsverhalten:
	#   - Die Funktion zeigt ein Dialogfeld an, in dem der Benutzer die erforderlichen Informationen eingeben kann.
	#   - Nach Eingabe der Informationen führt die Funktion eine SQL-Abfrage in der Datenbank durch, um den zuvor deaktivierten Benutzer zu finden und online zu setzen.
	#   - Der zuvor deaktivierte Benutzer wird aktiviert, indem das "active"-Feld auf 1 gesetzt wird.
	#? Beispielaufruf:
	#   Die Funktion wird direkt vom Benutzer aufgerufen und verwendet ein Dialogfeld für die Eingabe der erforderlichen Informationen.
	#? Rückgabewert:
	# Diese Funktion gibt keinen expliziten Rückgabewert zurück, sondern aktiviert den zuvor deaktivierten Benutzer in der Datenbank und zeigt eine Bestätigungsnachricht an.
	#? Hinweise:
	#   - Stellen Sie sicher, dass die Tabelle "UserAccounts" in der angegebenen Datenbank vorhanden ist.
##
function db_setuseronline_dialog() {
	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then

		# Einstellungen
		boxbacktitel="opensimMULTITOOL"
		boxtitel="opensimMULTITOOL Eingabe"
		formtitle="Finde alle offensichtlich falschen E-Mail Adressen der Grid User und deaktiviere dauerhaft dessen Account"
		lable1="Benutzername:"
		lablename1=""
		lable2="Passwort:"
		lablename2=""
		lable3="Datenbankname:"
		lablename3=""
		lable4="Vorname:"
		lablename4=""
		lable5="Nachname:"
		lablename5=""

		# Abfrage
		setuseronline=$(dialog --backtitle "$boxbacktitel" --title "$boxtitel" --form "$formtitle" 25 60 16 "$lable1" 1 1 "$lablename1" 1 25 25 30 "$lable2" 2 1 "$lablename2" 2 25 25 30 "$lable3" 3 1 "$lablename3" 3 25 25 30 "$lable4" 4 1 "$lablename4" 4 25 25 30 "$lable5" 5 1 "$lablename5" 5 25 25 30 3>&1 1>&2 2>&3 3>&-)

		# Zeilen aus einer Variablen zerlegen und in verschiedenen Variablen schreiben.
		username=$(echo "$setuseronline" | sed -n '1p')
		password=$(echo "$setuseronline" | sed -n '2p')
		databasename=$(echo "$setuseronline" | sed -n '3p')
		firstname=$(echo "$setuseronline" | sed -n '4p')
		lastname=$(echo "$setuseronline" | sed -n '5p')

		# Alles loeschen.
		dialogclear
		ScreenLog
	else
		# Alle Aktionen ohne dialog
		log rohtext "Keine Menuelose Funktion" | exit
	fi # dialog Aktionen Ende

	mysqlrest "$username" "$password" "$databasename" "UPDATE UserAccounts SET active='1' WHERE FirstName='$firstname' AND LastName='$lastname'"

	warnbox "Benutzer $firstname $lastname wurde reaktiviert."

	return 0
}

## *  db_tabellencopy
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht es, eine Tabelle von einer Datenbank in eine andere zu kopieren. Sie benötigt den Namen der Quelldatenbank, den Namen der Zieldatenbank und den Namen der zu kopierenden Tabelle. Außerdem werden Benutzername und Passwort für den Datenbankzugriff benötigt.
	# Die Funktion erstellt zunächst eine neue Tabelle in der Zieldatenbank mit derselben Struktur wie die Quelltabelle (einschließlich Spalten, Datentypen und Constraints). Anschließend werden die Daten aus der Quelltabelle in die neu erstellte Zieltabelle kopiert.
	#? Parameter:
	#   - vondatenbank: Name der Quelldatenbank
	#   - nachdatenbank: Name der Zieldatenbank
	#   - kopieretabelle: Name der zu kopierenden Tabelle
	#   - username: Benutzername für den Datenbankzugriff
	#   - password: Passwort für den Datenbankzugriff
	#? Funktionsverhalten:
	#   - Die Funktion erstellt eine neue Tabelle in der Zieldatenbank mit derselben Struktur wie die Quelltabelle.
	#   - Anschließend werden die Daten aus der Quelltabelle in die neu erstellte Zieltabelle kopiert.
	#? Beispielaufruf:
	#   Die Funktion wird direkt vom Benutzer aufgerufen und erfordert die Eingabe der oben genannten Parameter.
	#? Rückgabewert:
	# Diese Funktion gibt keinen expliziten Rückgabewert zurück, sondern erstellt eine neue Tabelle in der Zieldatenbank und kopiert die Daten aus der Quelltabelle.
	#? Hinweise:
	#   - Stellen Sie sicher, dass die Quelldatenbank und die Zieldatenbank existieren und die richtigen Zugangsdaten bereitgestellt werden.
##
function db_tabellencopy() {
	# Datenbank Tabelle aus einer anderen Datenbank kopieren.
	# db_tabellencopy von_Datenbankname nach_Datenbankname Tabellenname Benutzername Passwort

	vondatenbank=$1
	nachdatenbank=$2
	kopieretabelle=$3

	username=$4
	password=$5

	#CREATE TABLE new_table LIKE old_table
	#INSERT INTO new_table SELECT * FROM old_table

	# Mit CREATE TABLE erzeugt ihr eine neue Tabelle, mit der selbsten Struktur wie die „Alte“.
	mysqlrest "$username" "$password" "$nachdatenbank" "CREATE TABLE $nachdatenbank.$kopieretabelle LIKE $vondatenbank.$kopieretabelle" # Tabellenstruktur kopieren Funktioniert

	echo "$result_mysqlrest"

	# Mit INSERT INTO kopiert ihr dann den Inhalt von der alten Tabelle in die neue Tabelle hinein.
	mysqlrest "$username" "$password" "$nachdatenbank" "INSERT INTO $kopieretabelle SELECT * FROM $vondatenbank.$kopieretabelle" # Tabelle kopieren Test

	echo "$result_mysqlrest"
}

## *  db_tabellencopy_extern
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht es, eine Tabelle von einer externen Datenbank auf einen Server zu kopieren. Sie benötigt den Namen oder die IP-Adresse des externen Servers, den Namen der Quelldatenbank, den Namen der Zieldatenbank und den Namen der zu kopierenden Tabelle. Außerdem werden Benutzername und Passwort für den Datenbankzugriff benötigt.
	# Die Funktion erstellt zunächst eine neue Tabelle in der Zieldatenbank mit derselben Struktur wie die Quelltabelle (einschließlich Spalten, Datentypen und Constraints). Anschließend können die Daten aus der Quelltabelle in die neu erstellte Zieltabelle kopiert werden.
	#? Parameter:
	#   - EXTERNERSERVER: Name oder IP-Adresse des externen Servers
	#   - vondatenbank: Name der Quelldatenbank
	#   - nachdatenbank: Name der Zieldatenbank
	#   - kopieretabelle: Name der zu kopierenden Tabelle
	#   - username: Benutzername für den Datenbankzugriff
	#   - password: Passwort für den Datenbankzugriff
	#? Funktionsverhalten:
	#   - Die Funktion erstellt eine neue Tabelle in der Zieldatenbank mit derselben Struktur wie die Quelltabelle auf dem externen Server.
	#   - Anschließend können die Daten aus der Quelltabelle auf dem externen Server in die neu erstellte Zieltabelle in der Zieldatenbank kopiert werden.
	#? Beispielaufruf:
	#   Die Funktion wird direkt vom Benutzer aufgerufen und erfordert die Eingabe der oben genannten Parameter.
	#? Rückgabewert:
	# Diese Funktion gibt keinen expliziten Rückgabewert zurück, sondern erstellt eine neue Tabelle in der Zieldatenbank und ermöglicht das Kopieren von Daten von einem externen Server in die Tabelle.
	#? Hinweise:
	#   - Stellen Sie sicher, dass der externe Server erreichbar ist und die Quelldatenbank sowie die Zieldatenbank existieren und die richtigen Zugangsdaten bereitgestellt werden.
##
function db_tabellencopy_extern() {
	# Datenbank Tabelle aus einer anderen Datenbank kopieren.
	# db_tabellencopy von_Datenbankname nach_Datenbankname Tabellenname Benutzername Passwort

	EXTERNERSERVER=$1
	vondatenbank=$2
	nachdatenbank=$3
	kopieretabelle=$4	

	username=$5
	password=$6

	# Für den externen weg muss der externe Server angegeben werden testen ob es ein teil 
	#EXTERNERSERVER="root@192.168.1.155"
	#$EXTERNERSERVER:/usr/src/

	#CREATE TABLE new_table LIKE old_table
	#INSERT INTO new_table SELECT * FROM old_table

	# Mit CREATE TABLE erzeugt ihr eine neue Tabelle, mit der selbsten Struktur wie die „Alte“.
	mysqlrest "$username" "$password" "$nachdatenbank" "CREATE TABLE $nachdatenbank.$kopieretabelle LIKE $vondatenbank.$kopieretabelle" # Tabellenstruktur kopieren Funktioniert
	echo "$result_mysqlrest"

	# Mit INSERT INTO kopiert ihr dann den Inhalt von der alten Tabelle in die neue Tabelle hinein.
	#mysqlrest "$username" "$password" "$nachdatenbank" "INSERT INTO $kopieretabelle SELECT * FROM $vondatenbank.$kopieretabelle" # Tabelle kopieren Test
	#echo "$result_mysqlrest"
}

## *  default_master_connection
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion konfiguriert und aktiviert die Verbindung zum MySQL-Master-Server. Sie ermöglicht es, den Standard-Master-Verbindungsnamen zu setzen, den Slave-Thread zu stoppen, das Master-Passwort zu ändern und den Slave-Thread wieder zu starten.
	# Die Funktion akzeptiert optional einen Benutzernamen und ein Passwort für die MySQL-Verbindung. Wenn diese nicht angegeben werden, verwendet sie den Standardbenutzernamen "root" und ein leeres Passwort.
	#? Parameter:
	#   - username (optional): Benutzername für die MySQL-Verbindung (Standard: "root")
	#   - password (optional): Passwort für die MySQL-Verbindung (Standard: Leer)
	#? Funktionsverhalten:
	#   - Die Funktion setzt den Standard-Master-Verbindungsnamen auf den angegebenen Benutzernamen oder auf "root", wenn kein Benutzername angegeben wurde.
	#   - Sie stoppt den Slave-Thread auf dem MySQL-Server.
	#   - Ändert das Master-Passwort auf das angegebene Passwort oder belässt es leer, wenn kein Passwort angegeben wurde.
	#   - Startet den Slave-Thread erneut.
	#? Beispielaufruf:
	#   Die Funktion kann direkt vom Benutzer aufgerufen werden und erlaubt die Option, Benutzername und Passwort für die MySQL-Verbindung anzugeben.
	#   Beispiel 1: default_master_connection "root" "geheimesPasswort"
	#   Beispiel 2: default_master_connection # Benutzt den Standardbenutzernamen "root" und ein leeres Passwort.
	#? Rückgabewert:
	# Diese Funktion gibt keine explizite Rückgabe aus, sondern führt die Konfigurations- und Aktivierungsschritte für die MySQL-Master-Verbindung durch.
	#? Hinweise:
	#   - Stellen Sie sicher, dass Sie über ausreichende Berechtigungen für die MySQL-Verbindung und die Konfiguration des Master-Slave-Replikationsprozesses verfügen.
	#   - Das Master-Passwort sollte sicher gespeichert und übertragen werden, da es Zugriff auf den MySQL-Master-Server ermöglicht.
##
function default_master_connection() {
	username=$1
	password=$2
	if [ -z "$username" ]; then username="root"; fi
	if [ -z "$password" ]; then password=""; fi

	mysqlrestnodb "$username" "$password" "SET default_master_connection = '$username';"
	mysqlrestnodb "$username" "$password" "STOP SLAVE;"
	mysqlrestnodb "$username" "$password" "CHANGE MASTER TO MASTER_PASSWORD='$password';"
	mysqlrestnodb "$username" "$password" "START SLAVE;"
	#shellcheck disable=SC2128
	log text " $FUNCNAME: $result_mysqlrestnodb"
	return 0
}

## *  connection_name
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion konfiguriert und aktiviert die Verbindung zu einem spezifischen MySQL-Server anhand eines benutzerdefinierten Verbindungsnamens. Sie ermöglicht es, den Slave-Thread für diese Verbindung zu stoppen, das Master-Passwort zu ändern und den Slave-Thread wieder zu starten.
	# Die Funktion akzeptiert optional einen Benutzernamen und ein Passwort für die MySQL-Verbindung. Wenn diese nicht angegeben werden, verwendet sie den Standardbenutzernamen "root" und ein leeres Passwort.
	#? Parameter:
	#   - username (optional): Benutzername für die MySQL-Verbindung (Standard: "root")
	#   - password (optional): Passwort für die MySQL-Verbindung (Standard: Leer)
	#? Funktionsverhalten:
	#   - Die Funktion stoppt den Slave-Thread für die spezifische Verbindung mit dem angegebenen Verbindungsnamen.
	#   - Ändert das Master-Passwort für diese Verbindung auf das angegebene Passwort oder belässt es leer, wenn kein Passwort angegeben wurde.
	#   - Startet den Slave-Thread für diese Verbindung erneut.
	#? Beispielaufruf:
	#   Die Funktion kann direkt vom Benutzer aufgerufen werden und erlaubt die Option, Benutzername und Passwort für die MySQL-Verbindung anzugeben.
	#   Beispiel 1: connection_name "meineverbindung" "geheimesPasswort"
	#   Beispiel 2: connection_name "andereverbindung" # Benutzt den Standardbenutzernamen "root" und ein leeres Passwort.
	#? Rückgabewert:
	# Diese Funktion gibt keine explizite Rückgabe aus, sondern führt die Konfigurations- und Aktivierungsschritte für die MySQL-Verbindung mit dem spezifischen Namen durch.
	#? Hinweise:
	#   - Stellen Sie sicher, dass Sie über ausreichende Berechtigungen für die MySQL-Verbindung und die Konfiguration des Master-Slave-Replikationsprozesses verfügen.
	#   - Das Master-Passwort sollte sicher gespeichert und übertragen werden, da es Zugriff auf den MySQL-Master-Server ermöglicht.
##
function connection_name() {
	username=$1
	password=$2
	if [ -z "$username" ]; then username="root"; fi
	if [ -z "$password" ]; then password=""; fi

	mysqlrestnodb "$username" "$password" "STOP SLAVE '$username';"
	mysqlrestnodb "$username" "$password" "CHANGE MASTER '$username' TO MASTER_PASSWORD='$password';"
	mysqlrestnodb "$username" "$password" "START SLAVE '$username';"
	#shellcheck disable=SC2128
	log text " $FUNCNAME: $result_mysqlrestnodb"
	return 0
}

## *  MASTER_USER
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion konfiguriert und aktiviert die Verbindung zum MySQL-Master-Server unter Verwendung eines benutzerdefinierten Benutzernamens und Passworts. Sie ermöglicht es, den Slave-Thread zu stoppen, den Master-Benutzernamen und das Passwort zu ändern und den Slave-Thread wieder zu starten.
	# Die Funktion akzeptiert optional einen Benutzernamen und ein Passwort für die MySQL-Verbindung. Wenn diese nicht angegeben werden, verwendet sie den Standardbenutzernamen "root" und ein leeres Passwort.
	#? Parameter:
	#   - username (optional): Benutzername für die MySQL-Verbindung (Standard: "root")
	#   - password (optional): Passwort für die MySQL-Verbindung (Standard: Leer)
	#? Funktionsverhalten:
	#   - Die Funktion stoppt den Slave-Thread auf dem aktuellen Server.
	#   - Ändert den Master-Benutzernamen und das Passwort für die Replikation auf die angegebenen Werte oder belässt sie leer, wenn keine Werte angegeben wurden.
	#   - Startet den Slave-Thread erneut, um die Replikation fortzusetzen.
	#? Beispielaufruf:
	#   Die Funktion kann direkt vom Benutzer aufgerufen werden und erlaubt die Option, Benutzername und Passwort für die MySQL-Verbindung anzugeben.
	#   Beispiel 1: MASTER_USER "meinbenutzer" "geheimesPasswort"
	#   Beispiel 2: MASTER_USER "andererbenutzer" # Benutzt den Standardbenutzernamen "root" und ein leeres Passwort.
	#? Rückgabewert:
	# Diese Funktion gibt keine explizite Rückgabe aus, sondern führt die Konfigurations- und Aktivierungsschritte für die MySQL-Verbindung durch.
	#? Hinweise:
	#   - Stellen Sie sicher, dass Sie über ausreichende Berechtigungen für die MySQL-Verbindung und die Konfiguration des Master-Slave-Replikationsprozesses verfügen.
	#   - Das Master-Passwort und der Benutzername sollten sicher gespeichert und übertragen werden, da sie Zugriff auf den MySQL-Master-Server ermöglichen.
##
function MASTER_USER() {
	username=$1
	password=$2
	if [ -z "$username" ]; then username="root"; fi
	if [ -z "$password" ]; then password=""; fi

	mysqlrestnodb "$username" "$password" "STOP SLAVE;"
	mysqlrestnodb "$username" "$password" "CHANGE MASTER TO MASTER_USER='$username', MASTER_PASSWORD='$password';"
	mysqlrestnodb "$username" "$password" "START SLAVE;"
	#shellcheck disable=SC2128
	log text " $FUNCNAME: $result_mysqlrestnodb"
	return 0
}

## *  MASTER_PASSWORD
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion konfiguriert und aktiviert die Verbindung zum MySQL-Master-Server unter Verwendung eines benutzerdefinierten Passworts. Sie ermöglicht es, den Slave-Thread zu stoppen, das Master-Passwort zu ändern und den Slave-Thread wieder zu starten.
	# Die Funktion akzeptiert optional einen Benutzernamen und ein Passwort für die MySQL-Verbindung. Wenn diese nicht angegeben werden, verwendet sie den Standardbenutzernamen "root" und ein leeres Passwort.
	#? Parameter:
	#   - username (optional): Benutzername für die MySQL-Verbindung (Standard: "root")
	#   - password (optional): Passwort für die MySQL-Verbindung (Standard: Leer)
	#? Funktionsverhalten:
	#   - Die Funktion stoppt den Slave-Thread auf dem aktuellen Server.
	#   - Ändert das Master-Passwort für die Replikation auf den angegebenen Wert oder belässt es leer, wenn kein Wert angegeben wurde.
	#   - Startet den Slave-Thread erneut, um die Replikation fortzusetzen.
	#? Beispielaufruf:
	#   Die Funktion kann direkt vom Benutzer aufgerufen werden und erlaubt die Option, Benutzername und Passwort für die MySQL-Verbindung anzugeben.
	#   Beispiel 1: MASTER_PASSWORD "meinbenutzer" "geheimesPasswort"
	#   Beispiel 2: MASTER_PASSWORD "andererbenutzer" # Benutzt den Standardbenutzernamen "root" und ein leeres Passwort.
	#? Rückgabewert:
	# Diese Funktion gibt keine explizite Rückgabe aus, sondern führt die Konfigurations- und Aktivierungsschritte für die MySQL-Verbindung durch.
	#? Hinweise:
	#   - Stellen Sie sicher, dass Sie über ausreichende Berechtigungen für die MySQL-Verbindung und die Konfiguration des Master-Slave-Replikationsprozesses verfügen.
	#   - Das Master-Passwort sollte sicher gespeichert und übertragen werden, da es Zugriff auf den MySQL-Master-Server ermöglicht.
##
function MASTER_PASSWORD() {
	username=$1
	password=$2
	if [ -z "$username" ]; then username="root"; fi
	if [ -z "$password" ]; then password=""; fi

	mysqlrestnodb "$username" "$password" "STOP SLAVE;"
	mysqlrestnodb "$username" "$password" "CHANGE MASTER TO MASTER_PASSWORD=$password;"
	mysqlrestnodb "$username" "$password" "START SLAVE;"
	#shellcheck disable=SC2128
	log text " $FUNCNAME: $result_mysqlrestnodb"
	return 0
}

## *  MASTER_HOST
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion konfiguriert und aktiviert die Verbindung zum MySQL-Master-Server unter Verwendung einer benutzerdefinierten Hostadresse, Benutzername und Passwort. Sie ermöglicht es, den Slave-Thread zu stoppen, den Host des MySQL-Master-Servers zu ändern und den Slave-Thread wieder zu starten.
	# Die Funktion akzeptiert optional einen Benutzernamen, ein Passwort und den Host des MySQL-Master-Servers für die MySQL-Verbindung. Wenn diese nicht angegeben werden, verwendet sie den Standardbenutzernamen "root", ein leeres Passwort und die Hostadresse "127.0.0.1".
	#? Parameter:
	#   - username (optional): Benutzername für die MySQL-Verbindung (Standard: "root")
	#   - password (optional): Passwort für die MySQL-Verbindung (Standard: Leer)
	#   - MASTERHOST (optional): Hostadresse des MySQL-Master-Servers (Standard: "127.0.0.1")
	#? Funktionsverhalten:
	#   - Die Funktion stoppt den Slave-Thread auf dem aktuellen Server.
	#   - Ändert den Host des MySQL-Master-Servers, den Benutzernamen und das Passwort für die Replikation auf die angegebenen Werte oder belässt sie auf den Standards, wenn keine Werte angegeben wurden.
	#   - Startet den Slave-Thread erneut, um die Replikation fortzusetzen.
	#? Beispielaufruf:
	#   Die Funktion kann direkt vom Benutzer aufgerufen werden und erlaubt die Option, Benutzername, Passwort und Hostadresse für die MySQL-Verbindung anzugeben.
	#   Beispiel 1: MASTER_HOST "meinbenutzer" "geheimesPasswort" "master.example.com"
	#   Beispiel 2: MASTER_HOST "andererbenutzer" # Benutzt den Standardbenutzernamen "root", ein leeres Passwort und die Hostadresse "127.0.0.1".
	#? Rückgabewert:
	# Diese Funktion gibt keine explizite Rückgabe aus, sondern führt die Konfigurations- und Aktivierungsschritte für die MySQL-Verbindung durch.
	#? Hinweise:
	#   - Stellen Sie sicher, dass Sie über ausreichende Berechtigungen für die MySQL-Verbindung und die Konfiguration des Master-Slave-Replikationsprozesses verfügen.
	#   - Die Hostadresse, der Benutzername und das Passwort sollten sicher gespeichert und übertragen werden, da sie Zugriff auf den MySQL-Master-Server ermöglichen.
##
function MASTER_HOST() {
	username=$1
	password=$2
	MASTERHOST=$3
	if [ -z "$username" ]; then username="root"; fi
	if [ -z "$password" ]; then password=""; fi
	if [ -z "$MASTERHOST" ]; then MASTERHOST='127.0.0.1'; fi

	mysqlrestnodb "$username" "$password" "STOP SLAVE;"
	mysqlrestnodb "$username" "$password" "CHANGE MASTER TO MASTER_HOST='$MASTERHOST', MASTER_USER='$username', MASTER_PASSWORD='$password', MASTER_USE_GTID=slave_pos;"
	mysqlrestnodb "$username" "$password" "START SLAVE;"
	#shellcheck disable=SC2128
	log text " $FUNCNAME: $result_mysqlrestnodb"
	return 0
}

## *  MASTER_HOST
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion konfiguriert und aktiviert die Verbindung zum MySQL-Master-Server unter Verwendung einer benutzerdefinierten Hostadresse, Benutzername und Passwort. Sie ermöglicht es, den Slave-Thread zu stoppen, den Host des MySQL-Master-Servers zu ändern und den Slave-Thread wieder zu starten.
	# Die Funktion akzeptiert optional einen Benutzernamen, ein Passwort und den Host des MySQL-Master-Servers für die MySQL-Verbindung. Wenn diese nicht angegeben werden, verwendet sie den Standardbenutzernamen "root", ein leeres Passwort und die Hostadresse "127.0.0.1".
	#? Parameter:
	#   - username (optional): Benutzername für die MySQL-Verbindung (Standard: "root")
	#   - password (optional): Passwort für die MySQL-Verbindung (Standard: Leer)
	#   - MASTERHOST (optional): Hostadresse des MySQL-Master-Servers (Standard: "127.0.0.1")
	#? Funktionsverhalten:
	#   - Die Funktion stoppt den Slave-Thread auf dem aktuellen Server.
	#   - Ändert den Host des MySQL-Master-Servers, den Benutzernamen und das Passwort für die Replikation auf die angegebenen Werte oder belässt sie auf den Standards, wenn keine Werte angegeben wurden.
	#   - Startet den Slave-Thread erneut, um die Replikation fortzusetzen.
	#? Beispielaufruf:
	#   Die Funktion kann direkt vom Benutzer aufgerufen werden und erlaubt die Option, Benutzername, Passwort und Hostadresse für die MySQL-Verbindung anzugeben.
	#   Beispiel 1: MASTER_HOST "meinbenutzer" "geheimesPasswort" "master.example.com"
	#   Beispiel 2: MASTER_HOST "andererbenutzer" # Benutzt den Standardbenutzernamen "root", ein leeres Passwort und die Hostadresse "127.0.0.1".
	#? Rückgabewert:
	# Diese Funktion gibt keine explizite Rückgabe aus, sondern führt die Konfigurations- und Aktivierungsschritte für die MySQL-Verbindung durch.
	#? Hinweise:
	#   - Stellen Sie sicher, dass Sie über ausreichende Berechtigungen für die MySQL-Verbindung und die Konfiguration des Master-Slave-Replikationsprozesses verfügen.
	#   - Die Hostadresse, der Benutzername und das Passwort sollten sicher gespeichert und übertragen werden, da sie Zugriff auf den MySQL-Master-Server ermöglichen.
##
function MASTER_PORT() {
	username=$1
	password=$2
	MASTERHOST=$3
	MASTERPORT=$4
	if [ -z "$username" ]; then username="root"; fi
	if [ -z "$password" ]; then password=""; fi
	if [ -z "$MASTERHOST" ]; then MASTERHOST='127.0.0.1'; fi
	if [ -z "$MASTERPORT" ]; then MASTERPORT='3306'; fi

	mysqlrestnodb "$username" "$password" "STOP SLAVE;"
	mysqlrestnodb "$username" "$password" "CHANGE MASTER TO MASTER_HOST='$MASTERHOST', MASTER_PORT='$MASTERPORT', MASTER_USER='$username', MASTER_PASSWORD='$password', MASTER_USE_GTID=slave_pos;"
	mysqlrestnodb "$username" "$password" "START SLAVE;"
	#shellcheck disable=SC2128
	log text " $FUNCNAME: $result_mysqlrestnodb"
	return 0
}

## *  MASTER_CONNECT_RETRY
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion konfiguriert und aktiviert die Verbindung zum MySQL-Master-Server unter Verwendung einer benutzerdefinierten Wiederholungsanzahl für die Verbindungsversuche. Sie ermöglicht es, den Slave-Thread zu stoppen, die Anzahl der Verbindungsversuche zum Master-Server zu ändern und den Slave-Thread wieder zu starten.
	# Die Funktion akzeptiert optional einen Benutzernamen, ein Passwort und die Anzahl der Verbindungsversuche für die MySQL-Verbindung. Wenn diese nicht angegeben werden, verwendet sie den Standardbenutzernamen "root", ein leeres Passwort und eine Anzahl von 20 Verbindungsversuchen.
	#? Parameter:
	#   - username (optional): Benutzername für die MySQL-Verbindung (Standard: "root")
	#   - password (optional): Passwort für die MySQL-Verbindung (Standard: Leer)
	#   - MASTERCONNECTRETRY (optional): Anzahl der Verbindungsversuche zum MySQL-Master-Server (Standard: 20)
	#? Funktionsverhalten:
	#   - Die Funktion stoppt den Slave-Thread auf dem aktuellen Server.
	#   - Ändert die Anzahl der Verbindungsversuche zum MySQL-Master-Server auf den angegebenen Wert oder belässt sie auf dem Standardwert.
	#   - Startet den Slave-Thread erneut, um die Replikation fortzusetzen.
	#? Beispielaufruf:
	#   Die Funktion kann direkt vom Benutzer aufgerufen werden und erlaubt die Option, Benutzername, Passwort und die Anzahl der Verbindungsversuche für die MySQL-Verbindung anzugeben.
	#   Beispiel 1: MASTER_CONNECT_RETRY "meinbenutzer" "geheimesPasswort" 30
	#   Beispiel 2: MASTER_CONNECT_RETRY "andererbenutzer" # Benutzt den Standardbenutzernamen "root", ein leeres Passwort und 20 Verbindungsversuche.
	#? Rückgabewert:
	# Diese Funktion gibt keine explizite Rückgabe aus, sondern führt die Konfigurations- und Aktivierungsschritte für die MySQL-Verbindung durch.
	#? Hinweise:
	#   - Stellen Sie sicher, dass Sie über ausreichende Berechtigungen für die MySQL-Verbindung und die Konfiguration des Master-Slave-Replikationsprozesses verfügen.
##
function MASTER_CONNECT_RETRY() {
	username=$1
	password=$2
	MASTERCONNECTRETRY=$3
	if [ -z "$username" ]; then username="root"; fi
	if [ -z "$password" ]; then password=""; fi
	if [ -z "$MASTERCONNECTRETRY" ]; then MASTERCONNECTRETRY='20'; fi

	mysqlrestnodb "$username" "$password" "STOP SLAVE;"
	mysqlrestnodb "$username" "$password" "CHANGE MASTER TO MASTER_CONNECT_RETRY=$MASTERCONNECTRETRY;"
	mysqlrestnodb "$username" "$password" "START SLAVE;"
	#shellcheck disable=SC2128
	log text " $FUNCNAME: $result_mysqlrestnodb"
	return 0
}

## *  MASTER_SSL
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion konfiguriert und aktiviert die Verwendung von SSL-verschlüsselten Verbindungen zwischen dem MySQL-Server und dem Slave-Server. Sie ermöglicht es, den Slave-Thread zu stoppen, die SSL-Verbindungsoptionen zu ändern und den Slave-Thread wieder zu starten.
	# Die Funktion akzeptiert optional einen Benutzernamen, ein Passwort und eine SSL-Verbindungsoption (1 für aktiviert oder 0 für deaktiviert). Wenn diese nicht angegeben werden, verwendet sie den Standardbenutzernamen "root", ein leeres Passwort und aktiviert SSL (MASTERSSL=1).
	#? Parameter:
	#   - username (optional): Benutzername für die MySQL-Verbindung (Standard: "root")
	#   - password (optional): Passwort für die MySQL-Verbindung (Standard: Leer)
	#   - MASTERSSL (optional): SSL-Verbindungsoption (1 für aktiviert, 0 für deaktiviert) (Standard: 1, aktiviert)
	#? Funktionsverhalten:
	#   - Die Funktion stoppt den Slave-Thread auf dem aktuellen Server.
	#   - Ändert die SSL-Verbindungsoption auf den angegebenen Wert oder belässt sie auf dem Standardwert (aktiviert).
	#   - Startet den Slave-Thread erneut, um die Replikation fortzusetzen.
	#? Beispielaufruf:
	#   Die Funktion kann direkt vom Benutzer aufgerufen werden und erlaubt die Option, Benutzername, Passwort und SSL-Verbindungsoption anzugeben.
	#   Beispiel 1: MASTER_SSL "meinbenutzer" "geheimesPasswort" 0
	#   Beispiel 2: MASTER_SSL "andererbenutzer" # Benutzt den Standardbenutzernamen "root", ein leeres Passwort und aktiviert SSL.
	#? Rückgabewert:
	# Diese Funktion gibt keine explizite Rückgabe aus, sondern führt die Konfigurations- und Aktivierungsschritte für die SSL-Verbindung durch.
	#? Hinweise:
	#   - Stellen Sie sicher, dass Sie über ausreichende Berechtigungen für die MySQL-Verbindung und die Konfiguration des Master-Slave-Replikationsprozesses verfügen.
##
function MASTER_SSL() {
	username=$1
	password=$2
	MASTERSSL=$3
	if [ -z "$username" ]; then username="root"; fi
	if [ -z "$password" ]; then password=""; fi
	if [ -z "$MASTERSSL" ]; then MASTERSSL=1; fi

	mysqlrestnodb "$username" "$password" "STOP SLAVE;"
	mysqlrestnodb "$username" "$password" "CHANGE MASTER TO MASTER_SSL=$MASTERSSL;"
	mysqlrestnodb "$username" "$password" "START SLAVE;"
	#shellcheck disable=SC2128
	log text " $FUNCNAME: $result_mysqlrestnodb"
	return 0
}

## *  MASTER_SSL_CA
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion konfiguriert und aktiviert die Verwendung von SSL-verschlüsselten Verbindungen zwischen dem MySQL-Server und dem Slave-Server unter Verwendung von SSL-Zertifikaten. Sie ermöglicht es, den Slave-Thread zu stoppen, die SSL-Verbindungsoptionen zu ändern und den Slave-Thread wieder zu starten.
	# Die Funktion akzeptiert optional einen Benutzernamen und ein Passwort. Wenn diese nicht angegeben werden, verwendet sie den Standardbenutzernamen "root" und ein leeres Passwort. Die SSL-Zertifikatsdateien und -optionen sind in der Funktion fest codiert, können jedoch an Ihre spezifischen Konfigurationsanforderungen angepasst werden.
	#? Parameter:
	#   - username (optional): Benutzername für die MySQL-Verbindung (Standard: "root")
	#   - password (optional): Passwort für die MySQL-Verbindung (Standard: Leer)
	#? Funktionsverhalten:
	#   - Die Funktion stoppt den Slave-Thread auf dem aktuellen Server.
	#   - Konfiguriert die SSL-Verbindungsoptionen unter Verwendung von fest codierten Zertifikatsdateien und Optionen.
	#   - Startet den Slave-Thread erneut, um die Replikation fortzusetzen.
	#? Beispielaufruf:
	#   Die Funktion kann direkt vom Benutzer aufgerufen werden und erlaubt die Option, Benutzername und Passwort anzugeben.
	#   Beispiel: MASTER_SSL_CA "meinbenutzer" "geheimesPasswort"
	#? Rückgabewert:
	# Diese Funktion gibt keine explizite Rückgabe aus, sondern führt die Konfigurations- und Aktivierungsschritte für die SSL-Verbindung durch.
	#? Hinweise:
	#   - Stellen Sie sicher, dass Sie über ausreichende Berechtigungen für die MySQL-Verbindung und die Verwendung von SSL-Zertifikaten verfügen.
	#   - Passen Sie die in der Funktion fest codierten SSL-Zertifikatsdateien und Optionen an Ihre spezifischen Anforderungen an.
##
function MASTER_SSL_CA() {
	username=$1
	password=$2
	if [ -z "$username" ]; then username="root"; fi
	if [ -z "$password" ]; then password=""; fi

	MASTERSSLCERT='/etc/my.cnf.d/certificates/server-cert.pem'
	MASTERSSLKEY='/etc/my.cnf.d/certificates/server-key.pem'
	MASTERSSLCA='/etc/my.cnf.d/certificates/ca.pem'
	MASTERSSLVERIFYSERVERCERT=1

	mysqlrestnodb "$username" "$password" "STOP SLAVE;"
	mysqlrestnodb "$username" "$password" "CHANGE MASTER TO MASTER_SSL_CERT='$MASTERSSLCERT', MASTER_SSL_KEY='$MASTERSSLKEY', MASTER_SSL_CA='$MASTERSSLCA', MASTER_SSL_VERIFY_SERVER_CERT=$MASTERSSLVERIFYSERVERCERT;"
	mysqlrestnodb "$username" "$password" "START SLAVE;"
	#shellcheck disable=SC2128
	log text " $FUNCNAME: $result_mysqlrestnodb"
	return 0
}

## *  MASTER_SSL_CAPATH
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion konfiguriert und aktiviert die Verwendung von SSL-verschlüsselten Verbindungen zwischen dem MySQL-Server und dem Slave-Server unter Verwendung von SSL-Zertifikaten und einem Verzeichnis für Zertifikate (CA-Path). Sie ermöglicht es, den Slave-Thread zu stoppen, die SSL-Verbindungsoptionen zu ändern und den Slave-Thread wieder zu starten.
	# Die Funktion akzeptiert optional einen Benutzernamen und ein Passwort. Wenn diese nicht angegeben werden, verwendet sie den Standardbenutzernamen "root" und ein leeres Passwort. Die SSL-Zertifikatsdateien und -optionen sind in der Funktion fest codiert, können jedoch an Ihre spezifischen Konfigurationsanforderungen angepasst werden.
	#? Parameter:
	#   - username (optional): Benutzername für die MySQL-Verbindung (Standard: "root")
	#   - password (optional): Passwort für die MySQL-Verbindung (Standard: Leer)
	#? Funktionsverhalten:
	#   - Die Funktion stoppt den Slave-Thread auf dem aktuellen Server.
	#   - Konfiguriert die SSL-Verbindungsoptionen unter Verwendung von fest codierten Zertifikatsdateien und Optionen sowie einem CA-Path-Verzeichnis für Zertifikate.
	#   - Startet den Slave-Thread erneut, um die Replikation fortzusetzen.
	#? Beispielaufruf:
	#   Die Funktion kann direkt vom Benutzer aufgerufen werden und erlaubt die Option, Benutzername und Passwort anzugeben.
	#   Beispiel: MASTER_SSL_CAPATH "meinbenutzer" "geheimesPasswort"
	#? Rückgabewert:
	# Diese Funktion gibt keine explizite Rückgabe aus, sondern führt die Konfigurations- und Aktivierungsschritte für die SSL-Verbindung durch.
	#? Hinweise:
	#   - Stellen Sie sicher, dass Sie über ausreichende Berechtigungen für die MySQL-Verbindung und die Verwendung von SSL-Zertifikaten verfügen.
	#   - Passen Sie die in der Funktion fest codierten SSL-Zertifikatsdateien und Optionen an Ihre spezifischen Anforderungen an.
	#   - Das CA-Path-Verzeichnis sollte Zertifikate im PEM-Format enthalten.
##
function MASTER_SSL_CAPATH() {
	username=$1
	password=$2
	if [ -z "$username" ]; then username="root"; fi
	if [ -z "$password" ]; then password=""; fi

	MASTERSSLCERT='/etc/my.cnf.d/certificates/server-cert.pem'
	MASTERSSLKEY='/etc/my.cnf.d/certificates/server-key.pem'
	MASTERSSLCAPATH='/etc/my.cnf.d/certificates/ca/'
	MASTERSSLVERIFYSERVERCERT=1

	mysqlrestnodb "$username" "$password" "STOP SLAVE;"
	mysqlrestnodb "$username" "$password" "CHANGE MASTER TO MASTER_SSL_CERT='$MASTERSSLCERT', MASTER_SSL_KEY='$MASTERSSLKEY', MASTER_SSL_CAPATH='$MASTERSSLCAPATH', MASTER_SSL_VERIFY_SERVER_CERT=$MASTERSSLVERIFYSERVERCERT;"
	mysqlrestnodb "$username" "$password" "START SLAVE;"
	#shellcheck disable=SC2128
	log text " $FUNCNAME: $result_mysqlrestnodb"
	return 0
}

## *  MASTER_SSL_CERT
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion konfiguriert und aktiviert die Verwendung von SSL-verschlüsselten Verbindungen zwischen dem MySQL-Server und dem Slave-Server unter Verwendung von SSL-Zertifikaten. Sie ermöglicht es, den Slave-Thread zu stoppen, die SSL-Verbindungsoptionen zu ändern und den Slave-Thread wieder zu starten.
	# Die Funktion akzeptiert optional einen Benutzernamen und ein Passwort. Wenn diese nicht angegeben werden, verwendet sie den Standardbenutzernamen "root" und ein leeres Passwort. Die SSL-Zertifikatsdateien und -optionen sind in der Funktion fest codiert, können jedoch an Ihre spezifischen Konfigurationsanforderungen angepasst werden.
	#? Parameter:
	#   - username (optional): Benutzername für die MySQL-Verbindung (Standard: "root")
	#   - password (optional): Passwort für die MySQL-Verbindung (Standard: Leer)
	#? Funktionsverhalten:
	#   - Die Funktion stoppt den Slave-Thread auf dem aktuellen Server.
	#   - Konfiguriert die SSL-Verbindungsoptionen unter Verwendung von fest codierten Zertifikatsdateien und Optionen.
	#   - Startet den Slave-Thread erneut, um die Replikation fortzusetzen.
	#? Beispielaufruf:
	#   Die Funktion kann direkt vom Benutzer aufgerufen werden und erlaubt die Option, Benutzername und Passwort anzugeben.
	#   Beispiel: MASTER_SSL_CERT "meinbenutzer" "geheimesPasswort"
	#? Rückgabewert:
	# Diese Funktion gibt keine explizite Rückgabe aus, sondern führt die Konfigurations- und Aktivierungsschritte für die SSL-Verbindung durch.
	#? Hinweise:
	#   - Stellen Sie sicher, dass Sie über ausreichende Berechtigungen für die MySQL-Verbindung und die Verwendung von SSL-Zertifikaten verfügen.
	#   - Passen Sie die in der Funktion fest codierten SSL-Zertifikatsdateien und Optionen an Ihre spezifischen Anforderungen an.
##
function MASTER_SSL_CERT() {
	username=$1
	password=$2
	if [ -z "$username" ]; then username="root"; fi
	if [ -z "$password" ]; then password=""; fi

	MASTERSSLCERT='/etc/my.cnf.d/certificates/server-cert.pem'
	MASTERSSLKEY='/etc/my.cnf.d/certificates/server-key.pem'
	MASTERSSLCA='/etc/my.cnf.d/certificates/ca.pem'
	MASTERSSLVERIFYSERVERCERT=1

	mysqlrestnodb "$username" "$password" "STOP SLAVE;"
	mysqlrestnodb "$username" "$password" "CHANGE MASTER TO MASTER_SSL_CERT='$MASTERSSLCERT', MASTER_SSL_KEY='$MASTERSSLKEY', MASTER_SSL_CA='$MASTERSSLCA', MASTER_SSL_VERIFY_SERVER_CERT=$MASTERSSLVERIFYSERVERCERT;"
	mysqlrestnodb "$username" "$password" "START SLAVE;"
	#shellcheck disable=SC2128
	log text " $FUNCNAME: $result_mysqlrestnodb"

	return 0
}

## *  MASTER_SSL_CRL
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion konfiguriert und aktiviert die Verwendung von SSL-verschlüsselten Verbindungen zwischen dem MySQL-Server und dem Slave-Server unter Verwendung von SSL-Zertifikaten und einer Zertifikatsperrliste (CRL - Certificate Revocation List). Sie ermöglicht es, den Slave-Thread zu stoppen, die SSL-Verbindungsoptionen zu ändern und den Slave-Thread wieder zu starten.
	# Die Funktion akzeptiert optional einen Benutzernamen und ein Passwort. Wenn diese nicht angegeben werden, verwendet sie den Standardbenutzernamen "root" und ein leeres Passwort. Die SSL-Zertifikatsdateien, Optionen und die CRL-Datei sind in der Funktion fest codiert und können an Ihre spezifischen Konfigurationsanforderungen angepasst werden.
	#? Parameter:
	#   - username (optional): Benutzername für die MySQL-Verbindung (Standard: "root")
	#   - password (optional): Passwort für die MySQL-Verbindung (Standard: Leer)
	#? Funktionsverhalten:
	#   - Die Funktion stoppt den Slave-Thread auf dem aktuellen Server.
	#   - Konfiguriert die SSL-Verbindungsoptionen unter Verwendung von fest codierten Zertifikatsdateien, Optionen und einer CRL-Datei.
	#   - Startet den Slave-Thread erneut, um die Replikation fortzusetzen.
	#? Beispielaufruf:
	#   Die Funktion kann direkt vom Benutzer aufgerufen werden und erlaubt die Option, Benutzername und Passwort anzugeben.
	#   Beispiel: MASTER_SSL_CRL "meinbenutzer" "geheimesPasswort"
	#? Rückgabewert:
	# Diese Funktion gibt keine explizite Rückgabe aus, sondern führt die Konfigurations- und Aktivierungsschritte für die SSL-Verbindung und CRL durch.
	#? Hinweise:
	#   - Stellen Sie sicher, dass Sie über ausreichende Berechtigungen für die MySQL-Verbindung und die Verwendung von SSL-Zertifikaten und CRLs verfügen.
	#   - Passen Sie die in der Funktion fest codierten SSL-Zertifikatsdateien, Optionen und CRL-Dateipfade an Ihre spezifischen Anforderungen an.
##
function MASTER_SSL_CRL() {
	username=$1
	password=$2
	if [ -z "$username" ]; then username="root"; fi
	if [ -z "$password" ]; then password=""; fi

	MASTERSSLCERT='/etc/my.cnf.d/certificates/server-cert.pem'
	MASTERSSLKEY='/etc/my.cnf.d/certificates/server-key.pem'
	MASTERSSLCA='/etc/my.cnf.d/certificates/ca.pem'
	MASTERSSLVERIFYSERVERCERT=1

	mysqlrestnodb "$username" "$password" "STOP SLAVE;"
	mysqlrestnodb "$username" "$password" "CHANGE MASTER TO MASTER_SSL_CERT='$MASTERSSLCERT', MASTER_SSL_KEY='$MASTERSSLKEY', MASTER_SSL_CA='$MASTERSSLCA', MASTER_SSL_VERIFY_SERVER_CERT=$MASTERSSLVERIFYSERVERCERT, MASTER_SSL_CRL='/etc/my.cnf.d/certificates/crl.pem';"
	mysqlrestnodb "$username" "$password" "START SLAVE;"
	#shellcheck disable=SC2128
	log text " $FUNCNAME: $result_mysqlrestnodb"

	return 0
}

## *  MASTER_SSL_CRLPATH
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion konfiguriert und aktiviert die Verwendung von SSL-verschlüsselten Verbindungen zwischen dem MySQL-Server und dem Slave-Server unter Verwendung von SSL-Zertifikaten und einer Zertifikatsperrliste (CRL - Certificate Revocation List). Sie ermöglicht es, den Slave-Thread zu stoppen, die SSL-Verbindungsoptionen zu ändern und den Slave-Thread wieder zu starten.
	# Die Funktion akzeptiert optional einen Benutzernamen und ein Passwort. Wenn diese nicht angegeben werden, verwendet sie den Standardbenutzernamen "root" und ein leeres Passwort. Die SSL-Zertifikatsdateien, Optionen und das Verzeichnis für die CRL-Dateien sind in der Funktion fest codiert und können an Ihre spezifischen Konfigurationsanforderungen angepasst werden.
	#? Parameter:
	#   - username (optional): Benutzername für die MySQL-Verbindung (Standard: "root")
	#   - password (optional): Passwort für die MySQL-Verbindung (Standard: Leer)
	#? Funktionsverhalten:
	#   - Die Funktion stoppt den Slave-Thread auf dem aktuellen Server.
	#   - Konfiguriert die SSL-Verbindungsoptionen unter Verwendung von fest codierten Zertifikatsdateien, Optionen und eines CRL-Verzeichnisses.
	#   - Startet den Slave-Thread erneut, um die Replikation fortzusetzen.
	#? Beispielaufruf:
	#   Die Funktion kann direkt vom Benutzer aufgerufen werden und erlaubt die Option, Benutzername und Passwort anzugeben.
	#   Beispiel: MASTER_SSL_CRLPATH "meinbenutzer" "geheimesPasswort"
	#? Rückgabewert:
	# Diese Funktion gibt keine explizite Rückgabe aus, sondern führt die Konfigurations- und Aktivierungsschritte für die SSL-Verbindung und CRL durch.
	#? Hinweise:
	#   - Stellen Sie sicher, dass Sie über ausreichende Berechtigungen für die MySQL-Verbindung und die Verwendung von SSL-Zertifikaten und CRLs verfügen.
	#   - Passen Sie die in der Funktion fest codierten SSL-Zertifikatsdateien, Optionen und das Verzeichnis für die CRL-Dateien an Ihre spezifischen Anforderungen an.
##
function MASTER_SSL_CRLPATH() {
	username=$1
	password=$2
	if [ -z "$username" ]; then username="root"; fi
	if [ -z "$password" ]; then password=""; fi

	MASTERSSLCERT='/etc/my.cnf.d/certificates/server-cert.pem'
	MASTERSSLKEY='/etc/my.cnf.d/certificates/server-key.pem'
	MASTERSSLCA='/etc/my.cnf.d/certificates/ca.pem'
	MASTERSSLVERIFYSERVERCERT=1

	mysqlrestnodb "$username" "$password" "STOP SLAVE;"
	mysqlrestnodb "$username" "$password" "CHANGE MASTER TO MASTER_SSL_CERT='$MASTERSSLCERT', MASTER_SSL_KEY='$MASTERSSLKEY', MASTER_SSL_CA='$MASTERSSLCA', MASTER_SSL_VERIFY_SERVER_CERT=$MASTERSSLVERIFYSERVERCERT, MASTER_SSL_CRLPATH='/etc/my.cnf.d/certificates/crl/';"
	mysqlrestnodb "$username" "$password" "START SLAVE;"
	#shellcheck disable=SC2128
	log text " $FUNCNAME: $result_mysqlrestnodb"

	return 0
}

## *  MASTER_SSL_KEY
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion konfiguriert und aktiviert die Verwendung von SSL-verschlüsselten Verbindungen zwischen dem MySQL-Server und dem Slave-Server unter Verwendung von SSL-Zertifikaten und einem privaten Schlüssel. Sie ermöglicht es, den Slave-Thread zu stoppen, die SSL-Verbindungsoptionen zu ändern und den Slave-Thread wieder zu starten.
	# Die Funktion akzeptiert optional einen Benutzernamen und ein Passwort. Wenn diese nicht angegeben werden, verwendet sie den Standardbenutzernamen "root" und ein leeres Passwort. Die SSL-Zertifikatsdateien, Optionen und der Pfad zum privaten Schlüssel sind in der Funktion fest codiert und können an Ihre spezifischen Konfigurationsanforderungen angepasst werden.
	#? Parameter:
	#   - username (optional): Benutzername für die MySQL-Verbindung (Standard: "root")
	#   - password (optional): Passwort für die MySQL-Verbindung (Standard: Leer)
	#? Funktionsverhalten:
	#   - Die Funktion stoppt den Slave-Thread auf dem aktuellen Server.
	#   - Konfiguriert die SSL-Verbindungsoptionen unter Verwendung von fest codierten Zertifikatsdateien, Optionen und einem privaten Schlüssel.
	#   - Startet den Slave-Thread erneut, um die Replikation fortzusetzen.
	#? Beispielaufruf:
	#   Die Funktion kann direkt vom Benutzer aufgerufen werden und erlaubt die Option, Benutzername und Passwort anzugeben.
	#   Beispiel: MASTER_SSL_KEY "meinbenutzer" "geheimesPasswort"
	#? Rückgabewert:
	# Diese Funktion gibt keine explizite Rückgabe aus, sondern führt die Konfigurations- und Aktivierungsschritte für die SSL-Verbindung durch.
	#? Hinweise:
	#   - Stellen Sie sicher, dass Sie über ausreichende Berechtigungen für die MySQL-Verbindung und die Verwendung von SSL-Zertifikaten und privaten Schlüsseln verfügen.
	#   - Passen Sie die in der Funktion fest codierten SSL-Zertifikatsdateien, Optionen und den Pfad zum privaten Schlüssel an Ihre spezifischen Anforderungen an.
##
function MASTER_SSL_KEY() {
	username=$1
	password=$2
	if [ -z "$username" ]; then username="root"; fi
	if [ -z "$password" ]; then password=""; fi

	MASTERSSLCERT='/etc/my.cnf.d/certificates/server-cert.pem'
	MASTERSSLKEY='/etc/my.cnf.d/certificates/server-key.pem'
	MASTERSSLCA='/etc/my.cnf.d/certificates/ca.pem'
	MASTERSSLVERIFYSERVERCERT=1

	mysqlrestnodb "$username" "$password" "STOP SLAVE;"
	mysqlrestnodb "$username" "$password" "CHANGE MASTER TO MASTER_SSL_CERT='$MASTERSSLCERT', MASTER_SSL_KEY='$MASTERSSLKEY', MASTER_SSL_CA='$MASTERSSLCA', MASTER_SSL_VERIFY_SERVER_CERT=$MASTERSSLVERIFYSERVERCERT;"
	mysqlrestnodb "$username" "$password" "START SLAVE;"
	#shellcheck disable=SC2128
	log text " $FUNCNAME: $result_mysqlrestnodb"

	return 0
}

## *  MASTER_SSL_CIPHER
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion konfiguriert und aktiviert die Verwendung einer bestimmten SSL-Verschlüsselung für die Kommunikation zwischen dem MySQL-Server und dem Slave-Server. Sie ermöglicht das Festlegen einer spezifischen SSL-Cipher-Suite (Verschlüsselungsmethode) für die SSL-gesicherte Verbindung.
	# Die Funktion akzeptiert optional einen Benutzernamen und ein Passwort. Wenn diese nicht angegeben werden, verwendet sie den Standardbenutzernamen "root" und ein leeres Passwort. Die SSL-Zertifikatsdateien, Optionen und der Pfad zum privaten Schlüssel sind in der Funktion fest codiert und können an Ihre spezifischen Konfigurationsanforderungen angepasst werden.
	#? Parameter:
	#   - username (optional): Benutzername für die MySQL-Verbindung (Standard: "root")
	#   - password (optional): Passwort für die MySQL-Verbindung (Standard: Leer)
	#? Funktionsverhalten:
	#   - Die Funktion stoppt den Slave-Thread auf dem aktuellen Server.
	#   - Konfiguriert die SSL-Verbindungsoptionen unter Verwendung einer fest codierten SSL-Cipher-Suite (Verschlüsselungsmethode).
	#   - Startet den Slave-Thread erneut, um die Replikation fortzusetzen.
	#? Beispielaufruf:
	#   Die Funktion kann direkt vom Benutzer aufgerufen werden und erlaubt die Option, Benutzername und Passwort anzugeben.
	#   Beispiel: MASTER_SSL_CIPHER "meinbenutzer" "geheimesPasswort"
	#? Rückgabewert:
	# Diese Funktion gibt keine explizite Rückgabe aus, sondern führt die Konfigurations- und Aktivierungsschritte für die SSL-Cipher-Suite durch.
	#? Hinweise:
	#   - Stellen Sie sicher, dass Sie über ausreichende Berechtigungen für die MySQL-Verbindung und die Verwendung von SSL-Zertifikaten und privaten Schlüsseln verfügen.
	#   - Passen Sie die in der Funktion fest codierten SSL-Zertifikatsdateien, Optionen und den Pfad zum privaten Schlüssel an Ihre spezifischen Anforderungen an.
	#   - Die SSL-Cipher-Suite muss gemäß den Sicherheitsanforderungen Ihrer Umgebung ausgewählt werden.
##
function MASTER_SSL_CIPHER() {
	username=$1
	password=$2
	if [ -z "$username" ]; then username="root"; fi
	if [ -z "$password" ]; then password=""; fi

	MASTERSSLCERT='/etc/my.cnf.d/certificates/server-cert.pem'
	MASTERSSLKEY='/etc/my.cnf.d/certificates/server-key.pem'
	MASTERSSLCA='/etc/my.cnf.d/certificates/ca.pem'
	MASTERSSLVERIFYSERVERCERT=1

	mysqlrestnodb "$username" "$password" "STOP SLAVE;"
	mysqlrestnodb "$username" "$password" "CHANGE MASTER TO MASTER_SSL_CERT='$MASTERSSLCERT', MASTER_SSL_KEY='$MASTERSSLKEY', MASTER_SSL_CA='$MASTERSSLCA', MASTER_SSL_VERIFY_SERVER_CERT=$MASTERSSLVERIFYSERVERCERT, MASTER_SSL_CIPHER='TLSv1.2';"
	mysqlrestnodb "$username" "$password" "START SLAVE;"
	#shellcheck disable=SC2128
	log text " $FUNCNAME: $result_mysqlrestnodb"

	return 0
}

## *  MASTER_SSL_VERIFY_SERVER_CERT
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion konfiguriert und aktiviert die Überprüfung des Serverzertifikats (Server-Zertifikatsvalidierung) für die SSL-gesicherte Verbindung zwischen dem MySQL-Server und dem Slave-Server. Sie stellt sicher, dass der Slave-Server das Serverzertifikat des Master-Servers überprüft, um sicherzustellen, dass es gültig ist und zur Verbindung verwendet werden kann.
	# Die Funktion akzeptiert optional einen Benutzernamen und ein Passwort. Wenn diese nicht angegeben werden, verwendet sie den Standardbenutzernamen "root" und ein leeres Passwort. Die SSL-Zertifikatsdateien, Optionen und der Pfad zum privaten Schlüssel sind in der Funktion fest codiert und können an Ihre spezifischen Konfigurationsanforderungen angepasst werden.
	#? Parameter:
	#   - username (optional): Benutzername für die MySQL-Verbindung (Standard: "root")
	#   - password (optional): Passwort für die MySQL-Verbindung (Standard: Leer)
	#? Funktionsverhalten:
	#   - Die Funktion stoppt den Slave-Thread auf dem aktuellen Server.
	#   - Konfiguriert die SSL-Verbindungsoptionen, um die Überprüfung des Serverzertifikats (Server-Zertifikatsvalidierung) zu aktivieren.
	#   - Startet den Slave-Thread erneut, um die Replikation fortzusetzen.
	#? Beispielaufruf:
	#   Die Funktion kann direkt vom Benutzer aufgerufen werden und erlaubt die Option, Benutzername und Passwort anzugeben.
	#   Beispiel: MASTER_SSL_VERIFY_SERVER_CERT "meinbenutzer" "geheimesPasswort"
	#? Rückgabewert:
	# Diese Funktion gibt keine explizite Rückgabe aus, sondern führt die Konfigurations- und Aktivierungsschritte für die Serverzertifikatsvalidierung durch.
	#? Hinweise:
	#   - Stellen Sie sicher, dass Sie über ausreichende Berechtigungen für die MySQL-Verbindung und die Verwendung von SSL-Zertifikaten und privaten Schlüsseln verfügen.
	#   - Passen Sie die in der Funktion fest codierten SSL-Zertifikatsdateien, Optionen und den Pfad zum privaten Schlüssel an Ihre spezifischen Anforderungen an.
##
function MASTER_SSL_VERIFY_SERVER_CERT() {
	username=$1
	password=$2
	if [ -z "$username" ]; then username="root"; fi
	if [ -z "$password" ]; then password=""; fi

	MASTERSSLCERT='/etc/my.cnf.d/certificates/server-cert.pem'
	MASTERSSLKEY='/etc/my.cnf.d/certificates/server-key.pem'
	MASTERSSLCA='/etc/my.cnf.d/certificates/ca.pem'
	MASTERSSLVERIFYSERVERCERT=1

	mysqlrestnodb "$username" "$password" "STOP SLAVE;"
	mysqlrestnodb "$username" "$password" "CHANGE MASTER TO MASTER_SSL_CERT='$MASTERSSLCERT', MASTER_SSL_KEY='$MASTERSSLKEY', MASTER_SSL_CA='$MASTERSSLCA', MASTER_SSL_VERIFY_SERVER_CERT=$MASTERSSLVERIFYSERVERCERT;"
	mysqlrestnodb "$username" "$password" "START SLAVE;"
	#shellcheck disable=SC2128
	log text " $FUNCNAME: $result_mysqlrestnodb"

	return 0
}

## *  MASTER_LOG_FILE
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion konfiguriert den MySQL-Server, um den gewünschten binären Protokoll-Dateinamen und die Position im binären Protokoll festzulegen, von dem die Replikation beginnen soll. Sie ermöglicht die genaue Steuerung der Replikationsquelle auf dem Slave-Server.
	# Die Funktion akzeptiert optional einen Benutzernamen und ein Passwort. Wenn diese nicht angegeben werden, verwendet sie den Standardbenutzernamen "root" und ein leeres Passwort.
	#? Parameter:
	#   - username (optional): Benutzername für die MySQL-Verbindung (Standard: "root")
	#   - password (optional): Passwort für die MySQL-Verbindung (Standard: Leer)
	#   - MASTERLOGFILE (optional): Der Name der binären Protokoll-Datei auf dem Master-Server, von der die Replikation beginnen soll (Standard: "master2-bin.001")
	#   - MASTERLOGPOS (optional): Die Position im binären Protokoll, von der die Replikation beginnen soll (Standard: 4)
	#? Funktionsverhalten:
	#   - Die Funktion stoppt den Slave-Thread auf dem aktuellen Server.
	#   - Konfiguriert den MySQL-Server, um den gewünschten binären Protokoll-Dateinamen und die Position im binären Protokoll festzulegen.
	#   - Startet den Slave-Thread erneut, um die Replikation von der angegebenen Position im binären Protokoll fortzusetzen.
	#? Beispielaufruf:
	#   Die Funktion kann direkt vom Benutzer aufgerufen werden und erlaubt die Option, Benutzername, Passwort, binären Protokoll-Dateinamen und Position anzugeben.
	#   Beispiel: MASTER_LOG_FILE "meinbenutzer" "geheimesPasswort" "master-bin.002" 1234
	#? Rückgabewert:
	# Diese Funktion gibt keine explizite Rückgabe aus, sondern führt die Konfigurations- und Aktivierungsschritte für die Replikation mit den angegebenen Parametern durch.
	#? Hinweise:
	#   - Stellen Sie sicher, dass Sie über ausreichende Berechtigungen für die MySQL-Verbindung und die Verwendung der Replikation verfügen.
	#   - Die Verwendung der richtigen binären Protokoll-Datei und Position ist entscheidend, um sicherzustellen, dass die Replikation korrekt funktioniert.
##
function MASTER_LOG_FILE() {
	username=$1
	password=$2
	MASTERLOGFILE=$3
	MASTERLOGPOS=$4
	if [ -z "$username" ]; then username="root"; fi
	if [ -z "$password" ]; then password=""; fi
	if [ -z "$MASTERLOGPOS" ]; then MASTERLOGPOS=4; fi
	if [ -z "$MASTERLOGFILE" ]; then MASTERLOGFILE="master2-bin.001"; fi

	mysqlrestnodb "$username" "$password" "STOP SLAVE;"
	mysqlrestnodb "$username" "CHANGE MASTER TO MASTER_LOG_FILE=$MASTERLOGFILE, MASTER_LOG_POS=$MASTERLOGPOS;"
	mysqlrestnodb "$username" "START SLAVE;"
	#shellcheck disable=SC2128
	log text " $FUNCNAME: $result_mysqlrestnodb"

	return 0
}

## *  MASTER_LOG_POS
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion konfiguriert den MySQL-Server, um die gewünschte Position im binären Protokoll und den dazugehörigen binären Protokoll-Dateinamen festzulegen, von denen die Replikation auf dem Slave-Server beginnen soll. Sie ermöglicht die genaue Steuerung der Replikationsquelle auf dem Slave-Server.
	# Die Funktion akzeptiert optional einen Benutzernamen und ein Passwort. Wenn diese nicht angegeben werden, verwendet sie den Standardbenutzernamen "root" und ein leeres Passwort.
	#? Parameter:
	#   - username (optional): Benutzername für die MySQL-Verbindung (Standard: "root")
	#   - password (optional): Passwort für die MySQL-Verbindung (Standard: Leer)
	#   - MASTERLOGPOS (optional): Die Position im binären Protokoll, von der die Replikation beginnen soll (Standard: 4)
	#   - MASTERLOGFILE (optional): Der Name der binären Protokoll-Datei auf dem Master-Server, von der die Replikation beginnen soll (Standard: "master2-bin.001")
	#? Funktionsverhalten:
	#   - Die Funktion stoppt den Slave-Thread auf dem aktuellen Server.
	#   - Konfiguriert den MySQL-Server, um die gewünschte Position im binären Protokoll und den dazugehörigen binären Protokoll-Dateinamen festzulegen.
	#   - Startet den Slave-Thread erneut, um die Replikation von der angegebenen Position im binären Protokoll fortzusetzen.
	#? Beispielaufruf:
	#   Die Funktion kann direkt vom Benutzer aufgerufen werden und erlaubt die Option, Benutzername, Passwort, Position im binären Protokoll und binären Protokoll-Dateinamen anzugeben.
	#   Beispiel: MASTER_LOG_POS "meinbenutzer" "geheimesPasswort" 1234 "master-bin.002"
	#? Rückgabewert:
	# Diese Funktion gibt keine explizite Rückgabe aus, sondern führt die Konfigurations- und Aktivierungsschritte für die Replikation mit den angegebenen Parametern durch.
	#? Hinweise:
	#   - Stellen Sie sicher, dass Sie über ausreichende Berechtigungen für die MySQL-Verbindung und die Verwendung der Replikation verfügen.
	#   - Die Verwendung der richtigen Position im binären Protokoll und des richtigen binären Protokoll-Dateinamens ist entscheidend, um sicherzustellen, dass die Replikation korrekt funktioniert.
##
function MASTER_LOG_POS() {
	username=$1
	password=$2
	MASTERLOGFILE=$2
	MASTERLOGPOS=$2
	if [ -z "$username" ]; then username="root"; fi
	if [ -z "$password" ]; then password=""; fi
	if [ -z "$MASTERLOGPOS" ]; then MASTERLOGPOS=4; fi
	if [ -z "$MASTERLOGFILE" ]; then MASTERLOGFILE="master2-bin.001"; fi

	mysqlrestnodb "$username" "$password" "STOP SLAVE;"
	mysqlrestnodb "$username" "$password" "CHANGE MASTER TO MASTER_LOG_FILE=$MASTERLOGFILE, MASTER_LOG_POS=$MASTERLOGPOS;"
	mysqlrestnodb "$username" "$password" "START SLAVE;"
	#shellcheck disable=SC2128
	log text " $FUNCNAME: $result_mysqlrestnodb"

	return 0
}

## *  RELAY_LOG_FILE
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion konfiguriert den MySQL-Server, um die gewünschte Position im Relay-Log und den dazugehörigen Relay-Log-Dateinamen festzulegen, von denen der SQL-Thread des Slave-Servers die Verarbeitung fortsetzen soll. Dies ermöglicht die Steuerung der Replikation auf dem Slave-Server.
	# Die Funktion akzeptiert optional einen Benutzernamen und ein Passwort. Wenn diese nicht angegeben werden, verwendet sie den Standardbenutzernamen "root" und ein leeres Passwort.
	#? Parameter:
	#   - username (optional): Benutzername für die MySQL-Verbindung (Standard: "root")
	#   - password (optional): Passwort für die MySQL-Verbindung (Standard: Leer)
	#   - RELAYLOGPOS (optional): Die Position im Relay-Log, von der der SQL-Thread die Verarbeitung fortsetzen soll (Standard: 4025)
	#   - RELAYLOGFILE (optional): Der Name der Relay-Log-Datei auf dem Slave-Server, von der der SQL-Thread die Verarbeitung fortsetzen soll (Standard: "slave-relay-bin.006")
	#? Funktionsverhalten:
	#   - Die Funktion stoppt den SQL-Thread auf dem Slave-Server.
	#   - Konfiguriert den MySQL-Server, um die gewünschte Position im Relay-Log und den dazugehörigen Relay-Log-Dateinamen festzulegen.
	#   - Startet den SQL-Thread erneut, um die Verarbeitung von der angegebenen Position im Relay-Log fortzusetzen.
	#? Beispielaufruf:
	#   Die Funktion kann direkt vom Benutzer aufgerufen werden und erlaubt die Option, Benutzername, Passwort, Position im Relay-Log und Relay-Log-Dateinamen anzugeben.
	#   Beispiel: RELAY_LOG_FILE "meinbenutzer" "geheimesPasswort" 5000 "slave-relay-bin.007"
	#? Rückgabewert:
	# Diese Funktion gibt keine explizite Rückgabe aus, sondern führt die Konfigurations- und Aktivierungsschritte für die Replikation mit den angegebenen Parametern durch.
	#? Hinweise:
	#   - Stellen Sie sicher, dass Sie über ausreichende Berechtigungen für die MySQL-Verbindung und die Verwendung der Replikation verfügen.
	#   - Die Verwendung der richtigen Position im Relay-Log und des richtigen Relay-Log-Dateinamens ist entscheidend, um sicherzustellen, dass die Replikation korrekt funktioniert.
##
function RELAY_LOG_FILE() {
	username=$1
	password=$2
	RELAYLOGFILE=$3
	RELAYLOGPOS=$4
	if [ -z "$username" ]; then username="root"; fi
	if [ -z "$password" ]; then password=""; fi
	if [ -z "$RELAYLOGPOS" ]; then RELAYLOGPOS=4025; fi
	if [ -z "$RELAYLOGFILE" ]; then RELAYLOGFILE="slave-relay-bin.006"; fi

	mysqlrestnodb "$username" "$password" "STOP SLAVE SQL_THREAD;"
	mysqlrestnodb "$username" "$password" "CHANGE MASTER TO RELAY_LOG_FILE=$RELAYLOGFILE, RELAY_LOG_POS=$RELAYLOGPOS;"
	mysqlrestnodb "$username" "$password" "START SLAVE SQL_THREAD;"
	#shellcheck disable=SC2128
	log text " $FUNCNAME: $result_mysqlrestnodb"

	return 0
}

## *  RELAY_LOG_POS
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion konfiguriert den MySQL-Server, um die gewünschte Position im Relay-Log festzulegen, von der der SQL-Thread des Slave-Servers die Verarbeitung fortsetzen soll. Dies ermöglicht die Steuerung der Replikation auf dem Slave-Server.
	# Die Funktion akzeptiert optional einen Benutzernamen und ein Passwort. Wenn diese nicht angegeben werden, verwendet sie den Standardbenutzernamen "root" und ein leeres Passwort.
	#? Parameter:
	#   - username (optional): Benutzername für die MySQL-Verbindung (Standard: "root")
	#   - password (optional): Passwort für die MySQL-Verbindung (Standard: Leer)
	#   - RELAYLOGPOS (optional): Die Position im Relay-Log, von der der SQL-Thread die Verarbeitung fortsetzen soll (Standard: 4025)
	#   - RELAYLOGFILE (optional): Der Name der Relay-Log-Datei auf dem Slave-Server, von der der SQL-Thread die Verarbeitung fortsetzen soll (Standard: "slave-relay-bin.006")
	#? Funktionsverhalten:
	#   - Die Funktion stoppt den SQL-Thread auf dem Slave-Server.
	#   - Konfiguriert den MySQL-Server, um die gewünschte Position im Relay-Log festzulegen.
	#   - Startet den SQL-Thread erneut, um die Verarbeitung von der angegebenen Position im Relay-Log fortzusetzen.
	#? Beispielaufruf:
	#   Die Funktion kann direkt vom Benutzer aufgerufen werden und erlaubt die Option, Benutzername, Passwort, Position im Relay-Log und Relay-Log-Dateinamen anzugeben.
	#   Beispiel: RELAY_LOG_POS "meinbenutzer" "geheimesPasswort" 5000 "slave-relay-bin.007"
	#? Rückgabewert:
	# Diese Funktion gibt keine explizite Rückgabe aus, sondern führt die Konfigurations- und Aktivierungsschritte für die Replikation mit den angegebenen Parametern durch.
	#? Hinweise:
	#   - Stellen Sie sicher, dass Sie über ausreichende Berechtigungen für die MySQL-Verbindung und die Verwendung der Replikation verfügen.
	#   - Die Verwendung der richtigen Position im Relay-Log ist entscheidend, um sicherzustellen, dass die Replikation korrekt funktioniert.
##
function RELAY_LOG_POS() {
	username=$1
	password=$2
	RELAYLOGFILE=$3
	RELAYLOGPOS=$4
	if [ -z "$username" ]; then username="root"; fi
	if [ -z "$password" ]; then password=""; fi
	if [ -z "$RELAYLOGPOS" ]; then RELAYLOGPOS=4025; fi
	if [ -z "$RELAYLOGFILE" ]; then RELAYLOGFILE="slave-relay-bin.006"; fi

	mysqlrestnodb "$username" "$password" "STOP SLAVE SQL_THREAD;"
	mysqlrestnodb "$username" "$password" "CHANGE MASTER TO RELAY_LOG_FILE=$RELAYLOGFILE, RELAY_LOG_POS=$RELAYLOGPOS;"
	mysqlrestnodb "$username" "$password" "START SLAVE SQL_THREAD;"
	#shellcheck disable=SC2128
	log text " $FUNCNAME: $result_mysqlrestnodb"

	return 0
}

## *  MASTER_USE_GTID
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion konfiguriert den MySQL-Server, um das Global Transaction Identifier (GTID)-Replikationsformat zu verwenden. GTID ist eine Methode zur eindeutigen Identifizierung von Transaktionen in einer Replikationsumgebung.
	# Die Funktion akzeptiert optional einen Benutzernamen und ein Passwort. Wenn diese nicht angegeben werden, verwendet sie den Standardbenutzernamen "root" und ein leeres Passwort.
	#? Parameter:
	#   - username (optional): Benutzername für die MySQL-Verbindung (Standard: "root")
	#   - password (optional): Passwort für die MySQL-Verbindung (Standard: Leer)
	#? Funktionsverhalten:
	#   - Die Funktion stoppt den Slave-SQL-Thread auf dem Slave-Server.
	#   - Konfiguriert den MySQL-Server, um das GTID-Replikationsformat zu verwenden.
	#   - Startet den Slave-SQL-Thread erneut, um die Verarbeitung mit GTID fortzusetzen.
	#? Beispielaufruf:
	#   Die Funktion kann direkt vom Benutzer aufgerufen werden und erlaubt die Option, Benutzername und Passwort anzugeben.
	#   Beispiel: MASTER_USE_GTID "meinbenutzer" "geheimesPasswort"
	#? Rückgabewert:
	# Diese Funktion gibt keine explizite Rückgabe aus, sondern führt die Konfigurations- und Aktivierungsschritte für die Verwendung von GTID in der Replikation durch.
	#? Hinweise:
	#   - Stellen Sie sicher, dass Sie über ausreichende Berechtigungen für die MySQL-Verbindung und die Verwendung von GTID verfügen.
##
function MASTER_USE_GTID() {
	username=$1
	password=$2
	if [ -z "$username" ]; then username="root"; fi
	if [ -z "$password" ]; then password=""; fi

	mysqlrestnodb "$username" "$password" "STOP SLAVE;"
	mysqlrestnodb "$username" "$password" "CHANGE MASTER TO MASTER_USE_GTID = current_pos;"
	mysqlrestnodb "$username" "$password" "START SLAVE;"
	#shellcheck disable=SC2128
	log text " $FUNCNAME: $result_mysqlrestnodb"

	return 0
}

## *  MASTER_USE_GTID_slv
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion konfiguriert den MySQL-Server, um das Global Transaction Identifier (GTID)-Replikationsformat zu verwenden. GTID ist eine Methode zur eindeutigen Identifizierung von Transaktionen in einer Replikationsumgebung.
	# Die Funktion akzeptiert optional einen Benutzernamen und ein Passwort. Wenn diese nicht angegeben werden, verwendet sie den Standardbenutzernamen "root" und ein leeres Passwort.
	#? Parameter:
	#   - username (optional): Benutzername für die MySQL-Verbindung (Standard: "root")
	#   - password (optional): Passwort für die MySQL-Verbindung (Standard: Leer)
	#? Funktionsverhalten:
	#   - Die Funktion stoppt den Slave-SQL-Thread auf dem Slave-Server.
	#   - Konfiguriert den MySQL-Server, um das GTID-Replikationsformat zu verwenden.
	#   - Startet den Slave-SQL-Thread erneut, um die Verarbeitung mit GTID fortzusetzen.
	#? Beispielaufruf:
	#   Die Funktion kann direkt vom Benutzer aufgerufen werden und erlaubt die Option, Benutzername und Passwort anzugeben.
	#   Beispiel: MASTER_USE_GTID "meinbenutzer" "geheimesPasswort"
	#? Rückgabewert:
	# Diese Funktion gibt keine explizite Rückgabe aus, sondern führt die Konfigurations- und Aktivierungsschritte für die Verwendung von GTID in der Replikation durch.
	#? Hinweise:
	#   - Stellen Sie sicher, dass Sie über ausreichende Berechtigungen für die MySQL-Verbindung und die Verwendung von GTID verfügen.
## 
function MASTER_USE_GTID_slv() {
	username=$1
	password=$2
	gtidslavepos=$3
	if [ -z "$username" ]; then username="root"; fi
	if [ -z "$password" ]; then password=""; fi
	if [ -z "$gtidslavepos" ]; then gtidslavepos='0-1-153'; fi

	mysqlrestnodb "$username" "$password" "STOP SLAVE;"
	mysqlrestnodb "$username" "$password" "SET GLOBAL gtid_slave_pos='$gtidslavepos';"
	mysqlrestnodb "$username" "$password" "CHANGE MASTER TO MASTER_USE_GTID = slave_pos;"
	mysqlrestnodb "$username" "$password" "START SLAVE;"
	#shellcheck disable=SC2128
	log text " $FUNCNAME: $result_mysqlrestnodb"

	return 0
}

## *  IGNORE_SERVER_IDS
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion konfiguriert den MySQL-Server, um bestimmte Server-IDs in der Replikation zu ignorieren. Server-IDs sind ein Mechanismus zur Identifizierung von Quell- und Zielsystemen in einer Replikationsumgebung.
	# Die Funktion akzeptiert einen Benutzernamen, ein Passwort und eine Liste von Server-IDs, die ignoriert werden sollen.
	#? Parameter:
	#   - username (optional): Benutzername für die MySQL-Verbindung (Standard: "root")
	#   - password (optional): Passwort für die MySQL-Verbindung (Standard: Leer)
	#   - ids: Eine kommaseparierte Liste von Server-IDs, die in der Replikation ignoriert werden sollen.
	#? Funktionsverhalten:
	#   - Die Funktion stoppt den Slave-SQL-Thread auf dem Slave-Server.
	#   - Konfiguriert den MySQL-Server, um die angegebenen Server-IDs in der Replikation zu ignorieren.
	#   - Startet den Slave-SQL-Thread erneut, um die Verarbeitung fortzusetzen.
	#? Beispielaufruf:
	#   Die Funktion kann direkt vom Benutzer aufgerufen werden und erfordert die Angabe von Benutzername, Passwort und einer Liste von Server-IDs.
	#   Beispiel: IGNORE_SERVER_IDS "meinbenutzer" "geheimesPasswort" "2,3,5"
	#? Rückgabewert:
	# Diese Funktion gibt keine explizite Rückgabe aus, sondern führt die Konfigurations- und Aktivierungsschritte zur Ignorierung von Server-IDs in der Replikation durch.
	#? Hinweise:
	#   - Stellen Sie sicher, dass Sie über ausreichende Berechtigungen für die MySQL-Verbindung und die Konfiguration der Server-IDs verfügen.
##
function IGNORE_SERVER_IDS() {
	username=$1
	password=$2
	ids=$3
	if [ -z "$username" ]; then username="root"; fi
	if [ -z "$password" ]; then password=""; fi

	mysqlrestnodb "$username" "$password" "STOP SLAVE;"
	mysqlrestnodb "$username" "$password" "CHANGE MASTER TO IGNORE_SERVER_IDS = ($ids);"
	mysqlrestnodb "$username" "$password" "START SLAVE;"
	#shellcheck disable=SC2128
	log text " $FUNCNAME: $result_mysqlrestnodb"

	return 0
}

## *  DO_DOMAIN_IDS
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion konfiguriert den MySQL-Server, um bestimmte Domänen-IDs in der Replikation zu verarbeiten. Domänen-IDs werden verwendet, um eine Gruppe von Transaktionen zu identifizieren, die zusammengehören. Mit dieser Funktion können Sie angeben, welche Domänen-IDs in der Replikation verarbeitet werden sollen.
	# Die Funktion akzeptiert einen Benutzernamen, ein Passwort und eine Liste von Domänen-IDs, die verarbeitet werden sollen.
	#? Parameter:
	#   - username (optional): Benutzername für die MySQL-Verbindung (Standard: "root")
	#   - password (optional): Passwort für die MySQL-Verbindung (Standard: Leer)
	#   - ids: Eine kommaseparierte Liste von Domänen-IDs, die in der Replikation verarbeitet werden sollen.
	#? Funktionsverhalten:
	#   - Die Funktion stoppt den Slave-SQL-Thread auf dem Slave-Server.
	#   - Konfiguriert den MySQL-Server, um die angegebenen Domänen-IDs in der Replikation zu verarbeiten.
	#   - Startet den Slave-SQL-Thread erneut, um die Verarbeitung fortzusetzen.
	#? Beispielaufruf:
	#   Die Funktion kann direkt vom Benutzer aufgerufen werden und erfordert die Angabe von Benutzername, Passwort und einer Liste von Domänen-IDs.
	#   Beispiel: DO_DOMAIN_IDS "meinbenutzer" "geheimesPasswort" "1,2,3"
	#? Rückgabewert:
	# Diese Funktion gibt keine explizite Rückgabe aus, sondern führt die Konfigurations- und Aktivierungsschritte zur Verarbeitung von Domänen-IDs in der Replikation durch.
	#? Hinweise:
	#   - Stellen Sie sicher, dass Sie über ausreichende Berechtigungen für die MySQL-Verbindung und die Konfiguration der Domänen-IDs verfügen.
##
function DO_DOMAIN_IDS() {
	username=$1
	password=$2
	ids=$3
	if [ -z "$username" ]; then username="root"; fi
	if [ -z "$password" ]; then password=""; fi

	mysqlrestnodb "$username" "$password" "STOP SLAVE;"
	mysqlrestnodb "$username" "$password" "CHANGE MASTER TO DO_DOMAIN_IDS = ($ids);"
	mysqlrestnodb "$username" "$password" "START SLAVE;"
	#shellcheck disable=SC2128
	log text " $FUNCNAME: $result_mysqlrestnodb"

	return 0
}

## *  DO_DOMAIN_IDS2_nids
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion konfiguriert den MySQL-Server, um bestimmte Domänen-IDs in der Replikation zu verarbeiten. Domänen-IDs werden verwendet, um eine Gruppe von Transaktionen zu identifizieren, die zusammengehören. Mit dieser Funktion können Sie angeben, welche Domänen-IDs in der Replikation verarbeitet werden sollen.
	# Die Funktion akzeptiert einen Benutzernamen, ein Passwort und eine Liste von Domänen-IDs, die verarbeitet werden sollen.
	#? Parameter:
	#   - username (optional): Benutzername für die MySQL-Verbindung (Standard: "root")
	#   - password (optional): Passwort für die MySQL-Verbindung (Standard: Leer)
	#   - ids: Eine kommaseparierte Liste von Domänen-IDs, die in der Replikation verarbeitet werden sollen.
	#? Funktionsverhalten:
	#   - Die Funktion stoppt den Slave-SQL-Thread auf dem Slave-Server.
	#   - Konfiguriert den MySQL-Server, um die angegebenen Domänen-IDs in der Replikation zu verarbeiten.
	#   - Startet den Slave-SQL-Thread erneut, um die Verarbeitung fortzusetzen.
	#? Beispielaufruf:
	#   Die Funktion kann direkt vom Benutzer aufgerufen werden und erfordert die Angabe von Benutzername, Passwort und einer Liste von Domänen-IDs.
	#   Beispiel: DO_DOMAIN_IDS "meinbenutzer" "geheimesPasswort" "1,2,3"
	#? Rückgabewert:
	# Diese Funktion gibt keine explizite Rückgabe aus, sondern führt die Konfigurations- und Aktivierungsschritte zur Verarbeitung von Domänen-IDs in der Replikation durch.
	#? Hinweise:
	#   - Stellen Sie sicher, dass Sie über ausreichende Berechtigungen für die MySQL-Verbindung und die Konfiguration der Domänen-IDs verfügen.
## 
function DO_DOMAIN_IDS2_nids() {
	username=$1
	password=$2
	if [ -z "$username" ]; then username="root"; fi
	if [ -z "$password" ]; then password=""; fi

	mysqlrestnodb "$username" "$password" "STOP SLAVE;"
	mysqlrestnodb "$username" "$password" "CHANGE MASTER TO DO_DOMAIN_IDS = ();"
	mysqlrestnodb "$username" "$password" "START SLAVE;"
	#shellcheck disable=SC2128
	log text " $FUNCNAME: $result_mysqlrestnodb"

	return 0
}

## *  IGNORE_DOMAIN_IDS
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion konfiguriert den MySQL-Server, um bestimmte Domänen-IDs in der Replikation zu ignorieren. Domänen-IDs werden verwendet, um eine Gruppe von Transaktionen zu identifizieren, die zusammengehören. Mit dieser Funktion können Sie angeben, welche Domänen-IDs in der Replikation ignoriert werden sollen.
	# Die Funktion akzeptiert einen Benutzernamen, ein Passwort und eine Liste von Domänen-IDs, die ignoriert werden sollen.
	#? Parameter:
	#   - username (optional): Benutzername für die MySQL-Verbindung (Standard: "root")
	#   - password (optional): Passwort für die MySQL-Verbindung (Standard: Leer)
	#   - ids: Eine kommaseparierte Liste von Domänen-IDs, die in der Replikation ignoriert werden sollen.
	#? Funktionsverhalten:
	#   - Die Funktion stoppt den Slave-SQL-Thread auf dem Slave-Server.
	#   - Konfiguriert den MySQL-Server, um die angegebenen Domänen-IDs in der Replikation zu ignorieren.
	#   - Startet den Slave-SQL-Thread erneut, um die Verarbeitung fortzusetzen.
	#? Beispielaufruf:
	#   Die Funktion kann direkt vom Benutzer aufgerufen werden und erfordert die Angabe von Benutzername, Passwort und einer Liste von Domänen-IDs.
	#   Beispiel: IGNORE_DOMAIN_IDS "meinbenutzer" "geheimesPasswort" "1,2,3"
	#? Rückgabewert:
	# Diese Funktion gibt keine explizite Rückgabe aus, sondern führt die Konfigurations- und Aktivierungsschritte zur Ignorierung von Domänen-IDs in der Replikation durch.
	#? Hinweise:
	#   - Stellen Sie sicher, dass Sie über ausreichende Berechtigungen für die MySQL-Verbindung und die Konfiguration der Domänen-IDs verfügen.
##
function IGNORE_DOMAIN_IDS() {
	username=$1
	password=$2
	ids=$3
	if [ -z "$username" ]; then username="root"; fi
	if [ -z "$password" ]; then password=""; fi

	mysqlrestnodb "$username" "$password" "STOP SLAVE;"
	mysqlrestnodb "$username" "$password" "CHANGE MASTER TO IGNORE_DOMAIN_IDS = ($ids);"
	mysqlrestnodb "$username" "$password" "START SLAVE;"
	#shellcheck disable=SC2128
	log text " $FUNCNAME: $result_mysqlrestnodb"

	return 0
}

## *  IGNORE_DOMAIN_IDS2_nids
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion konfiguriert den MySQL-Server, um bestimmte Domänen-IDs in der Replikation zu ignorieren. Domänen-IDs werden verwendet, um eine Gruppe von Transaktionen zu identifizieren, die zusammengehören. Mit dieser Funktion können Sie angeben, welche Domänen-IDs in der Replikation ignoriert werden sollen.
	# Die Funktion akzeptiert einen Benutzernamen, ein Passwort und eine Liste von Domänen-IDs, die ignoriert werden sollen.
	#? Parameter:
	#   - username (optional): Benutzername für die MySQL-Verbindung (Standard: "root")
	#   - password (optional): Passwort für die MySQL-Verbindung (Standard: Leer)
	#   - ids: Eine kommaseparierte Liste von Domänen-IDs, die in der Replikation ignoriert werden sollen.
	#? Funktionsverhalten:
	#   - Die Funktion stoppt den Slave-SQL-Thread auf dem Slave-Server.
	#   - Konfiguriert den MySQL-Server, um die angegebenen Domänen-IDs in der Replikation zu ignorieren.
	#   - Startet den Slave-SQL-Thread erneut, um die Verarbeitung fortzusetzen.
	#? Beispielaufruf:
	#   Die Funktion kann direkt vom Benutzer aufgerufen werden und erfordert die Angabe von Benutzername, Passwort und einer Liste von Domänen-IDs.
	#   Beispiel: IGNORE_DOMAIN_IDS "meinbenutzer" "geheimesPasswort" "1,2,3"
	#? Rückgabewert:
	# Diese Funktion gibt keine explizite Rückgabe aus, sondern führt die Konfigurations- und Aktivierungsschritte zur Ignorierung von Domänen-IDs in der Replikation durch.
	#? Hinweise:
	#   - Stellen Sie sicher, dass Sie über ausreichende Berechtigungen für die MySQL-Verbindung und die Konfiguration der Domänen-IDs verfügen.
##
function IGNORE_DOMAIN_IDS2_nids() {
	username=$1
	password=$2
	if [ -z "$username" ]; then username="root"; fi
	if [ -z "$password" ]; then password=""; fi

	mysqlrestnodb "$username" "$password" "STOP SLAVE;"
	mysqlrestnodb "$username" "$password" "CHANGE MASTER TO IGNORE_DOMAIN_IDS = ();"
	mysqlrestnodb "$username" "$password" "START SLAVE;"
	#shellcheck disable=SC2128
	log text " $FUNCNAME: $result_mysqlrestnodb"

	return 0
}

## *  MASTER_DELAY
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion konfiguriert den MySQL-Server, um eine Verzögerung in der Replikation einzuführen. Dies kann nützlich sein, um Daten auf dem Slave-Server zeitverzögert zu replizieren, um vorübergehende Fehler oder unerwünschte Änderungen zu verhindern.
	# Die Funktion akzeptiert einen Benutzernamen, ein Passwort und die Verzögerungszeit in Sekunden.
	#? Parameter:
	#   - username (optional): Benutzername für die MySQL-Verbindung (Standard: "root")
	#   - password (optional): Passwort für die MySQL-Verbindung (Standard: Leer)
	#   - MASTERDELAY (optional): Die Verzögerungszeit in Sekunden (Standard: 3600 Sekunden / 1 Stunde).
	#? Funktionsverhalten:
	#   - Die Funktion stoppt den Slave-SQL-Thread auf dem Slave-Server.
	#   - Konfiguriert den MySQL-Server, um die angegebene Verzögerungszeit in der Replikation zu verwenden.
	#   - Startet den Slave-SQL-Thread erneut, um die Verarbeitung fortzusetzen.
	#? Beispielaufruf:
	#   Die Funktion kann direkt vom Benutzer aufgerufen werden und erfordert die Angabe von Benutzername, Passwort und Verzögerungszeit in Sekunden.
	#   Beispiel: MASTER_DELAY "meinbenutzer" "geheimesPasswort" 1800
	#? Rückgabewert:
	# Diese Funktion gibt keine explizite Rückgabe aus, sondern führt die Konfiguration der Verzögerung in der Replikation durch.
	#? Hinweise:
	#   - Stellen Sie sicher, dass Sie über ausreichende Berechtigungen für die MySQL-Verbindung und die Konfiguration der Verzögerung verfügen.
##
function MASTER_DELAY() {
	username=$1
	password=$2
	MASTERDELAY=$3
	if [ -z "$username" ]; then username="root"; fi
	if [ -z "$password" ]; then password=""; fi
	if [ -z "$MASTERDELAY" ]; then MASTERDELAY=3600; fi

	mysqlrestnodb "$username" "$password" "STOP SLAVE;"
	mysqlrestnodb "$username" "$password" "CHANGE MASTER TO MASTER_DELAY=$MASTERDELAY;"
	mysqlrestnodb "$username" "$password" "START SLAVE;"
	#shellcheck disable=SC2128
	log text " $FUNCNAME: $result_mysqlrestnodb"

	return 0
}

## *  Replica_Backup
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion konfiguriert den MySQL-Server auf einem Replika (Slave) für die Durchführung eines Backup-Prozesses. Sie akzeptiert einen Benutzernamen, ein Passwort, den Namen der Master-Log-Datei (MASTERLOGFILE) und die Position in dieser Datei (MASTERLOGPOS).
	#? Parameter:
	#   - username (optional): Benutzername für die MySQL-Verbindung (Standard: "root").
	#   - password (optional): Passwort für die MySQL-Verbindung (Standard: Leer).
	#   - MASTERLOGFILE (optional): Der Name der Master-Log-Datei (Standard: "master2-bin.001").
	#   - MASTERLOGPOS (optional): Die Position in der Master-Log-Datei (Standard: 4).
	#? Funktionsverhalten:
	#   - Die Funktion konfiguriert den MySQL-Server auf dem Replika (Slave) für die Verwendung der angegebenen Master-Log-Datei und Position in der Replikation.
	#   - Startet den Slave-Thread, um die Replikation fortzusetzen und Backups durchzuführen.
	#? Beispielaufruf:
	#   Die Funktion kann direkt vom Benutzer aufgerufen werden und erfordert die Angabe von Benutzername, Passwort, Master-Log-Datei und Position.
	#   Beispiel: Replica_Backup "meinbenutzer" "geheimesPasswort" "master2-bin.001" 4
	#? Rückgabewert:
	# Diese Funktion gibt keine explizite Rückgabe aus, sondern führt die Konfiguration für das Backup auf dem Replika durch.
	#? Hinweise:
	#   - Stellen Sie sicher, dass Sie über ausreichende Berechtigungen für die MySQL-Verbindung und die Konfiguration des Replikations-Backups verfügen.
##
function Replica_Backup() {
	username=$1
	password=$2
	MASTERLOGFILE=$3
	MASTERLOGPOS=$4
	if [ -z "$username" ]; then username="root"; fi
	if [ -z "$password" ]; then password=""; fi
	if [ -z "$MASTERLOGFILE" ]; then MASTERLOGFILE="master2-bin.001"; fi
	if [ -z "$MASTERLOGPOS" ]; then MASTERLOGPOS=4; fi

	mysqlrestnodb "$username" "$password" "CHANGE MASTER TO MASTER_LOG_FILE=$MASTERLOGFILE, MASTER_LOG_POS=$MASTERLOGPOS;"
	mysqlrestnodb "$username" "$password" "START SLAVE;"
	#shellcheck disable=SC2128
	log text " $FUNCNAME: $result_mysqlrestnodb"

	return 0
}

## *  Replica_Backup_nmlp
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion konfiguriert den MySQL-Server auf einem Replika (Slave) für die Durchführung eines Backup-Prozesses. Sie akzeptiert einen Benutzernamen, ein Passwort, den Namen der Master-Log-Datei (MASTERLOGFILE) und die Position in dieser Datei (MASTERLOGPOS).
	#? Parameter:
	#   - username (optional): Benutzername für die MySQL-Verbindung (Standard: "root").
	#   - password (optional): Passwort für die MySQL-Verbindung (Standard: Leer).
	#   - MASTERLOGFILE (optional): Der Name der Master-Log-Datei (Standard: "master2-bin.001").
	#   - MASTERLOGPOS (optional): Die Position in der Master-Log-Datei (Standard: 4).
	#? Funktionsverhalten:
	#   - Die Funktion konfiguriert den MySQL-Server auf dem Replika (Slave) für die Verwendung der angegebenen Master-Log-Datei und Position in der Replikation.
	#   - Startet den Slave-Thread, um die Replikation fortzusetzen und Backups durchzuführen.
	#? Beispielaufruf:
	#   Die Funktion kann direkt vom Benutzer aufgerufen werden und erfordert die Angabe von Benutzername, Passwort, Master-Log-Datei und Position.
	#   Beispiel: Replica_Backup "meinbenutzer" "geheimesPasswort" "master2-bin.001" 4
	#? Rückgabewert:
	# Diese Funktion gibt keine explizite Rückgabe aus, sondern führt die Konfiguration für das Backup auf dem Replika durch.
	#? Hinweise:
	#   - Stellen Sie sicher, dass Sie über ausreichende Berechtigungen für die MySQL-Verbindung und die Konfiguration des Replikations-Backups verfügen.
##
function Replica_Backup_nmlp() {
	username=$1
	password=$2
	gtidslavepos=$3
	if [ -z "$username" ]; then username="root"; fi
	if [ -z "$password" ]; then password=""; fi
	if [ -z "$gtidslavepos" ]; then gtidslavepos='0-1-153'; fi

	mysqlrestnodb "$username" "$password" "SET GLOBAL gtid_slave_pos='$gtidslavepos';"
	mysqlrestnodb "$username" "$password" "CHANGE MASTER TO MASTER_USE_GTID=slave_pos;"
	mysqlrestnodb "$username" "$password" "START SLAVE;"
	#shellcheck disable=SC2128
	log text " $FUNCNAME: $result_mysqlrestnodb"

	return 0
}

## *  ReplikatKoordinaten
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion ändert die Koordinaten eines Replikats (Slave) in MySQL. Sie akzeptiert einen Benutzernamen, ein Passwort, die Hostadresse des primären Servers (MASTERHOST), den Port des primären Servers (MASTERPORT), den Namen der Master-Log-Datei (MASTERLOGFILE), die Position in dieser Datei (MASTERLOGPOS) und die Anzahl der Verbindungsversuche (MASTERCONNECTRETRY).
	#? Parameter:
	#   - username (optional): Benutzername für die MySQL-Verbindung (Standard: "root").
	#   - password (optional): Passwort für die MySQL-Verbindung (Standard: Leer).
	#   - MASTERHOST (optional): Die Hostadresse des primären Servers (Standard: "127.0.0.1").
	#   - MASTERPORT (optional): Der Port des primären Servers (Standard: 3306).
	#   - MASTERLOGFILE (optional): Der Name der Master-Log-Datei (Standard: "master2-bin.001").
	#   - MASTERLOGPOS (optional): Die Position in der Master-Log-Datei (Standard: 4).
	#   - MASTERCONNECTRETRY (optional): Die Anzahl der Verbindungsversuche (Standard: 20).
	#? Funktionsverhalten:
	#   - Die Funktion ändert die Koordinaten des Replikats, um es so einzurichten, dass es den primären Server repliziert.
	#   - Startet den Slave-Thread, um die Replikation zu beginnen oder fortzusetzen.
	#? Beispielaufruf:
	#   Die Funktion kann direkt vom Benutzer aufgerufen werden und erfordert die Angabe von Benutzername, Passwort, Hostadresse des primären Servers, Port des primären Servers, Master-Log-Datei, Position in der Datei und Anzahl der Verbindungsversuche.
	#   Beispiel: ReplikatKoordinaten "meinbenutzer" "geheimesPasswort" "192.168.1.100" 3306 "master2-bin.001" 4 20
	#? Rückgabewert:
	# Diese Funktion gibt keine explizite Rückgabe aus, sondern ändert die Koordinaten des Replikats für die Replikation.
	#? Hinweise:
	#   - Stellen Sie sicher, dass Sie über ausreichende Berechtigungen für die MySQL-Verbindung und die Konfiguration des Replikats verfügen.
##
function ReplikatKoordinaten() {
	username=$1
	password=$2
	MASTERHOST=$3
	MASTERPORT=$4
	MASTERLOGFILE=$5
	MASTERLOGPOS=$6
	MASTERCONNECTRETRY=$7
	if [ -z "$username" ]; then username="root"; fi
	if [ -z "$password" ]; then password=""; fi

	# Dies aendert die Koordinaten des primaeren und des primaeren Binaerlogs.
	# Dies wird verwendet, wenn Sie das Replikat so einrichten moechten, dass es das primaere repliziert:

	mysqlrestnodb "$username" "$password" "CHANGE MASTER TO  MASTER_HOST=$MASTERHOST, MASTER_USER=$username, MASTER_PASSWORD=$password, MASTER_PORT=$MASTERPORT, MASTER_LOG_FILE=$MASTERLOGFILE, MASTER_LOG_POS=$MASTERLOGPOS, MASTER_CONNECT_RETRY=$MASTERCONNECTRETRY;"
	mysqlrestnodb "$username" "$password" "START SLAVE;"
	#shellcheck disable=SC2128
	log text " $FUNCNAME: $result_mysqlrestnodb"

	return 0
}

## *  db_tablesplitt
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion zerlegt eine SQL-Dump-Datei in separate SQL-Dateien für jede Tabelle und speichert sie in einem Verzeichnis mit dem Namen der Datenbank.
	#? Parameter:
	#   - $1: Die SQL-Dump-Datei, die zerlegt werden soll.
	#? Funktionsverhalten:
	#   - Die Funktion erstellt ein Verzeichnis mit dem Namen der Datenbank (ohne Dateiendung) im aktuellen Arbeitsverzeichnis.
	#   - Sie sucht nach Tabellennamen in der SQL-Dump-Datei und erstellt für jede Tabelle eine separate SQL-Datei im erstellten Verzeichnis.
	#? Beispielaufruf:
	#   Die Funktion kann direkt vom Benutzer aufgerufen werden und erfordert die Angabe der SQL-Dump-Datei als Parameter.
	#   Beispiel: db_tablesplitt "dump.sql"
	#? Rückgabewert:
	# Diese Funktion gibt keine explizite Rückgabe aus, sondern erstellt separate SQL-Dateien für jede Tabelle im angegebenen Verzeichnis.
	#? Hinweise:
	#   - Stellen Sie sicher, dass die SQL-Dump-Datei im aktuellen Verzeichnis vorhanden ist.
##
function db_tablesplitt() {
	VERZEICHNISNAME=$(basename "$1" .sql)
	STARTVERZEICHNIS=$(pwd)
	TABELLEN_ZAEHLER=0
	mkdir -p "$STARTVERZEICHNIS"/"$VERZEICHNISNAME"
	log info "Zerlege $VERZEICHNISNAME und kopiere alle Tabellen nach $STARTVERZEICHNIS/$VERZEICHNISNAME"

	#Schleife fuer jeden Tabellennamen, der in der bereitgestellten Dumpdatei gefunden wird

	# shellcheck disable=SC2013
	for TABELLENNAME in $(grep "Table structure for table " "$1" | awk -F"\`" \{'print $2'\}); do
		log info "Entpacke $TABELLENNAME..."
		#Extrahiert den tabellenspezifischen Dump in TABELLENNAME.sql
		sed -n "/^-- Table structure for table \`$TABELLENNAME\`/,/^-- Table structure for table/p" "$1" >"$STARTVERZEICHNIS"/"$VERZEICHNISNAME"/"$TABELLENNAME".sql
		TABELLEN_ZAEHLER=$((TABELLEN_ZAEHLER + 1))
		log info "Kopiere $TABELLENNAME nach $STARTVERZEICHNIS/$VERZEICHNISNAME/$TABELLENNAME.sql"
	done
}

## *  db_tablextract
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion extrahiert die SQL-Daten einer speziellen Tabelle aus einer SQL-Dump-Datei und speichert sie in einer separaten SQL-Datei.
	#? Parameter:
	#   - $1: Die SQL-Dump-Datei, aus der die Daten extrahiert werden sollen.
	#   - $2: Der Name der Tabelle, deren Daten extrahiert werden sollen.
	#? Funktionsverhalten:
	#   - Die Funktion erstellt ein Verzeichnis mit dem Namen der Datenbank (ohne Dateiendung) im aktuellen Arbeitsverzeichnis.
	#   - Sie sucht nach dem angegebenen Tabellennamen in der SQL-Dump-Datei und erstellt eine separate SQL-Datei mit den Daten dieser Tabelle im erstellten Verzeichnis.
	#? Beispielaufruf:
	#   Die Funktion kann direkt vom Benutzer aufgerufen werden und erfordert zwei Parameter: die SQL-Dump-Datei und den Tabellennamen.
	#   Beispiel: db_tablextract "dump.sql" "meine_tabelle"
	#? Rückgabewert:
	# Diese Funktion gibt keine explizite Rückgabe aus, sondern erstellt eine separate SQL-Datei für die angegebene Tabelle im angegebenen Verzeichnis.
	#? Hinweise:
	#   - Stellen Sie sicher, dass die SQL-Dump-Datei im aktuellen Verzeichnis vorhanden ist und der angegebene Tabellenname existiert.
##
function db_tablextract() {
	VERZEICHNISNAME=$(basename "$1" .sql)
	STARTVERZEICHNIS=$(pwd)
	TABELLEN_ZAEHLER=0
	mkdir -p "$STARTVERZEICHNIS"/"$VERZEICHNISNAME"
	log info "Kopiere $TABELLENNAME nach $STARTVERZEICHNIS/$VERZEICHNISNAME/$TABELLENNAME.sql"

	# shellcheck disable=SC2013
	for TABELLENNAME in $(grep -E "Table structure for table \`$2\`" "$1" | awk -F"\`" \{'print $2'\}); do
		log info "Entpacke $TABELLENNAME..."
		#Extrahiert den tabellenspezifischen Dump in TABELLENNAME.sql
		sed -n "/^-- Table structure for table \`$TABELLENNAME\`/,/^-- Table structure for table/p" "$1" >"$STARTVERZEICHNIS"/"$VERZEICHNISNAME"/"$TABELLENNAME".sql
		TABELLEN_ZAEHLER=$((TABELLEN_ZAEHLER + 1))
		log info "Habe $TABELLENNAME nach $STARTVERZEICHNIS/$VERZEICHNISNAME/$TABELLENNAME.sql kopiert"
	done
}

## *  db_tablextract_regex
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion extrahiert SQL-Daten von Tabellen, die einem bestimmten regulären Ausdruck in einer SQL-Dump-Datei entsprechen, und speichert sie in separaten SQL-Dateien.
	#? Parameter:
	#   - $1: Die SQL-Dump-Datei, aus der die Daten extrahiert werden sollen.
	#   - $2: Der reguläre Ausdruck, um Tabellen zu filtern und zu extrahieren.
	#   - $3: Der Name der Datenbank (optional). Wenn angegeben, werden nur Tabellen aus dieser Datenbank extrahiert.
	#? Funktionsverhalten:
	#   - Die Funktion erstellt ein Verzeichnis mit dem Namen der Datenbank (ohne Dateiendung) im aktuellen Arbeitsverzeichnis.
	#   - Sie sucht nach Tabellen, deren Namen dem angegebenen regulären Ausdruck entsprechen, in der SQL-Dump-Datei und erstellt separate SQL-Dateien für diese Tabellen im erstellten Verzeichnis.
	#? Beispielaufruf:
	#   Die Funktion kann direkt vom Benutzer aufgerufen werden und erfordert zwei oder drei Parameter: die SQL-Dump-Datei, den regulären Ausdruck und optional den Namen der Datenbank.
	#   Beispiel 1: db_tablextract_regex "dump.sql" "^(mytable1|mytable2)" "mydatabase"
	#   Beispiel 2 (ohne Angabe der Datenbank): db_tablextract_regex "dump.sql" "^(mytable1|mytable2)"
	#? Rückgabewert:
	# Diese Funktion gibt keine explizite Rückgabe aus, sondern erstellt separate SQL-Dateien für die extrahierten Tabellen im angegebenen Verzeichnis.
	#? Hinweise:
	#   - Stellen Sie sicher, dass die SQL-Dump-Datei im aktuellen Verzeichnis vorhanden ist und die angegebenen Tabellen (oder der reguläre Ausdruck) in der SQL-Dump-Datei vorhanden sind.
##
function db_tablextract_regex() {
	VERZEICHNISNAME=$(basename "$1" .sql)
	STARTVERZEICHNIS=$(pwd)
	TABELLEN_ZAEHLER=0
	mkdir -p "$STARTVERZEICHNIS"/"$VERZEICHNISNAME"

	# shellcheck disable=SC2013
	for TABELLENNAME in $(grep -E "Table structure for table \`$3" "$1" | awk -F"\`" \{'print $2'\}); do

		log info "Entpacke $TABELLENNAME..."

		#Extrahiert den tabellenspezifischen Dump in TABELLENNAME.sql
		sed -n "/^-- Table structure for table \`$TABELLENNAME\`/,/^-- Table structure for table/p" "$1" >"$STARTVERZEICHNIS"/"$VERZEICHNISNAME"/"$TABELLENNAME".sql
		TABELLEN_ZAEHLER=$((TABELLEN_ZAEHLER + 1))
		log info "Kopiere $TABELLENNAME structur $1 nach $STARTVERZEICHNIS/$VERZEICHNISNAME/$TABELLENNAME.sql"
	done
}

#───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
#────────────────────────────────────────────────────────────────────────────────────────── MariaDB Spielwiese Playground ──────────────────────────────────────────────────────────────────────────────────────────
#───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

## * check_and_repair
	# Datum: 13.11.2023
	#? Beschreibung:
	# Diese Funktion führt eine Überprüfung und Reparatur von MariaDB-Tabellen in einer bestimmten Datenbank durch.
	# Benutzer werden aufgefordert, den MariaDB-Benutzernamen, das Passwort und den Datenbanknamen einzugeben.
	# Anschließend wird das Tool "mysqlcheck" mit den eingegebenen Informationen aufgerufen, um automatische Reparaturen und Überprüfungen durchzuführen.
	#? Parameter:
	#   - Keine festen Parameter; Benutzer wird zur Eingabe von MariaDB-Benutzername, Passwort und Datenbankname aufgefordert.
	#? Funktionsverhalten:
	#   - Die Funktion gibt Aufforderungen aus, um den MariaDB-Benutzernamen, das Passwort und den Datenbanknamen einzugeben.
	#   - Das Tool "mysqlcheck" wird dann mit den eingegebenen Informationen aufgerufen, um automatische Reparaturen und Überprüfungen in der angegebenen Datenbank durchzuführen.
	#? Beispielaufruf:
	#   Die Funktion wird direkt vom Benutzer aufgerufen und führt Interaktionen zur Eingabe von MariaDB-Anmeldeinformationen durch.
	#   Beispiel: check_and_repair
	#? Rückgabewert:
	#   - Es gibt keinen expliziten Rückgabewert. Die Funktion führt jedoch Reparaturen und Überprüfungen in der angegebenen MariaDB-Datenbank durch.
	#? Hinweise:
	#   - Stellen Sie sicher, dass die erforderlichen MariaDB-Anmeldeinformationen korrekt eingegeben werden.
	#   - Der Benutzer sollte die Berechtigungen haben, um "mysqlcheck" auf die angegebene Datenbank anzuwenden.
	#   - Das Tool führt automatische Reparaturen durch, wenn es auf beschädigte Tabellen stößt.
##
function check_and_repair() {
    echo "Enter MariaDB username: " 
    read -r db_user
    echo "Enter MariaDB password: " 
    read -r db_password
    echo    # newline
    echo "Enter MariaDB database name: " 
    read -r db_name

    sudo mysqlcheck -u "${db_user}" -p"${db_password}" --auto-repair --check "${db_name}"
}

## * manual_repair
	# Datum: 13.11.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht dem Benutzer, manuell auf eine MariaDB-Datenbank zuzugreifen, um Tabellen auszuwählen und die "REPAIR TABLE"-Operation durchzuführen.
	# Benutzer werden aufgefordert, den MariaDB-Benutzernamen, das Passwort und den Datenbanknamen einzugeben. Anschließend wird eine interaktive MySQL-Shell geöffnet.
	# Der Benutzer kann dann Tabellen manuell auswählen und die "REPAIR TABLE"-Operation auf die ausgewählte Tabelle anwenden.
	#? Parameter:
	#   - Keine festen Parameter; Benutzer wird zur Eingabe von MariaDB-Benutzername, Passwort und Datenbankname aufgefordert.
	#? Funktionsverhalten:
	#   - Die Funktion gibt Aufforderungen aus, um den MariaDB-Benutzernamen, das Passwort und den Datenbanknamen einzugeben.
	#   - Öffnet eine interaktive MySQL-Shell, in der der Benutzer manuell Tabellen auswählen und die "REPAIR TABLE"-Operation durchführen kann.
	#? Beispielaufruf:
	#   Die Funktion wird direkt vom Benutzer aufgerufen und ermöglicht eine interaktive Reparatur von MariaDB-Tabellen.
	#   Beispiel: manual_repair
	#? Rückgabewert:
	#   - Es gibt keinen expliziten Rückgabewert. Die Funktion öffnet jedoch eine MySQL-Shell für interaktive Reparaturen.
	#? Hinweise:
	#   - Stellen Sie sicher, dass die erforderlichen MariaDB-Anmeldeinformationen korrekt eingegeben werden.
	#   - Der Benutzer sollte die Berechtigungen haben, um auf die angegebene Datenbank zuzugreifen und "REPAIR TABLE"-Operationen durchzuführen.
	#   - Der Benutzer sollte mit den erforderlichen MySQL-Befehlen vertraut sein, um Tabellen auszuwählen und Operationen durchzuführen.
##
function manual_repair() {
    echo "Enter MariaDB username: " 
    read -r db_user
    echo "Enter MariaDB password: " 
    read -r db_password
    echo    # newline
    echo "Enter MariaDB database name: " 
    read -r db_name

    mysql -u "${db_user}" -p"${db_password}" "${db_name}"

    # Benutzer wird aufgefordert, die Tabelle manuell auszuwählen und dann REPAIR TABLE auszuführen
}

## * repair_table
	# Datum: 13.11.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht dem Benutzer, eine bestimmte Tabelle in einer MariaDB-Datenbank manuell zu reparieren.
	# Benutzer werden aufgefordert, den MariaDB-Benutzernamen, das Passwort, den Datenbanknamen und den Namen der zu reparierenden Tabelle einzugeben.
	# Anschließend wird die "REPAIR TABLE"-Operation mit der Option "QUICK" auf die angegebene Tabelle angewendet.
	#? Parameter:
	#   - Keine festen Parameter; Benutzer wird zur Eingabe von MariaDB-Benutzername, Passwort, Datenbankname und Tabellennamen aufgefordert.
	#? Funktionsverhalten:
	#   - Die Funktion gibt Aufforderungen aus, um den MariaDB-Benutzernamen, das Passwort, den Datenbanknamen und den Tabellennamen einzugeben.
	#   - Führt die "REPAIR TABLE"-Operation mit der Option "QUICK" auf die angegebene Tabelle in der MariaDB-Datenbank durch.
	#? Beispielaufruf:
	#   Die Funktion wird direkt vom Benutzer aufgerufen und ermöglicht eine gezielte Reparatur einer bestimmten Tabelle.
	#   Beispiel: repair_table
	#? Rückgabewert:
	#   - Es gibt keinen expliziten Rückgabewert. Die Funktion führt jedoch die angegebene Reparatur auf der Tabelle durch.
	#? Hinweise:
	#   - Stellen Sie sicher, dass die erforderlichen MariaDB-Anmeldeinformationen und der Tabellenname korrekt eingegeben werden.
	#   - Der Benutzer sollte die Berechtigungen haben, um auf die angegebene Datenbank zuzugreifen und "REPAIR TABLE"-Operationen durchzuführen.
	#   - Die Verwendung der Option "QUICK" führt eine schnelle Reparatur durch und ist geeignet für nicht allzu umfangreiche Tabellen.
##
function repair_table() {
    echo "Enter MariaDB username: " 
    read -r db_user
    echo "Enter MariaDB password: " 
    read -r db_password
    echo    # newline
    echo "Enter MariaDB database name: " 
    read -r db_name
    echo "Enter table name to repair: " 
    read -r table_name

    mysql -u "${db_user}" -p"${db_password}" "${db_name}" -e "REPAIR TABLE ${table_name} QUICK;"
}

## * repair_table_entries
	# Datum: 13.11.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht dem Benutzer, alle Einträge in einer bestimmten Tabelle in einer MariaDB-Datenbank zu löschen.
	# Benutzer werden aufgefordert, den MariaDB-Benutzernamen, das Passwort, den Datenbanknamen und den Namen der Tabelle einzugeben, deren Einträge repariert werden sollen.
	# Anschließend wird die "DELETE FROM"-Operation auf die angegebene Tabelle angewendet, um alle Einträge zu löschen.
	#? Parameter:
	#   - Keine festen Parameter; Benutzer wird zur Eingabe von MariaDB-Benutzername, Passwort, Datenbankname und Tabellennamen aufgefordert.
	#? Funktionsverhalten:
	#   - Die Funktion gibt Aufforderungen aus, um den MariaDB-Benutzernamen, das Passwort, den Datenbanknamen und den Tabellennamen einzugeben.
	#   - Führt die "DELETE FROM"-Operation auf die angegebene Tabelle in der MariaDB-Datenbank durch, um alle Einträge zu löschen.
	#? Beispielaufruf:
	#   Die Funktion wird direkt vom Benutzer aufgerufen und ermöglicht das Löschen aller Einträge in einer bestimmten Tabelle.
	#   Beispiel: repair_table_entries
	#? Rückgabewert:
	#   - Es gibt keinen expliziten Rückgabewert. Die Funktion löscht jedoch alle Einträge in der angegebenen Tabelle.
	#? Hinweise:
	#   - Stellen Sie sicher, dass die erforderlichen MariaDB-Anmeldeinformationen und der Tabellenname korrekt eingegeben werden.
	#   - Der Benutzer sollte die Berechtigungen haben, um auf die angegebene Datenbank zuzugreifen und "DELETE FROM"-Operationen durchzuführen.
	#   - Das Löschen aller Einträge ist eine intensive Operation und sollte mit Vorsicht verwendet werden.
##
function repair_table_entries() {
    echo "Enter MariaDB username: " 
    read -r db_user
    echo "Enter MariaDB password: " 
    read -r db_password
    echo    # newline
    echo "Enter MariaDB database name: " 
    read -r db_name
    echo "Enter table name to repair entries: " 
    read -r table_name

    mysql -u "${db_user}" -p"${db_password}" "${db_name}" -e "DELETE FROM ${table_name};"
}

## * repair_single_entry
	# Datum: 13.11.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht dem Benutzer, einen einzelnen Eintrag in einer bestimmten Tabelle in einer MariaDB-Datenbank zu reparieren.
	# Benutzer werden aufgefordert, den MariaDB-Benutzernamen, das Passwort, den Datenbanknamen, den Tabellennamen und den Primärschlüsselwert des zu reparierenden Eintrags einzugeben.
	# Zuerst wird die "REPAIR TABLE"-Operation mit der Option "USE_FRM" auf die angegebene Tabelle angewendet. Dann wird der spezifizierte Eintrag anhand des Primärschlüssels gelöscht.
	#? Parameter:
	#   - Keine festen Parameter; Benutzer wird zur Eingabe von MariaDB-Benutzername, Passwort, Datenbankname, Tabellennamen und Primärschlüsselwert aufgefordert.
	#? Funktionsverhalten:
	#   - Die Funktion gibt Aufforderungen aus, um den MariaDB-Benutzernamen, das Passwort, den Datenbanknamen, den Tabellennamen und den Primärschlüsselwert einzugeben.
	#   - Führt die "REPAIR TABLE"-Operation mit der Option "USE_FRM" auf die angegebene Tabelle in der MariaDB-Datenbank durch.
	#   - Löscht den spezifizierten Eintrag anhand des Primärschlüssels in der angegebenen Tabelle.
	#? Beispielaufruf:
	#   Die Funktion wird direkt vom Benutzer aufgerufen und ermöglicht das Reparieren eines bestimmten Eintrags in einer Tabelle.
	#   Beispiel: repair_single_entry
	#? Rückgabewert:
	#   - Es gibt keinen expliziten Rückgabewert. Die Funktion führt jedoch die angegebene Reparatur auf dem Eintrag durch.
	#? Hinweise:
	#   - Stellen Sie sicher, dass die erforderlichen MariaDB-Anmeldeinformationen, der Tabellenname und der Primärschlüsselwert korrekt eingegeben werden.
	#   - Der Benutzer sollte die Berechtigungen haben, um auf die angegebene Datenbank zuzugreifen und "REPAIR TABLE"-Operationen durchzuführen.
	#   - Die Verwendung der Option "USE_FRM" kann hilfreich sein, wenn die interne Struktur der Tabelle beschädigt ist.
##
function repair_single_entry() {
    echo "Enter MariaDB username: " 
    read -r db_user
    echo "Enter MariaDB password: " 
    read -r db_password
    echo    # newline
    echo "Enter MariaDB database name: " 
    read -r db_name
    echo "Enter table name to repair entry: " 
    read -r table_name
    echo "Enter primary key value of the entry to repair: " 
    read -r primary_key_value

    mysql -u "${db_user}" -p"${db_password}" "${db_name}" -e "REPAIR TABLE ${table_name} USE_FRM;"
    mysql -u "${db_user}" -p"${db_password}" "${db_name}" -e "DELETE FROM ${table_name} WHERE primary_key_column=${primary_key_value};"
}

## * delete_corrupted_entries
	# Datum: 13.11.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht dem Benutzer, defekte Einträge in einer bestimmten Tabelle in einer MariaDB-Datenbank zu löschen.
	# Benutzer werden aufgefordert, den MariaDB-Benutzernamen, das Passwort, den Datenbanknamen und den Tabellennamen einzugeben.
	# Zuerst wird die "CHECK TABLE"-Operation mit der Option "FAST" auf die angegebene Tabelle angewendet, um die Integrität zu überprüfen und gegebenenfalls zu reparieren.
	# Anschließend werden alle Einträge mit defektem CHECKSUM-Wert in der angegebenen Tabelle gelöscht.
	#? Parameter:
	#   - Keine festen Parameter; Benutzer wird zur Eingabe von MariaDB-Benutzername, Passwort, Datenbankname und Tabellennamen aufgefordert.
	#? Funktionsverhalten:
	#   - Die Funktion gibt Aufforderungen aus, um den MariaDB-Benutzernamen, das Passwort, den Datenbanknamen und den Tabellennamen einzugeben.
	#   - Führt die "CHECK TABLE"-Operation mit der Option "FAST" auf die angegebene Tabelle in der MariaDB-Datenbank durch.
	#   - Löscht alle Einträge mit defektem CHECKSUM-Wert in der angegebenen Tabelle.
	#? Beispielaufruf:
	#   Die Funktion wird direkt vom Benutzer aufgerufen und ermöglicht das Löschen defekter Einträge in einer Tabelle.
	#   Beispiel: delete_corrupted_entries
	#? Rückgabewert:
	#   - Es gibt keinen expliziten Rückgabewert. Die Funktion überprüft und repariert die Tabelle und löscht defekte Einträge.
	#? Hinweise:
	#   - Stellen Sie sicher, dass die erforderlichen MariaDB-Anmeldeinformationen und der Tabellenname korrekt eingegeben werden.
	#   - Der Benutzer sollte die Berechtigungen haben, um auf die angegebene Datenbank zuzugreifen und Operationen durchzuführen.
	#   - Das Löschen von Einträgen mit defektem CHECKSUM-Wert kann bei der Wiederherstellung der Datenintegrität hilfreich sein.
##
function delete_corrupted_entries() {
    echo "Enter MariaDB username: " 
    read -r db_user
    echo "Enter MariaDB password: " 
    read -r db_password
    echo    # newline
    echo "Enter MariaDB database name: " 
    read -r db_name
    echo "Enter table name to delete corrupted entries: " 
    read -r table_name

    # Überprüfen und Reparieren der Tabelle
    mysql -u "${db_user}" -p"${db_password}" "${db_name}" -e "CHECK TABLE ${table_name} FAST;"
    # Löschen defekter Einträge
    mysql -u "${db_user}" -p"${db_password}" "${db_name}" -e "DELETE FROM ${table_name} WHERE CHECKSUM = '1';"
}

## * backup_tables
	# Datum: 13.11.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht dem Benutzer das Erstellen eines Backups aller Tabellen in einer bestimmten MariaDB-Datenbank.
	# Benutzer werden aufgefordert, den MariaDB-Benutzernamen, das Passwort und den Datenbanknamen einzugeben.
	# Das Backup wird im SQL-Format erstellt und in einer Datei gespeichert, die den Datenbanknamen und das aktuelle Datum und die Uhrzeit enthält.
	#? Parameter:
	#   - Keine festen Parameter; Benutzer wird zur Eingabe von MariaDB-Benutzername, Passwort und Datenbankname aufgefordert.
	#? Funktionsverhalten:
	#   - Die Funktion gibt Aufforderungen aus, um den MariaDB-Benutzernamen, das Passwort und den Datenbanknamen einzugeben.
	#   - Erstellt ein Backup aller Tabellen in der angegebenen MariaDB-Datenbank im SQL-Format.
	#   - Die Backup-Datei wird im Format "Datenbankname_backup_JJJJMMTT_STUNDENMINUTENSEKUNDEN.sql" benannt.
	#   - Die Backup-Datei wird im aktuellen Arbeitsverzeichnis gespeichert.
	#   - Gibt eine Meldung aus, dass das Backup erfolgreich erstellt und in der entsprechenden Datei gespeichert wurde.
	#? Beispielaufruf:
	#   Die Funktion wird direkt vom Benutzer aufgerufen und ermöglicht das Erstellen eines Backups aller Tabellen in einer Datenbank.
	#   Beispiel: backup_tables
	#? Rückgabewert:
	#   - Es gibt keinen expliziten Rückgabewert. Die Funktion erstellt ein Backup und gibt eine Erfolgsmeldung aus.
	#? Hinweise:
	#   - Stellen Sie sicher, dass die erforderlichen MariaDB-Anmeldeinformationen korrekt eingegeben werden.
	#   - Das Backup wird im aktuellen Arbeitsverzeichnis gespeichert, daher überprüfen Sie die Schreibberechtigungen.
	#   - Verwenden Sie das Backup verantwortungsbewusst und bewahren Sie es an einem sicheren Ort auf.
##
function backup_tables() {
    echo "Enter MariaDB username: " 
    read -r db_user
    echo "Enter MariaDB password: " 
    read -r db_password
    echo    # newline
    echo "Enter MariaDB database name: " 
    read -r db_name

    current_date=$(date +"%Y%m%d_%H%M%S")
    backup_file="${db_name}_backup_${current_date}.sql"

    mysqldump -u "${db_user}" -p"${db_password}" "${db_name}" > "${backup_file}"

    echo "Backup saved to ${backup_file}"
}

## * restore_tables
	# Datum: 13.11.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht dem Benutzer das Wiederherstellen von Tabellen in einer MariaDB-Datenbank aus einem zuvor erstellten Backup.
	# Benutzer werden aufgefordert, den MariaDB-Benutzernamen, das Passwort, den Datenbanknamen und den Pfad zur SQL-Backup-Datei einzugeben.
	# Die Funktion verwendet das angegebene Backup, um die Tabellen in der MariaDB-Datenbank wiederherzustellen.
	#? Parameter:
	#   - Keine festen Parameter; Benutzer wird zur Eingabe von MariaDB-Benutzername, Passwort, Datenbankname und Backup-Pfad aufgefordert.
	#? Funktionsverhalten:
	#   - Die Funktion gibt Aufforderungen aus, um den MariaDB-Benutzernamen, das Passwort, den Datenbanknamen und den Pfad zur SQL-Backup-Datei einzugeben.
	#   - Verwendet das angegebene SQL-Backup, um die Tabellen in der MariaDB-Datenbank wiederherzustellen.
	#   - Die Backup-Datei wird im angegebenen Pfad gesucht und auf die Datenbank angewendet.
	#   - Gibt eine Meldung aus, dass die Tabellen erfolgreich aus dem Backup wiederhergestellt wurden.
	#? Beispielaufruf:
	#   Die Funktion wird direkt vom Benutzer aufgerufen und ermöglicht das Wiederherstellen von Tabellen aus einem SQL-Backup.
	#   Beispiel: restore_tables
	#? Rückgabewert:
	#   - Es gibt keinen expliziten Rückgabewert. Die Funktion stellt die Tabellen wieder her und gibt eine Erfolgsmeldung aus.
	#? Hinweise:
	#   - Stellen Sie sicher, dass die erforderlichen MariaDB-Anmeldeinformationen korrekt eingegeben werden.
	#   - Der Benutzer sollte die erforderlichen Berechtigungen haben, um auf die angegebene Datenbank zuzugreifen und Operationen durchzuführen.
	#   - Überprüfen Sie den Pfad zur Backup-Datei und stellen Sie sicher, dass die Datei vorhanden ist.
##
function restore_tables() {

    backup_file_path="/opt" # TODO: ? keine ahnung

    echo "Enter MariaDB username: "
    read -r db_user
    echo "Enter MariaDB password: "
    read -r db_password
    echo    # newline
    echo "Enter MariaDB database name: "
    read -r db_name

    echo "Enter the path to the SQL backup file: " backup_file_path

    mysql -u "${db_user}" -p"${db_password}" "${db_name}" < "${backup_file_path}"

    echo "Tables restored to ${db_name} from ${backup_file_path}"
}

## * update_entry
	# Datum: 13.11.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht dem Benutzer das Aktualisieren eines Eintrags in einer bestimmten Tabelle in einer MariaDB-Datenbank.
	# Benutzer werden aufgefordert, den MariaDB-Benutzernamen, das Passwort, den Datenbanknamen, Tabellennamen und die erforderlichen Aktualisierungsinformationen einzugeben.
	# Die Funktion führt eine UPDATE-Abfrage aus, um den Wert einer bestimmten Spalte in einem Eintrag zu aktualisieren, basierend auf einer angegebenen Bedingung.
	#? Parameter:
	#   - Keine festen Parameter; Benutzer wird zur Eingabe von MariaDB-Benutzername, Passwort, Datenbankname, Tabellennamen und Aktualisierungsinformationen aufgefordert.
	#? Funktionsverhalten:
	#   - Die Funktion gibt Aufforderungen aus, um den MariaDB-Benutzernamen, das Passwort, den Datenbanknamen, Tabellennamen und erforderliche Informationen für die Aktualisierung einzugeben.
	#   - Führt eine UPDATE-Abfrage aus, um den Wert einer bestimmten Spalte in einem Eintrag zu aktualisieren.
	#   - Die Aktualisierung erfolgt basierend auf einer angegebenen Bedingung, die durch eine Spalte und einen Wert definiert ist.
	#   - Gibt eine Meldung aus, dass der Eintrag erfolgreich aktualisiert wurde.
	#? Beispielaufruf:
	#   Die Funktion wird direkt vom Benutzer aufgerufen und ermöglicht das Aktualisieren eines Eintrags in einer Tabelle.
	#   Beispiel: update_entry
	#? Rückgabewert:
	#   - Es gibt keinen expliziten Rückgabewert. Die Funktion führt die Aktualisierung durch und gibt eine Erfolgsmeldung aus.
	#? Hinweise:
	#   - Stellen Sie sicher, dass die erforderlichen MariaDB-Anmeldeinformationen, der Tabellenname und die Aktualisierungsinformationen korrekt eingegeben werden.
	#   - Der Benutzer sollte die Berechtigungen haben, um auf die angegebene Datenbank zuzugreifen und Operationen durchzuführen.
##
function update_entry() {
    echo -n "Update Entry. Enter MariaDB username: "
    read -r db_user
    echo "Enter MariaDB password: " 
    read -r db_password
    echo    # newline
    echo -n "Enter MariaDB database name: "
    read -r db_name
    echo -n "Enter table name: "
    read -r table_name
    echo -n "Enter column name for condition: "
    read -r condition_column
    echo -n "Enter condition value: "
    read -r condition_value
    echo -n "Enter column name to update: "
    read -r update_column
    echo -n "Enter new value: "
    read -r new_value

    # Ausführen der UPDATE-Abfrage
    mysql -u "${db_user}" -p"${db_password}" "${db_name}" -e "UPDATE ${table_name} SET ${update_column}='${new_value}' WHERE ${condition_column}='${condition_value}';"

    echo "Entry updated successfully."
}

## * add_entry
	# Datum: 13.11.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht dem Benutzer das Hinzufügen eines neuen Eintrags in eine bestimmte Tabelle in einer MariaDB-Datenbank.
	# Benutzer werden aufgefordert, den MariaDB-Benutzernamen, das Passwort, den Datenbanknamen, Tabellennamen und die Werte für den neuen Eintrag einzugeben.
	# Die Funktion führt eine INSERT-Abfrage aus, um einen neuen Eintrag mit den angegebenen Werten in der Tabelle zu erstellen.
	#? Parameter:
	#   - Keine festen Parameter; Benutzer wird zur Eingabe von MariaDB-Benutzername, Passwort, Datenbankname, Tabellennamen und den Werten für den neuen Eintrag aufgefordert.
	#? Funktionsverhalten:
	#   - Die Funktion gibt Aufforderungen aus, um den MariaDB-Benutzernamen, das Passwort, den Datenbanknamen, Tabellennamen und die Werte für den neuen Eintrag einzugeben.
	#   - Führt eine INSERT-Abfrage aus, um einen neuen Eintrag mit den angegebenen Werten in der Tabelle zu erstellen.
	#   - Gibt eine Meldung aus, dass der Eintrag erfolgreich hinzugefügt wurde.
	#? Beispielaufruf:
	#   Die Funktion wird direkt vom Benutzer aufgerufen und ermöglicht das Hinzufügen eines neuen Eintrags in eine Tabelle.
	#   Beispiel: add_entry
	#? Rückgabewert:
	#   - Es gibt keinen expliziten Rückgabewert. Die Funktion fügt den Eintrag hinzu und gibt eine Erfolgsmeldung aus.
	#? Hinweise:
	#   - Stellen Sie sicher, dass die erforderlichen MariaDB-Anmeldeinformationen und der Tabellenname korrekt eingegeben werden.
	#   - Der Benutzer sollte die Berechtigungen haben, um auf die angegebene Datenbank zuzugreifen und Operationen durchzuführen.
##
function add_entry() {
    echo -n "Add Entry. Enter MariaDB username: "
    read -r db_user
    echo "Enter MariaDB password: " 
    read -r db_password
    echo    # newline
    echo -n "Enter MariaDB database name: "
    read -r db_name
    echo -n "Enter table name: "
    read -r table_name

    # Benutzer wird aufgefordert, Werte für neue Einträge einzugeben
    echo "Enter values for each column separated by spaces: " 
    read -r new_values

    # Ausführen der INSERT-Abfrage
    mysql -u "${db_user}" -p"${db_password}" "${db_name}" -e "INSERT INTO ${table_name} VALUES (${new_values});"

    echo "Entry added successfully."
}

## * delete_entry
	# Datum: 13.11.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht dem Benutzer das Löschen eines Eintrags aus einer bestimmten Tabelle in einer MariaDB-Datenbank.
	# Benutzer werden aufgefordert, den MariaDB-Benutzernamen, das Passwort, den Datenbanknamen, Tabellennamen und die Bedingung für das Löschen einzugeben.
	# Die Funktion führt eine DELETE-Abfrage aus, um den Eintrag basierend auf der angegebenen Bedingung zu löschen.
	#? Parameter:
	#   - Keine festen Parameter; Benutzer wird zur Eingabe von MariaDB-Benutzername, Passwort, Datenbankname, Tabellennamen und der Bedingung für das Löschen aufgefordert.
	#? Funktionsverhalten:
	#   - Die Funktion gibt Aufforderungen aus, um den MariaDB-Benutzernamen, das Passwort, den Datenbanknamen, Tabellennamen und die Bedingung für das Löschen einzugeben.
	#   - Führt eine DELETE-Abfrage aus, um den Eintrag basierend auf der angegebenen Bedingung zu löschen.
	#   - Gibt eine Meldung aus, dass der Eintrag erfolgreich gelöscht wurde.
	#? Beispielaufruf:
	#   Die Funktion wird direkt vom Benutzer aufgerufen und ermöglicht das Löschen eines Eintrags aus einer Tabelle.
	#   Beispiel: delete_entry
	#? Rückgabewert:
	#   - Es gibt keinen expliziten Rückgabewert. Die Funktion löscht den Eintrag und gibt eine Erfolgsmeldung aus.
	#? Hinweise:
	#   - Stellen Sie sicher, dass die erforderlichen MariaDB-Anmeldeinformationen, der Tabellenname und die Bedingung für das Löschen korrekt eingegeben werden.
	#   - Der Benutzer sollte die Berechtigungen haben, um auf die angegebene Datenbank zuzugreifen und Operationen durchzuführen.
##
function delete_entry() {
    echo -n "Delete Entry. Enter MariaDB username: "
    read -r db_user
    echo "Enter MariaDB password: " 
    read -r db_password
    echo    # newline
    echo -n "Enter MariaDB database name: "
    read -r db_name
    echo -n "Enter table name: "
    read -r table_name
    echo -n "Enter column name for condition: "
    read -r condition_column
    echo -n "Enter condition value: "
    read -r condition_value

    # Ausführen der DELETE-Abfrage
    mysql -u "${db_user}" -p"${db_password}" "${db_name}" -e "DELETE FROM ${table_name} WHERE ${condition_column}='${condition_value}';"

    echo "Entry deleted successfully."
}

## * generate_report
	# Datum: 13.11.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht dem Benutzer das Generieren eines Berichts basierend auf einer benutzerdefinierten SQL-Abfrage in einer MariaDB-Datenbank.
	# Benutzer werden aufgefordert, den MariaDB-Benutzernamen, das Passwort, den Datenbanknamen und die SQL-Abfrage für den Bericht einzugeben.
	# Die Funktion führt die angegebene SQL-Abfrage aus und zeigt die Ergebnisse des Berichts an.
	#? Parameter:
	#   - Keine festen Parameter; Benutzer wird zur Eingabe von MariaDB-Benutzername, Passwort, Datenbankname und SQL-Abfrage aufgefordert.
	#? Funktionsverhalten:
	#   - Die Funktion gibt Aufforderungen aus, um den MariaDB-Benutzernamen, das Passwort, den Datenbanknamen und die SQL-Abfrage für den Bericht einzugeben.
	#   - Führt die angegebene SQL-Abfrage aus und speichert das Ergebnis.
	#   - Zeigt die Ergebnisse des Berichts an.
	#? Beispielaufruf:
	#   Die Funktion wird direkt vom Benutzer aufgerufen und ermöglicht das Generieren eines Berichts basierend auf einer SQL-Abfrage.
	#   Beispiel: generate_report
	#? Rückgabewert:
	#   - Es gibt keinen expliziten Rückgabewert. Die Funktion führt die SQL-Abfrage aus und zeigt die Ergebnisse des Berichts an.
	#? Hinweise:
	#   - Stellen Sie sicher, dass die erforderlichen MariaDB-Anmeldeinformationen, der Datenbankname und die SQL-Abfrage korrekt eingegeben werden.
	#   - Der Benutzer sollte die Berechtigungen haben, um auf die angegebene Datenbank zuzugreifen und Operationen durchzuführen.
##
function generate_report() {
    echo -n "Generate Report. Enter MariaDB username: "
    read -r db_user
    echo "Enter MariaDB password: " 
    read -r db_password
    echo    # newline
    echo -n "Enter MariaDB database name: "
    read -r db_name
    echo -n "Enter SQL query for the report: "
    read -r sql_query

    # Ausführen der SQL-Abfrage
    result=$(mysql -u "${db_user}" -p"${db_password}" "${db_name}" -se "${sql_query}")

    # Anzeigen der Ergebnisse
    echo "Report Results:"
    echo "${result}"
}

## * begin_transaction
	# Datum: 13.11.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht dem Benutzer das Starten einer Transaktion in einer MariaDB-Datenbank.
	# Benutzer werden aufgefordert, den MariaDB-Benutzernamen, das Passwort und den Datenbanknamen einzugeben.
	# Die Funktion führt die START TRANSACTION-Abfrage aus, um eine Transaktion in der angegebenen Datenbank zu beginnen.
	#? Parameter:
	#   - Keine festen Parameter; Benutzer wird zur Eingabe von MariaDB-Benutzername, Passwort und Datenbankname aufgefordert.
	#? Funktionsverhalten:
	#   - Die Funktion gibt Aufforderungen aus, um den MariaDB-Benutzernamen, das Passwort und den Datenbanknamen einzugeben.
	#   - Führt die START TRANSACTION-Abfrage aus, um eine Transaktion in der angegebenen Datenbank zu starten.
	#   - Gibt eine Meldung aus, dass die Transaktion erfolgreich gestartet wurde.
	#? Beispielaufruf:
	#   Die Funktion wird direkt vom Benutzer aufgerufen und ermöglicht das Starten einer Transaktion in einer Datenbank.
	#   Beispiel: begin_transaction
	#? Rückgabewert:
	#   - Es gibt keinen expliziten Rückgabewert. Die Funktion startet die Transaktion und gibt eine Erfolgsmeldung aus.
	#? Hinweise:
	#   - Stellen Sie sicher, dass die erforderlichen MariaDB-Anmeldeinformationen und der Datenbankname korrekt eingegeben werden.
	#   - Der Benutzer sollte die Berechtigungen haben, um auf die angegebene Datenbank zuzugreifen und Transaktionen durchzuführen.
##
function begin_transaction() {
    echo -n "Begin Transaction. Enter MariaDB username: "
    read -r db_user
    echo "Enter MariaDB password: " 
    read -r db_password
    echo    # newline
    echo -n "Enter MariaDB database name: "
    read -r db_name

    # Ausführen der START TRANSACTION-Abfrage
    mysql -u "${db_user}" -p"${db_password}" "${db_name}" -e "START TRANSACTION;"

    echo "Transaction started."
}

## * commit_transaction
	# Datum: 13.11.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht es dem Benutzer, eine ausstehende Transaktion in einer MariaDB-Datenbank zu bestätigen (commit). Sie fordert den Benutzer auf, die erforderlichen Anmeldeinformationen einzugeben und führt dann die COMMIT-Abfrage in der angegebenen Datenbank aus.
	#? Parameter:
	#   - Keine festen Parameter.
	#? Funktionsverhalten:
	#   - Fordert den Benutzer auf, MariaDB-Anmeldeinformationen und den Datenbanknamen einzugeben.
	#   - Führt die COMMIT-Abfrage in der angegebenen Datenbank aus, um eine ausstehende Transaktion zu bestätigen.
	#? Beispielaufruf:
	#   Die Funktion wird direkt vom Benutzer aufgerufen, um eine ausstehende Transaktion zu bestätigen.
	#   Beispiel: commit_transaction
	#? Rückgabewert:
	#   - Es gibt keinen expliziten Rückgabewert. Die Funktion gibt eine Erfolgsmeldung aus, nachdem die Transaktion bestätigt wurde.
	#? Hinweise:
	#   - Stellen Sie sicher, dass der Benutzer über die erforderlichen Berechtigungen zum Bestätigen von Transaktionen verfügt.
##
function commit_transaction() {
    echo -n "Commit Transaction. Enter MariaDB username: "
    read -r db_user
    echo "Enter MariaDB password: " 
    read -r db_password
    echo    # newline
    echo -n "Enter MariaDB database name: "
    read -r db_name

    # Ausführen der COMMIT-Abfrage
    mysql -u "${db_user}" -p"${db_password}" "${db_name}" -e "COMMIT;"

    echo "Transaction committed."
}

## * rollback_transaction
	# Datum: 13.11.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht dem Benutzer das Rückgängigmachen (Rollback) einer laufenden Transaktion in einer MariaDB-Datenbank.
	# Benutzer werden aufgefordert, den MariaDB-Benutzernamen, das Passwort und den Datenbanknamen einzugeben.
	# Die Funktion führt die ROLLBACK-Abfrage aus, um alle Änderungen seit dem Beginn der aktuellen Transaktion rückgängig zu machen.
	#? Parameter:
	#   - Keine festen Parameter; Benutzer wird zur Eingabe von MariaDB-Benutzername, Passwort und Datenbankname aufgefordert.
	#? Funktionsverhalten:
	#   - Die Funktion gibt Aufforderungen aus, um den MariaDB-Benutzernamen, das Passwort und den Datenbanknamen einzugeben.
	#   - Führt die ROLLBACK-Abfrage aus, um alle Änderungen seit dem Beginn der aktuellen Transaktion rückgängig zu machen.
	#   - Gibt eine Meldung aus, dass die Transaktion erfolgreich rückgängig gemacht wurde.
	#? Beispielaufruf:
	#   Die Funktion wird direkt vom Benutzer aufgerufen und ermöglicht das Rückgängigmachen einer Transaktion in einer Datenbank.
	#   Beispiel: rollback_transaction
	#? Rückgabewert:
	#   - Es gibt keinen expliziten Rückgabewert. Die Funktion rollt die Transaktion zurück und gibt eine Erfolgsmeldung aus.
	#? Hinweise:
	#   - Stellen Sie sicher, dass die erforderlichen MariaDB-Anmeldeinformationen und der Datenbankname korrekt eingegeben werden.
	#   - Der Benutzer sollte die Berechtigungen haben, um auf die angegebene Datenbank zuzugreifen und Transaktionen durchzuführen.
##
function rollback_transaction() {
    echo -n "Rollback Transaction. Enter MariaDB username: "
    read -r db_user
    echo "Enter MariaDB password: " db_password
    echo    # newline
    echo -n "Enter MariaDB database name: "
    read -r db_name

    # Ausführen der ROLLBACK-Abfrage
    mysql -u "${db_user}" -p"${db_password}" "${db_name}" -e "ROLLBACK;"

    echo "Transaction rolled back."
}

## * display_table_schema
	# Datum: 13.11.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht es dem Benutzer, das Schema einer bestimmten Tabelle in einer MariaDB-Datenbank anzuzeigen. Sie fordert den Benutzer auf, die erforderlichen Anmeldeinformationen, den Datenbanknamen und den Tabellennamen einzugeben. Anschließend führt sie die SHOW COLUMNS-Abfrage aus und gibt das Schema der angegebenen Tabelle aus.
	#? Parameter:
	#   - Keine festen Parameter.
	#? Funktionsverhalten:
	#   - Fordert den Benutzer auf, MariaDB-Anmeldeinformationen, den Datenbanknamen und den Tabellennamen einzugeben.
	#   - Führt die SHOW COLUMNS-Abfrage für die angegebene Tabelle aus.
	#   - Gibt das Schema der angegebenen Tabelle aus.
	#? Beispielaufruf:
	#   Die Funktion wird direkt vom Benutzer aufgerufen, um das Schema einer Tabelle anzuzeigen.
	#   Beispiel: display_table_schema
	#? Rückgabewert:
	#   - Das Schema der angegebenen Tabelle wird auf der Konsole ausgegeben.
	#? Hinweise:
	#   - Stellen Sie sicher, dass der Benutzer über die erforderlichen Berechtigungen zum Anzeigen des Tabellenschemas verfügt.
##
function display_table_schema() {
    echo -n "Display Table Schema. Enter MariaDB username: "
    read -r db_user
    echo "Enter MariaDB password: " 
    read -r db_password
    echo    # newline
    echo -n "Enter MariaDB database name: "
    read -r db_name
    echo -n "Enter table name: "
    read -r table_name

    # Ausführen der SHOW COLUMNS-Abfrage
    result=$(mysql -u "${db_user}" -p"${db_password}" "${db_name}" -se "SHOW COLUMNS FROM ${table_name};")

    # Anzeigen der Ergebnisse
    echo "Table Schema for ${table_name}:"
    echo "${result}"
}

## * display_databases
	# Datum: 13.11.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht dem Benutzer das Anzeigen aller verfügbaren Datenbanken in einer MariaDB-Instanz.
	# Benutzer werden aufgefordert, den MariaDB-Benutzernamen und das Passwort einzugeben.
	# Die Funktion führt die SHOW DATABASES-Abfrage aus, um eine Liste aller verfügbaren Datenbanken abzurufen.
	#? Parameter:
	#   - Keine festen Parameter; Benutzer wird zur Eingabe von MariaDB-Benutzername und Passwort aufgefordert.
	#? Funktionsverhalten:
	#   - Die Funktion gibt Aufforderungen aus, um den MariaDB-Benutzernamen und das Passwort einzugeben.
	#   - Führt die SHOW DATABASES-Abfrage aus, um eine Liste aller verfügbaren Datenbanken abzurufen.
	#   - Zeigt die Ergebnisse mit den verfügbaren Datenbanken an.
	#? Beispielaufruf:
	#   Die Funktion wird direkt vom Benutzer aufgerufen und ermöglicht das Anzeigen aller verfügbaren Datenbanken.
	#   Beispiel: display_databases
	#? Rückgabewert:
	#   - Es gibt keinen expliziten Rückgabewert. Die Funktion zeigt die Liste der verfügbaren Datenbanken an.
	#? Hinweise:
	#   - Stellen Sie sicher, dass die erforderlichen MariaDB-Anmeldeinformationen korrekt eingegeben werden.
	#   - Der Benutzer sollte die Berechtigungen haben, um auf die MariaDB-Instanz zuzugreifen und Datenbanken anzuzeigen.
##
function display_databases() {
    echo -n "Display Databases. Enter MariaDB username: "
    read -r db_user
    echo "Enter MariaDB password: "
    read -r db_password
    echo    # newline

    # Ausführen der SHOW DATABASES-Abfrage
    result=$(mysql -u "${db_user}" -p"${db_password}" -se "SHOW DATABASES;")

    # Anzeigen der Ergebnisse
    echo "Available Databases:"
    echo "${result}"
}

## * optimize_tables
	# Datum: 13.11.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht dem Benutzer das Optimieren aller Tabellen in einer MariaDB-Datenbank.
	# Benutzer werden aufgefordert, den MariaDB-Benutzernamen, das Passwort und den Datenbanknamen einzugeben.
	# Die Funktion führt die OPTIMIZE TABLE-Abfrage für alle Tabellen in der angegebenen Datenbank aus.
	#? Parameter:
	#   - Keine festen Parameter; Benutzer wird zur Eingabe von MariaDB-Benutzername, Passwort und Datenbankname aufgefordert.
	#? Funktionsverhalten:
	#   - Die Funktion gibt Aufforderungen aus, um den MariaDB-Benutzernamen, das Passwort und den Datenbanknamen einzugeben.
	#   - Führt die OPTIMIZE TABLE-Abfrage für alle Tabellen in der angegebenen Datenbank aus.
	#   - Gibt eine Meldung aus, dass die Tabellen erfolgreich optimiert wurden.
	#? Beispielaufruf:
	#   Die Funktion wird direkt vom Benutzer aufgerufen und ermöglicht das Optimieren aller Tabellen in einer Datenbank.
	#   Beispiel: optimize_tables
	#? Rückgabewert:
	#   - Es gibt keinen expliziten Rückgabewert. Die Funktion optimiert die Tabellen und gibt eine Erfolgsmeldung aus.
	#? Hinweise:
	#   - Stellen Sie sicher, dass die erforderlichen MariaDB-Anmeldeinformationen und der Datenbankname korrekt eingegeben werden.
	#   - Der Benutzer sollte die Berechtigungen haben, um auf die angegebene Datenbank zuzugreifen und Tabellen zu optimieren.
##
function optimize_tables() {
    echo -n "Optimize Tables. Enter MariaDB username: "
    read -r db_user
    echo "Enter MariaDB password: "
    read -r db_password
    echo    # newline
    echo -n "Enter MariaDB database name: "
    read -r db_name

    # Ausführen der OPTIMIZE TABLE-Abfrage
    mysqlcheck -u "${db_user}" -p"${db_password}" --optimize --all-databases
    
    echo "Tables optimized successfully."
}

## * display_server_info
	# Datum: 13.11.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht dem Benutzer das Anzeigen von Informationen zum MariaDB-Server.
	# Benutzer werden aufgefordert, den MariaDB-Benutzernamen und das Passwort einzugeben.
	# Die Funktion führt die STATUS-Abfrage aus, um Informationen zum aktuellen Zustand des MariaDB-Servers abzurufen.
	#? Parameter:
	#   - Keine festen Parameter; Benutzer wird zur Eingabe von MariaDB-Benutzername und Passwort aufgefordert.
	#? Funktionsverhalten:
	#   - Die Funktion gibt Aufforderungen aus, um den MariaDB-Benutzernamen und das Passwort einzugeben.
	#   - Führt die STATUS-Abfrage aus, um Informationen zum aktuellen Zustand des MariaDB-Servers abzurufen.
	#   - Zeigt die Ergebnisse mit den Informationen zum MariaDB-Server an.
	#? Beispielaufruf:
	#   Die Funktion wird direkt vom Benutzer aufgerufen und ermöglicht das Anzeigen von Informationen zum MariaDB-Server.
	#   Beispiel: display_server_info
	#? Rückgabewert:
	#   - Es gibt keinen expliziten Rückgabewert. Die Funktion zeigt die Informationen zum MariaDB-Server an.
	#? Hinweise:
	#   - Stellen Sie sicher, dass die erforderlichen MariaDB-Anmeldeinformationen korrekt eingegeben werden.
	#   - Der Benutzer sollte die Berechtigungen haben, um auf den MariaDB-Server zuzugreifen und Serverinformationen anzuzeigen.
##
function display_server_info() {
    echo -n "Display Server Information. Enter MariaDB username: "
    read -r db_user
    echo "Enter MariaDB password: "
    read -r db_password
    echo    # newline

    # Ausführen der STATUS-Abfrage
    result=$(mysql -u "${db_user}" -p"${db_password}" -se "STATUS;")

    # Anzeigen der Ergebnisse
    echo "MariaDB Server Information:"
    echo "${result}"
}

## * search_entries
	# Datum: 13.11.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht dem Benutzer das Suchen von Einträgen in einer bestimmten Tabelle in einer MariaDB-Datenbank.
	# Benutzer werden aufgefordert, den MariaDB-Benutzernamen, das Passwort, den Datenbanknamen, Tabellennamen, Spaltennamen und den Suchbegriff einzugeben.
	# Die Funktion führt eine SELECT-Abfrage aus, um Einträge in der angegebenen Tabelle zu suchen, die dem Suchbegriff entsprechen.
	#? Parameter:
	#   - Keine festen Parameter; Benutzer wird zur Eingabe von MariaDB-Benutzername, Passwort, Datenbankname, Tabellennamen, Spaltennamen und Suchbegriff aufgefordert.
	#? Funktionsverhalten:
	#   - Die Funktion gibt Aufforderungen aus, um den MariaDB-Benutzernamen, das Passwort, den Datenbanknamen, Tabellennamen, Spaltennamen und den Suchbegriff einzugeben.
	#   - Führt eine SELECT-Abfrage aus, um Einträge in der angegebenen Tabelle zu suchen, die dem Suchbegriff entsprechen.
	#   - Zeigt die Ergebnisse der Suche an.
	#? Beispielaufruf:
	#   Die Funktion wird direkt vom Benutzer aufgerufen und ermöglicht das Suchen von Einträgen in einer Tabelle.
	#   Beispiel: search_entries
	#? Rückgabewert:
	#   - Es gibt keinen expliziten Rückgabewert. Die Funktion zeigt die Ergebnisse der Suche an.
	#? Hinweise:
	#   - Stellen Sie sicher, dass die erforderlichen MariaDB-Anmeldeinformationen, der Datenbankname, Tabellenname, Spaltenname und Suchbegriff korrekt eingegeben werden.
	#   - Der Benutzer sollte die Berechtigungen haben, um auf die angegebene Datenbank zuzugreifen und SELECT-Abfragen durchzuführen.
##
function search_entries() {
    echo -n "Search Entries. Enter MariaDB username: "
    read -r db_user
    read -r "Enter MariaDB password: "
    read -r db_password
    echo    # newline
    echo -n "Enter MariaDB database name: "
    read -r db_name
    echo -n "Enter table name to search: "
    read -r table_name
    echo -n "Enter column name to search: "
    read -r column_name
    echo -n "Enter search term: "
    read -r search_term

    # Ausführen der SELECT-Abfrage
    result=$(mysql -u "${db_user}" -p"${db_password}" "${db_name}" -se "SELECT * FROM ${table_name} WHERE ${column_name} LIKE '%${search_term}%';")

    # Anzeigen der Ergebnisse
    echo "Search Results:"
    echo "${result}"
}

## * search_entries_by_date
	# Datum: 13.11.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht dem Benutzer das Suchen von Einträgen in einer bestimmten Tabelle in einer MariaDB-Datenbank basierend auf einem Datumsbereich.
	# Benutzer werden aufgefordert, den MariaDB-Benutzernamen, das Passwort, den Datenbanknamen, Tabellennamen, Spaltennamen mit Datumsangaben und den Suchbereich einzugeben.
	# Die Funktion führt eine SELECT-Abfrage aus, um Einträge in der angegebenen Tabelle zu suchen, die innerhalb des angegebenen Datumsbereichs liegen.
	#? Parameter:
	#   - Keine festen Parameter; Benutzer wird zur Eingabe von MariaDB-Benutzername, Passwort, Datenbankname, Tabellennamen, Datenspaltennamen und Suchbereich aufgefordert.
	#? Funktionsverhalten:
	#   - Die Funktion gibt Aufforderungen aus, um den MariaDB-Benutzernamen, das Passwort, den Datenbanknamen, Tabellennamen, Datenspaltennamen und den Suchbereich einzugeben.
	#   - Überprüft die Eingabe der Datumsformate und gibt eine Fehlermeldung aus, wenn das Format ungültig ist.
	#   - Führt eine SELECT-Abfrage aus, um Einträge in der angegebenen Tabelle zu suchen, die innerhalb des angegebenen Datumsbereichs liegen.
	#   - Zeigt die Ergebnisse der Suche an.
	#? Beispielaufruf:
	#   Die Funktion wird direkt vom Benutzer aufgerufen und ermöglicht das Suchen von Einträgen in einer Tabelle basierend auf einem Datumsbereich.
	#   Beispiel: search_entries_by_date
	#? Rückgabewert:
	#   - Es gibt keinen expliziten Rückgabewert. Die Funktion zeigt die Ergebnisse der Suche an.
	#? Hinweise:
	#   - Stellen Sie sicher, dass die erforderlichen MariaDB-Anmeldeinformationen, der Datenbankname, Tabellenname, Datenspaltenname und der Suchbereich korrekt eingegeben werden.
	#   - Der Benutzer sollte die Berechtigungen haben, um auf die angegebene Datenbank zuzugreifen und SELECT-Abfragen durchzuführen.
##
function search_entries_by_date() {
    echo -n "Search Entries by Date. Enter MariaDB username: "
    read -r db_user
    read -r "Enter MariaDB password: "
    read -r db_password
    echo    # newline
    echo -n "Enter MariaDB database name: "
    read -r db_name
    echo -n "Enter table name to search: "
    read -r table_name
    echo -n "Enter column name with date values: "
    read -r date_column
    echo -n "Enter search start date (YYYY-MM-DD): "
    read -r start_date
    echo -n "Enter search end date (YYYY-MM-DD): "
    read -r end_date

    # Überprüfen, ob die eingegebenen Datumsformate korrekt sind
    date -d "$start_date" > /dev/null 2>&1
    if ! make "${start_date}"; then
        echo "Invalid start date format. Please use YYYY-MM-DD."
        return 1
    fi

    date -d "${end_date}" > /dev/null 2>&1
    if ! make "$end_date"; then
        echo "Invalid end date format. Please use YYYY-MM-DD."
        return 1
    fi

    # Ausführen der SELECT-Abfrage
    result=$(mysql -u "${db_user}" -p"${db_password}" "${db_name}" -se "SELECT * FROM ${table_name} WHERE ${date_column} BETWEEN '${start_date}' AND '${end_date}';")

    # Anzeigen der Ergebnisse
    echo "Search Results:"
    echo "${result}"
}

## * search_entries_by_unix_timestamp
	# Datum: 13.11.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht dem Benutzer das Suchen von Einträgen in einer bestimmten Tabelle in einer MariaDB-Datenbank basierend auf Unix-Zeitstempeln.
	# Benutzer werden aufgefordert, den MariaDB-Benutzernamen, das Passwort, den Datenbanknamen, Tabellennamen, Spaltennamen mit Unix-Zeitstempeln und den Suchbereich einzugeben.
	# Die Funktion führt eine SELECT-Abfrage mit FROM_UNIXTIME() aus, um Einträge in der angegebenen Tabelle zu suchen, die innerhalb des angegebenen Unix-Zeitstempelbereichs liegen.
	#? Parameter:
	#   - Keine festen Parameter; Benutzer wird zur Eingabe von MariaDB-Benutzername, Passwort, Datenbankname, Tabellennamen, Spaltennamen mit Unix-Zeitstempeln und Suchbereich aufgefordert.
	#? Funktionsverhalten:
	#   - Die Funktion gibt Aufforderungen aus, um den MariaDB-Benutzernamen, das Passwort, den Datenbanknamen, Tabellennamen, Spaltennamen mit Unix-Zeitstempeln und den Suchbereich einzugeben.
	#   - Führt eine SELECT-Abfrage mit FROM_UNIXTIME() aus, um Einträge in der angegebenen Tabelle zu suchen, die innerhalb des angegebenen Unix-Zeitstempelbereichs liegen.
	#   - Zeigt die Ergebnisse der Suche an.
	#? Beispielaufruf:
	#   Die Funktion wird direkt vom Benutzer aufgerufen und ermöglicht das Suchen von Einträgen in einer Tabelle basierend auf Unix-Zeitstempeln.
	#   Beispiel: search_entries_by_unix_timestamp
	#? Rückgabewert:
	#   - Es gibt keinen expliziten Rückgabewert. Die Funktion zeigt die Ergebnisse der Suche an.
	#? Hinweise:
	#   - Stellen Sie sicher, dass die erforderlichen MariaDB-Anmeldeinformationen, der Datenbankname, Tabellenname, Spaltenname mit Unix-Zeitstempeln und der Suchbereich korrekt eingegeben werden.
	#   - Der Benutzer sollte die Berechtigungen haben, um auf die angegebene Datenbank zuzugreifen und SELECT-Abfragen durchzuführen.
##
function search_entries_by_unix_timestamp() {
    echo -n "Search Entries by Unix Timestamp. Enter MariaDB username: "
    read -r db_user
    read -r "Enter MariaDB password: "
    read -r db_password
    echo    # newline
    echo -n "Enter MariaDB database name: "
    read -r db_name
    echo -n "Enter table name to search: "
    read -r table_name
    echo -n "Enter column name with Unix timestamps: "
    read -r unix_timestamp_column
    echo -n "Enter search start Unix timestamp: "
    read -r start_unix_timestamp
    echo -n "Enter search end Unix timestamp: "
    read -r end_unix_timestamp

    # Ausführen der SELECT-Abfrage mit FROM_UNIXTIME()
    result=$(mysql -u "${db_user}" -p"${db_password}" "${db_name}" -se "SELECT * FROM ${table_name} WHERE ${unix_timestamp_column} BETWEEN FROM_UNIXTIME(${start_unix_timestamp}) AND FROM_UNIXTIME(${end_unix_timestamp});")

    # Anzeigen der Ergebnisse
    echo "Search Results:"
    echo "${result}"
}

## * display_table_contents
	# Datum: 13.11.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht dem Benutzer das Anzeigen aller Einträge in einer bestimmten Tabelle in einer MariaDB-Datenbank.
	# Benutzer werden aufgefordert, den MariaDB-Benutzernamen, das Passwort, den Datenbanknamen und den Tabellennamen einzugeben.
	# Die Funktion führt eine SELECT-Abfrage aus, um alle Einträge in der angegebenen Tabelle abzurufen.
	#? Parameter:
	#   - Keine festen Parameter; Benutzer wird zur Eingabe von MariaDB-Benutzername, Passwort, Datenbankname und Tabellennamen aufgefordert.
	#? Funktionsverhalten:
	#   - Die Funktion gibt Aufforderungen aus, um den MariaDB-Benutzernamen, das Passwort, den Datenbanknamen und den Tabellennamen einzugeben.
	#   - Führt eine SELECT-Abfrage aus, um alle Einträge in der angegebenen Tabelle abzurufen.
	#   - Zeigt die Ergebnisse der SELECT-Abfrage an.
	#? Beispielaufruf:
	#   Die Funktion wird direkt vom Benutzer aufgerufen und ermöglicht das Anzeigen aller Einträge in einer Tabelle.
	#   Beispiel: display_table_contents
	#? Rückgabewert:
	#   - Es gibt keinen expliziten Rückgabewert. Die Funktion zeigt die Ergebnisse der SELECT-Abfrage an.
	#? Hinweise:
	#   - Stellen Sie sicher, dass die erforderlichen MariaDB-Anmeldeinformationen und der Tabellenname korrekt eingegeben werden.
	#   - Der Benutzer sollte die Berechtigungen haben, um auf die angegebene Datenbank zuzugreifen und SELECT-Abfragen durchzuführen.
##
function display_table_contents() {
    echo -n "Display Table Contents. Enter MariaDB username: "
    read -r db_user
    echo "Enter MariaDB password: "
    read -r db_password
    echo    # newline
    echo -n "Enter MariaDB database name: "
    read -r db_name
    echo -n "Enter table name: "
    read -r table_name

    # Ausführen der SELECT-Abfrage
    result=$(mysql -u "${db_user}" -p"${db_password}" "${db_name}" -se "SELECT * FROM ${table_name};")

    # Anzeigen der Ergebnisse
    echo "Table Contents for ${table_name}:"
    echo "${result}"
}

## * export_table_to_csv
	# Datum: 13.11.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht dem Benutzer das Exportieren aller Einträge in einer bestimmten Tabelle einer MariaDB-Datenbank in eine CSV-Datei.
	# Benutzer werden aufgefordert, den MariaDB-Benutzernamen, das Passwort, den Datenbanknamen, den Tabellennamen und den Dateipfad für die CSV-Datei einzugeben.
	# Die Funktion führt eine SELECT-Abfrage aus und exportiert die Ergebnisse in eine CSV-Datei unter Verwendung des angegebenen Dateipfads.
	#? Parameter:
	#   - Keine festen Parameter; Benutzer wird zur Eingabe von MariaDB-Benutzername, Passwort, Datenbankname, Tabellennamen und Dateipfad für die CSV-Datei aufgefordert.
	#? Funktionsverhalten:
	#   - Die Funktion gibt Aufforderungen aus, um den MariaDB-Benutzernamen, das Passwort, den Datenbanknamen, den Tabellennamen und den Dateipfad für die CSV-Datei einzugeben.
	#   - Führt eine SELECT-Abfrage aus und exportiert die Ergebnisse in eine CSV-Datei unter Verwendung des angegebenen Dateipfads.
	#   - Zeigt eine Erfolgsmeldung nach dem erfolgreichen Export an.
	#? Beispielaufruf:
	#   Die Funktion wird direkt vom Benutzer aufgerufen und ermöglicht das Exportieren aller Einträge in einer Tabelle in eine CSV-Datei.
	#   Beispiel: export_table_to_csv
	#? Rückgabewert:
	#   - Es gibt keinen expliziten Rückgabewert. Die Funktion zeigt eine Erfolgsmeldung an, wenn der Export erfolgreich ist.
	#? Hinweise:
	#   - Stellen Sie sicher, dass die erforderlichen MariaDB-Anmeldeinformationen, der Tabellenname und der Dateipfad korrekt eingegeben werden.
	#   - Der Benutzer sollte die Berechtigungen haben, um auf die angegebene Datenbank zuzugreifen und SELECT-Abfragen durchzuführen.
##
function export_table_to_csv() {
    echo -n "Export Table to CSV. Enter MariaDB username: "
    read -r db_user
    echo "Enter MariaDB password: "
    read -r db_password
    echo    # newline
    echo -n "Enter MariaDB database name: "
    read -r db_name
    echo -n "Enter table name: "
    read -r table_name
    echo -n "Enter CSV file path: "
    read -r csv_file_path

    # Ausführen der SELECT-Abfrage und Export in CSV
    mysql -u "${db_user}" -p"${db_password}" "${db_name}" -e "SELECT * INTO OUTFILE '${csv_file_path}' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"' LINES TERMINATED BY '\n' FROM ${table_name};"

    echo "Table exported to ${csv_file_path} successfully."
}

## * import_csv_to_table
	# Datum: 13.11.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht dem Benutzer das Importieren von Daten aus einer CSV-Datei in eine bestimmte Tabelle einer MariaDB-Datenbank.
	# Benutzer werden aufgefordert, den MariaDB-Benutzernamen, das Passwort, den Datenbanknamen, den Tabellennamen und den Dateipfad der CSV-Datei einzugeben.
	# Die Funktion führt den LOAD DATA LOCAL INFILE-Befehl aus, um Daten aus der CSV-Datei in die angegebene Tabelle zu importieren.
	#? Parameter:
	#   - Keine festen Parameter; Benutzer wird zur Eingabe von MariaDB-Benutzername, Passwort, Datenbankname, Tabellennamen und Dateipfad der CSV-Datei aufgefordert.
	#? Funktionsverhalten:
	#   - Die Funktion gibt Aufforderungen aus, um den MariaDB-Benutzernamen, das Passwort, den Datenbanknamen, den Tabellennamen und den Dateipfad der CSV-Datei einzugeben.
	#   - Führt den LOAD DATA LOCAL INFILE-Befehl aus, um Daten aus der CSV-Datei in die angegebene Tabelle zu importieren.
	#   - Zeigt eine Erfolgsmeldung nach dem erfolgreichen Import an.
	#? Beispielaufruf:
	#   Die Funktion wird direkt vom Benutzer aufgerufen und ermöglicht das Importieren von Daten aus einer CSV-Datei in eine Tabelle.
	#   Beispiel: import_csv_to_table
	#? Rückgabewert:
	#   - Es gibt keinen expliziten Rückgabewert. Die Funktion zeigt eine Erfolgsmeldung an, wenn der Import erfolgreich ist.
	#? Hinweise:
	#   - Stellen Sie sicher, dass die erforderlichen MariaDB-Anmeldeinformationen, der Tabellenname und der Dateipfad korrekt eingegeben werden.
	#   - Der Benutzer sollte die Berechtigungen haben, um auf die angegebene Datenbank zuzugreifen und den LOAD DATA LOCAL INFILE-Befehl auszuführen.
##
function import_csv_to_table() {
    echo -n "Import CSV to Table. Enter MariaDB username: "
    read -r db_user
    echo "Enter MariaDB password: "
    read -r db_password
    echo    # newline
    echo -n "Enter MariaDB database name: "
    read -r db_name
    echo -n "Enter table name: "
    read -r table_name
    echo -n "Enter CSV file path: "
    read -r csv_file_path

    # Ausführen des LOAD DATA LOCAL INFILE-Befehls
    mysql -u "${db_user}" -p"${db_password}" "${db_name}" -e "LOAD DATA LOCAL INFILE '${csv_file_path}' INTO TABLE ${table_name} FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"' LINES TERMINATED BY '\n';"

    echo "Data imported from ${csv_file_path} to ${table_name} successfully."
}

## * backup_all_databases
	# Datum: 13.11.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht dem Benutzer das Sichern aller Datenbanken in einer MariaDB-Instanz.
	# Benutzer werden aufgefordert, den MariaDB-Benutzernamen, das Passwort und den Pfad des Sicherungsverzeichnisses einzugeben.
	# Die Funktion führt den mysqldump-Befehl für alle Datenbanken aus und speichert das Backup im angegebenen Verzeichnis.
	#? Parameter:
	#   - Keine festen Parameter; Benutzer wird zur Eingabe von MariaDB-Benutzername, Passwort und Pfad des Sicherungsverzeichnisses aufgefordert.
	#? Funktionsverhalten:
	#   - Die Funktion gibt Aufforderungen aus, um den MariaDB-Benutzernamen, das Passwort und den Pfad des Sicherungsverzeichnisses einzugeben.
	#   - Führt den mysqldump-Befehl für alle Datenbanken aus und speichert das Backup im angegebenen Verzeichnis.
	#   - Zeigt eine Erfolgsmeldung nach dem erfolgreichen Backup an.
	#? Beispielaufruf:
	#   Die Funktion wird direkt vom Benutzer aufgerufen und ermöglicht das Sichern aller Datenbanken.
	#   Beispiel: backup_all_databases
	#? Rückgabewert:
	#   - Es gibt keinen expliziten Rückgabewert. Die Funktion zeigt eine Erfolgsmeldung an, wenn das Backup erfolgreich ist.
	#? Hinweise:
	#   - Stellen Sie sicher, dass die erforderlichen MariaDB-Anmeldeinformationen und der Verzeichnispfad korrekt eingegeben werden.
	#   - Der Benutzer sollte die Berechtigungen haben, um auf die Datenbanken zuzugreifen und den mysqldump-Befehl auszuführen.
##
function backup_all_databases() {
    echo -n "Backup All Databases. Enter MariaDB username: "
    read -r db_user
    echo "Enter MariaDB password: "
    read -r db_password
    echo    # newline
    echo -n "Enter backup directory path: "
    read -r backup_dir

    # Ausführen des mysqldump-Befehls für alle Datenbanken
    mysqldump -u "${db_user}" -p"${db_password}" --all-databases > "${backup_dir}/all_databases_backup.sql"

    echo "Backup of all databases saved to ${backup_dir}/all_databases_backup.sql"
}

## * restore_all_databases
	# Datum: 13.11.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht dem Benutzer die Wiederherstellung aller Datenbanken in einer MariaDB-Instanz aus einer SQL-Sicherungsdatei.
	# Benutzer werden aufgefordert, den MariaDB-Benutzernamen, das Passwort und den Dateipfad zur SQL-Sicherungsdatei einzugeben.
	# Die Funktion führt den mysql-Befehl aus, um alle Datenbanken aus der angegebenen Sicherungsdatei wiederherzustellen.
	#? Parameter:
	#   - Keine festen Parameter; Benutzer wird zur Eingabe von MariaDB-Benutzername, Passwort und Dateipfad zur SQL-Sicherungsdatei aufgefordert.
	#? Funktionsverhalten:
	#   - Die Funktion gibt Aufforderungen aus, um den MariaDB-Benutzernamen, das Passwort und den Dateipfad zur SQL-Sicherungsdatei einzugeben.
	#   - Führt den mysql-Befehl aus, um alle Datenbanken aus der angegebenen Sicherungsdatei wiederherzustellen.
	#   - Zeigt eine Erfolgsmeldung nach der erfolgreichen Wiederherstellung an.
	#? Beispielaufruf:
	#   Die Funktion wird direkt vom Benutzer aufgerufen und ermöglicht die Wiederherstellung aller Datenbanken aus einer SQL-Sicherungsdatei.
	#   Beispiel: restore_all_databases
	#? Rückgabewert:
	#   - Es gibt keinen expliziten Rückgabewert. Die Funktion zeigt eine Erfolgsmeldung an, wenn die Wiederherstellung erfolgreich ist.
	#? Hinweise:
	#   - Stellen Sie sicher, dass die erforderlichen MariaDB-Anmeldeinformationen und der Dateipfad zur SQL-Sicherungsdatei korrekt eingegeben werden.
	#   - Der Benutzer sollte die Berechtigungen haben, um Datenbanken wiederherzustellen und den mysql-Befehl auszuführen.
##
function restore_all_databases() {
    echo -n "Restore All Databases. Enter MariaDB username: "
    read -r db_user
    echo "Enter MariaDB password: "
    read -r db_password
    echo    # newline
    echo -n "Enter path to the SQL backup file: "
    read -r backup_file_path

    # Ausführen des mysql-Befehls für die Wiederherstellung aller Datenbanken
    mysql -u "${db_user}" -p"${db_password}" < "${backup_file_path}"

    echo "All databases restored from ${backup_file_path} successfully."
}

## * display_user_permissions
	# Datum: 13.11.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht dem Benutzer das Anzeigen der Berechtigungen für einen bestimmten Benutzer in einer MariaDB-Datenbank.
	# Benutzer werden aufgefordert, den MariaDB-Benutzernamen, das Passwort, den Datenbanknamen und den Benutzernamen für die Berechtigungsüberprüfung einzugeben.
	# Die Funktion führt die SHOW GRANTS-Abfrage aus, um die Berechtigungen des angegebenen Benutzers anzuzeigen.
	#? Parameter:
	#   - Keine festen Parameter; Benutzer wird zur Eingabe von MariaDB-Benutzername, Passwort, Datenbankname und Benutzernamen für die Berechtigungsüberprüfung aufgefordert.
	#? Funktionsverhalten:
	#   - Die Funktion gibt Aufforderungen aus, um den MariaDB-Benutzernamen, das Passwort, den Datenbanknamen und den Benutzernamen für die Berechtigungsüberprüfung einzugeben.
	#   - Führt die SHOW GRANTS-Abfrage aus, um die Berechtigungen des angegebenen Benutzers anzuzeigen.
	#   - Zeigt die Ergebnisse der Berechtigungen für den angegebenen Benutzer an.
	#? Beispielaufruf:
	#   Die Funktion wird direkt vom Benutzer aufgerufen und ermöglicht das Anzeigen der Berechtigungen für einen bestimmten Benutzer.
	#   Beispiel: display_user_permissions
	#? Rückgabewert:
	#   - Es gibt keinen expliziten Rückgabewert. Die Funktion zeigt die Berechtigungen des angegebenen Benutzers an.
	#? Hinweise:
	#   - Stellen Sie sicher, dass die erforderlichen MariaDB-Anmeldeinformationen, der Datenbankname und der Benutzername korrekt eingegeben werden.
	#   - Der Benutzer sollte die Berechtigungen haben, um die SHOW GRANTS-Abfrage auszuführen.
##
function display_user_permissions() {
    echo -n "Display User Permissions. Enter MariaDB username: "
    read -r db_user
    echo "Enter MariaDB password: "
    read -r db_password
    echo    # newline
    echo -n "Enter MariaDB database name: "
    read -r db_name
    echo -n "Enter username to check permissions: "
    read -r check_user

    # Ausführen der SHOW GRANTS-Abfrage
    result=$(mysql -u "${db_user}" -p"${db_password}" "${db_name}" -se "SHOW GRANTS FOR '${check_user}'@'%';")

    # Anzeigen der Ergebnisse
    echo "Permissions for ${check_user}:"
    echo "${result}"
}

## * add_user
	# Datum: 13.11.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht dem Benutzer das Hinzufügen eines neuen Benutzers zu einer MariaDB-Datenbank.
	# Benutzer werden aufgefordert, den MariaDB-Benutzernamen, das Passwort, den Datenbanknamen sowie den Benutzernamen und das Passwort für den neuen Benutzer einzugeben.
	# Die Funktion führt die CREATE USER-Abfrage aus, um einen neuen Benutzer mit dem angegebenen Benutzernamen und Passwort zu erstellen.
	#? Parameter:
	#   - Keine festen Parameter; Benutzer wird zur Eingabe von MariaDB-Benutzername, Passwort, Datenbankname, neuem Benutzernamen und neuem Passwort aufgefordert.
	#? Funktionsverhalten:
	#   - Die Funktion gibt Aufforderungen aus, um den MariaDB-Benutzernamen, das Passwort, den Datenbanknamen, den neuen Benutzernamen und das neue Passwort einzugeben.
	#   - Führt die CREATE USER-Abfrage aus, um einen neuen Benutzer mit den angegebenen Informationen zu erstellen.
	#   - Zeigt eine Erfolgsmeldung nach erfolgreichem Hinzufügen des Benutzers an.
	#? Beispielaufruf:
	#   Die Funktion wird direkt vom Benutzer aufgerufen und ermöglicht das Hinzufügen eines neuen Benutzers zur Datenbank.
	#   Beispiel: add_user
	#? Rückgabewert:
	#   - Es gibt keinen expliziten Rückgabewert. Die Funktion zeigt eine Erfolgsmeldung an, wenn das Hinzufügen des Benutzers erfolgreich ist.
	#? Hinweise:
	#   - Stellen Sie sicher, dass die erforderlichen MariaDB-Anmeldeinformationen, der Datenbankname, der neue Benutzername und das neue Passwort korrekt eingegeben werden.
	#   - Der Benutzer sollte die Berechtigungen haben, um die CREATE USER-Abfrage auszuführen.
##
function add_user() {
    echo -n "Add User. Enter MariaDB username: "
    read -r db_user
    echo "Enter MariaDB password: "
    read -r db_password
    echo    # newline
    echo -n "Enter MariaDB database name: "
    read -r db_name
    echo -n "Enter new username: "
    read -r new_username
    echo -n "Enter password for the new user: "
    read -r new_password

    # Ausführen der CREATE USER-Abfrage
    mysql -u "${db_user}" -p"${db_password}" "${db_name}" -e "CREATE USER '${new_username}'@'%' IDENTIFIED BY '${new_password}';"

    echo "User ${new_username} added successfully."
}

## * modify_user_permissions
	# Datum: 13.11.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht dem Benutzer die Modifikation der Berechtigungen für einen bestimmten Benutzer in einer MariaDB-Datenbank.
	# Benutzer werden aufgefordert, den MariaDB-Benutzernamen, das Passwort, den Datenbanknamen, den Benutzernamen für die Berechtigungsmodifikation und die neuen Berechtigungen einzugeben.
	# Die Funktion führt die GRANT-Abfrage aus, um die Berechtigungen des angegebenen Benutzers zu ändern oder zu erweitern.
	#? Parameter:
	#   - Keine festen Parameter; Benutzer wird zur Eingabe von MariaDB-Benutzername, Passwort, Datenbankname, Benutzernamen für die Berechtigungsmodifikation und neuen Berechtigungen aufgefordert.
	#? Funktionsverhalten:
	#   - Die Funktion gibt Aufforderungen aus, um den MariaDB-Benutzernamen, das Passwort, den Datenbanknamen, den Benutzernamen für die Berechtigungsmodifikation und die neuen Berechtigungen einzugeben.
	#   - Führt die GRANT-Abfrage aus, um die Berechtigungen des angegebenen Benutzers zu ändern oder zu erweitern.
	#   - Zeigt eine Erfolgsmeldung nach erfolgreicher Modifikation der Berechtigungen an.
	#? Beispielaufruf:
	#   Die Funktion wird direkt vom Benutzer aufgerufen und ermöglicht die Modifikation der Berechtigungen für einen bestimmten Benutzer.
	#   Beispiel: modify_user_permissions
	#? Rückgabewert:
	#   - Es gibt keinen expliziten Rückgabewert. Die Funktion zeigt eine Erfolgsmeldung an, wenn die Berechtigungen erfolgreich modifiziert wurden.
	#? Hinweise:
	#   - Stellen Sie sicher, dass die erforderlichen MariaDB-Anmeldeinformationen, der Datenbankname, der Benutzername für die Berechtigungsmodifikation und die neuen Berechtigungen korrekt eingegeben werden.
	#   - Der Benutzer sollte die Berechtigungen haben, um die GRANT-Abfrage auszuführen.
##
function modify_user_permissions() {
    echo -n "Modify User Permissions. Enter MariaDB username: "
    read -r db_user
    echo "Enter MariaDB password: "
    read -r db_password
    echo    # newline
    echo -n "Enter MariaDB database name: "
    read -r db_name
    echo -n "Enter username to modify permissions: "
    read -r modify_user
    echo -n "Enter new permissions (e.g., SELECT, INSERT): "
    read -r new_permissions

    # Ausführen der GRANT-Abfrage
    mysql -u "${db_user}" -p"${db_password}" "${db_name}" -e "GRANT ${new_permissions} ON *.* TO '${modify_user}'@'%';"

    echo "Permissions modified for ${modify_user}."
}

## * delete_user
	# Datum: 13.11.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht dem Benutzer das Löschen eines bestimmten Benutzers aus einer MariaDB-Datenbank.
	# Benutzer werden aufgefordert, den MariaDB-Benutzernamen, das Passwort, den Datenbanknamen und den Benutzernamen des zu löschenden Benutzers einzugeben.
	# Die Funktion führt die DROP USER-Abfrage aus, um den angegebenen Benutzer zu löschen.
	#? Parameter:
	#   - Keine festen Parameter; Benutzer wird zur Eingabe von MariaDB-Benutzername, Passwort, Datenbankname und Benutzernamen des zu löschenden Benutzers aufgefordert.
	#? Funktionsverhalten:
	#   - Die Funktion gibt Aufforderungen aus, um den MariaDB-Benutzernamen, das Passwort, den Datenbanknamen und den Benutzernamen des zu löschenden Benutzers einzugeben.
	#   - Führt die DROP USER-Abfrage aus, um den angegebenen Benutzer zu löschen.
	#   - Zeigt eine Erfolgsmeldung nach erfolgreichem Löschen des Benutzers an.
	#? Beispielaufruf:
	#   Die Funktion wird direkt vom Benutzer aufgerufen und ermöglicht das Löschen eines bestimmten Benutzers aus der Datenbank.
	#   Beispiel: delete_user
	#? Rückgabewert:
	#   - Es gibt keinen expliziten Rückgabewert. Die Funktion zeigt eine Erfolgsmeldung an, wenn das Löschen des Benutzers erfolgreich ist.
	#? Hinweise:
	#   - Stellen Sie sicher, dass die erforderlichen MariaDB-Anmeldeinformationen, der Datenbankname und der Benutzername des zu löschenden Benutzers korrekt eingegeben werden.
	#   - Der Benutzer sollte die Berechtigungen haben, um die DROP USER-Abfrage auszuführen.
##
function delete_user() {
    echo -n "Delete User. Enter MariaDB username: "
    read -r db_user
    echo "Enter MariaDB password: "
    read -r db_password
    echo    # newline
    echo -n "Enter MariaDB database name: "
    read -r db_name
    echo -n "Enter username to delete: "
    read -r delete_user

    # Ausführen der DROP USER-Abfrage
    mysql -u "${db_user}" -p"${db_password}" "${db_name}" -e "DROP USER '${delete_user}'@'%';"

    echo "User ${delete_user} deleted successfully."
}

## * rename_table
	# Datum: 13.11.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht dem Benutzer das Umbenennen einer Tabelle in einer MariaDB-Datenbank.
	# Benutzer werden aufgefordert, den MariaDB-Benutzernamen, das Passwort, den Datenbanknamen sowie den aktuellen und neuen Tabellennamen einzugeben.
	# Die Funktion führt die RENAME TABLE-Abfrage aus, um die angegebene Tabelle umzubenennen.
	#? Parameter:
	#   - Keine festen Parameter; Benutzer wird zur Eingabe von MariaDB-Benutzername, Passwort, Datenbankname sowie aktuellem und neuem Tabellennamen aufgefordert.
	#? Funktionsverhalten:
	#   - Die Funktion gibt Aufforderungen aus, um den MariaDB-Benutzernamen, das Passwort, den Datenbanknamen sowie den aktuellen und neuen Tabellennamen einzugeben.
	#   - Führt die RENAME TABLE-Abfrage aus, um die angegebene Tabelle umzubenennen.
	#   - Zeigt eine Erfolgsmeldung nach erfolgreichem Umbenennen der Tabelle an.
	#? Beispielaufruf:
	#   Die Funktion wird direkt vom Benutzer aufgerufen und ermöglicht das Umbenennen einer Tabelle in der Datenbank.
	#   Beispiel: rename_table
	#? Rückgabewert:
	#   - Es gibt keinen expliziten Rückgabewert. Die Funktion zeigt eine Erfolgsmeldung an, wenn das Umbenennen der Tabelle erfolgreich ist.
	#? Hinweise:
	#   - Stellen Sie sicher, dass die erforderlichen MariaDB-Anmeldeinformationen, der Datenbankname sowie aktueller und neuer Tabellenname korrekt eingegeben werden.
	#   - Der Benutzer sollte die Berechtigungen haben, um die RENAME TABLE-Abfrage auszuführen.
##
function rename_table() {
    echo -n "Rename Table. Enter MariaDB username: "
    read -r db_user
    echo "Enter MariaDB password: "
    read -r db_password
    echo    # newline
    echo -n "Enter MariaDB database name: "
    read -r db_name
    echo -n "Enter current table name: "
    read -r current_table_name
    echo -n "Enter new table name: "
    read -r new_table_name

    # Ausführen der RENAME TABLE-Abfrage
    mysql -u "${db_user}" -p"${db_password}" "${db_name}" -e "RENAME TABLE ${current_table_name} TO ${new_table_name};"

    echo "Table ${current_table_name} renamed to ${new_table_name} successfully."
}

## * show_running_processes
	# Datum: 13.11.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht dem Benutzer das Anzeigen der aktuellen laufenden Prozesse in einer MariaDB-Datenbank.
	# Benutzer werden aufgefordert, den MariaDB-Benutzernamen und das Passwort einzugeben.
	# Die Funktion führt die SHOW PROCESSLIST-Abfrage aus, um eine Liste der aktuellen Prozesse abzurufen.
	#? Parameter:
	#   - Keine festen Parameter; Benutzer wird zur Eingabe von MariaDB-Benutzername und Passwort aufgefordert.
	#? Funktionsverhalten:
	#   - Die Funktion gibt Aufforderungen aus, um den MariaDB-Benutzernamen und das Passwort einzugeben.
	#   - Führt die SHOW PROCESSLIST-Abfrage aus, um eine Liste der aktuellen Prozesse in der MariaDB-Datenbank abzurufen.
	#   - Zeigt die Ergebnisse, d. h. die laufenden Prozesse, an.
	#? Beispielaufruf:
	#   Die Funktion wird direkt vom Benutzer aufgerufen und ermöglicht das Anzeigen der aktuellen laufenden Prozesse.
	#   Beispiel: show_running_processes
	#? Rückgabewert:
	#   - Es gibt keinen expliziten Rückgabewert. Die Funktion zeigt die Liste der aktuellen laufenden Prozesse an.
	#? Hinweise:
	#   - Stellen Sie sicher, dass die erforderlichen MariaDB-Anmeldeinformationen korrekt eingegeben werden.
	#   - Der Benutzer sollte die Berechtigungen haben, um die SHOW PROCESSLIST-Abfrage auszuführen.
##
function show_running_processes() {
    echo -n "Show Running Processes. Enter MariaDB username: "
    read -r db_user
    echo "Enter MariaDB password: "
    read -r db_password
    echo    # newline

    # Ausführen der SHOW PROCESSLIST-Abfrage
    result=$(mysql -u "${db_user}" -p"${db_password}" -e "SHOW PROCESSLIST;")

    # Anzeigen der Ergebnisse
    echo "Running Processes:"
    echo "${result}"
}

## * clear_query_cache
	# Datum: 13.11.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht dem Benutzer das Löschen des Query-Cache in einer MariaDB-Datenbank.
	# Benutzer werden aufgefordert, den MariaDB-Benutzernamen und das Passwort einzugeben.
	# Die Funktion führt den RESET QUERY CACHE-Befehl aus, um den Query-Cache zu leeren.
	#? Parameter:
	#   - Keine festen Parameter; Benutzer wird zur Eingabe von MariaDB-Benutzername und Passwort aufgefordert.
	#? Funktionsverhalten:
	#   - Die Funktion gibt Aufforderungen aus, um den MariaDB-Benutzernamen und das Passwort einzugeben.
	#   - Führt den RESET QUERY CACHE-Befehl aus, um den Query-Cache in der MariaDB-Datenbank zu leeren.
	#   - Zeigt eine Erfolgsmeldung nach erfolgreichem Leeren des Query-Cache an.
	#? Beispielaufruf:
	#   Die Funktion wird direkt vom Benutzer aufgerufen und ermöglicht das Löschen des Query-Cache in der Datenbank.
	#   Beispiel: clear_query_cache
	#? Rückgabewert:
	#   - Es gibt keinen expliziten Rückgabewert. Die Funktion zeigt eine Erfolgsmeldung an, wenn das Leeren des Query-Cache erfolgreich ist.
	#? Hinweise:
	#   - Stellen Sie sicher, dass die erforderlichen MariaDB-Anmeldeinformationen korrekt eingegeben werden.
	#   - Der Benutzer sollte die Berechtigungen haben, um den RESET QUERY CACHE-Befehl auszuführen.
##
function clear_query_cache() {
    echo -n "Clear Query Cache. Enter MariaDB username: "
    read -r db_user
    echo "Enter MariaDB password: "
    read -r db_password
    echo    # newline

    # Ausführen des RESET QUERY CACHE-Befehls
    mysql -u "${db_user}" -p"${db_password}" -e "RESET QUERY CACHE;"

    echo "Query cache cleared successfully."
}

## * show_index_info
	# Datum: 13.11.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht dem Benutzer das Anzeigen von Indexinformationen für eine Tabelle in einer MariaDB-Datenbank.
	# Benutzer werden aufgefordert, den MariaDB-Benutzernamen, das Passwort und den Datenbanknamen einzugeben.
	# Die Funktion führt die SHOW INDEX-Abfrage aus, um Informationen zu den Indizes der angegebenen Tabelle anzuzeigen.
	#? Parameter:
	#   - Keine festen Parameter; Benutzer wird zur Eingabe von MariaDB-Benutzernamen, Passwort, Datenbankname und Tabellennamen aufgefordert.
	#? Funktionsverhalten:
	#   - Die Funktion gibt Aufforderungen aus, um den MariaDB-Benutzernamen, das Passwort, den Datenbanknamen und den Tabellennamen einzugeben.
	#   - Führt die SHOW INDEX-Abfrage aus, um Informationen zu den Indizes der angegebenen Tabelle anzuzeigen.
	#   - Zeigt die Ergebnisse, d. h. die Indexinformationen, an.
	#? Beispielaufruf:
	#   Die Funktion wird direkt vom Benutzer aufgerufen und ermöglicht das Anzeigen von Indexinformationen für eine bestimmte Tabelle.
	#   Beispiel: show_index_info
	#? Rückgabewert:
	#   - Es gibt keinen expliziten Rückgabewert. Die Funktion zeigt die Indexinformationen für die angegebene Tabelle an.
	#? Hinweise:
	#   - Stellen Sie sicher, dass die erforderlichen MariaDB-Anmeldeinformationen und der Tabellenname korrekt eingegeben werden.
	#   - Der Benutzer sollte die Berechtigungen haben, um auf die angegebene Datenbank zuzugreifen und Operationen durchzuführen.
##
function show_index_info() {
    echo -n "Show Index Information. Enter MariaDB username: "
    read -r db_user
    echo "Enter MariaDB password: "
    read -r db_password
    echo    # newline
    echo -n "Enter MariaDB database name: "
    read -r db_name
    echo -n "Enter table name: "
    read -r table_name

    # Ausführen der SHOW INDEX-Abfrage
    result=$(mysql -u "${db_user}" -p"${db_password}" "${db_name}" -e "SHOW INDEX FROM ${table_name};")

    # Anzeigen der Ergebnisse
    echo "Index Information for ${table_name}:"
    echo "${result}"
}

## * analyze_database
	# Datum: 13.11.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht dem Benutzer das Analysieren aller Tabellen in einer MariaDB-Datenbank, um Statistiken zu aktualisieren.
	# Benutzer werden aufgefordert, den MariaDB-Benutzernamen, das Passwort und den Datenbanknamen einzugeben.
	# Die Funktion führt den ANALYZE TABLE-Befehl aus, um alle Tabellen in der angegebenen Datenbank zu analysieren.
	#? Parameter:
	#   - Keine festen Parameter; Benutzer wird zur Eingabe von MariaDB-Benutzernamen, Passwort und Datenbankname aufgefordert.
	#? Funktionsverhalten:
	#   - Die Funktion gibt Aufforderungen aus, um den MariaDB-Benutzernamen, das Passwort und den Datenbanknamen einzugeben.
	#   - Führt den ANALYZE TABLE-Befehl aus, um alle Tabellen in der angegebenen Datenbank zu analysieren.
	#   - Zeigt eine Erfolgsmeldung nach erfolgreichem Analysieren der Datenbank an.
	#? Beispielaufruf:
	#   Die Funktion wird direkt vom Benutzer aufgerufen und ermöglicht das Analysieren aller Tabellen in einer Datenbank.
	#   Beispiel: analyze_database
	#? Rückgabewert:
	#   - Es gibt keinen expliziten Rückgabewert. Die Funktion zeigt eine Erfolgsmeldung an, wenn das Analysieren der Datenbank erfolgreich ist.
	#? Hinweise:
	#   - Stellen Sie sicher, dass die erforderlichen MariaDB-Anmeldeinformationen und der Datenbankname korrekt eingegeben werden.
	#   - Der Benutzer sollte die Berechtigungen haben, um auf die angegebene Datenbank zuzugreifen und Operationen durchzuführen.
##
function analyze_database() {
    echo -n "Analyze Database. Enter MariaDB username: "
    read -r db_user
    echo "Enter MariaDB password: "
    read -r db_password
    echo    # newline
    echo -n "Enter MariaDB database name: "
    read -r db_name

    # Ausführen des ANALYZE TABLE-Befehls
    mysql -u "${db_user}" -p"${db_password}" "${db_name}" -e "ANALYZE TABLE;"

    echo "Database analyzed successfully."
}

## * optimize_query
	# Datum: 13.11.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht dem Benutzer das Optimieren einer SQL-Abfrage in einer MariaDB-Datenbank.
	# Benutzer werden aufgefordert, den MariaDB-Benutzernamen, das Passwort, den Datenbanknamen und die zu optimierende SQL-Abfrage einzugeben.
	# Die Funktion führt den EXPLAIN-Befehl für den Ausführungsplan der angegebenen SQL-Abfrage aus, um Optimierungsmöglichkeiten aufzuzeigen.
	#? Parameter:
	#   - Keine festen Parameter; Benutzer wird zur Eingabe von MariaDB-Benutzernamen, Passwort, Datenbankname und SQL-Abfrage aufgefordert.
	#? Funktionsverhalten:
	#   - Die Funktion gibt Aufforderungen aus, um den MariaDB-Benutzernamen, das Passwort, den Datenbanknamen und die SQL-Abfrage einzugeben.
	#   - Führt den EXPLAIN-Befehl für den Ausführungsplan der SQL-Abfrage aus und zeigt Optimierungsmöglichkeiten an.
	#   - Zeigt den Ausführungsplan der SQL-Abfrage an.
	#? Beispielaufruf:
	#   Die Funktion wird direkt vom Benutzer aufgerufen und ermöglicht das Optimieren einer SQL-Abfrage.
	#   Beispiel: optimize_query
	#? Rückgabewert:
	#   - Es gibt keinen expliziten Rückgabewert. Die Funktion zeigt den Ausführungsplan der SQL-Abfrage an.
	#? Hinweise:
	#   - Stellen Sie sicher, dass die erforderlichen MariaDB-Anmeldeinformationen, der Datenbankname und die SQL-Abfrage korrekt eingegeben werden.
	#   - Die Analyse des Ausführungsplans kann Optimierungsmöglichkeiten für die angegebene SQL-Abfrage aufzeigen.
##
function optimize_query() {
    echo -n "Optimize Query. Enter MariaDB username: "
    read -r db_user
    echo "Enter MariaDB password: "
    read -r db_password
    echo    # newline
    echo -n "Enter MariaDB database name: "
    read -r db_name
    echo -n "Enter SQL query to optimize: "
    read -r sql_query

    # Ausführen des EXPLAIN-Befehls für den Ausführungsplan
    result=$(mysql -u "${db_user}" -p"${db_password}" "${db_name}" -e "EXPLAIN ${sql_query};")

    # Anzeigen des Ausführungsplans
    echo "Query Execution Plan:"
    echo "${result}"
}

## * create_database
	# Datum: 13.11.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht dem Benutzer das Erstellen einer neuen Datenbank in einer MariaDB-Instanz.
	# Benutzer werden aufgefordert, den MariaDB-Benutzernamen, das Passwort und einen Namen für die neue Datenbank einzugeben.
	# Die Funktion führt den CREATE DATABASE-Befehl aus, um die neue Datenbank zu erstellen.
	#? Parameter:
	#   - Keine festen Parameter; Benutzer wird zur Eingabe von MariaDB-Benutzernamen, Passwort und Namen für die neue Datenbank aufgefordert.
	#? Funktionsverhalten:
	#   - Die Funktion gibt Aufforderungen aus, um den MariaDB-Benutzernamen, das Passwort und einen Namen für die neue Datenbank einzugeben.
	#   - Führt den CREATE DATABASE-Befehl aus, um die neue Datenbank zu erstellen.
	#? Beispielaufruf:
	#   Die Funktion wird direkt vom Benutzer aufgerufen und ermöglicht das Erstellen einer neuen Datenbank.
	#   Beispiel: create_database
	#? Rückgabewert:
	#   - Es gibt keinen expliziten Rückgabewert. Die Funktion gibt eine Erfolgsmeldung aus, wenn die Datenbank erfolgreich erstellt wurde.
	#? Hinweise:
	#   - Stellen Sie sicher, dass die erforderlichen MariaDB-Anmeldeinformationen und der Name für die neue Datenbank korrekt eingegeben werden.
	#   - Der Benutzer sollte die erforderlichen Berechtigungen haben, um eine neue Datenbank zu erstellen.
##
function create_database() {
    echo -n "Create Database. Enter MariaDB username: "
    read -r db_user
    echo "Enter MariaDB password: "
    read -r db_password
    echo    # newline
    echo -n "Enter name for the new database: "
    read -r new_db_name

    # Ausführen des CREATE DATABASE-Befehls
    mysql -u "${db_user}" -p"${db_password}" -e "CREATE DATABASE ${new_db_name};"

    echo "Database ${new_db_name} created successfully."
}

## * create_table
	# Datum: 13.11.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht dem Benutzer das Erstellen einer neuen Tabelle in einer vorhandenen MariaDB-Datenbank.
	# Benutzer werden aufgefordert, den MariaDB-Benutzernamen, das Passwort, den Datenbanknamen und einen Namen für die neue Tabelle einzugeben.
	# Zusätzlich werden Benutzer gebeten, die Spalten und ihre Datentypen für die neue Tabelle einzugeben.
	# Die Funktion führt den CREATE TABLE-Befehl aus, um die neue Tabelle mit den angegebenen Spalten zu erstellen.
	#? Parameter:
	#   - Keine festen Parameter; Benutzer wird zur Eingabe von MariaDB-Benutzernamen, Passwort, Datenbanknamen und Namen für die neue Tabelle aufgefordert.
	#? Funktionsverhalten:
	#   - Die Funktion gibt Aufforderungen aus, um den MariaDB-Benutzernamen, das Passwort, den Datenbanknamen und den Namen für die neue Tabelle einzugeben.
	#   - Benutzer werden aufgefordert, die Spalten und ihre Datentypen für die neue Tabelle einzugeben.
	#   - Führt den CREATE TABLE-Befehl aus, um die neue Tabelle mit den angegebenen Spalten zu erstellen.
	#? Beispielaufruf:
	#   Die Funktion wird direkt vom Benutzer aufgerufen und ermöglicht das Erstellen einer neuen Tabelle.
	#   Beispiel: create_table
	#? Rückgabewert:
	#   - Es gibt keinen expliziten Rückgabewert. Die Funktion gibt eine Erfolgsmeldung aus, wenn die Tabelle erfolgreich erstellt wurde.
	#? Hinweise:
	#   - Stellen Sie sicher, dass die erforderlichen MariaDB-Anmeldeinformationen, der Datenbankname und der Name für die neue Tabelle korrekt eingegeben werden.
	#   - Der Benutzer sollte die erforderlichen Berechtigungen haben, um eine neue Tabelle zu erstellen.
##
function create_table() {
    echo -n "Create Table. Enter MariaDB username: "
    read -r db_user
    echo "Enter MariaDB password: "
    read -r db_password
    echo    # newline
    echo -n "Enter MariaDB database name: "
    read -r db_name
    echo -n "Enter name for the new table: "
    read -r new_table_name

    # Benutzer wird aufgefordert, Spalten und deren Datentypen einzugeben
    echo "Enter columns and data types (e.g., 'column1 INT, column2 VARCHAR(255), ...'): "
    read -r table_columns

    # Ausführen des CREATE TABLE-Befehls
    mysql -u "${db_user}" -p"${db_password}" "${db_name}" -e "CREATE TABLE ${new_table_name} (${table_columns});"

    echo "Table ${new_table_name} created successfully."
}

## * alter_table_structure
	# Datum: 13.11.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht dem Benutzer das Ändern der Struktur einer vorhandenen Tabelle in einer MariaDB-Datenbank.
	# Benutzer werden aufgefordert, den MariaDB-Benutzernamen, das Passwort, den Datenbanknamen und den Namen der zu ändernden Tabelle einzugeben.
	# Zusätzlich werden Benutzer gebeten, die gewünschten Änderungen an der Tabellenstruktur einzugeben.
	# Die Funktion führt den ALTER TABLE-Befehl aus, um die angegebenen Änderungen an der Tabelle durchzuführen.
	#? Parameter:
	#   - Keine festen Parameter; Benutzer wird zur Eingabe von MariaDB-Benutzernamen, Passwort, Datenbanknamen und Namen der zu ändernden Tabelle aufgefordert.
	#? Funktionsverhalten:
	#   - Die Funktion gibt Aufforderungen aus, um den MariaDB-Benutzernamen, das Passwort, den Datenbanknamen und den Namen der zu ändernden Tabelle einzugeben.
	#   - Benutzer werden aufgefordert, die gewünschten Änderungen an der Tabellenstruktur einzugeben.
	#   - Führt den ALTER TABLE-Befehl aus, um die angegebenen Änderungen an der Tabelle durchzuführen.
	#? Beispielaufruf:
	#   Die Funktion wird direkt vom Benutzer aufgerufen und ermöglicht das Ändern der Struktur einer vorhandenen Tabelle.
	#   Beispiel: alter_table_structure
	#? Rückgabewert:
	#   - Es gibt keinen expliziten Rückgabewert. Die Funktion gibt eine Erfolgsmeldung aus, wenn die Tabellenstruktur erfolgreich geändert wurde.
	#? Hinweise:
	#   - Stellen Sie sicher, dass die erforderlichen MariaDB-Anmeldeinformationen, der Datenbankname und der Name der zu ändernden Tabelle korrekt eingegeben werden.
	#   - Der Benutzer sollte die erforderlichen Berechtigungen haben, um die Struktur der Tabelle zu ändern.
##
function alter_table_structure() {
    echo -n "Alter Table Structure. Enter MariaDB username: "
    read -r db_user
    echo "Enter MariaDB password: "
    read -r db_password
    echo    # newline
    echo -n "Enter MariaDB database name: "
    read -r db_name
    echo -n "Enter name of the table to alter: "
    read -r alter_table_name

    # Benutzer wird aufgefordert, die gewünschten Änderungen einzugeben
    echo "Enter alterations (e.g., 'ADD COLUMN new_column INT, DROP COLUMN obsolete_column, ...'): "
    read -r alterations

    # Ausführen des ALTER TABLE-Befehls
    mysql -u "${db_user}" -p"${db_password}" "${db_name}" -e "ALTER TABLE ${alter_table_name} ${alterations};"

    echo "Table ${alter_table_name} structure altered successfully."
}

## * show_user_activity
	# Datum: 13.11.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht es dem Benutzer, die Aktivitäten eines bestimmten Benutzers in einer MariaDB-Datenbank anzuzeigen.
	# Benutzer werden aufgefordert, den MariaDB-Benutzernamen, das Passwort und den Benutzernamen, dessen Aktivität überprüft werden soll, einzugeben.
	# Die Funktion führt dann eine SHOW PROCESSLIST-Abfrage für den angegebenen Benutzer durch und zeigt die laufenden Prozesse und ihre Details an.
	#? Parameter:
	#   - Keine festen Parameter; Benutzer wird zur Eingabe von MariaDB-Benutzernamen, Passwort und dem zu überprüfenden Benutzernamen aufgefordert.
	#? Funktionsverhalten:
	#   - Die Funktion gibt Aufforderungen aus, um den MariaDB-Benutzernamen, das Passwort und den Benutzernamen, dessen Aktivität überprüft werden soll, einzugeben.
	#   - Führt eine SHOW PROCESSLIST-Abfrage für den angegebenen Benutzer durch und zeigt die laufenden Prozesse und ihre Details an.
	#? Beispielaufruf:
	#   Die Funktion wird direkt vom Benutzer aufgerufen und ermöglicht das Anzeigen der Aktivität eines bestimmten Benutzers.
	#   Beispiel: show_user_activity
	#? Rückgabewert:
	#   - Es gibt keinen expliziten Rückgabewert. Die Funktion gibt die laufenden Prozesse und ihre Details für den angegebenen Benutzer aus.
	#? Hinweise:
	#   - Stellen Sie sicher, dass die erforderlichen MariaDB-Anmeldeinformationen und der zu überprüfende Benutzername korrekt eingegeben werden.
	#   - Der Benutzer sollte die erforderlichen Berechtigungen haben, um die Aktivität anderer Benutzer überprüfen zu können.
##
function show_user_activity() {
    echo -n "Show User Activity. Enter MariaDB username: "
    read -r db_user
    echo "Enter MariaDB password: "
    read -r db_password
    echo    # newline
    echo -n "Enter username to check activity: "
    read -r check_user

    # Ausführen der SHOW PROCESSLIST-Abfrage für den bestimmten Benutzer
    result=$(mysql -u "${db_user}" -p"${db_password}" -e "SHOW PROCESSLIST LIKE '${check_user}';")

    # Anzeigen der Ergebnisse
    echo "User Activity for ${check_user}:"
    echo "${result}"
}

## * show_events
	# Datum: 13.11.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht es dem Benutzer, alle geplanten Ereignisse (Events) in einer MariaDB-Datenbank anzuzeigen.
	# Benutzer werden aufgefordert, den MariaDB-Benutzernamen und das Passwort einzugeben.
	# Die Funktion führt dann eine SHOW EVENTS-Abfrage durch und zeigt alle geplanten Ereignisse in der Datenbank an.
	#? Parameter:
	#   - Keine festen Parameter; Benutzer wird zur Eingabe von MariaDB-Benutzernamen und Passwort aufgefordert.
	#? Funktionsverhalten:
	#   - Die Funktion gibt Aufforderungen aus, um den MariaDB-Benutzernamen und das Passwort einzugeben.
	#   - Führt eine SHOW EVENTS-Abfrage durch und zeigt alle geplanten Ereignisse in der Datenbank an.
	#? Beispielaufruf:
	#   Die Funktion wird direkt vom Benutzer aufgerufen und ermöglicht das Anzeigen aller geplanten Ereignisse in der Datenbank.
	#   Beispiel: show_events
	#? Rückgabewert:
	#   - Es gibt keinen expliziten Rückgabewert. Die Funktion gibt alle geplanten Ereignisse in der Datenbank aus.
	#? Hinweise:
	#   - Stellen Sie sicher, dass die erforderlichen MariaDB-Anmeldeinformationen korrekt eingegeben werden.
	#   - Der Benutzer sollte die erforderlichen Berechtigungen haben, um auf die Ereignisse in der Datenbank zuzugreifen.
##
function show_events() {
    echo -n "Show Events. Enter MariaDB username: "
    read -r db_user
    echo "Enter MariaDB password: "
    read -r db_password
    echo    # newline

    # Ausführen der SHOW EVENTS-Abfrage
    result=$(mysql -u "${db_user}" -p"${db_password}" -e "SHOW EVENTS;")

    # Anzeigen der Ergebnisse
    echo "Database Events:"
    echo "${result}"
}

## * check_database_connection
	# Datum: 13.11.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht es dem Benutzer, die Verbindung zur MariaDB-Datenbank zu überprüfen.
	# Benutzer werden aufgefordert, den MariaDB-Benutzernamen und das Passwort einzugeben.
	# Die Funktion versucht dann, eine einfache SELECT 1-Abfrage durchzuführen, um die Verbindung zur Datenbank zu testen.
	# Zeigt eine Erfolgsmeldung an, wenn die Verbindung erfolgreich ist, andernfalls wird eine Fehlermeldung ausgegeben.
	#? Parameter:
	#   - Keine festen Parameter; Benutzer wird zur Eingabe von MariaDB-Benutzernamen und Passwort aufgefordert.
	#? Funktionsverhalten:
	#   - Die Funktion gibt Aufforderungen aus, um den MariaDB-Benutzernamen und das Passwort einzugeben.
	#   - Versucht, eine einfache SELECT 1-Abfrage durchzuführen, um die Verbindung zur Datenbank zu testen.
	#   - Zeigt eine Erfolgsmeldung an, wenn die Verbindung erfolgreich ist, andernfalls wird eine Fehlermeldung ausgegeben.
	#? Beispielaufruf:
	#   Die Funktion wird direkt vom Benutzer aufgerufen und überprüft die Verbindung zur MariaDB-Datenbank.
	#   Beispiel: check_database_connection
	#? Rückgabewert:
	#   - Es gibt keinen expliziten Rückgabewert. Die Funktion gibt eine Erfolgs- oder Fehlermeldung aus.
	#? Hinweise:
	#   - Stellen Sie sicher, dass die erforderlichen MariaDB-Anmeldeinformationen korrekt eingegeben werden.
##
function check_database_connection() {
    echo -n "Check Database Connection. Enter MariaDB username: "
    read -r db_user
    echo "Enter MariaDB password: "
    read -r db_password
    echo    # newline

    # Versuch der Verbindung zur Datenbank
    if mysql -u "${db_user}" -p"${db_password}" -e "SELECT 1;" &> /dev/null; then
        echo "Database connection successful."
    else
        echo "Unable to connect to the database."
    fi
}

## * show_variables
	# Datum: 13.11.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht es dem Benutzer, die aktuellen Konfigurationsvariablen der MariaDB-Datenbank anzuzeigen.
	# Benutzer werden aufgefordert, den MariaDB-Benutzernamen und das Passwort einzugeben.
	# Die Funktion führt dann eine SHOW VARIABLES-Abfrage aus und gibt die Ergebnisse aus.
	#? Parameter:
	#   - Keine festen Parameter; Benutzer wird zur Eingabe von MariaDB-Benutzernamen und Passwort aufgefordert.
	#? Funktionsverhalten:
	#   - Die Funktion gibt Aufforderungen aus, um den MariaDB-Benutzernamen und das Passwort einzugeben.
	#   - Führt eine SHOW VARIABLES-Abfrage aus, um die aktuellen Konfigurationsvariablen anzuzeigen.
	#   - Zeigt die Ergebnisse der Abfrage an.
	#? Beispielaufruf:
	#   Die Funktion wird direkt vom Benutzer aufgerufen, um die aktuellen Datenbankvariablen anzuzeigen.
	#   Beispiel: show_variables
	#? Rückgabewert:
	#   - Es gibt keinen expliziten Rückgabewert. Die Funktion gibt die Ergebnisse der SHOW VARIABLES-Abfrage aus.
	#? Hinweise:
	#   - Stellen Sie sicher, dass die erforderlichen MariaDB-Anmeldeinformationen korrekt eingegeben werden.
##
function show_variables() {
    echo -n "Show Database Variables. Enter MariaDB username: "
    read -r db_user
    echo "Enter MariaDB password: " db_password
    echo    # newline

    # Ausführen der SHOW VARIABLES-Abfrage
    result=$(mysql -u "${db_user}" -p"${db_password}" -e "SHOW VARIABLES;")

    # Anzeigen der Ergebnisse
    echo "Database Variables:"
    echo "${result}"
}

## * show_database_engines
	# Datum: 13.11.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht es dem Benutzer, die verfügbaren Datenbank-Engines in der MariaDB-Datenbank anzuzeigen.
	# Benutzer werden aufgefordert, den MariaDB-Benutzernamen und das Passwort einzugeben.
	# Die Funktion führt dann eine SHOW ENGINES-Abfrage aus und gibt die Ergebnisse aus.
	#? Parameter:
	#   - Keine festen Parameter; Benutzer wird zur Eingabe von MariaDB-Benutzernamen und Passwort aufgefordert.
	#? Funktionsverhalten:
	#   - Die Funktion gibt Aufforderungen aus, um den MariaDB-Benutzernamen und das Passwort einzugeben.
	#   - Führt eine SHOW ENGINES-Abfrage aus, um die verfügbaren Datenbank-Engines anzuzeigen.
	#   - Zeigt die Ergebnisse der Abfrage an.
	#? Beispielaufruf:
	#   Die Funktion wird direkt vom Benutzer aufgerufen, um die verfügbaren Datenbank-Engines anzuzeigen.
	#   Beispiel: show_database_engines
	#? Rückgabewert:
	#   - Es gibt keinen expliziten Rückgabewert. Die Funktion gibt die Ergebnisse der SHOW ENGINES-Abfrage aus.
	#? Hinweise:
	#   - Stellen Sie sicher, dass die erforderlichen MariaDB-Anmeldeinformationen korrekt eingegeben werden.
##
function show_database_engines() {
    echo -n "Show Database Engines. Enter MariaDB username: "
    read -r db_user
    echo "Enter MariaDB password: "
    read -r db_password
    echo    # newline

    # Ausführen der SHOW ENGINES-Abfrage
    result=$(mysql -u "${db_user}" -p"${db_password}" -e "SHOW ENGINES;")

    # Anzeigen der Ergebnisse
    echo "Database Engines:"
    echo "${result}"
}

## * show_collations
	# Datum: 13.11.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht es dem Benutzer, die verfügbaren Kollationen (Collations) in der MariaDB-Datenbank anzuzeigen.
	# Benutzer werden aufgefordert, den MariaDB-Benutzernamen und das Passwort einzugeben.
	# Die Funktion führt dann eine SHOW COLLATION-Abfrage aus und gibt die Ergebnisse aus.
	#? Parameter:
	#   - Keine festen Parameter; Benutzer wird zur Eingabe von MariaDB-Benutzernamen und Passwort aufgefordert.
	#? Funktionsverhalten:
	#   - Die Funktion gibt Aufforderungen aus, um den MariaDB-Benutzernamen und das Passwort einzugeben.
	#   - Führt eine SHOW COLLATION-Abfrage aus, um die verfügbaren Kollationen anzuzeigen.
	#   - Zeigt die Ergebnisse der Abfrage an.
	#? Beispielaufruf:
	#   Die Funktion wird direkt vom Benutzer aufgerufen, um die verfügbaren Kollationen anzuzeigen.
	#   Beispiel: show_collations
	#? Rückgabewert:
	#   - Es gibt keinen expliziten Rückgabewert. Die Funktion gibt die Ergebnisse der SHOW COLLATION-Abfrage aus.
	#? Hinweise:
	#   - Stellen Sie sicher, dass die erforderlichen MariaDB-Anmeldeinformationen korrekt eingegeben werden.
##
function show_collations() {
    echo -n "Show Collations. Enter MariaDB username: "
    read -r db_user
    echo "Enter MariaDB password: "
    read -r db_password
    echo    # newline

    # Ausführen der SHOW COLLATION-Abfrage
    result=$(mysql -u "${db_user}" -p"${db_password}" -e "SHOW COLLATION;")

    # Anzeigen der Ergebnisse
    echo "Database Collations:"
    echo "${result}"
}

## * show_database_statistics
	# Datum: 13.11.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht es dem Benutzer, Statistiken für die angegebene MariaDB-Datenbank anzuzeigen.
	# Benutzer werden aufgefordert, den MariaDB-Benutzernamen, das Passwort und den Datenbanknamen einzugeben.
	# Die Funktion führt dann eine ANALYZE TABLE-Abfrage für die gesamte Datenbank aus und gibt die Ergebnisse aus.
	#? Parameter:
	#   - Keine festen Parameter; Benutzer wird zur Eingabe von MariaDB-Benutzernamen, Passwort und Datenbanknamen aufgefordert.
	#? Funktionsverhalten:
	#   - Die Funktion gibt Aufforderungen aus, um den MariaDB-Benutzernamen, das Passwort und den Datenbanknamen einzugeben.
	#   - Führt eine ANALYZE TABLE-Abfrage für die gesamte Datenbank aus.
	#   - Zeigt die Ergebnisse der Abfrage an, die Statistiken für die Tabellen in der angegebenen Datenbank umfassen.
	#? Beispielaufruf:
	#   Die Funktion wird direkt vom Benutzer aufgerufen, um die Statistiken für eine bestimmte Datenbank anzuzeigen.
	#   Beispiel: show_database_statistics
	#? Rückgabewert:
	#   - Es gibt keinen expliziten Rückgabewert. Die Funktion gibt die Ergebnisse der ANALYZE TABLE-Abfrage aus.
	#? Hinweise:
	#   - Stellen Sie sicher, dass die erforderlichen MariaDB-Anmeldeinformationen und der Datenbankname korrekt eingegeben werden.
##
function show_database_statistics() {
    echo -n "Show Database Statistics. Enter MariaDB username: "
    read -r db_user
    echo "Enter MariaDB password: "
    read -r db_password
    echo    # newline
    echo -n "Enter MariaDB database name: "
    read -r db_name

    # Ausführen der ANALYZE TABLE-Abfrage
    result=$(mysql -u "${db_user}" -p"${db_password}" "${db_name}" -e "ANALYZE TABLE;")

    # Anzeigen der Ergebnisse
    echo "Database Statistics for ${db_name}:"
    echo "${result}"
}

## * show_foreign_keys
	# Datum: 13.11.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht es dem Benutzer, die Fremdschlüssel für eine bestimmte Tabelle in einer MariaDB-Datenbank anzuzeigen.
	# Benutzer werden aufgefordert, den MariaDB-Benutzernamen, das Passwort, den Datenbanknamen und den Tabellennamen einzugeben.
	# Die Funktion führt dann eine SHOW CREATE TABLE-Abfrage für die angegebene Tabelle durch und extrahiert die Fremdschlüsselinformationen.
	#? Parameter:
	#   - Keine festen Parameter; Benutzer wird zur Eingabe von MariaDB-Benutzernamen, Passwort, Datenbanknamen und Tabellennamen aufgefordert.
	#? Funktionsverhalten:
	#   - Die Funktion gibt Aufforderungen aus, um den MariaDB-Benutzernamen, das Passwort, den Datenbanknamen und den Tabellennamen einzugeben.
	#   - Führt eine SHOW CREATE TABLE-Abfrage für die angegebene Tabelle durch und extrahiert die Fremdschlüsselinformationen.
	#   - Zeigt die Ergebnisse der Abfrage an, die die Fremdschlüssel für die angegebene Tabelle enthält.
	#? Beispielaufruf:
	#   Die Funktion wird direkt vom Benutzer aufgerufen, um die Fremdschlüssel für eine bestimmte Tabelle anzuzeigen.
	#   Beispiel: show_foreign_keys
	#? Rückgabewert:
	#   - Es gibt keinen expliziten Rückgabewert. Die Funktion gibt die Ergebnisse der SHOW CREATE TABLE-Abfrage mit den Fremdschlüsseln aus.
	#? Hinweise:
	#   - Stellen Sie sicher, dass die erforderlichen MariaDB-Anmeldeinformationen, der Datenbankname und der Tabellenname korrekt eingegeben werden.
##
function show_foreign_keys() {
    echo -n "Show Foreign Keys. Enter MariaDB username: "
    read -r db_user
    echo "Enter MariaDB password: "
    read -r db_password
    echo    # newline
    echo -n "Enter MariaDB database name: "
    read -r db_name
    echo -n "Enter table name: "
    read -r table_name

    # Ausführen der SHOW CREATE TABLE-Abfrage
    result=$(mysql -u "${db_user}" -p"${db_password}" "${db_name}" -e "SHOW CREATE TABLE ${table_name}\G" | grep 'FOREIGN KEY';)

    # Anzeigen der Ergebnisse
    echo "Foreign Keys for ${table_name}:"
    echo "${result}"
}

## * add_column_encryption
	# Datum: 13.11.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht es dem Benutzer, eine Spalte in einer MariaDB-Tabelle zu verschlüsseln.
	# Der Benutzer wird aufgefordert, den MariaDB-Benutzernamen, das Passwort, den Datenbanknamen, den Tabellennamen und den Namen der zu verschlüsselnden Spalte einzugeben.
	# Die Funktion führt dann eine ALTER TABLE-Abfrage durch, um die angegebene Spalte in der angegebenen Tabelle zu verschlüsseln.
	#? Parameter:
	#   - Keine festen Parameter; Benutzer wird zur Eingabe von MariaDB-Benutzernamen, Passwort, Datenbanknamen, Tabellennamen und Spaltennamen aufgefordert.
	#? Funktionsverhalten:
	#   - Die Funktion gibt Aufforderungen aus, um den MariaDB-Benutzernamen, das Passwort, den Datenbanknamen, den Tabellennamen und den Spaltennamen einzugeben.
	#   - Führt eine ALTER TABLE-Abfrage durch, um die angegebene Spalte in der angegebenen Tabelle zu verschlüsseln.
	#   - Gibt eine Erfolgsmeldung aus, nachdem die Spalte erfolgreich verschlüsselt wurde.
	#? Beispielaufruf:
	#   Die Funktion wird direkt vom Benutzer aufgerufen, um eine bestimmte Spalte in einer Tabelle zu verschlüsseln.
	#   Beispiel: add_column_encryption
	#? Rückgabewert:
	#   - Es gibt keinen expliziten Rückgabewert. Die Funktion gibt eine Erfolgsmeldung nach erfolgreicher Verschlüsselung der Spalte aus.
	#? Hinweise:
	#   - Stellen Sie sicher, dass die erforderlichen MariaDB-Anmeldeinformationen, der Datenbankname, der Tabellenname und der Spaltenname korrekt eingegeben werden.
##
function add_column_encryption() {
    echo -n "Add Column Encryption. Enter MariaDB username: "
    read -r db_user
    echo "Enter MariaDB password: "
    read -r db_password
    echo    # newline
    echo -n "Enter MariaDB database name: "
    read -r db_name
    echo -n "Enter table name: "
    read -r table_name
    echo -n "Enter column name to encrypt: "
    read -r column_name

    # Ausführen der ALTER TABLE-Abfrage mit Verschlüsselung
    mysql -u "${db_user}" -p"${db_password}" "${db_name}" -e "ALTER TABLE ${table_name} MODIFY COLUMN ${column_name} VARBINARY(255) ENCRYPTED;"
    
    echo "Column ${column_name} in ${table_name} encrypted successfully."
}

## * show_last_table_changes
	# Datum: 13.11.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht es dem Benutzer, die letzten Änderungen an einer bestimmten Tabelle in MariaDB anzuzeigen.
	# Der Benutzer wird aufgefordert, den MariaDB-Benutzernamen, das Passwort, den Datenbanknamen und den Tabellennamen einzugeben.
	# Die Funktion führt dann eine INFORMATION_SCHEMA-Abfrage durch, um die letzten Änderungen an der angegebenen Tabelle abzurufen.
	#? Parameter:
	#   - Keine festen Parameter; Benutzer wird zur Eingabe von MariaDB-Benutzernamen, Passwort, Datenbanknamen und Tabellennamen aufgefordert.
	#? Funktionsverhalten:
	#   - Die Funktion gibt Aufforderungen aus, um den MariaDB-Benutzernamen, das Passwort, den Datenbanknamen und den Tabellennamen einzugeben.
	#   - Führt eine INFORMATION_SCHEMA-Abfrage durch, um die letzten Änderungen an der angegebenen Tabelle abzurufen.
	#   - Gibt die Ergebnisse der Abfrage aus, die die letzten Änderungen an der Tabelle anzeigen.
	#? Beispielaufruf:
	#   Die Funktion wird direkt vom Benutzer aufgerufen, um die letzten Änderungen an einer bestimmten Tabelle anzuzeigen.
	#   Beispiel: show_last_table_changes
	#? Rückgabewert:
	#   - Es gibt keinen expliziten Rückgabewert. Die Funktion gibt die Ergebnisse der Abfrage aus, die die letzten Änderungen an der Tabelle anzeigen.
	#? Hinweise:
	#   - Stellen Sie sicher, dass die erforderlichen MariaDB-Anmeldeinformationen, der Datenbankname und der Tabellenname korrekt eingegeben werden.
##
function show_last_table_changes() {
    echo -n "Show Last Table Changes. Enter MariaDB username: "
    read -r db_user
    echo "Enter MariaDB password: "
    read -r db_password
    echo    # newline
    echo -n "Enter MariaDB database name: "
    read -r db_name
    echo -n "Enter table name: "
    read -r table_name

    # Ausführen der INFORMATION_SCHEMA-Abfrage für Änderungen
    result=$(mysql -u "${db_user}" -p"${db_password}" "${db_name}" -e "SELECT * FROM information_schema.tables WHERE table_name = '${table_name}' ORDER BY update_time DESC LIMIT 1;")

    # Anzeigen der Ergebnisse
    echo "Last changes to ${table_name}:"
    echo "${result}"
}

## * show_database_events
	# Datum: 13.11.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht es dem Benutzer, die geplanten Ereignisse (Events) einer bestimmten Datenbank in MariaDB anzuzeigen.
	# Der Benutzer wird aufgefordert, den MariaDB-Benutzernamen, das Passwort und den Datenbanknamen einzugeben.
	# Die Funktion führt dann eine SHOW EVENTS-Abfrage durch, um die geplanten Ereignisse der angegebenen Datenbank abzurufen.
	#? Parameter:
	#   - Keine festen Parameter; Benutzer wird zur Eingabe von MariaDB-Benutzernamen, Passwort und Datenbanknamen aufgefordert.
	#? Funktionsverhalten:
	#   - Die Funktion gibt Aufforderungen aus, um den MariaDB-Benutzernamen, das Passwort und den Datenbanknamen einzugeben.
	#   - Führt eine SHOW EVENTS-Abfrage durch, um die geplanten Ereignisse der angegebenen Datenbank abzurufen.
	#   - Gibt die Ergebnisse der Abfrage aus, die die geplanten Ereignisse der Datenbank anzeigen.
	#? Beispielaufruf:
	#   Die Funktion wird direkt vom Benutzer aufgerufen, um die geplanten Ereignisse einer bestimmten Datenbank anzuzeigen.
	#   Beispiel: show_database_events
	#? Rückgabewert:
	#   - Es gibt keinen expliziten Rückgabewert. Die Funktion gibt die Ergebnisse der SHOW EVENTS-Abfrage aus, die die geplanten Ereignisse der Datenbank anzeigen.
	#? Hinweise:
	#   - Stellen Sie sicher, dass die erforderlichen MariaDB-Anmeldeinformationen und der Datenbankname korrekt eingegeben werden.
##
function show_database_events() {
    echo -n "Show Database Events. Enter MariaDB username: "
    read -r db_user
    echo "Enter MariaDB password: "
    read -r db_password
    echo    # newline
    echo -n "Enter MariaDB database name: "
    read -r db_name

    # Ausführen der SHOW EVENTS-Abfrage
    result=$(mysql -u "${db_user}" -p"${db_password}" -e "SHOW EVENTS FROM ${db_name};")

    # Anzeigen der Ergebnisse
    echo "Database Events for ${db_name}:"
    echo "${result}"
}

## * check_database_consistency
	# Datum: 13.11.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht es dem Benutzer, die Konsistenz einer bestimmten Datenbank in MariaDB zu überprüfen.
	# Der Benutzer wird aufgefordert, den MariaDB-Benutzernamen, das Passwort und den Datenbanknamen einzugeben.
	# Die Funktion führt dann eine CHECK TABLE-Abfrage für alle Tabellen in der angegebenen Datenbank durch, um die Konsistenz zu überprüfen.
	#? Parameter:
	#   - Keine festen Parameter; Benutzer wird zur Eingabe von MariaDB-Benutzernamen, Passwort und Datenbanknamen aufgefordert.
	#? Funktionsverhalten:
	#   - Die Funktion gibt Aufforderungen aus, um den MariaDB-Benutzernamen, das Passwort und den Datenbanknamen einzugeben.
	#   - Führt eine CHECK TABLE-Abfrage für alle Tabellen in der angegebenen Datenbank durch, um die Konsistenz zu überprüfen.
	#   - Gibt die Ergebnisse der Abfrage aus, die den Konsistenzstatus der Tabellen in der Datenbank anzeigen.
	#? Beispielaufruf:
	#   Die Funktion wird direkt vom Benutzer aufgerufen, um die Konsistenz einer bestimmten Datenbank zu überprüfen.
	#   Beispiel: check_database_consistency
	#? Rückgabewert:
	#   - Es gibt keinen expliziten Rückgabewert. Die Funktion gibt die Ergebnisse der CHECK TABLE-Abfrage aus, die den Konsistenzstatus der Tabellen in der Datenbank anzeigen.
	#? Hinweise:
	#   - Stellen Sie sicher, dass die erforderlichen MariaDB-Anmeldeinformationen und der Datenbankname korrekt eingegeben werden.
##
function check_database_consistency() {
    echo -n "Check Database Consistency. Enter MariaDB username: "
    read -r db_user
    echo "Enter MariaDB password: "
    read -r db_password
    echo    # newline
    echo -n "Enter MariaDB database name: "
    read -r db_name

    # Ausführen der CHECK TABLE-Abfrage für alle Tabellen
    result=$(mysqlcheck -u "${db_user}" -p"${db_password}" --check --databases "${db_name}")

    # Anzeigen der Ergebnisse
    echo "Database Consistency Check for ${db_name}:"
    echo "${result}"
}

## * backup_database
	# Datum: 13.11.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht es dem Benutzer, eine Sicherung einer bestimmten Datenbank in MariaDB zu erstellen.
	# Der Benutzer wird aufgefordert, den MariaDB-Benutzernamen, das Passwort, den Datenbanknamen und den gewünschten Namen für die Backup-Datei (ohne Erweiterung) einzugeben.
	# Die Funktion führt dann eine mysqldump-Abfrage für die angegebene Datenbank durch und speichert das Backup in einer SQL-Datei mit dem angegebenen Namen.
	#? Parameter:
	#   - Keine festen Parameter; Benutzer wird zur Eingabe von MariaDB-Benutzernamen, Passwort, Datenbanknamen und Backup-Dateinamen aufgefordert.
	#? Funktionsverhalten:
	#   - Die Funktion gibt Aufforderungen aus, um den MariaDB-Benutzernamen, das Passwort, den Datenbanknamen und den gewünschten Namen für die Backup-Datei einzugeben.
	#   - Führt eine mysqldump-Abfrage für die angegebene Datenbank durch und speichert das Backup in einer SQL-Datei.
	#   - Gibt eine Erfolgsmeldung aus, wenn das Backup erfolgreich erstellt wurde.
	#? Beispielaufruf:
	#   Die Funktion wird direkt vom Benutzer aufgerufen, um eine Sicherung einer bestimmten Datenbank zu erstellen.
	#   Beispiel: backup_database
	#? Rückgabewert:
	#   - Es gibt keinen expliziten Rückgabewert. Die Funktion gibt eine Erfolgsmeldung aus, wenn das Backup erfolgreich erstellt wurde.
	#? Hinweise:
	#   - Stellen Sie sicher, dass die erforderlichen MariaDB-Anmeldeinformationen, der Datenbankname und der gewünschte Dateiname für das Backup korrekt eingegeben werden.
##
function backup_database() {
    echo -n "Backup Database. Enter MariaDB username: "
    read -r db_user
    echo "Enter MariaDB password: "
    read -r db_password
    echo    # newline
    echo -n "Enter MariaDB database name: "
    read -r db_name
    echo -n "Enter backup file name (without extension): "
    read -r backup_file

    # Ausführen der mysqldump-Abfrage für die Sicherung
    mysqldump -u "${db_user}" -p"${db_password}" "${db_name}" > "${backup_file}.sql"

    echo "Database backed up successfully to ${backup_file}.sql"
}

## * restore_database
	# Datum: 13.11.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht es dem Benutzer, eine zuvor gesicherte Datenbank in MariaDB wiederherzustellen.
	# Der Benutzer wird aufgefordert, den MariaDB-Benutzernamen, das Passwort, den Datenbanknamen und den Dateinamen der Backup-Datei (mit .sql-Erweiterung) einzugeben.
	# Die Funktion führt dann eine mysql-Abfrage durch, um die Datenbank aus der angegebenen Backup-Datei wiederherzustellen.
	#? Parameter:
	#   - Keine festen Parameter; Benutzer wird zur Eingabe von MariaDB-Benutzernamen, Passwort, Datenbanknamen und Backup-Dateinamen aufgefordert.
	#? Funktionsverhalten:
	#   - Die Funktion gibt Aufforderungen aus, um den MariaDB-Benutzernamen, das Passwort, den Datenbanknamen und den Dateinamen der Backup-Datei einzugeben.
	#   - Führt eine mysql-Abfrage durch, um die Datenbank aus der Backup-Datei wiederherzustellen.
	#   - Gibt eine Erfolgsmeldung aus, wenn die Datenbank erfolgreich wiederhergestellt wurde.
	#? Beispielaufruf:
	#   Die Funktion wird direkt vom Benutzer aufgerufen, um eine zuvor gesicherte Datenbank wiederherzustellen.
	#   Beispiel: restore_database
	#? Rückgabewert:
	#   - Es gibt keinen expliziten Rückgabewert. Die Funktion gibt eine Erfolgsmeldung aus, wenn die Datenbank erfolgreich wiederhergestellt wurde.
	#? Hinweise:
	#   - Stellen Sie sicher, dass die erforderlichen MariaDB-Anmeldeinformationen, der Datenbankname und der korrekte Dateiname der Backup-Datei angegeben werden.
##
function restore_database() {
    echo -n "Restore Database. Enter MariaDB username: "
    read -r db_user
    echo "Enter MariaDB password: "
    read -r db_password
    echo    # newline
    echo -n "Enter MariaDB database name: "
    read -r db_name
    echo -n "Enter backup file name (with .sql extension): "
    read -r backup_file

    # Ausführen der mysql-Abfrage für die Wiederherstellung
    mysql -u "${db_user}" -p"${db_password}" "${db_name}" < "${backup_file}"

    echo "Database restored successfully from ${backup_file}"
}

## * show_database_users
	# Datum: 13.11.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht es dem Benutzer, alle Benutzer in einer bestimmten MariaDB-Datenbank anzuzeigen.
	# Der Benutzer wird aufgefordert, den MariaDB-Benutzernamen, das Passwort und den Datenbanknamen einzugeben.
	# Die Funktion führt dann eine SHOW USERS-Abfrage durch und gibt die Liste der Benutzer in der angegebenen Datenbank aus.
	#? Parameter:
	#   - Keine festen Parameter; Benutzer wird zur Eingabe von MariaDB-Benutzernamen, Passwort und Datenbanknamen aufgefordert.
	#? Funktionsverhalten:
	#   - Die Funktion gibt Aufforderungen aus, um den MariaDB-Benutzernamen, das Passwort und den Datenbanknamen einzugeben.
	#   - Führt eine SHOW USERS-Abfrage durch, um alle Benutzer in der angegebenen Datenbank anzuzeigen.
	#   - Gibt die Liste der Benutzer in der Datenbank aus.
	#? Beispielaufruf:
	#   Die Funktion wird direkt vom Benutzer aufgerufen, um alle Benutzer in einer bestimmten MariaDB-Datenbank anzuzeigen.
	#   Beispiel: show_database_users
	#? Rückgabewert:
	#   - Es gibt keinen expliziten Rückgabewert. Die Funktion gibt die Liste der Benutzer in der Datenbank aus.
	#? Hinweise:
	#   - Stellen Sie sicher, dass die erforderlichen MariaDB-Anmeldeinformationen und der Datenbankname angegeben werden.
##
function show_database_users() {
    echo -n "Show Database Users. Enter MariaDB username: "
    read -r db_user
    echo "Enter MariaDB password: "
    read -r db_password
    echo    # newline
    echo -n "Enter MariaDB database name: "
    read -r db_name

    # Ausführen der SHOW USERS-Abfrage
    result=$(mysql -u "${db_user}" -p"${db_password}" "${db_name}" -e "SELECT user FROM mysql.user;")

    # Anzeigen der Ergebnisse
    echo "Database Users:"
    echo "${result}"
}

## * check_user_privileges
	# Datum: 13.11.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht es dem Benutzer, die Berechtigungen eines bestimmten Benutzers in einer MariaDB-Datenbank zu überprüfen.
	# Der Benutzer wird aufgefordert, den MariaDB-Benutzernamen, das Passwort, den Datenbanknamen und den Benutzernamen für die Berechtigungsüberprüfung einzugeben.
	# Die Funktion führt dann eine SHOW GRANTS-Abfrage für den angegebenen Benutzer in der angegebenen Datenbank durch und gibt die Berechtigungen aus.
	#? Parameter:
	#   - Keine festen Parameter; Benutzer wird zur Eingabe von MariaDB-Benutzernamen, Passwort, Datenbanknamen und Benutzername für die Berechtigungsüberprüfung aufgefordert.
	#? Funktionsverhalten:
	#   - Die Funktion gibt Aufforderungen aus, um den MariaDB-Benutzernamen, das Passwort, den Datenbanknamen und den Benutzernamen für die Berechtigungsüberprüfung einzugeben.
	#   - Führt eine SHOW GRANTS-Abfrage für den angegebenen Benutzer in der angegebenen Datenbank durch.
	#   - Gibt die Berechtigungen des Benutzers aus.
	#? Beispielaufruf:
	#   Die Funktion wird direkt vom Benutzer aufgerufen, um die Berechtigungen eines bestimmten Benutzers in einer MariaDB-Datenbank zu überprüfen.
	#   Beispiel: check_user_privileges
	#? Rückgabewert:
	#   - Es gibt keinen expliziten Rückgabewert. Die Funktion gibt die Berechtigungen des angegebenen Benutzers aus.
	#? Hinweise:
	#   - Stellen Sie sicher, dass die erforderlichen MariaDB-Anmeldeinformationen, der Datenbankname und der Benutzername für die Berechtigungsüberprüfung angegeben werden.
##
function check_user_privileges() {
    echo -n "Check User Privileges. Enter MariaDB username: "
    read -r db_user
    echo "Enter MariaDB password: "
    read -r db_password
    echo    # newline
    echo -n "Enter MariaDB database name: "
    read -r db_name
    echo -n "Enter username to check privileges: "
    read -r check_user

    # Ausführen der SHOW GRANTS-Abfrage für den bestimmten Benutzer
    result=$(mysql -u "${db_user}" -p"${db_password}" "${db_name}" -e "SHOW GRANTS FOR '${check_user}'@'%';")

    # Anzeigen der Ergebnisse
    echo "Privileges for ${check_user}:"
    echo "${result}"
}

## * change_user_password
	# Datum: 13.11.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht es dem Benutzer, das Passwort für einen bestimmten MariaDB-Benutzer zu ändern.
	# Der Benutzer wird aufgefordert, den MariaDB-Benutzernamen, das Passwort, den Benutzernamen des zu ändernden Benutzers und das neue Passwort einzugeben.
	# Die Funktion führt dann eine SET PASSWORD-Abfrage durch, um das Passwort des angegebenen Benutzers zu ändern.
	#? Parameter:
	#   - Keine festen Parameter; Benutzer wird zur Eingabe von MariaDB-Benutzernamen, Passwort, Benutzernamen des zu ändernden Benutzers und neuem Passwort aufgefordert.
	#? Funktionsverhalten:
	#   - Die Funktion gibt Aufforderungen aus, um den MariaDB-Benutzernamen, das Passwort, den Benutzernamen des zu ändernden Benutzers und das neue Passwort einzugeben.
	#   - Führt eine SET PASSWORD-Abfrage durch, um das Passwort des angegebenen Benutzers zu ändern.
	#   - Gibt eine Bestätigung aus, dass das Passwort erfolgreich geändert wurde.
	#? Beispielaufruf:
	#   Die Funktion wird direkt vom Benutzer aufgerufen, um das Passwort eines bestimmten Benutzers in MariaDB zu ändern.
	#   Beispiel: change_user_password
	#? Rückgabewert:
	#   - Es gibt keinen expliziten Rückgabewert. Die Funktion gibt eine Bestätigung aus, dass das Passwort erfolgreich geändert wurde.
	#? Hinweise:
	#   - Stellen Sie sicher, dass die erforderlichen MariaDB-Anmeldeinformationen, der Benutzername des zu ändernden Benutzers und das neue Passwort angegeben werden.
##
function change_user_password() {
    echo -n "Change User Password. Enter MariaDB username: "
    read -r db_user
    echo "Enter MariaDB password: "
    read -r db_password
    echo    # newline
    echo -n "Enter username to change password: "
    read -r change_user
    echo -n "Enter new password: "
    read -s -r new_password

    # Ausführen der SET PASSWORD-Abfrage
    mysql -u "${db_user}" -p"${db_password}" -e "SET PASSWORD FOR '${change_user}'@'%' = PASSWORD('${new_password}');"

    echo "Password for ${change_user} changed successfully."
}

## * check_error_logs
	# Datum: 13.11.2023
	#? Beschreibung:
	# Diese Funktion ermöglicht es dem Benutzer, die MySQL-Fehlerprotokolle zu überprüfen. Sie öffnet das Fehlerprotokoll in einem Texteditor (hier nano) und gibt dem Benutzer die Möglichkeit, das Protokoll zu inspizieren.
	#? Parameter:
	#   - Keine festen Parameter.
	#? Funktionsverhalten:
	#   - Öffnet das MySQL-Fehlerprotokoll in einem Texteditor (hier nano).
	#   - Der Benutzer kann das Protokoll überprüfen und bei Bedarf nach relevanten Informationen suchen.
	#? Beispielaufruf:
	#   Die Funktion wird direkt vom Benutzer aufgerufen, um das MySQL-Fehlerprotokoll zu überprüfen.
	#   Beispiel: check_error_logs
	#? Rückgabewert:
	#   - Es gibt keinen expliziten Rückgabewert. Die Funktion öffnet das Fehlerprotokoll im Texteditor und ermöglicht dem Benutzer, es zu überprüfen.
	#? Hinweise:
	#   - Stellen Sie sicher, dass der Benutzer über die erforderlichen Berechtigungen verfügt, um auf das Fehlerprotokoll zuzugreifen.
##
function check_error_logs() {
    sudo nano /var/log/mysql/error.log
}

#───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
#────────────────────────────────────────────────────────────────────────────────────────── MariaDB Spielwiese Playground ENDE ─────────────────────────────────────────────────────────────────────────────────────
#───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

## *  conf_write
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion ändert eine bestimmte Konfigurationseinstellung in einer Datei, indem sie den Wert von `CONF_SEARCH` durch `CONF_ERSATZ` ersetzt.
	#? Parameter:
	#   - $1: Der Name der Konfigurationseinstellung, die geändert werden soll (z.B., "CONF_VARIABLE").
	#   - $2: Der neue Wert, durch den die Konfigurationseinstellung ersetzt werden soll.
	#   - $3: Der Pfad zum Verzeichnis, in dem die Datei liegt (z.B., "/etc").
	#   - $4: Der Name der Datei, in der die Konfigurationseinstellung geändert werden soll.
	#? Funktionsverhalten:
	#   - Die Funktion verwendet das `sed`-Kommando, um die Konfigurationseinstellung in der angegebenen Datei zu ändern.
	#   - Der Wert von `CONF_SEARCH` wird in der Datei gesucht und durch `CONF_ERSATZ` ersetzt.
	#? Beispielaufruf:
	#   Die Funktion kann direkt vom Benutzer aufgerufen werden und erfordert vier Parameter: die Konfigurationseinstellung, den neuen Wert, den Pfad zum Verzeichnis und den Dateinamen.
	#   Beispiel: conf_write "CONF_VARIABLE" "new_value" "/etc" "config.conf"
	#? Rückgabewert:
	# Diese Funktion gibt keine explizite Rückgabe aus, sondern ändert den Wert der Konfigurationseinstellung in der angegebenen Datei.
	#? Hinweise:
	#   - Stellen Sie sicher, dass die angegebene Datei im angegebenen Verzeichnis vorhanden ist.
	#   - Beachten Sie, dass diese Funktion die Datei direkt ändert. Stellen Sie sicher, dass Sie eine Sicherungskopie der Datei haben, falls Sie versehentlich Änderungen vornehmen.
##
function conf_write() {
	CONF_SEARCH=$1
	CONF_ERSATZ=$2
	CONF_PFAD=$3
	CONF_DATEINAME=$4
	sed -i 's/'"$CONF_SEARCH"' =.*$/'"$CONF_SEARCH"' = '"$CONF_ERSATZ"'/' /"$CONF_PFAD"/"$CONF_DATEINAME"
	log info "Einstellung $CONF_SEARCH auf Parameter $CONF_ERSATZ geaendert in Datei /$CONF_PFAD/$CONF_DATEINAME"
	return 0
}

## *  conf_read
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion sucht nach einer bestimmten Konfigurationseinstellung in einer Datei und gibt die Zeile aus, die die Einstellung enthält, zurück.
	#? Parameter:
	#   - $1: Der Name der Konfigurationseinstellung, die gesucht werden soll (z.B., "CONF_VARIABLE").
	#   - $2: Der Pfad zum Verzeichnis, in dem die Datei liegt (z.B., "/etc").
	#   - $3: Der Name der Datei, in der die Konfigurationseinstellung gesucht werden soll.
	#? Funktionsverhalten:
	#   - Die Funktion verwendet das `sed`-Kommando mit der Option `-n`, um nur die Zeilen auszugeben, die die gesuchte Konfigurationseinstellung enthalten.
	#   - Die gefundene Zeile wird auf dem Bildschirm ausgegeben.
	#? Beispielaufruf:
	#   Die Funktion kann direkt vom Benutzer aufgerufen werden und erfordert drei Parameter: die Konfigurationseinstellung, den Pfad zum Verzeichnis und den Dateinamen.
	#   Beispiel: conf_read "CONF_VARIABLE" "/etc" "config.conf"
	#? Rückgabewert:
	# Diese Funktion gibt die Zeile aus der Datei zurück, die die gesuchte Konfigurationseinstellung enthält.
	# Wenn die Konfigurationseinstellung nicht gefunden wird, wird nichts zurückgegeben.
	#? Hinweise:
	#   - Stellen Sie sicher, dass die angegebene Datei im angegebenen Verzeichnis vorhanden ist.
##
function conf_read() {
	CONF_SEARCH=$1
	CONF_PFAD=$2
	CONF_DATEINAME=$3
	sed -n -e '/'"$CONF_SEARCH"'/p' /"$CONF_PFAD"/"$CONF_DATEINAME"
	log info "Einstellung $CONF_SEARCH suchen in Datei /$CONF_PFAD/$CONF_DATEINAME"
	return 0
}

## *  conf_delete
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion löscht eine bestimmte Konfigurationseinstellung aus einer Datei, indem sie die Zeile, die die Einstellung enthält, entfernt.
	#? Parameter:
	#   - $1: Der Name der Konfigurationseinstellung, die gelöscht werden soll (z.B., "CONF_VARIABLE").
	#   - $2: Der Pfad zum Verzeichnis, in dem die Datei liegt (z.B., "/etc").
	#   - $3: Der Name der Datei, aus der die Konfigurationseinstellung gelöscht werden soll.
	#? Funktionsverhalten:
	#   - Die Funktion verwendet das `sed`-Kommando, um die Zeile mit der gesuchten Konfigurationseinstellung zu löschen.
	#   - Die Funktion überschreibt die Datei, um die Änderungen zu speichern.
	#? Beispielaufruf:
	#   Die Funktion kann direkt vom Benutzer aufgerufen werden und erfordert drei Parameter: die Konfigurationseinstellung, den Pfad zum Verzeichnis und den Dateinamen.
	#   Beispiel: conf_delete "CONF_VARIABLE" "/etc" "config.conf"
	#? Rückgabewert:
	# Diese Funktion gibt keine Werte zurück, aber sie führt die Löschung der Konfigurationseinstellung in der Datei durch.
	# Wenn die Konfigurationseinstellung nicht gefunden wird, hat dies keine Auswirkungen auf die Datei.
	#? Hinweise:
	#   - Stellen Sie sicher, dass die angegebene Datei im angegebenen Verzeichnis vorhanden ist.
## 
function conf_delete() {
	CONF_SEARCH=$1
	CONF_PFAD=$2
	CONF_DATEINAME=$3
	sed -i 's/'"$CONF_SEARCH"' =.*$/''/' /"$CONF_PFAD"/"$CONF_DATEINAME"
	log info "Zeile $CONF_SEARCH geloescht in Datei /$CONF_PFAD/$CONF_DATEINAME"
	return 0
}

## *  ramspeicher
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion ermittelt die Größe des im System installierten RAM-Speichers und speichert das Ergebnis in der Variable RAMSPEICHER.
	#? Parameter:
	#   - Keine Parameter werden von dieser Funktion erwartet.
	#? Funktionsverhalten:
	#   - Die Funktion verwendet den Befehl "dmidecode" mit dem Parameter "--type 17", um Informationen über den RAM-Speicher auszulesen.
	#   - Die Ausgabe von "dmidecode" wird in eine temporäre Datei "/tmp/raminfo.inf" geschrieben.
	#   - Dann wird die Datei mit "awk" durchsucht, um die RAM-Größe zu extrahieren und in der Variable RAMSPEICHER zu speichern.
	#   - Nachdem die Größe ermittelt wurde, wird die temporäre Datei gelöscht.
	#? Beispielaufruf:
	#   Die Funktion kann direkt vom Benutzer aufgerufen werden. Sie erwartet keine Parameter.
	#   Beispiel: ramspeicher
	#? Rückgabewert:
	# Die Funktion speichert die ermittelte RAM-Größe in der Variable RAMSPEICHER. Der Wert kann später in Ihrem Skript verwendet werden.
	#? Hinweise:
	#   - Diese Funktion setzt voraus, dass das Befehlszeilenwerkzeug "dmidecode" auf Ihrem System verfügbar ist.
## 
function ramspeicher() {
	# RAM groesse auslesen
	dmidecode --type 17 >/tmp/raminfo.inf
	RAMSPEICHER=$(awk -F ":" '/Size/ {print $2}' /tmp/raminfo.inf)
	rm /tmp/raminfo.inf
	# Zeichen loeschen
	RAMSPEICHER="${RAMSPEICHER:1}"   # erstes Zeichen loeschen
	RAMSPEICHER="${RAMSPEICHER::-3}" # letzten 3 Zeichen loeschen
	return 0
}

## *  mysqleinstellen
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion passt die Konfiguration eines MySQL-Servers basierend auf dem verfügbaren RAM-Speicher und anderen Parametern an.
	#? Parameter:
	#   - Keine Parameter werden von dieser Funktion erwartet.
	#? Funktionsverhalten:
	#   - Die Funktion ruft zunächst die Funktion "ramspeicher()" auf, um die Größe des RAM-Speichers zu ermitteln.
	#   - Anschließend werden verschiedene MySQL-Konfigurationsparameter basierend auf dem verfügbaren RAM-Speicher und anderen Faktoren gesetzt.
	#   - Die generierte Konfiguration wird in die Datei "/tmp/mysqld.txt" geschrieben, damit der Benutzer sie in die MySQL-Konfigurationsdatei (/etc/mysql/mysql.conf.d/mysqld.cnf) einfügen kann.
	#   - Die Funktion gibt Hinweise und Anweisungen aus, damit der Benutzer die Konfigurationsdatei korrekt aktualisieren kann.
	#? Beispielaufruf:
	#   Die Funktion kann direkt vom Benutzer aufgerufen werden. Sie erwartet keine Parameter.
	#   Beispiel: mysqleinstellen
	#? Rückgabewert:
	#   - Die Funktion gibt keine expliziten Rückgabewerte zurück.
	#? Hinweise:
	#   - Diese Funktion setzt voraus, dass die Funktion "ramspeicher()" definiert ist und ordnungsgemäß funktioniert.
	#   - Die generierte MySQL-Konfiguration wird in die Datei "/tmp/mysqld.txt" geschrieben. Der Benutzer muss den Inhalt dieser Datei in die MySQL-Konfigurationsdatei (/etc/mysql/mysql.conf.d/mysqld.cnf) manuell einfügen und MySQL neu starten.
##
function mysqleinstellen() {
	# Ermitteln wie viel RAM Speicher der Server hat
	ramspeicher

	# Ich nehme hier einfach 25% des RAM Speichers weil OpenSim schon so speicherhungrig ist.
	mysqlspeicher=$((RAMSPEICHER / 4))
	logfilesize=512   # (128M – 2G muss nicht groesser als der Pufferpool sein) von 256 auf 512 erhoeht"
	iocapacitymax=400 # standardmaessig der doppelte Wert von innodb_io_capacity sonst 2000"
	iocapacity=200    # 100 Harddrive, 200 SSD"
	MEGABYTE="M"

	#Da bei SQL nicht zwischen Gross- und Kleinschreibung unterschieden wird, muessen bei Betriebssystemen,
	#bei denen zwischen Gross- und Kleinschreibung unterschieden wird, alle Tabellennamen in Kleinbuchstaben geschrieben werden.
	#Fuegen Sie die folgende Zeile hinzu:
	# echo "lower_case_table_names = 1" # testen

	#** Zeichensatz testen
	# echo "[client]"
	# echo "default-character-set=utf8mb4"
	# echo "[mysqld]"
	# echo "character-set-server=utf8mb4"

	echo "mySQL Konfiguration auf $mysqlspeicher$MEGABYTE Einstellen und neu starten"
	echo "*** Bitte den Inhalt der Datei /tmp/mysqld.txt in die Datei /etc/mysql/mysql.conf.d/mysqld.cnf einfuegen. ***"
	echo "$DATUM $(date +%H:%M:%S) MYSQLEINSTELLEN: mySQL Konfiguration auf $mysqlspeicher$MEGABYTE Einstellen und neu starten" >>"/$STARTVERZEICHNIS/$DATEIDATUM$logfilename.log"

	# Hier wird die config geschrieben es wird angehaengt
	{
		echo "#"
		echo "# Meine Einstellungen $mysqlspeicher"
		# echo "[client]"
		# echo "default-character-set=utf8mb4"
		# echo "[mysqld]"
		# echo "character-set-server=utf8mb4"
		# echo "lower_case_table_names = 1" # testen
		echo "innodb_buffer_pool_size = $mysqlspeicher$MEGABYTE  # (Hier sollte man etwa 50% des gesamten RAM nutzen) von 1G auf 2G erhoeht"
		echo "innodb_log_file_size = $logfilesize$MEGABYTE  # (128M – 2G muss nicht groesser als der Pufferpool sein) von 256 auf 512 erhoeht"
		echo "innodb_log_buffer_size = 256M # Normal 0 oder 1MB"
		echo "innodb_flush_log_at_trx_commit = 1  # (0/2 mehr Leistung, weniger Zuverlaessigkeit, 1 Standard)"
		echo "innodb_flush_method = O_DIRECT  # (Vermeidet doppelte Pufferung)"
		echo "sync_binlog = 0"
		echo "binlog_format=ROW  # oder MIXED"
		echo "innodb_autoinc_lock_mode = 2 # Notwendigkeit einer AUTO-INC-Sperre auf Tabellenebene wird beseitigt und die Leistung kann erhoeht werden."
		echo "innodb_io_capacity_max = $iocapacitymax"
		echo "innodb_io_capacity = $iocapacity"
		# Die naechsten Zeilen muessen ganz unten stehen.
		# echo "[mysqldump]"
		# echo "max_allowed_packet=2147483648"
		echo "# Meine Einstellungen $mysqlspeicher Ende"
		echo "#"
	} >>"/tmp/mysqld.txt" # lieber so damit die Leute mySQL nicht abschiessen.

	echo "*** Bitte den Inhalt der Datei /tmp/mysqld.txt in die Datei /etc/mysql/mysql.conf.d/mysqld.cnf einfuegen. ***"
	# /etc/mysql/mysql.conf.d/mysqld.cnf
	# /etc/mysql/my.cnf

	# MySQL neu starten
	#mysql_neustart
	return 0
}

## *  newregionini
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion erstellt eine Regionskonfigurationsdatei für einen Simulator.
	#? Parameter:
	#   - Keine Parameter werden von dieser Funktion erwartet.
	#? Funktionsverhalten:
	#   - Die Funktion ermittelt die aktuelle IP-Adresse über eine Suchadresse.
	#   - Der Benutzer wird nach verschiedenen Informationen für die Regionskonfigurationsdatei gefragt, wie Regionsname, Serveradresse, Ort im Grid usw.
	#   - Die Regionskonfigurationsdatei wird basierend auf den eingegebenen Informationen erstellt.
	#   - Der Benutzer kann angeben, für welchen Simulator die Konfigurationsdatei erstellt werden soll (optional).
	#   - Die erstellte Konfigurationsdatei wird in das entsprechende Verzeichnis geschrieben.
	#? Beispielaufruf:
	#   Die Funktion kann direkt vom Benutzer aufgerufen werden. Sie erwartet keine Parameter.
	#   Beispiel: newregionini
	#? Rückgabewert:
	#   - Die Funktion gibt keine expliziten Rückgabewerte zurück.
	#? Hinweise:
	#   - Die Funktion erwartet, dass der Befehl "wget" verfügbar ist, um die aktuelle IP-Adresse zu ermitteln.
	#   - Die erstellte Regionskonfigurationsdatei wird in das angegebene Verzeichnis geschrieben.
	#   - Der Benutzer muss die Funktion interaktiv ausführen und die erforderlichen Informationen eingeben.
	#   - Es ist ratsam, die Funktion zuerst in einer Testumgebung zu verwenden, um sicherzustellen, dass die erstellte Konfigurationsdatei korrekt ist.
##
function newregionini() {
	# Aktuelle IP ueber Suchadresse ermitteln und Ausfuehrungszeichen anhaengen.
	DNAAKTUELLEIP="$(wget -O - -q $SEARCHADRES)"

	# Wohin soll die Datei geschrieben werden 1.
    log rohtext "Fuer welchen Simulator moechten sie die Regionskonfigurationsdatei erstellen sim1, sim2, sim..."
    log rohtext "Enter fuer das Hauptverzeichnis."
    read -r simname

    log rohtext "Regionsname [Welcome]"
	read -r regionsname
	if [ -z "$regionsname" ]; then regionsname="Welcome"; fi

	log rohtext "Geben Sie ihre Server Adresse ein: (Beispiel meinserver.de oder 192.168.2.1) [$AKTUELLEIP]"
	read -r DNANAME
	if [ -z "$DNANAME" ]; then DNANAME=$DNAAKTUELLEIP; fi

	log rohtext "Ort im Grid X Y [4500,4500]"
	read -r STARTPUNKT
	if [ -z "$STARTPUNKT" ]; then STARTPUNKT="4500,4500"; fi

	log rohtext "Groesse der Region: 512"
	read -r groesseregion
	if [ -z "$groesseregion" ]; then groesseregion=512; fi

	log rohtext "InternalPort Beispiel: 9150"
	read -r INTERNALPORT
	if [ -z "$INTERNALPORT" ]; then INTERNALPORT=9150; fi

    # Wohin soll die Datei geschrieben werden 2.
    if [ -z "$simname" ] 
    then
        # /$STARTVERZEICHNIS/
        pfad="/$STARTVERZEICHNIS/$regionsname.ini"
    else
        # /$STARTVERZEICHNIS/sim1/bin/Regions
        pfad="/$STARTVERZEICHNIS/$simname/bin/Regions/$regionsname.ini"
    fi

	UUID=$(uuidgen)

	{
		echo '['$regionsname']'
		echo 'RegionUUID = '"$UUID"
		echo 'Location = '"$STARTPUNKT"
		echo 'SizeX = '"$groesseregion"
		echo 'SizeY = '"$groesseregion"
		echo 'SizeZ = '"$groesseregion"
		echo 'InternalAddress = 0.0.0.0'
		echo 'InternalPort = '"$INTERNALPORT"
		echo 'ResolveAddress = False'
        echo 'AllowAlternatePorts = False'
		echo 'ExternalHostName = '"$DNANAME"
		echo 'MaptileStaticUUID = '"$UUID"
        echo 'NonPhysicalPrimMax = '"$groesseregion"
        echo 'PhysicalPrimMax = 64'
        echo 'ClampPrimSize = false'
        echo 'NonPhysicalPrimMin = 0.001'
        echo 'PhysicalPrimMin = 0.01'
        echo ';LinksetPrims = 0'
        echo 'MaxPrims = 250000'
        echo 'MaxAgents = 50'
        echo ';MaxPrimsPerUser = -1'
		echo ';RegionType = Estate'
		echo ';MasterAvatarFirstName = Vorname'
		echo ';MasterAvatarLastName = Nachname'
		echo ';MasterAvatarSandboxPassword = Passwort'
	} > "$pfad"
	return 0
}

## *  constconfig
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion erstellt eine Konfigurationsdatei mit verschiedenen Parametern für eine Anwendung.
	#? Parameter:
	#   1. BASEHOSTNAME: Basis-Hostname (z. B. example.com oder 127.0.0.1)
	#   2. PRIVURL: Private URL (z. B. http://example.com oder http://127.0.0.1)
	#   3. MONEYPORT: Geld-Port (z. B. 8002)
	#   4. SIMULATORPORT: Simulator-Port (z. B. 9000)
	#   5. MYSQLDATABASE: MySQL-Datenbankname
	#   6. MYSQLUSER: MySQL-Benutzername
	#   7. MYSQLPASSWORD: MySQL-Passwort
	#   8. STARTREGION: Startregion
	#   9. SIMULATORGRIDNAME: Simulator Grid Name
	#   10. SIMULATORGRIDNICK: Simulator Grid Nick
	#   11. CONSTINI: Pfad zur Ausgabedatei der Konfiguration
	#? Funktionsverhalten:
	#   - Die Funktion erstellt eine Konfigurationsdatei mit den angegebenen Parametern und speichert sie unter dem angegebenen Dateinamen.
	#   - Die Konfigurationsdatei enthält verschiedene Sektionen und Parameter.
	#   - Die Werte der Parameter werden aus den übergebenen Argumenten genommen und in die Datei geschrieben.
	#? Beispielaufruf:
	#   constconfig "example.com" "http://example.com" "8002" "9000" "mydatabase" "myuser" "mypassword" "MyRegion" "MyGrid" "NickName" "/pfad/zur/ausgabedatei.ini"
	#? Rückgabewert:
	#   - Die Funktion gibt keine expliziten Rückgabewerte zurück.
	#? Hinweise:
	#   - Die Funktion erwartet 11 Parameter, die die verschiedenen Konfigurationswerte definieren.
	#   - Der Pfad zur Ausgabedatei der Konfiguration (CONSTINI) sollte vollständig angegeben werden, um die Datei korrekt zu speichern.
	#   - Die Funktion erstellt die Konfigurationsdatei mit den angegebenen Parametern. Stellen Sie sicher, dass die Parameter korrekt sind, bevor Sie die Funktion aufrufen.
##
function constconfig() {

    BASEHOSTNAME=$1
    PRIVURL=$2
    MONEYPORT=$3
    SIMULATORPORT=$4
    MYSQLDATABASE=$5
    MYSQLUSER=$6
    MYSQLPASSWORD=$7
    STARTREGION=$8
    SIMULATORGRIDNAME=$9
    SIMULATORGRIDNICK=${10}
    CONSTINI=${11}

    {
    echo '[Const]'
    echo ";# {BaseHostname} {} {BaseHostname} {example.com 127.0.0.1} 127.0.0.1"
    echo 'BaseHostname = "'"$BASEHOSTNAME"'"'
    echo " "
    echo ";# http://\${Const|BaseHostname}"
    echo "BaseURL = http://\${Const|BaseHostname}"
    echo " "
    echo ";# {PublicPort} {} {PublicPort} {8002 9000} 8002"
    echo 'PublicPort = "8002"'
    echo " "
    echo "; you can also have them on a diferent url / IP"
    echo ";# \${Const|BaseURL}"
    echo "PrivURL = \${Const|BaseURL}"
    echo " "
    echo ";grid default private port 8003, not used in standalone"
    echo ";# {PrivatePort} {} {PrivatePort} {8003} 8003"
    echo "; port to access private grid services."
    echo "; grids that run all their regions should deny access to this port"
    echo "; from outside their networks, using firewalls"
    echo 'PrivatePort = "8003"'
    echo " "
    echo ";# {MoneyPort} {} \${Const|BaseURL}:\${Const|MoneyPort}"
    echo 'MoneyPort = "8008"'
    echo " "
    echo ";# {SimulatorPort} {} {SimulatorPort} {\${Const|SimulatorPort}} \${Const|SimulatorPort}"
    echo 'SimulatorPort = "'"$SIMULATORPORT"'"'
    echo " "	
    echo "; If this is the robust configuration, the robust database is entered here."
    echo "; If this is the OpenSim configuration, the OpenSim database is entered here."
    echo " "
    echo "; The Database \${Const|MysqlDatabase}"
    echo 'MysqlDatabase = "'"$MYSQLDATABASE"'"'
    echo " "
    echo "; The User \${Const|MysqlUser}"
    echo 'MysqlUser = "'"$MYSQLUSER"'"'
    echo " "
    echo "; The Password \${Const|MysqlPassword}"
    echo 'MysqlPassword = "'"$MYSQLPASSWORD"'"'
    echo " "
    echo "; The Region Welcome \${Const|StartRegion}"
    echo 'StartRegion = "'"$STARTREGION"'"'
    echo " "
    echo ";# Grid name \${Const|Simulatorgridname}"
    echo 'Simulatorgridname = "'"$SIMULATORGRIDNAME"'"'
    echo " "
    echo "; The Simulator grid nick \${Const|Simulatorgridnick}"
    echo 'Simulatorgridnick = "'"$SIMULATORGRIDNICK"'"'
    echo " "
    echo " "
    } > "$CONSTINI"
}

## *  regionconfig
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion erstellt eine Konfigurationsdatei für eine Region mit verschiedenen Parametern.
	#? Parameter:
	#   1. REGIONSNAME: Name der Region
	#   2. STARTLOCATION: Startposition der Region (z. B. "1000,1000")
	#   3. SIZE: Größe der Region (Standard: 256)
	#   4. INTERNALPORT: Interner Port der Region (Standard: Zufallsport)
	#   5. REGIONSINI: Ausgabedatei der Region Konfiguration
	#? Funktionsverhalten:
	#   - Die Funktion erstellt eine Konfigurationsdatei für eine Region mit den angegebenen Parametern und speichert sie unter dem angegebenen Dateinamen.
	#   - Die Region erhält eine zufällige UUID.
	#   - Falls der Regionsname leer ist oder "zufall", wird ein zufälliger Name generiert.
	#   - Falls STARTLOCATION, SIZE oder INTERNALPORT nicht angegeben sind, werden Standardwerte verwendet.
	#? Beispielaufruf:
	#   regionconfig "MeineRegion" "1000,1000" "256" "9000" "MeineRegion.ini"
	#? Rückgabewert:
	#   - Die Funktion gibt keine expliziten Rückgabewerte zurück.
	#? Hinweise:
	#   - Die Funktion erwartet 5 Parameter, die die verschiedenen Konfigurationswerte für die Region definieren.
	#   - Der Pfad zur Ausgabedatei der Region Konfiguration (REGIONSINI) sollte vollständig angegeben werden, um die Datei korrekt zu speichern.
	#   - Die Funktion erstellt die Konfigurationsdatei mit den angegebenen Parametern. Stellen Sie sicher, dass die Parameter korrekt sind, bevor Sie die Funktion aufrufen.
##
function regionconfig() {
		
    REGIONSNAME=$1
    STARTLOCATION=$2
    SIZE=$3
    INTERNALPORT=$4
    REGIONSINI=$5
    
    UUID=$(uuidgen)

	# ist Regionsname leer dann Zufallsnamen nutzen.
	namen; ZUFALLSREGIONSNAME=$NEUERREGIONSNAME;
	if [ "$REGIONSNAME" = "zufall" ] || [ "$REGIONSNAME" = "" ]; then REGIONSNAME=$ZUFALLSREGIONSNAME; REGIONSINI="$REGIONSNAME.ini"; fi
	# Zufallszahl ermmiteln.
	RANDOMPOSITION=$((100 + $RANDOM % 200))
	if [ "$STARTLOCATION" = "" ]; then STARTLOCATION="$((2000 + $RANDOM % 8000)),$((2000 + $RANDOM % 8000))"; fi
	if [ "$SIZE" = "" ]; then SIZE=256; fi
	if [ "$INTERNALPORT" = "" ]; then INTERNALPORT="9$RANDOMPOSITION"; fi
	# AKTUELLEIP
	if [ "$BASEHOSTNAME" = "" ]; then BASEHOSTNAME="$AKTUELLEIP"; fi

    {
    echo "[$REGIONSNAME]"
    echo "RegionUUID = $UUID"
    echo "Location = $STARTLOCATION"
    echo "SizeX = $SIZE"
    echo "SizeY = $SIZE"
    echo "SizeZ = $SIZE"
    echo "InternalAddress = 0.0.0.0"
    echo "InternalPort = $INTERNALPORT"
    echo "ResolveAddress = False"
    echo "ExternalHostName = $BASEHOSTNAME"
    echo "MaptileStaticUUID = $UUID"
    echo "DefaultLanding = <128,128,25>"
    echo ";MaxPrimsPerUser = -1"
    echo ";ScopeID = $UUID"
    echo ";RegionType = Mainland"
    echo ";MapImageModule = Warp3DImageModule"
    echo ";TextureOnMapTile = true"
    echo ";DrawPrimOnMapTile = true"
    echo ";GenerateMaptiles = true"
    echo ";MaptileRefresh = 0"
    echo ";MaptileStaticFile = water-logo-info.png"
    echo ";MasterAvatarFirstName = John"
    echo ";MasterAvatarLastName = Doe"
    echo ";MasterAvatarSandboxPassword = passwd" 
    } > "$REGIONSINI"
}

## *  flotsamconfig
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion erstellt eine Konfigurationsdatei für den Asset-Cache (Flotsam-Cache) mit verschiedenen Parametern.
	#? Parameter:
	#   1. FLOTSAMCACHEINI: Ausgabedatei für die Cache-Konfiguration
	#? Funktionsverhalten:
	#   - Die Funktion erstellt eine Konfigurationsdatei für den Asset-Cache (Flotsam-Cache) mit den angegebenen Parametern und speichert sie unter dem angegebenen Dateinamen.
	#   - Die erstellte Konfigurationsdatei enthält verschiedene Cache-Parameter.
	#? Beispielaufruf:
	#   flotsamconfig "flotsamcache.ini"
	#? Rückgabewert:
	#   - Die Funktion gibt keine expliziten Rückgabewerte zurück.
	#? Hinweise:
	#   - Der Pfad zur Ausgabedatei der Cache-Konfiguration (FLOTSAMCACHEINI) sollte vollständig angegeben werden, um die Datei korrekt zu speichern.
	#   - Die Funktion erstellt die Konfigurationsdatei mit den angegebenen Parametern. Stellen Sie sicher, dass die Parameter korrekt sind, bevor Sie die Funktion aufrufen.
##
function flotsamconfig() {

    FLOTSAMCACHEINI=$1

    {
    echo "[AssetCache]"
    echo "CacheDirectory = ./assetcache"
    echo "LogLevel = 0"
    echo "HitRateDisplay = 100"
    echo "MemoryCacheEnabled = false"
    echo "UpdateFileTimeOnCacheHit = false"
    echo "NegativeCacheEnabled = true"
    echo "NegativeCacheTimeout = 120"
    echo "NegativeCacheSliding = false"
    echo "FileCacheEnabled = true"
    echo "MemoryCacheTimeout = .016 ; one minute"
    echo "FileCacheTimeout = 48"
    echo "FileCleanupTimer = \"24.0\""
    } > "$FLOTSAMCACHEINI"
}

## *  osslEnableconfig
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion erstellt eine Konfigurationsdatei für OpenSimulator (OSSL) mit erlaubten Funktionen und Bedingungen.
	#? Parameter:
	#   1. OSSLENABLEINI: Ausgabedatei für die OSSL-Konfiguration
	#? Funktionsverhalten:
	#   - Die Funktion erstellt eine Konfigurationsdatei für OpenSimulator (OSSL) mit den angegebenen erlaubten Funktionen und speichert sie unter dem angegebenen Dateinamen.
	#   - Die erstellte Konfigurationsdatei enthält verschiedene erlaubte Funktionen und Bedingungen für OSSL.
	#? Beispielaufruf:
	#   osslEnableconfig "ossl_enable.ini"
	#? Rückgabewert:
	#   - Die Funktion gibt keine expliziten Rückgabewerte zurück.
	#? Hinweise:
	#   - Der Pfad zur Ausgabedatei der OSSL-Konfiguration (OSSLENABLEINI) sollte vollständig angegeben werden, um die Datei korrekt zu speichern.
	#   - Die Funktion erstellt die Konfigurationsdatei mit den angegebenen erlaubten Funktionen und Bedingungen. Stellen Sie sicher, dass die Parameter korrekt sind, bevor Sie die Funktion aufrufen.
##
function osslEnableconfig() {

    OSSLENABLEINI=$1

    {
    echo "[OSSL]"
    echo "  AllowOSFunctions = true"
    echo "  AllowMODFunctions = true"
    echo "  AllowLightShareFunctions = true"
    echo "  PermissionErrorToOwner = true"
    echo "  OSFunctionThreatLevel = Moderate"
    echo '  osslParcelO = "PARCEL_OWNER,"'
    echo '  osslParcelOG = "PARCEL_GROUP_MEMBER,PARCEL_OWNER,"'
    echo "  osslNPC = \${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER"
    echo "     "
    echo "  Allow_osGetAgents =               \${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER"
    echo "  Allow_osGetAvatarList =           \${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER"
    echo "  Allow_osGetNPCList =              \${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER"
    echo "  Allow_osNpcGetOwner =             \${OSSL|osslNPC}"
    echo "  Allow_osSetSunParam =             ESTATE_MANAGER,ESTATE_OWNER"
    echo "  Allow_osTeleportOwner =           \${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER"
    echo "  Allow_osSetEstateSunSettings =    ESTATE_MANAGER,ESTATE_OWNER"
    echo "  Allow_osSetRegionSunSettings =    ESTATE_MANAGER,ESTATE_OWNER"
    echo "  Allow_osEjectFromGroup =          \${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER"
    echo "  Allow_osForceBreakAllLinks =      \${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER"
    echo "  Allow_osForceBreakLink =          \${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER"
    echo "  Allow_osGetWindParam =            true"
    echo "  Allow_osInviteToGroup =           \${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER"
    echo "  Allow_osReplaceString =           true"
    echo "  Allow_osSetDynamicTextureData =       \${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER"
    echo "  Allow_osSetDynamicTextureDataFace =   \${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER"
    echo "  Allow_osSetDynamicTextureDataBlend =  \${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER"
    echo "  Allow_osSetDynamicTextureDataBlendFace = \${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER"
    echo "  Allow_osSetParcelMediaURL =       \${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER"
    echo "  Allow_osSetParcelMusicURL =       \${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER"
    echo "  Allow_osSetParcelSIPAddress =     \${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER"
    echo "  Allow_osSetPrimFloatOnWater =     true"
    echo "  Allow_osSetWindParam =            \${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER"
    echo "  Allow_osTerrainFlush =            ESTATE_MANAGER,ESTATE_OWNER"
    echo "  Allow_osUnixTimeToTimestamp =     true"
    echo "  Allow_osAvatarName2Key =          \${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER"
    echo "  Allow_osFormatString =            true"
    echo "  Allow_osKey2Name =                \${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER"
    echo "  Allow_osListenRegex =             true"
    echo "  Allow_osLoadedCreationDate =      \${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER"
    echo "  Allow_osLoadedCreationID =        \${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER"
    echo "  Allow_osLoadedCreationTime =      \${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER"
    echo "  Allow_osMessageObject =           \${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER"
    echo "  Allow_osRegexIsMatch =            true"
    echo "  Allow_osGetAvatarHomeURI =        \${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER"
    echo "  Allow_osNpcSetProfileAbout =      \${OSSL|osslNPC}"
    echo "  Allow_osNpcSetProfileImage =      \${OSSL|osslNPC}"
    echo "  Allow_osDie =                     \${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER"
    echo "  Allow_osDetectedCountry =         \${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER"
    echo "  Allow_osDropAttachment =          \${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER"
    echo "  Allow_osDropAttachmentAt =        \${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER"
    echo "  Allow_osGetAgentCountry =         \${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER"
    echo "  Allow_osGetGridCustom =           \${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER"
    echo "  Allow_osGetGridGatekeeperURI =    \${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER"
    echo "  Allow_osGetGridHomeURI =          \${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER"
    echo "  Allow_osGetGridLoginURI =         \${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER"
    echo "  Allow_osGetGridName =             true"
    echo "  Allow_osGetGridNick =             true"
    echo "  Allow_osGetNumberOfAttachments =  \${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER"
    echo "  Allow_osGetRegionStats =          \${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER"
    echo "  Allow_osGetSimulatorMemory =      \${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER"
    echo "  Allow_osGetSimulatorMemoryKB =    \${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER"
    echo "  Allow_osMessageAttachments =      \${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER"
    echo "  Allow_osReplaceAgentEnvironment = \${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER"
    echo "  Allow_osSetSpeed =                \${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER"
    echo "  Allow_osSetOwnerSpeed =           \${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER"
    echo "  Allow_osRequestURL =              \${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER"
    echo "  Allow_osRequestSecureURL =        \${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER"
    echo "  Allow_osCauseDamage =             \${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER"
    echo "  Allow_osCauseHealing =            \${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER"
    echo "  Allow_osSetHealth =               \${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER"
    echo "  Allow_osSetHealRate =             \${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER"
    echo "  Allow_osForceAttachToAvatar =     \${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER"
    echo "  Allow_osForceAttachToAvatarFromInventory = \${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER"
    echo "  Allow_osForceCreateLink =         \${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER"
    echo "  Allow_osForceDropAttachment =     \${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER"
    echo "  Allow_osForceDropAttachmentAt =   \${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER"
    echo "  Allow_osGetLinkPrimitiveParams =  \${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER"
    echo "  Allow_osGetPhysicsEngineType =    true"
    echo "  Allow_osGetRegionMapTexture =     \${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER"
    echo "  Allow_osGetScriptEngineName =     true"
    echo "  Allow_osGetSimulatorVersion =     true"
    echo "  Allow_osMakeNotecard =            \${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER"
    echo "  Allow_osMatchString =             true"
    echo "  Allow_osNpcCreate =               \${OSSL|osslNPC}"
    echo "  Allow_osNpcGetPos =               \${OSSL|osslNPC}"
    echo "  Allow_osNpcGetRot =               \${OSSL|osslNPC}"
    echo "  Allow_osNpcLoadAppearance =       \${OSSL|osslNPC}"
    echo "  Allow_osNpcMoveTo =               \${OSSL|osslNPC}"
    echo "  Allow_osNpcMoveToTarget =         \${OSSL|osslNPC}"
    echo "  Allow_osNpcPlayAnimation =        \${OSSL|osslNPC}"
    echo "  Allow_osNpcRemove =               \${OSSL|osslNPC}"
    echo "  Allow_osNpcSaveAppearance =       \${OSSL|osslNPC}"
    echo "  Allow_osNpcSay =                  \${OSSL|osslNPC}"
    echo "  Allow_osNpcSayTo =                \${OSSL|osslNPC}"
    echo "  Allow_osNpcSetRot =               \${OSSL|osslNPC}"
    echo "  Allow_osNpcShout =                \${OSSL|osslNPC}"
    echo "  Allow_osNpcSit =                  \${OSSL|osslNPC}"
    echo "  Allow_osNpcStand =                \${OSSL|osslNPC}"
    echo "  Allow_osNpcStopAnimation =        \${OSSL|osslNPC}"
    echo "  Allow_osNpcStopMoveToTarget =     \${OSSL|osslNPC}"
    echo "  Allow_osNpcTouch =                \${OSSL|osslNPC}"
    echo "  Allow_osNpcWhisper =              \${OSSL|osslNPC}"
    echo "  Allow_osOwnerSaveAppearance =     \${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER"
    echo "  Allow_osParcelJoin =              ESTATE_MANAGER,ESTATE_OWNER"
    echo "  Allow_osParcelSubdivide =         ESTATE_MANAGER,ESTATE_OWNER"
    echo "  Allow_osRegionRestart =           ESTATE_MANAGER,ESTATE_OWNER"
    echo "  Allow_osRegionNotice =            ESTATE_MANAGER,ESTATE_OWNER"
    echo "  Allow_osSetProjectionParams =     \${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER"
    echo "  Allow_osSetRegionWaterHeight =    ESTATE_MANAGER,ESTATE_OWNER"
    echo "  Allow_osSetTerrainHeight =        ESTATE_MANAGER,ESTATE_OWNER"
    echo "  Allow_osSetTerrainTexture =       ESTATE_MANAGER,ESTATE_OWNER"
    echo "  Allow_osSetTerrainTextureHeight = ESTATE_MANAGER,ESTATE_OWNER"
    echo "  Allow_osAgentSaveAppearance =     ESTATE_MANAGER,ESTATE_OWNER"
    echo "  Allow_osAvatarPlayAnimation =     \${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER"
    echo "  Allow_osAvatarStopAnimation =     \${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER"
    echo "  Allow_osForceAttachToOtherAvatarFromInventory = \${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER"
    echo "  Allow_osForceDetachFromAvatar =   \${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER"
    echo "  Allow_osForceOtherSit =           \${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER"
    echo "  Allow_osGetNotecard =             \${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER"
    echo "  Allow_osGetNotecardLine =         \${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER"
    echo "  Allow_osGetNumberOfNotecardLines = \${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER"
    echo "  Allow_osSetDynamicTextureURL =    ESTATE_MANAGER,ESTATE_OWNER"
    echo "  Allow_osSetDynamicTextureURLBlend = ESTATE_MANAGER,ESTATE_OWNER"
    echo "  Allow_osSetDynamicTextureURLBlendFace = ESTATE_MANAGER,ESTATE_OWNER"
    echo "  Allow_osSetRot  =                 \${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER"
    } > "$OSSLENABLEINI"
}

## *  moneyconfig
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion erstellt eine Konfigurationsdatei für Geldtransaktionen in OpenSimulator.
	#? Parameter:
	#   1. MONEYINI: Ausgabedatei für die Money-Konfiguration
	#? Funktionsverhalten:
	#   - Die Funktion erstellt eine Konfigurationsdatei für Geldtransaktionen in OpenSimulator und speichert sie unter dem angegebenen Dateinamen.
	#   - Die erstellte Konfigurationsdatei enthält Einstellungen für die MySQL-Datenbankverbindung, MoneyServer-Optionen und BalanceMessage-Nachrichten.
	#? Beispielaufruf:
	#   moneyconfig "money_config.ini"
	#? Rückgabewert:
	#   - Die Funktion gibt keine expliziten Rückgabewerte zurück.
	#? Hinweise:
	#   - Der Pfad zur Ausgabedatei der Money-Konfiguration (MONEYINI) sollte vollständig angegeben werden, um die Datei korrekt zu speichern.
	#   - Stellen Sie sicher, dass die MySQL-Datenbankparameter (hostname, database, username, password) korrekt sind, bevor Sie die Funktion aufrufen.
	#   - Sie können die BalanceMessage-Nachrichten anpassen, indem Sie die entsprechenden Zeilen bearbeiten.
	#   - Überprüfen Sie alle Parameter und Optionen sorgfältig, bevor Sie die Funktion aufrufen.
##
function moneyconfig() {

    MONEYINI=$1

    {
    echo "[Startup]"
    echo "[MySql]"
    echo 'hostname = "localhost"'
    echo 'database = "'"$MYSQLDATABASE"'"'
    echo 'username = "'"$MYSQLUSER"'"'
    echo 'password = "'"$MYSQLPASSWORD"'"'
    echo 'pooling  = "true"'
    echo 'port = "3306"'
    echo 'MaxConnection = "40"'
    echo "[MoneyServer]"
    echo 'ServerPort = "8008"'
    echo 'DefaultBalance = "1000"'
    echo 'EnableAmountZero = "true"'
    echo 'BankerAvatar = "00000000-0000-0000-0000-000000000000"'
    echo 'EnableForceTransfer = "true"'
    echo 'EnableScriptSendMoney = "true"'
    echo 'MoneyScriptAccessKey  = "123456789"'
    echo 'MoneyScriptIPaddress  = "'"$BASEHOSTNAME"'"'
    echo 'EnableHGAvatar = "true"'
    echo 'EnableGuestAvatar = "true"'
    echo 'HGAvatarDefaultBalance = "1000"'
    echo 'GuestAvatarDefaultBalance = "1000"'
    #shellcheck disable=SC2016
    echo 'BalanceMessageSendGift     = "Sent Gift L${0} to {1}."'
    #shellcheck disable=SC2016
    echo 'BalanceMessageReceiveGift  = "Received Gift L${0} from {1}."'
    #shellcheck disable=SC2016
    echo 'BalanceMessagePayCharge    = "Paid the Money L${0} for creation."'
    #shellcheck disable=SC2016
    echo 'BalanceMessageBuyObject    = "Bought the Object {2} from {1} by L${0}."'
    #shellcheck disable=SC2016
    echo 'BalanceMessageSellObject   = "{1} bought the Object {2} by L${0}."'
    #shellcheck disable=SC2016
    echo 'BalanceMessageLandSale     = "Paid the Money L${0} for Land."'
    #shellcheck disable=SC2016
    echo 'BalanceMessageScvLandSale  = "Paid the Money L${0} for Land."'
    #shellcheck disable=SC2016
    echo 'BalanceMessageGetMoney     = "Got the Money L${0} from {1}."'
    #shellcheck disable=SC2016
    echo 'BalanceMessageBuyMoney     = "Bought the Money L${0}."'
    #shellcheck disable=SC2016
    echo 'BalanceMessageRollBack     = "RollBack the Transaction: L${0} from/to {1}."'
    #shellcheck disable=SC2016
    echo 'BalanceMessageSendMoney    = "Paid the Money L${0} to {1}."'
    #shellcheck disable=SC2016
    echo 'BalanceMessageReceiveMoney = "Received L${0} from {1}."'
    echo "[Certificate]"
    echo 'CheckServerCert = "false"'
    } > "$MONEYINI"
}

## *  osconfigstruktur
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion erstellt die Konfigurationsstruktur für OpenSimulator-Simulationen und erzeugt Konfigurationsdateien sowie Verzeichnisse für mehrere Simulatoren.
	#? Parameter:
	#   1. STARTVERZEICHNIS: Das Startverzeichnis, in dem die Simulatoren erstellt werden sollen.
	#   2. ANZAHL_SIMULATOREN: Die Anzahl der zu erstellenden Simulatoren.
	#? Funktionsverhalten:
	#   - Die Funktion erstellt die Konfigurationsstruktur für mehrere OpenSimulator-Simulatoren.
	#   - Sie erzeugt Konfigurationsdateien, Verzeichnisse und führt verschiedene Konfigurationsfunktionen aus.
	#   - Die Funktion verwendet vorherige Konfigurationsfunktionen wie `constconfig()`, `moneyconfig()`, `regionconfig()`, `flotsamconfig()` und `createdatabase()`.
	#? Beispielaufruf:
	#   osconfigstruktur "/pfad/zum/startverzeichnis" 5
	#? Rückgabewert:
	#   - Die Funktion gibt keinen expliziten Rückgabewert zurück.
	#? Hinweise:
	#   - Stellen Sie sicher, dass die Konfigurationsfunktionen (constconfig, moneyconfig, regionconfig, flotsamconfig, createdatabase) korrekte Parameter haben und ordnungsgemäß funktionieren.
	#   - Die Funktion verwendet Schleifen, um die Konfiguration für mehrere Simulatoren durchzuführen.
	#   - Überprüfen Sie alle Parameter und Optionen sorgfältig, bevor Sie die Funktion aufrufen.
##
function osconfigstruktur() {
    # Ist die /"$STARTVERZEICHNIS"/$SIMDATEI vorhanden dann zuerst löschen
    if [ ! -f "/$STARTVERZEICHNIS/$SIMDATEI" ]; then
        #rm /"$STARTVERZEICHNIS"/$SIMDATEI
        log rohtext "$SIMDATEI Datei ist noch nicht vorhanden"
    else
        log rohtext "Lösche vorhandene $SIMDATEI"
        rm /"$STARTVERZEICHNIS"/$SIMDATEI
    fi

    # Ist die Datei CONFIGPFAD="OpenSimConfig"
	if [ ! -f "/$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/" ]; then
		log rohtext "Lege robust an im Verzeichnis $ROBUSTVERZEICHNIS an"
		mkdir -p /"$STARTVERZEICHNIS"/$ROBUSTVERZEICHNIS/bin/config-include
        cp "$AKTUELLEVERZ"/$CONFIGPFAD/config-include/GridCommon.ini /"$STARTVERZEICHNIS"/$ROBUSTVERZEICHNIS/bin/config-include
        cp "$AKTUELLEVERZ"/$CONFIGPFAD/Robust.ini /"$STARTVERZEICHNIS"/$ROBUSTVERZEICHNIS/bin
        
        CONSTINI="/$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS/bin/config-include/Const.ini"
        constconfig "$BASEHOSTNAME" "$PRIVURL" "$MONEYPORT" "$SIMULATORPORT" "$CREATEROBUSTDATABASENAME" "$MYSQLUSER" "$MYSQLPASSWORD" "$STARTREGION" "$SIMULATORGRIDNAME" "$SIMULATORGRIDNICK" "$CONSTINI"

        moneyconfig "/$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS/bin/MoneyServer.ini"

	else
		log error "Verzeichnis $ROBUSTVERZEICHNIS existiert bereits"
	fi


	for ((i = 1; i <= $2; i++)); do
		log rohtext "Ich lege gerade sim$i an!"
		mkdir -p /"$STARTVERZEICHNIS"/sim"$i"/bin/config-include
        mkdir -p /"$STARTVERZEICHNIS"/sim"$i"/bin/Regions
        cp "$AKTUELLEVERZ"/$CONFIGPFAD/config-include/GridCommon.ini /"$STARTVERZEICHNIS"/sim"$i"/bin/config-include
        cp "$AKTUELLEVERZ"/$CONFIGPFAD/OpenSim.ini /"$STARTVERZEICHNIS"/sim"$i"/bin
        cd /"$STARTVERZEICHNIS"/sim"$i"/bin/config-include || exit # Beenden wenn Verzeichnis nicht vorhanden ist.
        CONSTINI="/$STARTVERZEICHNIS/sim$i/bin/config-include/Const.ini"
        ZWISCHENSPEICHERMSDB=$MYSQLDATABASE
        ZWISCHENSPEICHERSP=$SIMULATORPORT
        LOCALX=5000; LOCALY=5000; LANDGOESSE=256;

        constconfig "$BASEHOSTNAME" "$PRIVURL" "$MONEYPORT" "$((SIMULATORPORT + "$i"))" "$MYSQLDATABASE$i" "$MYSQLUSER" "$MYSQLPASSWORD" "$STARTREGION" "$SIMULATORGRIDNAME" "$SIMULATORGRIDNICK" "$CONSTINI"

        if [ "$SKRIPTAKTIV" = "nein" ]; then
        osslEnableconfig "/$STARTVERZEICHNIS/sim$i/bin/config-include/osslEnable.ini.Beispiel"
        fi

        if [ "$SKRIPTAKTIV" = "ja" ]; then
        osslEnableconfig "/$STARTVERZEICHNIS/sim$i/bin/config-include/osslEnable.ini"
        fi

        if [ "$REGIONAKTIV" = "nein" ]; then
		# Random Regionsname einbauen.
        regionconfig "sim$i" "$((LOCALX + "$i")),$((LOCALY + "$i"))" "$LANDGOESSE" "$((9100 + "$i"))" "/$STARTVERZEICHNIS/sim$i/bin/Regions/Regions.ini.Beispiel"
        fi

        if  [ "$REGIONAKTIV" = "ja" ]; then
        regionconfig "sim$i" "$((LOCALX + "$i")),$((LOCALY + "$i"))" "$LANDGOESSE" "$((9100 + "$i"))" "/$STARTVERZEICHNIS/sim$i/bin/Regions/Regions.ini"
        fi

		if  [ "$CREATEDATABASE" = "ja" ]; then
		createdatabase "$CREATEDATABASENAME$i" "$DBUSER" "$DBPASSWD"
		fi

        flotsamconfig "/$STARTVERZEICHNIS/sim$i/bin/config-include/FlotsamCache.ini"
		log rohtext "Schreibe sim$i in $SIMDATEI"
        #echo "Schreibe sim$i in $SIMDATEI, legen sie bitte Datenbank $MYSQLDATABASE an."
		# xargs sollte leerzeichen entfernen.
		printf 'sim'"$i"'\t%s\n' | xargs >>/"$STARTVERZEICHNIS"/$SIMDATEI
        MYSQLDATABASE=$ZWISCHENSPEICHERMSDB # Zuruecksetzen sonst wird falsch addiert.
        SIMULATORPORT=$ZWISCHENSPEICHERSP # Zuruecksetzen sonst wird falsch addiert.
        LOCALX=5000; LOCALY=5000; # Zuruecksetzen sonst wird falsch addiert.
        # Restliche Dateien kopieren
        
	done
    echo "*******************************************************************"
	return 0
}

## *  configabfrage
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion führt eine umfassende Abfrage durch, um Konfigurationsparameter für OpenSimulator-Simulationen einzustellen.
	#? Parameter: Keine
	#? Funktionsverhalten:
	#   - Die Funktion interagiert mit dem Benutzer, um Konfigurationsparameter abzufragen.
	#   - Sie verwendet vordefinierte Standardwerte, falls der Benutzer keine Eingabe macht.
	#   - Sie ruft die Funktion `osconfigstruktur()` auf, um die Konfigurationsstruktur zu erstellen.
	#? Beispielaufruf:
	#   configabfrage
	#? Rückgabewert: Die Funktion gibt keinen expliziten Rückgabewert zurück.
	#? Hinweise:
	#   - Die Funktion interagiert mit dem Benutzer, stellen Sie sicher, dass die Benutzereingabe validiert wird.
	#   - Stellen Sie sicher, dass alle Standardwerte und vordefinierten Parameter sinnvoll sind.
	#   - Überprüfen Sie die Aufrufe von `osconfigstruktur()` und die Reihenfolge der Konfigurationsabfragen.
	#   - Stellen Sie sicher, dass die Konfigurationsabfrage die erforderlichen Informationen für die OpenSimulator-Simulationen sammelt.
##
function configabfrage() {
	#** Eintragungen uebersicht!
	# BaseHostname = "MyGrid.com"
	# BaseURL = http://${Const|BaseHostname}
	# PublicPort = "8002"
	# PrivURL = ${Const|BaseURL}
	# PrivatePort = "8003"
	# MoneyPort = "8008"
	# SimulatorPort = "9010"
	# MysqlDatabase = "MysqlDatabase"
	# MysqlUser = "MysqlUser"
	# MysqlPassword = "MysqlPassword"
	# StartRegion = "Welcome"
	# Simulatorgridname = "MyGrid"
	# Simulatorgridnick = "MG"

	# Ausgabe Kopfzeilen
	echo "$SCRIPTNAME Version $VERSION"
	log rohtext "Ihre aktuelle externe IP ist $AKTUELLEIP"
	echo " "
	echo "*******************************************************************"
	log rohtext "********** ABBRUCH MIT DER TASTENKOMBINATION ********************"
	log rohtext "********************  CTRL/STRG + C  *****************************"
	echo "*******************************************************************"
	log rohtext #**     Die Werte in den [Klammern] sind vorschläge              *#"
	log rohtext #**     und können mit Enter übernommen werden.                  *#"
	echo "*******************************************************************"
	echo " "
	log rohtext "Wieviele Konfigurationen darf ich ihnen schreiben? [5]"
	read -r CONFIGANZAHL
	if [ "$CONFIGANZAHL" = "" ]; then CONFIGANZAHL="5"; fi
	log rohtext "Ihre Anzahl ist $CONFIGANZAHL"
	echo "*******************************************************************"

	log rohtext "Wohin darf ich diese schreiben? [$STARTVERZEICHNIS]"
	read -r VERZEICHNISABFRAGE
	if [ "$VERZEICHNISABFRAGE" = "" ]; then log rohtext "Ihr Konfigurationsordner ist $STARTVERZEICHNIS"; else STARTVERZEICHNIS="$VERZEICHNISABFRAGE";fi
	echo "*******************************************************************"

	log rohtext "Ihre Server Adresse? [$AKTUELLEIP]"
	read -r BASEHOSTNAME
	if [ "$BASEHOSTNAME" = "" ]; then BASEHOSTNAME="$AKTUELLEIP"; fi
	log rohtext "Ihre Server Adresse ist $BASEHOSTNAME"
	echo "*******************************************************************"

	log rohtext "Ihr SimulatorPort startet bei: [9010]"
	read -r SIMULATORPORT
	if [ "$SIMULATORPORT" = "" ]; then SIMULATORPORT="9010"; fi
	log rohtext "Ihr SimulatorPort startet bei: $SIMULATORPORT"
	echo "*******************************************************************"

	log rohtext "Bitte geben sie den mySQL/mariaDB Benutzernamen ihrer Datenbank an [opensim]:"
	read -r MYSQLUSER
	if [ "$MYSQLUSER" = "" ]; then MYSQLUSER="opensim"; fi
	log rohtext "Ihr Datenbank Benutzername lautet: $MYSQLUSER"
	echo "*******************************************************************"

	log rohtext "Bitte geben sie das Passwort ihrer mySQL/mariaDB Datenbank an [opensim]:"
	read -r MYSQLPASSWORD
	if [ "$MYSQLPASSWORD" = "" ]; then MYSQLPASSWORD="opensim"; fi
	log rohtext "Ihr Passwort ihrer Datenbank lautet: $MYSQLPASSWORD"
	echo "*******************************************************************"

	log rohtext "Datenbanken jetzt direkt anlegen [nein]:"
	read -r CREATEDATABASE
	if [ "$CREATEDATABASE" = "" ]; then CREATEDATABASE="nein"; fi

	if [ "$CREATEDATABASE" = "nein" ]; then
		log rohtext "Bitte geben sie den Datenbanknamen an [opensim]:"
		read -r MYSQLDATABASE
		if [ "$MYSQLDATABASE" = "" ]; then MYSQLDATABASE="opensim"; fi
		log rohtext "Ihr Datenbanknamen lautet: $MYSQLDATABASE"
		CREATEROBUSTDATABASENAME="$MYSQLDATABASE"
		echo "*******************************************************************"
	fi

	if [ "$CREATEDATABASE" = "ja" ]; then
		#** OpenSim Datenbanken
		log rohtext "Name der Datenbanken [sim]:"
		read -r CREATEDATABASENAME	
		if [ "$CREATEDATABASENAME" = "" ]; then CREATEDATABASENAME="sim"; fi

		#** Robust Datenbank
		log rohtext "Robust Datenbank anlegen [nein]:"
		read -r CREATEROBUSTDATABASE
		if [ "$CREATEROBUSTDATABASE" = "" ]; then CREATEROBUSTDATABASE="nein"; fi
		
		if [ "$CREATEROBUSTDATABASE" = "ja" ]; then
			log rohtext "Name der Robust Datenbank [robust]:"
			read -r CREATEROBUSTDATABASENAME
			if [ "$CREATEROBUSTDATABASENAME" = "" ]; then CREATEROBUSTDATABASENAME="robust"; fi
			createdatabase $CREATEROBUSTDATABASENAME $MYSQLUSER $MYSQLPASSWORD
		fi
	fi
	echo "*******************************************************************"

	# Der Grid Master Avatar

	log rohtext "Bitte geben sie den Vornamen ihres Grid Besitzer/Master Avatar an [John]:"
	read -r FIRSTNAMEMASTER
	if [ "$FIRSTNAMEMASTER" = "" ]; then FIRSTNAMEMASTER="John"; fi
	log rohtext "Der Vornamen ihres Grid Besitzer/Master Avatar lautet: $FIRSTNAMEMASTER"
	echo "*******************************************************************"

	log rohtext "Bitte geben sie den Nachnamen ihres Grid Besitzer/Master Avatar an [Doe]:"
	read -r LASTNAMEMASTER
	if [ "$LASTNAMEMASTER" = "" ]; then LASTNAMEMASTER="Doe"; fi
	log rohtext "Der Nachnamen ihres Grid Besitzer/Master Avatar lautet: $LASTNAMEMASTER"
	echo "*******************************************************************"

	log rohtext "Bitte geben sie das Passwort ihres Grid Besitzer/Master Avatar an [opensim]:"
	read -r PASSWDNAMEMASTER
	if [ "$PASSWDNAMEMASTER" = "" ]; then PASSWDNAMEMASTER="opensim"; fi
	log rohtext "Das Passwort ihres Grid Besitzer/Master Avatar lautet: $PASSWDNAMEMASTER"
	echo "*******************************************************************"

	log rohtext "Bitte geben sie die E-Mail ihres Grid Besitzer/Master Avatar an [john@doe.com]:"
	read -r EMAILNAMEMASTER
	if [ "$EMAILNAMEMASTER" = "" ]; then EMAILNAMEMASTER="john@doe.com"; fi
	log rohtext "Die E-Mail ihres Grid Besitzer/Master Avatar lautet: $EMAILNAMEMASTER"
	echo "*******************************************************************"

	UUIDNAMEMASTER=$(uuidgen)
	log rohtext "Bitte geben sie die UUID ihres Grid Besitzer/Master Avatar an [$UUIDNAMEMASTER]:"
	read -r UUIDNAMEMASTER
	if [ "$UUIDNAMEMASTER" = "" ]; then UUIDNAMEMASTER="$UUIDNAMEMASTER"; fi
	log rohtext "Die UUID ihres Grid Besitzer/Master Avatar lautet: $UUIDNAMEMASTER"
	echo "*******************************************************************"

	log rohtext "Bitte geben sie das Estate ihres Grid Besitzer/Master Avatar an [MyGrid Estate]:"
	read -r ESTATENAMEMASTER
	if [ "$ESTATENAMEMASTER" = "" ]; then ESTATENAMEMASTER="MyGrid Estate"; fi
	log rohtext "Das Estate ihres Grid Besitzer/Master Avatar lautet: $ESTATENAMEMASTER"
	echo "*******************************************************************"

	MODELNAMEMASTER=""

	# Master Avatar erstellen.
	#bash osmtool.sh rostart
	#bash osmtool.sh oscommand robust Welcome "create user $FIRSTNAMEMASTER $LASTNAMEMASTER $PASSWDNAMEMASTER $EMAILNAMEMASTER $UUIDNAMEMASTER $MODELNAMEMASTER"

	# Besitzerrechte und estate eintragen.
	# OpenSim starten:
	#bash osmtool.sh osstart sim1
	#bash osmtool.sh oscommand sim1 Welcome "$FIRSTNAMEMASTER"
	#bash osmtool.sh oscommand sim1 Welcome "$LASTNAMEMASTER"
	#bash osmtool.sh oscommand sim1 Welcome "$ESTATENAMEMASTER"

	#echo "*******************************************************************"

	log rohtext "Bitte geben sie den Namen ihrer Startregion an [Welcome]:"
	read -r STARTREGION
	if [ "$STARTREGION" = "" ]; then STARTREGION="Welcome"; fi
	log rohtext "Der Name ihrer Startregion lautet: $STARTREGION"
	echo "*******************************************************************"

	log rohtext "Bitte geben sie den Namen ihres Grids an [MyGrid]:"
	read -r SIMULATORGRIDNAME
	if [ "$SIMULATORGRIDNAME" = "" ]; then SIMULATORGRIDNAME="MyGrid"; fi
	log rohtext "Der Name ihrers Grids lautet: $SIMULATORGRIDNAME"
	echo "*******************************************************************"

	log rohtext "Bitte geben sie den Grid-Nickname an [MG]:"
	read -r SIMULATORGRIDNICK
	if [ "$SIMULATORGRIDNICK" = "" ]; then SIMULATORGRIDNICK="MG"; fi
	log rohtext "Der Grid-Nickname lautet: $SIMULATORGRIDNICK"
	echo "*******************************************************************"

	log rohtext "Möchten sie die Regionskonfigurationen direkt Aktivieren ja/nein [nein]:"
	read -r REGIONAKTIV
	if [ "$REGIONAKTIV" = "" ]; then REGIONAKTIV="nein"; fi
	log rohtext "Sie haben ausgewählt: $REGIONAKTIV"
	echo "*******************************************************************"

	log rohtext "Möchten sie die Skriptkonfigurationen Aktivieren ja/nein [nein]:"
	read -r SKRIPTAKTIV
	if [ "$SKRIPTAKTIV" = "" ]; then SKRIPTAKTIV="nein"; fi
	log rohtext "Sie haben ausgewählt: $SKRIPTAKTIV"
	echo "*******************************************************************"

	# Weitere Auswertungen
	if [ "$PRIVURL" = "" ]; then PRIVURL="\${Const|BaseURL}"; fi
	if [ "$MONEYPORT" = "" ]; then MONEYPORT="8008"; fi

	osconfigstruktur 1 "$CONFIGANZAHL"
}

## *  firstinstallation
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion führt die Erstinstallation eines Grids oder einer OpenSimulator-Instanz durch.
	# Sie stoppt das Grid, kopiert Dateien und erstellt Master- und Region-Avatare.
	#? Parameter: Keine
	#? Funktionsverhalten:
	#   - Die Funktion stoppt das Grid, falls es läuft, durch Aufruf von `autostop()`.
	#   - Sie kopiert Dateien von einer Quelle auf eine Zielposition mit den Funktionen `oscopyrobust()` und `oscopysim()`.
	#   - Sie erstellt Master- und Region-Avatare mit den Funktionen `createmasteravatar()` und `createregionavatar()`.
	#? Beispielaufruf:
	#   firstinstallation
	#? Rückgabewert: Die Funktion gibt keinen expliziten Rückgabewert zurück.
	#? Hinweise:
	#   - Überprüfen Sie, ob alle aufgerufenen Funktionen (autostop, oscopyrobust, oscopysim, createmasteravatar, createregionavatar) ordnungsgemäß definiert und konfiguriert sind.
	#   - Stellen Sie sicher, dass die Funktion korrekt und sicher läuft, da es sich um einen kritischen Prozess handelt.
	#   - Die Funktion sollte sicherstellen, dass alle erforderlichen Vorbereitungen für die erste Installation getroffen werden.
##
function firstinstallation() {
	log line
	log info "Erstinstallation"
	log info "Das Grid wird jetzt vorbereitet"
	log line
	# Grid Stoppen.
	log info "Alles Beenden falls da etwas laeuft"
	autostop
	# Kopieren.
	log info "Neue Version kopieren"
	oscopyrobust
	oscopysim
	log line
	createmasteravatar
	createregionavatar
}

## *  createmasteravatar
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion erstellt einen Master-Avatar für Ihr Grid, indem sie bestimmte Befehle über das osmtool ausführt.
	#? Parameter: Keine
	#? Funktionsverhalten:
	#   - Die Funktion startet den Robust Server durch Aufruf von `bash osmtool.sh rostart`.
	#   - Sie erstellt den Master-Avatar durch Aufruf von `bash osmtool.sh oscommand robust Welcome "create user ..."`.
	#? Beispielaufruf:
	#   createmasteravatar
	#? Rückgabewert: Die Funktion gibt keinen expliziten Rückgabewert zurück.
	#? Hinweise:
	#   - Überprüfen Sie, ob die in den Befehlen verwendeten Skripte oder Programme (osmtool.sh) ordnungsgemäß konfiguriert und vorhanden sind.
	#   - Stellen Sie sicher, dass die Parameter für die Erstellung des Master-Avatars (FIRSTNAMEMASTER, LASTNAMEMASTER, PASSWDNAMEMASTER, EMAILNAMEMASTER, UUIDNAMEMASTER, MODELNAMEMASTER) korrekt festgelegt und definiert sind.
	#   - Die Funktion sollte sicherstellen, dass der Master-Avatar erfolgreich erstellt wird, andernfalls sollten Fehlerbehandlungsmechanismen hinzugefügt werden.
##
function createmasteravatar() {
	# Master Avatar erstellen.
	bash osmtool.sh rostart
	bash osmtool.sh oscommand robust Welcome "create user $FIRSTNAMEMASTER $LASTNAMEMASTER $PASSWDNAMEMASTER $EMAILNAMEMASTER $UUIDNAMEMASTER $MODELNAMEMASTER"
}

## *  createregionavatar
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion erstellt einen Avatar in jeder Region des Grids, indem sie bestimmte Befehle in den Regionsscreens ausführt.
	#? Parameter: Keine
	#? Funktionsverhalten:
	#   - Die Funktion ruft `makeverzeichnisliste` auf, um eine Liste von Verzeichnissen zu erstellen, in denen Aktionen ausgeführt werden sollen.
	#   - Für jedes Verzeichnis in der Liste führt die Funktion folgende Aktionen aus:
	#       - Wechselt zum entsprechenden Verzeichnis.
	#       - Führt `screen`-Befehle aus, um den Master-Avatar in der Region zu erstellen.
	#? Beispielaufruf:
	#   createregionavatar
	#? Rückgabewert: Die Funktion gibt keinen expliziten Rückgabewert zurück.
	#? Hinweise:
	#   - Überprüfen Sie, ob die in den Befehlen verwendeten Skripte oder Programme (screen) ordnungsgemäß konfiguriert und vorhanden sind.
	#   - Stellen Sie sicher, dass die Parameter für die Erstellung des Master-Avatars (FIRSTNAMEMASTER, LASTNAMEMASTER, ESTATENAMEMASTER) korrekt festgelegt und definiert sind.
	#   - Die Funktion sollte sicherstellen, dass der Avatar erfolgreich in jeder Region erstellt wurde, andernfalls sollten Fehlerbehandlungsmechanismen hinzugefügt werden.
##
function createregionavatar() {
	makeverzeichnisliste
	for ((i = 0; i < "$ANZAHLVERZEICHNISSLISTE"; i++)); do
		cd /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin || return 1

		screen -S "$OSCOMMANDSCREEN" -p 0 -X eval "stuff '$FIRSTNAMEMASTER'^M"
		screen -S "$OSCOMMANDSCREEN" -p 0 -X eval "stuff '$LASTNAMEMASTER'^M"
		screen -S "$OSCOMMANDSCREEN" -p 0 -X eval "stuff '$ESTATENAMEMASTER'^M"

		sleep 1
	done

	return 0
}

#──────────────────────────────────────────────────────────────────────────────────────────
#* Build Funktionen Funktionsgruppe
#──────────────────────────────────────────────────────────────────────────────────────────

## *  compilieren
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion überprüft das Vorhandensein von erforderlichen Dateien und Verzeichnissen für die OpenSimulator-Kompilierung und führt die Kompilierung durch, wenn sie nicht vorhanden sind.
	#? Parameter: Keine
	#? Funktionsverhalten:
	#   - Überprüft das Vorhandensein von erforderlichen Dateien und Verzeichnissen.
	#   - Kopiert fehlende Dateien/Verzeichnisse aus den Quellen (falls verfügbar).
	#   - Führt die OpenSimulator-Kompilierung durch, wenn das OpenSimulator-Verzeichnis fehlt.
	#? Beispielaufruf:
	#   compilieren
	#? Rückgabewert: Die Funktion gibt keinen expliziten Rückgabewert zurück.
	#? Hinweise:
	#   - Stellen Sie sicher, dass die Pfade und Dateinamen in den Überprüfungen und Kopierbefehlen korrekt sind.
	#   - Wenn verschiedene Kompilierungsoptionen vorhanden sind (AOT-Aktivierung), können Sie diese entsprechend implementieren.
	#   - Die Funktion sollte sicherstellen, dass die Kompilierung erfolgreich war und ggf. Fehler behandeln.
##
function compilieren() {
	log info "Bauen eines neuen OpenSimulators  wird gestartet..."
	# Nachsehen ob Verzeichnis ueberhaupt existiert.
	if [ ! -f "/$STARTVERZEICHNIS/$SCRIPTSOURCE/" ]; then
		scriptcopy
	else
		log error "OSSL Script Verzeichnis existiert nicht"
	fi

	if [ ! -f "/$STARTVERZEICHNIS/$MONEYSOURCE/" ]; then
		moneycopy
	else
		log error "MoneyServer Verzeichnis existiert nicht"
	fi

	if [ ! -f "/$STARTVERZEICHNIS/BulletSim/" ]; then
		bulletcopy
	else
		log error "BulletSim Verzeichnis existiert nicht"
	fi

	if [ ! -f "/$STARTVERZEICHNIS/$OSSEARCHCOPY/" ]; then
		searchgitcopy
	else
		log error "OpenSimSearch Verzeichnis existiert nicht"
	fi

	if [ ! -f "/$STARTVERZEICHNIS/OpensimPython/" ]; then
		pythoncopy
	else
		log error "OpensimPython Verzeichnis existiert nicht"
	fi

	if [ ! -f "/$STARTVERZEICHNIS/OpenSimSearch/" ]; then
		searchcopy
	else
		log error "OpenSimSearch Verzeichnis existiert nicht"
	fi

	if [ ! -f "/$STARTVERZEICHNIS/OpenSimMutelist/" ]; then
		mutelistcopy
	else
		log error "OpenSimMutelist Verzeichnis existiert nicht"
	fi

	if [ ! -f "/$STARTVERZEICHNIS/Chris.OS.Additions/" ]; then
		chrisoscopy
	else
		log error "Chris.OS.Additions Verzeichnis existiert nicht"
	fi

	if [ ! -f "/$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/" ]; then
		# Jetzt alles Kompilieren.
		oscompi
	else
		log error "OpenSim Verzeichnis zum Kompilieren existiert nicht"
	fi

	return 0
}

## *  osgridcopy
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion überprüft den Build-Status und aktualisiert das OpenSimulator-Grid, wenn der Build erfolgreich war. Sie stoppt das Grid, kopiert die neue Version und löscht bei Bedarf den MoneyServer.
	#? Parameter: Keine
	#? Funktionsverhalten:
	#   - Überprüft den Build-Status anhand der Build-Nachrichten.
	#   - Stoppt das Grid, falls es läuft.
	#   - Kopiert die neue Version des Grids.
	#   - Löscht den MoneyServer, wenn erforderlich (abhängig von MONEYVERZEICHNIS-Einstellungen).
	#? Beispielaufruf:
	#   osgridcopy
	#? Rückgabewert: Die Funktion gibt keinen expliziten Rückgabewert zurück.
	#? Hinweise:
	#   - Stellen Sie sicher, dass die Pfade und Dateinamen in den Kopierbefehlen korrekt sind.
	#   - Die Funktion sollte sicherstellen, dass die Kopie erfolgreich war und ggf. Fehler behandeln.
	#   - Überprüfen Sie, ob die Überwachung des Build-Status korrekt implementiert ist.
##  
function osgridcopy() {
	log text " *****************************"
	log text "Steht hier:"
	log text " "
	log info "Build succeeded."
	log text "    0 Warning(s)"
	log text "    0 Error(s)"
	log text " "
	log info "Dann ist alles gut gegangen."
	log text " *****************************"
	log warn " !!!      BEI FEHLER      !!! "
	log warn " !!! ABBRUCH MIT STRG + C !!! "
	log text " *****************************"

	log info "Das Grid wird jetzt kopiert/aktualisiert"
	log line
	# Grid Stoppen.
	log info "Alles Beenden falls da etwas laeuft"
	autostop
	# Kopieren.
	log info "Neue Version kopieren"
	oscopyrobust
	oscopysim
	log line
	# MoneyServer eventuell loeschen.
	if [ "$MONEYVERZEICHNIS" = "keins" ] || [ "$MONEYVERZEICHNIS" = "no" ] || [ "$MONEYVERZEICHNIS" = "nein" ]; then moneydelete; fi
	return 0
}

## *  osupgrade93
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion aktualisiert ein OpenSimulator-Grid auf Version 0.9.3. Sie stoppt das Grid, löscht ggf. den Cache, aktualisiert die Versionsdatei, kopiert die neue Version und löscht den MoneyServer (abhängig von MONEYVERZEICHNIS-Einstellungen).
	#? Parameter: Keine
	#? Funktionsverhalten:
	#   - Stoppt das Grid, falls es läuft.
	#   - Löscht den Grid-Cache, wenn GRIDCACHECLEAR auf "yes" gesetzt ist.
	#   - Aktualisiert die Versionsdatei auf das aktuelle Datum.
	#   - Kopiert die neue Version des Grids (robust und sim).
	#   - Löscht den MoneyServer, wenn erforderlich (abhängig von MONEYVERZEICHNIS-Einstellungen).
	#   - Startet das Grid nach dem Upgrade (nicht auskommentierten Abschnitt aktivieren, wenn benötigt).
	#? Beispielaufruf:
	#   osupgrade93
	#? Rückgabewert: Die Funktion gibt keinen expliziten Rückgabewert zurück.
	#? Hinweise:
	#   - Stellen Sie sicher, dass die Pfade und Dateinamen in den Kopierbefehlen korrekt sind.
	#   - Überprüfen Sie die Konfigurationseinstellungen wie GRIDCACHECLEAR und MONEYVERZEICHNIS.
	#   - Aktivieren Sie das Grid-Starten, wenn Sie möchten, dass das Grid automatisch nach dem Upgrade gestartet wird.
## 
function osupgrade93() {
	log text " *****************************"
	log text " !!!      BEI FEHLER      !!! "
	log text " !!! ABBRUCH MIT STRG + C !!! "
	log text " *****************************"

	log info "Das Grid wird jetzt upgegradet"
	autostop
	# Cache loeschen
	if [ "$GRIDCACHECLEAR" = "yes" ]; then gridcachedelete; fi
	# Version
	# echo " $Datum " >/$STARTVERZEICHNIS/opensim/bin/'.version'
	# Kopieren.
	log line
	log info "Neue Version Installieren"
	oscopyrobust
	oscopysim
	autologdel
	# MoneyServer eventuell loeschen.
	if [ "$MONEYVERZEICHNIS" = "keins" ] || [ "$MONEYVERZEICHNIS" = "no" ] || [ "$MONEYVERZEICHNIS" = "nein" ]; then moneydelete; fi
	# Grid Starten.
	# log info "Das Grid wird jetzt gestartet"
	autostart
	return 0
}

## *  osupgrade
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion aktualisiert ein OpenSimulator-Grid auf Version 0.9.3. Sie stoppt das Grid, löscht ggf. den Cache, aktualisiert die Versionsdatei, kopiert die neue Version und löscht den MoneyServer (abhängig von MONEYVERZEICHNIS-Einstellungen).
	#? Parameter: Keine
	#? Funktionsverhalten:
	#   - Stoppt das Grid, falls es läuft.
	#   - Löscht den Grid-Cache, wenn GRIDCACHECLEAR auf "yes" gesetzt ist.
	#   - Aktualisiert die Versionsdatei auf das aktuelle Datum.
	#   - Kopiert die neue Version des Grids (robust und sim).
	#   - Löscht den MoneyServer, wenn erforderlich (abhängig von MONEYVERZEICHNIS-Einstellungen).
	#   - Startet das Grid nach dem Upgrade (nicht auskommentierten Abschnitt aktivieren, wenn benötigt).
	#? Beispielaufruf:
	#   osupgrade
	#? Rückgabewert: Die Funktion gibt keinen expliziten Rückgabewert zurück.
	#? Hinweise:
	#   - Stellen Sie sicher, dass die Pfade und Dateinamen in den Kopierbefehlen korrekt sind.
	#   - Überprüfen Sie die Konfigurationseinstellungen wie GRIDCACHECLEAR und MONEYVERZEICHNIS.
	#   - Aktivieren Sie das Grid-Starten, wenn Sie möchten, dass das Grid automatisch nach dem Upgrade gestartet wird.
##
function osupgrade() {
	log text " *****************************"
	log text " !!!      BEI FEHLER      !!! "
	log text " !!! ABBRUCH MIT STRG + C !!! "
	log text " *****************************"

	log info "Das Grid wird jetzt upgegradet"
	autostop
	# Cache loeschen
	if [ "$GRIDCACHECLEAR" = "yes" ]; then gridcachedelete; fi
	# Kopieren.
	log line
	log info "Neue Version Installieren"
	oscopyrobust
	oscopysim
	autologdel
	# MoneyServer eventuell loeschen.
	if [ "$MONEYVERZEICHNIS" = "keins" ] || [ "$MONEYVERZEICHNIS" = "no" ] || [ "$MONEYVERZEICHNIS" = "nein" ]; then moneydelete; fi
	# Grid Starten.
	# log info "Das Grid wird jetzt gestartet"
	autostart
	return 0
}

## *  osdowngrade
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion setzt ein OpenSimulator-Grid auf die vorherige Version zurück. Sie stoppt das Grid, löscht ggf. den Cache, benennt die aktuelle Version um und kopiert die vorherige Version zurück.
	#? Parameter: Keine
	#? Funktionsverhalten:
	#   - Stoppt das Grid, falls es läuft.
	#   - Löscht den Grid-Cache, wenn GRIDCACHECLEAR auf "yes" gesetzt ist.
	#   - Benennt das aktuelle Grid-Verzeichnis um und kopiert das vorherige Grid-Verzeichnis zurück.
	#   - Löscht den MoneyServer, wenn erforderlich (abhängig von MONEYVERZEICHNIS-Einstellungen).
	#   - Startet das Grid nach dem Downgrade (nicht auskommentierten Abschnitt aktivieren, wenn benötigt).
	#? Beispielaufruf:
	#   osdowngrade
	#? Rückgabewert: Die Funktion gibt keinen expliziten Rückgabewert zurück.
	#? Hinweise:
	#   - Stellen Sie sicher, dass die Pfade und Verzeichnisnamen in den Kopierbefehlen korrekt sind.
	#   - Überprüfen Sie die Konfigurationseinstellungen wie GRIDCACHECLEAR und MONEYVERZEICHNIS.
	#   - Aktivieren Sie das Grid-Starten, wenn Sie möchten, dass das Grid automatisch nach dem Downgrade gestartet wird.
##
function osdowngrade() {
	log text " *****************************"
	log text " !!!      BEI FEHLER      !!! "
	log text " !!! ABBRUCH MIT STRG + C !!! "
	log text " *****************************"

	log info "Das Grid wird jetzt zurückgesetzt, auf die vorherige Version."

	echo "Das zurücksetzen von OpenSim 0.9.3 auf 0.9.2 ist zur Zeit nicht möglich!!!"
	echo "Möchten Sie das wirklich tun? (ja/[nein]): " 
	read -r osdowngradeanswer
    if [[ "$osdowngradeanswer" != "ja" ]]; then
        echo "Abbruch."
        exit 1
    fi

	autostop
	# Cache loeschen
	if [ "$GRIDCACHECLEAR" = "yes" ]; then gridcachedelete; fi
	# Kopieren.
	log line
	log info "Alte Version Installieren"
    cd /"$STARTVERZEICHNIS" || return 1
    mv opensim opensim2
    mv opensim1 opensim
    mv opensim2 opensim1
	oscopyrobust
	oscopysim
	autologdel
	# MoneyServer eventuell loeschen.
	if [ "$MONEYVERZEICHNIS" = "keins" ] || [ "$MONEYVERZEICHNIS" = "no" ] || [ "$MONEYVERZEICHNIS" = "nein" ]; then moneydelete; fi
	# Grid Starten.
	# log info "Das Grid wird jetzt gestartet"
	autostart
	return 0
}

## *  oszipupgrade
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion entpackt einen neuen OpenSimulator aus einer ZIP-Datei und installiert ihn. Die Funktion verwendet Dialog, um die Versionsnummer einzugeben, falls verfügbar, andernfalls erfolgt die Eingabe ohne Dialog.
	#? Parameter: Keine
	#? Funktionsverhalten:
	#   - Ermöglicht die Eingabe der Versionsnummer entweder mit Dialog (falls verfügbar) oder ohne Dialog.
	#   - Sichert die alte OpenSimulator-Installation.
	#   - Entpackt den neuen OpenSimulator aus der ZIP-Datei.
	#   - Benennt den neuen OpenSimulator um.
	#   - Führt ein Upgrade des Grids mit osupgrade() durch.
	#? Beispielaufruf:
	#   oszipupgrade
	#? Rückgabewert: Die Funktion gibt keinen expliziten Rückgabewert zurück.
	#? Hinweise:
	#   - Stellen Sie sicher, dass die ZIP-Datei und die Installationspfade korrekt sind.
	#   - Passen Sie die Funktion an, um die Versionsnummer auf die richtige Weise zu extrahieren, wenn dies erforderlich ist.
##  
function oszipupgrade() {
	#** dialog Aktionen
	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then
		# Alle Aktionen mit dialog
		VERSIONSNUMMER=$(dialog --backtitle "opensimMULTITOOL $VERSION" --title "opensimMULTITOOL Eingabe" --help-button --defaultno --inputbox "Versionsnummer:" 8 40 3>&1 1>&2 2>&3 3>&-)
		antwort=$?
		dialogclear
		ScreenLog

		if [[ $antwort = 2 ]]; then hilfemenu; fi
		if [[ $antwort = 1 ]]; then exit; fi	
	else
		# Alle Aktionen ohne dialog
		log rohtext "Keine Menuelose Funktion vorhanden!" | exit
		#VERSIONSNUMMER=$1
	fi
	# dialog Aktionen Ende

	cd /"$STARTVERZEICHNIS" || exit

	# Konfigurationsabfrage Neues Grid oder Upgrade.
	log info "Alten OpenSimulator sichern"
	osdelete

	log line

	log info "Neuen OpenSimulator aus der ZIP entpacken"
	unzip opensim-0.9.3.0."$VERSIONSNUMMER".zip

	log line

	log info "Neuen OpenSimulator umbenennen"
	mv /"$STARTVERZEICHNIS"/opensim-0.9.3.0."$VERSIONSNUMMER"/ /"$STARTVERZEICHNIS"/opensim/

	log line

	osupgrade
	return 0
}

function pcampbot() {
	PCBfirstname=$1
	PCBlastname=$2
	PCBpassword=$3	
	PCBregion=$4
	PCBanzahl=$5

	log line
	log info "Test Bots erstellen die sich auf einer Region bewegen."
	log line

	if [ "$PCBanzahl" = "" ]; then PCBanzahl=0; fi

	cd /"$ROBUSTVERZEICHNIS" || exit

	# DOTNET oder mono
	if [[ "${DOTNETMODUS}" == "yes" ]]; then
	screen -fa -S PCB -d -U -m dotnet pCampBot.dll -loginuri http://127.0.0.1:8002 -s $PCBregion -firstname $PCBfirstname -lastname $PCBlastname -password $PCBpassword -botcount $PCBanzahl -b p
	else
	screen -fa -S PCB -d -U -m mono pCampBot.exe -loginuri http://127.0.0.1:8002 -s $PCBregion -firstname $PCBfirstname -lastname $PCBlastname -password $PCBpassword -botcount $PCBanzahl -b p
	fi
}

#──────────────────────────────────────────────────────────────────────────────────────────
#* Automatische Konfigurationen Prototype Funktionsgruppe
#──────────────────────────────────────────────────────────────────────────────────────────

## * ConfigSet
	# Datum: 02.10.2023
	# Autor: [Ihr Name oder Benutzername]
	#? Beschreibung:
	# Diese Funktion verarbeitet eine INI-Datei und wandelt die Konfiguration daraus in eine Bash-Array-Struktur um.
	#? Parameter:
	#   $1 (String): Der Name der INI-Datei, die verarbeitet werden soll.
	# Funktionsverhalten:
	#   - Löscht zuerst eine eventuell vorhandene "$datei.ini.cnf"-Datei.
	#   - Kopiert die "$datei.ini"-Datei in "$datei.ini.cnf".
	#   - Entfernt alle Zeilen in der "$datei.ini.cnf"-Datei, die mit ";" beginnen (Kommentare).
	#   - Entfernt führende Leerzeichen (Leerzeichen und Tabulatoren) vor jeder Zeile in der "$datei.ini.cnf"-Datei.
	#   - Entfernt alle leeren Zeilen in der "$datei.ini.cnf"-Datei.
	#   - Ersetzt alle doppelten Hochstriche ("") durch einfache Hochstriche ('') in der "$datei.ini.cnf"-Datei.
	#   - Fügt an den Anfang und das Ende jeder Zeile in der "$datei.ini.cnf"-Datei ein doppeltes Hochstrich-Paar hinzu.
	#   - Erstellt ein Bash-Array mit den konfigurierten Werten und weist es der Variable "$dateiConfigList" zu.
	# Beispielaufruf:
	#   ConfigSet "config.ini"
	#? Rückgabewert: Die Funktion ändert die Datei "$datei.ini.cnf" und erstellt ein Bash-Array "$dateiConfigList".
	# Hinweise:
	#   - Passen Sie die Funktionalität an die Anforderungen Ihres Skripts an.
##
function ConfigSet() {
    datei=$1

    log rohtext "Loesche $datei.ini.cnf"
    rm "$datei.ini.cnf"

    log rohtext "Kopiere $datei.ini nach $datei.ini.cnf"
    cp "$datei.ini" "$datei.ini.cnf"

    log rohtext "Loesche alle Zeilen mit ;"
    #sed -i -e '/string/d' input
    sed -i -e '/;/d' "$datei.ini.cnf"

    log rohtext "Fuehrende Leerzeichen (Leerzeichen, Tabulatoren) vor jeder Zeile loeschen"
    sed -i -e 's/^[ \t]*//' "$datei.ini.cnf"

    log rohtext "Loesche alle leeren Zeilen"
    sed -i -e '/^$/d' "$datei.ini.cnf"

    log rohtext "Ersetze alle doppelten Hochstriche gegen einfache."
    sed -i -e s/\"/\'/g "$datei.ini.cnf"

    log rohtext "Einstrich Sonderzeichen an den anfang und ende jeder Zeile haengen."
    sed -i -e s/^/\"/ "$datei.ini.cnf"
    sed -i -e s/$/\"/g "$datei.ini.cnf"

    log rohtext "Ein Array daraus machen."
    sed -i -e 1 i\$dateiConfigList=\( "$datei.ini.cnf"
    sed -i -e '$a)' "$datei.ini.cnf"
}

## * AutoInstall
	# Datum: 02.10.2023
	# Autor: [Ihr Name oder Benutzername]
	#? Beschreibung:
	# Diese Funktion führt eine Grundinstallation für einen Server durch, wobei sie speziell auf verschiedene Versionen von Ubuntu abzielt.
	# Funktionsverhalten:
	#   - Ermittelt die Ubuntu-Version und speichert sie in den Variablen $ubuntuDescription, $ubuntuRelease und $ubuntuCodename.
	#   - Stellt eine Willkommensnachricht dar und fragt den Benutzer, ob er die Grundinstallation durchführen möchte.
	#   - Führt die Grundinstallation nur dann durch, wenn der Benutzer "ja" auswählt.
	#   - Je nach erkannter Ubuntu-Version werden unterschiedliche Installationsschritte durchgeführt.
	# Beispielaufruf:
	#   AutoInstall
	#? Rückgabewert: Die Funktion führt die Grundinstallation des Servers durch, abhängig von der erkannten Ubuntu-Version.
	# Hinweise:
	#   - Passen Sie die Funktionalität an die Anforderungen Ihres Skripts und die unterstützten Ubuntu-Versionen an.
##
function AutoInstall() {
    #ramspeicher
    #mysqlspeicher=$((RAMSPEICHER / 2))
	# Linux Version
	myDescription=$(lsb_release -d) # Description: Ubuntu 22.04 LTS
	myRelease=$(lsb_release -r)     # Release: 22.04
	myCodename=$(lsb_release -sc)   # jammy

	ubuntuDescription=$(cut -f2 <<<"$myDescription") # Ubuntu 22.04 LTS
	ubuntuRelease=$(cut -f2 <<<"$myRelease")         # 22.04
	ubuntuCodename=$(cut -f2 <<<"$myCodename")       # jammy

	if [ "$ubuntuCodename" = "jammy" ]; then MYSERVER="Ubuntu 22 jammy"; fi
	if [ "$ubuntuCodename" = "bionic" ]; then MYSERVER="Ubuntu 18 bionic"; fi

    log rohtext "Herzlich willkommen zur Grundinstallation ihreres Servers."
    log rohtext "Möchten sie eine Grundinstallation ihres $MYSERVER Servers, "

    log rohtext "damit alle für den Betrieb benötigten Linux Pakete installiert werden ja/nein: [nein]"
	read -r installation
	if [ "$installation" = "" ]; then installation="nein"; fi

    if [ "$installation" = "ja" ]; then
        if [ "$ubuntuCodename" = "jammy" ]; then
            #echo "entdeckt Ubuntu 22"
            linuxupgrade
            installubuntu22
			monoinstall20 # 22 gibt es nicht.
			monoinstall22 # Upgrade monoistall20
            installphpmyadmin
            ufwset
            #installationhttps22
            installfinish
        elif [ "$ubuntuCodename" = "bionic" ]; then
            #echo "entdeckt Ubuntu 18"
            serverupgrade
            installopensimulator
            monoinstall18
            installfinish
        else
            log rohtext "Ich erkenne das Betriebssystem nicht"
        fi
    fi
}

## * osslEnableConfig
	# Datum: 02.10.2023
	# Autor: [Ihr Name oder Benutzername]
	#? Beschreibung:
	# Diese Funktion fordert den Benutzer auf, Rechte für ein OpenSimulator-Skript zu konfigurieren.
	# Funktionsverhalten:
	#   - Fragt den Benutzer nach den Skriptrechten für den Grid-Betreiber mit der UUID $BenutzerUUID.
	#   - Verarbeitet die Benutzereingabe und verwendet die eingegebenen Rechte oder die Standard-UUID $BenutzerUUID, falls keine Eingabe erfolgt.
	#   - Ruft die Funktion osslEnableConfigSet() auf, um die Konfiguration mit den angegebenen Rechten durchzuführen.
	# Beispielaufruf:
	#   osslEnableConfig
	#? Rückgabewert: Die Funktion ruft osslEnableConfigSet() mit den verarbeiteten Benutzereingaben auf.
	# Hinweise:
	#   - Stellen Sie sicher, dass die Variablen $BenutzerUUID und osslEnableConfigSet() in Ihrem Skript definiert sind.
	#   - Passen Sie die Funktionalität an die Anforderungen Ihres Skripts an.
##
function osslEnableConfig() {
    # Abfrage des Benutzers.
    echo "Alle Skript Rechte an Grid Betreiber [$BenutzerUUID]: "; read -r Rechte
    # Auswertung der Eingaben.
    if test -z "$Rechte"; then Rechte="$BenutzerUUID"; fi

    osslEnableConfigSet "$Rechte"
}

## * osslEnableConfigSet
	# Datum: 02.10.2023
	# Autor: [Ihr Name oder Benutzername]
	#? Beschreibung:
	# Diese Funktion erstellt eine Konfigurationsdatei mit OpenSimulator-Skriptberechtigungen.
	# Funktionsverhalten:
	#   - Definiert eine Liste von Konfigurationszeilen für die Berechtigungen von OpenSimulator-Skripten.
	#   - Erstellt die Konfigurationsdatei $osslEnabledatei und speichert die Zeilen darin.
	#   - Tauscht einfache Hochstriche (') gegen doppelte Hochstriche (") aus.
	# Beispielaufruf:
	#   osslEnableConfigSet "$Rechte"
	#? Parameter:
	#   $Rechte - Die Skriptberechtigungen, die in der Konfigurationsdatei festgelegt werden sollen.
	#             Dies kann eine Liste von Berechtigungen und Benutzergruppen sein.
	#? Rückgabewert: Die Funktion erstellt die Konfigurationsdatei mit den angegebenen Berechtigungen.
	# Hinweise:
	#   - Passen Sie die Liste der Berechtigungen an Ihre Anforderungen an.
	#   - Stellen Sie sicher, dass die Variable $osslEnabledatei in Ihrem Skript definiert ist.
	#   - Beachten Sie, dass diese Funktion die vorhandene Konfigurationsdatei überschreiben kann.
##
function osslEnableConfigSet() {
    osslEnabledatei="osslEnable.ini"

    OsslEnableConfigList=(
    "[OSSL]"
    "AllowOSFunctions = true"
    "AllowMODFunctions = true"
    "AllowLightShareFunctions = true"
    "PermissionErrorToOwner = true"
    "OSFunctionThreatLevel = Moderate"
    "osslParcelO = 'PARCEL_OWNER,$Rechte,'"
    "osslParcelOG = 'PARCEL_GROUP_MEMBER,PARCEL_OWNER,$Rechte,'"
    "osslNPC = ${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER,$Rechte"
    "Allow_osDrawText = 				true"
    "Allow_osGetAgents = 				true"
    "Allow_osGetAvatarList =  			true"
    "Allow_osGetGender =               true"
    "Allow_osGetHealth =               true"
    "Allow_osGetHealRate =             true"
    "Allow_osGetNPCList =              true"
    "Allow_osGetRezzingObject =        true"
    "Allow_osNpcGetOwner =             ${OSSL|osslNPC}"
    "Allow_osSetSunParam =             ${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER"
    "Allow_osTeleportOwner =           ${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER"
    "Allow_osWindActiveModelPluginName = true"
    "Allow_osSetEstateSunSettings =    ESTATE_MANAGER,ESTATE_OWNER"
    "Allow_osSetRegionSunSettings =    ESTATE_MANAGER,ESTATE_OWNER"
    "Allow_osEjectFromGroup =          ${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER"
    "Allow_osForceBreakAllLinks =      ${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER"
    "Allow_osForceBreakLink =          ${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER"
    "Allow_osGetWindParam =            true"
    "Allow_osInviteToGroup =           ${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER"
    "Allow_osReplaceString =           true"
    "Allow_osSetDynamicTextureData =  true"
    "Allow_osSetDynamicTextureDataFace =   ${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER"
    "Allow_osSetDynamicTextureDataBlend =  ${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER"
    "Allow_osSetDynamicTextureDataBlendFace = ${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER"
    "Allow_osSetDynamicTextureURL =        ${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER"
    "Allow_osSetDynamicTextureURLBlend =   ${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER"
    "Allow_osSetDynamicTextureURLBlendFace = ${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER"
    "Allow_osSetParcelMediaURL =       ${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER"
    "Allow_osSetParcelSIPAddress =     ${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER"
    "Allow_osSetPrimFloatOnWater =     true"
    "Allow_osSetWindParam =            ${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER"
    "Allow_osTerrainFlush =            ESTATE_MANAGER,ESTATE_OWNER"
    "Allow_osUnixTimeToTimestamp =     true"
    "Allow_osAvatarName2Key =          true"
    "Allow_osFormatString =            true"
    "Allow_osKey2Name =                ${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER"
    "Allow_osListenRegex =             true"
    "Allow_osLoadedCreationDate =      ${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER"
    "Allow_osLoadedCreationID =        ${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER"
    "Allow_osLoadedCreationTime =      ${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER"
    "Allow_osMessageObject =           true"
    "Allow_osRegexIsMatch =            true"
    "Allow_osGetAvatarHomeURI =        true"
    "Allow_osNpcSetProfileAbout =      ${OSSL|osslNPC}"
    "Allow_osNpcSetProfileImage =      ${OSSL|osslNPC}"
    "Allow_osDie =                     ${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER"
    "Allow_osDetectedCountry =         ${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER"
    "Allow_osDropAttachment =          ${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER"
    "Allow_osDropAttachmentAt =        ${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER"
    "Allow_osGetAgentCountry =         true"
    "Allow_osGetGridCustom =           true"
    "Allow_osGetGridGatekeeperURI =    true"
    "Allow_osGetGridHomeURI =          true"
    "Allow_osGetGridLoginURI =         true"
    "Allow_osGetGridName =             true"
    "Allow_osGetGridNick =             true"
    "Allow_osGetNumberOfAttachments =  true"
    "Allow_osGetRegionStats =          true"
    "Allow_osGetSimulatorMemory =      true"
    "Allow_osGetSimulatorMemoryKB =    true"
    "Allow_osMessageAttachments =      ${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER"
    "Allow_osSetSpeed =                ${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER"
    "Allow_osSetOwnerSpeed =           ${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER"
    "Allow_osCauseDamage =             ${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER"
    "Allow_osCauseHealing =            ${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER"
    "Allow_osSetHealth =               ${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER"
    "Allow_osSetHealRate =             ${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER"
    "Allow_osForceAttachToAvatar =     ${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER"
    "Allow_osForceAttachToAvatarFromInventory = ${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER"
    "Allow_osForceCreateLink =         ${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER"
    "Allow_osForceDropAttachment =     ${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER"
    "Allow_osForceDropAttachmentAt =   ${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER"
    "Allow_osGetLinkPrimitiveParams =  ${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER"
    "Allow_osGetPhysicsEngineType =    ${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER"
    "Allow_osGetRegionMapTexture =     ${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER"
    "Allow_osGetScriptEngineName =     ${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER"
    "Allow_osGetSimulatorVersion =     ${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER"
    "Allow_osMakeNotecard =            ${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER"
    "Allow_osMatchString =             ${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER"
    "Allow_osNpcCreate =               ${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER"
    "Allow_osNpcGetPos =               ${OSSL|osslNPC}"
    "Allow_osNpcGetRot =               ${OSSL|osslNPC}"
    "Allow_osNpcLoadAppearance =       ${OSSL|osslNPC}"
    "Allow_osNpcMoveTo =               ${OSSL|osslNPC}"
    "Allow_osNpcMoveToTarget =         ${OSSL|osslNPC}"
    "Allow_osNpcPlayAnimation =        ${OSSL|osslNPC}"
    "Allow_osNpcRemove =               true"
    "Allow_osNpcSaveAppearance =       ${OSSL|osslNPC}"
    "Allow_osNpcSay =                  ${OSSL|osslNPC}"
    "Allow_osNpcSayTo =                ${OSSL|osslNPC}"
    "Allow_osNpcSetRot =               ${OSSL|osslNPC}"
    "Allow_osNpcShout =                ${OSSL|osslNPC}"
    "Allow_osNpcSit =                  ${OSSL|osslNPC}"
    "Allow_osNpcStand =                ${OSSL|osslNPC}"
    "Allow_osNpcStopAnimation =        ${OSSL|osslNPC}"
    "Allow_osNpcStopMoveToTarget =     ${OSSL|osslNPC}"
    "Allow_osNpcTouch =                ${OSSL|osslNPC}"
    "Allow_osNpcWhisper =              ${OSSL|osslNPC}"
    "Allow_osOwnerSaveAppearance =     ${OSSL|osslNPC}"
    "Allow_osParcelJoin =              ESTATE_MANAGER,ESTATE_OWNER"
    "Allow_osParcelSubdivide =         ESTATE_MANAGER,ESTATE_OWNER"
    "Allow_osRegionRestart =           ESTATE_MANAGER,ESTATE_OWNER"
    "Allow_osRegionNotice =            ESTATE_MANAGER,ESTATE_OWNER"
    "Allow_osSetProjectionParams =     ${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER"
    "Allow_osSetRegionWaterHeight =    ESTATE_MANAGER,ESTATE_OWNER"
    "Allow_osSetTerrainHeight =        ESTATE_MANAGER,ESTATE_OWNER"
    "Allow_osSetTerrainTexture =       ESTATE_MANAGER,ESTATE_OWNER"
    "Allow_osSetTerrainTextureHeight = ESTATE_MANAGER,ESTATE_OWNER"
    "Allow_osAgentSaveAppearance =     ESTATE_MANAGER,ESTATE_OWNER"
    "Allow_osAvatarPlayAnimation =     ${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER"
    "Allow_osAvatarStopAnimation =     ${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER"
    "Allow_osForceAttachToOtherAvatarFromInventory = ${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER"
    "Allow_osForceDetachFromAvatar =   ${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER"
    "Allow_osForceOtherSit =           ${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER"
    "Allow_osGetNotecard =             ${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER"
    "Allow_osGetNotecardLine =         ${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER"
    "Allow_osGetNumberOfNotecardLines = ${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER"
    "Allow_osSetRot  =                 ${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER"
    "Allow_osSetParcelDetails =        ${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER"
    "Allow_osGrantScriptPermissions =  ${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER"
    "Allow_osKickAvatar =              ${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER"
    "Allow_osRevokeScriptPermissions = ${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER"
    "Allow_osTeleportAgent =           ${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER"
    "Allow_osTeleportObject =          ${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER"
    "Allow_osSetContentType =          ${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER"
    )
    log rohtext "Alte $osslEnabledatei Datei loeschen falls vorhanden."
    rm -f $osslEnabledatei # || echo "Keine $osslEnabledatei Datei vorhanden."

    log rohtext "$osslEnabledatei schreiben"
    printf '%s\n' "${OsslEnableConfigList[@]}" > $osslEnabledatei

    log rohtext "Tausche Hochstriche aus."
    sed -i -e s/\'/\"/g "$GridCommondatei"
}

#──────────────────────────────────────────────────────────────────────────────────────────
#* Hilfen und Info Funktionsgruppe
#──────────────────────────────────────────────────────────────────────────────────────────

## * show_info
	# Datum: 02.10.2023
	#? Beschreibung: Zeigt eine Informationsmeldung in einem Dialogfenster an.
	#? Parameter:
	#   $1 - Titel des Dialogfensters
	#   $2 - Die anzuzeigende Information
	#? Verwendung:
	#   show_info "Mein Titel" "Dies ist die anzuzeigende Information."
	#? Rückgabewert:
	#   Keiner (void)
##
function show_info() {
	# Der erste Parameter ($1) wird als Titel für das Dialogfenster verwendet.
	# Der zweite Parameter ($2) wird als Nachricht im Dialogfenster angezeigt.
	# Das Dialogfenster ist ein modaler Nachrichten-Dialog (msgbox) ohne Zusammenklappen.
	# Die Größe des Dialogfensters wird automatisch an den Text angepasst (0 0).
	dialog --title "$1" \
		--no-collapse \
		--msgbox "$info" 0 0
}

## * systeminformation
	# Datum: 02.10.2023
	#? Beschreibung: Zeigt verschiedene Systeminformationen in einem Dialogfenster an.
	#? Verwendung:
	#   systeminformation
	#? Rückgabewert:
	#   Keiner (void)
##
function systeminformation() {
	# Definiert die Ausgangsstatuscodes der Dialogfelder
	DIALOG_CANCEL=1
	DIALOG_ESC=255
	HEIGHT=0
	WIDTH=0

	# Zeigt den Menuepunkt mit einer While-Schleife an
	while true; do
		exec 3>&1
		selection=$(dialog \
			--backtitle "opensimMULTITOOL $VERSION Systeminformationen" \
			--title "[Main Menu]" \
			--clear \
			--cancel-label "Exit" \
			--menu "\nPlease select:" $HEIGHT $WIDTH 4 \
			"1" "Display OS Type" \
			"2" "Display CPU Info" \
			"3" "Display Memory Info" \
			"4" "Display HardDisk Info" \
			"5" "Display File System" \
			2>&1 1>&3)
		exit_status=$?
		exec 3>&-

		# Fall, der angezeigt werden soll, wenn das Programm erfolgreich beendet oder das Programm abgebrochen wurde
		case $exit_status in
		"$DIALOG_CANCEL")
			ScreenLog
			#echo "Program exit successfully."
			hauptmenu
			exit
			;;
		"$DIALOG_ESC")
			ScreenLog
			#echo "Program aborted." >&2
			hauptmenu >&2
			exit 1
			;;
		esac

		# Fallauswahl, um Informationen der Benutzer Auswahl anzuzeigen
		case $selection in
		0)
			ScreenLog
			echo "Program exit successfully."
			;;
		1)
			info=$(uname -o)
			show_info "Operating System Type"
			;;
		2)
			info=$(lscpu)
			show_info "CPU Information"
			;;
		3)
			info=$(less /proc/meminfo)
			show_info "Memory Information"
			;;
		4)
			info=$(lsblk)
			show_info "Hard disk Information"
			;;
		5)
			info=$(df)
			show_info "File System (Mounted)"
			;;
		esac
	done
}

## * info
	# Datum: 02.10.2023
	#? Beschreibung: Zeigt Informationen über den Server in einem log-Dateiformat an.
	#? Verwendung:
	#   info
	#? Rückgabewert:
	#   0 - Erfolgreiche Ausführung
##
function info() {
	log rohtext "$(tput setab 4) Server Name: ${HOSTNAME}"
	log rohtext " Bash Version: ${BASH_VERSION}"
	log rohtext " Server IP: ${AKTUELLEIP}"
	log rohtext " MONO THREAD Einstellung: ${MONO_THREADS_PER_CPU}"
	log rohtext " Spracheinstellung: ${LANG} $(tput sgr 0)"
	log rohtext " $(screen --version)"
	who -b
	return 0
}

## * infodialog
	# Datum: 02.10.2023
	#? Beschreibung: Zeigt eine Informationsmeldung in einem Dialogfenster an.
	#? Verwendung:
	#   infodialog
	#? Rückgabewert:
	#   Keiner (void)
##
function infodialog() {
	TEXT1=(" Server Name: ${HOSTNAME}")
	TEXT2=(" Bash Version: ${BASH_VERSION}")
	TEXT3=(" Server IP: ${AKTUELLEIP}")
	TEXT4=(" MONO THREAD Einstellung: ${MONO_THREADS_PER_CPU}")
	TEXT5=(" Spracheinstellung: ${LANG}")
	TEXT0=(" MULTITOOL: wurde gestartet am $(date +%d.%m.%Y) um $(date +%H:%M:%S) Uhr")
	TEXT6=(" $(screen --version)")
	# shellcheck disable=SC2128
	dialog --backtitle "opensimMULTITOOL $VERSION" --msgbox "$TEXT0\n$TEXT1\n$TEXT2\n$TEXT3\n$TEXT4\n$TEXT5\n$TEXT6" 0 0
	# Dialog-Bildschirm loeschen
	dialogclear
	# Bildschirm loeschen
	ScreenLog
	hauptmenu
}

## * kalender
	# Datum: 02.10.2023
	#? Beschreibung: Zeigt einen Kalender in einem Dialogfenster an und ermöglicht die Auswahl eines Datums.
	#? Verwendung:
	#   kalender
	#? Rückgabewert:
	#   Keiner (void)
##
function kalender() {
	HEIGHT=0
	WIDTH=0
	TITLE="opensimMULTITOOL $VERSION"

	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then

		TDATUM=$(date +%d)
		MDATUM=$(date +%m)
		JDATUM=$(date +%Y)
		# dialog --calendar

		DATUMERGEBNIS=$(dialog --calendar "calendar" $HEIGHT $WIDTH "$TDATUM" "$MDATUM" "$JDATUM" 3>&1 1>&2 2>&3) # Unbekannter Fehler

		dialogclear
		ScreenLog

		# Zeilen aus einer Variablen zerlegen und in verschiedenen Variablen schreiben.
		NEWDATUM=$(echo "$DATUMERGEBNIS" | sed -n '1p' | sed 's/\//./g') # erste zeile aus DATUMERGEBNIS nehmen und die Schraegstriche gegen ein leerzeichen austauschen.

		warnbox "Ihr gewaehltes Datum: $NEWDATUM" || hauptmenu

		#hauptmenu
	else
		# wenn dialog nicht installiert ist die Hilfe anzeigen.
		hilfe
	fi
}

## * robustbackup
	# Datum: 02.10.2023
	#? Beschreibung: Ermöglicht dem Benutzer die Auswahl eines Datums für ein robustes Backup und speichert das ausgewählte Datum in einer temporären Datei.
	#? Verwendung:
	#   robustbackup
	#? Rückgabewert:
	#   Keiner (void)
##
function robustbackup() {
	HEIGHT=0
	WIDTH=0
	TITLE="opensimMULTITOOL $VERSION"

	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then

		TDATUM=$(date +%d)
		MDATUM=$(date +%m)
		JDATUM=$(date +%Y)
		# dialog --calendar

		DATUMERGEBNIS=$(dialog --calendar "calendar" $HEIGHT $WIDTH "$TDATUM" "$MDATUM" "$JDATUM" 3>&1 1>&2 2>&3) # Unbekannter Fehler

		dialogclear
		ScreenLog

		# Zeilen aus einer Variablen zerlegen und in verschiedenen Variablen schreiben.
		NEWDATUM=$(echo "$DATUMERGEBNIS" | sed -n '1p' | sed 's/\//./g') # erste zeile aus DATUMERGEBNIS nehmen und die Schraegstriche gegen ein leerzeichen austauschen.

		#warnbox "Ihr gewaehltes Datum: $NEWDATUM" || hauptmenu
		echo "$NEWDATUM" >/tmp/backup.tmp

		#hauptmenu
	else
		# wenn dialog nicht installiert ist die Hilfe anzeigen.
		hilfe
	fi

	#mysqlrest "$username" "$password" "$databasename" "SHOW TABLES FROM $databasename"
	#warnbox "$result_mysqlrest"
}

## * backupdatum
	# Datum: 02.10.2023
	#? Beschreibung: Überprüft, ob eine Datei mit einem Backup-Datum vorhanden ist, vergleicht das Datum mit dem aktuellen Datum und führt entsprechende Aktionen basierend auf dem Vergleich aus.
	#? Verwendung:
	#   backupdatum
	#? Rückgabewert:
	#   Keiner (void)
## 
function backupdatum() {
	# Ist die Datei backup.tmp vorhanden?
	if [ -f /tmp/backup.tmp ]; then log rohtext "Datei ist vorhanden!"; fi
	# Beispiel Text in der backup.tmp Datei - 30.06.2022

	# Heutiges Datum steht in $DATUM
	log rohtext "Heute ist der: $DATUM"

	BACKUPDATUM=()
	while IFS= read -r line; do BACKUPDATUM+=("$line"); done </tmp/backup.tmp
	myDATUM=$(echo "${BACKUPDATUM[@]}" | sed -n '1p')

	if [ "$myDATUM" = "$DATUM" ]; then log rohtext "Datum ist gleich! $myDATUM - $DATUM"; fi
	if [ ! "$myDATUM" = "$DATUM" ]; then log rohtext "Datum ist nicht gleich! $myDATUM - $DATUM"; fi

	# Wenn das Datum gleich ist Grid herunterfahren.
	# Backup der Griddatenbank machen.
	#mysqldump -u root -p omlgrid assets > AssetService.sql
	# Grid wieder hochfahren.

	# Wenn Datum ungleich Grid restarten.

	return 0
}

## *  osreparatur
	# Datum: 08.10.2023
	#! Test für OpenSim 0.9.3 es ist nicht funktionsfähig!!!!!
	#? Beschreibung: 
	# Dieses Skript bietet Optionen zur Reparatur einer OpenSim-Umgebung.
	#? Parameter: Keine
	#
	#? Verwendung:
	#   osreparatur
	#? Rückgabewert:
	#   Keiner (void)
##
function osreparatur() {
    #! Test für OpenSim 0.9.3 es ist nicht funktionsfähig!!!!!
	log info "*** Reperatur Funktion ***"

	echo " 1 Haben sie Probleme mit den Datenbanken? - STATUS funktioniert!"
	echo " 2 Haben sie Probleme nach dem letzten upgrade? - STATUS ungetestet"
	echo " 3 Sind die Probleme ohne upgrade aufgetaucht? - STATUS ungetestet"
	echo " 4 Sind die Probleme ohne upgrade aufgetaucht aber auswahl 3 brachte nicht das erwünschte ergebnis? - STATUS ungetestet"
	read -r osrauswahl

# Fallauswahl
case $osrauswahl in
  1) 
  	#Alle Datenbanken Prüfen und Reparieren. - STATUS funktioniert!
	cd /$STARTVERZEICHNIS || exit
    allrepair_db; 
    log info "Alle Datenbanken Checken, Reparieren und Optimieren beendet."
    ;;
  2)
	# rename opensim -> opensim-def und opensim1 -> opensim dann upgrade.
	cd /$STARTVERZEICHNIS || exit
	mv opensim opensim-def
	mv opensim1 opensim
	osupgrade93
	log info "Upgrade beendet."
    ;;
  3)
	# opensim auffrischung.
	# cd /$STARTVERZEICHNIS/opensim || exit
    # git pull
	cd /$STARTVERZEICHNIS || exit
	osbuildingupgrade93
	log info "Upgrade beendet."
    ;;
  4)
    # Rename opensim -> opensim-def dann download eine Reguläre opensim Version und upgrade.
	mv opensim opensim-def
	oscompi93
	cd /$STARTVERZEICHNIS || exit
	mv opensim93 opensim
	log info "Die Reparatur ist beendet."
    ;;
  *)
    log info "Ungültige Eingabe. Bitte wählen Sie einen Punkt von 1 bis 4."
    ;;
esac
}

## *  senddata
	# Datum: 02.10.2023
	#? Beschreibung: Komprimiert ein Verzeichnis und sendet es an einen anderen Server im gleichen Verzeichnis unter Verwendung von rsync.
	#? Parameter:
	#   $1 - Benutzername für den Zielserver
	#   $2 - Das zu sendende Verzeichnis auf dem lokalen Server
	#   $3 - Die IP-Adresse oder Hostname des Ziel-Servers
	#? Verwendung:
	#   senddata "Benutzername" "/Pfad/zum/Verzeichnis" "Server-IP-Adresse"
	#? Rückgabewert:
	#   Keiner (void)
##
function senddata() {
	USERNAMEN=$1
	SENDEVERZEICHNIS=$2	
	SERVERADRESS=$3
	
	#? Beispiel:
	# SENDEVERZEICHNIS="/$STARTVERZEICHNIS/backup"
	# USERNAMEN="root"
	# SERVERADRESS="192.168.2.100"

	log rohtext " Ganzes Verzeichnis komprimiert an neuen Server im gleichen Verzeichnis senden."

	# Ganzes Verzeichnis(-r) komprimiert(-C) an neuen Server senden.
	#scp -r -C "$SENDEVERZEICHNIS" "$USERNAMEN"@"$SERVERADRESS":"$SENDEVERZEICHNIS"

	# --ignore-existing Ignoriert schon vorhandene Daten.
	# -r Rekursiv das heist alle Unterverzeichnisse werden samt Daten mitkopiert.
	# -v Anzeigen was gerade passiert.
	# -z Komprimierung bei der übertragung aktivieren.
	#rsync --ignore-existing -rvz "$SENDEVERZEICHNIS" "$USERNAMEN"@"$SERVERADRESS":"$SENDEVERZEICHNIS"
	# Trockenübung
	rsync --ignore-existing -rvzn "$SENDEVERZEICHNIS" "$USERNAMEN"@"$SERVERADRESS":"$SENDEVERZEICHNIS"

	return 0
}

## * fortschritsanzeige
	# Datum: 02.10.2023
	#? Beschreibung: Zeigt eine Fortschrittsanzeige mit einem Ladebalken mithilfe von Dialog.
	#? Verwendung:
	#   fortschritsanzeige
	#? Rückgabewert:
	#   Keiner (void)
##
function fortschritsanzeige() {
	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then

		dialogtext="Bitte warten!"

		# dialog --gauge eine Fortschritsanzeige
		for i in $(seq 0 10 100); do
			sleep 1
			echo "$i" | dialog --gauge "$dialogtext" 10 70 0
		done

	else
		# wenn dialog nicht installiert ist die Hilfe anzeigen.
		hilfe
	fi
}


## * menuinfo
	# Datum: 02.10.2023
	#? Beschreibung: Zeigt Informationen über den Server, das System und aktive Bildschirmsitzungen in einem Dialogfenster an.
	#? Verwendung:
	#   menuinfo
	#? Rückgabewert:
	#   Keiner (void)
##
function menuinfo() {
	menuinfoergebnis=$(screen -ls | sed '1d' | sed '$d' | awk -F. '{print $2}' | awk -F\( '{print $1}')

	infoboxtext=""
	infoboxtext+=" Es ist der $(date +%d.%m.%Y) um $(date +%H:%M:%S) Uhr\n"
	infoboxtext+=" Server Name: ${HOSTNAME}\n"
	infoboxtext+=" Bash Version: ${BASH_VERSION}\n"
	infoboxtext+=" Server IP: ${AKTUELLEIP}\n"
	infoboxtext+=" MONO THREAD Einstellung: ${MONO_THREADS_PER_CPU}\n"
	infoboxtext+=" Spracheinstellung: ${LANG}\n"
	infoboxtext+=" $(screen --version)\n"
	infoboxtext+=" Letzter$(who -b)\n\n"
	infoboxtext+=" Aktuell laeuft im Moment:\n"
	infoboxtext+=" __________________________________________________________\n"
	infoboxtext+="$menuinfoergebnis"

	dialog --msgbox "$infoboxtext" 20 65
	dialogclear
	hauptmenu

	return 0
}

## * menukonsolenhilfe
	# Datum: 02.10.2023
	#? Beschreibung: Zeigt die Konsolenhilfe in einem Dialogfenster an.
	#? Verwendung:
	#   menukonsolenhilfe
	#? Rückgabewert:
	#   Keiner (void)
##
function menukonsolenhilfe() {
	#helpergebnis=$(help)
	#dialog --msgbox "Konsolenhilfe:\n $helpergebnis" 50 75; dialogclear

	help >help.txt
	dialog --textbox "help.txt" 55 85
	dialogclear

	hauptmenu
	return 0
}

## * dotnetinfo
	# Datum: 02.10.2023
	#? Beschreibung: Zeigt Informationen zu den verschiedenen Versionen von .NET und den zugehörigen C#-Sprachversionen.
	#? Verwendung:
	#   dotnetinfo
	#? Rückgabewert:
	#   Keiner (void)
##
function dotnetinfo() {
	echo "dotNET-7.x = C# 11"
	echo "dotNET-6.x = C# 10"
	echo "dotNET-5.x = C# 9.0"
	echo "dotNET Core-3.x = C# 8.0"
	echo "dotNET Core-2.x = C# 7.3"
	echo "dotNET-Standard-2.1 = C# 8.0"
	echo "dotNET-Standard-2.0 = C# 7.3"
	echo "dotNET-Standard-1.x = C# 7.3"
	echo "dotNET Framework-alle = C# 7.3"
}

## * dbhilfe
	# Datum: 02.10.2023
	#? Beschreibung: Zeigt eine Liste von mySQL - mariaDB Befehlen und deren Erklärungen für den Umgang mit Datenbanken.
	#? Verwendung:
	#   dbhilfe
	#? Rückgabewert:
	#   Keiner (void)
##
function dbhilfe() {
	echo "$(tput setab 1)mySQL - mariaDB Befehle ACHTUNG! Sie muessen hier fuer die Grundlagen von SQL beherschen. $(tput sgr 0)"
	echo "DO_DOMAIN_IDS	- $(tput setab 5)username password ids$(tput sgr 0) – CHANGE MASTER TO DO DOMAIN IDS."
	echo "DO_DOMAIN_IDS2_nids	- $(tput setab 5)username password$(tput sgr 0) – CHANGE MASTER TO DO DOMAIN IDS = ()."
	echo "IGNORE_DOMAIN_IDS	- $(tput setab 5)username password ids$(tput sgr 0) – CHANGE MASTER TO IGNORE DOMAIN IDS."
	echo "IGNORE_DOMAIN_IDS2_nids	- $(tput setab 5)username password$(tput sgr 0) – CHANGE MASTER TO IGNORE DOMAIN IDS = ()."
	echo "IGNORE_SERVER_IDS	- $(tput setab 5)username password ids$(tput sgr 0) – CHANGE MASTER TO IGNORE SERVER IDS."
	echo "MASTER_CONNECT_RETRY	- $(tput setab 5)username password MASTERCONNECTRETRY$(tput sgr 0) – CHANGE MASTER TO MASTER CONNECT RETRY=MASTERCONNECTRETRY."	
	echo "MASTER_DELAY	- $(tput setab 5)Parameter$(tput sgr 0) – Use the MASTER_DELAY option for CHANGE MASTER TO to set the delay to N seconds."
	echo "MASTER_HOST	- $(tput setab 5)Parameter$(tput sgr 0) – CHANGE MASTER TO ist nützlich zum Einrichten eines Replikats."
	echo "MASTER_LOG_FILE	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "MASTER_LOG_POS	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "MASTER_PASSWORD	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "MASTER_PORT	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "MASTER_SSL	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "MASTER_SSL_CA	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "MASTER_SSL_CAPATH	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "MASTER_SSL_CERT	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "MASTER_SSL_CIPHER	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "MASTER_SSL_CRL	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "MASTER_SSL_CRLPATH	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "MASTER_SSL_KEY	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "MASTER_SSL_VERIFY_SERVER_CERT	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "MASTER_USER	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "MASTER_USE_GTID	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "MASTER_USE_GTID_slv	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "RELAY_LOG_FILE	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "RELAY_LOG_POS	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "Replica_Backup	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "Replica_Backup_nmlp	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."	
	echo "ReplikatKoordinaten	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "db_all_name	- $(tput setab 5)Parameter$(tput sgr 0) – Alle Benutzernamen des Grids anzeigen."
	echo "db_all_name_dialog	- $(tput setab 5)Parameter$(tput sgr 0) – Alle Benutzernamen des Grids anzeigen."
	echo "db_all_user	- $(tput setab 5)Parameter$(tput sgr 0) – Daten von allen Benutzern anzeigen."
	echo "db_all_user_dialog	- $(tput setab 5)Parameter$(tput sgr 0) – Daten von allen Benutzern anzeigen."
	echo "db_all_userfailed	- $(tput setab 5)Parameter$(tput sgr 0) – -1 Daten von allen Benutzern anzeigen."
	echo "db_all_uuid	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "db_all_uuid_dialog	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "db_anzeigen_dialog	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "db_backup	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "db_backuptabellentypen	- $(tput setab 5)username password databasename(tput sgr 0) – Asset Datenbank Tabelle geteilt in Typen speichern."
	echo "db_benutzer_anzeigen	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "db_compress_backup	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "db_create	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "db_create_new_dbuser	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "db_dbuser	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "db_dbuserrechte	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "db_deldbuser	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "db_delete	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "db_deletepartner	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "db_email_setincorrectuseroff	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "db_email_setincorrectuseroff_dialog	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "db_empty	- $(tput setab 5)Parameter$(tput sgr 0) – loescht eine Datenbank und erstellt diese anschliessend neu."
	echo "db_false_email	- $(tput setab 5)Parameter$(tput sgr 0) – Finde offensichtlich falsche E-Mail Adressen der User."
	echo "db_foldertyp_user	- $(tput setab 5)username password databasename firstname lastname foldertyp$(tput sgr 0) – Alles vom inventoryfolders type des User anzeigen."
	echo "db_friends	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "db_gridlist	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "db_inv_search	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "db_inventar_no_assets	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "db_online	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "db_region	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "db_region_anzahl_regionsid	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "db_region_anzahl_regionsnamen	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "db_region_parzelle	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "db_region_parzelle_pakete	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "db_regions	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "db_regionsport	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "db_regionsuri	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "db_restorebackuptabellen2test	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "db_restoretabellentypen	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "db_setpartner	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "db_setuserofline	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "db_setuserofline_dialog	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "db_setuseronline	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "db_setuseronline_dialog	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "db_tables	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "db_tables_dialog	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "db_tablextract_regex	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "db_user_anzahl	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "db_user_data	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "db_user_data_dialog	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "db_user_infos	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "db_user_infos_dialog	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "db_user_online	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "db_user_uuid	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "db_user_uuid_dialog	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "db_userdate	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "connection_name	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
}

## * hilfe.
	# Hilfe auf dem Bildschirm anzeigen.
	# 
	#? @param name Erklaerung.
	#? @return name was wird zurueckgegeben.
	# todo: nichts.
##  
function hilfe() {
	echo "$(tput setab 5)Funktion:$(tput sgr 0)		$(tput setab 2)Parameter:$(tput sgr 0)		$(tput setab 4)Informationen:$(tput sgr 0)"
	echo "hilfe 			- $(tput setaf 3)hat keine Parameter$(tput sgr 0)	- Diese Hilfe."
	echo "konsolenhilfe 		- $(tput setaf 3)hat keine Parameter$(tput sgr 0)	- konsolenhilfe ist eine Hilfe fuer Putty oder Xterm"
	echo "commandhelp 		- $(tput setaf 3)hat keine Parameter$(tput sgr 0)	- Die OpenSim Commands."
	echo "RobustCommands 		- $(tput setaf 3)hat keine Parameter$(tput sgr 0)	- Die Robust Commands."
	echo "OpenSimCommands 		- $(tput setaf 3)hat keine Parameter$(tput sgr 0)	- Die OpenSim Commands."
	echo "MoneyServerCommands 		- $(tput setaf 3)hat keine Parameter$(tput sgr 0)	- Die MoneyServer Commands."
	echo "dbhilfe 			- $(tput setaf 3)hat keine Parameter$(tput sgr 0)	- Datenbankhilfe auf dem Bildschirm anzeigen."
	echo "restart 		- $(tput setaf 3)hat keine Parameter$(tput sgr 0)	- Startet das gesamte Grid neu."
	echo "autostop 		- $(tput setaf 3)hat keine Parameter$(tput sgr 0)	- Stoppt das gesamte Grid."
	echo "autostart 		- $(tput setaf 3)hat keine Parameter$(tput sgr 0)	- Startet das gesamte Grid."
	echo "works 			- $(tput setab 5)Verzeichnisname$(tput sgr 0)	- Einzelne screens auf Existenz pruefen."
	echo "osstart 		- $(tput setab 5)Verzeichnisname$(tput sgr 0)	- Startet einen einzelnen Simulator."
	echo "osstop 			- $(tput setab 5)Verzeichnisname$(tput sgr 0)	- Stoppt einen einzelnen Simulator."
	echo "meineregionen 		- $(tput setaf 3)hat keine Parameter$(tput sgr 0)   - listet alle Regionen aus den Konfigurationen auf."
	echo "autologdel		- $(tput setaf 3)hat keine Parameter$(tput sgr 0)	- Loescht alle Log Dateien."
	echo "automapdel		- $(tput setaf 3)hat keine Parameter$(tput sgr 0)	- Loescht alle Map Karten."
	echo "newregionini		- $(tput setaf 4)hat Abfragen$(tput sgr 0)-Erstellt eine neue Regions.ini in ein Regions Verzeichnis."

	echo "$(tput setab 3)Erweiterte Funktionen$(tput sgr 0)"
	echo "regionbackup 		- $(tput setab 5)Verzeichnisname$(tput sgr 0) $(tput setab 4)Regionsname$(tput sgr 0) - Backup einer ausgewaehlten Region."
	echo "assetdel 		- $(tput setab 5)screen_name$(tput sgr 0) $(tput setab 4)Regionsname$(tput sgr 0) $(tput setab 2)Objektname$(tput sgr 0) - Einzelnes Asset loeschen."
	echo "oscommand 		- $(tput setab 5)Verzeichnisname$(tput sgr 0) $(tput setab 3)Region$(tput sgr 0) $(tput setab 4)Konsolenbefehl Parameter$(tput sgr 0) - Konsolenbefehl senden."
	echo "gridstart 		- $(tput setaf 3)hat keine Parameter$(tput sgr 0) - Startet Robust und Money. "
	echo "gridstop 		- $(tput setaf 3)hat keine Parameter$(tput sgr 0) - Beendet Robust und Money. "
	echo "rostart 		- $(tput setaf 3)hat keine Parameter$(tput sgr 0) - Startet Robust Server."
	echo "rostop 			- $(tput setaf 3)hat keine Parameter$(tput sgr 0) - Stoppt Robust Server."
	echo "mostart 		- $(tput setaf 3)hat keine Parameter$(tput sgr 0) - Startet Money Server."
	echo "mostop 			- $(tput setaf 3)hat keine Parameter$(tput sgr 0) - Stoppt Money Server."
	echo "autosimstart 		- $(tput setaf 3)hat keine Parameter$(tput sgr 0) - Startet alle Regionen."
	echo "autosimstop 		- $(tput setaf 3)hat keine Parameter$(tput sgr 0) - Beendet alle Regionen. "
	echo "autoscreenstop		- $(tput setaf 3)hat keine Parameter$(tput sgr 0) - Killt alle OpenSim Screens."
	echo "logdel 			- $(tput setab 5)Verzeichnisname$(tput sgr 0)     - Loescht alle Simulator Log Dateien im Verzeichnis."
	echo "mapdel 			- $(tput setab 5)Verzeichnisname$(tput sgr 0)     - Loescht alle Simulator Map-Karten im Verzeichnis."
	echo "settings 		- $(tput setaf 3)hat keine Parameter$(tput sgr 0) - setzt Linux Einstellungen."
	echo "configlesen 		- $(tput setab 5)Verzeichnisname$(tput sgr 0)     - Alle Regionskonfigurationen im Verzeichnis anzeigen."

	echo "$(tput setab 1)Experten Funktionen$(tput sgr 0)"
	echo "osupgrade 		- $(tput setaf 3)hat keine Parameter$(tput sgr 0) - Installiert eine neue OpenSim Version."
	echo "autoregionbackup	- $(tput setaf 3)hat keine Parameter$(tput sgr 0) - Backup aller Regionen."
	echo "oscopy			- $(tput setab 5)Verzeichnisname$(tput sgr 0)     - Kopiert den Simulator."
	echo "osstruktur		- $(tput setab 5)ersteSIM$(tput sgr 0) $(tput setab 4)letzteSIM$(tput sgr 0)  - Legt eine Verzeichnisstruktur an."
	echo "setversion		- $(tput setab 2)Versionsnummer$(tput sgr 0)      - Aendert die Versionseinstellungen 0.9.2.XXXX"
	echo "compilieren 		- $(tput setaf 3)hat keine Parameter$(tput sgr 0) - Kopiert fehlende Dateien und Kompiliert."
	echo "oscompi 		- $(tput setaf 3)hat keine Parameter$(tput sgr 0) - Kompiliert einen neuen OpenSimulator ohne kopieren."
	echo "scriptcopy 		- $(tput setaf 3)hat keine Parameter$(tput sgr 0) - Kopiert die Scripte in den Source."
	echo "moneycopy 		- $(tput setaf 3)hat keine Parameter$(tput sgr 0) - Kopiert Money Source in den OpenSimulator Source."
	echo "osdelete 		- $(tput setaf 3)hat keine Parameter$(tput sgr 0) - Loescht alte OpenSim Version."
	echo "regionsiniteilen 	- $(tput setab 5)Verzeichnisname$(tput sgr 0) $(tput setab 3)Region$(tput sgr 0) - kopiert aus der Regions.ini eine Region heraus."
	echo "autoregionsiniteilen 	- $(tput setaf 3)hat keine Parameter$(tput sgr 0) - aus allen Regions.ini alle Regionen vereinzeln."
	echo "regionliste 		- $(tput setaf 3)hat keine Parameter$(tput sgr 0) - Die osmregionlist.ini erstellen."
	echo "Regionsdateiliste 	- $(tput setab 4)-b Bildschirm oder -d Datei$(tput sgr 0) $(tput setab 5)Verzeichnisname$(tput sgr 0) - Regionsdateiliste erstellen."
	echo "osgitholen 		- $(tput setaf 3)hat keine Parameter$(tput sgr 0) - kopiert eine OpenSimulator Git Entwicklerversion."
	echo "terminator 		- $(tput setaf 3)hat keine Parameter$(tput sgr 0) - Killt alle laufenden Screens."

	echo "$(tput setab 1)Ungetestete oder zu testende Funktionen$(tput sgr 0)"
	echo "osgridcopy		- $(tput setaf 3)hat keine Parameter$(tput sgr 0) - Automatisches kopieren aus dem opensim Verzeichniss."
	echo "makeaot			- $(tput setaf 3)hat keine Parameter$(tput sgr 0) - aot Dateien erstellen."
	echo "cleanaot		- $(tput setaf 3)hat keine Parameter$(tput sgr 0) - aot Dateien entfernen."
	echo "monoinstall		- $(tput setaf 3)hat keine Parameter$(tput sgr 0) - mono 6.x installation."
	echo "installationen		- $(tput setaf 3)hat keine Parameter$(tput sgr 0) - Linux Pakete - installationen aufisten."
	echo "serverinstall		- $(tput setaf 3)hat keine Parameter$(tput sgr 0) - alle benoetigten Linux Pakete installieren."
	echo "osbuilding		- $(tput setab 5)Versionsnummer$(tput sgr 0) - Upgrade des OpenSimulator aus einer Source ZIP Datei."
	echo "createuser 		- $(tput setab 5) Vorname $(tput sgr 0) $(tput setab 4) Nachname $(tput sgr 0) $(tput setab 2) Passwort $(tput sgr 0) $(tput setab 3) E-Mail $(tput sgr 0) - Grid Benutzer anlegen."
	log line
	echo "db_anzeigen	- $(tput setab 5) DBBENUTZER $(tput sgr 0) $(tput setab 4) DBDATENBANKNAME $(tput sgr 0) - Alle Datenbanken anzeigen."
	echo "create_db	- $(tput setab 5) DBBENUTZER $(tput sgr 0) $(tput setab 4) DBPASSWORT $(tput sgr 0) $(tput setab 2) DATENBANKNAME $(tput sgr 0) - Datenbank anlegen."
	#echo "create_db_user	- $(tput setab 5) DBBENUTZER $(tput sgr 0) $(tput setab 4) DBDATENBANKNAME $(tput sgr 0) $(tput setab 2) NEUERNAME $(tput sgr 0) $(tput setab 3) NEUESPASSWORT $(tput sgr 0) - DB Benutzer anlegen."
	echo "delete_db	- $(tput setab 5) DBBENUTZER $(tput sgr 0) $(tput setab 4) DBPASSWORT $(tput sgr 0) $(tput setab 2) DATENBANKNAME $(tput sgr 0) - Datenbank loeschen."
	# ? echo "leere_db	- $(tput setab 5) DBBENUTZER $(tput sgr 0) $(tput setab 4) DBPASSWORT $(tput sgr 0) $(tput setab 2) DATENBANKNAME $(tput sgr 0) - Datenbank leeren."
	echo "allrepair_db	- $(tput setab 5) DBBENUTZER $(tput sgr 0) $(tput setab 4) DBPASSWORT $(tput sgr 0) - Alle Datenbanken Reparieren und Optimieren."
	# ? echo "db_sichern	- $(tput setab 5) DBBENUTZER $(tput sgr 0) $(tput setab 4) DBPASSWORT $(tput sgr 0) $(tput setab 2) DATENBANKNAME $(tput sgr 0) - Datenbank sichern."
	echo "mysql_neustart	- $(tput setaf 3)hat keine Parameter$(tput sgr 0) - MySQL neu starten."

	echo "regionsabfrage	- $(tput setab 5) DBBENUTZER $(tput sgr 0) $(tput setab 4) DBPASSWORT $(tput sgr 0) $(tput setab 2) DATENBANKNAME $(tput sgr 0) - Regionsliste."
	echo "regionsuri	- $(tput setab 5) DBBENUTZER $(tput sgr 0) $(tput setab 4) DBPASSWORT $(tput sgr 0) $(tput setab 2) DATENBANKNAME $(tput sgr 0) - URI pruefen sortiert nach URI."
	echo "regionsport	- $(tput setab 5) DBBENUTZER $(tput sgr 0) $(tput setab 4) DBPASSWORT $(tput sgr 0) $(tput setab 2) DATENBANKNAME $(tput sgr 0) - Ports pruefen sortiert nach Ports."

	echo "opensimholen	- $(tput setaf 3)hat keine Parameter$(tput sgr 0) - Laedt eine Regulaere OpenSimulator Version herunter."
	echo "mysqleinstellen	- $(tput setaf 3)hat keine Parameter$(tput sgr 0) - mySQL Konfiguration auf Server Einstellen und neu starten."
	echo "conf_write	- $(tput setab 5) SUCHWORT $(tput sgr 0) $(tput setab 4) ERSATZWORT $(tput sgr 0) $(tput setab 2) PFAD $(tput sgr 0) $(tput setab 3) DATEINAME $(tput sgr 0) - Konfigurationszeile schreiben."
	echo "conf_delete	- $(tput setab 5) SUCHWORT $(tput sgr 0) $(tput setab 4) PFAD $(tput sgr 0) $(tput setab 2) DATEINAME $(tput sgr 0) - Konfigurationszeile loeschen."
	echo "conf_read	- $(tput setab 5) SUCHWORT $(tput sgr 0) $(tput setab 4) PFAD $(tput sgr 0) $(tput setab 2) DATEINAME $(tput sgr 0) - Konfigurationszeile lesen."
	echo "landclear 	- $(tput setab 5)screen_name$(tput sgr 0) $(tput setab 4)Regionsname$(tput sgr 0) - Land clear - Loescht alle Parzellen auf dem Land."

	log line
	echo "db_tablesplitt - $(tput setab 5) /Pfad/SQL_Datei.sql $(tput sgr 0) Alle Tabellen aus SQL Sicherung in ein gleichnamigen Verzeichnis extrahieren."
	echo "db_tablextract - $(tput setab 5) /Pfad/SQL_Datei.sql $(tput setab 4) Tabellenname $(tput sgr 0) Einzelne Tabelle aus SQL Backup extrahieren."
	echo " "
	echo "db_backuptabellen - $(tput setab 5)username $(tput setab 4)password $(tput setab 3)databasename $(tput sgr 0) Backup eine Datenbanken Tabellenweise speichern."
	echo "db_restorebackuptabellen - $(tput setab 5)username $(tput setab 4)password $(tput setab 3)databasename $(tput setab 2)newdatabasename $(tput sgr 0) Restore Datenbank Tabellenweise wiederherstellen."

	log line
	echo "loadinventar - $(tput setab 5)NAME VERZEICHNIS PASSWORD DATEINAMEmitPFAD $(tput sgr 0) - laedt Inventar aus einer iar"
	echo "saveinventar - $(tput setab 5)NAME VERZEICHNIS PASSWORD DATEINAMEmitPFAD $(tput sgr 0) - speichert Inventar in einer iar"

	# ? echo "unlockexample	- $(tput setaf 3)hat keine Parameter$(tput sgr 0) - Benennt alle example Dateien um."

	echo "passwdgenerator - $(tput setab 5)Passwortstaerke$(tput sgr 0) - Generiert ein Passwort zur weiteren verwendung."
	echo "AutoInstall	- $(tput setab 5)hat keine Parameter$(tput sgr 0) – Grundinstallation ihreres Servers."	
	echo "ConfigSet	- $(tput setab 5)Datei$(tput sgr 0) – Reduziert die Konfigurationsdateien auf ein uebersichtliches Mass."
	
	echo "ScreenLog	- $(tput setab 5)ScreenLogLevel 1 bis 5$(tput sgr 0) – ScreenLog Bildschirmausgabe reduzieren."	
	echo "accesslog	- $(tput setaf 3)hat keine Parameter$(tput sgr 0) – access log anzeigen."	
	echo "allclean	- $(tput setab 5)Verzeichnis$(tput sgr 0) – loescht Log, dll, so, exe, aot Dateien fuer einen saubere neue installation, ohne Robust."	
	echo "apacheerror	- $(tput setaf 3)hat keine Parameter$(tput sgr 0) – php log anzeigen."	
	echo "assetcachedel	- $(tput setab 5)Verzeichnis$(tput sgr 0) – loescht die asset cache Dateien."	
	echo "authlog	- $(tput setaf 3)hat keine Parameter$(tput sgr 0) – auth log anzeigen."	
	echo "autoallclean	- $(tput setaf 3)hat keine Parameter$(tput sgr 0) – loescht Log, dll, so, exe, aot Dateien fuer einen saubere neue installation, mit Robust."	
	echo "autoassetcachedel	- $(tput setaf 3)hat keine Parameter$(tput sgr 0) – automatisches loeschen aller asset cache Dateien."	
	echo "autorestart	- $(tput setab 5)LOGDELETE yes no$(tput sgr 0) – startet das gesamte Grid neu und loescht die log Dateien."

	log line
	echo "autorobustmapdel - $(tput setab 5)keine Parameter$(tput sgr 0) – automatisches loeschen aller Map/Karten Dateien in Robust."	
	echo "avatarmenu	- $(tput setab 5)keine Parameter$(tput sgr 0) – aufruf Avatar Menue."	
	echo "backupdatum	- $(tput setab 5)Parameter$(tput sgr 0) – robustbackup Grid Datenbank sichern. Datum auswerten."	
	echo "buildmenu	- $(tput setab 5)Parameter$(tput sgr 0) – aufruf Build Menue."	
	echo "checkfile	- $(tput setab 5)pfad name$(tput sgr 0) – pruefen ob Datei vorhanden ist."	
	#echo "chrisoscopy	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."	
	echo "cleaninstall	- $(tput setab 5)keine Parameter$(tput sgr 0) – loeschen aller externen addon Module."	
	echo "clearuserlist	- $(tput setab 5)keine Parameter$(tput sgr 0) – Alle Besucherlisten loeschen."	
	echo "compilieren	- $(tput setab 5)keine Parameter$(tput sgr 0) – kompilieren des OpenSimulator."	
	echo "configabfrage	- $(tput setab 5)Abfragen$(tput sgr 0) – Konfigurationen und Verzeichnisstrukturen anlegen."
	echo "constconfig	- $(tput setab 5)11Parameter$(tput sgr 0) – const.ini schreiben."	
	echo "createdatabase	- $(tput setab 5)DBNAME DBUSER DBPASSWD$(tput sgr 0) – Andere Art Datenbanken und Benutzer anzulegen."	
	echo "createdbuser	- $(tput setab 5)ROOTUSER ROOTPASSWD NEWDBUSER NEWDBPASSWD$(tput sgr 0) – Datenbankbenutzer erstellen."	
	echo "createmasteravatar	- $(tput setab 5)FIRSTNAMEMASTER LASTNAMEMASTER PASSWDNAMEMASTER EMAILNAMEMASTER UUIDNAMEMASTER MODELNAMEMASTER$(tput sgr 0) – Master Avatar erstellen."
	echo "createregionavatar	- $(tput setab 5)FIRSTNAMEMASTER LASTNAMEMASTER ESTATENAMEMASTE$(tput sgr 0) – Besitzerrechte und estate eintragen."	
	echo "dateimenu	- $(tput setab 5)keine Parameter$(tput sgr 0) – Dateimenue oeffnen."	
	echo "dialogclear	- $(tput setab 5)keine Parameter$(tput sgr 0) – Dialog loeschen."

	log line	
	echo "dotnetinfo	- $(tput setab 5)keine Parameter$(tput sgr 0) – .NET und CSharp Informationen."

	echo "downloados	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "edittextbox	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "ende	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "expertenmenu	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "fail2banset	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "fehler	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "finstall	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "firstinstallation	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "flotsamconfig	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "fortschritsanzeige	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "fpspeicher	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "functionslist	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "funktionenmenu	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "get_regionsarray	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "get_value_from_Region_key	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "gridcachedelete	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "hauptmenu	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "hilfeall	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "hilfemenu	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "historylogclear	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "iinstall	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "iinstallnew	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "info	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "infodialog	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "install_mysqltuner	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "installationhttps22	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "linuxupgrade	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "installfinish	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "installmariadb18	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "installmariadb22	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "installopensimulator	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "installphpmyadmin	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "installubuntu22	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "installwordpress	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "instdialog	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "iptablesset	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "kalender	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "lastrebootdatum	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "linuxupgrade	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "log	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "makeregionsliste	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "makeverzeichnisliste	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "makewebmaps	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "mariadberror	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."

	echo "moneyconfig	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "moneycopy	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "moneydelete	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "moneygitcopy	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "monoinstall18	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "monoinstall20	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "monoinstall22	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "mutelistcopy	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "mySQLmenu	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "mysqlbackup	- $(tput setab 5)username password databasename$(tput sgr 0) – Funktion zum sichern von mySQL Datensaetzen."
	echo "mysqldberror	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "mysqlrest	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "mysqlrestnodb	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "nachrichtbox	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "namen	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "oscompi	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "osconfigstruktur	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "oscopy	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "oscopyrobust	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "oscopysim	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "osdauerstart	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "osdauerstop	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "osdelete	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "osdowngrade	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "osmtoolconfig	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "osmtoolconfigabfrage	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "setversion	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "osscreenstop	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "ossettings	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "osslEnableConfig	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "osslEnableConfigSet	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "osslEnableconfig	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "osstarteintrag	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "osstarteintragdel	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "osstruktur	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "oswriteconfig	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "oszipupgrade	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "passgen	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "pythoncopy	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "radiolist	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "ramspeicher	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "rebootdatum	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "regionconfig	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "regionrestore	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "regionsinisuchen	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "robustbackup	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "rologdel	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "schreibeinfo	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "screenlist	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "screenlistrestart	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "scriptcopy	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "scriptgitcopy	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "searchcopy	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "searchgitcopy	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "senddata	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "serverinstall22	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "serverupgrade	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "set_empty_user	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "setpartner	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "show_info	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "simstats	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "sourcelist18	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "sourcelist22	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "systeminformation	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "tabellenabfrage	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "textbox	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "trimm	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "ufwlog	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "ufwset	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "uncompress	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	#echo "vardel	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "vartest	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "warnbox	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "waslauft	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."


	log line
	echo "$(tput setaf 3)  Der Verzeichnisname ist gleichzeitig auch der Screen Name!$(tput sgr 0)"

	# log info "HILFE: Hilfe wurde angefordert."
}

## * hilfemenudirektaufrufe.
	# Hilfe auf dem Bildschirm anzeigen.
	# 
	#? @param name Erklaerung.
	#? @return name was wird zurueckgegeben.
	# todo: nichts.
## 
function hilfemenudirektaufrufe() {
	echo "menuassetdel	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "menuautologdel	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "menuautorestart	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "menuautoscreenstop	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "menuautosimstart	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "menuautosimstop	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "menuautostart	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "menuautostop	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "menucreateuser	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "menufinstall	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "menugridstart	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "menugridstop	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "menuinfo	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	#echo "menukonsolenhilfe	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "menulandclear	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "menuloadinventar	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "menulogdel	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "menumapdel	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "menumostart	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "menumostop	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "menuoscommand	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "menuosdauerstart	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "menuosdauerstop	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "menuosstart	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "menuosstarteintrag	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "menuosstarteintragdel	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "menuosstop	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "menuosstruktur	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "menuoswriteconfig	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "menuregionbackup	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "menuregionrestore	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "menurostart	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "menurostop	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "menusaveinventar	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "menuwaslauft	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "menuworks	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
}

## * konsolenhilfe.
	# Konsolenhilfe auf dem Bildschirm anzeigen.
	# 
	#? @param name Erklaerung.
	#? @return name was wird zurueckgegeben.
	# todo: nichts.
##
function konsolenhilfe() {
	echo "$(tput setab 5)Funktion:$(tput sgr 0) $(tput setab 4)Informationen:$(tput sgr 0)"
	echo "Tab - Dateien und Ordnernamen automatisch vervollstaendigen."
	echo "Strg + W - Loescht das word vor dem Cursor."
	echo "Strg + K - Loescht die Zeile hinter dem Cursor."
	echo "Strg + T - Vertauscht die letzten beiden Zeichen vor dem Cursor."
	echo "Esc + T - Vertauscht die letzten beiden Woerter vor dem Cursor."
	echo "Alt + F - Bewegt den Cursor Wortweise vorwaehrts."
	echo "Alt + B - Bewegt den Cursor Wortweise rueckwaerts."
	echo "Strg + A - Gehe zum Anfang der Zeile."
	echo "Strg + E - Zum Ende der Zeile gehen."
	echo "Strg + L - Bildschirm loeschen."
	echo "Strg + U - Loescht die Zeile vor der cursor Position. Am Ende wird die gesamte Zeile geloescht."
	echo "Strg + H - Wie Ruecktaste"
	echo "Strg + R - Ermoeglicht die Suche nach zuvor verwendeten Befehlen"
	echo "Strg + C - Beendet was auch immer gerade laeuft."
	echo "Strg + D - Beendet Putty oder Xterm."
	echo "Strg + Z - Setzt alles, was Sie ausfuehren, in einen angehaltenen Hintergrundprozess."

	# log info "HILFE: Konsolenhilfe wurde angefordert"
}

## * commandhelp.
	# Help OpenSim Commands.
	# 
	#? @param name Erklaerung.
	#? @return name was wird zurueckgegeben.
	# todo: nichts.
##  
function commandhelp() {
	cat <<eof
$(tput setab 1)
Help OpenSim Commands:
Aufruf: oscommand Screen Region "Befehl mit Parameter in Hochstrichen"
Beispiel: bash osmtool.sh oscommand sim1 Welcome "alert Hallo liebe Leute dies ist eine Nachricht"
$(tput sgr 0)

$(tput setab 1)A$(tput sgr 0)
alert <Nachricht> - sendet eine Nachricht an alle.
alert-user <Vorname> <Nachname> <Nachricht> - sendet eine Nachricht an eine bestimmte Person.
appearance find <uuid-oder-start-der-uuid> - herausfinden welcher Avatar das angegebene Asset als gebackene Textur verwendet, falls vorhanden.
appearance rebake <Vorname> <Nachname> - Sendet eine Anfrage an den Viewer des Benutzers, damit er seine Aussehenstexturen neu backen und hochladen kann.
appearance send <Vorname> <Nachname> - Sendet Aussehensdaten fuer jeden Avatar im Simulator an andere Viewer.

$(tput setab 1)B$(tput sgr 0)
backup - Das momentan nicht gespeicherte Objekt wird sofort geaendert, anstatt auf den normalen Speicheraufruf zu warten.
bypass permissions <true / false> - Berechtigungspruefungen umgehen.

$(tput setab 1)C$(tput sgr 0)
change region <Regionsname> - aendere die aktuelle Region in der Konsole.
clear image queues <Vorname> <Nachname> - Loescht die Bildwarteschlangen (ueber UDP heruntergeladene Texturen) fuer einen bestimmten Client.
command-script <Skript> - Ausfuehren eines Befehlsskripts aus einer Datei.
config save <Pfad> - Speichert die aktuelle Konfiguration in einer Datei unter dem angegebenen Pfad.
config set <Sektion> <key> <value> - Legt eine Konfigurationsoption fest. Dies ist in den meisten Faellen nicht sinnvoll, da geaenderte Parameter nicht dynamisch nachgeladen werden. Geaenderte Parameter bleiben auch nicht bestehen - Sie muessen eine Konfigurationsdatei manuell aendern und neu starten.
create region ["Regionsname"] <Regionsdatei.ini> - Erstellt eine neue Region.

$(tput setab 1)D$(tput sgr 0)
debug attachments log [0|1] - Debug Protokollierung fuer Anhaenge aktivieren.
debug eq [0|1|2] - Aktiviert das Debuggen der Ereigniswarteschlange.
  <= 0 - deaktiviert die gesamte Protokollierung der Ereigniswarteschlange.
  >= 1 - aktiviert die Einrichtung der Ereigniswarteschlange und die Protokollierung ausgehender Ereignisse.
  >= 2 - schaltet die Umfragebenachrichtigung ein.
debug groups messaging verbose <true|false> - Diese Einstellung aktiviert das Debuggen von sehr ausfuehrlichen Gruppennachrichten.
debug groups verbose <true|false> – Diese Einstellung aktiviert das Debuggen von sehr ausfuehrlichen Gruppen.
debug http <in|out|all> [<level>] - Aktiviert die Protokollierung von HTTP-Anfragen.
debug jobengine <start|stop|status|log> - Start, Stopp, Status abrufen oder Logging Level der Job-Engine festlegen.
debug permissions <true / false> - Berechtigungs Debugging aktivieren.
debug scene get - Listet die aktuellen Szenenoptionen auf.
debug scene set <param> <value> - Aktiviert die Debugging-Optionen fuer die Szene.
debug threadpool level 0..3 - Aktiviert die Protokollierung der Aktivitaet im Hauptthreadpool.
debug threadpool set worker|iocp min|max <n> - Legt die Threadpool-Parameter fest. Fuer Debugzwecke.
delete object creator <UUID> - Szenenobjekte nach Ersteller loeschen.
delete object id <UUID-or-localID> - Loeschen eines Szenenobjekts nach uuid oder localID.
delete object name [--regex] <name> - Loescht ein Szenenobjekt nach Namen.
delete object outside - Alle Szenenobjekte ausserhalb der Regionsgrenzen loeschen.
delete object owner <UUID> - Szenenobjekte nach Besitzer loeschen.
delete object pos <start x, start y , start z> <end x, end y, end z> - Loescht Szenenobjekte innerhalb des angegebenen Volumens.
delete-region <name> - Loeschen einer Region von der Festplatte.
dump asset <id> - Ein Asset ausgeben.
dump object id <UUID-oder-localID> - Dump der formatierten Serialisierung des angegebenen Objekts in die Datei <UUID>.xml

$(tput setab 1)E$(tput sgr 0)
edit scale <name> <x> <y> <z> - aendert die Groesse des benannten Prim.
estate create <owner UUID> <estate name> - Erstellt ein neues Anwesen mit dem angegebenen Namen, das dem angegebenen Benutzer gehoert. Der Name des Anwesens muss eindeutig sein.
estate link region <estate ID> <region ID> - Haengt die angegebene Region an die angegebene Domain an.
estate set name <estate-id> <new name> - Setzt den Namen des angegebenen Anwesens auf den angegebenen Wert. Der neue Name muss eindeutig sein.
estate set owner <estate-id>[ <UUID> | <Vorname> <Nachname> ] - Setzt den Besitzer des angegebenen Anwesens auf die angegebene UUID oder den angegebenen Benutzer.
export-map [<Pfad>] - Speichert ein Bild der Karte.

$(tput setab 1)F$(tput sgr 0)
fcache assets - Versucht alle Assets in allen Szenen gruendlich zu scannen und zwischenzuspeichern.
fcache cachedefaultassets - laedt lokale Standardassets in den Cache. Dies kann Rasterfelder ueberschreiben, mit Vorsicht verwenden.
fcache clear [file] [memory] - Entfernt alle Assets im Cache. Wenn Datei oder Speicher angegeben ist, wird nur dieser Cache geleert.
fcache deletedefaultassets - loescht standardmaessige lokale Assets aus dem Cache, damit sie aus dem Raster aktualisiert werden koennen, mit Vorsicht verwenden.
fcache expire <datetime(mm/dd/YYYY)> - Loescht zwischengespeicherte Assets, die aelter als das angegebene Datum oder die angegebene Uhrzeit sind.
force gc - Ruft die Garbage Collection zur Laufzeit manuell auf. Fuer Debugging-Zwecke.
force permissions <true / false> - Berechtigungen ein- oder ausschalten.
force update - Erzwinge die Aktualisierung aller Objekte auf Clients.

$(tput setab 1)G$(tput sgr 0)
generate map - Erzeugt und speichert ein neues Kartenstueck.

$(tput setab 1)J$(tput sgr 0)
j2k decode <ID> - Fuehrt die JPEG2000 Decodierung eines Assets durch.

$(tput setab 1)K$(tput sgr 0)
kick user <first> <last> [--force] [message] - Einen Benutzer aus dem Simulator werfen.

$(tput setab 1)L$(tput sgr 0)
land clear - Loescht alle Parzellen aus der Region.
link-mapping [<x> <y>] - Stellt lokale Koordinaten ein, um HG Regionen abzubilden.
link-region <Xloc> <Yloc> <ServerURI> [<RemoteRegionName>] - Verknuepft eine HyperGrid Region.
load iar [-m|--merge] <first> <last> <inventory path> <password> [<IAR path>] - Benutzerinventararchiv (IAR) laden.
load oar [-m|--merge] [-s|--skip-assets] [--default-user "User Name"] [--merge-terrain] [--merge-parcels] [--mergeReplaceObjects] [--no-objects] [--rotation degrees] [--bounding-origin "<x,y,z>"] [--bounding-size "<x,y,z>"] [--displacement "<x,y,z>"] [-d|--debug] [<OAR path>] - Laden der Daten einer Region aus einem OAR Archiv.
load xml [<file name> [-newUID [<x> <y> <z>]]] - Laden der Daten einer Region aus dem XML-Format.
load xml2 [<file name>] - Laden Sie die Daten einer Region aus dem XML2-Format.
login disable - Simulator Logins deaktivieren.
login enable - Simulator Logins aktivieren.

$(tput setab 1)P$(tput sgr 0)
physics set <param> [<value>|TRUE|FALSE] [localID|ALL] - Setzt Physikparameter aus der aktuell ausgewaehlten Region.

$(tput setab 1)Q$(tput sgr 0)
quit - Beenden Sie die Anwendung.

$(tput setab 1)R$(tput sgr 0)
region restart abort [<message>] - Einen Neustart der Region abbrechen.
region restart bluebox <message> <delta seconds>+ - Planen eines Regionsneustart.
region restart notice <message> <delta seconds>+ - Planen eines Neustart der Region.
region set - Stellt Steuerinformationen fuer die aktuell ausgewaehlte Region ein.
remove-region <name> - Entferne eine Region aus diesem Simulator.
reset user cache - Benutzercache zuruecksetzen, damit geaenderte Einstellungen uebernommen werden koennen.
restart - Startet die aktuell ausgewaehlte(n) Region(en) in dieser Instanz neu.
rotate scene <degrees> [centerX, centerY] - Dreht alle Szenenobjekte um centerX, centerY (Standard 128, 128) (bitte sichern Sie Ihre Region vor der Verwendung).

$(tput setab 1)S$(tput sgr 0)
save iar [-h|--home=<url>] [--noassets] <first> <last> <inventory path> <password> [<IAR path>] [-c|--creators] [-e|--exclude=<name/uuid>] [-f|--excludefolder=<foldername/uuid>] [-v|--verbose] - Benutzerinventararchiv (IAR) speichern.
save oar [-h|--home=<url>] [--noassets] [--publish] [--perm=<permissions>] [--all] [<OAR path>] - Speichert die Daten einer Region in ein OAR-Archiv.
save prims xml2 [<prim name> <file name>] - Speichern Sie das benannte Prim in XML2
save xml [<file name>] - Speichern Sie die Daten einer Region im XML-Format
save xml2 [<file name>] - Speichern Sie die Daten einer Region im XML2-Format
scale scene <factor> - Skaliert die Szenenobjekte (bitte sichern Sie Ihre Region vor der Verwendung)
set log level <level> - Legt die Konsolenprotokollierungsebene fuer diese Sitzung fest.
set terrain heights <corner> <min> <max> [<x>] [<y>] - Setzt die Terrain Texturhoehen an Ecke #<corner> auf <min>/<max>, wenn <x> oder <y > angegeben sind, wird es nur auf Regionen mit einer uebereinstimmenden Koordinate gesetzt. Geben Sie -1 in <x> oder <y> an, um diese Koordinate mit Platzhaltern zu versehen. Ecke # SW = 0, NW = 1, SE = 2, NE = 3, alle Ecken = -1.
set terrain texture <number> <uuid> [<x>] [<y>] - Setzt das Terrain <number> auf <uuid>, wenn <x> oder <y> angegeben ist, wird es nur auf Regionen mit . gesetzt eine passende Koordinate. Geben Sie -1 in <x> oder <y> an, um diese Koordinate mit Platzhaltern zu versehen.
set water height <height> [<x>] [<y>] - Legt die Wasserhoehe in Metern fest. Wenn <x> und <y> angegeben sind, wird es nur auf Regionen mit einer uebereinstimmenden Koordinate gesetzt. Geben Sie -1 in <x> oder <y> an, um diese Koordinate mit Platzhaltern zu versehen.
shutdown - Beendet die Anwendung
sit user name [--regex] <first-name> <last-name> - Setzet den benannten Benutzer auf ein unbesetztes Objekt mit einem Sit-Target.
stand user name [--regex] <first-name> <last-name> - Nutzer zum aufstehen zwingen.
stats record start|stop - Steuert ob Statistiken regelmaessig in einer separaten Datei aufgezeichnet werden.
stats save <path> - Statistik Snapshot in einer Datei speichern. Wenn die Datei bereits existiert, wird der Bericht angehaengt.

$(tput setab 1)T$(tput sgr 0)
teleport user <first-name> <last-name> <destination> - Teleportiert einen Benutzer in diesem Simulator zum angegebenen Ziel.
terrain load - Laedt ein Terrain aus einer angegebenen Datei.
terrain load-tile - Laedt ein Terrain aus einem Abschnitt einer groesseren Datei.
terrain save - Speichert die aktuelle Heightmap in einer bestimmten Datei.
terrain save-tile - Speichert die aktuelle Heightmap in der groesseren Datei.
terrain fill - Fuellt die aktuelle Heightmap mit einem bestimmten Wert.
terrain elevate - Erhoeht die aktuelle Heightmap um den angegebenen Betrag.
terrain lower - Senkt die aktuelle Hoehenmap um den angegebenen Wert.
terrain multiply - Multipliziert die Heightmap mit dem angegebenen Wert.
terrain bake - Speichert das aktuelle Terrain in der Regions-Back-Map.
terrain revert - Laedt das gebackene Kartengelaende in die Regions-Hoehenmap.
terrain newbrushes - Aktiviert experimentelle Pinsel, die die Standard-Terrain-Pinsel ersetzen. WARNUNG: Dies ist eine Debug-Einstellung und kann jederzeit entfernt werden.
terrain show - Zeigt die Gelaendehoehe an einer bestimmten Koordinate an.
terrain stats - Zeigt Informationen ueber die Regions-Heightmap fuer Debugging-Zwecke an.
terrain effect - Fuehrt einen angegebenen Plugin-Effekt aus.
terrain flip - Flippt das aktuelle Gelaende um die X- oder Y-Achse.
terrain rescale - Skaliert das aktuelle Terrain so, dass es zwischen die angegebenen Min- und Max-Hoehen passt
terrain min - Legt die minimale Gelaendehoehe auf den angegebenen Wert fest.
terrain max - Legt die maximale Gelaendehoehe auf den angegebenen Wert fest.
translate scene <x,y,z> - Verschiebe die gesamte Szene in eine neue Koordinate. Nuetzlich zum Verschieben einer Szene an einen anderen Ort in einem Mega- oder variablen Bereich.
tree active - Aktivitaetsstatus fuer das Baummodul aendern.
tree freeze - einfrieren und weiterbauen eines Waldes.
tree load - Laden Sie eine Wald-Definition aus einer XML-Datei.
tree plant - Beginn mit dem bepflanzen eines Waldes.
tree rate - Zuruecksetzen der Baumaktualisierungsrate (mSec).
tree reload - Erneutes Laden von Copse-Definitionen aus den In-Scene-Baeumen.
tree remove - Entfert eine Wald-Definition und alle ihrer bereits gepflanzten Baeume.
tree statistics - Log-Statistik ueber die Baeume.

$(tput setab 1)U$(tput sgr 0)
unlink-region <local name> - Verknuepfung einer Hypergrid-Region aufheben

$(tput setab 1)V$(tput sgr 0)
vivox debug <on>|<off> - Einstellen des vivox-Debuggings

$(tput setab 1)W$(tput sgr 0)
wind base wind_update_rate [<value>] - Abrufen oder Festlegen der Windaktualisierungsrate.
wind ConfigurableWind avgDirection [<value>] - durchschnittliche Windrichtung in Grad.
wind ConfigurableWind avgStrength [<value>] - durchschnittliche Windstaerke.
wind ConfigurableWind rateChange [<value>] - aenderungsrate.
wind ConfigurableWind varDirection [<value>] - zulaessige Abweichung der Windrichtung in +/- Grad.
wind ConfigurableWind varStrength [<value>] - zulaessige Abweichung der Windstaerke.
wind SimpleRandomWind strength [<value>] - Windstaerke.

eof

	# log info "HILFE: Commands Hilfe wurde angefordert"
}

FARBE1=0
FARBE2=2
## * MoneyServerCommands.
	# MoneyServer Commands.
	# 
	#? @param name Erklaerung.
	#? @return name was wird zurueckgegeben.
	# todo: nichts.
##  
function MoneyServerCommands() {
echo "$(tput setaf $FARBE1) $(tput setab $FARBE2) MoneyServer Commands $(tput sgr 0)$(tput setaf $FARBE2) $(tput setab $FARBE1)Dies sind die Kommandos der MoneyServer Konsole. $(tput sgr 0)"
echo "
# command-script <script> - Run a command script from file
# config get [<section>] [<key>] - Synonym for config show
# config save <path> - Save current configuration to a file at the given path
# config set <section> <key> <value> - Set a config option.  In most cases this is not useful since changed parameters are not dynamically reloaded.  Neither do changed parameters persist - you will have to change a config file manually and restart.
# config show [<section>] [<key>] - Show config information
# debug jobengine <start|stop|status|log> - Start, stop, get status or set logging level of the job engine.
# debug threadpool level 0..3 - Turn on logging of activity in the main thread pool.
# debug threadpool set worker|iocp min|max <n> - Set threadpool parameters.  For debug purposes.
# debug threadpool status - Show current debug threadpool parameters.
# force gc - Manually invoke runtime garbage collection.  For debugging purposes
# get log level - Get the current console logging level
# help [<item>] - Display help on a particular command or on a list of commands in a category
# quit - Quit the application
# set log level <level> - Set the console logging level for this session.
# show checks - Show checks configured for this server
# show info - Show general information about the server
# show stats [list|all|(<category>[.<container>])+ - Alias for  stats show  command
# show threadpool calls complete - Show details about threadpool calls that have been completed.
# show threads - Show thread status
# show uptime - Show server uptime
# show version - Show server version
# shutdown - Quit the application
# stats record start|stop - Control whether stats are being regularly recorded to a separate file.
# stats save <path> - Save stats snapshot to a file.  If the file already exists, then the report is appended.
# stats show [list|all|(<category>[.<container>])+ - Show statistical information for this server
# threads abort <thread-id> - Abort a managed thread.  Use  show threads  to find possible threads.
# threads show - Show thread status.  Synonym for  show threads 
"
}

## * OpenSimCommands.
	# OpenSim Commands.
	# 
	#? @param name Erklaerung.
	#? @return name was wird zurueckgegeben.
	# todo: nichts.
##  
function OpenSimCommands() {
echo "$(tput setaf $FARBE1) $(tput setab $FARBE2) OpenSim Commands $(tput sgr 0)$(tput setaf $FARBE2) $(tput setab $FARBE1)Dies sind die Kommandos der OpenSim Konsole. $(tput sgr 0)"
echo "
# load iar [-m|--merge] <first> <last> <inventory path> <password> [<IAR path>] - Load user inventory archive (IAR).
# load oar [-m|--merge] [-s|--skip-assets] [--default-user  User Name ] [--merge-terrain] [--merge-parcels] [--mergeReplaceObjects] [--no-objects] [--rotation degrees] [--bounding-origin  <x,y,z> ] [--bounding-size  <x,y,z> ] [--displacement  <x,y,z> ] [-d|--debug] [<OAR path>] - Load a region s data from an OAR archive.
# load xml [<file name> [-newUID [<x> <y> <z>]]] - Load a region s data from XML format
# load xml2 [<file name>] - Load a region s data from XML2 format
# save iar [-h|--home=<url>] [--noassets] <first> <last> <inventory path> <password> [<IAR path>] [-c|--creators] [-e|--exclude=<name/uuid>] [-f|--excludefolder=<foldername/uuid>] [-v|--verbose] - Save user inventory archive (IAR).
# save oar [-h|--home=<url>] [--noassets] [--publish] [--perm=<permissions>] [--all] [<OAR path>] - Save a region s data to an OAR archive.
# save prims xml2 [<prim name> <file name>] - Save named prim to XML2
# save xml [<file name>] - Save a region s data in XML format
# save xml2 [<file name>] - Save a region s data in XML2 format
# dump asset <id> - Dump an asset
# fcache assets - Attempt a deep scan and cache of all assets in all scenes
# fcache cachedefaultassets - loads local default assets to cache. This may override grid ones. use with care
# fcache clear [file] [memory] - Remove all assets in the cache.  If file or memory is specified then only this cache is cleared.
# fcache deletedefaultassets - deletes default local assets from cache so they can be refreshed from grid. use with care
# fcache expire <datetime(mm/dd/YYYY)> - Purge cached assets older than the specified date/time
# fcache status - Display cache status
# j2k decode <ID> - Do JPEG2000 decoding of an asset.
# show asset <ID> - Show asset information
# clear image queues <first-name> <last-name> - Clear the image queues (textures downloaded via UDP) for a particular client.
# show caps list - Shows list of registered capabilities for users.
# show caps stats by cap [<cap-name>] - Shows statistics on capabilities use by capability.
# show caps stats by user [<first-name> <last-name>] - Shows statistics on capabilities use by user.
# show circuits - Show agent circuit data
# show connections - Show connection data
# show http-handlers - Show all registered http handlers
# show image queues <first-name> <last-name> - Show the image queues (textures downloaded via UDP) for a particular client.
# show pending-objects - Show # of objects on the pending queues of all scene viewers
# show pqueues [full] - Show priority queue data for each client
# show queues [full] - Show queue data for each client
# show throttles [full] - Show throttle settings for each client and for the server overall
# debug attachments log [0|1] - Turn on attachments debug logging
# debug attachments status - Show current attachments debug status
# debug eq [0|1|2] - Turn on event queue debugging
# debug eq 0 - turns off all event queue logging
# debug eq 1 - turns on event queue setup and outgoing event logging
# debug eq 2 - turns on poll notification
# debug groups messaging verbose <true|false> - This setting turns on very verbose groups messaging debugging
# debug groups verbose <true|false> - This setting turns on very verbose groups debugging
# debug http <in|out|all> [<level>] - Turn on http request logging.
# debug jobengine <start|stop|status|log> - Start, stop, get status or set logging level of the job engine.
# debug permissions <true / false> - Turn on permissions debugging
# debug scene get - List current scene options.
# debug scene set <param> <value> - Turn on scene debugging options.
# debug threadpool level 0..3 - Turn on logging of activity in the main thread pool.
# debug threadpool set worker|iocp min|max <n> - Set threadpool parameters.  For debug purposes.
# debug threadpool status - Show current debug threadpool parameters.
# force gc - Manually invoke runtime garbage collection.  For debugging purposes
# show eq - Show contents of event queues for logged in avatars.  Used for debugging.
# show threadpool calls complete - Show details about threadpool calls that have been completed.
# threads abort <thread-id> - Abort a managed thread.  Use  show threads  to find possible threads.
# estate create <owner UUID> <estate name> - Creates a new estate with the specified name, owned by the specified user. Estate name must be unique.
# estate link region <estate ID> <region ID> - Attaches the specified region to the specified estate.
# estate set name <estate-id> <new name> - Sets the name of the specified estate to the specified value. New name must be unique.
# estate set owner <estate-id>[ <UUID> | <Firstname> <Lastname> ] - Sets the owner of the specified estate to the specified UUID or user.
# estate show - Shows all estates on the simulator.
# friends show [--cache] <first-name> <last-name> - Show the friends for the given user if they exist.
# change region <region name> - Change current console region
# command-script <script> - Run a command script from file
# config get [<section>] [<key>] - Synonym for config show
# config save <path> - Save current configuration to a file at the given path
# config set <section> <key> <value> - Set a config option.  In most cases this is not useful since changed parameters are not dynamically reloaded.  Neither do changed parameters persist - you will have to change a config file manually and restart.
# config show [<section>] [<key>] - Show config information
# get log level - Get the current console logging level
# monitor report - Returns a variety of statistics about the current region and/or simulator
# quit - Quit the application
# set log level <level> - Set the console logging level for this session.
# show checks - Show checks configured for this server
# show info - Show general information about the server
# show modules - Show module data
# show stats [list|all|(<category>[.<container>])+ - Alias for  stats show  command
# show threads - Show thread status
# show uptime - Show server uptime
# show version - Show server version
# shutdown - Quit the application
# stats record start|stop - Control whether stats are being regularly recorded to a separate file.
# stats save <path> - Save stats snapshot to a file.  If the file already exists, then the report is appended.
# stats show [list|all|(<category>[.<container>])+ - Show statistical information for this server
# threads show - Show thread status.  Synonym for  show threads 
# link-mapping [<x> <y>] - Set local coordinate to map HG regions to
# link-region <Xloc> <Yloc> <ServerURI> [<RemoteRegionName>] - Link a HyperGrid Region. Examples for <ServerURI>: http://grid.net:8002/ or http://example.org/path/foo.php
# show hyperlinks - List the HG regions
# unlink-region <local name> - Unlink a hypergrid region
# land clear - Clear all the parcels from the region.
# land show [<local-land-id>] - Show information about the parcels on the region.
# backup - Persist currently unsaved object changes immediately instead of waiting for the normal persistence call.
# delete object creator <UUID> - Delete scene objects by creator
# delete object id <UUID-or-localID> - Delete a scene object by uuid or localID
# delete object name [--regex] <name> - Delete a scene object by name.
# delete object outside - Delete all scene objects outside region boundaries
# delete object owner <UUID> - Delete scene objects by owner
# delete object pos <start x, start y , start z> <end x, end y, end z> - Delete scene objects within the given volume.
# dump object id <UUID-or-localID> - Dump the formatted serialization of the given object to the file <UUID>.xml
# edit scale <name> <x> <y> <z> - Change the scale of a named prim
# force update - Force the update of all objects on clients
# rotate scene <degrees> [centerX, centerY] - Rotates all scene objects around centerX, centerY (default 128, 128) (please back up your region before using)
# scale scene <factor> - Scales the scene objects (please back up your region before using)
# show object id [--full] <UUID-or-localID> - Show details of a scene object with the given UUID or localID
# show object name [--full] [--regex] <name> - Show details of scene objects with the given name.
# show object owner [--full] <OwnerID> - Show details of scene objects with given owner.
# show object pos [--full] <start x, start y , start z> <end x, end y, end z> - Show details of scene objects within give volume
# show part id <UUID-or-localID> - Show details of a scene object part with the given UUID or localID
# show part name [--regex] <name> - Show details of scene object parts with the given name.
# show part pos <start x, start y , start z> <end x, end y, end z> - Show details of scene object parts within the given volume.
# translate scene xOffset yOffset zOffset - translates the scene objects (please back up your region before using)
# create region [ region name ] <region_file.ini> - Create a new region.
# delete-region <name> - Delete a region from disk
# export-map [<path>] - Save an image of the world map
# generate map - Generates and stores a new maptile.
# physics get [<param>|ALL] - Get physics parameter from currently selected region
# physics list - List settable physics parameters
# physics set <param> [<value>|TRUE|FALSE] [localID|ALL] - Set physics parameter from currently selected region
# region get - Show control information for the currently selected region (host name, max physical prim size, etc).
# region restart abort [<message>] - Abort a region restart
# region restart bluebox <message> <delta seconds>+ - Schedule a region restart
# region restart notice <message> <delta seconds>+ - Schedule a region restart
# region set - Set control information for the currently selected region.
# remove-region <name> - Remove a region from this simulator
# restart - Restart the currently selected region(s) in this instance
# set terrain heights <corner> <min> <max> [<x>] [<y>] - Sets the terrain texture heights on corner #<corner> to <min>/<max>, if <x> or <y> are specified, it will only set it on regions with a matching coordinate. Specify -1 in <x> or <y> to wildcard that coordinate. Corner # SW = 0, NW = 1, SE = 2, NE = 3, all corners = -1.
# set terrain texture <number> <uuid> [<x>] [<y>] - Sets the terrain <number> to <uuid>, if <x> or <y> are specified, it will only set it on regions with a matching coordinate. Specify -1 in <x> or <y> to wildcard that coordinate.
# set water height <height> [<x>] [<y>] - Sets the water height in meters.  If <x> and <y> are specified, it will only set it on regions with a matching coordinate. Specify -1 in <x> or <y> to wildcard that coordinate.
# show neighbours - Shows the local region neighbours
# show ratings - Show rating data
# show region - Show control information for the currently selected region (host name, max physical prim size, etc).
# show regions - Show region data
# show regionsinview - Shows regions that can be seen from a region
# show scene - Show live information for the currently selected scene (fps, prims, etc.).
# wind base wind_update_rate [<value>] - Get or set the wind update rate.
# wind ConfigurableWind avgDirection [<value>] - average wind direction in degrees
# wind ConfigurableWind avgStrength [<value>] - average wind strength
# wind ConfigurableWind rateChange [<value>] - rate of change
# wind ConfigurableWind varDirection [<value>] - allowable variance in wind direction in +/- degrees
# wind ConfigurableWind varStrength [<value>] - allowable variance in wind strength
# wind SimpleRandomWind strength [<value>] - wind strength
# terrain load - Loads a terrain from a specified file.
# terrain load-tile - Loads a terrain from a section of a larger file.
# terrain save - Saves the current heightmap to a specified file.
# terrain save-tile - Saves the current heightmap to the larger file.
# terrain fill - Fills the current heightmap with a specified value.
# terrain elevate - Raises the current heightmap by the specified amount.
# terrain lower - Lowers the current heightmap by the specified amount.
# terrain multiply - Multiplies the heightmap by the value specified.
# terrain bake - Saves the current terrain into the regions baked map.
# terrain revert - Loads the baked map terrain into the regions heightmap.
# terrain show - Shows terrain height at a given co-ordinate.
# terrain stats - Shows some information about the regions heightmap for debugging purposes.
# terrain effect - Runs a specified plugin effect
# terrain flip - Flips the current terrain about the X or Y axis
# terrain rescale - Rescales the current terrain to fit between the given min and max heights
# terrain min - Sets the minimum terrain height to the specified value.
# terrain max - Sets the maximum terrain height to the specified value.
# tree active - Change activity state for the trees module
# tree freeze - Freeze/Unfreeze activity for a defined copse
# tree load - Load a copse definition from an xml file
# tree plant - Start the planting on a copse
# tree rate - Reset the tree update rate (mSec)
# tree reload - Reload copses from the in-scene trees
# tree remove - Remove a copse definition and all its in-scene trees
# tree statistics - Log statistics about the trees
# alert <message> - Send an alert to everyone
# alert-user <first> <last> <message> - Send an alert to a user
# appearance find <uuid-or-start-of-uuid> - Find out which avatar uses the given asset as a baked texture, if any.
# appearance rebake <first-name> <last-name> - Send a request to the user s viewer for it to rebake and reupload its appearance textures.
# appearance send [<first-name> <last-name>] - Send appearance data for each avatar in the simulator to other viewers.
# appearance show [<first-name> <last-name>] - Show appearance information for avatars.
# attachments show [<first-name> <last-name>] - Show attachment information for avatars in this simulator.
# bypass permissions <true / false> - Bypass permission checks
# force permissions <true / false> - Force permissions on or off
# kick user <first> <last> [--force] [message] - Kick a user off the simulator
# login disable - Disable simulator logins
# login enable - Enable simulator logins
# login status - Show login status
# reset user cache - reset user cache to allow changed settings to be applied
# show animations [<first-name> <last-name>] - Show animation information for avatars in this simulator.
# show appearance [<first-name> <last-name>] - Synonym for  appearance show 
# show name <uuid> - Show the bindings between a single user UUID and a user name
# show names - Show the bindings between user UUIDs and user names
# show users [full] - Show user data for users currently on the region
# sit user name [--regex] <first-name> <last-name> - Sit the named user on an unoccupied object with a sit target.
# stand user name [--regex] <first-name> <last-name> - Stand the named user.
# teleport user <first-name> <last-name> <destination> - Teleport a user in this simulator to the given destination
# wearables check <first-name> <last-name> - Check that the wearables of a given avatar in the scene are valid.
# wearables show [<first-name> <last-name>] - Show information about wearables for avatars.
# vivox debug <on>|<off> - Set vivox debugging
# yeng [...|help|...] ... - Run YEngine script engine commands
"
}

## * RobustCommands.
	# Robust Commands.
	# 
	#? @param name Erklaerung.
	#? @return name was wird zurueckgegeben.
	# todo: nichts.
##  
function RobustCommands() {
echo "$(tput setaf $FARBE1) $(tput setab $FARBE2) Robust Commands $(tput sgr 0)$(tput setaf $FARBE2) $(tput setab $FARBE1)Dies sind die Kommandos der Robust Konsole. $(tput sgr 0)"
echo "
# delete asset <ID> - Delete asset from database
# dump asset <ID> - Dump asset to a file
# show asset <ID> - Show asset information
# show http-handlers - Show all registered http handlers
# debug http <in|out|all> [<level>] - Turn on http request logging.
# debug jobengine <start|stop|status|log> - Start, stop, get status or set logging level of the job engine.
# debug threadpool level 0..3 - Turn on logging of activity in the main thread pool.
# debug threadpool set worker|iocp min|max <n> - Set threadpool parameters.  For debug purposes.
# debug threadpool status - Show current debug threadpool parameters.
# force gc - Manually invoke runtime garbage collection.  For debugging purposes
# show threadpool calls complete - Show details about threadpool calls that have been completed.
# threads abort <thread-id> - Abort a managed thread.  Use  show threads  to find possible threads.
# delete bakes <ID> - Delete agent s baked textures from server
# command-script <script> - Run a command script from file
# config get [<section>] [<key>] - Synonym for config show
# config save <path> - Save current configuration to a file at the given path
# config set <section> <key> <value> - Set a config option.  In most cases this is not useful since changed parameters are not dynamically reloaded.  Neither do changed parameters persist - you will have to change a config file manually and restart.
# config show [<section>] [<key>] - Show config information
# get log level - Get the current console logging level
# quit - Quit the application
# set log level <level> - Set the console logging level for this session.
# show checks - Show checks configured for this server
# show grid size - Show the current grid size (excluding hyperlink references)
# show info - Show general information about the server
# show stats [list|all|(<category>[.<container>])+ - Alias for  stats show  command
# show threads - Show thread status
# show uptime - Show server uptime
# show version - Show server version
# shutdown - Quit the application
# stats record start|stop - Control whether stats are being regularly recorded to a separate file.
# stats save <path> - Save stats snapshot to a file.  If the file already exists, then the report is appended.
# stats show [list|all|(<category>[.<container>])+ - Show statistical information for this server
# threads show - Show thread status.  Synonym for  show threads 
# link-mapping [<x> <y>] - Set local coordinate to map HG regions to
# link-region <Xloc> <Yloc> <ServerURI> [<RemoteRegionName>] - Link a HyperGrid Region. Examples for <ServerURI>: http://grid.net:8002/ or http://example.org/path/foo.php
# show hyperlinks - List the HG regions
# unlink-region <local name> - Unlink a hypergrid region
# plugin add  plugin index  - Install plugin from repository.
# plugin disable  plugin index  - Disable a plugin
# plugin enable  plugin index  - Enable the selected plugin plugin
# plugin info  plugin index  - Show detailed information for plugin
# plugin list available - List available plugins
# plugin list installed - List install plugins
# plugin remove  plugin index  - Remove plugin from repository
# plugin update  plugin index  - Update the plugin
# plugin updates - List available updates
# deregister region id <region-id>+ - Deregister a region manually.
# set region flags <Region name> <flags> - Set database flags for region
# show region at <x-coord> <y-coord> - Show details on a region at the given co-ordinate.
# show region name <Region name> - Show details on a region
# show regions - Show details on all regions
# repo add  url  - Add repository
# repo disable [url | index]  - Disable registered repository
# repo enable  [url | index]  - Enable registered repository
# repo list - List registered repositories
# repo refresh  url  - Sync with a registered repository
# repo remove  [url | index]  - Remove repository from registry
# create user [<first> [<last> [<pass> [<email> [<user id> [<model>]]]]]] - Create a new user
# login level <level> - Set the minimum user level to log in
# login reset - Reset the login level to allow all users
# login text <text> - Set the text users will see on login
# reset user email [<first> [<last> [<email>]]] - Reset a user email address
# reset user password [<first> [<last> [<password>]]] - Reset a user password
# set user level [<first> [<last> [<level>]]] - Set user level. If >= 200 and  allow_grid_gods = true  in OpenSim.ini, this account will be treated as god-moded. It will also affect the  login level  command.
# show account <first> <last> - Show account details for the given user
# show grid user <ID> - Show grid user entry or entries that match or start with the given ID.  This will normally be a UUID.
# show grid users online - Show number of grid users registered as online.
"
}

## * pCampbotCommands.
	# pCampbot Commands.
	# 
	#? @param name Erklaerung.
	#? @return name was wird zurueckgegeben.
	# todo: nichts.
##  
function pCampbotCommands() {
echo "$(tput setaf $FARBE1) $(tput setab $FARBE2) pCampbot Commands $(tput sgr 0)$(tput setaf $FARBE2) $(tput setab $FARBE1)Dies sind die Kommandos der pCampbot Konsole. $(tput sgr 0)"
echo "
# add behaviour <abgekürzter Name> [<Bot Nummer>] – Fügt einem Bot ein Verhalten hinzu.
# connect [<n>] - Bots verbinden.
# debug lludp packet <Ebene> <Vorname des Avatars> <Nachname des Avatars> – Aktiviert die Protokollierung empfangener Pakete.
# disconnect [<n>] - Bots trennen.
# help [<item>] - Hilfe zu einem bestimmten Befehl oder zu einer Liste von Befehlen in einer Kategorie anzeigen.
# quit - Bots herunterfahren und beenden.
# remove behaviour <abgekürzter Name> [<Bot-Nummer>] – Entfernt ein Verhalten von einem Bot.
# set bots <key> <value> - Legt eine Einstellung für alle Bots fest.
# show bot <bot-number> - Zeigt den detaillierten Status und die Einstellungen eines bestimmten Bots an.
# show bots - Zeigt den Status aller Bots an.
# show regions - Bots bekannte Regionen anzeigen.
# show stats [list|all|(<category>[.<container>])+ - Alias für den Befehl „stats show“.
# show status - Zeigt den pCampbot-Status an.
# shutdown - Bots herunterfahren und beenden.
# sit - Alle Bots hinsetzen.
# stand - Alle Bots stehen.
# stats record start|stop - Steuert ob Statistiken regelmäßig in einer separaten Datei aufgezeichnet werden.
# stats save <path> - Speichert den Statistik-Snapshot in einer Datei. Wenn die Datei bereits vorhanden ist, wird der Bericht angehängt.
# stats show [list|all|(<category>[.<container>])+ - Statistische Informationen für diesen Server anzeigen.
"
}

## * all
	# Ruft die Hilfen fuer Robust Commands, OpenSim Commands, Money Server Commands auf.
	# 
	#? @param name Erklaerung.
	#? @return name was wird zurueckgegeben.
	# todo: nichts.
## 
function all() {
RobustCommands
OpenSimCommands
MoneyServerCommands
pCampbotCommands
}

#──────────────────────────────────────────────────────────────────────────────────────────
#* Menu Menue Funktionsgruppe
#──────────────────────────────────────────────────────────────────────────────────────────

## * menutrans
	# Versuch das Menu schneller und besser zu uebersetzen.
	# 
	#? @param name Erklaerung.
	#? @return name was wird zurueckgegeben.
	# todo: nichts.
## 
function menutrans() {
	OSMTRANSTEXT=$1
	if [ "$OSMTRANSLATOR" = "OFF" ]; then echo $OSMTRANSTEXT; fi 
	if [ "$OSMTRANSLATOR" = "ON" ]; then trans -brief -no-warn $OSMTRANS "$OSMTRANSTEXT"; fi
}

## * hilfemenu
	# Menue der Hilfe.
	# 
	#? @param name Erklaerung.
	#? @return name was wird zurueckgegeben.
	# todo: nichts.
##
function hilfemenu() {
	HEIGHT=0
	WIDTH=0
	CHOICE_HEIGHT=30
	BACKTITLE="opensimMULTITOOL"
	TITLE="Hilfemenu"
	MENU="opensimMULTITOOL $VERSION"

	Hilfe=$(menutrans "Hilfe")
	Konsolenhilfe=$(menutrans "Konsolenhilfe")
	Kommandohilfe=$(menutrans "Kommandohilfe")
	RobustCommands=$(menutrans "RobustCommands")	
	pCampbotCommands=$(menutrans "pCampbotCommands")
	MoneyServerCommands=$(menutrans "MoneyServerCommands")
	RobustCommands=$(menutrans "RobustCommands")
	Konfigurationlesen=$(menutrans "Konfiguration lesen")

	Passwortgenerator=$(menutrans "Passwortgenerator")
	Kalender=$(menutrans "Kalender")

	Hauptmenu=$(menutrans "Hauptmenu")

	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then
		OPTIONS=("$Hilfe" ""
			"$Konsolenhilfe" ""
			"$Kommandohilfe" ""
			"$RobustCommands" ""
			"$OpenSimCommands" ""
			"$MoneyServerCommands" ""
			"$pCampbotCommands" ""
			"$Konfigurationlesen" ""
			"--------------------------" ""
			"$Passwortgenerator" ""
			"$Kalender" ""
			"--------------------------" ""
			"$Hauptmenu" "")

		#hauswahl=$(dialog --clear --backtitle "$BACKTITLE" --title "$TITLE" --help-button --defaultno --menu "$MENU" $HEIGHT $WIDTH $CHOICE_HEIGHT "${OPTIONS[@]}" 2>&1 >/dev/tty)
		hauswahl=$(dialog --backtitle "$BACKTITLE" --title "$TITLE" --defaultno --menu "$MENU" $HEIGHT $WIDTH $CHOICE_HEIGHT "${OPTIONS[@]}" 2>&1 >/dev/tty)

		hantwort=$?
		#dialogclear
		dialog --clear
		ScreenLog

		if [[ $hauswahl = "$Hilfe" ]]; then hilfe; fi
		if [[ $hauswahl = "$Konsolenhilfe" ]]; then menukonsolenhilfe; fi # Test menukonsolenhilfe
		if [[ $hauswahl = "$Kommandohilfe" ]]; then commandhelp; fi

		if [[ $hauswahl = "$RobustCommands" ]]; then RobustCommands; fi
		if [[ $hauswahl = "$OpenSimCommands" ]]; then OpenSimCommands; fi
		if [[ $hauswahl = "$MoneyServerCommands" ]]; then MoneyServerCommands; fi
		if [[ $hauswahl = "$pCampbotCommands" ]]; then pCampbotCommands; fi

		if [[ $hauswahl = "$Konfigurationlesen" ]]; then menuoswriteconfig; fi

		if [[ $hauswahl = "$Passwortgenerator" ]]; then passwdgenerator; fi
		if [[ $hauswahl = "$Kalender" ]]; then kalender; fi

		if [[ $hauswahl = "$Hauptmenu" ]]; then hauptmenu; fi
		if [[ $hantwort = 1 ]]; then hauptmenu; fi
	else
		# wenn dialog nicht installiert ist die Hilfe anzeigen.
		hilfe
	fi
}

## * hauptmenu
	# Startmenue.
	# 
	#? @param name Erklaerung.
	#? @return name was wird zurueckgegeben.
	# todo: nichts.
##
function hauptmenu() {
	HEIGHT=0
	WIDTH=0
	CHOICE_HEIGHT=30
	BACKTITLE="opensimMULTITOOL"
	TITLE="Hauptmenu"
	MENU="opensimMULTITOOL $VERSION"

	OpenSimRestart=$(menutrans "OpenSim Restart")
	OpenSimAutostopp=$(menutrans "OpenSim Autostopp")
	OpenSimAutostart=$(menutrans "OpenSim Autostart")

	SimulatorStop=$(menutrans "Einzelner Simulator Stop")
	SimulatorStart=$(menutrans "Einzelner Simulator Start")

	Accountanlegen=$(menutrans "Benutzer Account anlegen")
	Parzellenentfernen=$(menutrans "Parzellen entfernen")
	Objektentfernen=$(menutrans "Objekt entfernen")

	Systeminformationen=$(menutrans "Systeminformationen")
	SimInformationen=$(menutrans "Sim Informationen")
	ScreenListe=$(menutrans "Screen Liste")
	ServerlaufzeitundNeustart=$(menutrans "Server laufzeit und Neustart")

	Avatarmennu=$(menutrans "Avatarmennu")
	WeitereFunktionen=$(menutrans "Weitere Funktionen")
	Dateimennu=$(menutrans "Dateimennu")
	mySQLmenu=$(menutrans "mySQLmenu")
	BuildFunktionen=$(menutrans "Build Funktionen")
	ExpertenFunktionen=$(menutrans "Experten Funktionen")

	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then
		OPTIONS=("$OpenSimRestart" ""
			"$OpenSimAutostopp" ""
			"$OpenSimAutostart" ""
			"--------------------------" ""
			"$SimulatorStop" ""
			"$SimulatorStart" ""
			"--------------------------" ""
			"$Accountanlegen" ""
			"$Parzellenentfernen" ""
			"$Objektentfernen" ""
			"--------------------------" ""
			"$Systeminformationen" ""
			"$SimInformationen" ""
			"$ScreenListe" ""
			"$ServerlaufzeitundNeustart" ""
			"----------Menu------------" ""
			"$Avatarmennu" ""
			"$WeitereFunktionen" ""
			"$Dateimennu" ""
			"$mySQLmenu" ""
			"$BuildFunktionen" ""
			"$ExpertenFunktionen" "")

		#osmtranslate $OPTIONS

		mauswahl=$(dialog --backtitle "$BACKTITLE" --title "$TITLE" --help-button --defaultno --menu "$MENU" $HEIGHT $WIDTH $CHOICE_HEIGHT "${OPTIONS[@]}" 2>&1 >/dev/tty)
		mantwort=$?
		#dialogclear
		dialog --clear
		ScreenLog

		if [[ $mauswahl = "$OpenSimRestart" ]]; then menuautorestart; fi
		if [[ $mauswahl = "$OpenSimAutostopp" ]]; then menuautostop; fi
		if [[ $mauswahl = "$OpenSimAutostart" ]]; then menuautostart; fi

		if [[ $mauswahl = "$SimulatorStop" ]]; then menuosstop; fi
		if [[ $mauswahl = "$SimulatorStart" ]]; then menuosstart; fi
		#if [[ $mauswahl = "Einzelner Simulator Status" ]]; then menuworks; fi
		#if [[ $mauswahl = "Alle Simulatoren Status" ]]; then menuwaslauft; fi
		if [[ $mauswahl = "$SimInformationen" ]]; then menuinfo; fi
		if [[ $mauswahl = "$Systeminformationen" ]]; then systeminformation; fi

		if [[ $mauswahl = "$ScreenListe" ]]; then screenlist; fi
		if [[ $mauswahl = "$Parzellenentfernen" ]]; then menulandclear; fi
		if [[ $mauswahl = "$Objektentfernen" ]]; then menuassetdel; fi
		if [[ $mauswahl = "$Accountanlegen" ]]; then menucreateuser; fi
		if [[ $mauswahl = "$ServerlaufzeitundNeustart" ]]; then rebootdatum; fi

		if [[ $mauswahl = "$Dateimennu" ]]; then dateimenu; fi
		if [[ $mauswahl = "$mySQLmenu" ]]; then mySQLmenu; fi
		if [[ $mauswahl = "$WeitereFunktionen" ]]; then funktionenmenu; fi
		if [[ $mauswahl = "$ExpertenFunktionen" ]]; then expertenmenu; fi
		if [[ $mauswahl = "$BuildFunktionen" ]]; then buildmenu; fi
		if [[ $mauswahl = "$Avatarmennu" ]]; then avatarmenu; fi

		if [[ $mantwort = 2 ]]; then hilfemenu; fi
		if [[ $mantwort = 1 ]]; then osmexit; fi
	else
		# wenn dialog nicht installiert ist die Hilfe anzeigen.
		hilfe
	fi
}

## * funktionenmenu
	# Menue fuer Funktionen.
	# 
	#? @param name Erklaerung.
	#? @return name was wird zurueckgegeben.
	# todo: nichts.
##
function funktionenmenu() {
	HEIGHT=0
	WIDTH=0
	CHOICE_HEIGHT=30
	BACKTITLE="opensimMULTITOOL"
	TITLE="Funktionsmenu"
	MENU="opensimMULTITOOL $VERSION"

	Gridstarten=$(menutrans "Grid starten")
	Gridstoppen=$(menutrans "Grid stoppen")

	Robuststarten=$(menutrans "Robust starten")
	Robuststoppen=$(menutrans "Robust stoppen")
	Moneystarten=$(menutrans "Money starten")
	Moneystoppen=$(menutrans "Money stoppen")

	AutomatischerSimstart=$(menutrans "Automatischer Sim start")
	AutomatischerSimstop=$(menutrans "Automatischer Sim stop")

	AutomatischerScreenstop=$(menutrans "Automatischer Screen stop")
	Regionenanzeigen=$(menutrans "Regionen anzeigen")

	Hauptmennu=$(menutrans "Hauptmennu")
	Avatarmennu=$(menutrans "Avatarmennu")
	Dateimennu=$(menutrans "Dateimennu")
	mySQLmenu=$(menutrans "mySQLmenu")
	BuildFunktionen=$(menutrans "Build Funktionen")
	ExpertenFunktionen=$(menutrans "Experten Funktionen")

	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then
		OPTIONS=("$Gridstarten" ""
			"$Gridstoppen" ""
			"--------------------------" ""
			"$Robuststarten" ""
			"$Robuststoppen" ""
			"$Moneystarten" ""
			"$Moneystoppen" ""
			"--------------------------" ""
			"$AutomatischerSimstart" ""
			"$AutomatischerSimstop" ""
			"--------------------------" ""
			"$AutomatischerScreenstop" ""
			"$Regionenanzeigen" ""
			"----------Menu------------" ""
			"$Hauptmennu" ""
			"$Avatarmennu" ""
			"$Dateimennu" ""
			"$mySQLmenu" ""
			"$BuildFunktionen" ""
			"$ExpertenFunktionen" "")

		fauswahl=$(dialog --backtitle "$BACKTITLE" --title "$TITLE" --help-button --defaultno --menu "$MENU" $HEIGHT $WIDTH $CHOICE_HEIGHT "${OPTIONS[@]}" 2>&1 >/dev/tty)

		fantwort=$?
		#dialogclear
		dialog --clear
		ScreenLog

		if [[ $fauswahl = "$Gridstarten" ]]; then gridstart; fi
		if [[ $fauswahl = "$Gridstoppen" ]]; then gridstop; fi
		if [[ $fauswahl = "$Robuststarten" ]]; then rostart; fi
		if [[ $fauswahl = "$Robuststoppen" ]]; then rostop; fi
		if [[ $fauswahl = "$Moneystarten" ]]; then mostart; fi
		if [[ $fauswahl = "$Moneystoppen" ]]; then mostop; fi
		if [[ $fauswahl = "$AutomatischerSimstart" ]]; then menuautosimstart; fi
		if [[ $fauswahl = "$AutomatischerSimstop" ]]; then menuautosimstop; fi
		if [[ $fauswahl = "$AutomatischerScreenstop" ]]; then autoscreenstop; fi
		if [[ $fauswahl = "$Regionenanzeigen" ]]; then meineregionen; fi

		if [[ $fauswahl = "$Dateimennu" ]]; then dateimenu; fi
		if [[ $fauswahl = "$mySQLmenu" ]]; then mySQLmenu; fi
		if [[ $fauswahl = "$Hauptmennu" ]]; then hauptmenu; fi
		if [[ $fauswahl = "$ExpertenFunktionen" ]]; then expertenmenu; fi
		if [[ $fauswahl = "$BuildFunktionen" ]]; then buildmenu; fi
		if [[ $fauswahl = "$Avatarmennu" ]]; then avatarmenu; fi

		if [[ $fantwort = 2 ]]; then hilfemenu; fi
		if [[ $fantwort = 1 ]]; then osmexit; fi
	else
		# wenn dialog nicht installiert ist die Hilfe anzeigen.
		hilfe
	fi
}

## * dateimenu
	# Menue fuer Dateifunktionen.
	# 
	#? @param name Erklaerung.
	#? @return name was wird zurueckgegeben.
	# todo: nichts.
##
function dateimenu() {
	HEIGHT=0
	WIDTH=0
	CHOICE_HEIGHT=30
	BACKTITLE="opensimMULTITOOL"
	TITLE="Dateimenu"
	MENU="opensimMULTITOOL $VERSION"

	Inventarspeichern=$(menutrans "Inventar speichern")
	Inventarladen=$(menutrans "Inventar laden")
	RegionOARsichern=$(menutrans "Region OAR sichern")
	AutomatischerRegionsbackup=$(menutrans "Automatischer Regionsbackup")

	LogDateienloeschen=$(menutrans "Log Dateien loeschen")
	MapKartenloeschen=$(menutrans "Map Karten loeschen")
	AssetCacheloeschen=$(menutrans "Asset Cache loeschen")
	Assetloeschen=$(menutrans "Asset loeschen")

	GridKonfigurationenerstellen=$(menutrans "Grid Konfigurationen erstellen")

	Hauptmenu=$(menutrans "Hauptmenu")
	Avatarmennu=$(menutrans "Avatarmennu")
	WeitereFunktionen=$(menutrans "Weitere Funktionen")
	mySQLmenu=$(menutrans "mySQLmenu")
	BuildFunktionen=$(menutrans "Build Funktionen")
	ExpertenFunktionen=$(menutrans "Experten Funktionen")

	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then
		OPTIONS=("$Inventarspeichern" ""
			"$Inventarladen" ""
			"$RegionOARsichern" ""
			"$AutomatischerRegionsbackup" ""
			"--------------------------" ""
			"$LogDateienloeschen" ""
			"$MapKartenloeschen" ""
			"$AssetCacheloeschen" ""
			"$Assetloeschen" ""
			"--------------------------" ""
			"$GridKonfigurationenerstellen" ""
			"----------Menu------------" ""
			"$Hauptmenu" ""
			"$Avatarmennu" ""
			"$WeitereFunktionen" ""
			"$mySQLmenu" ""
			"$BuildFunktionen" ""
			"$ExpertenFunktionen" "")

		dauswahl==$(dialog --backtitle "$BACKTITLE" --title "$TITLE" --help-button --defaultno --menu "$MENU" $HEIGHT $WIDTH $CHOICE_HEIGHT "${OPTIONS[@]}" 2>&1 >/dev/tty)
		dantwort=$?
		#dialogclear
		dialog --clear
		ScreenLog

		if [[ $dauswahl = "$Inventarspeichern" ]]; then menusaveinventar; fi
		if [[ $dauswahl = "$Inventarladen" ]]; then menuloadinventar; fi
		if [[ $dauswahl = "$RegionOARsichern" ]]; then menuregionbackup; fi
		if [[ $dauswahl = "$AutomatischerRegionsbackup" ]]; then autoregionbackup; fi
		# -----	
		if [[ $dauswahl = "$LogDateienloeschen" ]]; then autologdel; fi
		if [[ $dauswahl = "$MapKartenloeschen" ]]; then automapdel; fi		
		if [[ $dauswahl = "$Assetloeschen" ]]; then menuassetdel; fi
		if [[ $dauswahl = "$AssetCacheloeschen" ]]; then autoassetcachedel; fi
		# -----
		if [[ $dauswahl = "$GridKonfigurationenerstellen" ]]; then configabfrage; fi		
		# -----
		if [[ $dauswahl = "$Hauptmenu" ]]; then hauptmenu; fi
		if [[ $dauswahl = "$mySQLmenu" ]]; then mySQLmenu; fi
		if [[ $dauswahl = "$WeitereFunktionen" ]]; then funktionenmenu; fi
		if [[ $dauswahl = "$ExpertenFunktionen" ]]; then expertenmenu; fi
		if [[ $dauswahl = "$BuildFunktionen" ]]; then buildmenu; fi
		if [[ $dauswahl = "$Avatarmennu" ]]; then avatarmenu; fi

		if [[ $dantwort = 2 ]]; then hilfemenu; fi
		if [[ $dantwort = 1 ]]; then osmexit; fi
	else
		# wenn dialog nicht installiert ist die Hilfe anzeigen.
		hilfe
	fi
}

## * mySQLmenu
	# Menue fuer SQL Funktionen.
	# 
	#? @param name Erklaerung.
	#? @return name was wird zurueckgegeben.
	# todo: nichts.
##
function mySQLmenu() {
	HEIGHT=0
	WIDTH=0
	CHOICE_HEIGHT=30
	BACKTITLE="opensimMULTITOOL"
	TITLE="mySQLmenu"
	MENU="opensimMULTITOOL $VERSION"

	AlleDatenbankenanzeigen=$(menutrans "Alle Datenbanken anzeigen")
	TabelleneinerDatenbank=$(menutrans "Tabellen einer Datenbank")
	mySQLDatenbankbenutzeranzeigen=$(menutrans "mySQL Datenbankbenutzer anzeigen")
	AlleGridRegionenlisten=$(menutrans "Alle Grid Regionen listen")			
	RegionURIpruefensortiertnachURI=$(menutrans "Region URI pruefen sortiert nach URI")
	PortspruefensortiertnachPorts=$(menutrans "Ports pruefen sortiert nach Ports")			
	Benutzerinventoryfolders=$(menutrans "Benutzer inventoryfolders alles was type -1 ist anzeigen")
	ZeigeErstellungsdatumeinesUsersan=$(menutrans "Zeige Erstellungsdatum eines Users an")
	FindefalscheEMailAdressen=$(menutrans "Finde falsche E-Mail Adressen")
	ListetalleerstelltenBenutzerrechteauf=$(menutrans "Listet alle erstellten Benutzerrechte auf")

	NeueDatenbankerstellen=$(menutrans "Neue Datenbank erstellen")
	NeuenDatenbankbenutzeranlegen=$(menutrans "Neuen Datenbankbenutzer anlegen")

	Datenbankleeren=$(menutrans "Datenbank leeren")
	Datenbankkomplettloeschen=$(menutrans "Datenbank komplett loeschen")
	LoeschteinenDatenbankbenutzer=$(menutrans "Loescht einen Datenbankbenutzer")

	mysqlTunerherunterladen=$(menutrans "mysqlTuner herunterladen")
	AlleDatenbankenCheckenReparierenundOptimieren=$(menutrans "Alle Datenbanken Checken, Reparieren und Optimieren")			

	Hauptmenu=$(menutrans "Hauptmenu")
	Avatarmennu=$(menutrans "Avatarmennu")
	WeitereFunktionen=$(menutrans "Weitere Funktionen")
	Dateimennu=$(menutrans "Dateimennu")
	BuildFunktionen=$(menutrans "Build Funktionen")
	ExpertenFunktionen=$(menutrans "Experten Funktionen")

	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then
		OPTIONS=("$AlleDatenbankenanzeigen" ""
			"$TabelleneinerDatenbank" ""
			"$mySQLDatenbankbenutzeranzeigen" ""
			"$AlleGridRegionenlisten" ""			
			"$RegionURIpruefensortiertnachURI" ""
			"$PortspruefensortiertnachPorts" ""			
			"$Benutzerinventoryfolders" ""
			"$ZeigeErstellungsdatumeinesUsersan" ""
			"$FindefalscheEMailAdressen" ""
			"$ListetalleerstelltenBenutzerrechteauf" ""
			"--------------------------" ""
			"$NeueDatenbankerstellen" ""
			"$NeuenDatenbankbenutzeranlegen" ""
			"--------------------------" ""
			"$Datenbankleeren" ""
			"$Datenbankkomplettloeschen" ""
			"$LoeschteinenDatenbankbenutzer" ""
			"--------------------------" ""
			"$mysqlTunerherunterladen" ""
			"$AlleDatenbankenCheckenReparierenundOptimieren" ""			
			"----------Menu------------" ""
			"$Hauptmenu" ""
			"$Avatarmennu" ""
			"$WeitereFunktionen" ""
			"$Dateimennu" ""
			"$BuildFunktionen" ""
			"$ExpertenFunktionen" "")

		mysqlauswahl=$(dialog --backtitle "$BACKTITLE" --title "$TITLE" --help-button --defaultno --menu "$MENU" $HEIGHT $WIDTH $CHOICE_HEIGHT "${OPTIONS[@]}" 2>&1 >/dev/tty)
		mysqlantwort=$?
		#dialogclear
		dialog --clear
		ScreenLog

		# db_anzeigen_dialog, db_tables_dialog, db_all_user_dialog, db_all_uuid_dialog, db_email_setincorrectuseroff_dialog, db_setuseronline_dialog, db_setuserofline_dialog
		# db_all_name_dialog, db_user_data_dialog, db_user_infos_dialog, db_user_uuid_dialog

		if [[ $mysqlauswahl = "$AlleDatenbankenanzeigen" ]]; then db_anzeigen_dialog; fi
		if [[ $mysqlauswahl = "$TabelleneinerDatenbank" ]]; then db_tables_dialog; fi		

		if [[ $mysqlauswahl = "$mySQLDatenbankbenutzeranzeigen" ]]; then db_benutzer_anzeigen; fi
		if [[ $mysqlauswahl = "$AlleGridRegionenlisten" ]]; then db_regions; fi
		if [[ $mysqlauswahl = "$RegionURIpruefensortiertnachURI" ]]; then db_regionsuri; fi
		if [[ $mysqlauswahl = "$PortspruefensortiertnachPorts" ]]; then db_regionsport; fi
		if [[ $mysqlauswahl = "$NeueDatenbankerstellen" ]]; then db_create; fi
		if [[ $mysqlauswahl = "$Benutzerinventoryfolders" ]]; then db_all_userfailed; fi
		if [[ $mysqlauswahl = "$ZeigeErstellungsdatumeinesUsersan" ]]; then db_userdate; fi
		if [[ $mysqlauswahl = "$FindefalscheEMailAdressen" ]]; then db_false_email; fi
		if [[ $mysqlauswahl = "$Datenbankkomplettloeschen" ]]; then db_delete; fi

		if [[ $mysqlauswahl = "$Datenbankleeren" ]]; then db_empty; fi
		if [[ $mysqlauswahl = "$NeuenDatenbankbenutzeranlegen" ]]; then db_create_new_dbuser; fi
		if [[ $mysqlauswahl = "$ListetalleerstelltenBenutzerrechteauf" ]]; then db_dbuserrechte; fi
		if [[ $mysqlauswahl = "$LoeschteinenDatenbankbenutzer" ]]; then db_deldbuser; fi
		if [[ $mysqlauswahl = "$AlleDatenbankenCheckenReparierenundOptimieren" ]]; then allrepair_db; fi
		if [[ $mysqlauswahl = "$mysqlTunerherunterladen" ]]; then install_mysqltuner; fi
		# -----
		if [[ $mysqlauswahl = "$Hauptmenu" ]]; then hauptmenu; fi
		if [[ $mysqlauswahl = "$Dateimennu" ]]; then dateimenu; fi
		if [[ $mysqlauswahl = "$WeitereFunktionen" ]]; then funktionenmenu; fi
		if [[ $mysqlauswahl = "$ExpertenFunktionen" ]]; then expertenmenu; fi
		if [[ $mysqlauswahl = "$BuildFunktionen" ]]; then buildmenu; fi
		if [[ $mysqlauswahl = "$Avatarmennu" ]]; then avatarmenu; fi

		if [[ $mysqlantwort = 2 ]]; then hilfemenu; fi
		if [[ $mysqlantwort = 1 ]]; then osmexit; fi
	else
		# wenn dialog nicht installiert ist die Hilfe anzeigen.
		hilfe
	fi
}

## * avatarmenu
	# Menue fuer Benutzerfunktionen.
	# 
	#? @param name Erklaerung.
	#? @return name was wird zurueckgegeben.
	# todo: nichts.
##
function avatarmenu() {
	HEIGHT=0
	WIDTH=0
	CHOICE_HEIGHT=30
	BACKTITLE="opensimMULTITOOL"
	TITLE="Avatarmenu"
	MENU="opensimMULTITOOL $VERSION"

	AlleBenutzerdatenderROBUSTDatenbank=$(menutrans "Alle Benutzerdaten der ROBUST Datenbank")
	UUIDvonallenBenutzernanzeigen=$(menutrans "UUID von allen Benutzern anzeigen")
	AlleBenutzernamenanzeigen=$(menutrans "Alle Benutzernamen anzeigen")
	DatenvoneinemBenutzeranzeigen=$(menutrans "Daten von einem Benutzer anzeigen")
	UUIDVorNachnameEMailvomBenutzeranzeigen=$(menutrans "UUID, Vor, Nachname, E-Mail vom Benutzer anzeigen")
	UUIDvoneinemBenutzeranzeigen=$(menutrans "UUID von einem Benutzer anzeigen")

	AlleBenutzermitinkorrekterEMailabschalten=$(menutrans "Alle Benutzer mit inkorrekter EMail abschalten")
	Benutzeracountabschalten=$(menutrans "Benutzeracount abschalten")
	Benutzeracounteinschalten=$(menutrans "Benutzeracount einschalten")

	Hauptmennu=$(menutrans "Hauptmennu")
	Avatarmennu=$(menutrans "Avatarmennu")
	Dateimennu=$(menutrans "Dateimennu")
	mySQLmenu=$(menutrans "mySQLmenu")
	BuildFunktionen=$(menutrans "Build Funktionen")
	ExpertenFunktionen=$(menutrans "Experten Funktionen")

	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then
		OPTIONS=("$AlleBenutzerdatenderROBUSTDatenbank" ""
			"$UUIDvonallenBenutzernanzeigen" ""
			"$AlleBenutzernamenanzeigen" ""
			"$DatenvoneinemBenutzeranzeigen" ""
			"$UUIDVorNachnameEMailvomBenutzeranzeigen" ""
			"$UUIDvoneinemBenutzeranzeigen" ""
			"--------------------------" ""
			"$AlleBenutzermitinkorrekterEMailabschalten" ""
			"$Benutzeracountabschalten" ""
			"$Benutzeracounteinschalten" ""
			"----------Menu------------" ""
			"$Hauptmennu" ""
			"$Avatarmennu" ""
			"$Dateimennu" ""
			"$mySQLmenu" ""
			"$BuildFunktionen" ""
			"$ExpertenFunktionen" "")

		avatarauswahl=$(dialog --backtitle "$BACKTITLE" --title "$TITLE" --help-button --defaultno --menu "$MENU" $HEIGHT $WIDTH $CHOICE_HEIGHT "${OPTIONS[@]}" 2>&1 >/dev/tty)

		avatarantwort=$?
		#dialogclear
		dialog --clear
		ScreenLog

		if [[ $avatarauswahl = "$AlleBenutzerdatenderROBUSTDatenbank" ]]; then db_all_user_dialog; fi
		if [[ $avatarauswahl = "$UUIDvonallenBenutzernanzeigen" ]]; then db_all_uuid_dialog; fi
		
		if [[ $avatarauswahl = "$AlleBenutzernamenanzeigen" ]]; then db_all_name_dialog; fi
		if [[ $avatarauswahl = "$DatenvoneinemBenutzeranzeigen" ]]; then db_user_data_dialog; fi
		if [[ $avatarauswahl = "$UUIDVorNachnameEMailvomBenutzeranzeigen" ]]; then db_user_infos_dialog; fi
		if [[ $avatarauswahl = "$UUIDvoneinemBenutzeranzeigen" ]]; then db_user_uuid_dialog; fi
		
		if [[ $avatarauswahl = "$AlleBenutzermitinkorrekterEMailabschalten" ]]; then db_email_setincorrectuseroff_dialog; fi
		if [[ $avatarauswahl = "$Benutzeracountabschalten" ]]; then db_setuserofline_dialog; fi
		if [[ $avatarauswahl = "$Benutzeracounteinschalten" ]]; then db_setuseronline_dialog; fi

		if [[ $avatarauswahl = "$Dateimennu" ]]; then dateimenu; fi
		if [[ $avatarauswahl = "$mySQLmenu" ]]; then mySQLmenu; fi
		if [[ $avatarauswahl = "$Hauptmennu" ]]; then hauptmenu; fi
		if [[ $avatarauswahl = "$ExpertenFunktionen" ]]; then expertenmenu; fi
		if [[ $avatarauswahl = "$BuildFunktionen" ]]; then buildmenu; fi

		if [[ $avatarantwort = 2 ]]; then hilfemenu; fi
		if [[ $avatarantwort = 1 ]]; then osmexit; fi
	else
		# wenn dialog nicht installiert ist die Hilfe anzeigen.
		hilfe
	fi
}

## * buildmenu
	# Menue zum erstellen von OpenSim Versionen.
	# 
	#? @param name Erklaerung.
	#? @return name was wird zurueckgegeben.
	# todo: nichts.
##
function buildmenu() {
	HEIGHT=0
	WIDTH=0
	CHOICE_HEIGHT=30
	BACKTITLE="opensimMULTITOOL"
	TITLE="Buildmenu"
	MENU="opensimMULTITOOL $VERSION"

	OpenSimherunterladen=$(menutrans "OpenSim herunterladen")
	MoneyServervomgitkopieren=$(menutrans "MoneyServer vom git kopieren")
	OSSLSkriptevomgitkopieren=$(menutrans "OSSL Skripte vom git kopieren")
	OpensimvomGithubholen=$(menutrans "Opensim vom Github holen")

	DowngradezurletztenVersion=$(menutrans "Downgrade zur letzten Version")
	Kompilieren=$(menutrans "Kompilieren")
	oscompi=$(menutrans "oscompi")
	Opensimulatorupgraden=$(menutrans "Opensimulator upgraden")
	Opensimulatorauszipupgraden=$(menutrans "Opensimulator aus zip upgraden")
	Opensimulatorbauenundupgraden=$(menutrans "Opensimulator bauen und upgraden")
			
	KonfigurationenundVerzeichnisstrukturenanlegen=$(menutrans "Konfigurationen und Verzeichnisstrukturen anlegen")
	Verzeichnisstrukturenanlegen=$(menutrans "Verzeichnisstrukturen anlegen")
	RegionslisteerstellenBackup=$(menutrans "Regionsliste erstellen (Backup)")

	SiminVerzeichnisstruktureneintragen=$(menutrans "Sim in Verzeichnisstrukturen eintragen")
	SiminVerzeichnisstrukturenaustragen=$(menutrans "Sim in Verzeichnisstrukturen austragen")
	SiminStartkonfigurationeinfuegen=$(menutrans "Sim in Startkonfiguration einfuegen")
	SimausStartkonfigurationentfernen=$(menutrans "Sim aus Startkonfiguration entfernen")

	Hauptmennu=$(menutrans "Hauptmennu")
	Avatarmennu=$(menutrans "Avatarmennu")
	WeitereFunktionen=$(menutrans "Weitere Funktionen")
	Dateimennu=$(menutrans "Dateimennu")
	mySQLmenu=$(menutrans "mySQLmenu")
	ExpertenFunktionen=$(menutrans "Experten Funktionen")

	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then
		OPTIONS=("$OpenSimherunterladen" ""
			"$MoneyServervomgitkopieren" ""
			"$OSSLSkriptevomgitkopieren" ""
			"$OpensimvomGithubholen" ""
			"--------------------------" ""
			"$DowngradezurletztenVersion" ""
			"$Kompilieren" ""
			"$oscompi" ""
			"$Opensimulatorupgraden" ""
			"$Opensimulatorauszipupgraden" ""
			"$Opensimulatorbauenundupgraden" ""
			"--------------------------" ""			
			"$KonfigurationenundVerzeichnisstrukturenanlegen" ""
			"$Verzeichnisstrukturenanlegen" ""
			"$RegionslisteerstellenBackup" ""
			"--------------------------" ""
			"$SiminVerzeichnisstruktureneintragen" ""
			"$SiminVerzeichnisstrukturenaustragen" ""
			"$SiminStartkonfigurationeinfuegen" ""
			"$SimausStartkonfigurationentfernen" ""
			"----------Menu------------" ""
			"$Hauptmenu" ""
			"$Avatarmennu" ""
			"$WeitereFunktionen" ""
			"$Dateimennu" ""
			"$mySQLmenu" ""
			"$ExpertenFunktionen" "")

		buildauswahl=$(dialog --backtitle "$BACKTITLE" --title "$TITLE" --help-button --defaultno --menu "$MENU" $HEIGHT $WIDTH $CHOICE_HEIGHT "${OPTIONS[@]}" 2>&1 >/dev/tty)
		buildantwort=$?
		if [[ $buildantwort = 1 ]]; then osmexit; fi
		if [[ $buildantwort = 2 ]]; then hilfemenu; fi
		#warnbox $buildantwort
		#dialogclear
		dialog --clear
		ScreenLog

		if [[ $buildauswahl = "$OpenSimherunterladen" ]]; then downloados; fi
		if [[ $buildauswahl = "$MoneyServervomgitkopieren" ]]; then moneygitcopy; fi
		if [[ $buildauswahl = "$OSSLSkriptevomgitkopieren" ]]; then scriptgitcopy; fi
		if [[ $buildauswahl = "$OpensimvomGithubholen" ]]; then osgitholen; fi
		# -----
		if [[ $buildauswahl = "$DowngradezurletztenVersion" ]]; then osdowngrade; fi
		if [[ $buildauswahl = "$Kompilieren" ]]; then compilieren; fi
		if [[ $buildauswahl = "$oscompi" ]]; then oscompi; fi
		if [[ $buildauswahl = "$Opensimulatorupgraden" ]]; then osupgrade; fi
		if [[ $buildauswahl = "$Opensimulatorauszipupgraden" ]]; then oszipupgrade; fi
		if [[ $buildauswahl = "$Opensimulatorbauenundupgraden" ]]; then osbuilding; fi
		# -----
		if [[ $buildauswahl = "$KonfigurationenundVerzeichnisstrukturenanlegen" ]]; then configabfrage; fi
		if [[ $buildauswahl = "$Verzeichnisstrukturenanlegen" ]]; then menuosstruktur; fi
		if [[ $buildauswahl = "$RegionslisteerstellenBackup" ]]; then regionliste; fi
		# -----
		if [[ $buildauswahl = "$SiminVerzeichnisstruktureneintragen" ]]; then menuosstarteintrag; fi
		if [[ $buildauswahl = "$SiminVerzeichnisstrukturenaustragen" ]]; then menuosstarteintragdel; fi
		if [[ $buildauswahl = "$SiminStartkonfigurationeinfuegen" ]]; then menuosdauerstart; fi
		if [[ $buildauswahl = "$SimausStartkonfigurationentfernen" ]]; then menuosdauerstop; fi

		if [[ $buildauswahl = "$Hauptmenu" ]]; then hauptmenu; fi
		if [[ $buildauswahl = "$Dateimennu" ]]; then dateimenu; fi
		if [[ $buildauswahl = "$mySQLmenu" ]]; then mySQLmenu; fi
		if [[ $buildauswahl = "$WeitereFunktionen" ]]; then funktionenmenu; fi
		if [[ $buildauswahl = "$ExpertenFunktionen" ]]; then expertenmenu; fi
		if [[ $buildauswahl = "$Avatarmennu" ]]; then avatarmenu; fi

		#if [[ $buildantwort = 2 ]]; then hilfemenu; fi
		#if [[ $buildantwort = 1 ]]; then warnbox $buildantwort; fi
	else
		# wenn dialog nicht installiert ist die Hilfe anzeigen.
		hilfe
	fi
}

## * expertenmenu
	# Menuepunkte fuer Experten.
	# 
	#? @param name Erklaerung.
	#? @return name was wird zurueckgegeben.
	# todo: nichts.
##
function expertenmenu() {
	HEIGHT=0
	WIDTH=0
	CHOICE_HEIGHT=30
	BACKTITLE="opensimMULTITOOL"
	TITLE="Expertenmenu"
	MENU="opensimMULTITOOL $VERSION"

	ExampleDateienumbenennen=$(menutrans "Example Dateien umbenennen")
	Voreinstellungensetzen=$(menutrans "Voreinstellungen setzen")

	autoregionsiniteilen=$(menutrans "autoregionsiniteilen")
	RegionListe=$(menutrans "RegionListe")

	ServerInstallation=$(menutrans "Server Installation")
	ServerInstallationfuerWordPress=$(menutrans "Server Installation fuer WordPress")
	ServerInstallationohnemono=$(menutrans "Server Installation ohne mono")
	MonoInstallation=$(menutrans "Mono Installation")

	terminator=$(menutrans "terminator")
	makeaot=$(menutrans "make AOT")
	cleanaot=$(menutrans "clean AOT")
	Installationenanzeigen=$(menutrans "Installationen anzeigen")

	KommandoanOpenSimsenden=$(trans -brief -no-warn "Kommando an OpenSim senden")

	Hauptmennu=$(menutrans "Hauptmennu")
	Avatarmennu=$(menutrans "Avatarmennu")
	WeitereFunktionen=$(menutrans "Weitere Funktionen")
	Dateimennu=$(menutrans "Dateimennu")
	mySQLmenu=$(menutrans "mySQLmenu")
	BuildFunktionen=$(menutrans "Build Funktionen")

	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then
		OPTIONS=("$ExampleDateienumbenennen" ""
			"$Voreinstellungensetzen" ""
			"--------------------------" ""
			"$autoregionsiniteilen" ""
			"$RegionListe" ""
			"--------------------------" ""
			"$ServerInstallation" ""
			"$ServerInstallationfuerWordPress" ""
			"$ServerInstallationohnemono" ""
			"$MonoInstallation" ""
			"--------------------------" ""
			"$terminator" ""
			"$makeaot" ""
			"$cleanaot" ""
			"$Installationenanzeigen" ""
			"--------------------------" ""
			"$KommandoanOpenSimsenden" ""
			"----------Menu------------" ""
			"$Hauptmennu" ""
			"$Avatarmennu" ""
			"$WeitereFunktionen" ""
			"$Dateimennu" ""
			"$mySQLmenu" ""
			"$BuildFunktionen" "")

		feauswahl=$(dialog --backtitle "$BACKTITLE" --title "$TITLE" --help-button --defaultno --menu "$MENU" $HEIGHT $WIDTH $CHOICE_HEIGHT "${OPTIONS[@]}" 2>&1 >/dev/tty)
		fantwort=$?
		#dialogclear
		dialog --clear
		ScreenLog

		if [[ $feauswahl = "$ExampleDateienumbenennen" ]]; then unlockexample; fi
		if [[ $feauswahl = "$Voreinstellungensetzen" ]]; then ossettings; fi

		if [[ $feauswahl = "$KommandoanOpenSimsenden" ]]; then menuoscommand; fi

		if [[ $feauswahl = "$autoregionsiniteilen" ]]; then autoregionsiniteilen; fi
		if [[ $feauswahl = "$RegionListe" ]]; then regionliste; fi

		if [[ $feauswahl = "$terminator" ]]; then terminator; fi
		if [[ $feauswahl = "$makeaot" ]]; then makeaot; fi
		if [[ $feauswahl = "$cleanaot" ]]; then cleanaot; fi
		if [[ $feauswahl = "$Installationenanzeigen" ]]; then installationen; fi

		if [[ $feauswahl = "$ServerInstallation" ]]; then serverinstall; fi
		if [[ $feauswahl = "$ServerInstallationfuerWordPress" ]]; then installwordpress; fi
		if [[ $feauswahl = "$ServerInstallationohnemono" ]]; then installopensimulator; fi
		if [[ $feauswahl = "$MonoInstallation" ]]; then monoinstall; fi

		if [[ $feauswahl = "$Dateimennu" ]]; then dateimenu; fi
		if [[ $feauswahl = "$mySQLmenu" ]]; then mySQLmenu; fi
		if [[ $feauswahl = "$Hauptmennu" ]]; then hauptmenu; fi
		if [[ $feauswahl = "$WeitereFunktionen" ]]; then funktionenmenu; fi
		if [[ $feauswahl = "$BuildFunktionen" ]]; then buildmenu; fi
		if [[ $feauswahl = "$Avatarmennu" ]]; then avatarmenu; fi

		if [[ $fantwort = 2 ]]; then hilfemenu; fi
		if [[ $fantwort = 1 ]]; then osmexit; fi
	else
		# wenn dialog nicht installiert ist die Hilfe anzeigen.
		hilfe
	fi
}

## *  mainMenu Test alle Funktionen
	# Shell-Skript-Menü mit allen Funktionen
	# Dieses Skript bietet ein Menü mit verschiedenen Funktionen, die der Benutzer auswählen und ausführen kann.
	#! !!!!! WARNUNG !!!!! Dies darf nur von Personen die wissen was sie machen benutzt werden.
	#! !!!!! WARNING !!!!! This should only be used by people who know what they are doing.
	#? Verwendung:
	#   bash osmtool.sh mainMenu
	#? Abhängigkeiten:
	#   - Das Skript verwendet das dialog-Tool, das installiert sein muss.
##
function mainMenu() {
  while true; do
    choice=$(dialog --defaultno --menu "Hauptmenü" 0 0 0 \
	accesslog "" \
	all "" \
	allclean "" \
	allrepair_db "" \
	apacheerror "" \
	assetcachedel "" \
	assetdel "" \
	authlog "" \
	autoallclean "" \
	autoassetcachedel "" \
	AutoInstall "" \
	autologdel "" \
	automapdel "" \
	autoregionbackup "" \
	autoregionsiniteilen "" \
	autorestart "" \
	autorobustmapdel "" \
	autoscreenstop "" \
	autosimstart "" \
	autosimstop "" \
	autostart "" \
	autostop "" \
	avatarmenu "" \
	backupdatum "" \
	benutzer "" \
	buildmenu "" \
	checkfile "" \
	checkupgrade93 "" \
	cleanaot "" \
	cleaninstall "" \
	cleanprebuild "" \
	clearuserlist "" \
	commandhelp "" \
	compilieren "" \
	configabfrage "" \
	configlesen "" \
	ConfigSet "" \
	conf_delete "" \
	conf_read "" \
	conf_write "" \
	connection_name "" \
	constconfig "" \
	createdatabase "" \
	createdbuser "" \
	createmanual "" \
	createmasteravatar "" \
	createregionavatar "" \
	createuser "" \
	create_db "" \
	create_db_user "" \
	dalaiinstall "" \
	dalaiinstallinfos "" \
	dalaimodelinstall "" \
	dalaisearch "" \
	dalaiserverinstall "" \
	dalaistart "" \
	dalaistop "" \
	dalaiuninstall "" \
	dalaiupgrade "" \
	dateimenu "" \
	dbhilfe "" \
	db_all_name "" \
	db_all_name_dialog "" \
	db_all_user "" \
	db_all_userfailed "" \
	db_all_user_dialog "" \
	db_all_uuid "" \
	db_all_uuid_dialog "" \
	db_anzeigen "" \
	db_anzeigen_dialog "" \
	db_backup "" \
	db_backuptabellen "" \
	db_backuptabellentypen "" \
	db_backuptabelle_noassets "" \
	db_benutzer_anzeigen "" \
	db_compress_backup "" \
	db_create "" \
	db_create_new_dbuser "" \
	db_dbuser "" \
	db_dbuserrechte "" \
	db_deldbuser "" \
	db_delete "" \
	db_deletepartner "" \
	db_email_setincorrectuseroff "" \
	db_email_setincorrectuseroff_dialog "" \
	db_empty "" \
	db_false_email "" \
	db_foldertyp_user "" \
	db_friends "" \
	db_gridlist "" \
	db_inventar_no_assets "" \
	db_inv_search "" \
	db_online "" \
	db_region "" \
	db_regions "" \
	db_regionsport "" \
	db_regionsuri "" \
	db_region_anzahl_regionsid "" \
	db_region_anzahl_regionsnamen "" \
	db_region_parzelle "" \
	db_region_parzelle_pakete "" \
	db_restorebackuptabellen "" \
	db_setpartner "" \
	db_setuserofline "" \
	db_setuserofline_dialog "" \
	db_setuseronline "" \
	db_setuseronline_dialog "" \
	db_tabellencopy "" \
	db_tabellencopy_extern "" \
	db_tables "" \
	db_tablesplitt "" \
	db_tables_dialog "" \
	db_tablextract "" \
	db_tablextract_regex "" \
	db_ungenutzteobjekte "" \
	db_userdate "" \
	db_user_anzahl "" \
	db_user_data "" \
	db_user_data_dialog "" \
	db_user_infos "" \
	db_user_infos_dialog "" \
	db_user_online "" \
	db_user_uuid "" \
	db_user_uuid_dialog "" \
	default_master_connection "" \
	deladvantagetools "" \
	delete_db "" \
	delete_emty_mark "" \
	dialogclear "" \
	divacopy "" \
	divagitcopy "" \
	dotnetinfo "" \
	downloados "" \
	DO_DOMAIN_IDS "" \
	DO_DOMAIN_IDS2_nids "" \
	dummyvar "" \
	edittextbox "" \
	ende "" \
	expertenmenu "" \
	fail2banset "" \
	fehler "" \
	finstall "" \
	firstinstallation "" \
	flotsamconfig "" \
	fortschritsanzeige "" \
	fpspeicher "" \
	functionslist "" \
	funktionenmenu "" \
	getcachegroesse "" \
	getcachesinglegroesse "" \
	get_regionsarray "" \
	get_value_from_Region_key "" \
	gridcachedelete "" \
	gridstart "" \
	gridstop "" \
	hauptmenu "" \
	hilfe "" \
	hilfemenu "" \
	hilfemenudirektaufrufe "" \
	historylogclear "" \
	icecastconfig "" \
	icecastinstall "" \
	icecastrestart "" \
	icecaststart "" \
	icecaststop "" \
	icecastversion "" \
	IGNORE_DOMAIN_IDS "" \
	IGNORE_DOMAIN_IDS2_nids "" \
	IGNORE_SERVER_IDS "" \
	iinstall "" \
	iinstallnew "" \
	info "" \
	infodialog "" \
	ini_get "" \
	ini_set "" \
	installationen "" \
	installationhttps22 "" \
	installfinish "" \
	installmariadb18 "" \
	installmariadb22 "" \
	installopensimulator "" \
	installphpmyadmin "" \
	installubuntu22 "" \
	installwordpress "" \
	install_mysqltuner "" \
	instdialog "" \
	iptablesset "" \
	isroot "" \
	janein "" \
	kalender "" \
	konsolenhilfe "" \
	laeuftos "" \
	landclear "" \
	lastrebootdatum "" \
	letterdel "" \
	linuxupgrade "" \
	loadinventar "" \
	log "" \
	logdel "" \
	mainMenu "" \
	makeaot "" \
	makeregionsliste "" \
	makeverzeichnisliste "" \
	makewebmaps "" \
	mapdel "" \
	mariadberror "" \
	MASTER_CONNECT_RETRY "" \
	MASTER_DELAY "" \
	MASTER_HOST "" \
	MASTER_LOG_FILE "" \
	MASTER_LOG_POS "" \
	MASTER_PASSWORD "" \
	MASTER_PORT "" \
	MASTER_SSL "" \
	MASTER_SSL_CA "" \
	MASTER_SSL_CAPATH "" \
	MASTER_SSL_CERT "" \
	MASTER_SSL_CIPHER "" \
	MASTER_SSL_CRL "" \
	MASTER_SSL_CRLPATH "" \
	MASTER_SSL_KEY "" \
	MASTER_SSL_VERIFY_SERVER_CERT "" \
	MASTER_USER "" \
	MASTER_USE_GTID "" \
	MASTER_USE_GTID_slv "" \
	meineregionen "" \
	menuassetdel "" \
	menuautologdel "" \
	menuautorestart "" \
	menuautoscreenstop "" \
	menuautosimstart "" \
	menuautosimstop "" \
	menuautostart "" \
	menuautostop "" \
	menucreateuser "" \
	menufinstall "" \
	menugridstart "" \
	menugridstop "" \
	menuinfo "" \
	menukonsolenhilfe "" \
	menulandclear "" \
	menuloadinventar "" \
	menulogdel "" \
	menumapdel "" \
	menumostart "" \
	menumostop "" \
	menuoscommand "" \
	menuosdauerstart "" \
	menuosdauerstop "" \
	menuosstart "" \
	menuosstarteintrag "" \
	menuosstarteintragdel "" \
	menuosstop "" \
	menuosstruktur "" \
	menuoswriteconfig "" \
	menuregionbackup "" \
	menuregionrestore "" \
	menurostart "" \
	menurostop "" \
	menusaveinventar "" \
	menutrans "" \
	menuwaslauft "" \
	menuworks "" \
	moneyconfig "" \
	moneycopy "" \
	moneycopy93 "" \
	moneydelete "" \
	moneygitcopy "" \
	moneygitcopy93 "" \
	MoneyServerCommands "" \
	monoinstall "" \
	monoinstall18 "" \
	monoinstall20 "" \
	monoinstall22 "" \
	mostart "" \
	mostop "" \
	mutelistcopy "" \
	mysqlbackup "" \
	mysqldberror "" \
	mysqleinstellen "" \
	mySQLmenu "" \
	mysqlrest "" \
	mysqlrestnodb "" \
	mysql_neustart "" \
	nachrichtbox "" \
	namen "" \
	newhelp "" \
	newregionini "" \
	OpenSimCommands "" \
	opensimgitcopy93 "" \
	opensimholen "" \
	osbauen93 "" \
	osbuilding "" \
	osbuilding93 "" \
	osbuildingupgrade93 "" \
	oscommand "" \
	oscompi "" \
	oscompi93 "" \
	osconfigstruktur "" \
	oscopy "" \
	oscopyrobust "" \
	oscopysim "" \
	osdauerstart "" \
	osdauerstop "" \
	osdelete "" \
	osdowngrade "" \
	osgitholen "" \
	osgitholen93 "" \
	osgitstatus "" \
	osgridcopy "" \
	osmnotranslate "" \
	osmtoolconfig "" \
	osmtoolconfigabfrage "" \
	osmtranslate "" \
	osmtranslatedirekt "" \
	osmtranslateinstall "" \
	osmupgrade "" \
	osreparatur "" \
	osscreenstop "" \
	ossettings "" \
	osslEnableconfig "" \
	osslEnableConfig "" \
	osslEnableConfigSet "" \
	osstart "" \
	osstarteintrag "" \
	osstarteintragdel "" \
	osstop "" \
	osstruktur "" \
	ostimestamp "" \
	osupgrade "" \
	osupgrade93 "" \
	oswriteconfig "" \
	oszipupgrade "" \
	passgen "" \
	passwdgenerator "" \
	pull "" \
	radiolist "" \
	ramspeicher "" \
	randomname "" \
	reboot "" \
	rebootdatum "" \
	regionbackup "" \
	regionconfig "" \
	regionliste "" \
	regionrestore "" \
	regionsabfrage "" \
	regionsconfigdateiliste "" \
	regionsinisuchen "" \
	regionsiniteilen "" \
	regionsport "" \
	regionsuri "" \
	RELAY_LOG_FILE "" \
	RELAY_LOG_POS "" \
	remarklist "" \
	Replica_Backup "" \
	Replica_Backup_nmlp "" \
	ReplikatKoordinaten "" \
	robustbackup "" \
	RobustCommands "" \
	pCampbotCommands "" \
	rologdel "" \
	rostart "" \
	rostop "" \
	saveinventar "" \
	schreibeinfo "" \
	sckill "" \
	screenlist "" \
	screenlistrestart "" \
	ScreenLog "" \
	scriptcopy "" \
	scriptgitcopy "" \
	scstart "" \
	scstop "" \
	searchcopy "" \
	senddata "" \
	serverinstall "" \
	serverinstall22 "" \
	serverupgrade "" \
	setpartner "" \
	setversion "" \
	setversion93 "" \
	set_empty_user "" \
	show_info "" \
	simstats "" \
	skriptversion "" \
	sourcelist18 "" \
	sourcelist22 "" \
	systeminformation "" \
	tabellenabfrage "" \
	tastaturcachedelete "" \
	terminator "" \
	textbox "" \
	trimm "" \
	trim_all "" \
	trim_string "" \
	ufwblock "" \
	ufwlog "" \
	ufwoff "" \
	ufwport "" \
	ufwset "" \
	uncompress "" \
	vardel "" \
	vardelall "" \
	vartest "" \
	versionsausgabe93 "" \
	vornamen "" \
	warnbox "" \
	waslauft "" \
	works "" \
	xhelp "" \
	2>&1 >/dev/tty)
	
    case $choice in
	accesslog) accesslog; break ;;
	all) all; break ;;
	allclean) allclean; break ;;
	allrepair_db) allrepair_db; break ;;
	apacheerror) apacheerror; break ;;
	assetcachedel) assetcachedel; break ;;
	assetdel) assetdel; break ;;
	authlog) authlog; break ;;
	autoallclean) autoallclean; break ;;
	autoassetcachedel) autoassetcachedel; break ;;
	AutoInstall) AutoInstall; break ;;
	autologdel) autologdel; break ;;
	automapdel) automapdel; break ;;
	autoregionbackup) autoregionbackup; break ;;
	autoregionsiniteilen) autoregionsiniteilen; break ;;
	autorestart) autorestart; break ;;
	autorobustmapdel) autorobustmapdel; break ;;
	autoscreenstop) autoscreenstop; break ;;
	autosimstart) autosimstart; break ;;
	autosimstop) autosimstop; break ;;
	autostart) autostart; break ;;
	autostop) autostop; break ;;
	avatarmenu) avatarmenu; break ;;
	backupdatum) backupdatum; break ;;
	benutzer) benutzer; break ;;
	buildmenu) buildmenu; break ;;
	checkfile) checkfile; break ;;
	checkupgrade93) checkupgrade93; break ;;
	cleanaot) cleanaot; break ;;
	cleaninstall) cleaninstall; break ;;
	cleanprebuild) cleanprebuild; break ;;
	clearuserlist) clearuserlist; break ;;
	commandhelp) commandhelp; break ;;
	compilieren) compilieren; break ;;
	configabfrage) configabfrage; break ;;
	configlesen) configlesen; break ;;
	ConfigSet) ConfigSet; break ;;
	conf_delete) conf_delete; break ;;
	conf_read) conf_read; break ;;
	conf_write) conf_write; break ;;
	connection_name) connection_name; break ;;
	constconfig) constconfig; break ;;
	createdatabase) createdatabase; break ;;
	createdbuser) createdbuser; break ;;
	createmanual) createmanual; break ;;
	createmasteravatar) createmasteravatar; break ;;
	createregionavatar) createregionavatar; break ;;
	createuser) createuser; break ;;
	create_db) create_db; break ;;
	create_db_user) create_db_user; break ;;
	dalaiinstall) dalaiinstall; break ;;
	dalaiinstallinfos) dalaiinstallinfos; break ;;
	dalaimodelinstall) dalaimodelinstall; break ;;
	dalaisearch) dalaisearch; break ;;
	dalaiserverinstall) dalaiserverinstall; break ;;
	dalaistart) dalaistart; break ;;
	dalaistop) dalaistop; break ;;
	dalaiuninstall) dalaiuninstall; break ;;
	dalaiupgrade) dalaiupgrade; break ;;
	dateimenu) dateimenu; break ;;
	dbhilfe) dbhilfe; break ;;
	db_all_name) db_all_name; break ;;
	db_all_name_dialog) db_all_name_dialog; break ;;
	db_all_user) db_all_user; break ;;
	db_all_userfailed) db_all_userfailed; break ;;
	db_all_user_dialog) db_all_user_dialog; break ;;
	db_all_uuid) db_all_uuid; break ;;
	db_all_uuid_dialog) db_all_uuid_dialog; break ;;
	db_anzeigen) db_anzeigen; break ;;
	db_anzeigen_dialog) db_anzeigen_dialog; break ;;
	db_backup) db_backup; break ;;
	db_backuptabellen) db_backuptabellen; break ;;
	db_backuptabellentypen) db_backuptabellentypen; break ;;
	db_backuptabelle_noassets) db_backuptabelle_noassets; break ;;
	db_benutzer_anzeigen) db_benutzer_anzeigen; break ;;
	db_compress_backup) db_compress_backup; break ;;
	db_create) db_create; break ;;
	db_create_new_dbuser) db_create_new_dbuser; break ;;
	db_dbuser) db_dbuser; break ;;
	db_dbuserrechte) db_dbuserrechte; break ;;
	db_deldbuser) db_deldbuser; break ;;
	db_delete) db_delete; break ;;
	db_deletepartner) db_deletepartner; break ;;
	db_email_setincorrectuseroff) db_email_setincorrectuseroff; break ;;
	db_email_setincorrectuseroff_dialog) db_email_setincorrectuseroff_dialog; break ;;
	db_empty) db_empty; break ;;
	db_false_email) db_false_email; break ;;
	db_foldertyp_user) db_foldertyp_user; break ;;
	db_friends) db_friends; break ;;
	db_gridlist) db_gridlist; break ;;
	db_inventar_no_assets) db_inventar_no_assets; break ;;
	db_inv_search) db_inv_search; break ;;
	db_online) db_online; break ;;
	db_region) db_region; break ;;
	db_regions) db_regions; break ;;
	db_regionsport) db_regionsport; break ;;
	db_regionsuri) db_regionsuri; break ;;
	db_region_anzahl_regionsid) db_region_anzahl_regionsid; break ;;
	db_region_anzahl_regionsnamen) db_region_anzahl_regionsnamen; break ;;
	db_region_parzelle) db_region_parzelle; break ;;
	db_region_parzelle_pakete) db_region_parzelle_pakete; break ;;
	db_restorebackuptabellen) db_restorebackuptabellen; break ;;
	db_setpartner) db_setpartner; break ;;
	db_setuserofline) db_setuserofline; break ;;
	db_setuserofline_dialog) db_setuserofline_dialog; break ;;
	db_setuseronline) db_setuseronline; break ;;
	db_setuseronline_dialog) db_setuseronline_dialog; break ;;
	db_tabellencopy) db_tabellencopy; break ;;
	db_tabellencopy_extern) db_tabellencopy_extern; break ;;
	db_tables) db_tables; break ;;
	db_tablesplitt) db_tablesplitt; break ;;
	db_tables_dialog) db_tables_dialog; break ;;
	db_tablextract) db_tablextract; break ;;
	db_tablextract_regex) db_tablextract_regex; break ;;
	db_ungenutzteobjekte) db_ungenutzteobjekte; break ;;
	db_userdate) db_userdate; break ;;
	db_user_anzahl) db_user_anzahl; break ;;
	db_user_data) db_user_data; break ;;
	db_user_data_dialog) db_user_data_dialog; break ;;
	db_user_infos) db_user_infos; break ;;
	db_user_infos_dialog) db_user_infos_dialog; break ;;
	db_user_online) db_user_online; break ;;
	db_user_uuid) db_user_uuid; break ;;
	db_user_uuid_dialog) db_user_uuid_dialog; break ;;
	default_master_connection) default_master_connection; break ;;
	deladvantagetools) deladvantagetools; break ;;
	delete_db) delete_db; break ;;
	delete_emty_mark) delete_emty_mark; break ;;
	dialogclear) dialogclear; break ;;
	divacopy) divacopy; break ;;
	divagitcopy) divagitcopy; break ;;
	dotnetinfo) dotnetinfo; break ;;
	downloados) downloados; break ;;
	DO_DOMAIN_IDS) DO_DOMAIN_IDS; break ;;
	DO_DOMAIN_IDS2_nids) DO_DOMAIN_IDS2_nids; break ;;
	dummyvar) dummyvar; break ;;
	edittextbox) edittextbox; break ;;
	ende) ende; break ;;
	expertenmenu) expertenmenu; break ;;
	fail2banset) fail2banset; break ;;
	fehler) fehler; break ;;
	finstall) finstall; break ;;
	firstinstallation) firstinstallation; break ;;
	flotsamconfig) flotsamconfig; break ;;
	fortschritsanzeige) fortschritsanzeige; break ;;
	fpspeicher) fpspeicher; break ;;
	functionslist) functionslist; break ;;
	funktionenmenu) funktionenmenu; break ;;
	getcachegroesse) getcachegroesse; break ;;
	getcachesinglegroesse) getcachesinglegroesse; break ;;
	get_regionsarray) get_regionsarray; break ;;
	get_value_from_Region_key) get_value_from_Region_key; break ;;
	gridcachedelete) gridcachedelete; break ;;
	gridstart) gridstart; break ;;
	gridstop) gridstop; break ;;
	hauptmenu) hauptmenu; break ;;
	hilfe) hilfe; break ;;
	hilfemenu) hilfemenu; break ;;
	hilfemenudirektaufrufe) hilfemenudirektaufrufe; break ;;
	historylogclear) historylogclear; break ;;
	icecastconfig) icecastconfig; break ;;
	icecastinstall) icecastinstall; break ;;
	icecastrestart) icecastrestart; break ;;
	icecaststart) icecaststart; break ;;
	icecaststop) icecaststop; break ;;
	icecastversion) icecastversion; break ;;
	IGNORE_DOMAIN_IDS) IGNORE_DOMAIN_IDS; break ;;
	IGNORE_DOMAIN_IDS2_nids) IGNORE_DOMAIN_IDS2_nids; break ;;
	IGNORE_SERVER_IDS) IGNORE_SERVER_IDS; break ;;
	iinstall) iinstall; break ;;
	iinstallnew) iinstallnew; break ;;
	info) info; break ;;
	infodialog) infodialog; break ;;
	ini_get) ini_get; break ;;
	ini_set) ini_set; break ;;
	installationen) installationen; break ;;
	installationhttps22) installationhttps22; break ;;
	installfinish) installfinish; break ;;
	installmariadb18) installmariadb18; break ;;
	installmariadb22) installmariadb22; break ;;
	installopensimulator) installopensimulator; break ;;
	installphpmyadmin) installphpmyadmin; break ;;
	installubuntu22) installubuntu22; break ;;
	installwordpress) installwordpress; break ;;
	install_mysqltuner) install_mysqltuner; break ;;
	instdialog) instdialog; break ;;
	iptablesset) iptablesset; break ;;
	isroot) isroot; break ;;
	janein) janein; break ;;
	kalender) kalender; break ;;
	konsolenhilfe) konsolenhilfe; break ;;
	laeuftos) laeuftos; break ;;
	landclear) landclear; break ;;
	lastrebootdatum) lastrebootdatum; break ;;
	letterdel) letterdel; break ;;
	linuxupgrade) linuxupgrade; break ;;
	loadinventar) loadinventar; break ;;
	log) log; break ;;
	logdel) logdel; break ;;
	mainMenu) mainMenu; break ;;
	makeaot) makeaot; break ;;
	makeregionsliste) makeregionsliste; break ;;
	makeverzeichnisliste) makeverzeichnisliste; break ;;
	makewebmaps) makewebmaps; break ;;
	mapdel) mapdel; break ;;
	mariadberror) mariadberror; break ;;
	MASTER_CONNECT_RETRY) MASTER_CONNECT_RETRY; break ;;
	MASTER_DELAY) MASTER_DELAY; break ;;
	MASTER_HOST) MASTER_HOST; break ;;
	MASTER_LOG_FILE) MASTER_LOG_FILE; break ;;
	MASTER_LOG_POS) MASTER_LOG_POS; break ;;
	MASTER_PASSWORD) MASTER_PASSWORD; break ;;
	MASTER_PORT) MASTER_PORT; break ;;
	MASTER_SSL) MASTER_SSL; break ;;
	MASTER_SSL_CA) MASTER_SSL_CA; break ;;
	MASTER_SSL_CAPATH) MASTER_SSL_CAPATH; break ;;
	MASTER_SSL_CERT) MASTER_SSL_CERT; break ;;
	MASTER_SSL_CIPHER) MASTER_SSL_CIPHER; break ;;
	MASTER_SSL_CRL) MASTER_SSL_CRL; break ;;
	MASTER_SSL_CRLPATH) MASTER_SSL_CRLPATH; break ;;
	MASTER_SSL_KEY) MASTER_SSL_KEY; break ;;
	MASTER_SSL_VERIFY_SERVER_CERT) MASTER_SSL_VERIFY_SERVER_CERT; break ;;
	MASTER_USER) MASTER_USER; break ;;
	MASTER_USE_GTID) MASTER_USE_GTID; break ;;
	MASTER_USE_GTID_slv) MASTER_USE_GTID_slv; break ;;
	meineregionen) meineregionen; break ;;
	menuassetdel) menuassetdel; break ;;
	menuautologdel) menuautologdel; break ;;
	menuautorestart) menuautorestart; break ;;
	menuautoscreenstop) menuautoscreenstop; break ;;
	menuautosimstart) menuautosimstart; break ;;
	menuautosimstop) menuautosimstop; break ;;
	menuautostart) menuautostart; break ;;
	menuautostop) menuautostop; break ;;
	menucreateuser) menucreateuser; break ;;
	menufinstall) menufinstall; break ;;
	menugridstart) menugridstart; break ;;
	menugridstop) menugridstop; break ;;
	menuinfo) menuinfo; break ;;
	menukonsolenhilfe) menukonsolenhilfe; break ;;
	menulandclear) menulandclear; break ;;
	menuloadinventar) menuloadinventar; break ;;
	menulogdel) menulogdel; break ;;
	menumapdel) menumapdel; break ;;
	menumostart) menumostart; break ;;
	menumostop) menumostop; break ;;
	menuoscommand) menuoscommand; break ;;
	menuosdauerstart) menuosdauerstart; break ;;
	menuosdauerstop) menuosdauerstop; break ;;
	menuosstart) menuosstart; break ;;
	menuosstarteintrag) menuosstarteintrag; break ;;
	menuosstarteintragdel) menuosstarteintragdel; break ;;
	menuosstop) menuosstop; break ;;
	menuosstruktur) menuosstruktur; break ;;
	menuoswriteconfig) menuoswriteconfig; break ;;
	menuregionbackup) menuregionbackup; break ;;
	menuregionrestore) menuregionrestore; break ;;
	menurostart) menurostart; break ;;
	menurostop) menurostop; break ;;
	menusaveinventar) menusaveinventar; break ;;
	menutrans) menutrans; break ;;
	menuwaslauft) menuwaslauft; break ;;
	menuworks) menuworks; break ;;
	moneyconfig) moneyconfig; break ;;
	moneycopy) moneycopy; break ;;
	moneycopy93) moneycopy93; break ;;
	moneydelete) moneydelete; break ;;
	moneygitcopy) moneygitcopy; break ;;
	moneygitcopy93) moneygitcopy93; break ;;
	MoneyServerCommands) MoneyServerCommands; break ;;
	monoinstall) monoinstall; break ;;
	monoinstall18) monoinstall18; break ;;
	monoinstall20) monoinstall20; break ;;
	monoinstall22) monoinstall22; break ;;
	mostart) mostart; break ;;
	mostop) mostop; break ;;
	mutelistcopy) mutelistcopy; break ;;
	mysqlbackup) mysqlbackup; break ;;
	mysqldberror) mysqldberror; break ;;
	mysqleinstellen) mysqleinstellen; break ;;
	mySQLmenu) mySQLmenu; break ;;
	mysqlrest) mysqlrest; break ;;
	mysqlrestnodb) mysqlrestnodb; break ;;
	mysql_neustart) mysql_neustart; break ;;
	nachrichtbox) nachrichtbox; break ;;
	namen) namen; break ;;
	newhelp) newhelp; break ;;
	newregionini) newregionini; break ;;
	OpenSimCommands) OpenSimCommands; break ;;
	opensimgitcopy93) opensimgitcopy93; break ;;
	opensimholen) opensimholen; break ;;
	osbauen93) osbauen93; break ;;
	osbuilding) osbuilding; break ;;
	osbuilding93) osbuilding93; break ;;
	osbuildingupgrade93) osbuildingupgrade93; break ;;
	oscommand) oscommand; break ;;
	oscompi) oscompi; break ;;
	oscompi93) oscompi93; break ;;
	osconfigstruktur) osconfigstruktur; break ;;
	oscopy) oscopy; break ;;
	oscopyrobust) oscopyrobust; break ;;
	oscopysim) oscopysim; break ;;
	osdauerstart) osdauerstart; break ;;
	osdauerstop) osdauerstop; break ;;
	osdelete) osdelete; break ;;
	osdowngrade) osdowngrade; break ;;
	osgitholen) osgitholen; break ;;
	osgitholen93) osgitholen93; break ;;
	osgitstatus) osgitstatus; break ;;
	osgridcopy) osgridcopy; break ;;
	osmnotranslate) osmnotranslate; break ;;
	osmtoolconfig) osmtoolconfig; break ;;
	osmtoolconfigabfrage) osmtoolconfigabfrage; break ;;
	osmtranslate) osmtranslate; break ;;
	osmtranslatedirekt) osmtranslatedirekt; break ;;
	osmtranslateinstall) osmtranslateinstall; break ;;
	osmupgrade) osmupgrade; break ;;
	osreparatur) osreparatur; break ;;
	osscreenstop) osscreenstop; break ;;
	ossettings) ossettings; break ;;
	osslEnableconfig) osslEnableconfig; break ;;
	osslEnableConfig) osslEnableConfig; break ;;
	osslEnableConfigSet) osslEnableConfigSet; break ;;
	osstart) osstart; break ;;
	osstarteintrag) osstarteintrag; break ;;
	osstarteintragdel) osstarteintragdel; break ;;
	osstop) osstop; break ;;
	osstruktur) osstruktur; break ;;
	ostimestamp) ostimestamp; break ;;
	osupgrade) osupgrade; break ;;
	osupgrade93) osupgrade93; break ;;
	oswriteconfig) oswriteconfig; break ;;
	oszipupgrade) oszipupgrade; break ;;
	passgen) passgen; break ;;
	passwdgenerator) passwdgenerator; break ;;
	pull) pull; break ;;
	radiolist) radiolist; break ;;
	ramspeicher) ramspeicher; break ;;
	randomname) randomname; break ;;
	reboot) reboot; break ;;
	rebootdatum) rebootdatum; break ;;
	regionbackup) regionbackup; break ;;
	regionconfig) regionconfig; break ;;
	regionliste) regionliste; break ;;
	regionrestore) regionrestore; break ;;
	regionsabfrage) regionsabfrage; break ;;
	regionsconfigdateiliste) regionsconfigdateiliste; break ;;
	regionsinisuchen) regionsinisuchen; break ;;
	regionsiniteilen) regionsiniteilen; break ;;
	regionsport) regionsport; break ;;
	regionsuri) regionsuri; break ;;
	RELAY_LOG_FILE) RELAY_LOG_FILE; break ;;
	RELAY_LOG_POS) RELAY_LOG_POS; break ;;
	remarklist) remarklist; break ;;
	Replica_Backup) Replica_Backup; break ;;
	Replica_Backup_nmlp) Replica_Backup_nmlp; break ;;
	ReplikatKoordinaten) ReplikatKoordinaten; break ;;
	robustbackup) robustbackup; break ;;
	RobustCommands) RobustCommands; break ;;
	pCampbotCommands) pCampbotCommands; break ;;
	rologdel) rologdel; break ;;
	rostart) rostart; break ;;
	rostop) rostop; break ;;
	saveinventar) saveinventar; break ;;
	schreibeinfo) schreibeinfo; break ;;
	sckill) sckill; break ;;
	screenlist) screenlist; break ;;
	screenlistrestart) screenlistrestart; break ;;
	ScreenLog) ScreenLog; break ;;
	scriptcopy) scriptcopy; break ;;
	scriptgitcopy) scriptgitcopy; break ;;
	scstart) scstart; break ;;
	scstop) scstop; break ;;
	searchcopy) searchcopy; break ;;
	senddata) senddata; break ;;
	serverinstall) serverinstall; break ;;
	serverinstall22) serverinstall22; break ;;
	serverupgrade) serverupgrade; break ;;
	setpartner) setpartner; break ;;
	setversion) setversion; break ;;
	setversion93) setversion93; break ;;
	set_empty_user) set_empty_user; break ;;
	show_info) show_info; break ;;
	simstats) simstats; break ;;
	skriptversion) skriptversion; break ;;
	sourcelist18) sourcelist18; break ;;
	sourcelist22) sourcelist22; break ;;
	systeminformation) systeminformation; break ;;
	tabellenabfrage) tabellenabfrage; break ;;
	tastaturcachedelete) tastaturcachedelete; break ;;
	terminator) terminator; break ;;
	textbox) textbox; break ;;
	trimm) trimm; break ;;
	trim_all) trim_all; break ;;
	trim_string) trim_string; break ;;
	ufwblock) ufwblock; break ;;
	ufwlog) ufwlog; break ;;
	ufwoff) ufwoff; break ;;
	ufwport) ufwport; break ;;
	ufwset) ufwset; break ;;
	uncompress) uncompress; break ;;
	vardel) vardel; break ;;
	vardelall) vardelall; break ;;
	vartest) vartest; break ;;
	versionsausgabe93) versionsausgabe93; break ;;
	vornamen) vornamen; break ;;
	warnbox) warnbox; break ;;
	waslauft) waslauft; break ;;
	works) works; break ;;
	xhelp) xhelp; break ;;
	*) break;;
	esac
done
exit 0;
}

## *  newhelp
	# Datum: 02.10.2023
	#? Beschreibung:
	# Diese Funktion zeigt eine Hilfeanzeige für das Shell-Skript "osmtool.sh" an und erläutert die verfügbaren Optionen und Verwendungszwecke.
	#? Parameter: Keine
	#? Funktionsverhalten:
	#   - Zeigt eine Übersicht der verfügbaren Optionen und deren Bedeutungen.
	#   - Erklärt die Verwendung des Shell-Skripts und zeigt Beispiele für die Befehlseingabe.
	#? Beispielaufruf:
	#   newhelp
	#? Rückgabewert: Die Funktion gibt die Hilfeanzeige auf dem Bildschirm aus.
	#? Hinweise:
	#   - Passen Sie die Hilfeanzeige an die spezifischen Anforderungen des "osmtool.sh"-Skripts an.
##
function newhelp() {
	echo "$(tput setaf 2)Display Hilfe"
	echo "Syntax:$(tput sgr 0) osmtool.sh [h|hilfe|konsolenhilfe|dbhilfe|commandhelp|RobustCommands|OpenSimCommands|hda]"
	echo "$(tput setaf 2)Optionen:$(tput sgr 0)"
	echo "h                       $(tput setaf 2)Zeigt diese hilfe.$(tput sgr 0)"
	echo "hilfe                   $(tput setaf 2)Haupthilfefunktionen.$(tput sgr 0)"
	echo "konsolenhilfe           $(tput setaf 2)Konsolenhilfe dreht sich um Putty.$(tput sgr 0)"
	echo "dbhilfe                 $(tput setaf 2)Hilfe rund um die Datenbankmanipulation.$(tput sgr 0)"
	echo "commandhelp             $(tput setaf 2)OpenSimulator Kommandos in Deutsch.$(tput sgr 0)"
	echo "RobustCommands          $(tput setaf 2)Robust Kommandos.$(tput sgr 0)"
	echo "OpenSimCommands         $(tput setaf 2)OpenSimulator Kommandos.$(tput sgr 0)"
	echo "MoneyServerCommands     $(tput setaf 2)MoneyServer Kommandos.$(tput sgr 0)"	
	echo "pCampbotCommands        $(tput setaf 2)pCampbotCommands Kommandos.$(tput sgr 0)"
	echo "all                     $(tput setaf 2)Alle OpenSimulator Konsolenkommandos.$(tput sgr 0)"
	echo "hda                     $(tput setaf 2)Dialog Menue direktaufrufe.$(tput sgr 0)"
	echo " "
	echo " Der Kommando aufruf:"
	echo "$(tput setaf $FARBE1) $(tput setab $FARBE2)#? Beispiel: bash osmtool.sh oscommand sim1 Welcome \"alert Hallo Welt\" $(tput sgr 0)"
	echo "$(tput setaf $FARBE1) $(tput setab $FARBE2)#? Beispiel: bash osmtool.sh oscommand sim1 Welcome \"alert-user John Doe Hallo John Doe\" $(tput sgr 0)"
}

#──────────────────────────────────────────────────────────────────────────────────────────
#* Tests Funktionsgruppe
#──────────────────────────────────────────────────────────────────────────────────────────

## *  ostimestamp
	# Datum: 02.10.2023	
	#? Beschreibung:
	# Diese Funktion zeigt das aktuelle Datum und die Uhrzeit in verschiedenen Formaten an. Sie wandelt auch zwischen Datumsformaten und Unix-Zeitstempeln um.
	#? Parameter: Keine
	#? Funktionsverhalten:
	#   - Ermittelt das aktuelle Datum und die Uhrzeit im Format "yyyy-mm-dd" (Englisch) und "dd-mm-yyyy" (Deutsch).
	#   - Wandelt das Datum in einen Unix-Zeitstempel um.
	#   - Wandelt den Unix-Zeitstempel wieder in ein Datumsformat um.
	#? Beispielaufruf:
	#   ostimestamp
	#? Rückgabewert: Die Funktion gibt keine expliziten Rückgabewerte zurück. Sie zeigt die Ergebnisse auf dem Bildschirm an.
	#? Hinweise:
	#   - Stellen Sie sicher, dass die Ausgabeformate Ihren Anforderungen entsprechen.
##
function ostimestamp() {
    # Aktuelles Datum und Uhrzeit im Format "yyyy-mm-dd" (Englisch)
    EN_DATUM=$(date '+%Y-%m-%d %H:%M:%S')
    echo "$EN_DATUM" Aktuelles Datum Aktuell in Englisch

    # Aktuelles Datum und Uhrzeit im Format "dd-mm-yyyy" (Deutsch)
    DE_DATUM=$(date '+%d-%m-%Y %H:%M:%S')
    echo "$DE_DATUM" Aktuelles Datum Aktuell in Deutsch

    # Umwandlung des Datums in einen Unix-Zeitstempel
    DATE_TO_UNIX_TIMESTAMP=$(date -d "$EN_DATUM" +%s)
    echo "$DATE_TO_UNIX_TIMESTAMP" Datum zu Zeitstempel Ausgabe

    # Umwandlung des Unix-Zeitstempels zurück in ein Datumsformat
    UNIX_TIMESTAMP_TO_DATE=$(date -d "@$DATE_TO_UNIX_TIMESTAMP" '+%Y-%m-%d %H:%M:%S')
    echo "$UNIX_TIMESTAMP_TO_DATE" Zeitstempel zu Datum Ausgabe
}

#──────────────────────────────────────────────────────────────────────────────────────────
#* Eingabeauswertung Konsolenmenue Funktionsgruppe
#──────────────────────────────────────────────────────────────────────────────────────────

case $KOMMANDO in
	AutoInstall) AutoInstall ;;
	ConfigSet) ConfigSet "$2" ;;
	DO_DOMAIN_IDS) DO_DOMAIN_IDS "$2" "$3" "$4" ;;
	DO_DOMAIN_IDS2_nids) DO_DOMAIN_IDS2_nids "$2" "$3" ;;
	IGNORE_DOMAIN_IDS) IGNORE_DOMAIN_IDS "$2" "$3" "$4" ;;
	IGNORE_SERVER_IDS) IGNORE_SERVER_IDS "$2" "$3" "$4" ;;
	MASTER_CONNECT_RETRY) MASTER_CONNECT_RETRY "$2" "$3" "$4" ;;
	MASTER_DELAY) MASTER_DELAY "$2" "$3" "$4" ;;
	MASTER_HOST) MASTER_HOST "$2" "$3" "$4" ;;
	MASTER_LOG_FILE) MASTER_LOG_FILE "$2" "$3" "$4" "$5" ;;
	MASTER_LOG_POS) MASTER_LOG_POS "$2" "$3" "$4" "$5" ;;
	MASTER_PASSWORD) MASTER_PASSWORD "$2" "$3" ;;
	MASTER_PORT) MASTER_PORT "$2" "$3" "$4" "$5" ;;
	MASTER_SSL) MASTER_SSL "$2" "$3" ;;
	MASTER_SSL_CA) MASTER_SSL_CA "$2" "$3" ;;
	MASTER_SSL_CAPATH) MASTER_SSL_CAPATH "$2" "$3" ;;
	MASTER_SSL_CERT) MASTER_SSL_CERT "$2" "$3" ;;
	MASTER_SSL_CIPHER) MASTER_SSL_CIPHER "$2" "$3" ;;
	MASTER_SSL_CRL) MASTER_SSL_CRL "$2" "$3" ;;
	MASTER_SSL_CRLPATH) MASTER_SSL_CRLPATH "$2" "$3" ;;
	MASTER_SSL_KEY) MASTER_SSL_KEY "$2" "$3" ;;
	MASTER_SSL_VERIFY_SERVER_CERT) MASTER_SSL_VERIFY_SERVER_CERT "$2" "$3" ;;
	MASTER_USER) MASTER_USER "$2" "$3" ;;
	MASTER_USE_GTID) MASTER_USE_GTID "$2" "$3" ;;
	MASTER_USE_GTID_slv) MASTER_USE_GTID_slv "$2" "$3" "$4" ;;
	OpenSimConfig) OpenSimConfig ;;
	RELAY_LOG_FILE) RELAY_LOG_FILE "$2" "$3" "$4" "$5" ;;
	RELAY_LOG_POS) RELAY_LOG_POS "$2" "$3" "$4" "$5" ;;
	Replica_Backup) Replica_Backup "$2" "$3" "$4" "$5" ;;
	Replica_Backup_nmlp) Replica_Backup_nmlp "$2" "$3" "$4" ;;
	ReplikatKoordinaten) ReplikatKoordinaten "$2" "$3" "$4" "$5" "$6" "$7" "$8" ;;
	ScreenLog) ScreenLog ;;
	accesslog) accesslog ;;
	ald | autologdel) autologdel ;;
	allclean) allclean "$2" ;;
	allrepair_db) allrepair_db "$2" "$3" ;;
	amd | automapdel) automapdel ;;
	apacheerror) apacheerror ;;
	arb | autoregionbackup) autoregionbackup ;;
	arit | autoregionsiniteilen) autoregionsiniteilen ;;
	asdel | assetdel) assetdel "$2" "$3" "$4" ;;
	assetcachedel) assetcachedel "$2" ;; # Test
	astart | autostart | start) autostart ;;
	astart93 | autostart93 | start93) autostart ;;
	astop | autostop | stop | astop93 | autostop93 | stop93) autostop ;;
	authlog) authlog ;;
	autoallclean) autoallclean ;;
	autoassetcachedel) autoassetcachedel ;;
	autorobustmapdel) autorobustmapdel ;;
	backupdatum) backupdatum ;;
	checkfile) checkfile "$2" ;;
	chrisoscopy) chrisoscopy ;;
	cl | configlesen) configlesen "$2" ;;
	cleanaot) cleanaot ;;
	cleaninstall) cleaninstall ;;
	commandhelp) commandhelp ;;
    rc | robust | RobustCommands) RobustCommands ;;
    oc | opensim | OpenSimCommands) OpenSimCommands ;;
    mc | money | MoneyServerCommands) MoneyServerCommands ;;
	pCampbotCommands) pCampbotCommands ;;
    all) all ;;
	compi | compilieren) compilieren ;;
	conf_delete) conf_delete "$2" "$3" "$4" ;;
	conf_read) conf_read "$2" "$3" "$4" ;;
	conf_write) conf_write "$2" "$3" "$4" "$5" ;;	
	connection_name) connection_name "$2" "$3" ;;
	create_db) create_db "$2" "$3" "$4" ;;
	create_db_user) create_db_user "$2" "$3" "$4" "$5" ;;
	createuser) createuser "$2" "$3" "$4" "$5" "$6" ;;
	db_all_name) db_all_name "$2" "$3" "$4" ;;
	db_all_user) db_all_user "$2" "$3" "$4" ;;
	db_all_user_dialog) db_all_user_dialog "$2" "$3" "$4" ;;
	db_all_userfailed) db_all_userfailed "$2" "$3" "$4" "$5" "$6" ;;
	db_all_uuid) db_all_uuid "$2" "$3" "$4" ;;
	db_all_uuid_dialog) db_all_uuid_dialog "$2" "$3" "$4" ;;
	db_anzeigen) db_anzeigen "$2" "$3" "$4" ;;
	db_anzeigen_dialog) db_anzeigen_dialog "$2" "$3" ;;
	db_backuptabellen) db_backuptabellen "$2" "$3" "$4" ;;
	db_benutzer_anzeigen) db_benutzer_anzeigen "$2" "$3" ;;
	db_create) db_create "$2" "$3" "$4" ;;
	db_create_new_dbuser) db_create_new_dbuser "$2" "$3" "$4" "$5" ;;
	db_dbuser) db_dbuser "$2" "$3" ;;
	db_dbuserrechte) db_dbuserrechte "$2" "$3" "$4" ;;
	db_deldbuser) db_deldbuser "$2" "$3" "$4" ;;
	db_delete) db_delete "$2" "$3" "$4" ;;
	db_email_setincorrectuseroff) db_email_setincorrectuseroff "$2" "$3" "$4" ;;
	db_empty) db_empty "$2" "$3" "$4" ;;
	db_false_email) db_false_email "$2" "$3" "$4" ;;
	db_foldertyp_user) db_foldertyp_user "$2" "$3" "$4" "$5" "$6" "$7" ;;
	db_regions) db_regions "$2" "$3" "$4" ;;
	db_regionsport) db_regionsport "$2" "$3" "$4" ;;
	db_regionsuri) db_regionsuri "$2" "$3" "$4" ;;
	db_restorebackuptabellen) db_restorebackuptabellen "$2" "$3" "$4" "$5" ;;
	db_setuserofline) db_setuserofline "$2" "$3" "$4" "$5" "$6" ;;
	db_setuseronline) db_setuseronline "$2" "$3" "$4" "$5" "$6" ;;
	db_sichern) db_sichern "$2" "$3" "$4" ;;
	db_tables) db_tables "$2" "$3" "$4" ;;
	db_tables_dialog) db_tables_dialog "$2" "$3" "$4" ;;
	db_tablesplitt) db_tablesplitt "$2" ;;
	db_tablextract) db_tablextract "$2" "$3" ;;
	db_tablextract_regex) db_tablextract_regex "$2" "$3" "$4" ;;
	db_user_data) db_user_data "$2" "$3" "$4" "$5" "$6" ;;
	db_user_infos) db_user_infos "$2" "$3" "$4" "$5" "$6" ;;
	db_user_uuid) db_user_uuid "$2" "$3" "$4" "$5" "$6" ;;
	db_userdate) db_userdate "$2" "$3" "$4" "$5" "$6" ;;
	default_master_connection) default_master_connection "$2" "$3" ;;
	delete_db) delete_db "$2" "$3" "$4" ;;
	dotnetinfo) dotnetinfo ;;
	dotnetubu18) dotnetubu18 ;;
	dotnetubu22) dotnetubu22 ;;
	uninstall_mono) uninstall_mono ;;
	downloados) downloados ;;
	e | terminator) terminator ;;
	ende) ende ;; # Test
	expertenmenu) expertenmenu ;;
	fehler) fehler ;; # Test
	finstall) finstall "$2" ;;
	fortschritsanzeige) fortschritsanzeige ;;
	fpspeicher) fpspeicher ;;
	funktionsliste | functionslist) functionslist ;;
	funktionenmenu) funktionenmenu ;;
	get_value_from_Region_key) get_value_from_Region_key ;;
	gridcommonini) gridcommonini ;;
	gsta | gridstart) gridstart ;;
	gsto | gridstop | gsto93 | gridstop93) gridstop ;;
	hilfe | help | aider | ayuda) hilfe ;;
	historylogclear) historylogclear "$2" ;;
	info) info ;;
	infodialog) infodialog ;;
	installationen) installationen ;;
	installationhttps22) installationhttps22 "$2" "$3" ;;
	update | linuxupgrade) linuxupgrade ;;
	installfinish) installfinish ;;
	installmariadb18) installmariadb18 ;;
	installmariadb22) installmariadb22 ;;
	installphpmyadmin) installphpmyadmin ;;
	installubuntu22) installubuntu22 ;;
	deladvantagetools) deladvantagetools ;;
	ipsetzen) ipsetzen ;;
	konsolenhilfe) konsolenhilfe ;;
	l | list | screenlist) screenlist ;;
	landclear) landclear "$2" "$3" ;;
	ld | logdel) logdel "$2" ;;
	leere_db) leere_db "$2" "$3" "$4" ;;
	loadinventar) loadinventar "$2" "$3" "$4" "$5" ;;
	makeaot) makeaot ;;
	makeregionsliste) makeregionsliste ;;
	makeverzeichnisliste) makeverzeichnisliste ;;
	makewebmaps) makewebmaps ;;
	mariadberror) mariadberror ;;
	mc | moneycopy) moneycopy ;;
	mc93 | moneycopy93) moneycopy93 ;;
	md | mapdel) mapdel "$2" ;;
	menuinfo) menuinfo ;;
	menuosdauerstart) menuosdauerstart "$2" ;; # Test
	menuosdauerstop) menuosdauerstop "$2" ;; # Test
	menuoswriteconfig) menuoswriteconfig "$2" ;;
	menuworks) menuworks "$2" ;;
	moneydelete) moneydelete ;;
	moneygitcopy) moneygitcopy ;;
	moneygitcopy93) moneygitcopy93 ;;
	bulletgitcopy) bulletgitcopy ;;
	moneyserverini) moneyserverini ;;
	monoinstall) monoinstall ;;
	mr | meineregionen) meineregionen ;;
	ms | moneystart | mostart) mostart ;;
	mstop | moneystop | mostop | mstop93 | moneystop93 | mostop93) mostop ;;
	mutelistcopy) mutelistcopy ;;
	mysql_neustart) mysql_neustart ;;
	mysqldberror) mysqldberror ;;
	mysqleinstellen) mysqleinstellen ;;
	mysqldump | mysqlbackup) mysqlbackup "$2" "$3" "$4" "$5" ;;
	neuegridconfig) neuegridconfig ;;
	newregionini) newregionini ;;
	od | osdelete) osdelete ;;
	opensimholen) opensimholen ;;
	opensimini) opensimini ;;
	os | osstruktur) osstruktur "$2" "$3" ;;
	osbuilding) osbuilding "$2" ;;
	buildbullet) buildbullet ;;
	osc | com | oscommand) oscommand "$2" "$3" "$4" ;;
	osc2 | com2 | oscommand2) oscommand2 "$2" "$3" "$4" "$5" ;;
	oscompi) oscompi ;;
	oscopy) oscopy "$2" ;;
	oscopyrobust) oscopyrobust ;;
	oscopysim) oscopysim ;;
	osdauerstart) osdauerstart "$2" ;; # Test
	osdauerstop) osdauerstop "$2" ;; # Test
	osg | osgitholen) osgitholen ;;
	osg93 | osgitholen93) osgitholen93 ;;
	osbauen93) osbauen93 ;;
	osgridcopy) osgridcopy ;;
	setversion) setversion "$2" ;;
	setversion93) setversion93 "$2" ;;
	osslEnableConfig) osslEnableConfig ;;
	osslenableini) osslenableini ;;
	osstarteintrag) osstarteintrag "$2" ;; # Test
	osstarteintragdel) osstarteintragdel "$2" ;; # Test
	osta | osstart) osstart "$2" ;;
	osta93 | osstart93) osstart "$2" ;;
	osto | osstop | osto93 | osstop93) osstop "$2" ;;
	oswriteconfig) oswriteconfig "$2" ;;
	ou | osupgrade) osupgrade ;;
	ou93 | osupgrade93) osupgrade93 ;;
	passgen) passgen "$2" ;;
	passwdgenerator) passwdgenerator "$2" ;;
	pythoncopy) pythoncopy ;;
	r | restart | autorestart | r93 | restart93 | autorestart93) autorestart ;;
	radiolist) radiolist ;;
	ramspeicher) ramspeicher ;;
	rb | regionbackup) regionbackup "$2" "$3" ;;
	rebootdatum) rebootdatum ;;
	regionini) regionini ;;
	regionsabfrage) regionsabfrage "$2" "$3" "$4" ;;
	regionsinisuchen) regionsinisuchen ;;
	regionsport) regionsport "$2" "$3" "$4" ;;
	regionsuri) regionsuri "$2" "$3" "$4" ;;
	rit | regionsiniteilen) regionsiniteilen "$2" "$3" ;;
	rl | Regionsdateiliste | regionsconfigdateiliste) regionsconfigdateiliste "$3" "$2" ;;
	rn | RegionListe | regionliste) regionliste ;;
	robustbackup) robustbackup ;;
	robustini) robustini ;;
	rologdel) rologdel ;;
	rs | robuststart | rostart) rostart ;;
	rsto | robuststop | rostop | rsto93 | robuststop93 | rostop93) rostop ;;
	s | settings | ossettings) ossettings ;;
	saveinventar) saveinventar "$2" "$3" "$4" "$5" ;;
	sc | scriptcopy) scriptcopy ;;
	schreibeinfo) schreibeinfo ;;
	screenlistrestart) screenlistrestart ;;
	scriptgitcopy) scriptgitcopy ;;
	sd | screendel) autoscreenstop ;;
	searchcopy) searchcopy ;;
	serverinstall) serverinstall ;;
	serverinstall22) serverinstall22 ;;
	set_empty_user) set_empty_user "$2" "$3" "$4" "$5" "$6" "$7" ;;
	setpartner) setpartner "$2" "$3" "$4" "$5" "$6" ;;
	simstats) simstats "$2" ;;
	ss | osscreenstop | ss93 | osscreenstop93) osscreenstop "$2" ;;
	sta | autosimstart | simstart) autosimstart ;;
	sta93 | autosimstart93 | simstart93) autosimstart ;;
	sto | autosimstop | simstop | sto93 | autosimstop93 | simstop93) autosimstop ;;
	systeminformation) systeminformation ;;
	tabellenabfrage) tabellenabfrage "$2" "$3" "$4" ;;
	textbox) textbox "$2" ;;
	ufwlog) ufwlog ;;
	ufwset) ufwset ;;
	ufwoff) ufwoff ;;
	ufwblock) ufwblock ;;
	ufwport) ufwport "$2" ;;
	unlockexample) unlockexample ;;
	w | works) works "$2" ;;
	warnbox) warnbox "$2" ;;
	waslauft) waslauft ;;
	rebootdatum) rebootdatum ;;
	lastrebootdatum) lastrebootdatum ;;
	reboot) reboot ;;
	db_friends) db_friends "$2" "$3" "$4" "$5" ;;
	db_online) db_online "$2" "$3" "$4" ;;
	db_region) db_region "$2" "$3" "$4" ;;
	db_inv_search) db_inv_search "$2" "$3" "$4" "$5" ;;
	db_user_anzahl) db_user_anzahl "$2" "$3" "$4" ;;
	db_user_online) db_user_online "$2" "$3" "$4" ;;
	db_region_parzelle) db_region_parzelle "$2" "$3" "$4" ;;
	db_region_parzelle_pakete) db_region_parzelle_pakete "$2" "$3" "$4" ;;
	db_region_anzahl_regionsnamen) db_region_anzahl_regionsnamen "$2" "$3" "$4" ;;
	db_region_anzahl_regionsid) db_region_anzahl_regionsid "$2" "$3" "$4" ;;
	db_inventar_no_assets) db_inventar_no_assets "$2" "$3" "$4" ;;
	mysqlrest) mysqlrest "$2" "$3" "$4" "$5" ;;
	mariarest) mariarest "$2" "$3" "$4" "$5" ;;
	mysqlrestnodb) mysqlrestnodb "$2" "$3" "$4" ;;
	iptablesset) iptablesset "$2" ;;
	fail2banset) fail2banset ;;
	db_gridlist) db_gridlist "$2" "$3" "$4" ;;
	db_backuptabellentypen) db_backuptabellentypen "$2" "$3" "$4" ;;
	db_ungenutzteobjekte) db_ungenutzteobjekte "$2" "$3" "$4" "$5" "$6" ;;
	senddata) senddata "$2" "$3" "$4" ;;
	gridcachedelete) gridcachedelete ;;
	config | gridkonfiguration | configabfrage) configabfrage ;;
	osmtoolconfigabfrage) osmtoolconfigabfrage ;;
	osdowngrade) osdowngrade ;;
	name | namen) namen "$2" ;;
	vornamen) vornamen "$2" ;;
	regionconfig) regionconfig "$2" "$3" "$4" "$5" "$6" ;;
	createdatabase) createdatabase "$2" "$3" "$4" ;;
	createdbuser) createdbuser "$2" "$3" "$4" "$5" ;;
	clearuserlist) clearuserlist ;;
	instdialog) instdialog ;;
	createmasteravatar) createmasteravatar ;;
	createregionavatar) createregionavatar ;;
	firstinstallation) firstinstallation ;;
	osgitstatus) osgitstatus ;;
	scstart) scstart "$2" ;;
	scstop) scstop "$2" ;;
	sckill) sckill "$2" ;;
	dateimenu) dateimenu ;;
	hauptmenu) hauptmenu ;;
	hilfemenu) hilfemenu ;;
	mySQLmenu) mySQLmenu ;;
	avatarmenu) avatarmenu ;;
	buildmenu) buildmenu ;;
	expertenmenu) expertenmenu ;;
	funktionenmenu) funktionenmenu ;;
	dbhilfe) dbhilfe ;;
	divacopy) divacopy ;;
	cleanprebuild) cleanprebuild ;;
	divagitcopy) divagitcopy ;;
	skriptversion) skriptversion "$2" ;;
	version | versionsausgabe93) versionsausgabe93 ;;
	osbuildingupgrade93) osbuildingupgrade93 "$2" ;;
	xhelp) xhelp "$2" ;;
	checkupgrade93) checkupgrade93 ;;
	getcachegroesse) getcachegroesse ;;
	getcachesinglegroesse) getcachesinglegroesse "$2" ;;
	db_tabellencopy) db_tabellencopy "$2" "$3" "$4" "$5" "$6" ;;
	remarklist) remarklist ;;
	ini_get) ini_get "$2" "$3" "$4" ;;
	ini_set) ini_set "$2" "$3" "$4" "$5" ;;
	pcampbot) pcampbot "$2" "$3" "$4" "$5" "$6" ;;
	randomname) randomname ;;
	icecaststart) icecaststart ;;
	icecaststop) icecaststop ;;
	icecastrestart) icecastrestart ;;
	icecastversion) icecastversion ;;
	icecastinstall) icecastinstall ;;
	icecastconfig) icecastconfig ;;
	osmtranslateinstall) osmtranslateinstall ;;
	osmtranslate) osmtranslate "$2" ;;
	janein) janein "$2" ;;
	dalaiserverinstall) dalaiserverinstall ;;
	dalaiinstall) dalaiinstall "$2" ;;
	dalaiinstallinfos) dalaiinstallinfos ;;
	dalaistart) dalaistart ;;
	dalaistop) dalaistop ;;
	dalaiupgrade) dalaiupgrade "$2" ;;
	dalaimodelinstall) dalaimodelinstall "$2" ;;
	dalaiuninstall) dalaiuninstall ;;
	tastaturcachedelete) tastaturcachedelete ;;
	isroot) isroot ;;
	vardelall) vardelall ;;
	vardel) vardel ;;
	osmupgrade) osmupgrade ;;
	benutzer) benutzer ;;
	pull) pull ;;
	laeuftos) laeuftos "$2" ;;
	createmanual) createmanual ;;
	delete_emty_mark) delete_emty_mark "$2" "$3" ;;
	osreparatur) osreparatur ;;
	mainMenu) mainMenu ;;
	check_and_repair) check_and_repair ;;
	manual_repair) manual_repair ;;
	repair_table) repair_table ;;
	repair_table_entries) repair_table_entries ;;
	repair_single_entry) repair_single_entry ;;
	delete_corrupted_entries) delete_corrupted_entries ;;
	backup_tables) backup_tables ;;
	restore_tables) restore_tables ;;
	update_entry) update_entry ;;
	add_entr) add_entr ;;
	delete_entry) delete_entry ;;
	generate_report) generate_report ;;
	begin_transaction) begin_transaction ;;
	commit_transaction) commit_transaction ;;
	rollback_transaction) rollback_transaction ;;
	display_table_schema) display_table_schema ;;
	display_databases) display_databases ;;
	optimize_tables) optimize_tables ;;
	display_server_info) display_server_info ;;
	search_entries) search_entries ;;
	search_entries_by_date) search_entries_by_date ;;
	search_entries_by_unix_timestamp) search_entries_by_unix_timestamp ;;
	display_table_contents) display_table_contents ;;
	export_table_to_csv) export_table_to_csv ;;
	import_csv_to_table) import_csv_to_table ;;
	backup_all_databases) backup_all_databases ;;
	restore_all_databases) restore_all_databases ;;
	display_user_permissions) display_user_permissions ;;
	add_user) add_user ;;
	modify_user_permissions) modify_user_permissions ;;
	delete_user) delete_user ;;
	rename_table) rename_table ;;
	show_running_processes) show_running_processes ;;
	clear_query_cache) clear_query_cache ;;
	show_index_info) show_index_info ;;
	analyze_database) analyze_database ;;
	optimize_query) optimize_query ;;
	create_database) create_database ;;
	create_table) create_table ;;
	alter_table_structure) alter_table_structure ;;
	show_user_activity) show_user_activity ;;
	show_events) show_events ;;
	check_database_connection) check_database_connection ;;
	show_variables) show_variables ;;
	show_database_engines) show_database_engines ;;
	show_collations) show_collations ;;
	show_database_statistics) show_database_statistics ;;
	show_foreign_keys) show_foreign_keys ;;
	add_column_encryption) add_column_encryption ;;
	show_last_table_changes) show_last_table_changes ;;
	show_database_events) show_database_events ;;
	check_database_consistency) check_database_consistency ;;
	backup_database) backup_database ;;
	restore_database) restore_database ;;
	show_database_users) show_database_users ;;
	check_user_privileges) check_user_privileges ;;
	change_user_password) change_user_password ;;
	check_error_logs) check_error_logs ;;
	update_and_restart) update_and_restart	;;
	update_clean) update_clean	;;
	zeige_netzwerkinformationen) zeige_netzwerkinformationen	;;
	ping_test) ping_test	;;
	netstat_info) netstat_info	;;
	traceroute_info) traceroute_info	;;
	pruefe_dienst_nc) pruefe_dienst_nc	;;
	pruefe_dienst_curl)	pruefe_dienst_curl	;;
	whois_info)	whois_info	;;
	netz_ss_info) netz_ss_info	;;
	ss_info) ss_info	;;
	dns_dig_info) dns_dig_info	;;
	nmap_scan) nmap_scan	;;
	bulletconfig) bulletconfig "$2" ;;
	hda | hilfedirektaufruf | hilfemenudirektaufrufe) hilfemenudirektaufrufe ;;
	h) newhelp ;;
	V | v) echo "$SCRIPTNAME $VERSION" ;;
	*) hauptmenu ;;
esac
vardelall
exit 0
