#!/bin/bash

# ? opensimMULTITOOL Copyright (c) 2021 2022 BigManzai Manfred Aabye
# opensim.sh Basiert auf meinen Einzelscripten, an denen ich bereits 7 Jahre Arbeite und verbessere.
# Da Server unterschiedlich sind, kann eine einwandfreie fuunktion nicht gewaehrleistet werden, also bitte mit bedacht verwenden.
# Die Benutzung dieses Scriptes, oder deren Bestandteile, erfolgt auf eigene Gefahr!!!
# Erstellt und getestet ist opensim.sh, auf verschiedenen Ubuntu 18.04 Servern, unter verschiedenen Server Anbietern (Contabo, Hetzner ...).

# ? Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

# ? The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

# ! THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# ! FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# ! LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# * Status 27.07.2022 291 Funktionen.

# # Visual Studio Code # ShellCheck # shellman # Better Comments #

#### ? Einstellungen ####

VERSION="V0.79.593" # opensimMULTITOOL Versionsausgabe
#clear # Bildschirmausgabe loeschen.
#reset # Bildschirmausgabe loeschen inklusive dem Scrollbereich.
tput reset # Bildschirmausgabe loeschen inklusive dem Scrollbereich.
# printf '\e[3J' # Bildschirmausgabe sauber loeschen inklusive dem Scrollbereich.

# ? Alte Variablen loeschen aus eventuellen voherigen sessions
unset STARTVERZEICHNIS
unset MONEYVERZEICHNIS
unset ROBUSTVERZEICHNIS
unset OPENSIMVERZEICHNIS
unset SCRIPTSOURCE
unset SCRIPTZIP
unset MONEYSOURCE
unset MONEYZIP
unset REGIONSNAME
unset REGIONSNAMEb
unset REGIONSNAMEc
unset REGIONSNAMEd
unset VERZEICHNISSCREEN

### ! dummyvar, Shell-Check ueberlisten wegen der Konfigurationsdatei, hat sonst keinerlei Funktion und wird auch nicht aufgerufen.
function dummyvar() {
	# shellcheck disable=SC2034
	STARTVERZEICHNIS="opt"; MONEYVERZEICHNIS="robust"; ROBUSTVERZEICHNIS="robust"; OPENSIMVERZEICHNIS="opensim"; SCRIPTSOURCE="ScriptNeu"; SCRIPTZIP="opensim-ossl-example-scripts-main.zip"; MONEYSOURCE="money48"
	MONEYZIP="OpenSimCurrencyServer-2021-master.zip"; OSVERSION="opensim-0.9.2.2Dev"; REGIONSDATEI="RegionList.ini"; SIMDATEI="SimulatorList.ini"; WARTEZEIT=30; STARTWARTEZEIT=10; STOPWARTEZEIT=30; MONEYWARTEZEIT=60; ROBUSTWARTEZEIT=60
	BACKUPWARTEZEIT=120; AUTOSTOPZEIT=60; SETMONOTHREADS=800; SETMONOTHREADSON="yes"; OPENSIMDOWNLOAD="http://opensimulator.org/dist/"; OPENSIMVERSION="opensim-0.9.2.2.zip"; SEARCHADRES="icanhazip.com"; # AUTOCONFIG="no"
	CONFIGURESOURCE="opensim-configuration-addon-modul-main"; CONFIGUREZIP="opensim-configuration-addon-modul-main.zip"
	textfontcolor=7; textbaggroundcolor=0; debugfontcolor=4; debugbaggroundcolor=0	infofontcolor=2	infobaggroundcolor=0; warnfontcolor=3; warnbaggroundcolor=0
	errorfontcolor=1; errorbaggroundcolor=0; SETMONOGCPARAMSON1="no"; SETMONOGCPARAMSON2="yes"	LOGDELETE="no"; LOGWRITE="no"; "$trimmvar"; logfilename="multitool"
	username="username"	password="userpasswd"	databasename="grid"	linefontcolor=7	linebaggroundcolor=0; apache2errorlog="/var/log/apache2/error.log"; apache2accesslog="/var/log/apache2/access.log"
	authlog="/var/log/auth.log"	ufwlog="/var/log/ufw.log"	mysqlmariadberor="/var/log/mysql/mariadb.err"; mysqlerrorlog="/var/log/mysql/error.log"; listVar=""; ScreenLogLevel=0
	# DIALOG_OK=0; DIALOG_HELP=2; DIALOG_EXTRA=3; DIALOG_ITEM_HELP=4; SIG_NONE=0; SIG_HUP=1; SIG_INT=2; SIG_QUIT=3; SIG_KILL=9; SIG_TERM=15
	DIALOG_CANCEL=1; DIALOG_ESC=255; DIALOG=dialog; 
}

### Datumsvariablen Datum, Dateidatum und Uhrzeit
DATUM=$(date +%d.%m.%Y)
DATEIDATUM=$(date +%d_%m_%Y) # UHRZEIT=$(date +%H:%M:%S)

# Linux Version
myDescription=$(lsb_release -d) # Description: Ubuntu 22.04 LTS
myRelease=$(lsb_release -r)     # Release: 22.04
myCodename=$(lsb_release -sc)   # jammy

ubuntuDescription=$(cut -f2 <<<"$myDescription") # Ubuntu 22.04 LTS
ubuntuRelease=$(cut -f2 <<<"$myRelease")         # 22.04
ubuntuCodename=$(cut -f2 <<<"$myCodename")       # jammy

### Einstellungen aus opensim.cnf laden, bei einem Script upgrade gehen so die einstellungen nicht mehr verloren.
# Pfad des opensim.sh Skriptes herausfinden
SCRIPTPATH=$(cd "$(dirname "$0")" && pwd)
# Variablen aus config Datei laden opensim.cnf muss sich im gleichen Verzeichnis wie opensim.sh befinden.
# shellcheck disable=SC1091
. "$SCRIPTPATH"/opensim.cnf

### Aktuelle IP ueber Suchadresse ermitteln und Ausfuehrungszeichen anhaengen.
AKTUELLEIP='"'$(wget -O - -q $SEARCHADRES)'"'

### gibt es das Startverzeichnis wenn nicht abbruch.
cd /"$STARTVERZEICHNIS" || return 1
sleep 1

### * Eingabeauswertung fuer Funktionen ohne dialog.
KOMMANDO=$1

### ! vardel, Variablen loeschen.
function vardel() {
	unset STARTVERZEICHNIS
	unset MONEYVERZEICHNIS
	unset ROBUSTVERZEICHNIS
	unset WARTEZEIT
	unset STARTWARTEZEIT
	unset STOPWARTEZEIT
	unset MONEYWARTEZEIT
	unset NAME
	unset VERZEICHNIS
	unset PASSWORD
	unset DATEI
	unset OPENSIMVERZEICHNIS
	unset SCRIPTSOURCE
	unset SCRIPTZIP
	unset MONEYSOURCE
	unset MONEYZIP
	unset REGIONSNAME
	unset REGIONSNAMEb
	unset REGIONSNAMEc
	unset REGIONSNAMEd
	unset VERZEICHNISSCREEN
	return 0
}

### ScreenLog Bildschirmausgabe reduzieren. TEST
function ScreenLog() {
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

### ScreenLog Bildschirmausgabe reduzieren. TEST
function dialogclear() {
	dialog --clear
	return 0
}

### Log Dateien von Ubuntu loeschen Beispiel: historylogclear "history"
function historylogclear() {
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

logfilename=""
### ! Log Dateien und Funktionen
function log() {
	local text
	local logtype
	#local datetime
	logtype="$1"
	text="$2"
	#datetime=$(date +'%F %H:%M:%S')
	DATEIDATUM=$(date +%d_%m_%Y)
	lline="#####################################################################################"

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

### ! .Funktionen eines Bash Skript auslesen und in eine Text Datei schreiben.
function functionslist() {
	file="/opt/opensim.sh"
	ergebnisfunktionslist=$(grep -i -r "function " $file | grep -v ^# | grep -v ^$)
	echo "$ergebnisfunktionslist" >/opt/funktionsliste.txt
}

### ! Kopfzeile
function schreibeinfo() {
	# Wenn das schreiben abgeschaltet ist dann braucht man nicht zu schauen ob was in der Datei steht.
	if [ "$LOGWRITE" = "yes" ]; then
		FILENAME="/$STARTVERZEICHNIS/$DATEIDATUM$logfilename.log" # Name der Datei
		FILESIZE=$(stat -c%s "$FILENAME")                         # Wie Gross ist die Datei.
	fi
	NULL=0
	# Ist die Datei Groesser als null, dann Kopfzeile nicht erneut schreiben.
	if [ "$FILESIZE" \< "$NULL" ]; then
		log rohtext "   ____                        _____  _                    _         _               "
		log rohtext "  / __ \                      / ____|(_)                  | |       | |              "
		log rohtext " | |  | | _ __    ___  _ __  | (___   _  _ __ ___   _   _ | |  __ _ | |_  ___   _ __ "
		log rohtext " | |  | ||  _ \  / _ \|  _ \  \___ \ | ||  _   _ \ | | | || | / _  || __|/ _ \ |  __|"
		log rohtext " | |__| || |_) ||  __/| | | | ____) || || | | | | || |_| || || (_| || |_| (_) || |   "
		log rohtext "  \____/ |  __/  \___||_| |_||_____/ |_||_| |_| |_| \____||_| \____| \__|\___/ |_|   "
		log rohtext "         | |                                                                         "
		log rohtext "         |_|                                                                         "
		log rohtext " $VERSION"
		log rohtext " "
		log line
		log rohtext "$DATUM $(date +%H:%M:%S) MULTITOOL: wurde gestartet am $(date +%d.%m.%Y) um $(date +%H:%M:%S) Uhr"
		log rohtext "$DATUM $(date +%H:%M:%S) INFO: Server Name: ${HOSTNAME}"
		log rohtext "$DATUM $(date +%H:%M:%S) INFO: Server IP: ${AKTUELLEIP}"
		log rohtext "$DATUM $(date +%H:%M:%S) INFO: Linux Version: $ubuntuDescription"
		log rohtext "$DATUM $(date +%H:%M:%S) INFO: Release Nummer: $ubuntuRelease"
		log rohtext "$DATUM $(date +%H:%M:%S) INFO: Linux Name: $ubuntuCodename"
		log rohtext "$DATUM $(date +%H:%M:%S) INFO: Bash Version: ${BASH_VERSION}"
		log rohtext "$DATUM $(date +%H:%M:%S) INFO: MONO THREAD Einstellung: ${MONO_THREADS_PER_CPU}"
		log rohtext "$DATUM $(date +%H:%M:%S) INFO: Spracheinstellung: ${LANG}"
		log rohtext "$DATUM $(date +%H:%M:%S) INFO: $(screen --version)"
		log rohtext "$DATUM $(date +%H:%M:%S) INFO: $(who -b)"
		log line
		log rohtext " "
	fi
	return 0
}

# *Kopfzeile in die Log Datei schreiben.
schreibeinfo

### ! Leerzeichen korrigieren,
# trimm "   Beispiel   Text    "
# oder trimm $variable, rueckgabe in Variable: $trimmvar.
function trimm() {
	set -f
	# shellcheck disable=SC2086,SC2048
	set -- $*
	trimmvar=$(printf '%s\n' "$*")
	set +f
}

### ! Zeichen entfernen
# letterdel $variable "[aAbBcCdD]" - letterdel $variable "[[:space:]]"
letterdel() {
	printf '%s\n' "${1//$2/}"
}

### ! Zeichen entfernen
# Usage: trim_string "   example   string    "
trim_string() {
    : "${1#"${1%%[![:space:]]*}"}"
    : "${_%"${_##*[![:space:]]}"}"
    printf '%s\n' "$_"
}

### ! Variable auf inhalt testen.
# testvariable="Voll"
# vartest $testvariable
# echo "${result}"
function vartest () {
    VARIABLE="$1"
    if [ -z "$VARIABLE" ]
    then
        result="false"
    else
        result="true"
    fi
}

### ! Alle Zeichen entfernen
# Usage: trim_all "   example   string    "
trim_all() {
    set -f
# shellcheck disable=SC2086,SC2048
    set -- $*
    printf '%s\n' "$*"
    set +f
}

### ! Linux apt-get Installationsroutine
function iinstall() {
	installation=$1
	if dpkg-query -s "$installation" 2>/dev/null | grep -q installed; then
		echo "$installation ist bereits installiert."
	else
		echo "Ich installiere jetzt $installation"
		sudo apt-get -y install "$installation"
	fi
}

### ! Linux apt Installationsroutine
function iinstall2() {
	installation=$1
	if dpkg-query -s "$installation" 2>/dev/null | grep -q installed; then
		echo "$installation ist bereits installiert.""
	else
		echo ""Ich installiere jetzt $installation"
		sudo apt install "$installation" -y
	fi
}

### ! Neue apt-get installationsroutine aus Datei
function finstall() {
	TXTLISTE=$1

	while read -r txtline; do
		if dpkg-query -s "$txtline" 2>/dev/null | grep -q installed; then
			echo "$txtline ist bereits installiert!"
		else
			echo "Ich installiere jetzt: $txtline"
			sudo apt-get -y install "$txtline"
		fi
	done <"$TXTLISTE"
}

### ! Neue installationsroutine aus Datei
function menufinstall() {
	TXTLISTE=$1
	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then
		# Alle Aktionen mit dialog
		boxtitel="opensimMULTITOOL Eingabe"
		boxtext="Screen Name:"
		TXTLISTE=$(dialog --backtitle "opensimMULTITOOL $VERSION" --title "$boxtitel" --inputbox "$boxtext" 8 40 3>&1 1>&2 2>&3 3>&-)
		dialogclear
		ScreenLog

		while read -r line; do
			if dpkg-query -s "$line" 2>/dev/null | grep -q installed; then
				echo "$line ist bereits installiert!"
			else
				echo "Ich installiere jetzt: $line"
				sudo apt-get -y install "$line"
			fi
		done <"$TXTLISTE"
	else
		# Alle Aktionen ohne dialog
		while read -r line; do
			if dpkg-query -s "$line" 2>/dev/null | grep -q installed; then
				echo "$line ist bereits installiert!"
			else
				echo "Ich installiere jetzt: $line"
				sudo apt-get -y install "$line"
			fi
		done <"$TXTLISTE"
	fi
}

### ! uncompress ermittelt welcher Kompressor eingesetzt wurde und gibt den entpack Befehl zurueck.
function uncompress()
{
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

    return 0
}

### ! downloados Opensim download
function downloados() {
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

	hauptmenu
}

### Radioliste erstellen aus Webseitenlinks.
function radiolist()
{
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

            # den Benutzer extrahieren (falls vorhanden).
            #user="$(echo "$url" | grep @ | cut -d@ -f1)"

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

### ! rebootdatum letzter reboot des Servers.
function rebootdatum() {
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
	else
		# Nein
		hauptmenu
	fi
	return 0
}

## * --no-collapse   verhindert dialog die Neuformatierung des Nachrichtentextes.
## * Verwenden Sie dies, wenn die exakte Darstellung des Textes erforderlich ist.

### ! warnbox Medung anzeigen.
function warnbox() {
	dialog --msgbox "$1" 0 0
	dialogclear
	ScreenLog
	hauptmenu
}

### ! Text editieren.
function edittextbox() {
	#--editbox 	DATEI HOEHE BREITE
	dialog --editbox "$1" 0 0
	#NEWTEXT=$(dialog --editbox "$1" 0 0)
	dialogclear
	ScreenLog
	#echo "$NEWTEXT"
	hauptmenu
}

### ! Text Meldung anzeigen.
function textbox() {
	#--editbox 	DATEI HOEHE BREITE
	dialog --textbox "$1" 0 0
	dialogclear
	ScreenLog
	hauptmenu
}

### ! Nachrichtbox Meldung anzeigen.
function nachrichtbox() {
	dialog --title "$1" --no-collapse --msgbox "$result" 0 0
	hauptmenu
}

### ! php log anzeigen.
function apacheerror() {
	###php log Datei:
	if [ -f "$apache2errorlog" ]; then
		textbox "$apache2errorlog"
	else
		warnbox "$apache2errorlog File not found!"
	fi
}

### ! mysql log anzeigen.
function mysqldberror() {
	###mysql log Datei:
	if [ -f "$mysqlerrorlog" ]; then
		textbox "$mysqlerrorlog"
	else
		warnbox "$mysqlerrorlog File not found!"
	fi
}

### ! mariadb error anzeigen.
function mariadberror() {
	###mariaDB log Datei:
	if [ -f "$mysqlmariadberor" ]; then
		textbox "$mysqlmariadberor"
	else
		warnbox "$mysqlmariadberor File not found!"
	fi
}

### ! ufw log anzeigen.
function ufwlog() {
	###mariaDB log Datei:
	if [ -f "$ufwlog" ]; then
		textbox "$ufwlog"
	else
		warnbox "$ufwlog File not found!"
	fi
}

### ! auth log anzeigen.
function authlog() {
	###auth.log Datei:
	if [ -f "$authlog" ]; then
		textbox "$authlog"
	else
		warnbox "$authlog File not found!"
	fi
}

### ! access log anzeigen.
function accesslog() {
	###access.log Datei:
	if [ -f "$apache2accesslog" ]; then
		textbox "$apache2accesslog"
	else
		warnbox "$apache2accesslog File not found!"
	fi
}

### ! Festplattenspeicher anzeigen.
function fpspeicher() {
	result=$(df -h)
	nachrichtbox "Freier Spericher"
}

### !  screenlist, Laufende Screens auflisten.
function screenlist() {
	log line
	log info "Alle laufende Screens anzeigen!"
	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then
		# Alle Aktionen mit dialog
		txtscreenlist=$(screen -ls)
		warnbox "$txtscreenlist"
		hauptmenu
	else
		# Alle Aktionen ohne dialog
		mynewlist=$(screen -ls)
		log text "$mynewlist"
		return 0
	fi
}
### ! screenlistrestart Alle laufende Screens anzeigen
function screenlistrestart() {
	log line
	log info "Alle laufende Screens anzeigen!"
	mynewlist=$(screen -ls)
	log text "$mynewlist"
	return 0
}

### ! makeverzeichnisliste Erstellen eines Arrays aus einer Textdatei - Verzeichnisse
function makeverzeichnisliste() {
	VERZEICHNISSLISTE=()
	while IFS= read -r line; do
		VERZEICHNISSLISTE+=("$line")
	done </$STARTVERZEICHNIS/$SIMDATEI
	# Anzahl der Eintraege.
	ANZAHLVERZEICHNISSLISTE=${#VERZEICHNISSLISTE[*]}
	return 0
}

### ! makeregionsliste Erstellen eines Arrays aus einer Textdatei - Regionen
function makeregionsliste() {
	REGIONSLISTE=()
	while IFS= read -r line; do
		REGIONSLISTE+=("$line")
	done </$STARTVERZEICHNIS/$REGIONSDATEI
	ANZAHLREGIONSLISTE=${#REGIONSLISTE[*]} # Anzahl der Eintraege.
	return 0
}

### ! mysqlrest Funktion zum abfragen von mySQL Datensaetzen: mymysql "username" "password" "databasename" "mysqlcommand"
function mysqlrest() {
	username=$1
	password=$2
	databasename=$3
	mysqlcommand=$4
	result_mysqlrest=$(echo "$mysqlcommand;" | MYSQL_PWD=$password mysql -u"$username" "$databasename" -N) 2>/dev/null
}
### ! mysqlrestnodb Funktion mySQL Datensaetzen: mymysql "username" "password" "mysqlcommand"
function mysqlrestnodb() {
	username=$1
	password=$2
	mysqlcommand=$3
	result_mysqlrestnodb=$(echo "$mysqlcommand" | MYSQL_PWD=$password mysql -u"$username")
}

### ! mysqlbackup Funktion zum sichern von mySQL Datensaetzen: mysqlbackup "username" "password" "databasename"
function mysqlbackup() {
	# bearbeitung noetig!
	username=$1
	password=$2
	databasename=$3
	result_mysqlrest=$("MYSQL_PWD=$password" "mysqldump -u$username $databasename" -N)
	# mysqldump -u root -p omlgrid assets > AssetService.sql
}

### !  passwdgenerator, Passwortgenerator
function passwdgenerator() {
	### dialog Aktionen
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

### !  assetdel, Asset von der Region loeschen. Aufruf: assetdel screen_name Regionsname Objektname
function assetdel() {
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

### ! menuassetdel Assets loeschen.
function menuassetdel() {
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
		VERZEICHNISSCREEN=$(echo "$ASSETDELBOXERGEBNIS" | sed -n '1p')
		REGION=$(echo "$ASSETDELBOXERGEBNIS" | sed -n '2p')
		OBJEKT=$(echo "$ASSETDELBOXERGEBNIS" | sed -n '3p')

		# Alles loeschen.
		dialogclear
		ScreenLog
	else
		# Alle Aktionen ohne dialog
		echo "Keine Menuelose Funktion" | exit
	fi # dialog Aktionen Ende

	# Nachschauen ob der Screen und die Region existiert.
	if screen -list | grep -q "$VERZEICHNISSCREEN"; then
		log warn "$OBJEKT Asset von der Region $REGION loeschen"
		screen -S "$VERZEICHNISSCREEN" -p 0 -X eval "stuff 'change region ""$REGION""'^M"                  # Region wechseln
		screen -S "$VERZEICHNISSCREEN" -p 0 -X eval "stuff 'alert "Loesche: "$OBJEKT" von der Region!"'^M" # Mit einer loesch Meldung
		screen -S "$VERZEICHNISSCREEN" -p 0 -X eval "stuff 'delete object name ""$OBJEKT""'^M"             # Objekt loeschen
		screen -S "$VERZEICHNISSCREEN" -p 0 -X eval "stuff 'y'^M"                                          # Mit y also yes bestaetigen
		return 0
	else
		log error "ASSETDEL: $OBJEKT Asset von der Region $REGION loeschen fehlgeschlagen"
		return 1
	fi
}

### !  landclear, Land clear - Loescht alle Parzellen auf dem Land. # Aufruf: landclear screen_name Regionsname Objektname
function landclear() {
	LANDCLEARSCREEN=$1
	REGION=$2
	# Nachschauen ob der Screen und die Region existiert.
	if screen -list | grep -q "$LANDCLEARSCREEN"; then
		log warn "$OBJEKT Parzellen von der Region $REGION loeschen"
		screen -S "$LANDCLEARSCREEN" -p 0 -X eval "stuff 'change region ""$REGION""'^M"                 # Region wechseln
		screen -S "$LANDCLEARSCREEN" -p 0 -X eval "stuff 'alert "Loesche Parzellen von der Region!"'^M" # Mit einer loesch Meldung
		screen -S "$LANDCLEARSCREEN" -p 0 -X eval "stuff 'land clear'^M"                                # Objekt loeschen
		screen -S "$LANDCLEARSCREEN" -p 0 -X eval "stuff 'y'^M"                                         # Mit y also yes bestaetigen
		return 0
	else
		log error "LANDCLEAR: $OBJEKT Parzellen von der Region $REGION loeschen fehlgeschlagen"
		return 1
	fi
}

### !  menulandclear, Land clear - Loescht alle Parzellen auf dem Land. # Aufruf: landclear screen_name Regionsname Objektname
function menulandclear() {
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
		VERZEICHNISSCREEN=$(echo "$landclearBOXERGEBNIS" | sed -n '1p')
		REGION=$(echo "$landclearBOXERGEBNIS" | sed -n '2p')

		# Alles loeschen.
		dialogclear
		ScreenLog
	else
		# Alle Aktionen ohne dialog
		echo "Keine Menuelose Funktion" | exit
	fi # dialog Aktionen Ende

	# Nachschauen ob der Screen und die Region existiert.
	if screen -list | grep -q "$VERZEICHNISSCREEN"; then
		log warn "$OBJEKT Parzellen von der Region $REGION loeschen"
		screen -S "$VERZEICHNISSCREEN" -p 0 -X eval "stuff 'change region ""$REGION""'^M"                 # Region wechseln
		screen -S "$VERZEICHNISSCREEN" -p 0 -X eval "stuff 'alert "Loesche Parzellen von der Region!"'^M" # Mit einer loesch Meldung
		screen -S "$VERZEICHNISSCREEN" -p 0 -X eval "stuff 'land clear'^M"                                # Objekt loeschen
		screen -S "$VERZEICHNISSCREEN" -p 0 -X eval "stuff 'y'^M"                                         # Mit y also yes bestaetigen
		return 0
	else
		log error "LANDCLEAR: $OBJEKT Parzellen von der Region $REGION loeschen fehlgeschlagen"
		return 1
	fi
}

### !  loadinventar, saveinventar # Aufruf: load oder saveinventar "NAME" "VERZEICHNIS" "PASSWORD" "DATEImitPFAD"
function loadinventar() {
	LOADINVSCREEN="sim1"
	NAME=$1
	VERZEICHNIS=$2
	PASSWORD=$3
	DATEI=$4
	if screen -list | grep -q "$LOADINVSCREEN"; then
		log info "OSCOMMAND: load iar $NAME $VERZEICHNIS ***** $DATEI"
		screen -S "$LOADINVSCREEN" -p 0 -X eval "stuff 'load iar $NAME $VERZEICHNIS $PASSWORD $DATEI'^M"
		return 0
	else
		log error "OSCOMMAND: Der Screen $LOADINVSCREEN existiert nicht"
		return 1
	fi
}

### !  loadinventar, saveinventar # Aufruf: load oder saveinventar "NAME" "VERZEICHNIS" "PASSWORD" "DATEImitPFAD"
function menuloadinventar() {
	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then

		# Einstellungen
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
		lablename4="/opt/texture.iar"

		# Abfrage
		loadinventarBOXERGEBNIS=$(dialog --backtitle "$boxbacktitel" --title "$boxtitel" --form "$formtitle" 25 60 16 "$lable1" 1 1 "$lablename1" 1 25 25 30 "$lable2" 2 1 "$lablename2" 2 25 25 30 "$lable3" 3 1 "$lablename3" 3 25 25 30 "$lable4" 4 1 "$lablename4" 4 25 25 30 3>&1 1>&2 2>&3 3>&-)

		# Zeilen aus einer Variablen zerlegen und in verschiedenen Variablen schreiben.
		NAME=$(echo "$loadinventarBOXERGEBNIS" | sed -n '1p')
		VERZEICHNIS=$(echo "$loadinventarBOXERGEBNIS" | sed -n '2p')
		PASSWORD=$(echo "$loadinventarBOXERGEBNIS" | sed -n '3p')
		DATEI=$(echo "$loadinventarBOXERGEBNIS" | sed -n '4p')

		# Alles loeschen.
		dialogclear
		ScreenLog
	else
		# Alle Aktionen ohne dialog
		echo "Keine Menuelose Funktion" | exit
	fi # dialog Aktionen Ende

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

### !  saveinventar, saveinventar # Aufruf: load oder saveinventar "NAME" "VERZEICHNIS" "PASSWORD" "DATEImitPFAD"
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

### !  saveinventar, saveinventar # Aufruf: load oder saveinventar "NAME" "VERZEICHNIS" "PASSWORD" "DATEImitPFAD"
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
		lablename4="/opt/texture.iar"

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
		echo "Keine Menuelose Funktion" | exit
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

### !  oscommand, OpenSim Command direkt in den screen senden. # Aufruf: oscommand Screen Region Befehl Parameter
# Beispiel: /opt/opensim.sh oscommand sim1 Welcome "alert Hallo liebe Leute dies ist eine Nachricht"
# Beispiel: /opt/opensim.sh oscommand sim1 Welcome "alert-user John Doe Hallo John Doe"
function oscommand() {
	OSCOMMANDSCREEN=$1
	REGION=$2
	COMMAND=$3
	if screen -list | grep -q "$OSCOMMANDSCREEN"; then
		log info "OSCOMMAND: $COMMAND an $OSCOMMANDSCREEN senden"
		screen -S "$OSCOMMANDSCREEN" -p 0 -X eval "stuff 'change region ""$REGION""'^M" # Region wechseln
		screen -S "$OSCOMMANDSCREEN" -p 0 -X eval "stuff '$COMMAND'^M"
	else
		log error "OSCOMMAND: Der Screen $OSCOMMANDSCREEN existiert nicht"
	fi
	return 0
}

### !  oscommand, OpenSim Command direkt in den screen senden. # Aufruf: oscommand Screen Region Befehl Parameter
function menuoscommand() {
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
		echo "Keine Menuelose Funktion" | exit
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
### ! oswriteconfig
function oswriteconfig() {
	SETSIMULATOR=$1
	CONFIGWRITE="config save /opt/$SETSIMULATOR.ini"
	screen -S "$SETSIMULATOR" -p 0 -X eval "stuff '$CONFIGWRITE'^M"
}
### ! menuoswriteconfig
function menuoswriteconfig() {
	SETSIMULATOR=$1 # OpenSimulator, Verzeichnis und Screen Name

	### dialog Aktionen
	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then
		# Alle Aktionen mit dialog
		boxtitel="opensimMULTITOOL Eingabe"
		boxtext="Screen Name:"
		SETSIMULATOR=$(dialog --backtitle "opensimMULTITOOL $VERSION" --title "$boxtitel" --inputbox "$boxtext" 8 40 3>&1 1>&2 2>&3 3>&-)
		dialogclear
		ScreenLog

		if ! screen -list | grep -q "$SETSIMULATOR"; then
			# es laeuft nicht - not work
			dialog --backtitle "opensimMULTITOOL $VERSION" --msgbox "OpenSimulator $SETSIMULATOR OFFLINE!" 5 40
			dialogclear
			ScreenLog
		else
			# es laeuft - work
			# Konfig schreiben
			CONFIGWRITE="config save /opt/$SETSIMULATOR.ini"
			CONFIGREAD=$(sed '' "$SETSIMULATOR.ini")
			screen -S "$SETSIMULATOR" -p 0 -X eval "stuff '$CONFIGWRITE'^M"
			# # Konfig lesen
			dialog --backtitle "opensimMULTITOOL $VERSION" --msgbox "$CONFIGREAD" 0 0
			#dialog --editbox "$CONFIGREAD" 0 0
			#dialog --textbox "$CONFIGREAD" 0 0
			dialogclear
			ScreenLog
		fi
	else
		# Alle Aktionen ohne dialog
		if ! screen -list | grep -q "$SETSIMULATOR"; then
			# es laeuft nicht - not work
			log info "WORKS: $SETSIMULATOR OFFLINE!"
			return 1
		else
			# es laeuft - work
			# Konfig schreiben
			CONFIGWRITE="config save /opt/$SETSIMULATOR.ini"
			screen -S "$SETSIMULATOR" -p 0 -X eval "stuff '$CONFIGWRITE'^M"
			return 0
		fi
	fi
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then hauptmenu; fi
}

### !  menuworks, screen pruefen ob er laeuft. dialog auswahl
function menuworks() {
	WORKSSCREEN=$1 # OpenSimulator, Verzeichnis und Screen Name

	### dialog Aktionen
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

### !  works, screen pruefen ob er laeuft. # Aufruf: works screen_name
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

### ! waslauft - Zeigt alle Laufenden Screens an.
function waslauft() {
	# Die screen -ls ausgabe zu einer Liste aendern.
	# sed '1d' = erste Zeile loeschen - sed '$d' letzte Zeile loeschen.
	# awk -F. alles vor dem Punkt entfernen - -F\( alles hinter dem  ( loeschen.
	ergebnis=$(screen -ls | sed '1d' | sed '$d' | awk -F. '{print $2}' | awk -F\( '{print $1}')
	echo "$ergebnis"
	return 0
}

### ! menuwaslauft - Zeigt alle Laufenden Screens an im dialog.
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

### !  checkfile, pruefen ob Datei vorhanden ist. # Aufruf: checkfile "pfad/name"
# Verwendung als Einzeiler: checkfile /pfad/zur/datei && echo "File exists" || echo "File not found!"
function checkfile() {
	DATEINAME=$1
	[ -f "$DATEINAME" ]
	return $?
}

### !  mapdel, loescht die Map-Karten. # Aufruf: mapdel Verzeichnis
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

### !  logdel, loescht die Log Dateien. # Aufruf: logdel Verzeichnis
function logdel() {
	VERZEICHNIS=$1
	if [ -d "$VERZEICHNIS" ]; then
		rm /$STARTVERZEICHNIS/"$VERZEICHNIS"/bin/*.log 2>/dev/null || echo "Ich habe die $VERZEICHNIS log nicht gefunden!"		
	else
		log error "LOGDEL: $VERZEICHNIS logs nicht gefunden"
		return 1
	fi
	log info "OpenSimulator log Verzeichnisse geloescht"
	return 0
}

### !  rologdel, loescht die Log Dateien. # Aufruf: rologdel Verzeichnis
function rologdel() {
	# /opt/robust/bin
	RVERZEICHNIS="robust"
	if [ -d /$STARTVERZEICHNIS/$RVERZEICHNIS ]; then
		rm /$STARTVERZEICHNIS/"$RVERZEICHNIS"/bin/*.log 2>/dev/null || echo "Ich habe die Robust und/oder Money logs nicht gefunden."		
	else
		log info "Robust Verzeichnis wurden nicht gefunden"
		return 1
	fi
	log info "Robust und Money logs wurden geloescht"
	return 0
}

### !  menumapdel, loescht die Log Dateien. # Aufruf: mapdel Verzeichnis
function menumapdel() {
	### dialog Aktionen
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

### !  logdel, loescht die Log Dateien. # Aufruf: logdel Verzeichnis
function menulogdel() {
	### dialog Aktionen
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

### !  ossettings, stellt den Linux Server fuer OpenSim ein.
function ossettings() {
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
		log info "Setze die Einstellung: nursery-size=32m,promotion-age=14,"
		log info "minor=split,major=marksweep,no-lazy-sweep,alloc-ratio=50,"
		log info "nursery-size=64m"

		# Test 26.02.2022
		export MONO_GC_PARAMS="nursery-size=32m,promotion-age=14,minor=split,major=marksweep,no-lazy-sweep,alloc-ratio=50,nursery-size=64m"
		export MONO_GC_DEBUG=""
		export MONO_ENV_OPTIONS="--desktop"
	fi
	return 0
}

### !  osstart, startet Region Server. # Beispiel-Example: /opt/opensim.sh osstart sim1
function osstart() {
	OSSTARTSCREEN=$1 # OpenSimulator, Verzeichnis und Screen Name

	if ! screen -list | grep -q "$OSSTARTSCREEN"; then
		if [ -d "$OSSTARTSCREEN" ]; then

			cd /$STARTVERZEICHNIS/"$OSSTARTSCREEN"/bin || return 1

			# AOT Aktiveren oder Deaktivieren.
			if [[ $SETAOTON = "yes" ]]; then
				log info "OpenSimulator $OSSTARTSCREEN Starten mit aot"
				screen -fa -S "$OSSTARTSCREEN" -d -U -m mono --desktop -O=all OpenSim.exe
				return 0
				log info "OpenSimulator $OSSTARTSCREEN Starten"
				screen -fa -S "$OSSTARTSCREEN" -d -U -m mono OpenSim.exe
				return 0
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

	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then hauptmenu; fi
}

### !  osstop, stoppt Region Server. # Beispiel-Example: /opt/opensim.sh osstop sim1
function osstop() {
	OSSTOPSCREEN=$1 # OpenSimulator, Verzeichnis und Screen Name
	if screen -list | grep -q "$OSSTOPSCREEN"; then
		log warn "OpenSimulator $OSSTOPSCREEN Beenden"
		screen -S "$OSSTOPSCREEN" -p 0 -X eval "stuff 'shutdown'^M"
		sleep 10
		return 0
	else
		log error "OpenSimulator $OSSTOPSCREEN nicht vorhanden"
		return 1
	fi

	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then hauptmenu; fi
}

### !  menuosstart() ist die dialog Version von osstart()
function menuosstart() {
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

			# AOT Aktiveren oder Deaktivieren.
			if [[ $SETAOTON = "yes" ]]; then
				DIALOG=dialog
				(
					echo "10"
					screen -fa -S "$IOSSTARTSCREEN" -d -U -m mono --desktop -O=all OpenSim.exe
					sleep 3
					echo "100"
					sleep 2
				) 
				#|
				#$DIALOG --title "$IOSSTARTSCREEN" --gauge "Start" 8 30
				#$dialogclear
				#$DIALOG --msgbox "$IOSSTARTSCREEN gestartet!" 5 20
				#$dialogclear
				ScreenLog
				return 0
			else
				DIALOG=dialog
				(
					echo "10"
					screen -fa -S "$IOSSTARTSCREEN" -d -U -m mono OpenSim.exe
					sleep 3
					echo "100"
					sleep 2
				) #|
					#$DIALOG --title "$IOSSTARTSCREEN" --gauge "Start" 8 30
				#$dialogclear
				#$DIALOG --msgbox "$IOSSTARTSCREEN gestartet!" 5 20
				#$dialogclear
				ScreenLog
				hauptmenu
			fi
		else
			echo "OpenSimulator $IOSSTARTSCREEN nicht vorhanden"
			hauptmenu
		fi
	else
		# es laeuft - work
		log error "OpenSimulator $IOSSTARTSCREEN laeuft bereits"
		hauptmenu
	fi
	# hauptmenu
}

### !  menuosstop() ist die dialog Version von osstop()
function menuosstop() {
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
			echo "10"
			screen -S "$IOSSTOPSCREEN" -p 0 -X eval "stuff 'shutdown'^M"
			sleep 3
			echo "100"
			sleep 2
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

### !  rostart, Robust starten.
function rostart() {
	log line
	if checkfile /$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS/bin/Robust.exe; then
		cd /$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS/bin || return 1
		# Start mit oder ohne AOT.
		if [[ $SETAOTON = "yes" ]]; then
			log info "Robust wird gestartet mit aot..."
			screen -fa -S RO -d -U -m mono --desktop -O=all Robust.exe
			sleep $ROBUSTWARTEZEIT
			return 0
		else
			log info "Robust wird gestartet..."
			screen -fa -S RO -d -U -m mono Robust.exe
			sleep $ROBUSTWARTEZEIT
			return 0
		fi
	else
		log error " Robust wurde nicht gefunden"
		return 1
	fi
}
### ! menurostart
function menurostart() {
	# log line
	if checkfile /$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS/bin/Robust.exe; then
		cd /$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS/bin || return 1

		# Start mit oder ohne AOT.
		if [[ $SETAOTON = "yes" ]]; then
			log info "Robust wird mit aot gestartet..."
			screen -fa -S RO -d -U -m mono --desktop -O=all Robust.exe
			sleep $ROBUSTWARTEZEIT
		else
			log info "Robust wird gestartet..."
			screen -fa -S RO -d -U -m mono Robust.exe
			sleep $ROBUSTWARTEZEIT
		fi
	else
		log error " Robust wurde nicht gefunden"
	fi
}

### !  rostop, Robust herunterfahren.
function rostop() {
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
### !  menurostop, Robust herunterfahren.
function menurostop() {
	if screen -list | grep -q "RO"; then
		screen -S RO -p 0 -X eval "stuff 'shutdown'^M"
		log warn "Robust Beenden"
		sleep $WARTEZEIT
	else
		log error "Robust nicht vorhanden"
	fi
}

### !  mostart, Money starten.
function mostart() {
	if checkfile /$STARTVERZEICHNIS/$MONEYVERZEICHNIS/bin/MoneyServer.exe; then
		cd /$STARTVERZEICHNIS/$MONEYVERZEICHNIS/bin || return 1

		# AOT Aktiveren oder Deaktivieren.
		if [[ $SETAOTON = "yes" ]]; then
			log info "Money wird mit aot gestartet..."
			screen -fa -S MO -d -U -m mono --desktop -O=all MoneyServer.exe
			sleep $MONEYWARTEZEIT
			return 0
		else
			log info "Money wird gestartet..."
			screen -fa -S MO -d -U -m mono MoneyServer.exe
			sleep $MONEYWARTEZEIT
			return 0
		fi
	fi
}

### !  menumostart, Money starten.
function menumostart() {
	if checkfile /$STARTVERZEICHNIS/$MONEYVERZEICHNIS/bin/MoneyServer.exe; then
		cd /$STARTVERZEICHNIS/$MONEYVERZEICHNIS/bin || return 1

		# AOT Aktiveren oder Deaktivieren.
		if [[ $SETAOTON = "yes" ]]; then
			log info "Money wird gestartet mit aot..."
			screen -fa -S MO -d -U -m mono --desktop -O=all MoneyServer.exe
			sleep $MONEYWARTEZEIT
			return 0
		else
			log info "Money wird gestartet..."
			screen -fa -S MO -d -U -m mono MoneyServer.exe
			sleep $MONEYWARTEZEIT
			return 0
		fi
	else
		log error "Money wurde nicht gefunden"
		return 1
	fi
}

### !  mostop, Money herunterfahren.
function mostop() {
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
### !  menumostop, Money herunterfahren.
function menumostop() {
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

### !  osscreenstop, beendet ein Screeen. # Beispiel-Example: osscreenstop sim1
function osscreenstop() {
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

### !  gridstart, startet erst Robust und dann Money.
function gridstart() {
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
### ! menugridstart
function menugridstart() {
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

### !  simstats, zeigt Simstatistik an. # simstats screen_name
# Beispiel-Example: simstats sim1
# erzeugt im Hauptverzeichnis eine Datei namens sim1.log in dieser Datei ist die Statistik zu finden.
function simstats() {
	STATSSCREEN=$1 # OpenSimulator, Verzeichnis und Screen Name
	if screen -list | grep -q "$STATSSCREEN"; then
		if checkfile /$STARTVERZEICHNIS/"$STATSSCREEN".log; then
			rm /$STARTVERZEICHNIS/"$STATSSCREEN".log
		fi
		log info "OpenSimulator $STATSSCREEN Simstatistik anzeigen"
		screen -S "$STATSSCREEN" -p 0 -X eval "stuff 'stats save /$STARTVERZEICHNIS/$STATSSCREEN.log'^M"
		sleep 2
		cat /$STARTVERZEICHNIS/"$STATSSCREEN".log
	else
		log error "Simulator $STATSSCREEN nicht vorhanden"
	fi
	return 0
}

### !  terminator, killt alle noch offene Screens.
function terminator() {
	log info "hasta la vista baby"
	log warn "TERMINATOR: Alle Screens wurden durch Benutzer beendet"
	killall screen
	screen -ls
	return 0
}

### !  oscompi, kompilieren des OpenSimulator.
function oscompi() {
	log info " Kompilierungsvorgang startet"
	# In das opensim Verzeichnis wechseln wenn es das gibt ansonsten beenden.
	cd /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS || return 1

	log info " Prebuildvorgang startet"
	# runprebuild19.sh startbar machen und starten.
	chmod +x runprebuild19.sh || chmod +x runprebuild48.sh
	./runprebuild19.sh || ./runprebuild48.sh

	# ohne log Datei.
	if [[ $SETOSCOMPION = "no" ]]; then
		msbuild /p:Configuration=Release || return 1
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

### !  gitcopy, Dateien vom Github kopieren.
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

### !  gitcopy, Dateien vom Github kopieren.
function scriptgitcopy() {
	#Money und Scripte vom Git holen
	if [[ $SCRIPTCOPY = "yes" ]]; then
		log info "SCRIPTCOPY: Script Assets werden vom GIT geholt"
		git clone https://github.com/BigManzai/opensim-ossl-example-scripts /$STARTVERZEICHNIS/opensim-ossl-example-scripts-main
	else
		log error "SCRIPTCOPY: Script Assets sind nicht vorhanden"
	fi
	return 0
}

### !  gitcopy, Dateien vom Github kopieren.
function configuregitcopy() {
	#Money und Scripte vom Git holen
	if [[ $CONFIGURECOPY = "yes" ]]; then
		log info "CONFIGURECOPY: Configure wird vom GIT geholt"
		git clone https://github.com/BigManzai/opensim-configuration-addon-modul
	else
		log error "CONFIGURECOPY: Configure ist nicht vorhanden"
	fi
	return 0
}

### !  gitcopy, Dateien vom Github kopieren.
function searchgitcopy() {
	#OpenSimSearch vom Git holen
	if [[ $OSSEARCHCOPY = "yes" ]]; then
		log info "COPY: OpenSimSearch wird vom GIT geholt"
		git clone https://github.com/BigManzai/OpenSimSearch
	else
		log error "COPY: OpenSimSearch ist nicht vorhanden"
	fi
	return 0
}

### !  scriptcopy, lsl ossl scripte kopieren.
function scriptcopy() {
	if [[ $SCRIPTCOPY = "yes" ]]; then
		if [ -d /$STARTVERZEICHNIS/$SCRIPTSOURCE/ ]; then
			log info "SCRIPTCOPY: Script Assets werden kopiert"
			cp -r /$STARTVERZEICHNIS/$SCRIPTSOURCE/assets /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/bin
			cp -r /$STARTVERZEICHNIS/$SCRIPTSOURCE/inventory /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/bin
			log line
		else
			# entpacken und kopieren
			log info "SCRIPTCOPY: Script Assets werden entpackt"
			unzip "$SCRIPTZIP"
			log info "SCRIPTCOPY: Script Assets werden kopiert"
			cp -r /$STARTVERZEICHNIS/$SCRIPTSOURCE/assets /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/bin
			cp -r /$STARTVERZEICHNIS/$SCRIPTSOURCE/inventory /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/bin
			log line
		fi
	else
		log warn "SCRIPTCOPY: Skripte werden nicht kopiert."
	fi
	return 0
}

### !  moneycopy, Money Dateien kopieren.
function moneycopy() {
	if [[ $MONEYCOPY = "yes" ]]; then
		if [ -d /$STARTVERZEICHNIS/$MONEYSOURCE/ ]; then
			log info "MONEYCOPY: Money Kopiervorgang gestartet"
			cp -r /$STARTVERZEICHNIS/$MONEYSOURCE/bin /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS
			cp -r /$STARTVERZEICHNIS/$MONEYSOURCE/addon-modules /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS
			log line
		else
			# Entpacken und kopieren
			log info "MONEYCOPY: Money entpacken"
			unzip "$MONEYZIP"
			log info "MONEYCOPY: Money Kopiervorgang gestartet"
			cp -r /$STARTVERZEICHNIS/$MONEYSOURCE/bin /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS
			cp -r /$STARTVERZEICHNIS/$MONEYSOURCE/addon-modules /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS
		fi
	else
		log warn "SCRIPTCOPY: Money wird nicht kopiert."
	fi
	return 0
}

### ! configurecopy
function configurecopy() {
	if [[ $CONFIGURECOPY = "yes" ]]; then
		##/opt/opensim-configuration-addon-modul/Configuration
		if [ -d /opt/opensim-configuration-addon-modul ]; then
			log info "CONFIGURECOPY: Configure Kopiervorgang gestartet"
			cp -r /opt/opensim-configuration-addon-modul/Configuration /opt/opensim/addon-modules
			//mv /opt/opensim/addon-modules/opensim-configuration-addon-modul /opt/opensim/addon-modules/Configuration

			log line
		else
			# Entpacken und kopieren
			log info "CONFIGURECOPY: Configure entpacken"
			unzip "$CONFIGUREZIP"
			log info "CONFIGURECOPY: Configure Kopiervorgang gestartet"
			cp -r /opt/opensim-configuration-addon-modul/Configuration /$STARTVERZEICHNIS/opensim/addon-modules
			//mv /opt/opensim/addon-modules/opensim-configuration-addon-modul /opt/opensim/addon-modules/Configuration
			log line
		fi
	else
		log warn "CONFIGURE: Configure wird nicht kopiert."
	fi
	return 0
}

### !  pythoncopy, Plugin Daten kopieren.
function pythoncopy() {
	if [[ $PYTHONCOPY = "yes" ]]; then
		if [ -d /$STARTVERZEICHNIS/OpensimPython/ ]; then
			log info "PYTHONCOPY: python wird kopiert"
			cp -r /$STARTVERZEICHNIS/OpensimPython /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/addon-modules
		else
			log warn "PYTHONCOPY: python ist nicht vorhanden"
		fi
	else
		log warn "PYTHONCOPY: Python wird nicht kopiert."
	fi
	return 0
}

### !  searchcopy, Plugin Daten kopieren.
function searchcopy() {
	if [[ $SEARCHCOPY = "yes" ]]; then
		if [ -d /$STARTVERZEICHNIS/OpenSimSearch/ ]; then
			log info "OpenSimSearch: python wird kopiert"
			cp -r /$STARTVERZEICHNIS/OpenSimSearch /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/addon-modules
			log line
		else
			log info "OpenSimSearch: python ist nicht vorhanden"
		fi
	else
		log info "OpenSimSearch: OpenSimSearch wird nicht kopiert."
	fi
	return 0
}

### !  mutelistcopy, Plugin Daten kopieren.
function mutelistcopy() {
	if [[ $MUTELISTCOPY = "yes" ]]; then
		if [ -d /$STARTVERZEICHNIS/OpenSimMutelist/ ]; then
			log info "OpenSimMutelist: python wird kopiert"
			cp -r /$STARTVERZEICHNIS/OpenSimMutelist /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/addon-modules
			log line
		else
			log error "OpenSimMutelist: python ist nicht vorhanden"
		fi
	else
		log warn "OpenSimMutelist: OpenSimMutelist wird nicht kopiert."
	fi
	return 0
}

### !  chrisoscopy, Plugin Dateien kopieren.
function chrisoscopy() {
	if [[ $CHRISOSCOPY = "yes" ]]; then
		# /opt/Chris.OS.Additions
		if [ -d /$STARTVERZEICHNIS/Chris.OS.Additions/ ]; then
			log info "CHRISOSCOPY: Chris.OS.Additions Kopiervorgang gestartet"
			cp -r /$STARTVERZEICHNIS/Chris.OS.Additions /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/addon-modules
			log line
		else
			log error "CHRISOSCOPY: Chris.OS.Additions ist nicht vorhanden"
		fi
	else
		log warn "CHRISOSCOPY: Chris.OS.Additions werden nicht kopiert."
	fi
	return 0
}

### !  makeaot, aot generieren.
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

### !  cleanaot, aot entfernen. Test
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

### !  osprebuild, Prebuild einstellen # Aufruf Beispiel: opensim.sh prebuild 1330.
# Ergebnis ist eine Einstellung fuer Release mit dem Namn OpenSim 0.9.2.1330
# sed -i schreibt sofort - s/Suchwort/Ersatzwort/g - /Verzeichnis/Dateiname.Endung
function osprebuild() {
	NUMMER=$1
	log info "PREBUILD: Version umbenennen und Release auf $NUMMER einstellen"

	echo "V$NUMMER " >/$STARTVERZEICHNIS/opensim/bin/'.version'

	# Nummer einfuegen
	#sed -i s/0.9.2.1/0.9.2.1."$NUMMER"/g /$STARTVERZEICHNIS/opensim/OpenSim/Framework/VersionInfo.cs
	# Release setzen
	#sed -i s/Flavour.Dev/Flavour.Release/g /$STARTVERZEICHNIS/opensim/OpenSim/Framework/VersionInfo.cs
	# Yeti loeschen
	sed -i s/Yeti//g /$STARTVERZEICHNIS/opensim/OpenSim/Framework/VersionInfo.cs
	# flavour loeschen
	sed -i s/' + flavour'//g /$STARTVERZEICHNIS/opensim/OpenSim/Framework/VersionInfo.cs
	return 0
}

### !  osstruktur, legt die Verzeichnisstruktur fuer OpenSim an. # Aufruf: opensim.sh osstruktur ersteSIM letzteSIM
# Beispiel: ./opensim.sh osstruktur 1 10 - erstellt ein Grid Verzeichnis fuer 10 Simulatoren inklusive der SimulatorList.ini.
function osstruktur() {
	if [ ! -f "/$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/" ]; then
		log info "OSSTRUKTUR: Lege robust an im Verzeichnis $ROBUSTVERZEICHNIS"
		mkdir -p /$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS/bin
	else
		log error "OSSTRUKTUR: Verzeichnis $ROBUSTVERZEICHNIS existiert bereits"
	fi
	for ((i = $1; i <= $2; i++)); do
		echo "Lege sim$i an"
		mkdir -p /$STARTVERZEICHNIS/sim"$i"/bin
		echo "Schreibe sim$i in $SIMDATEI"
		# xargs sollte leerzeichen entfernen.
		printf 'sim'"$i"'\t%s\n' | xargs >>/$STARTVERZEICHNIS/$SIMDATEI
	done
	log info "OSSTRUKTUR: Lege robust an ,Schreibe sim$i in $SIMDATEI"
	return 0
}

### !  menuosstruktur() ist die dialog Version von osstruktur()
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
		echo "Keine Menuelose Funktion" | exit
	fi # dialog Aktionen Ende

	if [ ! -f "/$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/" ]; then
		log info "OSSTRUKTUR: Lege robust an im Verzeichnis $ROBUSTVERZEICHNIS"
		mkdir -p /$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS/bin
	else
		log error "OSSTRUKTUR: Verzeichnis $ROBUSTVERZEICHNIS existiert bereits"
	fi
	# shellcheck disable=SC2004
	for ((i = $EINGABE; i <= $EINGABE2; i++)); do
		echo "Lege sim$i an"
		mkdir -p /$STARTVERZEICHNIS/sim"$i"/bin
		echo "Schreibe sim$i in $SIMDATEI"
		printf 'sim'"$i"'\t%s\n' >>/$STARTVERZEICHNIS/$SIMDATEI
	done
	log info "OSSTRUKTUR: Lege robust an ,Schreibe sim$i in $SIMDATEI"
	return 0
}

### !  osdelete, altes opensim loeschen und letztes opensim als Backup umbenennen.
function osdelete() {
	if [ -d /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/ ]; then
		log info "OSDELETE: Loesche altes opensim1 Verzeichnis"
		cd /$STARTVERZEICHNIS || return 1
		rm -r /$STARTVERZEICHNIS/opensim1
		log info "OSDELETE: Umbenennen von $OPENSIMVERZEICHNIS nach opensim1 zur sicherung"
		mv /$STARTVERZEICHNIS/opensim /$STARTVERZEICHNIS/opensim1
		log line

	else
		log error "$STARTVERZEICHNIS Verzeichnis existiert nicht"
	fi
	return 0
}

### !  oscopyrobust, Robust Daten kopieren.
function oscopyrobust() {
	cd /$STARTVERZEICHNIS || return 1
	if [ -d /$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS/ ]; then
		log line
		log info "Kopiere Robust, Money!"
		sleep 2		
		cd /$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS/bin || return 1
		cp -r /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/bin /$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS
		log info "Robust und Money wurden kopiert"
		log line
	else
		log line
	fi
	return 0
}

### !  oscopysim, Simulatoren kopieren aus dem Verzeichnis opensim.
function oscopysim() {
	cd /$STARTVERZEICHNIS || return 1
	makeverzeichnisliste
	#log info "Kopiere Simulatoren!"
	#log line
	sleep 2
	for ((i = 0; i < "$ANZAHLVERZEICHNISSLISTE"; i++)); do
		log info "OpenSimulator ${VERZEICHNISSLISTE[$i]} kopiert"
		cd /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin || return 1
		cp -r /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/bin /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"
		sleep 2
	done
	return 0
}

### !  oscopysim, Simulatoren kopieren aus dem Verzeichnis opensim.
function oscopy() {
	cd /$STARTVERZEICHNIS || return 1
	VERZEICHNIS=$1
	log info "Kopiere Simulator $VERZEICHNIS "
	cd /$STARTVERZEICHNIS/"$VERZEICHNIS"/bin || return 1
	cp -r /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/bin /$STARTVERZEICHNIS/"$VERZEICHNIS"
	return 0
}

### !  configlesen, Regionskonfigurationen lesen. # Beispiel: configlesen sim1
function configlesen() {
	log info "CONFIGLESEN: Regionskonfigurationen von $CONFIGLESENSCREEN"
	CONFIGLESENSCREEN=$1
	KONFIGLESEN=$(awk -F":" '// {print $0 }' /$STARTVERZEICHNIS/"$CONFIGLESENSCREEN"/bin/Regions/*.ini) # Regionskonfigurationen aus einem Verzeichnis lesen.
	log info "$KONFIGLESEN"
	return 0
}

### !  regionsconfigdateiliste, schreibt Dateinamen mit Pfad in eine Datei.
# regionsconfigdateiliste -b(Bildschirm) -d(Datei)  Vereichnis
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

### !  meineregionen, listet alle Regionen aus den Konfigurationen auf.
function meineregionen() {
	makeverzeichnisliste
	log info "MEINEREGIONEN: Regionsliste"
	sleep 2
	for ((i = 0; i < "$ANZAHLVERZEICHNISSLISTE"; i++)); do
		VERZEICHNIS="${VERZEICHNISSLISTE[$i]}"
		REGIONSAUSGABE=$(awk -F "[" '/\[/ {print $1 $2 $3}' /$STARTVERZEICHNIS/"$VERZEICHNIS"/bin/Regions/*.ini | sed s/'\]'//g) # Zeigt nur die Regionsnamen aus einer Regions.ini an
		log info "$VERZEICHNIS"
		log info "$REGIONSAUSGABE"
	done
	log info "MEINEREGIONEN: Regionsliste Ende"
	return 0
}

### !  regionsinisuchen, sucht alle Regionen.
function regionsinisuchen() {
	makeverzeichnisliste
	sleep 2

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

### !  get_regionsarray, gibt ein Array aller Regionsabschnitte zurueck.
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

### !  get_value_from_Region_key, gibt den Wert eines bestimmten Schluessels im angegebenen Abschnitt zurueck.
# $1 - Datei - $2 - Schluessel - $3 - Sektion
function get_value_from_Region_key() {
	# RKDATEI=$1; RKSCHLUESSEL=$2; RKSEKTION=$3;
	# Es fehlt eine pruefung ob Datei vorhanden ist.
	# shellcheck disable=SC2005
	#echo "$(sed -nr "/^\[$2\]/ { :l /^$3[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" "$1")" # Nur Parameter
	echo "$(sed -nr "/^\[$2\]/ { :l /$3[ ]}*=/ { p; q;}; n; b l;}" "$1")" # Komplette eintraege
	return 0
}

### ! Regions.ini zerlegen
## Funktion regionsiniteilen, holt aus der Regions.ini eine Region heraus und speichert sie mit ihrem Regionsnamen.
# Aufruf: regionsiniteilen Verzeichnis Regionsname
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

### !  autoregionsiniteilen, Die gemeinschaftsdatei Regions.ini in einzelne Regionen teilen.
# diese dann unter dem Regionsnamen speichern, danach die Alte Regions.ini umbenennen in Regions.ini.old.
function autoregionsiniteilen() {
	makeverzeichnisliste
	sleep 2
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
			sleep 2
			echo "regionsiniteilen $VERZEICHNIS $MeineRegion"
		done
		#  Dann umbenennen:
		# Pruefung ob Datei vorhanden ist, wenn ja umbenennen.
		if [ ! -d "$INI_FILE" ]; then
			mv /$STARTVERZEICHNIS/"$INIVERZEICHNIS"/bin/Regions/Regions.ini /$STARTVERZEICHNIS/"$INIVERZEICHNIS"/bin/Regions/"$DATUM"-Regions.ini.old
		fi
	done
	return 0
}

### !  regionliste, Die RegionListe ermitteln und mit dem Verzeichnisnamen in die RegionList.ini schreiben.
function regionliste() {
	# Alte RegionList.ini sichern und in RegionList.ini.old umbenennen.
	if [ -f "/$STARTVERZEICHNIS/RegionList.ini" ]; then
		if [ -f "/$STARTVERZEICHNIS/RegionList.ini.old" ]; then
			rm -r /$STARTVERZEICHNIS/RegionList.ini.old
		fi
		mv /$STARTVERZEICHNIS/RegionList.ini /$STARTVERZEICHNIS/RegionList.ini.old
	fi
	# Die mit regionsconfigdateiliste erstellte Datei RegionList.ini nach sim Verzeichnis und Regionsnamen in die RegionList.ini speichern.
	declare -A Dateien # Array erstellen
	makeverzeichnisliste
	sleep 2
	for ((i = 0; i < "$ANZAHLVERZEICHNISSLISTE"; i++)); do
		log info "Regionnamen ${VERZEICHNISSLISTE[$i]} schreiben"
		VERZEICHNIS="${VERZEICHNISSLISTE[$i]}"
		# shellcheck disable=SC2178
		Dateien=$(find /$STARTVERZEICHNIS/"$VERZEICHNIS"/bin/Regions/ -name "*.ini")
		for i2 in "${Dateien[@]}"; do # Array abarbeiten
			echo "$i2" >>RegionList.ini
		done
	done
	# Ueberfluessige Zeichen entfernen
	LOESCHEN=$(sed s/'\/opt\/'//g /$STARTVERZEICHNIS/RegionList.ini)              # /opt/ entfernen.
	echo "$LOESCHEN" >/$STARTVERZEICHNIS/RegionList.ini                           # Aenderung /opt/ speichern.
	LOESCHEN=$(sed s/'\/bin\/Regions\/'/' "'/g /$STARTVERZEICHNIS/RegionList.ini) # /bin/Regions/ entfernen.
	echo "$LOESCHEN" >/$STARTVERZEICHNIS/RegionList.ini                           # Aenderung /bin/Regions/ speichern.
	LOESCHEN=$(sed s/'.ini'/'"'/g /$STARTVERZEICHNIS/RegionList.ini)              # Endung .ini entfernen.
	echo "$LOESCHEN" >/$STARTVERZEICHNIS/RegionList.ini                           # Aenderung .ini entfernen speichern.
	# Schauen ob da noch Regions.ini bei sind also Regionen mit dem Namen Regions, diese Zeilen loeschen.
	LOESCHEN=$(sed '/Regions/d' /$STARTVERZEICHNIS/RegionList.ini) # Alle Zeilen mit dem Eintrag Regions entfernen	.
	echo "$LOESCHEN" >/$STARTVERZEICHNIS/RegionList.ini            # Aenderung .ini entfernen speichern.
	return 0
}

### !  makewebmaps
function makewebmaps() {
	MAPTILEVERZEICHNIS="maptiles"
	log info "MAKEWEBMAPS: Kopiere Maptile"
	# Verzeichnis erstellen wenn es noch nicht vorhanden ist.
	mkdir -p /var/www/html/$MAPTILEVERZEICHNIS/
	# Maptiles kopieren
	find /$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS/bin/maptiles -type f -exec cp -a -t /var/www/html/$MAPTILEVERZEICHNIS/ {} +
	return 0
}

### !  moneydelete, loescht den MoneyServer ohne die OpenSim Config zu veraendern.
function moneydelete() {
	makeverzeichnisliste
	sleep 2
	# MoneyServer aus den sims entfernen
	for ((i = 0; i < "$ANZAHLVERZEICHNISSLISTE"; i++)); do
		cd /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin || return 1               # Pruefen ob Verzeichnis vorhanden ist.
		rm -r /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/MoneyServer.exe.config # Dateien loeschen.
		rm -r /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/MoneyServer.ini.example
		rm -r /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/OpenSim.Data.MySQL.MySQLMoneyDataWrapper.dll
		rm -r /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/OpenSim.Modules.Currency.dll
		log info "MONEYDELETE: MoneyServer ${VERZEICHNISSLISTE[$i]} geloescht"
		sleep 2
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

### !  osgitholen, kopiert eine Entwicklerversion in das opensim Verzeichnis.
function osgitholen() {
	if [ -d /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/ ]; then
		echo "$(tput setaf 1) $(tput setaf 7)Kopieren der Entwicklungsversion des OpenSimulator aus dem Git$(tput sgr 0)"
		log info "##############################"
		cd /$STARTVERZEICHNIS || return 1
		rm -r /$STARTVERZEICHNIS/opensim1
		mv /$STARTVERZEICHNIS/opensim /$STARTVERZEICHNIS/opensim1
		git clone git://opensimulator.org/git/opensim opensim
		log info "OPENSIMHOLEN: Git klonen"
	else
		echo "$(tput setaf 1) $(tput setaf 7)Kopieren der Entwicklungsversion des OpenSimulator aus dem Git$(tput sgr 0)"
		log info "##############################"
		log info "Kopieren der Entwicklungsversion des OpenSimulator aus dem Git"
		git clone git://opensimulator.org/git/opensim opensim
	fi
	return 0
}

### !  opensimholen, holt den OpenSimulator in das Arbeitsverzeichnis.
function opensimholen() {
	if [ -d /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/ ]; then
		log info "Kopieren des OpenSimulator in das Arbeitsverzeichnis"
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
		log info "Kopieren des OpenSimulator in das Arbeitsverzeichnis"

		echo "$OPENSIMDOWNLOAD$OPENSIMVERSION"
		wget $OPENSIMDOWNLOAD$OPENSIMVERSION.zip
		echo "$OPENSIMVERSION"
		unzip $OPENSIMVERSION
		mv /$STARTVERZEICHNIS/$OPENSIMVERSION /$STARTVERZEICHNIS/opensim

		log info "OPENSIMHOLEN: Download"
	fi
	return 0
}

### !Installation von mysqltuner
function install_mysqltuner() {
	cd /$STARTVERZEICHNIS || return 1
	log info "mySQL Tuner Download"
	wget http://mysqltuner.pl/ -O mysqltuner.pl 2>/dev/null
	wget https://raw.githubusercontent.com/major/MySQLTuner-perl/master/basic_passwords.txt -O basic_passwords.txt 2>/dev/null
	wget https://raw.githubusercontent.com/major/MySQLTuner-perl/master/vulnerabilities.csv -O vulnerabilities.csv 2>/dev/null
	mySQLmenu
	return 0
}

### !  regionbackup, backup einer Region.
# regionbackup Screenname "Der Regionsname"
function regionbackup() {
	# Backup Verzeichnis anlegen.
	mkdir -p /$STARTVERZEICHNIS/backup/
	sleep 2
	VERZEICHNISSCREENNAME=$1
	REGIONSNAME=$2
	DATEINAME=${REGIONSNAME//\"/}
	NSDATEINAME=${DATEINAME// /}

	log info "OSBACKUP: Region $NSDATEINAME speichern"
	cd /$STARTVERZEICHNIS/"$VERZEICHNISSCREENNAME"/bin || return 1
	log info "Ich kann nicht pruefen ob die Region im OpenSimulator vorhanden ist."
	log info "Sollte sie nicht vorhanden sein wird root also alle Regionen gespeichert."
	screen -S "$VERZEICHNISSCREENNAME" -p 0 -X eval "stuff 'change region ${REGIONSNAME//\"/}'^M"
	screen -S "$VERZEICHNISSCREENNAME" -p 0 -X eval "stuff 'save oar /$STARTVERZEICHNIS/backup/'$DATUM'-$NSDATEINAME.oar'^M"
	screen -S "$VERZEICHNISSCREENNAME" -p 0 -X eval "stuff 'terrain save /$STARTVERZEICHNIS/backup/'$DATUM'-$NSDATEINAME.png'^M"
	screen -S "$VERZEICHNISSCREENNAME" -p 0 -X eval "stuff 'terrain save /$STARTVERZEICHNIS/backup/'$DATUM'-$NSDATEINAME.raw'^M"
	log info "Region $DATUM-$NSDATEINAME RAW und PNG Terrain wird gespeichert"
	log line
	sleep 10
	if [ ! -f /$STARTVERZEICHNIS/"$VERZEICHNISSCREENNAME"/bin/Regions/"$NSDATEINAME".ini ]; then
		cp -r /$STARTVERZEICHNIS/"$VERZEICHNISSCREENNAME"/bin/Regions/Regions.ini /$STARTVERZEICHNIS/backup/"$DATUM"-"$NSDATEINAME".ini
		log info "OSBACKUP: Region $DATUM-$NSDATEINAME.ini wird gespeichert"
	fi
	if [ ! -f /$STARTVERZEICHNIS/"$VERZEICHNISSCREENNAME"/bin/Regions/"${REGIONSNAME//\"/}".ini ]; then
		cp -r /$STARTVERZEICHNIS/"$VERZEICHNISSCREENNAME"/bin/Regions/Regions.ini /$STARTVERZEICHNIS/backup/"$DATUM"-"$NSDATEINAME".ini
		log info "OSBACKUP: Region $DATUM-$NSDATEINAME.ini wird gespeichert"
	fi
	if [ ! -f /$STARTVERZEICHNIS/"$VERZEICHNISSCREENNAME"/bin/Regions/Regions.ini ]; then
		cp -r /$STARTVERZEICHNIS/"$VERZEICHNISSCREENNAME"/bin/Regions/"$NSDATEINAME".ini /$STARTVERZEICHNIS/backup/"$DATUM"-"$NSDATEINAME".ini
		log info "OSBACKUP: Region $NSDATEINAME.ini wird gespeichert"
	fi
	return 0
}

### !  menuregionbackup() ist die dialog Version von regionbackup()
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
		VERZEICHNISSCREENNAME=$(echo "$regionbackupBOXERGEBNIS" | sed -n '1p')
		REGIONSNAME=$(echo "$regionbackupBOXERGEBNIS" | sed -n '2p')

		# Alles loeschen.
		dialogclear
		ScreenLog
	else
		# Alle Aktionen ohne dialog
		echo "Keine Menuelose Funktion" | exit
	fi # dialog Aktionen Ende

	# Backup Verzeichnis anlegen.
	mkdir -p /$STARTVERZEICHNIS/backup/
	sleep 2
	DATEINAME=${REGIONSNAME//\"/}
	NSDATEINAME=${DATEINAME// /}

	log info "OSBACKUP: Region $NSDATEINAME speichern"
	cd /$STARTVERZEICHNIS/"$VERZEICHNISSCREENNAME"/bin || return 1
	log info "Ich kann nicht pruefen ob die Region im OpenSimulator vorhanden ist."
	log info "Sollte sie nicht vorhanden sein wird root also alle Regionen gespeichert."
	screen -S "$VERZEICHNISSCREENNAME" -p 0 -X eval "stuff 'change region ${REGIONSNAME//\"/}'^M"
	screen -S "$VERZEICHNISSCREENNAME" -p 0 -X eval "stuff 'save oar /$STARTVERZEICHNIS/backup/'$DATUM'-$NSDATEINAME.oar'^M"
	screen -S "$VERZEICHNISSCREENNAME" -p 0 -X eval "stuff 'terrain save /$STARTVERZEICHNIS/backup/'$DATUM'-$NSDATEINAME.png'^M"
	screen -S "$VERZEICHNISSCREENNAME" -p 0 -X eval "stuff 'terrain save /$STARTVERZEICHNIS/backup/'$DATUM'-$NSDATEINAME.raw'^M"
	log info "Region $DATUM-$NSDATEINAME RAW und PNG Terrain wird gespeichert"
	log line
	sleep 10
	if [ ! -f /$STARTVERZEICHNIS/"$VERZEICHNISSCREENNAME"/bin/Regions/"$NSDATEINAME".ini ]; then
		cp -r /$STARTVERZEICHNIS/"$VERZEICHNISSCREENNAME"/bin/Regions/Regions.ini /$STARTVERZEICHNIS/backup/"$DATUM"-"$NSDATEINAME".ini
		log info "OSBACKUP: Region $DATUM-$NSDATEINAME.ini wird gespeichert"
	fi
	if [ ! -f /$STARTVERZEICHNIS/"$VERZEICHNISSCREENNAME"/bin/Regions/"${REGIONSNAME//\"/}".ini ]; then
		cp -r /$STARTVERZEICHNIS/"$VERZEICHNISSCREENNAME"/bin/Regions/Regions.ini /$STARTVERZEICHNIS/backup/"$DATUM"-"$NSDATEINAME".ini
		log info "OSBACKUP: Region $DATUM-$NSDATEINAME.ini wird gespeichert"
	fi
	if [ ! -f /$STARTVERZEICHNIS/"$VERZEICHNISSCREENNAME"/bin/Regions/Regions.ini ]; then
		cp -r /$STARTVERZEICHNIS/"$VERZEICHNISSCREENNAME"/bin/Regions/"$NSDATEINAME".ini /$STARTVERZEICHNIS/backup/"$DATUM"-"$NSDATEINAME".ini
		log info "OSBACKUP: Region $NSDATEINAME.ini wird gespeichert"
	fi
	return 0
}

### !  regionrestore, hochladen einer Region.
# regionrestore Screenname "Der Regionsname"
# Ich kann nicht pruefen ob die Region im OpenSimulator vorhanden ist.
# Sollte sie nicht vorhanden sein wird root (Alle) oder die letzte ausgewaehlte Region wiederhergestellt. Dies zerstoert eventuell vorhandene Regionen.
function regionrestore() {
	VERZEICHNISSCREENNAME=$1
	REGIONSNAME=$2
	DATEINAME=${REGIONSNAME//\"/}
	NSDATEINAME=${DATEINAME// /}

	log info "OSRESTORE: Region $NSDATEINAME wiederherstellen"
	cd /$STARTVERZEICHNIS/"$VERZEICHNISSCREENNAME"/bin || return 1
	log info "Ich kann nicht pruefen ob die Region im OpenSimulator vorhanden ist."
	log info "Sollte sie nicht vorhanden sein wird root also alle Regionen wiederhergestellt."
	screen -S "$VERZEICHNISSCREENNAME" -p 0 -X eval "stuff 'change region ${REGIONSNAME//\"/}'^M"
	screen -S "$VERZEICHNISSCREENNAME" -p 0 -X eval "stuff 'load oar /$STARTVERZEICHNIS/backup/'$DATUM'-$NSDATEINAME.oar'^M"

	log info "OSRESTORE: Region $DATUM-$NSDATEINAME wird wiederhergestellt"
	log line
	return 0
}

### !  menuregionrestore() ist die dialog Version von regionrestore()
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
		VERZEICHNISSCREENNAME=$(echo "$regionrestoreBOXERGEBNIS" | sed -n '1p')
		REGIONSNAME=$(echo "$regionrestoreBOXERGEBNIS" | sed -n '2p')

		# Alles loeschen.
		dialogclear
		ScreenLog
	else
		# Alle Aktionen ohne dialog
		echo "Keine Menuelose Funktion" | exit
	fi # dialog Aktionen Ende

	DATEINAME=${REGIONSNAME//\"/}
	NSDATEINAME=${DATEINAME// /}

	log info "OSRESTORE: Region $NSDATEINAME wiederherstellen"
	cd /$STARTVERZEICHNIS/"$VERZEICHNISSCREENNAME"/bin || return 1
	log info "Ich kann nicht pruefen ob die Region im OpenSimulator vorhanden ist."
	log info "Sollte sie nicht vorhanden sein wird root also alle Regionen wiederhergestellt."
	screen -S "$VERZEICHNISSCREENNAME" -p 0 -X eval "stuff 'change region ${REGIONSNAME//\"/}'^M"
	screen -S "$VERZEICHNISSCREENNAME" -p 0 -X eval "stuff 'load oar /$STARTVERZEICHNIS/backup/'$DATUM'-$NSDATEINAME.oar'^M"

	log info "OSRESTORE: Region $DATUM-$NSDATEINAME wird wiederhergestellt"
	log line
	return 0
}

### !  autosimstart, automatischer sim start ohne Robust und Money.
function autosimstart() {
	if ! screen -list | grep -q 'sim'; then
		# es laeuft kein Simulator - not work
		makeverzeichnisliste
		sleep 2
		for ((i = 0; i < "$ANZAHLVERZEICHNISSLISTE"; i++)); do
			log info "Regionen ${VERZEICHNISSLISTE[$i]} werden gestartet"
			cd /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin || return 1

			# AOT Aktiveren oder Deaktivieren.
			if [[ $SETAOTON = "yes" ]]; then
				screen -fa -S "${VERZEICHNISSLISTE[$i]}" -d -U -m mono --desktop -O=all OpenSim.exe
			else

				screen -fa -S "${VERZEICHNISSLISTE[$i]}" -d -U -m mono OpenSim.exe
			fi
			sleep $STARTWARTEZEIT
		done
	else
		# es laeuft mindestens ein Simulator - work
		log text "WORKS:  Regionen laufen bereits!"
	fi
	return 0
}

### !  autosimstop, stoppen aller laufenden Simulatoren.
function autosimstop() {
	makeverzeichnisliste
	sleep 2
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
### !  autosimstart, automatischer sim start ohne Robust und Money.
function menuautosimstart() {
	if ! screen -list | grep -q 'sim'; then
		# es laeuft kein Simulator - not work
		makeverzeichnisliste
		sleep 2
		for ((i = 0; i < "$ANZAHLVERZEICHNISSLISTE"; i++)); do
			log info "Regionen ${VERZEICHNISSLISTE[$i]} werden gestartet"
			cd /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin || return 1

			# AOT Aktiveren oder Deaktivieren.
			if [[ $SETAOTON = "yes" ]]; then
				#BERECHNUNG1=$((100 / "$ANZAHLVERZEICHNISSLISTE"))
				#BALKEN1=$(("$i" * "$BERECHNUNG1"))
				screen -fa -S "${VERZEICHNISSLISTE[$i]}" -d -U -m mono --desktop -O=all OpenSim.exe | log info "${VERZEICHNISSLISTE[$i]} wurde gestartet" # dialog --gauge "Auto Sim start..." 6 64 $BALKEN1
				#dialogclear
			else
				#BERECHNUNG1=$((100 / "$ANZAHLVERZEICHNISSLISTE"))
				#BALKEN1=$(("$i" * "$BERECHNUNG1"))
				screen -fa -S "${VERZEICHNISSLISTE[$i]}" -d -U -m mono OpenSim.exe | log info "${VERZEICHNISSLISTE[$i]} wurde gestartet" # dialog --gauge "Auto Sim start..." 6 64 $BALKEN1
				#dialogclear

			fi
			sleep $STARTWARTEZEIT
		done
	else
		# es laeuft mindestens ein Simulator - work
		log error "Regionen laufen bereits!"
	fi
	return 0
}

### !  autosimstop, stoppen aller laufenden Simulatoren.
function menuautosimstop() {
	makeverzeichnisliste
	sleep 2
	for ((i = 0; i < "$ANZAHLVERZEICHNISSLISTE"; i++)); do
		if screen -list | grep -q "${VERZEICHNISSLISTE[$i]}"; then
			log text "Regionen ${VERZEICHNISSLISTE[$i]} Beenden"

			#BALKEN2=$(("$i"*5))
			#TMP2=$(("$ANZAHLVERZEICHNISSLISTE"*"$i"))
			#BALKEN2=$(("$TMP2/100"))
			#BERECHNUNG2=$((100 / "$ANZAHLVERZEICHNISSLISTE"))
			#BALKEN2=$(("$i" * "$BERECHNUNG2"))
			#BALKEN2=$(( (100/"$ANZAHLVERZEICHNISSLISTE") * "${VERZEICHNISSLISTE[$i]}"))

			screen -S "${VERZEICHNISSLISTE[$i]}" -p 0 -X eval "stuff 'shutdown'^M" | log info "${VERZEICHNISSLISTE[$i]} wurde gestoppt" #| dialog --gauge "Alle Simulatoren werden gestoppt!" 6 64 $BALKEN2
			#dialogclear
			sleep $STOPWARTEZEIT
		else
			log error "Regionen ${VERZEICHNISSLISTE[$i]}  laeuft nicht!"
		fi
	done
	return 0
}

### !  autologdel, automatisches loeschen aller log Dateien.
# Die Dateien samt neuer Daten werden beim naechsten start des opensimulator neu geschrieben.
function autologdel() {
	log line
	makeverzeichnisliste
	sleep 2
	for ((i = 0; i < "$ANZAHLVERZEICHNISSLISTE"; i++)); do
		rm /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/*.log 2>/dev/null || log warn "Die Log Datei ${VERZEICHNISSLISTE[$i]} ist nicht vorhanden! "
		log info "OpenSimulator log Datei ${VERZEICHNISSLISTE[$i]} geloescht"
		sleep 2
	done

	# schauen ist Robust und Money da dann diese Logs auch loeschen!
	if [[ ! $ROBUSTVERZEICHNIS == "robust" ]]; then
		log warn "Robust Log Dateien loeschen!"
		log warn "Money Log Dateien loeschen!"
		rm /$STARTVERZEICHNIS/robust/bin/*.log 2>/dev/null || return 0
	fi
	# if [[ ! $MONEYVERZEICHNIS == "money" ]]
	# then
	# 	rm /$STARTVERZEICHNIS/money/bin/*.log || log line
	# fi

	return 0
}

### !  menuautologdel
function menuautologdel() {
	log line
	makeverzeichnisliste
	sleep 2
	for ((i = 0; i < "$ANZAHLVERZEICHNISSLISTE"; i++)); do
		#BERECHNUNG3=$((100 / "$ANZAHLVERZEICHNISSLISTE"))
		#BALKEN3=$(("$i" * "$BERECHNUNG3"))
		rm /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/*.log #| log info "" # dialog --gauge "Auto Sim stop..." 6 64 $BALKEN3
		#dialogclear || return 0
		log info "OpenSimulator log ${VERZEICHNISSLISTE[$i]} geloescht"
		sleep 2
	done

	# schauen ist Robust und Money da dann diese Logs auch loeschen!
	if [[ ! $ROBUSTVERZEICHNIS == "robust" ]]; then
		log warn "Robust Log Dateien loeschen!"
		log warn "Money Log Dateien loeschen!"
		rm /$STARTVERZEICHNIS/robust/bin/*.log 2>/dev/null || log error " menuautologdel: Ich kann die Robust und Money Log Dateien nicht loeschen! "
	fi
}

### !  automapdel, automatisches loeschen aller Map/Karten Dateien.
# Die Dateien samt neuer Daten werden beim naechsten start des opensimulator neu geschrieben.
function automapdel() {
	makeverzeichnisliste
	sleep 2
	for ((i = 0; i < "$ANZAHLVERZEICHNISSLISTE"; i++)); do
		cd /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin || return 1
		rm -r maptiles/* || echo " "
		log warn "OpenSimulator maptile ${VERZEICHNISSLISTE[$i]} geloescht"
		sleep 2
	done
	autorobustmapdel
	return 0
}

### !  autorobustmapdel, automatisches loeschen aller Map/Karten Dateien in Robust.
# Die Dateien samt neuer Daten werden beim naechsten start des opensimulator neu geschrieben.
function autorobustmapdel() {
	cd /$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS/bin || return 1
	rm -r maptiles/* || log line
	log warn "OpenSimulator maptile aus $ROBUSTVERZEICHNIS geloescht"
	return 0
}

### !  cleaninstall, loeschen aller externen addon Module.
function cleaninstall() {

	if [ ! -f "/$STARTVERZEICHNIS/opensim/addon-modules/" ]; then
		rm -r $STARTVERZEICHNIS/opensim/addon-modules/*
	else
		log error "addon-modules Verzeichnis existiert nicht"
	fi
	return 0
}

### !  allclean, loescht Log, dll, so, exe, aot Dateien fuer einen saubere neue installation, ohne Robust.
# Hierbei werden keine Datenbanken oder Konfigurationen geloescht aber opensim ist anschliessend nicht mehr startbereit.
# Um opensim wieder Funktionsbereit zu machen muss ein Upgrade oder ein oscopy vorgang ausgefuehrt werden.
# allclean Verzeichnis
function allclean() {
	if [ -d "$1" ]; then
		rm /$STARTVERZEICHNIS/"$1"/bin/*.log
		rm /$STARTVERZEICHNIS/"$1"/bin/*.dll
		rm /$STARTVERZEICHNIS/"$1"/bin/*.exe
		rm /$STARTVERZEICHNIS/"$1"/bin/*.so
		rm /$STARTVERZEICHNIS/"$1"/bin/*.xml
		rm /$STARTVERZEICHNIS/"$1"/bin/*.dylib
		rm /$STARTVERZEICHNIS/"$1"/bin/*.example
		rm /$STARTVERZEICHNIS/"$1"/bin/*.sample
		rm /$STARTVERZEICHNIS/"$1"/bin/*.txt
		rm /$STARTVERZEICHNIS/"$1"/bin/*.config
		rm /$STARTVERZEICHNIS/"$1"/bin/*.py
		rm /$STARTVERZEICHNIS/"$1"/bin/*.old
		log warn "clean: Dateien in $1 geloescht"
	else
		log error "clean: Dateien in $1 nicht gefunden"
	fi
	return 0
}

### !  autoallclean, loescht Log, dll, so, exe, aot Dateien fuer einen saubere neue installation, mit Robust.
# Hierbei werden keine Datenbanken oder Konfigurationen geloescht.
# Hierbei werden keine Datenbanken oder Konfigurationen geloescht aber opensim ist anschliessend nicht mehr startbereit.
# Um opensim wieder Funktionsbereit zu machen muss ein Upgrade oder ein oscopy vorgang ausgefuehrt werden.
function autoallclean() {
	makeverzeichnisliste
	sleep 2
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

		# Verzeichnisse leeren
		rm -r /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/assetcache/*
		rm -r /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/maptiles/*
		rm -r /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/MeshCache/*
		rm -r /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/j2kDecodeCache/*
		rm -r /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/ScriptEngines/*
		log warn "autoallclean: ${VERZEICHNISSLISTE[$i]} geloescht"
		sleep 2
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

	rm -r /$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS/bin/assetcache/*
	rm -r /$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS/bin/maptiles/*
	rm -r /$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS/bin/MeshCache/*
	rm -r /$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS/bin/j2kDecodeCache/*
	rm -r /$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS/bin/ScriptEngines/*
	return 0
}

### !  autoregionbackup, automatischer Backup aller Regionen die in der Regionsliste eingetragen sind.
function autoregionbackup() {
	log info "Automatisches Backup wird gestartet."
	makeregionsliste
	sleep 2
	for ((i = 0; i < "$ANZAHLREGIONSLISTE"; i++)); do
		derscreen=$(echo "${REGIONSLISTE[$i]}" | cut -d ' ' -f 1)
		dieregion=$(echo "${REGIONSLISTE[$i]}" | cut -d ' ' -f 2)
		regionbackup "$derscreen" "$dieregion"
		sleep $BACKUPWARTEZEIT
	done
	return 0
}

### !  autoscreenstop, beendet alle laufenden simX screens.
function autoscreenstop() {
	makeverzeichnisliste
	sleep 2

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
### !  menuautoscreenstop
function menuautoscreenstop() {
	makeverzeichnisliste
	sleep 2

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

### !  autostart, startet das komplette Grid mit allen sims.
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

### !  autostop, stoppt das komplette Grid mit allen sims.
function autostop() {
	log warn "### Stoppe das Grid! ###"
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
	log info "die nicht innerhalb von $AUTOSTOPZEIT Sekunden heruntergefahren werden konnten,"
	log info "werden jetzt zwangsbeendet!"
	autoscreenstop
	return 0
}

### !  autostart, startet das komplette Grid mit allen sims.
function menuautostart() {
	echo ""
	if [[ $ROBUSTVERZEICHNIS == "robust" ]]; then
		log info "Bitte warten..."
		menugridstart
	fi
	menuautosimstart
	screenlist
	log info "Auto Start abgeschlossen!"
	return 0
}

### !  autostop, stoppt das komplette Grid mit allen sims.
# function menuautostop() {
# 	# schauen ob screens laufen wenn ja beenden.
# 	# shellcheck disable=SC2022
# 	if ! screen -list | grep -q 'sim'; then
# 		echo ""
# 	else
# 		menuautosimstop
# 	fi

# 	if ! screen -list | grep -q "RO"; then
# 		echo ""
# 	else
# 		menugridstop
# 	fi
# 	# schauen ob screens laufen wenn ja warten.
# 	# shellcheck disable=SC2022
# 	if ! screen -list | grep -q 'sim'; then
# 		echo ""
# 	else
# 		sleep $AUTOSTOPZEIT
# 		killall screen
# 	fi
# 	menuautoscreenstop
# }
### !  autostop, stoppt das komplette Grid mit allen sims.
function menuautostop() {
	# schauen ob screens laufen wenn ja beenden.
	if screen -list | grep -q 'sim'; then log info "Bitte warten..."; menuautosimstop; fi
	if screen -list | grep -q "RO"; then log info "Bitte warten..."; menugridstop; fi
	# schauen ob screens laufen wenn ja warten.
	if screen -list | grep -q 'sim'; then log info "Bitte warten..."; sleep $AUTOSTOPZEIT; killall screen; fi

	menuautoscreenstop
	hauptmenu
}

### ! autorestart, startet das gesamte Grid neu und loescht die log Dateien.
function autorestart() {
	autostop
	if [ "$LOGDELETE" = "yes" ]; then autologdel; rologdel; fi
	gridstart
	autosimstart
	screenlistrestart
	return 0
}
### ! menuautorestart
function menuautorestart() {
	menuautostop
	if [ "$LOGDELETE" = "yes" ]; then menuautologdel; rologdel; fi
	menugridstart
	menuautosimstart
	menuinfo
	log info "Auto Restart abgeschlossen."
}

### ! serverinstall, Ubuntu 18 Server zum Betrieb von OpenSim vorbereiten.
function serverupgrade() {
	sudo apt-get update
	sudo apt-get upgrade
}
### ! Installation oder Migration von MariaDB 10.8.3 oder hoeher fuer Ubuntu 18
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

### ! Installation oder Migration von MariaDB fuer Ubuntu 22
function installmariadb22() {
	# MySQL stoppen wenn es laeuft:
	sudo service mysql stop

	# MariaDB installieren:
	sudo apt-get update
	sudo apt-get -y install mariadb-server

	mariadb --version
}

### ! monoinstall18 alt
### Funktion monoinstall, mono 6.x installieren.
function monoinstall() {
	if dpkg-query -s mono-complete 2>/dev/null | grep -q installed; then
		log info "mono-complete ist installiert."
	else
		log info "mono-complete ist nicht installiert."
		log info "Installation von mono 6.x fuer Ubuntu 18"

		sleep 2

		sudo apt install gnupg ca-certificates
		sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
		echo "deb https://download.mono-project.com/repo/ubuntu stable-bionic main" | sudo tee /etc/apt/sources.list.d/mono-official-stable.list
		sudo apt update
		sudo apt-get -y install mono-complete
		sudo apt-get upgrade
	fi
	return 0
}

### ! monoinstall18
function monoinstall18() {
	if dpkg-query -s mono-complete 2>/dev/null | grep -q installed; then
		echo "mono-complete ist bereits installiert."
	else
		echo "Ich installiere jetzt mono-complete"
		sleep 2

		sudo apt install gnupg ca-certificates
		sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
		echo "deb https://download.mono-project.com/repo/ubuntu stable-bionic main" | sudo tee /etc/apt/sources.list.d/mono-official-stable.list

		sudo apt update
		sudo apt-get -y install mono-complete
		sudo apt-get upgrade
	fi
}

### ! monoinstall20
function monoinstall20() {
	if dpkg-query -s mono-complete 2>/dev/null | grep -q installed; then
		echo "mono-complete ist bereits installiert."
	else
		echo "Ich installiere jetzt mono-complete"
		sleep 2

		sudo apt install gnupg ca-certificates
		sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
		echo "deb https://download.mono-project.com/repo/ubuntu stable-focal main" | sudo tee /etc/apt/sources.list.d/mono-official-stable.list

		sudo apt update
		sudo apt-get -y install mono-complete
		sudo apt-get upgrade
	fi
}

### ! monoinstall22
function monoinstall22() {
	sudo apt install mono-roslyn mono-complete mono-dbg mono-xbuild -y
}

### ! sourcelist18
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

### !  sourcelist22
function sourcelist22() {
	echo "deb http://de.archive.ubuntu.com/ubuntu jammy main restricted universe multiverse"
	echo "#deb-src http://de.archive.ubuntu.com/ubuntu impish main restricted universe multiverse"

	echo "deb http://de.archive.ubuntu.com/ubuntu jammy-updates main restricted universe multiverse"
	echo "#deb-src http://de.archive.ubuntu.com/ubuntu jammy-updates main restricted universe multiverse"

	echo "deb http://de.archive.ubuntu.com/ubuntu jammy-security main restricted universe multiverse"
	echo "#deb-src http://de.archive.ubuntu.com/ubuntu jammy-security main restricted universe multiverse"

	echo "deb http://de.archive.ubuntu.com/ubuntu jammy-backports main restricted universe multiverse"
	echo "#deb-src http://de.archive.ubuntu.com/ubuntu jammy-backports main restricted universe multiverse"
}

### !  installwordpress
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

### !  installobensimulator
function installobensimulator() {
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
}

### !  installbegin
function installbegin() { apt update && apt upgrade; }

### !  linuxupgrade
function linuxupgrade() { apt update && apt upgrade -y; }

### !  installubuntu22
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
}

### !  ufwset
function ufwset() {
	### Uncomplicated Firewall
	#sudo ufw app list

	# Now we will enable Apache Full.
	sudo ufw allow OpenSSH
	sudo ufw allow 'Apache Full'
	sudo ufw enable

	# Test
	#sudo ufw status
	# alles erlauben
	#sudo ufw default allow
	# alles verbieten
	#sudo ufw default deny

	# Port oeffnen robust
	sudo ufw allow 8000/tcp
	sudo ufw allow 8001/tcp
	sudo ufw allow 8002/tcp
	sudo ufw allow 8003/tcp
	sudo ufw allow 8004/tcp
	sudo ufw allow 8005/tcp
	sudo ufw allow 8006/tcp
	sudo ufw allow 8895/tcp

	# Port oeffnen OpenSim
	sudo ufw allow 9000/tcp
	# von 9000 bis 9100 oeffnen
	sudo ufw allow 9000:9100/udp
	# XmlRpcPort = 20800 ?
	sudo ufw allow 20800:20900/udp
}

### !Installieren von PhpMyAdmin
function installphpmyadmin() {
	### Installieren von PhpMyAdmin
	sudo apt install phpmyadmin
}

### !  installfinis
function installfinish() {
	apt update
	apt upgrade
	apt -f install
	# zuerst schauen das nichts mehr laeuft bevor man einfach rebootet
	#reboot now
}

### !HTTPS installieren: installationhttps22 "myemail@server.com" "myworld.com"
function installationhttps22() {
	httpsemail=$1
	httpsdomain=$2
	### HTTPS installieren
	sudo apt install python3-certbot-apache

	# Jetzt haben wir Certbot von Let’s Encrypt fuer Ubuntu 22.04 installiert,
	# fuehren Sie diesen Befehl aus, um Ihre Zertifikate zu erhalten.
	sudo certbot --apache --agree-tos --redirect -m "$httpsemail" -d "$httpsdomain" -d www."$httpsdomain"
}

### !  serverinstall22
function serverinstall22() {
	installbegin
	installubuntu22
	installmono22
	installphpmyadmin
	ufwset
	#installationhttps22
	installfinish
}

### !Auswahl der zu installierenden Pakete (Dies ist meinem Geschmack angepasst)
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
			installobensimulator
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
			installobensimulator
			monoinstall18
			installfinish
		else
			echo "Abbruch"
		fi
	fi
	# dialog Aktionen Ende
}

### !  installationen, Ubuntu 18 Server, Was habe ich alles auf meinem Server Installiert? sortiert auflisten.
function installationen() {
	log info "Liste aller Installierten Pakete unter Linux:"
	dpkg-query -Wf '${Package;-40}${Priority}\n' | sort -b -k2,2 -k1,1
	dpkg-query -Wf '${Package;-40}${Priority}\n' | sort -b -k2,2 -k1,1 >>"/$STARTVERZEICHNIS/$DATEIDATUM$logfilename.log"
	return 0
}

### !  osbuilding, test automation.
# Beispiel: opensim-0.9.2.2Dev-1187-gcf0b1b1.zip
# /opt/opensim.sh osbuilding 1187
function osbuilding() {
	## dialog Aktionen
	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then
		# Alle Aktionen mit dialog
		VERSIONSNUMMER=$(dialog --backtitle "opensimMULTITOOL $VERSION" --title "opensimMULTITOOL Eingabe" --inputbox "Versionsnummer:" 8 40 3>&1 1>&2 2>&3 3>&-)
		dialogclear
		ScreenLog
	else
		# Alle Aktionen ohne dialog
		VERSIONSNUMMER=$1
	fi
	# dialog Aktionen Ende

	cd /$STARTVERZEICHNIS || exit
	log info "OSBUILDING: Alten OpenSimulator sichern"
	osdelete

	log line

	# Neue Versionsnummer: opensim-0.9.2.2Dev-4-g5e9b3b4.zip
	log info "OSBUILDING: Neuen OpenSimulator entpacken"
	unzip $OSVERSION"$VERSIONSNUMMER"-*.zip

	log line

	log info "OSBUILDING: Neuen OpenSimulator umbenennen"
	mv /$STARTVERZEICHNIS/$OSVERSION"$VERSIONSNUMMER"-*/ /$STARTVERZEICHNIS/opensim/

	log line
	sleep 3

	log info "OSBUILDING: Prebuild des neuen OpenSimulator starten"
	osprebuild "$VERSIONSNUMMER"

	log line

	log info "OSBUILDING: Compilieren des neuen OpenSimulator"
	compilieren

	log line
	osupgrade

	return 0
}

### !  create user [first] [last] [passw] [RegionX] [RegionY] [Email] - creates a new user and password
function createuser() {
	VORNAME=$1
	NACHNAME=$2
	PASSWORT=$3
	EMAIL=$4
	userid=$5

	if [ -z "$VORNAME" ]; then echo "Der VORNAME fehlt!"; fi
	if [ -z "$NACHNAME" ]; then echo "Der NACHNAME fehlt!"; fi
	if [ -z "$PASSWORT" ]; then echo "Das PASSWORT fehlt!"; fi
	if [ -z "$EMAIL" ]; then echo "Die EMAIL Adresse fehlt!"; fi

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

### !  menucreateuser() ist die dialog Version von createuser()
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
		echo "Keine Menuelose Funktion" | exit
	fi # dialog Aktionen Ende

	if [ -z "$VORNAME" ]; then echo "Der VORNAME fehlt!"; fi
	if [ -z "$NACHNAME" ]; then echo "Der NACHNAME fehlt!"; fi
	if [ -z "$PASSWORT" ]; then echo "Das PASSWORT fehlt!"; fi
	if [ -z "$EMAIL" ]; then echo "Die EMAIL Adresse fehlt!"; fi

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

# Datenbank Befehle Achtung alles noch nicht ausgereift!!!

### !  db_anzeigen, listet alle erstellten Datenbanken auf.
function db_anzeigen() {
	username=$1
	password=$2
	databasename=$3

	log text "PRINT DATABASE: Alle Datenbanken anzeigen."
	mysqlrest "$username" "$password" "$databasename" "show databases"
	log rohtext "$result_mysqlrest"

	return 0
}
### !  db_anzeigen_dialog, listet alle erstellten Datenbanken auf.
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
		echo "Keine Menuelose Funktion" | exit
	fi # dialog Aktionen Ende

	# Abfrage
	mysqlergebniss=$(echo "show databases;" | MYSQL_PWD=$password mysql -u"$username" -N) 2>/dev/null
	# Ausgabe in Box
	warnbox "$mysqlergebniss"

	return 0
}

### !db_tables tabellenabfrage, listet alle Tabellen in einer Datenbank auf.
function db_tables() {
	username=$1
	password=$2
	databasename=$3

	log text "PRINT DATABASE: tabellenabfrage, listet alle Tabellen in einer Datenbank auf."
	mysqlrest "$username" "$password" "$databasename" "SHOW TABLES FROM $databasename"
	log rohtext "$result_mysqlrest"

	return 0
}
### !db_tables_dialog tabellenabfrage, listet alle Tabellen in einer Datenbank auf.
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
		echo "Keine Menuelose Funktion" | exit
	fi # dialog Aktionen Ende

	mysqlrest "$username" "$password" "$databasename" "SHOW TABLES FROM $databasename"

	warnbox "$result_mysqlrest"

	return 0
}

### !  db_benutzer_anzeigen, alle angelegten Benutzer von mySQL anzeigen.
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

### ! Regionsabfrage, Alle Regionen listen (Dies geht nur im Grid (Grid Datenbank) oder Standalone Modus).
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

### ! Regionsuri, Region URI pruefen sortiert nach URI (Dies geht nur im Grid (Grid Datenbank) oder Standalone Modus).
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

### ! Regionsport, Ports pruefen sortiert nach Ports (Dies geht nur im Grid (Grid Datenbank) oder Standalone Modus).
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

### !  create_db, erstellt eine neue Datenbank.
function create_db() {
	DBBENUTZER=$1
	DBPASSWORT=$2
	DATENBANKNAME=$3

	echo "$(tput setaf 5)CREATE DATABASE: Datenbanken anlegen. $(tput sgr0)"
	echo "$DATUM $(date +%H:%M:%S) CREATE DATABASE: Datenbanken anlegen" >>"/$STARTVERZEICHNIS/$DATEIDATUM$logfilename.log"
	echo "$DBBENUTZER, ********, $DATENBANKNAME" >>"/$STARTVERZEICHNIS/$DATEIDATUM$logfilename.log"

	# 2>/dev/null verhindert die Fehlerausgabe - mysql warning using a password on the command line interface can be insecure. disable.
	mysql -u"$DBBENUTZER" -p"$DBPASSWORT" -e "CREATE DATABASE IF NOT EXISTS $DATENBANKNAME CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci" 2>/dev/null
	# utf8mb4 COLLATE utf8mb4_unicode_ci

	echo "$(tput setaf 5)CREATE DATABASE: Datenbanken $DATENBANKNAME wurde angelegt. $(tput sgr0)"
	echo "$DATUM $(date +%H:%M:%S) CREATE DATABASE: Datenbanken $DATENBANKNAME wurde angelegt" >>"/$STARTVERZEICHNIS/$DATEIDATUM$logfilename.log"

	# Eingabe Variablen loeschen
	unset DBBENUTZER
	unset DBPASSWORT
	unset DATENBANKNAME

	return 0
}

### !  create_db_user - Operation CREATE USER failed - Fehler.
function create_db_user() {
	DBBENUTZER=$1
	DBPASSWORT=$2
	NEUERNAME=$3
	NEUESPASSWORT=$4

	echo "$(tput setaf 5)CREATE DATABASE USER: Datenbankbenutzer anlegen. $(tput sgr0)"
	echo "$DATUM $(date +%H:%M:%S) CREATE DATABASE USER: Datenbankbenutzer anlegen" >>"/$STARTVERZEICHNIS/$DATEIDATUM$logfilename.log"
	echo "$DBBENUTZER, ********, $NEUERNAME, ********" >>"/$STARTVERZEICHNIS/$DATEIDATUM$logfilename.log"

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

### !  delete_db, loescht eine Datenbank.
function delete_db() {
	DBBENUTZER=$1
	DBPASSWORT=$2
	DATENBANKNAME=$3

	echo "$(tput setaf 5)DELETE DATABASE: Datenbank loeschen. $(tput sgr0)"
	echo "$DATUM $(date +%H:%M:%S) DELETE DATABASE: Datenbank loeschen" >>"/$STARTVERZEICHNIS/$DATEIDATUM$logfilename.log"

	echo "$DBBENUTZER, ********, $DATENBANKNAME" >>"/$STARTVERZEICHNIS/$DATEIDATUM$logfilename.log"
	# 2>/dev/null verhindert die Fehlerausgabe - mysql warning using a password on the command line interface can be insecure. disable.
	mysql -u"$DBBENUTZER" -p"$DBPASSWORT" -e "DROP DATABASE $DATENBANKNAME" 2>/dev/null

	# Eingabe Variablen loeschen
	unset DBBENUTZER
	unset DBPASSWORT
	unset DATENBANKNAME

	return 0
}

### !db_empty, loescht eine Datenbank und erstellt diese anschliessend neu. Das ist Datenbank leeren auf die schnelle Art.
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

### !  allrepair_db, CHECK – REPAIR – ANALYZE – OPTIMIZE, alle Datenbanken.
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

### !  mysql_neustart, startet mySQL neu.
function mysql_neustart() {
	log text "MYSQL RESTART: MySQL Neu starten."

	service mysql stop
	sleep 15
	service mysql start
	log text "MYSQL RESTART: Fertig."

	return 0
}

### !db_backup, sichert eine einzelne Datenbank. Neu
function db_backup() {
	username=$1
	password=$2
	databasename=$3

	log text "SAVE DATABASE: Datenbank $databasename sichern."

	mysqldump -u"$username" -p"$password" "$databasename" >/$STARTVERZEICHNIS/"$databasename".sql 2>/dev/null

	log text "SAVE DATABASE: Im Hintergrund wird die Datenbank $databasename jetzt gesichert." # Screen fehlt!

	return 0
}
### ! db_compress_backup, sichert eine einzelne Datenbank mit gz komprimierung. Neu
function db_compress_backup() {
	username=$1
	password=$2
	databasename=$3

	log text "SAVE DATABASE: Datenbank $databasename sichern."

	mysqldump -u"$username" -p"$password" "$databasename" | gzip -c >"$databasename".sql.gz

	log text "SAVE DATABASE: Im Hintergrund wird die Datenbank $databasename jetzt gesichert." # Screen fehlt!

	return 0
}

### ! Backup, eine Datenbanken Tabellenweise speichern. Test OK
## function db_backuptabellen DB_Benutzername DB_Passwort Datenbankname
## Datenbank Tabellenweise sichern im Verzeichnis Datenbankname
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

### ! Backup Test, eine Datenbanken Tabellenweise wiederherstellen.
## function db_restorebackuptabellen DB_Benutzername DB_Passwort AlterDatenbankname NeuerDatenbankname
## Die Tabellenweise gesicherte Datenbank in einer neuen Datenbank zusammensetzen.
function db_restorebackuptabellen() {
	username=$1
	password=$2
	databasename=$3
	newdatabasename=$4

	cd /$STARTVERZEICHNIS/backup/"$databasename" || exit

	tabellenname=()
	while IFS= read -r tabellenname; do
		sleep 2
		unzip -p /"$STARTVERZEICHNIS"/backup/"$databasename"/"$tabellenname".sql.zip | mysql >MYSQL_PWD="$password" -u"$username" "$newdatabasename"
		log info "Datenbank Tabelle: $newdatabasename - $tabellenname widerhergestellt."
	done </$STARTVERZEICHNIS/backup/"$databasename"/liste.txt

	return 0
}
### ! Backup Test, eine Datenbanken Tabellenweise wiederherstellen.
## function db_restorebackuptabellen DB_Benutzername DB_Passwort AlterDatenbankname NeuerDatenbankname
## Die Tabellenweise gesicherte Datenbank in einer neuen Datenbank zusammensetzen.
function db_restorebackuptabellen2test() {
	username=$1
	password=$2
	databasename=$3
	newdatabasename=$4

	cd /$STARTVERZEICHNIS/backup/"$databasename" || exit

	tabellenname=()
	while IFS= read -r tabellenname; do
		sleep 2		
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

### !create_db, erstellt eine neue Datenbank. db_create "username" "password" "databasename"
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

# Test funktioniert
### !  db_dbuser, listet alle erstellten Datenbankbenutzer auf.
function db_dbuser() {
	username=$1
	password=$2

	log text "PRINT DATABASE: Alle Datenbankbenutzer anzeigen."
	result_mysqlrest=$(echo "select User from mysql.user;" | MYSQL_PWD=$password mysql -u"$username" -N) 2>/dev/null
	log rohtext "$result_mysqlrest"

	return 0
}

### ! db_benutzerrechte, listet alle erstellten Benutzerrechte auf. db_dbuserrechte root 123456 testuser
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

### !  db_deldbuser, loescht einen Datenbankbenutzer. db_deldbuser root 123456 testuser
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

### !db_create_new_dbuser root password NEUERNAME NEUESPASSWORT
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

### ! db_delete, loescht eine Datenbank komplett.
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

### ! tabellenabfrage, listet alle Tabellen in einer Datenbank auf.
# Es geht hier um die machbarkeit und nicht den Sinn.
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

### !  regionsabfrage, Alle Regionen listen (Dies geht nur im Grid (Grid Datenbank) oder Standalone Modus).
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

### !  regionsuri, Region URI pruefen sortiert nach URI (Dies geht nur im Grid (Grid Datenbank) oder Standalone Modus).
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

### !  regionsport, Ports pruefen sortiert nach Ports (Dies geht nur im Grid (Grid Datenbank) oder Standalone Modus).
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

### !  setpartner, Partner setzen bei einer Person. Also bei beiden Partnern muss dies gemacht werden.
# opensim.sh setpartner Datenbankbenutzer Datenbankpasswort Robustdatenbank "AvatarUUID" "PartnerUUID"
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

	echo "$(tput setaf 5)SETPARTNER: $NEUERPARTNER ist jetzt Partner von $AVATARUUID. $(tput sgr0)"
	echo "$DATUM $(date +%H:%M:%S) SETPARTNER: $NEUERPARTNER ist jetzt Partner von $AVATARUUID" >>"/$STARTVERZEICHNIS/$DATEIDATUM$logfilename.log"
	return 0
}
### !setpartner, Partner setzen bei einer Person. Also bei beiden Partnern muss dies gemacht werden.
# opensim.sh setpartner Datenbankbenutzer Datenbankpasswort Robustdatenbank "AvatarUUID" "PartnerUUID"
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
### !db_deletepartner, Partner loeschen bei einer Person. Also bei beiden Partnern muss dies gemacht werden.
# opensim.sh setpartner Datenbankbenutzer Datenbankpasswort Robustdatenbank "AvatarUUID" "PartnerUUID"
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

########### Neu am 04.06.2022

# Test: getestet und korrigiert am 05.06.2022

### !Daten von allen Benutzern anzeigen: db_all_user "username" "password" "databasename"
function db_all_user() {
	username=$1
	password=$2
	databasename=$3
	echo "Daten von allen Benutzern anzeigen:"
	echo " "
	mysqlrest "$username" "$password" "$databasename" "SELECT * FROM UserAccounts" # Alles holen und in die Variable result_mysqlrest schreiben.
	log rohtext "$result_mysqlrest"

	return 0
}
### !db_all_user_dialog tabellenabfrage, Daten von allen Benutzern anzeigen.
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
		echo "Keine Menuelose Funktion" | exit
	fi # dialog Aktionen Ende

	mysqlrest "$username" "$password" "$databasename" "SELECT * FROM UserAccounts" # Alles holen und in die Variable result_mysqlrest schreiben.

	warnbox "$result_mysqlrest"

	return 0
}

### !UUID von allen Benutzern anzeigen: db_all_uuid "username" "password" "databasename"
function db_all_uuid() {
	username=$1
	password=$2
	databasename=$3
	echo "UUID von allen Benutzern anzeigen:"
	echo " "
	mysqlrest "$username" "$password" "$databasename" "SELECT PrincipalID FROM UserAccounts"
	log rohtext "$result_mysqlrest"

	return 0
}
### !UUID von allen Benutzern anzeigen.
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
		echo "Keine Menuelose Funktion" | exit
	fi # dialog Aktionen Ende

	mysqlrest "$username" "$password" "$databasename" "SELECT PrincipalID FROM UserAccounts"

	warnbox "$result_mysqlrest"

	return 0
}

### ! Alle Namen anzeigen: db_all_name "username" "password" "databasename"
function db_all_name() {
	username=$1
	password=$2
	databasename=$3
	echo "Vor- und Zuname von allen Benutzern anzeigen:"
	echo " "
	mysqlrest "$username" "$password" "$databasename" "SELECT FirstName, LastName FROM UserAccounts"
	log rohtext "$result_mysqlrest"

	return 0
}
### ! Alle Namen anzeigen: db_all_name_dialog "username" "password" "databasename"
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
		echo "Keine Menuelose Funktion" | exit
	fi # dialog Aktionen Ende

	mysqlrest "$username" "$password" "$databasename" "SELECT FirstName, LastName FROM UserAccounts"

	warnbox "$result_mysqlrest"

	return 0
}

### !Daten von einem Benutzer anzeigen: db_user_data "username" "password" "databasename" "firstname" "lastname"
function db_user_data() {
	username=$1
	password=$2
	databasename=$3
	firstname=$4
	lastname=$5
	echo "Daten von einem Benutzer anzeigen:"
	echo " "
	mysqlrest "$username" "$password" "$databasename" "SELECT * FROM UserAccounts WHERE firstname='$firstname' AND lastname LIKE '$lastname'"
	log rohtext "$result_mysqlrest"

	return 0
}
### !Daten von einem Benutzer anzeigen: db_user_data_dialog "username" "password" "databasename" "firstname" "lastname"
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
		echo "Keine Menuelose Funktion" | exit
	fi # dialog Aktionen Ende

	mysqlrest "$username" "$password" "$databasename" "SELECT * FROM UserAccounts WHERE firstname='$firstname' AND lastname LIKE '$lastname'"

	warnbox "$result_mysqlrest"

	return 0
}

### !UUID Vor- und Nachname sowie E-Mail Adresse von einem Benutzer anzeigen: db_user_infos "username" "password" "databasename" "firstname" "lastname"
function db_user_infos() {
	username=$1
	password=$2
	databasename=$3
	firstname=$4
	lastname=$5
	echo "UUID Vor- und Nachname sowie E-Mail Adresse von einem Benutzer anzeigen:"
	echo " "
	mysqlrest "$username" "$password" "$databasename" "SELECT PrincipalID, FirstName, LastName, Email FROM UserAccounts WHERE firstname='$firstname' AND lastname LIKE '$lastname'"
	log rohtext "$result_mysqlrest"

	return 0
}
### !UUID Vor- und Nachname sowie E-Mail Adresse von einem Benutzer anzeigen: db_user_infos "username" "password" "databasename" "firstname" "lastname"
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
		echo "Keine Menuelose Funktion" | exit
	fi # dialog Aktionen Ende

	mysqlrest "$username" "$password" "$databasename" "SELECT PrincipalID, FirstName, LastName, Email FROM UserAccounts WHERE firstname='$firstname' AND lastname LIKE '$lastname'"

	warnbox "$result_mysqlrest"

	return 0
}

### !UUID von einem Benutzer anzeigen: db_user_uuid
function db_user_uuid() {
	username=$1
	password=$2
	databasename=$3
	firstname=$4
	lastname=$5
	echo "UUID von einem Benutzer anzeigen:"
	echo " "
	mysqlrest "$username" "$password" "$databasename" "SELECT PrincipalID FROM UserAccounts WHERE FirstName='$firstname' AND LastName='$lastname'"
	log rohtext "$result_mysqlrest"

	return 0
}
### !UUID von einem Benutzer anzeigen: db_user_uuid_dialog
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
		echo "Keine Menuelose Funktion" | exit
	fi # dialog Aktionen Ende

	mysqlrest "$username" "$password" "$databasename" "SELECT PrincipalID FROM UserAccounts WHERE FirstName='$firstname' AND LastName='$lastname'"

	warnbox "$result_mysqlrest"

	return 0
}

### !Alles vom inventoryfolders type des User: db_foldertyp_user "username" "password" "databasename" "firstname" "lastname" "foldertyp"
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

	echo "Alles vom Inventar des User, nach Verzeichnissnamen oder ID:"
	echo " "
	mysqlrest "$username" "$password" "$databasename" "SELECT PrincipalID FROM UserAccounts WHERE FirstName='$firstname' AND LastName='$lastname'"
	user_uuid="$result_mysqlrest"
	mysqlrest "$username" "$password" "$databasename" "SELECT * FROM inventoryfolders WHERE (type='$foldertyp') AND agentID='$user_uuid'"
	log rohtext "$result_mysqlrest"

	return 0
}

### ! Alles vom inventoryfolders was type -1 des User: db_all_userfailed "username" "password" "databasename" "firstname" "lastname"
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

### !Zeige Erstellungsdatum eines Users an: db_userdate "username" "password" "databasename" "firstname" "lastname"
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

### ! Finde offensichtlich falsche E-Mail Adressen der User: db_false_email "username" "password" "databasename"
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

### !Einen User in der Datenbank erstellen und das ohne Inventar (Gut fuer Picker): set_empty_user "username" "password" "databasename" "firstname" "lastname" "email"
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

########### Neu am 04.06.2022 Ende

########### Neu am 08.06.2022

### ! Finde alle offensichtlich falschen E-Mail Adressen der Grid User und
## deaktiviere dauerhaft dessen Account:
## /opt/opensim.sh db_email_setincorrectuseroff "GRIDdatabaseusername" "GRIDdatabasepassword" "GRIDdatabasename"
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
### ! Finde alle offensichtlich falschen E-Mail Adressen der Grid User und
## deaktiviere dauerhaft dessen Account:
## /opt/opensim.sh db_email_setincorrectuseroff "GRIDdatabaseusername" "GRIDdatabasepassword" "GRIDdatabasename"
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
		echo "Keine Menuelose Funktion" | exit
	fi # dialog Aktionen Ende

	ausnahmefirstname="GRID"
	ausnahmelastname="SERVICES"

	mysqlrest "$username" "$password" "$databasename" "UPDATE UserAccounts SET active = -1 WHERE Email NOT LIKE '%_@__%.__%'AND NOT firstname='$ausnahmefirstname' AND NOT lastname='$ausnahmelastname';"

	warnbox "Alle offensichtlich falschen E-Mail Adressen der Grid User wurden gesucht und dessen Accounts deaktiviert."

	return 0
}

### ! Grid User dauerhaft abschalten:
## /opt/opensim.sh db_setuserofline "GRIDdatabaseusername" "GRIDdatabasepassword" "GRIDdatabasename" "firstname" "lastname"
function db_setuserofline() {
	username=$1
	password=$2
	databasename=$3
	firstname=$4
	lastname=$5

	echo "Setze User $firstname $lastname offline."
	echo " "
	mysqlrest "$username" "$password" "$databasename" "UPDATE UserAccounts SET active='-1' WHERE FirstName='$firstname' AND LastName='$lastname'"
	echo "$result_mysqlrest"

	return 0
}
### ! Grid User dauerhaft abschalten:
## /opt/opensim.sh db_setuserofline_dialog "GRIDdatabaseusername" "GRIDdatabasepassword" "GRIDdatabasename" "firstname" "lastname"
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
		echo "Keine Menuelose Funktion" | exit
	fi # dialog Aktionen Ende

	mysqlrest "$username" "$password" "$databasename" "UPDATE UserAccounts SET active='-1' WHERE FirstName='$firstname' AND LastName='$lastname'"

	warnbox "Benutzer $firstname $lastname wurde abgeschaltet."

	return 0
}

### ! Grid User dauerhaft aktivieren:
## /opt/opensim.sh db_setuseronline "GRIDdatabaseusername" "GRIDdatabasepassword" "GRIDdatabasename" "firstname" "lastname"
function db_setuseronline() {
	username=$1
	password=$2
	databasename=$3
	firstname=$4
	lastname=$5

	echo "Setze User $firstname $lastname online."
	echo " "
	mysqlrest "$username" "$password" "$databasename" "UPDATE UserAccounts SET active='1' WHERE FirstName='$firstname' AND LastName='$lastname'"
	echo "$result_mysqlrest"

	return 0
}
### ! Grid User dauerhaft aktivieren:
## /opt/opensim.sh db_setuseronline "GRIDdatabaseusername" "GRIDdatabasepassword" "GRIDdatabasename" "firstname" "lastname"
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
		echo "Keine Menuelose Funktion" | exit
	fi # dialog Aktionen Ende

	mysqlrest "$username" "$password" "$databasename" "UPDATE UserAccounts SET active='1' WHERE FirstName='$firstname' AND LastName='$lastname'"

	warnbox "Benutzer $firstname $lastname wurde reaktiviert."

	return 0
}

########### Neu am 08.06.2022 Ende

### NEU mariaDB 30.06.2022 Anfang ########################################################################
### ! default_master_connection "$2" "$3"
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

### ! connection_name "$2" "$3"
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

### ! MASTER_USER "$2" "$3"
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

### ! MASTER_PASSWORD "$2" "$3"
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

### ! MASTER_HOST "$2" "$3" "$4"
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

### ! MASTER_PORT "$2" "$3" "$4" "$5"
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

### ! MASTER_CONNECT_RETRY "$2" "$3" "$4"
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

### ! MASTER_SSL "$2" "$3"
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

### ! MASTER_SSL_CA "$2" "$3"
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

### ! MASTER_SSL_CAPATH "$2" "$3"
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

### ! MASTER_SSL_CERT "$2" "$3"
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

### ! MASTER_SSL_CRL "$2" "$3"
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

### ! MASTER_SSL_CRLPATH "$2" "$3"
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

### ! MASTER_SSL_KEY "$2" "$3"
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

### ! MASTER_SSL_CIPHER "$2" "$3"
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

### ! MASTER_SSL_VERIFY_SERVER_CERT "$2" "$3"
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

### ! MASTER_LOG_FILE "$2" "$3" "$4" "$5"
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

### ! MASTER_LOG_POS "$2" "$3" "$4" "$5"
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

### ! RELAY_LOG_FILE "$2" "$3" "$4" "$5"
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

### ! RELAY_LOG_POS "$2" "$3" "$4" "$5"
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

### ! MASTER_USE_GTID "$2" "$3"
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
### ! MASTER_USE_GTID2 "$2" "$3" "$4"
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

### ! IGNORE_SERVER_IDS "$2" "$3" "$4"
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

### ! DO_DOMAIN_IDS "$2" "$3" "$4"
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
### ! DO_DOMAIN_IDS2 "$2" "$3"
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

### ! IGNORE_DOMAIN_IDS "$2" "$3" "$4"
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
### ! IGNORE_DOMAIN_IDS2 "$2" "$3"
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

### ! MASTER_DELAY "$2" "$3" "$4"
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

### ! MASTER_PASSWORD "$2" "$3"
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

### ! Creating a Replica from a Backup "$2" "$3" "$4" "$5"
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
### ! Creating a Replica from a Backup2 "$2" "$3" "$4"
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
### ! ReplikatKoordinaten - Dies aendert die Koordinaten des primaeren und des primaeren Binaerlogs "$2" "$3" "$4" "$5" "$6" "$7" "$8"
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

### NEU mariaDB 30.06.2022 ENDE ########################################################################

###* NEU Datenbank splitten 03.07.2022 ENDE #############################################################

### ! Alle Tabellen aus einer SQL Datensicherung in ein gleichnahmigen Verzeichniss extrahieren.
# db_tablesplitt /Pfad/SQL_Datei.sql
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

### ! Eine einzelne Tabelle aus einem SQL Datenbank Backup extrahieren.
# db_tablextract /Pfad/SQL_Datei.sql Tabellenname
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

### ! db_tablextract_regex, Extrahiere Tabelle aus SQL Datenbank Backup unter zuhilfenahme von regex.
# db_tablextract_regex DUMP-FILE-NAME -S TABLE-NAME-REGEXP Extrahiert
# Tabellen aus der sql Datei mit dem angegebenen regulaeren Ausdruck.
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
###* NEU Datenbank splitten ENDE 03.07.2022 ENDE ########################################################################

### !  conf_write, Konfiguration schreiben ersatz fuer alle UNGETESTETEN ini Funktionen.
# ./opensim.sh conf_write Einstellung NeuerParameter Verzeichnis Dateiname
function conf_write() {
	CONF_SEARCH=$1
	CONF_ERSATZ=$2
	CONF_PFAD=$3
	CONF_DATEINAME=$4
	sed -i 's/'"$CONF_SEARCH"' =.*$/'"$CONF_SEARCH"' = '"$CONF_ERSATZ"'/' /"$CONF_PFAD"/"$CONF_DATEINAME"
	echo "Einstellung $CONF_SEARCH auf Parameter $CONF_ERSATZ geaendert in Datei /$CONF_PFAD/$CONF_DATEINAME"
	echo "$DATUM $(date +%H:%M:%S) CONF_WRITE: Einstellung $CONF_SEARCH auf Parameter $CONF_ERSATZ geaendert in Datei /$CONF_PFAD/$CONF_DATEINAME" >>"/$STARTVERZEICHNIS/$DATEIDATUM$logfilename.log"
	return 0
}

### !  conf_read, ganze Zeile aus der Konfigurationsdatei anzeigen.
# ./opensim.sh conf_read Einstellungsbereich Verzeichnis Dateiname
function conf_read() {
	CONF_SEARCH=$1
	CONF_PFAD=$2
	CONF_DATEINAME=$3
	sed -n -e '/'"$CONF_SEARCH"'/p' /"$CONF_PFAD"/"$CONF_DATEINAME"
	echo "Einstellung $CONF_SEARCH suchen in Datei /$CONF_PFAD/$CONF_DATEINAME"
	echo "$DATUM $(date +%H:%M:%S) CONF_WRITE: Einstellung $CONF_SEARCH suchen in Datei /$CONF_PFAD/$CONF_DATEINAME" >>"/$STARTVERZEICHNIS/$DATEIDATUM$logfilename.log"
	return 0
}

### !  conf_delete, ganze Zeile aus der Konfigurationsdatei loeschen.
# ./opensim.sh conf_delete Einstellungsbereich Verzeichnis Dateiname
function conf_delete() {
	CONF_SEARCH=$1
	CONF_PFAD=$2
	CONF_DATEINAME=$3
	sed -i 's/'"$CONF_SEARCH"' =.*$/''/' /"$CONF_PFAD"/"$CONF_DATEINAME"
	echo "Zeile $CONF_SEARCH geloescht in Datei /$CONF_PFAD/$CONF_DATEINAME"
	echo "$DATUM $(date +%H:%M:%S) CONF_DELETE: Zeile $CONF_SEARCH geloescht in Datei /$CONF_PFAD/$CONF_DATEINAME" >>"/$STARTVERZEICHNIS/$DATEIDATUM$logfilename.log"
	return 0
}

### !  ramspeicher, den echten RAM Speicher auslesen.
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

### !  mysqleinstellen, ermitteln wieviel RAM Speicher vorhanden ist und anschliessend mySQL Einstellen.
# Einstellungen sind in der my.cnf nicht moeglich es muss in die /etc/mysql/mysql.conf.d/mysqld.cnf
# Hier wird nicht geprueft ob die Einstellungen schon vorhanden sind sondern nur angehaengt.
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

	### Zeichensatz testen
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

### !  In Arbeit
function neuegridconfig() {
	echo "$(tput setaf 2)NEUEGRIDCONFIG: Konfigurationsdateien holen und in das ExampleConfig Verzeichnis kopieren. $(tput sgr0)"
	echo "$DATUM $(date +%H:%M:%S) NEUEGRIDCONFIG: Konfigurationsdateien holen und in das ExampleConfig Verzeichnis kopieren" >>"/$STARTVERZEICHNIS/$DATEIDATUM$logfilename.log"

	cd /"$STARTVERZEICHNIS" || exit
	git clone https://github.com/BigManzai/OpenSim-Shell-Script
	mv /"$STARTVERZEICHNIS"/OpenSim-Shell-Script/ExampleConfig /"$STARTVERZEICHNIS"/ExampleConfig
	rm -r /"$STARTVERZEICHNIS"/OpenSim-Shell-Script

	echo "IP eintragen"
	ipsetzen

	cp /"$STARTVERZEICHNIS"/ExampleConfig/robust/ /"$STARTVERZEICHNIS"/opensim/bin
	cp /"$STARTVERZEICHNIS"/ExampleConfig/sim/ /"$STARTVERZEICHNIS"/opensim/bin
	return 0
}

### !  ipsetzen, setzt nach Abfrage die IP in die Konfigurationen. OK
function ipsetzen() {
	cd /"$STARTVERZEICHNIS/ExampleConfig" || return 1 # gibt es das ExampleConfig Verzeichnis wenn nicht abbruch.

	EINGABEIP=""
	echo "$(tput setaf 2)IPSETZEN: Bitte geben Sie ihre externe IP ein oder druecken sie Enter fuer $(tput sgr0) $AKTUELLEIP"

	# Eingabe einlesen in Variable EINGABEIP
	read -r EINGABEIP

	# Pruefen ob Variableninhalt Enter oder eine IP ist
	if test "$EINGABEIP" = ""; then
		# ENTER wurde gewaehlt
		# Robust aendern
		sed -i 's/BaseURL =.*$/BaseURL = '"$AKTUELLEIP"'/' /"$STARTVERZEICHNIS"/ExampleConfig/robust/Robust.ini
		# OpenSim aendern
		sed -i 's/BaseHostname =.*$/BaseHostname = '"$AKTUELLEIP"'/' /"$STARTVERZEICHNIS"/ExampleConfig/sim/OpenSim.ini
		# MoneyServer aendern
		sed -i 's/MoneyScriptIPaddress  =.*$/MoneyScriptIPaddress  = '"$AKTUELLEIP"'/' /"$STARTVERZEICHNIS"/ExampleConfig/robust/MoneyServer.ini
		# GridCommon aendern
		sed -i 's/BaseHostname =.*$/BaseHostname = '"$AKTUELLEIP"'/' /"$STARTVERZEICHNIS"/ExampleConfig/sim/config-include/GridCommon.ini
	else
		# IP wurde gewaehlt
		# Ausfuehrungszeichen anhaengen
		EINGABEIP='"'$EINGABEIP'"'
		# Robust aendern
		sed -i 's/BaseURL =.*$/BaseURL = '"$EINGABEIP"'/' /"$STARTVERZEICHNIS"/ExampleConfig/robust/Robust.ini
		# OpenSim aendern
		sed -i 's/BaseHostname =.*$/BaseHostname = '"$EINGABEIP"'/' /"$STARTVERZEICHNIS"/ExampleConfig/sim/OpenSim.ini
		# MoneyServer aendern
		sed -i 's/MoneyScriptIPaddress  =.*$/MoneyScriptIPaddress  = '"$EINGABEIP"'/' /"$STARTVERZEICHNIS"/ExampleConfig/robust/MoneyServer.ini
		# GridCommon aendern
		sed -i 's/BaseHostname =.*$/BaseHostname = '"$EINGABEIP"'/' /"$STARTVERZEICHNIS"/ExampleConfig/sim/config-include/GridCommon.ini
	fi

	log info "IPSETZEN: IP oder DNS Einstellungen geaendert"
	return 0
}

### !Aktuelle IP in die Robust.ini schreiben. UNGETESTET
function robustini() {
	# Aktuelle IP ueber Suchadresse ermitteln und Ausfuehrungszeichen anhaengen.
	DNAAKTUELLEIP="$(wget -O - -q $SEARCHADRES)"

	echo "Gebe deine Server Adresse ein: (Beispiel meinserver.de oder 192.168.2.106)"
	echo "Enter fuer $AKTUELLEIP"
	read -r DNANAME
	if [ -z "$DNANAME" ]; then DNANAME=$DNAAKTUELLEIP; fi
	IP8002='"''http://'"$DNANAME"":8002"'"'
	IP8003='"''http://'"$DNANAME"":8003"'"'

	echo "Datenbankname:"
	read -r DBNAME
	echo "Datenbank Benutzername:"
	read -r DBUSER
	echo "Datenbank Passwort:"
	read -r DBPASSWD

	echo "Gridname:"
	read -r GRIDNAME
	echo "Gridnick:"
	read -r GRIDNICK
	# shellcheck disable=SC2016
	{
		echo '[Const]'
		echo 'BaseURL = '"$DNANAME"
		echo 'PublicPort = "8002"'
		echo 'PrivatePort = "8003"'
		echo 'MysqlDatabase = '"$DBNAME"
		echo 'MysqlUser = '"$DBUSER"
		echo 'MysqlPassword = '"$DBPASSWD"
		echo 'StartRegion = "Welcome"'
		echo 'Simulatorgridname = '"$GRIDNAME"
		echo 'Simulatorgridnick = '"$GRIDNICK"
		echo '[Startup]'
		echo 'PIDFile = "/tmp/Robust.pid"'
		echo 'RegistryLocation = "."'
		echo 'ConfigDirectory = "robust-include"'
		echo 'ConsoleHistoryFileEnabled = true'
		echo 'ConsoleHistoryFile = "RobustConsoleHistory.txt"'
		echo 'ConsoleHistoryFileLines = 100'
		echo 'NoVerifyCertChain = true'
		echo 'NoVerifyCertHostname = true'
		echo '[ServiceList]'
		echo 'AssetServiceConnector = "${Const|PrivatePort}/OpenSim.Server.Handlers.dll:AssetServiceConnector"'
		echo 'InventoryInConnector = "${Const|PrivatePort}/OpenSim.Server.Handlers.dll:XInventoryInConnector"'
		echo 'GridServiceConnector = "${Const|PrivatePort}/OpenSim.Server.Handlers.dll:GridServiceConnector"'
		echo 'GridInfoServerInConnector = "${Const|PublicPort}/OpenSim.Server.Handlers.dll:GridInfoServerInConnector"'
		echo 'AuthenticationServiceConnector = "${Const|PrivatePort}/OpenSim.Server.Handlers.dll:AuthenticationServiceConnector"'
		echo 'OpenIdServerConnector = "${Const|PublicPort}/OpenSim.Server.Handlers.dll:OpenIdServerConnector"'
		echo 'AvatarServiceConnector = "${Const|PrivatePort}/OpenSim.Server.Handlers.dll:AvatarServiceConnector"'
		echo 'LLLoginServiceInConnector = "${Const|PublicPort}/OpenSim.Server.Handlers.dll:LLLoginServiceInConnector"'
		echo 'PresenceServiceConnector = "${Const|PrivatePort}/OpenSim.Server.Handlers.dll:PresenceServiceConnector"'
		echo 'UserAccountServiceConnector = "${Const|PrivatePort}/OpenSim.Server.Handlers.dll:UserAccountServiceConnector"'
		echo 'GridUserServiceConnector = "${Const|PrivatePort}/OpenSim.Server.Handlers.dll:GridUserServiceConnector"'
		echo 'AgentPreferencesServiceConnector = "${Const|PrivatePort}/OpenSim.Server.Handlers.dll:AgentPreferencesServiceConnector"'
		echo 'FriendsServiceConnector = "${Const|PrivatePort}/OpenSim.Server.Handlers.dll:FriendsServiceConnector"'
		echo 'MapAddServiceConnector = "${Const|PrivatePort}/OpenSim.Server.Handlers.dll:MapAddServiceConnector"'
		echo 'MapGetServiceConnector = "${Const|PublicPort}/OpenSim.Server.Handlers.dll:MapGetServiceConnector"'
		echo 'OfflineIMServiceConnector = "${Const|PrivatePort}/OpenSim.Addons.OfflineIM.dll:OfflineIMServiceRobustConnector"'
		echo 'GroupsServiceConnector = "${Const|PrivatePort}/OpenSim.Addons.Groups.dll:GroupsServiceRobustConnector"'
		echo 'BakedTextureService = "${Const|PrivatePort}/OpenSim.Server.Handlers.dll:XBakesConnector"'
		echo 'UserProfilesServiceConnector = "${Const|PublicPort}/OpenSim.Server.Handlers.dll:UserProfilesConnector"'
		echo 'MuteListConnector = "${Const|PrivatePort}/OpenSim.Server.Handlers.dll:MuteListServiceConnector"'
		echo 'GatekeeperServiceInConnector = "${Const|PublicPort}/OpenSim.Server.Handlers.dll:GatekeeperServiceInConnector"'
		echo 'UserAgentServerConnector = "${Const|PublicPort}/OpenSim.Server.Handlers.dll:UserAgentServerConnector"'
		echo 'HeloServiceInConnector = "${Const|PublicPort}/OpenSim.Server.Handlers.dll:HeloServiceInConnector"'
		echo 'HGFriendsServerConnector = "${Const|PublicPort}/OpenSim.Server.Handlers.dll:HGFriendsServerConnector"'
		echo 'InstantMessageServerConnector = "${Const|PublicPort}/OpenSim.Server.Handlers.dll:InstantMessageServerConnector"'
		echo 'HGInventoryServiceConnector = "HGInventoryService@${Const|PublicPort}/OpenSim.Server.Handlers.dll:XInventoryInConnector"'
		echo 'HGAssetServiceConnector = "HGAssetService@${Const|PublicPort}/OpenSim.Server.Handlers.dll:AssetServiceConnector"'
		echo 'HGGroupsServiceConnector = "${Const|PublicPort}/OpenSim.Addons.Groups.dll:HGGroupsServiceRobustConnector"'
		echo '[Network]'
		echo 'port = ${Const|PrivatePort}'
		echo 'AllowllHTTPRequestIn = false'
		echo '[Hypergrid]'
		echo 'HomeURI = "${Const|BaseURL}:${Const|PublicPort}"'
		echo 'GatekeeperURI = "${Const|BaseURL}:${Const|PublicPort}"'
		echo '[AccessControl]'
		echo 'DeniedClients = "Imprudence|CopyBot|Twisted|Crawler|Cryolife|darkstorm|DarkStorm|Darkstorm"'
		echo '[DatabaseService]'
		echo 'StorageProvider = "OpenSim.Data.MySQL.dll"'
		echo 'ConnectionString = "Data Source=localhost;Database='"$DBNAME"';User ID='"$DBUSER"';Password='"$DBPASSWD"';Old Guids=true;"'
		echo '[AssetService]'
		echo 'LocalServiceModule = "OpenSim.Services.AssetService.dll:AssetService"'
		echo 'DefaultAssetLoader = "OpenSim.Framework.AssetLoader.Filesystem.dll"'
		echo 'AssetLoaderArgs = "./assets/AssetSets.xml"'
		echo 'AllowRemoteDelete = true'
		echo 'AllowRemoteDeleteAllTypes = false'
		echo '[InventoryService]'
		echo 'LocalServiceModule = "OpenSim.Services.InventoryService.dll:XInventoryService"'
		echo 'AllowDelete = true'
		echo '[GridService]'
		echo 'LocalServiceModule = "OpenSim.Services.GridService.dll:GridService"'
		echo 'AssetService = "OpenSim.Services.AssetService.dll:AssetService"'
		echo 'MapTileDirectory = "./maptiles"'
		echo 'Region_${Const|StartRegion} = "DefaultRegion, DefaultHGRegion, FallbackRegion"'
		echo 'HypergridLinker = true'
		echo 'ExportSupported = true'
		echo 'GatekeeperURI = "${Const|BaseURL}:${Const|PublicPort}"'
		echo '[FreeswitchService]'
		echo 'LocalServiceModule = "OpenSim.Services.FreeswitchService.dll:FreeswitchService"'
		echo '[AuthenticationService]'
		echo 'LocalServiceModule = "OpenSim.Services.AuthenticationService.dll:PasswordAuthenticationService"'
		echo 'AllowGetAuthInfo = true'
		echo 'AllowSetAuthInfo = true'
		echo 'AllowSetPassword = true'
		echo '[OpenIdService]'
		echo 'AuthenticationServiceModule = "OpenSim.Services.AuthenticationService.dll:PasswordAuthenticationService"'
		echo 'UserAccountServiceModule = "OpenSim.Services.UserAccountService.dll:UserAccountService"'
		echo '[UserAccountService]'
		echo 'LocalServiceModule = "OpenSim.Services.UserAccountService.dll:UserAccountService"'
		echo 'AuthenticationService = "OpenSim.Services.AuthenticationService.dll:PasswordAuthenticationService"'
		echo 'PresenceService = "OpenSim.Services.PresenceService.dll:PresenceService"'
		echo 'GridService = "OpenSim.Services.GridService.dll:GridService"'
		echo 'InventoryService = "OpenSim.Services.InventoryService.dll:XInventoryService"'
		echo 'AvatarService = "OpenSim.Services.AvatarService.dll:AvatarService"'
		echo 'GridUserService = "OpenSim.Services.UserAccountService.dll:GridUserService"'
		echo 'CreateDefaultAvatarEntries = true'
		echo 'AllowCreateUser = true'
		echo 'AllowSetAccount = true'
		echo '[GridUserService]'
		echo 'LocalServiceModule = "OpenSim.Services.UserAccountService.dll:GridUserService"'
		echo '[AgentPreferencesService]'
		echo 'LocalServiceModule = "OpenSim.Services.UserAccountService.dll:AgentPreferencesService"'
		echo '[PresenceService]'
		echo 'LocalServiceModule = "OpenSim.Services.PresenceService.dll:PresenceService"'
		echo '[AvatarService]'
		echo 'LocalServiceModule = "OpenSim.Services.AvatarService.dll:AvatarService"'
		echo '[FriendsService]'
		echo 'LocalServiceModule = "OpenSim.Services.FriendsService.dll:FriendsService"'
		echo '[EstateService]'
		echo 'LocalServiceModule = "OpenSim.Services.EstateService.dll:EstateDataService"'
		echo '[LibraryService]'
		echo 'LibraryName = "OpenSim Library"'
		echo 'DefaultLibrary = "./inventory/Libraries.xml"'
		echo '[LoginService]'
		echo 'LocalServiceModule = "OpenSim.Services.LLLoginService.dll:LLLoginService"'
		echo 'UserAccountService = "OpenSim.Services.UserAccountService.dll:UserAccountService"'
		echo 'GridUserService = "OpenSim.Services.UserAccountService.dll:GridUserService"'
		echo 'AuthenticationService = "OpenSim.Services.AuthenticationService.dll:PasswordAuthenticationService"'
		echo 'InventoryService = "OpenSim.Services.InventoryService.dll:XInventoryService"'
		echo 'AvatarService = "OpenSim.Services.AvatarService.dll:AvatarService"'
		echo 'PresenceService = "OpenSim.Services.PresenceService.dll:PresenceService"'
		echo 'GridService = "OpenSim.Services.GridService.dll:GridService"'
		echo 'SimulationService ="OpenSim.Services.Connectors.dll:SimulationServiceConnector"'
		echo 'LibraryService = "OpenSim.Services.InventoryService.dll:LibraryService"'
		echo 'FriendsService = "OpenSim.Services.FriendsService.dll:FriendsService"'
		echo 'MinLoginLevel = 0'
		echo 'UserAgentService = "OpenSim.Services.HypergridService.dll:UserAgentService"'
		echo 'HGInventoryServicePlugin = "HGInventoryService@OpenSim.Services.HypergridService.dll:HGSuitcaseInventoryService"'
		echo 'Currency = "T$"'
		echo 'ClassifiedFee = 0'
		echo 'WelcomeMessage = "Welcome, Avatar!"'
		echo 'AllowRemoteSetLoginLevel = "false"'
		echo 'MapTileURL = "${Const|BaseURL}:${Const|PublicPort}/";'
		echo 'SearchURL = "${Const|BaseURL}:${Const|PublicPort}/";'
		echo 'GatekeeperURI = "${Const|BaseURL}:${Const|PublicPort}"'
		echo 'SRV_HomeURI = "${Const|BaseURL}:${Const|PublicPort}"'
		echo 'SRV_InventoryServerURI = "${Const|BaseURL}:${Const|PublicPort}"'
		echo 'SRV_AssetServerURI = "${Const|BaseURL}:${Const|PublicPort}"'
		echo 'SRV_ProfileServerURI = "${Const|BaseURL}:${Const|PublicPort}"'
		echo 'SRV_FriendsServerURI = "${Const|BaseURL}:${Const|PublicPort}"'
		echo 'SRV_IMServerURI = "${Const|BaseURL}:${Const|PublicPort}"'
		echo 'SRV_GroupsServerURI = "${Const|BaseURL}:${Const|PublicPort}"'
		echo 'DSTZone = "America/Los_Angeles;Pacific Standard Time"'
		echo '[MapImageService]'
		echo 'LocalServiceModule = "OpenSim.Services.MapImageService.dll:MapImageService"'
		echo 'TilesStoragePath = "maptiles"'
		echo '[GridInfoService]'
		echo 'login = ${Const|BaseURL}:${Const|PublicPort}/'
		echo 'gridname = "${Const|Simulatorgridname}"'
		echo 'gridnick = ${Const|Simulatorgridnick}'
		echo 'welcome = ${Const|BaseURL}/'
		echo 'economy = ${Const|BaseURL}/helper/'
		echo 'about = ${Const|BaseURL}/'
		echo 'register = ${Const|BaseURL}/'
		echo 'help = ${Const|BaseURL}/'
		echo 'password = ${Const|BaseURL}/'
		echo 'gatekeeper = ${Const|BaseURL}:${Const|PublicPort}/'
		echo 'uas = ${Const|BaseURL}:${Const|PublicPort}/'
		echo '[GatekeeperService]'
		echo 'LocalServiceModule = "OpenSim.Services.HypergridService.dll:GatekeeperService"'
		echo 'UserAccountService = "OpenSim.Services.UserAccountService.dll:UserAccountService"'
		echo 'UserAgentService = "OpenSim.Services.HypergridService.dll:UserAgentService"'
		echo 'PresenceService = "OpenSim.Services.PresenceService.dll:PresenceService"'
		echo 'GridUserService = "OpenSim.Services.UserAccountService.dll:GridUserService"'
		echo 'GridService = "OpenSim.Services.GridService.dll:GridService"'
		echo 'AuthenticationService = "OpenSim.Services.Connectors.dll:AuthenticationServicesConnector"'
		echo 'SimulationService ="OpenSim.Services.Connectors.dll:SimulationServiceConnector"'
		echo 'AllowTeleportsToAnyRegion = true'
		echo 'ForeignAgentsAllowed = true'
		echo 'AllowExcept = "http://grid.sacrarium.su:8888"'
		echo '[UserAgentService]'
		echo 'LocalServiceModule = "OpenSim.Services.HypergridService.dll:UserAgentService"'
		echo 'GridUserService     = "OpenSim.Services.UserAccountService.dll:GridUserService"'
		echo 'GridService         = "OpenSim.Services.GridService.dll:GridService"'
		echo 'GatekeeperService   = "OpenSim.Services.HypergridService.dll:GatekeeperService"'
		echo 'PresenceService     = "OpenSim.Services.PresenceService.dll:PresenceService"'
		echo 'FriendsService      = "OpenSim.Services.FriendsService.dll:FriendsService"'
		echo 'UserAccountService  = "OpenSim.Services.UserAccountService.dll:UserAccountService"'
		echo 'LevelOutsideContacts = 0'
		echo 'ShowUserDetailsInHGProfile = True'
		echo '[HGInventoryService]'
		echo 'LocalServiceModule = "OpenSim.Services.InventoryService.dll:XInventoryService"'
		echo 'UserAccountsService = "OpenSim.Services.UserAccountService.dll:UserAccountService"'
		echo 'AvatarService = "OpenSim.Services.AvatarService.dll:AvatarService"'
		echo 'AuthType = None'
		echo 'HomeURI = "${Const|BaseURL}:${Const|PublicPort}"'
		echo '[HGAssetService]'
		echo 'LocalServiceModule = "OpenSim.Services.HypergridService.dll:HGAssetService"'
		echo 'UserAccountsService = "OpenSim.Services.UserAccountService.dll:UserAccountService"'
		echo 'AuthType = None'
		echo 'HomeURI = "${Const|BaseURL}:${Const|PublicPort}"'
		echo '[HGFriendsService]'
		echo 'LocalServiceModule = "OpenSim.Services.HypergridService.dll:HGFriendsService"'
		echo 'UserAgentService = "OpenSim.Services.HypergridService.dll:UserAgentService"'
		echo 'FriendsService = "OpenSim.Services.FriendsService.dll:FriendsService"'
		echo 'UserAccountService = "OpenSim.Services.UserAccountService.dll:UserAccountService"'
		echo 'GridService = "OpenSim.Services.GridService.dll:GridService"'
		echo 'PresenceService = "OpenSim.Services.PresenceService.dll:PresenceService"'
		echo '[HGInstantMessageService]'
		echo 'LocalServiceModule  = "OpenSim.Services.HypergridService.dll:HGInstantMessageService"'
		echo 'GridService         = "OpenSim.Services.GridService.dll:GridService"'
		echo 'PresenceService     = "OpenSim.Services.PresenceService.dll:PresenceService"'
		echo 'UserAgentService    = "OpenSim.Services.HypergridService.dll:UserAgentService"'
		echo 'InGatekeeper = True'
		echo '[Messaging]'
		echo 'OfflineIMService = "OpenSim.Addons.OfflineIM.dll:OfflineIMService"'
		echo '[Groups]'
		echo 'OfflineIMService = "OpenSim.Addons.OfflineIM.dll:OfflineIMService"'
		echo 'UserAccountService = "OpenSim.Services.UserAccountService.dll:UserAccountService"'
		echo 'HomeURI = "${Const|BaseURL}:${Const|PublicPort}"'
		echo 'MaxAgentGroups = 42'
		echo '[UserProfilesService]'
		echo 'LocalServiceModule = "OpenSim.Services.UserProfilesService.dll:UserProfilesService"'
		echo 'Enabled = true'
		echo 'UserAccountService = OpenSim.Services.UserAccountService.dll:UserAccountService'
		echo 'AuthenticationServiceModule = "OpenSim.Services.AuthenticationService.dll:PasswordAuthenticationService"'
		echo '[BakedTextureService]'
		echo 'LocalServiceModule = "OpenSim.Server.Handlers.dll:XBakes"'
		echo 'BaseDirectory = "./bakes"'
		echo '[MuteListService]'
		echo 'LocalServiceModule = "OpenSim.Services.MuteListService.dll:MuteListService"'
	} >"/$STARTVERZEICHNIS/$DATEIDATUM-Robust.ini"
	return 0
}

### !Aktuelle IP in die MoneyServer.ini schreiben. UNGETESTET
function moneyserverini() {
	# Aktuelle IP ueber Suchadresse ermitteln und Ausfuehrungszeichen anhaengen.
	DNAAKTUELLEIP="$(wget -O - -q $SEARCHADRES)"

	echo "Datenbankname:"
	read -r DBNAME
	echo "Datenbank Benutzername:"
	read -r DBUSER
	echo "Datenbank Passwort:"
	read -r DBPASSWD
	# shellcheck disable=SC2016
	{
		echo '[Startup]'
		echo 'PIDFile = "/tmp/money.pid"'
		echo '[MySql]'
		echo 'hostname = localhost'
		echo 'database = '"$DBNAME"
		echo 'username = '"$DBUSER"
		echo 'password = '"$DBPASSWD"
		echo 'pooling  = true'
		echo 'port = 3306'
		echo 'MaxConnection = 20'
		echo '[MoneyServer]'
		echo 'ServerPort = 8008'
		echo 'DefaultBalance = 1000'
		echo 'EnableAmountZero = true'
		echo 'BankerAvatar = "00000000-0000-0000-0000-000000000000"'
		echo 'EnableForceTransfer = true'
		echo 'EnableScriptSendMoney = true'
		echo 'MoneyScriptAccessKey  = "123456789"'
		echo 'MoneyScriptIPaddress  = '"$DNAAKTUELLEIP"
		echo 'EnableHGAvatar = true'
		echo 'EnableGuestAvatar = true'
		echo 'HGAvatarDefaultBalance = 1000'
		echo 'GuestAvatarDefaultBalance = 1000'
		echo 'BalanceMessageSendGift     = "Sent Gift L${0} to {1}."'
		echo 'BalanceMessageReceiveGift  = "Received Gift L${0} from {1}."'
		echo 'BalanceMessagePayCharge    = "Paid the Money L${0} for creation."'
		echo 'BalanceMessageBuyObject    = "Bought the Object {2} from {1} by L${0}."'
		echo 'BalanceMessageSellObject   = "{1} bought the Object {2} by L${0}."'
		echo 'BalanceMessageLandSale     = "Paid the Money L${0} for Land."'
		echo 'BalanceMessageScvLandSale  = "Paid the Money L${0} for Land."'
		echo 'BalanceMessageGetMoney     = "Got the Money L${0} from {1}."'
		echo 'BalanceMessageBuyMoney     = "Bought the Money L${0}."'
		echo 'BalanceMessageRollBack     = "RollBack the Transaction: L${0} from/to {1}."'
		echo 'BalanceMessageSendMoney    = "Paid the Money L${0} to {1}."'
		echo 'BalanceMessageReceiveMoney = "Received L${0} from {1}."'
		echo '[Certificate]'
		echo 'CheckServerCert = false'
	} >"/$STARTVERZEICHNIS/$DATEIDATUM-MoneyServer.ini"
	return 0
}

### !Aktuelle IP in die OpenSim.ini schreiben.
function opensimini() {
	# Aktuelle IP ueber Suchadresse ermitteln und Ausfuehrungszeichen anhaengen.
	DNAAKTUELLEIP="$(wget -O - -q $SEARCHADRES)"

	echo "Gebe deine Server Adresse ein: (Beispiel meinserver.de oder 192.168.2.106)"
	echo "Enter fuer $AKTUELLEIP"
	read -r DNANAME
	if [ -z "$DNANAME" ]; then DNANAME=$DNAAKTUELLEIP; fi
	IP8002='"''http://'"$DNANAME"":8002"'"'
	IP8003='"''http://'"$DNANAME"":8003"'"'
	BASEURL='"''http://'"$DNANAME"'"'
	echo "Gridname:"
	read -r GRIDNAME
	echo "SimulatorPort (9010):"
	read -r SIMULATORPORT
	if [ -z "$SIMULATORPORT" ]; then SIMULATORPORT=9010; fi
	echo "SimulatorXmlRpcPort (20801):"
	read -r SIMULATORXMLRPCPORT
	if [ -z "$SIMULATORXMLRPCPORT" ]; then SIMULATORXMLRPCPORT=20801; fi

	# shellcheck disable=SC2016
	{
		echo '[Const]'
		echo 'BaseHostname = '"$DNANAME"
		echo 'BaseURL = '"$BASEURL"
		echo 'PublicPort = "8002"'
		echo 'PrivURL = ${Const|BaseURL}'
		echo 'PrivatePort = "8003"'
		echo 'MoneyPort = "8008"'
		echo 'SimulatorPort = '"$SIMULATORPORT"
		echo 'SimulatorXmlRpcPort = '"$SIMULATORXMLRPCPORT"
		echo 'Simulatorgridname = '"$GRIDNAME"
		echo '[Startup]'
		echo 'ConsolePrompt = "Region (\R) "'
		echo 'ConsoleHistoryFileEnabled = true'
		echo 'ConsoleHistoryFile = "OpenSimConsoleHistory.txt"'
		echo 'ConsoleHistoryFileLines = 100'
		echo 'ConsoleHistoryTimeStamp = true'
		echo 'region_info_source = "filesystem"'
		echo 'NonPhysicalPrimMin = 0.001'
		echo 'NonPhysicalPrimMax = 1024'
		echo 'PhysicalPrimMin = 0.01'
		echo 'PhysicalPrimMax = 64'
		echo 'ClampPrimSize = false'
		echo 'AllowScriptCrossing = true'
		echo 'DefaultDrawDistance = 128.0'
		echo 'MaxDrawDistance = 128'
		echo 'MaxRegionsViewDistance = 128'
		echo 'MinRegionsViewDistance = 48'
		echo 'MinimumTimeBeforePersistenceConsidered = 60'
		echo 'MaximumTimeBeforePersistenceConsidered = 600'
		echo 'physical_prim = true'
		echo 'meshing = Meshmerizer'
		echo 'physics = BulletSim'
		echo 'DefaultScriptEngine = "YEngine"'
		echo 'SpawnPointRouting = closest'
		echo 'TelehubAllowLandmark = true'
		echo '[AccessControl]'
		echo 'DeniedClients = "Imprudence|CopyBot|Twisted|Crawler|Cryolife|darkstorm|DarkStorm|Darkstorm"'
		echo '[Map]'
		echo 'GenerateMaptiles = true'
		echo 'MapImageModule = "MapImageModule"'
		echo 'MaptileRefresh = 0'
		echo 'MaptileStaticUUID = "00000000-0000-0000-0000-000000000000"'
		echo 'TextureOnMapTile = true'
		echo 'DrawPrimOnMapTile = true'
		echo 'TexturePrims = true'
		echo 'TexturePrimSize = 48'
		echo 'RenderMeshes = true'
		echo '[Permissions]'
		echo 'permissionmodules = DefaultPermissionsModule'
		echo 'serverside_object_permissions = true'
		echo 'automatic_gods = false'
		echo 'implicit_gods = false'
		echo 'allow_grid_gods = true'
		echo 'region_owner_is_god = true'
		echo 'region_manager_is_god = true'
		echo '[Estates]'
		echo '[SMTP]'
		echo '[Network]'
		echo 'http_listener_port = "${Const|SimulatorPort}"'
		echo 'ExternalHostNameForLSL = ${Const|BaseHostname}'
		echo 'shard = "OpenSim"'
		echo 'user_agent = "OpenSim LSL (Mozilla Compatible)"'
		echo '[XMLRPC]'
		echo 'XmlRpcRouterModule = "XmlRpcRouterModule"'
		echo 'XmlRpcPort = "${Const|SimulatorXmlRpcPort}"'
		echo 'XmlRpcHubURI = ${Const|BaseHostname}'
		echo '[ClientStack.LindenUDP]'
		echo 'DisableFacelights = "true"'
		echo 'scene_throttle_max_bps = 625000000'
		echo 'client_throttle_max_bps = 500000'
		echo 'enable_adaptive_throttles = true'
		echo '[ClientStack.LindenCaps]'
		echo 'Cap_GetTexture = "localhost"'
		echo 'Cap_GetMesh = "localhost"'
		echo 'Cap_AvatarPickerSearch = "localhost"'
		echo 'Cap_GetDisplayNames = "localhost"'
		echo '[SimulatorFeatures]'
		echo 'SearchServerURI = "${Const|BaseURL}:${Const|PublicPort}"'
		echo 'DestinationGuideURI = "${Const|BaseURL}:${Const|PublicPort}"'
		echo '[Chat]'
		echo 'whisper_distance = 25'
		echo 'say_distance = 70'
		echo 'shout_distance = 250'
		echo '[EntityTransfer]'
		echo '[Messaging]'
		echo 'OfflineMessageModule = "Offline Message Module V2"'
		echo 'OfflineMessageURL = ${Const|BaseURL}:${Const|PrivatePort}'
		echo 'StorageProvider = OpenSim.Data.MySQL.dll'
		echo 'MuteListModule = MuteListModule'
		echo 'MuteListURL = ${Const|BaseHostname}/helper/mute.php'
		echo 'ForwardOfflineGroupMessages = true'
		echo '[BulletSim]'
		echo 'AvatarToAvatarCollisionsByDefault = true'
		echo 'UseSeparatePhysicsThread = false'
		echo 'TerrainImplementation = 0'
		echo 'TerrainMeshMagnification = 2'
		echo '[ODEPhysicsSettings]'
		echo '[RemoteAdmin]'
		echo 'enabled = false'
		echo 'create_region_enable_voice = true'
		echo 'create_region_public = true'
		echo 'enabled_methods = all'
		echo 'default_female = Default Female'
		echo 'default_appearance = default_appearance.xml'
		echo '[Wind]'
		echo 'enabled = true'
		echo 'wind_update_rate = 150'
		echo 'wind_plugin = SimpleRandomWind'
		echo 'strength = 2.0'
		echo '[LightShare]'
		echo 'enable_windlight = true'
		echo '[Materials]'
		echo 'enable_materials = true'
		echo 'MaxMaterialsPerTransaction = 500'
		echo '[DataSnapshot]'
		echo 'index_sims = true'
		echo 'data_exposure = minimum'
		echo 'gridname = "${Const|Simulatorgridname}"'
		echo 'default_snapshot_period = 7200'
		echo 'snapshot_cache_directory = "DataSnapshot"'
		echo '[Economy]'
		echo 'SellEnabled = true'
		echo 'EconomyModule = DTLNSLMoneyModule'
		echo 'CurrencyServer = "${Const|BaseURL}:8008/"'
		echo 'UserServer = "${Const|BaseURL}:8002/"'
		echo 'CheckServerCert = false'
		echo 'PriceUpload = 0'
		echo 'MeshModelUploadCostFactor = 1.0'
		echo 'MeshModelUploadTextureCostFactor = 1.0'
		echo 'MeshModelMinCostFactor = 1.0'
		echo 'PriceGroupCreate = 0'
		echo 'ObjectCount = 0'
		echo 'PriceEnergyUnit = 0'
		echo 'PriceObjectClaim = 0'
		echo 'PricePublicObjectDecay = 0'
		echo 'PricePublicObjectDelete = 0'
		echo 'PriceParcelClaim = 0'
		echo 'PriceParcelClaimFactor = 1'
		echo 'PriceRentLight = 0'
		echo 'TeleportMinPrice = 0'
		echo 'TeleportPriceExponent = 2'
		echo 'EnergyEfficiency = 1'
		echo 'PriceObjectRent = 0'
		echo 'PriceObjectScaleFactor = 10'
		echo 'PriceParcelRent = 0'
		echo '[YEngine]'
		echo 'Enabled = true'
		echo '[XEngine]'
		echo 'Enabled = false'
		echo 'AppDomainLoading = false'
		echo 'DeleteScriptsOnStartup = true'
		echo '[OSSL]'
		echo 'Include-osslDefaultEnable = "config-include/osslDefaultEnable.ini"'
		echo '[FreeSwitchVoice]'
		echo '[VivoxVoice]'
		echo 'Enabled = false'
		echo '[Groups]'
		echo 'Enabled = true'
		echo 'LevelGroupCreate = 0'
		echo 'Module = "Groups Module V2"'
		echo 'StorageProvider = OpenSim.Data.MySQL.dll'
		echo 'ServicesConnectorModule = "Groups HG Service Connector"'
		echo 'LocalService = remote'
		echo 'GroupsServerURI = ${Const|BaseURL}:${Const|PrivatePort}'
		echo 'HomeURI = "${Const|BaseURL}:${Const|PublicPort}"'
		echo 'MessagingEnabled = true'
		echo 'MessagingModule = "Groups Messaging Module V2"'
		echo 'NoticesEnabled = true'
		echo 'MessageOnlineUsersOnly = true'
		echo 'DebugEnabled = false'
		echo 'DebugMessagingEnabled = false'
		echo 'XmlRpcServiceReadKey    = 1234'
		echo 'XmlRpcServiceWriteKey   = 1234'
		echo '[InterestManagement]'
		echo 'UpdatePrioritizationScheme = BestAvatarResponsiveness'
		echo 'ObjectsCullingByDistance = true'
		echo '[MediaOnAPrim]'
		echo 'Enabled = true'
		echo '[NPC]'
		echo 'Enabled = true'
		echo 'MaxNumberNPCsPerScene = 40'
		echo 'AllowNotOwned = true'
		echo 'AllowSenseAsAvatar = true'
		echo 'AllowCloneOtherAvatars = true'
		echo 'NoNPCGroup = true'
		echo '[Terrain]'
		echo 'InitialTerrain = "flat"'
		echo '[LandManagement]'
		echo 'ShowParcelBansLines = true'
		echo '[UserProfiles]'
		echo 'ProfileServiceURL = ${Const|BaseURL}:${Const|PublicPort}'
		echo 'AllowUserProfileWebURLs = true'
		echo '[Profile]'
		echo 'Module = "OpenSimProfile"'
		echo 'ProfileURL = ${Const|BaseURL}/helper/profile.php'
		echo '[XBakes]'
		echo 'URL = ${Const|BaseURL}:${Const|PrivatePort}'
		echo '[AutoBackupModule]'
		echo ' AutoBackupModuleEnabled = false'
		echo '[Architecture]'
		echo 'Include-Architecture = "config-include/GridHypergrid.ini"'
	} >"/$STARTVERZEICHNIS/$DATEIDATUM-OpenSim.ini"
	return 0
}

### !Aktuelle IP in die GridCommon.ini schreiben. UNGETESTET
function gridcommonini() {
	# Aktuelle IP ueber Suchadresse ermitteln und Ausfuehrungszeichen anhaengen.
	DNAAKTUELLEIP="$(wget -O - -q $SEARCHADRES)"

	echo "Gebe deine Server Adresse ein: (Beispiel meinserver.de oder 192.168.2.106)"
	echo "Enter fuer $AKTUELLEIP"
	read -r DNANAME
	if [ -z "$DNANAME" ]; then DNANAME=$DNAAKTUELLEIP; fi
	IP8002='"''http://'"$DNANAME"":8002"'"'
	IP8003='"''http://'"$DNANAME"":8003"'"'

	echo "Datenbankname:"
	read -r DBNAME
	echo "Datenbank Benutzername:"
	read -r DBUSER
	echo "Datenbank Passwort:"
	read -r DBPASSWD

	{
		echo '[DatabaseService]'
		echo 'StorageProvider = "OpenSim.Data.MySQL.dll"'
		echo 'ConnectionString = "Data Source=localhost;Database='"$DBNAME"';User ID='"$DBUSER"';Password='"$DBPASSWD"';Old Guids=true;"'
		echo '[Hypergrid]'
		echo 'HomeURI = '"$IP8002"
		echo 'GatekeeperURI = '"$IP8002"
		echo '[Modules]'
		echo 'AssetCaching = "FlotsamAssetCache"'
		echo 'Include-FlotsamCache = "config-include/FlotsamCache.ini"'
		echo '[AssetService]'
		echo 'DefaultAssetLoader = "OpenSim.Framework.AssetLoader.Filesystem.dll"'
		echo 'AssetLoaderArgs = "assets/AssetSets.xml"'
		echo 'AssetServerURI = '"$IP8003"
		echo '[InventoryService]'
		echo 'InventoryServerURI = '"$IP8003"
		echo '[GridInfo]'
		echo 'GridInfoURI = '"$IP8002"
		echo '[GridService]'
		echo 'GridServerURI = '"$IP8003"
		echo 'AllowHypergridMapSearch = true'
		echo 'MapTileDirectory = "./maptiles"'
		echo 'Gatekeeper='"$IP8002"
		echo '[EstateDataStore]'
		echo '[EstateService]'
		echo 'EstateServerURI = '"$IP8003"
		echo '[Messaging]'
		echo 'Gatekeeper = '"$IP8002"
		echo '[AvatarService]'
		echo 'AvatarServerURI = '"$IP8003"
		echo '[AgentPreferencesService]'
		echo 'AgentPreferencesServerURI = '"$IP8003"
		echo '[PresenceService]'
		echo 'PresenceServerURI = '"$IP8003"
		echo '[UserAccountService]'
		echo 'UserAccountServerURI = '"$IP8003"
		echo '[GridUserService]'
		echo 'GridUserServerURI = '"$IP8003"
		echo '[AuthenticationService]'
		echo 'AuthenticationServerURI = '"$IP8003"
		echo '[FriendsService]'
		echo 'FriendsServerURI = '"$IP8003"
		echo '[HGInventoryAccessModule]'
		echo 'HomeURI = '"$IP8002"
		echo 'Gatekeeper = '"$IP8002"
		echo 'RestrictInventoryAccessAbroad = false'
		echo '[HGAssetService]'
		echo 'HomeURI = '"$IP8002"
		echo '[HGFriendsModule]'
		echo 'LevelHGFriends = 0;'
		echo '[UserAgentService]'
		echo 'UserAgentServerURI = '"$IP8002"
		echo '[MapImageService]'
		echo 'MapImageServerURI = '"$IP8003"
		echo '[AuthorizationService]'
		echo '[MuteListService]'
		echo 'MuteListServerURI = '"$IP8003"
	} >"/$STARTVERZEICHNIS/$DATEIDATUM-GridCommon.ini"
	#/$STARTVERZEICHNIS/"$VERZEICHNIS"/bin/config-include/GridCommon.ini
	return 0
}

### ! Regionini Simulator Dateiname
### Aktuelle IP in die Regions.ini schreiben. UNGETESTET
function regionini() {
	# Aktuelle IP ueber Suchadresse ermitteln und Ausfuehrungszeichen anhaengen.
	DNAAKTUELLEIP="$(wget -O - -q $SEARCHADRES)"

	echo "Gebe deine Server Adresse ein: (Beispiel meinserver.de oder 192.168.2.106)"
	echo "Enter fuer $AKTUELLEIP"
	read -r DNANAME
	if [ -z "$DNANAME" ]; then DNANAME=$DNAAKTUELLEIP; fi

	echo "Startpunkt des Grid Beispiel: 4500,4500"
	read -r STARTPUNKT
	if [ -z "$STARTPUNKT" ]; then STARTPUNKT="4500,4500"; fi
	echo "InternalPort Beispiel: 9050"
	read -r INTERNALPORT
	if [ -z "$INTERNALPORT" ]; then INTERNALPORT=9050; fi

	UUID=$(uuidgen)

	{
		echo '[Welcome]'
		echo 'RegionUUID = '"$UUID"
		echo 'Location = '"$STARTPUNKT"
		echo 'SizeX = 256'
		echo 'SizeY = 256'
		echo 'SizeZ = 256'
		echo 'InternalAddress = 0.0.0.0'
		echo 'InternalPort = '"$INTERNALPORT"
		echo 'ResolveAddress = False'
		echo 'ExternalHostName = '"$DNANAME"
		echo 'MaptileStaticUUID = '"$UUID"
	} >"/$STARTVERZEICHNIS/$DATEIDATUM-welcome.ini"
	return 0
}


### !  osslenableini() erstellt eine osslenable.ini Datei und Konfiguriert diese.
function osslenableini() {
	#osslEnable.ini
	echo "OSFunctionThreatLevel Moeglichkeiten: None, VeryLow, Low, Moderate, High, VeryHigh, Severe"
	echo "Enter = Severe"
	read -r OSFUNCTION
	if [ -z "$OSFUNCTION" ]; then OSFUNCTION="Severe"; fi

	# shellcheck disable=SC2016
	{
		echo '[OSSL]'
		echo 'OSFunctionThreatLevel = '$OSFUNCTION
		echo 'osslParcelO = "PARCEL_OWNER,"'
		echo 'osslParcelOG = "PARCEL_GROUP_MEMBER,PARCEL_OWNER,"'
		echo 'osslNPC = ${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER'
		echo ' '
		echo 'Allow_osGetAgents = true'
		echo 'Allow_osGetAvatarList = true'
		echo 'Allow_osGetGender = true'
		echo 'Allow_osGetHealth = true'
		echo 'Allow_osGetHealRate = true'
		echo 'Allow_osGetNPCList =true'
		echo 'Allow_osGetRezzingObject =true'
		echo 'Allow_osGetSunParam = true'
		echo 'Allow_osNpcGetOwner = true'
		echo 'Allow_osSetSunParam = ESTATE_MANAGER,ESTATE_OWNER'
		echo 'Allow_osTeleportOwner = ${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER'
		echo 'Allow_osWindActiveModelPluginName = true'
		echo 'Allow_osSetEstateSunSettings =ESTATE_MANAGER,ESTATE_OWNER'
		echo 'Allow_osSetRegionSunSettings =ESTATE_MANAGER,ESTATE_OWNER'
		echo 'Allow_osEjectFromGroup =${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER'
		echo 'Allow_osForceBreakAllLinks =${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER'
		echo 'Allow_osForceBreakLink =${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER'
		echo 'Allow_osGetWindParam =true'
		echo 'Allow_osInviteToGroup = ${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER'
		echo 'Allow_osReplaceString = true'
		echo 'Allow_osSetDynamicTextureData = true'
		echo 'Allow_osSetDynamicTextureDataFace = true'
		echo 'Allow_osSetDynamicTextureDataBlend =true'
		echo 'Allow_osSetDynamicTextureDataBlendFace = true'
		echo 'Allow_osSetParcelMediaURL = true'
		echo 'Allow_osSetParcelMusicURL = true'
		echo 'Allow_osSetParcelSIPAddress = ${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER'
		echo 'Allow_osSetPrimFloatOnWater = true'
		echo 'Allow_osSetWindParam =${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER'
		echo 'Allow_osTerrainFlush =ESTATE_MANAGER,ESTATE_OWNER'
		echo 'Allow_osUnixTimeToTimestamp = true'
		echo 'Allow_osAvatarName2Key =true'
		echo 'Allow_osFormatString =true'
		echo 'Allow_osKey2Name =true'
		echo 'Allow_osListenRegex = true'
		echo 'Allow_osLoadedCreationDate =true'
		echo 'Allow_osLoadedCreationID =true'
		echo 'Allow_osLoadedCreationTime =true'
		echo 'Allow_osMessageObject = true'
		echo 'Allow_osRegexIsMatch =true'
		echo 'Allow_osGetAvatarHomeURI =true'
		echo 'Allow_osNpcSetProfileAbout =true'
		echo 'Allow_osNpcSetProfileImage =true'
		echo 'Allow_osDie = true'
		echo 'Allow_osDetectedCountry = true'
		echo 'Allow_osDropAttachment =true'
		echo 'Allow_osDropAttachmentAt =true'
		echo 'Allow_osGetAgentCountry = true'
		echo 'Allow_osGetGridCustom = true'
		echo 'Allow_osGetGridGatekeeperURI =true'
		echo 'Allow_osGetGridHomeURI =true'
		echo 'Allow_osGetGridLoginURI = true'
		echo 'Allow_osGetGridName = true'
		echo 'Allow_osGetGridNick = true'
		echo 'Allow_osGetNumberOfAttachments =true'
		echo 'Allow_osGetRegionStats =true'
		echo 'Allow_osGetSimulatorMemory =true'
		echo 'Allow_osGetSimulatorMemoryKB =true'
		echo 'Allow_osMessageAttachments =true'
		echo 'Allow_osReplaceAgentEnvironment = true'
		echo 'Allow_osSetSpeed =true'
		echo 'Allow_osSetOwnerSpeed = true'
		echo 'Allow_osRequestURL =true'
		echo 'Allow_osRequestSecureURL =true'
		echo 'Allow_osCauseDamage = ${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER'
		echo 'Allow_osCauseHealing =${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER'
		echo 'Allow_osSetHealth = ${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER'
		echo 'Allow_osSetHealRate = ${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER'
		echo 'Allow_osForceAttachToAvatar = ${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER'
		echo 'Allow_osForceAttachToAvatarFromInventory = ${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER'
		echo 'Allow_osForceCreateLink = ${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER'
		echo 'Allow_osForceDropAttachment = ${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER'
		echo 'Allow_osForceDropAttachmentAt = ${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER'
		echo 'Allow_osGetLinkPrimitiveParams =${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER'
		echo 'Allow_osGetPhysicsEngineType =true'
		echo 'Allow_osGetRegionMapTexture = true'
		echo 'Allow_osGetScriptEngineName = true'
		echo 'Allow_osGetSimulatorVersion = true'
		echo 'Allow_osMakeNotecard =true'
		echo 'Allow_osMatchString = true'
		echo 'Allow_osNpcCreate = true'
		echo 'Allow_osNpcGetPos = true'
		echo 'Allow_osNpcGetRot = true'
		echo 'Allow_osNpcLoadAppearance = true'
		echo 'Allow_osNpcMoveTo = true'
		echo 'Allow_osNpcMoveToTarget = true'
		echo 'Allow_osNpcPlayAnimation =true'
		echo 'Allow_osNpcRemove = true'
		echo 'Allow_osNpcSaveAppearance = true'
		echo 'Allow_osNpcSay =true'
		echo 'Allow_osNpcSayTo =true'
		echo 'Allow_osNpcSetRot = true'
		echo 'Allow_osNpcShout =true'
		echo 'Allow_osNpcSit =true'
		echo 'Allow_osNpcStand =true'
		echo 'Allow_osNpcStopAnimation =true'
		echo 'Allow_osNpcStopMoveToTarget = true'
		echo 'Allow_osNpcTouch =true'
		echo 'Allow_osNpcWhisper =true'
		echo 'Allow_osOwnerSaveAppearance = ${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER'
		echo 'Allow_osParcelJoin =ESTATE_MANAGER,ESTATE_OWNER'
		echo 'Allow_osParcelSubdivide = ESTATE_MANAGER,ESTATE_OWNER'
		echo 'Allow_osRegionRestart = ESTATE_MANAGER,ESTATE_OWNER'
		echo 'Allow_osRegionNotice =ESTATE_MANAGER,ESTATE_OWNER'
		echo 'Allow_osSetProjectionParams = ${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER'
		echo 'Allow_osSetRegionWaterHeight =ESTATE_MANAGER,ESTATE_OWNER'
		echo 'Allow_osSetTerrainHeight =ESTATE_MANAGER,ESTATE_OWNER'
		echo 'Allow_osSetTerrainTexture = ESTATE_MANAGER,ESTATE_OWNER'
		echo 'Allow_osSetTerrainTextureHeight = ESTATE_MANAGER,ESTATE_OWNER'
		echo 'Allow_osAgentSaveAppearance = true'
		echo 'Allow_osAvatarPlayAnimation = true'
		echo 'Allow_osAvatarStopAnimation = true'
		echo 'Allow_osForceAttachToOtherAvatarFromInventory = ${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER'
		echo 'Allow_osForceDetachFromAvatar = ${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER'
		echo 'Allow_osForceOtherSit = true'
		echo 'Allow_osGetNotecard = true'
		echo 'Allow_osGetNotecardLine = true'
		echo 'Allow_osGetNumberOfNotecardLines = true'
		echo 'Allow_osSetDynamicTextureURL =true'
		echo 'Allow_osSetDynamicTextureURLBlend = true'
		echo 'Allow_osSetDynamicTextureURLBlendFace = true'
		echo 'Allow_osSetRot= ${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER'
		echo 'Allow_osSetParcelDetails =${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER'
		echo 'Allow_osConsoleCommand =false'
		echo 'Allow_osKickAvatar =${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER'
		echo 'Allow_osTeleportAgent = ${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER'
		echo 'Allow_osTeleportObject =${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER'
		echo 'Allow_osGetAgentIP =true'
		echo 'Allow_osSetContentType =${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER'
	} >"/$STARTVERZEICHNIS/$DATEIDATUM-osslEnable.ini"
	return 0
}

### ! Umbenennen der example Dateien in Konfigurationsdateien vor dem kopieren.
function unlockexample() {
	log info "RENAME: Alle example Dateien umbenennen"
	UEVERZEICHNIS1="/$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/bin"
	UEVERZEICHNIS2="/$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/bin/config-include"

	for file1 in /"$STARTVERZEICHNIS"/"$OPENSIMVERZEICHNIS"/bin/*.example; do
		if [ -e "$file1" ]; then
			cd "$UEVERZEICHNIS1" || exit
			for file in *.ini.example; do mv -i "${file}" "${file%%.ini.example}.ini"; done
			for file in *.html.example; do mv -i "${file}" "${file%%.html.example}.html"; done
			for file in *.txt.example; do mv -i "${file}" "${file%%.txt.example}.txt"; done
			break
		else
			log error "RENAME: keine example Datei im Verzeichnis $UEVERZEICHNIS1 vorhanden"
		fi
	done

	for file2 in /"$STARTVERZEICHNIS"/"$OPENSIMVERZEICHNIS"/bin/config-include/*.example; do
		if [ -e "$file2" ]; then
			cd "$UEVERZEICHNIS2" || exit
			for file in *.ini.example; do mv -i "${file}" "${file%%.ini.example}.ini"; done
			break
		else
			log error "ENAME: keine example Datei im Verzeichnis $UEVERZEICHNIS2 vorhanden"
		fi
	done
	return 0
}

### newregionini - eine neue Regionsdatei schreiben.
function newregionini() {
	# Aktuelle IP ueber Suchadresse ermitteln und Ausfuehrungszeichen anhaengen.
	DNAAKTUELLEIP="$(wget -O - -q $SEARCHADRES)"

	# Wohin soll die Datei geschrieben werden 1.
    echo "Fuer welchen Simulator moechten sie die Regionskonfigurationsdatei erstellen sim1, sim2, sim..."
    echo "Enter fuer das Hauptverzeichnis."
    read -r simname

    echo "Regionsname [Welcome]"
	read -r regionsname
	if [ -z "$regionsname" ]; then regionsname="Welcome"; fi

	echo "Geben Sie ihre Server Adresse ein: (Beispiel meinserver.de oder 192.168.2.1) [$AKTUELLEIP]"
	read -r DNANAME
	if [ -z "$DNANAME" ]; then DNANAME=$DNAAKTUELLEIP; fi

	echo "Ort im Grid X Y [4500,4500]"
	read -r STARTPUNKT
	if [ -z "$STARTPUNKT" ]; then STARTPUNKT="4500,4500"; fi

	echo "Groesse der Region: 512"
	read -r groesseregion
	if [ -z "$groesseregion" ]; then groesseregion=512; fi

	echo "InternalPort Beispiel: 9150"
	read -r INTERNALPORT
	if [ -z "$INTERNALPORT" ]; then INTERNALPORT=9150; fi

    # Wohin soll die Datei geschrieben werden 2.
    if [ -z "$simname" ] 
    then
        # /opt/
        pfad="/$STARTVERZEICHNIS/$regionsname.ini"
    else
        # /opt/sim1/bin/Regions
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

###########################################################################
# Samples
###########################################################################

### !  gridstop, stoppt erst Money dann Robust.
function gridstop() {
	if screen -list | grep -q MO; then
		mostop
	fi

	if screen -list | grep -q RO; then
		rostop
	fi
	return 0
}
### !  gridstop, stoppt erst Money dann Robust.
function menugridstop() {
	if screen -list | grep -q MO; then
		menumostop
	fi

	if screen -list | grep -q RO; then
		menurostop
	fi
	return 0
}

### !  compilieren, kompilieren des OpenSimulator.
function compilieren() {
	log info "COMPILIEREN: Bauen eines neuen OpenSimulators  wird gestartet..."
	# Nachsehen ob Verzeichnis ueberhaupt existiert.
	if [ ! -f "/$STARTVERZEICHNIS/$SCRIPTSOURCE/" ]; then
		scriptcopy
	else
		log error "COMPILIEREN: OSSL Script Verzeichnis existiert nicht"
	fi

	if [ ! -f "/$STARTVERZEICHNIS/$MONEYSOURCE/" ]; then
		moneycopy
	else
		log error "COMPILIEREN: MoneyServer Verzeichnis existiert nicht"
	fi

	if [ ! -f "/$STARTVERZEICHNIS/$CONFIGURESOURCE/" ]; then
		configurecopy
	else
		log error "COMPILIEREN: Configure Verzeichnis existiert nicht"
	fi

	if [ ! -f "/$STARTVERZEICHNIS/$OSSEARCHCOPY/" ]; then
		searchgitcopy
	else
		log error "COMPILIEREN: OpenSimSearch Verzeichnis existiert nicht"
	fi

	if [ ! -f "/$STARTVERZEICHNIS/OpensimPython/" ]; then
		pythoncopy
	else
		log error "COMPILIEREN: OpensimPython Verzeichnis existiert nicht"
	fi

	if [ ! -f "/$STARTVERZEICHNIS/OpenSimSearch/" ]; then
		searchcopy
	else
		log error "COMPILIEREN: OpenSimSearch Verzeichnis existiert nicht"
	fi

	if [ ! -f "/$STARTVERZEICHNIS/OpenSimMutelist/" ]; then
		mutelistcopy
	else
		log error "COMPILIEREN: OpenSimMutelist Verzeichnis existiert nicht"
	fi

	if [ ! -f "/$STARTVERZEICHNIS/Chris.OS.Additions/" ]; then
		chrisoscopy
	else
		log error "COMPILIEREN: Chris.OS.Additions Verzeichnis existiert nicht"
	fi

	if [ ! -f "/$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/" ]; then

		# AOT Aktiveren oder Deaktivieren.
		if [[ $SETAOTON = "yes" ]]; then
			oscompiaot
		else
			oscompi
		fi

	else
		log error "COMPILIEREN: opensim Verzeichnis existiert nicht"
	fi
	return 0
}

### !  OSGRIDCOPY, automatisches kopieren des opensimulator aus dem verzeichnis opensim.
function osgridcopy() {
	log text " #############################"
	log text "Steht hier:"
	log text " "
	log info "Build succeeded."
	log text "    0 Warning(s)"
	log text "    0 Error(s)"
	log text " "
	log info "Dann ist alles gut gegangen.
	log text " #############################"
	log warn " !!!      BEI FEHLER      !!! "
	log warn " !!! ABBRUCH MIT STRG + C !!! "
	log text " #############################"

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

### !  osupgrade, automatisches upgrade des opensimulator aus dem verzeichnis opensim.
function osupgrade() {
	log text " #############################"
	log text " !!!      BEI FEHLER      !!! "
	log text " !!! ABBRUCH MIT STRG + C !!! "
	log text " #############################"

	log info "Das Grid wird jetzt upgegradet"
	autostop
	# Kopieren.
	log line
	log info "Neue Version Installieren"
	oscopyrobust
	oscopysim
	autologdel
	rologdel
	# MoneyServer eventuell loeschen.
	if [ "$MONEYVERZEICHNIS" = "keins" ] || [ "$MONEYVERZEICHNIS" = "no" ] || [ "$MONEYVERZEICHNIS" = "nein" ]; then moneydelete; fi
	# Grid Starten.
	# log info "Das Grid wird jetzt gestartet"
	autostart
	return 0
}

### !  osupgrade, automatisches upgrade des opensimulator aus dem verzeichnis opensim.
function oszipupgrade() {
	### dialog Aktionen
	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then
		# Alle Aktionen mit dialog
		VERSIONSNUMMER=$(dialog --backtitle "opensimMULTITOOL $VERSION" --title "opensimMULTITOOL Eingabe" --inputbox "Versionsnummer:" 8 40 3>&1 1>&2 2>&3 3>&-)
		dialogclear
		ScreenLog
	else
		# Alle Aktionen ohne dialog
		echo "Keine Menuelose Funktion vorhanden!" | exit
		#VERSIONSNUMMER=$1
	fi
	# dialog Aktionen Ende

	cd /"$STARTVERZEICHNIS" || exit

	# Konfigurationsabfrage Neues Grid oder Upgrade.
	log info "OSBUILDING: Alten OpenSimulator sichern"
	osdelete

	log line

	log info "OSBUILDING: Neuen OpenSimulator aus der ZIP entpacken"
	unzip opensim-0.9.2.2."$VERSIONSNUMMER".zip

	log line

	log info "OSBUILDING: Neuen OpenSimulator umbenennen"
	mv /"$STARTVERZEICHNIS"/opensim-0.9.2.2."$VERSIONSNUMMER"/ /"$STARTVERZEICHNIS"/opensim/

	log line

	osupgrade
	return 0
}

###########################################################################
# Automatische Konfigurationen Prototype
###########################################################################

### !  Hier entsteht die Automatische Konfiguration. UNGETESTET
# Aufruf: ./opensim.sh AutoInstall

### Config Set - Reduziert die Konfigurationsdateien auf ein uebersichtliches Mass.
function ConfigSet() {
    datei=$1

    echo "Loesche $datei.ini.cnf"
    rm "$datei.ini.cnf"

    echo "Kopiere $datei.ini nach $datei.ini.cnf"
    cp "$datei.ini" "$datei.ini.cnf"

    echo "Loesche alle Zeilen mit ;"
    #sed -i -e '/string/d' input
    sed -i -e '/;/d' "$datei.ini.cnf"

    echo "Fuehrende Leerzeichen (Leerzeichen, Tabulatoren) vor jeder Zeile loeschen"
    sed -i -e 's/^[ \t]*//' "$datei.ini.cnf"

    echo "Loesche alle leeren Zeilen"
    sed -i -e '/^$/d' "$datei.ini.cnf"

    echo "Ersetze alle doppelten Hochstriche gegen einfache."
    sed -i -e s/\"/\'/g "$datei.ini.cnf"

    echo "Einstrich Sonderzeichen an den anfang und ende jeder Zeile haengen."
    sed -i -e s/^/\"/ "$datei.ini.cnf"
    sed -i -e s/$/\"/g "$datei.ini.cnf"

    echo "Ein Array daraus machen."
    sed -i -e 1 i\$dateiConfigList=\( "$datei.ini.cnf"
    sed -i -e '$a)' "$datei.ini.cnf"
}

### AutoInstall
function AutoInstall() {
    ramspeicher
    mysqlspeicher=$((RAMSPEICHER / 2))

    echo "RAM Speicher für Simulatoren betraegt etwa: $mysqlspeicher"
    echo "Herzlich willkommen zur Konfiguration ihrer OpenSimulator Software."
    echo "Möchten sie eine Grundinstallation ihres Servers, "    
    echo "damit alle für den Betrieb benötigten Linux Pakete installiert werden Ja/Nein: [Nein]"

    installation=Nein; read -r installation
    if [ "$installation" = "Ja" ]; then
        if myCodename=jammy; then
            echo "entdeckt Ubuntu 22"
            installbegin
            installubuntu22
            installmono22
            installphpmyadmin
            ufwset
            #installationhttps22
            installfinish
        elif myCodename=Bionic; then
            echo "entdeckt Ubuntu 18"
            serverupgrade
            installobensimulator
            monoinstall18
            installfinish
        else
            echo "Ich kenne das Betriebssystem nicht"
        fi
    fi

    echo "Als nächstes benötige ich ein Paar Daten von ihnen."

    BaseHostname=$AKTUELLEIP
    echo "Wie ist ihre IP oder URL Adresse [$AKTUELLEIP]: "; read -r BaseHostname
	echo "Debug: $BaseHostname"

    gridname="'$BaseHostname'World"
    echo "Welchen Namen soll ihr Grid haben: ['$BaseHostname'World] "; read -r gridname
	echo "Debug: $gridname"

    ### OpenSim Verzeichnisstruktur
    anzahlregionen=5
    echo "Wie viele Regionsserver möchten sie anlegen: [5]"; read -r anzahlregionen
    osstruktur 1 "$anzahlregionen"
	echo "Debug: osstruktur 1 $anzahlregionen"
    oscopyrobust
	echo "Debug: oscopyrobust"
	oscopysim
	echo "Debug: oscopysim"

    ### Datenbankbenutzer erstellen
    datenbank_benutzer="Nein"
    echo "Moechten Sie einen neuen Datenbankbenutzer anlegen? [Nein]"; read -r datenbank_benutzer
    if [ "$datenbank_benutzer" = "Ja" ]
    then 
        DBBENUTZER="opensim"
        echo "DBBENUTZER: [$DBBENUTZER]"; read -r DBBENUTZER
        DBPASSWORT="opensim" 
        echo "DBPASSWORT: [$DBPASSWORT]"; read -r DBPASSWORT

        NEUERNAME="opensim"  
        echo "DATENBANKNAME: [$NEUERNAME]"; read -r NEUERNAME
		MysqlUser=$NEUERNAME
        NEUESPASSWORT="opensim"  
        echo "DATENBANKNAME: [$NEUESPASSWORT]"; read -r NEUESPASSWORT
		MysqlPassword=$NEUESPASSWORT

        create_db_user "$DBBENUTZER" "$DBPASSWORT" "$NEUERNAME" "$NEUESPASSWORT"
        DBBENUTZER="$NEUERNAME" 
        DBPASSWORT="$NEUESPASSWORT"
    fi

	echo "Debug: Datenbankbenutzer erstellen $datenbank_benutzer"

	# MysqlUser="$DBBENUTZER"; MysqlPassword="$DBPASSWORT"; MysqlDatabase="$DATENBANKNAME"
    # echo "Name der mySQL Datenbank [MysqlDatabase]: "; read -r MysqlDatabase
    # echo "Benutzername der Datenbank [MysqlUser]: "; read -r MysqlUser
    # echo "Passwort des des Benutzers der Datenbank [******]: "; read -r MysqlPassword
	# echo "Debug: Datenbanken anlegen $datenbanken_angelegen"

    ### Datenbanken erstellen
    datenbanken_angelegen="Nein"
    echo "Moechten sie Datenbanken anlegen?: [Nein]"; read -r datenbanken_angelegen
	echo "Debug: Datenbanken anlegen $datenbanken_angelegen"
    if [ "$datenbanken_angelegen" = "Ja" ]
    then 
        DBBENUTZER="opensim"
        echo "DBBENUTZER: [$DBBENUTZER]"; read -r DBBENUTZER
        DBPASSWORT="opensim" 
        echo "DBPASSWORT: [$DBPASSWORT]"; read -r DBPASSWORT
        DATENBANKNAME="opensim"  
        echo "DATENBANKNAME: [$DATENBANKNAME]"; read -r DATENBANKNAME

        create_db "$DBBENUTZER" "$DBPASSWORT" robust
        
        makeverzeichnisliste
        for ((i = 0; i < "$ANZAHLVERZEICHNISSLISTE"; i++)); do
			echo "Datenbank ${VERZEICHNISSLISTE[$i]} wird erstellt."
			create_db "$DBBENUTZER" "$DBPASSWORT" "sim${VERZEICHNISSLISTE[$i]}"
			sleep 2
		done
    fi    
    
    # # Wir müssen jetzt einen Master Avatar anlegen, 
    # # dieser wird auch direkt der Banker für das Money System 
    # # und verfügt über alle Skript rechte.
    masteravatar_angelegen="Nein"
    echo "Moechten sie einen Master Avatar anlegen?: [Nein]"; read -r masteravatar_angelegen
	echo "Debug: Master Avatar anlegen: $masteravatar_angelegen"
    if [ "$masteravatar_angelegen" = "Ja" ]
    then
        masteravatar_UUID=$(uuidgen)
        echo "UUID: [$masteravatar_UUID]"; read -r masteravatar_UUID
        VORNAME="Max"
        echo "VORNAME: [$VORNAME]"; read -r VORNAME
        NACHNAME="Mustermann"
        echo "NACHNAME: [$NACHNAME]"; read -r NACHNAME
        PASSWORT="123456"
        echo "PASSWORT: [$PASSWORT]"; read -r PASSWORT
        EMAIL="mail@mail.com"
        echo "EMAIL: [$EMAIL]"; read -r EMAIL
        createuser "$VORNAME" "$NACHNAME" "$PASSWORT" "$EMAIL" "$masteravatar_UUID"
    fi

    ##### OpenSimConfigSet
    
    #SimulatorPort=9010
    #echo "Bitte geben sie den Simulator Port ein [9010]: "; read -r SimulatorPort
    #AutoBackup="Nein"
    #echo "Moechten sie den Automatischen Backup ihrer Regionen einschalten? [Nein]: "; read -r AutoBackup

    ##### osslEnableConfigSet
    echo "Alle Skript Rechte an Grid Betreiber [$masteravatar_UUID]: "; read -r Rechte # Vorher einen Robust Master User erstellen.

    ##### RegionsConfigSet
    UUID=$(uuidgen)
    echo "RegionName [Welcome]:"; read -r RegionName
    echo "RegionUUID [$UUID]: "; read -r RegionUUID
    echo "Location [3333,3333]: "; read -r Location
    echo "InternalPort [9050]: "; read -r InternalPort
    echo "ExternalHostName [127.0.0.1]: "; read -r ExternalHostName
    echo "Size [512]: "; read -r Size
    echo "MaxPrims [100000]: "; read -r MaxPrims
    echo "MaxAgents [50]: "; read -r MaxAgents

    ##### RobustConfigSet
    echo "StartRegion [Welcome]: "; read -r StartRegion
    
    PublicPort="8002"
    PrivatePort="8003"
    MoneyPort="8008"
	BenutzerUUID=$(uuidgen)
    
    # Auswertung der Eingaben.
    if test -z "$BaseHostname"; then BaseHostname="127.0.0.1"; fi
    if test -z "$SimulatorPort"; then SimulatorPort="9010"; fi
    if test -z "$gridname"; then gridname="myGrid"; fi
    if test -z "$AutoBackup"; then AutoBackup="false"; fi
    if test -z "$HomeURI"; then HomeURI="127.0.0.1"; fi
    if test -z "$UserID"; then UserID="myName"; fi
    if test -z "$Rechte"; then Rechte="$BenutzerUUID"; fi
    if test -z "$RegionName"; then RegionName="Welcome"; fi
    if test -z "$RegionUUID"; then RegionUUID="$UUID"; fi
    if test -z "$Location"; then Location="1000,1000"; fi
    if test -z "$InternalPort"; then InternalPort="9050"; fi
    if test -z "$ExternalHostName"; then ExternalHostName="127.0.0.1"; fi
    if test -z "$Size"; then Size="512"; fi
    if test -z "$MaxPrims"; then MaxPrims="100000"; fi
    if test -z "$MaxAgents"; then MaxAgents="50"; fi
    if test -z "$MysqlDatabase"; then MysqlDatabase="myDatabase"; fi
    if test -z "$MysqlUser"; then MysqlUser="myUser"; fi
    if test -z "$MysqlPassword"; then MysqlPassword="myPassword"; fi    
    if test -z "$StartRegion"; then StartRegion="Welcome"; fi

    PrivURL=$BaseHostname
    BaseURL="http://$BaseHostname"
    HomeURI=$BaseHostname

    ##### Start #####
    RobustConfigSet $BaseHostname $gridname $UserID $MysqlPassword $MysqlDatabase $StartRegion $PublicPort $PrivatePort $PrivURL $BaseURL $MoneyPort

    makeverzeichnisliste

    for ((i = 0; i < "$ANZAHLVERZEICHNISSLISTE"; i++)); do
        echo "OpenSimKonfiguration ${VERZEICHNISSLISTE[$i]} wird erstellt."
        OpenSimConfigSet $BaseHostname "$SimulatorPort${VERZEICHNISSLISTE[$i]}" $gridname $AutoBackup $PublicPort $PrivatePort $BaseURL $MoneyPort
        sleep 2
        GridCommonConfigSet $HomeURI "$MysqlDatabase${VERZEICHNISSLISTE[$i]}" $UserID $MysqlPassword $PublicPort $PrivatePort
        sleep 2
        RegionsConfigSet "$RegionName${VERZEICHNISSLISTE[$i]}" "$RegionUUID" $Location "$InternalPort+${VERZEICHNISSLISTE[$i]}" $ExternalHostName $Size $MaxPrims $MaxAgents "$UUID"
        sleep 2
        osslEnableConfigSet "$Rechte"
        sleep 2
    done        
    #OpenSimConfigSet $BaseHostname $SimulatorPort $gridname $AutoBackup $PublicPort $PrivatePort $BaseURL $MoneyPort   
    #GridCommonConfigSet $HomeURI $MysqlDatabase $UserID $MysqlPassword $PublicPort $PrivatePort
    #osslEnableConfigSet "$Rechte"
    #RegionsConfigSet $RegionName "$RegionUUID" $Location $InternalPort $ExternalHostName $Size $MaxPrims $MaxAgents "$UUID"
}

### OpenSim Config
function OpenSimConfig() {
    # Abfrage des Benutzers.
    echo "Bitte geben sie die IP oder DNS Adresse ihres Server oder PC ein [127.0.0.1]: "; read -r BaseHostname
    echo "Bitte geben sie den Simulator Port ein [9010]: "; read -r SimulatorPort
    echo "Bitte geben sie den Gridnamen ein [myGrid]: "; read -r gridname
    echo "Moechten sie den Automatischen Backup ihrer Regionen einschalten true/false [false]: "; read -r AutoBackup
    # Auswertung der Eingaben.
    if test -z "$BaseHostname"; then BaseHostname="127.0.0.1"; fi
    if test -z "$SimulatorPort"; then SimulatorPort="9010"; fi
    if test -z "$gridname"; then gridname="myGrid"; fi
    if test -z "$AutoBackup"; then AutoBackup="false"; fi

    PublicPort="8002"
    PrivatePort="8003"
    PrivURL=$BaseHostname
    BaseURL="http://$BaseHostname"
    MoneyPort="8008"

    OpenSimConfigSet $BaseHostname $SimulatorPort $gridname $AutoBackup $PublicPort $PrivatePort $BaseURL $MoneyPort
    # OpenSimConfigSet
}
function OpenSimConfigSet() {
    #  $BaseHostname,$SimulatorPort,$gridname,$AutoBackup,$PublicPort,$PrivatePort,$BaseURL,$MoneyPort
    OpenSimdatei="OpenSim.ini"
    OpenSimConfigList=(
    "[Const]"
    "BaseHostname = '$BaseHostname'"
    "BaseURL = '$BaseURL'"
    "PublicPort = '$PublicPort'"
    "PrivURL = '$BaseURL'"
    "PrivatePort = '$PrivatePort'"
    "MoneyPort = '$MoneyPort'"
    "SimulatorPort = '$SimulatorPort'"
    "[Startup]"
    "NonPhysicalPrimMax = 1024"
    "DefaultDrawDistance = 128.0"
    "MaxDrawDistance = 128"
    "MaxRegionsViewDistance = 128"
    "MinRegionsViewDistance = 48"
    "meshing = Meshmerizer"
    "physics = BulletSim"
    "DefaultScriptEngine = 'YEngine'"
    "[AccessControl]"
    "DeniedClients = 'Imprudence|CopyBot|Twisted|Crawler|Cryolife|darkstorm|DarkStorm|Darkstorm|hydrastorm viewer|kinggoon copybot|goon squad copybot|copybot pro|darkstorm viewer|copybot club|darkstorm second life|copybot download|HydraStorm Copybot Viewer|Copybot|Firestorm Pro|DarkStorm v3|DarkStorm v2|ShoopedStorm|HydraStorm|hydrastorm|kinggoon|goon squad|goon|copybot|Shooped|ShoopedStorm|Triforce|Triforce Viewer|Firestorm Professional|ShoopedLife|Sombrero|Sombrero Firestorm|GoonSquad|Solar|SolarStorm'"
    "[Map]"
    "DrawPrimOnMapTile = true"
    "RenderMeshes = true"
    "[Permissions]"
    "automatic_gods = false"
    "implicit_gods = false"
    "allow_grid_gods = true"
    "[Estates]"
    "[SMTP]"
    "[Network]"
    "http_listener_port = '$SimulatorPort'"
    "ExternalHostNameForLSL = '$BaseURL'"
    "shard = 'OpenSim'"
    "user_agent = 'OpenSim LSL (Mozilla Compatible)'"
    "[XMLRPC]"
    "[ClientStack.LindenUDP]"
    "DisableFacelights = 'true'"
    "client_throttle_max_bps = 400000"
    "scene_throttle_max_bps = 75000000"
    "[ClientStack.LindenCaps]"
    "Cap_GetTexture = 'localhost'"
    "Cap_GetMesh = 'localhost'"
    "Cap_AvatarPickerSearch = 'localhost'"
    "Cap_GetDisplayNames = 'localhost'"
    "[SimulatorFeatures]"
    "SearchServerURI = $BaseURL:$PublicPort"
    "DestinationGuideURI = $BaseURL:$PublicPort"
    "[Chat]"
    "whisper_distance = 25"
    "say_distance = 70"
    "shout_distance = 250"
    "[EntityTransfer]"
    "[Messaging]"
    "OfflineMessageModule = 'Offline Message Module V2'"
    "OfflineMessageURL = $PrivURL:$PrivatePort"
    "StorageProvider = OpenSim.Data.MySQL.dll"
    "MuteListModule = MuteListModule"
    "ForwardOfflineGroupMessages = true"
    "[BulletSim]"
    "AvatarToAvatarCollisionsByDefault = true"
    "[ODEPhysicsSettings]"
    "[RemoteAdmin]"
    "[Wind]"
    "[Materials]"
    "enable_materials = true"
    "MaxMaterialsPerTransaction = 250"
    "[DataSnapshot]"
    "index_sims = true"
    "data_exposure = minimum"
    "gridname = '$gridname'"
    "default_snapshot_period = 7200"
    "snapshot_cache_directory = 'DataSnapshot'"
    "[Economy]"
    "SellEnabled = true"
    "EconomyModule = DTLNSLMoneyModule"
    "CurrencyServer = '$BaseURL:8008/'"
    "UserServer = '$BaseURL:$PublicPort/'"
    "CheckServerCert = false"
    "PriceUpload = 0"
    "MeshModelUploadCostFactor = 1.0"
    "MeshModelUploadTextureCostFactor = 1.0"
    "MeshModelMinCostFactor = 1.0"
    "PriceGroupCreate = 0"
    "ObjectCount = 0"
    "PriceEnergyUnit = 0"
    "PriceObjectClaim = 0"
    "PricePublicObjectDecay = 0"
    "PricePublicObjectDelete = 0"
    "PriceParcelClaim = 0"
    "PriceParcelClaimFactor = 1"
    "PriceRentLight = 0"
    "TeleportMinPrice = 0"
    "TeleportPriceExponent = 2"
    "EnergyEfficiency = 1"
    "PriceObjectRent = 0"
    "PriceObjectScaleFactor = 10"
    "PriceParcelRent = 0"
    "[YEngine]"
    "Enabled = true"
    "[XEngine]"
    "Enabled = false"
    "AppDomainLoading = false"
    "DeleteScriptsOnStartup = true"
    "[OSSL]"
    "Include-osslDefaultEnable = 'config-include/osslDefaultEnable.ini'"
    "[FreeSwitchVoice]"
    "[VivoxVoice]"
    "enabled = false"
    "vivox_server = www.osp.vivox.com"
    "vivox_sip_uri = osp.vivox.com"
    "vivox_admin_user = myName"
    "vivox_admin_password = myPassword"
    "vivox_channel_type = positional"
    "vivox_channel_distance_model = 2"
    "vivox_channel_mode = 'open'"
    "vivox_channel_roll_off = 2.0"
    "vivox_channel_max_range = 80"
    "vivox_channel_clamping_distance = 10"
    "[Groups]"
    "Enabled = true"
    "LevelGroupCreate = 0"
    "Module = 'Groups Module V2'"
    "StorageProvider = OpenSim.Data.MySQL.dll"
    "ServicesConnectorModule = Groups HG Service Connector"
    "LocalService = remote"
    "GroupsServerURI = '$BaseURL:$PrivatePort'"
    "HomeURI = '$BaseURL:$PublicPort'"
    "MessagingEnabled = true"
    "MessagingModule = 'Groups Messaging Module V2'"
    "NoticesEnabled = true"
    "MessageOnlineUsersOnly = true"
    "XmlRpcServiceReadKey    = 1234"
    "XmlRpcServiceWriteKey   = 1234"
    "[InterestManagement]"
    "UpdatePrioritizationScheme = BestAvatarResponsiveness"
    "ObjectsCullingByDistance = true"
    "[MediaOnAPrim]"
    "[NPC]"
    "Enabled = true"
    "MaxNumberNPCsPerScene = 40"
    "AllowNotOwned = true"
    "AllowSenseAsAvatar = true"
    "AllowCloneOtherAvatars = true"
    "NoNPCGroup = true"
    "[Terrain]"
    "InitialTerrain = 'flat'"
    "[LandManagement]"
    "ShowParcelBansLines = true"
    "[UserProfiles]"
    "ProfileServiceURL = '$BaseURL:$PublicPort'"
    "AllowUserProfileWebURLs = true"
    "[XBakes]"
    "URL = '$PrivURL:$PrivatePort'"
    "[Attachments]"
    "[Textures]"
    "ReuseDynamicTextures = true"
    "ReuseDynamicLowDataTextures = true"
    "[AutoBackupModule]"
    "AutoBackup = '$AutoBackup'"
    "AutoBackupModuleEnabled = '$AutoBackup'"
    "AutoBackupInterval = 1260"
    "AutoBackupBusyCheck = false"
    "AutoBackupThreshold = 1"
    "AutoBackupSkipAssets = false"
    "AutoBackupNaming = Time"
    "AutoBackupKeepFilesForDays = 7"
    "AutoBackupDir = '/tmp/backup'"
    "[Architecture]"
    "Include-Architecture = 'config-include/GridHypergrid.ini'"
    )

    #echo "Alte $OpenSimdatei Datei loeschen falls vorhanden."
    rm -f $OpenSimdatei # || echo "Keine $OpenSimdatei Datei vorhanden."

    #echo "$OpenSimdatei schreiben"
    printf '%s\n' "${OpenSimConfigList[@]}" > $OpenSimdatei

    #echo "Tausche Hochstriche aus."
    sed -i -e s/\'/\"/g "$OpenSimdatei"
}

### GridCommon Config
function GridCommonConfig() {
    # Abfrage des Benutzers.
    echo "IP oder Adresse des Servers [127.0.0.1]: "; read -r HomeURI
    echo "Datenbankname [sim1]: "; read -r MysqlDatabase
    echo "Benutzername der Datenbank [myName]: "; read -r UserID
    echo "Passwort des des Benutzers der Datenbank [myPassword]: "; read -r MysqlPassword
    # Auswertung der Eingaben.
    if test -z "$HomeURI"; then HomeURI="127.0.0.1"; fi
    if test -z "$MysqlDatabase"; then MysqlDatabase="sim1"; fi
    if test -z "$UserID"; then UserID="myName"; fi
    if test -z "$MysqlPassword"; then MysqlPassword="myPassword"; fi

    PublicPort="8002"
    PrivatePort="8003"

    GridCommonConfigSet $HomeURI $MysqlDatabase $UserID $MysqlPassword $PublicPort $PrivatePort
}
function GridCommonConfigSet() {
    GridCommondatei="GridCommon.ini"

    GridCommonConfigList=(
    "[DatabaseService]"
    "StorageProvider = 'OpenSim.Data.MySQL.dll'"
    "ConnectionString = 'Data Source=localhost;Database='$MysqlDatabase';User ID='$UserID';Password='$MysqlPassword';Old Guids=true;SslMode=None;'"
    "[Hypergrid]"
    "HomeURI = '$HomeURI'"
    "GatekeeperURI = 'http://'$HomeURI:$PublicPort'"
    "[Modules]"
    "AssetCaching = 'FlotsamAssetCache'"
    "Include-FlotsamCache = 'config-include/FlotsamCache.ini'"
    "[AssetService]"
    "DefaultAssetLoader = 'OpenSim.Framework.AssetLoader.Filesystem.dll'"
    "AssetLoaderArgs = 'assets/AssetSets.xml'"
    "AssetServerURI = 'http://'$HomeURI:$PrivatePort'"
    "[InventoryService]"
    "InventoryServerURI = 'http://'$HomeURI:$PrivatePort'"
    "[GridInfo]"
    "GridInfoURI = 'http://'$HomeURI:$PublicPort'"
    "[GridService]"
    "GridServerURI = 'http://'$HomeURI:$PrivatePort'"
    "AllowHypergridMapSearch = true"
    "MapTileDirectory = './maptiles'"
    "Gatekeeper='http://'$HomeURI:$PublicPort'"
    "[EstateDataStore]"
    "[EstateService]"
    "EstateServerURI = 'http://$HomeURI:$PrivatePort'"
    "[Messaging]"
    "Gatekeeper = 'http://'$HomeURI:$PublicPort'"
    "[AvatarService]"
    "AvatarServerURI = 'http://'$HomeURI:$PrivatePort'"
    "[AgentPreferencesService]"
    "AgentPreferencesServerURI = 'http://'$HomeURI:$PrivatePort'"
    "[PresenceService]"
    "PresenceServerURI = 'http://'$HomeURI:$PrivatePort'"
    "[UserAccountService]"
    "UserAccountServerURI = 'http://'$HomeURI:$PrivatePort'"
    "[GridUserService]"
    "GridUserServerURI = 'http://'$HomeURI:$PrivatePort'"
    "[AuthenticationService]"
    "AuthenticationServerURI = 'http://'$HomeURI:$PrivatePort'"
    "[FriendsService]"
    "FriendsServerURI = 'http://'$HomeURI:$PrivatePort'"
    "[HGInventoryAccessModule]"
    "HomeURI = 'http://'$HomeURI:$PublicPort'"
    "Gatekeeper = 'http://'$HomeURI:$PublicPort'"
    "RestrictInventoryAccessAbroad = false"
    "[HGAssetService]"
    "HomeURI = 'http://'$HomeURI:$PublicPort'"
    "[HGFriendsModule]"
    "[UserAgentService]"
    "UserAgentServerURI = 'http://'$HomeURI:$PublicPort'"
    "[MapImageService]"
    "MapImageServerURI = 'http://'$HomeURI:$PrivatePort'"
    "[AuthorizationService]"
    "[MuteListService]"
    "MuteListServerURI = 'http://'$HomeURI:$PrivatePort'"
    )
    echo "Alte $GridCommondatei Datei loeschen falls vorhanden."
    rm -f $GridCommondatei # || echo "Keine $GridCommondatei Datei vorhanden."

    echo "$GridCommondatei schreiben"
    printf '%s\n' "${GridCommonConfigList[@]}" > $GridCommondatei

    echo "Tausche Hochstriche aus."
    sed -i -e s/\'/\"/g "$GridCommondatei"
}

### osslEnable Config
function osslEnableConfig() {
    # Abfrage des Benutzers.
    echo "Alle Skript Rechte an Grid Betreiber [$BenutzerUUID]: "; read -r Rechte
    # Auswertung der Eingaben.
    if test -z "$Rechte"; then Rechte="$BenutzerUUID"; fi

    osslEnableConfigSet "$Rechte"
}
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
    echo "Alte $osslEnabledatei Datei loeschen falls vorhanden."
    rm -f $osslEnabledatei # || echo "Keine $osslEnabledatei Datei vorhanden."

    echo "$osslEnabledatei schreiben"
    printf '%s\n' "${OsslEnableConfigList[@]}" > $osslEnabledatei

    echo "Tausche Hochstriche aus."
    sed -i -e s/\'/\"/g "$GridCommondatei"
}

### Regions Config
function RegionsConfig() {
    UUID=$(uuidgen)
    # Abfrage des Benutzers.
    echo "RegionName [Welcome]:"; read -r RegionName
    echo "RegionUUID [$UUID]: "; read -r RegionUUID
    echo "Location [1000,1000]: "; read -r Location
    echo "InternalPort [9050]: "; read -r InternalPort
    echo "ExternalHostName [127.0.0.1]: "; read -r ExternalHostName
    echo "Size [512]: "; read -r Size
    echo "MaxPrims [100000]: "; read -r MaxPrims
    echo "MaxAgents [50]: "; read -r MaxAgents
    # Auswertung der Eingaben.
    if test -z "$RegionName"; then RegionName="Welcome"; fi
    if test -z "$RegionUUID"; then RegionUUID="$UUID"; fi
    if test -z "$Location"; then Location="1000,1000"; fi
    if test -z "$InternalPort"; then InternalPort="9050"; fi
    if test -z "$ExternalHostName"; then ExternalHostName="127.0.0.1"; fi
    if test -z "$Size"; then Size="512"; fi
    if test -z "$MaxPrims"; then MaxPrims="100000"; fi
    if test -z "$MaxAgents"; then MaxAgents="50"; fi

    RegionsConfigSet $RegionName "$RegionUUID" $Location $InternalPort $ExternalHostName $Size $MaxPrims $MaxAgents "$UUID"
}
function RegionsConfigSet() {
    Regionsdatei="OpenSim.ini"

    RegionsConfigList=(
    "[Erste-Region]"
    "RegionUUID = $RegionUUID"
    "Location = $Location"
    "InternalAddress = 0.0.0.0"
    "InternalPort = $InternalPort"
    "AllowAlternatePorts = False"
    "ExternalHostName = $ExternalHostName"
    "SizeX = $Size"
    "SizeY = $Size"
    "SizeZ = $Size"
    "NonPhysicalPrimMax = 256"
    "PhysicalPrimMax = 64"
    "MaxPrims = $MaxPrims"
    "MaxAgents = $MaxAgents"
    )
    echo "Alte $Regionsdatei Datei loeschen falls vorhanden."
    rm -f $Regionsdatei # || echo "Keine $Regionsdatei Datei vorhanden."

    echo "$Regionsdatei schreiben"
    printf '%s\n' "${RegionsConfigList[@]}" > $Regionsdatei

    echo "Tausche Hochstriche aus."
    sed -i -e s/\'/\"/g "$GridCommondatei"
}

### Robust Config
function RobustConfig() {    
    # Abfrage des Benutzers.
    echo "BaseHostname [127.0.0.1]: "; read -r BaseHostname
    echo "gridname [myGrid]: "; read -r gridname
    echo "mySQL User Name [myName]: "; read -r UserID
    echo "mySQL Password [myPassword]: "; read -r MysqlPassword
    echo "mySQL Database [myDatabase]: "; read -r MysqlDatabase
    echo "StartRegion [Welcome]: "; read -r StartRegion
    # Auswertung der Eingaben.
    if test -z "$BaseHostname"; then BaseHostname="127.0.0.1"; fi
    if test -z "$gridname"; then gridname="myGrid"; fi
    if test -z "$UserID"; then UserID="myName"; fi
    if test -z "$MysqlPassword"; then MysqlPassword="myPassword"; fi
    if test -z "$MysqlDatabase"; then MysqlDatabase="myDatabase"; fi
    if test -z "$StartRegion"; then StartRegion="Welcome"; fi

    PublicPort="8002"
    PrivatePort="8003"
    PrivURL=$BaseHostname
    BaseURL="http://$BaseHostname"
    MoneyPort="8008"

    RobustConfigSet $BaseHostname $gridname $UserID $MysqlPassword $MysqlDatabase $StartRegion $PublicPort $PrivatePort $PrivURL $BaseURL $MoneyPort
}
function RobustConfigSet() {
    Robustdatei="Robust.ini"    

    RobustConfigList=(
    "[Const]"
    "BaseURL = '$BaseURL'"
    "PublicPort = '$PublicPort'"
    "PrivatePort = '$PrivatePort'"
    "MysqlDatabase = '$MysqlDatabase'"
    "MysqlUser = '$MysqlUser'"
    "MysqlPassword = '$MysqlPassword'"
    "StartRegion = '$StartRegion'"
    "Simulatorgridname = '$gridname'"
    "Simulatorgridnick = '$gridname'"
    "[Startup]"
    "PIDFile = '/tmp/Robust.pid'"
    "RegistryLocation = '.'"
    "ConfigDirectory = 'robust-include'"
    "ConsoleHistoryFileEnabled = true"
    "ConsoleHistoryFile = 'RobustConsoleHistory.txt'"
    "ConsoleHistoryFileLines = 100"
    "NoVerifyCertChain = true"
    "NoVerifyCertHostname = true"
    "[ServiceList]"
    "AssetServiceConnector = '${Const|PrivatePort}/OpenSim.Server.Handlers.dll:AssetServiceConnector'"
    "InventoryInConnector = '${Const|PrivatePort}/OpenSim.Server.Handlers.dll:XInventoryInConnector'"
    "GridServiceConnector = '${Const|PrivatePort}/OpenSim.Server.Handlers.dll:GridServiceConnector'"
    "GridInfoServerInConnector = '${Const|PublicPort}/OpenSim.Server.Handlers.dll:GridInfoServerInConnector'"
    "AuthenticationServiceConnector = '${Const|PrivatePort}/OpenSim.Server.Handlers.dll:AuthenticationServiceConnector'"
    "OpenIdServerConnector = '${Const|PublicPort}/OpenSim.Server.Handlers.dll:OpenIdServerConnector'"
    "AvatarServiceConnector = '${Const|PrivatePort}/OpenSim.Server.Handlers.dll:AvatarServiceConnector'"
    "LLLoginServiceInConnector = '${Const|PublicPort}/OpenSim.Server.Handlers.dll:LLLoginServiceInConnector'"
    "PresenceServiceConnector = '${Const|PrivatePort}/OpenSim.Server.Handlers.dll:PresenceServiceConnector'"
    "UserAccountServiceConnector = '${Const|PrivatePort}/OpenSim.Server.Handlers.dll:UserAccountServiceConnector'"
    "GridUserServiceConnector = '${Const|PrivatePort}/OpenSim.Server.Handlers.dll:GridUserServiceConnector'"
    "AgentPreferencesServiceConnector = '${Const|PrivatePort}/OpenSim.Server.Handlers.dll:AgentPreferencesServiceConnector'"
    "FriendsServiceConnector = '${Const|PrivatePort}/OpenSim.Server.Handlers.dll:FriendsServiceConnector'"
    "MapAddServiceConnector = '${Const|PrivatePort}/OpenSim.Server.Handlers.dll:MapAddServiceConnector'"
    "MapGetServiceConnector = '${Const|PublicPort}/OpenSim.Server.Handlers.dll:MapGetServiceConnector'"
    "OfflineIMServiceConnector = '${Const|PrivatePort}/OpenSim.Addons.OfflineIM.dll:OfflineIMServiceRobustConnector'"
    "GroupsServiceConnector = '${Const|PrivatePort}/OpenSim.Addons.Groups.dll:GroupsServiceRobustConnector'"
    "BakedTextureService = '${Const|PrivatePort}/OpenSim.Server.Handlers.dll:XBakesConnector'"
    "UserProfilesServiceConnector = '${Const|PublicPort}/OpenSim.Server.Handlers.dll:UserProfilesConnector'"
    "MuteListConnector = '${Const|PrivatePort}/OpenSim.Server.Handlers.dll:MuteListServiceConnector'"
    "GatekeeperServiceInConnector = '${Const|PublicPort}/OpenSim.Server.Handlers.dll:GatekeeperServiceInConnector'"
    "UserAgentServerConnector = '${Const|PublicPort}/OpenSim.Server.Handlers.dll:UserAgentServerConnector'"
    "HeloServiceInConnector = '${Const|PublicPort}/OpenSim.Server.Handlers.dll:HeloServiceInConnector'"
    "HGFriendsServerConnector = '${Const|PublicPort}/OpenSim.Server.Handlers.dll:HGFriendsServerConnector'"
    "InstantMessageServerConnector = '${Const|PublicPort}/OpenSim.Server.Handlers.dll:InstantMessageServerConnector'"
    "HGInventoryServiceConnector = 'HGInventoryService@${Const|PublicPort}/OpenSim.Server.Handlers.dll:XInventoryInConnector'"
    "HGAssetServiceConnector = 'HGAssetService@${Const|PublicPort}/OpenSim.Server.Handlers.dll:AssetServiceConnector'"
    "HGGroupsServiceConnector = '${Const|PublicPort}/OpenSim.Addons.Groups.dll:HGGroupsServiceRobustConnector'"
    "[Network]"
    "port = ${Const|PrivatePort}"
    "AllowllHTTPRequestIn = false"
    "[Hypergrid]"
    "HomeURI = '${Const|BaseURL}:${Const|PublicPort}'"
    "GatekeeperURI = '${Const|BaseURL}:${Const|PublicPort}'"
    "[AccessControl]"
    "DeniedClients = 'Imprudence|CopyBot|Twisted|Crawler|Cryolife|darkstorm|DarkStorm|Darkstorm|hydrastorm viewer|kinggoon copybot|goon squad copybot|copybot pro|darkstorm viewer|copybot club|darkstorm second life|copybot download|HydraStorm Copybot Viewer|Copybot|Firestorm Pro|DarkStorm v3|DarkStorm v2|ShoopedStorm|HydraStorm|hydrastorm|kinggoon|goon squad|goon|copybot|Shooped|ShoopedStorm|Triforce|Triforce Viewer|Firestorm Professional|ShoopedLife|Sombrero|Sombrero Firestorm|GoonSquad|Solar|SolarStorm'"
    "[DatabaseService]"
    "StorageProvider = 'OpenSim.Data.MySQL.dll'"
    "ConnectionString = 'Data Source=localhost;Database='$MysqlDatabase';User ID='$UserID';Password='$MysqlPassword';Old Guids=true;SslMode=None;'"
    "[AssetService]"
    "LocalServiceModule = 'OpenSim.Services.AssetService.dll:AssetService'"
    "DefaultAssetLoader = 'OpenSim.Framework.AssetLoader.Filesystem.dll'"
    "AssetLoaderArgs = './assets/AssetSets.xml'"
    "AllowRemoteDelete = true"
    "AllowRemoteDeleteAllTypes = false"
    "[InventoryService]"
    "LocalServiceModule = 'OpenSim.Services.InventoryService.dll:XInventoryService'"
    "AllowDelete = true"
    "[GridService]"
    "LocalServiceModule = 'OpenSim.Services.GridService.dll:GridService'"
    "AssetService = 'OpenSim.Services.AssetService.dll:AssetService'"
    "MapTileDirectory = './maptiles'"
    "Region_$StartRegion = 'DefaultRegion, DefaultHGRegion'"
    "HypergridLinker = true"
    "ExportSupported = true"
    "GatekeeperURI = '${Const|BaseURL}:${Const|PublicPort}'"
    "[FreeswitchService]"
    "LocalServiceModule = 'OpenSim.Services.FreeswitchService.dll:FreeswitchService'"
    "[AuthenticationService]"
    "LocalServiceModule = 'OpenSim.Services.AuthenticationService.dll:PasswordAuthenticationService'"
    "AllowGetAuthInfo = true"
    "AllowSetAuthInfo = true"
    "AllowSetPassword = true"
    "[OpenIdService]"
    "AuthenticationServiceModule = 'OpenSim.Services.AuthenticationService.dll:PasswordAuthenticationService'"
    "UserAccountServiceModule = 'OpenSim.Services.UserAccountService.dll:UserAccountService'"
    "[UserAccountService]"
    "LocalServiceModule = 'OpenSim.Services.UserAccountService.dll:UserAccountService'"
    "AuthenticationService = 'OpenSim.Services.AuthenticationService.dll:PasswordAuthenticationService'"
    "PresenceService = 'OpenSim.Services.PresenceService.dll:PresenceService'"
    "GridService = 'OpenSim.Services.GridService.dll:GridService'"
    "InventoryService = 'OpenSim.Services.InventoryService.dll:XInventoryService'"
    "AvatarService = 'OpenSim.Services.AvatarService.dll:AvatarService'"
    "GridUserService = 'OpenSim.Services.UserAccountService.dll:GridUserService'"
    "CreateDefaultAvatarEntries = true"
    "AllowCreateUser = true"
    "AllowSetAccount = true"
    "[GridUserService]"
    "LocalServiceModule = 'OpenSim.Services.UserAccountService.dll:GridUserService'"
    "[AgentPreferencesService]"
    "LocalServiceModule = 'OpenSim.Services.UserAccountService.dll:AgentPreferencesService'"
    "[PresenceService]"
    "LocalServiceModule = 'OpenSim.Services.PresenceService.dll:PresenceService'"
    "[AvatarService]"
    "LocalServiceModule = 'OpenSim.Services.AvatarService.dll:AvatarService'"
    "[FriendsService]"
    "LocalServiceModule = 'OpenSim.Services.FriendsService.dll:FriendsService'"
    "[EstateService]"
    "LocalServiceModule = 'OpenSim.Services.EstateService.dll:EstateDataService'"
    "[LibraryService]"
    "LibraryName = 'OpenSim Library'"
    "DefaultLibrary = './inventory/Libraries.xml'"
    "[LoginService]"
    "LocalServiceModule = 'OpenSim.Services.LLLoginService.dll:LLLoginService'"
    "UserAccountService = 'OpenSim.Services.UserAccountService.dll:UserAccountService'"
    "GridUserService = 'OpenSim.Services.UserAccountService.dll:GridUserService'"
    "AuthenticationService = 'OpenSim.Services.AuthenticationService.dll:PasswordAuthenticationService'"
    "InventoryService = 'OpenSim.Services.InventoryService.dll:XInventoryService'"
    "AvatarService = 'OpenSim.Services.AvatarService.dll:AvatarService'"
    "PresenceService = 'OpenSim.Services.PresenceService.dll:PresenceService'"
    "GridService = 'OpenSim.Services.GridService.dll:GridService'"
    "SimulationService ='OpenSim.Services.Connectors.dll:SimulationServiceConnector'"
    "LibraryService = 'OpenSim.Services.InventoryService.dll:LibraryService'"
    "FriendsService = 'OpenSim.Services.FriendsService.dll:FriendsService'"
    "MinLoginLevel = 0"
    "UserAgentService = 'OpenSim.Services.HypergridService.dll:UserAgentService'"
    "HGInventoryServicePlugin = 'HGInventoryService@OpenSim.Services.HypergridService.dll:HGSuitcaseInventoryService'"
    "Currency = 'T$'"
    "ClassifiedFee = 0"
    "WelcomeMessage = 'Welcome, Avatar!'"
    "AllowRemoteSetLoginLevel = 'false'"
    "GatekeeperURI = '${Const|BaseURL}:${Const|PublicPort}'"
    "SRV_HomeURI = '${Const|BaseURL}:${Const|PublicPort}'"
    "SRV_InventoryServerURI = '${Const|BaseURL}:${Const|PublicPort}'"
    "SRV_AssetServerURI = '${Const|BaseURL}:${Const|PublicPort}'"
    "SRV_ProfileServerURI = '${Const|BaseURL}:${Const|PublicPort}'"
    "SRV_FriendsServerURI = '${Const|BaseURL}:${Const|PublicPort}'"
    "SRV_IMServerURI = '${Const|BaseURL}:${Const|PublicPort}'"
    "SRV_GroupsServerURI = '${Const|BaseURL}:${Const|PublicPort}'"
    "AllowLoginFallbackToAnyRegion = false"
    "DeniedMacs = '44ed33b396b10a5c95d04967aff8bd9c'"
    "[MapImageService]"
    "LocalServiceModule = 'OpenSim.Services.MapImageService.dll:MapImageService'"
    "TilesStoragePath = 'maptiles'"
    "[GridInfoService]"
    "login = ${Const|BaseURL}:${Const|PublicPort}/"
    "gridname = '$gridname'"
    "gridnick = '$gridname'"
    "welcome = ${Const|BaseURL}/"
    "economy = ${Const|BaseURL}/helper/"
    "about = ${Const|BaseURL}/"
    "register = ${Const|BaseURL}/"
    "help = ${Const|BaseURL}/"
    "password = ${Const|BaseURL}/"
    "gatekeeper = ${Const|BaseURL}:${Const|PublicPort}/"
    "uas = ${Const|BaseURL}:${Const|PublicPort}/"
    "[GatekeeperService]"
    "LocalServiceModule = 'OpenSim.Services.HypergridService.dll:GatekeeperService'"
    "UserAccountService = 'OpenSim.Services.UserAccountService.dll:UserAccountService'"
    "UserAgentService = 'OpenSim.Services.HypergridService.dll:UserAgentService'"
    "PresenceService = 'OpenSim.Services.PresenceService.dll:PresenceService'"
    "GridUserService = 'OpenSim.Services.UserAccountService.dll:GridUserService'"
    "GridService = 'OpenSim.Services.GridService.dll:GridService'"
    "AuthenticationService = 'OpenSim.Services.Connectors.dll:AuthenticationServicesConnector'"
    "SimulationService ='OpenSim.Services.Connectors.dll:SimulationServiceConnector'"
    "AllowTeleportsToAnyRegion = true"
    "ForeignAgentsAllowed = true"
    "[UserAgentService]"
    "LocalServiceModule = 'OpenSim.Services.HypergridService.dll:UserAgentService'"
    "GridUserService     = 'OpenSim.Services.UserAccountService.dll:GridUserService'"
    "GridService         = 'OpenSim.Services.GridService.dll:GridService'"
    "GatekeeperService   = 'OpenSim.Services.HypergridService.dll:GatekeeperService'"
    "PresenceService     = 'OpenSim.Services.PresenceService.dll:PresenceService'"
    "FriendsService      = 'OpenSim.Services.FriendsService.dll:FriendsService'"
    "UserAccountService  = 'OpenSim.Services.UserAccountService.dll:UserAccountService'"
    "LevelOutsideContacts = 0"
    "ShowUserDetailsInHGProfile = True"
    "[HGInventoryService]"
    "LocalServiceModule    = 'OpenSim.Services.InventoryService.dll:XInventoryService'"
    "UserAccountsService = 'OpenSim.Services.UserAccountService.dll:UserAccountService'"
    "AvatarService = 'OpenSim.Services.AvatarService.dll:AvatarService'"
    "AuthType = None"
    "HomeURI = '${Const|BaseURL}:${Const|PublicPort}'"
    "[HGAssetService]"
    "LocalServiceModule = 'OpenSim.Services.HypergridService.dll:HGAssetService'"
    "UserAccountsService = 'OpenSim.Services.UserAccountService.dll:UserAccountService'"
    "AuthType = None"
    "HomeURI = '${Const|BaseURL}:${Const|PublicPort}'"
    "[HGFriendsService]"
    "LocalServiceModule = 'OpenSim.Services.HypergridService.dll:HGFriendsService'"
    "UserAgentService = 'OpenSim.Services.HypergridService.dll:UserAgentService'"
    "FriendsService = 'OpenSim.Services.FriendsService.dll:FriendsService'"
    "UserAccountService = 'OpenSim.Services.UserAccountService.dll:UserAccountService'"
    "GridService = 'OpenSim.Services.GridService.dll:GridService'"
    "PresenceService = 'OpenSim.Services.PresenceService.dll:PresenceService'"
    "[HGInstantMessageService]"
    "LocalServiceModule  = 'OpenSim.Services.HypergridService.dll:HGInstantMessageService'"
    "GridService         = 'OpenSim.Services.GridService.dll:GridService'"
    "PresenceService     = 'OpenSim.Services.PresenceService.dll:PresenceService'"
    "UserAgentService    = 'OpenSim.Services.HypergridService.dll:UserAgentService'"
    "InGatekeeper = True"
    "[Messaging]"
    "OfflineIMService = 'OpenSim.Addons.OfflineIM.dll:OfflineIMService'"
    "[Groups]"
    "OfflineIMService = 'OpenSim.Addons.OfflineIM.dll:OfflineIMService'"
    "UserAccountService = 'OpenSim.Services.UserAccountService.dll:UserAccountService'"
    "HomeURI = '${Const|BaseURL}:${Const|PublicPort}'"
    "MaxAgentGroups = 50"
    "[UserProfilesService]"
    "LocalServiceModule = 'OpenSim.Services.UserProfilesService.dll:UserProfilesService'"
    "Enabled = true"
    "UserAccountService = OpenSim.Services.UserAccountService.dll:UserAccountService"
    "AuthenticationServiceModule = 'OpenSim.Services.AuthenticationService.dll:PasswordAuthenticationService'"
    "[BakedTextureService]"
    "LocalServiceModule = 'OpenSim.Server.Handlers.dll:XBakes'"
    "BaseDirectory = './bakes'"
    "[MuteListService]"
    "LocalServiceModule = 'OpenSim.Services.MuteListService.dll:MuteListService'"
    )
    echo "Alte $Robustdatei Datei loeschen falls vorhanden."
    rm -f $Robustdatei # || echo "Keine $Robustdatei Datei vorhanden."

    echo "$Robustdatei schreiben"
    printf '%s\n' "${RobustConfigList[@]}" > $Robustdatei

    echo "Tausche Hochstriche aus."
    sed -i -e s/\'/\"/g "$GridCommondatei"
}

###########################################################################
# Hilfen und Info
###########################################################################

### ! Funktion zum Anzeigen von Informationen der Auswahl.
function show_info() {
	dialog --title "$1" \
		--no-collapse \
		--msgbox "$info" 0 0
}

### ! Systeminformationen anzeigen.
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

### !  info, Informationen auf den Bildschirm ausgeben.
function info() {
	echo "$(tput setab 4) Server Name: ${HOSTNAME}"
	echo " Bash Version: ${BASH_VERSION}"
	echo " Server IP: ${AKTUELLEIP}"
	echo " MONO THREAD Einstellung: ${MONO_THREADS_PER_CPU}"
	echo " Spracheinstellung: ${LANG} $(tput sgr 0)"
	echo " $(screen --version)"
	who -b
	return 0
}

### !  infodialog, Informationen auf den Bildschirm ausgeben.
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

### !  kalender(), einfach nur ein Kalender.
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

### !  robustbackup Grid Datenbank sichern.(Kalender) in bearbeitung
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

### !  robustbackup Grid Datenbank sichern.(Datum auswerten) in bearbeitung
function backupdatum() {
	# Ist die Datei backup.tmp vorhanden?
	if [ -f /tmp/backup.tmp ]; then echo "Datei ist vorhanden!"; fi
	# Beispiel Text in der backup.tmp Datei - 30.06.2022

	# Heutiges Datum steht in $DATUM
	echo "Heute ist der: $DATUM"

	BACKUPDATUM=()
	while IFS= read -r line; do BACKUPDATUM+=("$line"); done </tmp/backup.tmp
	myDATUM=$(echo "${BACKUPDATUM[@]}" | sed -n '1p')

	if [ "$myDATUM" = "$DATUM" ]; then echo "Datum ist gleich! $myDATUM - $DATUM"; fi
	if [ ! "$myDATUM" = "$DATUM" ]; then echo "Datum ist nicht gleich! $myDATUM - $DATUM"; fi

	# Wenn das Datum gleich ist Grid herunterfahren.
	# Backup der Griddatenbank machen.
	#mysqldump -u root -p omlgrid assets > AssetService.sql
	# Grid wieder hochfahren.

	# Wenn Datum ungleich Grid restarten.

	return 0
}

### !  fortschritsanzeige(), test fuer eine Fortschrittsanzeige.
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

### !  menuinfo, Informationen im dialog ausgeben.
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
### !  menukonsolenhilfe, menukonsolenhilfe auf dem Bildschirm anzeigen.
function menukonsolenhilfe() {
	#helpergebnis=$(help)
	#dialog --msgbox "Konsolenhilfe:\n $helpergebnis" 50 75; dialogclear

	help >help.txt
	dialog --textbox "help.txt" 55 85
	dialogclear

	hauptmenu
	return 0
}

### !  hilfe, Hilfe auf dem Bildschirm anzeigen.
function hilfe() {
	echo "$(tput setab 5)Funktion:$(tput sgr 0)		$(tput setab 2)Parameter:$(tput sgr 0)		$(tput setab 4)Informationen:$(tput sgr 0)"
	echo "hilfe 			- $(tput setaf 3)hat keine Parameter$(tput sgr 0)	- Diese Hilfe."
	echo "konsolenhilfe 		- $(tput setaf 3)hat keine Parameter$(tput sgr 0)	- konsolenhilfe ist eine Hilfe fuer Putty oder Xterm."
	echo "commandhelp 		- $(tput setaf 3)hat keine Parameter$(tput sgr 0)	- Die OpenSim Commands."
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
	echo "osprebuild		- $(tput setab 2)Versionsnummer$(tput sgr 0)      - Aendert die Versionseinstellungen 0.9.2.XXXX"
	echo "compilieren 		- $(tput setaf 3)hat keine Parameter$(tput sgr 0) - Kopiert fehlende Dateien und Kompiliert."
	echo "oscompi 		- $(tput setaf 3)hat keine Parameter$(tput sgr 0) - Kompiliert einen neuen OpenSimulator ohne kopieren."
	echo "scriptcopy 		- $(tput setaf 3)hat keine Parameter$(tput sgr 0) - Kopiert die Scripte in den Source."
	echo "moneycopy 		- $(tput setaf 3)hat keine Parameter$(tput sgr 0) - Kopiert Money Source in den OpenSimulator Source."
	echo "osdelete 		- $(tput setaf 3)hat keine Parameter$(tput sgr 0) - Loescht alte OpenSim Version."
	echo "regionsiniteilen 	- $(tput setab 5)Verzeichnisname$(tput sgr 0) $(tput setab 3)Region$(tput sgr 0) - kopiert aus der Regions.ini eine Region heraus."
	echo "autoregionsiniteilen 	- $(tput setaf 3)hat keine Parameter$(tput sgr 0) - aus allen Regions.ini alle Regionen vereinzeln."
	echo "RegionListe 		- $(tput setaf 3)hat keine Parameter$(tput sgr 0) - Die RegionList.ini erstellen."
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
	echo "leere_db	- $(tput setab 5) DBBENUTZER $(tput sgr 0) $(tput setab 4) DBPASSWORT $(tput sgr 0) $(tput setab 2) DATENBANKNAME $(tput sgr 0) - Datenbank leeren."
	echo "allrepair_db	- $(tput setab 5) DBBENUTZER $(tput sgr 0) $(tput setab 4) DBPASSWORT $(tput sgr 0) - Alle Datenbanken Reparieren und Optimieren."
	echo "db_sichern	- $(tput setab 5) DBBENUTZER $(tput sgr 0) $(tput setab 4) DBPASSWORT $(tput sgr 0) $(tput setab 2) DATENBANKNAME $(tput sgr 0) - Datenbank sichern."
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
	echo "loadinventar - $(tput setab 5)NAME VERZEICHNIS PASSWORD DATEINAMEmitPFAD $(tput sgr 0) - laedt Inventar aus einer iar"
	echo "saveinventar - $(tput setab 5)NAME VERZEICHNIS PASSWORD DATEINAMEmitPFAD $(tput sgr 0) - speichert Inventar in einer iar"

	echo "unlockexample	- $(tput setaf 3)hat keine Parameter$(tput sgr 0) - Benennt alle example Dateien um."

	echo "passwdgenerator - $(tput setab 5)Passwortstaerke$(tput sgr 0) - Generiert ein Passwort zur weiteren verwendung."

	log line
	echo "$(tput setaf 3)  Der Verzeichnisname ist gleichzeitig auch der Screen Name!$(tput sgr 0)"

	log info "HILFE: Hilfe wurde angefordert."
}

### !  konsolenhilfe, konsolenhilfe auf dem Bildschirm anzeigen.
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

	log info "HILFE: Konsolenhilfe wurde angefordert"
}

### !  commandhelp
function commandhelp() {
	cat <<eof
$(tput setab 1)
Help OpenSim Commands:
Aufruf: oscommand Screen Region "Befehl mit Parameter in Hochstrichen"
Beispiel: /opt/opensim.sh oscommand sim1 Welcome "alert Hallo liebe Leute dies ist eine Nachricht"
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

	log info "HILFE: Commands Hilfe wurde angefordert"
}

###########################################################################
# Menu Menue
###########################################################################

### !  hauptmenu
function hauptmenu() {
	HEIGHT=0
	WIDTH=0
	CHOICE_HEIGHT=30
	BACKTITLE="opensimMULTITOOL"
	TITLE="Hauptmenu"
	MENU="opensimMULTITOOL $VERSION"
	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then
		OPTIONS=("OpenSim Restart" ""
			"OpenSim Autostopp" ""
			"OpenSim Autostart" ""
			"--------------------------" ""
			"Einzelner Simulator Stop" ""
			"Einzelner Simulator Start" ""
			"--------------------------" ""
			"Benutzer Account anlegen" ""
			"Parzellen entfernen" ""
			"Objekt entfernen" ""
			"--------------------------" ""
			"Systeminformationen" ""
			"Informationen" ""
			"Screen Liste" ""
			"Server laufzeit und Neustart" ""
			"--------------------------" ""
			"Passwortgenerator" ""
			"Kalender" ""
			"----------Menu------------" ""
			"Weitere Funktionen" ""
			"Dateimennu" ""
			"mySQLmenu" ""
			"Experten Funktionen" "")

		mauswahl=$(dialog --backtitle "$BACKTITLE" --title "$TITLE" --help-button --defaultno --menu "$MENU" $HEIGHT $WIDTH $CHOICE_HEIGHT "${OPTIONS[@]}" 2>&1 >/dev/tty)
		antwort=$?
		dialogclear
		ScreenLog

		if [[ $mauswahl = "OpenSim Autostart" ]]; then menuautostart; fi
		if [[ $mauswahl = "OpenSim Autostopp" ]]; then menuautostop; fi
		if [[ $mauswahl = "OpenSim Restart" ]]; then menuautorestart; fi

		if [[ $mauswahl = "Einzelner Simulator Stop" ]]; then menuosstop; fi
		if [[ $mauswahl = "Einzelner Simulator Start" ]]; then menuosstart; fi
		#if [[ $mauswahl = "Einzelner Simulator Status" ]]; then menuworks; fi
		#if [[ $mauswahl = "Alle Simulatoren Status" ]]; then menuwaslauft; fi
		if [[ $mauswahl = "Informationen" ]]; then menuinfo; fi
		if [[ $mauswahl = "Systeminformationen" ]]; then systeminformation; fi

		if [[ $mauswahl = "Screen Liste" ]]; then screenlist; fi
		if [[ $mauswahl = "Parzellen entfernen" ]]; then menulandclear; fi
		if [[ $mauswahl = "Objekt entfernen" ]]; then menuassetdel; fi
		if [[ $mauswahl = "Benutzer Account anlegen" ]]; then menucreateuser; fi
		if [[ $mauswahl = "Server laufzeit und Neustart" ]]; then rebootdatum; fi

		if [[ $mauswahl = "Passwortgenerator" ]]; then passwdgenerator; fi
		if [[ $mauswahl = "Kalender" ]]; then kalender; fi

		if [[ $mauswahl = "Dateimennu" ]]; then dateimenu; fi
		if [[ $mauswahl = "mySQLmenu" ]]; then mySQLmenu; fi
		if [[ $mauswahl = "Weitere Funktionen" ]]; then funktionenmenu; fi
		if [[ $mauswahl = "Experten Funktionen" ]]; then expertenmenu; fi

		if [[ $antwort = 2 ]]; then hilfemenu; fi
		if [[ $antwort = 1 ]]; then exit; fi
	else
		# wenn dialog nicht installiert ist die Hilfe anzeigen.
		hilfe
	fi
}

### !  hilfemenu
function hilfemenu() {
	HEIGHT=0
	WIDTH=45
	CHOICE_HEIGHT=30
	BACKTITLE="opensimMULTITOOL"
	TITLE="Hilfemenu"
	MENU="opensimMULTITOOL $VERSION"

	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then
		OPTIONS=("Hilfe" ""
			"Konsolenhilfe" ""
			"Kommandohilfe" ""
			"Konfiguration lesen" ""
			"Hauptmenu" "")

		hauswahl=$(dialogclear \
			--backtitle "$BACKTITLE" \
			--title "$TITLE" \
			--help-button --defaultno \
			--menu "$MENU" \
			$HEIGHT $WIDTH $CHOICE_HEIGHT \
			"${OPTIONS[@]}" \
			2>&1 >/dev/tty) # 3>&1 1>&2 2>&3

		antwort=$?
		dialogclear
		ScreenLog

		if [[ $hauswahl = "Hilfe" ]]; then hilfe; fi
		if [[ $hauswahl = "Konsolenhilfe" ]]; then menukonsolenhilfe; fi # Test menukonsolenhilfe
		if [[ $hauswahl = "Kommandohilfe" ]]; then commandhelp; fi
		if [[ $hauswahl = "Konfiguration lesen" ]]; then menuoswriteconfig; fi

		if [[ $hauswahl = "Hauptmenu" ]]; then hauptmenu; fi
		if [[ $antwort = 1 ]]; then hauptmenu; fi
	else
		# wenn dialog nicht installiert ist die Hilfe anzeigen.
		hilfe
	fi
}

### !  funktionenmenu
function funktionenmenu() {
	HEIGHT=0
	WIDTH=45
	CHOICE_HEIGHT=30
	BACKTITLE="opensimMULTITOOL"
	TITLE="Funktionsmenu"
	MENU="opensimMULTITOOL $VERSION"

	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then
		OPTIONS=("Grid starten" ""
			"Grid stoppen" ""
			"--------------------------" ""
			"Robust starten" ""
			"Robust stoppen" ""
			"Money starten" ""
			"Money stoppen" ""
			"--------------------------" ""
			"Automatischer Sim start" ""
			"Automatischer Sim stop" ""
			"--------------------------" ""
			"Automatischer Screen stop" ""
			"Regionen anzeigen" ""
			"----------Menu------------" ""
			"Hauptmennu" ""
			"Dateimennu" ""
			"mySQLmenu" ""
			"Experten Funktionen" "")

		fauswahl=$(dialogclear \
			--backtitle "$BACKTITLE" \
			--title "$TITLE" \
			--help-button --defaultno \
			--menu "$MENU" \
			$HEIGHT $WIDTH $CHOICE_HEIGHT \
			"${OPTIONS[@]}" \
			2>&1 >/dev/tty) # 3>&1 1>&2 2>&3

		antwort=$?
		dialogclear
		ScreenLog

		if [[ $fauswahl = "Grid starten" ]]; then gridstart; fi
		if [[ $fauswahl = "Grid stoppen" ]]; then gridstop; fi
		if [[ $fauswahl = "Robust starten" ]]; then rostart; fi
		if [[ $fauswahl = "Robust stoppen" ]]; then rostop; fi
		if [[ $fauswahl = "Money starten" ]]; then mostart; fi
		if [[ $fauswahl = "Money stoppen" ]]; then mostop; fi
		if [[ $fauswahl = "Automatischer Sim start" ]]; then menuautosimstart; fi
		if [[ $fauswahl = "Automatischer Sim stop" ]]; then menuautosimstop; fi
		if [[ $fauswahl = "Automatischer Screen stop" ]]; then autoscreenstop; fi
		if [[ $fauswahl = "Regionen anzeigen" ]]; then meineregionen; fi

		if [[ $fauswahl = "Dateimennu" ]]; then dateimenu; fi
		if [[ $fauswahl = "mySQLmenu" ]]; then mySQLmenu; fi
		if [[ $fauswahl = "Hauptmennu" ]]; then hauptmenu; fi
		if [[ $fauswahl = "Experten Funktionen" ]]; then expertenmenu; fi

		if [[ $antwort = 2 ]]; then hilfemenu; fi
		if [[ $antwort = 1 ]]; then exit; fi
	else
		# wenn dialog nicht installiert ist die Hilfe anzeigen.
		hilfe
	fi
}

### !  dateimenu
function dateimenu() {
	HEIGHT=0
	WIDTH=45
	CHOICE_HEIGHT=30
	BACKTITLE="opensimMULTITOOL"
	TITLE="Dateimenu"
	MENU="opensimMULTITOOL $VERSION"

	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then
		OPTIONS=("Inventar speichern" ""
			"Inventar laden" ""
			"Region OAR sichern" ""
			"--------------------------" ""
			"Log Dateien loeschen" ""
			"Map Karten loeschen" ""
			"Asset loeschen" ""
			"--------------------------" ""
			"OpenSim herunterladen" ""
			"MoneyServer vom git kopieren" ""
			"OSSL Skripte vom git kopieren" ""
			"Configure vom git kopieren" ""
			"Opensim vom Github holen" ""
			"--------------------------" ""
			"Verzeichnisstrukturen anlegen" ""
			"----------Menu------------" ""
			"Hauptmenu" ""
			"Weitere Funktionen" ""
			"mySQLmenu" ""
			"Experten Funktionen" "")

		dauswahl=$(dialogclear \
			--backtitle "$BACKTITLE" \
			--title "$TITLE" \
			--help-button --defaultno \
			--menu "$MENU" \
			$HEIGHT $WIDTH $CHOICE_HEIGHT \
			"${OPTIONS[@]}" \
			2>&1 >/dev/tty) # 3>&1 1>&2 2>&3

		antwort=$?
		dialogclear
		ScreenLog

		if [[ $dauswahl = "Inventar speichern" ]]; then menusaveinventar; fi
		if [[ $dauswahl = "Inventar laden" ]]; then menuloadinventar; fi
		if [[ $dauswahl = "Region OAR sichern" ]]; then menuregionbackup; fi
		if [[ $dauswahl = "OpenSim herunterladen" ]]; then downloados; fi
		if [[ $dauswahl = "Log Dateien loeschen" ]]; then autologdel; fi
		if [[ $dauswahl = "Map Karten loeschen" ]]; then automapdel; fi
		if [[ $dauswahl = "MoneyServer vom git kopieren" ]]; then moneygitcopy; fi
		if [[ $dauswahl = "OSSL Skripte vom git kopieren" ]]; then scriptgitcopy; fi
		if [[ $dauswahl = "Configure vom git kopieren" ]]; then configuregitcopy; fi
		if [[ $dauswahl = "Opensim vom Github holen" ]]; then osgitholen; fi
		if [[ $dauswahl = "Verzeichnisstrukturen anlegen" ]]; then menuosstruktur; fi

		if [[ $dauswahl = "Asset loeschen" ]]; then menuassetdel; fi

		if [[ $dauswahl = "Hauptmenu" ]]; then hauptmenu; fi
		if [[ $dauswahl = "mySQLmenu" ]]; then mySQLmenu; fi
		if [[ $dauswahl = "Weitere Funktionen" ]]; then funktionenmenu; fi
		if [[ $dauswahl = "Experten Funktionen" ]]; then expertenmenu; fi

		if [[ $antwort = 2 ]]; then hilfemenu; fi
		if [[ $antwort = 1 ]]; then exit; fi
	else
		# wenn dialog nicht installiert ist die Hilfe anzeigen.
		hilfe
	fi
}

### !  mySQLmenu
function mySQLmenu() {
	HEIGHT=0
	WIDTH=0
	CHOICE_HEIGHT=30
	BACKTITLE="opensimMULTITOOL"
	TITLE="mySQLmenu"
	MENU="opensimMULTITOOL $VERSION"
	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then
		OPTIONS=("Alle Datenbanken anzeigen" ""
			"Tabellen einer Datenbank" ""
			"Alle Benutzerdaten der ROBUST Datenbank" ""
			"UUID von allen Benutzern anzeigen" ""
			"Alle Benutzernamen anzeigen" ""
			"Daten von einem Benutzer anzeigen" ""
			"UUID, Vor, Nachname, E-Mail vom Benutzer anzeigen" ""
			"UUID von einem Benutzer anzeigen" ""
			"--------------------------" ""
			"mySQL Datenbankbenutzer anzeigen" ""
			"Alle Grid Regionen listen" ""
			"Region URI pruefen sortiert nach URI" ""
			"Ports pruefen sortiert nach Ports" ""
			"Neue Datenbank erstellen" ""
			"Benutzer inventoryfolders alles was type -1 ist anzeigen" ""
			"Zeige Erstellungsdatum eines Users an" ""
			"Finde falsche E-Mail Adressen" ""
			"Datenbank komplett loeschen" ""
			"--------------------------" ""
			"Datenbank leeren" ""
			"Neuen Datenbankbenutzer anlegen" ""
			"Listet alle erstellten Benutzerrechte auf" ""
			"Loescht einen Datenbankbenutzer" ""
			"Alle Datenbanken Checken, Reparieren und Optimieren" ""
			"mysqlTuner herunterladen" ""
			"--------------------------" ""
			"Alle Benutzer mit inkorrekter EMail abschalten" ""
			"Benutzeracount abschalten" ""
			"Benutzeracount einschalten" ""
			"----------Menu------------" ""
			"Hauptmenu" ""
			"Weitere Funktionen" ""
			"Dateimennu" ""
			"Experten Funktionen" "")

		mysqlauswahl=$(dialog --backtitle "$BACKTITLE" --title "$TITLE" --help-button --defaultno --menu "$MENU" $HEIGHT $WIDTH $CHOICE_HEIGHT "${OPTIONS[@]}" 2>&1 >/dev/tty)
		antwort=$?
		dialogclear
		ScreenLog

		# db_anzeigen_dialog, db_tables_dialog, db_all_user_dialog, db_all_uuid_dialog, db_email_setincorrectuseroff_dialog, db_setuseronline_dialog, db_setuserofline_dialog
		# db_all_name_dialog, db_user_data_dialog, db_user_infos_dialog, db_user_uuid_dialog

		if [[ $mysqlauswahl = "Alle Datenbanken anzeigen" ]]; then db_anzeigen_dialog; fi
		if [[ $mysqlauswahl = "Tabellen einer Datenbank" ]]; then db_tables_dialog; fi
		if [[ $mysqlauswahl = "Alle Benutzerdaten der ROBUST Datenbank" ]]; then db_all_user_dialog; fi
		if [[ $mysqlauswahl = "UUID von allen Benutzern anzeigen" ]]; then db_all_uuid_dialog; fi

		if [[ $mysqlauswahl = "mySQL Datenbankbenutzer anzeigen" ]]; then db_benutzer_anzeigen; fi
		if [[ $mysqlauswahl = "Alle Grid Regionen listen" ]]; then db_regions; fi
		if [[ $mysqlauswahl = "Region URI pruefen sortiert nach URI" ]]; then db_regionsuri; fi
		if [[ $mysqlauswahl = "Ports pruefen sortiert nach Ports" ]]; then db_regionsport; fi
		if [[ $mysqlauswahl = "Neue Datenbank erstellen" ]]; then db_create; fi
		if [[ $mysqlauswahl = "Benutzer inventoryfolders alles was type -1 ist anzeigen" ]]; then db_all_userfailed; fi
		if [[ $mysqlauswahl = "Zeige Erstellungsdatum eines Users an" ]]; then db_userdate; fi
		if [[ $mysqlauswahl = "Finde falsche E-Mail Adressen" ]]; then db_false_email; fi
		if [[ $mysqlauswahl = "Datenbank komplett loeschen" ]]; then db_delete; fi

		if [[ $mysqlauswahl = "Datenbank leeren" ]]; then db_empty; fi
		if [[ $mysqlauswahl = "Neuen Datenbankbenutzer anlegen" ]]; then db_create_new_dbuser; fi
		if [[ $mysqlauswahl = "Listet alle erstellten Benutzerrechte auf" ]]; then db_dbuserrechte; fi
		if [[ $mysqlauswahl = "Loescht einen Datenbankbenutzer" ]]; then db_deldbuser; fi
		if [[ $mysqlauswahl = "Alle Datenbanken Checken, Reparieren und Optimieren" ]]; then allrepair_db; fi

		if [[ $mysqlauswahl = "mysqlTuner herunterladen" ]]; then install_mysqltuner; fi

		if [[ $mysqlauswahl = "Alle Benutzernamen anzeigen" ]]; then db_all_name_dialog; fi
		if [[ $mysqlauswahl = "Daten von einem Benutzer anzeigen" ]]; then db_user_data_dialog; fi
		if [[ $mysqlauswahl = "UUID, Vor, Nachname, E-Mail vom Benutzer anzeigen" ]]; then db_user_infos_dialog; fi
		if [[ $mysqlauswahl = "UUID von einem Benutzer anzeigen" ]]; then db_user_uuid_dialog; fi

		if [[ $mysqlauswahl = "Alle Benutzer mit inkorrekter EMail abschalten" ]]; then db_email_setincorrectuseroff_dialog; fi
		if [[ $mysqlauswahl = "Benutzeracount abschalten" ]]; then db_setuserofline_dialog; fi
		if [[ $mysqlauswahl = "Benutzeracount einschalten" ]]; then db_setuseronline_dialog; fi

		if [[ $mysqlauswahl = "Hauptmenu" ]]; then hauptmenu; fi
		if [[ $mysqlauswahl = "Dateimennu" ]]; then dateimenu; fi
		if [[ $mysqlauswahl = "Weitere Funktionen" ]]; then funktionenmenu; fi
		if [[ $mysqlauswahl = "Experten Funktionen" ]]; then expertenmenu; fi

		if [[ $antwort = 2 ]]; then hilfemenu; fi
		if [[ $antwort = 1 ]]; then exit; fi
	else
		# wenn dialog nicht installiert ist die Hilfe anzeigen.
		hilfe
	fi
}

### !  expertenmenu
function expertenmenu() {
	HEIGHT=0
	WIDTH=45
	CHOICE_HEIGHT=30
	BACKTITLE="opensimMULTITOOL"
	TITLE="Expertenmenu"
	MENU="opensimMULTITOOL $VERSION"

	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then
		OPTIONS=("Example Dateien umbenennen" ""
			"Voreinstellungen setzen" ""
			"Opensimulator upgraden" ""
			"Opensimulator aus zip upgraden" ""
			"Opensimulator bauen und upgraden" ""
			"Kompilieren" ""
			"oscompi" ""
			"--------------------------" ""
			"Automatischer Regionsbackup" ""
			"--------------------------" ""
			"autoregionsiniteilen" ""
			"RegionListe" ""
			"--------------------------" ""
			"Server Installation" ""
			"Server Installation fuer WordPress" ""
			"Server Installation ohne mono" ""
			"Mono Installation" ""
			"--------------------------" ""
			"terminator" ""
			"makeaot" ""
			"cleanaot" ""
			"Installationen anzeigen" ""
			"--------------------------" ""
			"Kommando an OpenSim senden" ""
			"----------Menu------------" ""
			"Hauptmennu" ""
			"Dateimennu" ""
			"mySQLmenu" ""
			"Weitere Funktionen" "")

		feauswahl=$(dialogclear \
			--backtitle "$BACKTITLE" \
			--title "$TITLE" \
			--help-button --defaultno \
			--menu "$MENU" \
			$HEIGHT $WIDTH $CHOICE_HEIGHT \
			"${OPTIONS[@]}" \
			2>&1 >/dev/tty)

		antwort=$?
		dialogclear
		ScreenLog

		if [[ $feauswahl = "Example Dateien umbenennen" ]]; then unlockexample; fi
		if [[ $feauswahl = "Voreinstellungen setzen" ]]; then ossettings; fi

		if [[ $feauswahl = "Kommando an OpenSim senden" ]]; then menuoscommand; fi

		if [[ $feauswahl = "Opensimulator upgraden" ]]; then osupgrade; fi
		if [[ $feauswahl = "Opensimulator aus zip upgraden" ]]; then oszipupgrade; fi
		if [[ $feauswahl = "Opensimulator bauen und upgraden" ]]; then osbuilding; fi

		if [[ $feauswahl = "Automatischer Regionsbackup" ]]; then autoregionbackup; fi
		if [[ $feauswahl = "Kompilieren" ]]; then compilieren; fi
		if [[ $feauswahl = "oscompi" ]]; then oscompi; fi

		if [[ $feauswahl = "autoregionsiniteilen" ]]; then autoregionsiniteilen; fi
		if [[ $feauswahl = "RegionListe" ]]; then RegionListe; fi

		if [[ $feauswahl = "terminator" ]]; then terminator; fi
		if [[ $feauswahl = "makeaot" ]]; then makeaot; fi
		if [[ $feauswahl = "cleanaot" ]]; then cleanaot; fi
		if [[ $feauswahl = "Installationen anzeigen" ]]; then installationen; fi

		if [[ $feauswahl = "Server Installation" ]]; then serverinstall; fi
		if [[ $feauswahl = "Server Installation fuer WordPress" ]]; then installwordpress; fi
		if [[ $feauswahl = "Server Installation ohne mono" ]]; then installobensimulator; fi
		if [[ $feauswahl = "Mono Installation" ]]; then monoinstall; fi

		if [[ $feauswahl = "Hilfe" ]]; then hilfemenu; fi

		if [[ $feauswahl = "Dateimennu" ]]; then dateimenu; fi
		if [[ $feauswahl = "mySQLmenu" ]]; then mySQLmenu; fi
		if [[ $feauswahl = "Hauptmennu" ]]; then hauptmenu; fi
		if [[ $feauswahl = "Weitere Funktionen" ]]; then funktionenmenu; fi

		if [[ $antwort = 2 ]]; then hilfemenu; fi
		if [[ $antwort = 1 ]]; then exit; fi
	else
		# wenn dialog nicht installiert ist die Hilfe anzeigen.
		hilfe
	fi
}

###########################################################################
# Eingabeauswertung Konsolenmenue
###########################################################################
case $KOMMANDO in
schreibeinfo) schreibeinfo ;;
makeverzeichnisliste) makeverzeichnisliste ;;
makeregionsliste) makeregionsliste ;;
checkfile) checkfile "$2" ;;
r | restart) autorestart ;;
sta | autosimstart | simstart) autosimstart ;;
sto | autosimstop | simstop) autosimstop ;;
astart | autostart | start) autostart ;;
astop | autostop | stop) autostop ;;
amd | automapdel) automapdel ;;
ald | autologdel) autologdel ;;
s | settings) ossettings ;;
rs | robuststart | rostart) rostart ;;
ms | moneystart | mostart) mostart ;;
rsto | robuststop | rostop) rostop ;;
mstop | moneystop | mostop) mostop ;;
osto | osstop) osstop "$2" ;;
osta | osstart) osstart "$2" ;;
gsta | gridstart) gridstart ;;
gsto | gridstop) gridstop ;;
sd | screendel) autoscreenstop ;;
l | list | screenlist) screenlist ;;
w | works) works "$2" ;;
md | mapdel) mapdel "$2" ;;
ld | logdel) logdel "$2" ;;
ss | osscreenstop) osscreenstop "$2" ;;
h | hilfe | help) hilfe ;;
asdel | assetdel) assetdel "$2" "$3" "$4" ;;
e | terminator) terminator ;;
ou | osupgrade) osupgrade ;;
oscopyrobust) oscopyrobust ;;
oscopysim) oscopysim ;;
oscopy) oscopy "$2" ;;
rb | regionbackup) regionbackup "$2" "$3" ;;
arb | autoregionbackup) autoregionbackup ;;
compi | compilieren) compilieren ;;
sc | scriptcopy) scriptcopy ;;
mc | moneycopy) moneycopy ;;
oscompi) oscompi ;;
od | osdelete) osdelete ;;
os | osstruktur) osstruktur "$2" "$3" ;;
cl | configlesen) configlesen "$2" ;;
osc | com | oscommand) oscommand "$2" "$3" "$4" ;;
osc2 | com2 | oscommand2) oscommand2 "$2" "$3" "$4" "$5" ;;
rl | Regionsdateiliste | regionsconfigdateiliste) regionsconfigdateiliste "$3" "$2" ;;
rn | RegionListe) regionliste ;;
mr | meineregionen) meineregionen ;;
moneydelete) moneydelete ;;
rit | regionsiniteilen) regionsiniteilen "$2" "$3" ;;
arit | autoregionsiniteilen) autoregionsiniteilen ;;
regionsinisuchen) regionsinisuchen ;;
osg | osgitholen) osgitholen ;;
osprebuild) osprebuild "$2" ;;
chrisoscopy) chrisoscopy ;;
cleaninstall) cleaninstall ;;
autoallclean) autoallclean ;;
allclean) allclean "$2" ;;
makeaot) makeaot ;;
cleanaot) cleanaot ;;
pythoncopy) pythoncopy ;;
get_value_from_Region_key) get_value_from_Region_key ;;
autorobustmapdel) autorobustmapdel ;;
info) info ;;
mutelistcopy) mutelistcopy ;;
searchcopy) searchcopy ;;
monoinstall) monoinstall ;;
installationen) installationen ;;
serverinstall) serverinstall ;;
konsolenhilfe) konsolenhilfe ;;
simstats) simstats "$2" ;;
osbuilding) osbuilding "$2" ;;
createuser) createuser "$2" "$3" "$4" "$5" "$6" ;;
db_benutzer_anzeigen) db_benutzer_anzeigen "$2" "$3" ;;
create_db) create_db "$2" "$3" "$4" ;;
create_db_user) create_db_user "$2" "$3" "$4" "$5" ;;
delete_db) delete_db "$2" "$3" "$4" ;;
leere_db) leere_db "$2" "$3" "$4" ;;
allrepair_db) allrepair_db "$2" "$3" ;;
mysql_neustart) mysql_neustart ;;
db_sichern) db_sichern "$2" "$3" "$4" ;;
tabellenabfrage) tabellenabfrage "$2" "$3" "$4" ;;
regionsabfrage) regionsabfrage "$2" "$3" "$4" ;;
regionsuri) regionsuri "$2" "$3" "$4" ;;
regionsport) regionsport "$2" "$3" "$4" ;;
setpartner) setpartner "$2" "$3" "$4" "$5" "$6" ;;
makewebmaps) makewebmaps ;;
opensimholen) opensimholen ;;
conf_write) conf_write "$2" "$3" "$4" "$5" ;;
conf_delete) conf_delete "$2" "$3" "$4" ;;
conf_read) conf_read "$2" "$3" "$4" ;;
ipsetzen) ipsetzen ;;
neuegridconfig) neuegridconfig ;;
ramspeicher) ramspeicher ;;
mysqleinstellen) mysqleinstellen ;;
landclear) landclear "$2" "$3" ;;
commandhelp) commandhelp ;;
gridcommonini) gridcommonini ;;
robustini) robustini ;;
opensimini) opensimini ;;
moneyserverini) moneyserverini ;;
regionini) regionini ;;
osslenableini) osslenableini ;;
loadinventar) loadinventar "$2" "$3" "$4" "$5" ;;
saveinventar) saveinventar "$2" "$3" "$4" "$5" ;;
infodialog) infodialog ;;
fortschritsanzeige) fortschritsanzeige ;;
moneygitcopy) moneygitcopy ;;
scriptgitcopy) scriptgitcopy ;;
unlockexample) unlockexample ;;
passwdgenerator) passwdgenerator "$2" ;;
configurecopy) configurecopy ;;
menuworks) menuworks "$2" ;;
waslauft) waslauft ;;
rebootdatum) rebootdatum ;;
menuinfo) menuinfo ;;
funktionenmenu) funktionenmenu ;;
expertenmenu) expertenmenu ;;
downloados) downloados ;;
oswriteconfig) oswriteconfig "$2" ;;
menuoswriteconfig) menuoswriteconfig "$2" ;;
finstall) finstall "$2" ;;
rologdel) rologdel ;;
osgridcopy) osgridcopy ;;
screenlistrestart) screenlistrestart ;;
db_all_user) db_all_user "$2" "$3" "$4" ;;
db_all_uuid) db_all_uuid "$2" "$3" "$4" ;;
db_all_name) db_all_name "$2" "$3" "$4" ;;
db_user_data) db_user_data "$2" "$3" "$4" "$5" "$6" ;;
db_user_infos) db_user_infos "$2" "$3" "$4" "$5" "$6" ;;
db_user_uuid) db_user_uuid "$2" "$3" "$4" "$5" "$6" ;;
db_foldertyp_user) db_foldertyp_user "$2" "$3" "$4" "$5" "$6" "$7" ;;
db_all_userfailed) db_all_userfailed "$2" "$3" "$4" "$5" "$6" ;;
db_userdate) db_userdate "$2" "$3" "$4" "$5" "$6" ;;
db_false_email) db_false_email "$2" "$3" "$4" ;;
set_empty_user) set_empty_user "$2" "$3" "$4" "$5" "$6" "$7" ;;
db_create) db_create "$2" "$3" "$4" ;;
db_dbuserrechte) db_dbuserrechte "$2" "$3" "$4" ;;
db_deldbuser) db_deldbuser "$2" "$3" "$4" ;;
db_create_new_dbuser) db_create_new_dbuser "$2" "$3" "$4" "$5" ;;
db_anzeigen) db_anzeigen "$2" "$3" "$4" ;;
db_dbuser) db_dbuser "$2" "$3" ;;
db_delete) db_delete "$2" "$3" "$4" ;;
db_empty) db_empty "$2" "$3" "$4" ;;
db_tables) db_tables "$2" "$3" "$4" ;;
db_tables_dialog) db_tables_dialog "$2" "$3" "$4" ;;
db_regions) db_regions "$2" "$3" "$4" ;;
db_regionsuri) db_regionsuri "$2" "$3" "$4" ;;
db_regionsport) db_regionsport "$2" "$3" "$4" ;;
db_email_setincorrectuseroff) db_email_setincorrectuseroff "$2" "$3" "$4" ;;
db_setuserofline) db_setuserofline "$2" "$3" "$4" "$5" "$6" ;;
db_setuseronline) db_setuseronline "$2" "$3" "$4" "$5" "$6" ;;
warnbox) warnbox "$2" ;;
db_anzeigen_dialog) db_anzeigen_dialog "$2" "$3" ;;
db_all_user_dialog) db_all_user_dialog "$2" "$3" "$4" ;;
db_all_uuid_dialog) db_all_uuid_dialog "$2" "$3" "$4" ;;
installmariadb18) installmariadb18 ;;
installmariadb22) installmariadb22 ;;
serverinstall22) serverinstall22 ;;
installbegin) installbegin ;;
linuxupgrade) linuxupgrade ;;
installubuntu22) installubuntu22 ;;
installmono22) installmono22 ;;
installphpmyadmin) installphpmyadmin ;;
ufwset) ufwset ;;
installationhttps22) installationhttps22 "$2" "$3" ;;
installfinish) installfinish ;;
functionslist) functionslist ;;
robustbackup) robustbackup ;;
backupdatum) backupdatum ;;
db_backuptabellen) db_backuptabellen "$2" "$3" "$4" ;;
db_restorebackuptabellen) db_restorebackuptabellen "$2" "$3" "$4" "$5" ;;
default_master_connection) default_master_connection "$2" "$3" ;;
connection_name) connection_name "$2" "$3" ;;
MASTER_USER) MASTER_USER "$2" "$3" ;;
MASTER_PASSWORD) MASTER_PASSWORD "$2" "$3" ;;
MASTER_HOST) MASTER_HOST "$2" "$3" "$4" ;;
MASTER_PORT) MASTER_PORT "$2" "$3" "$4" "$5" ;;
MASTER_CONNECT_RETRY) MASTER_CONNECT_RETRY "$2" "$3" "$4" ;;
MASTER_SSL) MASTER_SSL "$2" "$3" ;;
MASTER_SSL_CA) MASTER_SSL_CA "$2" "$3" ;;
MASTER_SSL_CAPATH) MASTER_SSL_CAPATH "$2" "$3" ;;
MASTER_SSL_CERT) MASTER_SSL_CERT "$2" "$3" ;;
MASTER_SSL_CRL) MASTER_SSL_CRL "$2" "$3" ;;
MASTER_SSL_CRLPATH) MASTER_SSL_CRLPATH "$2" "$3" ;;
MASTER_SSL_KEY) MASTER_SSL_KEY "$2" "$3" ;;
MASTER_SSL_CIPHER) MASTER_SSL_CIPHER "$2" "$3" ;;
MASTER_SSL_VERIFY_SERVER_CERT) MASTER_SSL_VERIFY_SERVER_CERT "$2" "$3" ;;
MASTER_LOG_FILE) MASTER_LOG_FILE "$2" "$3" "$4" "$5" ;;
MASTER_LOG_POS) MASTER_LOG_POS "$2" "$3" "$4" "$5" ;;
RELAY_LOG_FILE) RELAY_LOG_FILE "$2" "$3" "$4" "$5" ;;
RELAY_LOG_POS) RELAY_LOG_POS "$2" "$3" "$4" "$5" ;;
MASTER_USE_GTID) MASTER_USE_GTID "$2" "$3" ;;
MASTER_USE_GTID2) MASTER_USE_GTID2 "$2" "$3" "$4" ;;
IGNORE_SERVER_IDS) IGNORE_SERVER_IDS "$2" "$3" "$4" ;;
DO_DOMAIN_IDS) DO_DOMAIN_IDS "$2" "$3" "$4" ;;
DO_DOMAIN_IDS2) DO_DOMAIN_IDS2 "$2" "$3" ;;
IGNORE_DOMAIN_IDS) IGNORE_DOMAIN_IDS "$2" "$3" "$4" ;;
MASTER_DELAY) MASTER_DELAY "$2" "$3" "$4" ;;
Replica_Backup) Replica_Backup "$2" "$3" "$4" "$5" ;;
Replica_Backup2) Replica_Backup2 "$2" "$3" "$4" ;;
ReplikatKoordinaten) ReplikatKoordinaten "$2" "$3" "$4" "$5" "$6" "$7" "$8" ;;
textbox) textbox "$8" ;;
apacheerror) apacheerror ;;
mysqldberror) mysqldberror ;;
mariadberror) mariadberror ;;
ufwlog) ufwlog ;;
authlog) authlog ;;
accesslog) accesslog ;;
fpspeicher) fpspeicher ;;
db_tablesplitt) db_tablesplitt "$2" ;;
db_tablextract) db_tablextract "$2" "$3" ;;
db_tablextract_regex) db_tablextract_regex "$2" "$3" "$4" ;;
systeminformation) systeminformation ;;
radiolist) radiolist ;;
newregionini) newregionini ;;
ConfigSet) ConfigSet "$2" ;;
AutoInstall) AutoInstall ;;
OpenSimConfig) OpenSimConfig ;;
GridCommonConfig) GridCommonConfig ;;
osslEnableConfig) osslEnableConfig ;;
RegionsConfig) RegionsConfig ;;
RobustConfig) RobustConfig ;;
historylogclear) historylogclear "$2" ;;
ScreenLog) ScreenLog ;;
*) hauptmenu ;;
esac
vardel
#log info "###########ENDE################"
exit 0
