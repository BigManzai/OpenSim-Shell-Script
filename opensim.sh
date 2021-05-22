#!/bin/bash

# opensimMULTITOOL Version 0.27.56 (c) May 2021 Manfred Aabye
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
# BASH_VERSION ist eine System Variable
DATUM=$(date +%d-%m-%Y)
# UHRZEIT=$(date +%H-%M-%S)
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
# Black=0
Red=1
Green=2
Yellow=3
Blue=4
# Magenta=5
# Cyan=6
White=7

cd /"$STARTVERZEICHNIS" || return 1
sleep 1
KOMMANDO=$1 # Eingabeauswertung
# MULTITOOLLOG="/$STARTVERZEICHNIS/$DATUM-multitool.log" # Name der Log Datei
function schreibeinfo() 
{
	{	echo "$DATUM $(date +%H-%M-%S) INFO: Server Name: ${HOSTNAME}"
		echo "$DATUM $(date +%H-%M-%S) INFO: Bash Version: ${BASH_VERSION}"
		echo "$DATUM $(date +%H-%M-%S) INFO: MONO THREAD Einstellung: ${MONO_THREADS_PER_CPU}"
		echo "$DATUM $(date +%H-%M-%S) INFO: Spracheinstellung: ${LANG}"
		echo "$DATUM $(date +%H-%M-%S) INFO: Screen Version: $(screen --version)"
		echo " "
	} >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
}
echo "#######################################################" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
echo "$DATUM $(date +%H-%M-%S) MULTITOOL: wurde gestartet" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
schreibeinfo

### Funktion vardel, Variablen loeschen.
function vardel()
{
	unset STARTVERZEICHNIS
	unset MONEYVERZEICHNIS
	unset ROBUSTVERZEICHNIS
	unset WARTEZEIT
	unset STARTWARTEZEIT
	unset unset STOPWARTEZEIT
	unset MONEYWARTEZEIT
	unset Red
	unset Green
	unset White
	echo "$DATUM $(date +%H-%M-%S) VARDEL: Variablen wurden gelöscht" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
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
	echo "$DATUM $(date +%H-%M-%S) MAKEVERZEICHNISLISTE: Verzeichnisliste wurde angefordert" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
}
function makeregionsliste() 
{
    REGIONSLISTE=()
    while IFS= read -r line; do
    REGIONSLISTE+=("$line")
    done < /$STARTVERZEICHNIS/$REGIONSDATEI
    # Anzahl der Eintraege.    
    ANZAHLREGIONSLISTE=${#REGIONSLISTE[*]}
	echo "$DATUM $(date +%H-%M-%S) MAKEREGIONSLISTE: Regionsliste wurde angefordert" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
}

### Funktion assetdel, Asset von der Region loeschen.
# assetdel screen_name Regionsname Objektname
function assetdel()
{
	echo "$(tput setaf $Red) $(tput setab $White)$3 Asset von der Region löschen$(tput sgr 0)"
		screen -S "$1" -p 0 -X eval "stuff 'change region ""$2""'^M" # Region wechseln
		screen -S "$1" -p 0 -X eval "stuff 'alert "Loesche: "$3" von der Region!"'^M" # Mit einer loesch Meldung
		screen -S "$1" -p 0 -X eval "stuff 'delete object name ""$3""'^M" # Objekt loeschen
		screen -S "$1" -p 0 -X eval "stuff 'y'^M" # Mit y also yes bestaetigen
		echo "$DATUM $(date +%H-%M-%S) ASSETDEL: $3 Asset von der Region löschen" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
}

### Funktion oscommand, OpenSim Commands senden.
# oscommand Screen Befehl Parameter
function oscommand()
{	
	Screen=$1 
	Befehl=$2 
	Parameter=$3
	echo "$(tput setab $Green)Sende $Befehl $Parameter an $Screen $(tput sgr 0)"
	screen -S "$Screen" -p 0 -X eval "stuff '$Befehl $Parameter'^M"
	echo "$DATUM $(date +%H-%M-%S) OSCOMMAND: Sende $Befehl $Parameter an $Screen" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
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
	echo "$(tput setaf 2) Alle laufende Screens! $(tput sgr 0)"
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
	  #screen -fa -S "$1" -d -U -m mono OpenSim.exe && sleep 10 && return 0
	  #/$STARTVERZEICHNIS/osscreen.sh "$1" "/$STARTVERZEICHNIS/$1/bin/OpenSim.exe"
	  sleep 10
	  # -fa nicht den Screen nach dem oeffnen 
	  # -S Namen Verwenden 
	  # -d Detach den laufenden screen (und reattach ihn hier)
	  # -U Weist Screen an, die UTF-8-Codierung zu verwenden
	  # -m ignoriere die Variable $STY, erstelle eine neue Bildschirmsitzung.
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
	  echo "$(tput setaf 2)Robust wurde nicht gefunden.$(tput sgr 0)"
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
	  echo "$(tput setaf 2)MoneyServer wurde nicht gefunden.$(tput sgr 0)"
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
	# In das opensim Verzeichnis wechseln wenn es das gibt ansonsten beenden.
	cd /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS || return 1
	
	echo 'Prebuildvorgang startet!'
	# runprebuild19.sh startbar machen und starten.
	chmod +x runprebuild19.sh
	./runprebuild19.sh

	echo 'Kompilierungsvorgang startet!'
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
	echo "$(tput setab $Green)Script Assets werden kopiert! $(tput sgr 0)"
	echo "$DATUM $(date +%H-%M-%S) SCRIPTCOPY: Script Assets werden kopiert" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
	cp -r /$STARTVERZEICHNIS/$SCRIPTSOURCE/assets /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/bin
	cp -r /$STARTVERZEICHNIS/$SCRIPTSOURCE/inventory /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/bin
	echo " "	
}

### Funktion moneycopy, Money Dateien kopieren.
function moneycopy()
{
	echo "$(tput setab $Green)Money Kopiervorgang startet! $(tput sgr 0)"
	echo "$DATUM $(date +%H-%M-%S) MONEYCOPY: Money Kopiervorgang" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
	cp -r /$STARTVERZEICHNIS/$MONEYSOURCE/bin /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS
	cp -r /$STARTVERZEICHNIS/$MONEYSOURCE/addon-modules /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS
	echo " "	
}

### Funktion compilieren, kompilieren des OpenSimulator.
function compilieren()
{
	echo "$(tput setab $Green)Bauen eines neuen OpenSimulators wird gestartet! $(tput sgr 0)"
	echo "$DATUM $(date +%H-%M-%S) COMPILIEREN: Bauen eines neuen OpenSimulators" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
	scriptcopy
	moneycopy
	oscompi	
}

# Legt die Verzeichnisstruktur fuer OpenSim an.
# Aufruf: opensim.sh osstruktur ersteSIM letzteSIM
# Beispiel: ./opensim.sh osstruktur 1 10 - erstellt ein Grid Verzeichnis fuer 10 Simulatoren inklusive der SimulatorList.ini.
function osstruktur()
{
	echo "Lege robust an im Verzeichnis $ROBUSTVERZEICHNIS"
	mkdir -p /$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS/bin

	for ((i=$1;i<=$2;i++))
	do
	echo "Lege sim$i an"
	mkdir -p /$STARTVERZEICHNIS/sim"$i"/bin
	echo "Schreibe sim$i in $SIMDATEI"
	printf 'sim\t%s\n' "$i" >> /$STARTVERZEICHNIS/$SIMDATEI
	done
	echo "$DATUM $(date +%H-%M-%S) OSSTRUKTUR: Lege robust an ,Schreibe sim$i in $SIMDATEI" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
}

### Funktion osdelete
function osdelete()
{
	echo "$(tput setaf $Red) $(tput setab $White)Lösche alte opensim1 Dateien$(tput sgr 0)"
	cd /$STARTVERZEICHNIS  || return 1
	rm -r opensim1
	echo "$(tput setaf $Red) $(tput setab $White)Umbenennen von opensim nach opensim1 zur sicherung$(tput sgr 0)"
	mv opensim opensim1
	echo " "
	echo "$DATUM $(date +%H-%M-%S) OSDELETE: Lösche alte opensim1 Dateien" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
}

### Funktion oscopy
function oscopy()
{
    makeverzeichnisliste
	echo "$(tput setab $Green)Kopiere Robust, Money und Simulatoren! $(tput sgr 0)"
	echo " "
	sleep 3
    # Robust
		echo "$(tput setaf $Green) $(tput setab $White)Robust und Money kopiert$(tput sgr 0)"
		cd /$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS/bin || return 1
		cp -r /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/bin /$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS
    # Sim
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

### Funktion autoregionconf
# ACHTUNG funktioniert nicht zerstört die Konfigurationen!!!
# function autoregionconf()
# {
# 	makeverzeichnisliste
# 	rm -f /$STARTVERZEICHNIS/$REGIONSDATEI # Alte Datei loeschen
# 	sleep 3
# 	for (( i = 0 ; i < "$ANZAHLVERZEICHNISSLISTE" ; i++)) do
# 		TEST+=$(ls /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/Regions/*.ini) # Test ob alle Verzeichnisse stimmen.
# 		REGIONSNAME+=${VERZEICHNISSLISTE[$i]} # simX anhaengen
# 		REGIONSNAME+=" " # Leerzeichen anhaengen
# 		REGIONSNAME+=$(grep "['[']" < /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/Regions/*.ini) # Alle Regionskonfigurationen lesen und die Regionsnamen entnehmen.
		
# 		REGIONSNAMEb=${REGIONSNAME//\[/} # loesche Zeichen [
# 		REGIONSNAMEc=${REGIONSNAMEb//\]/} # loesche Zeichen ]    
# 		echo "$REGIONSNAMEc" >> /$STARTVERZEICHNIS/$REGIONSDATEI # anhaengend schreiben.
		
# 	done
# 	echo "$(tput setab $Green)$TEST $(tput sgr 0)"

#   # Jetzt simX einfuegen 
# 	REGIONSNAMEd=$(sed -e '1,99s/^//' /$STARTVERZEICHNIS/$REGIONSDATEI) # letzte massnahme simX vorsetzen.
# 	echo "$REGIONSNAMEd" > /$STARTVERZEICHNIS/$REGIONSDATEI # ueberschreiben
# 	echo "$REGIONSNAMEd" # Test Ausgabe
# 	echo "$DATUM $(date +%H-%M-%S) AUTOREGIONCONF: Autoregionskonfiguration abgeschlossen" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
# }

### Funktion osupgrade
function osupgrade()
{
	echo "$(tput setab $Green)Das Grid wird jetzt upgegradet! $(tput sgr 0)"
	echo " "
	# Grid Stoppen.
	autostop
	# Kopieren.
	oscopy
	# Grid Starten.
	autostart
	echo "$DATUM $(date +%H-%M-%S) OSUPGRADE: Das Grid wird jetzt upgegradet" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
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
	# Datum für die Dateinamen in die Variable DATUM schreiben.
	DATUM=$(date +%F)
	sleep 3
	SCREENNAME=$1
	REGIONSNAME=$2	
	dateiname=${REGIONSNAME//\"/}
	nospace=${dateiname// /}

	echo "$(tput setaf 4) $(tput setab 7)Region $nospace speichern$(tput sgr 0)"
	cd /$STARTVERZEICHNIS/"$SCREENNAME"/bin || return 1
	# Ich kann nicht pruefen ob die Region im OpenSimulator vorhanden ist.
	# Sollte sie nicht vorhanden sein wird root also alle Regionen gespeichert.
	screen -S "$SCREENNAME" -p 0 -X eval "stuff 'change region ${REGIONSNAME//\"/}'^M"
	screen -S "$SCREENNAME" -p 0 -X eval "stuff 'save oar /$STARTVERZEICHNIS/backup/'$DATUM'-$nospace.oar'^M"
	screen -S "$SCREENNAME" -p 0 -X eval "stuff 'terrain save /$STARTVERZEICHNIS/backup/'$DATUM'-$nospace.png'^M"
	screen -S "$SCREENNAME" -p 0 -X eval "stuff 'terrain save /$STARTVERZEICHNIS/backup/'$DATUM'-$nospace.raw'^M"
	echo " "
	sleep 10
	if [ ! -f /$STARTVERZEICHNIS/"$SCREENNAME"/bin/Regions/"$nospace".ini ]; then
		cp -r /$STARTVERZEICHNIS/"$SCREENNAME"/bin/Regions/Regions.ini /$STARTVERZEICHNIS/backup/"$DATUM"-"$nospace".ini
		echo "$(tput setaf 2)Regions.ini wurde als $DATUM-$nospace.ini gespeichert."
		echo "Bitte alle Regionen bis auf Region ${REGIONSNAME//\"/} aus dieser Datei entfernen.$(tput sgr 0)"
	fi
	if [ ! -f /$STARTVERZEICHNIS/"$SCREENNAME"/bin/Regions/"${REGIONSNAME//\"/}".ini ]; then
		cp -r /$STARTVERZEICHNIS/"$SCREENNAME"/bin/Regions/Regions.ini /$STARTVERZEICHNIS/backup/"$DATUM"-"$nospace".ini
		echo "$(tput setaf 2)Regions.ini wurde als $DATUM-$nospace.ini gespeichert."
		echo "Bitte alle Regionen bis auf Region ${2//\"/} aus dieser Datei entfernen.$(tput sgr 0)"
	fi
	if [ ! -f /$STARTVERZEICHNIS/"$SCREENNAME"/bin/Regions/Regions.ini ]; then
		cp -r /$STARTVERZEICHNIS/"$SCREENNAME"/bin/Regions/"$nospace".ini /$STARTVERZEICHNIS/backup/"$DATUM"-"$nospace".ini	
	fi
	echo "$DATUM $(date +%H-%M-%S) REGIONBACKUP: Backup wurde gestartet" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
}

### Funktion autosimstart
function autosimstart()
{
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
	makeregionsliste
	sleep 3
	for (( i = 0 ; i < "$ANZAHLREGIONSLISTE" ; i++)) do
		derscreen=$(echo "${REGIONSLISTE[$i]}" | cut -d ' ' -f 1)
		dieregion=$(echo "${REGIONSLISTE[$i]}" | cut -d ' ' -f 2)
		regionbackup "$derscreen" "$dieregion"
		echo "$DATUM $(date +%H-%M-%S) AUTOREGIONBACKUP: Auto Regionsbackup $derscreen - $dieregion" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
		sleep $BACKUPWARTEZEIT
	done
}
### Funktion autoscreenstop
function autoscreenstop()
{
	makeverzeichnisliste
	sleep 3
	for (( i = 0 ; i < "$ANZAHLVERZEICHNISSLISTE" ; i++)) do
    	screen -S "${VERZEICHNISSLISTE[$i]}" -X quit
	done
	screen -S MO -X quit
	screen -S RO -X quit
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
	echo "$AUTOSTOPZEIT Sekunden warten bis die Simulatoren heruntergefahren sind!"
	sleep $AUTOSTOPZEIT
	echo " "
	echo "$(tput setab 1)Beende alle noch offenen Screens! $(tput sgr 0)"
	autoscreenstop
	echo " "
	screenlist
	echo " "
	echo "$DATUM $(date +%H-%M-%S) AUTOSTOP: Auto Stopp abgeschlossen" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
}
### Funktion autorestart
function autorestart()
{
	echo "$(tput setab 1)Stoppe alles! $(tput sgr 0)"
	autosimstop
	gridstop
	echo "60 Sekunden warten bis die Simulatoren heruntergefahren sind!"
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
info
echo " "

	echo "$(tput setab $Green)Funktion:		Parameter:		Informationen: $(tput sgr 0)"
	echo "hilfe 			- hat keine Parameter - Diese Hilfe."
	echo "restart 		- hat keine Parameter - Startet das gesammte Grid neu."
	echo "autostop 		- hat keine Parameter - Stoppt das gesammte Grid."
	echo "autostart 		- hat keine Parameter - Startet das gesammte Grid."
	echo "works 			- Verzeichnisname - Einzelne screens auf Existens prüfen."

echo "$(tput setab $Yellow)Erweiterte Funktionen$(tput sgr 0)"
	echo "rostart 		- hat keine Parameter - Startet Robust Server."
	echo "rostop 			- hat keine Parameter - Stoppt Robust Server."
	echo "mostart 		- hat keine Parameter - Startet Money Server."
	echo "mostop 			- hat keine Parameter - Stoppt Money Server."
	echo "osstart 		- Verzeichnisname - Startet einzelnen Simulator."
	echo "osstop 			- Verzeichnisname - Stoppt einzelnen Simulator."
	echo "terminator 		- hat keine Parameter - Killt alle laufenden Screens."
	echo "autoscreenstop		- hat keine Parameter - Killt alle OpenSim Screens."
	echo "autosimstart 		- hat keine Parameter - Startet alle Regionen."
	echo "autosimstop 		- hat keine Parameter - Beendet alle Regionen. "
	echo "gridstart 		- hat keine Parameter - Startet Robust und Money. "
	echo "gridstop 		- hat keine Parameter - Beendet Robust und Money. "
	echo "configlesen 		- Verzeichnisname - Alle Regionskonfigurationen im Verzeichnis anzeigen. "

echo "$(tput setab $Red)Experten Funktionen$(tput sgr 0)"
	echo "assetdel 		- screen_name Regionsname Objektname - Einzelnes Asset löschen."
	echo "autologdel		- hat keine Parameter - Löscht alle Log Dateien."
	echo "automapdel		- hat keine Parameter - Löscht alle Map Karten."
	echo "logdel 			- Verzeichnisname - Löscht einzelne Simulator Log Dateien."
	echo "mapdel 			- Verzeichnisname - Löscht einzelne Simulator Map-Karten."
	echo "settings 		- hat keine Parameter - setzt Linux Einstellungen."
	echo "osupgrade 		- hat keine Parameter - Installiert eine neue OpenSim Version."
	echo "regionbackup 		- Verzeichnisname Regionsname - Backup einer ausgewählten Region."
	echo "autoregionbackup	- hat keine Parameter - Backup aller Regionen."
	echo "oscopy			- Verzeichnisname - Kopiert den Simulator."
	echo "osstruktur		- ersteSIM letzteSIM - Legt die Verzeichnisstruktur an."
	echo "compilieren 		- hat keine Parameter - Kopiert fehlende Dateien und Kompiliert."
	echo "scriptcopy 		- hat keine Parameter - Kopiert die Scripte in den Source."
	echo "moneycopy 		- hat keine Parameter - Kopiert das Money in den Source."
	echo "osdelete 		- hat keine Parameter - Löscht alte OpenSim Version."
	echo "oscompi 		- hat keine Parameter - Kompiliert einen neuen OpenSimulator."
	echo "oscommand 		- screen_name Konsolenbefehl Parameter - OpenSim Konsolenbefehl senden."
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
	settings)	ossettings ;;
	rs | robuststart | rostart) rostart ;;
	ms | moneystart | mostart) mostart ;;
	rsto | robuststop | rostop) rostop ;;
	mstop | moneystop | mostop) mostop ;;
	osstop) osstop "$2" ;;
	osstart) osstart "$2" ;;
	gridstart) gridstart ;;
	gridstop) gridstop ;;
	sd | screendel)	autoscreenstop ;;
	l | list | screenlist) screenlist ;;
	w | works) works "$2" ;;
	md | mapdel) mapdel "$2" ;;
	ld | logdel) logdel "$2" ;;
	ss | osscreenstop) osscreenstop "$2" ;;
	h | hilfe | help) hilfe ;;
	asdel | assetdel) assetdel "$2" "$3" "$4" ;;
	e | terminator) terminator ;;
	osupgrade) osupgrade ;;
	oscopy) oscopy ;;
	regionbackup) regionbackup "$2" "$3" ;;
	autoregionbackup) autoregionbackup ;;
	compilieren) compilieren ;;
	scriptcopy) scriptcopy ;;
	moneycopy) moneycopy ;;
	oscompi) oscompi ;;
	osdelete) osdelete ;;
	osstruktur) osstruktur "$2" "$3" ;;
	configlesen) configlesen "$2" ;;
	com | oscommand) oscommand "$2" "$3" "$4" ;;
    *) hilfe ;;
esac

vardel
echo "$DATUM $(date +%H-%M-%S) MULTITOOL: Alles wurde beendet" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"
echo "#######################################################" >> "/$STARTVERZEICHNIS/$DATUM-multitool.log"