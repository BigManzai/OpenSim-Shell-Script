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
VERSION="1.2.0" # Versionsausgabe
### Aktuelle IP ueber Suchadresse ermitteln und Ausfuehrungszeichen anhaengen.
SEARCHADRES="icanhazip.com"
AKTUELLEIP="$(wget -O - -q $SEARCHADRES)"
AKTUELLEVERZ=$(pwd) # Aktuelles Verzeichnis

tput reset # Bildschirmausgabe loeschen inklusive dem Scrollbereich.
#linefontcolor=2	linebaggroundcolor=0;
#lline="$(tput setaf $linefontcolor)$(tput setab $linebaggroundcolor)#####################################################################################$(tput sgr 0)"

function silent(){ STARTVERZEICHNIS="opt"; }

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

echo "Bitte geben sie den Datenbanknamen an [opensim]:"
read -r MYSQLDATABASE
if [ "$MYSQLDATABASE" = "" ]; then MYSQLDATABASE="opensim"; fi
echo "Ihr Datenbanknamen lautet: $MYSQLDATABASE"
echo "##################################################################"

echo "Bitte geben sie den Benutzernamen ihrer Datenbank an [opensim]:"
read -r MYSQLUSER
if [ "$MYSQLUSER" = "" ]; then MYSQLUSER="opensim"; fi
echo "Ihr Datenbank Benutzername lautet: $MYSQLUSER"
echo "##################################################################"

echo "Bitte geben sie das Passwort ihrer Datenbank an [opensim]:"
read -r MYSQLPASSWORD
if [ "$MYSQLPASSWORD" = "" ]; then MYSQLPASSWORD="opensim"; fi
echo "Ihr Passwort ihrer Datenbank lautet: ********"
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
		echo "Lege robust an im Verzeichnis $ROBUSTVERZEICHNIS an"
		mkdir -p /"$STARTVERZEICHNIS"/$ROBUSTVERZEICHNIS/bin/config-include
        cp "$AKTUELLEVERZ"/config-include/GridCommon.ini /"$STARTVERZEICHNIS"/$ROBUSTVERZEICHNIS/bin/config-include
        cp "$AKTUELLEVERZ"/Robust.ini /"$STARTVERZEICHNIS"/$ROBUSTVERZEICHNIS/bin
        
        CONSTINI="/$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS/bin/config-include/Const.ini"
        constconfig "$BASEHOSTNAME" "$PRIVURL" "$MONEYPORT" "$SIMULATORPORT" "$MYSQLDATABASE" "$MYSQLUSER" "$MYSQLPASSWORD" "$STARTREGION" "$SIMULATORGRIDNAME" "$SIMULATORGRIDNICK" "$CONSTINI"

        moneyconfig "/$STARTVERZEICHNIS/$ROBUSTVERZEICHNIS/bin/MoneyServer.ini"

	else
		log error "Verzeichnis $ROBUSTVERZEICHNIS existiert bereits"
	fi
	for ((i = 1; i <= $2; i++)); do
		echo "Ich lege gerade sim$i an!"
		mkdir -p /"$STARTVERZEICHNIS"/sim"$i"/bin/config-include
        mkdir -p /"$STARTVERZEICHNIS"/sim"$i"/bin/Regions
        cp "$AKTUELLEVERZ"/config-include/GridCommon.ini /"$STARTVERZEICHNIS"/sim"$i"/bin/config-include
        cp "$AKTUELLEVERZ"/OpenSim.ini /"$STARTVERZEICHNIS"/sim"$i"/bin
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
        regionconfig "sim$i" "$((LOCALX + "$i")),$((LOCALY + "$i"))" "$LANDGOESSE" "$((9100 + "$i"))" "/$STARTVERZEICHNIS/sim$i/bin/Regions/Regions.ini.Beispiel"
        fi

        if  [ "$REGIONAKTIV" = "ja" ]; then
        regionconfig "sim$i" "$((LOCALX + "$i")),$((LOCALY + "$i"))" "$LANDGOESSE" "$((9100 + "$i"))" "/$STARTVERZEICHNIS/sim$i/bin/Regions/Regions.ini"
        fi        

        flotsamconfig "/$STARTVERZEICHNIS/sim$i/bin/config-include/FlotsamCache.ini"

        echo "Schreibe sim$i in $SIMDATEI, legen sie bitte Datenbank $MYSQLDATABASE an."
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

osconfigstruktur 1 "$CONFIGANZAHL"
