#!/bin/bash

#* Aufruf Beispiel: ./config.sh
#* Dies schreibt per abfrage die Konfigurationen für den OpenSimulator.
#* Author Manfred Aabye 2023 MIT Lizens, Ubuntu 22.04 Linux Server.

### Eintragungen uebersicht!
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

# Variables
STARTVERZEICHNIS="home"; # Hauptverzeichnis
ROBUSTVERZEICHNIS="robust"; # Robustverzeichnis
SIMDATEI="SimulatorList.ini";
OPENSIMVERZEICHNIS="opensim";
SCRIPTNAME="constconfig" # Versionsausgabe
VERSION="0.1.0.0" # Versionsausgabe
### Aktuelle IP ueber Suchadresse ermitteln und Ausfuehrungszeichen anhaengen.
SEARCHADRES="icanhazip.com"
AKTUELLEIP="$(wget -O - -q $SEARCHADRES)"

tput reset # Bildschirmausgabe loeschen inklusive dem Scrollbereich.
#linefontcolor=2	linebaggroundcolor=0;
#lline="$(tput setaf $linefontcolor)$(tput setab $linebaggroundcolor)#####################################################################################$(tput sgr 0)"

function silent(){ STARTVERZEICHNIS="opt"; }

# Ausgabe Kopfzeilen
echo "$SCRIPTNAME Version $VERSION"
echo " "
echo "Ihre aktuelle externe IP ist $AKTUELLEIP"
echo " "
echo "#################################"
echo "ABBRUCH MIT DER TASTENKOMBINATION"
echo "########  STRG + C  #############"
echo " "
echo "Die Werte in den [Klammern] sind vorschläge und können mit Enter übernommen werden."
echo " "
echo "Wieviele Konfigurationen darf ich ihnen schreiben? [5]"
read -r CONFIGANZAHL
if [ "$CONFIGANZAHL" = "" ]; then CONFIGANZAHL="5"; fi
echo "Ihre Anzahl ist $CONFIGANZAHL"
echo " "

echo "Wohin darf ich diese schreiben? [$STARTVERZEICHNIS]"
read -r VERZEICHNISABFRAGE
if [ "$VERZEICHNISABFRAGE" = "" ]; then echo "$STARTVERZEICHNIS"; else STARTVERZEICHNIS="$VERZEICHNISABFRAGE";fi
echo "Ihr Konfigurationsordner ist $STARTVERZEICHNIS"
echo " "

echo "Ihre Server Adresse? [$AKTUELLEIP]"
read -r BASEHOSTNAME
if [ "$BASEHOSTNAME" = "" ]; then BASEHOSTNAME="$AKTUELLEIP"; fi
echo "Ihre Server Adresse ist $BASEHOSTNAME"
echo " "

echo "Ihr SimulatorPort startet bei: [9010]"
read -r SIMULATORPORT
if [ "$SIMULATORPORT" = "" ]; then SIMULATORPORT="9010"; fi
echo "Ihr SimulatorPort startet bei: $SIMULATORPORT"
echo " "

echo "Bitte geben sie den Datenbanknamen an [opensim]:"
read -r MYSQLDATABASE
if [ "$MYSQLDATABASE" = "" ]; then MYSQLDATABASE="opensim"; fi
echo "Ihr Datenbanknamen lautet: $MYSQLDATABASE"
echo " "

echo "Bitte geben sie den Benutzernamen ihrer Datenbank an [opensim]:"
read -r MYSQLUSER
if [ "$MYSQLUSER" = "" ]; then MYSQLUSER="opensim"; fi
echo "Ihr Datenbank Benutzername lautet: $MYSQLUSER"
echo " "

echo "Bitte geben sie das Passwort ihrer Datenbank an [opensim]:"
read -r MYSQLPASSWORD
if [ "$MYSQLPASSWORD" = "" ]; then MYSQLPASSWORD="opensim"; fi
echo "Ihr Passwort ihrer Datenbank lautet: ********"
echo " "

echo "Bitte geben sie den Namen ihrer Startregion an [Welcome]:"
read -r STARTREGION
if [ "$STARTREGION" = "" ]; then STARTREGION="Welcome"; fi
echo "Der Namen ihrer Startregion lautet: $STARTREGION"
echo " "

echo "Bitte geben sie den Namen ihres Grids an [MyGrid]:"
read -r SIMULATORGRIDNAME
if [ "$SIMULATORGRIDNAME" = "" ]; then SIMULATORGRIDNAME="MyGrid"; fi
echo "Der Namen ihrers Grids lautet: $SIMULATORGRIDNAME"
echo " "

echo "Bitte geben sie den Grid-Nickname an [MG]:"
read -r SIMULATORGRIDNICK
if [ "$SIMULATORGRIDNICK" = "" ]; then SIMULATORGRIDNICK="MG"; fi
echo "Der Grid-Nickname lautet: $SIMULATORGRIDNICK"
echo " "

# Weitere Auswertungen
if [ "$PRIVURL" = "" ]; then PRIVURL="\${Const|BaseURL}"; fi
if [ "$MONEYPORT" = "" ]; then MONEYPORT="8008"; fi

### ! configausgabe
function configausgabe() {
{
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

### !  osstruktur, legt die Verzeichnisstruktur fuer OpenSim an. # Aufruf: opensim.sh osstruktur ersteSIM letzteSIM
# Beispiel: ./opensim.sh osstruktur 1 10 - erstellt ein Grid Verzeichnis fuer 10 Simulatoren inklusive der $SIMDATEI.
function osconfigstruktur() {
    # Ist die /"$STARTVERZEICHNIS"/$SIMDATEI vorhanden dann zuerst löschen
    if [ ! -f "/$STARTVERZEICHNIS/$SIMDATEI" ]; then
        #rm /"$STARTVERZEICHNIS"/$SIMDATEI
        echo "$SIMDATEI Datei ist noch nicht vorhanden"
    else
        echo "Lösche vorhandene $SIMDATEI"
        rm /"$STARTVERZEICHNIS"/$SIMDATEI
    fi
    # Ist die Datei 
	if [ ! -f "/$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/" ]; then
		echo "Lege robust an im Verzeichnis $ROBUSTVERZEICHNIS"
		mkdir -p /"$STARTVERZEICHNIS"/$ROBUSTVERZEICHNIS/bin/config-include
        CONSTINI="/$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS/bin/config-include/Const.ini"
        configausgabe "$BASEHOSTNAME" "$PRIVURL" "$MONEYPORT" "$SIMULATORPORT" "$MYSQLDATABASE" "$MYSQLUSER" "$MYSQLPASSWORD" "$STARTREGION" "$SIMULATORGRIDNAME" "$SIMULATORGRIDNICK" "$CONSTINI"

	else
		log error "Verzeichnis $ROBUSTVERZEICHNIS existiert bereits"
	fi
	for ((i = 1; i <= $2; i++)); do
		echo "Ich lege gerade sim$i an!"
		mkdir -p /"$STARTVERZEICHNIS"/sim"$i"/bin/config-include
        cd /"$STARTVERZEICHNIS"/sim"$i"/bin/config-include || exit # Beenden wenn Verzeichnis nicht vorhanden ist.
        CONSTINI="/$STARTVERZEICHNIS/sim$i/bin/config-include/Const.ini"
        ZWISCHENSPEICHERMSDB=$MYSQLDATABASE
        ZWISCHENSPEICHERSP=$SIMULATORPORT
        configausgabe "$BASEHOSTNAME" "$PRIVURL" "$MONEYPORT" "$((SIMULATORPORT + "$i"))" "$MYSQLDATABASE$i" "$MYSQLUSER" "$MYSQLPASSWORD" "$STARTREGION" "$SIMULATORGRIDNAME" "$SIMULATORGRIDNICK" "$CONSTINI"
        echo "Schreibe sim$i in $SIMDATEI, legen sie bitte Datenbank $MYSQLDATABASE an."
		# xargs sollte leerzeichen entfernen.
		printf 'sim'"$i"'\t%s\n' | xargs >>/"$STARTVERZEICHNIS"/$SIMDATEI
        MYSQLDATABASE=$ZWISCHENSPEICHERMSDB
        SIMULATORPORT=$ZWISCHENSPEICHERSP
	done
	echo "Lege robust an!"
	return 0
}

osconfigstruktur 1 "$CONFIGANZAHL"
