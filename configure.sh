#!/bin/bash

#* Aufruf Beispiel: ./configure.sh
#* Dies schreibt per abfrage die Konfigurationen für den OpenSimulator.
#* Author Manfred Aabye 2023 MIT Lizens, Ubuntu 22.04 Linux Server.

# ? Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

# ? The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

# ! THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# ! FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# ! LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#? Der nachteil dieser art von konfiguration ist, 
#? das die Zeilen keine leerzeichen und Tabs am anfang haben dürfen, deswegen muss ich diese löschen.

# Variables
STARTVERZEICHNIS="opt"; # Hauptverzeichnis
CONFIGVERZEICHNIS="AutoConfig" # Arbeitsverzeichnis im Hauptverzeichnis
OPENSIMVERZEICHNIS="opensim" # OpenSimulator Verzeichnis im Hauptverzeichnis
linefontcolor=2	linebaggroundcolor=0;
lline="$(tput setaf $linefontcolor)$(tput setab $linebaggroundcolor)#####################################################################################$(tput sgr 0)"
SCRIPTNAME="configure" # Versionsausgabe
VERSION="0.1.39 ALPHA" # Versionsausgabe
### Aktuelle IP ueber Suchadresse ermitteln und Ausfuehrungszeichen anhaengen.
SEARCHADRES="icanhazip.com"
AKTUELLEIP='"'$(wget -O - -q $SEARCHADRES)'"'
tput reset # Bildschirmausgabe loeschen inklusive dem Scrollbereich.
# Schauen ob crudini installiert ist
if [[ -f $(which "crudini" 2>/dev/null) ]]
    then
	echo " "
    else
	echo "crudini gibt es nicht, zumindest nicht mit dem Namen crudini"
    echo "möchten sie crudini installieren?"
    echo "Bitte tippen Sie ja oder [nein] ein:"
    read -r auswahlcrudini
    if [ "$auswahlcrudini" = "" ]; then auswahlcrudini="nein"; fi

    if [ "$auswahlcrudini" = "ja" ] || [ "$auswahlcrudini" = "j" ]
    then
        sudo apt-get update -y
        sudo apt-get install -y crudini
        sudo apt-get -f install -y
    fi
    if [ "$auswahlconfigsetup" = "nein" ]; then echo "weiter..."; fi
fi

# Ausgabe Kopfzeilen
echo "$SCRIPTNAME Version $VERSION"
echo " "
echo "Ihre aktuelle externe IP ist $AKTUELLEIP"
echo " "
echo "#################################"
echo "ABBRUCH MIT DER TASTENKOMBINATION"
echo "########  STRG + C  #############"

#! Die ganzen Konfigurationen im Überblick:
# Estates.ini.example
# FlotsamCache.ini.example
# Grid.ini
# GridCommon.ini.example
# GridHypergrid.ini
# LaunchSLClient.ini
# MoneyServer.ini.example
# OpenSim.ConsoleClient.ini.example
# OpenSim.ini.example
# OpenSimDefaults.ini
# osslDefaultEnable.ini
# osslEnable.ini.example
# pCampBot.ini.example
# Regions.ini.example
# Robust.HG.ini.example
# Robust.ini.example
# Robust.Tests.ini
# SQLiteStandalone.ini
# Standalone.ini
# StandaloneCommon.ini.example
# StandaloneHypergrid.ini

#! Examples - Beispiele im Überblick
#? Add/Update a var - Variable hinzufügen/aktualisieren
#crudini --set config_file section parameter value
#? Update an existing var - Aktualisieren Sie eine vorhandene Variable
#crudini --set --existing config_file section parameter value
#? Add/Append a value to a space or comma separated list - Hinzufügen/Anhängen eines Werts an eine durch Leerzeichen oder Kommas getrennte Liste
#crudini --set --list config_file section parameter a_value
#? update an ini file from shell variable(s) - Aktualisiere eine INI Datei aus Shell Variable(n)
#echo name="$name" | crudini --merge config_file section
#? merge an ini file from another ini - eine ini-Datei aus einer anderen ini zusammenführen
#crudini --merge config_file < another.ini

#? Delete a var - Löscht eine Var - Löscht eine Variable
#crudini --del config_file section parameter
#? Delete a section - Löscht einen Abschnitt
#crudini --del config_file section

#? output a value - einen Wert ausgeben
#crudini --get config_file section parameter
#? output a global value not in a section - gib einen globalen Wert aus, der sich nicht in einem Abschnitt befindet
#crudini --get config_file '' parameter
#? output a section - einen Abschnitt ausgeben
#crudini --get config_file section
#? output a section, parseable by shell - gibt einen Abschnitt aus, der von der Shell analysiert werden kann
#eval $(crudini --get --format=sh config_file section)
#? output an ini processable by text utils - gibt eine ini aus, die von text utils verarbeitet werden kann
#crudini --get --format=lines config_file

#* crudini schreibt nur in dateien die keine Leerzeichen oder Tabs am anfang der Zeile haben.

### ! Linux Installation  Test 21.01.2023 geprüft OK
function linstall() {
    echo "$lline"
    echo "Möchten sie ihren Ubuntu 18 oder 22 Server vorbereitet, für die verwendung des OpenSimulator?"
    echo "Wählen sie ja, um die benötigten Server Komponenten jetzt zu Installieren."
    echo "Bitte tippen Sie ja oder [nein] ein:"
    read -r auswahllinstall
    if [ "$auswahllinstall" = "" ]; then auswahllinstall="nein"; fi

    if [ "$auswahllinstall" = "ja" ] || [ "$auswahllinstall" = "j" ]
        then
        echo "Bitte warten..."
            cd /$STARTVERZEICHNIS || exit
            echo "Server wird installation wird gestartet..."
            /$STARTVERZEICHNIS/opensim.sh AutoInstall
        fi
if [ "$auswahllinstall" = "nein" ]; then echo "weiter..."; fi
}

# Sind die Konfigurationen vorhanden?
function configcopy() {
        # Sind Dateien vorhanden?
        if [ -e /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini.example ] || [ -e /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.HG.ini.example ] || [ -e /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.ini.example ]
        then echo "Konfigurationsdateien vorhanden weiter..."
        else
         # Ist das OpenSim Verzeichnis vorhanden?
            if [ -d "/$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS" ] 
            then
            echo "Ich kopiere jetzt die Konfigurationsdateien in das /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS Verzeichnis."
            # /opt/opensim/bin/config-include
            # /opt/opensim/bin
            # /opt/opensim/bin/Estates
            # /opt/opensim/bin/Regions
            # /opt/opensim/bin/config-include/storage
            cp /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/bin/*.ini.example /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS;
            cp /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/bin/config-include/*.ini.example /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS;
            cp /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/bin/*.ini /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS;
            cp /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/bin/config-include/*.ini /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS;
            cp /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/bin/Estates/*.ini.example /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS;  
            cp /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/bin/config-include/storage/*.ini /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS;
            cp /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS/bin/Regions/*.ini.example /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS;
            else
            echo "Verzeichnis /$STARTVERZEICHNIS/$OPENSIMVERZEICHNIS nicht vorhanden,"
            echo "die Konfigurationsdateien konnten nicht kopiert werden."
            echo "Ist ihr OpenSimulator noch nicht entpackt, oder haben sie ihn nicht in opensim umbenannt?"
            fi
        fi
}

### ! Konfigurationen vorbereiten für weitere verarbeitungen  Test 21.01.2023 geprüft OK
function configsetup() {
    echo "$lline"
    echo "Möchten Sie ihre Konfigurationen vorbereiten für die weitere verarbeitung?"
    echo "Keine Angst die Originaldateien werden als *.backup gesichert."
    echo "ja oder [nein]"
    read -r auswahlconfigsetup
    if [ "$auswahlconfigsetup" = "" ]; then auswahlconfigsetup="nein"; fi

    if [ "$auswahlconfigsetup" = "ja" ] || [ "$auswahlconfigsetup" = "j" ]
    then
    echo "Bitte warten..."
        # INI Datei von Leerzeichen und Tabs am anfang des Textes befreien.
        # sed TAB = \t
        sed -i.backup -re 's#^ +## ; s#^\t+##' /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Estates.ini.example
        sed -i.backup -re 's#^ +## ; s#^\t+##' /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/FlotsamCache.ini.example
        sed -i.backup -re 's#^ +## ; s#^\t+##' /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Grid.ini
        sed -i.backup -re 's#^ +## ; s#^\t+##' /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/GridCommon.ini.example
        sed -i.backup -re 's#^ +## ; s#^\t+##' /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/GridHypergrid.ini
        sed -i.backup -re 's#^ +## ; s#^\t+##' /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/LaunchSLClient.ini
        sed -i.backup -re 's#^ +## ; s#^\t+##' /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/MoneyServer.ini.example
        sed -i.backup -re 's#^ +## ; s#^\t+##' /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ConsoleClient.ini.example
        sed -i.backup -re 's#^ +## ; s#^\t+##' /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini.example
        sed -i.backup -re 's#^ +## ; s#^\t+##' /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSimDefaults.ini
        sed -i.backup -re 's#^ +## ; s#^\t+##' /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/osslDefaultEnable.ini
        sed -i.backup -re 's#^ +## ; s#^\t+##' /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/osslEnable.ini.example
        sed -i.backup -re 's#^ +## ; s#^\t+##' /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/pCampBot.ini.example
        sed -i.backup -re 's#^ +## ; s#^\t+##' /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Regions.ini.example
        sed -i.backup -re 's#^ +## ; s#^\t+##' /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.HG.ini.example
        sed -i.backup -re 's#^ +## ; s#^\t+##' /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.ini.example
        sed -i.backup -re 's#^ +## ; s#^\t+##' /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.Tests.ini
        sed -i.backup -re 's#^ +## ; s#^\t+##' /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/SQLiteStandalone.ini
        sed -i.backup -re 's#^ +## ; s#^\t+##' /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Standalone.ini
        sed -i.backup -re 's#^ +## ; s#^\t+##' /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/StandaloneCommon.ini.example
        sed -i.backup -re 's#^ +## ; s#^\t+##' /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/StandaloneHypergrid.ini

        # Jetzt werden die wichtigen Dateien umkopiert von *.ini.example in *.ini
        cp /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Estates.ini.example /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Estates.ini
        cp /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/FlotsamCache.ini.example /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/FlotsamCache.ini
        cp /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/GridCommon.ini.example /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/GridCommon.ini
        cp /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/MoneyServer.ini.example /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/MoneyServer.ini
        cp /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini.example /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini
        cp /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/osslEnable.ini.example /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/osslEnable.ini
        cp /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.HG.ini.example /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.HG.ini
        cp /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.ini.example /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.ini
        cp /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/StandaloneCommon.ini.example /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/StandaloneCommon.ini
        fi
    if [ "$auswahlconfigsetup" = "nein" ]; then echo "weiter..."; fi
}

### ! Estates.ini  Test 25.01.2023 fertig
function Estatessetup() {
    echo "$lline"
    echo "Möchten Sie ihre Estates vorgeben?"
    echo "ja oder [nein]"
    read -r auswahlEstatessetup
    if [ "$auswahlEstatessetup" = "" ]; then auswahlEstatessetup="nein"; fi

    if [ "$auswahlEstatessetup" = "ja" ] || [ "$auswahlEstatessetup" = "j" ]
    then
        UUID=$(uuidgen)
        echo "Estates.ini"
        echo "Estate Name eingeben [Example Estate]"
        read -r Example_Estate
        echo "Benutzer UUID eingeben [$UUID]"
        read -r Owner
        echo "Estate ID eingeben [0] Null für Auto-Increment-ID (empfohlen)."
        read -r EstateID

        echo "Bitte warten..."

        if [ "$Example_Estate" = "" ]; then Example_Estate="Example Estate"; fi
        if [ "$Owner" = "" ]; then Owner="$UUID"; fi
        if [ "$EstateID" = "" ]; then EstateID="0"; fi
        # Example Estate löschen.
        crudini --del /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Estates.ini "Example Estate"
        # Neues Estate einfügen.
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Estates.ini "$Example_Estate"
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Estates.ini "$Example_Estate" Owner "\"$Owner\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Estates.ini "$Example_Estate" EstateID "\"$EstateID\""
    fi
if [ "$auswahlEstatessetup" = "nein" ]; then echo "weiter..."; fi
}
### ! FlotsamCache.ini  Test 21.01.2023 geprüft OK
function FlotsamCachesetup() {
    echo "$lline"
    
    echo "Möchten Sie Flotsam Cache einstellen?"
    echo "ja oder [nein]"
    read -r auswahlFlotsamCachesetup
    if [ "$auswahlFlotsamCachesetup" = "" ]; then auswahlFlotsamCachesetup="nein"; fi

    if [ "$auswahlFlotsamCachesetup" = "ja" ] || [ "$auswahlFlotsamCachesetup" = "j" ]
    then
        echo "FlotsamCache.ini"
        echo "Wie oft in Stunden soll die Festplatte auf abgelaufene Dateien überprüft werden?"
        echo "Geben Sie 0 an, um die Ablaufprüfung zu deaktivieren [24.0]"
        read -r FlotsamTime
        if [ "$FlotsamTime" = "" ]; then FlotsamTime="24.0"; fi

        echo "Bitte warten..."

        #[AssetCache]FlotsamCache.ini
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/FlotsamCache.ini AssetCache FileCleanupTimer "\"$FlotsamTime\""
    fi
if [ "$auswahlFlotsamCachesetup" = "nein" ]; then echo "weiter..."; fi
}
### ! MoneyServer.ini Test 21.01.2023 geprüft OK
function MoneyServersetup() {
    echo "$lline"
    echo "MoneyServer.ini";
    echo "Möchten Sie den Money Server konfigurieren?"
    echo "ja oder [nein]"
    read -r auswahlMoneyServersetup
    if [ "$auswahlMoneyServersetup" = "" ]; then auswahlMoneyServersetup="nein"; fi

    if [ "$auswahlMoneyServersetup" = "ja" ] || [ "$auswahlMoneyServersetup" = "j" ]
    then
        echo "Ein Fehler der immer wieder begangen wird,"
        echo "ist das man nicht einen extra Banker anlegt,"
        echo "der nur für die Grid Vermögenswerte,"
        echo "beziehungsweise Grid Geldautomaten/Glücksspielautomaten zuständig ist."
        echo "Ein Avatar der Banker ist, kann sich nicht selbst Geld geben oder verdienen."
        echo " "
        echo "Datenbankeinstellungen für den Money Server"
        echo " "
        echo "Money Server Adresse [localhost]"
        read -r localhost
        if [ "$localhost" = "" ]; then localhost="localhost"; fi
        echo "Datenbankname [opensim]"
        read -r Database_name
        if [ "$Database_name" = "" ]; then Database_name="opensim"; fi
        echo "Datenbank Benutzername [opensim]"
        read -r Database_user
        if [ "$Database_user" = "" ]; then Database_user="opensim"; fi
        echo "Datenbank Passwort [opensim]"
        read -r Database_password
        if [ "$Database_password" = "" ]; then Database_password="opensim"; fi
        echo "Money Server Zugangsschlüssel [123456789]"
        read -r AccessKey
        if [ "$AccessKey" = "" ]; then AccessKey="123456789"; fi
        echo "Money Server IP Adresse [$AKTUELLEIP]"
        read -r ScriptIPaddress
        if [ "$ScriptIPaddress" = "" ]; then ScriptIPaddress="$AKTUELLEIP"; fi
        echo "Maximale Datenbank Verbindungen [40]"
        read -r MaxConnection
        if [ "$MaxConnection" = "" ]; then MaxConnection="40"; fi
        echo "Server Port [8008]"
        read -r ServerPort
        if [ "$ServerPort" = "" ]; then ServerPort="8008"; fi
        echo "Höhe des Standardsaldo Startkapital eines Avatars [1000]"
        read -r DefaultBalance
        if [ "$DefaultBalance" = "" ]; then DefaultBalance="1000"; fi
        echo "Höhe des Standardsaldo Startkapital eines HG Avatars [1000]"
        read -r DefaultBalance
        if [ "$DefaultBalance" = "" ]; then DefaultBalance="1000"; fi
        echo "Höhe des Standardsaldo Startkapital eines Gast Avatars [1000]"
        read -r DefaultBalance
        if [ "$DefaultBalance" = "" ]; then DefaultBalance="1000"; fi
        echo "UUID des Bankier-Avatar [00000000-0000-0000-0000-000000000000]"
        read -r BankerAvatar
        if [ "$BankerAvatar" = "" ]; then BankerAvatar="00000000-0000-0000-0000-000000000000"; fi

        echo "Bitte warten..."

        #[MySql]MoneyServer.ini
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/MoneyServer.ini MySql hostname "\"$localhost\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/MoneyServer.ini MySql database "\"$Database_name\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/MoneyServer.ini MySql username "\"$Database_user\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/MoneyServer.ini MySql password "\"$Database_password\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/MoneyServer.ini MySql MaxConnection "\"$MaxConnection\""
        #[MoneyServer]MoneyServer.ini
        sed -i s/\;EnableScriptSendMoney/EnableScriptSendMoney/g /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/MoneyServer.ini
        sed -i s/\;MoneyScriptAccessKey/MoneyScriptAccessKey/g /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/MoneyServer.ini
        sed -i s/\;MoneyScriptIPaddress/MoneyScriptIPaddress/g /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/MoneyServer.ini
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/MoneyServer.ini MoneyServer ServerPort "\"8008\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/MoneyServer.ini MoneyServer DefaultBalance "\"1000\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/MoneyServer.ini MoneyServer HGAvatarDefaultBalance "\"1000\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/MoneyServer.ini MoneyServer GuestAvatarDefaultBalance "\"1000\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/MoneyServer.ini MoneyServer BankerAvatar "\"00000000-0000-0000-0000-000000000000\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/MoneyServer.ini MoneyServer EnableScriptSendMoney "\"true\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/MoneyServer.ini MoneyServer MoneyScriptAccessKey  "\"$AccessKey\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/MoneyServer.ini MoneyServer MoneyScriptIPaddress  "$ScriptIPaddress"
        #[Certificate]MoneyServer.ini
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/MoneyServer.ini Certificate CheckServerCert "false"
        #[Economy]OpenSim.ini
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini Economy SellEnabled "true"
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini Economy EconomyModule "DTLNSLMoneyModule"
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini Economy CurrencyServer "\"\${Const|BaseURL}:8008/\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini Economy UserServer "\"\${Const|BaseURL}:8002/\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini Economy CheckServerCert "false"
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini Economy PriceUpload "0"
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini Economy MeshModelUploadCostFactor "1.0"
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini Economy MeshModelUploadTextureCostFactor "1.0"
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini Economy MeshModelMinCostFactor "1.0"
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini Economy PriceGroupCreate "0"
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini Economy ObjectCount "0"
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini Economy PriceEnergyUnit "0"
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini Economy PriceObjectClaim "0"
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini Economy PricePublicObjectDecay "0"
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini Economy PricePublicObjectDelete "0"
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini Economy PriceParcelClaim "0"
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini Economy PriceParcelClaimFactor "1"
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini Economy PriceRentLight "0"
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini Economy TeleportMinPrice "0"
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini Economy TeleportPriceExponent "2"
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini Economy EnergyEfficiency "1"
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini Economy PriceObjectRent "0"
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini Economy PriceObjectScaleFactor "10"
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini Economy PriceParcelRent "0"
        echo "weiter..."
    fi
if [ "$auswahlMoneyServersetup" = "nein" ]; then echo "weiter..."; fi
}

### ! OpenSim.ini
function OpenSimsetup() {
    echo "$lline"
    echo "OpenSim.ini";
    echo "Möchten Sie den OpenSimulator konfigurieren?"
    echo "ja oder [nein]"
    read -r auswahlOpenSimsetup
    if [ "$auswahlOpenSimsetup" = "" ]; then auswahlOpenSimsetup="nein"; fi

    if [ "$auswahlOpenSimsetup" = "ja" ] || [ "$auswahlOpenSimsetup" = "j" ]
    then
    echo "Bitte warten..."
        # [DataSnapshot]OpenSim.ini
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini DataSnapshot index_sims "\"true\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini DataSnapshot data_exposure "\"minimum\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini DataSnapshot default_snapshot_period "\"7200\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini DataSnapshot snapshot_cache_directory "\"DataSnapshot\""
        
        # [Startup]OpenSim.ini
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini Startup NonPhysicalPrimMax "\"1024\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini Startup AllowScriptCrossing "\"false\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini Startup DefaultDrawDistance "\"128.0\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini Startup MaxDrawDistance "\"128\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini Startup MaxRegionsViewDistance "\"128\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini Startup MinRegionsViewDistance "\"48\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini Startup meshing "\"Meshmerizer\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini Startup physics "\"BulletSim\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini Startup DefaultScriptEngine "\"YEngine\""

        # [AccessControl]OpenSim.ini
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini AccessControl DeniedClients "\"Imprudence|CopyBot|Twisted|Crawler|Cryolife|darkstorm|DarkStorm|Darkstorm|hydrastorm viewer|kinggoon copybot|goon squad copybot|copybot pro|darkstorm viewer|copybot club|darkstorm second life|copybot download|HydraStorm Copybot Viewer|Copybot|Firestorm Pro|DarkStorm v3|DarkStorm v2|ShoopedStorm|HydraStorm|hydrastorm|kinggoon|goon squad|goon|copybot|Shooped|ShoopedStorm|Triforce|Triforce Viewer|Firestorm Professional|ShoopedLife|Sombrero|Sombrero Firestorm|GoonSquad|Solar|SolarStorm\""

        # [Permissions]OpenSim.ini
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini Permissions permissionmodules "\"DefaultPermissionsModule\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini Permissions serverside_object_permissions "\"true\""

        # [Map]OpenSim.ini
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini Map DrawPrimOnMapTile "\"true\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini Map RenderMeshes "\"true\""
        
        # [Permissions]OpenSim.ini
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini Permissions allow_grid_gods "\"true\""
        
        # [Network]OpenSim.ini
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini Network user_agent "\"OpenSim LSL (Mozilla Compatible)\""
        
        # [ClientStack.LindenUDP]OpenSim.ini
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini ClientStack.LindenUDP DisableFacelights "\"true\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini ClientStack.LindenUDP client_throttle_max_bps "\"400000\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini ClientStack.LindenUDP scene_throttle_max_bps "\"70000000\""
        
        # [SimulatorFeatures]/$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini SimulatorFeatures SearchServerURI "\"\$\{Const\|BaseURL\}:\$\{Const\|PublicPort\}\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini SimulatorFeatures DestinationGuideURI "\"\$\{Const\|BaseURL\}:\$\{Const\|PublicPort\}\""
        
        # [InterestManagement]/$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini InterestManagement UpdatePrioritizationScheme "\"BestAvatarResponsiveness\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini InterestManagement ObjectsCullingByDistance "\"true\""
        
        # [Terrain]/$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini Terrain InitialTerrain "\"flat\""
        
        # [UserProfiles]/$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini UserProfiles ProfileServiceURL "\"\$\{Const\|BaseURL\}:\$\{Const\|PublicPort\}\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini UserProfiles AllowUserProfileWebURLs "\"true\""
        
        # [Materials]/$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini Materials enable_materials "\"true\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini Materials MaxMaterialsPerTransaction "\"250\""

        #[XEngine]/$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini XEngine Enabled "false"

        #[YEngine]/$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini XEngine Enabled "true"

        #[Groups]
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini Groups Enabled "true"
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini Groups LevelGroupCreate "0"
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini Groups Module "\"Groups Module V2\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini Groups StorageProvider "OpenSim.Data.MySQL.dll"
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini Groups ServicesConnectorModule "Groups HG Service Connector"
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini Groups LocalService "remote"
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini Groups GroupsServerURI "\$\{Const\|BaseURL\}:\$\{Const\|PrivatePort\}"
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini Groups HomeURI "\$\{Const\|BaseURL\}:\$\{Const\|PublicPort\}"
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini Groups MessagingEnabled "true"
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini Groups MessagingModule "Groups Messaging Module V2"
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini Groups NoticesEnabled "true"
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini Groups MessageOnlineUsersOnly "true"
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini Groups  XmlRpcServiceReadKey "1234"
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini Groups XmlRpcServiceWriteKey "1234"

    fi
if [ "$auswahlOpenSimsetup" = "nein" ]; then echo "weiter..."; fi
}

### ! osslEnable.ini  Test 21.01.2023 geprüft OK
function osslEnablesetup() {
    echo "$lline"
    echo "osslEnable.ini";
    echo "Möchten Sie den osslEnable konfigurieren?"
    echo "ja oder [nein]"
    read -r auswahlosslEnablesetup
    if [ "$auswahlosslEnablesetup" = "" ]; then auswahlosslEnablesetup="nein"; fi

    if [ "$auswahlosslEnablesetup" = "ja" ] || [ "$auswahlosslEnablesetup" = "j" ]
    then
    echo "OpenSimulator Skript Level Einstellungen"
    echo "Weitere Informationen zu diesen Ebenen finden Sie unter http://opensimulator.org/wiki/Threat_level."
    echo "Die flächendeckende Aktivierung der ossl-Funktionen ist gefährlich und wir empfehlen keine höhere Einstellung als [VeryLow]"
    echo "Mögliche Einstellungen sind:  None, [VeryLow], Low, Moderate, High, VeryHigh, Severe."
    read -r SkriptLevel
    if [ "$SkriptLevel" = "" ]; then SkriptLevel="VeryLow"; fi

    #[OSSL]/$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/osslEnable.ini    
    crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/osslEnable.ini OSSL OSFunctionThreatLevel "\"$SkriptLevel\""
    echo "PARCEL_GROUP_MEMBER,PARCEL_OWNER,ESTATE_MANAGER und ESTATE_OWNER freigeben [ja]"
    read -r SkriptOwner
    if [ "$SkriptOwner" = "" ]; then SkriptOwner="ja"; fi

    echo "Bitte warten..."

    if [ "$SkriptOwner" = "ja" ] || [ "$SkriptOwner" = "j" ]
    then
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/osslEnable.ini OSSL osslParcelO "\"PARCEL_OWNER,ESTATE_MANAGER,ESTATE_OWNER,\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/osslEnable.ini OSSL osslParcelOG "\"PARCEL_GROUP_MEMBER,PARCEL_OWNER,ESTATE_MANAGER,ESTATE_OWNER,\"" 
    fi

    echo "
    Allow_osGetAgents =               \${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER
    Allow_osGetAvatarList =           \${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER
    Allow_osGetNPCList =              \${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER
    Allow_osNpcGetOwner =             \${OSSL|osslNPC}
    Allow_osSetSunParam =             ESTATE_MANAGER,ESTATE_OWNER
    Allow_osTeleportOwner =           \${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER
    Allow_osSetEstateSunSettings =    ESTATE_MANAGER,ESTATE_OWNER
    Allow_osSetRegionSunSettings =    ESTATE_MANAGER,ESTATE_OWNER

    Allow_osEjectFromGroup =          \${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER
    Allow_osForceBreakAllLinks =      \${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER
    Allow_osForceBreakLink =          \${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER
    Allow_osGetWindParam =            true
    Allow_osInviteToGroup =           \${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER
    Allow_osReplaceString =           true
    Allow_osSetDynamicTextureData =       \${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER
    Allow_osSetDynamicTextureDataFace =   \${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER
    Allow_osSetDynamicTextureDataBlend =  \${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER
    Allow_osSetDynamicTextureDataBlendFace = \${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER
    Allow_osSetParcelMediaURL =       \${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER
    Allow_osSetParcelMusicURL =       \${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER
    Allow_osSetParcelSIPAddress =     \${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER
    Allow_osSetPrimFloatOnWater =     true
    Allow_osSetWindParam =            \${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER
    Allow_osTerrainFlush =            ESTATE_MANAGER,ESTATE_OWNER
    Allow_osUnixTimeToTimestamp =     true

    Allow_osAvatarName2Key =          \${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER
    Allow_osFormatString =            true
    Allow_osKey2Name =                \${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER
    Allow_osListenRegex =             true
    Allow_osLoadedCreationDate =      \${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER
    Allow_osLoadedCreationID =        \${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER
    Allow_osLoadedCreationTime =      \${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER
    Allow_osMessageObject =           \${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER
    Allow_osRegexIsMatch =            true
    Allow_osGetAvatarHomeURI =        \${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER
    Allow_osNpcSetProfileAbout =      \${OSSL|osslNPC}
    Allow_osNpcSetProfileImage =      \${OSSL|osslNPC}
    Allow_osDie =                     \${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER

    Allow_osDetectedCountry =         \${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER
    Allow_osDropAttachment =          \${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER
    Allow_osDropAttachmentAt =        \${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER
    Allow_osGetAgentCountry =         \${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER
    Allow_osGetGridCustom =           \${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER
    Allow_osGetGridGatekeeperURI =    \${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER
    Allow_osGetGridHomeURI =          \${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER
    Allow_osGetGridLoginURI =         \${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER
    Allow_osGetGridName =             true
    Allow_osGetGridNick =             true
    Allow_osGetNumberOfAttachments =  \${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER
    Allow_osGetRegionStats =          \${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER
    Allow_osGetSimulatorMemory =      \${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER
    Allow_osGetSimulatorMemoryKB =    \${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER
    Allow_osMessageAttachments =      \${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER
    Allow_osReplaceAgentEnvironment = \${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER
    Allow_osSetSpeed =                \${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER
    Allow_osSetOwnerSpeed =           \${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER
    Allow_osRequestURL =              \${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER
    Allow_osRequestSecureURL =        \${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER

    Allow_osCauseDamage =             \${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER
    Allow_osCauseHealing =            \${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER
    Allow_osSetHealth =               \${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER
    Allow_osSetHealRate =             \${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER
    Allow_osForceAttachToAvatar =     \${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER
    Allow_osForceAttachToAvatarFromInventory = \${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER
    Allow_osForceCreateLink =         \${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER
    Allow_osForceDropAttachment =     \${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER
    Allow_osForceDropAttachmentAt =   \${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER
    Allow_osGetLinkPrimitiveParams =  \${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER
    Allow_osGetPhysicsEngineType =    true
    Allow_osGetRegionMapTexture =     \${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER
    Allow_osGetScriptEngineName =     true
    Allow_osGetSimulatorVersion =     true
    Allow_osMakeNotecard =            \${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER
    Allow_osMatchString =             true
    Allow_osNpcCreate =               \${OSSL|osslNPC}
    Allow_osNpcGetPos =               \${OSSL|osslNPC}
    Allow_osNpcGetRot =               \${OSSL|osslNPC}
    Allow_osNpcLoadAppearance =       \${OSSL|osslNPC}
    Allow_osNpcMoveTo =               \${OSSL|osslNPC}
    Allow_osNpcMoveToTarget =         \${OSSL|osslNPC}
    Allow_osNpcPlayAnimation =        \${OSSL|osslNPC}
    Allow_osNpcRemove =               \${OSSL|osslNPC}
    Allow_osNpcSaveAppearance =       \${OSSL|osslNPC}
    Allow_osNpcSay =                  \${OSSL|osslNPC}
    Allow_osNpcSayTo =                \${OSSL|osslNPC}
    Allow_osNpcSetRot =               \${OSSL|osslNPC}
    Allow_osNpcShout =                \${OSSL|osslNPC}
    Allow_osNpcSit =                  \${OSSL|osslNPC}
    Allow_osNpcStand =                \${OSSL|osslNPC}
    Allow_osNpcStopAnimation =        \${OSSL|osslNPC}
    Allow_osNpcStopMoveToTarget =     \${OSSL|osslNPC}
    Allow_osNpcTouch =                \${OSSL|osslNPC}
    Allow_osNpcWhisper =              \${OSSL|osslNPC}
    Allow_osOwnerSaveAppearance =     \${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER
    Allow_osParcelJoin =              ESTATE_MANAGER,ESTATE_OWNER
    Allow_osParcelSubdivide =         ESTATE_MANAGER,ESTATE_OWNER
    Allow_osRegionRestart =           ESTATE_MANAGER,ESTATE_OWNER
    Allow_osRegionNotice =            ESTATE_MANAGER,ESTATE_OWNER
    Allow_osSetProjectionParams =     \${OSSL|osslParcelOG}ESTATE_MANAGER,ESTATE_OWNER
    Allow_osSetRegionWaterHeight =    ESTATE_MANAGER,ESTATE_OWNER
    Allow_osSetTerrainHeight =        ESTATE_MANAGER,ESTATE_OWNER
    Allow_osSetTerrainTexture =       ESTATE_MANAGER,ESTATE_OWNER
    Allow_osSetTerrainTextureHeight = ESTATE_MANAGER,ESTATE_OWNER

    Allow_osAgentSaveAppearance =     ESTATE_MANAGER,ESTATE_OWNER

    Allow_osAvatarPlayAnimation =     false
    Allow_osAvatarStopAnimation =     false
    Allow_osForceAttachToOtherAvatarFromInventory = false
    Allow_osForceDetachFromAvatar =   false
    Allow_osForceOtherSit =           false

    Allow_osGetNotecard =             \${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER
    Allow_osGetNotecardLine =         \${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER
    Allow_osGetNumberOfNotecardLines = \${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER
    Allow_osSetDynamicTextureURL =    ESTATE_MANAGER,ESTATE_OWNER
    Allow_osSetDynamicTextureURLBlend = ESTATE_MANAGER,ESTATE_OWNER
    Allow_osSetDynamicTextureURLBlendFace = ESTATE_MANAGER,ESTATE_OWNER
    Allow_osSetRot  =                 false
    Allow_osSetParcelDetails =        \${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER

    Allow_osConsoleCommand =          false
    Allow_osKickAvatar =              \${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER
    Allow_osTeleportAgent =           \${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER
    Allow_osTeleportObject =          \${OSSL|osslParcelO}ESTATE_MANAGER,ESTATE_OWNER

    Allow_osGetAgentIP =              true   ; always restricted to Administrators (true or false to disable)
    Allow_osSetContentType =          false" >> /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/osslEnable.ini
fi

if [ "$auswahlosslEnablesetup" = "nein" ]; then echo "weiter..."; fi

}

### ! Robust.HG.ini  Test 22.01.2023 geprüft OK
function RobustHGsetup() {
    echo "$lline"
     echo "Robust.HG.ini";
    echo "Möchten Sie Robust Hypergrid konfigurieren?"
    echo "ja oder [nein]"
    read -r auswahlRobustHGsetup
    if [ "$auswahlRobustHGsetup" = "" ]; then auswahlRobustHGsetup="nein"; fi

    if [ "$auswahlRobustHGsetup" = "ja" ] || [ "$auswahlRobustHGsetup" = "j" ]
    then
        echo "Der Name des Grids?"
        read -r osgridname
        echo "Abkürzung des Namens Des Grids?"
        read -r osgridnick

        echo "Bitte warten..."
        #[Const]/$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.HG.ini
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.HG.ini Const BaseURL "\"http://$auswahlipdnssetup\""

        #[AssetService]
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.HG.ini AssetService AllowRemoteDelete "true"

        #[UserAccountService]
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.HG.ini UserAccountService AllowCreateUser "true"
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.HG.ini UserAccountService AllowSetAccount "true"

        #[ServiceList]/$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.HG.ini
        sed -i s/\;\ OfflineIMServiceConnector/OfflineIMServiceConnector/g /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.HG.ini
        sed -i s/\;\ GroupsServiceConnector/GroupsServiceConnector/g /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.HG.ini
        sed -i s/\;\ BakedTextureService/BakedTextureService/g /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.HG.ini
        sed -i s/\;\ UserProfilesServiceConnector/UserProfilesServiceConnector/g /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.HG.ini
        sed -i s/\;\ HGGroupsServiceConnector/HGGroupsServiceConnector/g /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.HG.ini

        #[Hypergrid]/$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.HG.ini
        sed -i s/\;\ HomeURI/HomeURI/g /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.HG.ini
        sed -i s/\;\ GatekeeperURI/GatekeeperURI/g /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.HG.ini
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.HG.ini Hypergrid HomeURI "\"\${Const|BaseURL}:\${Const|PublicPort}\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.HG.ini Hypergrid GatekeeperURI "\"\${Const|BaseURL}:\${Const|PublicPort}\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.HG.ini Hypergrid GatekeeperURIAlias "\"\${Const|BaseURL}:\${Const|PublicPort}\""
        
        #[AccessControl]/$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.HG.ini
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.HG.ini AccessControl DeniedClients "\"Imprudence|CopyBot|Twisted|Crawler|Cryolife|darkstorm|DarkStorm|Darkstorm|hydrastorm viewer|kinggoon copybot|goon squad copybot|copybot pro|darkstorm viewer|copybot club|darkstorm second life|copybot download|HydraStorm Copybot Viewer|Copybot|Firestorm Pro|DarkStorm v3|DarkStorm v2|ShoopedStorm|HydraStorm|hydrastorm|kinggoon|goon squad|goon|copybot|Shooped|ShoopedStorm|Triforce|Triforce Viewer|Firestorm Professional|ShoopedLife|Sombrero|Sombrero Firestorm|GoonSquad|Solar|SolarStorm\""
        
        #[GridService]/$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.HG.ini
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.HG.ini GridService MapTileDirectory "\"./maptiles\""
        
        #[LoginService]/$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.HG.ini
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.HG.ini LoginService MinLoginLevel "0"
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.HG.ini LoginService WelcomeMessage "\"Welcome, Avatar!\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.HG.ini LoginService AllowRemoteSetLoginLevel "false"
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.HG.ini LoginService SearchURL "\"\${Const|BaseURL}:\${Const|PublicPort}/\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.HG.ini LoginService Currency "\"T$\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.HG.ini LoginService ClassifiedFee 0
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.HG.ini LoginService DeniedMacs "\"44ed33b396b10a5c95d04967aff8bd9c|5574234b1336a4523b6acb803737b608\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.HG.ini LoginService DeniedID0s "\"d1fdb346d01a3bda2dcb82322bd88456\""
        
        #[MapImageService]/$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.HG.ini
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.HG.ini MapImageService TilesStoragePath "\"maptiles\""
        
        #[GridInfoService]/$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.HG.ini
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.HG.ini GridInfoService gridname "\"$osgridname\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.HG.ini GridInfoService gridnick "\"$osgridnick"
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.HG.ini GridInfoService welcome "\"\${Const|BaseURL}/\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.HG.ini GridInfoService economy "\"\${Const|BaseURL}/opensim/helper/\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.HG.ini GridInfoService about "\"\${Const|BaseURL}/opensim/helper/\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.HG.ini GridInfoService register "\"\${Const|BaseURL}/opensim/helper/\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.HG.ini GridInfoService help "\"\${Const|BaseURL}/opensim/helper/\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.HG.ini GridInfoService password "\${Const|BaseURL}/opensim/helper/\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.HG.ini GridInfoService gatekeeper "\"\${Const|BaseURL}:\${Const|PublicPort}/\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.HG.ini GridInfoService uas "\"\${Const|BaseURL}:\${Const|PublicPort}/\""
        
        #[GatekeeperService]/$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.HG.ini
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.HG.ini GatekeeperService LocalServiceModule "\"OpenSim.Services.InventoryService.dll:XInventoryService\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.HG.ini GatekeeperService DeniedMacs "\"44ed33b396b10a5c95d04967aff8bd9c|5574234b1336a4523b6acb803737b608\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.HG.ini GatekeeperService DeniedID0s "\"d1fdb346d01a3bda2dcb82322bd88456\""
        
        #[UserAgentService]/$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.HG.ini
        #;LevelOutsideContacts = 0
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.HG.ini UserAgentService LevelOutsideContacts "0"
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.HG.ini UserAgentService ShowUserDetailsInHGProfile "\"true\""

        #[AuthenticationService]/$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.HG.ini
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.HG.ini AuthenticationService AllowGetAuthInfo "\"true\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.HG.ini AuthenticationService AllowSetAuthInfo "\"true\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.HG.ini AuthenticationService AllowSetPassword "\"true\""
      
        #[UserProfilesService]/$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.HG.ini
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.HG.ini UserProfilesService Enabled "\"true\""

        #[HGInventoryService]
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.HG.ini HGInventoryService LocalServiceModule "\"OpenSim.Services.InventoryService.dll:XInventoryService\""

        #[Groups]
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.HG.ini Groups MaxAgentGroups "50"
    fi
if [ "$auswahlRobustHGsetup" = "nein" ]; then echo "weiter..."; fi
}
### ! Robust.ini  Test 22.01.2023 geprüft OK
function Robustsetup() {
    echo "$lline"
     echo "Robust.ini";
    echo "Möchten Sie Robust konfigurieren?"
    echo "ja oder [nein]"
    read -r auswahlRobustsetup
    if [ "$auswahlRobustsetup" = "" ]; then auswahlRobustsetup="nein"; fi

    if [ "$auswahlRobustsetup" = "ja" ] || [ "$auswahlRobustsetup" = "j" ]
    then
    echo "Bitte warten..."
        #[ServiceList]/$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.ini
        #sed -i s/Anton/Berta/g /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.ini
        sed -i s/\;\ OfflineIMServiceConnector/OfflineIMServiceConnector/g /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.ini
        sed -i s/\;\ GroupsServiceConnector/GroupsServiceConnector/g /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.ini
        sed -i s/\;\ BakedTextureService/BakedTextureService/g /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.ini
        sed -i s/\;\ UserProfilesServiceConnector/UserProfilesServiceConnector/g /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.ini
    fi
if [ "$auswahlRobustsetup" = "nein" ]; then echo "weiter..."; fi
}


### ! IP oder DNS in die Konfigurationen schreiben  Test 22.01.2023 geprüft OK
function ipdnssetup() {
    echo "$lline"
    
    echo "Möchten Sie den Konfigurationen ihre IP oder DNS Adresse eintragen?"
    echo "ja oder [nein]"
    read -r auswahlipdnssetup
    if [ "$auswahlipdnssetup" = "" ]; then auswahlipdnssetup="nein"; fi

    if [ "$auswahlipdnssetup" = "ja" ] || [ "$auswahlipdnssetup" = "j" ]
    then
        #auswahlipdnssetup="$AKTUELLEIP" # Vorgabe ExterneIP
        echo "Geben Sie ihre IP Adresse ($AKTUELLEIP) oder ihre DNS (meingrid.de) ein:"
        read -r auswahlipdnssetup

        echo "Bitte warten..."

        echo "Robust.ini"
        #[Const]Robust.ini
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.ini Const BaseURL "\"$auswahlipdnssetup\""

        echo "Robust.HG.ini"
        #[Const]Robust.HG.ini
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.HG.ini Const BaseURL "\"$auswahlipdnssetup\""

        echo "OpenSim.ini"
        # [Const]OpenSim.ini
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini Const BaseHostname "\"$auswahlipdnssetup\""
        # [DataSnapshot]/$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini DataSnapshot gridname "\"$auswahlipdnssetup\""
    fi
if [ "$auswahlipdnssetup" = "nein" ]; then echo "weiter..."; fi
}

### ! GridCommon.ini und StandaloneCommon.ini Const anlegen  Test 22.01.2023 geprüft OK
function constsetup() {
    echo "$lline"
    
    echo "Möchten Sie die fehlenden Const bereiche in den GridCommon und StandaloneCommon eintragen?"
    echo "ja oder [nein]"
    read -r auswahlconstsetup
    if [ "$auswahlconstsetup" = "" ]; then auswahlconstsetup="nein"; fi

    if [ "$auswahlconstsetup" = "ja" ] || [ "$auswahlconstsetup" = "j" ]
    then
    echo "GridCommon.ini Const anlegen"

    # Prüfen ob Const vorhanden ist:
    CONSTOK=$(crudini --get /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/GridCommon.ini Const)

    # Const ist vorhanden
    if [ "$CONSTOK" = "Const" ]
    then
        echo "Nur die neue IP/DNS eintragen"
        echo "Bitte warten..."
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/GridCommon.ini Const BaseURL "\"$auswahlipdnssetup\""
    fi
    # Const ist nicht vorhanden
    if [ "$CONSTOK" = "" ]
    then
    echo "Bitte warten..."
        echo "Const neu anlegen am anfang der GridCommon.ini"
        sed -i '1s/.*$/\[Const\]\n&/g' /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/GridCommon.ini
        sed -i '2s/.*$/BaseURL = "http:\/\/'"\"$auswahlipdnssetup\""'"\n&/g' /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/GridCommon.ini
        sed -i '3s/.*$/PublicPort = "8002"\n&/g' /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/GridCommon.ini
        sed -i '4s/.*$/PrivatePort = "8003"\n&/g' /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/GridCommon.ini
        sed -i '5s/.*$/PrivURL = "$\{Const|BaseURL}"\n&/g' /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/GridCommon.ini
        sed -i '6s/.*$/\n&/g' /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/GridCommon.ini
    fi

    echo "StandaloneCommon.ini Const anlegen"
    
    # Prüfen ob Const vorhanden ist:
    CONSTOK=$(crudini --get /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/StandaloneCommon.ini Const)

    # Const ist vorhanden
    if [ "$CONSTOK" = "Const" ]
    then
        echo "Nur die neue IP/DNS eintragen"
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/StandaloneCommon.ini Const BaseURL "\"$auswahlipdnssetup\""
    fi
    # Const ist nicht vorhanden
    if [ "$CONSTOK" = "" ]
    then
    echo "Bitte warten..."
        echo "Const neu anlegen am anfang der StandaloneCommon.ini"
        sed -i '1s/.*$/\[Const\]\n&/g' /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/StandaloneCommon.ini
        sed -i '2s/.*$/BaseURL = "http:\/\/'"\"$auswahlipdnssetup\""'"\n&/g' /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/StandaloneCommon.ini
        sed -i '3s/.*$/PublicPort = "8002"\n&/g' /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/StandaloneCommon.ini
        sed -i '4s/.*$/PrivatePort = "8003"\n&/g' /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/StandaloneCommon.ini
        sed -i '5s/.*$/PrivURL = "$\{Const|BaseURL}"\n&/g' /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/StandaloneCommon.ini
        sed -i '6s/.*$/\n&/g' /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/StandaloneCommon.ini
    fi
    fi
if [ "$auswahlconstsetup" = "nein" ]; then echo "weiter..."; fi
}
### ! StandaloneCommon.ini
function StandaloneCommonsetup() {
    echo "$lline"
     echo "StandaloneCommon.ini";
    echo "Möchten Sie StandaloneCommon einstellen?"
    echo "ja oder [nein]"
    read -r auswahlStandaloneCommon
    if [ "$auswahlStandaloneCommon" = "" ]; then auswahlStandaloneCommon="nein"; fi

    if [ "$auswahlStandaloneCommon" = "ja" ] || [ "$auswahlStandaloneCommon" = "j" ]
    then
    echo "Bitte warten..."
        # [Hypergrid]/$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/StandaloneCommon.ini
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/StandaloneCommon.ini Hypergrid GatekeeperURI "\"\$\{Const\|BaseURL\}:\$\{Const\|PublicPort\}\""
        # [Modules]/$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/StandaloneCommon.ini
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/StandaloneCommon.ini Modules AuthorizationServices "\"RemoteAuthorizationServicesConnector\""
        # [GridService]/$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/StandaloneCommon.ini
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/StandaloneCommon.ini GridService AllowHypergridMapSearch "\"true\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/StandaloneCommon.ini GridService MapTileDirectory "\"./maptiles\""
        # [HGInventoryAccessModule]/$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/StandaloneCommon.ini
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/StandaloneCommon.ini HGInventoryAccessModule HomeURI "\"\$\{Const\|BaseURL\}:\$\{Const\|PublicPort\}\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/StandaloneCommon.ini HGInventoryAccessModule Gatekeeper "\"\$\{Const\|BaseURL\}:\$\{Const\|PublicPort\}\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/StandaloneCommon.ini HGInventoryAccessModule RestrictInventoryAccessAbroad "\"false\""
        # [HGFriendsModule]/$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/StandaloneCommon.ini
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/StandaloneCommon.ini HGFriendsModule LevelHGFriends "0;"
    fi
if [ "$auswahlStandaloneCommon" = "nein" ]; then echo "weiter..."; fi
}

### ! GridCommon.ini  Test 22.01.2023 geprüft OK
function GridCommonsetup() {
    echo "$lline"
     echo "GridCommon.ini";
    echo "Möchten Sie GridCommon einstellen?"
    echo "ja oder [nein]"
    read -r auswahlGridCommon
    if [ "$auswahlGridCommon" = "" ]; then auswahlGridCommon="nein"; fi

    if [ "$auswahlGridCommon" = "ja" ] || [ "$auswahlGridCommon" = "j" ]
    then
    echo "Bitte warten..."
        # [Hypergrid]GridCommon.ini
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/GridCommon.ini Hypergrid GatekeeperURI "\"\$\{Const\|BaseURL\}:\$\{Const\|PublicPort\}\""
        # [Modules]GridCommon.ini
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/GridCommon.ini Modules AuthorizationServices "\"RemoteAuthorizationServicesConnector\""
        # [GridService]GridCommon.ini
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/GridCommon.ini GridService AllowHypergridMapSearch "\"true\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/GridCommon.ini GridService MapTileDirectory "\"./maptiles\""
        # [HGInventoryAccessModule]GridCommon.ini
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/GridCommon.ini HGInventoryAccessModule HomeURI "\"\$\{Const\|BaseURL\}:\$\{Const\|PublicPort\}\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/GridCommon.ini HGInventoryAccessModule Gatekeeper "\"\$\{Const\|BaseURL\}:\$\{Const\|PublicPort\}\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/GridCommon.ini HGInventoryAccessModule RestrictInventoryAccessAbroad "\"false\""
        # [HGFriendsModule]GridCommon.ini
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/GridCommon.ini HGFriendsModule LevelHGFriends "0;"
    fi
if [ "$auswahlGridCommon" = "nein" ]; then echo "weiter..."; fi
}

### ! LaunchSLClient.ini Test 21.01.2023 OK
function LaunchSLClientsetup() {
    echo "$lline"
     echo "LaunchSLClient.ini";
    echo "Möchten Sie LaunchSLClient einstellen?"
    echo "ja oder [nein]"
    read -r auswahlLaunchSLClient
    if [ "$auswahlLaunchSLClient" = "" ]; then auswahlLaunchSLClient="nein"; fi

    if [ "$auswahlLaunchSLClient" = "ja" ] || [ "$auswahlLaunchSLClient" = "j" ]
    then
    echo "Bitte warten..."
        # [OSGrid]LaunchSLClient.ini
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/LaunchSLClient.ini "$auswahlipdnssetup"
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/LaunchSLClient.ini "$auswahlipdnssetup" loginURI "http://$auswahlipdnssetup:8002/"
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/LaunchSLClient.ini "$auswahlipdnssetup" URL "$auswahlipdnssetup"
    fi
if [ "$auswahlLaunchSLClient" = "nein" ]; then echo "weiter..."; fi
}

### ! Datenbank sqlite oder mysql  Test 22.01.2023 geprüft OK
function databasesetup() {
    echo "$lline"
    
    echo "Möchten Sie ihre Datenbank für mysql einstellen?"
    echo "ja für mysql oder [nein] für sqlite"
    read -r auswahldatabasesetup
    if [ "$auswahldatabasesetup" = "" ]; then auswahldatabasesetup="nein"; fi

    if [ "$auswahldatabasesetup" = "ja" ] || [ "$auswahldatabasesetup" = "j" ]
    then
        # [DatabaseService] mysql oder sqlite
        echo "Bei der Datenbank hat man 2 möglichkeiten sqlite oder mysql/mariaDB"
        echo "Bei einem Grid muss Robust mit mysql/mariaDB laufen wärend der Opensimulator mit sqlite laufen kann."
        echo "Ich empfehle den kompletten betrieb mit mysql/mariaDB"
        echo "Möchten sie SQlite nutzen [nein]"
        read -r auswahlmysql

        echo "Bitte geben sie den Ort ihrer Datenbank an [localhost]:"
        read -r auswahlsource
        echo "Bitte geben sie den Datenbanknamen an [opensim]:"
        read -r auswahldatabase
        echo "Bitte geben sie den Benutzernamen ihrer Datenbank an [opensim]:"
        read -r auswahluserid
        echo "Bitte geben sie das Passwort ihrer Datenbank an [opensim]:"
        read -r auswahlpassword

        echo "Bitte warten..."

        if [ "$auswahlmysql" = "" ]; then auswahlmysql="nein"; fi
        if [ "$auswahlsource" = "" ]; then Source="localhost"; fi
        if [ "$auswahldatabase" = "" ]; then Database="opensim"; fi
        if [ "$auswahluserid" = "" ]; then User_ID="opensim"; fi
        if [ "$auswahlpassword" = "" ]; then Password="opensim"; fi

        # GridCommon.ini Robust.HG.ini Robust.ini
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.ini DatabaseService StorageProvider "\"OpenSim.Data.MySQL.dll\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.ini DatabaseService ConnectionString "\"Data Source=$auswahlsource;Database=$auswahldatabase;User ID=$auswahluserid;Password=$auswahlpassword;Old Guids=true;SslMode=None;\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.HG.ini DatabaseService StorageProvider "\"OpenSim.Data.MySQL.dll\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.HG.ini DatabaseService ConnectionString "\"Data Source=$auswahlsource;Database=$auswahldatabase;User ID=$auswahluserid;Password=$auswahlpassword;Old Guids=true;SslMode=None;\""

        # Wird mysql/mariaDB ausgewählt dann ändern
        if [ "$auswahlmysql" = "ja" ] || [ "$auswahlmysql" = "j" ]
        then
        # SQlite kommentieren
        sed -i s/Include-Storage = \"config-include/storage/SQLiteStandalone.ini\"\;/\;Include-Storage = \"config-include/storage/SQLiteStandalone.ini\"\;/g /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/GridCommon.ini
        # mysql/mariaDB eintragen
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/GridCommon.ini DatabaseService StorageProvider "\"OpenSim.Data.MySQL.dll\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/GridCommon.ini DatabaseService ConnectionString = "\"Data Source=$Source;Database=$Database;User ID=$User_ID;Password=$Password;Old Guids=true;SslMode=None;\""
        else
        echo "SQlite wird beibehalten"
        fi

    fi
if [ "$auswahldatabasesetup" = "nein" ]; then echo "weiter..."; fi
}

### ! Region Konfigurationen schreiben  Test 22.01.2023 geprüft OK
function regionconfig() {
    echo "$lline"
    echo "Möchten Sie ihre Region Konfigurationen erstellen?"
    echo "ja oder [nein]"
    read -r auswahlregioncon
    if [ "$auswahlregioncon" = "" ]; then auswahlregioncon="nein"; fi

    if [ "$auswahlregioncon" = "ja" ] || [ "$auswahlregioncon" = "j" ]
    then
        
        echo "Bitte geben sie einen Regionsnamen ein für ihre Start-Welcome-Center Region [WelcomeCenter]"
        read -r regionsname
        echo "Bitte geben sie die Größe ihrer Region an [256]:"
        read -r size
        echo "Bitte geben sie den Ort ihrer Region an [1000,1000]:"
        read -r location
        echo "Soll diese Region als Default Startregion genutzt werden:"
        read -r Defaultregion

        echo "Bitte warten..."

        if [ "$regionsname" = "" ]; then regionsname="WelcomeCenter"; fi
        if [ "$size" = "" ]; then size="256"; fi
        if [ "$location" = "" ]; then location="1000,1000"; fi

        if [ "$Defaultregion" = "ja" ] || [ "$Defaultregion" = "j" ]
        then
        # [GridService] Robust.HG.ini   # ; Region_Welcome_Area = "DefaultRegion, DefaultHGRegion"
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.HG.ini GridService Region_"$regionsname" "\"DefaultRegion, DefaultHGRegion\""
        fi

        UUID=$(uuidgen)
        #[Regionsname]/$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Regions.ini
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Regions.ini "$regionsname"
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Regions.ini "$regionsname" RegionUUID "\"$UUID\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Regions.ini "$regionsname" Location "\"$location\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Regions.ini "$regionsname" SizeX "\"$size\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Regions.ini "$regionsname" SizeY "\"$size\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Regions.ini "$regionsname" SizeZ "\"$size\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Regions.ini "$regionsname" InternalAddress "\"0.0.0.0\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Regions.ini "$regionsname" InternalPort "\"9100\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Regions.ini "$regionsname" ResolveAddress "\"False\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Regions.ini "$regionsname" ExternalHostName "\"$auswahlipdnssetup\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Regions.ini "$regionsname" MaptileStaticUUID "\"$UUID\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Regions.ini "$regionsname" DefaultLanding "\"<128,128,25>\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Regions.ini "$regionsname" \;MaxPrimsPerUser "\"-1\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Regions.ini "$regionsname" \;ScopeID "\"$UUID\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Regions.ini "$regionsname" \;RegionType "\"Mainland\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Regions.ini "$regionsname" \;MapImageModule "\"Warp3DImageModule\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Regions.ini "$regionsname" \;TextureOnMapTile "\"true\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Regions.ini "$regionsname" \;DrawPrimOnMapTile "\"true\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Regions.ini "$regionsname" \;GenerateMaptiles "\"true\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Regions.ini "$regionsname" \;MaptileRefresh "\"0\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Regions.ini "$regionsname" \;MaptileStaticFile "\"water-logo-info.png"\"
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Regions.ini "$regionsname" \;MasterAvatarFirstName "\"John\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Regions.ini "$regionsname" \;MasterAvatarLastName "\"Doe\""
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Regions.ini "$regionsname" \;MasterAvatarSandboxPassword "\"passwd\""
        #[GridService]/$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.HG.ini Region als Default eintragen.
        #crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.HG.ini GridService Region_"$regionsname" "\"DefaultRegion, DefaultHGRegion\""
    fi
if [ "$auswahlregioncon" = "nein" ]; then echo "weiter..."; fi
}

### ! Hypergrid Konfigurationen schreiben  Test 22.01.2023 geprüft OK
function hypergridsetup() {
    echo "$lline"
    echo "Möchten Sie ihre OpenSim/Grid Konfigurationen erstellen?"
    echo "ja oder [nein]"
    read -r auswahlhypergrid
    if [ "$auswahlhypergrid" = "" ]; then auswahlhypergrid="nein"; fi

    if [ "$auswahlhypergrid" = "ja" ] || [ "$auswahlhypergrid" = "j" ]
    then
        echo " "; echo " "
        echo "Möchten Sie ein Eigenständiges Grid"
        echo "oder eine OpenSimulator Region mit Reisemöglichkeit zu anderen Grids?"
        echo "dann tippen sie [hggrid] oder hgos ein."
        echo " "
        echo "Wenn, sie kein Hypergrid möchten,"
        echo "sondern lieber in sichere Umgebung ihres Netzwerkes agieren?"
        echo "dann geben sie grid oder os ein."
        read -r auswahlhg
        if [ "$auswahlhg" = "" ]; then auswahlhg="hggrid"; fi

        if [ "$auswahlhg" = "hggrid" ]
        then
        echo "Bitte warten..."
        # PublicPort = "8002"
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini Const PublicPort "\"8002\""
        # Network http_listener_port = "9000"
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini Network http_listener_port "\"9010\""
        # Include-Architecture "config-include/GridHypergrid.ini"
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini Architecture Include-Architecture "\"config-include/GridHypergrid.ini\""
        # [XBakes]
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini XBakes URL "\"\$\{Const\|BaseURL\}:\$\{Const\|PrivatePort\}\""
        fi

        if [ "$auswahlhg" = "hgos" ]
        then
        echo "Bitte warten..."
        # PublicPort = "9000" besser 9010 weil 9000 und 9001 belegt sein könnten
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini Const PublicPort "\"9010\""
        # Include-Architecture "config-include/StandaloneHypergrid.ini"
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini Architecture Include-Architecture "\"config-include/StandaloneHypergrid.ini\""
        fi

        if [ "$auswahlhg" = "grid" ]
        then
        echo "Bitte warten..."
        # PublicPort = "8002"
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini Const PublicPort "\"8002\""
        # Network http_listener_port = "9000"
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini Network http_listener_port "\"9010\""
        # Include-Architecture "config-include/Grid.ini"
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini Architecture Include-Architecture "\"config-include/Grid.ini\""
        # [XBakes]
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini XBakes URL "\"\$\{Const\|BaseURL\}:\$\{Const\|PrivatePort\}\""
        fi

        if [ "$auswahlhg" = "os" ]
        then
        echo "Bitte warten..."
        # PublicPort = "9000" besser 9010 weil 9000 und 9001 belegt sein könnten
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini Const PublicPort "\"9010\""
        # Include-Architecture "config-include/Standalone.ini"
        crudini --set /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini Architecture Include-Architecture "\"config-include/Standalone.ini\"" 
        fi

    fi
if [ "$auswahlhypergrid" = "nein" ]; then echo "weiter..."; fi
}

### ! Messaging Konfigurationen schreiben
function Messagingsetup() {
    echo "$lline"
    echo "Möchten Sie ihre Offline Nachrichten Konfigurieren?"
    echo "ja oder [nein]"
    read -r auswahlMessagingsetup
    if [ "$auswahlMessagingsetup" = "" ]; then auswahlMessagingsetup="nein"; fi

    if [ "$auswahlMessagingsetup" = "ja" ] || [ "$auswahlMessagingsetup" = "j" ]
    then
    echo "Bitte warten..."
    # [Messaging]OpenSim.ini
    OfflineMessageModule="; OfflineMessageModule = OfflineMessageModule"
    newOfflineMessageModule="OfflineMessageModule = OfflineMessageModule"
    sed -i s/"$OfflineMessageModule"/"$newOfflineMessageModule"/g /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini
    OfflineMessageURL="; OfflineMessageURL = \${Const|PrivURL}:\${Const|PrivatePort}"
    newOfflineMessageURL="OfflineMessageURL = \${Const|PrivURL}:\${Const|PrivatePort}"
    sed -i s/"$OfflineMessageURL"/"$newOfflineMessageURL"/g /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini
    sed -i s/\;\ StorageProvider/StorageProvider/g /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini
    sed -i s/\;\ MuteListModule/MuteListModule/g /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini
    sed -i s/\;\ ForwardOfflineGroupMessages/ForwardOfflineGroupMessages/g /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini
    fi

    if [ "$auswahlMessagingsetup" = "nein" ]; then echo "weiter..."; fi
}

### ! Kommentare aus den Hauptkonfigurationen löschen.
function deletecomments() {
    echo "$lline"
    echo "Möchten Sie alle Kommentare in ihren Hauptkonfigurationen löschen?"
    echo "ja oder [nein]"
    read -r auswahldelcomments
    if [ "$auswahldelcomments" = "" ]; then auswahldelcomments="nein"; fi

    if [ "$auswahldelcomments" = "ja" ] || [ "$auswahldelcomments" = "j" ]
    then
        echo "Löschen aller kommentare in einer ini Konfiguration."
        sed -i -e '/^;/d;/^\s*$/d' /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Estates.ini
        sed -i -e '/^;/d;/^\s*$/d' /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/FlotsamCache.ini
        sed -i -e '/^;/d;/^\s*$/d' /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/GridCommon.ini
        sed -i -e '/^;/d;/^\s*$/d' /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/MoneyServer.ini
        sed -i -e '/^;/d;/^\s*$/d' /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/OpenSim.ini
        sed -i -e '/^;/d;/^\s*$/d' /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/osslEnable.ini
        sed -i -e '/^;/d;/^\s*$/d' /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.HG.ini
        sed -i -e '/^;/d;/^\s*$/d' /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/Robust.ini
        sed -i -e '/^;/d;/^\s*$/d' /$STARTVERZEICHNIS/$CONFIGVERZEICHNIS/StandaloneCommon.ini
    fi
}

# Programmablauf: Funktionen aufrufen
linstall
configcopy
configsetup
ipdnssetup
constsetup
GridCommonsetup
hypergridsetup
databasesetup
Estatessetup
FlotsamCachesetup
MoneyServersetup
OpenSimsetup
osslEnablesetup
RobustHGsetup
Robustsetup
StandaloneCommonsetup
LaunchSLClientsetup
regionconfig
Messagingsetup
deletecomments



echo "$lline"
echo "Das konfigurieren mit configure, können sie so oft wiederholen, wie sie möchten."
echo "Als nächstes müssen sie die Robust.exe starten und \"create avatar\" eingeben."
echo "Anschließend werden sie abgefragt, wichtig sind nur Vorname, Nachname, Passwort und ihre E-Mail Adresse,"
echo "bei einem upgrade mit vorhandener Datenbank, benötigen sie noch die Original UUID ihres alten Avatars."
echo "Bitte Notieren sie alle Informationen sorgfältig und bewahren sie diese sicher auf."
echo "Optional könnten sie direkt einen Banker Avatar erstellen."
echo "$lline"

# Sollte keine IP oder DNS eingetragen sein, dann 127.0.0.1, damit das nicht leer bleibt und dort nicht "nein" steht.
if [ "$auswahlipdnssetup" = "" ] || [ "$auswahlipdnssetup" = "nein" ]; then auswahlipdnssetup="127.0.0.1"; fi
echo "So melden Sie sich in ihrem Grid oder OpenSimulator an"
echo "Falls ihr Viewer ihre Grid-Manager-Einstellungen nicht eingetragen hat:"
echo " "
echo "Grid"
echo "loginURI http://$auswahlipdnssetup:8002/"
echo "URL $auswahlipdnssetup"
echo " "
echo "oder"
echo " "
echo "OpenSimulator"
echo "loginURI http://$auswahlipdnssetup:9000/"
echo "URL $auswahlipdnssetup"

# TODO

















# Zum schluss müssen alle Konfigurationen, an ihren richtigen Platz kopiert werden.
