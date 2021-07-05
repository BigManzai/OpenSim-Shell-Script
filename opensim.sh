#!/bin/bash

# opensimMULTITOOL Version 0.37.113 Copyright (c) 2021 BigManzai Manfred Aabye
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
echo "	    $(tput setaf 2)opensim$(tput setaf 4)MULTITOOL$(tput sgr 0) 0.37.113" # Versionsausgabe
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
{	unset STARTVERZEICHNIS
	unset MONEYVERZEICHNIS
	unset ROBUSTVERZEICHNIS
	unset WARTEZEIT
	unset STARTWARTEZEIT
	unset STOPWARTEZEIT
	unset MONEYWARTEZEIT
	unset Red
	unset Green
	unset White
}

### myshellschreck, ShellCheck ueberlisten, hat sonst keinerlei Funktion und wird auch nicht aufgerufen.
function myshellschreck()
{
STARTVERZEICHNIS="opt" MONEYVERZEICHNIS="robust" ROBUSTVERZEICHNIS="robust" OPENSIMVERZEICHNIS="opensim" SCRIPTSOURCE="ScriptNeu" MONEYSOURCE="money48" OSVERSION="opensim-0.9.2.0Dev"
REGIONSDATEI="RegionList.ini" SIMDATEI="SimulatorList.ini" WARTEZEIT=30 STARTWARTEZEIT=10 STOPWARTEZEIT=30 MONEYWARTEZEIT=50 BACKUPWARTEZEIT=120 AUTOSTOPZEIT=60 SETMONOTHREADS=800 SETMONOTHREADSON="yes"
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

### Funktion oscommand, OpenSim Command senden.
# Aufruf: oscommand Screen Region Befehl Parameter
function oscommand()
{	
	VERZEICHNISSCREEN=$1; REGION=$2; BEFEHL=$3; PARAMETER=$4
	if screen -list | grep -q "$VERZEICHNISSCREEN"; then
	echo "$(tput setab $Green)Sende $BEFEHL $PARAMETER an $VERZEICHNISSCREEN $(tput sgr 0)"
	screen -S "$VERZEICHNISSCREEN" -p 0 -X eval "stuff 'change region ""$REGION""'^M" # Region wechseln
	echo "$DATUM $(date +%H:%M:%S) OSCOMMAND: $BEFEHL $PARAMETER an $VERZEICHNISSCREEN senden" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	screen -S "$VERZEICHNISSCREEN" -p 0 -X eval "stuff '$BEFEHL $PARAMETER'^M"
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
	echo " "
}

### Funktion screenlist, Laufende Screens auflisten.
function screenlist()
{
	echo "$(tput setaf $White)$(tput setab $Green) Alle laufende Screens! $(tput sgr 0)"
	screen -ls
	echo "$DATUM $(date +%H:%M:%S) SCREENLIST: Alle laufende Screens" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
	screen -ls >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
}

### Funktion osstart, startet Region Server.
# osstart screen_name
# Beispiel-Example: osstart sim1
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
# Beispiel-Example: osstop sim1
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
	echo "$(tput setab $Green)Version umbenennen und Release einstellen. $(tput sgr 0)"
	echo "$DATUM $(date +%H:%M:%S) PREBUILD: Version umbenennen und Release einstellen" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"

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
	printf 'sim\t%s\n' "$i" >> /$STARTVERZEICHNIS/$SIMDATEI
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
		else
			echo "$(tput setaf 1)Ich installiere jetzt apache2.$(tput sgr0)"
			sudo apt-get -y install apache2
	fi
	if dpkg-query -s libapache2-mod-php 2>/dev/null|grep -q installed; then
			echo "$(tput setaf 2)libapache2-mod-php ist installiert.$(tput sgr0)"
		else
			echo "$(tput setaf 1)Ich installiere jetzt libapache2-mod-php.$(tput sgr0)"
			sudo apt-get -y install libapache2-mod-php
	fi

##PHP, mysql und Erweiterungen installieren.
	if dpkg-query -s php 2>/dev/null|grep -q installed; then
			echo "$(tput setaf 2)php ist installiert.$(tput sgr0)"
		else
			echo "$(tput setaf 1)Ich installiere jetzt php.$(tput sgr0)"
			sudo apt-get -y install php
	fi
	if dpkg-query -s mysql-server 2>/dev/null|grep -q installed; then
			echo "$(tput setaf 2)mysql-server ist installiert.$(tput sgr0)"
		else
			echo "$(tput setaf 1)Ich installiere jetzt mysql-server.$(tput sgr0)"
			sudo apt-get -y install mysql-server
	fi
	if dpkg-query -s php-mysql 2>/dev/null|grep -q installed; then
			echo "$(tput setaf 2)php-mysql ist installiert.$(tput sgr0)"
		else
			echo "$(tput setaf 1)Ich installiere jetzt php-mysql.$(tput sgr0)"
			sudo apt-get -y install php-mysql
	fi
	if dpkg-query -s php-common 2>/dev/null|grep -q installed; then
			echo "$(tput setaf 2)php-common ist installiert.$(tput sgr0)"
		else
			echo "$(tput setaf 1)Ich installiere jetzt php-common.$(tput sgr0)"
			sudo apt-get -y install php-common
	fi
	if dpkg-query -s php-gd 2>/dev/null|grep -q installed; then
			echo "$(tput setaf 2)php-gd ist installiert.$(tput sgr0)"
		else
			echo "$(tput setaf 1)Ich installiere jetzt php-gd.$(tput sgr0)"
			sudo apt-get -y install php-gd
	fi
	if dpkg-query -s php-pear 2>/dev/null|grep -q installed; then
			echo "$(tput setaf 2)php-pear ist installiert.$(tput sgr0)"
		else
			echo "$(tput setaf 1)Ich installiere jetzt php-pear.$(tput sgr0)"
			sudo apt-get -y install php-pear
	fi
	if dpkg-query -s php-xmlrpc 2>/dev/null|grep -q installed; then
			echo "$(tput setaf 2)php-xmlrpc ist installiert.$(tput sgr0)"
		else
			echo "$(tput setaf 1)Ich installiere jetzt php-xmlrpc.$(tput sgr0)"
			sudo apt-get -y install php-xmlrpc
	fi
	if dpkg-query -s php-curl 2>/dev/null|grep -q installed; then
			echo "$(tput setaf 2)php-curl ist installiert.$(tput sgr0)"
		else
			echo "$(tput setaf 1)Ich installiere jetzt php-curl.$(tput sgr0)"
			sudo apt-get -y install php-curl
	fi
	if dpkg-query -s php-mbstring 2>/dev/null|grep -q installed; then
			echo "$(tput setaf 2)php-mbstring ist installiert.$(tput sgr0)"
		else
			echo "$(tput setaf 1)Ich installiere jetzt php-mbstring.$(tput sgr0)"
			sudo apt-get -y install php-mbstring
	fi
	if dpkg-query -s php-gettext 2>/dev/null|grep -q installed; then
			echo "$(tput setaf 2)php-gettext ist installiert.$(tput sgr0)"
		else
			echo "$(tput setaf 1)Ich installiere jetzt php-gettext.$(tput sgr0)"
			sudo apt-get -y install php-gettext
	fi

##Mono Installieren um OpenSim ausführen zu können.
	monoinstall

##Hilfsprogramme zum entpacken, Hintergrunddienste, Git, NAnt und Grafiktools installieren.
	if dpkg-query -s zip 2>/dev/null|grep -q installed; then
			echo "$(tput setaf 2)zip ist installiert.$(tput sgr0)"
		else
			echo "$(tput setaf 1)Ich installiere jetzt zip.$(tput sgr0)"
			sudo apt-get -y install zip
	fi
	if dpkg-query -s screen 2>/dev/null|grep -q installed; then
			echo "$(tput setaf 2)screen ist installiert.$(tput sgr0)"
		else
			echo "$(tput setaf 1)Ich installiere jetzt screen.$(tput sgr0)"
			sudo apt-get -y install screen
	fi
	if dpkg-query -s git 2>/dev/null|grep -q installed; then
			echo "$(tput setaf 2)git ist installiert.$(tput sgr0)"
		else
			echo "$(tput setaf 1)Ich installiere jetzt git.$(tput sgr0)"
			sudo apt-get -y install git
	fi
	if dpkg-query -s nant 2>/dev/null|grep -q installed; then
			echo "$(tput setaf 2)nant ist installiert.$(tput sgr0)"
		else
			echo "$(tput setaf 1)Ich installiere jetzt nant.$(tput sgr0)"
			sudo apt-get -y install nant
	fi
	if dpkg-query -s libopenjp2-tools 2>/dev/null|grep -q installed; then
			echo "$(tput setaf 2)libopenjp2-tools ist installiert.$(tput sgr0)"
		else
			echo "$(tput setaf 1)Ich installiere jetzt libopenjp2-tools.$(tput sgr0)"
			sudo apt-get -y install libopenjp2-tools
	fi
	if dpkg-query -s graphicsmagick 2>/dev/null|grep -q installed; then
			echo "$(tput setaf 2)graphicsmagick ist installiert.$(tput sgr0)"
		else
			echo "$(tput setaf 1)Ich installiere jetzt graphicsmagick.$(tput sgr0)"
			sudo apt-get -y install graphicsmagick
	fi
	if dpkg-query -s imagemagick 2>/dev/null|grep -q installed; then
			echo "$(tput setaf 2)imagemagick ist installiert.$(tput sgr0)"
		else
			echo "$(tput setaf 1)Ich installiere jetzt imagemagick.$(tput sgr0)"
			sudo apt-get -y install imagemagick
	fi
	if dpkg-query -s curl 2>/dev/null|grep -q installed; then
			echo "$(tput setaf 2)curl ist installiert.$(tput sgr0)"
		else
			echo "$(tput setaf 1)Ich installiere jetzt curl.$(tput sgr0)"
			sudo apt-get -y install curl
	fi
	if dpkg-query -s php-cli 2>/dev/null|grep -q installed; then
			echo "$(tput setaf 2)php-cli ist installiert.$(tput sgr0)"
		else
			echo "$(tput setaf 1)Ich installiere jetzt php-cli.$(tput sgr0)"
			sudo apt-get -y install php-cli
	fi
	if dpkg-query -s php-bcmath 2>/dev/null|grep -q installed; then
			echo "$(tput setaf 2)php-bcmath ist installiert.$(tput sgr0)"
		else
			echo "$(tput setaf 1)Ich installiere jetzt php-bcmath.$(tput sgr0)"
			sudo apt-get -y install php-bcmath
	fi

##Zeitsteuerung
	if dpkg-query -s at 2>/dev/null|grep -q installed; then
			echo "$(tput setaf 2)at ist installiert.$(tput sgr0)"
		else
			echo "$(tput setaf 1)Ich installiere jetzt at.$(tput sgr0)"
			sudo apt-get -y install at
	fi

##Als letzte Maßnahmen noch Updaten und Upgraden und Server neu starten wegen Mono Threads.
	apt update
	apt upgrade
	apt -f install

	echo "$(tput setaf 1)Zum Abschluss sollte der ganze Server neu gestartet werden mit dem Kommando: $(tput sgr0) reboot now"
}

### Funktion installationen, Ubuntu 18 Server, Was habe ich alles auf meinem Server Installiert? sortiert auflisten.
function installationen() 
{
	echo "$(tput setaf 1)Liste aller Installierten Pakete unter Linux: $(tput sgr0)"
	dpkg-query -Wf '${Package;-40}${Priority}\n' | sort -b -k2,2 -k1,1
}

### Funktion manniversion, test automation.
function manniversion() 
{
    VERSIONSNUMMER=$1
    cd /$STARTVERZEICHNIS || exit
	echo "$DATUM $(date +%H:%M:%S) MANNIVERSION: cd /$STARTVERZEICHNIS" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
    #apt update
    #apt upgrade
    osdelete
	echo "$DATUM $(date +%H:%M:%S) MANNIVERSION: osdelete" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
    unzip opensim-0.9.2.0Dev-"$VERSIONSNUMMER"-*.zip
	echo "$DATUM $(date +%H:%M:%S) MANNIVERSION: entpacken" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"

    mv /$STARTVERZEICHNIS/opensim-0.9.2.0Dev-"$VERSIONSNUMMER"-*/ /$STARTVERZEICHNIS/opensim/
	echo "$DATUM $(date +%H:%M:%S) MANNIVERSION: umbenennen " >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"

    osprebuild "$VERSIONSNUMMER"
	echo "$DATUM $(date +%H:%M:%S) MANNIVERSION: Konfigurieren" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
    compilieren
	echo "$DATUM $(date +%H:%M:%S) MANNIVERSION: compilieren" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
}

### Funktion osbuilding, test automation.
# Beispiel: opensim-0.9.2.0Dev-1187-gcf0b1b1.zip
# /opt/opensim.sh osbuilding 1187
function osbuilding() 
{
    VERSIONSNUMMER=$1
	
    cd /$STARTVERZEICHNIS || exit

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

### Funktion info, Informationen auf den Bildschirm ausgeben.
function info()
{
	echo "$(tput setab $Blue) Server Name: ${HOSTNAME}"
	echo " Bash Version: ${BASH_VERSION}"
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
	echo "oscommand 		- $(tput setab $Magenta)Verzeichnisname$(tput sgr 0) $(tput setab $Yello)Region$(tput sgr 0) $(tput setab $Blue)Konsolenbefehl$(tput sgr 0) $(tput setab $Green)Parameter$(tput sgr 0) - Konsolenbefehl senden."
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

echo "$(tput setab $Red)Ungetestete Funktionen$(tput sgr 0)"
	echo "makeaot			- $(tput setaf $Yello)hat keine Parameter$(tput sgr 0) - aot Dateien erstellen."
	echo "cleanaot		- $(tput setaf $Yello)hat keine Parameter$(tput sgr 0) - aot Dateien entfernen."
	echo "monoinstall		- $(tput setaf $Yello)hat keine Parameter$(tput sgr 0) - mono 6.x installation."
	echo "installationen		- $(tput setaf $Yello)hat keine Parameter$(tput sgr 0) - Linux Pakete - installationen aufisten."
	echo "serverinstall		- $(tput setaf $Yello)hat keine Parameter$(tput sgr 0) - alle benötigten Linux Pakete installieren."
	echo "osbuilding 			- $(tput setab $Magenta)Versionsnummer$(tput sgr 0)	- Upgrade des OpenSimulator aus einer Source ZIP Datei."

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
	osc | com | oscommand) oscommand "$2" "$3" "$4" "$5" ;;
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
	manniversion) manniversion "$2" ;;
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
	*) hilfe ;;
esac

echo "$DATUM $(date +%H:%M:%S) opensimMULTITOOL wurde beendet." >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
echo "#######################################################" >> "/$STARTVERZEICHNIS/$DATEIDATUM-multitool.log"
vardel
