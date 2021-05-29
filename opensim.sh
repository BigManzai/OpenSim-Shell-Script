#!/bin/bash

# opensimMULTITOOL Version 0.31.75 (c) May 2021 Manfred Aabye
# opensim.sh Basiert auf meinen Einzelscripten, an denen ich bereits 6 Jahre Arbeite und verbessere.
# Da Server unterschiedlich sind, kann eine einwandfreie fuunktion nicht gewährleistet werden, also bitte mit bedacht verwenden.
# Die Benutzung dieses Scriptes, oder deren Bestandteile, erfolgt auf eigene Gefahr!!!
# Erstellt und getestet ist opensim.sh, auf verschiedenen Ubuntu 18.04 Servern, unter verschiedenen Server Anbietern (Contabo, Hetzner ...).

clear # Bildschirm loeschen

echo "$(tput setaf 4)   ____                        _____  _                    _         _               "     
echo "  / __ \                      / ____|(_)                  | |       | |              "
echo " | |  | | _ __    ___  _ __  | (___   _  _ __ ___   _   _ | |  __ _ | |_  ___   _ __ "
echo " | |  | ||  _ \  / _ \|  _ \  \___ \ | ||  _   _ \ | | | || | / _  || __|/ _ \ |  __|"
echo "$(tput setaf 2) | |__| || |_) ||  __/| | | | ____) || || | | | | || |_| || || (_| || |_| (_) || |   "
echo "  \____/ |  __/  \___||_| |_||_____/ |_||_| |_| |_| \____||_| \____| \__|\___/ |_|   "
echo "         | |                                                                         "
echo "         |_|                                                                         "
echo "	    $(tput setaf 2)opensim$(tput setaf 4)MULTITOOL$(tput sgr 0)"
echo " "

DATUM=$(date +%d-%m-%Y)
echo "Datum: $DATUM Uhrzeit: $(date +%H-%M-%S)"
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
. "$SCRIPTPATH"/opensim.cnf

## Farben
Red=1; Green=2; Yello=3; Blue=4; Magenta=5; White=7

cd /"$STARTVERZEICHNIS" || return 1
sleep 1
KOMMANDO=$1 # Eingabeauswertung
# MULTITOOLLOG="/$STARTVERZEICHNIS/$DATUM-multitool.log" # Name der Log Datei
function schreibeinfo() 
{
	FILENAME="/$STARTVERZEICHNIS/$DATUM-multitool.log" # Name der Datei
	FILESIZE=$(stat -c%s "$FILENAME") # Wie Gross ist die Datei.
	NULL=0
	# Ist die Datei Groesser als null, dann Kopfzeile nicht erneut schreiben.
	if [ "$FILESIZE" \< "$NULL" ]
	then
	{	echo "#######################################################"
		echo "$DATUM $(date +%H-%M-%S) MULTITOOL: wurde gestartet"
		echo "$DATUM $(date +%H-%M-%S) INFO: Server Name: ${HOSTNAME}"
		echo "$DATUM $(date +%H-%M-%S) INFO: Bash Version: ${BASH_VERSION}"
		echo "$DATUM $(date +%H-%M-%S) INFO: MONO THREAD Einstellung: ${MONO_THREADS_PER_CPU}"
		echo "$DATUM $(date +%H-%M-%S) INFO: Spracheinstellung: ${LANG}"
		echo "$DATUM $(date +%H-%M-%S) INFO: Screen Version: $(screen --version)"
		echo " "
	} >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
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
	unset unset STOPWARTEZEIT
	unset MONEYWARTEZEIT
	unset Red
	unset Green
	unset White
	# echo "$DATUM $(date +%H-%M-%S) VARDEL: Variablen wurden gelöscht" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
}
### myshellschreck, ShellCheck ueberlisten hat sonst keinerlei Funktion und wird auch nicht aufgerufen.
function myshellschreck()
{
STARTVERZEICHNIS="opt" MONEYVERZEICHNIS="robust" ROBUSTVERZEICHNIS="robust" OPENSIMVERZEICHNIS="opensim" SCRIPTSOURCE="ScriptNeu" MONEYSOURCE="money48" REGIONSDATEI="RegionList.ini" SIMDATEI="SimulatorList.ini" WARTEZEIT=30 STARTWARTEZEIT=10 STOPWARTEZEIT=30 MONEYWARTEZEIT=50 BACKUPWARTEZEIT=120 AUTOSTOPZEIT=60
}
### Erstellen eines Arrays aus einer Textdatei ###
function makeverzeichnisliste() 
{
	VERZEICHNISSLISTE=()
	while IFS= read -r line; do
	VERZEICHNISSLISTE+=("$line")
	done < /$STARTVERZEICHNIS/$SIMDATEI
	# Anzahl der Eintraege.
	ANZAHLVERZEICHNISSLISTE=${#VERZEICHNISSLISTE[*]}
	# echo "$DATUM $(date +%H-%M-%S) MAKEVERZEICHNISLISTE: Verzeichnisliste wurde angefordert" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
}
function makeregionsliste() 
{
	REGIONSLISTE=()
	while IFS= read -r line; do
	REGIONSLISTE+=("$line")
	done < /$STARTVERZEICHNIS/$REGIONSDATEI
	# Anzahl der Eintraege.    
	ANZAHLREGIONSLISTE=${#REGIONSLISTE[*]}
	# echo "$DATUM $(date +%H-%M-%S) MAKEREGIONSLISTE: Regionsliste wurde angefordert" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
}
### Funktion assetdel, Asset von der Region loeschen.
# assetdel screen_name Regionsname Objektname
function assetdel()
{
	SCREEN=$1; REGION=$2; OBJEKT=$3
	# Nachschauen ob der Screen und die Region existiert. Screen OK
	if screen -list | grep -q "$SCREEN"; then
		echo "$(tput setaf $Red) $(tput setab $White)$OBJEKT Asset von der Region $SCREEN löschen$(tput sgr 0)"
		screen -S "$SCREEN" -p 0 -X eval "stuff 'change region ""$REGION""'^M" # Region wechseln
		screen -S "$SCREEN" -p 0 -X eval "stuff 'alert "Loesche: "$OBJEKT" von der Region!"'^M" # Mit einer loesch Meldung
		screen -S "$SCREEN" -p 0 -X eval "stuff 'delete object name ""$OBJEKT""'^M" # Objekt loeschen
		screen -S "$SCREEN" -p 0 -X eval "stuff 'y'^M" # Mit y also yes bestaetigen
		echo "$DATUM $(date +%H-%M-%S) ASSETDEL: $OBJEKT Asset von der Region $SCREEN löschen" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
	else
		echo "$(tput setaf $Red) $(tput setab $White)$OBJEKT Asset von der Region $SCREEN löschen fehlgeschlagen$(tput sgr 0)"
		echo "$DATUM $(date +%H-%M-%S) ASSETDEL: $OBJEKT Asset von der Region $SCREEN löschen fehlgeschlagen" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
	fi
}
### Funktion oscommand, OpenSim Commands senden.
# oscommand Screen Region Befehl Parameter
function oscommand()
{	
	SCREEN=$1
	REGION=$2
	BEFEHL=$3 
	PARAMETER=$4
	if screen -list | grep -q "$SCREEN"; then
	echo "$(tput setab $Green)Sende $BEFEHL $PARAMETER an $SCREEN $(tput sgr 0)"
	screen -S "$SCREEN" -p 0 -X eval "stuff 'change region ""$REGION""'^M" # Region wechseln
	echo "$DATUM $(date +%H-%M-%S) OSCOMMAND: $BEFEHL $PARAMETER an $SCREEN senden" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
	screen -S "$SCREEN" -p 0 -X eval "stuff '$BEFEHL $PARAMETER'^M"
	else
		echo "Der Screen $SCREEN existiert nicht."
		echo "$DATUM $(date +%H-%M-%S) OSCOMMAND: Der Screen $SCREEN existiert nicht" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
	fi
}
### Funktion works, screen pruefen ob er laeuft.
# works screen_name
function works()
{
	if ! screen -list | grep -q "$1"; then
		# es laeuft nicht - not work
			echo "$(tput setaf $White)$(tput setab $Red) $1 OFFLINE! $(tput sgr 0)"
			echo "$DATUM $(date +%H-%M-%S) WORKS: $1 OFFLINE!" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
			return 1
		else
		# es laeuft - work
			echo "$(tput setaf $White)$(tput setab $Green) $1 ONLINE! $(tput sgr 0)"
			echo "$DATUM $(date +%H-%M-%S) WORKS: $1 ONLINE!" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
			return 0
	fi
}
### Funktion checkfile, pruefen ob Datei vorhanden ist.
# checkfile "pfad/name"
# checkfile /pfad/zur/datei && echo "File exists" || echo "File not found!"
function checkfile 
{
	[ -f "$1" ]	
	return $?
}
### Funktion mapdel, loescht die Map-Karten.
# mapdel Verzeichnis
function mapdel()
{
	if [ -d "$1" ]; then
		echo "$(tput setaf $Red) $(tput setab $White)OpenSimulator maptile $1 geloescht$(tput sgr 0)"
		cd /$STARTVERZEICHNIS/"$1"/bin || return 1
		rm -r maptiles/*
		echo "$DATUM $(date +%H-%M-%S) MAPDEL: OpenSimulator maptile $1 geloescht" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
	else
		echo "$(tput setaf $Red)maptile $1 nicht gefunden $(tput sgr 0)"
		echo "$DATUM $(date +%H-%M-%S) MAPDEL: maptile $1 nicht gefunden" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
	fi
}
### Funktion logdel, loescht die Log Dateien.
# logdel Verzeichnis
function logdel()
{
	if [ -d "$1" ]; then
		echo "$(tput setaf $Red) $(tput setab $White)OpenSimulator log $1 geloescht$(tput sgr 0)"
		rm /$STARTVERZEICHNIS/"$1"/bin/*.log
		echo "$DATUM $(date +%H-%M-%S) LOGDEL: OpenSimulator log $1 geloescht" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
	else
		echo "$(tput setaf $Red)logs nicht gefunden $(tput sgr 0)"
		echo "$DATUM $(date +%H-%M-%S) LOGDEL: logs nicht gefunden" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
	fi
}
### Funktion ossettings, stellt den Linux Server fuer OpenSim ein.
function ossettings()
{
	# Hier kommen alle gewünschten Einstellungen rein.
	echo "$(tput setab $Green)Setze die Einstellungen! $(tput sgr 0)"
	echo "$DATUM $(date +%H-%M-%S) OSSETTINGS: Setze die Einstellung: ulimit -s 1048576" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
	echo "ulimit -s 1048576"
	ulimit -s 1048576
	echo "$DATUM $(date +%H-%M-%S) OSSETTINGS: Setze die Einstellung: minor=split,promotion-age=14,nursery-size=64m" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
	echo "minor=split,promotion-age=14,nursery-size=64m"
	export MONO_GC_PARAMS="minor=split,promotion-age=14,nursery-size=64m"
	echo " "
}
### Funktion screenlist, Laufende Screens auflisten.
function screenlist()
{
	echo "$(tput setaf 2)$(tput setab $White) Alle laufende Screens! $(tput sgr 0)"
	screen -ls
	echo "$DATUM $(date +%H-%M-%S) SCREENLIST: Alle laufende Screens" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
	screen -ls >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
}
### Funktion osstart, startet Region Server.
# osstart screen_name
# Beispiel-Example: osstart sim1
function osstart()
{
	if [ -d "$1" ]; then
		echo "$(tput setaf 2) $(tput setab $White)Region $1 Starten$(tput sgr 0)"
		echo "$DATUM $(date +%H-%M-%S) OSSTART: Region $1 Starten" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
		cd /$STARTVERZEICHNIS/"$1"/bin || return 1
		screen -fa -S "$1" -d -U -m mono OpenSim.exe
		sleep 10
	else
		echo "$(tput setaf $Red) $(tput setab $White)Region $1 nicht vorhanden$(tput sgr 0)"
		echo "$DATUM $(date +%H-%M-%S) OSSTART: Region $1 nicht vorhanden" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
	fi
	return
}
### Funktion osstop, stoppt Region Server.
# Beispiel-Example: osstop sim1
function osstop()
{
	if screen -list | grep -q "$1"; then
		echo "$(tput setaf $Red) $(tput setab $White)Region $1 Beenden$(tput sgr 0)"
		echo "$DATUM $(date +%H-%M-%S) OSSTOP: Region $1 Beenden" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
		screen -S "$1" -p 0 -X eval "stuff 'shutdown'^M"
		sleep 10
	else
		echo "$(tput setaf $Red) $(tput setab $White)Region $1 nicht vorhanden$(tput sgr 0)"
		echo "$DATUM $(date +%H-%M-%S) OSSTOP: Region $1 nicht vorhanden" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
	fi
	return
}
### Funktion rostart, Robust Server starten.
function rostart()
{
	if checkfile /$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS/bin/Robust.exe; then
		echo "$(tput setaf 2) $(tput setab $White)Robust Start$(tput sgr 0)"
		cd /$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS/bin || return 1
		echo "$DATUM $(date +%H-%M-%S) ROSTART: Robust Start" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
		screen -fa -S RO -d -U -m mono Robust.exe 
		#/$STARTVERZEICHNIS/osscreen.sh "RO" "/$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS/bin/Robust.exe"
		sleep $WARTEZEIT
	else
		echo "$(tput setaf $Red)Robust wurde nicht gefunden.$(tput sgr 0)"
		echo "$DATUM $(date +%H-%M-%S) ROSTART: Robust wurde nicht gefunden" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
	fi
}
### Funktion rostop, Robust Server herunterfahren.
function rostop()
{
	if screen -list | grep -q "RO"; then
		echo "$(tput setaf $Red) $(tput setab $White)RobustServer Beenden$(tput sgr 0)"
		screen -S RO -p 0 -X eval "stuff 'shutdown'^M"
		echo "$DATUM $(date +%H-%M-%S) ROSTOP: RobustServer Beenden" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
		sleep $WARTEZEIT	  
	else
		echo "$(tput setaf $Red) $(tput setab $White)RobustServer nicht vorhanden$(tput sgr 0)"
		echo "$DATUM $(date +%H-%M-%S) ROSTOP: RobustServer nicht vorhanden" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
	fi	
}
### Funktion mostart, Money Server starten.
function mostart()
{
	if checkfile /$STARTVERZEICHNIS/$MONEYVERZEICHNIS/bin/MoneyServer.exe; then
		echo "$(tput setaf 2) $(tput setab $White)MoneyServer Start$(tput sgr 0)"
		cd /$STARTVERZEICHNIS/$MONEYVERZEICHNIS/bin || return 1
		echo "$DATUM $(date +%H-%M-%S) MOSTART: MoneyServer Start" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
		screen -fa -S MO -d -U -m mono MoneyServer.exe
		#/$STARTVERZEICHNIS/osscreen.sh "MO" "/$STARTVERZEICHNIS/$MONEYVERZEICHNIS/bin/MoneyServer.exe"
		sleep $MONEYWARTEZEIT
	else
		echo "$(tput setaf $Red)MoneyServer wurde nicht gefunden.$(tput sgr 0)"
		echo "$DATUM $(date +%H-%M-%S) MOSTART: MoneyServer wurde nicht gefunden" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
	fi
}
### Funktion mostop, Money Server herunterfahren.
function mostop()
{
	if screen -list | grep -q "MO"; then
		echo "$(tput setaf $Red) $(tput setab $White)MoneyServer Beenden$(tput sgr 0)"
		screen -S MO -p 0 -X eval "stuff 'shutdown'^M"
		echo "$DATUM $(date +%H-%M-%S) MOSTOP: MoneyServer Beenden" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
	  sleep $MONEYWARTEZEIT	  
	else
		echo "$(tput setaf $Red) $(tput setab $White)MoneyServer nicht vorhanden$(tput sgr 0)"
		echo "$DATUM $(date +%H-%M-%S) MOSTOP: MoneyServer nicht vorhanden" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
	fi	
}
### Funktion osscreenstop, beendet Screeens.
# Beispiel-Example: osscreenstop sim1
function osscreenstop()
{
	if screen -list | grep -q "$1"; then
		echo "$(tput setaf $Red) $(tput setab $White)Screeen $1 Beenden$(tput sgr 0)"
		echo "$DATUM $(date +%H-%M-%S) OSSCREENSTOP: Screeen $1 Beenden" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
		screen -S "$1" -X quit	  
	else
		echo "$(tput setaf $Red) $(tput setab $White)Screeen $1 nicht vorhanden$(tput sgr 0)"
		echo "$DATUM $(date +%H-%M-%S) OSSCREENSTOP: Screeen $1 nicht vorhanden" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
	fi
	echo "No screen session found. Ist hier kein Fehler, sondern ein Beweis, das alles zuvor sauber heruntergefahren wurde."
}
### Funktion gridstart, startet erst Robust und dann Money
function gridstart()
{
	if screen -list | grep -q RO; then
		echo "$(tput setaf $Red) $(tput setab $White)RobustServer läuft bereits $(tput sgr 0)"
	else
		echo "$DATUM $(date +%H-%M-%S) ROSTART: Start" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
		rostart
	fi

	if screen -list | grep -q MO; then
		echo "$(tput setaf $Red) $(tput setab $White)MoneyServer läuft bereits $(tput sgr 0)"
	else
		echo "$DATUM $(date +%H-%M-%S) MOSTART: Start" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
		mostart
	fi
}
### Funktion gridstop, stoppt erst Money dann Robust
function gridstop()
{
	if screen -list | grep -q MO; then
		echo "$DATUM $(date +%H-%M-%S) ROSTOP: Stopp" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
		mostop		
	else
		echo "$(tput setaf $Red)MoneyServer läuft nicht $(tput sgr 0)"
	fi

	if screen -list | grep -q RO; then
		echo "$DATUM $(date +%H-%M-%S) MOSTOP: Stopp" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
		rostop		
	else
		echo "$(tput setaf $Red)RobustServer läuft nicht $(tput sgr 0)"
	fi
}
### Funktion terminator
function terminator()
{
	echo "hasta la vista baby"
	echo "$DATUM $(date +%H-%M-%S) TERMINATOR: Alle Screens wurden durch Benutzer beendet" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
	killall screen
	screen -ls
	return 0
}
### Funktion oscompi, kompilieren des OpenSimulator.
function oscompi()
{
	echo "$(tput setab $Green)Kompilierungsvorgang startet! $(tput sgr 0)"
	echo "$DATUM $(date +%H-%M-%S) OSCOMPI: Kompilierungsvorgang startet" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
	# In das opensim Verzeichnis wechseln wenn es das gibt ansonsten beenden.
	cd /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS || return 1
	
	echo 'Prebuildvorgang startet!'
	echo "$DATUM $(date +%H-%M-%S) OSCOMPI: Prebuildvorgang startet" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
	# runprebuild19.sh startbar machen und starten.
	chmod +x runprebuild19.sh
	./runprebuild19.sh

	echo 'Kompilierungsvorgang startet!'
	echo "$DATUM $(date +%H-%M-%S) OSCOMPI: Kompilierungsvorgang startet" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
	# ohne log Datei.
	msbuild /p:Configuration=Release
	# mit log Datei.
	# msbuild /p:Configuration=Release /fileLogger /flp:logfile=opensimbuild.log /v:d
	echo " "
	echo "$DATUM $(date +%H-%M-%S) OSCOMPI: Kompilierung wurde durchgeführt" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
}
### Funktion scriptcopy, lsl ossl scripte kopieren.
function scriptcopy()
{
	if [ -d /$STARTVERZEICHNIS/$SCRIPTSOURCE/ ]; then
		echo "$(tput setab $Green)Script Assets werden kopiert! $(tput sgr 0)"
		echo "$DATUM $(date +%H-%M-%S) SCRIPTCOPY: Script Assets werden kopiert" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
		cp -r /$STARTVERZEICHNIS/$SCRIPTSOURCE/assets /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/bin
		cp -r /$STARTVERZEICHNIS/$SCRIPTSOURCE/inventory /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/bin
	echo " "
	else
		echo "$(tput setab $Green)Script Assets sind nicht vorhanden! $(tput sgr 0)"
		echo "$DATUM $(date +%H-%M-%S) SCRIPTCOPY: Script Assets sind nicht vorhanden" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
	fi
}
### Funktion moneycopy, Money Dateien kopieren.
function moneycopy()
{
	if [ -d /$STARTVERZEICHNIS/$MONEYSOURCE/ ]; then
		echo "$(tput setab $Green)Money Kopiervorgang startet! $(tput sgr 0)"
		echo "$DATUM $(date +%H-%M-%S) MONEYCOPY: Money Kopiervorgang gestartet" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
		cp -r /$STARTVERZEICHNIS/$MONEYSOURCE/bin /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS
		cp -r /$STARTVERZEICHNIS/$MONEYSOURCE/addon-modules /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS
		echo " "
	else
		echo "$(tput setab $Green)Script Assets sind nicht vorhanden! $(tput sgr 0)"
		echo "$DATUM $(date +%H-%M-%S) SCRIPTCOPY: Script Assets sind nicht vorhanden" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
	fi	
}
### Funktion compilieren, kompilieren des OpenSimulator.
function compilieren()
{
	echo "$(tput setab $Green)Bauen eines neuen OpenSimulators wird gestartet! $(tput sgr 0)"
	echo "$DATUM $(date +%H-%M-%S) COMPILIEREN: Bauen eines neuen OpenSimulators wird gestartet" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
	# Nachsehen ob Verzeichnis überhaupt existiert.
	if [ ! -f "/$STARTVERZEICHNIS/$SCRIPTSOURCE/" ]; then
		scriptcopy
	else
		echo "OSSL Script Verzeichnis existiert nicht."
		echo "$DATUM $(date +%H-%M-%S) COMPILIEREN: OSSL Script Verzeichnis existiert nicht" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
	fi
	if [ ! -f "/$STARTVERZEICHNIS/$MONEYSOURCE/" ]; then
		moneycopy
	else
		echo "MoneyServer Verzeichnis existiert nicht."
		echo "$DATUM $(date +%H-%M-%S) COMPILIEREN: MoneyServer Verzeichnis existiert nicht" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
	fi
	if [ ! -f "/$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/" ]; then
		oscompi
	else
		echo "opensim Verzeichnis existiert nicht."
		echo "$DATUM $(date +%H-%M-%S) COMPILIEREN: opensim Verzeichnis existiert nicht" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
	fi
}
# Legt die Verzeichnisstruktur fuer OpenSim an.
# Aufruf: opensim.sh osstruktur ersteSIM letzteSIM
# Beispiel: ./opensim.sh osstruktur 1 10 - erstellt ein Grid Verzeichnis fuer 10 Simulatoren inklusive der SimulatorList.ini.
function osstruktur()
{
	if [ ! -f "/$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/" ]; then
		echo "Lege robust an im Verzeichnis $ROBUSTVERZEICHNIS"
		echo "$DATUM $(date +%H-%M-%S) OSSTRUKTUR: Lege robust an im Verzeichnis $ROBUSTVERZEICHNIS" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
		mkdir -p /$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS/bin
	else
		echo "opensim Verzeichnis existiert bereits."
		echo "$DATUM $(date +%H-%M-%S) OSSTRUKTUR: Verzeichnis $ROBUSTVERZEICHNIS existiert bereits" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
	fi
	for ((i=$1;i<=$2;i++))
	do
	echo "Lege sim$i an"
	mkdir -p /$STARTVERZEICHNIS/sim"$i"/bin
	echo "Schreibe sim$i in $SIMDATEI"
	printf 'sim\t%s\n' "$i" >> /$STARTVERZEICHNIS/$SIMDATEI
	done
	echo "$DATUM $(date +%H-%M-%S) OSSTRUKTUR: Lege robust an ,Schreibe sim$i in $SIMDATEI" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
}
### Funktion osdelete, altes opensim loeschen und neues als Backup.
function osdelete()
{	
	if [ -d /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/ ]; then
		echo "$(tput setaf $Red) $(tput setab $White)Lösche alte opensim1 Dateien$(tput sgr 0)"
		cd /$STARTVERZEICHNIS  || return 1
		rm -r /$STARTVERZEICHNIS/opensim1
		echo "$(tput setaf $Red) $(tput setab $White)Umbenennen von $OPENSIMVERZEICHNIS nach opensim1 zur sicherung$(tput sgr 0)"
		mv /$STARTVERZEICHNIS/opensim /$STARTVERZEICHNIS/opensim1
		echo " "
		echo "$DATUM $(date +%H-%M-%S) OSDELETE: Lösche alte opensim1 Dateien" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
	else
		echo "$(tput setaf $Red) $(tput setab $White) $STARTVERZEICHNIS Verzeichnis existiert nicht$(tput sgr 0)"
	fi
}
### Funktion oscopyrobust
function oscopyrobust()
{
	if [ -d /$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS/ ]; then
		makeverzeichnisliste
		echo "$(tput setab $Green)Kopiere Robust, Money! $(tput sgr 0)"
		echo " "
		sleep 3
		echo "$(tput setaf $Green) $(tput setab $White)Robust und Money kopiert$(tput sgr 0)"
		cd /$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS/bin || return 1
		cp -r /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/bin /$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS
		echo " "
		echo "$DATUM $(date +%H-%M-%S) OSCOPY: Robust kopieren" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
	else
		echo " "
	fi
}
### Funktion oscopysim
function oscopysim()
{
	makeverzeichnisliste
	echo "$(tput setab $Green)Kopiere Simulatoren! $(tput sgr 0)"
	echo " "
	sleep 3
	for (( i = 0 ; i < "$ANZAHLVERZEICHNISSLISTE" ; i++)) do
		echo "$(tput setaf $Green) $(tput setab $White)OpenSimulator ${VERZEICHNISSLISTE[$i]} kopiert$(tput sgr 0)"
		cd /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin || return 1
		cp -r /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/bin /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"
		sleep 3
	done
	echo " "
	echo "$DATUM $(date +%H-%M-%S) OSCOPY: OpenSim kopieren" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
}
# Regionskonfigurationen lesen
function configlesen()
{
	echo "$(tput setab $Green)Regionskonfigurationen von $1 $(tput sgr 0)"
	KONFIGLESEN=$(awk -F":" '// {print $0 }' /$STARTVERZEICHNIS/"$1"/bin/Regions/*.ini)	# Regionskonfigurationen aus einem Verzeichnis lesen.
	echo "$KONFIGLESEN"
	echo "$DATUM $(date +%H-%M-%S) CONFIGLESEN: Regionskonfigurationen von $1" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
	echo "$KONFIGLESEN" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
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
### Funktion meineregionen, listet alle Regionen aus den auf.
function meineregionen() 
{	
	makeverzeichnisliste
	echo "$DATUM $(date +%H-%M-%S) MEINEREGIONEN: Regionsliste" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
	sleep 3
	for (( i = 0 ; i < "$ANZAHLVERZEICHNISSLISTE" ; i++))
	do
	VERZEICHNIS="${VERZEICHNISSLISTE[$i]}"
		REGIONSAUSGABE=$(awk -F "[" '/\[/ {print $1 $2 $3}' /$STARTVERZEICHNIS/"$VERZEICHNIS"/bin/Regions/*.ini |sed s/'\]'//g) # Zeigt nur die Regionsnamen aus einer Regions.ini an
		echo "$(tput setaf $Green)$(tput setab $White) $VERZEICHNIS $(tput sgr 0)"
		echo "$REGIONSAUSGABE"
		echo "$REGIONSAUSGABE" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
	done
	echo "$DATUM $(date +%H-%M-%S) MEINEREGIONEN: Regionsliste Ende" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
}
### Regions.ini zerlegen
### Funktion meineregionen, listet alle Regionen aus den auf.
function regionsinisuchen() 
{	
	makeverzeichnisliste
	sleep 3

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
# Gibt ein Array aller Regionsabschnitte zurueck, regionsinizerlegen
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
# Gibt den Wert eines bestimmten Schluessels im angegebenen Abschnitt zurueck , regionsinizerlegen
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
	echo "$DATUM $(date +%H-%M-%S) REGIONSINITEILEN: Schreiben der Werte für $RTREGIONSNAME" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
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
		echo "$DATUM $(date +%H-%M-%S) REGIONSINITEILEN: $INI_FILE wurde nicht gefunden" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
	fi
}
### Funktion regionsinizerlegen, Die gemeinschaftsdatei Regions.ini in einzelne Regionen teilen 
# diese dann unter dem Regionsnamen speichern, danach die Alte Regions.ini umbenennen in Regions.ini.old.
function autoregionsiniteilen()
{
	makeverzeichnisliste
	sleep 3
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
				sleep 3
				echo "regionsiniteilen $VERZEICHNIS $MeineRegion"
			done
	#  Dann umbenennen:
	# Pruefung ob Datei vorhanden ist, wenn ja umbenennen.
	if [ ! -d "$INI_FILE" ]; then
		mv /$STARTVERZEICHNIS/"$INIVERZEICHNIS"/bin/Regions/Regions.ini /$STARTVERZEICHNIS/"$INIVERZEICHNIS"/bin/Regions/"$DATUM"-Regions.ini.old
	fi
	done	
}
### Funktion RegionListe, Die RegionListe ermitteln und mit dem Verzeichnisnamen in die RegionList.ini schreiben.
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
	sleep 3
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
	sleep 3
	# MoneyServer aus den sims entfernen 
	for (( i = 0 ; i < "$ANZAHLVERZEICHNISSLISTE" ; i++)) do
		echo "$(tput setaf $Red) $(tput setab $White)MoneyServer ${VERZEICHNISSLISTE[$i]} geloescht$(tput sgr 0)"
		cd /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin || return 1 # Pruefen ob Verzeichnis vorhanden ist.
		rm -r /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/MoneyServer.exe.config # Dateien loeschen.
		rm -r /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/MoneyServer.ini.example
		rm -r /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/OpenSim.Data.MySQL.MySQLMoneyDataWrapper.dll
		rm -r /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/OpenSim.Modules.Currency.dll
		echo "$DATUM $(date +%H-%M-%S) MONEYDELETE: MoneyServer ${VERZEICHNISSLISTE[$i]} geloescht" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
		sleep 3
	done
	# MoneyServer aus Robust entfernen
	if [ -d /$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS/ ]
	then
		cd /$STARTVERZEICHNIS/robust/bin || return 1
		rm -r /$STARTVERZEICHNIS/robust/bin/MoneyServer.exe.config
		rm -r /$STARTVERZEICHNIS/robust/bin/MoneyServer.ini.example
		rm -r /$STARTVERZEICHNIS/robust/bin/OpenSim.Data.MySQL.MySQLMoneyDataWrapper.dll
		rm -r /$STARTVERZEICHNIS/robust/bin/OpenSim.Modules.Currency.dll
		echo "$DATUM $(date +%H-%M-%S) MONEYDELETE: MoneyServer aus Robust geloescht" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
	fi
}
### Funktion osgitholen, kopiert eine Entwicklerversion.
function osgitholen()
{
	if [ -d /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/ ]
	then
		echo "$(tput setaf 1) $(tput setab 7)Kopieren der Entwicklungsversion des OpenSimulator aus dem Git$(tput sgr 0)"
		cd /$STARTVERZEICHNIS  || return 1
		rm -r /$STARTVERZEICHNIS/opensim1
		mv /$STARTVERZEICHNIS/opensim /$STARTVERZEICHNIS/opensim1
        git clone git://opensimulator.org/git/opensim opensim
		echo "$DATUM $(date +%H-%M-%S) OPENSIMHOLEN: Git klonen" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
	else
		echo "$(tput setaf 1) $(tput setab 7)Kopieren der Entwicklungsversion des OpenSimulator aus dem Git$(tput sgr 0)"
		git clone git://opensimulator.org/git/opensim opensim
		echo "$DATUM $(date +%H-%M-%S) OPENSIMHOLEN: Git klonen" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
	fi 
}
### Funktion osupgrade
function osupgrade()
{
	echo "$(tput setab $Green)Das Grid wird jetzt upgegradet! $(tput sgr 0)"
	echo "$DATUM $(date +%H-%M-%S) OSUPGRADE: Das Grid wird jetzt upgegradet" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
	echo " "
	# Grid Stoppen.
	echo "$DATUM $(date +%H-%M-%S) OSUPGRADE: Alles Beenden" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
	autostop
	# Kopieren.
	echo "$DATUM $(date +%H-%M-%S) OSUPGRADE: Neue Version Installieren" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
	oscopyrobust	
	oscopysim
	# MoneyServer eventuell loeschen.	
	if [ "$MONEYVERZEICHNIS" = "keins" ] || [ "$MONEYVERZEICHNIS" = "no" ] || [ "$MONEYVERZEICHNIS" = "nein" ]; then moneydelete; fi
	# Grid Starten.
	echo "$DATUM $(date +%H-%M-%S) OSUPGRADE: Das Grid wird jetzt gestartet" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
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
# 	echo "$DATUM $(date +%H-%M-%S) DEBUG: Start von MULTITOOL" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
# }

### Funktion regionbackup
# regionbackup Screenname "Der Regionsname"
function regionbackup()
{
	# Backup Verzeichnis anlegen.
	mkdir -p /$STARTVERZEICHNIS/backup/
	sleep 3
	SCREENNAME=$1
	REGIONSNAME=$2	
	DATEINAME=${REGIONSNAME//\"/}
	NSDATEINAME=${DATEINAME// /}

	echo "$(tput setaf 4) $(tput setab 7)Region $NSDATEINAME speichern$(tput sgr 0)"
	echo "$DATUM $(date +%H-%M-%S) OSBACKUP: Region $NSDATEINAME speichern" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
	cd /$STARTVERZEICHNIS/"$SCREENNAME"/bin || return 1
	# Ich kann nicht pruefen ob die Region im OpenSimulator vorhanden ist.
	# Sollte sie nicht vorhanden sein wird root also alle Regionen gespeichert.
	screen -S "$SCREENNAME" -p 0 -X eval "stuff 'change region ${REGIONSNAME//\"/}'^M"
	screen -S "$SCREENNAME" -p 0 -X eval "stuff 'save oar /$STARTVERZEICHNIS/backup/'$DATUM'-$NSDATEINAME.oar'^M"
	screen -S "$SCREENNAME" -p 0 -X eval "stuff 'terrain save /$STARTVERZEICHNIS/backup/'$DATUM'-$NSDATEINAME.png'^M"
	screen -S "$SCREENNAME" -p 0 -X eval "stuff 'terrain save /$STARTVERZEICHNIS/backup/'$DATUM'-$NSDATEINAME.raw'^M"
	echo "$DATUM $(date +%H-%M-%S) OSBACKUP: Region $DATUM-$NSDATEINAME RAW und PNG Terrain gespeichert" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
	echo " "
	sleep 10
	if [ ! -f /$STARTVERZEICHNIS/"$SCREENNAME"/bin/Regions/"$NSDATEINAME".ini ]; then
		cp -r /$STARTVERZEICHNIS/"$SCREENNAME"/bin/Regions/Regions.ini /$STARTVERZEICHNIS/backup/"$DATUM"-"$NSDATEINAME".ini
		echo "$(tput setaf 2)Regions.ini wurde als $DATUM-$NSDATEINAME.ini gespeichert."
		echo "$DATUM $(date +%H-%M-%S) OSBACKUP: Region $DATUM-$NSDATEINAME.ini gespeichert" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
	fi
	if [ ! -f /$STARTVERZEICHNIS/"$SCREENNAME"/bin/Regions/"${REGIONSNAME//\"/}".ini ]; then
		cp -r /$STARTVERZEICHNIS/"$SCREENNAME"/bin/Regions/Regions.ini /$STARTVERZEICHNIS/backup/"$DATUM"-"$NSDATEINAME".ini
		echo "$(tput setaf 2)Regions.ini wurde als $DATUM-$NSDATEINAME.ini gespeichert."
		echo "$DATUM $(date +%H-%M-%S) OSBACKUP: Region $DATUM-$NSDATEINAME.ini gespeichert" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
	fi
	if [ ! -f /$STARTVERZEICHNIS/"$SCREENNAME"/bin/Regions/Regions.ini ]; then
		cp -r /$STARTVERZEICHNIS/"$SCREENNAME"/bin/Regions/"$NSDATEINAME".ini /$STARTVERZEICHNIS/backup/"$DATUM"-"$NSDATEINAME".ini
		echo "$DATUM $(date +%H-%M-%S) OSBACKUP: Region $NSDATEINAME.ini gespeichert" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
	fi
}
### Funktion autosimstart
function autosimstart()
{
	# shellcheck disable=SC2022
	if ! screen -list | grep -q 'sim*'; then
	# es laeuft nicht - not work
		makeverzeichnisliste
		sleep 3
		for (( i = 0 ; i < "$ANZAHLVERZEICHNISSLISTE" ; i++)) do
			echo "$(tput setaf 2) $(tput setab $White)Regionen OpenSimulator ${VERZEICHNISSLISTE[$i]} Starten$(tput sgr 0)"
			cd /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin || return 1
			screen -fa -S "${VERZEICHNISSLISTE[$i]}" -d -U -m mono OpenSim.exe
			#/$STARTVERZEICHNIS/osscreen.sh "${VERZEICHNISSLISTE[$i]}" "/$STARTVERZEICHNIS/${VERZEICHNISSLISTE[$i]}/bin/OpenSim.exe"
			echo "$DATUM $(date +%H-%M-%S) AUTOSIMSTART: Regionen OpenSimulator ${VERZEICHNISSLISTE[$i]} Starten" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
			sleep $STARTWARTEZEIT
		done
	else
		echo "$(tput setaf $White)$(tput setab $Green) Regionen laufen bereits! $(tput sgr 0)"
		echo "$DATUM $(date +%H-%M-%S) WORKS:  Regionen laufen bereits!" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
	fi
}
### Funktion autosimstop
function autosimstop()
{
	makeverzeichnisliste
	sleep 3
	for (( i = 0 ; i < "$ANZAHLVERZEICHNISSLISTE" ; i++)) do
		echo "$(tput setaf $Red) $(tput setab $White)Regionen OpenSimulator ${VERZEICHNISSLISTE[$i]} Beenden$(tput sgr 0)"
		screen -S "${VERZEICHNISSLISTE[$i]}" -p 0 -X eval "stuff 'shutdown'^M"
		echo "$DATUM $(date +%H-%M-%S) AUTOSIMSTOP: Regionen OpenSimulator ${VERZEICHNISSLISTE[$i]} Beenden" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
		sleep $STOPWARTEZEIT
	done
}
### Funktion autologdel
function autologdel()
{
	makeverzeichnisliste
	sleep 3
	for (( i = 0 ; i < "$ANZAHLVERZEICHNISSLISTE" ; i++)) do
		echo "$(tput setaf $Red) $(tput setab $White)OpenSimulator log ${VERZEICHNISSLISTE[$i]} geloescht$(tput sgr 0)"
		rm /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/*.log
		echo "$DATUM $(date +%H-%M-%S) AUTOLOGDEL: OpenSimulator log ${VERZEICHNISSLISTE[$i]} geloescht" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
		sleep 3
	done
}
### Funktion automapdel
function automapdel()
{
	makeverzeichnisliste
	sleep 3
	for (( i = 0 ; i < "$ANZAHLVERZEICHNISSLISTE" ; i++)) do
		echo "$(tput setaf $Red) $(tput setab $White)OpenSimulator maptile ${VERZEICHNISSLISTE[$i]} geloescht$(tput sgr 0)"
		cd /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin || return 1
		rm -r maptiles/*
		echo "$DATUM $(date +%H-%M-%S) AUTOMAPDEL: OpenSimulator maptile ${VERZEICHNISSLISTE[$i]} geloescht" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
		sleep 3
	done
}
### Funktion autoregionbackup
function autoregionbackup()
{
	echo "$(tput setaf $Red) $(tput setab $White)Automatisches Backup wird gestartet. $(tput sgr 0)"
	makeregionsliste
	echo "$DATUM $(date +%H-%M-%S) OSBACKUP: Automatisches Backup wird gestartet" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
	sleep 3
	for (( i = 0 ; i < "$ANZAHLREGIONSLISTE" ; i++)) do
		derscreen=$(echo "${REGIONSLISTE[$i]}" | cut -d ' ' -f 1)
		dieregion=$(echo "${REGIONSLISTE[$i]}" | cut -d ' ' -f 2)
		regionbackup "$derscreen" "$dieregion"
		sleep $BACKUPWARTEZEIT
	done
}
### Funktion autoscreenstop
function autoscreenstop()
{
	makeverzeichnisliste
	sleep 3

	# shellcheck disable=SC2022
	if ! screen -list | grep -q 'sim*'; then
	echo "$(tput setaf $White)$(tput setab $Red) SIMs OFFLINE! $(tput sgr 0)"
	echo "$DATUM $(date +%H-%M-%S) WORKS: SIMs OFFLINE!" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
	else
		for (( i = 0 ; i < "$ANZAHLVERZEICHNISSLISTE" ; i++)) do
			screen -S "${VERZEICHNISSLISTE[$i]}" -X quit
		done
	fi

	if ! screen -list | grep -q "MO"; then
	echo "$(tput setaf $White)$(tput setab $Red) MONEY OFFLINE! $(tput sgr 0)"
	echo "$DATUM $(date +%H-%M-%S) WORKS: MONEY OFFLINE!" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
	else	
	screen -S MO -X quit
	fi

	if ! screen -list | grep -q "RO"; then
	echo "$(tput setaf $White)$(tput setab $Red) ROBUST OFFLINE! $(tput sgr 0)"
	echo "$DATUM $(date +%H-%M-%S) WORKS: ROBUST OFFLINE!" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
	else
	screen -S RO -X quit
	fi

	echo "$DATUM $(date +%H-%M-%S) AUTOSCREENSTOP: Auto Screen Stopp abgeschlossen" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
}
### Funktion autostart
function autostart()
{
	echo "$(tput setab $Green)Starte das Grid! $(tput sgr 0)"
	echo " "	
	gridstart
	autosimstart
	echo " "
	screenlist
	echo " "
	echo "$DATUM $(date +%H-%M-%S) AUTOSTART: Auto Start abgeschlossen" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
}
### Funktion autostop
function autostop()
{
	echo "$(tput setab 1)Stoppe alles! $(tput sgr 0)"
	autosimstop
	gridstop
	# echo "$AUTOSTOPZEIT Sekunden warten bis die Simulatoren heruntergefahren sind!"
	sleep $AUTOSTOPZEIT
	echo " "
	echo "$(tput setab 1)Beende alle noch offenen Screens! $(tput sgr 0)"
	autoscreenstop
	# echo " "
	# screenlist
	echo " "
	echo "$DATUM $(date +%H-%M-%S) AUTOSTOP: Auto Stopp abgeschlossen" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
}
### Funktion autorestart
function autorestart()
{
	echo "$(tput setab 1)Stoppe alles! $(tput sgr 0)"
	autosimstop
	gridstop
	sleep 60
	echo " "
	echo "$(tput setab 1)Beende alle noch offenen Screens! $(tput sgr 0)"
	autoscreenstop
	echo " "
	echo "$(tput setab 1)Log Dateien löschen! $(tput sgr 0)"
	autologdel
	echo " "
	echo "$(tput setab 2)Starte alles! $(tput sgr 0)"
	gridstart
	autosimstart
	echo " "
	screenlist
	echo " "
	echo "$DATUM $(date +%H-%M-%S) AUTORESTART: Auto Restart abgeschlossen" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
}
### Funktion info
function info()
{
	echo "$(tput setab $Blue) Server Name: ${HOSTNAME}"
	echo " Bash Version: ${BASH_VERSION}"
	echo " MONO THREAD Einstellung: ${MONO_THREADS_PER_CPU}"
	echo " Spracheinstellung: ${LANG} $(tput sgr 0)"
}
### Funktion hilfe
function hilfe()
{
	echo "$(tput setab $Magenta)Funktion:$(tput sgr 0)		$(tput setab $Green)Parameter:$(tput sgr 0)		$(tput setab $Blue)Informationen:$(tput sgr 0)"
	echo "hilfe 			- $(tput setaf $Yello)hat keine Parameter$(tput sgr 0)	- Diese Hilfe."
	echo "restart 		- $(tput setaf $Yello)hat keine Parameter$(tput sgr 0)	- Startet das gesammte Grid neu."
	echo "autostop 		- $(tput setaf $Yello)hat keine Parameter$(tput sgr 0)	- Stoppt das gesammte Grid."
	echo "autostart 		- $(tput setaf $Yello)hat keine Parameter$(tput sgr 0)	- Startet das gesammte Grid."
	echo "works 			- $(tput setab $Magenta)Verzeichnisname$(tput sgr 0)	- Einzelne screens auf Existens prüfen."
	echo "osstart 		- $(tput setab $Magenta)Verzeichnisname$(tput sgr 0)	- Startet einen einzelnen Simulator."
	echo "osstop 			- $(tput setab $Magenta)Verzeichnisname$(tput sgr 0)	- Stoppt einen einzelnen Simulator."
	echo "meineregionen 		- $(tput setaf $Yello)hat keine Parameter$(tput sgr 0) - listet alle Regionen aus den Konfigurationen auf."
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
	echo "logdel 			- $(tput setab $Magenta)Verzeichnisname$(tput sgr 0) - Löscht alle Simulator Log Dateien im Verzeichnis."
	echo "mapdel 			- $(tput setab $Magenta)Verzeichnisname$(tput sgr 0) - Löscht alle Simulator Map-Karten im Verzeichnis."
	echo "settings 		- $(tput setaf $Yello)hat keine Parameter$(tput sgr 0) - setzt Linux Einstellungen."
	echo "configlesen 		- $(tput setab $Magenta)Verzeichnisname$(tput sgr 0) - Alle Regionskonfigurationen im Verzeichnis anzeigen."

echo "$(tput setab $Red)Experten Funktionen$(tput sgr 0)"
	echo "osupgrade 		- $(tput setaf $Yello)hat keine Parameter$(tput sgr 0) - Installiert eine neue OpenSim Version."
	echo "autoregionbackup	- $(tput setaf $Yello)hat keine Parameter$(tput sgr 0) - Backup aller Regionen."
	echo "oscopy			- $(tput setab $Magenta)Verzeichnisname$(tput sgr 0) - Kopiert den Simulator."
	echo "osstruktur		- $(tput setab $Magenta)ersteSIM$(tput sgr 0) $(tput setab $Blue)letzteSIM$(tput sgr 0) - Legt eine Verzeichnisstruktur an."
	echo "compilieren 		- $(tput setaf $Yello)hat keine Parameter$(tput sgr 0) - Kopiert fehlende Dateien und Kompiliert."
	echo "oscompi 		- $(tput setaf $Yello)hat keine Parameter$(tput sgr 0) - Kompiliert einen neuen OpenSimulator ohne kopieren."
	echo "scriptcopy 		- $(tput setaf $Yello)hat keine Parameter$(tput sgr 0) - Kopiert die Scripte in den Source."
	echo "moneycopy 		- $(tput setaf $Yello)hat keine Parameter$(tput sgr 0) - Kopiert Money Source in den OpenSimulator Source."
	echo "osdelete 		- $(tput setaf $Yello)hat keine Parameter$(tput sgr 0) - Löscht alte OpenSim Version."
	echo "regionsiniteilen 	- $(tput setab $Magenta)Verzeichnisname$(tput sgr 0) $(tput setab $Yello)Region$(tput sgr 0) - kopiert aus der Regions.ini eine Region heraus."
	echo "autoregionsiniteilen 	- $(tput setaf $Yello)hat keine Parameter$(tput sgr 0) - aus allen Regions.ini alle Regionen vereinzeln."
	echo "RegionListe 		- $(tput setaf $Yello)hat keine Parameter$(tput sgr 0) - Die RegionList.ini erstellen."
	echo "Regionsdateiliste 	- $(tput setab $Blue)-b Bildschirm oder -d Datei$(tput sgr 0) $(tput setab $Magenta)Verzeichnisname$(tput sgr 0) - Regionsdateiliste erstellen."
	echo "osgitholen 		- $(tput setaf $Yello)hat keine Parameter$(tput sgr 0) - kopiert eine OpenSimulator Entwicklerversion."
	echo "terminator 		- $(tput setaf $Yello)hat keine Parameter$(tput sgr 0) - Killt alle laufenden Screens."
	echo " "
	echo "$(tput setaf $Yello)  Der Verzeichnisname ist gleichzeitig auch der Screen Name!$(tput sgr 0)"
	echo "$DATUM $(date +%H-%M-%S) HILFE: Hilfe wurde angefordert" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
}
### Eingabeauswertung:
case  $KOMMANDO  in
	r | restart) autorestart ;;
	sta | autosimstart | simstart) autosimstart ;;
	sto | autosimstop | simstop) autosimstop ;;
	astart | autostart | start) autotart ;;
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
	oscopy) oscopy ;;
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
	*) hilfe ;;
esac

echo "$DATUM $(date +%H-%M-%S) MULTITOOL: Aufgabe wurde zufriedenstellend ausgeführt" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
echo "#######################################################" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
vardel