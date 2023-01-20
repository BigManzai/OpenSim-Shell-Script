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

#? Der nachteil dieser art von konfiguration ist, das die Zeilen keine leerzeichen und Tabs am anfang haben dürfen.
# Variables
STARTVERZEICHNIS="opt";

SCRIPTNAME="configure" # Versionsausgabe
VERSION="0.1.6 ALPHA" # Versionsausgabe
tput reset # Bildschirmausgabe loeschen inklusive dem Scrollbereich.
echo "$SCRIPTNAME Version $VERSION"
echo " "
### Aktuelle IP ueber Suchadresse ermitteln und Ausfuehrungszeichen anhaengen.
SEARCHADRES="icanhazip.com"
AKTUELLEIP='"'$(wget -O - -q $SEARCHADRES)'"'
echo "Ihre aktuelle externe IP ist $AKTUELLEIP"
echo " "
echo "ABBRUCH MIT DER TASTENKOMBINATION"
echo "########  STRG + C  #############"
echo " "; echo " ";
# echo "Möchten sie die automatische konfiguration starten?"
# echo "ja oder [nein]"
# read -r starten
# if [ "$starten" = "" ]; then starten="nein"; fi

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

#* crudini schreibt nur in dateien die keine Leerzeichen am anfang enthalten.

### ! Linux Installation
function linstall() {
echo "Möchten sie ihren Ubuntu 18 oder 22 Server vorbereitet, für die verwendung des OpenSimulator?"
echo "Tippen sie nein ja um die benötigten Server Komponenten zu Installieren."
echo "Bitte tippen Sie ja oder [nein] ein:"
read -r auswahllinstall
if [ "$auswahllinstall" = "" ]; then auswahllinstall="nein"; fi

if [ "$auswahllinstall" = "ja" ]
    then 
        cd /$STARTVERZEICHNIS || exit
        echo "Server wird installation wird gestartet..."
        /$STARTVERZEICHNIS/opensim.sh AutoInstall
    fi
if [ "$auswahllinstall" = "nein" ]; then echo "weiter..."; fi
}

### ! Konfigurationen vorbereiten für weitere verarbeitungen
function configsetup() {
echo "Möchten Sie ihre Konfigurationen vorbereiten für die weitere verarbeitung?"
echo "Keine Angst die Originaldateien werden als *.backup gesichert."
echo "ja oder [nein]"
read -r auswahlconfigsetup
if [ "$auswahlconfigsetup" = "" ]; then auswahlconfigsetup="nein"; fi

if [ "$auswahlconfigsetup" = "ja" ] 
then
    # INI Datei von Leerzeichen und Tabs am anfang des Textes befreien.
    # sed TAB = \t
    sed -i.backup -re 's#^ +## ; s#^\t+##' /$STARTVERZEICHNIS/AutoConfig/Estates.ini.example
    sed -i.backup -re 's#^ +## ; s#^\t+##' /$STARTVERZEICHNIS/AutoConfig/FlotsamCache.ini.example
    sed -i.backup -re 's#^ +## ; s#^\t+##' /$STARTVERZEICHNIS/AutoConfig/Grid.ini
    sed -i.backup -re 's#^ +## ; s#^\t+##' /$STARTVERZEICHNIS/AutoConfig/GridCommon.ini.example
    sed -i.backup -re 's#^ +## ; s#^\t+##' /$STARTVERZEICHNIS/AutoConfig/GridHypergrid.ini
    sed -i.backup -re 's#^ +## ; s#^\t+##' /$STARTVERZEICHNIS/AutoConfig/LaunchSLClient.ini
    sed -i.backup -re 's#^ +## ; s#^\t+##' /$STARTVERZEICHNIS/AutoConfig/MoneyServer.ini.example
    sed -i.backup -re 's#^ +## ; s#^\t+##' /$STARTVERZEICHNIS/AutoConfig/OpenSim.ConsoleClient.ini.example
    sed -i.backup -re 's#^ +## ; s#^\t+##' /$STARTVERZEICHNIS/AutoConfig/OpenSim.ini.example
    sed -i.backup -re 's#^ +## ; s#^\t+##' /$STARTVERZEICHNIS/AutoConfig/OpenSimDefaults.ini
    sed -i.backup -re 's#^ +## ; s#^\t+##' /$STARTVERZEICHNIS/AutoConfig/osslDefaultEnable.ini
    sed -i.backup -re 's#^ +## ; s#^\t+##' /$STARTVERZEICHNIS/AutoConfig/osslEnable.ini.example
    sed -i.backup -re 's#^ +## ; s#^\t+##' /$STARTVERZEICHNIS/AutoConfig/pCampBot.ini.example
    sed -i.backup -re 's#^ +## ; s#^\t+##' /$STARTVERZEICHNIS/AutoConfig/Regions.ini.example
    sed -i.backup -re 's#^ +## ; s#^\t+##' /$STARTVERZEICHNIS/AutoConfig/Robust.HG.ini.example
    sed -i.backup -re 's#^ +## ; s#^\t+##' /$STARTVERZEICHNIS/AutoConfig/Robust.ini.example
    sed -i.backup -re 's#^ +## ; s#^\t+##' /$STARTVERZEICHNIS/AutoConfig/Robust.Tests.ini
    sed -i.backup -re 's#^ +## ; s#^\t+##' /$STARTVERZEICHNIS/AutoConfig/SQLiteStandalone.ini
    sed -i.backup -re 's#^ +## ; s#^\t+##' /$STARTVERZEICHNIS/AutoConfig/Standalone.ini
    sed -i.backup -re 's#^ +## ; s#^\t+##' /$STARTVERZEICHNIS/AutoConfig/StandaloneCommon.ini.example
    sed -i.backup -re 's#^ +## ; s#^\t+##' /$STARTVERZEICHNIS/AutoConfig/StandaloneHypergrid.ini

    # Jetzt werden die wichtigen Dateien umkopiert von *.ini.example in *.ini
    cp /$STARTVERZEICHNIS/AutoConfig/Estates.ini.example /$STARTVERZEICHNIS/AutoConfig/Estates.ini
    cp /$STARTVERZEICHNIS/AutoConfig/FlotsamCache.ini.example /$STARTVERZEICHNIS/AutoConfig/FlotsamCache.ini
    cp /$STARTVERZEICHNIS/AutoConfig/GridCommon.ini.example /$STARTVERZEICHNIS/AutoConfig/GridCommon.ini
    cp /$STARTVERZEICHNIS/AutoConfig/MoneyServer.ini.example /$STARTVERZEICHNIS/AutoConfig/MoneyServer.ini
    cp /$STARTVERZEICHNIS/AutoConfig/OpenSim.ini.example /$STARTVERZEICHNIS/AutoConfig/OpenSim.ini
    cp /$STARTVERZEICHNIS/AutoConfig/osslEnable.ini.example /$STARTVERZEICHNIS/AutoConfig/osslEnable.ini
    cp /$STARTVERZEICHNIS/AutoConfig/Robust.HG.ini.example /$STARTVERZEICHNIS/AutoConfig/Robust.HG.ini
    cp /$STARTVERZEICHNIS/AutoConfig/Robust.ini.example /$STARTVERZEICHNIS/AutoConfig/Robust.ini
    cp /$STARTVERZEICHNIS/AutoConfig/StandaloneCommon.ini.example /$STARTVERZEICHNIS/AutoConfig/StandaloneCommon.ini
    fi
if [ "$auswahlconfigsetup" = "nein" ]; then echo "weiter..."; fi
}

### ! Estates.ini
function Estatessetup() {
    echo "Möchten Sie ihre Estates vorgeben?"
    echo "ja oder [nein]"
    read -r auswahlEstatessetup
    if [ "$auswahlEstatessetup" = "" ]; then auswahlEstatessetup="nein"; fi

    if [ "$auswahlEstatessetup" = "ja" ]
    then
        echo " "; echo " ";
        UUID=$(uuidgen)
        echo "Estates.ini"
        echo "Estate Name eingeben [Example Estate]"
        read -r Example_Estate
        echo "Benutzer UUID eingeben [$UUID]"
        read -r Owner
        echo "Estate ID eingeben [0]"
        read -r EstateID

        if [ "$Example_Estate" = "" ]; then Example_Estate="Example Estate"; fi
        if [ "$Owner" = "" ]; then Owner="$UUID"; fi
        if [ "$EstateID" = "" ]; then EstateID="0"; fi

        crudini --set /$STARTVERZEICHNIS/AutoConfig/Estates.ini "$Example_Estate"
        crudini --set /$STARTVERZEICHNIS/AutoConfig/Estates.ini "$Example_Estate" Owner "\"$Owner\""
        crudini --set /$STARTVERZEICHNIS/AutoConfig/Estates.ini "$Example_Estate" EstateID "\"$EstateID\""
    fi
if [ "$auswahlEstatessetup" = "nein" ]; then echo "weiter..."; fi
}
### ! FlotsamCache.ini
function FlotsamCachesetup() {
    echo " "; echo " ";
    echo "Möchten Sie Flotsam Cache einstellen?"
    echo "ja oder [nein]"
    read -r auswahlFlotsamCachesetup
    if [ "$auswahlFlotsamCachesetup" = "" ]; then auswahlFlotsamCachesetup="nein"; fi

    if [ "$auswahlFlotsamCachesetup" = "ja" ]
    then
        echo "FlotsamCache.ini"
        echo "Wie oft in Stunden soll die Festplatte auf abgelaufene Dateien überprüft werden?"
        echo "Geben Sie 0 an, um die Ablaufprüfung zu deaktivieren [24.0]"
        read -r FlotsamTime
        if [ "$FlotsamTime" = "" ]; then FlotsamTime="24.0"; fi
        #[AssetCache]FlotsamCache.ini
        crudini --set /$STARTVERZEICHNIS/AutoConfig/FlotsamCache.ini AssetCache FileCleanupTimer "\"$FlotsamTime\""
    fi
if [ "$auswahlFlotsamCachesetup" = "nein" ]; then echo "weiter..."; fi
}
### ! MoneyServer.ini
function MoneyServersetup() {
    echo " "; echo " "; echo "MoneyServer.ini";
    echo "Möchten Sie den Money Server konfigurieren?"
    echo "ja oder [nein]"
    read -r auswahlMoneyServersetup
    if [ "$auswahlMoneyServersetup" = "" ]; then auswahlMoneyServersetup="nein"; fi

    if [ "$auswahlMoneyServersetup" = "ja" ]
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

        #[MySql]MoneyServer.ini
        crudini --set /$STARTVERZEICHNIS/AutoConfig/MoneyServer.ini MySql hostname "\"$localhost\""
        crudini --set /$STARTVERZEICHNIS/AutoConfig/MoneyServer.ini MySql database "\"$Database_name\""
        crudini --set /$STARTVERZEICHNIS/AutoConfig/MoneyServer.ini MySql username "\"$Database_user\""
        crudini --set /$STARTVERZEICHNIS/AutoConfig/MoneyServer.ini MySql password = "\"$Database_password\""
        #[MoneyServer]MoneyServer.ini 
        crudini --set /$STARTVERZEICHNIS/AutoConfig/MoneyServer.ini MoneyServer EnableScriptSendMoney "\"true\""
        crudini --set /$STARTVERZEICHNIS/AutoConfig/MoneyServer.ini MoneyServer MoneyScriptAccessKey  "\"$AccessKey\""
        crudini --set /$STARTVERZEICHNIS/AutoConfig/MoneyServer.ini MoneyServer MoneyScriptIPaddress  "\"$ScriptIPaddress\""

        # Die MoneyServer einstellungen für die Regionen
        # [Economy]OpenSim.ini
        # SellEnabled = true
        # EconomyModule = DTLNSLMoneyModule
        # CurrencyServer = "${Const|BaseURL}:8008/"
        # UserServer = "${Const|BaseURL}:8002/"
        # CheckServerCert = false
        # PriceUpload = 0
        # MeshModelUploadCostFactor = 1.0
        # MeshModelUploadTextureCostFactor = 1.0
        # MeshModelMinCostFactor = 1.0
        # PriceGroupCreate = 0
        crudini --set /$STARTVERZEICHNIS/AutoConfig/OpenSim.ini Economy SellEnabled "true"
        crudini --set /$STARTVERZEICHNIS/AutoConfig/OpenSim.ini Economy EconomyModule "DTLNSLMoneyModule"
        crudini --set /$STARTVERZEICHNIS/AutoConfig/OpenSim.ini Economy CurrencyServer "\"\${Const|BaseURL}:8008/\""
        crudini --set /$STARTVERZEICHNIS/AutoConfig/OpenSim.ini Economy UserServer "\"\${Const|BaseURL}:8002/\""
        crudini --set /$STARTVERZEICHNIS/AutoConfig/OpenSim.ini Economy CheckServerCert "false"
        crudini --set /$STARTVERZEICHNIS/AutoConfig/OpenSim.ini Economy PriceUpload "0"
        crudini --set /$STARTVERZEICHNIS/AutoConfig/OpenSim.ini Economy MeshModelUploadCostFactor "1.0"
        crudini --set /$STARTVERZEICHNIS/AutoConfig/OpenSim.ini Economy MeshModelUploadTextureCostFactor "1.0"
        crudini --set /$STARTVERZEICHNIS/AutoConfig/OpenSim.ini Economy MeshModelMinCostFactor "1.0"
        crudini --set /$STARTVERZEICHNIS/AutoConfig/OpenSim.ini Economy PriceGroupCreate "0"
        
        # ObjectCount = 0
        # PriceEnergyUnit = 0
        # PriceObjectClaim = 0
        # PricePublicObjectDecay = 0
        # PricePublicObjectDelete = 0
        # PriceParcelClaim = 0
        # PriceParcelClaimFactor = 1
        # PriceRentLight = 0
        # TeleportMinPrice = 0
        # TeleportPriceExponent = 2
        # EnergyEfficiency = 1
        # PriceObjectRent = 0
        # PriceObjectScaleFactor = 10
        # PriceParcelRent = 0
        crudini --set /$STARTVERZEICHNIS/AutoConfig/OpenSim.ini Economy ObjectCount "0"
        crudini --set /$STARTVERZEICHNIS/AutoConfig/OpenSim.ini Economy PriceEnergyUnit "0"
        crudini --set /$STARTVERZEICHNIS/AutoConfig/OpenSim.ini Economy PriceObjectClaim "0"
        crudini --set /$STARTVERZEICHNIS/AutoConfig/OpenSim.ini Economy PricePublicObjectDecay "0"
        crudini --set /$STARTVERZEICHNIS/AutoConfig/OpenSim.ini Economy PricePublicObjectDelete "0"
        crudini --set /$STARTVERZEICHNIS/AutoConfig/OpenSim.ini Economy PriceParcelClaim "0"
        crudini --set /$STARTVERZEICHNIS/AutoConfig/OpenSim.ini Economy PriceParcelClaimFactor "1"
        crudini --set /$STARTVERZEICHNIS/AutoConfig/OpenSim.ini Economy PriceRentLight "0"
        crudini --set /$STARTVERZEICHNIS/AutoConfig/OpenSim.ini Economy TeleportMinPrice "0"
        crudini --set /$STARTVERZEICHNIS/AutoConfig/OpenSim.ini Economy TeleportPriceExponent "2"
        crudini --set /$STARTVERZEICHNIS/AutoConfig/OpenSim.ini Economy EnergyEfficiency "1"
        crudini --set /$STARTVERZEICHNIS/AutoConfig/OpenSim.ini Economy PriceObjectRent "0"
        crudini --set /$STARTVERZEICHNIS/AutoConfig/OpenSim.ini Economy PriceObjectScaleFactor "10"
        crudini --set /$STARTVERZEICHNIS/AutoConfig/OpenSim.ini Economy PriceParcelRent "0"

    fi
if [ "$auswahlMoneyServersetup" = "nein" ]; then echo "weiter..."; fi
}

### ! OpenSim.ini
function OpenSimsetup() {
    echo " "; echo " "; echo "OpenSim.ini";
    echo "Möchten Sie den OpenSimulator konfigurieren?"
    echo "ja oder [nein]"
    read -r auswahlOpenSimsetup
    if [ "$auswahlOpenSimsetup" = "" ]; then auswahlOpenSimsetup="nein"; fi

    if [ "$auswahlOpenSimsetup" = "ja" ]
    then
        # [DataSnapshot]OpenSim.ini
        crudini --set /$STARTVERZEICHNIS/AutoConfig/OpenSim.ini DataSnapshot index_sims "\"true\""
        crudini --set /$STARTVERZEICHNIS/AutoConfig/OpenSim.ini DataSnapshot data_exposure "\"minimum\""
        crudini --set /$STARTVERZEICHNIS/AutoConfig/OpenSim.ini DataSnapshot default_snapshot_period "\"7200\""
        crudini --set /$STARTVERZEICHNIS/AutoConfig/OpenSim.ini DataSnapshot snapshot_cache_directory "\"DataSnapshot\""
        # [Startup]OpenSim.ini
        crudini --set /$STARTVERZEICHNIS/AutoConfig/OpenSim.ini Startup NonPhysicalPrimMax "\"1024\""
        crudini --set /$STARTVERZEICHNIS/AutoConfig/OpenSim.ini Startup AllowScriptCrossing "\"false\""
        crudini --set /$STARTVERZEICHNIS/AutoConfig/OpenSim.ini Startup DefaultDrawDistance "\"128.0\""
        crudini --set /$STARTVERZEICHNIS/AutoConfig/OpenSim.ini Startup MaxDrawDistance "\"128\""
        crudini --set /$STARTVERZEICHNIS/AutoConfig/OpenSim.ini Startup MaxRegionsViewDistance "\"128\""
        crudini --set /$STARTVERZEICHNIS/AutoConfig/OpenSim.ini Startup MinRegionsViewDistance "\"48\""
        # [AccessControl]OpenSim.ini
        crudini --set /$STARTVERZEICHNIS/AutoConfig/OpenSim.ini AccessControl DeniedClients "\"Imprudence,CopyBot,Twisted,Crawler,Cryolife,darkstorm,DarkStorm,Darkstorm\""
        # [Map]OpenSim.ini
        crudini --set /$STARTVERZEICHNIS/AutoConfig/OpenSim.ini Map DrawPrimOnMapTile "\"true\""
        crudini --set /$STARTVERZEICHNIS/AutoConfig/OpenSim.ini Map RenderMeshes "\"true\""
        # [Permissions]OpenSim.ini
        crudini --set /$STARTVERZEICHNIS/AutoConfig/OpenSim.ini Permissions allow_grid_gods "\"true\""
        # [Network]OpenSim.ini
        crudini --set /$STARTVERZEICHNIS/AutoConfig/OpenSim.ini Network user_agent "\"OpenSim LSL (Mozilla Compatible)\""
        # [ClientStack.LindenUDP]OpenSim.ini
        crudini --set /$STARTVERZEICHNIS/AutoConfig/OpenSim.ini ClientStack.LindenUDP DisableFacelights "\"true\""
        crudini --set /$STARTVERZEICHNIS/AutoConfig/OpenSim.ini ClientStack.LindenUDP client_throttle_max_bps "\"400000\""
        crudini --set /$STARTVERZEICHNIS/AutoConfig/OpenSim.ini ClientStack.LindenUDP scene_throttle_max_bps "\"70000000\""
        # [SimulatorFeatures]/$STARTVERZEICHNIS/AutoConfig/OpenSim.ini
        crudini --set /$STARTVERZEICHNIS/AutoConfig/OpenSim.ini SimulatorFeatures SearchServerURI "\"\$\{Const\|BaseURL\}:\$\{Const\|PublicPort\}\""
        crudini --set /$STARTVERZEICHNIS/AutoConfig/OpenSim.ini SimulatorFeatures DestinationGuideURI "\"\$\{Const\|BaseURL\}:\$\{Const\|PublicPort\}\""
        # [InterestManagement]/$STARTVERZEICHNIS/AutoConfig/OpenSim.ini
        crudini --set /$STARTVERZEICHNIS/AutoConfig/OpenSim.ini InterestManagement UpdatePrioritizationScheme "\"BestAvatarResponsiveness\""
        crudini --set /$STARTVERZEICHNIS/AutoConfig/OpenSim.ini InterestManagement ObjectsCullingByDistance "\"true\""
        # [Terrain]/$STARTVERZEICHNIS/AutoConfig/OpenSim.ini
        crudini --set /$STARTVERZEICHNIS/AutoConfig/OpenSim.ini Terrain InitialTerrain "\"flat\""
        # [UserProfiles]/$STARTVERZEICHNIS/AutoConfig/OpenSim.ini
        crudini --set /$STARTVERZEICHNIS/AutoConfig/OpenSim.ini UserProfiles ProfileServiceURL "\"\$\{Const\|BaseURL\}:\$\{Const\|PublicPort\}\""
        crudini --set /$STARTVERZEICHNIS/AutoConfig/OpenSim.ini UserProfiles AllowUserProfileWebURLs "\"true\""
        # [Materials]/$STARTVERZEICHNIS/AutoConfig/OpenSim.ini
        crudini --set /$STARTVERZEICHNIS/AutoConfig/OpenSim.ini Materials enable_materials "\"true\""
        crudini --set /$STARTVERZEICHNIS/AutoConfig/OpenSim.ini Materials MaxMaterialsPerTransaction "\"250\""
    fi
if [ "$auswahlOpenSimsetup" = "nein" ]; then echo "weiter..."; fi
}

### ! osslEnable.ini
function osslEnablesetup() {
    echo " "; echo " "; echo "osslEnable.ini";
    echo "Möchten Sie den osslEnable konfigurieren?"
    echo "ja oder [nein]"
    read -r auswahlosslEnablesetup
    if [ "$auswahlosslEnablesetup" = "" ]; then auswahlosslEnablesetup="nein"; fi

    if [ "$auswahlosslEnablesetup" = "ja" ]
    then
    echo "OpenSimulator Skript Level Einstellungen"
    echo "Weitere Informationen zu diesen Ebenen finden Sie unter http://opensimulator.org/wiki/Threat_level."
    echo "Die flächendeckende Aktivierung der ossl-Funktionen ist gefährlich und wir empfehlen keine höhere Einstellung als [VeryLow]"
    echo "Mögliche Einstellungen sind:  None, VeryLow, Low, Moderate, High, VeryHigh, Severe."
    read -r SkriptLevel
    if [ "$SkriptLevel" = "" ]; then SkriptLevel="VeryLow"; fi
    #[OSSL]/$STARTVERZEICHNIS/AutoConfig/osslEnable.ini    
    crudini --set /$STARTVERZEICHNIS/AutoConfig/osslEnable.ini OSSL OSFunctionThreatLevel "\"$SkriptLevel\""
    echo "PARCEL_GROUP_MEMBER,PARCEL_OWNER,ESTATE_MANAGER und ESTATE_OWNER freigeben [ja]"
    read -r SkriptOwner
    if [ "$SkriptOwner" = "" ]; then SkriptOwner="ja"; fi
    if [ "$SkriptOwner" = "ja" ]
    then
        crudini --set /$STARTVERZEICHNIS/AutoConfig/osslEnable.ini OSSL osslParcelO "\"PARCEL_OWNER,ESTATE_MANAGER,ESTATE_OWNER,\""
        crudini --set /$STARTVERZEICHNIS/AutoConfig/osslEnable.ini OSSL osslParcelOG "\"PARCEL_GROUP_MEMBER,PARCEL_OWNER,ESTATE_MANAGER,ESTATE_OWNER,\"" 
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
    Allow_osSetContentType =          false" >> /$STARTVERZEICHNIS/AutoConfig/osslEnable.ini
fi

if [ "$auswahlosslEnablesetup" = "nein" ]; then echo "weiter..."; fi

}

### ! Robust.HG.ini
function RobustHGsetup() {
    echo " "; echo " "; echo "Robust.HG.ini";
    echo "Möchten Sie den Robust Hypergrid konfigurieren?"
    echo "ja oder [nein]"
    read -r auswahlRobustHGsetup
    if [ "$auswahlRobustHGsetup" = "" ]; then auswahlRobustHGsetup="nein"; fi

    if [ "$auswahlRobustHGsetup" = "ja" ]
    then
        #[ServiceList]/$STARTVERZEICHNIS/AutoConfig/Robust.HG.ini
        crudini --set /$STARTVERZEICHNIS/AutoConfig/Robust.HG.ini ServiceList OfflineIMServiceConnector "\"\${Const|PrivatePort}/OpenSim.Addons.OfflineIM.dll:OfflineIMServiceRobustConnector\""
        crudini --set /$STARTVERZEICHNIS/AutoConfig/Robust.HG.ini ServiceList GroupsServiceConnector "\"\${Const|PrivatePort}/OpenSim.Addons.Groups.dll:GroupsServiceRobustConnector\""
        crudini --set /$STARTVERZEICHNIS/AutoConfig/Robust.HG.ini ServiceList BakedTextureService "\"\${Const|PrivatePort}/OpenSim.Server.Handlers.dll:XBakesConnector\""
        crudini --set /$STARTVERZEICHNIS/AutoConfig/Robust.HG.ini ServiceList UserProfilesServiceConnector "\"\${Const|PublicPort}/OpenSim.Server.Handlers.dll:UserProfilesConnector\""
        crudini --set /$STARTVERZEICHNIS/AutoConfig/Robust.HG.ini ServiceList HGGroupsServiceConnector "\"\${Const|PublicPort}/OpenSim.Addons.Groups.dll:HGGroupsServiceRobustConnector\""
        #[Hypergrid]/$STARTVERZEICHNIS/AutoConfig/Robust.HG.ini
        crudini --set /$STARTVERZEICHNIS/AutoConfig/Robust.HG.ini Hypergrid HomeURI "\"\${Const|BaseURL}:\${Const|PublicPort}\""
        crudini --set /$STARTVERZEICHNIS/AutoConfig/Robust.HG.ini Hypergrid GatekeeperURI "\"\${Const|BaseURL}:\${Const|PublicPort}\""
        #[AccessControl]/$STARTVERZEICHNIS/AutoConfig/Robust.HG.ini
        crudini --set /$STARTVERZEICHNIS/AutoConfig/Robust.HG.ini AccessControl DeniedClients "\"Imprudence|CopyBot|Twisted|Crawler|Cryolife|darkstorm|DarkStorm|Darkstorm|hydrastorm viewer|kinggoon copybot|goon squad copybot|copybot pro|darkstorm viewer|copybot club|darkstorm second life|copybot download|HydraStorm Copybot Viewer|Copybot|Firestorm Pro|DarkStorm v3|DarkStorm v2|ShoopedStorm|HydraStorm|hydrastorm|kinggoon|goon squad|goon|copybot|Shooped|ShoopedStorm|Triforce|Triforce Viewer|Firestorm Professional|ShoopedLife|Sombrero|Sombrero Firestorm|GoonSquad|Solar|SolarStorm\""
        #[GridService]/$STARTVERZEICHNIS/AutoConfig/Robust.HG.ini
        crudini --set /$STARTVERZEICHNIS/AutoConfig/Robust.HG.ini GridService MapTileDirectory "\"./maptiles\""
        #[LoginService]/$STARTVERZEICHNIS/AutoConfig/Robust.HG.ini
        crudini --set /$STARTVERZEICHNIS/AutoConfig/Robust.HG.ini LoginService Currency "\"T$\""
        crudini --set /$STARTVERZEICHNIS/AutoConfig/Robust.HG.ini LoginService ClassifiedFee 0
        crudini --set /$STARTVERZEICHNIS/AutoConfig/Robust.HG.ini LoginService DeniedMacs "\"44ed33b396b10a5c95d04967aff8bd9c|5574234b1336a4523b6acb803737b608\""
        crudini --set /$STARTVERZEICHNIS/AutoConfig/Robust.HG.ini LoginService DeniedID0s "\"d1fdb346d01a3bda2dcb82322bd88456\""
        #[MapImageService]/$STARTVERZEICHNIS/AutoConfig/Robust.HG.ini
        crudini --set /$STARTVERZEICHNIS/AutoConfig/Robust.HG.ini MapImageService TilesStoragePath "\"maptiles\""
        #[GridInfoService]/$STARTVERZEICHNIS/AutoConfig/Robust.HG.ini
        crudini --set /$STARTVERZEICHNIS/AutoConfig/Robust.HG.ini GridInfoService gridname "\"the lost continent of hippo\""
        crudini --set /$STARTVERZEICHNIS/AutoConfig/Robust.HG.ini GridInfoService gridnick "\"hippogrid"
        crudini --set /$STARTVERZEICHNIS/AutoConfig/Robust.HG.ini GridInfoService economy "\"\${Const|BaseURL}/opensim/helper/\""
        crudini --set /$STARTVERZEICHNIS/AutoConfig/Robust.HG.ini GridInfoService about "\"\${Const|BaseURL}/opensim/helper/\""
        crudini --set /$STARTVERZEICHNIS/AutoConfig/Robust.HG.ini GridInfoService register "\"\${Const|BaseURL}/opensim/helper/\""
        crudini --set /$STARTVERZEICHNIS/AutoConfig/Robust.HG.ini GridInfoService help "\"\${Const|BaseURL}/opensim/helper/\""
        crudini --set /$STARTVERZEICHNIS/AutoConfig/Robust.HG.ini GridInfoService password "\${Const|BaseURL}/opensim/helper/\""
        crudini --set /$STARTVERZEICHNIS/AutoConfig/Robust.HG.ini GridInfoService gatekeeper "\"\${Const|BaseURL}:\${Const|PublicPort}/\""
        crudini --set /$STARTVERZEICHNIS/AutoConfig/Robust.HG.ini GridInfoService uas "\"\${Const|BaseURL}:\${Const|PublicPort}/\""
        #[GatekeeperService]/$STARTVERZEICHNIS/AutoConfig/Robust.HG.ini
        crudini --set /$STARTVERZEICHNIS/AutoConfig/Robust.HG.ini GatekeeperService DeniedMacs "\"44ed33b396b10a5c95d04967aff8bd9c|5574234b1336a4523b6acb803737b608\""
        crudini --set /$STARTVERZEICHNIS/AutoConfig/Robust.HG.ini GatekeeperService DeniedID0s "\"d1fdb346d01a3bda2dcb82322bd88456\""
        #[UserAgentService]/$STARTVERZEICHNIS/AutoConfig/Robust.HG.ini
        crudini --set /$STARTVERZEICHNIS/AutoConfig/Robust.HG.ini UserAgentService ShowUserDetailsInHGProfile "\"True\""  
    fi
if [ "$auswahlRobustHGsetup" = "nein" ]; then echo "weiter..."; fi
}
### ! Robust.ini
function Robustsetup() {
    echo " "; echo " "; echo "Robust.ini";
    echo "Möchten Sie den Robust konfigurieren?"
    echo "ja oder [nein]"
    read -r auswahlRobustsetup
    if [ "$auswahlRobustsetup" = "" ]; then auswahlRobustsetup="nein"; fi

    if [ "$auswahlRobustsetup" = "ja" ]
    then
        #[ServiceList]/$STARTVERZEICHNIS/AutoConfig/Robust.ini
        crudini --set /$STARTVERZEICHNIS/AutoConfig/Robust.ini ServiceList OfflineIMServiceConnector "\"\${Const|PrivatePort}/OpenSim.Addons.OfflineIM.dll:OfflineIMServiceRobustConnector\""
        crudini --set /$STARTVERZEICHNIS/AutoConfig/Robust.ini ServiceList GroupsServiceConnector "\"\${Const|PrivatePort}/OpenSim.Addons.Groups.dll:GroupsServiceRobustConnector\""
        crudini --set /$STARTVERZEICHNIS/AutoConfig/Robust.ini ServiceList BakedTextureService "\"\${Const|PrivatePort}/OpenSim.Server.Handlers.dll:XBakesConnector\""
        crudini --set /$STARTVERZEICHNIS/AutoConfig/Robust.ini ServiceList UserProfilesServiceConnector "\"\${Const|PublicPort}/OpenSim.Server.Handlers.dll:UserProfilesConnector\""
    fi
if [ "$auswahlRobustsetup" = "nein" ]; then echo "weiter..."; fi
}


### ! IP oder DNS in die Konfigurationen schreiben
function ipdnssetup() {
    echo " "; echo " ";
    echo "Möchten Sie den Konfigurationen ihre IP oder DNS Adresse eintragen?"
    echo "ja oder [nein]"
    read -r auswahlipdnssetup
    if [ "$auswahlipdnssetup" = "" ]; then auswahlipdnssetup="nein"; fi

    if [ "$auswahlipdnssetup" = "ja" ]
    then
        #auswahlipdnssetup="$AKTUELLEIP" # Vorgabe ExterneIP
        echo "Geben Sie ihre IP Adresse ($AKTUELLEIP) oder ihre DNS (meingrid.de) ein:"
        read -r auswahlipdnssetup

        echo "Robust.ini"
        #[Const]Robust.ini
        crudini --set /$STARTVERZEICHNIS/AutoConfig/Robust.ini Const BaseURL "\"$auswahlipdnssetup\""

        echo "Robust.HG.ini"
        #[Const]Robust.HG.ini
        crudini --set /$STARTVERZEICHNIS/AutoConfig/Robust.HG.ini Const BaseURL "\"$auswahlipdnssetup\""

        echo "OpenSim.ini"
        # [Const]OpenSim.ini
        crudini --set /$STARTVERZEICHNIS/AutoConfig/OpenSim.ini Const BaseHostname "\"$auswahlipdnssetup\""
        # [DataSnapshot]/$STARTVERZEICHNIS/AutoConfig/OpenSim.ini
        crudini --set /$STARTVERZEICHNIS/AutoConfig/OpenSim.ini DataSnapshot gridname "\"$auswahlipdnssetup\""
    fi
if [ "$auswahlipdnssetup" = "nein" ]; then echo "weiter..."; fi
}

### ! GridCommon.ini und StandaloneCommon.ini Const anlegen
function constsetup() {
    echo " "; echo " ";
    echo "Möchten Sie die fehlenden Const bereiche in den GridCommon und StandaloneCommon eintragen?"
    echo "ja oder [nein]"
    read -r auswahlconstsetup
    if [ "$auswahlconstsetup" = "" ]; then auswahlconstsetup="nein"; fi

    if [ "$auswahlconstsetup" = "ja" ]
    then
    echo "GridCommon.ini Const anlegen"

    # Prüfen ob Const vorhanden ist:
    CONSTOK=$(crudini --get /$STARTVERZEICHNIS/AutoConfig/GridCommon.ini Const)

    # Const ist vorhanden
    if [ "$CONSTOK" = "Const" ]
    then
        echo "Nur die neue IP/DNS eintragen"
        crudini --set /$STARTVERZEICHNIS/AutoConfig/GridCommon.ini Const BaseURL "\"$auswahlipdnssetup\""
    fi
    # Const ist nicht vorhanden
    if [ "$CONSTOK" = "" ]
    then
        echo "Const neu anlegen am anfang der GridCommon.ini"
        sed -i '1s/.*$/\[Const\]\n&/g' /$STARTVERZEICHNIS/AutoConfig/GridCommon.ini
        sed -i '2s/.*$/BaseURL = "http:\/\/'"\"$auswahlipdnssetup\""'"\n&/g' /$STARTVERZEICHNIS/AutoConfig/GridCommon.ini
        sed -i '3s/.*$/PublicPort = "8002"\n&/g' /$STARTVERZEICHNIS/AutoConfig/GridCommon.ini
        sed -i '4s/.*$/PrivatePort = "8003"\n&/g' /$STARTVERZEICHNIS/AutoConfig/GridCommon.ini
        sed -i '5s/.*$/PrivURL = "$\{Const|BaseURL}"\n&/g' /$STARTVERZEICHNIS/AutoConfig/GridCommon.ini
        sed -i '6s/.*$/\n&/g' /$STARTVERZEICHNIS/AutoConfig/GridCommon.ini
    fi

    echo "StandaloneCommon.ini Const anlegen"
    
    # Prüfen ob Const vorhanden ist:
    CONSTOK=$(crudini --get /$STARTVERZEICHNIS/AutoConfig/StandaloneCommon.ini Const)

    # Const ist vorhanden
    if [ "$CONSTOK" = "Const" ]
    then
        echo "Nur die neue IP/DNS eintragen"
        crudini --set /$STARTVERZEICHNIS/AutoConfig/StandaloneCommon.ini Const BaseURL "\"$auswahlipdnssetup\""
    fi
    # Const ist nicht vorhanden
    if [ "$CONSTOK" = "" ]
    then
        echo "Const neu anlegen am anfang der StandaloneCommon.ini"
        sed -i '1s/.*$/\[Const\]\n&/g' /$STARTVERZEICHNIS/AutoConfig/StandaloneCommon.ini
        sed -i '2s/.*$/BaseURL = "http:\/\/'"\"$auswahlipdnssetup\""'"\n&/g' /$STARTVERZEICHNIS/AutoConfig/StandaloneCommon.ini
        sed -i '3s/.*$/PublicPort = "8002"\n&/g' /$STARTVERZEICHNIS/AutoConfig/StandaloneCommon.ini
        sed -i '4s/.*$/PrivatePort = "8003"\n&/g' /$STARTVERZEICHNIS/AutoConfig/StandaloneCommon.ini
        sed -i '5s/.*$/PrivURL = "$\{Const|BaseURL}"\n&/g' /$STARTVERZEICHNIS/AutoConfig/StandaloneCommon.ini
        sed -i '6s/.*$/\n&/g' /$STARTVERZEICHNIS/AutoConfig/StandaloneCommon.ini
    fi
    fi
if [ "$auswahlconstsetup" = "nein" ]; then echo "weiter..."; fi
}
### ! StandaloneCommon.ini
function StandaloneCommonsetup() {
    echo " "; echo " "; echo "StandaloneCommon.ini";
    echo "Möchten Sie StandaloneCommon einstellen?"
    echo "ja oder [nein]"
    read -r auswahlStandaloneCommon
    if [ "$auswahlStandaloneCommon" = "" ]; then auswahlStandaloneCommon="nein"; fi

    if [ "$auswahlStandaloneCommon" = "ja" ]
    then
        # [Hypergrid]/$STARTVERZEICHNIS/AutoConfig/StandaloneCommon.ini
        crudini --set /$STARTVERZEICHNIS/AutoConfig/StandaloneCommon.ini Hypergrid GatekeeperURI "\"\$\{Const\|BaseURL\}:\$\{Const\|PublicPort\}\""
        # [Modules]/$STARTVERZEICHNIS/AutoConfig/StandaloneCommon.ini
        crudini --set /$STARTVERZEICHNIS/AutoConfig/StandaloneCommon.ini Modules AuthorizationServices "\"RemoteAuthorizationServicesConnector\""
        # [GridService]/$STARTVERZEICHNIS/AutoConfig/StandaloneCommon.ini
        crudini --set /$STARTVERZEICHNIS/AutoConfig/StandaloneCommon.ini GridService AllowHypergridMapSearch "\"true\""
        crudini --set /$STARTVERZEICHNIS/AutoConfig/StandaloneCommon.ini GridService MapTileDirectory "\"./maptiles\""
        # [HGInventoryAccessModule]/$STARTVERZEICHNIS/AutoConfig/StandaloneCommon.ini
        crudini --set /$STARTVERZEICHNIS/AutoConfig/StandaloneCommon.ini HGInventoryAccessModule HomeURI "\"\$\{Const\|BaseURL\}:\$\{Const\|PublicPort\}\""
        crudini --set /$STARTVERZEICHNIS/AutoConfig/StandaloneCommon.ini HGInventoryAccessModule Gatekeeper "\"\$\{Const\|BaseURL\}:\$\{Const\|PublicPort\}\""
        crudini --set /$STARTVERZEICHNIS/AutoConfig/StandaloneCommon.ini HGInventoryAccessModule RestrictInventoryAccessAbroad "\"false\""
        # [HGFriendsModule]/$STARTVERZEICHNIS/AutoConfig/StandaloneCommon.ini
        crudini --set /$STARTVERZEICHNIS/AutoConfig/StandaloneCommon.ini HGFriendsModule LevelHGFriends "0;"
    fi
if [ "$auswahlStandaloneCommon" = "nein" ]; then echo "weiter..."; fi
}

### ! GridCommon.ini
function GridCommonsetup() {
    echo " "; echo " "; echo "GridCommon.ini";
    echo "Möchten Sie GridCommon einstellen?"
    echo "ja oder [nein]"
    read -r auswahlGridCommon
    if [ "$auswahlGridCommon" = "" ]; then auswahlGridCommon="nein"; fi

    if [ "$auswahlGridCommon" = "ja" ]
    then
        # [Hypergrid]GridCommon.ini
        crudini --set /$STARTVERZEICHNIS/AutoConfig/GridCommon.ini Hypergrid GatekeeperURI "\"\$\{Const\|BaseURL\}:\$\{Const\|PublicPort\}\""
        # [Modules]GridCommon.ini
        crudini --set /$STARTVERZEICHNIS/AutoConfig/GridCommon.ini Modules AuthorizationServices "\"RemoteAuthorizationServicesConnector\""
        # [GridService]GridCommon.ini
        crudini --set /$STARTVERZEICHNIS/AutoConfig/GridCommon.ini GridService AllowHypergridMapSearch "\"true\""
        crudini --set /$STARTVERZEICHNIS/AutoConfig/GridCommon.ini GridService MapTileDirectory "\"./maptiles\""
        # [HGInventoryAccessModule]GridCommon.ini
        crudini --set /$STARTVERZEICHNIS/AutoConfig/GridCommon.ini HGInventoryAccessModule HomeURI "\"\$\{Const\|BaseURL\}:\$\{Const\|PublicPort\}\""
        crudini --set /$STARTVERZEICHNIS/AutoConfig/GridCommon.ini HGInventoryAccessModule Gatekeeper "\"\$\{Const\|BaseURL\}:\$\{Const\|PublicPort\}\""
        crudini --set /$STARTVERZEICHNIS/AutoConfig/GridCommon.ini HGInventoryAccessModule RestrictInventoryAccessAbroad "\"false\""
        # [HGFriendsModule]GridCommon.ini
        crudini --set /$STARTVERZEICHNIS/AutoConfig/GridCommon.ini HGFriendsModule LevelHGFriends "0;"
    fi
if [ "$auswahlGridCommon" = "nein" ]; then echo "weiter..."; fi
}

### ! LaunchSLClient.ini
function LaunchSLClientsetup() {
    echo " "; echo " "; echo "LaunchSLClient.ini";
    echo "Möchten Sie LaunchSLClient einstellen?"
    echo "ja oder [nein]"
    read -r auswahlLaunchSLClient
    if [ "$auswahlLaunchSLClient" = "" ]; then auswahlLaunchSLClient="nein"; fi

    if [ "$auswahlLaunchSLClient" = "ja" ]
    then
        # [OSGrid]LaunchSLClient.ini
        crudini --set /$STARTVERZEICHNIS/AutoConfig/LaunchSLClient.ini "$auswahlipdnssetup"
        crudini --set /$STARTVERZEICHNIS/AutoConfig/LaunchSLClient.ini "$auswahlipdnssetup" loginURI "http://$auswahlipdnssetup:8002/"
        crudini --set /$STARTVERZEICHNIS/AutoConfig/LaunchSLClient.ini "$auswahlipdnssetup" URL "$auswahlipdnssetup"
    fi
if [ "$auswahlLaunchSLClient" = "nein" ]; then echo "weiter..."; fi
}

### ! Datenbank sqlite oder mysql
function databasesetup() {
    echo " "; echo " ";
    echo "Möchten Sie ihre Datenbank sqlite oder mysql einstellen?"
    echo "ja oder [nein]"
    read -r auswahldatabasesetup
    if [ "$auswahldatabasesetup" = "" ]; then auswahldatabasesetup="nein"; fi

    if [ "$auswahldatabasesetup" = "ja" ]
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

        if [ "$auswahlmysql" = "" ]; then auswahlmysql="nein"; fi
        if [ "$auswahlsource" = "" ]; then Source="localhost"; fi
        if [ "$auswahldatabase" = "" ]; then Database="opensim"; fi
        if [ "$auswahluserid" = "" ]; then User_ID="opensim"; fi
        if [ "$auswahlpassword" = "" ]; then Password="opensim"; fi

        # GridCommon.ini Robust.HG.ini Robust.ini
        crudini --set /$STARTVERZEICHNIS/AutoConfig/Robust.ini DatabaseService StorageProvider "\"OpenSim.Data.MySQL.dll\""
        crudini --set /$STARTVERZEICHNIS/AutoConfig/Robust.ini DatabaseService ConnectionString "\"Data Source=$Source;Database=$Database;User ID=$User_ID;Password=$Password;Old Guids=true;SslMode=None;\""
        crudini --set /$STARTVERZEICHNIS/AutoConfig/Robust.HG.ini DatabaseService StorageProvider "\"OpenSim.Data.MySQL.dll\""
        crudini --set /$STARTVERZEICHNIS/AutoConfig/Robust.HG.ini DatabaseService ConnectionString "\"Data Source=$Source;Database=$Database;User ID=$User_ID;Password=$Password;Old Guids=true;SslMode=None;\""

        # Wird mysql/mariaDB ausgewählt dann ändern
        if [ "$auswahlmysql" = "ja" ]
        then
        # SQlite kommentieren
        sed -i s/Include-Storage = \"config-include/storage/SQLiteStandalone.ini\"\;/\;Include-Storage = \"config-include/storage/SQLiteStandalone.ini\"\;/g /$STARTVERZEICHNIS/AutoConfig/GridCommon.ini
        # mysql/mariaDB eintragen
        crudini --set /$STARTVERZEICHNIS/AutoConfig/GridCommon.ini DatabaseService StorageProvider "\"OpenSim.Data.MySQL.dll\""
        crudini --set /$STARTVERZEICHNIS/AutoConfig/GridCommon.ini DatabaseService ConnectionString = "\"Data Source=$Source;Database=$Database;User ID=$User_ID;Password=$Password;Old Guids=true;SslMode=None;\""
        else
        echo "SQlite wird beibehalten"
        fi

    fi
if [ "$auswahldatabasesetup" = "nein" ]; then echo "weiter..."; fi
}

### ! Region Konfigurationen schreiben
function regionconfig() {
    echo "Möchten Sie ihre Region Konfigurationen erstellen?"
    echo "ja oder [nein]"
    read -r auswahlregioncon
    if [ "$auswahlregioncon" = "" ]; then auswahlregioncon="nein"; fi

    if [ "$auswahlregioncon" = "ja" ]
    then
        echo " "; echo " ";
        echo "Bitte geben sie einen Regionsnamen ein für ihre Start-Welcome-Center Region [WelcomeCenter]"
        read -r regionsname
        echo "Bitte geben sie die Größe ihrer Region an [256]:"
        read -r size
        echo "Bitte geben sie den Ort ihrer Region an [1000,1000]:"
        read -r location

        if [ "$regionsname" = "" ]; then regionsname="WelcomeCenter"; fi
        if [ "$size" = "" ]; then size="256"; fi
        if [ "$location" = "" ]; then location="1000,1000"; fi

        UUID=$(uuidgen)
        #[Regionsname]/$STARTVERZEICHNIS/AutoConfig/Regions.ini
        crudini --set /$STARTVERZEICHNIS/AutoConfig/Regions.ini "$regionsname"
        crudini --set /$STARTVERZEICHNIS/AutoConfig/Regions.ini "$regionsname" RegionUUID "\"$UUID\""
        crudini --set /$STARTVERZEICHNIS/AutoConfig/Regions.ini "$regionsname" Location "\"$location\""
        crudini --set /$STARTVERZEICHNIS/AutoConfig/Regions.ini "$regionsname" SizeX "\"$size\""
        crudini --set /$STARTVERZEICHNIS/AutoConfig/Regions.ini "$regionsname" SizeY "\"$size\""
        crudini --set /$STARTVERZEICHNIS/AutoConfig/Regions.ini "$regionsname" SizeZ "\"$size\""
        crudini --set /$STARTVERZEICHNIS/AutoConfig/Regions.ini "$regionsname" InternalAddress "\"0.0.0.0\""
        crudini --set /$STARTVERZEICHNIS/AutoConfig/Regions.ini "$regionsname" InternalPort "\"9100\""
        crudini --set /$STARTVERZEICHNIS/AutoConfig/Regions.ini "$regionsname" ResolveAddress "\"False\""
        crudini --set /$STARTVERZEICHNIS/AutoConfig/Regions.ini "$regionsname" ExternalHostName "\"$auswahlipdnssetup\""
        crudini --set /$STARTVERZEICHNIS/AutoConfig/Regions.ini "$regionsname" MaptileStaticUUID "\"$UUID\""
        crudini --set /$STARTVERZEICHNIS/AutoConfig/Regions.ini "$regionsname" DefaultLanding "\"<128,128,25>\""
        crudini --set /$STARTVERZEICHNIS/AutoConfig/Regions.ini "$regionsname" \;MaxPrimsPerUser "\"-1\""
        crudini --set /$STARTVERZEICHNIS/AutoConfig/Regions.ini "$regionsname" \;ScopeID "\"$UUID\""
        crudini --set /$STARTVERZEICHNIS/AutoConfig/Regions.ini "$regionsname" \;RegionType "\"Mainland\""
        crudini --set /$STARTVERZEICHNIS/AutoConfig/Regions.ini "$regionsname" \;MapImageModule "\"Warp3DImageModule\""
        crudini --set /$STARTVERZEICHNIS/AutoConfig/Regions.ini "$regionsname" \;TextureOnMapTile "\"true\""
        crudini --set /$STARTVERZEICHNIS/AutoConfig/Regions.ini "$regionsname" \;DrawPrimOnMapTile "\"true\""
        crudini --set /$STARTVERZEICHNIS/AutoConfig/Regions.ini "$regionsname" \;GenerateMaptiles "\"true\""
        crudini --set /$STARTVERZEICHNIS/AutoConfig/Regions.ini "$regionsname" \;MaptileRefresh "\"0\""
        crudini --set /$STARTVERZEICHNIS/AutoConfig/Regions.ini "$regionsname" \;MaptileStaticFile "\"water-logo-info.png"\"
        crudini --set /$STARTVERZEICHNIS/AutoConfig/Regions.ini "$regionsname" \;MasterAvatarFirstName "\"John\""
        crudini --set /$STARTVERZEICHNIS/AutoConfig/Regions.ini "$regionsname" \;MasterAvatarLastName "\"Doe\""
        crudini --set /$STARTVERZEICHNIS/AutoConfig/Regions.ini "$regionsname" \;MasterAvatarSandboxPassword "\"passwd\""
        #[GridService]/$STARTVERZEICHNIS/AutoConfig/Robust.HG.ini Region als Default eintragen.
        crudini --set /$STARTVERZEICHNIS/AutoConfig/Robust.HG.ini GridService Region_"$regionsname" "\"DefaultRegion, DefaultHGRegion\""
    fi
if [ "$auswahlregioncon" = "nein" ]; then echo "weiter..."; fi
}

### ! Hypergrid Konfigurationen schreiben
function hypergridsetup() {
    echo "Möchten Sie ihre OpenSim/Grid Konfigurationen erstellen?"
    echo "ja oder [nein]"
    read -r auswahlhypergrid
    if [ "$auswahlhypergrid" = "" ]; then auswahlhypergrid="nein"; fi

    if [ "$auswahlhypergrid" = "ja" ]
    then
        echo " "; echo " "
        echo "Möchten Sie ein Eigenständiges Grid"
        echo "oder eine OpenSimulator Region mit Reisemöglichkeit zu anderen Grids?"
        echo "dann tippen sie hggrid oder hgos ein."
        echo " "
        echo "Wenn, sie kein Hypergrid möchten,"
        echo "sondern lieber in sichere Umgebung ihres Netzwerkes agieren?"
        echo "dann geben sie grid oder os ein."
        read -r auswahlhg

        if [ "$auswahlhg" = "hggrid" ]
        then
        # PublicPort = "8002"
        crudini --set /$STARTVERZEICHNIS/AutoConfig/OpenSim.ini Const PublicPort "\"8002\""
        # Network http_listener_port = "9000"
        crudini --set /$STARTVERZEICHNIS/AutoConfig/OpenSim.ini Network http_listener_port "\"9010\""
        # Include-Architecture "config-include/GridHypergrid.ini"
        crudini --set /$STARTVERZEICHNIS/AutoConfig/OpenSim.ini Architecture Include-Architecture "\"config-include/GridHypergrid.ini\""
        # [XBakes]
        crudini --set /$STARTVERZEICHNIS/AutoConfig/OpenSim.ini XBakes URL "\"\$\{Const\|BaseURL\}:\$\{Const\|PrivatePort\}\""
        fi

        if [ "$auswahlhg" = "hgos" ]
        then
        # PublicPort = "9000" besser 9010 weil 9000 und 9001 belegt sein könnten
        crudini --set /$STARTVERZEICHNIS/AutoConfig/OpenSim.ini Const PublicPort "\"9010\""
        # Include-Architecture "config-include/StandaloneHypergrid.ini"
        crudini --set /$STARTVERZEICHNIS/AutoConfig/OpenSim.ini Architecture Include-Architecture "\"config-include/StandaloneHypergrid.ini\""
        fi

        if [ "$auswahlhg" = "grid" ]
        then
        # PublicPort = "8002"
        crudini --set /$STARTVERZEICHNIS/AutoConfig/OpenSim.ini Const PublicPort "\"8002\""
        # Network http_listener_port = "9000"
        crudini --set /$STARTVERZEICHNIS/AutoConfig/OpenSim.ini Network http_listener_port "\"9010\""
        # Include-Architecture "config-include/Grid.ini"
        crudini --set /$STARTVERZEICHNIS/AutoConfig/OpenSim.ini Architecture Include-Architecture "\"config-include/Grid.ini\""
        # [XBakes]
        crudini --set /$STARTVERZEICHNIS/AutoConfig/OpenSim.ini XBakes URL "\"\$\{Const\|BaseURL\}:\$\{Const\|PrivatePort\}\""
        fi

        if [ "$auswahlhg" = "os" ]
        then 
        # PublicPort = "9000" besser 9010 weil 9000 und 9001 belegt sein könnten
        crudini --set /$STARTVERZEICHNIS/AutoConfig/OpenSim.ini Const PublicPort "\"9010\""
        # Include-Architecture "config-include/Standalone.ini"
        crudini --set /$STARTVERZEICHNIS/AutoConfig/OpenSim.ini Architecture Include-Architecture "\"config-include/Standalone.ini\"" 
        fi

    fi
if [ "$auswahlhypergrid" = "nein" ]; then echo "weiter..."; fi
}

### ! Messaging Konfigurationen schreiben
function Messagingsetup() {
echo "OpenSim.ini Messagingsetup"

# [Messaging]OpenSim.ini
# OfflineMessageModule = "Offline Message Module V2"
# OfflineMessageURL = ${Const|PrivURL}:${Const|PrivatePort}
# StorageProvider = OpenSim.Data.MySQL.dll
# MuteListModule = MuteListModule
# ForwardOfflineGroupMessages = true
crudini --set /$STARTVERZEICHNIS/AutoConfig/OpenSim.ini Messaging OfflineMessageModule "Offline Message Module V2"
crudini --set /$STARTVERZEICHNIS/AutoConfig/OpenSim.ini Messaging OfflineMessageURL "\${Const|PrivURL}:\${Const|PrivatePort}"
crudini --set /$STARTVERZEICHNIS/AutoConfig/OpenSim.ini Messaging StorageProvider "OpenSim.Data.MySQL.dll"
crudini --set /$STARTVERZEICHNIS/AutoConfig/OpenSim.ini Messaging MuteListModule "MuteListModule"
crudini --set /$STARTVERZEICHNIS/AutoConfig/OpenSim.ini Messaging ForwardOfflineGroupMessages "true"

}


# Programmablauf: Funktionen aufrufen
linstall
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
#Messagingsetup

# TODO
# Zum schluss müssen alle Konfigurationen an ihren richtigen Platz kopiert werden.