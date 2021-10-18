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

### myshellschreck, ShellCheck ueberlisten, hat sonst keinerlei Funktion und wird auch nicht aufgerufen.
function myshellschreck()
{
STARTVERZEICHNIS="opt" MONEYVERZEICHNIS="robust" ROBUSTVERZEICHNIS="robust" OPENSIMVERZEICHNIS="opensim" SCRIPTSOURCE="ScriptNeu" MONEYSOURCE="money48" OSVERSION="opensim-0.9.2.0Dev"
REGIONSDATEI="RegionList.ini" SIMDATEI="SimulatorList.ini" WARTEZEIT=30 STARTWARTEZEIT=10 STOPWARTEZEIT=30 MONEYWARTEZEIT=50 BACKUPWARTEZEIT=120 AUTOSTOPZEIT=60 SETMONOTHREADS=800 SETMONOTHREADSON="yes"
OPENSIMDOWNLOAD="http://opensimulator.org/dist/" OPENSIMVERSION="opensim-0.9.1.1.zip" SEARCHADRES="icanhazip.com" AUTOCONFIG="no" SETMONOGCPARAMSON="yes"
}
VERSION="V0.50.193" # opensimMULTITOOL Versionsausgabe
clear # Bildschirm loeschen

# LOGO
echo "$(tput setaf 4)   ____                        _____  _                    _         _               "     
echo "  / __ \                      / ____|(_)                  | |       | |              "
echo " | |  | | _ __    ___  _ __  | (___   _  _ __ ___   _   _ | |  __ _ | |_  ___   _ __ "
echo " | |  | ||  _ \  / _ \|  _ \  \___ \ | ||  _   _ \ | | | || | / _  || __|/ _ \ |  __|"
echo "$(tput setaf 2) | |__| || |_) ||  __/| | | | ____) || || | | | | || |_| || || (_| || |_| (_) || |   "
echo "  \____/ |  __/  \___||_| |_||_____/ |_||_| |_| |_| \____||_| \____| \__|\___/ |_|   "
echo "         | |                                                                         "
echo "         |_|                                                                         "
echo "	    $(tput setaf 2)opensim$(tput setaf 4)MULTITOOL$(tput sgr 0) $VERSION" # Versionsausgabe
echo " "

# Datum und Uhrzeit
DATUM=$(date +%d.%m.%Y)
DATEIDATUM=$(date +%d_%m_%Y)
echo "Datum: $DATUM Uhrzeit: $(date +%H:%M:%S)"
echo "Abbruch mit STRG und C"
echo " "

### Alte Variablen loeschen aus eventuellen voherigen sessions ###
unset STARTVERZEICHNIS
unset MONEYVERZEICHNIS
unset ROBUSTVERZEICHNIS
unset OPENSIMVERZEICHNIS
unset SCRIPTSOURCE
unset MONEYSOURCE
unset REGIONSNAME
unset REGIONSNAMEb
unset REGIONSNAMEc
unset REGIONSNAMEd

### Einstellungen aus opensim.cnf laden ###
# Warum? ganz einfach bei einem Script upgrade gehen so die einstellungen nicht mehr verloren.

# Pfad des opensim.sh Skriptes herausfinden
SCRIPTPATH=$(cd "$(dirname "$0")" && pwd)
# Variablen aus config Datei laden opensim.cnf muss sich im gleichen Verzeichnis wie opensim.sh befinden.
# shellcheck disable=SC1091
# shellcheck source=opensim.cnf
. "$SCRIPTPATH"/opensim.cnf

# Aktuelle IP über Suchadresse ermitteln und Ausführungszeichen anhängen.
AKTUELLEIP='"'$(wget -O - -q $SEARCHADRES)'"'

## Farben Color
Red=1; Green=2; Yello=3; Blue=4; Magenta=5; White=7

cd /"$STARTVERZEICHNIS" || return 1 # gibt es das Startverzeichnis wenn nicht abbruch.
sleep 1
KOMMANDO=$1 # Eingabeauswertung

# Kopfzeile der log Datei.
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
		echo " "
	} >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	fi
}

# Kopfzeile in die Log Datei schreiben.
schreibeinfo

### Funktion vardel, Variablen loeschen.
function vardel()
{	unset STARTVERZEICHNIS; unset MONEYVERZEICHNIS; unset ROBUSTVERZEICHNIS
	unset WARTEZEIT; unset STARTWARTEZEIT; unset STOPWARTEZEIT
	unset MONEYWARTEZEIT; unset Red; unset Green; unset White
	unset NAME; unset VERZEICHNIS; unset PASSWORD; unset DATEI
	unset OPENSIMVERZEICHNIS; unset SCRIPTSOURCE; unset MONEYSOURCE
	unset REGIONSNAME; unset REGIONSNAMEb; unset REGIONSNAMEc; unset REGIONSNAMEd
}

### Erstellen eines Arrays aus einer Textdatei - Verzeichnisse und Regionen ###
function makeverzeichnisliste() 
{
	VERZEICHNISSLISTE=()
	while IFS= read -r line; do
	VERZEICHNISSLISTE+=("$line")
	done < /$STARTVERZEICHNIS/$SIMDATEI
	# Anzahl der Eintraege.
	ANZAHLVERZEICHNISSLISTE=${#VERZEICHNISSLISTE[*]}
}

function makeregionsliste() 
{
	REGIONSLISTE=()
	while IFS= read -r line; do
	REGIONSLISTE+=("$line")
	done < /$STARTVERZEICHNIS/$REGIONSDATEI
	# Anzahl der Eintraege.    
	ANZAHLREGIONSLISTE=${#REGIONSLISTE[*]}
}

### Funktion assetdel, Asset von der Region loeschen.
# Aufruf: assetdel screen_name Regionsname Objektname
function assetdel()
{
	VERZEICHNISSCREEN=$1; REGION=$2; OBJEKT=$3
	# Nachschauen ob der Screen und die Region existiert.
	if screen -list | grep -q "$VERZEICHNISSCREEN"; then
		echo "$(tput setaf $Red) $(tput setab $White)$OBJEKT Asset von der Region $REGION löschen$(tput sgr 0)"
		screen -S "$VERZEICHNISSCREEN" -p 0 -X eval "stuff 'change region ""$REGION""'^M" # Region wechseln
		screen -S "$VERZEICHNISSCREEN" -p 0 -X eval "stuff 'alert "Loesche: "$OBJEKT" von der Region!"'^M" # Mit einer loesch Meldung
		screen -S "$VERZEICHNISSCREEN" -p 0 -X eval "stuff 'delete object name ""$OBJEKT""'^M" # Objekt loeschen
		screen -S "$VERZEICHNISSCREEN" -p 0 -X eval "stuff 'y'^M" # Mit y also yes bestaetigen
		echo "$DATUM $(date +%H:%M:%S) ASSETDEL: $OBJEKT Asset von der Region $REGION löschen" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	else
		echo "$(tput setaf $Red) $(tput setab $White)$OBJEKT Asset von der Region $REGION löschen fehlgeschlagen$(tput sgr 0)"
		echo "$DATUM $(date +%H:%M:%S) ASSETDEL: $OBJEKT Asset von der Region $REGION löschen fehlgeschlagen" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	fi
}

### Funktion landclear, Land clear - Löscht alle Parzellen auf dem Land. 
# Aufruf: landclear screen_name Regionsname Objektname
function landclear()
{
	VERZEICHNISSCREEN=$1; REGION=$2
	# Nachschauen ob der Screen und die Region existiert.
	if screen -list | grep -q "$VERZEICHNISSCREEN"; then
		echo "$(tput setaf $Red) $(tput setab $White)$OBJEKT Parzellen von der Region $REGION löschen$(tput sgr 0)"
		screen -S "$VERZEICHNISSCREEN" -p 0 -X eval "stuff 'change region ""$REGION""'^M" # Region wechseln
		screen -S "$VERZEICHNISSCREEN" -p 0 -X eval "stuff 'alert "Loesche Parzellen von der Region!"'^M" # Mit einer loesch Meldung
		screen -S "$VERZEICHNISSCREEN" -p 0 -X eval "stuff 'land clear'^M" # Objekt loeschen
		screen -S "$VERZEICHNISSCREEN" -p 0 -X eval "stuff 'y'^M" # Mit y also yes bestaetigen
		echo "$DATUM $(date +%H:%M:%S) LANDCLEAR: $OBJEKT Parzellen von der Region $REGION löschen" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	else
		echo "$(tput setaf $Red) $(tput setab $White)$OBJEKT Parzellen von der Region $REGION löschen fehlgeschlagen$(tput sgr 0)"
		echo "$DATUM $(date +%H:%M:%S) LANDCLEAR: $OBJEKT Parzellen von der Region $REGION löschen fehlgeschlagen" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	fi
}

### Funktion loadinventar, saveinventar
# Aufruf: load oder saveinventar "NAME" "VERZEICHNIS" "PASSWORD" "DATEImitPFAD"
function loadinventar()
{	
	VERZEICHNISSCREEN="sim1"; NAME=$1; VERZEICHNIS=$2; PASSWORD=$3; DATEI=$4
	if screen -list | grep -q "$VERZEICHNISSCREEN"; then
	echo "$(tput setab $Green)load iar $NAME $VERZEICHNIS ***** $DATEI $(tput sgr 0)"
	echo "$DATUM $(date +%H:%M:%S) OSCOMMAND: load iar $NAME $VERZEICHNIS ***** $DATEI " >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	screen -S "$VERZEICHNISSCREEN" -p 0 -X eval "stuff 'load iar $NAME $VERZEICHNIS $PASSWORD $DATEI'^M"
	else
		echo "Der Screen $VERZEICHNISSCREEN existiert nicht."
		echo "$DATUM $(date +%H:%M:%S) OSCOMMAND: Der Screen $VERZEICHNISSCREEN existiert nicht" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	fi
}
function saveinventar()
{	
	VERZEICHNISSCREEN="sim1"; NAME=$1; VERZEICHNIS=$2; PASSWORD=$3; DATEI=$4
	if screen -list | grep -q "$VERZEICHNISSCREEN"; then
	echo "$(tput setab $Green)save iar $NAME $VERZEICHNIS ***** $DATEI $(tput sgr 0)"
	echo "$DATUM $(date +%H:%M:%S) OSCOMMAND: save iar $NAME $VERZEICHNIS ***** $DATEI " >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	screen -S "$VERZEICHNISSCREEN" -p 0 -X eval "stuff 'save iar $NAME $VERZEICHNIS $PASSWORD $DATEI'^M"
	else
		echo "Der Screen $VERZEICHNISSCREEN existiert nicht."
		echo "$DATUM $(date +%H:%M:%S) OSCOMMAND: Der Screen $VERZEICHNISSCREEN existiert nicht" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	fi
}
### Funktion oscommand, OpenSim Command direkt in den screen senden.
# Aufruf: oscommand Screen Region Befehl Parameter
# Beispiel: /opt/opensim.sh oscommand sim1 Welcome "alert Hallo liebe Leute dies ist eine Nachricht"
# Beispiel: /opt/opensim.sh oscommand sim1 Welcome "alert-user John Doe Hallo John Doe"
function oscommand()
{	
	VERZEICHNISSCREEN=$1; REGION=$2; COMMAND=$3
	if screen -list | grep -q "$VERZEICHNISSCREEN"; then
	echo "$(tput setab $Green)Sende $COMMAND an $VERZEICHNISSCREEN $(tput sgr 0)"
	screen -S "$VERZEICHNISSCREEN" -p 0 -X eval "stuff 'change region ""$REGION""'^M" # Region wechseln
	echo "$DATUM $(date +%H:%M:%S) OSCOMMAND: $COMMAND an $VERZEICHNISSCREEN senden" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	screen -S "$VERZEICHNISSCREEN" -p 0 -X eval "stuff '$COMMAND'^M"
	else
		echo "Der Screen $VERZEICHNISSCREEN existiert nicht."
		echo "$DATUM $(date +%H:%M:%S) OSCOMMAND: Der Screen $VERZEICHNISSCREEN existiert nicht" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	fi
}

### Funktion works, screen pruefen ob er laeuft.
# Aufruf: works screen_name
function works()
{
	VERZEICHNISSCREEN=$1  # OpenSimulator, Verzeichnis und Screen Name
	if ! screen -list | grep -q "$VERZEICHNISSCREEN"; then
		# es laeuft nicht - not work
			echo "$(tput setaf $White)$(tput setab $Red) $VERZEICHNISSCREEN OFFLINE! $(tput sgr 0)"
			echo "$DATUM $(date +%H:%M:%S) WORKS: $VERZEICHNISSCREEN OFFLINE!" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
			return 1
		else
		# es laeuft - work
			echo "$(tput setaf $White)$(tput setab $Green) $VERZEICHNISSCREEN ONLINE! $(tput sgr 0)"
			echo "$DATUM $(date +%H:%M:%S) WORKS: $VERZEICHNISSCREEN ONLINE!" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
			return 0
	fi
}

### Funktion checkfile, pruefen ob Datei vorhanden ist.
# Aufruf: checkfile "pfad/name"
# Verwendung als Einzeiler: checkfile /pfad/zur/datei && echo "File exists" || echo "File not found!"
function checkfile 
{
	DATEINAME=$1
	[ -f "$DATEINAME" ]	
	return $?
}

### Funktion mapdel, loescht die Map-Karten.
# Aufruf: mapdel Verzeichnis
function mapdel()
{
	VERZEICHNIS=$1
	if [ -d "$VERZEICHNIS" ]; then
		echo "$(tput setaf $Red) $(tput setab $White)OpenSimulator maptile $VERZEICHNIS geloescht$(tput sgr 0)"
		cd /$STARTVERZEICHNIS/"$VERZEICHNIS"/bin || return 1
		rm -r maptiles/*
		echo "$DATUM $(date +%H:%M:%S) MAPDEL: OpenSimulator maptile $VERZEICHNIS geloescht" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	else
		echo "$(tput setaf $Red)maptile $VERZEICHNIS nicht gefunden $(tput sgr 0)"
		echo "$DATUM $(date +%H:%M:%S) MAPDEL: maptile $VERZEICHNIS nicht gefunden" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	fi
}

### Funktion logdel, loescht die Log Dateien.
# Aufruf: logdel Verzeichnis
function logdel()
{
	VERZEICHNIS=$1
	if [ -d "$VERZEICHNIS" ]; then
		echo "$(tput setaf $Red) $(tput setab $White)OpenSimulator log $VERZEICHNIS geloescht$(tput sgr 0)"
		rm /$STARTVERZEICHNIS/"$VERZEICHNIS"/bin/*.log
		echo "$DATUM $(date +%H:%M:%S) LOGDEL: OpenSimulator log $VERZEICHNIS geloescht" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	else
		echo "$(tput setaf $Red)logs nicht gefunden $(tput sgr 0)"
		echo "$DATUM $(date +%H:%M:%S) LOGDEL: logs nicht gefunden" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	fi
}

### Funktion ossettings, stellt den Linux Server fuer OpenSim ein.
function ossettings()
{
	# Hier kommen alle gewünschten Einstellungen rein.
	echo " "
	echo "$(tput setab $Green)Setze die Einstellungen neu! $(tput sgr 0)"

	# ulimit
	if [[ $SETULIMITON = "yes" ]]
	then
	echo "$DATUM $(date +%H:%M:%S) OSSETTINGS: Setze die Einstellung: ulimit -s 1048576" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	echo "Setze ulimit auf 1048576"
	ulimit -s 1048576
	fi

	# MONO_THREADS_PER_CPU
	if [[ $SETMONOTHREADSON = "yes" ]]
	then
	echo "$DATUM $(date +%H:%M:%S) OSSETTINGS: Setze die Mono Threads auf $SETMONOTHREADS" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	echo "Setze Mono Threads auf $SETMONOTHREADS"
	MONO_THREADS_PER_CPU=$SETMONOTHREADS
	fi

	# MONO_GC_PARAMS
	if [[ $SETMONOGCPARAMSON = "yes" ]]
	then
	echo "$DATUM $(date +%H:%M:%S) OSSETTINGS: Setze die Einstellung: minor=split,promotion-age=14,nursery-size=64m" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	echo "Setze Mono GC Parameter auf minor=split,promotion-age=14,nursery-size=64m"
	export MONO_GC_PARAMS="minor=split,promotion-age=14,nursery-size=64m"
	fi

	# Manual page auf Deutsch
	if [[ $SETMANUALPAGES = "yes" ]]
	then
	echo "$DATUM $(date +%H:%M:%S) OSSETTINGS: Setze manual pages auf Deutsch" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	echo "Setze manual pages auf Deutsch"
	alias man="man -L de_DE.utf8"
	fi

	# Zum schluss eine Leerzeile.
	echo " "
}

### Funktion screenlist, Laufende Screens auflisten und auch in die Log Datei schreiben.
function screenlist()
{
	echo "$(tput setaf $White)$(tput setab $Green) Alle laufende Screens anzeigen! $(tput sgr 0)"
	screen -ls
	echo "$DATUM $(date +%H:%M:%S) SCREENLIST: Alle laufende Screens anzeigen" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	screen -ls >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
}

### Funktion osstart, startet Region Server.
# osstart screen_name
# Beispiel-Example: /opt/opensim.sh osstart sim1
function osstart()
{
	VERZEICHNISSCREEN=$1 # OpenSimulator, Verzeichnis und Screen Name
	if [ -d "$VERZEICHNISSCREEN" ]; then
		
		cd /$STARTVERZEICHNIS/"$VERZEICHNISSCREEN"/bin || return 1

		# AOT Aktiveren oder Deaktivieren.
		if [[ $SETAOTON = "yes" ]]
		then
			echo "$(tput setaf 2) $(tput setab $White)OpenSimulator $VERZEICHNISSCREEN Starten aot $(tput sgr 0)"
			echo "$DATUM $(date +%H:%M:%S) OSSTART: OpenSimulator $VERZEICHNISSCREEN Starten aot" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
			screen -fa -S "$VERZEICHNISSCREEN" -d -U -m mono --desktop -O=all OpenSim.exe
		else
			echo "$(tput setaf 2) $(tput setab $White)OpenSimulator $VERZEICHNISSCREEN Starten$(tput sgr 0)"
			echo "$DATUM $(date +%H:%M:%S) OSSTART: OpenSimulator $VERZEICHNISSCREEN Starten" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
			screen -fa -S "$VERZEICHNISSCREEN" -d -U -m mono OpenSim.exe
		fi		
		sleep 10
	else
		echo "$(tput setaf $Red) $(tput setab $White)OpenSimulator $VERZEICHNISSCREEN nicht vorhanden$(tput sgr 0)"
		echo "$DATUM $(date +%H:%M:%S) OSSTART: OpenSimulator $VERZEICHNISSCREEN nicht vorhanden" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	fi
	return
}

### Funktion osstop, stoppt Region Server.
# Beispiel-Example: /opt/opensim.sh osstop sim1
function osstop()
{
	VERZEICHNISSCREEN=$1 # OpenSimulator, Verzeichnis und Screen Name
	if screen -list | grep -q "$VERZEICHNISSCREEN"; then
		echo "$(tput setaf $Red) $(tput setab $White)OpenSimulator $VERZEICHNISSCREEN Beenden$(tput sgr 0)"
		echo "$DATUM $(date +%H:%M:%S) OSSTOP: OpenSimulator $VERZEICHNISSCREEN Beenden" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		screen -S "$VERZEICHNISSCREEN" -p 0 -X eval "stuff 'shutdown'^M"
		sleep 10
	else
		echo "$(tput setaf $Red) $(tput setab $White)OpenSimulator $VERZEICHNISSCREEN nicht vorhanden$(tput sgr 0)"
		echo "$DATUM $(date +%H:%M:%S) OSSTOP: OpenSimulator $VERZEICHNISSCREEN nicht vorhanden" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	fi
	return
}

### Funktion rostart, Robust Server starten.
function rostart()
{
	if checkfile /$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS/bin/Robust.exe; then		
		cd /$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS/bin || return 1

		# AOT Aktiveren oder Deaktivieren.
		if [[ $SETAOTON = "yes" ]]
		then
			echo "$(tput setaf 2) $(tput setab $White)RobustServer Start aot$(tput sgr 0)"
			echo "$DATUM $(date +%H:%M:%S) ROSTART: RobustServer Start aot" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
			screen -fa -S RO -d -U -m mono --desktop -O=all Robust.exe 
		else
			echo "$(tput setaf 2) $(tput setab $White)RobustServer Start$(tput sgr 0)"
			echo "$DATUM $(date +%H:%M:%S) ROSTART: RobustServer Start" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
			screen -fa -S RO -d -U -m mono Robust.exe
		fi		
		sleep $WARTEZEIT
	else
		echo "$(tput setaf $Red)RobustServer wurde nicht gefunden.$(tput sgr 0)"
		echo "$DATUM $(date +%H:%M:%S) ROSTART: RobustServer wurde nicht gefunden" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	fi
}

### Funktion rostop, Robust Server herunterfahren.
function rostop()
{
	if screen -list | grep -q "RO"; then
		echo "$(tput setaf $Red) $(tput setab $White)RobustServer Beenden$(tput sgr 0)"
		screen -S RO -p 0 -X eval "stuff 'shutdown'^M"
		echo "$DATUM $(date +%H:%M:%S) ROSTOP: RobustServer Beenden" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		sleep $WARTEZEIT	  
	else
		echo "$(tput setaf $Red) $(tput setab $White)RobustServer nicht vorhanden$(tput sgr 0)"
		echo "$DATUM $(date +%H:%M:%S) ROSTOP: RobustServer nicht vorhanden" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
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
			echo "$(tput setaf 2) $(tput setab $White)Money Server Start aot $(tput sgr 0)"
			echo "$DATUM $(date +%H:%M:%S) MOSTART: Money Server Start aot" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
			screen -fa -S MO -d -U -m mono --desktop -O=all MoneyServer.exe
		else
			echo "$(tput setaf 2) $(tput setab $White)Money Server Start$(tput sgr 0)"
			echo "$DATUM $(date +%H:%M:%S) MOSTART: Money Server Start" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
			screen -fa -S MO -d -U -m mono MoneyServer.exe
		fi
		sleep $MONEYWARTEZEIT
	else
		echo "$(tput setaf $Red)Money Server wurde nicht gefunden.$(tput sgr 0)"
		echo "$DATUM $(date +%H:%M:%S) MOSTART: Money Server wurde nicht gefunden" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	fi
}

### Funktion mostop, Money Server herunterfahren.
function mostop()
{
	if screen -list | grep -q "MO"; then
		echo "$(tput setaf $Red) $(tput setab $White)Money Server Beenden$(tput sgr 0)"
		screen -S MO -p 0 -X eval "stuff 'shutdown'^M"
		echo "$DATUM $(date +%H:%M:%S) MOSTOP: Money Server Beenden" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	  sleep $MONEYWARTEZEIT	  
	else
		echo "$(tput setaf $Red) $(tput setab $White)Money Server nicht vorhanden$(tput sgr 0)"
		echo "$DATUM $(date +%H:%M:%S) MOSTOP: Money Server nicht vorhanden" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	fi	
}

### Funktion osscreenstop, beendet ein Screeen.
# Beispiel-Example: osscreenstop sim1
function osscreenstop()
{
	VERZEICHNISSCREEN=$1
	if screen -list | grep -q "$VERZEICHNISSCREEN"; then
		echo "$(tput setaf $Red) $(tput setab $White)Screeen $VERZEICHNISSCREEN Beenden$(tput sgr 0)"
		echo "$DATUM $(date +%H:%M:%S) OSSCREENSTOP: Screeen $VERZEICHNISSCREEN Beenden" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		screen -S "$VERZEICHNISSCREEN" -X quit	  
	else
		echo "$(tput setaf $Red) $(tput setab $White)Screeen $VERZEICHNISSCREEN nicht vorhanden$(tput sgr 0)"
		echo "$DATUM $(date +%H:%M:%S) OSSCREENSTOP: Screeen $VERZEICHNISSCREEN nicht vorhanden" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	fi
	echo "No screen session found. Ist hier kein Fehler, sondern ein Beweis, das alles zuvor sauber heruntergefahren wurde."
}

### Funktion gridstart, startet erst Robust und dann Money.
function gridstart()
{
	ossettings
	echo " "
	if screen -list | grep -q RO; then
		echo "$(tput setaf $Red) $(tput setab $White)RobustServer läuft bereits $(tput sgr 0)"
	else
		rostart
	fi

	if screen -list | grep -q MO; then
		echo "$(tput setaf $Red) $(tput setab $White)MoneyServer läuft bereits $(tput sgr 0)"
	else
		mostart
	fi
}

### Funktion simstats, zeigt Simstatistik an.
# simstats screen_name
# Beispiel-Example: simstats sim1
# erzeugt im Hauptverzeichnis eine Datei namens sim1.log in dieser Datei ist die Statistik zu finden.
function simstats()
{
	VERZEICHNISSCREEN=$1 # OpenSimulator, Verzeichnis und Screen Name
	if screen -list | grep -q "$VERZEICHNISSCREEN"; then
		if checkfile /$STARTVERZEICHNIS/"$VERZEICHNISSCREEN".log; then
			rm /$STARTVERZEICHNIS/"$VERZEICHNISSCREEN".log
		fi
		echo "$(tput setaf 2) $(tput setab $White)OpenSimulator $VERZEICHNISSCREEN Simstatistik anzeigen$(tput sgr 0)"
		echo "$DATUM $(date +%H:%M:%S) simstat: Region $VERZEICHNISSCREEN Simstatistik anzeigen" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		screen -S "$VERZEICHNISSCREEN" -p 0 -X eval "stuff 'stats save /$STARTVERZEICHNIS/$VERZEICHNISSCREEN.log'^M"
		sleep 2
		echo "$(tput setaf 2) "
		cat /$STARTVERZEICHNIS/"$VERZEICHNISSCREEN".log
		echo "$(tput sgr 0) "
	else
		echo "$(tput setaf $Red) $(tput setab $White)Simulator $VERZEICHNISSCREEN nicht vorhanden$(tput sgr 0)"
		echo "$DATUM $(date +%H:%M:%S) simstat: Simulator $VERZEICHNISSCREEN nicht vorhanden" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	fi
	return
}

### Funktion gridstop, stoppt erst Money dann Robust.
function gridstop()
{
	if screen -list | grep -q MO; then
		mostop		
	else
		echo "$(tput setaf $Red)MoneyServer läuft nicht $(tput sgr 0)"
	fi

	if screen -list | grep -q RO; then
		rostop		
	else
		echo "$(tput setaf $Red)RobustServer läuft nicht $(tput sgr 0)"
	fi
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
	echo "$(tput setab $Green)Kompilierungsvorgang startet! $(tput sgr 0)"
	echo "$DATUM $(date +%H:%M:%S) OSCOMPI: Kompilierungsvorgang startet" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	# In das opensim Verzeichnis wechseln wenn es das gibt ansonsten beenden.
	cd /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS || return 1
	
	echo 'Prebuildvorgang startet!'
	echo "$DATUM $(date +%H:%M:%S) OSCOMPI: Prebuildvorgang startet" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	# runprebuild19.sh startbar machen und starten.
	chmod +x runprebuild19.sh
	./runprebuild19.sh

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
}

### Funktion scriptcopy, lsl ossl scripte kopieren.
function scriptcopy()
{
	if [[ $SCRIPTCOPY = "yes" ]]
	then
		if [ -d /$STARTVERZEICHNIS/$SCRIPTSOURCE/ ]; then
			echo "$(tput setab $Green)Script Assets werden kopiert! $(tput sgr 0)"
			echo "$DATUM $(date +%H:%M:%S) SCRIPTCOPY: Script Assets werden kopiert" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
			cp -r /$STARTVERZEICHNIS/$SCRIPTSOURCE/assets /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/bin
			cp -r /$STARTVERZEICHNIS/$SCRIPTSOURCE/inventory /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/bin
		echo " "
		else
			echo "$(tput setab $Green)Script Assets sind nicht vorhanden! $(tput sgr 0)"
			echo "$DATUM $(date +%H:%M:%S) SCRIPTCOPY: Script Assets sind nicht vorhanden" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		fi
	else
    	echo "Skripte werden nicht kopiert."
		echo "$DATUM $(date +%H:%M:%S) SCRIPTCOPY: Skripte werden nicht kopiert." >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	fi
}

### Funktion moneycopy, Money Dateien kopieren.
function moneycopy()
{
	if [[ $MONEYCOPY = "yes" ]]
	then
		if [ -d /$STARTVERZEICHNIS/$MONEYSOURCE/ ]; then
			echo "$(tput setab $Green)Money Kopiervorgang startet! $(tput sgr 0)"
			echo "$DATUM $(date +%H:%M:%S) MONEYCOPY: Money Kopiervorgang gestartet" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
			cp -r /$STARTVERZEICHNIS/$MONEYSOURCE/bin /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS
			cp -r /$STARTVERZEICHNIS/$MONEYSOURCE/addon-modules /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS
			echo " "
		else
			echo "$(tput setab $Green)Script Assets sind nicht vorhanden! $(tput sgr 0)"
			echo "$DATUM $(date +%H:%M:%S) SCRIPTCOPY: Script Assets sind nicht vorhanden" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		fi
	else
    	echo "Money wird nicht kopiert."
		echo "$DATUM $(date +%H:%M:%S) SCRIPTCOPY: Money wird nicht kopiert." >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	fi
}

### Funktion pythoncopy, Plugin Daten kopieren.
function pythoncopy()
{
	if [[ $PYTHONCOPY = "yes" ]]
	then
		if [ -d /$STARTVERZEICHNIS/OpensimPython/ ]; then
			echo "$(tput setab $Green)python wird kopiert! $(tput sgr 0)"
			echo "$DATUM $(date +%H:%M:%S) PYTHONCOPY: python wird kopiert" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
			cp -r /$STARTVERZEICHNIS/OpensimPython /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/addon-modules
		echo " "
		else
			echo "$(tput setab $Green)python ist nicht vorhanden! $(tput sgr 0)"
			echo "$DATUM $(date +%H:%M:%S) PYTHONCOPY: python ist nicht vorhanden" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		fi
	else
    	echo "Python wird nicht kopiert."
		echo "$DATUM $(date +%H:%M:%S) PYTHONCOPY: Python wird nicht kopiert." >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	fi
}

### Funktion searchcopy, Plugin Daten kopieren.
function searchcopy()
{
	if [[ $SEARCHCOPY = "yes" ]]
	then
		if [ -d /$STARTVERZEICHNIS/OpenSimSearch/ ]; then
			echo "$(tput setab $Green)OpenSimSearch wird kopiert! $(tput sgr 0)"
			echo "$DATUM $(date +%H:%M:%S) OpenSimSearch: python wird kopiert" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
			cp -r /$STARTVERZEICHNIS/OpenSimSearch /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/addon-modules
		echo " "
		else
			echo "$(tput setab $Green)OpenSimSearch ist nicht vorhanden! $(tput sgr 0)"
			echo "$DATUM $(date +%H:%M:%S) OpenSimSearch: python ist nicht vorhanden" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		fi
	else
    	echo "OpenSimSearch wird nicht kopiert."
		echo "$DATUM $(date +%H:%M:%S) OpenSimSearch: OpenSimSearch wird nicht kopiert." >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	fi
}

### Funktion mutelistcopy, Plugin Daten kopieren.
function mutelistcopy()
{
	if [[ $MUTELISTCOPY = "yes" ]]
	then
		if [ -d /$STARTVERZEICHNIS/OpenSimMutelist/ ]; then
			echo "$(tput setab $Green)OpenSimMutelist wird kopiert! $(tput sgr 0)"
			echo "$DATUM $(date +%H:%M:%S) OpenSimMutelist: python wird kopiert" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
			cp -r /$STARTVERZEICHNIS/OpenSimMutelist /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/addon-modules
		echo " "
		else
			echo "$(tput setab $Green)OpenSimMutelist ist nicht vorhanden! $(tput sgr 0)"
			echo "$DATUM $(date +%H:%M:%S) OpenSimMutelist: python ist nicht vorhanden" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		fi
	else
    	echo "OpenSimMutelist wird nicht kopiert."
		echo "$DATUM $(date +%H:%M:%S) OpenSimMutelist: OpenSimMutelist wird nicht kopiert." >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	fi
}

### Funktion chrisoscopy, Plugin Dateien kopieren.
function chrisoscopy()
{
	if [[ $CHRISOSCOPY = "yes" ]]
	then
		# /opt/Chris.OS.Additions
		if [ -d /$STARTVERZEICHNIS/Chris.OS.Additions/ ]; then
			echo "$(tput setab $Green)Chris.OS.Additions Kopiervorgang startet! $(tput sgr 0)"
			echo "$DATUM $(date +%H:%M:%S) CHRISOSCOPY: Chris.OS.Additions Kopiervorgang gestartet" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
			cp -r /$STARTVERZEICHNIS/Chris.OS.Additions /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/addon-modules
			echo " "
		else
			echo "$(tput setab $Green)Chris.OS.Additions ist nicht vorhanden! $(tput sgr 0)"
			echo "$DATUM $(date +%H:%M:%S) CHRISOSCOPY: Chris.OS.Additions ist nicht vorhanden" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		fi	
	else
    	echo "Chris.OS.Additions werden nicht kopiert."
		echo "$DATUM $(date +%H:%M:%S) CHRISOSCOPY: Chris.OS.Additions werden nicht kopiert." >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	fi
}

### Funktion compilieren, kompilieren des OpenSimulator.
function compilieren()
{
	echo "$(tput setab $Green)Bauen eines neuen OpenSimulators wird gestartet! $(tput sgr 0)"
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
}

### Funktion osprebuild, Prebuild einstellen - Aufruf Beispiel: opensim.sh prebuild 1175.
# Ergebnis ist eine Einstellung für Release mit dem Namn OpenSim 0.9.2.1175
# sed -i schreibt sofort - s/Suchwort/Ersatzwort/g - /Verzeichnis/Dateiname.Endung
function osprebuild()
{
	NUMMER=$1
	echo "$(tput setab $Green)Version umbenennen und Release auf $NUMMER einstellen. $(tput sgr 0)"
	echo "$DATUM $(date +%H:%M:%S) PREBUILD: Version umbenennen und Release auf $NUMMER einstellen" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"

	# Nummer einfügen
	sed -i s/0.9.2.0/0.9.2."$NUMMER"/g /$STARTVERZEICHNIS/opensim/OpenSim/Framework/VersionInfo.cs
	# Release setzen
	sed -i s/Flavour.Dev/Flavour.Release/g /$STARTVERZEICHNIS/opensim/OpenSim/Framework/VersionInfo.cs
	# Yeti löschen
	sed -i s/Yeti//g /$STARTVERZEICHNIS/opensim/OpenSim/Framework/VersionInfo.cs
	# flavour löschen
	sed -i s/' + flavour'//g /$STARTVERZEICHNIS/opensim/OpenSim/Framework/VersionInfo.cs
}

# Funktion osstruktur, legt die Verzeichnisstruktur fuer OpenSim an.
# Aufruf: opensim.sh osstruktur ersteSIM letzteSIM
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
}

### Funktion osdelete, altes opensim loeschen und letztes opensim als Backup umbenennen.
function osdelete()
{	
	if [ -d /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/ ]; then
		echo "$(tput setaf $Red) $(tput setab $White)Lösche altes opensim1 Verzeichnis$(tput sgr 0)"
		echo "$DATUM $(date +%H:%M:%S) OSDELETE: Lösche altes opensim1 Verzeichnis" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		cd /$STARTVERZEICHNIS  || return 1
		rm -r /$STARTVERZEICHNIS/opensim1
		echo "$(tput setaf $Red) $(tput setab $White)Umbenennen von $OPENSIMVERZEICHNIS nach opensim1 zur sicherung$(tput sgr 0)"
		echo "$DATUM $(date +%H:%M:%S) OSDELETE: Umbenennen von $OPENSIMVERZEICHNIS nach opensim1 zur sicherung" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		mv /$STARTVERZEICHNIS/opensim /$STARTVERZEICHNIS/opensim1
		echo " "
		
	else
		echo "$(tput setaf $Red) $(tput setab $White) $STARTVERZEICHNIS Verzeichnis existiert nicht$(tput sgr 0)"
	fi
}

### Funktion oscopyrobust, Robust Daten kopieren.
function oscopyrobust()
{
	if [ -d /$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS/ ]; then
		makeverzeichnisliste
		echo "$(tput setab $Green)Kopiere Robust, Money! $(tput sgr 0)"
		echo " "
		sleep 2
		echo "$(tput setaf $Green) $(tput setab $White)Robust und Money kopiert$(tput sgr 0)"
		cd /$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS/bin || return 1
		cp -r /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/bin /$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS
		echo " "
		echo "$DATUM $(date +%H:%M:%S) OSCOPY: Robust kopieren" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	else
		echo " "
	fi
}

### Funktion oscopysim, Simulatoren kopieren aus dem Verzeichnis opensim.
function oscopysim()
{
	makeverzeichnisliste
	echo "$(tput setab $Green)Kopiere Simulatoren! $(tput sgr 0)"
	echo " "
	sleep 2
	for (( i = 0 ; i < "$ANZAHLVERZEICHNISSLISTE" ; i++)) do
		echo "$(tput setaf $Green) $(tput setab $White)OpenSimulator ${VERZEICHNISSLISTE[$i]} kopiert$(tput sgr 0)"
		cd /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin || return 1
		cp -r /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/bin /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"
		sleep 2
	done
	echo " "
	echo "$DATUM $(date +%H:%M:%S) OSCOPY: OpenSim kopieren" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
}

# Funktion configlesen, Regionskonfigurationen lesen.
## Beispiel: configlesen sim1
function configlesen()
{
	VERZEICHNISSCREEN=$1
	echo "$(tput setab $Green)Regionskonfigurationen von $VERZEICHNISSCREEN $(tput sgr 0)"
	KONFIGLESEN=$(awk -F":" '// {print $0 }' /$STARTVERZEICHNIS/"$VERZEICHNISSCREEN"/bin/Regions/*.ini)	# Regionskonfigurationen aus einem Verzeichnis lesen.
	echo "$KONFIGLESEN"
	echo "$DATUM $(date +%H:%M:%S) CONFIGLESEN: Regionskonfigurationen von $VERZEICHNISSCREEN" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	echo "$KONFIGLESEN" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
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
		echo "$(tput setaf $Green)$(tput setab $White) $VERZEICHNIS $(tput sgr 0)"
		echo "$REGIONSAUSGABE"
		echo "$REGIONSAUSGABE" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	done
	echo "$DATUM $(date +%H:%M:%S) MEINEREGIONEN: Regionsliste Ende" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
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
}

# Funktion get_regionsarray, gibt ein Array aller Regionsabschnitte zurueck.
# $1 - Datei
function get_regionsarray() 
{
	# Es fehlt eine pruefung ob Datei vorhanden ist.
	# shellcheck disable=SC2207
	ARRAY=($(grep '\[.*\]' "$1"))
	FIXED_ARRAY=""
	for i in "${ARRAY[@]}"; do
		FIX=$i
		FIX=$(echo "$FIX" | tr --delete "\r")
		FIX=$(echo "$FIX" | tr --delete "[")
		FIX=$(echo "$FIX" | tr --delete "]")
		FIXED_ARRAY+="${FIX} "
	done
	echo "${FIXED_ARRAY}"
}

# Funktion get_value_from_Region_key, gibt den Wert eines bestimmten Schluessels im angegebenen Abschnitt zurueck.
# $1 - Datei - $2 - Schluessel - $3 - Sektion
function get_value_from_Region_key() 
{
	# Es fehlt eine pruefung ob Datei vorhanden ist.
	# shellcheck disable=SC2005
	#echo "$(sed -nr "/^\[$2\]/ { :l /^$3[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" "$1")" # Nur Parameter
	echo "$(sed -nr "/^\[$2\]/ { :l /$3[ ]*=/ { p; q;}; n; b l;}" "$1")" # Komplette eintraege
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
	echo "$(tput setaf $Green)$(tput setab $White) REGIONSINITEILEN: Schreiben der Werte für $RTREGIONSNAME"
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
		echo "$(tput setaf $Red)$(tput setab $White)$INI_FILE wurde nicht gefunden $(tput sgr 0)"
		echo "$DATUM $(date +%H:%M:%S) REGIONSINITEILEN: $INI_FILE wurde nicht gefunden" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	fi
}

### Funktion autoregionsiniteilen, Die gemeinschaftsdatei Regions.ini in einzelne Regionen teilen.
# diese dann unter dem Regionsnamen speichern, danach die Alte Regions.ini umbenennen in Regions.ini.old.
function autoregionsiniteilen()
{
	makeverzeichnisliste
	sleep 2
	for (( i = 0 ; i < "$ANZAHLVERZEICHNISSLISTE" ; i++))
	do
		echo "$(tput setaf $Red) $(tput setab $White)Region.ini ${VERZEICHNISSLISTE[$i]} zerlegen$(tput sgr 0)"
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
		echo "$(tput setaf $Red) $(tput setab $White)Regionnamen ${VERZEICHNISSLISTE[$i]} schreiben$(tput sgr 0)"
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
}

### Funktion moneydelete, loescht den MoneyServer ohne die OpenSim Config zu veraendern.
function moneydelete()
{
	makeverzeichnisliste
	sleep 2
	# MoneyServer aus den sims entfernen 
	for (( i = 0 ; i < "$ANZAHLVERZEICHNISSLISTE" ; i++)) do
		echo "$(tput setaf $Red) $(tput setab $White)MoneyServer ${VERZEICHNISSLISTE[$i]} geloescht$(tput sgr 0)"
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
}

### Funktion osgitholen, kopiert eine Entwicklerversion in das opensim Verzeichnis.
function osgitholen()
{
	if [ -d /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/ ]
	then
		echo "$(tput setaf 1) $(tput setab 7)Kopieren der Entwicklungsversion des OpenSimulator aus dem Git$(tput sgr 0)"
		cd /$STARTVERZEICHNIS  || return 1
		rm -r /$STARTVERZEICHNIS/opensim1
		mv /$STARTVERZEICHNIS/opensim /$STARTVERZEICHNIS/opensim1
        git clone git://opensimulator.org/git/opensim opensim
		echo "$DATUM $(date +%H:%M:%S) OPENSIMHOLEN: Git klonen" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	else
		echo "$(tput setaf 1) $(tput setab 7)Kopieren der Entwicklungsversion des OpenSimulator aus dem Git$(tput sgr 0)"
		git clone git://opensimulator.org/git/opensim opensim
		echo "$DATUM $(date +%H:%M:%S) OPENSIMHOLEN: Git klonen" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	fi 
}

### Funktion opensimholen, holt den OpenSimulator in das Arbeitsverzeichnis.
function opensimholen()
{
	if [ -d /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/ ]
	then
		echo "$(tput setaf 1) $(tput setab 7)Kopieren des OpenSimulator in das Arbeitsverzeichnis$(tput sgr 0)"
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
		echo "$(tput setaf 1) $(tput setab 7)Kopieren des OpenSimulator in das Arbeitsverzeichnis$(tput sgr 0)"

		echo "$OPENSIMDOWNLOAD$OPENSIMVERSION"
        wget $OPENSIMDOWNLOAD$OPENSIMVERSION.zip
		echo "$OPENSIMVERSION"
		unzip $OPENSIMVERSION
		mv /$STARTVERZEICHNIS/$OPENSIMVERSION /$STARTVERZEICHNIS/opensim

		echo "$DATUM $(date +%H:%M:%S) OPENSIMHOLEN: Download" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	fi 
}

### Funktion osupgrade, automatisches upgrade des opensimulator aus dem verzeichnis opensim.
function osupgrade()
{
	echo "$(tput setab $Green)Das Grid wird jetzt upgegradet! $(tput sgr 0)"
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
	echo " "
	# MoneyServer eventuell loeschen.	
	if [ "$MONEYVERZEICHNIS" = "keins" ] || [ "$MONEYVERZEICHNIS" = "no" ] || [ "$MONEYVERZEICHNIS" = "nein" ]; then moneydelete; fi
	# Grid Starten.
	echo "$DATUM $(date +%H:%M:%S) OSUPGRADE: Das Grid wird jetzt gestartet" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	autostart
}

# function restore()
# {	
# 	echo "ACHTUNG Test gefährlich!!!"
# 	RESCREENNAME=$1 
# 	REREGIONSNAME=$2
# 	PFADDATEINAME=$3
# 	screen -S "$RESCREENNAME" -p 0 -X eval "stuff 'change region ${REREGIONSNAME//\"/}'^M"
# 	# es muss hier geschaut werden, das es nicht root ist, sondern wirklich die Region, sonst werden alle Regionen ueberschrieben!!!
# 	screen -S "$RESCREENNAME" -p 0 -X eval "stuff 'load oar $PFADDATEINAME'^M"
# 	echo "$DATUM $(date +%H:%M:%S) DEBUG: Start von MULTITOOL" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
# }

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

	echo "$(tput setaf 4) $(tput setab 7)Region $NSDATEINAME speichern$(tput sgr 0)"
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
		echo "$(tput setaf 2)Regions.ini wurde als $DATUM-$NSDATEINAME.ini gespeichert."
		echo "$DATUM $(date +%H:%M:%S) OSBACKUP: Region $DATUM-$NSDATEINAME.ini gespeichert" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	fi
	if [ ! -f /$STARTVERZEICHNIS/"$VERZEICHNISSCREENNAME"/bin/Regions/"${REGIONSNAME//\"/}".ini ]; then
		cp -r /$STARTVERZEICHNIS/"$VERZEICHNISSCREENNAME"/bin/Regions/Regions.ini /$STARTVERZEICHNIS/backup/"$DATUM"-"$NSDATEINAME".ini
		echo "$(tput setaf 2)Regions.ini wurde als $DATUM-$NSDATEINAME.ini gespeichert."
		echo "$DATUM $(date +%H:%M:%S) OSBACKUP: Region $DATUM-$NSDATEINAME.ini gespeichert" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	fi
	if [ ! -f /$STARTVERZEICHNIS/"$VERZEICHNISSCREENNAME"/bin/Regions/Regions.ini ]; then
		cp -r /$STARTVERZEICHNIS/"$VERZEICHNISSCREENNAME"/bin/Regions/"$NSDATEINAME".ini /$STARTVERZEICHNIS/backup/"$DATUM"-"$NSDATEINAME".ini
		echo "$DATUM $(date +%H:%M:%S) OSBACKUP: Region $NSDATEINAME.ini gespeichert" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	fi
}

### Funktion autosimstart, automatischer sim start ohne Robust und Money.
function autosimstart()
{
	# shellcheck disable=SC2022
	if ! screen -list | grep -q 'sim*'; then
	# es laeuft nicht - not work
		makeverzeichnisliste
		sleep 2
		for (( i = 0 ; i < "$ANZAHLVERZEICHNISSLISTE" ; i++)) do
			echo "$(tput setaf 2) $(tput setab $White)Regionen OpenSimulator ${VERZEICHNISSLISTE[$i]} Starten$(tput sgr 0)"
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
		echo "$(tput setaf $White)$(tput setab $Green) Regionen laufen bereits! $(tput sgr 0)"
		echo "$DATUM $(date +%H:%M:%S) WORKS:  Regionen laufen bereits!" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	fi
}

### Funktion autosimstop, stoppen aller laufenden Simulatoren.
function autosimstop()
{
	makeverzeichnisliste
	sleep 2
	for (( i = 0 ; i < "$ANZAHLVERZEICHNISSLISTE" ; i++)) do
		if screen -list | grep -q "${VERZEICHNISSLISTE[$i]}"; then
			echo "$(tput setaf $Red) $(tput setab $White)Regionen OpenSimulator ${VERZEICHNISSLISTE[$i]} Beenden$(tput sgr 0)"
			screen -S "${VERZEICHNISSLISTE[$i]}" -p 0 -X eval "stuff 'shutdown'^M"
			echo "$DATUM $(date +%H:%M:%S) AUTOSIMSTOP: Regionen OpenSimulator ${VERZEICHNISSLISTE[$i]} Beenden" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
			sleep $STOPWARTEZEIT
		else
			echo "$(tput setaf $Red)${VERZEICHNISSLISTE[$i]} läuft nicht $(tput sgr 0)"
		fi
	done
}

### Funktion autologdel, automatisches loeschen aller log Dateien.
# Die Dateien samt neuer Daten werden beim naechsten start des opensimulator neu geschrieben.
function autologdel()
{
	echo "$(tput setab 1)Log Dateien löschen! $(tput sgr 0)"
	makeverzeichnisliste
	sleep 2
	for (( i = 0 ; i < "$ANZAHLVERZEICHNISSLISTE" ; i++)) do
		echo "$(tput setaf $Red) $(tput setab $White)OpenSimulator log ${VERZEICHNISSLISTE[$i]} geloescht$(tput sgr 0)"
		rm /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/*.log
		echo "$DATUM $(date +%H:%M:%S) AUTOLOGDEL: OpenSimulator log ${VERZEICHNISSLISTE[$i]} geloescht" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		sleep 2
	done
}

### Funktion automapdel, automatisches loeschen aller Map/Karten Dateien.
# Die Dateien samt neuer Daten werden beim naechsten start des opensimulator neu geschrieben.
function automapdel()
{
	makeverzeichnisliste
	sleep 2
	for (( i = 0 ; i < "$ANZAHLVERZEICHNISSLISTE" ; i++)) do
		echo "$(tput setaf $Red) $(tput setab $White)OpenSimulator maptile ${VERZEICHNISSLISTE[$i]} geloescht$(tput sgr 0)"
		cd /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin || return 1
		rm -r maptiles/*
		echo "$DATUM $(date +%H:%M:%S) AUTOMAPDEL: OpenSimulator maptile ${VERZEICHNISSLISTE[$i]} geloescht" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		sleep 2
	done
	autorobustmapdel
}

### Funktion autorobustmapdel, automatisches loeschen aller Map/Karten Dateien in Robust.
# Die Dateien samt neuer Daten werden beim naechsten start des opensimulator neu geschrieben.
function autorobustmapdel()
{
	echo "$(tput setaf $Red) $(tput setab $White)OpenSimulator maptile aus $ROBUSTVERZEICHNIS geloescht$(tput sgr 0)"
	cd /$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS/bin || return 1
	rm -r maptiles/*
	echo "$DATUM $(date +%H:%M:%S) AUTOMAPDEL: OpenSimulator maptile aus $ROBUSTVERZEICHNIS geloescht" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
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

}

### Funktion allclean, loescht Log, dll, so, exe, aot Dateien fuer einen saubere neue installation, ohne Robust.
# Hierbei werden keine Datenbanken oder Konfigurationen geloescht aber opensim ist anschliessend nicht mehr startbereit.
# Um opensim wieder Funktionsbereit zu machen muss ein Upgrade oder ein oscopy vorgang ausgeführt werden.
# allclean Verzeichnis
function allclean()
{
	if [ -d "$1" ]; then
		echo "$(tput setaf $Red) $(tput setab $White)OpenSimulator log $1 geloescht$(tput sgr 0)"
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
		echo "$(tput setaf $Red)Dateien in $1 nicht gefunden $(tput sgr 0)"
		echo "$DATUM $(date +%H:%M:%S) clean: Dateien in $1 nicht gefunden" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	fi
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
		echo "$(tput setaf $Red) $(tput setab $White)OpenSimulator alles ${VERZEICHNISSLISTE[$i]} geloescht$(tput sgr 0)"
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
	echo "$(tput setaf $Red) $(tput setab $White)OpenSimulator alles in $ROBUSTVERZEICHNIS geloescht$(tput sgr 0)"
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
}

### Funktion autoregionbackup, automatischer Backup aller Regionen die in der Regionsliste eingetragen sind.
function autoregionbackup()
{
	echo "$(tput setaf $Red) $(tput setab $White)Automatisches Backup wird gestartet. $(tput sgr 0)"
	makeregionsliste
	echo "$DATUM $(date +%H:%M:%S) OSBACKUP: Automatisches Backup wird gestartet" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	sleep 2
	for (( i = 0 ; i < "$ANZAHLREGIONSLISTE" ; i++)) do
		derscreen=$(echo "${REGIONSLISTE[$i]}" | cut -d ' ' -f 1)
		dieregion=$(echo "${REGIONSLISTE[$i]}" | cut -d ' ' -f 2)
		regionbackup "$derscreen" "$dieregion"
		sleep $BACKUPWARTEZEIT
	done
}

### Funktion autoscreenstop, beendet alle laufenden simX screens.
function autoscreenstop()
{
	makeverzeichnisliste
	sleep 2

	# shellcheck disable=SC2022
	if ! screen -list | grep -q 'sim*'; then
	echo "$(tput setaf $White)$(tput setab $Red) SIMs OFFLINE! $(tput sgr 0)"
	echo "$DATUM $(date +%H:%M:%S) WORKS: SIMs OFFLINE!" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	else
		for (( i = 0 ; i < "$ANZAHLVERZEICHNISSLISTE" ; i++)) do
			screen -S "${VERZEICHNISSLISTE[$i]}" -X quit
		done
	fi

	if ! screen -list | grep -q "MO"; then
	echo "$(tput setaf $White)$(tput setab $Red) MONEY OFFLINE! $(tput sgr 0)"
	echo "$DATUM $(date +%H:%M:%S) WORKS: MONEY OFFLINE!" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	else	
	screen -S MO -X quit
	fi

	if ! screen -list | grep -q "RO"; then
	echo "$(tput setaf $White)$(tput setab $Red) ROBUST OFFLINE! $(tput sgr 0)"
	echo "$DATUM $(date +%H:%M:%S) WORKS: ROBUST OFFLINE!" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	else
	screen -S RO -X quit
	fi
}

### Funktion autostart, startet das komplette Grid mit allen sims.
function autostart()
{
	echo "$(tput setab $Green)Starte das Grid! $(tput sgr 0)"
	echo " "	
	gridstart
	autosimstart
	echo " "
	screenlist
	echo " "
	echo "$DATUM $(date +%H:%M:%S) AUTOSTART: Auto Start abgeschlossen" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
}

### Funktion autostop, stoppt das komplette Grid mit allen sims.
function autostop()
{
	echo "$(tput setab 1)Stoppe alles! $(tput sgr 0)"
	# schauen ob screens laufen wenn ja beenden.
	# shellcheck disable=SC2022
	if ! screen -list | grep -q 'sim*'; then
		echo "$(tput setaf $White)$(tput setab $Red) SIMs OFFLINE! $(tput sgr 0)"
	else
		autosimstop
	fi
	if ! screen -list | grep -q "MO"; then
		echo "$(tput setaf $White)$(tput setab $Red) MONEY OFFLINE! $(tput sgr 0)"
	else
		gridstop
	fi
	if ! screen -list | grep -q "RO"; then
		echo "$(tput setaf $White)$(tput setab $Red) ROBUST OFFLINE! $(tput sgr 0)"
	else
		gridstop
	fi
	# schauen ob screens laufen wenn ja warten.
	# shellcheck disable=SC2022
	if ! screen -list | grep -q 'sim*'; then
		echo " "
	else
		sleep $AUTOSTOPZEIT
	fi
	echo " "
	echo "$(tput setab 1)Beende alle noch offenen Screens! $(tput sgr 0)"
	autoscreenstop
	echo " "
}

### Funktion autorestart, startet das gesamte Grid neu und loescht die log Dateien.
function autorestart()
{
	echo " "
	autostop
	echo " "
	autologdel
	echo " "
	echo "$(tput setab 2)Starte alles! $(tput sgr 0)"
	gridstart
	autosimstart
	echo " "
	screenlist
	echo " "
	echo "$DATUM $(date +%H:%M:%S) AUTORESTART: Auto Restart abgeschlossen" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
}

### Dieses Installationsbeispiel installiert alles für OpenSim inkusive Web, sowie alles um einen OpenSimulator zu Kompilieren.
### Funktion monoinstall, mono 6.x installieren.
function monoinstall() 
{
	if dpkg-query -s mono-complete 2>/dev/null|grep -q installed; then
		echo "$(tput setaf 2)mono-complete ist installiert.$(tput sgr0)"
	else
		echo "$(tput setaf 1)mono-complete ist nicht installiert.$(tput sgr0)"
		echo "$(tput setaf 2)Installation von mono 6.x fuer Ubuntu 18.$(tput sgr0)"
		
		sleep 2

		sudo apt install gnupg ca-certificates
		sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
		echo "deb https://download.mono-project.com/repo/ubuntu stable-bionic main" | sudo tee /etc/apt/sources.list.d/mono-official-stable.list
		sudo apt update
		sudo apt-get -y install mono-complete
		sudo apt-get upgrade
	fi
}

### Funktion serverinstall, Ubuntu 18 Server zum Betrieb von OpenSim vorbereiten.
function serverinstall() 
{
##Updaten um Gewissheit zu haben das, das Ubuntu 18.04 aktuell ist.
sudo apt-get update
sudo apt-get upgrade

##Apache2 und Erweiterung installieren.
	if dpkg-query -s apache2 2>/dev/null|grep -q installed; then
			echo "$(tput setaf 2)apache2 ist installiert.$(tput sgr0)"
			echo "$DATUM $(date +%H:%M:%S) SERVERINSTALL: apache2 ist installiert" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		else
			echo "$(tput setaf 1)Ich installiere jetzt apache2.$(tput sgr0)"
			echo "$DATUM $(date +%H:%M:%S) SERVERINSTALL: Ich installiere jetzt apache2" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
			sudo apt-get -y install apache2
	fi
	if dpkg-query -s libapache2-mod-php 2>/dev/null|grep -q installed; then
			echo "$(tput setaf 2)libapache2-mod-php ist installiert.$(tput sgr0)"
			echo "$DATUM $(date +%H:%M:%S) SERVERINSTALL: libapache2-mod-php ist installiert" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		else
			echo "$(tput setaf 1)Ich installiere jetzt libapache2-mod-php.$(tput sgr0)"
			echo "$DATUM $(date +%H:%M:%S) SERVERINSTALL: Ich installiere jetzt libapache2-mod-php" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
			sudo apt-get -y install libapache2-mod-php
	fi

##PHP, mysql und Erweiterungen installieren.
	if dpkg-query -s php 2>/dev/null|grep -q installed; then
			echo "$(tput setaf 2)php ist installiert.$(tput sgr0)"
			echo "$DATUM $(date +%H:%M:%S) SERVERINSTALL: php ist installiert" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		else
			echo "$(tput setaf 1)Ich installiere jetzt php.$(tput sgr0)"
			echo "$DATUM $(date +%H:%M:%S) SERVERINSTALL: Ich installiere jetzt php" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
			sudo apt-get -y install php
	fi
	if dpkg-query -s mysql-server 2>/dev/null|grep -q installed; then
			echo "$(tput setaf 2)mysql-server ist installiert.$(tput sgr0)"
			echo "$DATUM $(date +%H:%M:%S) SERVERINSTALL: mysql-server ist installiert" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		else
			echo "$(tput setaf 1)Ich installiere jetzt mysql-server.$(tput sgr0)"
			echo "$DATUM $(date +%H:%M:%S) SERVERINSTALL: Ich installiere jetzt mysql-server" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
			sudo apt-get -y install mysql-server
	fi
	if dpkg-query -s php-mysql 2>/dev/null|grep -q installed; then
			echo "$(tput setaf 2)php-mysql ist installiert.$(tput sgr0)"
			echo "$DATUM $(date +%H:%M:%S) SERVERINSTALL: php-mysql ist installiert" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		else
			echo "$(tput setaf 1)Ich installiere jetzt php-mysql.$(tput sgr0)"
			echo "$DATUM $(date +%H:%M:%S) SERVERINSTALL: Ich installiere jetzt php-mysql" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
			sudo apt-get -y install php-mysql
	fi
	if dpkg-query -s php-common 2>/dev/null|grep -q installed; then
			echo "$(tput setaf 2)php-common ist installiert.$(tput sgr0)"
			echo "$DATUM $(date +%H:%M:%S) SERVERINSTALL: php-common ist installiert" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		else
			echo "$(tput setaf 1)Ich installiere jetzt php-common.$(tput sgr0)"
			echo "$DATUM $(date +%H:%M:%S) SERVERINSTALL: Ich installiere jetzt php-common" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
			sudo apt-get -y install php-common
	fi
	if dpkg-query -s php-gd 2>/dev/null|grep -q installed; then
			echo "$(tput setaf 2)php-gd ist installiert.$(tput sgr0)"
			echo "$DATUM $(date +%H:%M:%S) SERVERINSTALL: php-gd ist installiert" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		else
			echo "$(tput setaf 1)Ich installiere jetzt php-gd.$(tput sgr0)"
			echo "$DATUM $(date +%H:%M:%S) SERVERINSTALL: Ich installiere jetzt php-gd" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
			sudo apt-get -y install php-gd
	fi
	if dpkg-query -s php-pear 2>/dev/null|grep -q installed; then
			echo "$(tput setaf 2)php-pear ist installiert.$(tput sgr0)"
			echo "$DATUM $(date +%H:%M:%S) SERVERINSTALL: php-pear ist installiert" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		else
			echo "$(tput setaf 1)Ich installiere jetzt php-pear.$(tput sgr0)"
			echo "$DATUM $(date +%H:%M:%S) SERVERINSTALL: Ich installiere jetzt php-pear" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
			sudo apt-get -y install php-pear
	fi
	if dpkg-query -s php-xmlrpc 2>/dev/null|grep -q installed; then
			echo "$(tput setaf 2)php-xmlrpc ist installiert.$(tput sgr0)"
			echo "$DATUM $(date +%H:%M:%S) SERVERINSTALL: php-xmlrpc ist installiert" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		else
			echo "$(tput setaf 1)Ich installiere jetzt php-xmlrpc.$(tput sgr0)"
			echo "$DATUM $(date +%H:%M:%S) SERVERINSTALL: Ich installiere jetzt php-xmlrpc" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
			sudo apt-get -y install php-xmlrpc
	fi
	if dpkg-query -s php-curl 2>/dev/null|grep -q installed; then
			echo "$(tput setaf 2)php-curl ist installiert.$(tput sgr0)"
			echo "$DATUM $(date +%H:%M:%S) SERVERINSTALL: php-curl ist installiert" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		else
			echo "$(tput setaf 1)Ich installiere jetzt php-curl.$(tput sgr0)"
			echo "$DATUM $(date +%H:%M:%S) SERVERINSTALL: Ich installiere jetzt php-curl" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
			sudo apt-get -y install php-curl
	fi
	if dpkg-query -s php-mbstring 2>/dev/null|grep -q installed; then
			echo "$(tput setaf 2)php-mbstring ist installiert.$(tput sgr0)"
			echo "$DATUM $(date +%H:%M:%S) SERVERINSTALL: php-mbstring ist installiert" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		else
			echo "$(tput setaf 1)Ich installiere jetzt php-mbstring.$(tput sgr0)"
			echo "$DATUM $(date +%H:%M:%S) SERVERINSTALL: Ich installiere jetzt php-mbstring" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
			sudo apt-get -y install php-mbstring
	fi
	if dpkg-query -s php-gettext 2>/dev/null|grep -q installed; then
			echo "$(tput setaf 2)php-gettext ist installiert.$(tput sgr0)"
			echo "$DATUM $(date +%H:%M:%S) SERVERINSTALL: php-gettext ist installiert" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		else
			echo "$(tput setaf 1)Ich installiere jetzt php-gettext.$(tput sgr0)"
			echo "$DATUM $(date +%H:%M:%S) SERVERINSTALL: Ich installiere jetzt php-gettext" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
			sudo apt-get -y install php-gettext
	fi

##Mono Installieren um OpenSim ausführen zu können.
	monoinstall

##Hilfsprogramme zum entpacken, Hintergrunddienste, Git, NAnt und Grafiktools installieren.
	if dpkg-query -s zip 2>/dev/null|grep -q installed; then
			echo "$(tput setaf 2)zip ist installiert.$(tput sgr0)"
			echo "$DATUM $(date +%H:%M:%S) SERVERINSTALL: zip ist installiert" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		else
			echo "$(tput setaf 1)Ich installiere jetzt zip.$(tput sgr0)"
			echo "$DATUM $(date +%H:%M:%S) SERVERINSTALL: Ich installiere jetzt zip" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
			sudo apt-get -y install zip
	fi
	if dpkg-query -s screen 2>/dev/null|grep -q installed; then
			echo "$(tput setaf 2)screen ist installiert.$(tput sgr0)"
			echo "$DATUM $(date +%H:%M:%S) SERVERINSTALL: screen ist installiert" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		else
			echo "$(tput setaf 1)Ich installiere jetzt screen.$(tput sgr0)"
			echo "$DATUM $(date +%H:%M:%S) SERVERINSTALL: Ich installiere jetzt screen" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
			sudo apt-get -y install screen
	fi
	if dpkg-query -s git 2>/dev/null|grep -q installed; then
			echo "$(tput setaf 2)git ist installiert.$(tput sgr0)"
			echo "$DATUM $(date +%H:%M:%S) SERVERINSTALL: git ist installiert" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		else
			echo "$(tput setaf 1)Ich installiere jetzt git.$(tput sgr0)"
			echo "$DATUM $(date +%H:%M:%S) SERVERINSTALL: Ich installiere jetzt git" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
			sudo apt-get -y install git
	fi
	if dpkg-query -s nant 2>/dev/null|grep -q installed; then
			echo "$(tput setaf 2)nant ist installiert.$(tput sgr0)"
			echo "$DATUM $(date +%H:%M:%S) SERVERINSTALL: nant ist installiert" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		else
			echo "$(tput setaf 1)Ich installiere jetzt nant.$(tput sgr0)"
			echo "$DATUM $(date +%H:%M:%S) SERVERINSTALL: Ich installiere jetzt nant" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
			sudo apt-get -y install nant
	fi
	if dpkg-query -s libopenjp2-tools 2>/dev/null|grep -q installed; then
			echo "$(tput setaf 2)libopenjp2-tools ist installiert.$(tput sgr0)"
			echo "$DATUM $(date +%H:%M:%S) SERVERINSTALL: libopenjp2-tools ist installiert" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		else
			echo "$(tput setaf 1)Ich installiere jetzt libopenjp2-tools.$(tput sgr0)"
			echo "$DATUM $(date +%H:%M:%S) SERVERINSTALL: Ich installiere jetzt libopenjp2-tools" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
			sudo apt-get -y install libopenjp2-tools
	fi
	if dpkg-query -s graphicsmagick 2>/dev/null|grep -q installed; then
			echo "$(tput setaf 2)graphicsmagick ist installiert.$(tput sgr0)"
			echo "$DATUM $(date +%H:%M:%S) SERVERINSTALL: graphicsmagick ist installiert" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		else
			echo "$(tput setaf 1)Ich installiere jetzt graphicsmagick.$(tput sgr0)"
			echo "$DATUM $(date +%H:%M:%S) SERVERINSTALL: Ich installiere jetzt graphicsmagick" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
			sudo apt-get -y install graphicsmagick
	fi
	if dpkg-query -s imagemagick 2>/dev/null|grep -q installed; then
			echo "$(tput setaf 2)imagemagick ist installiert.$(tput sgr0)"
			echo "$DATUM $(date +%H:%M:%S) SERVERINSTALL: imagemagick ist installiert" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		else
			echo "$(tput setaf 1)Ich installiere jetzt imagemagick.$(tput sgr0)"
			echo "$DATUM $(date +%H:%M:%S) SERVERINSTALL: Ich installiere jetzt imagemagick" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
			sudo apt-get -y install imagemagick
	fi
	if dpkg-query -s curl 2>/dev/null|grep -q installed; then
			echo "$(tput setaf 2)curl ist installiert.$(tput sgr0)"
			echo "$DATUM $(date +%H:%M:%S) SERVERINSTALL: curl ist installiert" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		else
			echo "$(tput setaf 1)Ich installiere jetzt curl.$(tput sgr0)"
			echo "$DATUM $(date +%H:%M:%S) SERVERINSTALL: Ich installiere jetzt curl" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
			sudo apt-get -y install curl
	fi
	if dpkg-query -s php-cli 2>/dev/null|grep -q installed; then
			echo "$(tput setaf 2)php-cli ist installiert.$(tput sgr0)"
			echo "$DATUM $(date +%H:%M:%S) SERVERINSTALL: php-cli ist installiert" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		else
			echo "$(tput setaf 1)Ich installiere jetzt php-cli.$(tput sgr0)"
			echo "$DATUM $(date +%H:%M:%S) SERVERINSTALL: Ich installiere jetzt php-cli" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
			sudo apt-get -y install php-cli
	fi
	if dpkg-query -s php-bcmath 2>/dev/null|grep -q installed; then
			echo "$(tput setaf 2)php-bcmath ist installiert.$(tput sgr0)"
			echo "$DATUM $(date +%H:%M:%S) SERVERINSTALL: php-bcmath ist installiert" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		else
			echo "$(tput setaf 1)Ich installiere jetzt php-bcmath.$(tput sgr0)"
			echo "$DATUM $(date +%H:%M:%S) SERVERINSTALL: Ich installiere jetzt php-bcmath" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
			sudo apt-get -y install php-bcmath
	fi
	# Neu , dialog ist für dialogboxen und ungetestet.
	if dpkg-query -s dialog 2>/dev/null|grep -q installed; then
			echo "$(tput setaf 2)dialog ist installiert.$(tput sgr0)"
			echo "$DATUM $(date +%H:%M:%S) SERVERINSTALL: dialog ist installiert" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		else
			echo "$(tput setaf 1)Ich installiere jetzt dialog.$(tput sgr0)"
			echo "$DATUM $(date +%H:%M:%S) SERVERINSTALL: Ich installiere jetzt dialog" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
			sudo apt-get -y install dialog
	fi

##Zeitsteuerung
	if dpkg-query -s at 2>/dev/null|grep -q installed; then
			echo "$(tput setaf 2)at ist installiert.$(tput sgr0)"
			echo "$DATUM $(date +%H:%M:%S) SERVERINSTALL: at ist installiert" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		else
			echo "$(tput setaf 1)Ich installiere jetzt at.$(tput sgr0)"
			echo "$DATUM $(date +%H:%M:%S) SERVERINSTALL: Ich installiere jetzt at" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
			sudo apt-get -y install at
	fi

##Linux Handbuch in Deutsch
	if dpkg-query -s manpages-de 2>/dev/null|grep -q installed; then
			echo "$(tput setaf 2)Manual page DE ist installiert.$(tput sgr0)"
			echo "$DATUM $(date +%H:%M:%S) SERVERINSTALL: Manual page DE ist installiert" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
		else
			echo "$(tput setaf 1)Ich installiere jetzt manual page DE.$(tput sgr0)"
			echo "$DATUM $(date +%H:%M:%S) SERVERINSTALL: Ich installiere jetzt manual page DE" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
			sudo apt-get -y install manpages-de
			# Deutsch aktivieren
			alias man="man -L de_DE.utf8"
	fi

##Als letzte Maßnahmen noch Updaten und Upgraden und Server neu starten wegen Mono Threads.
	apt update
	apt upgrade
	apt -f install

	echo "$(tput setaf 1)Zum Abschluss sollte der ganze Server neu gestartet werden mit dem Kommando: $(tput sgr0) reboot now"
	echo "$DATUM $(date +%H:%M:%S) SERVERINSTALL: Zum Abschluss sollte der ganze Server neu gestartet werden" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
}

### Funktion installationen, Ubuntu 18 Server, Was habe ich alles auf meinem Server Installiert? sortiert auflisten.
function installationen() 
{
	echo "$(tput setaf 1)Liste aller Installierten Pakete unter Linux: $(tput sgr0)"
	dpkg-query -Wf '${Package;-40}${Priority}\n' | sort -b -k2,2 -k1,1
}

### Funktion osbuilding, test automation.
# Beispiel: opensim-0.9.2.0Dev-1187-gcf0b1b1.zip
# /opt/opensim.sh osbuilding 1187
function osbuilding() 
{
    VERSIONSNUMMER=$1
	
    cd /$STARTVERZEICHNIS || exit

	# Konfigurationsabfrage Neues Grid oder Upgrade.

	echo "$(tput setaf $Magenta)Alten OpenSimulator sichern$(tput sgr0)"
	echo "$DATUM $(date +%H:%M:%S) OSBUILDING: Alten OpenSimulator sichern" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
    osdelete

	echo " "

	echo "$(tput setaf $Magenta)Neuen OpenSimulator entpacken$(tput sgr0)"
	echo "$DATUM $(date +%H:%M:%S) OSBUILDING: Neuen OpenSimulator entpacken" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
    unzip $OSVERSION-"$VERSIONSNUMMER"-*.zip

	echo " "

	echo "$(tput setaf $Magenta)Neuen OpenSimulator umbenennen$(tput sgr0)"
	echo "$DATUM $(date +%H:%M:%S) OSBUILDING: Neuen OpenSimulator umbenennen" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
    mv /$STARTVERZEICHNIS/$OSVERSION-"$VERSIONSNUMMER"-*/ /$STARTVERZEICHNIS/opensim/

	echo " "

	echo "$(tput setaf $Magenta)Prebuild des neuen OpenSimulator starten$(tput sgr0)"
	echo "$DATUM $(date +%H:%M:%S) OSBUILDING: Prebuild des neuen OpenSimulator starten" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
    osprebuild "$VERSIONSNUMMER"

	echo " "

	echo "$(tput setaf $Magenta)Compilieren des neuen OpenSimulator$(tput sgr0)"
	echo "$DATUM $(date +%H:%M:%S) OSBUILDING: Compilieren des neuen OpenSimulator" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
    compilieren
    
    echo " " 
	
	# Hier darf erst weitergemacht werden wenn geprüft wurde ob das kompilieren ohne Fehler geschehen ist.
	#  msbuild /p:Configuration=Release || return 1 sollte bei Fehler mit return 1 beenden.

	echo "$(tput setaf $Magenta)Neuen OpenSimulator upgraden$(tput sgr0)"
	echo "$DATUM $(date +%H:%M:%S) OSBUILDING: Neuen OpenSimulator upgraden" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
    osupgrade
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

		echo "Kontrollausgabe: $VORNAME $NACHNAME $PASSWORT $EMAIL"

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
}

# Datenbank Befehle Achtung alles noch nicht ausgereift!!!

# function db_anzeigen, listt alle erstellten Datenbanken auf.
function db_anzeigen()
{
	DBBENUTZER=$1; DBPASSWORT=$2;

	echo "$(tput setaf $Magenta)PRINT DATABASE: Alle Datenbanken anzeigen. $(tput sgr0)"
	echo "$DATUM $(date +%H:%M:%S) PRINT DATABASE: Alle Datenbanken anzeigen" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"

	# 2>/dev/null verhindert die Fehlerausgabe - mysql warning using a password on the command line interface can be insecure. disable.
	mysql -u"$DBBENUTZER" -p"$DBPASSWORT" -e "show databases" 2>/dev/null
	mysql -u"$DBBENUTZER" -p"$DBPASSWORT" -e "show databases" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log" 2>/dev/null

	# Eingabe Variablen löschen
	unset DBBENUTZER
	unset DBPASSWORT
}

# function db_benutzer_anzeigen, alle angelegten Benutzer von mySQL anzeigen.
function db_benutzer_anzeigen()
{
	DBBENUTZER=$1; DBPASSWORT=$2;

	echo "$(tput setaf $Magenta)PRINT DATABASE USER: Alle Datenbankbenutzer anzeigen. $(tput sgr0)"
	echo "$DATUM $(date +%H:%M:%S) PRINT DATABASE USER: Alle Datenbankbenutzer anzeigen" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"

	# 2>/dev/null verhindert die Fehlerausgabe - mysql warning using a password on the command line interface can be insecure. disable.
	mysql -u"$DBBENUTZER" -p"$DBPASSWORT" -e "SELECT User FROM mysql.user" 2>/dev/null
	mysql -u"$DBBENUTZER" -p"$DBPASSWORT" -e "SELECT User FROM mysql.user" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log" 2>/dev/null

	# Eingabe Variablen löschen
	unset DBBENUTZER
	unset DBPASSWORT
}

# function create_db, erstellt eine neue Datenbank.
function create_db()
{
	DBBENUTZER=$1; DBPASSWORT=$2; DATENBANKNAME=$3;

	echo "$(tput setaf $Magenta)CREATE DATABASE: Datenbanken anlegen. $(tput sgr0)"
	echo "$DATUM $(date +%H:%M:%S) CREATE DATABASE: Datenbanken anlegen" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	echo "$DBBENUTZER, ********, $DATENBANKNAME" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"

	# 2>/dev/null verhindert die Fehlerausgabe - mysql warning using a password on the command line interface can be insecure. disable.
	mysql -u"$DBBENUTZER" -p"$DBPASSWORT" -e "CREATE DATABASE IF NOT EXISTS $DATENBANKNAME CHARACTER SET utf8 COLLATE utf8_general_ci" 2>/dev/null

	echo "$(tput setaf $Magenta)CREATE DATABASE: Datenbanken $DATENBANKNAME wurde angelegt. $(tput sgr0)"
	echo "$DATUM $(date +%H:%M:%S) CREATE DATABASE: Datenbanken $DATENBANKNAME wurde angelegt" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"

	# Eingabe Variablen löschen
	unset DBBENUTZER
	unset DBPASSWORT
	unset DATENBANKNAME
}

# function create_db_user - Operation CREATE USER failed - Fehler.
function create_db_user()
{
	DBBENUTZER=$1; DBPASSWORT=$2; NEUERNAME=$3; NEUESPASSWORT=$4;

	echo "$(tput setaf $Magenta)CREATE DATABASE USER: Datenbankbenutzer anlegen. $(tput sgr0)"
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
}

# function delete_db, löscht eine Datenbank.
function delete_db()
{
	DBBENUTZER=$1; DBPASSWORT=$2; DATENBANKNAME=$3;

	echo "$(tput setaf $Magenta)DELETE DATABASE: Datenbank löschen. $(tput sgr0)"
	echo "$DATUM $(date +%H:%M:%S) DELETE DATABASE: Datenbank löschen" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"

	echo "$DBBENUTZER, ********, $DATENBANKNAME" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	# 2>/dev/null verhindert die Fehlerausgabe - mysql warning using a password on the command line interface can be insecure. disable.
	mysql -u"$DBBENUTZER" -p"$DBPASSWORT" -e "DROP DATABASE $DATENBANKNAME" 2>/dev/null

	# Eingabe Variablen löschen
	unset DBBENUTZER
	unset DBPASSWORT
	unset DATENBANKNAME
}

# function leere_db, löscht eine Datenbank und erstellt diese anschließend neu.
function leere_db()
{
	DBBENUTZER=$1; DBPASSWORT=$2; DATENBANKNAME=$3;

	echo "$(tput setaf $Magenta)EMPTY DATABASE: Datenbank leeren. $(tput sgr0)"
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
}

# function allrepair_db, CHECK – REPAIR – ANALYZE – OPTIMIZE, alle Datenbanken.
function allrepair_db()
{
	DBBENUTZER=$1; DBPASSWORT=$2;

	echo "$(tput setaf $Magenta)ALL REPAIR DATABASE: Alle Datenbanken Checken, Reparieren und Optimieren. $(tput sgr0)"
	echo "$DATUM $(date +%H:%M:%S) ALL REPAIR DATABASE: Alle Datenbanken Checken, Reparieren und Optimieren" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"

	mysqlcheck -u"$DBBENUTZER" -p"$DBPASSWORT" --auto-repair --all-databases
	mysqlcheck -u"$DBBENUTZER" -p"$DBPASSWORT" --check --all-databases
	mysqlcheck -u"$DBBENUTZER" -p"$DBPASSWORT" --optimize --all-databases
	# Danach werden automatisiert folgende SQL Statements ausgeführt:
	# – CHECK TABLE
	# – REPAIR TABLE
	# – ANALYZE TABLE
	# – OPTIMIZE TABLE
	echo "$(tput setaf $Magenta)ALL REPAIR DATABASE: Fertig. $(tput sgr0)"
	echo "$DATUM $(date +%H:%M:%S) ALL REPAIR DATABASE: Fertig" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"

	# Eingabe Variablen löschen
	unset DBBENUTZER
	unset DBPASSWORT
}

# function mysql_neustart, startet mySQL neu.
function mysql_neustart()
{
	echo "$(tput setaf $Magenta)MYSQL RESTART: MySQL Neu starten. $(tput sgr0)"
	echo "$DATUM $(date +%H:%M:%S) MYSQL RESTART: MySQL Neu starten" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"

	echo "$(tput setaf $Red)MYSQL RESTART: Stoppen. $(tput sgr0)"
	service mysql stop
	sleep 2
	echo "$(tput setaf $Green)MYSQL RESTART: Starten. $(tput sgr0)"
	service mysql start
	echo "$(tput setaf $Magenta)MYSQL RESTART: Fertig. $(tput sgr0)"
}

# function db_sichern, sichert eine einzelne Datenbank.
function db_sichern()
{
	DBBENUTZER=$1; DBPASSWORT=$2; DATENBANKNAME=$3;

	echo "$(tput setaf $Magenta)SAVE DATABASE: Datenbank $DATENBANKNAME sichern. $(tput sgr0)"
	echo "$DATUM $(date +%H:%M:%S) SAVE DATABASE: Datenbank $DATENBANKNAME sichern" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"

	# 2>/dev/null verhindert die Fehlerausgabe - mysql warning using a password on the command line interface can be insecure. disable.
	mysqldump -u"$DBBENUTZER" -p"$DBPASSWORT" "$DATENBANKNAME" > /$STARTVERZEICHNIS/"$DATENBANKNAME".sql 2>/dev/null

	echo "$(tput setaf $Magenta)SAVE DATABASE: Im Hintergrund wird die Datenbank $DATENBANKNAME jetzt gesichert. $(tput sgr0)"
	echo "$DATUM $(date +%H:%M:%S) SAVE DATABASE: Im Hintergrund wird die Datenbank $DATENBANKNAME jetzt gesichert" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"

	# Eingabe Variablen löschen
	unset DBBENUTZER
	unset DBPASSWORT
	unset DATENBANKNAME
}

# function tabellenabfrage, listet alle Tabellen in einer Datenbank auf.
# Es geht hier um die machbarkeit und nicht den Sinn.
function tabellenabfrage()
{
	DBBENUTZER=$1; DBPASSWORT=$2; DATENBANKNAME=$3;
	
mysql -u"$DBBENUTZER" -p"$DBPASSWORT" <<MEINE_ABFRAGE_ENDE 2>/dev/null
USE $DATENBANKNAME
SHOW tables
MEINE_ABFRAGE_ENDE
}

# function regionsabfrage, Alle Regionen listen (Dies geht nur im Grid (Grid Datenbank) oder Standalone Modus).
function regionsabfrage()
{
	DBBENUTZER=$1; DBPASSWORT=$2; DATENBANKNAME=$3;	
mysql -u"$DBBENUTZER" -p"$DBPASSWORT" <<MEIN_ABFRAGE_ENDE 2>/dev/null
USE $DATENBANKNAME
SELECT regionName FROM regions
MEIN_ABFRAGE_ENDE
}

# function regionsuri, Region URI prüfen sortiert nach URI (Dies geht nur im Grid (Grid Datenbank) oder Standalone Modus).
function regionsuri()
{
	DBBENUTZER=$1; DBPASSWORT=$2; DATENBANKNAME=$3;	
mysql -u"$DBBENUTZER" -p"$DBPASSWORT" <<MEIN_ABFRAGE_ENDE 2>/dev/null
USE $DATENBANKNAME
SELECT regionName , serverURI FROM regions ORDER BY serverURI
MEIN_ABFRAGE_ENDE
}

# function regionsport, Ports prüfen sortiert nach Ports (Dies geht nur im Grid (Grid Datenbank) oder Standalone Modus).
function regionsport()
{
	DBBENUTZER=$1; DBPASSWORT=$2; DATENBANKNAME=$3;	
mysql -u"$DBBENUTZER" -p"$DBPASSWORT" <<MEIN_ABFRAGE_ENDE 2>/dev/null
USE $DATENBANKNAME
SELECT regionName , serverPort FROM regions ORDER BY serverPort
MEIN_ABFRAGE_ENDE
}

# function setpartner, Partner setzen bei einer Person. Also bei beiden Partnern muss dies gemacht werden.
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

	echo "$(tput setaf $Magenta)SETPARTNER: $NEUERPARTNER ist jetzt Partner von $AVATARUUID. $(tput sgr0)"
	echo "$DATUM $(date +%H:%M:%S) SETPARTNER: $NEUERPARTNER ist jetzt Partner von $AVATARUUID" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
}

# function conf_write, Konfiguration schreiben ersatz für alle UNGETESTETEN ini Funktionen.
# ./opensim.sh conf_write Einstellung NeuerParameter Verzeichnis Dateiname
function conf_write()
{
	CONF_SEARCH=$1; CONF_ERSATZ=$2; CONF_PFAD=$3; CONF_DATEINAME=$4;
	sed -i 's/'"$CONF_SEARCH"' =.*$/'"$CONF_SEARCH"' = '"$CONF_ERSATZ"'/' /"$CONF_PFAD"/"$CONF_DATEINAME"
	echo "Einstellung $CONF_SEARCH auf Parameter $CONF_ERSATZ geändert in Datei /$CONF_PFAD/$CONF_DATEINAME"
	echo "$DATUM $(date +%H:%M:%S) CONF_WRITE: Einstellung $CONF_SEARCH auf Parameter $CONF_ERSATZ geändert in Datei /$CONF_PFAD/$CONF_DATEINAME" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
}
# function conf_read, ganze Zeile aus der Konfigurationsdatei anzeigen.
# ./opensim.sh conf_read Einstellungsbereich Verzeichnis Dateiname
function conf_read()
{
    CONF_SEARCH=$1; CONF_PFAD=$2; CONF_DATEINAME=$3;
	sed -n -e '/'"$CONF_SEARCH"'/p' /"$CONF_PFAD"/"$CONF_DATEINAME"
    echo "Einstellung $CONF_SEARCH suchen in Datei /$CONF_PFAD/$CONF_DATEINAME"
	echo "$DATUM $(date +%H:%M:%S) CONF_WRITE: Einstellung $CONF_SEARCH suchen in Datei /$CONF_PFAD/$CONF_DATEINAME" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
}
# function conf_delete, ganze Zeile aus der Konfigurationsdatei löschen.
# ./opensim.sh conf_delete Einstellungsbereich Verzeichnis Dateiname
function conf_delete()
{
    CONF_SEARCH=$1; CONF_PFAD=$2; CONF_DATEINAME=$3;
	sed -i 's/'"$CONF_SEARCH"' =.*$/''/' /"$CONF_PFAD"/"$CONF_DATEINAME"
    echo "Zeile $CONF_SEARCH gelöscht in Datei /$CONF_PFAD/$CONF_DATEINAME"
	echo "$DATUM $(date +%H:%M:%S) CONF_DELETE: Zeile $CONF_SEARCH gelöscht in Datei /$CONF_PFAD/$CONF_DATEINAME" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
}

# function ramspeicher, den echten RAM Speicher auslesen.
function ramspeicher()
{
	# RAM größe auslesen
	dmidecode --type 17 > /tmp/raminfo.inf
	RAMSPEICHER=$(awk -F ":" '/Size/ {print $2}' /tmp/raminfo.inf)
	rm /tmp/raminfo.inf
	# Zeichen löschen
	RAMSPEICHER="${RAMSPEICHER:1}" # erstes Zeichen löschen
	RAMSPEICHER="${RAMSPEICHER::-3}" # letzten 3 Zeichen löschen
}

# function mysqleinstellen, ermitteln wieviel RAM Speicher vorhanden ist und anschließend mySQL Einstellen.
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
	} >> "/etc/mysql/mysql.conf.d/mysqld.cnf"
	# /etc/mysql/mysql.conf.d/mysqld.cnf
	# /etc/mysql/my.cnf

	# MySQL neu starten
	mysql_neustart
}

# In Arbeit
function neuegridconfig()
{
	echo "$(tput setaf $Green)NEUEGRIDCONFIG: Konfigurationsdateien holen und in das ExampleConfig Verzeichnis kopieren. $(tput sgr0)"
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

}

# function ipsetzen, setzt nach Abfrage die IP in die Konfigurationen. OK
function ipsetzen()
{
	cd /"$STARTVERZEICHNIS/ExampleConfig" || return 1 # gibt es das ExampleConfig Verzeichnis wenn nicht abbruch.

	EINGABEIP=""
	echo "$(tput setaf $Green)IPSETZEN: Bitte geben Sie ihre externe IP ein oder drücken sie Enter für $(tput sgr0) $AKTUELLEIP"
	
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

	echo "$(tput setaf $Green)IPSETZEN: IP oder DNS Einstellungen geändert. $(tput sgr0)"
	echo "$DATUM $(date +%H:%M:%S) IPSETZEN: IP oder DNS Einstellungen geändert" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
}

# Aktuelle IP in die Robust.ini schreiben. UNGETESTET
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
}
# Aktuelle IP in die MoneyServer.ini schreiben. UNGETESTET
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
}
# Aktuelle IP in die OpenSim.ini schreiben.
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
}
# Aktuelle IP in die GridCommon.ini schreiben. UNGETESTET
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

}

# regionini Simulator Dateiname
# Aktuelle IP in die Regions.ini schreiben. UNGETESTET
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
}

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
}
# Hier entsteht die Automatische Konfiguration. UNGETESTET
function autoconfig()
{
	$AUTOCONFIG # yes oder no
	echo "ohne Funktion!"
}
### Funktion info, Informationen auf den Bildschirm ausgeben.
function info()
{
	echo "$(tput setab $Blue) Server Name: ${HOSTNAME}"
	echo " Bash Version: ${BASH_VERSION}"
	echo " Server IP: ${AKTUELLEIP}"
	echo " MONO THREAD Einstellung: ${MONO_THREADS_PER_CPU}"
	echo " Spracheinstellung: ${LANG} $(tput sgr 0)"
}

### Funktion hilfe, Hilfe auf dem Bildschirm anzeigen.
function hilfe()
{
echo "$(tput setab $Magenta)Funktion:$(tput sgr 0)		$(tput setab $Green)Parameter:$(tput sgr 0)		$(tput setab $Blue)Informationen:$(tput sgr 0)"
	echo "hilfe 			- $(tput setaf $Yello)hat keine Parameter$(tput sgr 0)	- Diese Hilfe."
	echo "konsolenhilfe 		- $(tput setaf $Yello)hat keine Parameter$(tput sgr 0)	- konsolenhilfe ist eine Hilfe für Putty oder Xterm."
	echo "restart 		- $(tput setaf $Yello)hat keine Parameter$(tput sgr 0)	- Startet das gesamte Grid neu."
	echo "autostop 		- $(tput setaf $Yello)hat keine Parameter$(tput sgr 0)	- Stoppt das gesamte Grid."
	echo "autostart 		- $(tput setaf $Yello)hat keine Parameter$(tput sgr 0)	- Startet das gesamte Grid."
	echo "works 			- $(tput setab $Magenta)Verzeichnisname$(tput sgr 0)	- Einzelne screens auf Existenz prüfen."
	echo "osstart 		- $(tput setab $Magenta)Verzeichnisname$(tput sgr 0)	- Startet einen einzelnen Simulator."
	echo "osstop 			- $(tput setab $Magenta)Verzeichnisname$(tput sgr 0)	- Stoppt einen einzelnen Simulator."
	echo "meineregionen 		- $(tput setaf $Yello)hat keine Parameter$(tput sgr 0)   - listet alle Regionen aus den Konfigurationen auf."
	echo "autologdel		- $(tput setaf $Yello)hat keine Parameter$(tput sgr 0)	- Löscht alle Log Dateien."
	echo "automapdel		- $(tput setaf $Yello)hat keine Parameter$(tput sgr 0)	- Löscht alle Map Karten."

echo "$(tput setab $Yello)Erweiterte Funktionen$(tput sgr 0)"
	echo "regionbackup 		- $(tput setab $Magenta)Verzeichnisname$(tput sgr 0) $(tput setab $Blue)Regionsname$(tput sgr 0) - Backup einer ausgewählten Region."
	echo "assetdel 		- $(tput setab $Magenta)screen_name$(tput sgr 0) $(tput setab $Blue)Regionsname$(tput sgr 0) $(tput setab $Green)Objektname$(tput sgr 0) - Einzelnes Asset löschen."
	echo "oscommand 		- $(tput setab $Magenta)Verzeichnisname$(tput sgr 0) $(tput setab $Yello)Region$(tput sgr 0) $(tput setab $Blue)Konsolenbefehl Parameter$(tput sgr 0) - Konsolenbefehl senden."
	echo "gridstart 		- $(tput setaf $Yello)hat keine Parameter$(tput sgr 0) - Startet Robust und Money. "
	echo "gridstop 		- $(tput setaf $Yello)hat keine Parameter$(tput sgr 0) - Beendet Robust und Money. "
	echo "rostart 		- $(tput setaf $Yello)hat keine Parameter$(tput sgr 0) - Startet Robust Server."
	echo "rostop 			- $(tput setaf $Yello)hat keine Parameter$(tput sgr 0) - Stoppt Robust Server."
	echo "mostart 		- $(tput setaf $Yello)hat keine Parameter$(tput sgr 0) - Startet Money Server."
	echo "mostop 			- $(tput setaf $Yello)hat keine Parameter$(tput sgr 0) - Stoppt Money Server."
	echo "autosimstart 		- $(tput setaf $Yello)hat keine Parameter$(tput sgr 0) - Startet alle Regionen."
	echo "autosimstop 		- $(tput setaf $Yello)hat keine Parameter$(tput sgr 0) - Beendet alle Regionen. "
	echo "autoscreenstop		- $(tput setaf $Yello)hat keine Parameter$(tput sgr 0) - Killt alle OpenSim Screens."
	echo "logdel 			- $(tput setab $Magenta)Verzeichnisname$(tput sgr 0)     - Löscht alle Simulator Log Dateien im Verzeichnis."
	echo "mapdel 			- $(tput setab $Magenta)Verzeichnisname$(tput sgr 0)     - Löscht alle Simulator Map-Karten im Verzeichnis."
	echo "settings 		- $(tput setaf $Yello)hat keine Parameter$(tput sgr 0) - setzt Linux Einstellungen."
	echo "configlesen 		- $(tput setab $Magenta)Verzeichnisname$(tput sgr 0)     - Alle Regionskonfigurationen im Verzeichnis anzeigen."

echo "$(tput setab $Red)Experten Funktionen$(tput sgr 0)"
	echo "osupgrade 		- $(tput setaf $Yello)hat keine Parameter$(tput sgr 0) - Installiert eine neue OpenSim Version."
	echo "autoregionbackup	- $(tput setaf $Yello)hat keine Parameter$(tput sgr 0) - Backup aller Regionen."
	echo "oscopy			- $(tput setab $Magenta)Verzeichnisname$(tput sgr 0)     - Kopiert den Simulator."
	echo "osstruktur		- $(tput setab $Magenta)ersteSIM$(tput sgr 0) $(tput setab $Blue)letzteSIM$(tput sgr 0)  - Legt eine Verzeichnisstruktur an."
	echo "osprebuild		- $(tput setab $Green)Versionsnummer$(tput sgr 0)      - Aendert die Versionseinstellungen 0.9.2.XXXX"
	echo "compilieren 		- $(tput setaf $Yello)hat keine Parameter$(tput sgr 0) - Kopiert fehlende Dateien und Kompiliert."
	echo "oscompi 		- $(tput setaf $Yello)hat keine Parameter$(tput sgr 0) - Kompiliert einen neuen OpenSimulator ohne kopieren."
	echo "scriptcopy 		- $(tput setaf $Yello)hat keine Parameter$(tput sgr 0) - Kopiert die Scripte in den Source."
	echo "moneycopy 		- $(tput setaf $Yello)hat keine Parameter$(tput sgr 0) - Kopiert Money Source in den OpenSimulator Source."
	echo "osdelete 		- $(tput setaf $Yello)hat keine Parameter$(tput sgr 0) - Löscht alte OpenSim Version."
	echo "regionsiniteilen 	- $(tput setab $Magenta)Verzeichnisname$(tput sgr 0) $(tput setab $Yello)Region$(tput sgr 0) - kopiert aus der Regions.ini eine Region heraus."
	echo "autoregionsiniteilen 	- $(tput setaf $Yello)hat keine Parameter$(tput sgr 0) - aus allen Regions.ini alle Regionen vereinzeln."
	echo "RegionListe 		- $(tput setaf $Yello)hat keine Parameter$(tput sgr 0) - Die RegionList.ini erstellen."
	echo "Regionsdateiliste 	- $(tput setab $Blue)-b Bildschirm oder -d Datei$(tput sgr 0) $(tput setab $Magenta)Verzeichnisname$(tput sgr 0) - Regionsdateiliste erstellen."
	echo "osgitholen 		- $(tput setaf $Yello)hat keine Parameter$(tput sgr 0) - kopiert eine OpenSimulator Git Entwicklerversion."
	echo "terminator 		- $(tput setaf $Yello)hat keine Parameter$(tput sgr 0) - Killt alle laufenden Screens."

echo "$(tput setab $Red)Ungetestete oder zu testende Funktionen$(tput sgr 0)"
	echo "makeaot			- $(tput setaf $Yello)hat keine Parameter$(tput sgr 0) - aot Dateien erstellen."
	echo "cleanaot		- $(tput setaf $Yello)hat keine Parameter$(tput sgr 0) - aot Dateien entfernen."
	echo "monoinstall		- $(tput setaf $Yello)hat keine Parameter$(tput sgr 0) - mono 6.x installation."
	echo "installationen		- $(tput setaf $Yello)hat keine Parameter$(tput sgr 0) - Linux Pakete - installationen aufisten."
	echo "serverinstall		- $(tput setaf $Yello)hat keine Parameter$(tput sgr 0) - alle benötigten Linux Pakete installieren."
	echo "osbuilding		- $(tput setab $Magenta)Versionsnummer$(tput sgr 0) - Upgrade des OpenSimulator aus einer Source ZIP Datei."
	echo "createuser 		- $(tput setab $Magenta) Vorname $(tput sgr 0) $(tput setab $Blue) Nachname $(tput sgr 0) $(tput setab $Green) Passwort $(tput sgr 0) $(tput setab $Yello) E-Mail $(tput sgr 0) - Grid Benutzer anlegen."
echo " "
	echo "db_anzeigen	- $(tput setab $Magenta) DBBENUTZER $(tput sgr 0) $(tput setab $Blue) DBDATENBANKNAME $(tput sgr 0) - Alle Datenbanken anzeigen."
	echo "create_db	- $(tput setab $Magenta) DBBENUTZER $(tput sgr 0) $(tput setab $Blue) DBPASSWORT $(tput sgr 0) $(tput setab $Green) DATENBANKNAME $(tput sgr 0) - Datenbank anlegen."
	#echo "create_db_user	- $(tput setab $Magenta) DBBENUTZER $(tput sgr 0) $(tput setab $Blue) DBDATENBANKNAME $(tput sgr 0) $(tput setab $Green) NEUERNAME $(tput sgr 0) $(tput setab $Yello) NEUESPASSWORT $(tput sgr 0) - DB Benutzer anlegen."
	echo "delete_db	- $(tput setab $Magenta) DBBENUTZER $(tput sgr 0) $(tput setab $Blue) DBPASSWORT $(tput sgr 0) $(tput setab $Green) DATENBANKNAME $(tput sgr 0) - Datenbank löschen."
	echo "leere_db	- $(tput setab $Magenta) DBBENUTZER $(tput sgr 0) $(tput setab $Blue) DBPASSWORT $(tput sgr 0) $(tput setab $Green) DATENBANKNAME $(tput sgr 0) - Datenbank leeren."
	echo "allrepair_db	- $(tput setab $Magenta) DBBENUTZER $(tput sgr 0) $(tput setab $Blue) DBPASSWORT $(tput sgr 0) - Alle Datenbanken Reparieren und Optimieren."
	echo "db_sichern	- $(tput setab $Magenta) DBBENUTZER $(tput sgr 0) $(tput setab $Blue) DBPASSWORT $(tput sgr 0) $(tput setab $Green) DATENBANKNAME $(tput sgr 0) - Datenbank sichern."
	echo "mysql_neustart	- $(tput setaf $Yello)hat keine Parameter$(tput sgr 0) - MySQL neu starten."

	echo "regionsabfrage	- $(tput setab $Magenta) DBBENUTZER $(tput sgr 0) $(tput setab $Blue) DBPASSWORT $(tput sgr 0) $(tput setab $Green) DATENBANKNAME $(tput sgr 0) - Regionsliste."
	echo "regionsuri	- $(tput setab $Magenta) DBBENUTZER $(tput sgr 0) $(tput setab $Blue) DBPASSWORT $(tput sgr 0) $(tput setab $Green) DATENBANKNAME $(tput sgr 0) - URI prüfen sortiert nach URI."
	echo "regionsport	- $(tput setab $Magenta) DBBENUTZER $(tput sgr 0) $(tput setab $Blue) DBPASSWORT $(tput sgr 0) $(tput setab $Green) DATENBANKNAME $(tput sgr 0) - Ports prüfen sortiert nach Ports."

	echo "opensimholen	- $(tput setaf $Yello)hat keine Parameter$(tput sgr 0) - Lädt eine Reguläre OpenSimulator Version herunter."
	echo "mysqleinstellen	- $(tput setaf $Yello)hat keine Parameter$(tput sgr 0) - mySQL Konfiguration auf Server Einstellen und neu starten."
	echo "conf_write	- $(tput setab $Magenta) SUCHWORT $(tput sgr 0) $(tput setab $Blue) ERSATZWORT $(tput sgr 0) $(tput setab $Green) PFAD $(tput sgr 0) $(tput setab $Yello) DATEINAME $(tput sgr 0) - Konfigurationszeile schreiben."
	echo "conf_delete	- $(tput setab $Magenta) SUCHWORT $(tput sgr 0) $(tput setab $Blue) PFAD $(tput sgr 0) $(tput setab $Green) DATEINAME $(tput sgr 0) - Konfigurationszeile löschen."
	echo "conf_read	- $(tput setab $Magenta) SUCHWORT $(tput sgr 0) $(tput setab $Blue) PFAD $(tput sgr 0) $(tput setab $Green) DATEINAME $(tput sgr 0) - Konfigurationszeile lesen."
	echo "landclear 	- $(tput setab $Magenta)screen_name$(tput sgr 0) $(tput setab $Blue)Regionsname$(tput sgr 0) - Land clear - Löscht alle Parzellen auf dem Land."

	echo " "
	echo "loadinventar - $(tput setab $Magenta)NAME VERZEICHNIS PASSWORD DATEINAMEmitPFAD $(tput sgr 0) - lädt Inventar aus einer iar"
	echo "saveinventar - $(tput setab $Magenta)NAME VERZEICHNIS PASSWORD DATEINAMEmitPFAD $(tput sgr 0) - speichert Inventar in einer iar"

	echo " "
	echo "$(tput setaf $Yello)  Der Verzeichnisname ist gleichzeitig auch der Screen Name!$(tput sgr 0)"
	echo "$DATUM $(date +%H:%M:%S) HILFE: Hilfe wurde angefordert" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
}

### Funktion konsolenhilfe, konsolenhilfe auf dem Bildschirm anzeigen.
function konsolenhilfe()
{
	echo "$(tput setab $Magenta)Funktion:$(tput sgr 0) $(tput setab $Blue)Informationen:$(tput sgr 0)"
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
$(tput setab $Red)
Help OpenSim Commands:
Aufruf: oscommand Screen Region "Befehl mit Parameter in Hochstrichen"
Beispiel: /opt/opensim.sh oscommand sim1 Welcome "alert Hallo liebe Leute dies ist eine Nachricht"
$(tput sgr 0)

$(tput setab $Red)A$(tput sgr 0)
alert <Nachricht> - sendet eine Nachricht an alle.
alert-user <Vorname> <Nachname> <Nachricht> - sendet eine Nachricht an eine bestimmte Person. 
appearance find <uuid-oder-start-der-uuid> - herausfinden welcher Avatar das angegebene Asset als gebackene Textur verwendet, falls vorhanden.
appearance rebake <Vorname> <Nachname> - Sendet eine Anfrage an den Viewer des Benutzers, damit er seine Aussehenstexturen neu backen und hochladen kann.
appearance send <Vorname> <Nachname> - Sendet Aussehensdaten für jeden Avatar im Simulator an andere Viewer. 

$(tput setab $Red)B$(tput sgr 0)
backup - Das momentan nicht gespeicherte Objekt wird sofort geändert, anstatt auf den normalen Speicheraufruf zu warten.
bypass permissions <true / false> - Berechtigungsprüfungen umgehen.

$(tput setab $Red)C$(tput sgr 0)
change region <Regionsname> - Ändere die aktuelle Region in der Konsole.
clear image queues <Vorname> <Nachname> - Löscht die Bildwarteschlangen (über UDP heruntergeladene Texturen) für einen bestimmten Client.
command-script <Skript> - Ausführen eines Befehlsskripts aus einer Datei.
config save <Pfad> - Speichert die aktuelle Konfiguration in einer Datei unter dem angegebenen Pfad.
config set <Sektion> <key> <value> - Legt eine Konfigurationsoption fest. Dies ist in den meisten Fällen nicht sinnvoll, da geänderte Parameter nicht dynamisch nachgeladen werden. Geänderte Parameter bleiben auch nicht bestehen - Sie müssen eine Konfigurationsdatei manuell ändern und neu starten.
create region ["Regionsname"] <Regionsdatei.ini> - Erstellt eine neue Region. 

$(tput setab $Red)D$(tput sgr 0)
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
 
$(tput setab $Red)E$(tput sgr 0)
edit scale <name> <x> <y> <z> - Ändert die Größe des benannten Prim.
estate create <owner UUID> <estate name> - Erstellt ein neues Anwesen mit dem angegebenen Namen, das dem angegebenen Benutzer gehört. Der Name des Anwesens muss eindeutig sein.
estate link region <estate ID> <region ID> - Hängt die angegebene Region an die angegebene Domain an.
estate set name <estate-id> <new name> - Setzt den Namen des angegebenen Anwesens auf den angegebenen Wert. Der neue Name muss eindeutig sein.
estate set owner <estate-id>[ <UUID> | <Vorname> <Nachname> ] - Setzt den Besitzer des angegebenen Anwesens auf die angegebene UUID oder den angegebenen Benutzer.
export-map [<Pfad>] - Speichert ein Bild der Karte.

$(tput setab $Red)F$(tput sgr 0)
fcache assets - Versucht alle Assets in allen Szenen gründlich zu scannen und zwischenzuspeichern.
fcache cachedefaultassets - lädt lokale Standardassets in den Cache. Dies kann Rasterfelder überschreiben, mit Vorsicht verwenden.
fcache clear [file] [memory] - Entfernt alle Assets im Cache. Wenn Datei oder Speicher angegeben ist, wird nur dieser Cache geleert.
fcache deletedefaultassets - löscht standardmäßige lokale Assets aus dem Cache, damit sie aus dem Raster aktualisiert werden können, mit Vorsicht verwenden.
fcache expire <datetime(mm/dd/YYYY)> - Löscht zwischengespeicherte Assets, die älter als das angegebene Datum oder die angegebene Uhrzeit sind.
force gc - Ruft die Garbage Collection zur Laufzeit manuell auf. Für Debugging-Zwecke.
force permissions <true / false> - Berechtigungen ein- oder ausschalten.
force update - Erzwinge die Aktualisierung aller Objekte auf Clients.

$(tput setab $Red)G$(tput sgr 0)
generate map - Erzeugt und speichert ein neues Kartenstück.

$(tput setab $Red)J$(tput sgr 0)
j2k decode <ID> - Führt die JPEG2000 Decodierung eines Assets durch.

$(tput setab $Red)K$(tput sgr 0)
kick user <first> <last> [--force] [message] - Einen Benutzer aus dem Simulator werfen.

$(tput setab $Red)L$(tput sgr 0)
land clear - Löscht alle Parzellen aus der Region.
link-mapping [<x> <y>] - Stellt lokale Koordinaten ein, um HG Regionen abzubilden.
link-region <Xloc> <Yloc> <ServerURI> [<RemoteRegionName>] - Verknüpft eine HyperGrid Region.
load iar [-m|--merge] <first> <last> <inventory path> <password> [<IAR path>] - Benutzerinventararchiv (IAR) laden.
load oar [-m|--merge] [-s|--skip-assets] [--default-user "User Name"] [--merge-terrain] [--merge-parcels] [--mergeReplaceObjects] [--no-objects] [--rotation degrees] [--bounding-origin "<x,y,z>"] [--bounding-size "<x,y,z>"] [--displacement "<x,y,z>"] [-d|--debug] [<OAR path>] - Laden der Daten einer Region aus einem OAR Archiv.
load xml [<file name> [-newUID [<x> <y> <z>]]] - Laden der Daten einer Region aus dem XML-Format.
load xml2 [<file name>] - Laden Sie die Daten einer Region aus dem XML2-Format.
login disable - Simulator Logins deaktivieren.
login enable - Simulator Logins aktivieren.

$(tput setab $Red)P$(tput sgr 0)
physics set <param> [<value>|TRUE|FALSE] [localID|ALL] - Setzt Physikparameter aus der aktuell ausgewählten Region.

$(tput setab $Red)Q$(tput sgr 0)
quit - Beenden Sie die Anwendung.

$(tput setab $Red)R$(tput sgr 0)
region restart abort [<message>] - Einen Neustart der Region abbrechen.
region restart bluebox <message> <delta seconds>+ - Planen eines Regionsneustart.
region restart notice <message> <delta seconds>+ - Planen eines Neustart der Region.
region set - Stellt Steuerinformationen für die aktuell ausgewählte Region ein.
remove-region <name> - Entferne eine Region aus diesem Simulator.
reset user cache - Benutzercache zurücksetzen, damit geänderte Einstellungen übernommen werden können.
restart - Startet die aktuell ausgewählte(n) Region(en) in dieser Instanz neu.
rotate scene <degrees> [centerX, centerY] - Dreht alle Szenenobjekte um centerX, centerY (Standard 128, 128) (bitte sichern Sie Ihre Region vor der Verwendung).

$(tput setab $Red)S$(tput sgr 0)
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

$(tput setab $Red)T$(tput sgr 0)
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

$(tput setab $Red)U$(tput sgr 0)
unlink-region <local name> - Verknüpfung einer Hypergrid-Region aufheben

$(tput setab $Red)V$(tput sgr 0)
vivox debug <on>|<off> - Einstellen des vivox-Debuggings

$(tput setab $Red)W$(tput sgr 0)
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

function hauptmenu()
{
	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null|grep -q installed; then
		# dialog --menu
		mauswahl=$(dialog --backtitle "opensimMULTITOOL $VERSION" --help-button --menu "OPENSIM MULTITOOL $VERSION" 0 35 0 \
		Restart ""\
		Stop ""\
		Start ""\
		"Server Informationen" ""\
		Kalender ""\
		"Weitere Funktionen" "" 3>&1 1>&2 2>&3)
		antwort=$?
		dialog --clear
		clear		
		if [[ $mauswahl = "Server Informationen" ]]; then infodialog; fi
		if [[ $mauswahl = "Kalender" ]]; then kalender; fi
		if [[ $mauswahl = "Start" ]]; then autostart; fi
		if [[ $mauswahl = "Stop" ]]; then autostop; fi
		if [[ $mauswahl = "Restart" ]]; then autorestart; fi
		if [[ $mauswahl = "Weitere Funktionen" ]]; then funktionenmenu; fi
		if [[ $mauswahl = "Hilfe" ]]; then hilfemenu; fi
		if [[ $antwort = 2 ]]; then hilfemenu ; fi
		if [[ $antwort = 1 ]]; then exit ; fi
	else
		# wenn dialog nicht installiert ist die Hilfe anzeigen.
		hilfe
	fi
}
function hilfemenu()
{
	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null|grep -q installed; then
		# dialog --radiolist
		# Name : menu1
		hauswahl=$(dialog --backtitle "opensimMULTITOOL $VERSION" --help-button --menu "OPENSIM MULTITOOL $VERSION" 0 45 0 \
		Hilfe ""\
		Konsolenhilfe ""\
		Kommandohilfe "" 3>&1 1>&2 2>&3)
		antwort=$?
		dialog --clear
		clear
		if [[ $hauswahl = "Hilfe" ]]; then hilfe; fi
		if [[ $hauswahl = "Konsolenhilfe" ]]; then konsolenhilfe; fi
		if [[ $hauswahl = "Kommandohilfe" ]]; then commandhelp; fi
		if [[ $antwort = 2 ]]; then hilfemenu ; fi
		if [[ $antwort = 1 ]]; then exit ; fi
	else
		# wenn dialog nicht installiert ist die Hilfe anzeigen.
		hilfe
	fi
}
function funktionenmenu()
{
	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null|grep -q installed; then
		# dialog --menu
		fauswahl=$(dialog --backtitle "opensimMULTITOOL $VERSION" --help-button --defaultno --menu "OPENSIM MULTITOOL $VERSION" 0 45 0 \
		"Grid starten" ""\
		"Grid stoppen" ""\
		"Robust starten" ""\
		"Robust stoppen" ""\
		"Money starten" ""\
		"Money stoppen" ""\
		"Automatischer Sim start" ""\
		"Automatischer Sim stop" ""\
		"Automatischer Screen stop" ""\
		"Regionen anzeigen" ""\
		"Log Dateien löschen" ""\
		"Map Karten löschen" ""\
		"Experten Funktionen" "" 3>&1 1>&2 2>&3)
		antwort=$?
		dialog --clear
		clear
		if [[ $fauswahl = "Grid starten" ]]; then gridstart; fi
		if [[ $fauswahl = "Grid stoppen" ]]; then gridstop; fi
		if [[ $fauswahl = "Robust starten" ]]; then rostart; fi
		if [[ $fauswahl = "Robust stoppen" ]]; then rostop; fi
		if [[ $fauswahl = "Money starten" ]]; then mostart; fi
		if [[ $fauswahl = "Money stoppen" ]]; then mostop; fi
		if [[ $fauswahl = "Automatischer Sim start" ]]; then autosimstart; fi
		if [[ $fauswahl = "Automatischer Sim stop" ]]; then autosimstop; fi
		if [[ $fauswahl = "Automatischer Screen stop" ]]; then autoscreenstop; fi
		if [[ $fauswahl = "Regionen anzeigen" ]]; then meineregionen; fi
		if [[ $fauswahl = "Log Dateien löschen" ]]; then autologdel; fi
		if [[ $fauswahl = "Map Karten löschen" ]]; then automapdel; fi
		if [[ $fauswahl = "Experten Funktionen" ]]; then expertenmenu; fi
		if [[ $fauswahl = "Hilfe" ]]; then hilfemenu; fi
		if [[ $antwort = 2 ]]; then hilfemenu ; fi
		if [[ $antwort = 1 ]]; then exit ; fi
	else
		# wenn dialog nicht installiert ist die Hilfe anzeigen.
		hilfe
	fi
}
function expertenmenu()
{
	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null|grep -q installed; then
		# dialog --menu
		feauswahl=$(dialog --backtitle "opensimMULTITOOL $VERSION" --help-button --defaultno --menu "OPENSIM MULTITOOL $VERSION" 0 45 0 \
		"Voreinstellungen setzen" ""\
		"Opensimulator upgraden" ""\
		"Automatischer Regionsbackup" ""\
		"Kompilieren" ""\
		"oscompi" ""\
		"autoregionsiniteilen" ""\
		"RegionListe" ""\
		"Opensim aus dem git holen" ""\
		"terminator" ""\
		"makeaot" ""\
		"cleanaot" ""\
		"Installationen anzeigen" ""\
		"Server Installation" "" 3>&1 1>&2 2>&3)
		antwort=$?
		dialog --clear
		clear
		if [[ $feauswahl = "Voreinstellungen setzen" ]]; then settings; fi
		if [[ $feauswahl = "Opensimulator upgraden" ]]; then osupgrade; fi
		if [[ $feauswahl = "Automatischer Regionsbackup" ]]; then autoregionbackup; fi
		if [[ $feauswahl = "Kompilieren" ]]; then compilieren; fi
		if [[ $feauswahl = "oscompi" ]]; then oscompi; fi
		if [[ $feauswahl = "autoregionsiniteilen" ]]; then autoregionsiniteilen; fi
		if [[ $feauswahl = "RegionListe" ]]; then RegionListe; fi
		if [[ $feauswahl = "Opensim aus dem git holen" ]]; then osgitholen; fi
		if [[ $feauswahl = "terminator" ]]; then terminator; fi
		if [[ $feauswahl = "makeaot" ]]; then makeaot; fi
		if [[ $feauswahl = "cleanaot" ]]; then cleanaot; fi
		if [[ $feauswahl = "Installationen anzeigen" ]]; then installationen; fi
		if [[ $feauswahl = "Server Installation" ]]; then serverinstall; fi
		if [[ $feauswahl = "Hilfe" ]]; then hilfemenu; fi
		if [[ $antwort = 2 ]]; then hilfemenu ; fi
		if [[ $antwort = 1 ]]; then exit ; fi
	else
		# wenn dialog nicht installiert ist die Hilfe anzeigen.
		hilfe
	fi
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
function kalender()
{
	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null|grep -q installed; then
		CDATUM=$(date +%d %m %Y)
		# dialog --calendar
		dialog --backtitle "opensimMULTITOOL $VERSION" --no-cancel --calendar Calendar 0 0 "$CDATUM"
		dialog --clear
		#clear
		hauptmenu
	else
		# wenn dialog nicht installiert ist die Hilfe anzeigen.
		hilfe
	fi
}
function fortschritsanzeige()
{
	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null|grep -q installed; then
        # Demonstriert dialog --gauge für eine Fortschritsanzeige
        DIALOG=dialog
        (
        echo "10" ; sleep 1
        echo "XXX" ; echo "Alle Daten werden gesichert"; echo "XXX"
        echo "20" ; sleep 1
        echo "50" ; sleep 1
        echo "XXX" ; echo "Alle Daten werden archiviert"; echo "XXX"
        echo "75" ; sleep 1
        echo "XXX" ; echo "Daten werden ins Webverzeichnis hochgeladen";
        echo "XXX"
        echo "100" ; sleep 3
        ) |
        $DIALOG --title "Fortschrittszustand" --gauge "Starte Backup-Script" 8 30
        $DIALOG --clear
        $DIALOG --msgbox "Arbeit erfolgreich beendet ..." 0 0
        $DIALOG --clear
        clear
	else
		# wenn dialog nicht installiert ist die Hilfe anzeigen.
		hilfe
	fi
}
### Eingabeauswertung:
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
	*) hauptmenu ;;
esac

echo "$DATUM $(date +%H:%M:%S) opensimMULTITOOL wurde beendet." >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
echo "#######################################################" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
vardel
