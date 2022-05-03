#!/bin/bash

# opensimMULTITOOL Copyright (c) 2021 BigManzai Manfred Aabye
# opensim.sh Basiert auf meinen Einzelscripten, an denen ich bereits 6 Jahre Arbeite und verbessere.
# Da Server unterschiedlich sind, kann eine einwandfreie fuunktion nicht gewährleistet werden, also bitte mit bedacht verwenden.
# Die Benutzung dieses Scriptes, oder deren Bestandteile, erfolgt auf eigene Gefahr!!!
# Erstellt und getestet ist opensim.sh, auf verschiedenen Ubuntu 18.04 Servern, unter verschiedenen Server Anbietern (Contabo, Hetzner ...).

# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#### Einstellungen ####
VERSION="V0.71.337" # opensimMULTITOOL Versionsausgabe
clear # Bildschirm loeschen

# Alte Variablen loeschen aus eventuellen voherigen sessions
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

### dummyvar, Shell-Check ueberlisten wegen der Konfigurationsdatei, hat sonst keinerlei Funktion und wird auch nicht aufgerufen.
function dummyvar()
{
# shellcheck disable=SC2034
	STARTVERZEICHNIS="opt" MONEYVERZEICHNIS="robust" ROBUSTVERZEICHNIS="robust" OPENSIMVERZEICHNIS="opensim" SCRIPTSOURCE="ScriptNeu" SCRIPTZIP="opensim-ossl-example-scripts-main.zip" MONEYSOURCE="money48" 
	MONEYZIP="OpenSimCurrencyServer-2021-master.zip" OSVERSION="opensim-0.9.2.2Dev"	REGIONSDATEI="RegionList.ini" SIMDATEI="SimulatorList.ini" WARTEZEIT=30 STARTWARTEZEIT=10 STOPWARTEZEIT=30 MONEYWARTEZEIT=60 ROBUSTWARTEZEIT=60
	BACKUPWARTEZEIT=120 AUTOSTOPZEIT=60 SETMONOTHREADS=800 SETMONOTHREADSON="yes" OPENSIMDOWNLOAD="http://opensimulator.org/dist/" OPENSIMVERSION="opensim-0.9.2.2.zip" SEARCHADRES="icanhazip.com" AUTOCONFIG="no" 
	CONFIGURESOURCE="opensim-configuration-addon-modul-main" CONFIGUREZIP="opensim-configuration-addon-modul-main.zip" 
	COLOR1=1; COLOR2=2; COLOR3=3; COLOR4=4; COLOR5=5; COLOR7=7; BCOLOR1=1;	BCOLOR2=2;	BCOLOR3=3;	BCOLOR4=4;	BCOLOR5=5;	BCOLOR7=7; OMCOLORSET="sw"; OMCOFF=0;
	SETMONOGCPARAMSON1="no"; SETMONOGCPARAMSON2="yes"
}

### Datumsvariablen Datum, Dateidatum und Uhrzeit
DATUM=$(date +%d.%m.%Y); DATEIDATUM=$(date +%d_%m_%Y); UHRZEIT=$(date +%H:%M:%S)

### Einstellungen aus opensim.cnf laden, bei einem Script upgrade gehen so die einstellungen nicht mehr verloren.
# Pfad des opensim.sh Skriptes herausfinden
SCRIPTPATH=$(cd "$(dirname "$0")" && pwd)
# Variablen aus config Datei laden opensim.cnf muss sich im gleichen Verzeichnis wie opensim.sh befinden.
# shellcheck disable=SC1091
. "$SCRIPTPATH"/opensim.cnf

### Aktuelle IP über Suchadresse ermitteln und Ausführungszeichen anhängen.
AKTUELLEIP='"'$(wget -O - -q $SEARCHADRES)'"'

### Farben Color der Konsole.

###  0 – Black    1 – Red    2 – Green    3 – Yellow    4 – Blue    5 – Magenta    6 – Cyan    7 – White
function omcolorf()
{
 # Schrift font
	COLOR1=1;	COLOR2=2;	COLOR3=3;	COLOR4=4;	COLOR5=5;	COLOR7=7;	
# Hintergrund back color
	BCOLOR1=1;	BCOLOR2=2;	BCOLOR3=3;	BCOLOR4=4;	BCOLOR5=5;	BCOLOR7=7;
	OMCOFF=0;
}

###  0 – Black    1 – Red    2 – Green    3 – Yellow    4 – Blue    5 – Magenta    6 – Cyan    7 – White
function omcolorbw()
{
 # Schrift font
	COLOR1=7;	COLOR2=7;	COLOR3=7;	COLOR4=7;	COLOR5=7;	COLOR7=7;

# Hintergrund back color
	BCOLOR1=0;	BCOLOR2=0;	BCOLOR3=0;	BCOLOR4=0;	BCOLOR5=0;	BCOLOR7=0;
	OMCOFF=0;
}

# Automatische Farbauswahl
if [[ $OMCOLORSET = "sw" ]] ; then omcolorbw; fi
if [[ $OMCOLORSET = "f" ]] ; then omcolorf; fi

### gibt es das Startverzeichnis wenn nicht abbruch.
cd /"$STARTVERZEICHNIS" || return 1
sleep 1

### Eingabeauswertung für Funktionen ohne dialog.
KOMMANDO=$1

#### Einstellungen Ende ####

### LOGO zeigt ein Logo im nicht dialog Modus an.
function logo()
{
	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null|grep -q installed; then
		clear # Bildschirm loeschen
	else
		# Datum und Uhrzeit
		DATUM=$(date +%d.%m.%Y)
		DATEIDATUM=$(date +%d_%m_%Y)
		echo "Datum: $DATUM Uhrzeit: $UHRZEIT"
		echo "Abbruch mit STRG und C"
		echo " "

		echo "$(tput setaf $COLOR4)   ____                        _____  _                    _         _               "     
		echo "  / __ \                      / ____|(_)                  | |       | |              "
		echo " | |  | | _ __    ___  _ __  | (___   _  _ __ ___   _   _ | |  __ _ | |_  ___   _ __ "
		echo " | |  | ||  _ \  / _ \|  _ \  \___ \ | ||  _   _ \ | | | || | / _  || __|/ _ \ |  __|"
		echo "$(tput setaf $COLOR2) | |__| || |_) ||  __/| | | | ____) || || | | | | || |_| || || (_| || |_| (_) || |   "
		echo "  \____/ |  __/  \___||_| |_||_____/ |_||_| |_| |_| \____||_| \____| \__|\___/ |_|   "
		echo "         | |                                                                         "
		echo "         |_|                                                                         "
		echo "	    $(tput setaf $COLOR2)opensim$(tput setaf $COLOR4)MULTITOOL$(tput sgr $OMCOFF) $VERSION" # Versionsausgabe
		echo " "
	fi
	return 0
}
logo

### Kopfzeile der log Datei.
function schreibeinfo()
{
	FILENAME="/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log" # Name der Datei
	FILESIZE=$(stat -c%s "$FILENAME") # Wie Gross ist die Datei.
	NULL=0
	# Ist die Datei Groesser als null, dann Kopfzeile nicht erneut schreiben.
	if [ "$FILESIZE" \< "$NULL" ]
	then
	{	echo "#######################################################"
		echo "$DATUM $(date +%H:%M:%S) MULTITOOL: wurde gestartet am $(date +%d.%m.%Y) um $(date +%H:%M:%S) Uhr"
		echo "$DATUM $(date +%H:%M:%S) INFO: Server Name: ${HOSTNAME}"
		echo "$DATUM $(date +%H:%M:%S) INFO: Server IP: ${AKTUELLEIP}"
		echo "$DATUM $(date +%H:%M:%S) INFO: Bash Version: ${BASH_VERSION}"
		echo "$DATUM $(date +%H:%M:%S) INFO: MONO THREAD Einstellung: ${MONO_THREADS_PER_CPU}"
		echo "$DATUM $(date +%H:%M:%S) INFO: Spracheinstellung: ${LANG}"
		echo "$DATUM $(date +%H:%M:%S) INFO: Screen Version: $(screen --version)"
		echo "$DATUM $(date +%H:%M:%S) INFO: $(who -b)"
		echo " "
	} >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	fi
	return 0
}

# Kopfzeile in die Log Datei schreiben.
schreibeinfo

### Funktion vardel, Variablen loeschen.
function vardel()
{	unset STARTVERZEICHNIS; unset MONEYVERZEICHNIS; unset ROBUSTVERZEICHNIS
	unset WARTEZEIT; unset STARTWARTEZEIT; unset STOPWARTEZEIT
	unset MONEYWARTEZEIT; unset NAME; unset VERZEICHNIS; unset PASSWORD; unset DATEI
	unset OPENSIMVERZEICHNIS; unset SCRIPTSOURCE; unset SCRIPTZIP; unset MONEYSOURCE; unset MONEYZIP
	unset REGIONSNAME; unset REGIONSNAMEb; unset REGIONSNAMEc; unset REGIONSNAMEd; unset VERZEICHNISSCREEN
	return 0
}

### Sprachen
function german() 
{
    bereitsinstalliert="ist bereits installiert."
    installierejetzt="Ich installiere jetzt"
}
function frensh() 
{
    bereitsinstalliert="est déjà installé."
    installierejetzt="J'installe maintenant"
}
function spain() 
{
    bereitsinstalliert="ya está instalado."
    installierejetzt="Estoy instalando ahora"
}
function english() 
{
    bereitsinstalliert="is already installed."
    installierejetzt="I'm installing now"
}

### Spprache Einstellungen
german # Sprache

## Neue installationsroutine
function iinstall()
{
    installation=$1
    if dpkg-query -s "$installation" 2>/dev/null|grep -q installed; then
        echo "$installation $bereitsinstalliert"
    else
        echo "$installierejetzt $installation"
        sudo apt-get -y install "$installation"
    fi
}
## Neue installationsroutine aus Datei
function finstall()
{
	TXTLISTE=$1

	while read -r txtline 
	do
		if dpkg-query -s "$txtline" 2>/dev/null|grep -q installed; then
			echo "$txtline ist bereits installiert!"
		else
			echo "Ich installiere jetzt: $txtline"
			sudo apt-get -y install "$txtline"
		fi
	done < "$TXTLISTE"
}
## Neue installationsroutine aus Datei
function menufinstall()
{
	TXTLISTE=$1
	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null|grep -q installed; then
		# Alle Aktionen mit dialog
		boxtitel="opensimMULTITOOL Eingabe"; boxtext="Screen Name:"; 
		TXTLISTE=$( dialog --backtitle "opensimMULTITOOL $VERSION" --title "$boxtitel" --inputbox "$boxtext" 8 40 3>&1 1>&2 2>&3 3>&- )
		dialog --clear
		clear

		while read -r line 
		do
			if dpkg-query -s "$line" 2>/dev/null|grep -q installed; then
				echo "$line ist bereits installiert!"
			else
				echo "Ich installiere jetzt: $line"
				sudo apt-get -y install "$line"
			fi
		done < "$TXTLISTE"
	else
		# Alle Aktionen ohne dialog		
		while read -r line 
		do
			if dpkg-query -s "$line" 2>/dev/null|grep -q installed; then
				echo "$line ist bereits installiert!"
			else
				echo "Ich installiere jetzt: $line"
				sudo apt-get -y install "$line"
			fi
		done < "$TXTLISTE"
	fi
}

### downloados() Opensim download
function downloados()
{
	ASSETDELBOXERGEBNIS=$( dialog --menu "Downloads" 30 80 25 \
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
	"Download26: " "$LINK26"  3>&1 1>&2 2>&3 3>&- )

	dialog --clear

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

### rebootdatum() letzter reboot des Servers.
function rebootdatum()
{
	HEUTEDATUM=$(date +%Y-%m-%d) # Heute

	# Parsen: system boot  2021-11-30 14:26
	# Trim = | xargs
	LETZTERREBOOT=$(who -b | awk -F' ' '{print $3}' | xargs) # Letzter Reboot

	# Tolles Datum Script 
	first_date=$(date -d "$HEUTEDATUM" "+%s")
	second_date=$(date -d "$LETZTERREBOOT" "+%s")
	EINST="-d" # Manuelle auswahl umgehen.
	case "$EINST" in
	"--seconds" | "-s") period=1;;
	"--minutes" | "-m") period=60;;
	"--hours" | "-h") period=$((60*60));;
	"--days" | "-d" | "") period=$((60*60*24));;
	esac
	datediff=$(( ("$first_date" - "$second_date")/("$period") ))

	dialog --args --yesno "Sie haben vor $datediff Tag(en)\nihren Server neu gestartet\n\nMöchten sie jetzt neu starten?" 10 45

	antwort=$?

    # Alles löschen.
    dialog --clear
    clear

	# Auswertung Ja / Nein
	if [ $antwort = 0 ]
	then
		# Ja herunterfahren von Robust und OpenSim anschliessend ein Server Reboot ausführen.
		autostop
		shutdown -r now
	else
		# Nein
		hauptmenu
	fi
	return 0
}

### warnbox() Medung anzeigen.
function warnbox()
{
    dialog --msgbox "$1" 0 0
    dialog --clear
	clear
	hauptmenu
}

### Funktion screenlist, Laufende Screens auflisten.
function screenlist()
{
	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null|grep -q installed; then
		# Alle Aktionen mit dialog
		txtscreenlist=$(screen -ls)
    	warnbox "$txtscreenlist"
		hauptmenu
	else
		# Alle Aktionen ohne dialog
		echo "$(tput setaf $COLOR7)$(tput setab $BCOLOR2) Alle laufende Screens anzeigen! $(tput sgr $OMCOFF)"
		screen -ls
		echo "$DATUM $(date +%H:%M:%S) SCREENLIST: Alle laufende Screens anzeigen" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		screen -ls >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		return 0
	fi
}

function screenlistrestart()
{
	echo "$(tput setaf $COLOR7)$(tput setab $BCOLOR2) Alle laufende Screens anzeigen! $(tput sgr $OMCOFF)"
	screen -ls
	# shellcheck disable=SC2129
	echo "$DATUM $(date +%H:%M:%S) SCREENLIST: Alle laufende Screens anzeigen" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	screen -ls >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	echo "$DATUM $(date +%H:%M:%S) AUTORESTART: Auto Restart abgeschlossen" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	exit
}

### Erstellen eines Arrays aus einer Textdatei - Verzeichnisse
function makeverzeichnisliste() 
{
	VERZEICHNISSLISTE=()
	while IFS= read -r line; do
	VERZEICHNISSLISTE+=("$line")
	done < /$STARTVERZEICHNIS/$SIMDATEI
	# Anzahl der Eintraege.
	ANZAHLVERZEICHNISSLISTE=${#VERZEICHNISSLISTE[*]}
	return 0
}

### Erstellen eines Arrays aus einer Textdatei - Regionen
function makeregionsliste() 
{
	REGIONSLISTE=()
	while IFS= read -r line; do
	REGIONSLISTE+=("$line")
	done < /$STARTVERZEICHNIS/$REGIONSDATEI
	ANZAHLREGIONSLISTE=${#REGIONSLISTE[*]} # Anzahl der Eintraege.
	return 0
}

### Funktion passwdgenerator, Passwortgenerator
function passwdgenerator()
{
	### dialog Aktionen
	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null|grep -q installed; then
		# Alle Aktionen mit dialog
		boxtitel="opensimMULTITOOL Eingabe"; boxtext="Passwortstärke:"; 
		STARK=$( dialog --backtitle "opensimMULTITOOL $VERSION" --title "$boxtitel" --inputbox "$boxtext" 8 40 3>&1 1>&2 2>&3 3>&- )
		dialog --clear
		clear
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
	fi	# dialog Aktionen Ende
	return 0
}

### Funktion assetdel, Asset von der Region loeschen. Aufruf: assetdel screen_name Regionsname Objektname
function assetdel()
{
	ASSDELSCREEN=$1; REGION=$2; OBJEKT=$3
	# Nachschauen ob der Screen und die Region existiert.
	if screen -list | grep -q "$ASSDELSCREEN"; then
		echo "$(tput setaf $COLOR1) $(tput setab $BCOLOR7)$OBJEKT Asset von der Region $REGION löschen$(tput sgr $OMCOFF)"
		screen -S "$ASSDELSCREEN" -p 0 -X eval "stuff 'change region ""$REGION""'^M" # Region wechseln
		screen -S "$ASSDELSCREEN" -p 0 -X eval "stuff 'alert "Loesche: "$OBJEKT" von der Region!"'^M" # Mit einer loesch Meldung
		screen -S "$ASSDELSCREEN" -p 0 -X eval "stuff 'delete object name ""$OBJEKT""'^M" # Objekt loeschen
		screen -S "$ASSDELSCREEN" -p 0 -X eval "stuff 'y'^M" # Mit y also yes bestaetigen
		echo "$DATUM $(date +%H:%M:%S) ASSETDEL: $OBJEKT Asset von der Region $REGION löschen" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		return 0
	else
		echo "$(tput setaf $COLOR1) $(tput setab $BCOLOR7)$OBJEKT Asset von der Region $REGION löschen fehlgeschlagen$(tput sgr $OMCOFF)"
		echo "$DATUM $(date +%H:%M:%S) ASSETDEL: $OBJEKT Asset von der Region $REGION löschen fehlgeschlagen" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		return 1
	fi
}

### menuassetdel() Assets loeschen.
function menuassetdel()
{
    # zuerst schauen ob dialog installiert ist
    if dpkg-query -s dialog 2>/dev/null|grep -q installed; then

    # Einstellungen
    boxbacktitel="opensimMULTITOOL"
    boxtitel="opensimMULTITOOL Eingabe"
    formtitle="Objekt von der Region entfernen"
    lable1="Simulator:"; lablename1=""
    lable2="Region:"; lablename2=""
    lable3="Objekt:"; lablename3=""

    # Abfrage
    ASSETDELBOXERGEBNIS=$( dialog --backtitle "$boxbacktitel" --title "$boxtitel" --form "$formtitle" 25 60 16 "$lable1" 1 1 "$lablename1" 1 25 25 30 "$lable2" 2 1 "$lablename2" 2 25 25 30 "$lable3" 3 1 "$lablename3" 3 25 25 30  3>&1 1>&2 2>&3 3>&- )

    # Zeilen aus einer Variablen zerlegen und in verschiedenen Variablen schreiben.
    VERZEICHNISSCREEN=$(echo "$ASSETDELBOXERGEBNIS" | sed -n '1p')
    REGION=$(echo "$ASSETDELBOXERGEBNIS" | sed -n '2p')
    OBJEKT=$(echo "$ASSETDELBOXERGEBNIS" | sed -n '3p')

    # Alles löschen.
    dialog --clear
    clear
	else
		# Alle Aktionen ohne dialog
        echo "Keine Menülose Funktion"|exit
	fi	# dialog Aktionen Ende

	# Nachschauen ob der Screen und die Region existiert.
	if screen -list | grep -q "$VERZEICHNISSCREEN"; then
		echo "$(tput setaf $COLOR1) $(tput setab $BCOLOR7)$OBJEKT Asset von der Region $REGION löschen$(tput sgr $OMCOFF)"
		screen -S "$VERZEICHNISSCREEN" -p 0 -X eval "stuff 'change region ""$REGION""'^M" # Region wechseln
		screen -S "$VERZEICHNISSCREEN" -p 0 -X eval "stuff 'alert "Loesche: "$OBJEKT" von der Region!"'^M" # Mit einer loesch Meldung
		screen -S "$VERZEICHNISSCREEN" -p 0 -X eval "stuff 'delete object name ""$OBJEKT""'^M" # Objekt loeschen
		screen -S "$VERZEICHNISSCREEN" -p 0 -X eval "stuff 'y'^M" # Mit y also yes bestaetigen
		echo "$DATUM $(date +%H:%M:%S) ASSETDEL: $OBJEKT Asset von der Region $REGION löschen" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		return 0
	else
		echo "$(tput setaf $COLOR1) $(tput setab $BCOLOR7)$OBJEKT Asset von der Region $REGION löschen fehlgeschlagen$(tput sgr $OMCOFF)"
		echo "$DATUM $(date +%H:%M:%S) ASSETDEL: $OBJEKT Asset von der Region $REGION löschen fehlgeschlagen" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		return 1
	fi
}

### Funktion landclear, Land clear - Löscht alle Parzellen auf dem Land. # Aufruf: landclear screen_name Regionsname Objektname
function landclear()
{
	LANDCLEARSCREEN=$1; REGION=$2
	# Nachschauen ob der Screen und die Region existiert.
	if screen -list | grep -q "$LANDCLEARSCREEN"; then
		echo "$(tput setaf $COLOR1) $(tput setab $BCOLOR7)$OBJEKT Parzellen von der Region $REGION löschen$(tput sgr $OMCOFF)"
		screen -S "$LANDCLEARSCREEN" -p 0 -X eval "stuff 'change region ""$REGION""'^M" # Region wechseln
		screen -S "$LANDCLEARSCREEN" -p 0 -X eval "stuff 'alert "Loesche Parzellen von der Region!"'^M" # Mit einer loesch Meldung
		screen -S "$LANDCLEARSCREEN" -p 0 -X eval "stuff 'land clear'^M" # Objekt loeschen
		screen -S "$LANDCLEARSCREEN" -p 0 -X eval "stuff 'y'^M" # Mit y also yes bestaetigen
		echo "$DATUM $(date +%H:%M:%S) LANDCLEAR: $OBJEKT Parzellen von der Region $REGION löschen" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		return 0
	else
		echo "$(tput setaf $COLOR1) $(tput setab $BCOLOR7)$OBJEKT Parzellen von der Region $REGION löschen fehlgeschlagen$(tput sgr $OMCOFF)"
		echo "$DATUM $(date +%H:%M:%S) LANDCLEAR: $OBJEKT Parzellen von der Region $REGION löschen fehlgeschlagen" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		return 1
	fi
}

### Funktion landclear, Land clear - Löscht alle Parzellen auf dem Land. # Aufruf: landclear screen_name Regionsname Objektname
function menulandclear()
{
    # zuerst schauen ob dialog installiert ist
    if dpkg-query -s dialog 2>/dev/null|grep -q installed; then

    # Einstellungen
    boxbacktitel="opensimMULTITOOL"
    boxtitel="opensimMULTITOOL Eingabe"
    formtitle="Parzellen einer Region entfernen"
    lable1="Simulator:"; lablename1="sim2"
    lable2="Regionsname:"; lablename2="Sandbox"

    # Abfrage
    landclearBOXERGEBNIS=$( dialog --backtitle "$boxbacktitel" --title "$boxtitel" --form "$formtitle" 25 60 16 "$lable1" 1 1 "$lablename1" 1 25 25 30 "$lable2" 2 1 "$lablename2" 2 25 25 30 3>&1 1>&2 2>&3 3>&- )

    # Zeilen aus einer Variablen zerlegen und in verschiedenen Variablen schreiben.
    VERZEICHNISSCREEN=$(echo "$landclearBOXERGEBNIS" | sed -n '1p')
    REGION=$(echo "$landclearBOXERGEBNIS" | sed -n '2p')

    # Alles löschen.
    dialog --clear
    clear
	else
		# Alle Aktionen ohne dialog
        echo "Keine Menülose Funktion"|exit
	fi	# dialog Aktionen Ende

	# Nachschauen ob der Screen und die Region existiert.
	if screen -list | grep -q "$VERZEICHNISSCREEN"; then
		echo "$(tput setaf $COLOR1) $(tput setab $BCOLOR7)$OBJEKT Parzellen von der Region $REGION löschen$(tput sgr $OMCOFF)"
		screen -S "$VERZEICHNISSCREEN" -p 0 -X eval "stuff 'change region ""$REGION""'^M" # Region wechseln
		screen -S "$VERZEICHNISSCREEN" -p 0 -X eval "stuff 'alert "Loesche Parzellen von der Region!"'^M" # Mit einer loesch Meldung
		screen -S "$VERZEICHNISSCREEN" -p 0 -X eval "stuff 'land clear'^M" # Objekt loeschen
		screen -S "$VERZEICHNISSCREEN" -p 0 -X eval "stuff 'y'^M" # Mit y also yes bestaetigen
		echo "$DATUM $(date +%H:%M:%S) LANDCLEAR: $OBJEKT Parzellen von der Region $REGION löschen" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		return 0
	else
		echo "$(tput setaf $COLOR1) $(tput setab $BCOLOR7)$OBJEKT Parzellen von der Region $REGION löschen fehlgeschlagen$(tput sgr $OMCOFF)"
		echo "$DATUM $(date +%H:%M:%S) LANDCLEAR: $OBJEKT Parzellen von der Region $REGION löschen fehlgeschlagen" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		return 1
	fi
}

### Funktion loadinventar, saveinventar # Aufruf: load oder saveinventar "NAME" "VERZEICHNIS" "PASSWORD" "DATEImitPFAD"
function loadinventar()
{	
	LOADINVSCREEN="sim1"; NAME=$1; VERZEICHNIS=$2; PASSWORD=$3; DATEI=$4
	if screen -list | grep -q "$LOADINVSCREEN"; then
		echo "$(tput setab $BCOLOR2)load iar $NAME $VERZEICHNIS ***** $DATEI $(tput sgr $OMCOFF)"
		echo "$DATUM $(date +%H:%M:%S) OSCOMMAND: load iar $NAME $VERZEICHNIS ***** $DATEI " >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		screen -S "$LOADINVSCREEN" -p 0 -X eval "stuff 'load iar $NAME $VERZEICHNIS $PASSWORD $DATEI'^M"
		return 0
	else
		echo "Der Screen $LOADINVSCREEN existiert nicht."
		echo "$DATUM $(date +%H:%M:%S) OSCOMMAND: Der Screen $LOADINVSCREEN existiert nicht" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		return 1
	fi
}

### Funktion loadinventar, saveinventar # Aufruf: load oder saveinventar "NAME" "VERZEICHNIS" "PASSWORD" "DATEImitPFAD"
function menuloadinventar()
{
    # zuerst schauen ob dialog installiert ist
    if dpkg-query -s dialog 2>/dev/null|grep -q installed; then

    # Einstellungen
    boxbacktitel="opensimMULTITOOL"
    boxtitel="opensimMULTITOOL Eingabe"
    formtitle="Inventarverzeichnis laden"
    lable1="NAME:"; lablename1="John Doe"
    lable2="VERZEICHNIS:"; lablename2="/texture"
    lable3="PASSWORD:"; lablename3="PASSWORD"
    lable4="DATEI:"; lablename4="/opt/texture.iar"

    # Abfrage
    loadinventarBOXERGEBNIS=$( dialog --backtitle "$boxbacktitel" --title "$boxtitel" --form "$formtitle" 25 60 16 "$lable1" 1 1 "$lablename1" 1 25 25 30 "$lable2" 2 1 "$lablename2" 2 25 25 30 "$lable3" 3 1 "$lablename3" 3 25 25 30 "$lable4" 4 1 "$lablename4" 4 25 25 30 3>&1 1>&2 2>&3 3>&- )

    # Zeilen aus einer Variablen zerlegen und in verschiedenen Variablen schreiben.
    NAME=$(echo "$loadinventarBOXERGEBNIS" | sed -n '1p')
    VERZEICHNIS=$(echo "$loadinventarBOXERGEBNIS" | sed -n '2p')
    PASSWORD=$(echo "$loadinventarBOXERGEBNIS" | sed -n '3p')
    DATEI=$(echo "$loadinventarBOXERGEBNIS" | sed -n '4p')

    # Alles löschen.
    dialog --clear
    clear
	else
		# Alle Aktionen ohne dialog
        echo "Keine Menülose Funktion"|exit
	fi	# dialog Aktionen Ende

	LOADINVSCREEN="sim1"
	if screen -list | grep -q "$LOADINVSCREEN"; then
		echo "$(tput setab $BCOLOR2)load iar $NAME $VERZEICHNIS ***** $DATEI $(tput sgr $OMCOFF)"
		echo "$DATUM $(date +%H:%M:%S) OSCOMMAND: load iar $NAME $VERZEICHNIS ***** $DATEI " >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		screen -S "$LOADINVSCREEN" -p 0 -X eval "stuff 'load iar $NAME $VERZEICHNIS $PASSWORD $DATEI'^M"
		return 0
	else
		echo "Der Screen $LOADINVSCREEN existiert nicht."
		echo "$DATUM $(date +%H:%M:%S) OSCOMMAND: Der Screen $LOADINVSCREEN existiert nicht" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		return 1
	fi    

    # Zum schluss alle Variablen löschen.
    unset LOADINVSCREEN NAME VERZEICHNIS PASSWORD DATEI
}

### Funktion saveinventar, saveinventar # Aufruf: load oder saveinventar "NAME" "VERZEICHNIS" "PASSWORD" "DATEImitPFAD"
function saveinventar()
{	
	SAVEINVSCREEN="sim1"; NAME=$1; VERZEICHNIS=$2; PASSWORD=$3; DATEI=$4
	if screen -list | grep -q "$SAVEINVSCREEN"; then
		echo "$(tput setab $BCOLOR2)save iar $NAME $VERZEICHNIS ***** $DATEI $(tput sgr $OMCOFF)"
		echo "$DATUM $(date +%H:%M:%S) OSCOMMAND: save iar $NAME $VERZEICHNIS ***** $DATEI " >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		screen -S "$SAVEINVSCREEN" -p 0 -X eval "stuff 'save iar $NAME $VERZEICHNIS $PASSWORD $DATEI'^M"
		return 0
	else
		echo "Der Screen $SAVEINVSCREEN existiert nicht."
		echo "$DATUM $(date +%H:%M:%S) OSCOMMAND: Der Screen $SAVEINVSCREEN existiert nicht" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		return 1
	fi
}

### Funktion saveinventar, saveinventar # Aufruf: load oder saveinventar "NAME" "VERZEICHNIS" "PASSWORD" "DATEImitPFAD"
function menusaveinventar()
{
    # zuerst schauen ob dialog installiert ist
    if dpkg-query -s dialog 2>/dev/null|grep -q installed; then

    # Einstellungen
    boxbacktitel="opensimMULTITOOL"
    boxtitel="opensimMULTITOOL Eingabe"
    formtitle="Inventarverzeichnis speichern"
    lable1="NAME:"; lablename1="John Doe"
    lable2="VERZEICHNIS:"; lablename2="/texture"
    lable3="PASSWORD:"; lablename3="PASSWORD"
    lable4="DATEI:"; lablename4="/opt/texture.iar"

    # Abfrage
    saveinventarBOXERGEBNIS=$( dialog --backtitle "$boxbacktitel" --title "$boxtitel" --form "$formtitle" 25 60 16 "$lable1" 1 1 "$lablename1" 1 25 25 30 "$lable2" 2 1 "$lablename2" 2 25 25 30 "$lable3" 3 1 "$lablename3" 3 25 25 30 "$lable4" 4 1 "$lablename4" 4 25 25 30 3>&1 1>&2 2>&3 3>&- )

    # Zeilen aus einer Variablen zerlegen und in verschiedenen Variablen schreiben.
    NAME=$(echo "$saveinventarBOXERGEBNIS" | sed -n '1p')
    VERZEICHNIS=$(echo "$saveinventarBOXERGEBNIS" | sed -n '2p')
    PASSWORD=$(echo "$saveinventarBOXERGEBNIS" | sed -n '3p')
    DATEI=$(echo "$saveinventarBOXERGEBNIS" | sed -n '4p')

    # Alles löschen.
    dialog --clear
    clear
	else
		# Alle Aktionen ohne dialog
        echo "Keine Menülose Funktion"|exit
	fi	# dialog Aktionen Ende

	SAVEINVSCREEN="sim1"
	if screen -list | grep -q "$SAVEINVSCREEN"; then
		echo "$(tput setab $BCOLOR2)save iar $NAME $VERZEICHNIS ***** $DATEI $(tput sgr $OMCOFF)"
		echo "$DATUM $(date +%H:%M:%S) OSCOMMAND: save iar $NAME $VERZEICHNIS ***** $DATEI " >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		screen -S "$SAVEINVSCREEN" -p 0 -X eval "stuff 'save iar $NAME $VERZEICHNIS $PASSWORD $DATEI'^M"
		return 0
	else
		echo "Der Screen $SAVEINVSCREEN existiert nicht."
		echo "$DATUM $(date +%H:%M:%S) OSCOMMAND: Der Screen $SAVEINVSCREEN existiert nicht" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		return 1
	fi    

    # Zum schluss alle Variablen löschen.
    unset SAVEINVSCREEN NAME VERZEICHNIS PASSWORD DATEI
}

### Funktion oscommand, OpenSim Command direkt in den screen senden. # Aufruf: oscommand Screen Region Befehl Parameter
# Beispiel: /opt/opensim.sh oscommand sim1 Welcome "alert Hallo liebe Leute dies ist eine Nachricht"
# Beispiel: /opt/opensim.sh oscommand sim1 Welcome "alert-user John Doe Hallo John Doe"
function oscommand()
{	
	OSCOMMANDSCREEN=$1; REGION=$2; COMMAND=$3
	if screen -list | grep -q "$OSCOMMANDSCREEN"; then
	echo "$(tput setab $BCOLOR2)Sende $COMMAND an $OSCOMMANDSCREEN $(tput sgr $OMCOFF)"
	screen -S "$OSCOMMANDSCREEN" -p 0 -X eval "stuff 'change region ""$REGION""'^M" # Region wechseln
	echo "$DATUM $(date +%H:%M:%S) OSCOMMAND: $COMMAND an $OSCOMMANDSCREEN senden" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	screen -S "$OSCOMMANDSCREEN" -p 0 -X eval "stuff '$COMMAND'^M"
	else
		echo "Der Screen $OSCOMMANDSCREEN existiert nicht."
		echo "$DATUM $(date +%H:%M:%S) OSCOMMAND: Der Screen $OSCOMMANDSCREEN existiert nicht" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	fi
	return 0
}

### Funktion oscommand, OpenSim Command direkt in den screen senden. # Aufruf: oscommand Screen Region Befehl Parameter
function menuoscommand()
{
    # zuerst schauen ob dialog installiert ist
    if dpkg-query -s dialog 2>/dev/null|grep -q installed; then

    # Einstellungen
    boxbacktitel="opensimMULTITOOL"
    boxtitel="opensimMULTITOOL Eingabe"
    formtitle="Kommando an den Simulator"
    lable1="Simulator:"; lablename1=""
    lable2="Region:"; lablename2=""
    lable3="Befehlskette:"; lablename3=""

    # Abfrage
    oscommandBOXERGEBNIS=$( dialog --backtitle "$boxbacktitel" --title "$boxtitel" --form "$formtitle" 25 60 16 "$lable1" 1 1 "$lablename1" 1 25 25 30 "$lable2" 2 1 "$lablename2" 2 25 25 30 "$lable3" 3 1 "$lablename3" 3 25 25 30  3>&1 1>&2 2>&3 3>&- )

    # Zeilen aus einer Variablen zerlegen und in verschiedenen Variablen schreiben.
    OSCOMMANDSCREEN=$(echo "$oscommandBOXERGEBNIS" | sed -n '1p')
    REGION=$(echo "$oscommandBOXERGEBNIS" | sed -n '2p')
    COMMAND=$(echo "$oscommandBOXERGEBNIS" | sed -n '3p')

    # Alles löschen.
    dialog --clear
    clear
	else
		# Alle Aktionen ohne dialog
        echo "Keine Menülose Funktion"|exit
	fi	# dialog Aktionen Ende

	if screen -list | grep -q "$OSCOMMANDSCREEN"; then
		echo "$(tput setab $BCOLOR2)Sende $COMMAND an $OSCOMMANDSCREEN $(tput sgr $OMCOFF)"
		screen -S "$OSCOMMANDSCREEN" -p 0 -X eval "stuff 'change region ""$REGION""'^M" # Region wechseln
		echo "$DATUM $(date +%H:%M:%S) OSCOMMAND: $COMMAND an $OSCOMMANDSCREEN senden" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		screen -S "$OSCOMMANDSCREEN" -p 0 -X eval "stuff '$COMMAND'^M"
		return 0
	else
		echo "Der Screen $OSCOMMANDSCREEN existiert nicht."
		echo "$DATUM $(date +%H:%M:%S) OSCOMMAND: Der Screen $OSCOMMANDSCREEN existiert nicht" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		return 1
	fi

    # Zum schluss alle Variablen löschen.
    unset OSCOMMANDSCREEN REGION COMMAND
}

function oswriteconfig()
{	
	SETSIMULATOR=$1
	CONFIGWRITE="config save /opt/$SETSIMULATOR.ini"
	screen -S "$SETSIMULATOR" -p 0 -X eval "stuff '$CONFIGWRITE'^M"
}

function menuoswriteconfig()
{
	SETSIMULATOR=$1  # OpenSimulator, Verzeichnis und Screen Name

	### dialog Aktionen
	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null|grep -q installed; then
		# Alle Aktionen mit dialog
		boxtitel="opensimMULTITOOL Eingabe"; boxtext="Screen Name:"; 
		SETSIMULATOR=$( dialog --backtitle "opensimMULTITOOL $VERSION" --title "$boxtitel" --inputbox "$boxtext" 8 40 3>&1 1>&2 2>&3 3>&- )
		dialog --clear
		clear

		if ! screen -list | grep -q "$SETSIMULATOR"; then
		# es laeuft nicht - not work
			dialog --backtitle "opensimMULTITOOL $VERSION" --msgbox "OpenSimulator $SETSIMULATOR OFFLINE!" 5 40
            dialog --clear
            clear
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
            dialog --clear
            #clear
		fi
	else
		# Alle Aktionen ohne dialog		
		if ! screen -list | grep -q "$SETSIMULATOR"; then
			# es laeuft nicht - not work
				echo "$(tput setaf $COLOR7)$(tput setab $BCOLOR1) $SETSIMULATOR OFFLINE! $(tput sgr $OMCOFF)"
				echo "$DATUM $(date +%H:%M:%S) WORKS: $SETSIMULATOR OFFLINE!" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
				return 1
			else
			# es laeuft - work
				#echo "$(tput setaf $COLOR7)$(tput setab $BCOLOR2) $SETSIMULATOR ONLINE! $(tput sgr $OMCOFF)"
				#echo "$DATUM $(date +%H:%M:%S) WORKS: $SETSIMULATOR ONLINE!" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
				# Konfig schreiben
				CONFIGWRITE="config save /opt/$SETSIMULATOR.ini"
				screen -S "$SETSIMULATOR" -p 0 -X eval "stuff '$CONFIGWRITE'^M"
				return 0
		fi
	fi
	if dpkg-query -s dialog 2>/dev/null|grep -q installed; then	hauptmenu; fi
}

### Funktion works, screen pruefen ob er laeuft. dialog auswahl
function menuworks()
{
	WORKSSCREEN=$1  # OpenSimulator, Verzeichnis und Screen Name

	### dialog Aktionen
	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null|grep -q installed; then
		# Alle Aktionen mit dialog
		boxtitel="opensimMULTITOOL Eingabe"; boxtext="Screen Name:"; 
		WORKSSCREEN=$( dialog --backtitle "opensimMULTITOOL $VERSION" --title "$boxtitel" --inputbox "$boxtext" 8 40 3>&1 1>&2 2>&3 3>&- )
		dialog --clear
		clear

		if ! screen -list | grep -q "$WORKSSCREEN"; then
		# es laeuft nicht - not work
			dialog --backtitle "opensimMULTITOOL $VERSION" --msgbox "OpenSimulator $WORKSSCREEN OFFLINE!" 5 40
            dialog --clear
            clear
		else
		# es laeuft - work
			dialog --backtitle "opensimMULTITOOL $VERSION" --msgbox "OpenSimulator $WORKSSCREEN ONLINE!" 5 40
            dialog --clear
            clear
		fi
	else
		# Alle Aktionen ohne dialog		
		if ! screen -list | grep -q "$WORKSSCREEN"; then
			# es laeuft nicht - not work
				echo "$(tput setaf $COLOR7)$(tput setab $BCOLOR1) $WORKSSCREEN OFFLINE! $(tput sgr $OMCOFF)"
				echo "$DATUM $(date +%H:%M:%S) WORKS: $WORKSSCREEN OFFLINE!" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
				return 1
			else
			# es laeuft - work
				echo "$(tput setaf $COLOR7)$(tput setab $BCOLOR2) $WORKSSCREEN ONLINE! $(tput sgr $OMCOFF)"
				echo "$DATUM $(date +%H:%M:%S) WORKS: $WORKSSCREEN ONLINE!" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
				return 0
		fi
	fi
	if dpkg-query -s dialog 2>/dev/null|grep -q installed; then	hauptmenu; fi
}

### Funktion works, screen pruefen ob er laeuft. # Aufruf: works screen_name
function works()
{
	WORKSSCREEN=$1  # OpenSimulator, Verzeichnis und Screen Name

	# Alle Aktionen ohne dialog		
	if ! screen -list | grep -q "$WORKSSCREEN"; then
		# es laeuft nicht - not work
			echo "$(tput setaf $COLOR7)$(tput setab $BCOLOR1) $WORKSSCREEN OFFLINE! $(tput sgr $OMCOFF)"
			echo "$DATUM $(date +%H:%M:%S) WORKS: $WORKSSCREEN OFFLINE!" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
			return 1
		else
		# es laeuft - work
			echo "$(tput setaf $COLOR7)$(tput setab $BCOLOR2) $WORKSSCREEN ONLINE! $(tput sgr $OMCOFF)"
			echo "$DATUM $(date +%H:%M:%S) WORKS: $WORKSSCREEN ONLINE!" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
			return 0
	fi
}

### waslauft() Zeigt alle Laufenden Screens an.
function waslauft()
{
  # Die screen -ls ausgabe zu einer Liste ändern.
  # sed '1d' = erste Zeile löschen - sed '$d' letzte Zeile löschen.
  # awk -F. alles vor dem Punkt entfernen - -F\( alles hinter dem  ( löschen.
  ergebnis=$(screen -ls | sed '1d' | sed '$d' | awk -F. '{print $2}' | awk -F\( '{print $1}')
  echo "$ergebnis"
  return 0
}

### menuwaslauft() Zeigt alle Laufenden Screens an im dialog.
function menuwaslauft()
{
  # Die screen -ls ausgabe zu einer Liste ändern.
  # sed '1d' = erste Zeile löschen - sed '$d' letzte Zeile löschen.
  # awk -F. alles vor dem Punkt entfernen - -F\( alles hinter dem  ( löschen.
  ergebnis=$(screen -ls | sed '1d' | sed '$d' | awk -F. '{print $2}' | awk -F\( '{print $1}')
  echo "$ergebnis"  
  # dialog --infobox      "Laufende Simulatoren: $ergebnis" $HEIGHT $WIDTH; dialog --clear
  dialog --msgbox       "Laufende Simulatoren:\n $ergebnis" 20 60; dialog --clear
  hauptmenu
  return 0
}

### Funktion checkfile, pruefen ob Datei vorhanden ist. # Aufruf: checkfile "pfad/name"
# Verwendung als Einzeiler: checkfile /pfad/zur/datei && echo "File exists" || echo "File not found!"
function checkfile()
{
	DATEINAME=$1
	[ -f "$DATEINAME" ]	
	return $?
}

### Funktion mapdel, loescht die Map-Karten. # Aufruf: mapdel Verzeichnis
function mapdel()
{
	VERZEICHNIS=$1
	if [ -d "$VERZEICHNIS" ]; then
		echo "$(tput setaf $COLOR1) $(tput setab $BCOLOR7)OpenSimulator maptile $VERZEICHNIS geloescht$(tput sgr $OMCOFF)"
		cd /$STARTVERZEICHNIS/"$VERZEICHNIS"/bin || return 1
		rm -r maptiles/*
		echo "$DATUM $(date +%H:%M:%S) MAPDEL: OpenSimulator maptile $VERZEICHNIS geloescht" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		return 0
	else
		echo "$(tput setaf $COLOR1)maptile $VERZEICHNIS nicht gefunden $(tput sgr $OMCOFF)"
		echo "$DATUM $(date +%H:%M:%S) MAPDEL: maptile $VERZEICHNIS nicht gefunden" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		return 1
	fi
}

### Funktion logdel, loescht die Log Dateien. # Aufruf: logdel Verzeichnis
function logdel()
{
	VERZEICHNIS=$1
	if [ -d "$VERZEICHNIS" ]; then
		echo "$(tput setaf $COLOR1) $(tput setab $BCOLOR7)OpenSimulator log $VERZEICHNIS geloescht$(tput sgr $OMCOFF)"
		rm /$STARTVERZEICHNIS/"$VERZEICHNIS"/bin/*.log || echo " "
		echo "$DATUM $(date +%H:%M:%S) LOGDEL: OpenSimulator log $VERZEICHNIS geloescht" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		return 0
	else
		echo "$(tput setaf $COLOR1) $VERZEICHNIS logs nicht gefunden $(tput sgr $OMCOFF)"
		echo "$DATUM $(date +%H:%M:%S) LOGDEL: $VERZEICHNIS logs nicht gefunden" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		return 1
	fi
}

### Funktion rologdel, loescht die Log Dateien. # Aufruf: rologdel Verzeichnis
function rologdel()
{
	# /opt/robust/bin
	RVERZEICHNIS="robust"
	if [ -d /$STARTVERZEICHNIS/$RVERZEICHNIS ]; then
		echo "$(tput setaf $COLOR1) $(tput setab $BCOLOR7)Robust logs geloescht$(tput sgr $OMCOFF)"
		rm /$STARTVERZEICHNIS/"$RVERZEICHNIS"/bin/*.log || echo "robust logs nicht gefunden."
		echo "$DATUM $(date +%H:%M:%S) LOGDEL: Robust logs geloescht" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		return 0
	else
		echo "$(tput setaf $COLOR1) Robust logs nicht gefunden $(tput sgr $OMCOFF)"
		echo "$DATUM $(date +%H:%M:%S) LOGDEL: Robust logs nicht gefunden" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		return 1
	fi
}

### Funktion menumapdel(), loescht die Log Dateien. # Aufruf: mapdel Verzeichnis
function menumapdel()
{
	### dialog Aktionen
	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null|grep -q installed; then
		# Alle Aktionen mit dialog
		boxtitel="opensimMULTITOOL Eingabe"; boxtext="Verzeichnis:"; 
		VERZEICHNIS=$( dialog --backtitle "opensimMULTITOOL $VERSION" --title "$boxtitel" --inputbox "$boxtext" 8 40 3>&1 1>&2 2>&3 3>&- )
		dialog --clear
		clear
	else
		# Alle Aktionen ohne dialog
		VERZEICHNIS=$1
	fi	# dialog Aktionen Ende
	
	if [ -d "$VERZEICHNIS" ]; then
		echo "$(tput setaf $COLOR1) $(tput setab $BCOLOR7)OpenSimulator maptile $VERZEICHNIS geloescht$(tput sgr $OMCOFF)"
		cd /$STARTVERZEICHNIS/"$VERZEICHNIS"/bin || return 1
		rm -r maptiles/* || echo " "
		echo "$DATUM $(date +%H:%M:%S) MAPDEL: OpenSimulator maptile $VERZEICHNIS geloescht" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		return 0
	else
		echo "$(tput setaf $COLOR1)maptile $VERZEICHNIS nicht gefunden $(tput sgr $OMCOFF)"
		echo "$DATUM $(date +%H:%M:%S) MAPDEL: maptile $VERZEICHNIS nicht gefunden" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		return 1
	fi
	hauptmenu
}

### Funktion logdel, loescht die Log Dateien. # Aufruf: logdel Verzeichnis
function menulogdel()
{
	### dialog Aktionen
	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null|grep -q installed; then
		# Alle Aktionen mit dialog
		boxtitel="opensimMULTITOOL Eingabe"; boxtext="Verzeichnis:"; 
		VERZEICHNIS=$( dialog --backtitle "opensimMULTITOOL $VERSION" --title "$boxtitel" --inputbox "$boxtext" 8 40 3>&1 1>&2 2>&3 3>&- )
		dialog --clear
		clear
	else
		# Alle Aktionen ohne dialog
		VERZEICHNIS=$1
	fi
	# dialog Aktionen Ende
	
	if [ -d "$VERZEICHNIS" ]; then
		echo "$(tput setaf $COLOR1) $(tput setab $BCOLOR7)OpenSimulator log $VERZEICHNIS geloescht$(tput sgr $OMCOFF)"
		rm /$STARTVERZEICHNIS/"$VERZEICHNIS"/bin/*.log || echo " "
		echo "$DATUM $(date +%H:%M:%S) LOGDEL: OpenSimulator log $VERZEICHNIS geloescht" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		return 0
	else
		echo "$(tput setaf $COLOR1)logs nicht gefunden $(tput sgr $OMCOFF)"
		echo "$DATUM $(date +%H:%M:%S) LOGDEL: logs nicht gefunden" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		return 1
	fi
	hauptmenu
}

### Funktion ossettings, stellt den Linux Server fuer OpenSim ein.
function ossettings()
{	
	# Hier kommen alle gewünschten Einstellungen rein.
	# echo " "
	# echo "$(tput setab $BCOLOR2)Setze die Einstellungen neu! $(tput sgr $OMCOFF)"

	# ulimit
	if [[ $SETULIMITON = "yes" ]]
	then
		echo "$DATUM $(date +%H:%M:%S) OSSETTINGS: Setze die Einstellung: ulimit -s 1048576" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		# echo "Setze ulimit auf 1048576"
	ulimit -s 1048576
	fi

	# MONO_THREADS_PER_CPU
	if [[ $SETMONOTHREADSON = "yes" ]]
	then
		echo "$DATUM $(date +%H:%M:%S) OSSETTINGS: Setze die Mono Threads auf $SETMONOTHREADS" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		# echo "Setze Mono Threads auf $SETMONOTHREADS"
		MONO_THREADS_PER_CPU=$SETMONOTHREADS
	fi

	# MONO_GC_PARAMS
	if [[ $SETMONOGCPARAMSON1 = "yes" ]]
	then
		echo "$DATUM $(date +%H:%M:%S) OSSETTINGS: Setze die Einstellung: minor=split,promotion-age=14,nursery-size=64m" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		# echo "Setze Mono GC Parameter auf minor=split,promotion-age=14,nursery-size=64m"

		export MONO_GC_PARAMS="minor=split,promotion-age=14,nursery-size=64m"

	fi
	if [[ $SETMONOGCPARAMSON2 = "yes" ]]
	then
		echo "$DATUM $(date +%H:%M:%S) OSSETTINGS: Setze die Einstellung: nursery-size=32m,promotion-age=14,minor=split,major=marksweep,no-lazy-sweep,alloc-ratio=50,nursery-size=64m" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"

		# Test 26.02.2022
		export MONO_GC_PARAMS="nursery-size=32m,promotion-age=14,minor=split,major=marksweep,no-lazy-sweep,alloc-ratio=50,nursery-size=64m"
		export MONO_GC_DEBUG=""
		export MONO_ENV_OPTIONS="--desktop"
	fi

	return 0
}

### Funktion osstart, startet Region Server. # Beispiel-Example: /opt/opensim.sh osstart sim1
function osstart()
{
	OSSTARTSCREEN=$1 # OpenSimulator, Verzeichnis und Screen Name

	if ! screen -list | grep -q "$OSSTARTSCREEN"; then
		if [ -d "$OSSTARTSCREEN" ]; then
			
			cd /$STARTVERZEICHNIS/"$OSSTARTSCREEN"/bin || return 1

			# AOT Aktiveren oder Deaktivieren.
			if [[ $SETAOTON = "yes" ]]
			then
				echo "$(tput setaf $COLOR2) $(tput setab $BCOLOR7)OpenSimulator $OSSTARTSCREEN Starten aot $(tput sgr $OMCOFF)"
				echo "$DATUM $(date +%H:%M:%S) OSSTART: OpenSimulator $OSSTARTSCREEN Starten aot" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
				screen -fa -S "$OSSTARTSCREEN" -d -U -m mono --desktop -O=all OpenSim.exe
				return 0
			else
				echo "$(tput setaf $COLOR2) $(tput setab $BCOLOR7)OpenSimulator $OSSTARTSCREEN Starten$(tput sgr $OMCOFF)"
				echo "$DATUM $(date +%H:%M:%S) OSSTART: OpenSimulator $OSSTARTSCREEN Starten" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
				screen -fa -S "$OSSTARTSCREEN" -d -U -m mono OpenSim.exe
				return 0
			fi		
			sleep 10
		else
			echo "$(tput setaf $COLOR1) $(tput setab $BCOLOR7)OpenSimulator $OSSTARTSCREEN nicht vorhanden$(tput sgr $OMCOFF)"
			echo "$DATUM $(date +%H:%M:%S) OSSTART: OpenSimulator $OSSTARTSCREEN nicht vorhanden" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
			return 1
		fi

	else
		# es laeuft - work
		echo "$(tput setaf $COLOR1) $(tput setab $BCOLOR7)OpenSimulator $OSSTARTSCREEN läuft bereits$(tput sgr $OMCOFF)"
		echo "$DATUM $(date +%H:%M:%S) OSSTART: OpenSimulator $OSSTARTSCREEN läuft bereits" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		return 1
	fi

	if dpkg-query -s dialog 2>/dev/null|grep -q installed; then hauptmenu; fi
}

### Funktion osstop, stoppt Region Server. # Beispiel-Example: /opt/opensim.sh osstop sim1
function osstop()
{
	OSSTOPSCREEN=$1 # OpenSimulator, Verzeichnis und Screen Name
	if screen -list | grep -q "$OSSTOPSCREEN"; then
		echo "$(tput setaf $COLOR1) $(tput setab $BCOLOR7)OpenSimulator $OSSTOPSCREEN Beenden$(tput sgr $OMCOFF)"
		echo "$DATUM $(date +%H:%M:%S) OSSTOP: OpenSimulator $OSSTOPSCREEN Beenden" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		screen -S "$OSSTOPSCREEN" -p 0 -X eval "stuff 'shutdown'^M"
		sleep 10
		return 0
	else
		echo "$(tput setaf $COLOR1) $(tput setab $BCOLOR7)OpenSimulator $OSSTOPSCREEN nicht vorhanden$(tput sgr $OMCOFF)"
		echo "$DATUM $(date +%H:%M:%S) OSSTOP: OpenSimulator $OSSTOPSCREEN nicht vorhanden" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		return 1
	fi

	if dpkg-query -s dialog 2>/dev/null|grep -q installed; then hauptmenu; fi
}

### Funktion menuosstart() ist die dialog Version von osstart()
function menuosstart()
{
    IOSSTARTSCREEN=$(\
    dialog --backtitle "opensimMULTITOOL $VERSION" --title "opensimMULTITOOL Eingabe" \
            --inputbox "Simulator:" 8 40 \
    3>&1 1>&2 2>&3 3>&- \
    )

    dialog --clear
    clear

	if ! screen -list | grep -q "$IOSSTARTSCREEN"; then
		# es laeuft nicht - not work

		if [ -d "$IOSSTARTSCREEN" ]; then
			
			cd /$STARTVERZEICHNIS/"$IOSSTARTSCREEN"/bin || return 1

			# AOT Aktiveren oder Deaktivieren.
			if [[ $SETAOTON = "yes" ]]
			then
			DIALOG=dialog
			(echo "10" ; screen -fa -S "$IOSSTARTSCREEN" -d -U -m mono --desktop -O=all OpenSim.exe ; sleep 3
			echo "100" ; sleep 2) |
			$DIALOG --title "$IOSSTARTSCREEN" --gauge "Start" 8 30
			$DIALOG --clear
			$DIALOG --msgbox "$IOSSTARTSCREEN gestartet!" 5 20
			$DIALOG --clear
			clear
			return 0
			else
			DIALOG=dialog
			(echo "10" ; screen -fa -S "$IOSSTARTSCREEN" -d -U -m mono OpenSim.exe ; sleep 3
			echo "100" ; sleep 2) |
			$DIALOG --title "$IOSSTARTSCREEN" --gauge "Start" 8 30
			$DIALOG --clear
			$DIALOG --msgbox "$IOSSTARTSCREEN gestartet!" 5 20
			$DIALOG --clear
			clear
			hauptmenu
			fi		
		else
			echo "OpenSimulator $IOSSTARTSCREEN nicht vorhanden"
			hauptmenu
		fi
	else
		# es laeuft - work
		echo "$(tput setaf $COLOR1) $(tput setab $BCOLOR7)OpenSimulator $IOSSTARTSCREEN läuft bereits$(tput sgr $OMCOFF)"
		echo "$DATUM $(date +%H:%M:%S) OSSTART: OpenSimulator $IOSSTARTSCREEN läuft bereits" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		hauptmenu
	fi
	# hauptmenu
}

### Funktion menuosstop() ist die dialog Version von osstop()
function menuosstop()
{
    IOSSTOPSCREEN=$(\
    dialog --backtitle "opensimMULTITOOL $VERSION" --title "opensimMULTITOOL Eingabe" \
            --inputbox "Simulator:" 8 40 \
    3>&1 1>&2 2>&3 3>&- \
    )
    dialog --clear
    clear

	if screen -list | grep -q "$IOSSTOPSCREEN"; then
		DIALOG=dialog
		(echo "10" ; screen -S "$IOSSTOPSCREEN" -p 0 -X eval "stuff 'shutdown'^M" ; sleep 3
		echo "100" ; sleep 2) |
		$DIALOG --title "$IOSSTOPSCREEN" --gauge "Stop" 8 30
		$DIALOG --clear
		$DIALOG --msgbox "$IOSSTOPSCREEN beendet!" 5 20
		$DIALOG --clear
		clear
		hauptmenu
	else
		hauptmenu
	fi
}

### Funktion rostart, Robust Server starten.
function rostart()
{
	if checkfile /$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS/bin/Robust.exe; then		
		cd /$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS/bin || return 1

		# AOT Aktiveren oder Deaktivieren.
		if [[ $SETAOTON = "yes" ]]
		then
			echo "$(tput setaf $COLOR2) $(tput setab $BCOLOR7)RobustServer Start aot $(tput sgr $OMCOFF)"
			echo "$DATUM $(date +%H:%M:%S) ROSTART: RobustServer Start aot" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
			screen -fa -S RO -d -U -m mono --desktop -O=all Robust.exe
			echo "$DATUM $(date +%H:%M:%S) ROSTART: RobustServer wartezeit $ROBUSTWARTEZEIT Sekunden" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
			sleep $ROBUSTWARTEZEIT
			return 0
		else
			echo "$(tput setaf $COLOR2) $(tput setab $BCOLOR7)RobustServer Start $(tput sgr $OMCOFF)"
			echo "$DATUM $(date +%H:%M:%S) ROSTART: RobustServer Start" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
			screen -fa -S RO -d -U -m mono Robust.exe
			echo "$DATUM $(date +%H:%M:%S) ROSTART: RobustServer wartezeit $ROBUSTWARTEZEIT Sekunden" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
			sleep $ROBUSTWARTEZEIT
			return 0
		fi		
	else
		echo "$(tput setaf $COLOR1)RobustServer wurde nicht gefunden $(tput sgr $OMCOFF)"
		echo "$DATUM $(date +%H:%M:%S) ROSTART: RobustServer wurde nicht gefunden" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		return 1
	fi
}
function menurostart()
{
	if checkfile /$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS/bin/Robust.exe; then		
		cd /$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS/bin || return 1

		# AOT Aktiveren oder Deaktivieren.
		if [[ $SETAOTON = "yes" ]]
		then
			echo "$DATUM $(date +%H:%M:%S) ROSTART: RobustServer Start aot" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
			screen -fa -S RO -d -U -m mono --desktop -O=all Robust.exe
			echo "$DATUM $(date +%H:%M:%S) ROSTART: RobustServer wartezeit $ROBUSTWARTEZEIT Sekunden" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
			sleep $ROBUSTWARTEZEIT
			#return 0
		else
			echo "$DATUM $(date +%H:%M:%S) ROSTART: RobustServer Start" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
			screen -fa -S RO -d -U -m mono Robust.exe
			echo "$DATUM $(date +%H:%M:%S) ROSTART: RobustServer wartezeit $ROBUSTWARTEZEIT Sekunden" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
			sleep $ROBUSTWARTEZEIT
			#return 0
		fi		
	else
		echo "$DATUM $(date +%H:%M:%S) ROSTART: RobustServer wurde nicht gefunden" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		#return 1
	fi
}

### Funktion rostop, Robust Server herunterfahren.
function rostop()
{
	if screen -list | grep -q "RO"; then
		echo "$(tput setaf $COLOR1) $(tput setab $BCOLOR7)RobustServer Beenden $(tput sgr $OMCOFF)"
		screen -S RO -p 0 -X eval "stuff 'shutdown'^M"
		echo "$DATUM $(date +%H:%M:%S) ROSTOP: RobustServer Beenden" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		sleep $WARTEZEIT
		return 0
	else
		echo "$(tput setaf $COLOR1) $(tput setab $BCOLOR7)RobustServer nicht vorhanden $(tput sgr $OMCOFF)"
		echo "$DATUM $(date +%H:%M:%S) ROSTOP: RobustServer nicht vorhanden" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		return 1
	fi
}
function menurostop()
{
	if screen -list | grep -q "RO"; then
		screen -S RO -p 0 -X eval "stuff 'shutdown'^M"
		echo "$DATUM $(date +%H:%M:%S) ROSTOP: RobustServer Beenden" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		sleep $WARTEZEIT
		#return 0
	else
		echo "$DATUM $(date +%H:%M:%S) ROSTOP: RobustServer nicht vorhanden" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		#return 1
	fi
}

### Funktion mostart, Money Server starten.
function mostart()
{
	if checkfile /$STARTVERZEICHNIS/$MONEYVERZEICHNIS/bin/MoneyServer.exe; then
		cd /$STARTVERZEICHNIS/$MONEYVERZEICHNIS/bin || return 1

		# AOT Aktiveren oder Deaktivieren.
		if [[ $SETAOTON = "yes" ]]
		then
			echo "$(tput setaf $COLOR2) $(tput setab $BCOLOR7)Money Server Start aot $(tput sgr $OMCOFF)"
			echo "$DATUM $(date +%H:%M:%S) MOSTART: Money Server Start aot" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
			screen -fa -S MO -d -U -m mono --desktop -O=all MoneyServer.exe
			echo "$DATUM $(date +%H:%M:%S) MOSTART: Money Server wartezeit $MONEYWARTEZEIT Sekunden" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
			sleep $MONEYWARTEZEIT
			return 0
		else
			echo "$(tput setaf $COLOR2) $(tput setab $BCOLOR7)Money Server Start $(tput sgr $OMCOFF)"
			echo "$DATUM $(date +%H:%M:%S) MOSTART: Money Server Start" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
			screen -fa -S MO -d -U -m mono MoneyServer.exe
			echo "$DATUM $(date +%H:%M:%S) MOSTART: Money Server wartezeit $MONEYWARTEZEIT Sekunden" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
			sleep $MONEYWARTEZEIT
			return 0
		fi
	else
		echo "$(tput setaf $COLOR1)Money Server wurde nicht gefunden $(tput sgr $OMCOFF)"
		echo "$DATUM $(date +%H:%M:%S) MOSTART: Money Server wurde nicht gefunden" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		return 1
	fi
}
function menumostart()
{
	if checkfile /$STARTVERZEICHNIS/$MONEYVERZEICHNIS/bin/MoneyServer.exe; then
		cd /$STARTVERZEICHNIS/$MONEYVERZEICHNIS/bin || return 1

		# AOT Aktiveren oder Deaktivieren.
		if [[ $SETAOTON = "yes" ]]
		then
			echo "$DATUM $(date +%H:%M:%S) MOSTART: Money Server Start aot" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
			screen -fa -S MO -d -U -m mono --desktop -O=all MoneyServer.exe
			echo "$DATUM $(date +%H:%M:%S) MOSTART: Money Server wartezeit $MONEYWARTEZEIT Sekunden" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
			sleep $MONEYWARTEZEIT
			return 0
		else
			echo "$DATUM $(date +%H:%M:%S) MOSTART: Money Server Start" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
			screen -fa -S MO -d -U -m mono MoneyServer.exe
			echo "$DATUM $(date +%H:%M:%S) MOSTART: Money Server wartezeit $MONEYWARTEZEIT Sekunden" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
			sleep $MONEYWARTEZEIT
			return 0
		fi
	else
		echo "$DATUM $(date +%H:%M:%S) MOSTART: Money Server wurde nicht gefunden" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		return 1
	fi
}

### Funktion mostop, Money Server herunterfahren.
function mostop()
{
	if screen -list | grep -q "MO"; then
		echo "$(tput setaf $COLOR1) $(tput setab $BCOLOR7)Money Server Beenden $(tput sgr $OMCOFF)"
		screen -S MO -p 0 -X eval "stuff 'shutdown'^M"
		echo "$DATUM $(date +%H:%M:%S) MOSTOP: Money Server Beenden" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		sleep $MONEYWARTEZEIT
		return 0
	else
		echo "$(tput setaf $COLOR1) $(tput setab $BCOLOR7)Money Server nicht vorhanden $(tput sgr $OMCOFF)"
		echo "$DATUM $(date +%H:%M:%S) MOSTOP: Money Server nicht vorhanden" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		return 1
	fi
}
function menumostop()
{
	if screen -list | grep -q "MO"; then
		#echo "$(tput setaf $COLOR1) $(tput setab $BCOLOR7)Money Server Beenden $(tput sgr $OMCOFF)"
		screen -S MO -p 0 -X eval "stuff 'shutdown'^M"
		echo "$DATUM $(date +%H:%M:%S) MOSTOP: Money Server Beenden" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		sleep $MONEYWARTEZEIT
		return 0
	else
		#echo "$(tput setaf $COLOR1) $(tput setab $BCOLOR7)Money Server nicht vorhanden $(tput sgr $OMCOFF)"
		echo "$DATUM $(date +%H:%M:%S) MOSTOP: Money Server nicht vorhanden" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		return 1
	fi
}

### Funktion osscreenstop, beendet ein Screeen. # Beispiel-Example: osscreenstop sim1
function osscreenstop()
{
	SCREENSTOPSCREEN=$1
	if screen -list | grep -q "$SCREENSTOPSCREEN"; then
		echo "$(tput setaf $COLOR1) $(tput setab $BCOLOR7)Screeen $SCREENSTOPSCREEN Beenden $(tput sgr $OMCOFF)"
		echo "$DATUM $(date +%H:%M:%S) OSSCREENSTOP: Screeen $SCREENSTOPSCREEN Beenden" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		screen -S "$SCREENSTOPSCREEN" -X quit
		return 0
	else
		echo "$(tput setaf $COLOR1) $(tput setab $BCOLOR7)Screeen $SCREENSTOPSCREEN nicht vorhanden $(tput sgr $OMCOFF)"
		echo "$DATUM $(date +%H:%M:%S) OSSCREENSTOP: Screeen $SCREENSTOPSCREEN nicht vorhanden" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		return 1
	fi
	echo "No screen session found. Ist hier kein Fehler, sondern ein Beweis, das alles zuvor sauber heruntergefahren wurde."
}

### Funktion gridstart, startet erst Robust und dann Money.
function gridstart()
{
	ossettings
	echo " "
	if screen -list | grep -q RO; then
		echo "$(tput setaf $COLOR1) $(tput setab $BCOLOR7)RobustServer läuft bereits $(tput sgr $OMCOFF)"
	else
		rostart
		#if [[ $? == 1 ]] ; then echo "gridstart ERROR: rostart"; exit 1; fi
	fi
	if screen -list | grep -q MO; then
		echo "$(tput setaf $COLOR1) $(tput setab $BCOLOR7)MoneyServer läuft bereits $(tput sgr $OMCOFF)"
	else
		mostart
		#if [[ $? == 1 ]] ; then echo "gridstart ERROR: mostart"; exit 1; fi
	fi
	return 0
}
#menugridstart
function menugridstart()
{
	ossettings
	echo " "
	if screen -list | grep -q RO; then
		echo "$(tput setaf $COLOR1) $(tput setab $BCOLOR7)RobustServer läuft bereits $(tput sgr $OMCOFF)"
	else
		menurostart
		#if [[ $? == 1 ]] ; then echo "gridstart ERROR: rostart"; exit 1; fi
	fi
	if screen -list | grep -q MO; then
		echo "$(tput setaf $COLOR1) $(tput setab $BCOLOR7)MoneyServer läuft bereits $(tput sgr $OMCOFF)"
	else
		menumostart
		#if [[ $? == 1 ]] ; then echo "gridstart ERROR: mostart"; exit 1; fi
	fi
	#return 0
}

### Funktion simstats, zeigt Simstatistik an. # simstats screen_name
# Beispiel-Example: simstats sim1
# erzeugt im Hauptverzeichnis eine Datei namens sim1.log in dieser Datei ist die Statistik zu finden.
function simstats()
{
	STATSSCREEN=$1 # OpenSimulator, Verzeichnis und Screen Name
	if screen -list | grep -q "$STATSSCREEN"; then
		if checkfile /$STARTVERZEICHNIS/"$STATSSCREEN".log; then
			rm /$STARTVERZEICHNIS/"$STATSSCREEN".log
		fi
		echo "$(tput setaf $COLOR2) $(tput setab $BCOLOR7)OpenSimulator $STATSSCREEN Simstatistik anzeigen $(tput sgr $OMCOFF)"
		echo "$DATUM $(date +%H:%M:%S) simstat: Region $STATSSCREEN Simstatistik anzeigen" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		screen -S "$STATSSCREEN" -p 0 -X eval "stuff 'stats save /$STARTVERZEICHNIS/$STATSSCREEN.log'^M"
		sleep 2
		echo "$(tput setaf $COLOR2) "
		cat /$STARTVERZEICHNIS/"$STATSSCREEN".log
		echo "$(tput sgr $OMCOFF) "
	else
		echo "$(tput setaf $COLOR1) $(tput setab $BCOLOR7)Simulator $STATSSCREEN nicht vorhanden $(tput sgr $OMCOFF)"
		echo "$DATUM $(date +%H:%M:%S) simstat: Simulator $STATSSCREEN nicht vorhanden" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	fi
	return 0
}

### Funktion terminator, killt alle noch offene Screens.
function terminator()
{
	echo "hasta la vista baby"
	echo "$DATUM $(date +%H:%M:%S) TERMINATOR: Alle Screens wurden durch Benutzer beendet" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	killall screen
	screen -ls
	return 0
}

### Funktion oscompi, kompilieren des OpenSimulator.
function oscompi()
{
	echo "$(tput setab $BCOLOR2)Kompilierungsvorgang startet! $(tput sgr $OMCOFF)"
	echo "$DATUM $(date +%H:%M:%S) OSCOMPI: Kompilierungsvorgang startet" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	# In das opensim Verzeichnis wechseln wenn es das gibt ansonsten beenden.
	cd /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS || return 1
	
	echo 'Prebuildvorgang startet!'
	echo "$DATUM $(date +%H:%M:%S) OSCOMPI: Prebuildvorgang startet" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	# runprebuild19.sh startbar machen und starten.
	chmod +x runprebuild19.sh || chmod +x runprebuild48.sh
	./runprebuild19.sh || ./runprebuild48.sh

	# ohne log Datei.
	if [[ $SETOSCOMPION = "no" ]]
	then
		msbuild /p:Configuration=Release || return 1
	fi
	# mit log Datei.
	if [[ $SETOSCOMPION = "yes" ]]
	then
		msbuild /p:Configuration=Release /fileLogger /flp:logfile=opensimbuild.log /v:d || return 1
	fi
	# AOT Aktiveren oder Deaktivieren.
	if [[ $SETAOTON = "yes" ]]
	then		
		makeaot
	fi
	echo " "
	echo "$DATUM $(date +%H:%M:%S) OSCOMPI: Kompilierung wurde durchgeführt" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	return 0
}

### Funktion gitcopy, Dateien vom Github kopieren.
function moneygitcopy()
{
#Money und Scripte vom Git holen

	if [[ $MONEYCOPY = "yes" ]]
	then
		echo "$(tput setab $BCOLOR2)MoneyServer wird vom GIT geholt! $(tput sgr $OMCOFF)"
		echo "$DATUM $(date +%H:%M:%S) MONEYSERVER: MoneyServer wird vom GIT geholt" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		git clone https://github.com/BigManzai/OpenSimCurrencyServer-2021 /$STARTVERZEICHNIS/OpenSimCurrencyServer-2021-master
	else
		echo "$(tput setab $BCOLOR2)MoneyServer nicht vorhanden! $(tput sgr $OMCOFF)"
		echo "$DATUM $(date +%H:%M:%S) MONEYSERVER: MoneyServer nicht vorhanden" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	fi
	return 0
}

### Funktion gitcopy, Dateien vom Github kopieren.
function scriptgitcopy()
{
#Money und Scripte vom Git holen
	if [[ $SCRIPTCOPY = "yes" ]]
	then
		echo "$(tput setab $BCOLOR2)Script Assets werden vom GIT geholt! $(tput sgr $OMCOFF)"
		echo "$DATUM $(date +%H:%M:%S) SCRIPTCOPY: Script Assets werden vom GIT geholt" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		git clone https://github.com/BigManzai/opensim-ossl-example-scripts /$STARTVERZEICHNIS/opensim-ossl-example-scripts-main
	else
		echo "$(tput setab $BCOLOR2)Script Assets sind nicht vorhanden! $(tput sgr $OMCOFF)"
		echo "$DATUM $(date +%H:%M:%S) SCRIPTCOPY: Script Assets sind nicht vorhanden" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	fi
	return 0
}

### Funktion gitcopy, Dateien vom Github kopieren.
function configuregitcopy()
{
#Money und Scripte vom Git holen
	if [[ $CONFIGURECOPY = "yes" ]]
	then
		echo "$(tput setab $BCOLOR2)Configure wird vom GIT geholt! $(tput sgr $OMCOFF)"
		echo "$DATUM $(date +%H:%M:%S) CONFIGURECOPY: Configure wird vom GIT geholt" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		git clone https://github.com/BigManzai/opensim-configuration-addon-modul
	else
		echo "$(tput setab $BCOLOR2)Configure ist nicht vorhanden! $(tput sgr $OMCOFF)"
		echo "$DATUM $(date +%H:%M:%S) CONFIGURECOPY: Configure ist nicht vorhanden" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	fi
	return 0
}

### Funktion gitcopy, Dateien vom Github kopieren.
function OpenSimSearchgitcopy()
{
#OpenSimSearch vom Git holen
	if [[ $OSSEARCHCOPY = "yes" ]]
	then
		echo "$(tput setab $BCOLOR2)OpenSimSearch wird vom GIT geholt! $(tput sgr $OMCOFF)"
		echo "$DATUM $(date +%H:%M:%S) COPY: OpenSimSearch wird vom GIT geholt" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		git clone https://github.com/BigManzai/OpenSimSearch
	else
		echo "$(tput setab $BCOLOR2)OpenSimSearch ist nicht vorhanden! $(tput sgr $OMCOFF)"
		echo "$DATUM $(date +%H:%M:%S) COPY: OpenSimSearch ist nicht vorhanden" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	fi
	return 0
}

### Funktion scriptcopy, lsl ossl scripte kopieren.
function scriptcopy()
{
	if [[ $SCRIPTCOPY = "yes" ]]
	then
		if [ -d /$STARTVERZEICHNIS/$SCRIPTSOURCE/ ]; then
			echo "$(tput setab $BCOLOR2)Script Assets werden kopiert! $(tput sgr $OMCOFF)"
			echo "$DATUM $(date +%H:%M:%S) SCRIPTCOPY: Script Assets werden kopiert" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
			cp -r /$STARTVERZEICHNIS/$SCRIPTSOURCE/assets /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/bin
			cp -r /$STARTVERZEICHNIS/$SCRIPTSOURCE/inventory /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/bin
			echo " "
		else
			# entpacken und kopieren
			echo "$(tput setab $BCOLOR2)Script Assets werden entpackt! $(tput sgr $OMCOFF)"
			echo "$DATUM $(date +%H:%M:%S) SCRIPTCOPY: Script Assets werden entpackt" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
			unzip "$SCRIPTZIP"
			echo "$(tput setab $BCOLOR2)Script Assets werden kopiert! $(tput sgr $OMCOFF)"
			echo "$DATUM $(date +%H:%M:%S) SCRIPTCOPY: Script Assets werden kopiert" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
			cp -r /$STARTVERZEICHNIS/$SCRIPTSOURCE/assets /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/bin
			cp -r /$STARTVERZEICHNIS/$SCRIPTSOURCE/inventory /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/bin
			echo " "

			#echo "$(tput setab $BCOLOR2)Script Assets sind nicht vorhanden! $(tput sgr $OMCOFF)"
			#echo "$DATUM $(date +%H:%M:%S) SCRIPTCOPY: Script Assets sind nicht vorhanden" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		fi
	else
    	echo "Skripte werden nicht kopiert."
		echo "$DATUM $(date +%H:%M:%S) SCRIPTCOPY: Skripte werden nicht kopiert." >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	fi
	return 0
}

### Funktion moneycopy, Money Dateien kopieren.
function moneycopy()
{
	if [[ $MONEYCOPY = "yes" ]]
	then
			if [ -d /$STARTVERZEICHNIS/$MONEYSOURCE/ ]; then
			echo "$(tput setab $BCOLOR2)Money Kopiervorgang startet! $(tput sgr $OMCOFF)"
			echo "$DATUM $(date +%H:%M:%S) MONEYCOPY: Money Kopiervorgang gestartet" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
			cp -r /$STARTVERZEICHNIS/$MONEYSOURCE/bin /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS
			cp -r /$STARTVERZEICHNIS/$MONEYSOURCE/addon-modules /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS
			echo " "
		else
			# Entpacken und kopieren
			echo "$(tput setab $BCOLOR2)Money entpacken! $(tput sgr $OMCOFF)"
			echo "$DATUM $(date +%H:%M:%S) MONEYCOPY: Money entpacken" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
			unzip "$MONEYZIP"
			echo "$(tput setab $BCOLOR2)Money Kopiervorgang startet! $(tput sgr $OMCOFF)"
			echo "$DATUM $(date +%H:%M:%S) MONEYCOPY: Money Kopiervorgang gestartet" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
			cp -r /$STARTVERZEICHNIS/$MONEYSOURCE/bin /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS
			cp -r /$STARTVERZEICHNIS/$MONEYSOURCE/addon-modules /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS
			echo " "
			#echo "$(tput setab $BCOLOR2)Moneyserver ist nicht vorhanden! $(tput sgr $OMCOFF)"
			#echo "$DATUM $(date +%H:%M:%S) SCRIPTCOPY: Moneyserver ist nicht vorhanden" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		fi
	else
    	echo "Money wird nicht kopiert."
		echo "$DATUM $(date +%H:%M:%S) SCRIPTCOPY: Money wird nicht kopiert." >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	fi
	return 0
}

### configurecopy
### Funktion moneycopy, Money Dateien kopieren.
function configurecopy()
{
	if [[ $CONFIGURECOPY = "yes" ]]
	then
	##/opt/opensim-configuration-addon-modul/Configuration
			if [ -d /opt/opensim-configuration-addon-modul ]; then
			echo "$(tput setab $BCOLOR2)Configure Kopiervorgang startet! $(tput sgr $OMCOFF)"
			echo "$DATUM $(date +%H:%M:%S) CONFIGURECOPY: Configure Kopiervorgang gestartet" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"			
			cp -r /opt/opensim-configuration-addon-modul/Configuration /opt/opensim/addon-modules
			//mv /opt/opensim/addon-modules/opensim-configuration-addon-modul /opt/opensim/addon-modules/Configuration

			echo " "
		else
			# Entpacken und kopieren
			echo "$(tput setab $BCOLOR2)Configure entpacken! $(tput sgr $OMCOFF)"
			echo "$DATUM $(date +%H:%M:%S) CONFIGURECOPY: Configure entpacken" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
			unzip "$CONFIGUREZIP"
			echo "$(tput setab $BCOLOR2)Configure Kopiervorgang startet! $(tput sgr $OMCOFF)"
			echo "$DATUM $(date +%H:%M:%S) CONFIGURECOPY: Configure Kopiervorgang gestartet" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"			
			cp -r /opt/opensim-configuration-addon-modul/Configuration /$STARTVERZEICHNIS/opensim/addon-modules
			//mv /opt/opensim/addon-modules/opensim-configuration-addon-modul /opt/opensim/addon-modules/Configuration
			echo " "
		fi
	else
    	echo "Configure wird nicht kopiert."
		echo "$DATUM $(date +%H:%M:%S) CONFIGURE: Configure wird nicht kopiert." >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	fi
	return 0
}

### Funktion pythoncopy, Plugin Daten kopieren.
function pythoncopy()
{
	if [[ $PYTHONCOPY = "yes" ]]
	then
		if [ -d /$STARTVERZEICHNIS/OpensimPython/ ]; then
			echo "$(tput setab $BCOLOR2)python wird kopiert! $(tput sgr $OMCOFF)"
			echo "$DATUM $(date +%H:%M:%S) PYTHONCOPY: python wird kopiert" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
			cp -r /$STARTVERZEICHNIS/OpensimPython /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/addon-modules
		echo " "
		else
			echo "$(tput setab $BCOLOR2)python ist nicht vorhanden! $(tput sgr $OMCOFF)"
			echo "$DATUM $(date +%H:%M:%S) PYTHONCOPY: python ist nicht vorhanden" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		fi
	else
    	echo "Python wird nicht kopiert."
		echo "$DATUM $(date +%H:%M:%S) PYTHONCOPY: Python wird nicht kopiert." >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	fi
	return 0
}

### Funktion searchcopy, Plugin Daten kopieren.
function searchcopy()
{
	if [[ $SEARCHCOPY = "yes" ]]
	then
		if [ -d /$STARTVERZEICHNIS/OpenSimSearch/ ]; then
			echo "$(tput setab $BCOLOR2)OpenSimSearch wird kopiert! $(tput sgr $OMCOFF)"
			echo "$DATUM $(date +%H:%M:%S) OpenSimSearch: python wird kopiert" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
			cp -r /$STARTVERZEICHNIS/OpenSimSearch /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/addon-modules
		echo " "
		else
			echo "$(tput setab $BCOLOR2)OpenSimSearch ist nicht vorhanden! $(tput sgr $OMCOFF)"
			echo "$DATUM $(date +%H:%M:%S) OpenSimSearch: python ist nicht vorhanden" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		fi
	else
    	echo "OpenSimSearch wird nicht kopiert."
		echo "$DATUM $(date +%H:%M:%S) OpenSimSearch: OpenSimSearch wird nicht kopiert." >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	fi
	return 0
}

### Funktion mutelistcopy, Plugin Daten kopieren.
function mutelistcopy()
{
	if [[ $MUTELISTCOPY = "yes" ]]
	then
		if [ -d /$STARTVERZEICHNIS/OpenSimMutelist/ ]; then
			echo "$(tput setab $BCOLOR2)OpenSimMutelist wird kopiert! $(tput sgr $OMCOFF)"
			echo "$DATUM $(date +%H:%M:%S) OpenSimMutelist: python wird kopiert" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
			cp -r /$STARTVERZEICHNIS/OpenSimMutelist /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/addon-modules
		echo " "
		else
			echo "$(tput setab $BCOLOR2)OpenSimMutelist ist nicht vorhanden! $(tput sgr $OMCOFF)"
			echo "$DATUM $(date +%H:%M:%S) OpenSimMutelist: python ist nicht vorhanden" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		fi
	else
    	echo "OpenSimMutelist wird nicht kopiert."
		echo "$DATUM $(date +%H:%M:%S) OpenSimMutelist: OpenSimMutelist wird nicht kopiert." >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	fi
	return 0
}

### Funktion chrisoscopy, Plugin Dateien kopieren.
function chrisoscopy()
{
	if [[ $CHRISOSCOPY = "yes" ]]
	then
		# /opt/Chris.OS.Additions
		if [ -d /$STARTVERZEICHNIS/Chris.OS.Additions/ ]; then
			echo "$(tput setab $BCOLOR2)Chris.OS.Additions Kopiervorgang startet! $(tput sgr $OMCOFF)"
			echo "$DATUM $(date +%H:%M:%S) CHRISOSCOPY: Chris.OS.Additions Kopiervorgang gestartet" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
			cp -r /$STARTVERZEICHNIS/Chris.OS.Additions /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/addon-modules
			echo " "
		else
			echo "$(tput setab $BCOLOR2)Chris.OS.Additions ist nicht vorhanden! $(tput sgr $OMCOFF)"
			echo "$DATUM $(date +%H:%M:%S) CHRISOSCOPY: Chris.OS.Additions ist nicht vorhanden" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		fi	
	else
    	echo "Chris.OS.Additions werden nicht kopiert."
		echo "$DATUM $(date +%H:%M:%S) CHRISOSCOPY: Chris.OS.Additions werden nicht kopiert." >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	fi
	return 0
}

### Funktion makeaot, aot generieren.
function makeaot()
{
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
		echo "opensim Verzeichnis existiert nicht."
		echo "$DATUM $(date +%H:%M:%S) MAKEAOT: opensim Verzeichnis existiert nicht" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	fi
	return 0
}

### Funktion cleanaot, aot entfernen. Test
function cleanaot()
{
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
		echo "opensim Verzeichnis existiert nicht."
		echo "$DATUM $(date +%H:%M:%S) MAKEAOT: opensim Verzeichnis existiert nicht" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	fi
	return 0
}

### Funktion osprebuild, Prebuild einstellen # Aufruf Beispiel: opensim.sh prebuild 1330.
# Ergebnis ist eine Einstellung für Release mit dem Namn OpenSim 0.9.2.1330
# sed -i schreibt sofort - s/Suchwort/Ersatzwort/g - /Verzeichnis/Dateiname.Endung
function osprebuild()
{
	NUMMER=$1
	echo "$(tput setab $BCOLOR2)Version umbenennen und Release auf $NUMMER einstellen. $(tput sgr $OMCOFF)"
	echo "$DATUM $(date +%H:%M:%S) PREBUILD: Version umbenennen und Release auf $NUMMER einstellen" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"

	echo "V$NUMMER " > /$STARTVERZEICHNIS/opensim/bin/'.version'

	# Nummer einfügen
	#sed -i s/0.9.2.1/0.9.2.1."$NUMMER"/g /$STARTVERZEICHNIS/opensim/OpenSim/Framework/VersionInfo.cs
	# Release setzen
	#sed -i s/Flavour.Dev/Flavour.Release/g /$STARTVERZEICHNIS/opensim/OpenSim/Framework/VersionInfo.cs
	# Yeti löschen
	sed -i s/Yeti//g /$STARTVERZEICHNIS/opensim/OpenSim/Framework/VersionInfo.cs
	# flavour löschen
	sed -i s/' + flavour'//g /$STARTVERZEICHNIS/opensim/OpenSim/Framework/VersionInfo.cs
	return 0
}

# Funktion osstruktur, legt die Verzeichnisstruktur fuer OpenSim an. # Aufruf: opensim.sh osstruktur ersteSIM letzteSIM
# Beispiel: ./opensim.sh osstruktur 1 10 - erstellt ein Grid Verzeichnis fuer 10 Simulatoren inklusive der SimulatorList.ini.
function osstruktur()
{
	if [ ! -f "/$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/" ]; then
		echo "Lege robust an im Verzeichnis $ROBUSTVERZEICHNIS"
		echo "$DATUM $(date +%H:%M:%S) OSSTRUKTUR: Lege robust an im Verzeichnis $ROBUSTVERZEICHNIS" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		mkdir -p /$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS/bin
	else
		echo "opensim Verzeichnis existiert bereits."
		echo "$DATUM $(date +%H:%M:%S) OSSTRUKTUR: Verzeichnis $ROBUSTVERZEICHNIS existiert bereits" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	fi
	for ((i=$1;i<=$2;i++))
	do
	echo "Lege sim$i an"
	mkdir -p /$STARTVERZEICHNIS/sim"$i"/bin
	echo "Schreibe sim$i in $SIMDATEI"
	printf 'sim'"$i"'\t%s\n' >> /$STARTVERZEICHNIS/$SIMDATEI
	done
	echo "$DATUM $(date +%H:%M:%S) OSSTRUKTUR: Lege robust an ,Schreibe sim$i in $SIMDATEI" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	return 0
}

### Funktion menuosstruktur() ist die dialog Version von osstruktur()
function menuosstruktur()
{
    # zuerst schauen ob dialog installiert ist
    if dpkg-query -s dialog 2>/dev/null|grep -q installed; then

    # Einstellungen
    boxbacktitel="opensimMULTITOOL"
    boxtitel="opensimMULTITOOL Eingabe"
    formtitle="Verzeichnisstrukturen anlegen"
    lable1="Von:"; lablename1="1"
    lable2="Bis:"; lablename2="10"

    # Abfrage
    osstrukturBOXERGEBNIS=$( dialog --backtitle "$boxbacktitel" --title "$boxtitel" --form "$formtitle" 25 60 16 "$lable1" 1 1 "$lablename1" 1 25 25 30 "$lable2" 2 1 "$lablename2" 2 25 25 30 3>&1 1>&2 2>&3 3>&- )

    # Zeilen aus einer Variablen zerlegen und in verschiedenen Variablen schreiben.
    EINGABE=$(echo "$osstrukturBOXERGEBNIS" | sed -n '1p')
    EINGABE2=$(echo "$osstrukturBOXERGEBNIS" | sed -n '2p')

    # Alles löschen.
    dialog --clear
    clear
	else
		# Alle Aktionen ohne dialog
        echo "Keine Menülose Funktion"|exit
	fi	# dialog Aktionen Ende

	if [ ! -f "/$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/" ]; then
		echo "Lege robust an im Verzeichnis $ROBUSTVERZEICHNIS"
		echo "$DATUM $(date +%H:%M:%S) OSSTRUKTUR: Lege robust an im Verzeichnis $ROBUSTVERZEICHNIS" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		mkdir -p /$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS/bin
	else
		echo "opensim Verzeichnis existiert bereits."
		echo "$DATUM $(date +%H:%M:%S) OSSTRUKTUR: Verzeichnis $ROBUSTVERZEICHNIS existiert bereits" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	fi
	# shellcheck disable=SC2004
	for ((i=$EINGABE;i<=$EINGABE2;i++))
	do
	echo "Lege sim$i an"
	mkdir -p /$STARTVERZEICHNIS/sim"$i"/bin
	echo "Schreibe sim$i in $SIMDATEI"
	printf 'sim'"$i"'\t%s\n' >> /$STARTVERZEICHNIS/$SIMDATEI
	done
	echo "$DATUM $(date +%H:%M:%S) OSSTRUKTUR: Lege robust an ,Schreibe sim$i in $SIMDATEI" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	return 0
}

### Funktion osdelete, altes opensim loeschen und letztes opensim als Backup umbenennen.
function osdelete()
{	
	if [ -d /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/ ]; then
		echo "$(tput setaf $COLOR1) $(tput setab $BCOLOR7)Lösche altes opensim1 Verzeichnis$(tput sgr $OMCOFF)"
		echo "$DATUM $(date +%H:%M:%S) OSDELETE: Lösche altes opensim1 Verzeichnis" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		cd /$STARTVERZEICHNIS  || return 1
		rm -r /$STARTVERZEICHNIS/opensim1
		echo "$(tput setaf $COLOR1) $(tput setab $BCOLOR7)Umbenennen von $OPENSIMVERZEICHNIS nach opensim1 zur sicherung$(tput sgr $OMCOFF)"
		echo "$DATUM $(date +%H:%M:%S) OSDELETE: Umbenennen von $OPENSIMVERZEICHNIS nach opensim1 zur sicherung" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		mv /$STARTVERZEICHNIS/opensim /$STARTVERZEICHNIS/opensim1
		echo " "
		
	else
		echo "$(tput setaf $COLOR1) $(tput setab $BCOLOR7) $STARTVERZEICHNIS Verzeichnis existiert nicht$(tput sgr $OMCOFF)"
	fi
	return 0
}

### Funktion oscopyrobust, Robust Daten kopieren.
function oscopyrobust()
{
	cd /$STARTVERZEICHNIS || return 1
	if [ -d /$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS/ ]; then
		echo "$(tput setab $BCOLOR2)Kopiere Robust, Money! $(tput sgr $OMCOFF)"
		echo " "
		sleep 2
		echo "$(tput setaf $COLOR2) $(tput setab $BCOLOR7)Robust und Money kopiert$(tput sgr $OMCOFF)"
		cd /$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS/bin || return 1
		cp -r /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/bin /$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS
		echo " "
		echo "$DATUM $(date +%H:%M:%S) OSCOPY: Robust kopieren" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	else
		echo " "
	fi
	return 0
}

### Funktion oscopysim, Simulatoren kopieren aus dem Verzeichnis opensim.
function oscopysim()
{
	cd /$STARTVERZEICHNIS || return 1
	makeverzeichnisliste
	echo "$(tput setab $BCOLOR2)Kopiere Simulatoren! $(tput sgr $OMCOFF)"
	echo " "
	sleep 2
	for (( i = 0 ; i < "$ANZAHLVERZEICHNISSLISTE" ; i++)) do
		echo "$(tput setaf $COLOR2) $(tput setab $BCOLOR7)OpenSimulator ${VERZEICHNISSLISTE[$i]} kopiert$(tput sgr $OMCOFF)"
		cd /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin || return 1
		cp -r /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/bin /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"
		sleep 2
	done
	echo " "
	echo "$DATUM $(date +%H:%M:%S) OSCOPY: OpenSim kopieren" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	return 0
}

### Funktion oscopysim, Simulatoren kopieren aus dem Verzeichnis opensim.
function oscopy()
{
	cd /$STARTVERZEICHNIS || return 1
	VERZEICHNIS=$1
	echo "$(tput setab $BCOLOR2)Kopiere Simulator $VERZEICHNIS $(tput sgr $OMCOFF)"

	cd /$STARTVERZEICHNIS/"$VERZEICHNIS"/bin || return 1
	cp -r /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/bin /$STARTVERZEICHNIS/"$VERZEICHNIS"

	echo "$DATUM $(date +%H:%M:%S) OSCOPY: OpenSim kopieren" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	return 0
}


# Funktion configlesen, Regionskonfigurationen lesen. # Beispiel: configlesen sim1
function configlesen()
{
	CONFIGLESENSCREEN=$1
	echo "$(tput setab $BCOLOR2)Regionskonfigurationen von $CONFIGLESENSCREEN $(tput sgr $OMCOFF)"
	KONFIGLESEN=$(awk -F":" '// {print $0 }' /$STARTVERZEICHNIS/"$CONFIGLESENSCREEN"/bin/Regions/*.ini)	# Regionskonfigurationen aus einem Verzeichnis lesen.
	echo "$KONFIGLESEN"
	echo "$DATUM $(date +%H:%M:%S) CONFIGLESEN: Regionskonfigurationen von $CONFIGLESENSCREEN" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	echo "$KONFIGLESEN" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	return 0
}

### Funktion regionsconfigdateiliste, schreibt Dateinamen mit Pfad in eine Datei.
# regionsconfigdateiliste -b(Bildschirm) -d(Datei)  Vereichnis
function regionsconfigdateiliste() 
{
	VERZEICHNIS=$1
	declare -A Dateien # Array erstellen
	# shellcheck disable=SC2178
	Dateien=$(find /$STARTVERZEICHNIS/"$VERZEICHNIS"/bin/Regions/ -name "*.ini") # Alle Regions.ini in das Assoziative Arrays mit der Option -A schreiben oder ein indiziertes mit -a.
	for i in "${Dateien[@]}"; do # Array abarbeiten
		if [ "$2" = "-d" ]; then echo "$i" >> RegionsDateiliste.txt; fi  # In die config Datei hinzufuegen.
		if [ "$2" = "-b" ]; then echo "$i"; fi  # In die config Datei hinzufuegen.
	done
	return 0
}

### Funktion meineregionen, listet alle Regionen aus den Konfigurationen auf.
function meineregionen() 
{	
	makeverzeichnisliste
	echo "$DATUM $(date +%H:%M:%S) MEINEREGIONEN: Regionsliste" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	sleep 2
	for (( i = 0 ; i < "$ANZAHLVERZEICHNISSLISTE" ; i++))
	do
	VERZEICHNIS="${VERZEICHNISSLISTE[$i]}"
		REGIONSAUSGABE=$(awk -F "[" '/\[/ {print $1 $2 $3}' /$STARTVERZEICHNIS/"$VERZEICHNIS"/bin/Regions/*.ini |sed s/'\]'//g) # Zeigt nur die Regionsnamen aus einer Regions.ini an
		echo "$(tput setaf $COLOR2)$(tput setab $BCOLOR7) $VERZEICHNIS $(tput sgr $OMCOFF)"
		echo "$REGIONSAUSGABE"
		echo "$REGIONSAUSGABE" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	done
	echo "$DATUM $(date +%H:%M:%S) MEINEREGIONEN: Regionsliste Ende" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	return 0
}

### Funktion regionsinisuchen, sucht alle Regionen.
function regionsinisuchen() 
{	
	makeverzeichnisliste
	sleep 2

	for (( i = 0 ; i < "$ANZAHLVERZEICHNISSLISTE" ; i++))
	do
	VERZEICHNIS="${VERZEICHNISSLISTE[$i]}"
		REGIONSINIAUSGABE=$(find /$STARTVERZEICHNIS/"$VERZEICHNIS"/bin/Regions/ -name "Regions.ini")
		#leerzeilen=$(echo "$REGIONSINIAUSGABE" | grep -v '^$')
		while read -r
		do
			[[ -z "$REPLY" ]] && continue
			#echo "gelesen: '$REPLY'"
			AUSGABE=$(awk -F "[" '/\[/ {print $1 $2 $3}' "$REPLY" |sed s/'\]'//g)
			echo "$AUSGABE"
		done <<<"$REGIONSINIAUSGABE"

	done
	return 0
}

# Funktion get_regionsarray, gibt ein Array aller Regionsabschnitte zurueck.
function get_regionsarray() 
{
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

# Funktion get_value_from_Region_key, gibt den Wert eines bestimmten Schluessels im angegebenen Abschnitt zurueck.
# $1 - Datei - $2 - Schluessel - $3 - Sektion
function get_value_from_Region_key() 
{
	# RKDATEI=$1; RKSCHLUESSEL=$2; RKSEKTION=$3;
	# Es fehlt eine pruefung ob Datei vorhanden ist.
	# shellcheck disable=SC2005
	#echo "$(sed -nr "/^\[$2\]/ { :l /^$3[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" "$1")" # Nur Parameter
	echo "$(sed -nr "/^\[$2\]/ { :l /$3[ ]}*=/ { p; q;}; n; b l;}" "$1")" # Komplette eintraege
	return 0
}

### Regions.ini zerlegen
### Funktion regionsiniteilen, holt aus der Regions.ini eine Region heraus und speichert sie mit ihrem Regionsnamen.
# Aufruf: regionsiniteilen Verzeichnis Regionsname
function regionsiniteilen()
{
	INIVERZEICHNIS=$1 # Auszulesendes Verzeichnis
	RTREGIONSNAME=$2 # Auszulesende Region
	INI_FILE="/$STARTVERZEICHNIS/$INIVERZEICHNIS/bin/Regions/Regions.ini" # Auszulesende Datei

	if [ ! -d "$INI_FILE" ]; then
	echo "$(tput setaf $COLOR2)$(tput setab $BCOLOR7) REGIONSINITEILEN: Schreiben der Werte für $RTREGIONSNAME"
	echo "$DATUM $(date +%H:%M:%S) REGIONSINITEILEN: Schreiben der Werte für $RTREGIONSNAME" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	# Schreiben der einzelnen Punkte nur wenn vorhanden ist.
	# shellcheck disable=SC2005
	{	echo "[$RTREGIONSNAME]"
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
	} >> "/$STARTVERZEICHNIS/$INIVERZEICHNIS/bin/Regions/$RTREGIONSNAME.ini"
	else
		echo "$(tput setaf $COLOR1)$(tput setab $BCOLOR7)$INI_FILE wurde nicht gefunden $(tput sgr $OMCOFF)"
		echo "$DATUM $(date +%H:%M:%S) REGIONSINITEILEN: $INI_FILE wurde nicht gefunden" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	fi
	return 0
}

### Funktion autoregionsiniteilen, Die gemeinschaftsdatei Regions.ini in einzelne Regionen teilen.
# diese dann unter dem Regionsnamen speichern, danach die Alte Regions.ini umbenennen in Regions.ini.old.
function autoregionsiniteilen()
{
	makeverzeichnisliste
	sleep 2
	for (( i = 0 ; i < "$ANZAHLVERZEICHNISSLISTE" ; i++))
	do
		echo "$(tput setaf $COLOR1) $(tput setab $BCOLOR7)Region.ini ${VERZEICHNISSLISTE[$i]} zerlegen$(tput sgr $OMCOFF)"
		echo " "
		VERZEICHNIS="${VERZEICHNISSLISTE[$i]}"
		# Regions.ini teilen:
		echo "$VERZEICHNIS" # OK geht
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

### Funktion regionliste, Die RegionListe ermitteln und mit dem Verzeichnisnamen in die RegionList.ini schreiben.
function regionliste()
{
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
	for (( i = 0 ; i < "$ANZAHLVERZEICHNISSLISTE" ; i++))
	do
		echo "$(tput setaf $COLOR1) $(tput setab $BCOLOR7)Regionnamen ${VERZEICHNISSLISTE[$i]} schreiben$(tput sgr $OMCOFF)"
		VERZEICHNIS="${VERZEICHNISSLISTE[$i]}"
		# shellcheck disable=SC2178
		Dateien=$(find /$STARTVERZEICHNIS/"$VERZEICHNIS"/bin/Regions/ -name "*.ini")
		for i2 in "${Dateien[@]}"; do # Array abarbeiten
		echo "$i2" >> RegionList.ini
		done
	done
	# Ueberfluessige Zeichen entfernen
	LOESCHEN=$(sed s/'\/opt\/'//g /$STARTVERZEICHNIS/RegionList.ini) # /opt/ entfernen.
	echo "$LOESCHEN" > /$STARTVERZEICHNIS/RegionList.ini # Aenderung /opt/ speichern.
	LOESCHEN=$(sed s/'\/bin\/Regions\/'/' "'/g /$STARTVERZEICHNIS/RegionList.ini) # /bin/Regions/ entfernen.
	echo "$LOESCHEN" > /$STARTVERZEICHNIS/RegionList.ini # Aenderung /bin/Regions/ speichern.
	LOESCHEN=$(sed s/'.ini'/'"'/g /$STARTVERZEICHNIS/RegionList.ini) # Endung .ini entfernen.
	echo "$LOESCHEN" > /$STARTVERZEICHNIS/RegionList.ini # Aenderung .ini entfernen speichern.
	# Schauen ob da noch Regions.ini bei sind also Regionen mit dem Namen Regions, diese Zeilen loeschen.
	LOESCHEN=$(sed '/Regions/d' /$STARTVERZEICHNIS/RegionList.ini) # Alle Zeilen mit dem Eintrag Regions entfernen	.
	echo "$LOESCHEN" > /$STARTVERZEICHNIS/RegionList.ini # Aenderung .ini entfernen speichern.
	return 0
}

function makewebmaps()
{
	MAPTILEVERZEICHNIS="maptiles"
	echo "$DATUM $(date +%H:%M:%S) MAKEWEBMAPS: Kopiere Maptile"
	echo "$DATUM $(date +%H:%M:%S) MAKEWEBMAPS: Kopiere Maptile" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	# Verzeichnis erstellen wenn es noch nicht vorhanden ist.
	mkdir -p /var/www/html/$MAPTILEVERZEICHNIS/
	# Maptiles kopieren
	find /$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS/bin/maptiles -type f -exec cp -a -t /var/www/html/$MAPTILEVERZEICHNIS/ {} +
	return 0
}

### Funktion moneydelete, loescht den MoneyServer ohne die OpenSim Config zu veraendern.
function moneydelete()
{
	makeverzeichnisliste
	sleep 2
	# MoneyServer aus den sims entfernen 
	for (( i = 0 ; i < "$ANZAHLVERZEICHNISSLISTE" ; i++)) do
		echo "$(tput setaf $COLOR1) $(tput setab $BCOLOR7)MoneyServer ${VERZEICHNISSLISTE[$i]} geloescht$(tput sgr $OMCOFF)"
		cd /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin || return 1 # Pruefen ob Verzeichnis vorhanden ist.
		rm -r /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/MoneyServer.exe.config # Dateien loeschen.
		rm -r /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/MoneyServer.ini.example
		rm -r /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/OpenSim.Data.MySQL.MySQLMoneyDataWrapper.dll
		rm -r /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/OpenSim.Modules.Currency.dll
		echo "$DATUM $(date +%H:%M:%S) MONEYDELETE: MoneyServer ${VERZEICHNISSLISTE[$i]} geloescht" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		sleep 2
	done
	# MoneyServer aus Robust entfernen
	if [ -d /$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS/ ]
	then
		cd /$STARTVERZEICHNIS/robust/bin || return 1
		rm -r /$STARTVERZEICHNIS/robust/bin/MoneyServer.exe.config
		rm -r /$STARTVERZEICHNIS/robust/bin/MoneyServer.ini.example
		rm -r /$STARTVERZEICHNIS/robust/bin/OpenSim.Data.MySQL.MySQLMoneyDataWrapper.dll
		rm -r /$STARTVERZEICHNIS/robust/bin/OpenSim.Modules.Currency.dll
		echo "$DATUM $(date +%H:%M:%S) MONEYDELETE: MoneyServer aus Robust geloescht" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	fi
	return 0
}

### Funktion osgitholen, kopiert eine Entwicklerversion in das opensim Verzeichnis.
function osgitholen()
{
	if [ -d /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/ ]
	then
		echo "$(tput setaf $COLOR1) $(tput setaf $BCOLOR7)Kopieren der Entwicklungsversion des OpenSimulator aus dem Git$(tput sgr $OMCOFF)"
		cd /$STARTVERZEICHNIS  || return 1
		rm -r /$STARTVERZEICHNIS/opensim1
		mv /$STARTVERZEICHNIS/opensim /$STARTVERZEICHNIS/opensim1
        git clone git://opensimulator.org/git/opensim opensim
		echo "$DATUM $(date +%H:%M:%S) OPENSIMHOLEN: Git klonen" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	else
		echo "$(tput setaf $COLOR1) $(tput setaf $BCOLOR7)Kopieren der Entwicklungsversion des OpenSimulator aus dem Git$(tput sgr $OMCOFF)"
		git clone git://opensimulator.org/git/opensim opensim
		echo "$DATUM $(date +%H:%M:%S) OPENSIMHOLEN: Git klonen" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	fi
	return 0
}

### Funktion opensimholen, holt den OpenSimulator in das Arbeitsverzeichnis.
function opensimholen()
{
	if [ -d /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/ ]
	then
		echo "$(tput setaf $COLOR1) $(tput setaf $BCOLOR7)Kopieren des OpenSimulator in das Arbeitsverzeichnis$(tput sgr $OMCOFF)"
		cd /$STARTVERZEICHNIS  || return 1
		rm -r /$STARTVERZEICHNIS/opensim1
		mv /$STARTVERZEICHNIS/opensim /$STARTVERZEICHNIS/opensim1

		echo "$OPENSIMDOWNLOAD$OPENSIMVERSION"
        wget $OPENSIMDOWNLOAD$OPENSIMVERSION.zip
		echo "$OPENSIMVERSION"
		unzip $OPENSIMVERSION
		mv /$STARTVERZEICHNIS/$OPENSIMVERSION /$STARTVERZEICHNIS/opensim

		echo "$DATUM $(date +%H:%M:%S) OPENSIMHOLEN: Download" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	else
		echo "$(tput setaf $COLOR1) $(tput setaf $BCOLOR7)Kopieren des OpenSimulator in das Arbeitsverzeichnis$(tput sgr $OMCOFF)"

		echo "$OPENSIMDOWNLOAD$OPENSIMVERSION"
        wget $OPENSIMDOWNLOAD$OPENSIMVERSION.zip
		echo "$OPENSIMVERSION"
		unzip $OPENSIMVERSION
		mv /$STARTVERZEICHNIS/$OPENSIMVERSION /$STARTVERZEICHNIS/opensim

		echo "$DATUM $(date +%H:%M:%S) OPENSIMHOLEN: Download" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	fi
	return 0
}

### Funktion regionbackup, backup einer Region.
# regionbackup Screenname "Der Regionsname"
function regionbackup()
{
	# Backup Verzeichnis anlegen.
	mkdir -p /$STARTVERZEICHNIS/backup/
	sleep 2
	VERZEICHNISSCREENNAME=$1
	REGIONSNAME=$2	
	DATEINAME=${REGIONSNAME//\"/}
	NSDATEINAME=${DATEINAME// /}

	echo "$(tput setaf $COLOR4) $(tput setaf $BCOLOR7)Region $NSDATEINAME speichern$(tput sgr $OMCOFF)"
	echo "$DATUM $(date +%H:%M:%S) OSBACKUP: Region $NSDATEINAME speichern" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	cd /$STARTVERZEICHNIS/"$VERZEICHNISSCREENNAME"/bin || return 1
	# Ich kann nicht pruefen ob die Region im OpenSimulator vorhanden ist.
	# Sollte sie nicht vorhanden sein wird root also alle Regionen gespeichert.
	screen -S "$VERZEICHNISSCREENNAME" -p 0 -X eval "stuff 'change region ${REGIONSNAME//\"/}'^M"
	screen -S "$VERZEICHNISSCREENNAME" -p 0 -X eval "stuff 'save oar /$STARTVERZEICHNIS/backup/'$DATUM'-$NSDATEINAME.oar'^M"
	screen -S "$VERZEICHNISSCREENNAME" -p 0 -X eval "stuff 'terrain save /$STARTVERZEICHNIS/backup/'$DATUM'-$NSDATEINAME.png'^M"
	screen -S "$VERZEICHNISSCREENNAME" -p 0 -X eval "stuff 'terrain save /$STARTVERZEICHNIS/backup/'$DATUM'-$NSDATEINAME.raw'^M"
	echo "$DATUM $(date +%H:%M:%S) OSBACKUP: Region $DATUM-$NSDATEINAME RAW und PNG Terrain gespeichert" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	echo " "
	sleep 10
	if [ ! -f /$STARTVERZEICHNIS/"$VERZEICHNISSCREENNAME"/bin/Regions/"$NSDATEINAME".ini ]; then
		cp -r /$STARTVERZEICHNIS/"$VERZEICHNISSCREENNAME"/bin/Regions/Regions.ini /$STARTVERZEICHNIS/backup/"$DATUM"-"$NSDATEINAME".ini
		echo "$(tput setaf $COLOR2)Regions.ini wurde als $DATUM-$NSDATEINAME.ini gespeichert."
		echo "$DATUM $(date +%H:%M:%S) OSBACKUP: Region $DATUM-$NSDATEINAME.ini gespeichert" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	fi
	if [ ! -f /$STARTVERZEICHNIS/"$VERZEICHNISSCREENNAME"/bin/Regions/"${REGIONSNAME//\"/}".ini ]; then
		cp -r /$STARTVERZEICHNIS/"$VERZEICHNISSCREENNAME"/bin/Regions/Regions.ini /$STARTVERZEICHNIS/backup/"$DATUM"-"$NSDATEINAME".ini
		echo "$(tput setaf $COLOR2)Regions.ini wurde als $DATUM-$NSDATEINAME.ini gespeichert."
		echo "$DATUM $(date +%H:%M:%S) OSBACKUP: Region $DATUM-$NSDATEINAME.ini gespeichert" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	fi
	if [ ! -f /$STARTVERZEICHNIS/"$VERZEICHNISSCREENNAME"/bin/Regions/Regions.ini ]; then
		cp -r /$STARTVERZEICHNIS/"$VERZEICHNISSCREENNAME"/bin/Regions/"$NSDATEINAME".ini /$STARTVERZEICHNIS/backup/"$DATUM"-"$NSDATEINAME".ini
		echo "$DATUM $(date +%H:%M:%S) OSBACKUP: Region $NSDATEINAME.ini gespeichert" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	fi
	return 0
}

### Funktion menuregionbackup() ist die dialog Version von regionbackup()
function menuregionbackup()
{
    # zuerst schauen ob dialog installiert ist
    if dpkg-query -s dialog 2>/dev/null|grep -q installed; then

    # Einstellungen
    boxbacktitel="opensimMULTITOOL"
    boxtitel="opensimMULTITOOL Eingabe"
    formtitle="Backup einer Region"
    lable1="Screenname:"; lablename1=""
    lable2="Regionsname:"; lablename2=""

    # Abfrage
    regionbackupBOXERGEBNIS=$( dialog --backtitle "$boxbacktitel" --title "$boxtitel" --form "$formtitle" 25 60 16 "$lable1" 1 1 "$lablename1" 1 25 25 30 "$lable2" 2 1 "$lablename2" 2 25 25 30 3>&1 1>&2 2>&3 3>&- )

    # Zeilen aus einer Variablen zerlegen und in verschiedenen Variablen schreiben.
    VERZEICHNISSCREENNAME=$(echo "$regionbackupBOXERGEBNIS" | sed -n '1p')
    REGIONSNAME=$(echo "$regionbackupBOXERGEBNIS" | sed -n '2p')

    # Alles löschen.
    dialog --clear
    clear
	else
		# Alle Aktionen ohne dialog
		echo "Keine Menülose Funktion"|exit
	fi	# dialog Aktionen Ende

	# Backup Verzeichnis anlegen.
	mkdir -p /$STARTVERZEICHNIS/backup/
	sleep 2
	DATEINAME=${REGIONSNAME//\"/}
	NSDATEINAME=${DATEINAME// /}

	echo "$(tput setaf $COLOR4) $(tput setaf $BCOLOR7)Region $NSDATEINAME speichern$(tput sgr $OMCOFF)"
	echo "$DATUM $(date +%H:%M:%S) OSBACKUP: Region $NSDATEINAME speichern" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	cd /$STARTVERZEICHNIS/"$VERZEICHNISSCREENNAME"/bin || return 1
	# Ich kann nicht pruefen ob die Region im OpenSimulator vorhanden ist.
	# Sollte sie nicht vorhanden sein wird root also alle Regionen gespeichert.
	screen -S "$VERZEICHNISSCREENNAME" -p 0 -X eval "stuff 'change region ${REGIONSNAME//\"/}'^M"
	screen -S "$VERZEICHNISSCREENNAME" -p 0 -X eval "stuff 'save oar /$STARTVERZEICHNIS/backup/'$DATUM'-$NSDATEINAME.oar'^M"
	screen -S "$VERZEICHNISSCREENNAME" -p 0 -X eval "stuff 'terrain save /$STARTVERZEICHNIS/backup/'$DATUM'-$NSDATEINAME.png'^M"
	screen -S "$VERZEICHNISSCREENNAME" -p 0 -X eval "stuff 'terrain save /$STARTVERZEICHNIS/backup/'$DATUM'-$NSDATEINAME.raw'^M"
	echo "$DATUM $(date +%H:%M:%S) OSBACKUP: Region $DATUM-$NSDATEINAME RAW und PNG Terrain gespeichert" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	echo " "
	sleep 10
	if [ ! -f /$STARTVERZEICHNIS/"$VERZEICHNISSCREENNAME"/bin/Regions/"$NSDATEINAME".ini ]; then
		cp -r /$STARTVERZEICHNIS/"$VERZEICHNISSCREENNAME"/bin/Regions/Regions.ini /$STARTVERZEICHNIS/backup/"$DATUM"-"$NSDATEINAME".ini
		echo "$(tput setaf $COLOR2)Regions.ini wurde als $DATUM-$NSDATEINAME.ini gespeichert."
		echo "$DATUM $(date +%H:%M:%S) OSBACKUP: Region $DATUM-$NSDATEINAME.ini gespeichert" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	fi
	if [ ! -f /$STARTVERZEICHNIS/"$VERZEICHNISSCREENNAME"/bin/Regions/"${REGIONSNAME//\"/}".ini ]; then
		cp -r /$STARTVERZEICHNIS/"$VERZEICHNISSCREENNAME"/bin/Regions/Regions.ini /$STARTVERZEICHNIS/backup/"$DATUM"-"$NSDATEINAME".ini
		echo "$(tput setaf $COLOR2)Regions.ini wurde als $DATUM-$NSDATEINAME.ini gespeichert."
		echo "$DATUM $(date +%H:%M:%S) OSBACKUP: Region $DATUM-$NSDATEINAME.ini gespeichert" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	fi
	if [ ! -f /$STARTVERZEICHNIS/"$VERZEICHNISSCREENNAME"/bin/Regions/Regions.ini ]; then
		cp -r /$STARTVERZEICHNIS/"$VERZEICHNISSCREENNAME"/bin/Regions/"$NSDATEINAME".ini /$STARTVERZEICHNIS/backup/"$DATUM"-"$NSDATEINAME".ini
		echo "$DATUM $(date +%H:%M:%S) OSBACKUP: Region $NSDATEINAME.ini gespeichert" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	fi
	return 0
}

### Funktion regionrestore, hochladen einer Region.
# regionrestore Screenname "Der Regionsname"
# Ich kann nicht pruefen ob die Region im OpenSimulator vorhanden ist.
# Sollte sie nicht vorhanden sein wird root (Alle) oder die letzte ausgewählte Region wiederhergestellt. Dies zerstört eventuell vorhandene Regionen.
function regionrestore()
{
	VERZEICHNISSCREENNAME=$1
	REGIONSNAME=$2	
	DATEINAME=${REGIONSNAME//\"/}
	NSDATEINAME=${DATEINAME// /}

	echo "$(tput setaf $COLOR4) $(tput setaf $BCOLOR7)Region $NSDATEINAME wiederherstellen$(tput sgr $OMCOFF)"
	echo "$DATUM $(date +%H:%M:%S) OSRESTORE: Region $NSDATEINAME wiederherstellen" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	cd /$STARTVERZEICHNIS/"$VERZEICHNISSCREENNAME"/bin || return 1
	# Ich kann nicht pruefen ob die Region im OpenSimulator vorhanden ist.
	# Sollte sie nicht vorhanden sein wird root also alle Regionen wiederhergestellt.
	screen -S "$VERZEICHNISSCREENNAME" -p 0 -X eval "stuff 'change region ${REGIONSNAME//\"/}'^M"
	screen -S "$VERZEICHNISSCREENNAME" -p 0 -X eval "stuff 'load oar /$STARTVERZEICHNIS/backup/'$DATUM'-$NSDATEINAME.oar'^M"

	echo "$DATUM $(date +%H:%M:%S) OSRESTORE: Region $DATUM-$NSDATEINAME wiederhergestellt" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	echo " "
	return 0
}

### Funktion menuregionrestore() ist die dialog Version von regionrestore()
function menuregionrestore()
{
    # zuerst schauen ob dialog installiert ist
    if dpkg-query -s dialog 2>/dev/null|grep -q installed; then

    # Einstellungen
    boxbacktitel="opensimMULTITOOL"
    boxtitel="opensimMULTITOOL Eingabe"
    formtitle="Backup einer Region"
    lable1="Screenname:"; lablename1=""
    lable2="Regionsname:"; lablename2=""

    # Abfrage
    regionrestoreBOXERGEBNIS=$( dialog --backtitle "$boxbacktitel" --title "$boxtitel" --form "$formtitle" 25 60 16 "$lable1" 1 1 "$lablename1" 1 25 25 30 "$lable2" 2 1 "$lablename2" 2 25 25 30 3>&1 1>&2 2>&3 3>&- )

    # Zeilen aus einer Variablen zerlegen und in verschiedenen Variablen schreiben.
    VERZEICHNISSCREENNAME=$(echo "$regionrestoreBOXERGEBNIS" | sed -n '1p')
    REGIONSNAME=$(echo "$regionrestoreBOXERGEBNIS" | sed -n '2p')

    # Alles löschen.
    dialog --clear
    clear
	else
		# Alle Aktionen ohne dialog
		echo "Keine Menülose Funktion"|exit
	fi	# dialog Aktionen Ende

	DATEINAME=${REGIONSNAME//\"/}
	NSDATEINAME=${DATEINAME// /}

	echo "$(tput setaf $COLOR4) $(tput setaf $BCOLOR7)Region $NSDATEINAME wiederherstellen$(tput sgr $OMCOFF)"
	echo "$DATUM $(date +%H:%M:%S) OSRESTORE: Region $NSDATEINAME wiederherstellen" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	cd /$STARTVERZEICHNIS/"$VERZEICHNISSCREENNAME"/bin || return 1
	# Ich kann nicht pruefen ob die Region im OpenSimulator vorhanden ist.
	# Sollte sie nicht vorhanden sein wird root also alle Regionen wiederhergestellt.
	screen -S "$VERZEICHNISSCREENNAME" -p 0 -X eval "stuff 'change region ${REGIONSNAME//\"/}'^M"
	screen -S "$VERZEICHNISSCREENNAME" -p 0 -X eval "stuff 'load oar /$STARTVERZEICHNIS/backup/'$DATUM'-$NSDATEINAME.oar'^M"

	echo "$DATUM $(date +%H:%M:%S) OSRESTORE: Region $DATUM-$NSDATEINAME wiederhergestellt" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	echo " "
	return 0
}

### Funktion autosimstart, automatischer sim start ohne Robust und Money.
function autosimstart()
{
	if ! screen -list | grep -q 'sim'; 
	then
	# es laeuft kein Simulator - not work
		makeverzeichnisliste
		sleep 2
		for (( i = 0 ; i < "$ANZAHLVERZEICHNISSLISTE" ; i++)) do
			echo "$(tput setaf $COLOR2) $(tput setab $BCOLOR7)Regionen OpenSimulator ${VERZEICHNISSLISTE[$i]} Starten$(tput sgr $OMCOFF)"
			cd /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin || return 1
			
			# AOT Aktiveren oder Deaktivieren.
			if [[ $SETAOTON = "yes" ]]
			then		
				screen -fa -S "${VERZEICHNISSLISTE[$i]}" -d -U -m mono --desktop -O=all OpenSim.exe
			else
				
				screen -fa -S "${VERZEICHNISSLISTE[$i]}" -d -U -m mono OpenSim.exe
			fi

			echo "$DATUM $(date +%H:%M:%S) AUTOSIMSTART: Regionen OpenSimulator ${VERZEICHNISSLISTE[$i]} Starten" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
			sleep $STARTWARTEZEIT
		done
	else
	# es laeuft mindestens ein Simulator - work
		echo "$(tput setaf $COLOR7)$(tput setab $BCOLOR2) Regionen laufen bereits! $(tput sgr $OMCOFF)"
		echo "$DATUM $(date +%H:%M:%S) WORKS:  Regionen laufen bereits!" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	fi
	return 0
}

### Funktion autosimstop, stoppen aller laufenden Simulatoren.
function autosimstop()
{
	makeverzeichnisliste
	sleep 2
	for (( i = 0 ; i < "$ANZAHLVERZEICHNISSLISTE" ; i++)) do
		if screen -list | grep -q "${VERZEICHNISSLISTE[$i]}"; then
			echo "$(tput setaf $COLOR1) $(tput setab $BCOLOR7)Regionen OpenSimulator ${VERZEICHNISSLISTE[$i]} Beenden$(tput sgr $OMCOFF)"
			screen -S "${VERZEICHNISSLISTE[$i]}" -p 0 -X eval "stuff 'shutdown'^M"
			echo "$DATUM $(date +%H:%M:%S) AUTOSIMSTOP: Regionen OpenSimulator ${VERZEICHNISSLISTE[$i]} Beenden" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
			sleep $STOPWARTEZEIT
		else
			echo "$(tput setaf $COLOR1)$(tput setab $BCOLOR7)${VERZEICHNISSLISTE[$i]} läuft nicht $(tput sgr $OMCOFF)"
		fi
	done
	return 0
}
### Funktion autosimstart, automatischer sim start ohne Robust und Money.
function menuautosimstart()
{
	if ! screen -list | grep -q 'sim'; 
	then
	# es laeuft kein Simulator - not work
		makeverzeichnisliste
		sleep 2
		for (( i = 0 ; i < "$ANZAHLVERZEICHNISSLISTE" ; i++)) do
			echo "$(tput setaf $COLOR2) $(tput setab $BCOLOR7)Regionen OpenSimulator ${VERZEICHNISSLISTE[$i]} Starten$(tput sgr $OMCOFF)"
			cd /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin || return 1
			
			# AOT Aktiveren oder Deaktivieren.
			if [[ $SETAOTON = "yes" ]]
			then
				BERECHNUNG1=$((100/"$ANZAHLVERZEICHNISSLISTE"))
				BALKEN1=$(("$i"*"$BERECHNUNG1"))
				screen -fa -S "${VERZEICHNISSLISTE[$i]}" -d -U -m mono --desktop -O=all OpenSim.exe | dialog --gauge "Auto Sim start..." 6 64 $BALKEN1; dialog --clear
			else
				BERECHNUNG1=$((100/"$ANZAHLVERZEICHNISSLISTE"))
				BALKEN1=$(("$i"*"$BERECHNUNG1"))
				screen -fa -S "${VERZEICHNISSLISTE[$i]}" -d -U -m mono OpenSim.exe | dialog --gauge "Auto Sim start..." 6 64 $BALKEN1; dialog --clear

			fi

			echo "$DATUM $(date +%H:%M:%S) AUTOSIMSTART: Regionen OpenSimulator ${VERZEICHNISSLISTE[$i]} Starten" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
			sleep $STARTWARTEZEIT
		done
	else
	# es laeuft mindestens ein Simulator - work
		echo "$(tput setaf $COLOR7)$(tput setab $BCOLOR2) Regionen laufen bereits! $(tput sgr $OMCOFF)"
		echo "$DATUM $(date +%H:%M:%S) WORKS:  Regionen laufen bereits!" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	fi
	#return 0
}

### Funktion autosimstop, stoppen aller laufenden Simulatoren.
function menuautosimstop()
{
	makeverzeichnisliste
	sleep 2
	for (( i = 0 ; i < "$ANZAHLVERZEICHNISSLISTE" ; i++)) do
		if screen -list | grep -q "${VERZEICHNISSLISTE[$i]}"; then
			echo "$(tput setaf $COLOR1) $(tput setab $BCOLOR7)Regionen OpenSimulator ${VERZEICHNISSLISTE[$i]} Beenden$(tput sgr $OMCOFF)"

			#BALKEN2=$(("$i"*5))
			#TMP2=$(("$ANZAHLVERZEICHNISSLISTE"*"$i"))
			#BALKEN2=$(("$TMP2/100"))
			BERECHNUNG2=$((100/"$ANZAHLVERZEICHNISSLISTE"))
			BALKEN2=$(("$i"*"$BERECHNUNG2"))
			#BALKEN2=$(( (100/"$ANZAHLVERZEICHNISSLISTE") * "${VERZEICHNISSLISTE[$i]}"))
			

			screen -S "${VERZEICHNISSLISTE[$i]}" -p 0 -X eval "stuff 'shutdown'^M" | dialog --gauge "Alle Simulatoren werden gestoppt!" 6 64 $BALKEN2; dialog --clear

			echo "$DATUM $(date +%H:%M:%S) AUTOSIMSTOP: Regionen OpenSimulator ${VERZEICHNISSLISTE[$i]} Beenden" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
			sleep $STOPWARTEZEIT
		else
			#echo "$(tput setaf $COLOR1)$(tput setab $BCOLOR7)${VERZEICHNISSLISTE[$i]} läuft nicht $(tput sgr $OMCOFF)"
			echo ""
		fi
	done
	return 0
}

### Funktion autologdel, automatisches loeschen aller log Dateien.
# Die Dateien samt neuer Daten werden beim naechsten start des opensimulator neu geschrieben.
function autologdel()
{
	echo "$(tput setaf $BCOLOR1) $(tput setab $BCOLOR7)Log Dateien löschen! $(tput sgr $OMCOFF)"
	makeverzeichnisliste
	sleep 2
	for (( i = 0 ; i < "$ANZAHLVERZEICHNISSLISTE" ; i++)) do
		echo "$(tput setaf $COLOR1) $(tput setab $BCOLOR7)OpenSimulator log ${VERZEICHNISSLISTE[$i]} geloescht$(tput sgr $OMCOFF)"
		rm /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/*.log || echo " "
		echo "$DATUM $(date +%H:%M:%S) AUTOLOGDEL: OpenSimulator log ${VERZEICHNISSLISTE[$i]} geloescht" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		sleep 2
	done

	# schauen ist Robust und Money da dann diese Logs auch löschen!
	if [[ ! $ROBUSTVERZEICHNIS == "robust" ]]
	then
		echo "$(tput setaf $BCOLOR1) $(tput setab $BCOLOR7)autologdel: Robust Log Dateien löschen! $(tput sgr $OMCOFF)"
		rm /$STARTVERZEICHNIS/robust/bin/*.log || echo " autologdel: Ich kann die Robust Log Dateien nicht löschen! "
	fi
	# if [[ ! $MONEYVERZEICHNIS == "money" ]]
	# then 
	# 	rm /$STARTVERZEICHNIS/money/bin/*.log || echo " "
	# fi

	return 0
}
function menuautologdel()
{
	echo "$(tput setaf $BCOLOR1) $(tput setab $BCOLOR7)Log Dateien löschen! $(tput sgr $OMCOFF)"
	makeverzeichnisliste
	sleep 2
	for (( i = 0 ; i < "$ANZAHLVERZEICHNISSLISTE" ; i++)) do
		echo "$(tput setaf $COLOR1) $(tput setab $BCOLOR7)OpenSimulator log ${VERZEICHNISSLISTE[$i]} geloescht$(tput sgr $OMCOFF)"

		BERECHNUNG3=$((100/"$ANZAHLVERZEICHNISSLISTE"))
		BALKEN3=$(("$i"*"$BERECHNUNG3"))

		rm /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/*.log | dialog --gauge "Auto Sim stop..." 6 64 $BALKEN3; dialog --clear  || echo " "
		echo "$DATUM $(date +%H:%M:%S) AUTOLOGDEL: OpenSimulator log ${VERZEICHNISSLISTE[$i]} geloescht" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		sleep 2
	done

	# schauen ist Robust und Money da dann diese Logs auch löschen!
	if [[ ! $ROBUSTVERZEICHNIS == "robust" ]]
	then
		echo "$(tput setaf $BCOLOR1) $(tput setab $BCOLOR7) menuautologdel: Robust Log Dateien löschen! $(tput sgr $OMCOFF)"
		rm /$STARTVERZEICHNIS/robust/bin/*.log || echo " menuautologdel: Ich kann die Robust Log Dateien nicht löschen! "
	fi
	# if [[ ! $MONEYVERZEICHNIS == "money" ]]
	# then 
	# 	rm /$STARTVERZEICHNIS/money/bin/*.log || echo " "
	# fi

	#return 0
}

### Funktion automapdel, automatisches loeschen aller Map/Karten Dateien.
# Die Dateien samt neuer Daten werden beim naechsten start des opensimulator neu geschrieben.
function automapdel()
{
	makeverzeichnisliste
	sleep 2
	for (( i = 0 ; i < "$ANZAHLVERZEICHNISSLISTE" ; i++)) do
		echo "$(tput setaf $COLOR1) $(tput setab $BCOLOR7)OpenSimulator maptile ${VERZEICHNISSLISTE[$i]} geloescht$(tput sgr $OMCOFF)"
		cd /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin || return 1
		rm -r maptiles/* || echo " "
		echo "$DATUM $(date +%H:%M:%S) AUTOMAPDEL: OpenSimulator maptile ${VERZEICHNISSLISTE[$i]} geloescht" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		sleep 2
	done
	autorobustmapdel
	return 0
}

### Funktion autorobustmapdel, automatisches loeschen aller Map/Karten Dateien in Robust.
# Die Dateien samt neuer Daten werden beim naechsten start des opensimulator neu geschrieben.
function autorobustmapdel()
{
	echo "$(tput setaf $COLOR1) $(tput setab $BCOLOR7)OpenSimulator maptile aus $ROBUSTVERZEICHNIS geloescht$(tput sgr $OMCOFF)"
	cd /$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS/bin || return 1
	rm -r maptiles/* || echo " "
	echo "$DATUM $(date +%H:%M:%S) AUTOMAPDEL: OpenSimulator maptile aus $ROBUSTVERZEICHNIS geloescht" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	return 0
}

### Funktion cleaninstall, loeschen aller externen addon Module.
function cleaninstall()
{

	if [ ! -f "/$STARTVERZEICHNIS/opensim/addon-modules/" ]; then
		rm -r $STARTVERZEICHNIS/opensim/addon-modules/*
	else
		echo "addon-modules Verzeichnis existiert nicht."
		echo "$DATUM $(date +%H:%M:%S) cleaninstall: addon-modules Verzeichnis existiert nicht" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	fi
	return 0
}

### Funktion allclean, loescht Log, dll, so, exe, aot Dateien fuer einen saubere neue installation, ohne Robust.
# Hierbei werden keine Datenbanken oder Konfigurationen geloescht aber opensim ist anschliessend nicht mehr startbereit.
# Um opensim wieder Funktionsbereit zu machen muss ein Upgrade oder ein oscopy vorgang ausgeführt werden.
# allclean Verzeichnis
function allclean()
{
	if [ -d "$1" ]; then
		echo "$(tput setaf $COLOR1) $(tput setab $BCOLOR7)OpenSimulator log $1 geloescht$(tput sgr $OMCOFF)"
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
		echo "$DATUM $(date +%H:%M:%S) clean: OpenSimulator Dateien in $1 geloescht" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	else
		echo "$(tput setaf $COLOR1)Dateien in $1 nicht gefunden $(tput sgr $OMCOFF)"
		echo "$DATUM $(date +%H:%M:%S) clean: Dateien in $1 nicht gefunden" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	fi
	return 0
}

### Funktion autoallclean, loescht Log, dll, so, exe, aot Dateien fuer einen saubere neue installation, mit Robust.
# Hierbei werden keine Datenbanken oder Konfigurationen geloescht.
# Hierbei werden keine Datenbanken oder Konfigurationen geloescht aber opensim ist anschliessend nicht mehr startbereit.
# Um opensim wieder Funktionsbereit zu machen muss ein Upgrade oder ein oscopy vorgang ausgeführt werden.
function autoallclean()
{
	makeverzeichnisliste
	sleep 2
	for (( i = 0 ; i < "$ANZAHLVERZEICHNISSLISTE" ; i++)) do
		echo "$(tput setaf $COLOR1) $(tput setab $BCOLOR7)OpenSimulator alles ${VERZEICHNISSLISTE[$i]} geloescht$(tput sgr $OMCOFF)"
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
		echo "$DATUM $(date +%H:%M:%S) autoallclean: OpenSimulator alles ${VERZEICHNISSLISTE[$i]} geloescht" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		sleep 2
	done
	# nochmal das gleiche mit Robust
	echo "$(tput setaf $COLOR1) $(tput setab $BCOLOR7)OpenSimulator alles in $ROBUSTVERZEICHNIS geloescht$(tput sgr $OMCOFF)"
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
	echo "$DATUM $(date +%H:%M:%S) autoallclean: OpenSimulator alles in $ROBUSTVERZEICHNIS geloescht" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	return 0
}

### Funktion autoregionbackup, automatischer Backup aller Regionen die in der Regionsliste eingetragen sind.
function autoregionbackup()
{
	echo "$(tput setaf $COLOR1) $(tput setab $BCOLOR7)Automatisches Backup wird gestartet. $(tput sgr $OMCOFF)"
	makeregionsliste
	echo "$DATUM $(date +%H:%M:%S) OSBACKUP: Automatisches Backup wird gestartet" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	sleep 2
	for (( i = 0 ; i < "$ANZAHLREGIONSLISTE" ; i++)) do
		derscreen=$(echo "${REGIONSLISTE[$i]}" | cut -d ' ' -f 1)
		dieregion=$(echo "${REGIONSLISTE[$i]}" | cut -d ' ' -f 2)
		regionbackup "$derscreen" "$dieregion"
		sleep $BACKUPWARTEZEIT
	done
	return 0
}

### Funktion autoscreenstop, beendet alle laufenden simX screens.
function autoscreenstop()
{
	makeverzeichnisliste
	sleep 2

	# shellcheck disable=SC2022
	if ! screen -list | grep -q 'sim'; then
	echo "$(tput setaf $COLOR7)$(tput setab $BCOLOR1) SIMs OFFLINE! $(tput sgr $OMCOFF)"
	echo "$DATUM $(date +%H:%M:%S) WORKS: SIMs OFFLINE!" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	else
		for (( i = 0 ; i < "$ANZAHLVERZEICHNISSLISTE" ; i++)) do
			screen -S "${VERZEICHNISSLISTE[$i]}" -X quit
		done
	fi

	if ! screen -list | grep -q "MO"; then
	echo "$(tput setaf $COLOR7)$(tput setab $BCOLOR1) MONEY OFFLINE! $(tput sgr $OMCOFF)"
	echo "$DATUM $(date +%H:%M:%S) WORKS: MONEY OFFLINE!" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	else	
	screen -S MO -X quit
	fi

	if ! screen -list | grep -q "RO"; then
	echo " "
	#echo "$(tput setaf $COLOR7)$(tput setab $BCOLOR1) Nachsehen ob ROBUST heruntergefahren wurde $(tput sgr $OMCOFF)"
	echo "$(tput setaf $COLOR7)$(tput setab $BCOLOR1) ROBUST OFFLINE! $(tput sgr $OMCOFF)"
	echo "$DATUM $(date +%H:%M:%S) WORKS: ROBUST OFFLINE!" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	else
	echo "$(tput setaf $COLOR7)$(tput setab $BCOLOR1) ROBUST Killen! $(tput sgr $OMCOFF)"
	screen -S RO -X quit
	fi
	return 0
}
function menuautoscreenstop()
{
	makeverzeichnisliste
	sleep 2

	# shellcheck disable=SC2022
	if ! screen -list | grep -q 'sim'; then
	echo "$DATUM $(date +%H:%M:%S) WORKS: SIMs OFFLINE!" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	else
		for (( i = 0 ; i < "$ANZAHLVERZEICHNISSLISTE" ; i++)) do
			screen -S "${VERZEICHNISSLISTE[$i]}" -X quit
		done
	fi

	if ! screen -list | grep -q "MO"; then
	echo "$DATUM $(date +%H:%M:%S) WORKS: MONEY OFFLINE!" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	else	
	screen -S MO -X quit
	fi

	if ! screen -list | grep -q "RO"; then
	echo "$DATUM $(date +%H:%M:%S) WORKS: ROBUST OFFLINE!" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	else
	screen -S RO -X quit
	fi
	return 0
}

### Funktion autostart, startet das komplette Grid mit allen sims.
function autostart()
{
	echo "$(tput setab $BCOLOR2)Starte das Grid! $(tput sgr $OMCOFF)"
	if [[ $ROBUSTVERZEICHNIS == "robust" ]]
	then
		gridstart
	fi
	autosimstart
	echo " "
	screenlist
	echo " "
	echo "$DATUM $(date +%H:%M:%S) AUTOSTART: Auto Start abgeschlossen" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	return 0
}

### Funktion autostop, stoppt das komplette Grid mit allen sims.
function autostop()
{
	echo "$(tput setaf $BCOLOR1) $(tput setab $BCOLOR7) ### Stoppe alles! ### $(tput sgr $OMCOFF)"
	# schauen ob screens laufen wenn ja beenden.
	# shellcheck disable=SC2022
	if ! screen -list | grep -q 'sim'; then
		echo "$(tput setaf $COLOR7)$(tput setab $BCOLOR1) SIMs OFFLINE! $(tput sgr $OMCOFF)"
	else
		autosimstop
	fi
	# if ! screen -list | grep -q "MO"; then
	# 	echo "$(tput setaf $COLOR7)$(tput setab $BCOLOR1) MONEY OFFLINE! $(tput sgr $OMCOFF)"
	# else
	# 	gridstop
	# fi
	if ! screen -list | grep -q "RO"; then
		#echo "$(tput setaf $COLOR7)$(tput setab $BCOLOR1) ROBUST OFFLINE! $(tput sgr $OMCOFF)"
		echo " "
	else
		gridstop
	fi
	# schauen ob screens laufen wenn ja warten.
	# shellcheck disable=SC2022
	if ! screen -list | grep -q 'sim'; then
		echo " "
	else
		sleep $AUTOSTOPZEIT
	fi
	echo "$(tput setaf $BCOLOR1)$(tput setab $BCOLOR7)Beende alle noch offenen Screens! $(tput sgr $OMCOFF)"
	autoscreenstop
	return 0
}

### Funktion autostart, startet das komplette Grid mit allen sims.
function menuautostart()
{
	echo ""
	if [[ $ROBUSTVERZEICHNIS == "robust" ]]
	then 
		menugridstart
	fi
	menuautosimstart
	screenlist
	echo "$DATUM $(date +%H:%M:%S) AUTOSTART: Auto Start abgeschlossen" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	#return 0
}

### Funktion autostop, stoppt das komplette Grid mit allen sims.
function menuautostop()
{
	# schauen ob screens laufen wenn ja beenden.
	# shellcheck disable=SC2022
	if ! screen -list | grep -q 'sim'; then
		echo ""
	else
		menuautosimstop
	fi

	if ! screen -list | grep -q "RO"; then
		echo ""
	else
		menugridstop
	fi
	# schauen ob screens laufen wenn ja warten.
	# shellcheck disable=SC2022
	if ! screen -list | grep -q 'sim'; then
		echo ""
	else
		sleep $AUTOSTOPZEIT
		killall screen
	fi
	#echo "$(tput setaf $BCOLOR1)$(tput setab $BCOLOR7)Beende alle noch offenen Screens! $(tput sgr $OMCOFF)"
	menuautoscreenstop
	#return 0
	#hauptmenu
}

### Funktion autorestart, startet das gesamte Grid neu und loescht die log Dateien.
function autorestart()
{
	echo " "
	autostop
	#if [[ $? == 1 ]] ; then echo "ERROR: autostop"; exit 1; fi
	echo " "

	autologdel
	rologdel
	#if [[ $? == 1 ]] ; then echo "ERROR: autologdel"; exit 1; fi
	echo " "

	gridstart
	#if [[ $? == 1 ]] ; then echo "ERROR: gridstart"; exit 1; fi
	autosimstart
	#if [[ $? == 1 ]] ; then echo "ERROR: autosimstart"; exit 1; fi
	echo " "

	screenlistrestart
	#if [[ $? == 1 ]] ; then echo "ERROR: screenlist"; exit 1; fi
	echo " "
	echo "$DATUM $(date +%H:%M:%S) AUTORESTART: Auto Restart abgeschlossen" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	
	return 0
}
function menuautorestart()
{
	# HOEHE=8; BREITE=40
	# # Alles Stoppen
	# DIALOG=dialog
	# 		(echo "5" ; menuautostop ; sleep 3
	# 		echo "25" ; sleep 2) |
	# 		$DIALOG --title "Stopp" --gauge "Grid und Simulatoren herunterfahren!" $HOEHE $BREITE
	# 		$DIALOG --clear
	# 		clear
	# # Alle Log Dateien löschen
	# DIALOG=dialog
	# 		(echo "25" ; menuautologdel ; sleep 3
	# 		echo "50" ; sleep 2) |
	# 		$DIALOG --title "log löschen" --gauge "Log Dateien löschen!" $HOEHE $BREITE
	# 		$DIALOG --clear
	# 		clear
	# # Das Grid also Robust und Money starten
	# DIALOG=dialog
	# 		(echo "50" ; menugridstart ; sleep 3
	# 		echo "75" ; sleep 2) |
	# 		$DIALOG --title "Grid start" --gauge "Grid Start!" $HOEHE $BREITE
	# 		$DIALOG --clear
	# 		clear
	# # Alle Simulatoren starten
	# DIALOG=dialog
	# 		(echo "75" ; menuautosimstart ; sleep 3
	# 		echo "100" ; sleep 2) |
	# 		$DIALOG --title "Sim start" --gauge "Starte alle Simulatoren!" $HOEHE $BREITE
	# 		$DIALOG --clear
	# 		clear

	menuautostop
	menuautologdel
	rologdel
	menugridstart
	menuautosimstart

	#screenlistrestart
	menuinfo
	echo "$DATUM $(date +%H:%M:%S) AUTORESTART: Auto Restart abgeschlossen" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	
	#return 0
	#hauptmenu
}

### Dieses Installationsbeispiel installiert alles für OpenSim inkusive Web, sowie alles um einen OpenSimulator zu Kompilieren.
### Funktion monoinstall, mono 6.x installieren.
function monoinstall() 
{
	if dpkg-query -s mono-complete 2>/dev/null|grep -q installed; then
		echo "$(tput setaf $COLOR2)mono-complete ist installiert.$(tput sgr0)"
	else
		echo "$(tput setaf $COLOR1)mono-complete ist nicht installiert.$(tput sgr0)"
		echo "$(tput setaf $COLOR2)Installation von mono 6.x fuer Ubuntu 18.$(tput sgr0)"
		
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

### Funktion serverinstall, Ubuntu 18 Server zum Betrieb von OpenSim vorbereiten.
function serverupgrade()
{    
    sudo apt-get update
    sudo apt-get upgrade
}

function monoinstall18()
{
	if dpkg-query -s mono-complete 2>/dev/null|grep -q installed; then
		echo "mono-complete $bereitsinstalliert"
	else
		echo "$installierejetzt mono-complete"
		sleep 2

		sudo apt install gnupg ca-certificates
		sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
		echo "deb https://download.mono-project.com/repo/ubuntu stable-bionic main" | sudo tee /etc/apt/sources.list.d/mono-official-stable.list

		sudo apt update
        sudo apt-get -y install mono-complete
		sudo apt-get upgrade
	fi
}

function monoinstall20()
{
	if dpkg-query -s mono-complete 2>/dev/null|grep -q installed; then
		echo "mono-complete $bereitsinstalliert"
	else
		echo "$installierejetzt mono-complete"
		sleep 2

		sudo apt install gnupg ca-certificates
        sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
        echo "deb https://download.mono-project.com/repo/ubuntu stable-focal main" | sudo tee /etc/apt/sources.list.d/mono-official-stable.list

        sudo apt update
        sudo apt-get -y install mono-complete
		sudo apt-get upgrade       
	fi
}

function installwordpress()
{
	#Installationen die für Wordpress benötigt werden
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

function installobensimulator() 
{
    #Alles für den OpenSimulator ausser mono
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
}

function installfinish()
{
	apt update
	apt upgrade
	apt -f install
	# zuerst schauen das nichts mehr läuft bevor man einfach rebootet
    #reboot now
}

### Auswahl der zu installierenden Pakete (Dies ist meinem Geschmack angepasst)
function serverinstall()
{
	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null|grep -q installed; then
		dialog --yesno "Möchten Sie wirklich alle nötigen Ubuntu Pakete installieren?" 0 0
		# 0=ja; 1=nein
		siantwort=$?
		# Dialog-Bildschirm löschen
		dialog --clear
		# Ausgabe auf die Konsole
		if [ $siantwort = 0 ]
		then
			serverupgrade
			installobensimulator
			monoinstall18
			installfinish
		fi
		if [ $siantwort = 1 ]
		then
			# Nein, dann zurück zum Hauptmenu.
			hauptmenu
		fi
		# Bildschirm löschen
		clear
	else
		# ohne dialog erstmal einfach installieren - Test
		read -r -p "Ubuntu Pakete installieren [y]es: " yesno
		if [ "$yesno" = "y" ]
		then
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

### Funktion installationen, Ubuntu 18 Server, Was habe ich alles auf meinem Server Installiert? sortiert auflisten.
function installationen() 
{
	echo "$(tput setaf $COLOR1)Liste aller Installierten Pakete unter Linux: $(tput sgr0)"
	dpkg-query -Wf '${Package;-40}${Priority}\n' | sort -b -k2,2 -k1,1
	dpkg-query -Wf '${Package;-40}${Priority}\n' | sort -b -k2,2 -k1,1  >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	return 0
}

### Funktion osbuilding, test automation.
# Beispiel: opensim-0.9.2.2Dev-1187-gcf0b1b1.zip
# /opt/opensim.sh osbuilding 1187
function osbuilding() 
{
	### dialog Aktionen
	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null|grep -q installed; then
		# Alle Aktionen mit dialog
		VERSIONSNUMMER=$( dialog --backtitle "opensimMULTITOOL $VERSION" --title "opensimMULTITOOL Eingabe" --inputbox "Versionsnummer:" 8 40 3>&1 1>&2 2>&3 3>&- )
		dialog --clear
		clear
	else
		# Alle Aktionen ohne dialog
		VERSIONSNUMMER=$1
	fi
	# dialog Aktionen Ende
	
    cd /$STARTVERZEICHNIS || exit

	echo "$(tput setaf $COLOR5)Alten OpenSimulator sichern$(tput sgr0)"
	echo "$DATUM $(date +%H:%M:%S) OSBUILDING: Alten OpenSimulator sichern" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
    osdelete

	echo " "

	# Neue Versionsnummer: opensim-0.9.2.2Dev-4-g5e9b3b4.zip

	echo "$(tput setaf $COLOR5)Neuen OpenSimulator entpacken$(tput sgr0)"
	echo "$DATUM $(date +%H:%M:%S) OSBUILDING: Neuen OpenSimulator entpacken" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
    unzip $OSVERSION"$VERSIONSNUMMER"-*.zip

	echo " "

	echo "$(tput setaf $COLOR5)Neuen OpenSimulator umbenennen$(tput sgr0)"
	echo "$DATUM $(date +%H:%M:%S) OSBUILDING: Neuen OpenSimulator umbenennen" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	mv /$STARTVERZEICHNIS/$OSVERSION"$VERSIONSNUMMER"-*/ /$STARTVERZEICHNIS/opensim/

	echo " "
	sleep 3

	echo "$(tput setaf $COLOR5)Prebuild des neuen OpenSimulator starten$(tput sgr0)"
	echo "$DATUM $(date +%H:%M:%S) OSBUILDING: Prebuild des neuen OpenSimulator starten" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
    osprebuild "$VERSIONSNUMMER"

	echo " "

	echo "$(tput setaf $COLOR5)Compilieren des neuen OpenSimulator$(tput sgr0)"
	echo "$DATUM $(date +%H:%M:%S) OSBUILDING: Compilieren des neuen OpenSimulator" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
    compilieren
    
    echo " " 
    osupgrade

	return 0
}

# create user [first] [last] [passw] [RegionX] [RegionY] [Email] - creates a new user and password 
function createuser()
{	
	VORNAME=$1; NACHNAME=$2; PASSWORT=$3; EMAIL=$4;

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

		#echo "Kontrollausgabe: $VORNAME $NACHNAME $PASSWORT $EMAIL"

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
		echo "CREATEUSER: Robust existiert nicht."
		echo "$DATUM $(date +%H:%M:%S) CREATEUSER: Robust existiert nicht" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	fi
	return 0
}

### Funktion menucreateuser() ist die dialog Version von createuser()
function menucreateuser()
{
    # zuerst schauen ob dialog installiert ist
    if dpkg-query -s dialog 2>/dev/null|grep -q installed; then

    # Einstellungen
    boxbacktitel="opensimMULTITOOL"
    boxtitel="opensimMULTITOOL Eingabe"
    formtitle="Benutzer Account anlegen"
    lable1="Vorname:"; lablename1="John"
    lable2="Nachname:"; lablename2="Doe"
    lable3="PASSWORT:"; lablename3="PASSWORT"
    lable4="EMAIL:"; lablename4="EMAIL"

    # Abfrage
    createuserBOXERGEBNIS=$( dialog --backtitle "$boxbacktitel" --title "$boxtitel" --form "$formtitle" 25 60 16 "$lable1" 1 1 "$lablename1" 1 25 25 30 "$lable2" 2 1 "$lablename2" 2 25 25 30 "$lable3" 3 1 "$lablename3" 3 25 25 30 "$lable4" 4 1 "$lablename4" 4 25 25 30 3>&1 1>&2 2>&3 3>&- )

    # Zeilen aus einer Variablen zerlegen und in verschiedenen Variablen schreiben.
    VORNAME=$(echo "$createuserBOXERGEBNIS" | sed -n '1p')
    NACHNAME=$(echo "$createuserBOXERGEBNIS" | sed -n '2p')
    PASSWORT=$(echo "$createuserBOXERGEBNIS" | sed -n '3p')
    EMAIL=$(echo "$createuserBOXERGEBNIS" | sed -n '4p')

    # Alles löschen.
    dialog --clear
    clear
	else
		# Alle Aktionen ohne dialog
        echo "Keine Menülose Funktion"|exit
	fi	# dialog Aktionen Ende

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

		#echo "Kontrollausgabe: $VORNAME $NACHNAME $PASSWORT $EMAIL"

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
		echo "CREATEUSER: Robust existiert nicht."
		echo "$DATUM $(date +%H:%M:%S) CREATEUSER: Robust existiert nicht" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	fi

    # Zum schluss alle Variablen löschen.
    unset VORNAME NACHNAME PASSWORT EMAIL

	hauptmenu
}

# Datenbank Befehle Achtung alles noch nicht ausgereift!!!

### function db_anzeigen, listt alle erstellten Datenbanken auf.
function db_anzeigen()
{
	DBBENUTZER=$1; DBPASSWORT=$2;

	echo "$(tput setaf $COLOR5)PRINT DATABASE: Alle Datenbanken anzeigen. $(tput sgr0)"
	echo "$DATUM $(date +%H:%M:%S) PRINT DATABASE: Alle Datenbanken anzeigen" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"

	# 2>/dev/null verhindert die Fehlerausgabe - mysql warning using a password on the command line interface can be insecure. disable.
	mysql -u"$DBBENUTZER" -p"$DBPASSWORT" -e "show databases" 2>/dev/null
	mysql -u"$DBBENUTZER" -p"$DBPASSWORT" -e "show databases" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log" 2>/dev/null

	# Eingabe Variablen löschen
	unset DBBENUTZER
	unset DBPASSWORT

	return 0
}

### function db_benutzer_anzeigen, alle angelegten Benutzer von mySQL anzeigen.
function db_benutzer_anzeigen()
{
	DBBENUTZER=$1; DBPASSWORT=$2;

	echo "$(tput setaf $COLOR5)PRINT DATABASE USER: Alle Datenbankbenutzer anzeigen. $(tput sgr0)"
	echo "$DATUM $(date +%H:%M:%S) PRINT DATABASE USER: Alle Datenbankbenutzer anzeigen" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"

	# 2>/dev/null verhindert die Fehlerausgabe - mysql warning using a password on the command line interface can be insecure. disable.
	mysql -u"$DBBENUTZER" -p"$DBPASSWORT" -e "SELECT User FROM mysql.user" 2>/dev/null
	mysql -u"$DBBENUTZER" -p"$DBPASSWORT" -e "SELECT User FROM mysql.user" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log" 2>/dev/null

	# Eingabe Variablen löschen
	unset DBBENUTZER
	unset DBPASSWORT

	return 0
}

### function create_db, erstellt eine neue Datenbank.
function create_db()
{
	DBBENUTZER=$1; DBPASSWORT=$2; DATENBANKNAME=$3;

	echo "$(tput setaf $COLOR5)CREATE DATABASE: Datenbanken anlegen. $(tput sgr0)"
	echo "$DATUM $(date +%H:%M:%S) CREATE DATABASE: Datenbanken anlegen" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	echo "$DBBENUTZER, ********, $DATENBANKNAME" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"

	# 2>/dev/null verhindert die Fehlerausgabe - mysql warning using a password on the command line interface can be insecure. disable.
	mysql -u"$DBBENUTZER" -p"$DBPASSWORT" -e "CREATE DATABASE IF NOT EXISTS $DATENBANKNAME CHARACTER SET utf8 COLLATE utf8_general_ci" 2>/dev/null

	echo "$(tput setaf $COLOR5)CREATE DATABASE: Datenbanken $DATENBANKNAME wurde angelegt. $(tput sgr0)"
	echo "$DATUM $(date +%H:%M:%S) CREATE DATABASE: Datenbanken $DATENBANKNAME wurde angelegt" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"

	# Eingabe Variablen löschen
	unset DBBENUTZER
	unset DBPASSWORT
	unset DATENBANKNAME

	return 0
}

### function create_db_user - Operation CREATE USER failed - Fehler.
function create_db_user()
{
	DBBENUTZER=$1; DBPASSWORT=$2; NEUERNAME=$3; NEUESPASSWORT=$4;

	echo "$(tput setaf $COLOR5)CREATE DATABASE USER: Datenbankbenutzer anlegen. $(tput sgr0)"
	echo "$DATUM $(date +%H:%M:%S) CREATE DATABASE USER: Datenbankbenutzer anlegen" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	echo "$DBBENUTZER, ********, $NEUERNAME, ********" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"

	mysql -u"$DBBENUTZER" -p"$DBPASSWORT" -e "CREATE USER '$NEUERNAME'@'localhost' IDENTIFIED BY '$NEUESPASSWORT'"
	mysql -u"$DBBENUTZER" -p"$DBPASSWORT" -e "GRANT ALL PRIVILEGES ON * . * TO '$NEUERNAME'@'localhost'"
	mysql -u"$DBBENUTZER" -p"$DBPASSWORT" -e "flush privileges"

	# Eingabe Variablen löschen
	unset DBBENUTZER
	unset DBPASSWORT
	unset NEUERNAME
	unset NEUESPASSWORT

	return 0
}

### function delete_db, löscht eine Datenbank.
function delete_db()
{
	DBBENUTZER=$1; DBPASSWORT=$2; DATENBANKNAME=$3;

	echo "$(tput setaf $COLOR5)DELETE DATABASE: Datenbank löschen. $(tput sgr0)"
	echo "$DATUM $(date +%H:%M:%S) DELETE DATABASE: Datenbank löschen" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"

	echo "$DBBENUTZER, ********, $DATENBANKNAME" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	# 2>/dev/null verhindert die Fehlerausgabe - mysql warning using a password on the command line interface can be insecure. disable.
	mysql -u"$DBBENUTZER" -p"$DBPASSWORT" -e "DROP DATABASE $DATENBANKNAME" 2>/dev/null

	# Eingabe Variablen löschen
	unset DBBENUTZER
	unset DBPASSWORT
	unset DATENBANKNAME

	return 0
}

### function leere_db, löscht eine Datenbank und erstellt diese anschließend neu.
function leere_db()
{
	DBBENUTZER=$1; DBPASSWORT=$2; DATENBANKNAME=$3;

	echo "$(tput setaf $COLOR5)EMPTY DATABASE: Datenbank leeren. $(tput sgr0)"
	echo "$DATUM $(date +%H:%M:%S) EMPTY DATABASE: Datenbank leeren" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"

	# 2>/dev/null verhindert die Fehlerausgabe - mysql warning using a password on the command line interface can be insecure. disable.

	# loesche
	mysql -u"$DBBENUTZER" -p"$DBPASSWORT" -e "DROP DATABASE $DATENBANKNAME" 2>/dev/null
	sleep 10	
	# erstelle neu
	mysql -u"$DBBENUTZER" -p"$DBPASSWORT" -e "CREATE DATABASE IF NOT EXISTS $DATENBANKNAME CHARACTER SET utf8 COLLATE utf8_general_ci" 2>/dev/null
	echo "$DATENBANKNAME geleert" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"

	# Eingabe Variablen löschen
	unset DBBENUTZER
	unset DBPASSWORT
	unset DATENBANKNAME

	return 0
}

### function allrepair_db, CHECK – REPAIR – ANALYZE – OPTIMIZE, alle Datenbanken.
function allrepair_db()
{
	DBBENUTZER=$1; DBPASSWORT=$2;

	echo "$(tput setaf $COLOR5)ALL REPAIR DATABASE: Alle Datenbanken Checken, Reparieren und Optimieren. $(tput sgr0)"
	echo "$DATUM $(date +%H:%M:%S) ALL REPAIR DATABASE: Alle Datenbanken Checken, Reparieren und Optimieren" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"

	mysqlcheck -u"$DBBENUTZER" -p"$DBPASSWORT" --auto-repair --all-databases
	mysqlcheck -u"$DBBENUTZER" -p"$DBPASSWORT" --check --all-databases
	mysqlcheck -u"$DBBENUTZER" -p"$DBPASSWORT" --optimize --all-databases
	# Danach werden automatisiert folgende SQL Statements ausgeführt:
	# – CHECK TABLE
	# – REPAIR TABLE
	# – ANALYZE TABLE
	# – OPTIMIZE TABLE
	echo "$(tput setaf $COLOR5)ALL REPAIR DATABASE: Fertig. $(tput sgr0)"
	echo "$DATUM $(date +%H:%M:%S) ALL REPAIR DATABASE: Fertig" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"

	# Eingabe Variablen löschen
	unset DBBENUTZER
	unset DBPASSWORT

	return 0
}

### function mysql_neustart, startet mySQL neu.
function mysql_neustart()
{
	echo "$(tput setaf $COLOR5)MYSQL RESTART: MySQL Neu starten. $(tput sgr0)"
	echo "$DATUM $(date +%H:%M:%S) MYSQL RESTART: MySQL Neu starten" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"

	echo "$(tput setaf $COLOR1)MYSQL RESTART: Stoppen. $(tput sgr0)"
	service mysql stop
	sleep 2
	echo "$(tput setaf $COLOR2)MYSQL RESTART: Starten. $(tput sgr0)"
	service mysql start
	echo "$(tput setaf $COLOR5)MYSQL RESTART: Fertig. $(tput sgr0)"

	return 0
}

### function db_sichern, sichert eine einzelne Datenbank.
function db_sichern()
{
	DBBENUTZER=$1; DBPASSWORT=$2; DATENBANKNAME=$3;

	echo "$(tput setaf $COLOR5)SAVE DATABASE: Datenbank $DATENBANKNAME sichern. $(tput sgr0)"
	echo "$DATUM $(date +%H:%M:%S) SAVE DATABASE: Datenbank $DATENBANKNAME sichern" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"

	# 2>/dev/null verhindert die Fehlerausgabe - mysql warning using a password on the command line interface can be insecure. disable.
	mysqldump -u"$DBBENUTZER" -p"$DBPASSWORT" "$DATENBANKNAME" > /$STARTVERZEICHNIS/"$DATENBANKNAME".sql 2>/dev/null

	echo "$(tput setaf $COLOR5)SAVE DATABASE: Im Hintergrund wird die Datenbank $DATENBANKNAME jetzt gesichert. $(tput sgr0)"
	echo "$DATUM $(date +%H:%M:%S) SAVE DATABASE: Im Hintergrund wird die Datenbank $DATENBANKNAME jetzt gesichert" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"

	# Eingabe Variablen löschen
	unset DBBENUTZER
	unset DBPASSWORT
	unset DATENBANKNAME

	return 0
}

### function tabellenabfrage, listet alle Tabellen in einer Datenbank auf.
# Es geht hier um die machbarkeit und nicht den Sinn.
function tabellenabfrage()
{
	DBBENUTZER=$1; DBPASSWORT=$2; DATENBANKNAME=$3;
	
mysql -u"$DBBENUTZER" -p"$DBPASSWORT" <<MEINE_ABFRAGE_ENDE 2>/dev/null
USE $DATENBANKNAME
SHOW tables
MEINE_ABFRAGE_ENDE

return 0
}

### function regionsabfrage, Alle Regionen listen (Dies geht nur im Grid (Grid Datenbank) oder Standalone Modus).
function regionsabfrage()
{
	DBBENUTZER=$1; DBPASSWORT=$2; DATENBANKNAME=$3;	
mysql -u"$DBBENUTZER" -p"$DBPASSWORT" <<MEIN_ABFRAGE_ENDE 2>/dev/null
USE $DATENBANKNAME
SELECT regionName FROM regions
MEIN_ABFRAGE_ENDE

return 0
}

### function regionsuri, Region URI prüfen sortiert nach URI (Dies geht nur im Grid (Grid Datenbank) oder Standalone Modus).
function regionsuri()
{
	DBBENUTZER=$1; DBPASSWORT=$2; DATENBANKNAME=$3;	
mysql -u"$DBBENUTZER" -p"$DBPASSWORT" <<MEIN_ABFRAGE_ENDE 2>/dev/null
USE $DATENBANKNAME
SELECT regionName , serverURI FROM regions ORDER BY serverURI
MEIN_ABFRAGE_ENDE

return 0
}

### function regionsport, Ports prüfen sortiert nach Ports (Dies geht nur im Grid (Grid Datenbank) oder Standalone Modus).
function regionsport()
{
	DBBENUTZER=$1; DBPASSWORT=$2; DATENBANKNAME=$3;	
mysql -u"$DBBENUTZER" -p"$DBPASSWORT" <<MEIN_ABFRAGE_ENDE 2>/dev/null
USE $DATENBANKNAME
SELECT regionName , serverPort FROM regions ORDER BY serverPort
MEIN_ABFRAGE_ENDE

return 0
}

### function setpartner, Partner setzen bei einer Person. Also bei beiden Partnern muss dies gemacht werden.
# opensim.sh setpartner Datenbankbenutzer Datenbankpasswort Robustdatenbank "AvatarUUID" "PartnerUUID"
function setpartner()
{
	DBBENUTZER=$1; DBPASSWORT=$2; DATENBANKNAME=$3; 
	AVATARUUID=$4; NEUERPARTNER=$5;
	
	LEEREMPTY="00000000-0000-0000-0000-000000000000";
	echo "$LEEREMPTY"

	#  2>/dev/null
mysql -u"$DBBENUTZER" -p"$DBPASSWORT" <<MEIN_ABFRAGE_ENDE 2>/dev/null
USE $DATENBANKNAME
UPDATE userprofile SET profilePartner = '$NEUERPARTNER' WHERE userprofile.useruuid = '$AVATARUUID'
MEIN_ABFRAGE_ENDE

	echo "$(tput setaf $COLOR5)SETPARTNER: $NEUERPARTNER ist jetzt Partner von $AVATARUUID. $(tput sgr0)"
	echo "$DATUM $(date +%H:%M:%S) SETPARTNER: $NEUERPARTNER ist jetzt Partner von $AVATARUUID" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	return 0
}

### function conf_write, Konfiguration schreiben ersatz für alle UNGETESTETEN ini Funktionen.
# ./opensim.sh conf_write Einstellung NeuerParameter Verzeichnis Dateiname
function conf_write()
{
	CONF_SEARCH=$1; CONF_ERSATZ=$2; CONF_PFAD=$3; CONF_DATEINAME=$4;
	sed -i 's/'"$CONF_SEARCH"' =.*$/'"$CONF_SEARCH"' = '"$CONF_ERSATZ"'/' /"$CONF_PFAD"/"$CONF_DATEINAME"
	echo "Einstellung $CONF_SEARCH auf Parameter $CONF_ERSATZ geändert in Datei /$CONF_PFAD/$CONF_DATEINAME"
	echo "$DATUM $(date +%H:%M:%S) CONF_WRITE: Einstellung $CONF_SEARCH auf Parameter $CONF_ERSATZ geändert in Datei /$CONF_PFAD/$CONF_DATEINAME" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	return 0
}
### function conf_read, ganze Zeile aus der Konfigurationsdatei anzeigen.
# ./opensim.sh conf_read Einstellungsbereich Verzeichnis Dateiname
function conf_read()
{
    CONF_SEARCH=$1; CONF_PFAD=$2; CONF_DATEINAME=$3;
	sed -n -e '/'"$CONF_SEARCH"'/p' /"$CONF_PFAD"/"$CONF_DATEINAME"
    echo "Einstellung $CONF_SEARCH suchen in Datei /$CONF_PFAD/$CONF_DATEINAME"
	echo "$DATUM $(date +%H:%M:%S) CONF_WRITE: Einstellung $CONF_SEARCH suchen in Datei /$CONF_PFAD/$CONF_DATEINAME" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	return 0
}
### function conf_delete, ganze Zeile aus der Konfigurationsdatei löschen.
# ./opensim.sh conf_delete Einstellungsbereich Verzeichnis Dateiname
function conf_delete()
{
    CONF_SEARCH=$1; CONF_PFAD=$2; CONF_DATEINAME=$3;
	sed -i 's/'"$CONF_SEARCH"' =.*$/''/' /"$CONF_PFAD"/"$CONF_DATEINAME"
    echo "Zeile $CONF_SEARCH gelöscht in Datei /$CONF_PFAD/$CONF_DATEINAME"
	echo "$DATUM $(date +%H:%M:%S) CONF_DELETE: Zeile $CONF_SEARCH gelöscht in Datei /$CONF_PFAD/$CONF_DATEINAME" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	return 0
}

### function ramspeicher, den echten RAM Speicher auslesen.
function ramspeicher()
{
	# RAM größe auslesen
	dmidecode --type 17 > /tmp/raminfo.inf
	RAMSPEICHER=$(awk -F ":" '/Size/ {print $2}' /tmp/raminfo.inf)
	rm /tmp/raminfo.inf
	# Zeichen löschen
	RAMSPEICHER="${RAMSPEICHER:1}" # erstes Zeichen löschen
	RAMSPEICHER="${RAMSPEICHER::-3}" # letzten 3 Zeichen löschen
	return 0
}

### function mysqleinstellen, ermitteln wieviel RAM Speicher vorhanden ist und anschließend mySQL Einstellen.
# Einstellungen sind in der my.cnf nicht möglich es muss in die /etc/mysql/mysql.conf.d/mysqld.cnf
# Hier wird nicht geprüft ob die Einstellungen schon vorhanden sind sondern nur angehängt.
function mysqleinstellen()
{
	# Ermitteln wie viel RAM Speicher der Server hat
	ramspeicher
	# Speicher Berechnung
	echo "Echter Speicher: $RAMSPEICHER"
	# Ich nehme hier einfach 25% des RAM Speichers weil OpenSim schon so speicherhungrig ist.
	mysqlspeicher=$((RAMSPEICHER/4)) 
	echo "Speicher für mySQL: $mysqlspeicher"
	MEGABYTE="M"

    echo "mySQL Konfiguration auf $mysqlspeicher$MEGABYTE Einstellen und neu starten"
	echo "*** Bitte den Inhalt der Datei /tmp/mysqld.txt in die Datei /etc/mysql/mysql.conf.d/mysqld.cnf einfügen. ***"
	echo "$DATUM $(date +%H:%M:%S) MYSQLEINSTELLEN: mySQL Konfiguration auf $mysqlspeicher$MEGABYTE Einstellen und neu starten" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"

	# Hier wird die config geschrieben es wird angehängt
	{	echo "#"
		echo "# Meine Einstellungen $mysqlspeicher"
		echo "innodb_buffer_pool_size = $mysqlspeicher$MEGABYTE  # (Hier sollte man etwa 50% des gesamten RAM nutzen) von 1G auf 2G erhöht"
		echo "innodb_log_file_size = 512M  # (128M – 2G muss nicht größer als der Pufferpool sein) von 256 auf 512 erhöht"
		echo "innodb_log_buffer_size = 256M # Normal 0 oder 1MB"
		echo "innodb_flush_log_at_trx_commit = 1  # (0/2 mehr Leistung, weniger Zuverlässigkeit, 1 Standard)"
		echo "innodb_flush_method = O_DIRECT  # (Vermeidet doppelte Pufferung)"
		echo "sync_binlog = 0"
		echo "binlog_format=ROW  # oder MIXED"
		echo "innodb_autoinc_lock_mode = 2 # Notwendigkeit einer AUTO-INC-Sperre auf Tabellenebene wird beseitigt und die Leistung kann erhöht werden."
		echo "innodb_io_capacity_max = $mysqlspeicher$MEGABYTE # (50% des Maximums festlegen)"
		echo "innodb_io_capacity = $mysqlspeicher$MEGABYTE # (50% des Maximums festlegen)"
		echo "# Meine Einstellungen $mysqlspeicher Ende"
		echo "#"
	} >> "/tmp/mysqld.txt"
	echo "*** Bitte den Inhalt der Datei /tmp/mysqld.txt in die Datei /etc/mysql/mysql.conf.d/mysqld.cnf einfügen. ***"
	# /etc/mysql/mysql.conf.d/mysqld.cnf
	# /etc/mysql/my.cnf

	# MySQL neu starten
	#mysql_neustart
	return 0
}

# In Arbeit
function neuegridconfig()
{
	echo "$(tput setaf $COLOR2)NEUEGRIDCONFIG: Konfigurationsdateien holen und in das ExampleConfig Verzeichnis kopieren. $(tput sgr0)"
	echo "$DATUM $(date +%H:%M:%S) NEUEGRIDCONFIG: Konfigurationsdateien holen und in das ExampleConfig Verzeichnis kopieren" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"

	cd /$STARTVERZEICHNIS || exit
	git clone https://github.com/BigManzai/OpenSim-Shell-Script
	mv /$STARTVERZEICHNIS/OpenSim-Shell-Script/ExampleConfig /$STARTVERZEICHNIS/ExampleConfig
	rm -r /$STARTVERZEICHNIS/OpenSim-Shell-Script

	echo "IP eintragen"
	ipsetzen

	#echo "Konfigurationen kopieren nach opensim"
	cp /$STARTVERZEICHNIS/ExampleConfig/robust/ /$STARTVERZEICHNIS/opensim/bin
	cp /$STARTVERZEICHNIS/ExampleConfig/sim/ /$STARTVERZEICHNIS/opensim/bin

	#echo "mySQL Einstellen und neu starten"
	#mysqleinstellen

	# Hier sind die gemeinsamkeiten zu ende.

	#echo "opensim kopieren in alle Verzeichnisse"
	
	#echo "Datenbanken erstellen und in allen Konfigurationen eintragen"
	return 0
}

### function ipsetzen, setzt nach Abfrage die IP in die Konfigurationen. OK
function ipsetzen()
{
	cd /"$STARTVERZEICHNIS/ExampleConfig" || return 1 # gibt es das ExampleConfig Verzeichnis wenn nicht abbruch.

	EINGABEIP=""
	echo "$(tput setaf $COLOR2)IPSETZEN: Bitte geben Sie ihre externe IP ein oder drücken sie Enter für $(tput sgr0) $AKTUELLEIP"
	
	# Eingabe einlesen in Variable EINGABEIP
	read -r EINGABEIP 
	
	# Prüfen ob Variableninhalt Enter oder eine IP ist 
	if test "$EINGABEIP" = ""
	then
	# ENTER wurde gewählt
	# Robust ändern
	sed -i 's/BaseURL =.*$/BaseURL = '"$AKTUELLEIP"'/' /$STARTVERZEICHNIS/ExampleConfig/robust/Robust.ini
	# OpenSim ändern
	sed -i 's/BaseHostname =.*$/BaseHostname = '"$AKTUELLEIP"'/' /$STARTVERZEICHNIS/ExampleConfig/sim/OpenSim.ini
	# MoneyServer ändern
	sed -i 's/MoneyScriptIPaddress  =.*$/MoneyScriptIPaddress  = '"$AKTUELLEIP"'/' /$STARTVERZEICHNIS/ExampleConfig/robust/MoneyServer.ini
	# GridCommon ändern
	sed -i 's/BaseHostname =.*$/BaseHostname = '"$AKTUELLEIP"'/' /$STARTVERZEICHNIS/ExampleConfig/sim/config-include/GridCommon.ini
	else
	# IP wurde gewählt
	# Ausführungszeichen anhängen
	EINGABEIP='"'$EINGABEIP'"'
	# Robust ändern
	sed -i 's/BaseURL =.*$/BaseURL = '"$EINGABEIP"'/' /$STARTVERZEICHNIS/ExampleConfig/robust/Robust.ini
	# OpenSim ändern
	sed -i 's/BaseHostname =.*$/BaseHostname = '"$EINGABEIP"'/' /$STARTVERZEICHNIS/ExampleConfig/sim/OpenSim.ini
	# MoneyServer ändern
	sed -i 's/MoneyScriptIPaddress  =.*$/MoneyScriptIPaddress  = '"$EINGABEIP"'/' /$STARTVERZEICHNIS/ExampleConfig/robust/MoneyServer.ini
	# GridCommon ändern
	sed -i 's/BaseHostname =.*$/BaseHostname = '"$EINGABEIP"'/' /$STARTVERZEICHNIS/ExampleConfig/sim/config-include/GridCommon.ini
	fi

	echo "$(tput setaf $COLOR2)IPSETZEN: IP oder DNS Einstellungen geändert. $(tput sgr0)"
	echo "$DATUM $(date +%H:%M:%S) IPSETZEN: IP oder DNS Einstellungen geändert" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	return 0
}

### Aktuelle IP in die Robust.ini schreiben. UNGETESTET
function robustini()
{
	# Aktuelle IP über Suchadresse ermitteln und Ausführungszeichen anhängen.
	DNAAKTUELLEIP="$(wget -O - -q $SEARCHADRES)"

	echo "Gebe deine Server Adresse ein: (Beispiel meinserver.de oder 192.168.2.106)"
	echo "Enter für $AKTUELLEIP"
	read -r DNANAME
	if [ -z "$DNANAME" ]; then DNANAME=$DNAAKTUELLEIP ; fi
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
	{	echo '[Const]' 
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
	} > "/$STARTVERZEICHNIS/$DATEIDATUM-Robust.ini"
	return 0
}

### Aktuelle IP in die MoneyServer.ini schreiben. UNGETESTET
function moneyserverini()
{	
	# Aktuelle IP über Suchadresse ermitteln und Ausführungszeichen anhängen.
	DNAAKTUELLEIP="$(wget -O - -q $SEARCHADRES)"

	echo "Datenbankname:"
	read -r DBNAME
	echo "Datenbank Benutzername:"
	read -r DBUSER
	echo "Datenbank Passwort:"
	read -r DBPASSWD
	# shellcheck disable=SC2016
	{ 	echo '[Startup]' 
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
	} > "/$STARTVERZEICHNIS/$DATEIDATUM-MoneyServer.ini"
	return 0
}

### Aktuelle IP in die OpenSim.ini schreiben.
function opensimini()
{
	# Aktuelle IP über Suchadresse ermitteln und Ausführungszeichen anhängen.
	DNAAKTUELLEIP="$(wget -O - -q $SEARCHADRES)"

	echo "Gebe deine Server Adresse ein: (Beispiel meinserver.de oder 192.168.2.106)"
	echo "Enter für $AKTUELLEIP"
	read -r DNANAME
	if [ -z "$DNANAME" ]; then DNANAME=$DNAAKTUELLEIP ; fi
	IP8002='"''http://'"$DNANAME"":8002"'"'
	IP8003='"''http://'"$DNANAME"":8003"'"'
	BASEURL='"''http://'"$DNANAME"'"'
	echo "Gridname:"
	read -r GRIDNAME
	echo "SimulatorPort (9010):"
	read -r SIMULATORPORT
	if [ -z "$SIMULATORPORT" ]; then SIMULATORPORT=9010 ; fi
	echo "SimulatorXmlRpcPort (20801):"
	read -r SIMULATORXMLRPCPORT
	if [ -z "$SIMULATORXMLRPCPORT" ]; then SIMULATORXMLRPCPORT=20801 ; fi

	# shellcheck disable=SC2016
	{	echo '[Const]' 
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
	} > "/$STARTVERZEICHNIS/$DATEIDATUM-OpenSim.ini"
	return 0
}

### Aktuelle IP in die GridCommon.ini schreiben. UNGETESTET
function gridcommonini()
{
	# Aktuelle IP über Suchadresse ermitteln und Ausführungszeichen anhängen.
	DNAAKTUELLEIP="$(wget -O - -q $SEARCHADRES)"

	echo "Gebe deine Server Adresse ein: (Beispiel meinserver.de oder 192.168.2.106)"
	echo "Enter für $AKTUELLEIP"
	read -r DNANAME
	if [ -z "$DNANAME" ]; then DNANAME=$DNAAKTUELLEIP ; fi
	IP8002='"''http://'"$DNANAME"":8002"'"'
	IP8003='"''http://'"$DNANAME"":8003"'"'

	echo "Datenbankname:"
	read -r DBNAME
	echo "Datenbank Benutzername:"
	read -r DBUSER
	echo "Datenbank Passwort:"
	read -r DBPASSWD

	{	echo '[DatabaseService]'
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
	} > "/$STARTVERZEICHNIS/$DATEIDATUM-GridCommon.ini"
	#/$STARTVERZEICHNIS/"$VERZEICHNIS"/bin/config-include/GridCommon.ini
	return 0
}

### regionini Simulator Dateiname
### Aktuelle IP in die Regions.ini schreiben. UNGETESTET
function regionini()
{	
	# Aktuelle IP über Suchadresse ermitteln und Ausführungszeichen anhängen.
	DNAAKTUELLEIP="$(wget -O - -q $SEARCHADRES)"

	echo "Gebe deine Server Adresse ein: (Beispiel meinserver.de oder 192.168.2.106)"
	echo "Enter für $AKTUELLEIP"
	read -r DNANAME
	if [ -z "$DNANAME" ]; then DNANAME=$DNAAKTUELLEIP ; fi

	echo "Startpunkt des Grid Beispiel: 4500,4500"
	read -r STARTPUNKT
	if [ -z "$STARTPUNKT" ]; then STARTPUNKT="4500,4500" ; fi
	echo "InternalPort Beispiel: 9050"
	read -r INTERNALPORT
	if [ -z "$INTERNALPORT" ]; then INTERNALPORT=9050 ; fi

	UUID=$(uuidgen)

	{	echo '[Welcome]' 
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
	} > "/$STARTVERZEICHNIS/$DATEIDATUM-welcome.ini"
	return 0
}

### function osslenableini() erstellt eine osslenable.ini Datei und Konfiguriert diese.
function osslenableini()
{	
	#osslEnable.ini
	echo "OSFunctionThreatLevel Möglichkeiten: None, VeryLow, Low, Moderate, High, VeryHigh, Severe"
	echo "Enter = Severe"
	read -r OSFUNCTION
	if [ -z "$OSFUNCTION" ]; then OSFUNCTION="Severe" ; fi

	# shellcheck disable=SC2016
	{	echo '[OSSL]'
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
	} > "/$STARTVERZEICHNIS/$DATEIDATUM-osslEnable.ini"
	return 0
}

### Umbenennen der example Dateien in Konfigurationsdateien vor dem kopieren.
function unlockexample()
{
	echo "$(tput setab $BCOLOR2)Alle example Dateien umbenennen. $(tput sgr $OMCOFF)"
	echo "$DATUM $(date +%H:%M:%S) RENAME: Alle example Dateien umbenennen" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	UEVERZEICHNIS1="/$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/bin"
	UEVERZEICHNIS2="/$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/bin/config-include"

	for file1 in /"$STARTVERZEICHNIS"/"$OPENSIMVERZEICHNIS"/bin/*.example
	do
	if [ -e "$file1" ]
	then
		cd $UEVERZEICHNIS1 || exit
		for file in *.ini.example; do mv -i "${file}" "${file%%.ini.example}.ini"; done
		for file in *.html.example; do mv -i "${file}" "${file%%.html.example}.html"; done
		for file in *.txt.example; do mv -i "${file}" "${file%%.txt.example}.txt"; done
		break
	else
		echo "$(tput setab $BCOLOR1)keine example Datei im Verzeichnis $UEVERZEICHNIS1 vorhanden. $(tput sgr $OMCOFF)"
		echo "$DATUM $(date +%H:%M:%S) RENAME: keine example Datei im Verzeichnis $UEVERZEICHNIS1 vorhanden" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	fi
	done

	for file2 in /"$STARTVERZEICHNIS"/"$OPENSIMVERZEICHNIS"/bin/config-include/*.example
	do
	if [ -e "$file2" ]
	then
		cd $UEVERZEICHNIS2 || exit
		for file in *.ini.example; do mv -i "${file}" "${file%%.ini.example}.ini"; done
		break
	else
		echo "$(tput setab $BCOLOR1)keine example Datei im Verzeichnis $UEVERZEICHNIS2 vorhanden. $(tput sgr $OMCOFF)"
		echo "$DATUM $(date +%H:%M:%S) RENAME: keine example Datei im Verzeichnis $UEVERZEICHNIS2 vorhanden" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	fi
	done
	return 0
}

###########################################################################
# Samples
###########################################################################

### Funktion gridstop, stoppt erst Money dann Robust.
function gridstop()
{
	if screen -list | grep -q MO; then
		mostop
	else
		echo "$(tput setaf $COLOR1)$(tput setab $BCOLOR7)### MoneyServer läuft nicht ### $(tput sgr $OMCOFF)"
	fi

	if screen -list | grep -q RO; then
		rostop		
	else
		echo "$(tput setaf $COLOR1)$(tput setab $BCOLOR7)### RobustServer läuft nicht ### $(tput sgr $OMCOFF)"
	fi
	return 0
}
### Funktion gridstop, stoppt erst Money dann Robust.
function menugridstop()
{
	if screen -list | grep -q MO; then
		menumostop		
	else
		#echo "$(tput setaf $COLOR1)$(tput setab $BCOLOR7)### MoneyServer läuft nicht ### $(tput sgr $OMCOFF)"
		echo " "
	fi

	if screen -list | grep -q RO; then
		menurostop		
	else
		#echo "$(tput setaf $COLOR1)$(tput setab $BCOLOR7)### RobustServer läuft nicht ### $(tput sgr $OMCOFF)"
		echo " "
	fi
	return 0
}

### Funktion compilieren, kompilieren des OpenSimulator.
function compilieren()
{
	echo "$(tput setab $BCOLOR2)Bauen eines neuen OpenSimulators wird gestartet! $(tput sgr $OMCOFF)"
	echo "$DATUM $(date +%H:%M:%S) COMPILIEREN: Bauen eines neuen OpenSimulators wird gestartet" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	# Nachsehen ob Verzeichnis überhaupt existiert.
	if [ ! -f "/$STARTVERZEICHNIS/$SCRIPTSOURCE/" ]; then
		scriptcopy
	else
		echo "OSSL Script Verzeichnis existiert nicht."
		echo "$DATUM $(date +%H:%M:%S) COMPILIEREN: OSSL Script Verzeichnis existiert nicht" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	fi

	if [ ! -f "/$STARTVERZEICHNIS/$MONEYSOURCE/" ]; then
		moneycopy
	else
		echo "MoneyServer Verzeichnis existiert nicht."
		echo "$DATUM $(date +%H:%M:%S) COMPILIEREN: MoneyServer Verzeichnis existiert nicht" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	fi

	if [ ! -f "/$STARTVERZEICHNIS/$CONFIGURESOURCE/" ]; then
		configurecopy
	else
		echo "Configure Verzeichnis existiert nicht."
		echo "$DATUM $(date +%H:%M:%S) COMPILIEREN: Configure Verzeichnis existiert nicht" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	fi

	if [ ! -f "/$STARTVERZEICHNIS/$OSSEARCHCOPY/" ]; then
		OpenSimSearchgitcopy
	else
		echo "OpenSimSearch Verzeichnis existiert nicht."
		echo "$DATUM $(date +%H:%M:%S) COMPILIEREN: OpenSimSearch Verzeichnis existiert nicht" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	fi

	if [ ! -f "/$STARTVERZEICHNIS/OpensimPython/" ]; then
		pythoncopy
	else
		echo "OpensimPython Verzeichnis existiert nicht."
		echo "$DATUM $(date +%H:%M:%S) COMPILIEREN: OpensimPython Verzeichnis existiert nicht" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	fi

	if [ ! -f "/$STARTVERZEICHNIS/OpenSimSearch/" ]; then
		searchcopy
	else
		echo "OpenSimSearch Verzeichnis existiert nicht."
		echo "$DATUM $(date +%H:%M:%S) COMPILIEREN: OpenSimSearch Verzeichnis existiert nicht" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	fi

	if [ ! -f "/$STARTVERZEICHNIS/OpenSimMutelist/" ]; then
		mutelistcopy
	else
		echo "OpenSimMutelist Verzeichnis existiert nicht."
		echo "$DATUM $(date +%H:%M:%S) COMPILIEREN: OpenSimMutelist Verzeichnis existiert nicht" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	fi

	if [ ! -f "/$STARTVERZEICHNIS/Chris.OS.Additions/" ]; then
		chrisoscopy
	else
		echo "Chris.OS.Additions Verzeichnis existiert nicht."
		echo "$DATUM $(date +%H:%M:%S) COMPILIEREN: Chris.OS.Additions Verzeichnis existiert nicht" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	fi

	if [ ! -f "/$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/" ]; then

		# AOT Aktiveren oder Deaktivieren.
		if [[ $SETAOTON = "yes" ]]
		then		
			oscompiaot
		else
			oscompi
		fi

	else
		echo "opensim Verzeichnis existiert nicht."
		echo "$DATUM $(date +%H:%M:%S) COMPILIEREN: opensim Verzeichnis existiert nicht" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	fi
	return 0
}

### Funktion OSGRIDCOPY, automatisches kopieren des opensimulator aus dem verzeichnis opensim.
function osgridcopy()
{
	echo " #############################"
	echo " !!!      BEI FEHLER      !!! "
	echo " !!! ABBRUCH MIT STRG + C !!! "
	echo " #############################"

	echo "$(tput setab $BCOLOR2)Das Grid wird jetzt kopiert/aktualisiert! $(tput sgr $OMCOFF)"
	echo "$DATUM $(date +%H:%M:%S) OSGRIDCOPY: Das Grid wird jetzt kopiert/aktualisiert" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	echo " "
	# Grid Stoppen.
	echo "$DATUM $(date +%H:%M:%S) OSGRIDCOPY: Alles Beenden falls da etwas läuft" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	autostop
	# Kopieren.
	echo "$DATUM $(date +%H:%M:%S) OSGRIDCOPY: Neue Version kopieren" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	oscopyrobust
	oscopysim
	echo " "
	# MoneyServer eventuell loeschen.	
	if [ "$MONEYVERZEICHNIS" = "keins" ] || [ "$MONEYVERZEICHNIS" = "no" ] || [ "$MONEYVERZEICHNIS" = "nein" ]; then moneydelete; fi
	return 0
}

### Funktion osupgrade, automatisches upgrade des opensimulator aus dem verzeichnis opensim.
function osupgrade()
{
	echo " #############################"
	echo " !!!      BEI FEHLER      !!! "
	echo " !!! ABBRUCH MIT STRG + C !!! "
	echo " #############################"

	echo "$(tput setab $BCOLOR2)Das Grid wird jetzt upgegradet! $(tput sgr $OMCOFF)"
	echo "$DATUM $(date +%H:%M:%S) OSUPGRADE: Das Grid wird jetzt upgegradet" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	echo " "
	# Grid Stoppen.
	echo "$DATUM $(date +%H:%M:%S) OSUPGRADE: Alles Beenden" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	autostop
	# Kopieren.
	echo "$DATUM $(date +%H:%M:%S) OSUPGRADE: Neue Version Installieren" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	oscopyrobust
	oscopysim
	echo " "
	echo "$DATUM $(date +%H:%M:%S) OSUPGRADE: Log Dateien loeschen!" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	autologdel
	rologdel
	echo " "
	# MoneyServer eventuell loeschen.	
	if [ "$MONEYVERZEICHNIS" = "keins" ] || [ "$MONEYVERZEICHNIS" = "no" ] || [ "$MONEYVERZEICHNIS" = "nein" ]; then moneydelete; fi
	# Grid Starten.
	echo "$DATUM $(date +%H:%M:%S) OSUPGRADE: Das Grid wird jetzt gestartet" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	autostart
	return 0
}

### Funktion osupgrade, automatisches upgrade des opensimulator aus dem verzeichnis opensim.
function oszipupgrade()
{
	### dialog Aktionen
	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null|grep -q installed; then
		# Alle Aktionen mit dialog
		VERSIONSNUMMER=$( dialog --backtitle "opensimMULTITOOL $VERSION" --title "opensimMULTITOOL Eingabe" --inputbox "Versionsnummer:" 8 40 3>&1 1>&2 2>&3 3>&- )
		dialog --clear
		clear
	else
		# Alle Aktionen ohne dialog
		echo "Keine Menülose Funktion vorhanden!"|exit
		#VERSIONSNUMMER=$1
	fi
	# dialog Aktionen Ende
	
    cd /$STARTVERZEICHNIS || exit

	# Konfigurationsabfrage Neues Grid oder Upgrade.

	echo "$(tput setaf $COLOR5)Alten OpenSimulator sichern$(tput sgr0)"
	echo "$DATUM $(date +%H:%M:%S) OSBUILDING: Alten OpenSimulator sichern" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
    osdelete

	echo " "

	echo "$(tput setaf $COLOR5)Neuen OpenSimulator entpacken$(tput sgr0)"
	echo "$DATUM $(date +%H:%M:%S) OSBUILDING: Neuen OpenSimulator aus der ZIP entpacken" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
    unzip opensim-0.9.2.2."$VERSIONSNUMMER".zip

	echo " "

	echo "$(tput setaf $COLOR5)Neuen OpenSimulator umbenennen$(tput sgr0)"
	echo "$DATUM $(date +%H:%M:%S) OSBUILDING: Neuen OpenSimulator umbenennen" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
    mv /$STARTVERZEICHNIS/opensim-0.9.2.2."$VERSIONSNUMMER"/ /$STARTVERZEICHNIS/opensim/

	echo " "

	osupgrade
	return 0
}

# Hier entsteht die Automatische Konfiguration. UNGETESTET
function autoconfig()
{
	$AUTOCONFIG # yes oder no
	echo "ohne Funktion!"
	return 0
}

###########################################################################
# Hilfen und Info
###########################################################################



### Funktion info, Informationen auf den Bildschirm ausgeben.
function info()
{
	echo "$(tput setab $BCOLOR4) Server Name: ${HOSTNAME}"
	echo " Bash Version: ${BASH_VERSION}"
	echo " Server IP: ${AKTUELLEIP}"
	echo " MONO THREAD Einstellung: ${MONO_THREADS_PER_CPU}"
	echo " Spracheinstellung: ${LANG} $(tput sgr $OMCOFF)"
	echo " Screen Version: $(screen --version)"
	who -b
	return 0
}

### Funktion infodialog, Informationen auf den Bildschirm ausgeben.
function infodialog()
{
	TEXT1=(" Server Name: ${HOSTNAME}")
	TEXT2=(" Bash Version: ${BASH_VERSION}")
	TEXT3=(" Server IP: ${AKTUELLEIP}")
	TEXT4=(" MONO THREAD Einstellung: ${MONO_THREADS_PER_CPU}")
	TEXT5=(" Spracheinstellung: ${LANG}")
	TEXT0=(" MULTITOOL: wurde gestartet am $(date +%d.%m.%Y) um $(date +%H:%M:%S) Uhr")
	TEXT6=(" $(screen --version)")
	# shellcheck disable=SC2128
	dialog --backtitle "opensimMULTITOOL $VERSION" --msgbox "$TEXT0\n$TEXT1\n$TEXT2\n$TEXT3\n$TEXT4\n$TEXT5\n$TEXT6" 0 0
	# Dialog-Bildschirm löschen
	dialog --clear
	# Bildschirm löschen
	#clear
	hauptmenu
}

### Funktion kalender(), einfach nur ein Kalender.
function kalender()
{
	HEIGHT=0
	WIDTH=0
    TITLE="opensimMULTITOOL $VERSION"

	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null|grep -q installed; then

		TDATUM=$(date +%d)
		MDATUM=$(date +%m)
		JDATUM=$(date +%Y)
		# dialog --calendar

		DATUMERGEBNIS=$(dialog --calendar "calendar" $HEIGHT $WIDTH "$TDATUM" "$MDATUM" "$JDATUM" 3>&1 1>&2 2>&3) # Unbekannter Fehler

		dialog --clear
		clear

		# Zeilen aus einer Variablen zerlegen und in verschiedenen Variablen schreiben.
		NEWDATUM=$(echo "$DATUMERGEBNIS" | sed -n '1p' | sed 's/\//./g') # erste zeile aus DATUMERGEBNIS nehmen und die Schrägstriche gegen ein leerzeichen austauschen.

		warnbox "Ihr gewähltes Datum: $NEWDATUM" || hauptmenu

		hauptmenu
	else
		# wenn dialog nicht installiert ist die Hilfe anzeigen.
		hilfe
	fi
}

### Funktion fortschritsanzeige(), test für eine Fortschrittsanzeige.
function fortschritsanzeige()
{
	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null|grep -q installed; then

		dialogtext="Bitte warten!"

        # dialog --gauge eine Fortschritsanzeige
		for i in $(seq 0 10 100)
		do
			sleep 1
			echo "$i" | dialog --gauge "$dialogtext" 10 70 0
		done

	else
		# wenn dialog nicht installiert ist die Hilfe anzeigen.
		hilfe
	fi
}

### Funktion menuinfo, Informationen im dialog ausgeben.
function menuinfo()
{
	menuinfoergebnis=$(screen -ls | sed '1d' | sed '$d' | awk -F. '{print $2}' | awk -F\( '{print $1}')

	infoboxtext=""
	infoboxtext+=" Es ist der $(date +%d.%m.%Y) um $(date +%H:%M:%S) Uhr\n"
	infoboxtext+=" Server Name: ${HOSTNAME}\n"
	infoboxtext+=" Bash Version: ${BASH_VERSION}\n"
	infoboxtext+=" Server IP: ${AKTUELLEIP}\n"
	infoboxtext+=" MONO THREAD Einstellung: ${MONO_THREADS_PER_CPU}\n"
	infoboxtext+=" Spracheinstellung: ${LANG}\n"
	infoboxtext+=" Screen Version: $(screen --version)\n"
	infoboxtext+=" Letzter$(who -b)\n\n"
	infoboxtext+=" Aktuell läuft im Moment:\n"
	infoboxtext+=" __________________________________________________________\n"
	infoboxtext+="$menuinfoergebnis"

	dialog --msgbox  "$infoboxtext" 20 65
	dialog --clear
	hauptmenu

	return 0
}
### Funktion menukonsolenhilfe, menukonsolenhilfe auf dem Bildschirm anzeigen.
function menukonsolenhilfe()
{
	#helpergebnis=$(help)
	#dialog --msgbox "Konsolenhilfe:\n $helpergebnis" 50 75; dialog --clear

	help > help.txt	
	dialog --textbox "help.txt" 55 85; dialog --clear

	hauptmenu
	return 0
}

### Funktion hilfe, Hilfe auf dem Bildschirm anzeigen.
function hilfe()
{
echo "$(tput setab $BCOLOR5)Funktion:$(tput sgr $OMCOFF)		$(tput setab $BCOLOR2)Parameter:$(tput sgr $OMCOFF)		$(tput setab $BCOLOR4)Informationen:$(tput sgr $OMCOFF)"
	echo "hilfe 			- $(tput setaf $COLOR3)hat keine Parameter$(tput sgr $OMCOFF)	- Diese Hilfe."
	echo "konsolenhilfe 		- $(tput setaf $COLOR3)hat keine Parameter$(tput sgr $OMCOFF)	- konsolenhilfe ist eine Hilfe für Putty oder Xterm."
	echo "restart 		- $(tput setaf $COLOR3)hat keine Parameter$(tput sgr $OMCOFF)	- Startet das gesamte Grid neu."
	echo "autostop 		- $(tput setaf $COLOR3)hat keine Parameter$(tput sgr $OMCOFF)	- Stoppt das gesamte Grid."
	echo "autostart 		- $(tput setaf $COLOR3)hat keine Parameter$(tput sgr $OMCOFF)	- Startet das gesamte Grid."
	echo "works 			- $(tput setab $BCOLOR5)Verzeichnisname$(tput sgr $OMCOFF)	- Einzelne screens auf Existenz prüfen."
	echo "osstart 		- $(tput setab $BCOLOR5)Verzeichnisname$(tput sgr $OMCOFF)	- Startet einen einzelnen Simulator."
	echo "osstop 			- $(tput setab $BCOLOR5)Verzeichnisname$(tput sgr $OMCOFF)	- Stoppt einen einzelnen Simulator."
	echo "meineregionen 		- $(tput setaf $COLOR3)hat keine Parameter$(tput sgr $OMCOFF)   - listet alle Regionen aus den Konfigurationen auf."
	echo "autologdel		- $(tput setaf $COLOR3)hat keine Parameter$(tput sgr $OMCOFF)	- Löscht alle Log Dateien."
	echo "automapdel		- $(tput setaf $COLOR3)hat keine Parameter$(tput sgr $OMCOFF)	- Löscht alle Map Karten."

echo "$(tput setab $BCOLOR3)Erweiterte Funktionen$(tput sgr $OMCOFF)"
	echo "regionbackup 		- $(tput setab $BCOLOR5)Verzeichnisname$(tput sgr $OMCOFF) $(tput setab $BCOLOR4)Regionsname$(tput sgr $OMCOFF) - Backup einer ausgewählten Region."
	echo "assetdel 		- $(tput setab $BCOLOR5)screen_name$(tput sgr $OMCOFF) $(tput setab $BCOLOR4)Regionsname$(tput sgr $OMCOFF) $(tput setab $BCOLOR2)Objektname$(tput sgr $OMCOFF) - Einzelnes Asset löschen."
	echo "oscommand 		- $(tput setab $BCOLOR5)Verzeichnisname$(tput sgr $OMCOFF) $(tput setab $BCOLOR3)Region$(tput sgr $OMCOFF) $(tput setab $BCOLOR4)Konsolenbefehl Parameter$(tput sgr $OMCOFF) - Konsolenbefehl senden."
	echo "gridstart 		- $(tput setaf $COLOR3)hat keine Parameter$(tput sgr $OMCOFF) - Startet Robust und Money. "
	echo "gridstop 		- $(tput setaf $COLOR3)hat keine Parameter$(tput sgr $OMCOFF) - Beendet Robust und Money. "
	echo "rostart 		- $(tput setaf $COLOR3)hat keine Parameter$(tput sgr $OMCOFF) - Startet Robust Server."
	echo "rostop 			- $(tput setaf $COLOR3)hat keine Parameter$(tput sgr $OMCOFF) - Stoppt Robust Server."
	echo "mostart 		- $(tput setaf $COLOR3)hat keine Parameter$(tput sgr $OMCOFF) - Startet Money Server."
	echo "mostop 			- $(tput setaf $COLOR3)hat keine Parameter$(tput sgr $OMCOFF) - Stoppt Money Server."
	echo "autosimstart 		- $(tput setaf $COLOR3)hat keine Parameter$(tput sgr $OMCOFF) - Startet alle Regionen."
	echo "autosimstop 		- $(tput setaf $COLOR3)hat keine Parameter$(tput sgr $OMCOFF) - Beendet alle Regionen. "
	echo "autoscreenstop		- $(tput setaf $COLOR3)hat keine Parameter$(tput sgr $OMCOFF) - Killt alle OpenSim Screens."
	echo "logdel 			- $(tput setab $BCOLOR5)Verzeichnisname$(tput sgr $OMCOFF)     - Löscht alle Simulator Log Dateien im Verzeichnis."
	echo "mapdel 			- $(tput setab $BCOLOR5)Verzeichnisname$(tput sgr $OMCOFF)     - Löscht alle Simulator Map-Karten im Verzeichnis."
	echo "settings 		- $(tput setaf $COLOR3)hat keine Parameter$(tput sgr $OMCOFF) - setzt Linux Einstellungen."
	echo "configlesen 		- $(tput setab $BCOLOR5)Verzeichnisname$(tput sgr $OMCOFF)     - Alle Regionskonfigurationen im Verzeichnis anzeigen."

echo "$(tput setab $BCOLOR1)Experten Funktionen$(tput sgr $OMCOFF)"
	echo "osupgrade 		- $(tput setaf $COLOR3)hat keine Parameter$(tput sgr $OMCOFF) - Installiert eine neue OpenSim Version."
	echo "autoregionbackup	- $(tput setaf $COLOR3)hat keine Parameter$(tput sgr $OMCOFF) - Backup aller Regionen."
	echo "oscopy			- $(tput setab $BCOLOR5)Verzeichnisname$(tput sgr $OMCOFF)     - Kopiert den Simulator."
	echo "osstruktur		- $(tput setab $BCOLOR5)ersteSIM$(tput sgr $OMCOFF) $(tput setab $BCOLOR4)letzteSIM$(tput sgr $OMCOFF)  - Legt eine Verzeichnisstruktur an."
	echo "osprebuild		- $(tput setab $BCOLOR2)Versionsnummer$(tput sgr $OMCOFF)      - Aendert die Versionseinstellungen 0.9.2.XXXX"
	echo "compilieren 		- $(tput setaf $COLOR3)hat keine Parameter$(tput sgr $OMCOFF) - Kopiert fehlende Dateien und Kompiliert."
	echo "oscompi 		- $(tput setaf $COLOR3)hat keine Parameter$(tput sgr $OMCOFF) - Kompiliert einen neuen OpenSimulator ohne kopieren."
	echo "scriptcopy 		- $(tput setaf $COLOR3)hat keine Parameter$(tput sgr $OMCOFF) - Kopiert die Scripte in den Source."
	echo "moneycopy 		- $(tput setaf $COLOR3)hat keine Parameter$(tput sgr $OMCOFF) - Kopiert Money Source in den OpenSimulator Source."
	echo "osdelete 		- $(tput setaf $COLOR3)hat keine Parameter$(tput sgr $OMCOFF) - Löscht alte OpenSim Version."
	echo "regionsiniteilen 	- $(tput setab $BCOLOR5)Verzeichnisname$(tput sgr $OMCOFF) $(tput setab $BCOLOR3)Region$(tput sgr $OMCOFF) - kopiert aus der Regions.ini eine Region heraus."
	echo "autoregionsiniteilen 	- $(tput setaf $COLOR3)hat keine Parameter$(tput sgr $OMCOFF) - aus allen Regions.ini alle Regionen vereinzeln."
	echo "RegionListe 		- $(tput setaf $COLOR3)hat keine Parameter$(tput sgr $OMCOFF) - Die RegionList.ini erstellen."
	echo "Regionsdateiliste 	- $(tput setab $BCOLOR4)-b Bildschirm oder -d Datei$(tput sgr $OMCOFF) $(tput setab $BCOLOR5)Verzeichnisname$(tput sgr $OMCOFF) - Regionsdateiliste erstellen."
	echo "osgitholen 		- $(tput setaf $COLOR3)hat keine Parameter$(tput sgr $OMCOFF) - kopiert eine OpenSimulator Git Entwicklerversion."
	echo "terminator 		- $(tput setaf $COLOR3)hat keine Parameter$(tput sgr $OMCOFF) - Killt alle laufenden Screens."

echo "$(tput setab $BCOLOR1)Ungetestete oder zu testende Funktionen$(tput sgr $OMCOFF)"
	echo "makeaot			- $(tput setaf $COLOR3)hat keine Parameter$(tput sgr $OMCOFF) - aot Dateien erstellen."
	echo "cleanaot		- $(tput setaf $COLOR3)hat keine Parameter$(tput sgr $OMCOFF) - aot Dateien entfernen."
	echo "monoinstall		- $(tput setaf $COLOR3)hat keine Parameter$(tput sgr $OMCOFF) - mono 6.x installation."
	echo "installationen		- $(tput setaf $COLOR3)hat keine Parameter$(tput sgr $OMCOFF) - Linux Pakete - installationen aufisten."
	echo "serverinstall		- $(tput setaf $COLOR3)hat keine Parameter$(tput sgr $OMCOFF) - alle benötigten Linux Pakete installieren."
	echo "osbuilding		- $(tput setab $BCOLOR5)Versionsnummer$(tput sgr $OMCOFF) - Upgrade des OpenSimulator aus einer Source ZIP Datei."
	echo "createuser 		- $(tput setab $BCOLOR5) Vorname $(tput sgr $OMCOFF) $(tput setab $BCOLOR4) Nachname $(tput sgr $OMCOFF) $(tput setab $BCOLOR2) Passwort $(tput sgr $OMCOFF) $(tput setab $BCOLOR3) E-Mail $(tput sgr $OMCOFF) - Grid Benutzer anlegen."
echo " "
	echo "db_anzeigen	- $(tput setab $BCOLOR5) DBBENUTZER $(tput sgr $OMCOFF) $(tput setab $BCOLOR4) DBDATENBANKNAME $(tput sgr $OMCOFF) - Alle Datenbanken anzeigen."
	echo "create_db	- $(tput setab $BCOLOR5) DBBENUTZER $(tput sgr $OMCOFF) $(tput setab $BCOLOR4) DBPASSWORT $(tput sgr $OMCOFF) $(tput setab $BCOLOR2) DATENBANKNAME $(tput sgr $OMCOFF) - Datenbank anlegen."
	#echo "create_db_user	- $(tput setab $BCOLOR5) DBBENUTZER $(tput sgr $OMCOFF) $(tput setab $BCOLOR4) DBDATENBANKNAME $(tput sgr $OMCOFF) $(tput setab $BCOLOR2) NEUERNAME $(tput sgr $OMCOFF) $(tput setab $BCOLOR3) NEUESPASSWORT $(tput sgr $OMCOFF) - DB Benutzer anlegen."
	echo "delete_db	- $(tput setab $BCOLOR5) DBBENUTZER $(tput sgr $OMCOFF) $(tput setab $BCOLOR4) DBPASSWORT $(tput sgr $OMCOFF) $(tput setab $BCOLOR2) DATENBANKNAME $(tput sgr $OMCOFF) - Datenbank löschen."
	echo "leere_db	- $(tput setab $BCOLOR5) DBBENUTZER $(tput sgr $OMCOFF) $(tput setab $BCOLOR4) DBPASSWORT $(tput sgr $OMCOFF) $(tput setab $BCOLOR2) DATENBANKNAME $(tput sgr $OMCOFF) - Datenbank leeren."
	echo "allrepair_db	- $(tput setab $BCOLOR5) DBBENUTZER $(tput sgr $OMCOFF) $(tput setab $BCOLOR4) DBPASSWORT $(tput sgr $OMCOFF) - Alle Datenbanken Reparieren und Optimieren."
	echo "db_sichern	- $(tput setab $BCOLOR5) DBBENUTZER $(tput sgr $OMCOFF) $(tput setab $BCOLOR4) DBPASSWORT $(tput sgr $OMCOFF) $(tput setab $BCOLOR2) DATENBANKNAME $(tput sgr $OMCOFF) - Datenbank sichern."
	echo "mysql_neustart	- $(tput setaf $COLOR3)hat keine Parameter$(tput sgr $OMCOFF) - MySQL neu starten."

	echo "regionsabfrage	- $(tput setab $BCOLOR5) DBBENUTZER $(tput sgr $OMCOFF) $(tput setab $BCOLOR4) DBPASSWORT $(tput sgr $OMCOFF) $(tput setab $BCOLOR2) DATENBANKNAME $(tput sgr $OMCOFF) - Regionsliste."
	echo "regionsuri	- $(tput setab $BCOLOR5) DBBENUTZER $(tput sgr $OMCOFF) $(tput setab $BCOLOR4) DBPASSWORT $(tput sgr $OMCOFF) $(tput setab $BCOLOR2) DATENBANKNAME $(tput sgr $OMCOFF) - URI prüfen sortiert nach URI."
	echo "regionsport	- $(tput setab $BCOLOR5) DBBENUTZER $(tput sgr $OMCOFF) $(tput setab $BCOLOR4) DBPASSWORT $(tput sgr $OMCOFF) $(tput setab $BCOLOR2) DATENBANKNAME $(tput sgr $OMCOFF) - Ports prüfen sortiert nach Ports."

	echo "opensimholen	- $(tput setaf $COLOR3)hat keine Parameter$(tput sgr $OMCOFF) - Lädt eine Reguläre OpenSimulator Version herunter."
	echo "mysqleinstellen	- $(tput setaf $COLOR3)hat keine Parameter$(tput sgr $OMCOFF) - mySQL Konfiguration auf Server Einstellen und neu starten."
	echo "conf_write	- $(tput setab $BCOLOR5) SUCHWORT $(tput sgr $OMCOFF) $(tput setab $BCOLOR4) ERSATZWORT $(tput sgr $OMCOFF) $(tput setab $BCOLOR2) PFAD $(tput sgr $OMCOFF) $(tput setab $BCOLOR3) DATEINAME $(tput sgr $OMCOFF) - Konfigurationszeile schreiben."
	echo "conf_delete	- $(tput setab $BCOLOR5) SUCHWORT $(tput sgr $OMCOFF) $(tput setab $BCOLOR4) PFAD $(tput sgr $OMCOFF) $(tput setab $BCOLOR2) DATEINAME $(tput sgr $OMCOFF) - Konfigurationszeile löschen."
	echo "conf_read	- $(tput setab $BCOLOR5) SUCHWORT $(tput sgr $OMCOFF) $(tput setab $BCOLOR4) PFAD $(tput sgr $OMCOFF) $(tput setab $BCOLOR2) DATEINAME $(tput sgr $OMCOFF) - Konfigurationszeile lesen."
	echo "landclear 	- $(tput setab $BCOLOR5)screen_name$(tput sgr $OMCOFF) $(tput setab $BCOLOR4)Regionsname$(tput sgr $OMCOFF) - Land clear - Löscht alle Parzellen auf dem Land."

	echo " "
	echo "loadinventar - $(tput setab $BCOLOR5)NAME VERZEICHNIS PASSWORD DATEINAMEmitPFAD $(tput sgr $OMCOFF) - lädt Inventar aus einer iar"
	echo "saveinventar - $(tput setab $BCOLOR5)NAME VERZEICHNIS PASSWORD DATEINAMEmitPFAD $(tput sgr $OMCOFF) - speichert Inventar in einer iar"

	echo "unlockexample	- $(tput setaf $COLOR3)hat keine Parameter$(tput sgr $OMCOFF) - Benennt alle example Dateien um."
	
	echo "passwdgenerator - $(tput setab $BCOLOR5)Passwortstärke$(tput sgr $OMCOFF) - Generiert ein Passwort zur weiteren verwendung."

	echo " "
	echo "$(tput setaf $COLOR3)  Der Verzeichnisname ist gleichzeitig auch der Screen Name!$(tput sgr $OMCOFF)"
	echo "$DATUM $(date +%H:%M:%S) HILFE: Hilfe wurde angefordert" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
}

### Funktion konsolenhilfe, konsolenhilfe auf dem Bildschirm anzeigen.
function konsolenhilfe()
{
	echo "$(tput setab $BCOLOR5)Funktion:$(tput sgr $OMCOFF) $(tput setab $BCOLOR4)Informationen:$(tput sgr $OMCOFF)"
	echo "Tab - Dateien und Ordnernamen automatisch vervollständigen."
	echo "Strg + W - Löscht das word vor dem Cursor."
	echo "Strg + K - Löscht die Zeile hinter dem Cursor."
	echo "Strg + T - Vertauscht die letzten beiden Zeichen vor dem Cursor."
	echo "Esc + T - Vertauscht die letzten beiden Wörter vor dem Cursor."
	echo "Alt + F - Bewegt den Cursor Wortweise vorwährts."
	echo "Alt + B - Bewegt den Cursor Wortweise rückwärts."
	echo "Strg + A - Gehe zum Anfang der Zeile."
	echo "Strg + E - Zum Ende der Zeile gehen."
	echo "Strg + L - Bildschirm löschen."
	echo "Strg + U - Löscht die Zeile vor der cursor Position. Am Ende wird die gesamte Zeile gelöscht."
	echo "Strg + H - Wie Rücktaste"
	echo "Strg + R - Ermöglicht die Suche nach zuvor verwendeten Befehlen"
	echo "Strg + C - Beendet was auch immer gerade läuft."
	echo "Strg + D - Beendet Putty oder Xterm."
	echo "Strg + Z - Setzt alles, was Sie ausführen, in einen angehaltenen Hintergrundprozess."

	echo "$DATUM $(date +%H:%M:%S) HILFE: Konsolenhilfe wurde angefordert" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
}


function commandhelp()
{
cat << eof
$(tput setab $BCOLOR1)
Help OpenSim Commands:
Aufruf: oscommand Screen Region "Befehl mit Parameter in Hochstrichen"
Beispiel: /opt/opensim.sh oscommand sim1 Welcome "alert Hallo liebe Leute dies ist eine Nachricht"
$(tput sgr $OMCOFF)

$(tput setab $BCOLOR1)A$(tput sgr $OMCOFF)
alert <Nachricht> - sendet eine Nachricht an alle.
alert-user <Vorname> <Nachname> <Nachricht> - sendet eine Nachricht an eine bestimmte Person. 
appearance find <uuid-oder-start-der-uuid> - herausfinden welcher Avatar das angegebene Asset als gebackene Textur verwendet, falls vorhanden.
appearance rebake <Vorname> <Nachname> - Sendet eine Anfrage an den Viewer des Benutzers, damit er seine Aussehenstexturen neu backen und hochladen kann.
appearance send <Vorname> <Nachname> - Sendet Aussehensdaten für jeden Avatar im Simulator an andere Viewer. 

$(tput setab $BCOLOR1)B$(tput sgr $OMCOFF)
backup - Das momentan nicht gespeicherte Objekt wird sofort geändert, anstatt auf den normalen Speicheraufruf zu warten.
bypass permissions <true / false> - Berechtigungsprüfungen umgehen.

$(tput setab $BCOLOR1)C$(tput sgr $OMCOFF)
change region <Regionsname> - Ändere die aktuelle Region in der Konsole.
clear image queues <Vorname> <Nachname> - Löscht die Bildwarteschlangen (über UDP heruntergeladene Texturen) für einen bestimmten Client.
command-script <Skript> - Ausführen eines Befehlsskripts aus einer Datei.
config save <Pfad> - Speichert die aktuelle Konfiguration in einer Datei unter dem angegebenen Pfad.
config set <Sektion> <key> <value> - Legt eine Konfigurationsoption fest. Dies ist in den meisten Fällen nicht sinnvoll, da geänderte Parameter nicht dynamisch nachgeladen werden. Geänderte Parameter bleiben auch nicht bestehen - Sie müssen eine Konfigurationsdatei manuell ändern und neu starten.
create region ["Regionsname"] <Regionsdatei.ini> - Erstellt eine neue Region. 

$(tput setab $BCOLOR1)D$(tput sgr $OMCOFF)
debug attachments log [0|1] - Debug Protokollierung für Anhänge aktivieren.
debug eq [0|1|2] - Aktiviert das Debuggen der Ereigniswarteschlange.
  <= 0 - deaktiviert die gesamte Protokollierung der Ereigniswarteschlange.
  >= 1 - aktiviert die Einrichtung der Ereigniswarteschlange und die Protokollierung ausgehender Ereignisse.
  >= 2 - schaltet die Umfragebenachrichtigung ein.
debug groups messaging verbose <true|false> - Diese Einstellung aktiviert das Debuggen von sehr ausführlichen Gruppennachrichten.
debug groups verbose <true|false> – Diese Einstellung aktiviert das Debuggen von sehr ausführlichen Gruppen.
debug http <in|out|all> [<level>] - Aktiviert die Protokollierung von HTTP-Anfragen.
debug jobengine <start|stop|status|log> - Start, Stopp, Status abrufen oder Logging Level der Job-Engine festlegen.
debug permissions <true / false> - Berechtigungs Debugging aktivieren.
debug scene get - Listet die aktuellen Szenenoptionen auf.
debug scene set <param> <value> - Aktiviert die Debugging-Optionen für die Szene.
debug threadpool level 0..3 - Aktiviert die Protokollierung der Aktivität im Hauptthreadpool.
debug threadpool set worker|iocp min|max <n> - Legt die Threadpool-Parameter fest. Für Debugzwecke.
delete object creator <UUID> - Szenenobjekte nach Ersteller löschen.
delete object id <UUID-or-localID> - Löschen eines Szenenobjekts nach uuid oder localID.
delete object name [--regex] <name> - Löscht ein Szenenobjekt nach Namen.
delete object outside - Alle Szenenobjekte außerhalb der Regionsgrenzen löschen.
delete object owner <UUID> - Szenenobjekte nach Besitzer löschen.
delete object pos <start x, start y , start z> <end x, end y, end z> - Löscht Szenenobjekte innerhalb des angegebenen Volumens.
delete-region <name> - Löschen einer Region von der Festplatte.
dump asset <id> - Ein Asset ausgeben.
dump object id <UUID-oder-localID> - Dump der formatierten Serialisierung des angegebenen Objekts in die Datei <UUID>.xml 
 
$(tput setab $BCOLOR1)E$(tput sgr $OMCOFF)
edit scale <name> <x> <y> <z> - Ändert die Größe des benannten Prim.
estate create <owner UUID> <estate name> - Erstellt ein neues Anwesen mit dem angegebenen Namen, das dem angegebenen Benutzer gehört. Der Name des Anwesens muss eindeutig sein.
estate link region <estate ID> <region ID> - Hängt die angegebene Region an die angegebene Domain an.
estate set name <estate-id> <new name> - Setzt den Namen des angegebenen Anwesens auf den angegebenen Wert. Der neue Name muss eindeutig sein.
estate set owner <estate-id>[ <UUID> | <Vorname> <Nachname> ] - Setzt den Besitzer des angegebenen Anwesens auf die angegebene UUID oder den angegebenen Benutzer.
export-map [<Pfad>] - Speichert ein Bild der Karte.

$(tput setab $BCOLOR1)F$(tput sgr $OMCOFF)
fcache assets - Versucht alle Assets in allen Szenen gründlich zu scannen und zwischenzuspeichern.
fcache cachedefaultassets - lädt lokale Standardassets in den Cache. Dies kann Rasterfelder überschreiben, mit Vorsicht verwenden.
fcache clear [file] [memory] - Entfernt alle Assets im Cache. Wenn Datei oder Speicher angegeben ist, wird nur dieser Cache geleert.
fcache deletedefaultassets - löscht standardmäßige lokale Assets aus dem Cache, damit sie aus dem Raster aktualisiert werden können, mit Vorsicht verwenden.
fcache expire <datetime(mm/dd/YYYY)> - Löscht zwischengespeicherte Assets, die älter als das angegebene Datum oder die angegebene Uhrzeit sind.
force gc - Ruft die Garbage Collection zur Laufzeit manuell auf. Für Debugging-Zwecke.
force permissions <true / false> - Berechtigungen ein- oder ausschalten.
force update - Erzwinge die Aktualisierung aller Objekte auf Clients.

$(tput setab $BCOLOR1)G$(tput sgr $OMCOFF)
generate map - Erzeugt und speichert ein neues Kartenstück.

$(tput setab $BCOLOR1)J$(tput sgr $OMCOFF)
j2k decode <ID> - Führt die JPEG2000 Decodierung eines Assets durch.

$(tput setab $BCOLOR1)K$(tput sgr $OMCOFF)
kick user <first> <last> [--force] [message] - Einen Benutzer aus dem Simulator werfen.

$(tput setab $BCOLOR1)L$(tput sgr $OMCOFF)
land clear - Löscht alle Parzellen aus der Region.
link-mapping [<x> <y>] - Stellt lokale Koordinaten ein, um HG Regionen abzubilden.
link-region <Xloc> <Yloc> <ServerURI> [<RemoteRegionName>] - Verknüpft eine HyperGrid Region.
load iar [-m|--merge] <first> <last> <inventory path> <password> [<IAR path>] - Benutzerinventararchiv (IAR) laden.
load oar [-m|--merge] [-s|--skip-assets] [--default-user "User Name"] [--merge-terrain] [--merge-parcels] [--mergeReplaceObjects] [--no-objects] [--rotation degrees] [--bounding-origin "<x,y,z>"] [--bounding-size "<x,y,z>"] [--displacement "<x,y,z>"] [-d|--debug] [<OAR path>] - Laden der Daten einer Region aus einem OAR Archiv.
load xml [<file name> [-newUID [<x> <y> <z>]]] - Laden der Daten einer Region aus dem XML-Format.
load xml2 [<file name>] - Laden Sie die Daten einer Region aus dem XML2-Format.
login disable - Simulator Logins deaktivieren.
login enable - Simulator Logins aktivieren.

$(tput setab $BCOLOR1)P$(tput sgr $OMCOFF)
physics set <param> [<value>|TRUE|FALSE] [localID|ALL] - Setzt Physikparameter aus der aktuell ausgewählten Region.

$(tput setab $BCOLOR1)Q$(tput sgr $OMCOFF)
quit - Beenden Sie die Anwendung.

$(tput setab $BCOLOR1)R$(tput sgr $OMCOFF)
region restart abort [<message>] - Einen Neustart der Region abbrechen.
region restart bluebox <message> <delta seconds>+ - Planen eines Regionsneustart.
region restart notice <message> <delta seconds>+ - Planen eines Neustart der Region.
region set - Stellt Steuerinformationen für die aktuell ausgewählte Region ein.
remove-region <name> - Entferne eine Region aus diesem Simulator.
reset user cache - Benutzercache zurücksetzen, damit geänderte Einstellungen übernommen werden können.
restart - Startet die aktuell ausgewählte(n) Region(en) in dieser Instanz neu.
rotate scene <degrees> [centerX, centerY] - Dreht alle Szenenobjekte um centerX, centerY (Standard 128, 128) (bitte sichern Sie Ihre Region vor der Verwendung).

$(tput setab $BCOLOR1)S$(tput sgr $OMCOFF)
save iar [-h|--home=<url>] [--noassets] <first> <last> <inventory path> <password> [<IAR path>] [-c|--creators] [-e|--exclude=<name/uuid>] [-f|--excludefolder=<foldername/uuid>] [-v|--verbose] - Benutzerinventararchiv (IAR) speichern.
save oar [-h|--home=<url>] [--noassets] [--publish] [--perm=<permissions>] [--all] [<OAR path>] - Speichert die Daten einer Region in ein OAR-Archiv.
save prims xml2 [<prim name> <file name>] - Speichern Sie das benannte Prim in XML2
save xml [<file name>] - Speichern Sie die Daten einer Region im XML-Format
save xml2 [<file name>] - Speichern Sie die Daten einer Region im XML2-Format
scale scene <factor> - Skaliert die Szenenobjekte (bitte sichern Sie Ihre Region vor der Verwendung)
set log level <level> - Legt die Konsolenprotokollierungsebene für diese Sitzung fest.
set terrain heights <corner> <min> <max> [<x>] [<y>] - Setzt die Terrain Texturhöhen an Ecke #<corner> auf <min>/<max>, wenn <x> oder <y > angegeben sind, wird es nur auf Regionen mit einer übereinstimmenden Koordinate gesetzt. Geben Sie -1 in <x> oder <y> an, um diese Koordinate mit Platzhaltern zu versehen. Ecke # SW = 0, NW = 1, SE = 2, NE = 3, alle Ecken = -1.
set terrain texture <number> <uuid> [<x>] [<y>] - Setzt das Terrain <number> auf <uuid>, wenn <x> oder <y> angegeben ist, wird es nur auf Regionen mit . gesetzt eine passende Koordinate. Geben Sie -1 in <x> oder <y> an, um diese Koordinate mit Platzhaltern zu versehen.
set water height <height> [<x>] [<y>] - Legt die Wasserhöhe in Metern fest. Wenn <x> und <y> angegeben sind, wird es nur auf Regionen mit einer übereinstimmenden Koordinate gesetzt. Geben Sie -1 in <x> oder <y> an, um diese Koordinate mit Platzhaltern zu versehen.
shutdown - Beendet die Anwendung
sit user name [--regex] <first-name> <last-name> - Setzet den benannten Benutzer auf ein unbesetztes Objekt mit einem Sit-Target.
stand user name [--regex] <first-name> <last-name> - Nutzer zum aufstehen zwingen.
stats record start|stop - Steuert ob Statistiken regelmäßig in einer separaten Datei aufgezeichnet werden.
stats save <path> - Statistik Snapshot in einer Datei speichern. Wenn die Datei bereits existiert, wird der Bericht angehängt.

$(tput setab $BCOLOR1)T$(tput sgr $OMCOFF)
teleport user <first-name> <last-name> <destination> - Teleportiert einen Benutzer in diesem Simulator zum angegebenen Ziel.
terrain load - Lädt ein Terrain aus einer angegebenen Datei.
terrain load-tile - Lädt ein Terrain aus einem Abschnitt einer größeren Datei.
terrain save - Speichert die aktuelle Heightmap in einer bestimmten Datei.
terrain save-tile - Speichert die aktuelle Heightmap in der größeren Datei.
terrain fill - Füllt die aktuelle Heightmap mit einem bestimmten Wert.
terrain elevate - Erhöht die aktuelle Heightmap um den angegebenen Betrag.
terrain lower - Senkt die aktuelle Höhenmap um den angegebenen Wert.
terrain multiply - Multipliziert die Heightmap mit dem angegebenen Wert.
terrain bake - Speichert das aktuelle Terrain in der Regions-Back-Map.
terrain revert - Lädt das gebackene Kartengelände in die Regions-Höhenmap.
terrain newbrushes - Aktiviert experimentelle Pinsel, die die Standard-Terrain-Pinsel ersetzen. WARNUNG: Dies ist eine Debug-Einstellung und kann jederzeit entfernt werden.
terrain show - Zeigt die Geländehöhe an einer bestimmten Koordinate an.
terrain stats - Zeigt Informationen über die Regions-Heightmap für Debugging-Zwecke an.
terrain effect - Führt einen angegebenen Plugin-Effekt aus.
terrain flip - Flippt das aktuelle Gelände um die X- oder Y-Achse.
terrain rescale - Skaliert das aktuelle Terrain so, dass es zwischen die angegebenen Min- und Max-Höhen passt
terrain min - Legt die minimale Geländehöhe auf den angegebenen Wert fest.
terrain max - Legt die maximale Geländehöhe auf den angegebenen Wert fest.
translate scene <x,y,z> - Verschiebe die gesamte Szene in eine neue Koordinate. Nützlich zum Verschieben einer Szene an einen anderen Ort in einem Mega- oder variablen Bereich.
tree active - Aktivitätsstatus für das Baummodul ändern.
tree freeze - einfrieren und weiterbauen eines Waldes.
tree load - Laden Sie eine Wald-Definition aus einer XML-Datei.
tree plant - Beginn mit dem bepflanzen eines Waldes.
tree rate - Zurücksetzen der Baumaktualisierungsrate (mSec).
tree reload - Erneutes Laden von Copse-Definitionen aus den In-Scene-Bäumen.
tree remove - Entfert eine Wald-Definition und alle ihrer bereits gepflanzten Bäume.
tree statistics - Log-Statistik über die Bäume.

$(tput setab $BCOLOR1)U$(tput sgr $OMCOFF)
unlink-region <local name> - Verknüpfung einer Hypergrid-Region aufheben

$(tput setab $BCOLOR1)V$(tput sgr $OMCOFF)
vivox debug <on>|<off> - Einstellen des vivox-Debuggings

$(tput setab $BCOLOR1)W$(tput sgr $OMCOFF)
wind base wind_update_rate [<value>] - Abrufen oder Festlegen der Windaktualisierungsrate.
wind ConfigurableWind avgDirection [<value>] - durchschnittliche Windrichtung in Grad.
wind ConfigurableWind avgStrength [<value>] - durchschnittliche Windstärke.
wind ConfigurableWind rateChange [<value>] - Änderungsrate.
wind ConfigurableWind varDirection [<value>] - zulässige Abweichung der Windrichtung in +/- Grad.
wind ConfigurableWind varStrength [<value>] - zulässige Abweichung der Windstärke.
wind SimpleRandomWind strength [<value>] - Windstärke.

eof

echo "$DATUM $(date +%H:%M:%S) HILFE: Commands Hilfe wurde angefordert" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
}

###########################################################################
# Menu
###########################################################################

function hauptmenu()
{
	HEIGHT=0
	WIDTH=0
	CHOICE_HEIGHT=30
    BACKTITLE="opensimMULTITOOL"
    TITLE="Hauptmenu"
    MENU="opensimMULTITOOL $VERSION"
	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null|grep -q installed; then
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
		"Informationen" ""	
		"Screen Liste" ""
		"Server laufzeit und Neustart" ""
		"--------------------------" ""
		"Passwortgenerator" ""
		"Kalender" ""
		"--------------------------" ""
		"Weitere Funktionen" ""
		"Dateimennu" ""
		"Experten Funktionen" "")
		
		mauswahl=$(dialog --backtitle "$BACKTITLE" --title "$TITLE" --help-button --defaultno --menu "$MENU" $HEIGHT $WIDTH $CHOICE_HEIGHT "${OPTIONS[@]}" 2>&1 >/dev/tty)
		antwort=$?
		dialog --clear
		clear

		if [[ $mauswahl = "OpenSim Autostart" ]]; then menuautostart; fi
		if [[ $mauswahl = "OpenSim Autostopp" ]]; then menuautostop; fi
		if [[ $mauswahl = "OpenSim Restart" ]]; then menuautorestart; fi

		if [[ $mauswahl = "Einzelner Simulator Stop" ]]; then menuosstop; fi
		if [[ $mauswahl = "Einzelner Simulator Start" ]]; then menuosstart; fi
		#if [[ $mauswahl = "Einzelner Simulator Status" ]]; then menuworks; fi		
		#if [[ $mauswahl = "Alle Simulatoren Status" ]]; then menuwaslauft; fi
		if [[ $mauswahl = "Informationen" ]]; then menuinfo; fi

		if [[ $mauswahl = "Screen Liste" ]]; then screenlist; fi
		if [[ $mauswahl = "Parzellen entfernen" ]]; then menulandclear; fi
		if [[ $mauswahl = "Objekt entfernen" ]]; then menuassetdel; fi
		if [[ $mauswahl = "Benutzer Account anlegen" ]]; then menucreateuser; fi
		if [[ $mauswahl = "Server laufzeit und Neustart" ]]; then rebootdatum; fi		

		if [[ $mauswahl = "Passwortgenerator" ]]; then passwdgenerator; fi
		if [[ $mauswahl = "Kalender" ]]; then kalender; fi
		
		if [[ $mauswahl = "Dateimennu" ]]; then dateimenu; fi
		if [[ $mauswahl = "Weitere Funktionen" ]]; then funktionenmenu; fi
		if [[ $mauswahl = "Experten Funktionen" ]]; then expertenmenu; fi

		if [[ $antwort = 2 ]]; then hilfemenu ; fi
		if [[ $antwort = 1 ]]; then exit ; fi
	else
		# wenn dialog nicht installiert ist die Hilfe anzeigen.
		hilfe
	fi
}

function hilfemenu()
{
	HEIGHT=0
	WIDTH=45
	CHOICE_HEIGHT=30
    BACKTITLE="opensimMULTITOOL"
    TITLE="Hilfemenu"
    MENU="opensimMULTITOOL $VERSION"

	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null|grep -q installed; then
		OPTIONS=("Hilfe" ""
		"Konsolenhilfe" ""
		"Kommandohilfe" ""
		"Konfiguration lesen" ""
		"Hauptmenu" "")

		hauswahl=$(dialog --clear \
                    --backtitle "$BACKTITLE" \
                    --title "$TITLE" \
					--help-button --defaultno \
                    --menu "$MENU" \
                    $HEIGHT $WIDTH $CHOICE_HEIGHT \
                    "${OPTIONS[@]}" \
                    2>&1 >/dev/tty) # 3>&1 1>&2 2>&3

		antwort=$?
		dialog --clear
		clear

		if [[ $hauswahl = "Hilfe" ]]; then hilfe; fi
		if [[ $hauswahl = "Konsolenhilfe" ]]; then menukonsolenhilfe; fi # Test menukonsolenhilfe
		if [[ $hauswahl = "Kommandohilfe" ]]; then commandhelp; fi
		if [[ $hauswahl = "Konfiguration lesen" ]]; then menuoswriteconfig; fi
		
		if [[ $hauswahl = "Hauptmenu" ]]; then hauptmenu; fi
		if [[ $antwort = 1 ]]; then hauptmenu ; fi
	else
		# wenn dialog nicht installiert ist die Hilfe anzeigen.
		hilfe
	fi
}

function funktionenmenu()
{
	HEIGHT=0
	WIDTH=45
	CHOICE_HEIGHT=30
    BACKTITLE="opensimMULTITOOL"
    TITLE="Funktionsmenu"
    MENU="opensimMULTITOOL $VERSION"

	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null|grep -q installed; then
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
		"--------------------------" ""
		"Hauptmennu" ""
		"Dateimennu" ""
		"Experten Funktionen" "")

		fauswahl=$(dialog --clear \
                    --backtitle "$BACKTITLE" \
                    --title "$TITLE" \
					--help-button --defaultno \
                    --menu "$MENU" \
                    $HEIGHT $WIDTH $CHOICE_HEIGHT \
                    "${OPTIONS[@]}" \
                    2>&1 >/dev/tty) # 3>&1 1>&2 2>&3

		antwort=$?
		dialog --clear
		clear

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
		if [[ $fauswahl = "Hauptmennu" ]]; then hauptmenu; fi
		if [[ $fauswahl = "Experten Funktionen" ]]; then expertenmenu; fi

		if [[ $antwort = 2 ]]; then hilfemenu ; fi
		if [[ $antwort = 1 ]]; then exit ; fi
	else
		# wenn dialog nicht installiert ist die Hilfe anzeigen.
		hilfe
	fi
}

function dateimenu()
{
	HEIGHT=0
	WIDTH=45
	CHOICE_HEIGHT=30
    BACKTITLE="opensimMULTITOOL"
    TITLE="Dateimenu"
    MENU="opensimMULTITOOL $VERSION"

	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null|grep -q installed; then
		OPTIONS=("Inventar speichern" ""
		"Inventar laden" ""
		"Region OAR sichern" ""
		"--------------------------" ""
		"Log Dateien löschen" ""
		"Map Karten löschen" ""
		"Asset loeschen" ""
		"--------------------------" ""
		"OpenSim herunterladen" ""
		"MoneyServer vom git kopieren" ""
		"OSSL Skripte vom git kopieren" ""
		"Configure vom git kopieren" ""		
		"Opensim vom Github holen" ""
		"--------------------------" ""
		"Verzeichnisstrukturen anlegen" ""		
		"--------------------------" ""
		"Hauptmenu" ""
		"Weitere Funktionen" ""
		"Experten Funktionen" "")

		dauswahl=$(dialog --clear \
                    --backtitle "$BACKTITLE" \
                    --title "$TITLE" \
					--help-button --defaultno \
                    --menu "$MENU" \
                    $HEIGHT $WIDTH $CHOICE_HEIGHT \
                    "${OPTIONS[@]}" \
                    2>&1 >/dev/tty) # 3>&1 1>&2 2>&3

		antwort=$?
		dialog --clear
		clear

		if [[ $dauswahl = "Inventar speichern" ]]; then menusaveinventar; fi
		if [[ $dauswahl = "Inventar laden" ]]; then menuloadinventar; fi
		if [[ $dauswahl = "Region OAR sichern" ]]; then menuregionbackup; fi
		if [[ $dauswahl = "OpenSim herunterladen" ]]; then downloados; fi
		if [[ $dauswahl = "Log Dateien löschen" ]]; then autologdel; fi
		if [[ $dauswahl = "Map Karten löschen" ]]; then automapdel; fi
		if [[ $dauswahl = "MoneyServer vom git kopieren" ]]; then moneygitcopy; fi
		if [[ $dauswahl = "OSSL Skripte vom git kopieren" ]]; then scriptgitcopy; fi
		if [[ $dauswahl = "Configure vom git kopieren" ]]; then configuregitcopy; fi
		if [[ $dauswahl = "Opensim vom Github holen" ]]; then osgitholen; fi
		if [[ $dauswahl = "Verzeichnisstrukturen anlegen" ]]; then menuosstruktur; fi

		if [[ $dauswahl = "Asset loeschen" ]]; then menuassetdel; fi
		
		if [[ $dauswahl = "Hauptmenu" ]]; then hauptmenu; fi
		if [[ $dauswahl = "Weitere Funktionen" ]]; then funktionenmenu; fi
		if [[ $dauswahl = "Experten Funktionen" ]]; then expertenmenu; fi

		if [[ $antwort = 2 ]]; then hilfemenu ; fi
		if [[ $antwort = 1 ]]; then exit ; fi
	else
		# wenn dialog nicht installiert ist die Hilfe anzeigen.
		hilfe
	fi
}

function expertenmenu()
{
	HEIGHT=0
	WIDTH=45
	CHOICE_HEIGHT=30
    BACKTITLE="opensimMULTITOOL"
    TITLE="Expertenmenu"
    MENU="opensimMULTITOOL $VERSION"

	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null|grep -q installed; then
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
		"Server Installation für WordPress" ""
		"Server Installation ohne mono" ""
		"Mono Installation" ""
		"--------------------------" ""
		"terminator" ""
		"makeaot" ""
		"cleanaot" ""
		"Installationen anzeigen" ""
		"--------------------------" ""
		"Kommando an OpenSim senden" ""
		"--------------------------" ""
		"Hauptmennu" ""
		"Dateimennu" ""
		"Weitere Funktionen" "")

		feauswahl=$(dialog --clear \
                    --backtitle "$BACKTITLE" \
                    --title "$TITLE" \
					--help-button --defaultno \
                    --menu "$MENU" \
                    $HEIGHT $WIDTH $CHOICE_HEIGHT \
                    "${OPTIONS[@]}" \
                    2>&1 >/dev/tty)

		antwort=$?
		dialog --clear
		clear

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
		if [[ $feauswahl = "Server Installation für WordPress" ]]; then installwordpress; fi
		if [[ $feauswahl = "Server Installation ohne mono" ]]; then installobensimulator; fi
		if [[ $feauswahl = "Mono Installation" ]]; then monoinstall; fi

		if [[ $feauswahl = "Hilfe" ]]; then hilfemenu; fi
		
		if [[ $fauswahl = "Dateimennu" ]]; then dateimenu; fi
		if [[ $feauswahl = "Hauptmennu" ]]; then hauptmenu; fi
		if [[ $feauswahl = "Weitere Funktionen" ]]; then funktionenmenu; fi

		if [[ $antwort = 2 ]]; then hilfemenu ; fi
		if [[ $antwort = 1 ]]; then exit ; fi
	else
		# wenn dialog nicht installiert ist die Hilfe anzeigen.
		hilfe
	fi
}

###########################################################################
# Eingabeauswertung
###########################################################################
case  $KOMMANDO  in
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
	s | settings)	ossettings ;;
	rs | robuststart | rostart) rostart ;;
	ms | moneystart | mostart) mostart ;;
	rsto | robuststop | rostop) rostop ;;
	mstop | moneystop | mostop) mostop ;;
	osto | osstop) osstop "$2" ;;
	osta | osstart) osstart "$2" ;;
	gsta | gridstart) gridstart ;;
	gsto | gridstop) gridstop ;;
	sd | screendel)	autoscreenstop ;;
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
	createuser) createuser "$2" "$3" "$4" "$5" ;;
	db_anzeigen) db_anzeigen "$2" "$3" ;;
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
	autoconfig) autoconfig ;;
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
	*) hauptmenu ;;
esac

echo "$DATUM $(date +%H:%M:%S) opensimMULTITOOL wurde beendet." >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
echo "#######################################################" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
vardel
