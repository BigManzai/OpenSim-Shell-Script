#!/bin/bash

# ? opensimMULTITOOL Copyright (c) 2021 2023 BigManzai Manfred Aabye
# osmtool.sh Basiert auf meinen Einzelscripten, an denen ich bereits 7 Jahre Arbeite und verbessere.
# Da Server unterschiedlich sind, kann eine einwandfreie fuunktion nicht gewaehrleistet werden, also bitte mit bedacht verwenden.
# Die Benutzung dieses Scriptes, oder deren Bestandteile, erfolgt auf eigene Gefahr!!!
# Erstellt und getestet ist osmtool.sh, auf verschiedenen Ubuntu 18.04 Servern, unter verschiedenen Server Anbietern (Contabo, Hetzner ...).

# ? Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

# ? The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

# ! THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# ! FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# ! LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# * Status 09.02.2024 350 Funktionen.

# # Visual Studio Code # ShellCheck # shellman # Better Comments # outline map #

#### ? Einstellungen ####

SCRIPTNAME="opensimMULTITOOL" # opensimMULTITOOL Versionsausgabe
VERSION="V0.92.750" # opensimMULTITOOL Versionsausgabe
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

NEUERREGIONSNAME="Welcome"
function namen(){
	# Array aus Bezeichnungen von Deutschen Orten und Voelker.
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
	"Ermunduren" "Danduten")

	# Zaehlen wie viele es sind.
	count=${#namensarray[@]}
	#echo $count

	# Zufallszahl ermmiteln aus der anzahl von eintraegen in dem namensarray.
	REGIONSNAMENZAHL=$(($RANDOM % $count))
	#echo $REGIONSNAMENZAHL

	# Regionsname ausgeben	
	NEUERREGIONSNAME=${namensarray[$REGIONSNAMENZAHL]}
	echo "Neuer Regionsname: $NEUERREGIONSNAME"

	# ausgeben aller Namen.
	# for i in ${namensarray[@]}; do
	# echo $i
	# done
}

### ! osmtoolconfig autoconfigure
function osmtoolconfig() {

	STARTVERZEICHNIS=$1
	ROBUSTVERZEICHNIS=$2
	MONEYVERZEICHNIS=$3
	OPENSIMVERZEICHNIS=$4
	CONFIGPFAD=$5
	OSTOOLINI=$6
# GRIDCACHECLEAR="yes"; ASSETCACHECLEAR="yes"; MAPTILESCLEAR="yes"; SCRIPTCLEAR="yes"; RMAPTILESCLEAR="yes"; RBAKESCLEAR="yes";
    {
		echo "### Einstellungen $SCRIPTNAME $VERSION"
		echo "     "
		echo "## Das Startverzeichnis home oder opt zum Beispiel."
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
		echo "     "
		echo '    CONFIGURESOURCE="opensim-configuration-addon-modul-main"'
		echo '    CONFIGUREZIP="opensim-configuration-addon-modul-main.zip"'
		echo "     "
		echo '    OSSEARCHSOURCE="OpenSimSearch"'
		echo '    OSSEARCHSZIP="OpenSimSearch-master.zip"'
		echo "     "
		echo "## Schrift- und Hintergrundfarben"
		echo "##  0 – Black, 1 – Red, 2 – Green, 3 – Yellow, 4 – Blue, 5 – Magenta, 6 – Cyan, 7 – White"
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
		echo '    line="############################################################";'
		echo "     "
		echo "## Dateien"
		echo '    REGIONSDATEI="osmregionlist.ini"'
		echo '    SIMDATEI="osmsimlist.ini"'
		echo '    OPENSIMDOWNLOAD="http://opensimulator.org/dist/"'
		echo '    OPENSIMVERSION="opensim-0.9.2.2Dev"'
		echo '    SEARCHADRES="icanhazip.com" # Suchadresse'
		echo "     "
		echo '    REGIONSANZEIGE="yes"'
		echo "     "
		echo '    LOGDELETE="yes" # yes/no'
		echo '    VISITORLIST="yes" # yes/no - schreibt vor dem loeschen alle Besucher samt mac in eine log Datei.'
		echo "     "
		echo "## Inklusive"
		echo '    SCRIPTCOPY="yes"'
		echo '    MONEYCOPY="yes"'
		echo '    CONFIGURECOPY="no"'
		echo '    PYTHONCOPY="no"'
		echo '    MUTELISTCOPY="no"'
		echo '    SEARCHCOPY="no"'
		echo '    CHRISOSCOPY="no"'
		echo '    AUTOCONFIG="no"'
		echo '    OSSEARCHCOPY="no"'
		echo "     "
		echo "## Die unterschiedlichen wartezeiten bis die Aktion ausgefuehrt wurde."
		echo "    WARTEZEIT=60 # Ist eine allgemeine Wartezeit."
		echo "    STARTWARTEZEIT=10 # Startwartezeit ist eine Pause, damit nicht alle Simulatoren gleichzeitig starten."
		echo "    STOPWARTEZEIT=30 # Stopwartezeit ist eine Pause, damit nicht alle Simulatoren gleichzeitig herunterfahren."
		echo "    MONEYWARTEZEIT=60 # Moneywartezeit ist eine Extra Pause, weil dieser zwischen Robust und Simulatoren gestartet werden muss."
		echo "    ROBUSTWARTEZEIT=90 # Robust wartezeit ist eine Extra Pause, weil dieser komplett gestartet werden muss."
		echo "    BACKUPWARTEZEIT=180 # Backupwartezeit ist eine Pause, damit der Server nicht ueberlastet wird."
		echo "    AUTOSTOPZEIT=60 # Autostopzeit ist eine Pause, um den Simulatoren zeit zum herunterfahren gegeben wird, bevor haengende Simulatoren gekillt werden."
		echo "     "
		echo "## Linux Einstellungen"
		echo '    SETMONOTHREADSON="yes"'
		echo "    SETMONOTHREADS=1024"
		echo '    SETULIMITON="yes"'
		echo '    SETMONOGCPARAMSON1="no"'
		echo '    SETMONOGCPARAMSON2="yes"'
		echo "     "
		echo "## Mono Version fuer Build Vorgang Visual Studio 2019 oder 2022 - Zweite Zahl net/mono framework."
		echo "    # 1948, 1950, 1960, 1970 - 2248, 2250, 2260, 2270"
		echo '    netversion="2248"'
		echo "     "
		echo "## Divers"
		echo '    SETOSCOMPION="no" # Mit oder ohne log Datei kompilieren. yes oder no.'
		echo '    SETAOTON="no"'
		echo "    # opensim-0.9.2.2Dev-4-g5e9b3b4.zip"
		echo '    OSVERSION="opensim-0.9.2.2Dev-"'
		echo "     "
		echo "## Bereinigungen"
		echo '    AUTOCLEANALL="yes"'
		echo '    GRIDCACHECLEAR="yes"'
		echo '    SCRIPTCLEAR="no"'
		echo '    ASSETCACHECLEAR="yes"'
		echo '    MAPTILESCLEAR="yes"'
		echo '    RMAPTILESCLEAR="yes"'
		echo '    RBAKESCLEAR="yes"'
		echo "     "
		echo "## OpenSim Downloads"
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
		echo "## Log Dateien"
		echo '    apache2errorlog="/var/log/apache2/error.log"'
		echo '    apache2accesslog="/var/log/apache2/access.log"'
		echo '    authlog="/var/log/auth.log"'
		echo '    ufwlog="/var/log/ufw.log"'
		echo '    mysqlmariadberor="/var/log/mysql/mariadb.err"'
		echo '    mysqlerrorlog="/var/log/mysql/error.log"'
		echo "     "
		echo "## Liste der zu verwendende Musiklisten."
		echo '    listVar="50s 60s 70s 80s 90s Alternative Blues Classic Club Country Dance Disco EDM Easy Electronic Folk Funk Gothic Heavy Hits House Indie Jazz Metal Misc Oldies Party Pop Reggae Rock Schlager Soul Techno Top Trance industrial pop"'
    } > "$OSTOOLINI"

	echo "### Ihre neuen Konfigurationsdateien wurden geschrieben! ###"
	echo "#####################  FERTIG  #############################"
}

### ! dummyvar, Shell-Check ueberlisten wegen der Konfigurationsdatei, hat sonst keinerlei Funktion und wird auch nicht aufgerufen.
function dummyvar() {
	# shellcheck disable=SC2034
	STARTVERZEICHNIS="opt"; MONEYVERZEICHNIS="robust"; ROBUSTVERZEICHNIS="robust"; OPENSIMVERZEICHNIS="opensim"; SCRIPTSOURCE="ScriptNeu"; SCRIPTZIP="opensim-ossl-example-scripts-main.zip"; MONEYSOURCE="money48"
	MONEYZIP="OpenSimCurrencyServer-2021-master.zip"; OSVERSION="opensim-0.9.2.2Dev"; REGIONSDATEI="osmregionlist.ini"; SIMDATEI="osmsimlist.ini"; WARTEZEIT=30; STARTWARTEZEIT=10; STOPWARTEZEIT=30; MONEYWARTEZEIT=60; ROBUSTWARTEZEIT=60
	BACKUPWARTEZEIT=120; AUTOSTOPZEIT=60; SETMONOTHREADS=800; SETMONOTHREADSON="yes"; OPENSIMDOWNLOAD="http://opensimulator.org/dist/"; OPENSIMVERSION="opensim-0.9.2.2.zip"; SEARCHADRES="icanhazip.com"; # AUTOCONFIG="no"
	CONFIGURESOURCE="opensim-configuration-addon-modul-main"; CONFIGUREZIP="opensim-configuration-addon-modul-main.zip"
	textfontcolor=7; textbaggroundcolor=0; debugfontcolor=4; debugbaggroundcolor=0	infofontcolor=2	infobaggroundcolor=0; warnfontcolor=3; warnbaggroundcolor=0
	errorfontcolor=1; errorbaggroundcolor=0; SETMONOGCPARAMSON1="no"; SETMONOGCPARAMSON2="yes"	LOGDELETE="no"; LOGWRITE="no"; "$trimmvar"; logfilename="_multitool"
	username="username"	password="userpasswd"	databasename="grid"	linefontcolor=7	linebaggroundcolor=0; apache2errorlog="/var/log/apache2/error.log"; apache2accesslog="/var/log/apache2/access.log"
	authlog="/var/log/auth.log"	ufwlog="/var/log/ufw.log"	mysqlmariadberor="/var/log/mysql/mariadb.err"; mysqlerrorlog="/var/log/mysql/error.log"; listVar=""; ScreenLogLevel=0
	# DIALOG_OK=0; DIALOG_HELP=2; DIALOG_EXTRA=3; DIALOG_ITEM_HELP=4; SIG_NONE=0; SIG_HUP=1; SIG_INT=2; SIG_QUIT=3; SIG_KILL=9; SIG_TERM=15
	DIALOG_CANCEL=1; DIALOG_ESC=255; DIALOG=dialog; VISITORLIST="yes"; REGIONSANZEIGE="yes"; #DELREGIONS="no";
	netversion="1946"; CONFIGPFAD="OpenSimConfig";
}

function osmtoolconfigabfrage() {
	# Ausgabe Kopfzeilen
	echo "$SCRIPTNAME Version $VERSION"
	echo " "
	echo "##################################################################"
	echo "########### ABBRUCH MIT DER TASTENKOMBINATION ####################"
	echo "####################  STRG + C  ##################################"
	echo "##################################################################"
	echo "##     Die Werte in den [Klammern] sind vorschläge              ##"
	echo "##     und können mit Enter übernommen werden.                  ##"
	echo "##################################################################"
	echo "##   Daten stehen gegeben falls auch in der alten opensim.cnf   ##"
	echo "##################################################################"
	echo " "
	echo "Das Verzeichnis wo sich ihr Grid befindet oder befinden soll [opt]"
	read -r STARTVERZEICHNIS
	if [ "$STARTVERZEICHNIS" = "" ]; then STARTVERZEICHNIS="opt"; fi
	echo "Ihr Gridverzeichnis ist $STARTVERZEICHNIS"
	echo "##################################################################"

	echo "Das Verzeichnis wo sich ihr Robust befindet [robust]"
	read -r ROBUSTVERZEICHNIS
	if [ "$ROBUSTVERZEICHNIS" = "" ]; then ROBUSTVERZEICHNIS="robust"; fi
	echo "Ihr Robustverzeichnis ist $ROBUSTVERZEICHNIS"
	echo "##################################################################"

	echo "Das Verzeichnis wo sich ihr Moneyverzeichnis befindet [robust]"
	read -r MONEYVERZEICHNIS
	if [ "$MONEYVERZEICHNIS" = "" ]; then MONEYVERZEICHNIS="robust"; fi
	echo "Ihr Moneyverzeichnis ist $MONEYVERZEICHNIS"
	echo "##################################################################"

	echo "Das Verzeichnis wo sich ihr OpenSimverzeichnis befindet [opensim]"
	read -r OPENSIMVERZEICHNIS
	if [ "$OPENSIMVERZEICHNIS" = "" ]; then OPENSIMVERZEICHNIS="opensim"; fi
	echo "Ihr OpenSimverzeichnis ist $OPENSIMVERZEICHNIS"
	echo "##################################################################"

	echo "Das Verzeichnis wo sich ihre Konfigurationsdateien befindet [OpenSimConfig]"
	read -r CONFIGPFAD
	if [ "$CONFIGPFAD" = "" ]; then CONFIGPFAD="OpenSimConfig"; fi
	echo "Ihr Konfigurationsdateienverzeichnis ist $CONFIGPFAD"
	echo "##################################################################"

    # Fertig und abfragen
    #osmtoolconfig "/opt/osmtoolconfig.ini"
	osmtoolconfig $STARTVERZEICHNIS $ROBUSTVERZEICHNIS $MONEYVERZEICHNIS $OPENSIMVERZEICHNIS $CONFIGPFAD "/$SCRIPTPATH/osmtoolconfig.ini"
}

AKTUELLEVERZ=$(pwd) # Aktuelles Verzeichnis

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
# SQL Version
SQLVERSIONVOLL=$(mysqld --version)
SQLVERSION=$(echo "${SQLVERSIONVOLL:0:45}")

### Einstellungen aus osmtoolconfig.ini laden, bei einem Script upgrade gehen so die einstellungen nicht mehr verloren.

# Pfad des osmtool.sh Skriptes herausfinden
SCRIPTPATH=$(cd "$(dirname "$0")" && pwd)

# Nutzer mit Konfigurationsfragen quaelen
# Abfrage Konfig Einstellungen
if ! [ -f "/$SCRIPTPATH/osmtoolconfig.ini" ]; then osmtoolconfigabfrage; fi

# Wenn es keine Konfigurationsdatei gibt anlegen
#if ! [ -f "/$SCRIPTPATH/osmtoolconfig.ini" ]; then osmtoolconfig "/$SCRIPTPATH/osmtoolconfig.ini"; fi

# Variablen aus config Datei laden osmtoolconfig.ini muss sich im gleichen Verzeichnis wie osmtool.sh befinden.
# shellcheck disable=SC1091
. "$SCRIPTPATH"/osmtoolconfig.ini

### Aktuelle IP ueber Suchadresse ermitteln und Ausfuehrungszeichen anhaengen.
AKTUELLEIP='"'$(wget -O - -q $SEARCHADRES)'"'

### gibt es das Startverzeichnis wenn nicht abbruch.
cd /"$STARTVERZEICHNIS" || return 1
sleep 1

# install dialog
function instdialog () {
	echo "Ich installiere jetzt dialog"
	sudo apt-get -y update
	sudo apt-get -y upgrade
	sudo apt-get -y install dialog
	# Warscheinlich ist die Installation fehlgeschlagen da abhängigkeiten fehlen.
	sudo apt-get -f install # abhängiketen nachinstallieren
	sudo apt-get -y install dialog # erneute installation
	#dialog --title 'Dialog Nachricht' --msgbox '. . . . Dialog wurde Installiert!' 6 50
	dialog --title 'Die erste Dialog Nachricht' --calendar 'Dialog wurde Installiert am:' 0 0
	tput reset # Bildschirmausgabe loeschen inklusive dem Scrollbereich.
}


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

### Beenden mit ausgabe der letzten Meldung.
function ende() {
	return
	log info "$?" # Beenden mit ausgabe der letzten Meldung.
}

### Den aufrufenden Prozess mit der letzten Meldung beenden.
function fehler() {
	exit
	log error "$?" # Den aufrufenden Prozess mit der letzten Meldung beenden.
}

### Den aufrufenden Prozess mit der letzten Meldung beenden.
function clearuserlist() {
	echo "Lösche Besucherlisten log"
	rm -r /$STARTVERZEICHNIS/*_osmvisitorlist.log
	echo "Lösche Besucherlisten txt"
	rm -r /$STARTVERZEICHNIS/*_osmvisitorlist.txt
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
	file="/$STARTVERZEICHNIS/osmtool.sh"
	ergebnisfunktionslist=$(grep -i -r "function " $file)
	echo "$ergebnisfunktionslist" >/$STARTVERZEICHNIS/osmfunktion"$DATEIDATUM".txt
}

### ! lastrebootdatum letzter reboot des Servers.
function lastrebootdatum() {
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
	datediff=$(( ("$first_date" - "$second_date") / ("$period") ))
	lastrebootdatuminfo="Sie haben vor $datediff Tag(en) ihren Server neu gestartet"
	if (( $(echo "${datediff} >= 30") )); then
		log warn "$lastrebootdatuminfo"
	else
		log info "$lastrebootdatuminfo"
	fi	
}

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

### ! Kopfzeile
function schreibeinfo() {
	# *Wenn die Log Datei nicht existiert muss sie erstellt werden sonst gibt es eine Fehlermeldung.
	if [ "$LOGWRITE" = "yes" ]; then
		if [ -f /$STARTVERZEICHNIS/"$DATEIDATUM""$logfilename".log ]; then
			# echo "/$STARTVERZEICHNIS/$DATEIDATUM$logfilename.log ist vorhanden!"
			echo " "
		else
			# echo "/$STARTVERZEICHNIS/$DATEIDATUM$logfilename.log ist nicht vorhanden und wird jetzt angelegt!"
			echo " " >/$STARTVERZEICHNIS/"$DATEIDATUM""$logfilename".log
		fi
	fi

	# NULL=0
	# Ist die Datei Groesser als null, dann Kopfzeile nicht erneut schreiben.
	# if [ "$FILESIZE" \< "$NULL" ]; then
		log rohtext "   ____                        _____  _                    _         _               "
		log rohtext "  / __ \                      / ____|(_)                  | |       | |              "
		log rohtext " | |  | | _ __    ___  _ __  | (___   _  _ __ ___   _   _ | |  __ _ | |_  ___   _ __ "
		log rohtext " | |  | ||  _ \  / _ \|  _ \  \___ \ | ||  _   _ \ | | | || | / _  || __|/ _ \ |  __|"
		log rohtext " | |__| || |_) ||  __/| | | | ____) || || | | | | || |_| || || (_| || |_| (_) || |   "
		log rohtext "  \____/ |  __/  \___||_| |_||_____/ |_||_| |_| |_| \____||_| \____| \__|\___/ |_|   "
		log rohtext "         | |                                                                         "
		log rohtext "         |_|                                                                         "
		log rohtext "            $SCRIPTNAME $VERSION"
		log rohtext " "
		log line
		log rohtext "  $DATUM $(date +%H:%M:%S) MULTITOOL: wurde gestartet am $(date +%d.%m.%Y) um $(date +%H:%M:%S) Uhr"
		log rohtext "  $DATUM $(date +%H:%M:%S) INFO: Server Name: ${HOSTNAME}"
		log rohtext "  $DATUM $(date +%H:%M:%S) INFO: Server IP: ${AKTUELLEIP}"
		log rohtext "  $DATUM $(date +%H:%M:%S) INFO: Linux Version: $ubuntuDescription"
		log rohtext "  $DATUM $(date +%H:%M:%S) INFO: Release Nummer: $ubuntuRelease"
		log rohtext "  $DATUM $(date +%H:%M:%S) INFO: Linux Name: $ubuntuCodename"
		log rohtext "  $DATUM $(date +%H:%M:%S) INFO: Bash Version: ${BASH_VERSION}"
		log rohtext "  $DATUM $(date +%H:%M:%S) INFO: MONO THREAD Einstellung: ${MONO_THREADS_PER_CPU}"
		log rohtext "  $DATUM $(date +%H:%M:%S) INFO: Spracheinstellung: ${LANG}"
		log rohtext "  $DATUM $(date +%H:%M:%S) INFO: $(screen --version)"
		SYSTEMBOOT=$(who -b); 
		trimm $SYSTEMBOOT;
		log rohtext "  $DATUM $(date +%H:%M:%S) INFO: $trimmvar"
		log rohtext "  $DATUM $(date +%H:%M:%S) INFO: $SQLVERSION"
		lastrebootdatum
		osdate=$(date --utc --date "$1" +%F)
		if curl -s "http://opensimulator.org/viewgit/?a=shortlog&p=opensim"  |  grep -q "$osdate"; then
			echo "  $DATUM $(date +%H:%M:%S) INFO:$(tput setaf 2) Eine neue OpenSimulator Master Version ist da.$(tput sgr 0)"
		else
			echo "  $DATUM $(date +%H:%M:%S) INFO:$(tput setaf 1) Es ist keine neue OpenSimulator Master Version da.$(tput sgr 0)"
		fi
		log line
		log rohtext " "
	# fi
	return 0
}

# *Kopfzeile in die Log Datei schreiben.
schreibeinfo

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
function uncompress(){
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
function radiolist(){
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
	###php log Datei
	if [ -f "$apache2errorlog" ]; then
		textbox "$apache2errorlog"
	else
		warnbox "$apache2errorlog File not found!"
	fi
}

### ! mysql log anzeigen.
function mysqldberror() {
	###mysql log Datei
	if [ -f "$mysqlerrorlog" ]; then
		textbox "$mysqlerrorlog"
	else
		warnbox "$mysqlerrorlog File not found!"
	fi
}

### ! mariadb error anzeigen.
function mariadberror() {
	###mariaDB log Datei
	if [ -f "$mysqlmariadberor" ]; then
		textbox "$mysqlmariadberor"
	else
		warnbox "$mysqlmariadberor File not found!"
	fi
}

### ! ufw log anzeigen.
function ufwlog() {
	###mariaDB log Datei
	if [ -f "$ufwlog" ]; then
		textbox "$ufwlog"
	else
		warnbox "$ufwlog File not found!"
	fi
}

### ! auth log anzeigen.
function authlog() {
	###auth.log Datei
	if [ -f "$authlog" ]; then
		textbox "$authlog"
	else
		warnbox "$authlog File not found!"
	fi
}

### ! access log anzeigen.
function accesslog() {
	###access.log Datei
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
### !  passgen, Passwortgenerator
function passgen() {
		# Alle Aktionen ohne dialog
		STARK=$1
		PASSWD=$(tr -dc 'A-Za-z0-9!"#$%&'\''()*+,-./:;<=>?@[\]^_`{|}~' </dev/urandom | head -c "$STARK")
		echo "$PASSWD"
		unset PASSWD
		return 0
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
		ASSETVERZEICHNISSCREEN=$(echo "$ASSETDELBOXERGEBNIS" | sed -n '1p')
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

### !  landclear, Land clear - Loescht alle Parzellen auf dem Land. # Aufruf: landclear screen_name Regionsname
function landclear() {
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

### !  menulandclear, Land clear - Loescht alle Parzellen auf dem Land. # Aufruf: landclear screen_name Regionsname
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
		MLANDCLEARSCREEN=$(echo "$landclearBOXERGEBNIS" | sed -n '1p')
		REGION=$(echo "$landclearBOXERGEBNIS" | sed -n '2p')

		# Alles loeschen.
		dialogclear
		ScreenLog
	else
		# Alle Aktionen ohne dialog
		echo "Keine Menuelose Funktion" | exit
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
		lablename4="/$STARTVERZEICHNIS/texture.iar"

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
# Beispiel: /opt/osmtool.sh oscommand sim1 Welcome "alert Hallo liebe Leute dies ist eine Nachricht"
# Beispiel: /opt/osmtool.sh oscommand sim1 Welcome "alert-user John Doe Hallo John Doe"
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
	CONFIGWRITE="config save /$STARTVERZEICHNIS/$SETSIMULATOR.ini"
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
			CONFIGWRITE="config save /$STARTVERZEICHNIS/$SETSIMULATOR.ini"
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
			CONFIGWRITE="config save /$STARTVERZEICHNIS/$SETSIMULATOR.ini"
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

### !  rologdel, loescht die Log Dateien. # Aufruf: rologdel
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

### !  assetcachedel, loescht die asset cache Dateien. # Aufruf: assetcachedel Verzeichnis
# assetdel.sh sim1
# Das Verzeichnis samt neuer Daten werden beim naechsten start des opensimulator neu geschrieben.
function assetcachedel() {
	VERZEICHNIS=$1
	if [ -d "$VERZEICHNIS" ]; then
		rm -r /$STARTVERZEICHNIS/"$VERZEICHNIS"/bin/assetcache 2>/dev/null || echo "Ich habe das $VERZEICHNIS assetcache Verzeichnis nicht gefunden!"	
	else
		log error "assetcachedel: $VERZEICHNIS assetcache Verzeichnis wurde nicht gefunden"
		return 1
	fi
	log info "OpenSimulator $VERZEICHNIS assetcache Verzeichnisse geloescht"
	return 0
}

### !  autoassetcachedel, automatisches loeschen aller asset cache Dateien.
# Die Verzeichnisse samt neuer Daten werden beim naechsten start des opensimulator neu geschrieben.
function autoassetcachedel() {
	#log line
	makeverzeichnisliste
	sleep 2
	for ((i = 0; i < "$ANZAHLVERZEICHNISSLISTE"; i++)); do
		rm -r /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/assetcache 2>/dev/null | log info "OpenSimulator ${VERZEICHNISSLISTE[$i]} assetcache Verzeichnisse geloescht" || log warn "${VERZEICHNISSLISTE[$i]} assetcache Verzeichnis wurde nicht gefunden! "
		
		sleep 2
	done
	return 0
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

### !  osstart, startet Region Server. # Beispiel-Example: /opt/osmtool.sh osstart sim1
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

### !  osstop, stoppt Region Server. # Beispiel-Example: /opt/osmtool.sh osstop sim1
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

##################################################################################################

### !  osstarteintrag fuegt der osmsimlist.ini einen Region Simulator hinzu und sortiert diese.
function osstarteintrag() {
	OSEINTRAG=$1 # OpenSimulator, Verzeichnis und Screen Name
	log info "OpenSimulator $OSEINTRAG wird der Datei $SIMDATEI hinzugefuegt!"
	sed -i '1s/.*$/'"$OSEINTRAG"'\n&/g' /"$STARTVERZEICHNIS"/$SIMDATEI
	sort /"$STARTVERZEICHNIS"/$SIMDATEI -o /"$STARTVERZEICHNIS"/$SIMDATEI
}
### !  menuosstarteintrag ist die dialog Version von osstarteintrag
function menuosstarteintrag() {
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

### !  osstarteintragdel entfernt einen Region Simulator aus  der osmsimlist.ini und sortiert diese.
function osstarteintragdel() {
	OSEINTRAGDEL=$1 # OpenSimulator, Verzeichnis und Screen Name
	log info "OpenSimulator $OSEINTRAGDEL wird aus der Datei $SIMDATEI entfernt!"
	sed -i '/'"$OSEINTRAGDEL"'/d' /"$STARTVERZEICHNIS"/$SIMDATEI
	sort /"$STARTVERZEICHNIS"/$SIMDATEI -o /"$STARTVERZEICHNIS"/$SIMDATEI
}
### !  menuosstarteintragdel ist die dialog Version von osstarteintragdel
function menuosstarteintragdel() {
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



### !  osdauerstop, stoppt Region Server. # Beispiel-Example: /opt/osmtool.sh osdauerstop sim1
function osdauerstop() {
	OSDAUERSTOPSCREEN=$1 # OpenSimulator, Verzeichnis und Screen Name
	if screen -list | grep -q "$OSDAUERSTOPSCREEN"; then
		log warn "OpenSimulator $OSDAUERSTOPSCREEN Beenden und aus der Startliste loeschen!"
		osstarteintrag "$OSDAUERSTOPSCREEN"

		screen -S "$OSDAUERSTOPSCREEN" -p 0 -X eval "stuff 'shutdown'^M"
		sleep 10
		return 0
	else
		log error "OpenSimulator $OSDAUERSTOPSCREEN nicht vorhanden"
		osstarteintrag "$OSDAUERSTOPSCREEN"
		return 1
	fi

	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then hauptmenu; fi
}

### !  menuosdauerstop() ist die dialog Version von osdauerstop()
function menuosdauerstop() {
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
			sleep 2
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

### !  osdauerstart, startet Region Server. # Beispiel-Example: /opt/osmtool.sh osdauerstart sim1
function osdauerstart() {
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

### !  menuosdauerstart() ist die dialog Version von osdauerstart()
function menuosdauerstart() {
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
					sleep 2
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
					sleep 2
				) #|
					#$DIALOG --title "$IOSDAUERSTARTSCREEN" --gauge "Start" 8 30
				#$dialogclear
				#$DIALOG --msgbox "$IOSDAUERSTARTSCREEN gestartet!" 5 20
				#$dialogclear
				ScreenLog
				dateimenu
			fi
		else
			echo "OpenSimulator $IOSDAUERSTARTSCREEN nicht vorhanden"
			dateimenu
		fi
	else
		# es laeuft - work
		log error "OpenSimulator $IOSDAUERSTARTSCREEN laeuft bereits"
		dateimenu
	fi

}

##################################################################################################

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
	# Wenn keine Einstellung vorhanden ist dann VS2019 mit mono 4.6
	if [[ "$netversion" = "" ]]; then
		netversion="1946"
	fi

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
		log info "Script Assets werden vom GIT geholt"
		git clone https://github.com/BigManzai/opensim-ossl-example-scripts /$STARTVERZEICHNIS/opensim-ossl-example-scripts-main
	else
		log error "Script Assets sind nicht vorhanden"
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
	# else
	# 	log info "COPY: OpenSimSearch ist nicht vorhanden"
	fi
	return 0
}

### !  scriptcopy, lsl ossl scripte kopieren.
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

### !  moneycopy, Money Dateien kopieren.
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

### ! configurecopy
function configurecopy() {
	if [[ $CONFIGURECOPY = "yes" ]]; then
		##/opt/opensim-configuration-addon-modul/Configuration
		if [ -d /$STARTVERZEICHNIS/opensim-configuration-addon-modul ]; then
			log info "CONFIGURECOPY: Configure Kopiervorgang gestartet"
			cp -r /$STARTVERZEICHNIS/opensim-configuration-addon-modul/Configuration /$STARTVERZEICHNIS/opensim/addon-modules
			#mv /$STARTVERZEICHNIS/opensim/addon-modules/opensim-configuration-addon-modul /$STARTVERZEICHNIS/opensim/addon-modules/Configuration

			log line
		else
			# Entpacken und kopieren
			log info "CONFIGURECOPY: Configure entpacken"
			unzip "$CONFIGUREZIP"
			log info "CONFIGURECOPY: Configure Kopiervorgang gestartet"
			cp -r /$STARTVERZEICHNIS/opensim-configuration-addon-modul/Configuration /$STARTVERZEICHNIS/opensim/addon-modules
			#mv /$STARTVERZEICHNIS/opensim/addon-modules/opensim-configuration-addon-modul /$STARTVERZEICHNIS/opensim/addon-modules/Configuration
			log line
		fi
	# else
	# 	log info "CONFIGURE: Configure wird nicht kopiert."
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
	# else
	# 	log warn "PYTHONCOPY: Python wird nicht kopiert."
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
	# else
	# 	log info "OpenSimSearch: OpenSimSearch wird nicht kopiert."
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
	# else
	# 	log warn "OpenSimMutelist: OpenSimMutelist wird nicht kopiert."
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
	# else
	# 	log warn "CHRISOSCOPY: Chris.OS.Additions werden nicht kopiert."
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

### !  osprebuild, Prebuild einstellen # Aufruf Beispiel: osmtool.sh prebuild 1330.
# Ergebnis ist eine Einstellung fuer Release mit dem Namn OpenSim 0.9.2.1330
# sed -i schreibt sofort - s/Suchwort/Ersatzwort/g - /Verzeichnis/Dateiname.Endung
function osprebuild() {
	NUMMER=$1
	log info "OpenSim Version umbenennen und Release auf $NUMMER einstellen"

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

### !  osstruktur, legt die Verzeichnisstruktur fuer OpenSim an. # Aufruf: osmtool.sh osstruktur ersteSIM letzteSIM
# Beispiel: ./osmtool.sh osstruktur 1 10 - erstellt ein Grid Verzeichnis fuer 10 Simulatoren inklusive der $SIMDATEI.
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

### !  regionliste, Die RegionListe ermitteln und mit dem Verzeichnisnamen in die osmregionlist.ini schreiben.
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
	sleep 2
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
	LOESCHEN=$(sed s/'\/'$STARTVERZEICHNIS'\/'//g /$STARTVERZEICHNIS/osmregionlist.ini)              # /opt/ entfernen.
	echo "$LOESCHEN" >/$STARTVERZEICHNIS/osmregionlist.ini                           # Aenderung /opt/ speichern.
	LOESCHEN=$(sed s/'\/bin\/Regions\/'/' "'/g /$STARTVERZEICHNIS/osmregionlist.ini) # /bin/Regions/ entfernen.
	echo "$LOESCHEN" >/$STARTVERZEICHNIS/osmregionlist.ini                           # Aenderung /bin/Regions/ speichern.
	LOESCHEN=$(sed s/'.ini'/'"'/g /$STARTVERZEICHNIS/osmregionlist.ini)              # Endung .ini entfernen.
	echo "$LOESCHEN" >/$STARTVERZEICHNIS/osmregionlist.ini                           # Aenderung .ini entfernen speichern.
	# Schauen ob da noch Regions.ini bei sind also Regionen mit dem Namen Regions, diese Zeilen loeschen.
	LOESCHEN=$(sed '/Regions/d' /$STARTVERZEICHNIS/osmregionlist.ini) # Alle Zeilen mit dem Eintrag Regions entfernen	.
	echo "$LOESCHEN" >/$STARTVERZEICHNIS/osmregionlist.ini            # Aenderung .ini entfernen speichern.
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
	BACKUPVERZEICHNISSCREENNAME=$1
	REGIONSNAME=$2
	DATEINAME=${REGIONSNAME//\"/}
	NSDATEINAME=${DATEINAME// /}

	log line
	log info "Backup der Region $NSDATEINAME"
	cd /$STARTVERZEICHNIS/"$BACKUPVERZEICHNISSCREENNAME"/bin || return 1
	log info "Ich kann nicht pruefen ob die Region im OpenSimulator vorhanden ist."
	log info "Sollte sie nicht vorhanden sein wird root also alle Regionen gespeichert"
	screen -S "$BACKUPVERZEICHNISSCREENNAME" -p 0 -X eval "stuff 'change region ${REGIONSNAME//\"/}'^M"
	screen -S "$BACKUPVERZEICHNISSCREENNAME" -p 0 -X eval "stuff 'save oar /$STARTVERZEICHNIS/backup/'$DATUM'-$NSDATEINAME.oar'^M"
	screen -S "$BACKUPVERZEICHNISSCREENNAME" -p 0 -X eval "stuff 'terrain save /$STARTVERZEICHNIS/backup/'$DATUM'-$NSDATEINAME.png'^M"
	screen -S "$BACKUPVERZEICHNISSCREENNAME" -p 0 -X eval "stuff 'terrain save /$STARTVERZEICHNIS/backup/'$DATUM'-$NSDATEINAME.raw'^M"
	log info "Region $DATUM-$NSDATEINAME RAW und PNG Terrain werden gespeichert"
	
	sleep 10
	if [ ! -f /$STARTVERZEICHNIS/"$BACKUPVERZEICHNISSCREENNAME"/bin/Regions/"$NSDATEINAME".ini ]; then
		cp -r /$STARTVERZEICHNIS/"$BACKUPVERZEICHNISSCREENNAME"/bin/Regions/Regions.ini /$STARTVERZEICHNIS/backup/"$DATUM"-"$NSDATEINAME".ini
		log info "Die Regions $DATUM-$NSDATEINAME.ini wird gespeichert"
	fi
	if [ ! -f /$STARTVERZEICHNIS/"$BACKUPVERZEICHNISSCREENNAME"/bin/Regions/"${REGIONSNAME//\"/}".ini ]; then
		cp -r /$STARTVERZEICHNIS/"$BACKUPVERZEICHNISSCREENNAME"/bin/Regions/Regions.ini /$STARTVERZEICHNIS/backup/"$DATUM"-"$NSDATEINAME".ini
		log info "Die Regions $DATUM-$NSDATEINAME.ini wird gespeichert"
	fi
	if [ ! -f /$STARTVERZEICHNIS/"$BACKUPVERZEICHNISSCREENNAME"/bin/Regions/Regions.ini ]; then
		cp -r /$STARTVERZEICHNIS/"$BACKUPVERZEICHNISSCREENNAME"/bin/Regions/"$NSDATEINAME".ini /$STARTVERZEICHNIS/backup/"$DATUM"-"$NSDATEINAME".ini
		log info "Die Regions $NSDATEINAME.ini wird gespeichert"
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
		MBACKUPVERZEICHNISSCREENNAME=$(echo "$regionbackupBOXERGEBNIS" | sed -n '1p')
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
	sleep 2$
	DATEINAME=${REGIONSNAME//\"/}
	NSDATEINAME=${DATEINAME// /}

	log line
	log info "Backup der Region $NSDATEINAME"
	cd /$STARTVERZEICHNIS/"$MBACKUPVERZEICHNISSCREENNAME"/bin || return 1
	log info "Ich kann nicht pruefen ob die Region im OpenSimulator vorhanden ist."
	log info "Sollte sie nicht vorhanden sein wird root also alle Regionen gespeichert."
	screen -S "$MBACKUPVERZEICHNISSCREENNAME" -p 0 -X eval "stuff 'change region ${REGIONSNAME//\"/}'^M"
	screen -S "$MBACKUPVERZEICHNISSCREENNAME" -p 0 -X eval "stuff 'save oar /$STARTVERZEICHNIS/backup/'$DATUM'-$NSDATEINAME.oar'^M"
	screen -S "$MBACKUPVERZEICHNISSCREENNAME" -p 0 -X eval "stuff 'terrain save /$STARTVERZEICHNIS/backup/'$DATUM'-$NSDATEINAME.png'^M"
	screen -S "$MBACKUPVERZEICHNISSCREENNAME" -p 0 -X eval "stuff 'terrain save /$STARTVERZEICHNIS/backup/'$DATUM'-$NSDATEINAME.raw'^M"
	log info "Region $DATUM-$NSDATEINAME RAW und PNG Terrain werden gespeichert"
	
	sleep 10
	if [ ! -f /$STARTVERZEICHNIS/"$VERZEICHNISSCREENNAME"/bin/Regions/"$NSDATEINAME".ini ]; then
		cp -r /$STARTVERZEICHNIS/"$VERZEICHNISSCREENNAME"/bin/Regions/Regions.ini /$STARTVERZEICHNIS/backup/"$DATUM"-"$NSDATEINAME".ini
		log info "Die Regions $DATUM-$NSDATEINAME.ini wird gespeichert"
	fi
	if [ ! -f /$STARTVERZEICHNIS/"$VERZEICHNISSCREENNAME"/bin/Regions/"${REGIONSNAME//\"/}".ini ]; then
		cp -r /$STARTVERZEICHNIS/"$VERZEICHNISSCREENNAME"/bin/Regions/Regions.ini /$STARTVERZEICHNIS/backup/"$DATUM"-"$NSDATEINAME".ini
		log info "Die Regions $DATUM-$NSDATEINAME.ini wird gespeichert"
	fi
	if [ ! -f /$STARTVERZEICHNIS/"$VERZEICHNISSCREENNAME"/bin/Regions/Regions.ini ]; then
		cp -r /$STARTVERZEICHNIS/"$VERZEICHNISSCREENNAME"/bin/Regions/"$NSDATEINAME".ini /$STARTVERZEICHNIS/backup/"$DATUM"-"$NSDATEINAME".ini
		log info "Die Regions $NSDATEINAME.ini wird gespeichert"
	fi
	return 0
}

### !  regionrestore, hochladen einer Region.
# regionrestore Screenname "Der Regionsname"
# Ich kann nicht pruefen ob die Region im OpenSimulator vorhanden ist.
# Sollte sie nicht vorhanden sein wird root (Alle) oder die letzte ausgewaehlte Region wiederhergestellt. Dies zerstoert eventuell vorhandene Regionen.
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
		MRESTOREVERZEICHNISSCREENNAME=$(echo "$regionrestoreBOXERGEBNIS" | sed -n '1p')
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
	cd /$STARTVERZEICHNIS/"$MRESTOREVERZEICHNISSCREENNAME"/bin || return 1
	log info "Ich kann nicht pruefen ob die Region im OpenSimulator vorhanden ist."
	log info "Sollte sie nicht vorhanden sein wird root also alle Regionen wiederhergestellt."
	screen -S "$MRESTOREVERZEICHNISSCREENNAME" -p 0 -X eval "stuff 'change region ${REGIONSNAME//\"/}'^M"
	screen -S "$MRESTOREVERZEICHNISSCREENNAME" -p 0 -X eval "stuff 'load oar /$STARTVERZEICHNIS/backup/'$DATUM'-$NSDATEINAME.oar'^M"

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

			if [ "$REGIONSANZEIGE" = "yes" ]; then
				# Zeigt die Regionsnamen aus den Regions.ini an
				STARTREGIONSAUSGABE=$(awk -F "[" '/\[/ {print $1 $2 $3}' /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/Regions/*.ini | sed s/'\]'//g);
				log info "${VERZEICHNISSLISTE[$i]} hat folgende Regionen:";
				#sed 's/^\(.\)/     \1/' "$STARTREGIONSAUSGABE"
				echo "$STARTREGIONSAUSGABE";
				#log info "$STARTREGIONSAUSGABE";
				#printf '%s' "$STARTREGIONSAUSGABE";
			fi

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

			screen -S "${VERZEICHNISSLISTE[$i]}" -p 0 -X eval "stuff 'shutdown'^M" | log info "${VERZEICHNISSLISTE[$i]} wurde angewiesen zu stoppen." #| dialog --gauge "Alle Simulatoren werden gestoppt!" 6 64 $BALKEN2
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
	sleep 1
	for ((i = 0; i < "$ANZAHLVERZEICHNISSLISTE"; i++)); do
		log info "OpenSimulator log Datei ${VERZEICHNISSLISTE[$i]} geloescht"
		rm /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/*.log 2>/dev/null || log warn "Die Log Datei ${VERZEICHNISSLISTE[$i]} ist nicht vorhanden!"		
		sleep 1
	done

	rologdel

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

	rologdel
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

### ! gridcachedelete, loescht alle Cache Dateien die sich im laufe der Zeit angesammelt haben.
# GRIDCACHECLEAR="yes"; ASSETCACHECLEAR="yes"; MAPTILESCLEAR="yes"; SCRIPTCLEAR="yes"; RMAPTILESCLEAR="yes"; RBAKESCLEAR="yes";
function gridcachedelete() {
	log line
	log warn "Lösche Cache Dateien aus dem gesamten Grid!"
	makeverzeichnisliste
	sleep 2
	# Simualtoren
	for ((i = 0; i < "$ANZAHLVERZEICHNISSLISTE"; i++)); do	
	if [ "$ASSETCACHECLEAR" = "yes" ]; then  rm -r /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/assetcache || echo " "; fi
	if [ "$MAPTILESCLEAR" = "yes" ]; then  rm -r /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/maptiles || echo " "; fi
	if [ "$SCRIPTCLEAR" = "yes" ]; then  rm -r /$STARTVERZEICHNIS/"${VERZEICHNISSLISTE[$i]}"/bin/ScriptEngines || echo " "; fi
	done
	# Robust
	if [ "$RMAPTILESCLEAR" = "yes" ]; then  rm -r /$STARTVERZEICHNIS/robust/bin/maptiles || echo " "; fi
	if [ "$RBAKESCLEAR" = "yes" ]; then  rm -r /$STARTVERZEICHNIS/robust/bin/bakes || echo " "; fi
}

### !  autoallclean, loescht Log, dll, so, exe, aot Dateien fuer einen saubere neue installation, mit Robust.
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
	log info "die nicht innerhalb von $AUTOSTOPZEIT Sekunden"
	log info "nach Robust heruntergefahren werden konnten,"
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
	if [ "$LOGDELETE" = "yes" ]; then autologdel; fi
	#if [ "$DELREGIONS" = "yes" ]; then deleteregionfromdatabase; fi
	gridstart
	autosimstart
	screenlistrestart
	log info "Auto Restart abgeschlossen."
	return 0
}
### ! menuautorestart
function menuautorestart() {
	# menuautostop
	# if [ "$LOGDELETE" = "yes" ]; then autologdel; fi
	# menugridstart
	# menuautosimstart
	# menuinfo

	autostop
	if [ "$LOGDELETE" = "yes" ]; then autologdel; fi
	#if [ "$DELREGIONS" = "yes" ]; then deleteregionfromdatabase; fi
	gridstart
	autosimstart
	screenlistrestart
	# log info "Auto Restart abgeschlossen."
	menuinfo
}

### ! serverinstall, Ubuntu Server zum Betrieb von OpenSim vorbereiten.
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

	echo "deb http://archive.canonical.com/ubuntu/ jammy partner"
	echo "deb-src http://archive.canonical.com/ubuntu/ jammy partner"
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
	iinstall crudini
	# Sicherheit 2023
	iinstall iptables
	iinstall fail2ban	
	# fail2ban - In der Datei jail.local werden alle von der jail.conf abweichenden Einträge eingestellt.
	# maxfailures = 3 
	# bantime = 900 
	# findtime = 600
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
	iinstall2 crudini
	iinstall2 iptables
	iinstall2 fail2ban	
}

### !  iptablesset
function iptablesset() {
	ipsperradresse=$1
	# Eine IP-Adresse für eingehende Datenpakete sperren
	iptables -A INPUT -s $ipsperradresse -j DROP

	# Eine IP-Adresse für ausgehende Datenpakete sperren
	iptables -A OUTPUT -s $ipsperradresse -j DROP

	# Alle IP-Adressen in den IPTABLES mitsamt Zeilennummern anzeigen, die momentan gesperrt sind
	iptables -L INPUT -n --line-numbers
}
### !  fail2banset
function fail2banset() {
	echo ""
	# /etc/fail2ban/jail.local
	# fail2ban - In der Datei jail.local werden alle von der jail.conf abweichenden Eintraege eingestellt.
	# maxfailures = 3 
	# bantime = 900 
	# findtime = 600

	echo "maxfailures = 3 
bantime = 900 
findtime = 600" >/etc/fail2ban/jail.local
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
# /opt/osmtool.sh osbuilding 1187
function osbuilding() {
	## dialog Aktionen
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
	osprebuild "$VERSIONSNUMMER"

	log line

	log info "Compilieren des neuen OpenSimulator"
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

### !  deleteregionfromdatabase.
# function deleteregionfromdatabase() {
# 	username=$1
# 	password=$2
# 	databasename=$3

# 	log text "Die - regions - Tabelle aus der Grid Datenbank leeren."
# 	log text "Dies ist erforderlich wenn eine Region in der Datenbank haengen bleibt."
# 	log text "Diese Aktion muss nach dem herunterfahren von Robust gestartet werden."
# 	log text "Anschliessend muss Robust neu gestartet werden."
	
# 	mysqlrest "$username" "$password" "$databasename" "TRUNCATE TABLE regions"
# 	log rohtext "$result_mysqlrest"

# 	return 0
# }

# Neu 19.11.2022

### !db_friends OK
function db_friends() {
	username=$1
	password=$2
	databasename=$3
	useruuid=$4

	echo "Listet alle internen Freunde auf, keine hg freunde:"
	mysqlrest "$username" "$password" "$databasename" "SELECT Friends.PrincipalID, CONCAT(UserAccounts.FirstName, ' ', UserAccounts.LastName) AS 'Friend' FROM Friends,UserAccounts WHERE Friends.Friend = '$useruuid' AND UserAccounts.PrincipalID = Friends.PrincipalID UNION SELECT Friends.Friend, CONCAT(UserAccounts.FirstName, ' ', UserAccounts.LastName) AS 'Friend'  FROM Friends, UserAccounts WHERE Friends.PrincipalID ='$useruuid' AND UserAccounts.PrincipalID = Friends.Friend"
	echo "$result_mysqlrest"

	return 0
}


### !db_online OK
function db_online() {
	username=$1
	password=$2
	databasename=$3

	echo "Listet Online User auf:"
	mysqlrest "$username" "$password" "$databasename" "SELECT concat(FirstName, ' ', LastName) AS 'Online Users' FROM UserAccounts INNER JOIN GridUser ON UserAccounts.PrincipalID = GridUser.UserID WHERE GridUser.Online = 'True'"
	echo "$result_mysqlrest"

	return 0
}

### !db_region OK
function db_region() {
	username=$1
	password=$2
	databasename=$3

	echo "Listet die Regionen in Ihrer Datenbank auf:"
	mysqlrest "$username" "$password" "$databasename" "SELECT regionName as 'Regions' FROM regions"
	echo "$result_mysqlrest"

	return 0
}

### !Gridliste der Benutzer die schon einmal im eigenen Grid waren
# Aufruf: /opt/osmtool.sh db_gridlist databaseusername databasepassword databasename
function db_gridlist() {
	username=$1
	password=$2
	databasename=$3

	echo "Listet die Grids in Ihrer Datenbank auf:"
	# SELECT * FROM 'GridUser' ORDER BY 'GridUser'.'UserID' ASC 
	#mysqlrest "$username" "$password" "$databasename" "SELECT regionName as 'Regions' FROM regions"
	mysqlrest "$username" "$password" "$databasename" "SELECT * FROM GridUser ORDER BY GridUser.UserID"

	mygridliste=$( echo "$result_mysqlrest" | sed 's/.*;http:\/\/ *//;T;s/ *\/;.*//' )
	echo "$mygridliste" >/$STARTVERZEICHNIS/osmgridlist.txt
	echo "$mygridliste"
	return 0
}

### !db_inv_search OK
function db_inv_search() {
	username=$1
	password=$2
	databasename=$3
    invname=$4

	echo "Inventareinträge mit einem bestimmten Namen auflisten:"
	mysqlrest "$username" "$password" "$databasename" "SELECT concat(inventoryName, ' - ',  replace(inventoryID, '-', '')) AS 'Inventory', concat(assets.name, ' - ', hex(assets.id)) AS 'Asset' FROM inventoryitems LEFT JOIN assets ON replace(assetID, '-', '')=hex(assets.id) WHERE inventoryName = '$invname'"
	echo "$result_mysqlrest"

	return 0
}

### !db_user_anzahl OK
function db_user_anzahl() {
	username=$1
	password=$2
	databasename=$3

	echo "Zaehlt die Gesamtzahl der Benutzer:"
	mysqlrest "$username" "$password" "$databasename" "SELECT count(PrincipalID) AS 'Users' FROM UserAccounts"
	echo "$result_mysqlrest"

	return 0
}

### !db_user_online
function db_user_online() {
	username=$1
	password=$2
	databasename=$3

	echo "Users Online:"
	mysqlrest "$username" "$password" "$databasename" "SELECT count(UserID) AS 'Online' FROM GridUser WHERE Online = 'True'"
	echo "$result_mysqlrest"

	return 0
}

### !db_region_parzelle
function db_region_parzelle() {
	username=$1
	password=$2
	databasename=$3

	echo "Zaehlt die Regionen mit Parzellen:"
	mysqlrest "$username" "$password" "$databasename" "SELECT count(DISTINCT regionUUID) FROM parcels"
	echo "$result_mysqlrest"

	return 0
}

### !db_region_parzelle_pakete
function db_region_parzelle_pakete() {
	username=$1
	password=$2
	databasename=$3

	echo "Zaehlt die Gesamtzahl der Pakete:"
	mysqlrest "$username" "$password" "$databasename" "SELECT count(parcelUUID) AS 'Parcels' FROM parcels"
	echo "$result_mysqlrest"

	return 0
}

### !db_region_anzahl_regionsnamen OK
function db_region_anzahl_regionsnamen() {
	username=$1
	password=$2
	databasename=$3

	echo "Zaehlt eindeutige Regionsnamen:"
	mysqlrest "$username" "$password" "$databasename" "SELECT count(DISTINCT regionName) AS 'Regions' FROM regions"
	echo "$result_mysqlrest"

	return 0
}

### !db_region_anzahl_regionsid
function db_region_anzahl_regionsid() {
	username=$1
	password=$2
	databasename=$3

	echo "Zaehlt RegionIDs:"
	mysqlrest "$username" "$password" "$databasename" "SELECT count(UUID) AS 'Regions' FROM regions"
	echo "$result_mysqlrest"

	return 0
}

### !db_inventar_no_assets stichprobe alle assets sind vorhanden
function db_inventar_no_assets() {
	username=$1
	password=$2
	databasename=$3

	echo "Listet alle Inventareintraege auf, die auf nicht vorhandene Assets verweisen:"
	mysqlrest "$username" "$password" "$databasename" "SELECT inventoryname, inventoryID, assetID FROM inventoryitems WHERE replace(assetID, '-', '') NOT IN (SELECT hex(id) FROM assets)"
	echo "$result_mysqlrest"

	return 0
}

# Neu 19.11.2022 Ende

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
# /opt/osmtool.sh db_backuptabellen username password databasename
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

# alles speichern ausser assets
# mysqldump -u"$username" -p"$password" "$databasename" –-ignore-table="assets" | zip >/$STARTVERZEICHNIS/backup/"$databasename".sql.zip
# nur assets speichern
# mysqldump -u"$username" -p"$password" "$databasename" assets | zip >/$STARTVERZEICHNIS/backup/"$databasename"/"$databasename"assets.sql.zip

# mit hexblob alles speichern ausser assets
# mysqldump -u"$username" -p"$password" "$databasename" --hex-blob –-ignore-table="assets" | zip >/$STARTVERZEICHNIS/backup/"$databasename"/"$tabellenname".sql.zip
# mit hexblob nur assets speichern
# mysqldump -u"$username" -p"$password" "$databasename" --hex-blob assets | zip >/$STARTVERZEICHNIS/backup/"$databasename"/"$databasename"assets.sql.zip

# CallingCard="2";
# mysqldump -u"$username" -p"$password" "$databasename" --tables assets --where="assetType = '2'" > CallingCard.sql

function db_backuptabellentypen2() {
	echo "test"
}

### ! Backup, Asset Datenbank Tabelle geteilt in Typen speichern.
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

	# Asset Typen aus Datenbank holen.
	mysqlrest "$username" "$password" "$databasename" "SELECT $fromtypes FROM $fromtable WHERE $fromtypes"
	# Nächste Zeile löscht doppelte einträge und speichert dies unter $fromtypes.txt
	log info "$result_mysqlrest" | sort | uniq >/$STARTVERZEICHNIS/backup/"$databasename"/$fromtypes.txt

	tabellenname=()
	while IFS= read -r tabellenname; do
		sleep 2
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

function db_restoretabellentypen() {
	echo "Testing"
	# Tabellenstruktur "Tabellenname" wiederherstellen
	# csv Tabellendaten wiederherstellen
}

### ! Backup Test, eine Datenbanken Tabellenweise wiederherstellen.
## function db_restorebackuptabellen DB_Benutzername DB_Passwort AlterDatenbankname NeuerDatenbankname
## Die Tabellenweise gesicherte Datenbank in einer neuen Datenbank zusammensetzen.
# /opt/osmtool.sh db_restorebackuptabellen username password databasename newdatabasename
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

##! Andere Art Datenbanken und Benutzer anzulegen
# createdatabase DBNAME DBUSER DBPASSWD
function createdatabase(){
    # Übergabeparameter
    DBNAME=$1
    DBUSER=$2
    DBPASSWD=$3

    # Abbruch bei fehlender Parameterangabe.
    if [ "$DBNAME" = "" ]; then echo "Datenbankname fehlt"; exit 1; fi
    if [ "$DBUSER" = "" ]; then echo "Benutzername fehlt"; exit 1; fi
    if [ "$DBPASSWD" = "" ]; then echo "Datenbankpasswort fehlt"; exit 1; fi

    # Ausführung
    mysql -u "$DBUSER" -pDBPASSWD <<EOF
CREATE DATABASE ${DBNAME};
USE ${DBNAME};
EOF
    # Dadurch, dass der MySQL-Client im nicht-interaktiven Modus ausgeführt wird, 
    # kannst du die quit-Anweisung am Ende weglassen.
    return 0
}

# createdbuser ROOTUSER ROOTPASSWD NEWDBUSER NEWDBPASSWD
# ROOTPASSWD ist optional.
function createdbuser(){
    # Übergabeparameter
    ROOTUSER=$1
    ROOTPASSWD=$2
    NEWDBUSER=$3
    NEWDBPASSWD=$4


    # Abbruch bei fehlender Parameterangabe.
    if [ "$ROOTUSER" = "" ]; then echo "Root Datenbankbenutzername fehlt"; exit 1; fi
    if [ "$ROOTPASSWD" = "" ]; then echo "Root Datenbankpasswort fehlt"; exit 1; fi
    if [ "$NEWDBUSER" = "" ]; then echo "Neuer Benutzername fehlt"; exit 1; fi
    if [ "$NEWDBPASSWD" = "" ]; then echo "Neues Datenbankpasswort fehlt"; exit 1; fi
    

    # Ausführung
    mysql -u "$ROOTUSER" -pROOTPASSWD <<EOF
CREATE USER "${NEWDBUSER}"@"localhost" IDENTIFIED BY "${NEWDBPASSWD}";
GRANT ALL ON *.* to "${NEWDBUSER}"@"localhost";
EOF
    # Dadurch, dass der MySQL-Client im nicht-interaktiven Modus ausgeführt wird, 
    # kannst du die quit-Anweisung am Ende weglassen.
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
# osmtool.sh setpartner Datenbankbenutzer Datenbankpasswort Robustdatenbank "AvatarUUID" "PartnerUUID"
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
# osmtool.sh setpartner Datenbankbenutzer Datenbankpasswort Robustdatenbank "AvatarUUID" "PartnerUUID"
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
# osmtool.sh setpartner Datenbankbenutzer Datenbankpasswort Robustdatenbank "AvatarUUID" "PartnerUUID"
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
## /opt/osmtool.sh db_email_setincorrectuseroff "GRIDdatabaseusername" "GRIDdatabasepassword" "GRIDdatabasename"
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
## /opt/osmtool.sh db_email_setincorrectuseroff "GRIDdatabaseusername" "GRIDdatabasepassword" "GRIDdatabasename"
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
## /opt/osmtool.sh db_setuserofline "GRIDdatabaseusername" "GRIDdatabasepassword" "GRIDdatabasename" "firstname" "lastname"
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
## /opt/osmtool.sh db_setuserofline_dialog "GRIDdatabaseusername" "GRIDdatabasepassword" "GRIDdatabasename" "firstname" "lastname"
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
## /opt/osmtool.sh db_setuseronline "GRIDdatabaseusername" "GRIDdatabasepassword" "GRIDdatabasename" "firstname" "lastname"
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
## /opt/osmtool.sh db_setuseronline "GRIDdatabaseusername" "GRIDdatabasepassword" "GRIDdatabasename" "firstname" "lastname"
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
# ./osmtool.sh conf_write Einstellung NeuerParameter Verzeichnis Dateiname
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
# ./osmtool.sh conf_read Einstellungsbereich Verzeichnis Dateiname
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
# ./osmtool.sh conf_delete Einstellungsbereich Verzeichnis Dateiname
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

###############################    Konfigurationen ########################

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


### ! constconfig
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

### ! Region Konfigurationen schreiben
# regionconfig REGIONSNAME STARTLOCATION SIZE INTERNALPORT REGIONSINI
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

### ! FlotsamCache Konfigurationen schreiben
# FlotsamCache.ini - flotsamconfig FLOTSAMCACHEINI
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

### ! osslEnableconfig Konfigurationen schreiben
# osslEnable.ini.example
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

# MoneyServer.ini
### ! moneyconfig DATABASE USERNAME PASSWORD MONEYINI
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

### !  osstruktur, legt die Verzeichnisstruktur fuer OpenSim an. # Aufruf: osmtool.sh osstruktur ersteSIM letzteSIM
# Beispiel: ./osmtool.sh osstruktur 1 10 - erstellt ein Grid Verzeichnis fuer 10 Simulatoren inklusive der $SIMDATEI.
function osconfigstruktur() {
    # Ist die /"$STARTVERZEICHNIS"/$SIMDATEI vorhanden dann zuerst löschen
    if [ ! -f "/$STARTVERZEICHNIS/$SIMDATEI" ]; then
        #rm /"$STARTVERZEICHNIS"/$SIMDATEI
        echo "$SIMDATEI Datei ist noch nicht vorhanden"
    else
        echo "Lösche vorhandene $SIMDATEI"
        rm /"$STARTVERZEICHNIS"/$SIMDATEI
    fi

    # Ist die Datei CONFIGPFAD="OpenSimConfig"
	if [ ! -f "/$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/" ]; then
		echo "Lege robust an im Verzeichnis $ROBUSTVERZEICHNIS an"
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
		echo "Ich lege gerade sim$i an!"
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
		echo "Schreibe sim$i in $SIMDATEI"
        #echo "Schreibe sim$i in $SIMDATEI, legen sie bitte Datenbank $MYSQLDATABASE an."
		# xargs sollte leerzeichen entfernen.
		printf 'sim'"$i"'\t%s\n' | xargs >>/"$STARTVERZEICHNIS"/$SIMDATEI
        MYSQLDATABASE=$ZWISCHENSPEICHERMSDB # Zuruecksetzen sonst wird falsch addiert.
        SIMULATORPORT=$ZWISCHENSPEICHERSP # Zuruecksetzen sonst wird falsch addiert.
        LOCALX=5000; LOCALY=5000; # Zuruecksetzen sonst wird falsch addiert.
        # Restliche Dateien kopieren
        
	done
    echo "##################################################################"
	return 0
}

function configabfrage(){
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

	# Ausgabe Kopfzeilen
	echo "$SCRIPTNAME Version $VERSION"
	echo "Ihre aktuelle externe IP ist $AKTUELLEIP"
	echo " "
	echo "##################################################################"
	echo "########### ABBRUCH MIT DER TASTENKOMBINATION ####################"
	echo "####################  STRG + C  ##################################"
	echo "##################################################################"
	echo "##     Die Werte in den [Klammern] sind vorschläge              ##"
	echo "##     und können mit Enter übernommen werden.                  ##"
	echo "##################################################################"
	echo " "
	echo "Wieviele Konfigurationen darf ich ihnen schreiben? [5]"
	read -r CONFIGANZAHL
	if [ "$CONFIGANZAHL" = "" ]; then CONFIGANZAHL="5"; fi
	echo "Ihre Anzahl ist $CONFIGANZAHL"
	echo "##################################################################"

	echo "Wohin darf ich diese schreiben? [$STARTVERZEICHNIS]"
	read -r VERZEICHNISABFRAGE
	if [ "$VERZEICHNISABFRAGE" = "" ]; then echo "Ihr Konfigurationsordner ist $STARTVERZEICHNIS"; else STARTVERZEICHNIS="$VERZEICHNISABFRAGE";fi
	echo "##################################################################"

	echo "Ihre Server Adresse? [$AKTUELLEIP]"
	read -r BASEHOSTNAME
	if [ "$BASEHOSTNAME" = "" ]; then BASEHOSTNAME="$AKTUELLEIP"; fi
	echo "Ihre Server Adresse ist $BASEHOSTNAME"
	echo "##################################################################"

	echo "Ihr SimulatorPort startet bei: [9010]"
	read -r SIMULATORPORT
	if [ "$SIMULATORPORT" = "" ]; then SIMULATORPORT="9010"; fi
	echo "Ihr SimulatorPort startet bei: $SIMULATORPORT"
	echo "##################################################################"

	echo "Bitte geben sie den mySQL/mariaDB Benutzernamen ihrer Datenbank an [opensim]:"
	read -r MYSQLUSER
	if [ "$MYSQLUSER" = "" ]; then MYSQLUSER="opensim"; fi
	echo "Ihr Datenbank Benutzername lautet: $MYSQLUSER"
	echo "##################################################################"

	echo "Bitte geben sie das Passwort ihrer mySQL/mariaDB Datenbank an [opensim]:"
	read -r MYSQLPASSWORD
	if [ "$MYSQLPASSWORD" = "" ]; then MYSQLPASSWORD="opensim"; fi
	echo "Ihr Passwort ihrer Datenbank lautet: ********"
	echo "##################################################################"

	echo "Datenbanken jetzt direkt anlegen [nein]:"
	read -r CREATEDATABASE
	if [ "$CREATEDATABASE" = "" ]; then CREATEDATABASE="nein"; fi

	if [ "$CREATEDATABASE" = "nein" ]; then
		echo "Bitte geben sie den Datenbanknamen an [opensim]:"
		read -r MYSQLDATABASE
		if [ "$MYSQLDATABASE" = "" ]; then MYSQLDATABASE="opensim"; fi
		echo "Ihr Datenbanknamen lautet: $MYSQLDATABASE"
		echo "##################################################################"
	fi

	if [ "$CREATEDATABASE" = "ja" ]; then
		### OpenSim Datenbanken
		echo "Name der Datenbanken [sim]:"
		read -r CREATEDATABASENAME	
		if [ "$CREATEDATABASENAME" = "" ]; then CREATEDATABASENAME="sim"; fi

		### Robust Datenbank
		echo "Robust Datenbank anlegen [nein]:"
		read -r CREATEROBUSTDATABASE
		if [ "$CREATEROBUSTDATABASE" = "" ]; then CREATEROBUSTDATABASE="nein"; fi
		
		if [ "$CREATEROBUSTDATABASE" = "ja" ]; then
			echo "Name der Robust Datenbank [robust]:"
			read -r CREATEROBUSTDATABASENAME
			if [ "$CREATEROBUSTDATABASENAME" = "" ]; then CREATEROBUSTDATABASENAME="robust"; fi
			createdatabase $CREATEROBUSTDATABASENAME $MYSQLUSER $MYSQLPASSWORD
		fi
	fi
	echo "##################################################################"

	echo "Bitte geben sie den Namen ihrer Startregion an [Welcome]:"
	read -r STARTREGION
	if [ "$STARTREGION" = "" ]; then STARTREGION="Welcome"; fi
	echo "Der Name ihrer Startregion lautet: $STARTREGION"
	echo "##################################################################"

	echo "Bitte geben sie den Namen ihres Grids an [MyGrid]:"
	read -r SIMULATORGRIDNAME
	if [ "$SIMULATORGRIDNAME" = "" ]; then SIMULATORGRIDNAME="MyGrid"; fi
	echo "Der Name ihrers Grids lautet: $SIMULATORGRIDNAME"
	echo "##################################################################"

	echo "Bitte geben sie den Grid-Nickname an [MG]:"
	read -r SIMULATORGRIDNICK
	if [ "$SIMULATORGRIDNICK" = "" ]; then SIMULATORGRIDNICK="MG"; fi
	echo "Der Grid-Nickname lautet: $SIMULATORGRIDNICK"
	echo "##################################################################"

	echo "Möchten sie die Regionskonfigurationen direkt Aktivieren ja/nein [nein]:"
	read -r REGIONAKTIV
	if [ "$REGIONAKTIV" = "" ]; then REGIONAKTIV="nein"; fi
	echo "Sie haben ausgewählt: $REGIONAKTIV"
	echo "##################################################################"

	echo "Möchten sie die Skriptkonfigurationen Aktivieren ja/nein [nein]:"
	read -r SKRIPTAKTIV
	if [ "$SKRIPTAKTIV" = "" ]; then SKRIPTAKTIV="nein"; fi
	echo "Sie haben ausgewählt: $SKRIPTAKTIV"
	echo "##################################################################"

	# Weitere Auswertungen
	if [ "$PRIVURL" = "" ]; then PRIVURL="\${Const|BaseURL}"; fi
	if [ "$MONEYPORT" = "" ]; then MONEYPORT="8008"; fi

	osconfigstruktur 1 "$CONFIGANZAHL"
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

	if [ ! -f "/$STARTVERZEICHNIS/$CONFIGURESOURCE/" ]; then
		configurecopy
	else
		log error "Configure Verzeichnis existiert nicht"
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

### !  osdowngrade, automatisches downgrade des opensimulator aus dem verzeichnis opensim.
function osdowngrade() {
	log text " #############################"
	log text " !!!      BEI FEHLER      !!! "
	log text " !!! ABBRUCH MIT STRG + C !!! "
	log text " #############################"

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

### !  oszipupgrade, automatisches upgrade des opensimulator aus einer opensim zip Datei.
function oszipupgrade() {
	### dialog Aktionen
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
		echo "Keine Menuelose Funktion vorhanden!" | exit
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

###########################################################################
# Automatische Konfigurationen Prototype
###########################################################################

### !  Hier entsteht die Automatische Konfiguration. UNGETESTET
# Aufruf: ./osmtool.sh AutoInstall

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

    echo "Herzlich willkommen zur Grundinstallation ihreres Servers."
    echo "Möchten sie eine Grundinstallation ihres $MYSERVER Servers, "

    echo "damit alle für den Betrieb benötigten Linux Pakete installiert werden ja/nein: [nein]"
	read -r installation
	if [ "$installation" = "" ]; then installation="nein"; fi

    if [ "$installation" = "ja" ]; then
        if [ "$ubuntuCodename" = "jammy" ]; then
            #echo "entdeckt Ubuntu 22"
            installbegin
            installubuntu22
            installmono22
            installphpmyadmin
            ufwset
            #installationhttps22
            installfinish
        elif [ "$ubuntuCodename" = "Bionic" ]; then
            #echo "entdeckt Ubuntu 18"
            serverupgrade
            installobensimulator
            monoinstall18
            installfinish
        else
            echo "Ich erkenne das Betriebssystem nicht"
        fi
    fi
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

### !  senddata Daten zu einem neuen Server senden ### Ungetestet ###
# senddata USERNAMEN SENDEVERZEICHNIS SERVERADRESS 
function senddata() {
	USERNAMEN=$1
	SENDEVERZEICHNIS=$2	
	SERVERADRESS=$3
	
	# Beispiel:
	# SENDEVERZEICHNIS="/opt/backup"
	# USERNAMEN="root"
	# SERVERADRESS="192.168.2.100"

	echo " Ganzes Verzeichnis komprimiert an neuen Server im gleichen Verzeichnis senden."

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

### ! dotnetinfo .NET und CSharp Informationen.
function dotnetinfo(){
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

### !  hilfe, Hilfe auf dem Bildschirm anzeigen.
function hilfe() {
	echo "$(tput setab 5)Funktion:$(tput sgr 0)		$(tput setab 2)Parameter:$(tput sgr 0)		$(tput setab 4)Informationen:$(tput sgr 0)"
	echo "hilfe 			- $(tput setaf 3)hat keine Parameter$(tput sgr 0)	- Diese Hilfe."
	echo "konsolenhilfe 		- $(tput setaf 3)hat keine Parameter$(tput sgr 0)	- konsolenhilfe ist eine Hilfe fuer Putty oder Xterm"
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
	echo "db_tablesplitt - $(tput setab 5) /Pfad/SQL_Datei.sql $(tput sgr 0) Alle Tabellen aus SQL Sicherung in ein gleichnamigen Verzeichnis extrahieren."
	echo "db_tablextract - $(tput setab 5) /Pfad/SQL_Datei.sql $(tput setab 4) Tabellenname $(tput sgr 0) Einzelne Tabelle aus SQL Backup extrahieren."
	echo " "
	echo "db_backuptabellen - $(tput setab 5)username $(tput setab 4)password $(tput setab 3)databasename $(tput sgr 0) Backup eine Datenbanken Tabellenweise speichern."
	echo "db_restorebackuptabellen - $(tput setab 5)username $(tput setab 4)password $(tput setab 3)databasename $(tput setab 2)newdatabasename $(tput sgr 0) Restore Datenbank Tabellenweise wiederherstellen."

	log line
	echo "loadinventar - $(tput setab 5)NAME VERZEICHNIS PASSWORD DATEINAMEmitPFAD $(tput sgr 0) - laedt Inventar aus einer iar"
	echo "saveinventar - $(tput setab 5)NAME VERZEICHNIS PASSWORD DATEINAMEmitPFAD $(tput sgr 0) - speichert Inventar in einer iar"

	echo "unlockexample	- $(tput setaf 3)hat keine Parameter$(tput sgr 0) - Benennt alle example Dateien um."

	echo "passwdgenerator - $(tput setab 5)Passwortstaerke$(tput sgr 0) - Generiert ein Passwort zur weiteren verwendung."

	log line
	echo "$(tput setaf 3)  Der Verzeichnisname ist gleichzeitig auch der Screen Name!$(tput sgr 0)"

	# log info "HILFE: Hilfe wurde angefordert."
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

	# log info "HILFE: Konsolenhilfe wurde angefordert"
}

### !  commandhelp
function commandhelp() {
	cat <<eof
$(tput setab 1)
Help OpenSim Commands:
Aufruf: oscommand Screen Region "Befehl mit Parameter in Hochstrichen"
Beispiel: /opt/osmtool.sh oscommand sim1 Welcome "alert Hallo liebe Leute dies ist eine Nachricht"
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
			"Sim Informationen" ""
			"Screen Liste" ""
			"Server laufzeit und Neustart" ""
			"----------Menu------------" ""
			"Avatarmennu" ""
			"Weitere Funktionen" ""
			"Dateimennu" ""
			"mySQLmenu" ""
			"Build Funktionen" ""
			"Experten Funktionen" "")

		mauswahl=$(dialog --backtitle "$BACKTITLE" --title "$TITLE" --help-button --defaultno --menu "$MENU" $HEIGHT $WIDTH $CHOICE_HEIGHT "${OPTIONS[@]}" 2>&1 >/dev/tty)
		antwort=$?
		#dialogclear
		dialog --clear
		ScreenLog

		if [[ $mauswahl = "OpenSim Autostart" ]]; then menuautostart; fi
		if [[ $mauswahl = "OpenSim Autostopp" ]]; then menuautostop; fi
		if [[ $mauswahl = "OpenSim Restart" ]]; then menuautorestart; fi

		if [[ $mauswahl = "Einzelner Simulator Stop" ]]; then menuosstop; fi
		if [[ $mauswahl = "Einzelner Simulator Start" ]]; then menuosstart; fi
		#if [[ $mauswahl = "Einzelner Simulator Status" ]]; then menuworks; fi
		#if [[ $mauswahl = "Alle Simulatoren Status" ]]; then menuwaslauft; fi
		if [[ $mauswahl = "Sim Informationen" ]]; then menuinfo; fi
		if [[ $mauswahl = "Systeminformationen" ]]; then systeminformation; fi

		if [[ $mauswahl = "Screen Liste" ]]; then screenlist; fi
		if [[ $mauswahl = "Parzellen entfernen" ]]; then menulandclear; fi
		if [[ $mauswahl = "Objekt entfernen" ]]; then menuassetdel; fi
		if [[ $mauswahl = "Benutzer Account anlegen" ]]; then menucreateuser; fi
		if [[ $mauswahl = "Server laufzeit und Neustart" ]]; then rebootdatum; fi

		if [[ $mauswahl = "Dateimennu" ]]; then dateimenu; fi
		if [[ $mauswahl = "mySQLmenu" ]]; then mySQLmenu; fi
		if [[ $mauswahl = "Weitere Funktionen" ]]; then funktionenmenu; fi
		if [[ $mauswahl = "Experten Funktionen" ]]; then expertenmenu; fi
		if [[ $mauswahl = "Build Funktionen" ]]; then buildmenu; fi
		if [[ $mauswahl = "Avatarmennu" ]]; then avatarmenu; fi

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
	WIDTH=0
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
			"--------------------------" ""
			"Passwortgenerator" ""
			"Kalender" ""
			"--------------------------" ""
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
		#dialogclear
		dialog --clear
		ScreenLog

		if [[ $hauswahl = "Hilfe" ]]; then hilfe; fi
		if [[ $hauswahl = "Konsolenhilfe" ]]; then menukonsolenhilfe; fi # Test menukonsolenhilfe
		if [[ $hauswahl = "Kommandohilfe" ]]; then commandhelp; fi
		if [[ $hauswahl = "Konfiguration lesen" ]]; then menuoswriteconfig; fi

		if [[ $hauswahl = "Passwortgenerator" ]]; then passwdgenerator; fi
		if [[ $hauswahl = "Kalender" ]]; then kalender; fi

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
	WIDTH=0
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
			"Avatarmennu" ""
			"Dateimennu" ""
			"mySQLmenu" ""
			"Build Funktionen" ""
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
		#dialogclear
		dialog --clear
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
		if [[ $fauswahl = "Build Funktionen" ]]; then buildmenu; fi
		if [[ $fauswahl = "Avatarmennu" ]]; then avatarmenu; fi

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
	WIDTH=0
	CHOICE_HEIGHT=30
	BACKTITLE="opensimMULTITOOL"
	TITLE="Dateimenu"
	MENU="opensimMULTITOOL $VERSION"

	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then
		OPTIONS=("Inventar speichern" ""
			"Inventar laden" ""
			"Region OAR sichern" ""
			"Automatischer Regionsbackup" ""
			"--------------------------" ""
			"Log Dateien loeschen" ""
			"Map Karten loeschen" ""
			"Asset Cache loeschen" ""
			"Asset loeschen" ""
			"--------------------------" ""
			"Grid Konfigurationen erstellen" ""
			"----------Menu------------" ""
			"Hauptmenu" ""
			"Avatarmennu" ""
			"Weitere Funktionen" ""
			"mySQLmenu" ""
			"Build Funktionen" ""
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
		#dialogclear
		dialog --clear
		ScreenLog

		if [[ $dauswahl = "Inventar speichern" ]]; then menusaveinventar; fi
		if [[ $dauswahl = "Inventar laden" ]]; then menuloadinventar; fi
		if [[ $dauswahl = "Region OAR sichern" ]]; then menuregionbackup; fi
		if [[ $dauswahl = "Automatischer Regionsbackup" ]]; then autoregionbackup; fi
		# -----	
		if [[ $dauswahl = "Log Dateien loeschen" ]]; then autologdel; fi
		if [[ $dauswahl = "Map Karten loeschen" ]]; then automapdel; fi		
		if [[ $dauswahl = "Asset loeschen" ]]; then menuassetdel; fi
		if [[ $dauswahl = "Asset Cache loeschen" ]]; then autoassetcachedel; fi
		# -----
		if [[ $dauswahl = "Grid Konfigurationen erstellen" ]]; then configabfrage; fi		
		# -----
		if [[ $dauswahl = "Hauptmenu" ]]; then hauptmenu; fi
		if [[ $dauswahl = "mySQLmenu" ]]; then mySQLmenu; fi
		if [[ $dauswahl = "Weitere Funktionen" ]]; then funktionenmenu; fi
		if [[ $dauswahl = "Experten Funktionen" ]]; then expertenmenu; fi
		if [[ $dauswahl = "Build Funktionen" ]]; then buildmenu; fi
		if [[ $dauswahl = "Avatarmennu" ]]; then avatarmenu; fi

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
			"mySQL Datenbankbenutzer anzeigen" ""
			"Alle Grid Regionen listen" ""			
			"Region URI pruefen sortiert nach URI" ""
			"Ports pruefen sortiert nach Ports" ""			
			"Benutzer inventoryfolders alles was type -1 ist anzeigen" ""
			"Zeige Erstellungsdatum eines Users an" ""
			"Finde falsche E-Mail Adressen" ""
			"Listet alle erstellten Benutzerrechte auf" ""
			"--------------------------" ""
			"Neue Datenbank erstellen" ""
			"Neuen Datenbankbenutzer anlegen" ""
			"--------------------------" ""
			"Datenbank leeren" ""
			"Datenbank komplett loeschen" ""
			"Loescht einen Datenbankbenutzer" ""
			"--------------------------" ""
			"mysqlTuner herunterladen" ""
			"Alle Datenbanken Checken, Reparieren und Optimieren" ""			
			"----------Menu------------" ""
			"Hauptmenu" ""
			"Avatarmennu" ""
			"Weitere Funktionen" ""
			"Dateimennu" ""
			"Build Funktionen" ""
			"Experten Funktionen" "")

		mysqlauswahl=$(dialog --backtitle "$BACKTITLE" --title "$TITLE" --help-button --defaultno --menu "$MENU" $HEIGHT $WIDTH $CHOICE_HEIGHT "${OPTIONS[@]}" 2>&1 >/dev/tty)
		antwort=$?
		#dialogclear
		dialog --clear
		ScreenLog

		# db_anzeigen_dialog, db_tables_dialog, db_all_user_dialog, db_all_uuid_dialog, db_email_setincorrectuseroff_dialog, db_setuseronline_dialog, db_setuserofline_dialog
		# db_all_name_dialog, db_user_data_dialog, db_user_infos_dialog, db_user_uuid_dialog

		if [[ $mysqlauswahl = "Alle Datenbanken anzeigen" ]]; then db_anzeigen_dialog; fi
		if [[ $mysqlauswahl = "Tabellen einer Datenbank" ]]; then db_tables_dialog; fi		

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
		# -----
		if [[ $mysqlauswahl = "Hauptmenu" ]]; then hauptmenu; fi
		if [[ $mysqlauswahl = "Dateimennu" ]]; then dateimenu; fi
		if [[ $mysqlauswahl = "Weitere Funktionen" ]]; then funktionenmenu; fi
		if [[ $mysqlauswahl = "Experten Funktionen" ]]; then expertenmenu; fi
		if [[ $mysqlauswahl = "Build Funktionen" ]]; then buildmenu; fi
		if [[ $mysqlauswahl = "Avatarmennu" ]]; then avatarmenu; fi

		if [[ $antwort = 2 ]]; then hilfemenu; fi
		if [[ $antwort = 1 ]]; then exit; fi
	else
		# wenn dialog nicht installiert ist die Hilfe anzeigen.
		hilfe
	fi
}

### !  avatarmenu
function avatarmenu() {
	HEIGHT=0
	WIDTH=0
	CHOICE_HEIGHT=30
	BACKTITLE="opensimMULTITOOL"
	TITLE="Avatarmenu"
	MENU="opensimMULTITOOL $VERSION"

	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then
		OPTIONS=("Alle Benutzerdaten der ROBUST Datenbank" ""
			"UUID von allen Benutzern anzeigen" ""
			"Alle Benutzernamen anzeigen" ""
			"Daten von einem Benutzer anzeigen" ""
			"UUID, Vor, Nachname, E-Mail vom Benutzer anzeigen" ""
			"UUID von einem Benutzer anzeigen" ""
			"--------------------------" ""
			"Alle Benutzer mit inkorrekter EMail abschalten" ""
			"Benutzeracount abschalten" ""
			"Benutzeracount einschalten" ""
			"----------Menu------------" ""
			"Hauptmennu" ""
			"Avatarmennu" ""
			"Dateimennu" ""
			"mySQLmenu" ""
			"Build Funktionen" ""
			"Experten Funktionen" "")

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

		if [[ $avatarauswahl = "Alle Benutzerdaten der ROBUST Datenbank" ]]; then db_all_user_dialog; fi
		if [[ $avatarauswahl = "UUID von allen Benutzern anzeigen" ]]; then db_all_uuid_dialog; fi
		
		if [[ $avatarauswahl = "Alle Benutzernamen anzeigen" ]]; then db_all_name_dialog; fi
		if [[ $avatarauswahl = "Daten von einem Benutzer anzeigen" ]]; then db_user_data_dialog; fi
		if [[ $avatarauswahl = "UUID, Vor, Nachname, E-Mail vom Benutzer anzeigen" ]]; then db_user_infos_dialog; fi
		if [[ $avatarauswahl = "UUID von einem Benutzer anzeigen" ]]; then db_user_uuid_dialog; fi
		
		if [[ $avatarauswahl = "Alle Benutzer mit inkorrekter EMail abschalten" ]]; then db_email_setincorrectuseroff_dialog; fi
		if [[ $avatarauswahl = "Benutzeracount abschalten" ]]; then db_setuserofline_dialog; fi
		if [[ $avatarauswahl = "Benutzeracount einschalten" ]]; then db_setuseronline_dialog; fi

		if [[ $avatarauswahl = "Dateimennu" ]]; then dateimenu; fi
		if [[ $avatarauswahl = "mySQLmenu" ]]; then mySQLmenu; fi
		if [[ $avatarauswahl = "Hauptmennu" ]]; then hauptmenu; fi
		if [[ $avatarauswahl = "Experten Funktionen" ]]; then expertenmenu; fi
		if [[ $avatarauswahl = "Build Funktionen" ]]; then buildmenu; fi

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
	WIDTH=0
	CHOICE_HEIGHT=30
	BACKTITLE="opensimMULTITOOL"
	TITLE="Expertenmenu"
	MENU="opensimMULTITOOL $VERSION"

	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then
		OPTIONS=("Example Dateien umbenennen" ""
			"Voreinstellungen setzen" ""
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
			"Avatarmennu" ""
			"Dateimennu" ""
			"mySQLmenu" ""
			"Build Funktionen" ""
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
		#dialogclear
		dialog --clear
		ScreenLog

		if [[ $feauswahl = "Example Dateien umbenennen" ]]; then unlockexample; fi
		if [[ $feauswahl = "Voreinstellungen setzen" ]]; then ossettings; fi

		if [[ $feauswahl = "Kommando an OpenSim senden" ]]; then menuoscommand; fi

		if [[ $feauswahl = "autoregionsiniteilen" ]]; then autoregionsiniteilen; fi
		if [[ $feauswahl = "RegionListe" ]]; then regionliste; fi

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
		if [[ $feauswahl = "Build Funktionen" ]]; then buildmenu; fi
		if [[ $feauswahl = "Avatarmennu" ]]; then avatarmenu; fi

		if [[ $antwort = 2 ]]; then hilfemenu; fi
		if [[ $antwort = 1 ]]; then exit; fi
	else
		# wenn dialog nicht installiert ist die Hilfe anzeigen.
		hilfe
	fi
}

### !  buildmenu
function buildmenu() {
	HEIGHT=0
	WIDTH=0
	CHOICE_HEIGHT=30
	BACKTITLE="opensimMULTITOOL"
	TITLE="Buildmenu"
	MENU="opensimMULTITOOL $VERSION"

	# zuerst schauen ob dialog installiert ist
	if dpkg-query -s dialog 2>/dev/null | grep -q installed; then
		OPTIONS=("OpenSim herunterladen" ""
			"MoneyServer vom git kopieren" ""
			"OSSL Skripte vom git kopieren" ""
			"Configure vom git kopieren" ""
			"Opensim vom Github holen" ""
			"--------------------------" ""
			"Downgrade zur letzten Version" ""
			"Kompilieren" ""
			"oscompi" ""
			"Opensimulator upgraden" ""
			"Opensimulator aus zip upgraden" ""
			"Opensimulator bauen und upgraden" ""
			"--------------------------" ""			
			"Konfigurationen und Verzeichnisstrukturen anlegen" ""
			"Verzeichnisstrukturen anlegen" ""
			"Regionsliste erstellen (Backup)" ""
			"--------------------------" ""
			"Sim in Verzeichnisstrukturen eintragen" ""
			"Sim in Verzeichnisstrukturen austragen" ""
			"Sim in Startkonfiguration einfuegen" ""
			"Sim aus Startkonfiguration entfernen" ""
			"----------Menu------------" ""
			"Hauptmenu" ""
			"Avatarmennu" ""
			"Weitere Funktionen" ""
			"Dateimennu" ""
			"mySQLmenu" ""
			"Experten Funktionen" "")

		buildauswahl=$(dialog --backtitle "$BACKTITLE" --title "$TITLE" --help-button --defaultno --menu "$MENU" $HEIGHT $WIDTH $CHOICE_HEIGHT "${OPTIONS[@]}" 2>&1 >/dev/tty)
		antwort=$?
		#dialogclear
		dialog --clear
		ScreenLog

		if [[ $buildauswahl = "OpenSim herunterladen" ]]; then downloados; fi
		if [[ $buildauswahl = "MoneyServer vom git kopieren" ]]; then moneygitcopy; fi
		if [[ $buildauswahl = "OSSL Skripte vom git kopieren" ]]; then scriptgitcopy; fi
		if [[ $buildauswahl = "Configure vom git kopieren" ]]; then configuregitcopy; fi
		if [[ $buildauswahl = "Opensim vom Github holen" ]]; then osgitholen; fi
		# -----
		if [[ $buildauswahl = "Downgrade zur letzten Version" ]]; then osdowngrade; fi
		if [[ $buildauswahl = "Kompilieren" ]]; then compilieren; fi
		if [[ $buildauswahl = "oscompi" ]]; then oscompi; fi
		if [[ $buildauswahl = "Opensimulator upgraden" ]]; then osupgrade; fi
		if [[ $buildauswahl = "Opensimulator aus zip upgraden" ]]; then oszipupgrade; fi
		if [[ $buildauswahl = "Opensimulator bauen und upgraden" ]]; then osbuilding; fi
		# -----
		if [[ $buildauswahl = "Konfigurationen und Verzeichnisstrukturen anlegen" ]]; then configabfrage; fi
		if [[ $buildauswahl = "Verzeichnisstrukturen anlegen" ]]; then menuosstruktur; fi
		if [[ $buildauswahl = "Regionsliste erstellen (Backup)" ]]; then regionliste; fi
		# -----
		if [[ $buildauswahl = "Sim in Verzeichnisstrukturen eintragen" ]]; then menuosstarteintrag; fi
		if [[ $buildauswahl = "Sim in Verzeichnisstrukturen austragen" ]]; then menuosstarteintragdel; fi
		if [[ $buildauswahl = "Sim in Startkonfiguration einfuegen" ]]; then menuosdauerstart; fi
		if [[ $buildauswahl = "Sim aus Startkonfiguration entfernen" ]]; then menuosdauerstop; fi

		if [[ $buildauswahl = "Hauptmenu" ]]; then hauptmenu; fi
		if [[ $buildauswahl = "Dateimennu" ]]; then dateimenu; fi
		if [[ $buildauswahl = "mySQLmenu" ]]; then mySQLmenu; fi
		if [[ $buildauswahl = "Weitere Funktionen" ]]; then funktionenmenu; fi
		if [[ $buildauswahl = "Experten Funktionen" ]]; then expertenmenu; fi
		if [[ $buildauswahl = "Avatarmennu" ]]; then avatarmenu; fi

		if [[ $antwort = 2 ]]; then hilfemenu; fi
		if [[ $antwort = 1 ]]; then exit; fi
	else
		# wenn dialog nicht installiert ist die Hilfe anzeigen.
		hilfe
	fi
}

###########################################################################
# Web Interface Test

### wiparameter0 - Webinterface ohne Parameterangabe gestartet.
function wiparameter0() {
	echo "Rueckgabe: Webinterface ohne Parameterangabe gestartet."
}
### wiparameter1 - Webinterface mit 1 Parameterangabe gestartet.
function wiparameter1() {
	parameter1=$1;
	echo "Rueckgabe: Webinterface mit 1 Parameterangabe gestartet."
	echo "Parameter1= $parameter1"
}
### wiparameter2 - Webinterface mit 2 Parameterangaben gestartet.
function wiparameter2() {
	parameter1=$1; parameter2=$2;
	echo "Rueckgabe: Webinterface mit 1 Parameterangaben gestartet."
	echo "Parameter1= $parameter1 Parameter2= $parameter2"
}
### wiparameter3 - Webinterface mit 3 Parameterangaben gestartet.
function wiparameter3() {
	parameter1=$1; parameter2=$2; parameter3=$3;
	echo "Rueckgabe: Webinterface mit 3 Parameterangaben gestartet."
	echo "Parameter1= $parameter1 Parameter2= $parameter2 Parameter3= $parameter3"
}
### wiparameter4 - Webinterface mit 4 Parameterangaben gestartet.
function wiparameter4() {
	parameter1=$1; parameter2=$2; parameter3=$3; parameter4=$4;
	echo "Rueckgabe: Webinterface mit 4 Parameterangaben gestartet."
	echo "Parameter1= $parameter1 Parameter2= $parameter2 Parameter3= $parameter3 Parameter4= $parameter4"
}
### wiparameter5 - Webinterface mit 5 Parameterangaben gestartet.
function wiparameter5() {
	parameter1=$1; parameter2=$2; parameter3=$3; parameter4=$4; parameter5=$5;
	echo "Rueckgabe: Webinterface mit 5 Parameterangaben gestartet."
	echo "Parameter1= $parameter1 Parameter2= $parameter2 Parameter3= $parameter3 Parameter4= $parameter4 Parameter5= $parameter5"
}
### wiparameter6 - Webinterface mit 6 Parameterangaben gestartet.
function wiparameter6() {
	parameter1=$1; parameter2=$2; parameter3=$3; parameter4=$4; parameter5=$5; parameter6=$6;
	echo "Rueckgabe: Webinterface mit 6 Parameterangaben gestartet."
	echo "Parameter1= $parameter1 Parameter2= $parameter2 Parameter3= $parameter3 Parameter4= $parameter4"
	echo "Parameter5= $parameter5 Parameter6= $parameter6"
}
### wiparameter7 - Webinterface mit 7 Parameterangaben gestartet.
function wiparameter7() {
	parameter1=$1; parameter2=$2; parameter3=$3; parameter4=$4; parameter5=$5; parameter6=$6; parameter7=$7;
	echo "Rueckgabe: Webinterface mit 7 Parameterangaben gestartet."
	echo "Parameter1= $parameter1 Parameter2= $parameter2 Parameter3= $parameter3 Parameter4= $parameter4"
	echo "Parameter5= $parameter5 Parameter6= $parameter6 Parameter7= $parameter7"
}
### wiparameter8 - Webinterface mit 8 Parameterangaben gestartet.
#  test1 test2 test3 test4 test5 test6 test7 test8
function wiparameter8() {
	parameter1=$1; parameter2=$2; parameter3=$3; parameter4=$4; parameter5=$5; parameter6=$6; parameter7=$7; parameter8=$8;
	echo "Rueckgabe: Webinterface mit 8 Parameterangaben gestartet."
	echo "Parameter1= $parameter1 Parameter2= $parameter2 Parameter3= $parameter3 Parameter4= $parameter4"
	echo "Parameter5= $parameter5 Parameter6= $parameter6 Parameter7= $parameter7 Parameter8= $parameter8"
}

###########################################################################
# Eingabeauswertung Konsolenmenue
###########################################################################
case $KOMMANDO in
	AutoInstall) AutoInstall ;;
	ConfigSet) ConfigSet "$2" ;;
	DO_DOMAIN_IDS) DO_DOMAIN_IDS "$2" "$3" "$4" ;;
	DO_DOMAIN_IDS2) DO_DOMAIN_IDS2 "$2" "$3" ;;
	GridCommonConfig) GridCommonConfig ;;
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
	RegionsConfig) RegionsConfig ;;
	Replica_Backup) Replica_Backup "$2" "$3" "$4" "$5" ;;
	Replica_Backup2) Replica_Backup2 "$2" "$3" "$4" ;;
	ReplikatKoordinaten) ReplikatKoordinaten "$2" "$3" "$4" "$5" "$6" "$7" "$8" ;;
	RobustConfig) RobustConfig ;;
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
	astop | autostop | stop) autostop ;;
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
	compi | compilieren) compilieren ;;
	conf_delete) conf_delete "$2" "$3" "$4" ;;
	conf_read) conf_read "$2" "$3" "$4" ;;
	conf_write) conf_write "$2" "$3" "$4" "$5" ;;
	configurecopy) configurecopy ;;
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
	functionslist) functionslist ;;
	funktionenmenu) funktionenmenu ;;
	get_value_from_Region_key) get_value_from_Region_key ;;
	gridcommonini) gridcommonini ;;
	gsta | gridstart) gridstart ;;
	gsto | gridstop) gridstop ;;
	h | hilfe | help) hilfe ;;
	historylogclear) historylogclear "$2" ;;
	info) info ;;
	infodialog) infodialog ;;
	installationen) installationen ;;
	installationhttps22) installationhttps22 "$2" "$3" ;;
	installbegin) installbegin ;;
	installfinish) installfinish ;;
	installmariadb18) installmariadb18 ;;
	installmariadb22) installmariadb22 ;;
	installmono22) installmono22 ;;
	installphpmyadmin) installphpmyadmin ;;
	installubuntu22) installubuntu22 ;;
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
	md | mapdel) mapdel "$2" ;;
	menuinfo) menuinfo ;;
	menuosdauerstart) menuosdauerstart "$2" ;; # Test
	menuosdauerstop) menuosdauerstop "$2" ;; # Test
	menuoswriteconfig) menuoswriteconfig "$2" ;;
	menuworks) menuworks "$2" ;;
	moneydelete) moneydelete ;;
	moneygitcopy) moneygitcopy ;;
	moneyserverini) moneyserverini ;;
	monoinstall) monoinstall ;;
	mr | meineregionen) meineregionen ;;
	ms | moneystart | mostart) mostart ;;
	mstop | moneystop | mostop) mostop ;;
	mutelistcopy) mutelistcopy ;;
	mysql_neustart) mysql_neustart ;;
	mysqldberror) mysqldberror ;;
	mysqleinstellen) mysqleinstellen ;;
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
	osgridcopy) osgridcopy ;;
	osprebuild) osprebuild "$2" ;;
	osslEnableConfig) osslEnableConfig ;;
	osslenableini) osslenableini ;;
	osstarteintrag) osstarteintrag "$2" ;; # Test
	osstarteintragdel) osstarteintragdel "$2" ;; # Test
	osta | osstart) osstart "$2" ;;
	osto | osstop) osstop "$2" ;;
	oswriteconfig) oswriteconfig "$2" ;;
	ou | osupgrade) osupgrade ;;
	passgen) passgen "$2" ;;
	passwdgenerator) passwdgenerator "$2" ;;
	pythoncopy) pythoncopy ;;
	r | restart) autorestart ;;
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
	rn | RegionListe) regionliste ;;
	robustbackup) robustbackup ;;
	robustini) robustini ;;
	rologdel) rologdel ;;
	rs | robuststart | rostart) rostart ;;
	rsto | robuststop | rostop) rostop ;;
	s | settings) ossettings ;;
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
	ss | osscreenstop) osscreenstop "$2" ;;
	sta | autosimstart | simstart) autosimstart ;;
	sto | autosimstop | simstop) autosimstop ;;
	systeminformation) systeminformation ;;
	tabellenabfrage) tabellenabfrage "$2" "$3" "$4" ;;
	textbox) textbox "$8" ;;
	ufwlog) ufwlog ;;
	ufwset) ufwset ;;
	unlockexample) unlockexample ;;
	w | works) works "$2" ;;
	warnbox) warnbox "$2" ;;
	waslauft) waslauft ;;
	wiparameter0) wiparameter0 ;;
	wiparameter1) wiparameter1 "$2" ;;
	wiparameter2) wiparameter2 "$2" "$3" ;;
	wiparameter3) wiparameter3 "$2" "$3" "$4" ;;
	wiparameter4) wiparameter4 "$2" "$3" "$4" "$5" ;;
	wiparameter5) wiparameter5 "$2" "$3" "$4" "$5" "$6" ;;
	wiparameter6) wiparameter6 "$2" "$3" "$4" "$5" "$6" "$7" ;;
	wiparameter7) wiparameter7 "$2" "$3" "$4" "$5" "$6" "$7" "$8" ;;
	wiparameter8) wiparameter8 "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9" ;;
	lastrebootdatum) lastrebootdatum ;;
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
	senddata) senddata "$2" "$3" "$4" ;;
	gridcachedelete) gridcachedelete ;;
	config | gridkonfiguration | configabfrage) configabfrage ;;
	osmtoolconfigabfrage) osmtoolconfigabfrage ;;
	osdowngrade) osdowngrade ;;
	namen) namen ;;
	regionconfig) regionconfig "$2" "$3" "$4" "$5" "$6" ;;
	createdatabase) createdatabase "$2" "$3" "$4" ;;
	createdbuser) createdbuser "$2" "$3" "$4" "$5" ;;
	clearuserlist) clearuserlist ;;
	instdialog) instdialog ;;
	*) hauptmenu ;;
esac
vardel
#log info "###########ENDE################"
exit 0

# TODO:
# Einfacher Linux Server Umzug:
# Kopieren von einem entfernten Server auf einen neuen Server
# scp benutzername@beispiel_oder_IP.de:/opt/backup/dateiname.sql /opt/backup
# oder andersherum
# scp /opt/backup benutzername@beispiel_oder_IP.de:/opt/backup/dateiname.sql

# Backup Funktion die es erlaubt die Regionen als OAR zu sichern
# und direkt auf einen neuen Server zu uebertragen.
# Scritte hierzu:
# Wenn die Regions.ini nicht vereinzelt ist diese vereinzeln mit:

