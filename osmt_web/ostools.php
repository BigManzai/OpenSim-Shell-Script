<!DOCTYPE html>
<html>
<title>opensimMultitool</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
<body>

<?php
// Login
session_start();
if($_SESSION['userid'] === 1)
{
 // geschützer bereich
 echo "Du bist eingeloggt.";
}
else 
{
    //echo '<a href="login.php">Log dich bitte ein</a>';
	header('Location: ostools.php'); // Zurueck zum Login.
	//exit ();
}
?>


<div class="w3-container w3-blue">
  <h1>opensimMultitool</h1>
</div>

<!-- Diese Links fuegen eine Navigation hinzu
<div class="w3-bar w3-green">
  <a href="#" class="w3-bar-item w3-button">Home</a>
  <a href="#" class="w3-bar-item w3-button">Link 1</a>
  <a href="#" class="w3-bar-item w3-button">Link 2</a>
  <a href="#" class="w3-bar-item w3-button">Link 3</a>
</div>
 -->

<img src="opensimMultitool.jpg" alt="opensimMultitool" style="width:60%">

<style>
.w3-button {width:150px;}
</style>

<div class="w3-container">
  <p>opensimMultitool ist eine Sammlung von automatisierter aufgaben für den OpenSimulator.</p>
</div>

<?php
// Funktion zum aufruf von opensim.sh Funktionen.
function commandaufruf(string $funktionsname)
{
    $ausgabe=null; $rueckgabewert=null;
    $zusammengesetzt="/opt/opensim.sh $funktionsname";
    exec($zusammengesetzt, $ausgabe, $rueckgabewert);

    foreach ($ausgabe as $bildschirmausgabe)
    {
        echo "<li>$bildschirmausgabe</li>";        
    }
}
?>

<?php
if ($_GET['start']) {
  # Dieser Code wird ausgefuehrt, wenn ?start=true gesetzt ist.
  commandaufruf("autostart");
}
if ($_GET['stop']) {
    # Dieser Code wird ausgefuehrt, wenn ?stop=true gesetzt ist.
	commandaufruf("autostop");
}
if ($_GET['restart']) {
	# Dieser Code wird ausgefuehrt, wenn ?restart=true gesetzt ist.
	commandaufruf("restart");
}
?>

<div class="w3-container">
  <!-- Dieser Link fuegt Ihrer URL ostools.php?start=true ?start=true hinzu -->
  <p><a href="?start=true" class="w3-button w3-blue w3-hover-green">Grid Start</a> Startet das gesamte Grid.</p>
  <!-- Dieser Link fuegt Ihrer URL ostools.php?stop=true ?stop=true hinzu -->
  <p><a href="?stop=true" class="w3-button w3-blue w3-hover-green">Grid Stop</a> Stoppt das gesamte Grid.</p>
  <!-- Dieser Link fuegt Ihrer URL ostools.php?restart=true ?restart=true hinzu -->
  <p><a href="?restart=true" class="w3-button w3-blue w3-hover-green">Grid Restart</a> Das gesamte Grid neu starten.</p>
</div>



</body>
<div class="w3-container w3-green">
  <h5>opensimMultitool</h5>
</div>
</html>



<?php
// Weitere moeglichkeiten aus der Hilfe:

	//"restart 		    - hat keine Parameter	- Startet das gesamte Grid neu."
	//"autostop 		- hat keine Parameter	- Stoppt das gesamte Grid."
	//"autostart 		- hat keine Parameter	- Startet das gesamte Grid."
	//"works 			- Verzeichnisname	- Einzelne screens auf Existenz pruefen."
	//"osstart 		    - Verzeichnisname	- Startet einen einzelnen Simulator."
	//"osstop 			- Verzeichnisname	- Stoppt einen einzelnen Simulator."
	//"meineregionen 	- hat keine Parameter   - listet alle Regionen aus den Konfigurationen auf."
	//"autologdel		- hat keine Parameter	- Loescht alle Log Dateien."
	//"automapdel		- hat keine Parameter	- Loescht alle Map Karten."
	//"newregionini		- $(tput setaf 4)hat Abfragen-Erstellt eine neue Regions.ini in ein Regions Verzeichnis."

	//"regionbackup 	- Verzeichnisname $(tput setab 4)Regionsname - Backup einer ausgewaehlten Region."
	//"assetdel 		- screen_name $(tput setab 4)Regionsname $(tput setab 2)Objektname - Einzelnes Asset loeschen."
	//"oscommand 		- Verzeichnisname $(tput setab 3)Region $(tput setab 4)Konsolenbefehl Parameter - Konsolenbefehl senden."
	//"gridstart 		- hat keine Parameter - Startet Robust und Money. "
	//"gridstop 		- hat keine Parameter - Beendet Robust und Money. "
	//"rostart 		    - hat keine Parameter - Startet Robust Server."
	//"rostop 			- hat keine Parameter - Stoppt Robust Server."
	//"mostart 		    - hat keine Parameter - Startet Money Server."
	//"mostop 			- hat keine Parameter - Stoppt Money Server."
	//"autosimstart 	- hat keine Parameter - Startet alle Regionen."
	//"autosimstop 		- hat keine Parameter - Beendet alle Regionen. "
	//"autoscreenstop	- hat keine Parameter - Killt alle OpenSim Screens."
	//"logdel 			- Verzeichnisname     - Loescht alle Simulator Log Dateien im Verzeichnis."
	//"mapdel 			- Verzeichnisname     - Loescht alle Simulator Map-Karten im Verzeichnis."
	//"settings 		- hat keine Parameter - setzt Linux Einstellungen."
	//"configlesen 		- Verzeichnisname     - Alle Regionskonfigurationen im Verzeichnis anzeigen."

	//"osupgrade 		- hat keine Parameter - Installiert eine neue OpenSim Version."
	//"autoregionbackup	- hat keine Parameter - Backup aller Regionen."
	//"oscopy			- Verzeichnisname     - Kopiert den Simulator."
	//"osstruktur		- ersteSIM $(tput setab 4)letzteSIM  - Legt eine Verzeichnisstruktur an."
	//"osprebuild		- $(tput setab 2)Versionsnummer      - Aendert die Versionseinstellungen 0.9.2.XXXX"
	//"compilieren 		- hat keine Parameter - Kopiert fehlende Dateien und Kompiliert."
	//"oscompi 		    - hat keine Parameter - Kompiliert einen neuen OpenSimulator ohne kopieren."
	//"scriptcopy 		- hat keine Parameter - Kopiert die Scripte in den Source."
	//"moneycopy 		- hat keine Parameter - Kopiert Money Source in den OpenSimulator Source."
	//"osdelete 		- hat keine Parameter - Loescht alte OpenSim Version."
	//"regionsiniteilen 	- Verzeichnisname $(tput setab 3)Region - kopiert aus der Regions.ini eine Region heraus."
	//"autoregionsiniteilen 	- hat keine Parameter - aus allen Regions.ini alle Regionen vereinzeln."
	//"RegionListe 		- hat keine Parameter - Die RegionList.ini erstellen."
	//"Regionsdateiliste 	- $(tput setab 4)-b Bildschirm oder -d Datei Verzeichnisname - Regionsdateiliste erstellen."
	//"osgitholen 		- hat keine Parameter - kopiert eine OpenSimulator Git Entwicklerversion."
	//"terminator 		- hat keine Parameter - Killt alle laufenden Screens."

	//"osgridcopy		- hat keine Parameter - Automatisches kopieren aus dem opensim Verzeichniss."
	//"makeaot			- hat keine Parameter - aot Dateien erstellen."
	//"cleanaot		    - hat keine Parameter - aot Dateien entfernen."
	//"monoinstall		- hat keine Parameter - mono 6.x installation."
	//"installationen	- hat keine Parameter - Linux Pakete - installationen aufisten."
	//"serverinstall	- hat keine Parameter - alle benoetigten Linux Pakete installieren."
	//"osbuilding		- Versionsnummer - Upgrade des OpenSimulator aus einer Source ZIP Datei."
	//"createuser 		-  Vorname  $(tput setab 4) Nachname  $(tput setab 2) Passwort  $(tput setab 3) E-Mail  - Grid Benutzer anlegen."

	//"db_anzeigen	    -  DBBENUTZER  $(tput setab 4) DBDATENBANKNAME  - Alle Datenbanken anzeigen."
	//"create_db	    -  DBBENUTZER  $(tput setab 4) DBPASSWORT  $(tput setab 2) DATENBANKNAME  - Datenbank anlegen."
	
	//"delete_db	    -  DBBENUTZER  $(tput setab 4) DBPASSWORT  $(tput setab 2) DATENBANKNAME  - Datenbank loeschen."
	//"leere_db	        -  DBBENUTZER  $(tput setab 4) DBPASSWORT  $(tput setab 2) DATENBANKNAME  - Datenbank leeren."
	//"allrepair_db	    -  DBBENUTZER  $(tput setab 4) DBPASSWORT  - Alle Datenbanken Reparieren und Optimieren."
	//"db_sichern	    -  DBBENUTZER  $(tput setab 4) DBPASSWORT  $(tput setab 2) DATENBANKNAME  - Datenbank sichern."
	//"mysql_neustart	- hat keine Parameter - MySQL neu starten."

	//"regionsabfrage	-  DBBENUTZER  $(tput setab 4) DBPASSWORT  $(tput setab 2) DATENBANKNAME  - Regionsliste."
	//"regionsuri	    -  DBBENUTZER  $(tput setab 4) DBPASSWORT  $(tput setab 2) DATENBANKNAME  - URI pruefen sortiert nach URI."
	//"regionsport	    -  DBBENUTZER  $(tput setab 4) DBPASSWORT  $(tput setab 2) DATENBANKNAME  - Ports pruefen sortiert nach Ports."

	//"opensimholen	    - hat keine Parameter - Laedt eine Regulaere OpenSimulator Version herunter."
	//"mysqleinstellen	- hat keine Parameter - mySQL Konfiguration auf Server Einstellen und neu starten."
	//"conf_write	    -  SUCHWORT  $(tput setab 4) ERSATZWORT  $(tput setab 2) PFAD  $(tput setab 3) DATEINAME  - Konfigurationszeile schreiben."
	//"conf_delete	    -  SUCHWORT  $(tput setab 4) PFAD  $(tput setab 2) DATEINAME  - Konfigurationszeile loeschen."
	//"conf_read	    -  SUCHWORT  $(tput setab 4) PFAD  $(tput setab 2) DATEINAME  - Konfigurationszeile lesen."
	//"landclear 	    - screen_name $(tput setab 4)Regionsname - Land clear - Loescht alle Parzellen auf dem Land."

	//"db_tablesplitt   -  /Pfad/SQL_Datei.sql  Alle Tabellen aus SQL Sicherung in ein gleichnamigen Verzeichnis extrahieren."
	//"db_tablextract   -  /Pfad/SQL_Datei.sql $(tput setab 4) Tabellenname  Einzelne Tabelle aus SQL Backup extrahieren."
	//"db_backuptabellen    - username $(tput setab 4)password $(tput setab 3)databasename  Backup eine Datenbanken Tabellenweise speichern."
	//"db_restorebackuptabellen - username $(tput setab 4)password $(tput setab 3)databasename $(tput setab 2)newdatabasename  Restore Datenbank Tabellenweise wiederherstellen."

	//"loadinventar     - NAME VERZEICHNIS PASSWORD DATEINAMEmitPFAD  - laedt Inventar aus einer iar"
	//"saveinventar     - NAME VERZEICHNIS PASSWORD DATEINAMEmitPFAD  - speichert Inventar in einer iar"
	//"unlockexample	- hat keine Parameter - Benennt alle example Dateien um."

	// Alle moeglichkeiten kurz und knapp:

	// 	schreibeinfo) schreibeinfo ;;
	// makeverzeichnisliste) makeverzeichnisliste ;;
	// makeregionsliste) makeregionsliste ;;
	// checkfile) checkfile "$2" ;;
	// r | restart) autorestart ;;
	// sta | autosimstart | simstart) autosimstart ;;
	// sto | autosimstop | simstop) autosimstop ;;
	// astart | autostart | start) autostart ;;
	// astop | autostop | stop) autostop ;;
	// amd | automapdel) automapdel ;;
	// ald | autologdel) autologdel ;;
	// s | settings) ossettings ;;
	// rs | robuststart | rostart) rostart ;;
	// ms | moneystart | mostart) mostart ;;
	// rsto | robuststop | rostop) rostop ;;
	// mstop | moneystop | mostop) mostop ;;
	// osto | osstop) osstop "$2" ;;
	// osta | osstart) osstart "$2" ;;
	// gsta | gridstart) gridstart ;;
	// gsto | gridstop) gridstop ;;
	// sd | screendel) autoscreenstop ;;
	// l | list | screenlist) screenlist ;;
	// w | works) works "$2" ;;
	// md | mapdel) mapdel "$2" ;;
	// ld | logdel) logdel "$2" ;;
	// ss | osscreenstop) osscreenstop "$2" ;;
	// h | hilfe | help) hilfe ;;
	// asdel | assetdel) assetdel "$2" "$3" "$4" ;;
	// e | terminator) terminator ;;
	// ou | osupgrade) osupgrade ;;
	// oscopyrobust) oscopyrobust ;;
	// oscopysim) oscopysim ;;
	// oscopy) oscopy "$2" ;;
	// rb | regionbackup) regionbackup "$2" "$3" ;;
	// arb | autoregionbackup) autoregionbackup ;;
	// compi | compilieren) compilieren ;;
	// sc | scriptcopy) scriptcopy ;;
	// mc | moneycopy) moneycopy ;;
	// oscompi) oscompi ;;
	// od | osdelete) osdelete ;;
	// os | osstruktur) osstruktur "$2" "$3" ;;
	// cl | configlesen) configlesen "$2" ;;
	// osc | com | oscommand) oscommand "$2" "$3" "$4" ;;
	// osc2 | com2 | oscommand2) oscommand2 "$2" "$3" "$4" "$5" ;;
	// rl | Regionsdateiliste | regionsconfigdateiliste) regionsconfigdateiliste "$3" "$2" ;;
	// rn | RegionListe) regionliste ;;
	// mr | meineregionen) meineregionen ;;
	// moneydelete) moneydelete ;;
	// rit | regionsiniteilen) regionsiniteilen "$2" "$3" ;;
	// arit | autoregionsiniteilen) autoregionsiniteilen ;;
	// regionsinisuchen) regionsinisuchen ;;
	// osg | osgitholen) osgitholen ;;
	// osprebuild) osprebuild "$2" ;;
	// chrisoscopy) chrisoscopy ;;
	// cleaninstall) cleaninstall ;;
	// autoallclean) autoallclean ;;
	// allclean) allclean "$2" ;;
	// makeaot) makeaot ;;
	// cleanaot) cleanaot ;;
	// pythoncopy) pythoncopy ;;
	// get_value_from_Region_key) get_value_from_Region_key ;;
	// autorobustmapdel) autorobustmapdel ;;
	// info) info ;;
	// mutelistcopy) mutelistcopy ;;
	// searchcopy) searchcopy ;;
	// monoinstall) monoinstall ;;
	// installationen) installationen ;;
	// serverinstall) serverinstall ;;
	// konsolenhilfe) konsolenhilfe ;;
	// simstats) simstats "$2" ;;
	// osbuilding) osbuilding "$2" ;;
	// createuser) createuser "$2" "$3" "$4" "$5" "$6" ;;
	// db_benutzer_anzeigen) db_benutzer_anzeigen "$2" "$3" ;;
	// create_db) create_db "$2" "$3" "$4" ;;
	// create_db_user) create_db_user "$2" "$3" "$4" "$5" ;;
	// delete_db) delete_db "$2" "$3" "$4" ;;
	// leere_db) leere_db "$2" "$3" "$4" ;;
	// allrepair_db) allrepair_db "$2" "$3" ;;
	// mysql_neustart) mysql_neustart ;;
	// db_sichern) db_sichern "$2" "$3" "$4" ;;
	// tabellenabfrage) tabellenabfrage "$2" "$3" "$4" ;;
	// regionsabfrage) regionsabfrage "$2" "$3" "$4" ;;
	// regionsuri) regionsuri "$2" "$3" "$4" ;;
	// regionsport) regionsport "$2" "$3" "$4" ;;
	// setpartner) setpartner "$2" "$3" "$4" "$5" "$6" ;;
	// makewebmaps) makewebmaps ;;
	// opensimholen) opensimholen ;;
	// conf_write) conf_write "$2" "$3" "$4" "$5" ;;
	// conf_delete) conf_delete "$2" "$3" "$4" ;;
	// conf_read) conf_read "$2" "$3" "$4" ;;
	// ipsetzen) ipsetzen ;;
	// neuegridconfig) neuegridconfig ;;
	// ramspeicher) ramspeicher ;;
	// mysqleinstellen) mysqleinstellen ;;
	// landclear) landclear "$2" "$3" ;;
	// commandhelp) commandhelp ;;
	// gridcommonini) gridcommonini ;;
	// robustini) robustini ;;
	// opensimini) opensimini ;;
	// moneyserverini) moneyserverini ;;
	// regionini) regionini ;;
	// osslenableini) osslenableini ;;
	// loadinventar) loadinventar "$2" "$3" "$4" "$5" ;;
	// saveinventar) saveinventar "$2" "$3" "$4" "$5" ;;
	// infodialog) infodialog ;;
	// fortschritsanzeige) fortschritsanzeige ;;
	// moneygitcopy) moneygitcopy ;;
	// scriptgitcopy) scriptgitcopy ;;
	// unlockexample) unlockexample ;;
	// passwdgenerator) passwdgenerator "$2" ;;
	// configurecopy) configurecopy ;;
	// menuworks) menuworks "$2" ;;
	// waslauft) waslauft ;;
	// rebootdatum) rebootdatum ;;
	// menuinfo) menuinfo ;;
	// funktionenmenu) funktionenmenu ;;
	// expertenmenu) expertenmenu ;;
	// downloados) downloados ;;
	// oswriteconfig) oswriteconfig "$2" ;;
	// menuoswriteconfig) menuoswriteconfig "$2" ;;
	// finstall) finstall "$2" ;;
	// rologdel) rologdel ;;
	// osgridcopy) osgridcopy ;;
	// screenlistrestart) screenlistrestart ;;
	// db_all_user) db_all_user "$2" "$3" "$4" ;;
	// db_all_uuid) db_all_uuid "$2" "$3" "$4" ;;
	// db_all_name) db_all_name "$2" "$3" "$4" ;;
	// db_user_data) db_user_data "$2" "$3" "$4" "$5" "$6" ;;
	// db_user_infos) db_user_infos "$2" "$3" "$4" "$5" "$6" ;;
	// db_user_uuid) db_user_uuid "$2" "$3" "$4" "$5" "$6" ;;
	// db_foldertyp_user) db_foldertyp_user "$2" "$3" "$4" "$5" "$6" "$7" ;;
	// db_all_userfailed) db_all_userfailed "$2" "$3" "$4" "$5" "$6" ;;
	// db_userdate) db_userdate "$2" "$3" "$4" "$5" "$6" ;;
	// db_false_email) db_false_email "$2" "$3" "$4" ;;
	// set_empty_user) set_empty_user "$2" "$3" "$4" "$5" "$6" "$7" ;;
	// db_create) db_create "$2" "$3" "$4" ;;
	// db_dbuserrechte) db_dbuserrechte "$2" "$3" "$4" ;;
	// db_deldbuser) db_deldbuser "$2" "$3" "$4" ;;
	// db_create_new_dbuser) db_create_new_dbuser "$2" "$3" "$4" "$5" ;;
	// db_anzeigen) db_anzeigen "$2" "$3" "$4" ;;
	// db_dbuser) db_dbuser "$2" "$3" ;;
	// db_delete) db_delete "$2" "$3" "$4" ;;
	// db_empty) db_empty "$2" "$3" "$4" ;;
	// db_tables) db_tables "$2" "$3" "$4" ;;
	// db_tables_dialog) db_tables_dialog "$2" "$3" "$4" ;;
	// db_regions) db_regions "$2" "$3" "$4" ;;
	// db_regionsuri) db_regionsuri "$2" "$3" "$4" ;;
	// db_regionsport) db_regionsport "$2" "$3" "$4" ;;
	// db_email_setincorrectuseroff) db_email_setincorrectuseroff "$2" "$3" "$4" ;;
	// db_setuserofline) db_setuserofline "$2" "$3" "$4" "$5" "$6" ;;
	// db_setuseronline) db_setuseronline "$2" "$3" "$4" "$5" "$6" ;;
	// warnbox) warnbox "$2" ;;
	// db_anzeigen_dialog) db_anzeigen_dialog "$2" "$3" ;;
	// db_all_user_dialog) db_all_user_dialog "$2" "$3" "$4" ;;
	// db_all_uuid_dialog) db_all_uuid_dialog "$2" "$3" "$4" ;;
	// installmariadb18) installmariadb18 ;;
	// installmariadb22) installmariadb22 ;;
	// serverinstall22) serverinstall22 ;;
	// installbegin) installbegin ;;
	// linuxupgrade) linuxupgrade ;;
	// installubuntu22) installubuntu22 ;;
	// installmono22) installmono22 ;;
	// installphpmyadmin) installphpmyadmin ;;
	// ufwset) ufwset ;;
	// installationhttps22) installationhttps22 "$2" "$3" ;;
	// installfinish) installfinish ;;
	// functionslist) functionslist ;;
	// robustbackup) robustbackup ;;
	// backupdatum) backupdatum ;;
	// db_backuptabellen) db_backuptabellen "$2" "$3" "$4" ;;
	// db_restorebackuptabellen) db_restorebackuptabellen "$2" "$3" "$4" "$5" ;;
	// default_master_connection) default_master_connection "$2" "$3" ;;
	// connection_name) connection_name "$2" "$3" ;;
	// MASTER_USER) MASTER_USER "$2" "$3" ;;
	// MASTER_PASSWORD) MASTER_PASSWORD "$2" "$3" ;;
	// MASTER_HOST) MASTER_HOST "$2" "$3" "$4" ;;
	// MASTER_PORT) MASTER_PORT "$2" "$3" "$4" "$5" ;;
	// MASTER_CONNECT_RETRY) MASTER_CONNECT_RETRY "$2" "$3" "$4" ;;
	// MASTER_SSL) MASTER_SSL "$2" "$3" ;;
	// MASTER_SSL_CA) MASTER_SSL_CA "$2" "$3" ;;
	// MASTER_SSL_CAPATH) MASTER_SSL_CAPATH "$2" "$3" ;;
	// MASTER_SSL_CERT) MASTER_SSL_CERT "$2" "$3" ;;
	// MASTER_SSL_CRL) MASTER_SSL_CRL "$2" "$3" ;;
	// MASTER_SSL_CRLPATH) MASTER_SSL_CRLPATH "$2" "$3" ;;
	// MASTER_SSL_KEY) MASTER_SSL_KEY "$2" "$3" ;;
	// MASTER_SSL_CIPHER) MASTER_SSL_CIPHER "$2" "$3" ;;
	// MASTER_SSL_VERIFY_SERVER_CERT) MASTER_SSL_VERIFY_SERVER_CERT "$2" "$3" ;;
	// MASTER_LOG_FILE) MASTER_LOG_FILE "$2" "$3" "$4" "$5" ;;
	// MASTER_LOG_POS) MASTER_LOG_POS "$2" "$3" "$4" "$5" ;;
	// RELAY_LOG_FILE) RELAY_LOG_FILE "$2" "$3" "$4" "$5" ;;
	// RELAY_LOG_POS) RELAY_LOG_POS "$2" "$3" "$4" "$5" ;;
	// MASTER_USE_GTID) MASTER_USE_GTID "$2" "$3" ;;
	// MASTER_USE_GTID2) MASTER_USE_GTID2 "$2" "$3" "$4" ;;
	// IGNORE_SERVER_IDS) IGNORE_SERVER_IDS "$2" "$3" "$4" ;;
	// DO_DOMAIN_IDS) DO_DOMAIN_IDS "$2" "$3" "$4" ;;
	// DO_DOMAIN_IDS2) DO_DOMAIN_IDS2 "$2" "$3" ;;
	// IGNORE_DOMAIN_IDS) IGNORE_DOMAIN_IDS "$2" "$3" "$4" ;;
	// MASTER_DELAY) MASTER_DELAY "$2" "$3" "$4" ;;
	// Replica_Backup) Replica_Backup "$2" "$3" "$4" "$5" ;;
	// Replica_Backup2) Replica_Backup2 "$2" "$3" "$4" ;;
	// ReplikatKoordinaten) ReplikatKoordinaten "$2" "$3" "$4" "$5" "$6" "$7" "$8" ;;
	// textbox) textbox "$8" ;;
	// apacheerror) apacheerror ;;
	// mysqldberror) mysqldberror ;;
	// mariadberror) mariadberror ;;
	// ufwlog) ufwlog ;;
	// authlog) authlog ;;
	// accesslog) accesslog ;;
	// fpspeicher) fpspeicher ;;
	// db_tablesplitt) db_tablesplitt "$2" ;;
	// db_tablextract) db_tablextract "$2" "$3" ;;
	// db_tablextract_regex) db_tablextract_regex "$2" "$3" "$4" ;;
	// systeminformation) systeminformation ;;
	// radiolist) radiolist ;;
	// newregionini) newregionini ;;
	// ConfigSet) ConfigSet "$2" ;;
	// AutoInstall) AutoInstall ;;
	// OpenSimConfig) OpenSimConfig ;;
	// GridCommonConfig) GridCommonConfig ;;
	// osslEnableConfig) osslEnableConfig ;;
	// RegionsConfig) RegionsConfig ;;
	// RobustConfig) RobustConfig ;;
	// historylogclear) historylogclear "$2" ;;
	// ScreenLog) ScreenLog ;;
	// dotnetinfo) dotnetinfo ;;
	// ende) ende ;; # Test
	// fehler) fehler ;; # Test
	// osdauerstop) osdauerstop "$2" ;; # Test
	// osstarteintrag) osstarteintrag "$2" ;; # Test
	// menuosdauerstop) menuosdauerstop "$2" ;; # Test
	// osdauerstart) osdauerstart "$2" ;; # Test
	// menuosdauerstart) menuosdauerstart "$2" ;; # Test
	// osstarteintragdel) osstarteintragdel "$2" ;; # Test
    ?>