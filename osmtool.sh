#!/bin/bash

#**************************************************************************
#* Informationen
#**************************************************************************

# ? opensimMULTITOOL Copyright (c) 2021 2023 BigManzai Manfred Zainhofer
# osmtool.sh Basiert auf meinen Einzelscripten, für den OpenSimulator (OpenSim) von http://opensimulator.org an denen ich bereits 7 Jahre Arbeite und verbessere.
# Da Server unterschiedlich sind, kann eine einwandfreie fuunktion nicht gewaehrleistet werden, also bitte mit bedacht verwenden.
# Die Benutzung dieses Scriptes, oder deren Bestandteile, erfolgt auf eigene Gefahr!!!
# Erstellt und getestet ist osmtool.sh, auf verschiedenen Ubuntu 18.04, 20.04 und 22.04 Servern, unter verschiedenen Server Anbietern (Contabo, Hetzner ...).

# ? Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

# ? The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

# ! THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# ! FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# ! LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# * Status 01.10.2023 419 Funktionen.

	# # Installieren sie bitte: #* Visual Studio Code
	#* dazu die Plugins:
	# ShellCheck #! ist eine geniale Hilfe gegen Fehler.
	# shellman #? Shell Skript Schnipsel.
	# Better Comments #* Bessere Farbliche Darstellung. Standards: #! #* #? #// #todo
	# outline map #? Navigationsleiste für Funktionen.
	# todo: eine Menge warten wir´s ab.

#**************************************************************************
#* Einstellungen
#**************************************************************************

SCRIPTNAME="opensimMULTITOOL" # opensimMULTITOOL Versionsausgabe.
VERSION="V0.9.3.0.1027" # opensimMULTITOOL Versionsausgabe angepasst an OpenSim.
tput reset # Bildschirmausgabe loeschen inklusive dem Scrollbereich.

##
	#* Funktion: isroot
	# 
	#? Beschreibung:
	# Diese Funktion überprüft, ob der aktuelle Benutzer root-Rechte (Administratorrechte) hat.
	# Sie vergleicht den effektiven Benutzer (EUID) mit 0, wobei 0 normalerweise auf den root-Benutzer hinweist.
	# Wenn der Benutzer keine root-Rechte hat, wird eine Meldung ausgegeben und die Funktion gibt den Wert 1 zurück.
	# Andernfalls wird eine Bestätigungsmeldung ausgegeben und die Funktion gibt den Wert 0 zurück.
	#
	#? Parameter:
	# Diese Funktion erwartet keine Parameter.
	#
	#? Rückgabewert:
	# - Erfolgreich: Wenn der Benutzer root-Rechte hat, gibt die Funktion den Wert 0 zurück.
	# - Fehler: Wenn der Benutzer keine root-Rechte hat, gibt die Funktion den Wert 1 zurück.
	#
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

##
	#* Funktion: benutzer
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

##
	#* osmupgrade - Eine Funktion zum Aktualisieren des OpenSim-Shell-Skripts
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

##
	#* vardel - Eine Funktion zum Löschen von Umgebungsvariablen aus vorherigen Sitzungen
	# Diese Funktion löscht eine Reihe von Umgebungsvariablen, die möglicherweise aus
	# vorherigen Sitzungen oder Skripten übrig geblieben sind, um sicherzustellen, dass
	# keine alten Werte beibehalten werden.
	#? @param keine.
	#? @return nichts wird zurueckgegeben.
	# todo: nichts.
##
function vardel() {
	# Letzte Bearbeitung 26.09.2023
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
        unset "$var"
    done

    return 0
}

##
	#* vardelall - Eine Funktion zum Löschen aller Variablen
	# Diese Funktion geht alle definierten Variablen in der aktuellen Shell durch
	# und löscht sie mit unset.
	#? @param keine.
	#? @return nichts wird zurueckgegeben.
	# todo: nichts.
##
function vardelall() {
	# Letzte Bearbeitung 26.09.2023
    # Verwende `set` mit `eval` und `unset`, um alle Variablen zu durchlaufen und zu löschen.
    for var in $(set | awk -F= '{print $1}'); do
        unset "$var"
    done
}

#** osmtoolconfigvariablen
# Letzte Bearbeitung 26.09.2023
# Beschreibung: Dies dient dazu, wichtige Konfigurationsinformationen für das OSM-Tool zu initialisieren.

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
myDescription=$(lsb_release -d) # Beispiel: Description: Ubuntu 22.04 LTS
myRelease=$(lsb_release -r)     # Beispiel: Release: 22.04
myCodename=$(lsb_release -sc)   # Beispiel: jammy

# Extrahieren von Ubuntu-spezifischen Informationen
ubuntuDescription=$(cut -f2 <<<"$myDescription") # Beispiel: Ubuntu 22.04 LTS
ubuntuRelease=$(cut -f2 <<<"$myRelease")         # Beispiel: 22.04
ubuntuCodename=$(cut -f2 <<<"$myCodename")       # Beispiel: jammy

# Informationen zur MySQL-Version
SQLVERSIONVOLL=$(mysqld --version)
SQLVERSION=$(echo "${SQLVERSIONVOLL:0:45}")

# Den Pfad des osmtool.sh Skriptes herausfinden
SCRIPTPATH=$(cd "$(dirname "$0")" && pwd)
#****************************************************************

##
	#* Funktion: osmtranslateinstall
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

##
	#* osmtranslate - Übersetzt Text mithilfe des OSM Translator-Dienstes
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
# function osmtranslate2() {
# 	# Letzte Bearbeitung 26.09.2023
#     OSMTRANSTEXT="$1"
    
#     if [ "$OSMTRANSLATOR" = "OFF" ]; then
#         text="$OSMTRANSTEXT"
#         return 0
#     fi

#     if [ "$OSMTRANSLATOR" = "ON" ]; then
#         # Nutzen Sie "trans" mit Optionen zur Übersetzung
#         text=$(trans -brief -no-warn "$OSMTRANS" "$OSMTRANSTEXT")

#         # Überprüfen Sie, ob die Übersetzung erfolgreich war
#         if [ $? -ne 0 ]; then
#             echo "Fehler beim Übersetzen des Textes."
#             return 1
#         fi
#     else
#         text="$OSMTRANSTEXT"
#         return 0
#     fi
# }

##
	#* osmtranslatedirekt - Übersetzt Text direkt mithilfe des OSM Translator-Dienstes
	# Diese Funktion verwendet den OSM Translator, um Text aus einer beliebigen Quellsprache in eine 
	# Zielsprache zu übersetzen. Der OSM Translator-Dienst muss für die Verwendung aktiviert sein.
	#? @param Parameter:
	#? @param   "Text zum Übersetzen" - Der Text, der übersetzt werden soll.
	# Um den OSM Translator-Dienst zu aktivieren, setzen Sie die Umgebungsvariable OSMTRANSLATOR auf "ON".
	# Wenn OSMTRANSLATOR auf "OFF" gesetzt ist, wird der Text nicht übersetzt.
	# Beispielaufruf:
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
# function osmtranslatedirekt2() {
# 	# Letzte Bearbeitung 26.09.2023
#     OSMTRANSTEXT="$1"

#     if [ "$OSMTRANSLATOR" = "OFF" ]; then
#         text="$OSMTRANSTEXT"
#         return 0
#     fi

#     if [ "$OSMTRANS" = ":de" ]; then
#         OSMTRANSLATOR="OFF"
#         echo "Es funktioniert nicht von derselben Sprache in dieselbe zu übersetzen."
#         return 1
#     fi

#     # Nutzen Sie "trans" mit Optionen zur Übersetzung
#     text=$(trans -brief "$OSMTRANS" "$OSMTRANSTEXT")

#     # Überprüfen Sie, ob die Übersetzung erfolgreich war
#     if [ $? -ne 0 ]; then
#         echo "Fehler beim Übersetzen des Textes."
#         return 1
#     fi
# }

##
	#* osmnotranslate - Kopiert den Text, ohne Übersetzung durchzuführen
	# Diese Funktion kopiert den angegebenen Text in eine Zielvariable. Wenn der OSM Translator-Dienst 
	# deaktiviert ist (OSMTRANSLATOR auf "OFF" gesetzt), wird der Text unverändert kopiert.
	#? @param Parameter:
	#? @param   "Text zum Kopieren" - Der Text, der kopiert werden soll.
	# Um den OSM Translator-Dienst zu aktivieren, setzen Sie die Umgebungsvariable OSMTRANSLATOR auf "ON".
	# Wenn OSMTRANSLATOR auf "OFF" gesetzt ist, wird der Text nicht übersetzt und direkt kopiert.
	# Beispielaufruf:
	#   OSMTRANSLATOR="ON"  # Aktiviert den OSM Translator-Dienst
	#   osmnotranslate "Hello, world!"  # Kopiert den Text
	#   echo "Kopierter Text: $text"  # Gibt den kopierten Text aus
##
function osmnotranslate() {
	# Letzte Bearbeitung 26.09.2023
	text=$OSMTRANSTEXT
	if [ "$OSMTRANSLATOR" = "OFF" ]; then text=$OSMTRANSTEXT; return 0; fi
}

##
	#* janein - Übersetzt eine Eingabe in "ja" oder "nein"
	# Diese Funktion übersetzt eine Eingabe in die deutsche Sprache und gibt entweder "ja" oder "nein" zurück,
	# basierend auf der übersetzten Eingabe. Die Eingabe wird zuerst in Kleinbuchstaben umgewandelt und
	# falls leer, wird "nein" zurückgegeben.
	#? @param Parameter:
	#? @param   "Eingabe zum Übersetzen" - Die Eingabe, die übersetzt werden soll.
	# Beispielaufruf:
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

##
	#* log - Schreibt Text in eine Log-Datei und gibt ihn auf der Konsole aus
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
	# Hinweise:
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
	lline="*************************************************************************************"

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

##
	#* osmtoolconfig - Erstellt die Konfigurationsdatei für das opensimTOOL.
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
		echo '    MONEYSOURCE="OpenSimCurrencyServer-2021-master"'
		echo '    MONEYZIP="OpenSimCurrencyServer-2021-master.zip"'
		echo '    #MONEYSOURCE="OpenSimCurrencyServer-2023"'
		echo '    #MONEYZIP="OpenSimCurrencyServer-2023.zip"'
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
		echo '    OSSEARCHSOURCE="OpenSimSearch"'
		echo '    OSSEARCHSZIP="OpenSimSearch-master.zip"'
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
		echo '    LOGWRITE="yes" # yes/no'
		echo '    logfilename="_multitool"'
		echo '    line="************************************************************";'
		echo "     "
		echo "#* Dateien"
		echo '    REGIONSDATEI="osmregionlist.ini"'
		echo '    SIMDATEI="osmsimlist.ini"'
		echo '    OPENSIMDOWNLOAD="http://opensimulator.org/dist/"'
		echo '    OPENSIMVERSION="opensim-0.9.2.2Dev"'
		echo '    #OPENSIMVERSION="opensim-0.9.3.0Dev"'
		echo '    SEARCHADRES="icanhazip.com" # Suchadresse'
		echo "     "
		echo '    REGIONSANZEIGE="yes"'
		echo "     "
		echo '    LOGDELETE="yes" # yes/no'
		echo '    VISITORLIST="yes" # yes/no - schreibt vor dem loeschen alle Besucher samt mac in eine log Datei.'
		echo "     "
		echo "#* Inklusive"
		echo '    SCRIPTCOPY="yes"'
		echo '    MONEYCOPY="yes"'
		echo '    MUTELISTCOPY="yes"'
		echo '    OSSEARCHCOPY="yes"'
		echo '    DIVACOPY="no"'
		echo '    PYTHONCOPY="no"'
		echo '    CHRISOSCOPY="no"'
		echo '    AUTOCONFIG="no"'
		echo '    OSSEARCHCOPY="no"'
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
		echo "#* Mono Version fuer Build Vorgang Visual Studio 2019 oder 2022 - Zweite Zahl net/mono framework."
		echo "    # 1948, 1950, 1960, 1970 - 2248, 2250, 2260, 2270"
		echo '    netversion="2248"'
		echo "     "
		echo "#* Divers"
		echo '    SETOSCOMPION="no" # Mit oder ohne log Datei kompilieren. yes oder no.'
		echo '    SETAOTON="no"'
		echo "    # opensim-0.9.2.2Dev-4-g5e9b3b4.zip"
		echo '    OSVERSION="opensim-0.9.2.2Dev-"'
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

##
	#* osmtoolconfigabfrage - Führt eine Benutzerabfrage durch und erstellt die opensimTOOL Konfigurationsdatei.
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
	log rohtext "Ihre dotnet 6 auswahl ist DOTNETMODUS=$DOTNETMODUS"
	log rohtext "*******************************************************************"

    # Fertig und abfragen
    #osmtoolconfig "/$STARTVERZEICHNIS/osmtoolconfig.ini"
	osmtoolconfig $STARTVERZEICHNIS $ROBUSTVERZEICHNIS $MONEYVERZEICHNIS $OPENSIMVERZEICHNIS $CONFIGPFAD "/$SCRIPTPATH/osmtoolconfig.ini"
}
function osmtoolconfigabfrage2() {
	# Letzte Bearbeitung 26.09.2023
    VSTARTVERZEICHNIS=$(pwd) # Vorläufiges Startverzeichnis

    log rohtext "$SCRIPTNAME Version $VERSION"

    # Benutzereingabe für automatische Übersetzung aktivieren
    log rohtext "Do you want to enable automatic translation? ON [OFF]"
    read -r OSMTRANSLATOR
    if [ "$OSMTRANSLATOR" = "" ]; then OSMTRANSLATOR="OFF"; fi
    log rohtext "Your selection: $OSMTRANSLATOR"
    log rohtext "*******************************************************************"

    # Benutzereingabe für Sprachauswahl
    log rohtext "Please select your language: [:de]"
    read -r OSMTRANS
    if [ "$OSMTRANS" = "" ]; then OSMTRANS=":de"; fi
    log rohtext "Your language: $OSMTRANS"
    log rohtext "*******************************************************************"

    log rohtext " "
    log rohtext "*******************************************************************"
    log rohtext "*********** CANCEL WITH KEY COMBINATION ***************************"
    log rohtext "*********************  CTRL/STRG + C  *****************************"
    log rohtext "*******************************************************************"
    log rohtext #** Values in brackets [] are default suggestions                 *#"
    log rohtext #** and can be accepted with Enter.                                *#"
    log rohtext "*******************************************************************"
    log rohtext #** Data may also be available in the old opensim.cnf file.       *#"
    log rohtext "*******************************************************************"
    log rohtext " "

    # Benutzereingabe für Startverzeichnis
    log rohtext "Directory where your grid is located or should be located [${VSTARTVERZEICHNIS//\//}]"
    read -r STARTVERZEICHNIS
    if [ "$STARTVERZEICHNIS" = "" ]; then STARTVERZEICHNIS="${VSTARTVERZEICHNIS//\//}"; fi
    log rohtext "Your grid directory is: $STARTVERZEICHNIS"
    log rohtext "*******************************************************************"

    # Benutzereingabe für Robust-Verzeichnis
    log rohtext "Directory where your Robust is located [robust]"
    read -r ROBUSTVERZEICHNIS
    if [ "$ROBUSTVERZEICHNIS" = "" ]; then ROBUSTVERZEICHNIS="robust"; fi
    log rohtext "Your Robust directory is: $ROBUSTVERZEICHNIS"
    log rohtext "*******************************************************************"

    # Benutzereingabe für Money-Verzeichnis
    log rohtext "Directory where your Money directory is located [robust]"
    read -r MONEYVERZEICHNIS
    if [ "$MONEYVERZEICHNIS" = "" ]; then MONEYVERZEICHNIS="robust"; fi
    log rohtext "Your Money directory is: $MONEYVERZEICHNIS"
    log rohtext "*******************************************************************"

    # Benutzereingabe für OpenSim-Verzeichnis
    log rohtext "Directory where your OpenSim directory is located [opensim]"
    read -r OPENSIMVERZEICHNIS
    if [ "$OPENSIMVERZEICHNIS" = "" ]; then OPENSIMVERZEICHNIS="opensim"; fi
    log rohtext "Your OpenSim directory is: $OPENSIMVERZEICHNIS"
    log rohtext "*******************************************************************"

    # Benutzereingabe für Konfigurationsverzeichnis
    log rohtext "Directory where your configuration files are located [OpenSimConfig]"
    read -r CONFIGPFAD
    if [ "$CONFIGPFAD" = "" ]; then CONFIGPFAD="OpenSimConfig"; fi
    log rohtext "Your configuration files directory is: $CONFIGPFAD"
    log rohtext "*******************************************************************"

    # Benutzereingabe für dotnet 6 Modus
    log rohtext "Should dotnet 6 be used [yes] no"
    read -r DOTNETMODUS
    if [ "$DOTNETMODUS" = "" ]; then DOTNETMODUS="yes"; fi
    log rohtext "Your dotnet 6 selection is: DOTNETMODUS=$DOTNETMODUS"
    log rohtext "*******************************************************************"

    # Erstellen der opensimTOOL-Konfigurationsdatei
    osmtoolconfig "$STARTVERZEICHNIS" "$ROBUSTVERZEICHNIS" "$MONEYVERZEICHNIS" "$OPENSIMVERZEICHNIS" "$CONFIGPFAD" "/$SCRIPTPATH/osmtoolconfig.ini"
}

#**************************************************************************
#* Konfiguration opensimMULTITOOL # Letzte Bearbeitung 26.09.2023
#**************************************************************************
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

#**************************************************************************
#* Hilfsfunktionen Funktionsgruppe
#**************************************************************************

##
	#* dummyvar, shellcheck disable=SC2034 umgehen.
	# Shell-Check ueberlisten wegen der Konfigurationsdatei, 
	# hat sonst keinerlei Funktion und wird auch nicht aufgerufen.
	#? @param keine.
	#? @return nichts wird zurueckgegeben.
	# todo: nichts.
##
function dummyvar() {
	# shellcheck disable=SC2034
	MONEYVERZEICHNIS="robust"; ROBUSTVERZEICHNIS="robust"; OPENSIMVERZEICHNIS="opensim"; SCRIPTSOURCE="ScriptNeu"; SCRIPTZIP="opensim-ossl-example-scripts-main.zip"; MONEYSOURCE="money48"
	MONEYZIP="OpenSimCurrencyServer-2021-master.zip"; REGIONSDATEI="osmregionlist.ini"; SIMDATEI="osmsimlist.ini"; WARTEZEIT=30; STARTWARTEZEIT=10; STOPWARTEZEIT=30; MONEYWARTEZEIT=60; ROBUSTWARTEZEIT=60
	BACKUPWARTEZEIT=120; AUTOSTOPZEIT=60; SETMONOTHREADS=800; SETMONOTHREADSON="yes"; OPENSIMDOWNLOAD="http://opensimulator.org/dist/"; SEARCHADRES="icanhazip.com"; # AUTOCONFIG="no"
	CONFIGURESOURCE="opensim-configuration-addon-modul-main"; CONFIGUREZIP="opensim-configuration-addon-modul-main.zip"
	textfontcolor=7; textbaggroundcolor=0; debugfontcolor=4; debugbaggroundcolor=0	infofontcolor=2	infobaggroundcolor=0; warnfontcolor=3; warnbaggroundcolor=0
	errorfontcolor=1; errorbaggroundcolor=0; SETMONOGCPARAMSON1="no"; SETMONOGCPARAMSON2="yes"	LOGDELETE="no"; LOGWRITE="no"; "$trimmvar"; logfilename="_multitool"
	username="username"	password="userpasswd"	databasename="grid"	linefontcolor=7	linebaggroundcolor=0; apache2errorlog="/var/log/apache2/error.log"; apache2accesslog="/var/log/apache2/access.log"
	authlog="/var/log/auth.log"	ufwlog="/var/log/ufw.log"	mysqlmariadberor="/var/log/mysql/mariadb.err"; mysqlerrorlog="/var/log/mysql/error.log"; listVar=""; ScreenLogLevel=0
	# DIALOG_OK=0; DIALOG_HELP=2; DIALOG_EXTRA=3; DIALOG_ITEM_HELP=4; SIG_NONE=0; SIG_HUP=1; SIG_INT=2; SIG_QUIT=3; SIG_KILL=9; SIG_TERM=15
	DIALOG_CANCEL=1; DIALOG_ESC=255; DIALOG=dialog; VISITORLIST="yes"; REGIONSANZEIGE="yes"; #DELREGIONS="no";
	netversion="1946"; CONFIGPFAD="OpenSimConfig"; DOTNETMODUS="yes";
	OSVERSION="opensim-0.9.2.2Dev";
	OPENSIMVERSION="opensim-0.9.2.2.zip"; OSMTRANS=":de"; OSMTRANSLATOR="OFF";
}

##
	#* xhelp Test
	# hilfe ausgeben.
	# 
	#? @param keiner.
	#? @return $VERSION
	# todo: nichts.
##
function xhelp() {
	if [[ $1 == "help" ]]; then	echo "Zeigt die Hilfe einzelner Funktionen an."; exit 0; fi
	exit 0;	
}
##
	#* xhelp - Eine Funktion, um Hilfe für andere Funktionen anzuzeigen.
	# Diese Funktion gibt Hilfeinformationen für andere Funktionen aus, indem sie den Funktionsnamen als Argument akzeptiert.
	#? Verwendung:
	#   xhelp <Funktionsname>
	#? Argumente:
	#   <Funktionsname>: Der Name der Funktion, für die Hilfe angezeigt werden soll.
	#? Beispiele:
	#   xhelp myfunction  # Zeigt die Hilfe für die Funktion "myfunction" an.
	#? Rückgabewerte:
	#   0 - Die Funktion wurde erfolgreich ausgeführt.
	#   1 - Die Funktion wurde mit ungültigen Argumenten aufgerufen.
##
function xhelp2() {
	# Letzte Bearbeitung 26.09.2023
  if [[ $# -ne 1 ]]; then
    echo "Fehler: Bitte geben Sie den Namen einer Funktion als Argument an."
    echo "Verwendung: xhelp <Funktionsname>"
    return 1
  fi

  local function_name="$1"

  if [[ "$function_name" == "help" ]]; then
    echo "Zeigt die Hilfe einzelner Funktionen an."
    return 0
  fi

  # Prüfen, ob die angegebene Funktion existiert
  if type -t "$function_name" &>/dev/null; then
    # Die Dokumentation der Funktion anzeigen
    type -t "$function_name"
  else
    echo "Fehler: Die Funktion '$function_name' existiert nicht."
    return 1
  fi
}

##
	#* skriptversion - Zeigt die Versionsnummer des opensimMULTITOOL-Skripts an.
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
function skriptversion2() {
	# Letzte Bearbeitung 26.09.2023
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -h|--help)
        echo "Zeigt die Versionsnummer des opensimMULTITOOL-Skripts an."
        return 0
        ;;
      *)
        echo "Fehler: Ungültiges Argument: $1"
        echo "Verwendung: skriptversion [-h|--help]"
        return 1
        ;;
    esac
    shift
  done

  echo "$VERSION"
  return 0
}

##
	#* meZufallsnan.
	# Array aus Bezeichnungen von Deutschen Orten und Voelker (Unvollstaendig da keine umlaute funktionieren).
	# 
	#? @param keiner.
	#? @return NEUERREGIONSNAME - Es wird ein Name zurueckgegeben.
	# todo: nichts.
##
function namen() {
	if [[ $1 == "help" ]]; then	echo "Ein Zufallsname wird ausgegeben."; exit 0; fi
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

	# Zaehlen wie viele es sind.
	count=${#namensarray[@]}
	#echo $count

	# Zufallszahl ermmiteln aus der anzahl von eintraegen in dem namensarray.
	REGIONSNAMENZAHL=$(($RANDOM % $count))
	#echo $REGIONSNAMENZAHL

	# Regionsname ausgeben	
	NEUERREGIONSNAME=${namensarray[$REGIONSNAMENZAHL]}
}

##
	#* Zufallsvornamen.
	# 
	#? @param keiner.
	#? @return NEUERREGIONSNAME - Es wird ein Name zurueckgegeben.
	# todo: nichts.
##
function vornamen() {
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

	# Zaehlen wie viele es sind.
	count=${#firstnamensarray[@]}
	#echo $count

	# Zufallszahl ermmiteln aus der anzahl von eintraegen in dem firstnamensarray.
	VORNAMENZAHL=$(($RANDOM % $count))
	#echo $REGIONSNAMENZAHL

	# Regionsname ausgeben	
	NEUERAVATARVORNAME=${firstnamensarray[$VORNAMENZAHL]}
}

##
	#* randomname.
	# 
	#? @param keiner.
	#? @return Es werden Name zurueckgegeben.
	# todo: nichts.
##
function randomname() {
	vornamen
	log rohtext "Neuer Vorname: $NEUERAVATARVORNAME"
	namen
	log rohtext "Neuer Avatarname: $NEUERAVATARVORNAME $NEUERREGIONSNAME"
	echo " "
	log rohtext "Neuer Regionsname: $NEUERREGIONSNAME"
}

##
	#* functionslist
	# Funktionen eines Bash Skript auslesen und in eine Text Datei schreiben.
	# 
	#? @param keine.
	#? @return datediff.
	# todo: nichts.
##
function functionslist() {
	file="/$STARTVERZEICHNIS/osmtool.sh"
	suche="function"
	ergebnisflist=$(grep -i -r "$suche " $file)
	echo "$ergebnisflist" >/$STARTVERZEICHNIS/osmfunktion"$DATEIDATUM".txt
}
##
	#* Funktion: functionslist
	#? Beschreibung:
	# Diese Funktion sucht nach Funktionen in einer angegebenen Shell-Datei und speichert
	# die gefundenen Funktionen alphabetisch aufsteigend in einer Ausgabedatei im angegebenen Verzeichnis.
	#? Parameter:
	# $1 - Die Pfadangabe zur Shell-Datei, in der nach Funktionen gesucht werden soll.
	# $2 - Die Ausgabedatei, in der die gefundenen Funktionen alphabetisch aufsteigend gespeichert werden sollen.
	#? Beispielaufruf:
	# functionslist "/Pfad/zur/Shell-Datei.sh" "/Ausgabeverzeichnis/ergebnis.txt"
##
function functionslist2() {
	# Letzte Bearbeitung 26.09.2023
    # Prüfen, ob die erforderlichen Parameter vorhanden sind
    if [ $# -ne 2 ]; then
        echo "Verwendung: functionslist <Shell-Datei> <Ausgabedatei>"
        return 1
    fi

    local file="$1"
    local output_file="$2"
    local search="function"

    # Überprüfen, ob die angegebene Datei existiert
    if [ ! -f "$file" ]; then
        echo "Die angegebene Shell-Datei existiert nicht."
        return 1
    fi

    # Suchen nach Funktionen in der Datei und in die Ausgabedatei schreiben
    #grep -i -r "$search " "$file" > "$output_file"
	# Suchen nach Funktionen in der Datei, sortieren und in die Ausgabedatei schreiben
    grep -i -r "$search " "$file" | sort -f > "$output_file"

    echo "Die gefundenen Funktionen wurden in $output_file gespeichert."
}

##
	#* remarklist
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

##
	#* Funktion: createmanual
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

##
	#* Funktion: trimm
	#
	#? Beschreibung:
	# Diese Funktion entfernt führende und abschließende Leerzeichen aus den übergebenen
	# Zeichenketten und speichert das bereinigte Ergebnis in einer Variablen.
	#
	#? Parameter:
	# $@ - Die Zeichenketten, die bereinigt werden sollen.
	#
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

##
 #* osgitstatus.
 # opensim quellcode status und upgraden.
 #
 #? @param $variable.
 #? @return $trimmvar.
 # todo: nichts.
##
function osgitstatus() {
	log info "OpenSim Sourcecode wird Upgegradet."
	cd /$STARTVERZEICHNIS/opensim || return 1
	log rohtext "  OpenSim ist: $(git pull)" || log rohtext "OpenSim kann nicht upgegradet werden."
	cd /$STARTVERZEICHNIS || return 0
}
##
	#* Funktion: osgitstatus
	#? Beschreibung:
	# Diese Funktion aktualisiert den OpenSim-Quellcode aus einem Git-Repository,
	# sofern verfügbar, und gibt Informationen über den Status des Upgrades aus.
	#? Parameter:
	# Keine Parameter erforderlich.
	#? Beispielaufruf:
	# osgitstatus
##
function osgitstatus2() {
	# Letzte Bearbeitung 26.09.2023
    log info "OpenSim Sourcecode wird aktualisiert."

    # Verzeichnis, in dem sich das Git-Repository für OpenSim befindet
    opensim_dir="/$STARTVERZEICHNIS/opensim"

    # Wechseln zum OpenSim-Verzeichnis oder Fehlermeldung ausgeben und die Funktion verlassen
    cd "$opensim_dir" || { log rohtext "Fehler: Das OpenSim-Verzeichnis '$opensim_dir' existiert nicht."; return 1; }

    # Aktualisieren des Git-Repositories und Speichern des Ergebnisses
    git_result=$(git pull)

    # Überprüfen, ob das Git-Update erfolgreich war
    if [ $? -eq 0 ]; then
        log rohtext "OpenSim wurde erfolgreich aktualisiert. Git-Ausgabe: $git_result"
    else
        log rohtext "Fehler: OpenSim konnte nicht aktualisiert werden. Git-Ausgabe: $git_result"
    fi

    # Zurück zum ursprünglichen Verzeichnis wechseln oder Fehlermeldung ausgeben
    cd "$STARTVERZEICHNIS" || { log rohtext "Fehler: Das ursprüngliche Verzeichnis '$STARTVERZEICHNIS' existiert nicht."; return 0; }
}

##
	#* Funktion: ende
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

##
	#* Funktion: fehler
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

##
	#* letterdel.
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
##
	#* Funktion: letterdel
	#? Beschreibung:
	# Diese Funktion entfernt bestimmte Zeichen oder Muster aus einer Zeichenkette
	# und gibt das bereinigte Ergebnis aus.
	#? Parameter:
	# $1 - Die Zeichenkette, aus der Zeichen oder Muster entfernt werden sollen.
	# $2 - Das Zeichen oder Muster, das aus der Zeichenkette entfernt werden soll.
	#? Rückgabewert:
	# Die bereinigte Zeichenkette wird auf die Standardausgabe ausgegeben.
	#? Beispielaufruf:
	# letterdel "Hallo, Welt!" "[aAbBcCdD]"
	# Ergebnis: "llo, Welt!"
##
function letterdel2() {
	# Letzte Bearbeitung 26.09.2023
    # Prüfen, ob beide Parameter übergeben wurden
    if [ $# -ne 2 ]; then
        echo "Verwendung: letterdel <Zeichenkette> <Zeichen oder Muster>"
        return 1
    fi

    local input_string="$1"
    local pattern="$2"

    # Verwenden Sie die printf-Funktion, um Zeichen oder Muster aus der Zeichenkette zu entfernen
    cleaned_string=$(printf '%s\n' "${input_string//$pattern/}")

    echo "$cleaned_string"
}

##
	#* trim_string.
	# Zeichen entfernen.
	# Usage: trim_string "   example   string    "
	#
	#? @param keine.
	#? @return nichts wird zurueckgegeben.
	# todo: nichts.
##
function trim_string() {
    : "${1#"${1%%[![:space:]]*}"}"
    : "${_%"${_##*[![:space:]]}"}"
    printf '%s\n' "$_"
}
##
	#* Funktion: trim_string
	#
	#? Beschreibung:
	# Diese Funktion entfernt führende und abschließende Leerzeichen aus einer
	# Zeichenkette und gibt das bereinigte Ergebnis aus.
	#
	#? Parameter:
	# $1 - Die Zeichenkette, aus der die Leerzeichen entfernt werden sollen.
	#
	#? Rückgabewert:
	# Die bereinigte Zeichenkette wird auf die Standardausgabe ausgegeben.
	#
	#? Beispielaufruf:
	# trimmed_text=$(trim_string "   Hallo, Welt!   ")
	# Ergebnis: "Hallo, Welt!"
##
function trim_string2() {
	# Letzte Bearbeitung 26.09.2023
    # Prüfen, ob ein Parameter übergeben wurde
    if [ $# -ne 1 ]; then
        echo "Verwendung: trim_string <Zeichenkette>"
        return 1
    fi

    local input_string="$1"

    # Entfernen führender Leerzeichen
    : '${input_string#"${input_string%%[![:space:]]*"}'

    # Entfernen abschließender Leerzeichen
    : '${_%"${_##*[![:space:]]}"}'

    printf '%s\n' "$_"
}

##
	#* vartest - Diese Funktion überprüft, ob eine Variable einen Wert hat oder leer ist.
	#? Verwendung: vartest VARIABLE
	#   - VARIABLE: Die zu überprüfende Variable
	#? Rückgabewert:
	#   - "true", wenn die Variable einen Wert hat
	#   - "false", wenn die Variable leer ist
	#? Beispielaufruf:
	# vartest "Hello, World!"
	# Dies wird "true" zurückgeben, da die Variable einen Wert hat.
##
function vartest2() {
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

##
	#* laeuftos - Diese Funktion überprüft, ob ein Prozess mit dem angegebenen Namen läuft.
	#? Verwendung: laeuftos PROZESSNAME
	#   - PROZESSNAME: Der Name des Prozesses, der überprüft werden soll.
	#
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

##
	#* trim_all - Diese Funktion entfernt führende und nachfolgende Leerzeichen aus allen Argumenten und gibt das bereinigte Ergebnis zurück.
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

##
	#* iinstall - Diese Funktion überprüft, ob ein Paket bereits installiert ist, und installiert es andernfalls.
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

##
	#* iinstall2 - Diese Funktion überprüft, ob ein Paket bereits installiert ist, und installiert es andernfalls.
	#? Verwendung: iinstall2 PAKETNAME
	#   - PAKETNAME: Der Name des Pakets, das installiert werden soll.
	# Diese Funktion überprüft, ob das angegebene PAKETNAME bereits installiert ist. Wenn es bereits installiert ist, wird eine Meldung ausgegeben.
	# Andernfalls wird versucht, das Paket mit sudo apt install zu installieren.
	#? Parameter:
	#   - PAKETNAME: Der Name des Pakets, das installiert werden soll.
	#? Beispiel:
	#   iinstall2 "firefox"
	#   Überprüft, ob das Paket "firefox" installiert ist, und installiert es andernfalls.
##
function iinstall2() {
	installation=$1
	if dpkg-query -s "$installation" 2>/dev/null | grep -q installed; then
		log rohtext "$installation ist bereits installiert."
	else
		log rohtext "Ich installiere jetzt $installation"
		sudo apt install "$installation" -y
	fi
}

##
	#* linuxupgrade - Diese Funktion führt ein Systemupdate und ein System-Upgrade auf Ubuntu durch.
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

##
	#* deladvantagetools - Diese Funktion entfernt das Paket "ubuntu-advantage-tools" von Ihrem Ubuntu-System.
	#? Verwendung: deladvantagetools
	#
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

##
	#* finstall - Führt eine apt-get-Installationsroutine aus einer Textdatei durch.
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

##
	#* menufinstall - Diese Funktion installiert Pakete aus einer Textdatei unter Verwendung des Dialog-Tools (wenn verfügbar).
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

##
	#* uncompress - Ermittelt den richtigen Entpackungsbefehl basierend auf dem Dateiformat.
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
##
	#* uncompress2 - Eine Funktion zum automatischen Entpacken von komprimierten Dateien.
	#? Verwendung: uncompress <Datei(en)>
	# Die Funktion erkennt den Dateityp und verwendet das entsprechende Entpackungswerkzeug.
	# Unterstützte Dateitypen: gzip, zip, 7z, rar, tar.gz, tar.bz2, tar.xz, bz2, xz
	#? Beispiel:
	# uncompress2 datei.zip        # Entpackt eine Zip-Datei
	# uncompress2 datei.tar.gz     # Entpackt eine tar.gz-Datei
	# uncompress2 datei.7z         # Entpackt eine 7z-Datei
	#? Beispielaufruf
	# uncompress2 datei.zip
##
function uncompress2() {
	# Letzte Bearbeitung 27.09.2023

    for datei in "$@"; do
        case $(file "$datei") in
            *ASCII*)    ;;
            *gzip*)     gunzip "$datei" ;;
            *zip*)      unzip -p "$datei" ;;
            *7z*)       7z e "$datei" ;;
            *rar*)      unrar e "$datei" ;;
            *tar.gz*)   tar -xf "$datei" ;;
            *tar.bz2*)  tar -xjf "$datei" ;;
            *tar.xz*)   tar -xJf "$datei" ;;
            *bz2*)      bunzip2 "$datei" ;;
            *xz*)       unxz "$datei" ;;
            *)          echo "Nicht unterstütztes Dateiformat für '$datei'" ;;
        esac
    done
}

##
	#* makeverzeichnisliste - Eine Funktion zum Erstellen einer Liste von Verzeichnissen aus einer Datei.
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

##
	#* makeregionsliste - Eine Funktion zum Erstellen einer Liste von Regionen aus einer Datei.
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

##
	#* mysqlrest - Eine Funktion zum Ausführen von MySQL-Befehlen und Erfassen des Ergebnisses.
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
    # Übergeben der Argumente an Variablen
    username="$1"
    password="$2"
    databasename="$3"
    mysqlcommand="$4"

    # Ausführen des MySQL-Befehls und Erfassen des Ergebnisses
	result_mysqlrest=$(echo "$mysqlcommand;" | MYSQL_PWD=$password mysql -u"$username" "$databasename" -N) 2>/dev/null
    # result_mysqlrest=$(echo "$mysqlcommand;" | MYSQL_PWD="$password" mysql -u"$username" "$databasename" -N 2>/dev/null)  #** NEU testen
}

##
	#* mysqlrestnodb - Eine Funktion zum Ausführen von MySQL-Befehlen ohne Angabe einer Datenbank.
	#? Verwendung: mysqlrestnodb <Benutzername> <Passwort> <MySQL-Befehl>
	# Diese Funktion führt den angegebenen MySQL-Befehl ohne Angabe einer Datenbank aus und erfasst das Ergebnis.
	# Das Ergebnis wird in der globalen Variable result_mysqlrestnodb gespeichert.
	#? Argumente:
	#   Benutzername - Der MySQL-Benutzername für die Verbindung.
	#   Passwort - Das Passwort für die Verbindung.
	#   MySQL-Befehl - Der zu auszuführende MySQL-Befehl.
	#? Beispiel:
	# mysqlrestnodb myuser mypassword "SHOW DATABASES"
##
function mysqlrestnodb() {
	# Letzte Bearbeitung 27.09.2023
    # Übergeben der Argumente an Variablen
    username="$1"
    password="$2"
    mysqlcommand="$3"

    # Ausführen des MySQL-Befehls und Erfassen des Ergebnisses
	result_mysqlrestnodb=$(echo "$mysqlcommand" | MYSQL_PWD=$password mysql -u"$username")
    # result_mysqlrestnodb=$(echo "$mysqlcommand" | MYSQL_PWD="$password" mysql -u"$username" 2>/dev/null)  #** NEU testen
}

#**************************************************************************
#* Konfigurationen Funktionsgruppe
#**************************************************************************

##
	#* instdialog - Installiert das Dialog-Programm für interaktive Shell-Dialoge.
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

##
	#* oswriteconfig - Schreibt eine Konfiguration für eine Anwendung in einem GNU Screen-Fenster.
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

##
	#* menuoswriteconfig - Schreibt eine Konfiguration für eine Anwendung in einem GNU Screen-Fenster.
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

##
	#* osstarteintrag
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

##
	#* menuosstarteintrag
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

##
	#* osstarteintragdel
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

##
	#* menuosstarteintragdel
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

##
	#* osdauerstop - Stoppt einen OpenSimulator-Server und entfernt ihn aus der Startliste.
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

##
	#* menuosdauerstop - Stoppt einen OpenSimulator-Server und entfernt ihn aus der Startliste.
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

##
	#* osdauerstart.
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

##
	#* menuosdauerstart.
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

##
	#* ossettings.
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

#**************************************************************************
#* Log und Cache Dateien Funktionsgruppe
#**************************************************************************

##
	#* ScreenLog.
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

##
	#* dialogclear.
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

##
	#* clearuserlist.
	# Diese Funktion löscht die Besucherlisten-Protokolldateien im angegebenen Verzeichnis.
	#
	#? Argumente: Keine
	#
	#? Rückgabewerte: Keine
	#
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

##
	#* historylogclear.
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

#**************************************************************************
#* Bildschirmausgaben Funktionsgruppe
#**************************************************************************

##
	#* lastrebootdatum.
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


##
	#* schreibeinfo.
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
		echo "            $SCRIPTNAME $VERSION"
		echo " "
		log line
		log rohtext "  $DATUM $(date +%H:%M:%S) MULTITOOL: wurde gestartet am $(date +%d.%m.%Y) um $(date +%H:%M:%S) Uhr"
		log rohtext "  $DATUM $(date +%H:%M:%S) INFO: Server Name: ${HOSTNAME}"
		log rohtext "  $DATUM $(date +%H:%M:%S) INFO: Server IP: ${AKTUELLEIP}"
		log rohtext "  $DATUM $(date +%H:%M:%S) INFO: Linux Version: $ubuntuDescription"
		log rohtext "  $DATUM $(date +%H:%M:%S) INFO: Release Nummer: $ubuntuRelease"
		log rohtext "  $DATUM $(date +%H:%M:%S) INFO: Linux Name: $ubuntuCodename"
		log rohtext "  $DATUM $(date +%H:%M:%S) INFO: Bash Version: ${BASH_VERSION}"
		txtmono=$(mono --version);
		log rohtext "  $DATUM $(date +%H:%M:%S) INFO: MONO Version: ${txtmono:0:37}"
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
		echo " "
	return 0
}

# *Kopfzeile in die Log Datei schreiben.
schreibeinfo

##
	#* rebootdatum .
	# letzter reboot des Servers.
	# Die Funktion `rebootdatum()` ermittelt das Datum des letzten Systemneustarts
	# und informiert den Benutzer über die vergangene Zeit seit dem letzten Neustart.
	#? @param keine.
	#? @return nichts wird zurueckgegeben.
	# todo: nichts.
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

##
	#* Funktion: reboot
	# Beschreibung: Startet den Server neu.
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

##
	#* Funktion: warnbox
	# Beschreibung: Zeigt eine Warnmeldung in einem Dialogfeld an.
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

##
	#* Funktion: edittextbox
	# Beschreibung: Öffnet eine Textdatei in einem Editor und ermöglicht deren Bearbeitung.
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


##
	#* Funktion: textbox
	# Beschreibung: Zeigt den Inhalt einer Textdatei in einem Dialogfeld an.
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

##
	#* Funktion: nachrichtbox
	# Beschreibung: Zeigt eine Benachrichtigungsnachricht in einem Dialogfeld an.
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

##
	#* Funktion: apacheerror
	# Beschreibung: Zeigt den Inhalt der Apache2-Fehlerprotokolldatei an, falls vorhanden.
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

##
	#* Funktion: mysqldberror
	# Beschreibung: Zeigt den Inhalt der MySQL-Datenbankfehlerprotokolldatei an, falls vorhanden.
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

##
	#* Funktion: mariadberror
	# Beschreibung: Zeigt den Inhalt der MariaDB-/MySQL-Datenbankfehlerprotokolldatei an, falls vorhanden.
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



##
	#* Funktion: ufwlog
	# Beschreibung: Zeigt den Inhalt der UFW-Protokolldatei an, falls vorhanden.
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

##
	#* Funktion: authlog
	# Beschreibung: Zeigt den Inhalt der Authentifizierungs-Protokolldatei an, falls vorhanden.
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

##
	#* Funktion: accesslog
	# Beschreibung: Zeigt den Inhalt des Apache2-Zugriffsprotokolls an, falls vorhanden.
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

##
	#* Funktion: fpspeicher
	# Beschreibung: Ermittelt den verfügbaren Speicherplatz auf dem Dateisystem und zeigt ihn in einer Nachrichtenbox an.
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

##
	#* Funktion: screenlist
	# Beschreibung: Zeigt eine Liste aller laufenden Screen-Sitzungen an, entweder mit oder ohne die Verwendung von 'dialog'.
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

##
	#* Funktion: screenlistrestart
	# Beschreibung: Zeigt eine Liste aller laufenden Screen-Sitzungen und protokolliert sie.
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


#**************************************************************************
#* Downloads Funktionsgruppe
#**************************************************************************

##
	#* Funktion: downloados
	# Beschreibung: Ermöglicht das Herunterladen von Betriebssystem-Dateien über einen Menüdialog.
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

##
	#* Funktion: radiolist
	# Beschreibung: Erstellt eine Liste von Internetradio-Streams basierend auf Musikgenres.
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

##
	#* Funktion: mysqlbackup
	# Beschreibung: Erstellt ein Backup einer MySQL-Datenbank und kann optional das Backup komprimieren.
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

#**************************************************************************
#* Sicherheitsfunktionen Funktionsgruppe
#**************************************************************************

##
	#* Funktion: passgen
	# Beschreibung: Generiert ein zufälliges Passwort mit der angegebenen Länge und gibt es auf der Standardausgabe aus.
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

##
	#* Funktion: passwdgenerator
	# Beschreibung: Generiert ein zufälliges Passwort mit der angegebenen Stärke und gibt es auf der Standardausgabe aus.
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

#**************************************************************************
#* KI AI Funktionsgruppe
#**************************************************************************

##
	#* Funktion: dalaiinstallinfos
	# Beschreibung: Gibt Informationen zu den installierten Versionen von Python, JRE (Java Runtime Environment) und Node.js aus.
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

##
	#* Funktion: dalaiserverinstall
	# Beschreibung: Installiert erforderliche Softwarekomponenten für den Dalai-Server.
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

##
	#* Funktion: dalaimodelinstall
	# Beschreibung: Installiert ein Modell für Dalai basierend auf der angegebenen Modellversion (MKIVERSION).
	#? Parameter:
	#   1. MKIVERSION (optional): Die Modellversion, die installiert werden soll. Standardmäßig wird "7B" verwendet, wenn keine Version angegeben wird.
	#? Rückgabewert: Es wird nichts zurückgegeben.
	#? Aufgaben:
	# 1. Extrahiert die Modellversion aus dem ersten Parameter 'MKIVERSION' oder verwendet "7B" als Standardwert.
	# 2. Überprüft, ob das Verzeichnis '/$mdalaihome/' bereits existiert. Falls nicht, wird es erstellt.
	# 3. Je nach ausgewählter Modellversion werden die entsprechenden Dateien für das Modell heruntergeladen und in das entsprechende Verzeichnis unter '/$mdalaihome/' abgelegt.
	#
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

##
	#* Funktion: dalaiinstall
	# Beschreibung: Installiert den Dalai-Server mit der angegebenen Modellversion (KIVERSION) und legt das Dalai-Modellverzeichnis fest.
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

##
	#* Funktion: dalaisearch
	# Beschreibung: Sucht nach der Verfügbarkeit von Node.js und npm sowie dem Dalai-Tool im System.
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

##
	#* Funktion: dalaiuninstall
	# Beschreibung: Deinstalliert Dalai-Modelle für die angegebenen Modellversionen.
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

##
	#* Funktion: dalaistart
	# Beschreibung: Startet den Dalai-Server und gibt die Serveradresse aus.
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

##
	#* Funktion: dalaistop
	# Beschreibung: Stoppt den laufenden Dalai-Server und zeigt die aktiven 'screen'-Sitzungen an.
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

##
	#* Funktion: dalaiupgrade
	# Beschreibung: Aktualisiert den Dalai-Server auf die angegebene Version oder die Standardversion.
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

#**************************************************************************
#* OpenSimulator Kommandos-Funktionen Funktionsgruppe
#**************************************************************************

##
	#* Funktion: oscommand
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

##
	#* Funktion: oscommand
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

##
	#* Funktion: assetdel
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

##
	#* Funktion: menuassetdel
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

##
	#* Funktion: landclear
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

##
	#* Funktion: menulandclear
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

##
	#* Funktion: loadinventar
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

##
	#* Funktion: menuloadinventar
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

#**************************************************************************
#* Starten und Stoppen Funktionsgruppe
#**************************************************************************

##
	#* Funktion: osstart
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

##
	#* Funktion: osstop
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

##
	#* Funktion: menuosstart
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

##
	#* Funktion: menuosstop
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

##
	#* Funktion: rostart
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

##
	#* Funktion: menurostart
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

##
	#* Funktion: rostop
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

##
	#* Funktion: menurostop
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

##
	#* Funktion: mostart
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

##
	#* Funktion: menumostart
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

##
	#* Funktion: mostop
	# 
	#? Beschreibung:
	# Diese Funktion dient dazu, den MoneyServer zu beenden. Sie überprüft zunächst, ob ein Bildschirm (Screen) mit dem Namen "MO" vorhanden ist, was auf einen laufenden MoneyServer hinweisen würde. Wenn der MoneyServer gefunden wird, sendet die Funktion einen Befehl zum Herunterfahren an den Bildschirm. Anschließend wird eine definierte Wartezeit (MONEYWARTEZEIT) eingehalten, um sicherzustellen, dass der Server ordnungsgemäß beendet wurde. Die Funktion gibt eine Warnmeldung aus und kehrt mit einem Rückgabewert 0 zurück, wenn der MoneyServer erfolgreich beendet wurde. Andernfalls wird eine Fehlermeldung ausgegeben, und die Funktion gibt einen Rückgabewert 1 zurück.
	#
	#? Parameter: Keine.
	#
	#? Rückgabewert:
	# - Erfolgreich: Die Funktion gibt eine Warnmeldung aus und kehrt mit einem Rückgabewert 0 zurück, nachdem der MoneyServer erfolgreich beendet wurde.
	# - Fehlerhaft: Die Funktion gibt eine Fehlermeldung aus und kehrt mit einem Rückgabewert 1 zurück, wenn der MoneyServer nicht gefunden wurde.
	#
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

##
	#* Funktion: menumostop
	# 
	#? Beschreibung:
	# Diese Funktion dient dazu, den MoneyServer zu beenden. Sie überprüft zunächst, ob ein Bildschirm (Screen) mit dem Namen "MO" vorhanden ist, was auf einen laufenden MoneyServer hinweisen würde. Wenn der MoneyServer gefunden wird, sendet die Funktion einen Befehl zum Herunterfahren an den Bildschirm. Anschließend wird eine definierte Wartezeit (MONEYWARTEZEIT) eingehalten, um sicherzustellen, dass der Server ordnungsgemäß beendet wurde. Die Funktion gibt eine Warnmeldung aus und kehrt mit einem Rückgabewert 0 zurück, wenn der MoneyServer erfolgreich beendet wurde. Andernfalls wird eine Fehlermeldung ausgegeben, und die Funktion gibt einen Rückgabewert 1 zurück.
	#
	#? Parameter: Keine.
	#
	#? Rückgabewert:
	# - Erfolgreich: Die Funktion gibt eine Warnmeldung aus und kehrt mit einem Rückgabewert 0 zurück, nachdem der MoneyServer erfolgreich beendet wurde.
	# - Fehlerhaft: Die Funktion gibt eine Fehlermeldung aus und kehrt mit einem Rückgabewert 1 zurück, wenn der MoneyServer nicht gefunden wurde.
	#
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

##
	#* Funktion: osscreenstop
	# 
	#? Beschreibung:
	# Diese Funktion dient dazu, einen bestimmten Screen (Bildschirm) zu beenden. Sie akzeptiert einen Parameter, der den Namen des zu beendenden Screens angibt (SCREENSTOPSCREEN). Die Funktion überprüft zunächst, ob der angegebene Screen existiert, indem sie die Liste der aktiven Screens durchsucht. Wenn der Screen gefunden wird, wird er durch den Befehl "screen -S SCREENSTOPSCREEN -X quit" beendet. Die Funktion gibt eine Erfolgsmeldung aus und kehrt mit einem Rückgabewert 0 zurück, wenn der Screen erfolgreich beendet wurde. Andernfalls wird eine Fehlermeldung ausgegeben, und die Funktion gibt einen Rückgabewert 1 zurück.
	#
	#? Parameter:
	# - SCREENSTOPSCREEN: Der Name des zu beendenden Screens.
	#
	#? Rückgabewert:
	# - Erfolgreich: Die Funktion gibt eine Erfolgsmeldung aus und kehrt mit einem Rückgabewert 0 zurück, nachdem der Screen erfolgreich beendet wurde.
	# - Fehlerhaft: Die Funktion gibt eine Fehlermeldung aus und kehrt mit einem Rückgabewert 1 zurück, wenn der angegebene Screen nicht gefunden wurde.
	#
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

##
	#* Funktion: gridstart
	#
	#? Beschreibung:
	# Die Funktion `gridstart` dient dazu, die verschiedenen Komponenten eines OpenSimulator-Grids (Robust und Money) zu starten. Zunächst werden die Einstellungen für den OpenSimulator über die Funktion `ossettings` konfiguriert. Anschließend überprüft die Funktion, ob die Screens für Robust und Money bereits laufen. Wenn eines oder beide der Screens nicht aktiv sind, werden sie gestartet, indem die Funktionen `rostart` und `mostart` aufgerufen werden. Diese Funktion ist hilfreich, um sicherzustellen, dass alle erforderlichen Komponenten des Grids aktiv sind.
	#
	#? Parameter:
	# Diese Funktion akzeptiert keine Parameter.
	#
	#? Rückgabewert:
	# - Erfolgreich: Die Funktion gibt einen Rückgabewert 0 zurück, nachdem sie die erforderlichen Komponenten gestartet hat.
	# - Fehlerhaft: Die Funktion gibt keine Fehlermeldungen aus, sondern protokolliert nur, wenn Robust oder Money bereits laufen. Sie gibt einen Rückgabewert 0 zurück, wenn alle Komponenten gestartet wurden.
	#
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

##
	#* Funktion: menugridstart
	#
	#? Beschreibung:
	# Die Funktion `menugridstart` dient dazu, die verschiedenen Komponenten eines OpenSimulator-Grids (Robust und Money) zu starten. Zunächst werden die Einstellungen für den OpenSimulator über die Funktion `ossettings` konfiguriert. Anschließend überprüft die Funktion, ob die Screens für Robust und Money bereits laufen. Wenn eines oder beide der Screens nicht aktiv sind, werden sie gestartet, indem die Funktionen `rostart` und `mostart` aufgerufen werden. Diese Funktion ist hilfreich, um sicherzustellen, dass alle erforderlichen Komponenten des Grids aktiv sind.
	#
	#? Parameter:
	# Diese Funktion akzeptiert keine Parameter.
	#
	#? Rückgabewert:
	# - Erfolgreich: Die Funktion gibt einen Rückgabewert 0 zurück, nachdem sie die erforderlichen Komponenten gestartet hat.
	# - Fehlerhaft: Die Funktion gibt keine Fehlermeldungen aus, sondern protokolliert nur, wenn Robust oder Money bereits laufen. Sie gibt einen Rückgabewert 0 zurück, wenn alle Komponenten gestartet wurden.
	#
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

##
	#* Funktion: icecaststart
	#
	#? Beschreibung:
	# Die Funktion `icecaststart` dient dazu, den Icecast-Streaming-Server zu starten. Der Icecast-Server wird über das init.d-Systemdienstskript gestartet. Diese Funktion ermöglicht es, den Icecast-Server auf einfache Weise zu aktivieren, um Streaming-Dienste bereitzustellen.
	#
	#? Parameter:
	# Diese Funktion akzeptiert keine Parameter.
	#
	#? Rückgabewert:
	# - Erfolgreich: Wenn der Icecast-Server erfolgreich gestartet wurde, gibt die Funktion keinen expliziten Rückgabewert zurück.
	# - Fehlerhaft: Wenn ein Fehler beim Starten des Icecast-Servers auftritt, wird dies in der Regel von den Meldungen des init.d-Scripts gemeldet. Die Funktion gibt keinen eigenen Rückgabewert zurück.
	#
	#? Beispielaufruf:
	# icecaststart
##
function icecaststart() {
	# Letzte Bearbeitung 30.09.2023
	# Starte den Icecast-Streaming-Server mit dem init.d-Systemdienstskript
	sudo /etc/init.d/icecast2 start
}

##
	#* Funktion: icecaststop
	#
	#? Beschreibung:
	# Die Funktion `icecaststop` dient dazu, den Icecast-Streaming-Server zu stoppen. Der Icecast-Server wird über das init.d-Systemdienstskript gestoppt. Diese Funktion ermöglicht es, den Icecast-Server auf einfache Weise zu deaktivieren.
	#
	#? Parameter:
	# Diese Funktion akzeptiert keine Parameter.
	#
	#? Rückgabewert:
	# - Erfolgreich: Wenn der Icecast-Server erfolgreich gestoppt wurde, gibt die Funktion keinen expliziten Rückgabewert zurück.
	# - Fehlerhaft: Wenn ein Fehler beim Stoppen des Icecast-Servers auftritt, wird dies in der Regel von den Meldungen des init.d-Scripts gemeldet. Die Funktion gibt keinen eigenen Rückgabewert zurück.
	#
	#? Beispielaufruf:
	# icecaststop
##
function icecaststop() {
	# Letzte Bearbeitung 30.09.2023
	# Stoppe den Icecast-Streaming-Server mit dem init.d-Systemdienstskript
	sudo /etc/init.d/icecast2 stop
}

##
	#* Funktion: icecastrestart
	#
	#? Beschreibung:
	# Die Funktion `icecastrestart` dient dazu, den Icecast-Streaming-Server neu zu starten. Der Icecast-Server wird über das init.d-Systemdienstskript neu gestartet. Diese Funktion ermöglicht es, den Icecast-Server nach Änderungen in der Konfiguration neu zu laden oder nach einem Fehlerzustand neu zu starten.
	#
	#? Parameter:
	# Diese Funktion akzeptiert keine Parameter.
	#
	#? Rückgabewert:
	# - Erfolgreich: Wenn der Icecast-Server erfolgreich neu gestartet wurde, gibt die Funktion keinen expliziten Rückgabewert zurück.
	# - Fehlerhaft: Wenn ein Fehler beim Neustarten des Icecast-Servers auftritt, wird dies in der Regel von den Meldungen des init.d-Scripts gemeldet. Die Funktion gibt keinen eigenen Rückgabewert zurück.
	#
	#? Beispielaufruf:
	# icecastrestart
##
function icecastrestart() {
	# Letzte Bearbeitung 30.09.2023
	# Starte den Icecast-Streaming-Server neu mit dem init.d-Systemdienstskript
	sudo /etc/init.d/icecast2 restart
}

##
	#* Funktion: icecastversion
	#
	#? Beschreibung:
	# Die Funktion `icecastversion` gibt die Version des Icecast-Streaming-Servers aus. Sie ruft das Icecast-Programm mit der Option "-v" auf, um die Version anzuzeigen, und gibt die Ausgabe auf dem Bildschirm aus.
	#
	#? Parameter:
	# Diese Funktion akzeptiert keine Parameter.
	#
	#? Rückgabewert:
	# Die Funktion gibt die Version des Icecast-Servers auf dem Bildschirm aus.
	#
	#? Beispielaufruf:
# icecastversion
##
function icecastversion() {
	# Letzte Bearbeitung 30.09.2023
	# Gibt die Version des Icecast-Servers aus
	/usr/bin/icecast2 -v
}


#**************************************************************************
#* Dateifunktionen Funktionsgruppe
#**************************************************************************

##
 #* saveinventar.
 # Speichere iar inventar "NAME" "VERZEICHNIS" "PASSWORD" "DATEImitPFAD".
 # 
 #? @param "NAME" "VERZEICHNIS" "PASSWORD" "DATEImitPFAD".
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
function saveinventar() {
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

##
 #* menusaveinventar.
 # Speichere Inventar mit dialog Menue in den OpenSimulator.
 # 
 #? @param dialog.
 #? @return dialog.
 # todo: nichts.
##
function menusaveinventar() {
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

##
 #* menuworks.
 # screen pruefen ob er laeuft, dialog auswahl.
 # 
 #? @param dialog.
 #? @return dialog.
 # todo: nichts.
##
function menuworks() {
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

##
 #* works.
 # screen pruefen ob er laeuft.
 # Aufruf: works screen_name
 # 
 #? @param $WORKSSCREEN.
 #? @return $WORKSSCREEN.
 # todo: nichts.
##
function works() {
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

##
 #* waslauft.
 # Zeigt alle Laufenden Screens an.
 # 
 #? @param keine.
 #? @return $ergebnis.
 # todo: nichts.
##
function waslauft() {
	# Die screen -ls ausgabe zu einer Liste aendern.
	# sed '1d' = erste Zeile loeschen - sed '$d' letzte Zeile loeschen.
	# awk -F. alles vor dem Punkt entfernen - -F\( alles hinter dem  ( loeschen.
	ergebnis=$(screen -ls | sed '1d' | sed '$d' | awk -F. '{print $2}' | awk -F\( '{print $1}')
	echo "$ergebnis"
	return 0
}

##
 #* waslauft.
 # Zeigt alle Laufenden Screens an.
 # 
 #? @param dialog.
 #? @return dialog.
 # todo: nichts.
##
function menuwaslauft() {
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

##
 #* checkfile.
 # pruefen ob Datei vorhanden ist.
 # Aufruf: checkfile "pfad/name"
 # 
 #? @param $DATEINAME.
 #? @return $?.
 # todo: nichts.
##
function checkfile() {
	# Verwendung als Einzeiler: checkfile /pfad/zur/datei && echo "File exists" || echo "File not found!"
	DATEINAME=$1
	[ -f "$DATEINAME" ]
	return $?
}

##
 #* mapdel.
 # loescht die Map-Karten.
 # Aufruf: mapdel Verzeichnis
 # 
 #? @param $VERZEICHNIS.
 #? @return $VERZEICHNIS.
 # todo: nichts.
##
function mapdel() {
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

##
 #* logdel.
 # loescht die Log Dateien. 
 # Aufruf: logdel Verzeichnis
 # 
 #? @param $VERZEICHNIS.
 #? @return $VERZEICHNIS.
 # todo: nichts.
##
function logdel() {
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

##
 #* rologdel.
 # loescht die Log Dateien. 
 # Aufruf: rologdel
 # 
 #? @param keine.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
function rologdel() {

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

##
 #* menumapdel.
 # loescht die Log Dateien.
 # 
 #? @param dialog.
 #? @return dialog.
 # todo: nichts.
##
function menumapdel() {
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

##
 #* menulogdel.
 # loescht die Log Dateien.
 # 
 #? @param dialog.
 #? @return dialog.
 # todo: nichts.
##
function menulogdel() {
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

##
 #* assetcachedel.
 # loescht die asset cache Dateien. 
 # Aufruf: assetcachedel Verzeichnis
 # Das Verzeichnis samt neuer Daten werden beim naechsten start des opensimulator neu geschrieben.
 #? @param $VERZEICHNIS.
 #? @return $VERZEICHNIS.
 # todo: nichts.
##
function assetcachedel() {
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

##
 #* autoassetcachedel.
 # automatisches loeschen aller asset cache Dateien.
 # Die Verzeichnisse samt neuer Daten werden beim naechsten start des opensimulator neu geschrieben.
 #? @param keine.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
function autoassetcachedel() {
	#log line
	makeverzeichnisliste
	sleep 1
	for ((i = 0; i < "$ANZAHLVERZEICHNISSLISTE"; i++)); do
		rm -r /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/assetcache 2>/dev/null | log info "OpenSimulator ${VERZEICHNISSLISTE[$i]} assetcache Verzeichnisse geloescht" || log warn "${VERZEICHNISSLISTE[$i]} assetcache Verzeichnis wurde nicht gefunden! "
		
		sleep 1
	done
	return 0
}

#**************************************************************************
#* Starten und Stoppen Funktionsgruppe
#**************************************************************************

##
 #* menugridstop.
 # Stoppt erst Money dann Robust.
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
##  gridstop, stoppt erst Money dann Robust.
function menugridstop() {
	if screen -list | grep -q MO; then
		menumostop
	fi

	if screen -list | grep -q RO; then
		menurostop
	fi
	return 0
}

##
 #* scstart.
 # startet Region Server - Kurzversion.
 # Beispiel-Example: bash osmtool.sh scstart sim1
 # 
 #? @param $SCSTARTSCREEN.
 #? @return nichts wird zurueckgegeben.
 # todo: testen.
##
function scstart() {
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

##
 #* scstop.
 # stoppt Region Server - Kurzversion.
 # Beispiel-Example: bash osmtool.sh scstop sim1
 # 
 #? @param $SCSTOPSCREEN.
 #? @return nichts wird zurueckgegeben.
 # todo: testen.
##
function scstop() {
	SCSTOPSCREEN=$1 # OpenSimulator, Verzeichnis und Screen Name
	screen -S "$SCSTOPSCREEN" -p 0 -X eval "stuff 'shutdown'^M"
}
##
 #* sckill.
 # Killt Region Server - Kurzversion.
 # Beispiel-Example: bash osmtool.sh sckill sim1
 # 
 #? @param $SCKILLSCREEN.
 #? @return nichts wird zurueckgegeben.
 # todo: testen.
##
function sckill() {
	SCKILLSCREEN=$1 # OpenSimulator, Verzeichnis und Screen Name
	screen -X -S "$SCKILLSCREEN" kill
}

##
 #* simstats.
 # zeigt Simstatistik an. 
 # simstats screen_name
 # erzeugt im Hauptverzeichnis eine Datei namens sim1.log in dieser Datei ist die Statistik zu finden.
 #? @param $STATSSCREEN.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
function simstats() {
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

##
 #* terminator.
 # killt alle noch offene Screens.
 # 
 #? @param keine.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
function terminator() {
	log info "hasta la vista baby"
	log warn "TERMINATOR: Alle Screens wurden durch Benutzer beendet"
	killall screen
	screen -ls
	return 0
}

##
 #* oscompi93.
 # kompilieren des OpenSimulator.
 # 
 #? @param $netversion.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
function oscompi93() {
	# ohne log Datei.
    git clone git://opensimulator.org/git/opensim opensim93
    cd opensim93 || exit
    git checkout dotnet6
    ./runprebuild.sh
    dotnet build --configuration Release OpenSim.sln
    log info "Eine Besonderheit ist, der Startvorgang hat sich geaendert, es wird nicht mehr mit mono OpenSim.exe gestartet, sondern mit dotnet OpenSim.dll."

	log info "Kompilierung wurde durchgefuehrt"
	return 0
}

##
 #* oscompi.
 # kompilieren des OpenSimulator.
 # 
 #? @param $netversion.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
function oscompi() {
	# Wenn keine Einstellung vorhanden ist dann VS2019 mit mono 4.6
	if [[ "$netversion" = "" ]]; then netversion="1946"; fi

	log info " Kompilierungsvorgang startet"
	# In das opensim Verzeichnis wechseln wenn es das gibt ansonsten beenden.
	cd /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS || return 1

	log info " Prebuildvorgang startet"

	# Funktionierend
	# Visual Studio 2019 mit mono 4.6
	if [[ "$netversion" = "1946" ]]; then

		log info " Prebuildvorgang mono 4.6"
		# Kopiere runprebuild.sh in das OpenSim Verzeichnis:
		cp -r /$STARTVERZEICHNIS/dotnet/*.* /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS
		# runprebuild.sh startbar machen:
		chmod +x runprebuild.sh
		# runprebuild.sh starten:
		./runprebuild.sh
	fi
	# Visual Studio 2019 mit mono 4.8
	if [[ "$netversion" = "1948" ]]; then
		log info " Prebuildvorgang mono 4.8"
		# Kopiere runprebuild48.sh in das OpenSim Verzeichnis:
		cp -r /$STARTVERZEICHNIS/dotnet/*.* /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS
		# runprebuild48.sh startbar machen:
		chmod +x runprebuild48.sh
		# runprebuild48.sh starten:
		./runprebuild48.sh
	fi

	# Visual Studio 2022 mit mono 4.8
	if [[ "$netversion" = "2248" ]]; then
		log info " Prebuildvorgang mono 4.8"
		# Kopiere runprebuild2248.sh in das OpenSim Verzeichnis:
		cp -r /$STARTVERZEICHNIS/dotnet/*.* /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS
		# runprebuild2248.sh startbar machen:
		chmod +x runprebuild2248.sh
		# runprebuild2248.sh starten:
		./runprebuild2248.sh
	fi
	# Funktionierend Ende

	# Visual Studio 2022 mit mono 5.0
	if [[ "$netversion" = "2250" ]]; then
		log info " Prebuildvorgang mono 5.0 VS2022"
		# Kopiere runprebuild2250.sh in das OpenSim Verzeichnis:
		cp -r /$STARTVERZEICHNIS/dotnet/*.* /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS
		# runprebuild2250.sh startbar machen:
		chmod +x runprebuild2250.sh
		# runprebuild2250.sh starten:
		./runprebuild2250.sh
	fi
	# Visual Studio 2022 mit mono 6.0
	if [[ "$netversion" = "2260" ]]; then
		log info " Prebuildvorgang mono 6.0 VS2022"
		# Kopiere runprebuild2260.sh in das OpenSim Verzeichnis:
		cp -r /$STARTVERZEICHNIS/dotnet/*.* /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS
		# runprebuild2260.sh startbar machen:
		chmod +x runprebuild2260.sh
		# runprebuild2260.sh starten:
		./runprebuild2260.sh
	fi
	# Visual Studio 2022 mit mono 7.0
	if [[ "$netversion" = "2270" ]]; then
		log info " Prebuildvorgang mono 7.0 VS2022"
		# Kopiere runprebuild2270.sh in das OpenSim Verzeichnis:
		cp -r /$STARTVERZEICHNIS/dotnet/*.* /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS
		# runprebuild2270.sh startbar machen:
		chmod +x runprebuild2270.sh
		# runprebuild2270.sh starten:
		./runprebuild2270.sh
	fi
		# Visual Studio 2019 mit mono 5.0
		if [[ "$netversion" = "1950" ]]; then
		log info " Prebuildvorgang mono 5.0 VS2019"
		# Kopiere runprebuild1950.sh in das OpenSim Verzeichnis:
		cp -r /$STARTVERZEICHNIS/dotnet/*.* /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS
		# runprebuild1950.sh startbar machen:
		chmod +x runprebuild1950.sh
		# runprebuild1950.sh starten:
		./runprebuild1950.sh
	fi
		# Visual Studio 2019 mit mono 6.0
	if [[ "$netversion" = "1960" ]]; then
		log info " Prebuildvorgang mono 6.0 VS2019"
		# Kopiere runprebuild1960.sh in das OpenSim Verzeichnis:
		cp -r /$STARTVERZEICHNIS/dotnet/*.* /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS
		# runprebuild1960.sh startbar machen:
		chmod +x runprebuild1960.sh
		# runprebuild1960.sh starten:
		./runprebuild1960.sh
	fi
		# Visual Studio 2019 mit mono 7.0
	if [[ "$netversion" = "1970" ]]; then
		log info " Prebuildvorgang mono 7.0 VS2019"
		# Kopiere runprebuild1970.sh in das OpenSim Verzeichnis:
		cp -r /$STARTVERZEICHNIS/dotnet/*.* /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS
		# runprebuild1970.sh startbar machen:
		chmod +x runprebuild1970.sh
		# runprebuild1970.sh starten:
		./runprebuild1970.sh
	fi

	# ohne log Datei.
	if [[ $SETOSCOMPION = "no" ]]; then
		if [[ $BUILDOLD = "yes" ]]; then
		msbuild /p:Configuration=Release || return 1
		fi
		if [[ $BUILDOLD = "no" ]]; then
		dotnet build -c Release OpenSim.sln || return 1
		fi
	fi
	# mit log Datei.
	if [[ $SETOSCOMPION = "yes" ]]; then
		msbuild /p:Configuration=Release /fileLogger /flp:logfile=opensimbuild.log /v:d || return 1
	fi
	# AOT Aktiveren oder Deaktivieren.
	if [[ $SETAOTON = "yes" ]]; then
		makeaot
	fi
	log info "Kompilierung wurde durchgefuehrt"
	return 0
}

##
 #* opensimgitcopy93.
 # OpenSimulator Source Dateien vom Github kopieren.
 # 
 #? @param nichts.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
function opensimgitcopy93() {
	#Money und Scripte vom Git holen

	if [[ $MONEYCOPY = "yes" ]]; then
		log info "OpenSimulator wird vom GIT geholt"
		git clone git://opensimulator.org/git/opensim /$STARTVERZEICHNIS/opensim
	else
		log error "OpenSimulator nicht vorhanden"
	fi
	return 0
}

##
 #* moneygitcopy93.
 # Money Server Source Dateien vom Github kopieren.
 # 
 #? @param $MONEYCOPY.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
function moneygitcopy93() {
	#Money und Scripte vom Git holen

	if [[ $MONEYCOPY = "yes" ]]; then
		log info "MONEYSERVER: MoneyServer wird vom GIT geholt"
		git clone https://github.com/BigManzai/OpenSimCurrencyServer-2023 /$STARTVERZEICHNIS/OpenSimCurrencyServer-2023
	else
		log error "MONEYSERVER: MoneyServer nicht vorhanden"
	fi
	return 0
}

##
 #* moneygitcopy.
 # Money Server Source Dateien vom Github kopieren.
 # 
 #? @param $MONEYCOPY.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
function moneygitcopy() {
	#Money und Scripte vom Git holen

	if [[ $MONEYCOPY = "yes" ]]; then
		log info "MONEYSERVER: MoneyServer wird vom GIT geholt"
		git clone https://github.com/BigManzai/OpenSimCurrencyServer-2021 /$STARTVERZEICHNIS/OpenSimCurrencyServer-2021-master
	else
		log error "MONEYSERVER: MoneyServer nicht vorhanden"
	fi
	return 0
}

##
 #* divagitcopy.
 # Diva Source Dateien vom Github kopieren.
 # 
 #? @param $DIVACOPY.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
function divagitcopy() {
	#DIVA und Scripte vom Git holen

	if [[ $DIVACOPY = "yes" ]]; then
		log info "DIVA wird vom GIT geholt"
		git clone https://github.com/BigManzai/diva-distribution /$STARTVERZEICHNIS/diva-distribution
	else
		log error "DIVA nicht vorhanden"
	fi
	return 0
}
##
 #* divacopy.
 # DIVA Server Dateien kopieren.
 # 
 #? @param keine.
 #? @return nichts wird zurueckgegeben.
 # todo: testen.
##
function divacopy() {
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

##
 #* scriptgitcopy.
 # Script Assets Dateien vom Github kopieren.
 # 
 #? @param keine.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
function scriptgitcopy() {
	#Scripte vom Git holen
	if [[ $SCRIPTCOPY = "yes" ]]; then
		log info "Script Assets werden vom GIT geholt"
		git clone https://github.com/BigManzai/opensim-ossl-example-scripts /$STARTVERZEICHNIS/opensim-ossl-example-scripts-main
	else
		log error "Script Assets sind nicht vorhanden"
	fi
	return 0
}

##
 #* scriptcopy.
 # lsl ossl scripte kopieren.
 # 
 #? @param keine.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
function scriptcopy() {
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

##
 #* moneycopy93.
 # Money Server Dateien kopieren.
 # 
 #? @param keine.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
function moneycopy93() {
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

##
 #* moneycopy.
 # Money Server Dateien kopieren.
 # 
 #? @param keine.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
function moneycopy() {
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

##
 #* mutelistcopy.
 # OpenSimMutelist Dateien kopieren.
 # 
 #? @param keine.
 #? @return nichts wird zurueckgegeben.
 # todo: Testen.
##
function mutelistcopy() {
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
##
 #* searchcopy.
 # OpenSimSearch Dateien kopieren.
 # 
 #? @param keine.
 #? @return nichts wird zurueckgegeben.
 # todo: Testen.
##
function searchcopy() {
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

##
 #* makeaot.
 # aot generieren.
 # 
 #? @param keine.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
function makeaot() {
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

##
 #* cleanaot.
 # aot entfernen.
 # 
 #? @param keine.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
function cleanaot() {
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

##
 #* setversion.
 # Prebuild erstellen 
 # Aufruf Beispiel: osmtool.sh prebuild 1330.
 # 
 #? @param $NUMMER.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
function setversion() {
	NUMMER=$1
	log info "OpenSim Version umbenennen und Release auf $NUMMER einstellen"

	echo "V$NUMMER " >/$STARTVERZEICHNIS/opensim/bin/'.version'

	# sed -i schreibt sofort - s/Suchwort/Ersatzwort/g - /Verzeichnis/Dateiname.Endung
	sed -i s/Yeti//g /$STARTVERZEICHNIS/opensim/OpenSim/Framework/VersionInfo.cs
	# flavour loeschen
	sed -i s/' + flavour'//g /$STARTVERZEICHNIS/opensim/OpenSim/Framework/VersionInfo.cs
	return 0
}

##
 #* versionsausgabe93
 # Version OpenSimulator unter dotnet6
 # Aufruf Beispiel: osmtool.sh versionsausgabe
 # 
 #? @param Keine.
 #? @return Ausgabe Informationen.
 # todo: nichts.
##
function versionsausgabe93() {
	cd /opt/opensim || exit
	log rohtext Verionsausgabe:
    git log -n 1
    git describe --abbrev=7 --always  --long --match v* master
}

##
 #* setversion93.
 # Versionsnummer Setzen
 # Aufruf Beispiel: osmtool.sh setversion93 1234.
 # 
 #? @param Nummer, d, p, z.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
function setversion93() {
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

	# Ganze Zeile austauschen gegen: 0.9.2.2Dev-676-gdd9e365e00
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

##
 #* osstruktur.
 # legt die Verzeichnisstruktur fuer OpenSim an. 
 # Aufruf: osmtool.sh osstruktur ersteSIM letzteSIM.
 # Beispiel: ./osmtool.sh osstruktur 1 10 - erstellt ein Grid Verzeichnis fuer 10 Simulatoren inklusive der $SIMDATEI.
 #? @param ersteSIM letzteSIM.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
function osstruktur() {
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

##
 #* menuosstruktur.
 # legt die Verzeichnisstruktur fuer OpenSim an.
 # 
 #? @param dialog.
 #? @return dialog.
 # todo: nichts.
##
function menuosstruktur() {
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

##
 #* osdelete.
 # altes opensim loeschen und letztes opensim als Backup umbenennen.
 # 
 #? @param keine.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
function osdelete() {
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

##
 #* oscopyrobust.
 # Robust Daten kopieren.
 # bash osmtools.sh oscopyrobust
 # 
 #? @param keine.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
function oscopyrobust() {
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

##
 #* oscopysim.
 # Simulatoren kopieren aus dem Verzeichnis opensim.
 # bash osmtools.sh oscopysim
 # 
 #? @param keine.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
function oscopysim() {
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

##
 #* oscopy.
 # Simulator kopieren aus dem Verzeichnis opensim.
 # bash osmtools.sh oscopy sim1
 # 
 #? @param keine.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
function oscopy() {
	cd /$STARTVERZEICHNIS || return 1
	VERZEICHNIS=$1
	log info "Kopiere Simulator $VERZEICHNIS "
	cd /$STARTVERZEICHNIS/"$VERZEICHNIS"/bin || return 1 # Prüfen ob Verzeichnis vorhanden ist.
	cp -r /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/bin /$STARTVERZEICHNIS/"$VERZEICHNIS"
	return 0
}

##
 #* configlesen.
 # Regionskonfigurationen lesen. 
 # Beispiel: configlesen sim1
 # 
 #? @param keine.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
function configlesen() {
	log info "CONFIGLESEN: Regionskonfigurationen von $CONFIGLESENSCREEN"
	CONFIGLESENSCREEN=$1
	KONFIGLESEN=$(awk -F":" '// {print $0 }' /$STARTVERZEICHNIS/"$CONFIGLESENSCREEN"/bin/Regions/*.ini) # Regionskonfigurationen aus einem Verzeichnis lesen.
	log info "$KONFIGLESEN"
	return 0
}

##
 #* ini_get.
 # Konfigurationsbereich lesen.
 # Verwendung: ini_get Dateiname SECTION KEY
 # 
 #? @param keine.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
function ini_get() {
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

##
 #* ini_set.
 # Konfigurationsbereich schreiben. 
 # Verwendung: ini_set Dateiname SECTION KEY WERT
 # 
 #? @param keine.
 #? @return nichts wird zurueckgegeben.
 # todo: Testen, schreibt nicht.
##
function ini_set() {
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

##
 #* regionsconfigdateiliste.
 # schreibt Dateinamen mit Pfad in eine Datei.
 # regionsconfigdateiliste -b(Bildschirm) -d(Datei)  Vereichnis
 # 
 #? @param keine.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
function regionsconfigdateiliste() {
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

##
 #* meineregionen.
 # listet alle Regionen aus den Konfigurationen auf.
 # 
 #? @param keine.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
function meineregionen() {
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

##
 #* regionsinisuchen.
 # sucht alle Regionen.
 # 
 #? @param keine.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
function regionsinisuchen() {
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

##
 #* get_regionsarray.
 # gibt ein Array aller Regionsabschnitte zurueck.
 # 
 #? @param keine.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
function get_regionsarray() {
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

##
 #* get_value_from_Region_key.
 # gibt den Wert eines bestimmten Schluessels im angegebenen Abschnitt zurueck.
 # $1 - Datei - $2 - Schluessel - $3 - Sektion
 # 
 #? @param keine.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
function get_value_from_Region_key() {
	# RKDATEI=$1; RKSCHLUESSEL=$2; RKSEKTION=$3;
	# Es fehlt eine pruefung ob Datei vorhanden ist.
	# shellcheck disable=SC2005
	#echo "$(sed -nr "/^\[$2\]/ { :l /^$3[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" "$1")" # Nur Parameter
	echo "$(sed -nr "/^\[$2\]/ { :l /$3[ ]}*=/ { p; q;}; n; b l;}" "$1")" # Komplette eintraege
	return 0
}

##
 #* regionsiniteilen.
 # holt aus der Regions.ini eine Region heraus und speichert sie mit ihrem Regionsnamen.
 # Aufruf: regionsiniteilen Verzeichnis Regionsname
 # 
 #? @param keine.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
function regionsiniteilen() {
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

##
 #* autoregionsiniteilen.
 # Die gemeinschaftsdatei Regions.ini in einzelne Regionen teilen.
 # diese dann unter dem Regionsnamen speichern, danach die Alte Regions.ini umbenennen in Regions.ini.old.
 # 
 #? @param keine.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
function autoregionsiniteilen() {
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

##
 #* regionliste.
 # Die RegionListe ermitteln und mit dem Verzeichnisnamen in die osmregionlist.ini schreiben.
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
##  
function regionliste() {
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

##
 #* makewebmaps.
 # Kopiere Maptile aus dem Robust nach html fuer Webanzeige.
 # 
 #? @param keine.
 #? @return nichts wird zurueckgegeben.
 # todo: Nur Bilder kopieren, wenn sie nicht vorhanden sind, oder aelter als bla bla sind.
##
function makewebmaps() {
	MAPTILEVERZEICHNIS="maptiles"
	log info "MAKEWEBMAPS: Kopiere Maptile"
	# Verzeichnis erstellen wenn es noch nicht vorhanden ist.
	mkdir -p /var/www/html/$MAPTILEVERZEICHNIS/
	# Maptiles kopieren
	find /$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS/bin/maptiles -type f -exec cp -a -t /var/www/html/$MAPTILEVERZEICHNIS/ {} +
	return 0
}

##
 #* moneydelete.
 # loescht den MoneyServer ohne die OpenSim Config zu veraendern.
 # 
 #? @param keine.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
function moneydelete() {
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

##
 #* osgitholen.
 # kopiert eine Entwicklerversion in das opensim Verzeichnis.
 # 
 #? @param keine.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
function osgitholen() {
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

##
 #* osgitholen93.
 # kopiert eine Entwicklerversion in das opensim Verzeichnis.
 # 
 #? @param keine.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
function osgitholen93() {
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

##
 #* osbauen93
 # Baut einen neuen OpenSimulator mit dotnet 6.
 # 
 #? @param keine.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
function osbauen93() {
	# Bauen
    cd /$STARTVERZEICHNIS/opensim || exit
    git checkout dotnet6
    ./runprebuild.sh
    dotnet build --configuration Release OpenSim.sln
    log rohtext "Eine Besonderheit ist, der Startvorgang hat sich geaendert, es wird nicht mehr mit mono OpenSim.exe gestartet, sondern mit dotnet OpenSim.dll."
}

##
 #* opensimholen.
 # holt den OpenSimulator in das Arbeitsverzeichnis.
 # 
 #? @param keine.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
function opensimholen() {
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

##
 #* install_mysqltuner.
 # Installation von mysqltuner.
 # 
 #? @param keine.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
function install_mysqltuner() {
	cd /$STARTVERZEICHNIS || return 1
	log info "mySQL Tuner Download"
	wget http://mysqltuner.pl/ -O mysqltuner.pl 2>/dev/null
	wget https://raw.githubusercontent.com/major/MySQLTuner-perl/master/basic_passwords.txt -O basic_passwords.txt 2>/dev/null
	wget https://raw.githubusercontent.com/major/MySQLTuner-perl/master/vulnerabilities.csv -O vulnerabilities.csv 2>/dev/null
	mySQLmenu
	return 0
}

##
 #* regionbackup.
 # backup einer Region.
 # regionbackup Screenname "Der Regionsname"
 # 
 #? @param BACKUPVERZEICHNISSCREENNAME REGIONSNAME.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
function regionbackup() {
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

##
 #* menuregionbackup.
 # ist die dialog Version von regionbackup().
 # 
 #? @param dialog.
 #? @return dialog.
 # todo: nichts.
##
function menuregionbackup() {
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

##
 #* regionrestore.
 # hochladen einer Region.
 # regionrestore Screenname "Der Regionsname"
 # Ich kann nicht pruefen ob die Region im OpenSimulator vorhanden ist. Sollte sie nicht vorhanden sein wird root (Alle) oder die letzte ausgewaehlte Region wiederhergestellt. 
 # Dies zerstoert eventuell vorhandene Regionen.
 #? @param keine.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
function regionrestore() {
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

##
 #* menuregionrestore.
 # Eine erklaerung, wie man Funktionen nach den Programierrichtlinien richtig kommentiert.
 # Ich kann nicht pruefen ob die Region im OpenSimulator vorhanden ist. Sollte sie nicht vorhanden sein wird root (Alle) oder die letzte ausgewaehlte Region wiederhergestellt. 
 # Dies zerstoert eventuell vorhandene Regionen.
 #? @param dialog.
 #? @return dialog.
 # todo: nichts.
##
function menuregionrestore() {
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

##
 #* autosimstart.
 # automatischer sim start ohne Robust und Money.
 # 
 #? @param keine.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
function autosimstart() {
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

##
 #* autosimstop.
 # Stoppen aller laufenden Simulatoren.
 # 
 #? @param keine.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
function autosimstop() {
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

##
 #* menuautosimstart.
 # Starten aller Simulatoren.
 # 
 #? @param dialog.
 #? @return dialog.
 # todo: nichts.
##
function menuautosimstart() {
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

##
 #* menuautosimstop.
 # Stoppen aller laufenden Simulatoren.
 # 
 #? @param dialog.
 #? @return dialog.
 # todo: nichts.
##
function menuautosimstop() {
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

##
 #* autologdel.
 # automatisches loeschen aller log Dateien.
 # 
 #? @param keine.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
# Die Dateien samt neuer Daten werden beim naechsten start des opensimulator neu geschrieben.
function autologdel() {
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

##
 #* menuautologdel.
 # automatisches loeschen aller log Dateien.
 # 
 #? @param dialog.
 #? @return dialog.
 # todo: nichts.
##
function menuautologdel() {
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

##
 #* automapdel.
 # utomatisches loeschen aller Map/Karten Dateien.
 # 
 #? @param keine.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
# Die Dateien samt neuer Daten werden beim naechsten start des opensimulator neu geschrieben.
function automapdel() {
	makeverzeichnisliste
	sleep 1
	for ((i = 0; i < "$ANZAHLVERZEICHNISSLISTE"; i++)); do
		cd /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin || return 1
		rm -r maptiles/* || echo " "
		log warn "OpenSimulator maptile ${VERZEICHNISSLISTE[$i]} geloescht"
		sleep 1
	done
	autorobustmapdel
	return 0
}

##
 #* autorobustmapdel.
 # automatisches loeschen aller Map/Karten Dateien in Robust.
 # Die Dateien samt neuer Daten werden beim naechsten start des opensimulator neu geschrieben.
 # 
 #? @param keine.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
function autorobustmapdel() {
	cd /$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS/bin || return 1
	rm -r maptiles/* || log line
	log warn "OpenSimulator maptile aus $ROBUSTVERZEICHNIS geloescht"
	return 0
}

##
 #* cleaninstall.
 # loeschen aller externen addon Module.
 # 
 #? @param keine.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
function cleaninstall() {

	if [ ! -f "/$STARTVERZEICHNIS/opensim/addon-modules/" ]; then
		rm -r $STARTVERZEICHNIS/opensim/addon-modules/*
	else
		log error "addon-modules Verzeichnis existiert nicht"
	fi
	return 0
}

##
 #* cleanprebuild.
 # loeschen aller Prebuild Dateien, da sie von OpenSim Prebuild clean nicht geloescht werden.
 # 
 #? @param keine.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
function cleanprebuild() {
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

##
 #* allclean.
 # loescht Log, dll, so, exe, aot Dateien fuer einen saubere neue installation, ohne Robust.
 # Hierbei werden keine Datenbanken oder Konfigurationen geloescht aber opensim ist anschliessend nicht mehr startbereit.
 # Um opensim wieder Funktionsbereit zu machen muss ein Upgrade oder ein oscopy vorgang ausgefuehrt werden.
 #? @param keine.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
function allclean() {
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

##
 #* getcachesinglegroesse.
 # Zeigt Cache Dateien und die größe aus einem einzelnen Simulator an.
 # du steht für disk usage.
 #? @param keine.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
function getcachesinglegroesse() {
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

##
 #* getcachegroesse.
 # Zeigt Cache Dateien und die größe aus dem gesamten Grid an.
 # du steht für disk usage.
 #? @param keine.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
function getcachegroesse() {
	# du -sh /opt/sim1/bin/verzeichnisname
	# Fehlermeldung ins Nirwana schicken:   2> /dev/null
	#log line
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

##
 #* tastaturcachedelete
 # history des Terminals löschen.
 # 
 #? @param keine.
 #? @return nichts.
 # todo: nichts.
##
function tastaturcachedelete() {
	history -cw
}

##
 #* gridcachedelete.
 # loescht alle Cache Dateien die sich im laufe der Zeit angesammelt haben.
 # GRIDCACHECLEAR="yes"; ASSETCACHECLEAR="yes"; MAPTILESCLEAR="yes"; SCRIPTCLEAR="yes"; RMAPTILESCLEAR="yes"; RBAKESCLEAR="yes";
 # 
 #? @param keine.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
function gridcachedelete() {
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

##
 #* autoallclean.
 # loescht Log, dll, so, exe, aot Dateien fuer einen saubere neue installation, mit Robust.
 # Hierbei werden keine Datenbanken oder Konfigurationen geloescht aber opensim ist anschliessend nicht mehr startbereit.
 # Um opensim wieder Funktionsbereit zu machen muss ein Upgrade oder ein oscopy vorgang ausgefuehrt werden.
 #? @param keine.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
function autoallclean() {
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

##
 #* autoregionbackup.
 # automatischer Backup aller Regionen die in der Regionsliste eingetragen sind.
  #* Zuerst muss aber einmalig eine Regionliste erstellt werden mit "osmtool.sh regionliste". Die RegionListe ermitteln und mit dem Verzeichnisnamen in die osmregionlist.ini schreiben.
 # 
 #? @param keine.
 #? @return regionbackup BACKUPSCREEN BACKUPREGION.
 # todo: Uebergabe Parameter Fehler. Bug Modus mit extra ausgaben. Ist keine osmregionlist.ini vorhanden muss sie erstellt werden.
##
function autoregionbackup() {
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

##
 #* autoscreenstop.
 # beendet alle laufenden simX screens.
 # 
 #? @param keine.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
function autoscreenstop() {
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

##
 #* menuautoscreenstop.
 # beendet alle laufenden simX screens.
 # 
 #? @param keine.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
function menuautoscreenstop() {
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

##
 #* autostart.
 # startet das komplette Grid mit allen sims.
 # 
 #? @param keine.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
function autostart() {
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

##
 #*  gridstop.
 # Stoppt erst Money dann Robust.
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
##  
function gridstop() {
	if screen -list | grep -q MO; then
		mostop
	fi

	if screen -list | grep -q RO; then
		rostop
	fi
	return 0
}

##
 #* autostop.
 # stoppt das komplette Grid mit allen sims.
 # 
 #? @param keine.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
function autostop() {
	log warn "#** Stoppe das Grid! **#"
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

##
 #* menuautostart.
 # startet das komplette Grid mit allen sims.
 # 
 #? @param keine.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
function menuautostart() {
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

##
 #* menuautostop.
 # stoppt das komplette Grid mit allen sims.
 # 
 #? @param keine.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
function menuautostop() {
	log warn "#** Stoppe das Grid! **#"
	# schauen ob screens laufen wenn ja beenden.
	if screen -list | grep -q 'sim'; then log info "Bitte warten..."; menuautosimstop; fi
	if screen -list | grep -q "RO"; then log info "Bitte warten..."; menugridstop; fi
	# schauen ob screens laufen wenn ja warten.
	if screen -list | grep -q 'sim'; then log info "Bitte warten..."; sleep $AUTOSTOPZEIT; killall screen; fi

	menuautoscreenstop
	hauptmenu
}

##
 #* autorestart.
 # startet das gesamte Grid neu und loescht die log Dateien.
 # 
 #? @param keine.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
function autorestart() {
	log rohtext " Automatischer Restart wird ausgeführt!"
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

##
 #* menuautorestart.
 # startet das gesamte Grid neu und loescht die log Dateien.
 # 
 #? @param keine.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
function menuautorestart() {
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

##
 #* serverupgrade.
 # Linux Server Updaten und Upgraden.
 # 
 #? @param keine.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
function serverupgrade() {
	sudo apt-get update
	sudo apt-get upgrade
}

##
 #* installmariadb18.
 # Installation oder Migration von MariaDB 10.8.3 oder hoeher fuer Ubuntu 18.
 # 
 #? @param keine.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
function installmariadb18() {

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

##
 #* installmariadb22.
 # Installation oder Migration von MariaDB fuer Ubuntu 22.
 # 
 #? @param keine.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
function installmariadb22() {
	# MySQL stoppen wenn es laeuft:
	sudo service mysql stop

	# MariaDB installieren:
	sudo apt-get update
	sudo apt-get -y install mariadb-server

	mariadb --version
}

##
 #* monoinstall.
 # mono 6.x installieren.
 # 
 #? @param keine.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
function monoinstall() {
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

##
 #* monoinstall18.
 # mono installation auf Ubuntu 18.
 # 
 #? @param keine.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
function monoinstall18() {
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

##
 #* monoinstall20.
 # mono installation auf Ubuntu 20.
 # 
 #? @param keine.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
function monoinstall20() {
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

##
 #* monoinstall22.
 # mono installation auf Ubuntu 22.
 # 
 #? @param keine.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
function monoinstall22() {
	sudo apt install mono-roslyn mono-complete mono-dbg mono-xbuild -y
}

##
 #* icecastinstall.
 # icecast installieren.
 # 
 #? @param keine.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
function icecastinstall() {
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

##
 #* icecastconfig.
 # icecast konfigurieren.
 # Der Port muss noch von 8000, auf irgend etwas, was noch nicht vom OpenSimulator benutzt wird, umgestellt werden.
 #? @param keine.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
function icecastconfig() {
	log rohtext "Icecast2 von Port 8000 auf Port 8999 setzen"
	sudo sed -i 's|8000|8999|' /etc/icecast2/icecast.xml
	log rohtext "Aufrufbeispiel: $AKTUELLEIP:8999"
}

##
 #* sourcelist18.
 # Sourcelist fuer Ubuntu bionic anzeigen.
 # 
 #? @param keine.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
function sourcelist18() {
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

##
 #* sourcelist22.
 # Sourcelist fuer Ubuntu jammy anzeigen.
 # 
 #? @param keine.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
function sourcelist22() {
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

##
 #* installwordpress.
 # Installiert oder Upgradet alles was für WordPress benötigt wird.
 # 
 #? @param keine.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
function installwordpress() {
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

##
 #* installopensimulator.
 # Installiert alles fuer den OpenSimulator ausser mono.
 # 
 #? @param keine.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
function installopensimulator() {
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
    iinstall libc6-dev
	iinstall translate-shell

}

##
 #* installubuntu22.
 # Installiert alles fuer den OpenSimulator ausser mono.
 # 
 #? @param keine.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
function installubuntu22() {
	#Alles fuer den OpenSimulator ausser mono
	iinstall2 screen
	iinstall2 git
	iinstall2 nant
	iinstall2 libopenjp3d7
	iinstall2 graphicsmagick
	iinstall2 imagemagick
	iinstall2 curl
	iinstall2 php-cli
	iinstall2 php-bcmath
	iinstall2 dialog
	iinstall2 at
	iinstall2 mysqltuner
	iinstall2 php-mysql
	iinstall2 php-common
	iinstall2 php-gd
	iinstall2 php-pear
	iinstall2 php-xmlrpc
	iinstall2 php-curl
	iinstall2 php-mbstring
	iinstall2 php-gettext
	iinstall2 php-fpm php
	iinstall2 libapache2-mod-php
	iinstall2 php-xml
	iinstall2 php-imagick
	iinstall2 php-cli
	iinstall2 php-imap
	iinstall2 php-opcache
	iinstall2 php-soap
	iinstall2 php-zip
	iinstall2 php-intl
	iinstall2 php-bcmath
	iinstall2 unzip
	iinstall2 php-mail
	iinstall2 zip
	iinstall2 screen
	iinstall2 graphicsmagick
	iinstall2 git
	iinstall2 libopenjp3d7
	iinstall2 crudini
	iinstall2 iptables
	iinstall2 fail2ban
	iinstall2 apt-utils
    iinstall2 libgdiplus
    iinstall2 libc6-dev
	iinstall2 translate-shell

	if [ $insterweitert = "yes" ]; then
		iinstall2 libldns-dev
		iinstall2 libldns3
		iinstall2 libjs-jquery-ui
		iinstall2 libopenexr25
		iinstall2 libmagickcore-6.q16-6-extra
		iinstall2 libswscale-dev
		iinstall2 php-twig
		iinstall2 libavcodec58
		iinstall2 libmagickwand-6.q16-6
		iinstall2 libavutil56
		iinstall2 imagemagick-6.q16
		iinstall2 libswscale5
		iinstall2 libmagickcore-6.q16-6
		iinstall2 libavutil-dev
		iinstall2 libswresample3
		iinstall2 imagemagick-6-common
		iinstall2 libavformat58
		iinstall2 python2.7-minimal
		iinstall2 python2.7
		iinstall2 libavformat-dev
		iinstall2 libavcodec-dev
		iinstall2 libpython2.7-minimal
		iinstall2 libpython2.7-stdlib
		iinstall2 libswresample-dev
	fi
	deladvantagetools
}

##
 #* iptablesset
 # IP sperren.
 # 
 #? @param ipsperradresse.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
function iptablesset() {
	ipsperradresse=$1
	# Eine IP-Adresse für eingehende Datenpakete sperren
	iptables -A INPUT -s $ipsperradresse -j DROP

	# Eine IP-Adresse für ausgehende Datenpakete sperren
	iptables -A OUTPUT -s $ipsperradresse -j DROP

	# Alle IP-Adressen in den IPTABLES mitsamt Zeilennummern anzeigen, die momentan gesperrt sind
	iptables -L INPUT -n --line-numbers
}

##
 #* fail2banset.
 # Bannen nach fehlerhaften anmeldungsversuchen am Server.
 # 
 #? @param keine.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
function fail2banset() {
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

##
 #* ufwset.
 # ufw Ports einstellen.
 # 
 #? @param keine.
 #? @return nichts wird zurueckgegeben.
 # todo: Das ganze muss automatisch nach ports in den Konfigs suchen und diese einstellen. Es darf nicht zuviel geoeffnet werden wie hier.
##
function ufwset() {
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

##
 #* ufwport.
 # ufw Firewall Port hinzufuegen.
 # 
 #? @param keine.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
function ufwport() {
	PORTLOCK=$1
	sudo ufw allow $PORTLOCK/tcp
	sudo ufw allow $PORTLOCK/udp
}

##
 #* ufwoff.
 # ufw Firewall abschalten.
 # 
 #? @param keine.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
function ufwoff() {
	sudo ufw disable
}

##
 #* ufwblock.
 # ufw Firewall alles verbieten blocken.
 # 
 #? @param keine.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
function ufwblock() {
	sudo ufw default deny
}

##
 #* installphpmyadmin.
 # Installieren von PhpMyAdmin.
 # 
 #? @param keine.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
function installphpmyadmin() {
	#** Installieren von PhpMyAdmin
	sudo apt install phpmyadmin
}

##
 #* installfinish.
 # Zum abschluss noch einmal alles pruefen und nachinstallieren.
 # 
 #? @param keine.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
function installfinish() {
	apt update
	apt upgrade
	apt -f install
	# zuerst schauen das nichts mehr laeuft bevor man einfach rebootet
	#reboot now
}

##
 #* installationhttps22.
 # HTTPS installieren: installationhttps22 "myemail@server.com" "myworld.com".
 # 
 #? @param keine.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
function installationhttps22() {
	httpsemail=$1
	httpsdomain=$2
	#** HTTPS installieren
	sudo apt install python3-certbot-apache

	# Jetzt haben wir Certbot von Let’s Encrypt fuer Ubuntu 22.04 installiert,
	# fuehren Sie diesen Befehl aus, um Ihre Zertifikate zu erhalten.
	sudo certbot --apache --agree-tos --redirect -m "$httpsemail" -d "$httpsdomain" -d www."$httpsdomain"
}

##
 #* serverinstall22.
 # Server Installationen aufrufen.
 # 
 #? @param keine.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
function serverinstall22() {
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

##
#* Funktion: serverinstall
# 
#? Beschreibung:
# Diese Funktion überprüft, ob das Paket 'dialog' auf dem System installiert ist, um eine interaktive Installation zu ermöglichen.
# Wenn 'dialog' installiert ist, wird der Benutzer gefragt, ob er alle erforderlichen Ubuntu-Pakete installieren möchte. 
# Falls ja, werden verschiedene Installationsfunktionen aufgerufen, andernfalls wird zum Hauptmenü zurückgekehrt.
# Wenn 'dialog' nicht installiert ist, wird der Benutzer einfach nach der Installation der Ubuntu-Pakete gefragt, ohne eine grafische Oberfläche zu verwenden.
#
#? Parameter:
# Diese Funktion erwartet keine Parameter.
#
#? Rückgabewert:
# Diese Funktion gibt keinen expliziten Rückgabewert zurück.
#
#? Abhängigkeiten:
# - Die Funktion verwendet die Befehle 'dpkg-query', 'dialog', 'dialogclear', 'serverupgrade', 'installopensimulator', 'monoinstall18', 'installfinish', 'log', 'ScreenLog' und 'hauptmenu'.
#
#? Beispielaufruf:
# serverinstall
##
function serverinstall() {
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

##
	#* Funktion: installationen
	# 
	#? Beschreibung:
	# Diese Funktion listet alle unter Linux installierten Pakete auf und speichert die Liste in einer Log-Datei.
	#
	#? Parameter:
	# Diese Funktion erwartet keine Parameter.
	#
	#? Rückgabewert:
	# Diese Funktion gibt immer den Wert 0 zurück, da keine Fehlerbehandlung implementiert ist.
	#
	#? Abhängigkeiten:
	# - Die Funktion verwendet die Befehle 'log' und 'dpkg-query'.
	# - Die Funktion verwendet die Umgebungsvariablen '$STARTVERZEICHNIS', '$DATEIDATUM' und '$logfilename'.
	#
	#? Beispielaufruf:
	# installationen
##
function installationen() {
	log info "Liste aller Installierten Pakete unter Linux:"
	dpkg-query -Wf '${Package;-40}${Priority}\n' | sort -b -k2,2 -k1,1
	dpkg-query -Wf '${Package;-40}${Priority}\n' | sort -b -k2,2 -k1,1 >>"/$STARTVERZEICHNIS/$DATEIDATUM$logfilename.log"
	return 0
}

##
	#* Funktion: checkupgrade93
	# 
	#? Beschreibung:
	# Diese Funktion überprüft, ob ein OpenSimulator-Upgrade verfügbar ist und bietet die Möglichkeit an, das Upgrade durchzuführen.
	#
	#? Parameter:
	# Diese Funktion erwartet keine Parameter.
	#
	#? Rückgabewert:
	# Diese Funktion gibt keinen expliziten Rückgabewert zurück.
	#
	#? Abhängigkeiten:
	# - Die Funktion geht davon aus, dass das Arbeitsverzeichnis auf das OpenSimulator-Verzeichnis gesetzt ist.
	# - Die Funktion verwendet die Befehle 'git pull', 'log' und 'osbuildingupgrade93'.
	# - Die Funktion verwendet die Umgebungsvariable '$STARTVERZEICHNIS'.
	#
	#? Beispielaufruf:
	# checkupgrade93
##
function checkupgrade93() {
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

##
	#* Funktion: pull
	# 
	#? Beschreibung:
	# Diese Funktion führt den Befehl 'git pull' aus, um Aktualisierungen aus dem Remote-Git-Repository in das lokale Repository zu ziehen.
	#
	#? Parameter:
	# Diese Funktion erwartet keine Parameter.
	#
	#? Rückgabewert:
	# Diese Funktion gibt keinen expliziten Rückgabewert zurück.
	#
	#? Abhängigkeiten:
	# - Die Funktion verwendet den Befehl 'git pull'.
	#
	#? Beispielaufruf:
	# pull
##
function pull() {
	# Führt den Befehl 'git pull' aus, um Aktualisierungen aus dem Remote-Git-Repository zu ziehen
	git pull
}

##
	#* Funktion: osbuilding93
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
	# osbuilding93 0.9.2.2Dev-4-g5e9b3b4
	# Oder (mit dialog):
	# osbuilding93
##
function osbuilding93() {
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

	# Neue Versionsnummer: opensim-0.9.2.2Dev-4-g5e9b3b4.zip
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

##
	#* Funktion: osbuildingupgrade93
	# 
	#? Beschreibung:
	# Diese Funktion sichert den aktuellen OpenSimulator, löscht ihn, lädt einen neuen OpenSimulator vom GitHub herunter,
	# führt verschiedene Konfigurationsschritte aus und kompiliert den OpenSimulator.
	#
	#? Parameter:
	# - $1 (optional): Die Versionsnummer des neuen OpenSimulator-Branches.
	#
	#? Rückgabewert:
	# Diese Funktion gibt immer den Wert 0 zurück, da keine Fehlerbehandlung implementiert ist.
	#
	#? Abhängigkeiten:
	# - Die Funktion verwendet die Befehle 'rm', 'mv', 'log', 'opensimgitcopy93', 'cd', 'git checkout', 'setversion93', 'runprebuild.sh', 'dotnet build', 'moneycopy93', 'scriptcopy', 'osupgrade93'.
	# - Die Funktion verwendet die Umgebungsvariablen '$STARTVERZEICHNIS', '$MONEYVERZEICHNIS' und '$SETOSVERSION'.
	#
	#? Beispielaufruf:
	# osbuildingupgrade93 09052023
##
function osbuildingupgrade93() {
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

	return 0
}

##
 #* osbuilding.
 # Baut automatisch einen neuen OpenSimulator mit den eingestellten Plugins.
 # Beispiel Datei: opensim-0.9.2.2Dev-1187-gcf0b1b1.zip
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

	# Neue Versionsnummer: opensim-0.9.2.2Dev-4-g5e9b3b4.zip
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

##
 #* createuser.
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

##
 #* menucreateuser.
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

##
 #* db_friends.
 # Listet alle internen Freunde auf, aber keine hg freunde.
 # 
 #? @param username password databasename useruuid.
 #? @return "$result_mysqlrest".
 # todo: nichts.
##
function db_friends() {
	username=$1
	password=$2
	databasename=$3
	useruuid=$4

	log rohtext "Listet alle internen Freunde auf, aber keine hg freunde:"
	mysqlrest "$username" "$password" "$databasename" "SELECT Friends.PrincipalID, CONCAT(UserAccounts.FirstName, ' ', UserAccounts.LastName) AS 'Friend' FROM Friends,UserAccounts WHERE Friends.Friend = '$useruuid' AND UserAccounts.PrincipalID = Friends.PrincipalID UNION SELECT Friends.Friend, CONCAT(UserAccounts.FirstName, ' ', UserAccounts.LastName) AS 'Friend'  FROM Friends, UserAccounts WHERE Friends.PrincipalID ='$useruuid' AND UserAccounts.PrincipalID = Friends.Friend"
	echo "$result_mysqlrest"

	return 0
}

##
 #* db_online.
 # Listet Online User auf.
 # 
 #? @param "$username" "$password" "$databasename".
 #? @return "$result_mysqlrest".
 # todo: nichts.
##
function db_online() {
	username=$1
	password=$2
	databasename=$3

	log rohtext "Listet Online User auf:"
	mysqlrest "$username" "$password" "$databasename" "SELECT concat(FirstName, ' ', LastName) AS 'Online Users' FROM UserAccounts INNER JOIN GridUser ON UserAccounts.PrincipalID = GridUser.UserID WHERE GridUser.Online = 'True'"
	echo "$result_mysqlrest"

	return 0
}

##
 #* db_region.
 # Listet die Regionen aus Ihrer Datenbank auf.
 # 
 #? @param "$username" "$password" "$databasename".
 #? @return "$result_mysqlrest".
 # todo: nichts.
##
function db_region() {
	username=$1
	password=$2
	databasename=$3

	log rohtext "Listet die Regionen in Ihrer Datenbank auf:"
	mysqlrest "$username" "$password" "$databasename" "SELECT regionName as 'Regions' FROM regions"
	echo "$result_mysqlrest"

	return 0
}

##
 #* db_gridlist.
 # Gridliste der Benutzer, die schon einmal im eigenen Grid waren.
 # Aufruf: bash osmtool.sh db_gridlist databaseusername databasepassword databasename
 # 
 #? @param "$username" "$password" "$databasename".
 #? @return "$mygridliste".
 # todo: nichts.
##
function db_gridlist() {
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

##
 #* db_inv_search.
 # Inventareinträge mit einem bestimmten Namen auflisten.
 # 
 #? @param username password databasename invname.
 #? @return $result_mysqlrest.
 # todo: nichts.
##
function db_inv_search() {
	username=$1
	password=$2
	databasename=$3
    invname=$4

	log rohtext "Inventareinträge mit einem bestimmten Namen auflisten:"
	mysqlrest "$username" "$password" "$databasename" "SELECT concat(inventoryName, ' - ',  replace(inventoryID, '-', '')) AS 'Inventory', concat(assets.name, ' - ', hex(assets.id)) AS 'Asset' FROM inventoryitems LEFT JOIN assets ON replace(assetID, '-', '')=hex(assets.id) WHERE inventoryName = '$invname'"
	echo "$result_mysqlrest"

	return 0
}

##
 #* db_ungenutzteobjekte.
 # # Asset Objekte, alles anzeigen was zuletzt zwischen zwei Daten aufgerufen wurde.
 # 
 #? @param username password databasename invname.
 #? @return $result_mysqlrest.
 # todo: nichts.
##
function db_ungenutzteobjekte() {
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

##
 #* db_user_anzahl.
 # Zaehlt die Gesamtzahl der Benutzer.
 # 
 #? @param username password databasename.
 #? @return $result_mysqlrest.
 # todo: nichts.
##
function db_user_anzahl() {
	username=$1
	password=$2
	databasename=$3

	log rohtext "Zaehlt die Gesamtzahl der Benutzer:"
	mysqlrest "$username" "$password" "$databasename" "SELECT count(PrincipalID) AS 'Users' FROM UserAccounts"
	echo "$result_mysqlrest"

	return 0
}

##
 #* db_user_online.
 # Users Online?
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
##
function db_user_online() {
	username=$1
	password=$2
	databasename=$3

	log rohtext "Users Online:"
	mysqlrest "$username" "$password" "$databasename" "SELECT count(UserID) AS 'Online' FROM GridUser WHERE Online = 'True'"
	echo "$result_mysqlrest"

	return 0
}

##
 #* db_region_parzelle.
 # Zaehlt die Regionen mit Parzellen.
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
##
function db_region_parzelle() {
	username=$1
	password=$2
	databasename=$3

	log rohtext "Zaehlt die Regionen mit Parzellen:"
	mysqlrest "$username" "$password" "$databasename" "SELECT count(DISTINCT regionUUID) FROM parcels"
	echo "$result_mysqlrest"

	return 0
}

##
 #* db_region_parzelle_pakete.
 # Zaehlt die Gesamtzahl der Pakete.
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
##
function db_region_parzelle_pakete() {
	username=$1
	password=$2
	databasename=$3

	log rohtext "Zaehlt die Gesamtzahl der Pakete:"
	mysqlrest "$username" "$password" "$databasename" "SELECT count(parcelUUID) AS 'Parcels' FROM parcels"
	echo "$result_mysqlrest"

	return 0
}

##
 #* db_region_anzahl_regionsnamen.
 # Zaehlt eindeutige Regionsnamen.
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
##
function db_region_anzahl_regionsnamen() {
	username=$1
	password=$2
	databasename=$3

	log rohtext "Zaehlt eindeutige Regionsnamen:"
	mysqlrest "$username" "$password" "$databasename" "SELECT count(DISTINCT regionName) AS 'Regions' FROM regions"
	echo "$result_mysqlrest"

	return 0
}

##
 #* db_region_anzahl_regionsid.
 # Zaehlt RegionIDs.
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
##
function db_region_anzahl_regionsid() {
	username=$1
	password=$2
	databasename=$3

	log rohtext "Zaehlt RegionIDs:"
	mysqlrest "$username" "$password" "$databasename" "SELECT count(UUID) AS 'Regions' FROM regions"
	echo "$result_mysqlrest"

	return 0
}

##
 #* db_inventar_no_assets.
 # Listet alle Inventareintraege auf, die auf nicht vorhandene Assets verweisen.
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
## 
function db_inventar_no_assets() {
	username=$1
	password=$2
	databasename=$3

	log rohtext "Listet alle Inventareintraege auf, die auf nicht vorhandene Assets verweisen:"
	mysqlrest "$username" "$password" "$databasename" "SELECT inventoryname, inventoryID, assetID FROM inventoryitems WHERE replace(assetID, '-', '') NOT IN (SELECT hex(id) FROM assets)"
	echo "$result_mysqlrest"

	return 0
}

# Neu 19.11.2022 Ende

##
 #* db_anzeigen.
 # Alle Datenbanken anzeigen, listet alle erstellten Datenbanken auf.
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
##
function db_anzeigen() {
	username=$1
	password=$2
	databasename=$3

	log text "PRINT DATABASE: Alle Datenbanken anzeigen."
	mysqlrest "$username" "$password" "$databasename" "show databases"
	log rohtext "$result_mysqlrest"

	return 0
}
##
 #* db_anzeigen_dialog.
 # Alle Datenbanken anzeigen, listet alle erstellten Datenbanken auf.
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
##
function db_anzeigen_dialog() {
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

##
 #* db_tables.
 # Tabellenabfrage, listet alle Tabellen in einer Datenbank auf.
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
##
function db_tables() {
	username=$1
	password=$2
	databasename=$3

	log text "PRINT DATABASE: tabellenabfrage, listet alle Tabellen in einer Datenbank auf."
	mysqlrest "$username" "$password" "$databasename" "SHOW TABLES FROM $databasename"
	log rohtext "$result_mysqlrest"

	return 0
}

##
 #* db_tables_dialog.
 # Tabellenabfrage, listet alle Tabellen in einer Datenbank auf.
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* db_benutzer_anzeigen.
 # Alle angelegten Benutzer von mySQL anzeigen.
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* db_regions.
 # Alle Regionen listen (Dies geht nur im Grid (Grid Datenbank) oder Standalone Modus).
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* db_regionsuri.
 #  Region URI pruefen sortiert nach URI (Dies geht nur im Grid (Grid Datenbank) oder Standalone Modus).
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* db_regionsport.
 # Ports pruefen sortiert nach Ports (Dies geht nur im Grid (Grid Datenbank) oder Standalone Modus).
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* create_db.
 # erstellt eine neue Datenbank.
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* create_db_user.
 # Operation CREATE USER failed - Fehler.
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* delete_db.
 # loescht eine Datenbank.
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* db_empty.
 # loescht eine Datenbank und erstellt diese anschliessend neu. Das ist Datenbank leeren auf die schnelle Art.
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #*allrepair_db.
 # CHECK – REPAIR – ANALYZE – OPTIMIZE, alle Datenbanken.
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* mysql_neustart.
 # startet mySQL neu.
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
##
function mysql_neustart() {
	log text "MYSQL RESTART: MySQL Neu starten."

	service mysql stop
	sleep 15
	service mysql start
	log text "MYSQL RESTART: Fertig."

	return 0
}

#**************************************************************************
# Externe Zugriffe auf MySQL-Server erlauben

# Um den Netzwerkzugriff auf eine MySQL-Datenbank zu ermöglichen, 
# passen Sie die Konfiguration des MySQL-Servers an und starten diesen erneut. 
# Ändern der Konfiguration in der Datei /etc/my.cnf.

# Melden Sie sich dazu als root auf Ihrem Server an und öffnen Sie die Datei /etc/my.cnf, zum Beispiel mit einem Editor:
#     /etc/my.cnf

# Suchen Sie die Zeile bind-address = 127.0.0.1.

# Da diese die MySQL-Datenbank anweist, eingehende Netzwerkverbindungen nur vom Loopback-Interface anzunehmen, 
# deaktivieren Sie diese mit einem Kommentarzeichen ('#'):
#      #bind-address = 127.0.0.1 

# Hinweis

# In manchen Linux-Distributionen ist die o.g. Zeile nicht vorhanden. Hier lautet die Zeile, die auskommentiert wird, wie folgt:

# 	#Skip Networking 

# Starten Sie den Datenbankserver neu, damit sich Ihre Konfigurationsänderung auswirkt:
#     /etc/init.d/mysql restart
# Der MySQL-Server nimmt jetzt externe Verbindungen über den Standardport für MySQL (3306) an.

# Datenbankzugriff auf bestimmte IP-Adresse einschränken

# Loggen Sie sich mit folgendem Kommando in Ihre MySQL-Shell auf Ihrem Server ein, halten Sie Ihr Root-Benutzer- bzw. Admin-Passwort bereit:
#     mysql -u admin -p

# Geben Sie folgenden Befehl ein:
#     use mysql; 

# Schränken Sie mit folgenden Befehlen den Zugriff auf Ihre Datenbank auf eine bestimmte IP-Adresse ein, 
# ersetzen Sie dabei die Beispielnamen und Ip-Adresse durch die gewünschten Daten. 
# Achten Sie außerdem darauf, dass Sie nach jedem ; die ENTER-Taste drücken:
#     mysql> update db set Host='123.123.123.123' where Db='yourdatabasename';
#     mysql> update user set Host='123.123.123.123' where user='yourdatabaseUsername'; 

# Verlassen Sie die MySQl-Shell mit dem Befehl Exit.
#**************************************************************************

##
 #* db_backup.
 # sichert eine einzelne Datenbank.
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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
##
 #* db_compress_backup.
 # sichert eine einzelne Datenbank mit gz komprimierung.
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* db_backuptabellen.
 # Eine Datenbanken Tabellenweise speichern.
 # bash osmtool.sh db_backuptabellen username password databasename
 # 
 #? @param db_backuptabellen DB_Benutzername DB_Passwort Datenbankname.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* db_backuptabelle_noassets.
 # Eine Datenbanken Tabellenweise ohne die Tabelle assets speichern.
 # bash osmtool.sh db_backuptabellen username password databasename
 # 
 #? @param db_backuptabellen DB_Benutzername DB_Passwort Datenbankname.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* db_backuptabellentypen.
 # Aus dem mit mysqldump generierten Backup die Asset Datenbank Tabelle geteilt in Typen speichern.
 # 
 #? @param "$username" "$password" "$databasename".
 #? @return name was wird zurueckgegeben.
 # todo: Das gleiche mit der Asset Tabelle machen. 
 # todo: Direkt die Asset bereiche vom Server holen.
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

##
 #* db_restorebackuptabellen.
 # Backup Test, eine Datenbanken Tabellenweise wiederherstellen.
 # db_restorebackuptabellen DB_Benutzername DB_Passwort AlterDatenbankname NeuerDatenbankname
 # Die Tabellenweise gesicherte Datenbank in einer neuen Datenbank zusammensetzen.
 # bash osmtool.sh db_restorebackuptabellen username password databasename newdatabasename
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
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
##
 #* db_restorebackuptabellen2test.
 # Backup Test, eine Datenbanken Tabellenweise wiederherstellen.
 # db_restorebackuptabellen DB_Benutzername DB_Passwort AlterDatenbankname NeuerDatenbankname
 # Die Tabellenweise gesicherte Datenbank in einer neuen Datenbank zusammensetzen.
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
##
function db_restorebackuptabellen2test() {
	username=$1
	password=$2
	databasename=$3
	newdatabasename=$4

	cd /$STARTVERZEICHNIS/backup/"$databasename" || exit

	tabellenname=()
	while IFS= read -r tabellenname; do
		sleep 1		
        for file in foo*; do
            case $(file "$file") in
                *ASCII*) /"$STARTVERZEICHNIS"/backup/"$databasename"/"$tabellenname".sql | mysql >MYSQL_PWD="$password" -u"$username" "$newdatabasename" ;;
                *gzip*) gunzip /"$STARTVERZEICHNIS"/backup/"$databasename"/"$tabellenname".sql.gz | mysql >MYSQL_PWD="$password" -u"$username" "$newdatabasename" ;;          
                *zip*) unzip -p /"$STARTVERZEICHNIS"/backup/"$databasename"/"$tabellenname".sql.zip | mysql >MYSQL_PWD="$password" -u"$username" "$newdatabasename" ;;          
                *7z*) 7z e /"$STARTVERZEICHNIS"/backup/"$databasename"/"$tabellenname".sql.7z | mysql >MYSQL_PWD="$password" -u"$username" "$newdatabasename" ;;
                *rar*) unrar e /"$STARTVERZEICHNIS"/backup/"$databasename"/"$tabellenname".sql.rar | mysql >MYSQL_PWD="$password" -u"$username" "$newdatabasename" ;;
                *tar.gz*) tar -xf /"$STARTVERZEICHNIS"/backup/"$databasename"/"$tabellenname".sql.tar.gz | mysql >MYSQL_PWD="$password" -u"$username" "$newdatabasename" ;;
                *tar.bz2*) tar -xjf /"$STARTVERZEICHNIS"/backup/"$databasename"/"$tabellenname".sql.tar.bz2 | mysql >MYSQL_PWD="$password" -u"$username" "$newdatabasename" ;;
                *tar.xz*) tar -xJf /"$STARTVERZEICHNIS"/backup/"$databasename"/"$tabellenname".sql.tar.xz | mysql >MYSQL_PWD="$password" -u"$username" "$newdatabasename" ;;
                *bz2*) bunzip2 /"$STARTVERZEICHNIS"/backup/"$databasename"/"$tabellenname".sql.bz2 | mysql >MYSQL_PWD="$password" -u"$username" "$newdatabasename" ;;
                *xz*) unxz /"$STARTVERZEICHNIS"/backup/"$databasename"/"$tabellenname".sql.xz | mysql >MYSQL_PWD="$password" -u"$username" "$newdatabasename" ;;
            esac
        done
		log info "Datenbank Tabelle: $newdatabasename - $tabellenname widerhergestellt."
	done </$STARTVERZEICHNIS/backup/"$databasename"/liste.txt

	return 0
}

##
 #* db_create.
 # erstellt eine neue Datenbank. db_create "username" "password" "databasename"
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
##
function db_create() {
	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then

		# Einstellungen
		boxbacktitel="opensimMULTITOOL"
		boxtitel="opensimMULTITOOL Eingabe"
		formtitle="Neue Datenbank erstellen"
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

##
 #* db_dbuser.
 # listet alle erstellten Datenbankbenutzer auf.
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
##
function db_dbuser() {
	username=$1
	password=$2

	log text "PRINT DATABASE: Alle Datenbankbenutzer anzeigen."
	result_mysqlrest=$(echo "select User from mysql.user;" | MYSQL_PWD=$password mysql -u"$username" -N) 2>/dev/null
	log rohtext "$result_mysqlrest"

	return 0
}

##
 #* db_dbuserrechte.
 # listet alle erstellten Benutzerrechte auf. db_dbuserrechte root 123456 testuser.
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* db_deldbuser.
 # loescht einen Datenbankbenutzer. db_deldbuser root 123456 testuser.
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* db_create_new_dbuser.
 # db_create_new_dbuser root password NEUERNAME NEUESPASSWORT.
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* createdatabase
 # Andere Art Datenbanken und Benutzer anzulegen.
 # createdatabase DBNAME DBUSER DBPASSWD
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* createdbuser
 # Andere Art Datenbanken und Benutzer anzulegen.
 # createdbuser ROOTUSER ROOTPASSWD NEWDBUSER NEWDBPASSWD
 # ROOTPASSWD ist optional.
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* db_delete.
 # loescht eine Datenbank komplett.
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* tabellenabfrage.
 # tabellenabfrage, listet alle Tabellen in einer Datenbank auf.
 # Es geht hier um die machbarkeit und nicht den Sinn.
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* regionsabfrage.
 # Alle Regionen listen (Dies geht nur im Grid (Grid Datenbank) oder Standalone Modus).
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* regionsuri.
 # Region URI pruefen sortiert nach URI (Dies geht nur im Grid (Grid Datenbank) oder Standalone Modus).
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* regionsport.
 # Ports pruefen sortiert nach Ports (Dies geht nur im Grid (Grid Datenbank) oder Standalone Modus).
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* setpartner.
 # Partner setzen bei einer Person. Also bei beiden Partnern muss dies gemacht werden.
 # osmtool.sh setpartner Datenbankbenutzer Datenbankpasswort Robustdatenbank "AvatarUUID" "PartnerUUID"
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* db_setpartner.
 #  Partner setzen bei einer Person. Also bei beiden Partnern muss dies gemacht werden.
 # osmtool.sh setpartner Datenbankbenutzer Datenbankpasswort Robustdatenbank "AvatarUUID" "PartnerUUID"
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* db_deletepartner.
 # Partner loeschen bei einer Person. Also bei beiden Partnern muss dies gemacht werden.
 # osmtool.sh setpartner Datenbankbenutzer Datenbankpasswort Robustdatenbank "AvatarUUID" "PartnerUUID"
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* db_all_user.
 # #Daten von allen Benutzern anzeigen: db_all_user "username" "password" "databasename".
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #*db_all_user_dialog.
 # Eine tabellenabfrage, Daten von allen Benutzern anzeigen.
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* db_all_uuid.
 # UUID von allen Benutzern anzeigen: db_all_uuid "username" "password" "databasename".
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* db_all_uuid_dialog.
 # UUID von allen Benutzern anzeigen.
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* db_all_name.
 # Alle Benutzernamen des Grids anzeigen.
 # db_all_name "username" "password" "databasename".
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* db_all_name_dialog.
 #  db_all_name_dialog "username" "password" "databasename".
 #  Alle Benutzernamen des Grids anzeigen.
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* db_user_data.
 # Daten von einem Benutzer anzeigen: db_user_data "username" "password" "databasename" "firstname" "lastname".
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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
##
 #* db_user_data_dialog.
 # Daten von einem Benutzer anzeigen: db_user_data_dialog "username" "password" "databasename" "firstname" "lastname".
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* db_user_infos.
 # UUID Vor- und Nachname sowie E-Mail Adresse von einem Benutzer anzeigen: 
 # db_user_infos "username" "password" "databasename" "firstname" "lastname".
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* db_user_infos_dialog.
 # UUID Vor- und Nachname sowie E-Mail Adresse von einem Benutzer anzeigen: 
 # db_user_infos "username" "password" "databasename" "firstname" "lastname".
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* db_user_uuid.
 # UUID von einem Benutzer anzeigen: db_user_uuid.
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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
##
 #* db_user_uuid_dialog.
 # UUID von einem Benutzer anzeigen: db_user_uuid_dialog.
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* db_foldertyp_user.
 # Alles vom inventoryfolders type des User anzeigen: db_foldertyp_user "username" "password" "databasename" "firstname" "lastname" "foldertyp".
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* db_all_userfailed.
 # Alles vom inventoryfolders was type -1 des User: db_all_userfailed "username" "password" "databasename" "firstname" "lastname".
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #*db_userdate.
 # Zeige Erstellungsdatum eines Users an: db_userdate "username" "password" "databasename" "firstname" "lastname".
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* db_false_email.
 # Finde offensichtlich falsche E-Mail Adressen der User: db_false_email "username" "password" "databasename".
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
## Finde offensichtlich falsche E-Mail Adressen der User: db_false_email "username" "password" "databasename"
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

##
 #* set_empty_user.
 # Einen User in der Datenbank erstellen und das ohne Inventar (Gut fuer Picker): 
 # set_empty_user "username" "password" "databasename" "firstname" "lastname" "email".
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* db_email_setincorrectuseroff.
 # Finde alle offensichtlich falschen E-Mail Adressen der Grid User und
 # deaktiviere dauerhaft dessen Account:
 # bash osmtool.sh db_email_setincorrectuseroff "GRIDdatabaseusername" "GRIDdatabasepassword" "GRIDdatabasename"
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* db_email_setincorrectuseroff_dialog.
 # Finde alle offensichtlich falschen E-Mail Adressen der Grid User und
 # deaktiviere dauerhaft dessen Account:
 # bash osmtool.sh db_email_setincorrectuseroff "GRIDdatabaseusername" "GRIDdatabasepassword" "GRIDdatabasename"
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* db_setuserofline.
 # Grid User dauerhaft abschalten:
 # bash osmtool.sh db_setuserofline "GRIDdatabaseusername" "GRIDdatabasepassword" "GRIDdatabasename" "firstname" "lastname"
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* db_setuserofline_dialog.
 # Grid User dauerhaft abschalten:
 # bash osmtool.sh db_setuserofline_dialog "GRIDdatabaseusername" "GRIDdatabasepassword" "GRIDdatabasename" "firstname" "lastname"
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* db_setuseronline.
 # Grid User dauerhaft aktivieren:
 # bash osmtool.sh db_setuseronline "GRIDdatabaseusername" "GRIDdatabasepassword" "GRIDdatabasename" "firstname" "lastname"
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* db_setuseronline_dialog.
 # Grid User dauerhaft aktivieren:
 # bash osmtool.sh db_setuseronline "GRIDdatabaseusername" "GRIDdatabasepassword" "GRIDdatabasename" "firstname" "lastname"
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* db_tabellencopy.
 # Datenbank Tabelle aus einer anderen Datenbank kopieren.
 # bash osmtool.sh db_tabellencopy von_Datenbankname nach_Datenbankname Tabellenname Benutzername Passwort
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* db_tabellencopy_extern.
 # Datenbank Tabelle aus einer anderen Datenbank kopieren.
 # bash osmtool.sh db_tabellencopy von_Datenbankname nach_Datenbankname Tabellenname Benutzername Passwort
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* default_master_connection.
 # Eine erklaerung, wie man Funktionen nach den Programierrichtlinien richtig kommentiert.
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
## default_master_connection "$2" "$3"
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

##
 #* connection_name.
 # connection_name "$2" "$3".
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
## connection_name "$2" "$3"
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

##
 #* MASTER_USER.
 # MASTER_USER "$2" "$3".
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #*MASTER_PASSWORD.
 # MASTER_PASSWORD "$2" "$3"
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* MASTER_HOST.
 # MASTER_HOST "$2" "$3" "$4"
 # CHANGE MASTER TO ist nützlich zum Einrichten eines Replikats, 
 # wenn Sie über den Snapshot der Quelle verfügen und die Binärprotokollkoordinaten 
 # der Quelle entsprechend dem Zeitpunkt des Snapshots aufgezeichnet haben.
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #*MASTER_PORT.
 # MASTER_PORT "$2" "$3" "$4" "$5"
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* MASTER_CONNECT_RETRY.
 # MASTER_CONNECT_RETRY "$2" "$3" "$4"
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* MASTER_SSL.
 # MASTER_SSL "$2" "$3"
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* MASTER_SSL_CA.
 # MASTER_SSL_CA "$2" "$3".
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #*  MASTER_SSL_CAPATH.
 # MASTER_SSL_CAPATH "$2" "$3".
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* MASTER_SSL_CERT.
 # MASTER_SSL_CERT "$2" "$3".
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* MASTER_SSL_CRL.
 # MASTER_SSL_CRL "$2" "$3".
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* MASTER_SSL_CRLPATH.
 # MASTER_SSL_CRLPATH "$2" "$3".
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* MASTER_SSL_KEY.
 # MASTER_SSL_KEY "$2" "$3".
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* MASTER_SSL_CIPHER.
 # MASTER_SSL_CIPHER "$2" "$3".
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* MASTER_SSL_VERIFY_SERVER_CERT.
 # MASTER_SSL_VERIFY_SERVER_CERT "$2" "$3".
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* MASTER_LOG_FILE.
 # MASTER_LOG_FILE "$2" "$3" "$4" "$5".
 # CHANGE MASTER TO bewirkt, dass die vorherigen Werte für MASTER_HOST, MASTER_PORT, MASTER_LOG_FILE und MASTER_LOG_POS zusammen 
 # mit anderen Informationen über den Status des Replikats vor der Ausführung in das Fehlerprotokoll geschrieben werden.
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* MASTER_LOG_POS.
 # MASTER_LOG_POS "$2" "$3" "$4" "$5".
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* RELAY_LOG_FILE.
 # RELAY_LOG_FILE "$2" "$3" "$4" "$5".
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* RELAY_LOG_POS.
 # RELAY_LOG_POS "$2" "$3" "$4" "$5".
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* MASTER_USE_GTID.
 # MASTER_USE_GTID "$2" "$3".
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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
##
 #* MASTER_USE_GTID2.
 # MASTER_USE_GTID2 "$2" "$3" "$4".
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
## 
function MASTER_USE_GTID2() {
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

##
 #* IGNORE_SERVER_IDS.
 # IGNORE_SERVER_IDS "$2" "$3" "$4".
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

# Die Begriffe „Master“ und „Slave“ wurden in der Vergangenheit bei der Replikation verwendet, 
# aber die Begriffe „ primary“ und „replica“ werden jetzt bevorzugt. 
# Die alten Begriffe werden immer noch in Teilen der Dokumentation und in MariaDB-Befehlen verwendet, 
# obwohl MariaDB 10.5 mit dem Umbenennungsprozess begonnen hat. Das Dokumentationsverfahren läuft.

# MASTER_BIND = 'Schnittstellenname'
#   | MASTER_HOST = 'host_name'
#   | MASTER_USER = 'Benutzername'
#   | MASTER_PASSWORD = 'Passwort'
#   | MASTER_PORT = port_num
#   | MASTER_CONNECT_RETRY = Intervall
#   | MASTER_HEARTBEAT_PERIOD = Intervall
#   | MASTER_LOG_FILE = 'master_log_name'
#   | MASTER_LOG_POS = master_log_pos
#   | RELAY_LOG_FILE = 'relay_log_name'
#   | RELAY_LOG_POS = relay_log_pos
#   | MASTER_DELAY = Intervall
#   | MASTER_SSL = {0|1}
#   | MASTER_SSL_CA = 'ca_file_name'
#   | MASTER_SSL_CAPATH = 'ca_directory_name'
#   | MASTER_SSL_CERT = 'cert_file_name'
#   | MASTER_SSL_CRL = 'crl_file_name'
#   | MASTER_SSL_CRLPATH = 'crl_directory_name'
#   | MASTER_SSL_KEY = 'key_file_name'
#   | MASTER_SSL_CIPHER = 'cipher_list'
#   | MASTER_SSL_VERIFY_SERVER_CERT = {0|1}
#   | MASTER_USE_GTID = {aktuelle_pos|slave_pos|nein}
#   | MASTER_DEMOTE_TO_SLAVE = bool
#   | IGNORE_SERVER_IDS = (server_id_list)
#   | DO_DOMAIN_IDS = ([N,..])
#   | IGNORE_DOMAIN_IDS = ([N,..])

##
 #* DO_DOMAIN_IDS.
 # DO_DOMAIN_IDS "$2" "$3" "$4".
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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
##
 #* DO_DOMAIN_IDS2.
 # DO_DOMAIN_IDS2 "$2" "$3".
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
## 
function DO_DOMAIN_IDS2() {
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

##
 #* IGNORE_DOMAIN_IDS.
 # IGNORE_DOMAIN_IDS "$2" "$3" "$4".
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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
##
 #* IGNORE_DOMAIN_IDS2.
 # IGNORE_DOMAIN_IDS2 "$2" "$3".
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
## 
function IGNORE_DOMAIN_IDS2() {
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

##
 #* MASTER_DELAY.
 # MASTER_DELAY "$2" "$3" "$4".
 # Use the MASTER_DELAY option for CHANGE MASTER TO to set the delay to N seconds.
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* Replica_Backup.
 # Creating a Replica from a Backup "$2" "$3" "$4" "$5".
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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
##
 #* Replica_Backup2.
 # Creating a Replica from a Backup2 "$2" "$3" "$4".
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
## 
function Replica_Backup2() {
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
##
 #* ReplikatKoordinaten.
 # Dies aendert die Koordinaten des primaeren und des primaeren Binaerlogs "$2" "$3" "$4" "$5" "$6" "$7" "$8".
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* db_tablesplitt.
 # Alle Tabellen aus einer SQL Datensicherung in ein gleichnahmigen Verzeichniss extrahieren.
 # db_tablesplitt /Pfad/SQL_Datei.sql
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* db_tablextract.
 # Eine einzelne Tabelle aus einem SQL Datenbank Backup extrahieren.
 # db_tablextract /Pfad/SQL_Datei.sql Tabellenname
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* db_tablextract_regex.
 # Extrahiere Tabelle aus SQL Datenbank Backup unter zuhilfenahme von regex.
 # db_tablextract_regex DUMP-FILE-NAME -S TABLE-NAME-REGEXP Extrahiert
 # Tabellen aus der sql Datei mit dem angegebenen regulaeren Ausdruck.
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* conf_write.
 #  Konfiguration schreiben ersatz fuer alle UNGETESTETEN ini Funktionen.
 # ./osmtool.sh conf_write Einstellung NeuerParameter Verzeichnis Dateiname
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* conf_read.
 # Ganze Zeile aus der Konfigurationsdatei anzeigen.
 # ./osmtool.sh conf_read Einstellungsbereich Verzeichnis Dateiname
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
##  
function conf_read() {
	CONF_SEARCH=$1
	CONF_PFAD=$2
	CONF_DATEINAME=$3
	sed -n -e '/'"$CONF_SEARCH"'/p' /"$CONF_PFAD"/"$CONF_DATEINAME"
	log info "Einstellung $CONF_SEARCH suchen in Datei /$CONF_PFAD/$CONF_DATEINAME"
	return 0
}

##
 #* conf_delete.
 # Ganze Zeile aus der Konfigurationsdatei loeschen.
 # ./osmtool.sh conf_delete Einstellungsbereich Verzeichnis Dateiname
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
##  
function conf_delete() {
	CONF_SEARCH=$1
	CONF_PFAD=$2
	CONF_DATEINAME=$3
	sed -i 's/'"$CONF_SEARCH"' =.*$/''/' /"$CONF_PFAD"/"$CONF_DATEINAME"
	log info "Zeile $CONF_SEARCH geloescht in Datei /$CONF_PFAD/$CONF_DATEINAME"
	return 0
}

##
 #* ramspeicher.
 # Den echten RAM Speicher auslesen.
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* mysqleinstellen.
 # Ermitteln wieviel RAM Speicher vorhanden ist und anschliessend mySQL Einstellen.
 # Einstellungen sind in der my.cnf nicht moeglich es muss in die /etc/mysql/mysql.conf.d/mysqld.cnf
 # Hier wird nicht geprueft ob die Einstellungen schon vorhanden sind sondern nur angehaengt.
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* newregionini.
 # newregionini - eine neue Regionsdatei schreiben.
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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


##
 #*constconfig.
 # constconfig, const schreiben.
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* regionconfig.
 # Region Konfigurationen schreiben
 # regionconfig REGIONSNAME STARTLOCATION SIZE INTERNALPORT REGIONSINI
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* flotsamconfig.
 # FlotsamCache Konfigurationen schreiben
 # FlotsamCache.ini - flotsamconfig FLOTSAMCACHEINI
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* osslEnableconfig.
 # Konfigurationen schreiben
 # osslEnable.ini.example
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* moneyconfig.
 # moneyconfig DATABASE USERNAME PASSWORD MONEYINI.
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* osconfigstruktur.
 # Legt die Verzeichnisstruktur fuer OpenSim an. # Aufruf: osmtool.sh osstruktur ersteSIM letzteSIM
 # Beispiel: ./osmtool.sh osstruktur 1 10 - erstellt ein Grid Verzeichnis fuer 10 Simulatoren inklusive der $SIMDATEI.
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* configabfrage.
 # Die Konfigurationsabfrage füt die OpenSim Konfigurationen.
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* firstinstallation.
 # Nachfolgende 3 Funktionen müssen noch getestet werden.
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* createmasteravatar.
 # Einen Master Avatar erstellen.
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
##
function createmasteravatar() {
	# Master Avatar erstellen.
	bash osmtool.sh rostart
	bash osmtool.sh oscommand robust Welcome "create user $FIRSTNAMEMASTER $LASTNAMEMASTER $PASSWDNAMEMASTER $EMAILNAMEMASTER $UUIDNAMEMASTER $MODELNAMEMASTER"
}

##
 #* createregionavatar.
 # Besitzerrechte und estate eintragen.
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

#**************************************************************************
#* Build Funktionen Funktionsgruppe
#**************************************************************************

##
 #* compilieren.
 # Kompilieren des OpenSimulator.
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

		# AOT Aktiveren oder Deaktivieren.
		if [[ $SETAOTON = "yes" ]]; then
			oscompiaot
		else
			oscompi
		fi

	else
		log error "OpenSim Verzeichnis zum Kompilieren existiert nicht"
	fi
	return 0
}

##
 #* osgridcopy.
 # Automatisches kopieren des opensimulator aus dem verzeichnis opensim.
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* osupgrade93.
 # Automatisches upgrade des opensimulator aus dem verzeichnis opensim.
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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
	echo " $Datum " >/$STARTVERZEICHNIS/opensim/bin/'.version'
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

##
 #* osupgrade.
 # Automatisches upgrade des opensimulator aus dem verzeichnis opensim.
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* osdowngrade.
 #  Automatisches downgrade des opensimulator aus dem verzeichnis opensim.
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
## 
function osdowngrade() {
	log text " *****************************"
	log text " !!!      BEI FEHLER      !!! "
	log text " !!! ABBRUCH MIT STRG + C !!! "
	log text " *****************************"

	log info "Das Grid wird jetzt zurückgesetzt, auf die vorherige Version."
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

##
 #* oszipupgrade.
 # Automatisches upgrade des opensimulator aus einer opensim zip Datei.
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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
	unzip opensim-0.9.2.2."$VERSIONSNUMMER".zip

	log line

	log info "Neuen OpenSimulator umbenennen"
	mv /"$STARTVERZEICHNIS"/opensim-0.9.2.2."$VERSIONSNUMMER"/ /"$STARTVERZEICHNIS"/opensim/

	log line

	osupgrade
	return 0
}

#**************************************************************************
#* Automatische Konfigurationen Prototype Funktionsgruppe
#**************************************************************************

##
 #* ConfigSet.
 # Reduziert die Konfigurationsdateien auf ein uebersichtliches Mass.
 # Aufruf: ./osmtool.sh AutoInstall
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* AutoInstall.
 # Grundinstallation ihreres Servers.
 # Aufruf: ./osmtool.sh AutoInstall
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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
	if [ "$ubuntuCodename" = "Bionic" ]; then MYSERVER="Ubuntu 18 Bionic"; fi

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
        elif [ "$ubuntuCodename" = "Bionic" ]; then
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

##
 #* osslEnableConfig.
 # Alle Skript Rechte an Grid Betreiber.
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
##
function osslEnableConfig() {
    # Abfrage des Benutzers.
    echo "Alle Skript Rechte an Grid Betreiber [$BenutzerUUID]: "; read -r Rechte
    # Auswertung der Eingaben.
    if test -z "$Rechte"; then Rechte="$BenutzerUUID"; fi

    osslEnableConfigSet "$Rechte"
}

##
 #* osslEnableConfigSet.
 # Konfiguration der osslEnable.ini.
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

#**************************************************************************
#* Hilfen und Info Funktionsgruppe
#**************************************************************************

##
 #* show_info.
 # Funktion zum Anzeigen von Informationen der Auswahl.
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
## 
function show_info() {
	dialog --title "$1" \
		--no-collapse \
		--msgbox "$info" 0 0
}

##
 #* systeminformation.
 # Systeminformationen anzeigen.
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* info.
 # Informationen auf den Bildschirm ausgeben.
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* infodialog.
 # Informationen auf den Bildschirm ausgeben.
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* kalender.
 # Einfach nur ein Kalender.
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* robustbackup.
 # Grid Datenbank sichern.(Kalender) in bearbeitung.
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* backupdatum.
 # Grid Datenbank sichern.(Datum auswerten) in bearbeitung.
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* senddata.
 # Daten zu einem neuen Server senden #** Ungetestet #**
 # senddata USERNAMEN SENDEVERZEICHNIS SERVERADRESS 
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
##  
function senddata() {
	USERNAMEN=$1
	SENDEVERZEICHNIS=$2	
	SERVERADRESS=$3
	
	# Beispiel:
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

##
 #* fortschritsanzeige.
 # test fuer eine Fortschrittsanzeige.
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* menuinfo.
 #  Informationen im dialog ausgeben.
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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
##
 #* menukonsolenhilfe.
 # Konsolenhilfe auf dem Bildschirm anzeigen.
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* dotnetinfo.
 # dotnetinfo .NET und CSharp Informationen.
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
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

##
 #* dbhilfe.
 # Datenbankhilfe auf dem Bildschirm anzeigen.
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
##  
function dbhilfe() {
	echo "$(tput setab 1)mySQL - mariaDB Befehle ACHTUNG! Sie muessen hier fuer die Grundlagen von SQL beherschen. $(tput sgr 0)"
	echo "DO_DOMAIN_IDS	- $(tput setab 5)username password ids$(tput sgr 0) – CHANGE MASTER TO DO DOMAIN IDS."
	echo "DO_DOMAIN_IDS2	- $(tput setab 5)username password$(tput sgr 0) – CHANGE MASTER TO DO DOMAIN IDS = ()."
	echo "IGNORE_DOMAIN_IDS	- $(tput setab 5)username password ids$(tput sgr 0) – CHANGE MASTER TO IGNORE DOMAIN IDS."
	echo "IGNORE_DOMAIN_IDS2	- $(tput setab 5)username password$(tput sgr 0) – CHANGE MASTER TO IGNORE DOMAIN IDS = ()."
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
	echo "MASTER_USE_GTID2	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "RELAY_LOG_FILE	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "RELAY_LOG_POS	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "Replica_Backup	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
	echo "Replica_Backup2	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."	
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

##
 #* hilfe.
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
	echo "iinstall2	- $(tput setab 5)Parameter$(tput sgr 0) – Informationen-Erklaerung."
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

##
 #* hilfemenudirektaufrufe.
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

##
 #* konsolenhilfe.
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

##
 #* commandhelp.
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
##
 #* MoneyServerCommands.
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

##
 #* OpenSimCommands.
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

##
 #* RobustCommands.
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

##
 #* all.
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
}

#**************************************************************************
#* Menu Menue Funktionsgruppe
#**************************************************************************

##
 #* menutrans
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

##
 #* hauptmenu.
 # Startmenue.
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
##  hauptmenu
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
		antwort=$?
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

		if [[ $antwort = 2 ]]; then hilfemenu; fi
		if [[ $antwort = 1 ]]; then exit; fi
	else
		# wenn dialog nicht installiert ist die Hilfe anzeigen.
		hilfe
	fi
}

##
 #* hilfemenu.
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
	OpenSimCommands=$(menutrans "OpenSimCommands")
	MoneyServerCommands=$(menutrans "MoneyServerCommands")
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
			"$Konfigurationlesen" ""
			"--------------------------" ""
			"$Passwortgenerator" ""
			"$Kalender" ""
			"--------------------------" ""
			"$Hauptmenu" "")

		hauswahl=$(dialog --clear \
			--backtitle "$BACKTITLE" \
			--title "$TITLE" \
			--help-button --defaultno \
			--menu "$MENU" \
			$HEIGHT $WIDTH $CHOICE_HEIGHT \
			"${OPTIONS[@]}" \
			2>&1 >/dev/tty) # 3>&1 1>&2 2>&3

		antwort=$?
		#dialogclear
		dialog --clear
		ScreenLog

		if [[ $hauswahl = "$Hilfe" ]]; then hilfe; fi
		if [[ $hauswahl = "$Konsolenhilfe" ]]; then menukonsolenhilfe; fi # Test menukonsolenhilfe
		if [[ $hauswahl = "$Kommandohilfe" ]]; then commandhelp; fi

		if [[ $hauswahl = "$RobustCommands" ]]; then RobustCommands; fi
		if [[ $hauswahl = "$OpenSimCommands" ]]; then OpenSimCommands; fi
		if [[ $hauswahl = "$MoneyServerCommands" ]]; then MoneyServerCommands; fi

		if [[ $hauswahl = "$Konfigurationlesen" ]]; then menuoswriteconfig; fi

		if [[ $hauswahl = "$Passwortgenerator" ]]; then passwdgenerator; fi
		if [[ $hauswahl = "$Kalender" ]]; then kalender; fi

		if [[ $hauswahl = "$Hauptmenu" ]]; then hauptmenu; fi
		if [[ $antwort = 1 ]]; then hauptmenu; fi
	else
		# wenn dialog nicht installiert ist die Hilfe anzeigen.
		hilfe
	fi
}

##
 #* funktionenmenu.
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

		fauswahl=$(dialog --clear \
			--backtitle "$BACKTITLE" \
			--title "$TITLE" \
			--help-button --defaultno \
			--menu "$MENU" \
			$HEIGHT $WIDTH $CHOICE_HEIGHT \
			"${OPTIONS[@]}" \
			2>&1 >/dev/tty) # 3>&1 1>&2 2>&3

		antwort=$?
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

		if [[ $antwort = 2 ]]; then hilfemenu; fi
		if [[ $antwort = 1 ]]; then exit; fi
	else
		# wenn dialog nicht installiert ist die Hilfe anzeigen.
		hilfe
	fi
}

##
 #* dateimenu.
 # Menue fuer Dateifunktionen.
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
##  dateimenu
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

		dauswahl=$(dialog --clear \
			--backtitle "$BACKTITLE" \
			--title "$TITLE" \
			--help-button --defaultno \
			--menu "$MENU" \
			$HEIGHT $WIDTH $CHOICE_HEIGHT \
			"${OPTIONS[@]}" \
			2>&1 >/dev/tty) # 3>&1 1>&2 2>&3

		antwort=$?
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

		if [[ $antwort = 2 ]]; then hilfemenu; fi
		if [[ $antwort = 1 ]]; then exit; fi
	else
		# wenn dialog nicht installiert ist die Hilfe anzeigen.
		hilfe
	fi
}

##
 #* mySQLmenu.
 # Menue fuer SQL Funktionen.
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
##  mySQLmenu
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
		antwort=$?
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

		if [[ $antwort = 2 ]]; then hilfemenu; fi
		if [[ $antwort = 1 ]]; then exit; fi
	else
		# wenn dialog nicht installiert ist die Hilfe anzeigen.
		hilfe
	fi
}

##
 #* avatarmenu.
 # Menue fuer Benutzerfunktionen.
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
##  avatarmenu
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

		avatarauswahl=$(dialog --clear \
			--backtitle "$BACKTITLE" \
			--title "$TITLE" \
			--help-button --defaultno \
			--menu "$MENU" \
			$HEIGHT $WIDTH $CHOICE_HEIGHT \
			"${OPTIONS[@]}" \
			2>&1 >/dev/tty) # 3>&1 1>&2 2>&3

		antwort=$?
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

		if [[ $antwort = 2 ]]; then hilfemenu; fi
		if [[ $antwort = 1 ]]; then exit; fi
	else
		# wenn dialog nicht installiert ist die Hilfe anzeigen.
		hilfe
	fi
}

##
 #* expertenmenu.
 # Menuepunkte fuer Experten.
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
##  expertenmenu
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
	Dateimennu=$(menutrans "Dateimennu")
	mySQLmenu=$(menutrans "mySQLmenu")
	BuildFunktionen=$(menutrans "Build Funktionen")
	#ExpertenFunktionen=$(menutrans "Experten Funktionen")

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
			"$Dateimennu" ""
			"$mySQLmenu" ""
			"$BuildFunktionen" ""
			"$WeitereFunktionen" "")

		feauswahl=$(dialog --clear \
			--backtitle "$BACKTITLE" \
			--title "$TITLE" \
			--help-button --defaultno \
			--menu "$MENU" \
			$HEIGHT $WIDTH $CHOICE_HEIGHT \
			"${OPTIONS[@]}" \
			2>&1 >/dev/tty)
			

		antwort=$?
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

		if [[ $feauswahl = "$Hilfe" ]]; then hilfemenu; fi

		if [[ $feauswahl = "$Dateimennu" ]]; then dateimenu; fi
		if [[ $feauswahl = "$mySQLmenu" ]]; then mySQLmenu; fi
		if [[ $feauswahl = "$Hauptmennu" ]]; then hauptmenu; fi
		if [[ $feauswahl = "$WeitereFunktionen" ]]; then funktionenmenu; fi
		if [[ $feauswahl = "$BuildFunktionen" ]]; then buildmenu; fi
		if [[ $feauswahl = "$Avatarmennu" ]]; then avatarmenu; fi

		if [[ $antwort = 2 ]]; then hilfemenu; fi
		if [[ $antwort = 1 ]]; then exit; fi
	else
		# wenn dialog nicht installiert ist die Hilfe anzeigen.
		hilfe
	fi
}

##
 #* buildmenu.
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
	Dateimennu=$(menutrans "Dateimennu")
	mySQLmenu=$(menutrans "mySQLmenu")
	BuildFunktionen=$(menutrans "Build Funktionen")
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
		antwort=$?
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

		if [[ $antwort = 2 ]]; then hilfemenu; fi
		if [[ $antwort = 1 ]]; then exit; fi
	else
		# wenn dialog nicht installiert ist die Hilfe anzeigen.
		hilfe
	fi
}

##
 #* newhelp.
 # newhelp Hilfe.
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
##  expertenmenu
function newhelp() {
	# $(tput setab 5) $(tput setaf 2) $(tput sgr 0)
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
	echo "all                     $(tput setaf 2)Alle OpenSimulator Konsolenkommandos.$(tput sgr 0)"
	echo "hda                     $(tput setaf 2)Dialog Menue direktaufrufe.$(tput sgr 0)"
	echo " "
	echo " Der Kommando aufruf:"
	echo "$(tput setaf $FARBE1) $(tput setab $FARBE2)# Beispiel: bash osmtool.sh oscommand sim1 Welcome \"alert Hallo Welt\" $(tput sgr 0)"
	echo "$(tput setaf $FARBE1) $(tput setab $FARBE2)# Beispiel: bash osmtool.sh oscommand sim1 Welcome \"alert-user John Doe Hallo John Doe\" $(tput sgr 0)"
}

##
 #* newhelp2
 # newhelp Hilfe.
 # 
 #? @param name Erklaerung.
 #? @return name was wird zurueckgegeben.
 # todo: nichts.
##  expertenmenu
function newhelp2() {
	# $(tput setab 5) $(tput setaf 2) $(tput sgr 0)
	log rohtext "Display Hilfe"
	log rohtext "Syntax: osmtool.sh [h|hilfe|konsolenhilfe|dbhilfe|commandhelp|RobustCommands|OpenSimCommands|hda]"
	log rohtext "Optionen:"
	log info "h                       Zeigt diese hilfe."
	log info "hilfe                   Haupthilfefunktionen."
	log info "konsolenhilfe           Konsolenhilfe dreht sich um Putty."
	log info "dbhilfe                 Hilfe rund um die Datenbankmanipulation."
	log info "commandhelp             OpenSimulator Kommandos in Deutsch."
	log info "RobustCommands          Robust Kommandos."
	log info "OpenSimCommands         OpenSimulator Kommandos."
	log info "MoneyServerCommands     MoneyServer Kommandos."
	log info "all                     Alle OpenSimulator Konsolenkommandos."
	log info "hda                     Dialog Menue direktaufrufe."
	echo " "
	log rohtext " Der Kommando aufruf:"
	log rohtext "# Beispiel: bash osmtool.sh oscommand sim1 Welcome \"alert Hallo Welt\" "
	log rohtext "# Beispiel: bash osmtool.sh oscommand sim1 Welcome \"alert-user John Doe Hallo John Doe\" "
}

#**************************************************************************
#* Tests Funktionsgruppe
#**************************************************************************

##
 #* ostimestamp Test
 # Timestamp Experimente.
 # 
 #? @param keiner.
 #? @return $VERSION
 # todo: nichts.
##
function ostimestamp() {
# “yyyy-mm-dd”
# Deutsch dd-mm-yyyy
EN_DATUM=$(date '+%Y-%m-%d %H:%M:%S')
echo "$EN_DATUM" Aktuelles Datum Aktuell in Englisch

DE_DATUM=$(date '+%d-%m-%Y %H:%M:%S')
echo "$DE_DATUM" Aktuelles Datum Aktuell in Deutsch

DATE_TO_UNIX_TIMESTAMP=$(date -d "$EN_DATUM" +%s)
echo "$DATE_TO_UNIX_TIMESTAMP" datum zu timestamp ausgabe

UNIX_TIMESTAMP_TO_DATE=$(date -d "@$DATE_TO_UNIX_TIMESTAMP" '+%Y-%m-%d %H:%M:%S')
echo "$UNIX_TIMESTAMP_TO_DATE" timestamp zu date ausgabe
}



#**************************************************************************
#* Eingabeauswertung Konsolenmenue Funktionsgruppe
#**************************************************************************
case $KOMMANDO in
	AutoInstall) AutoInstall ;;
	ConfigSet) ConfigSet "$2" ;;
	DO_DOMAIN_IDS) DO_DOMAIN_IDS "$2" "$3" "$4" ;;
	DO_DOMAIN_IDS2) DO_DOMAIN_IDS2 "$2" "$3" ;;
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
	MASTER_USE_GTID2) MASTER_USE_GTID2 "$2" "$3" "$4" ;;
	OpenSimConfig) OpenSimConfig ;;
	RELAY_LOG_FILE) RELAY_LOG_FILE "$2" "$3" "$4" "$5" ;;
	RELAY_LOG_POS) RELAY_LOG_POS "$2" "$3" "$4" "$5" ;;
	Replica_Backup) Replica_Backup "$2" "$3" "$4" "$5" ;;
	Replica_Backup2) Replica_Backup2 "$2" "$3" "$4" ;;
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
	linuxupgrade) linuxupgrade ;;
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
	linuxupgrade) linuxupgrade ;;
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
	hda | hilfedirektaufruf | hilfemenudirektaufrufe) hilfemenudirektaufrufe ;;
	h) newhelp ;;
	V | v) echo "$SCRIPTNAME $VERSION" ;;
	*) hauptmenu ;;
esac
# vardelall
exit 0
