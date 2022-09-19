<!DOCTYPE html>
<html>
<title>opensimMultitool</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
<body>
<?php
// Funktion zum aufruf von opensim.sh Funktionen.
function commandaufruf(string $funktionsname)
{
    $ausgabe=null; $rueckgabewert=null;
	$datei="/opt/opensim.sh";
    $zusammengesetzt="$datei $funktionsname";
    exec($zusammengesetzt, $ausgabe, $rueckgabewert);

	?> 	<div class="alert">
		<span class="closebtn" onclick="this.parentElement.style.display='none';">&times;</span> 
	<?php 

    foreach ($ausgabe as $bildschirmausgabe)
    {
		echo "<li>".$bildschirmausgabe."</li>";		
    }

	?> </div> <?php
}
// Funktion zum aufruf von opensim.sh Funktionen mit mehreren Parametern.
function commandaufruf2(string $funktionsname, string $parameter2)
{
    $ausgabe=null; $rueckgabewert=null;
	$datei="/opt/opensim.sh";
    $zusammengesetzt="$datei $funktionsname $parameter2";
    exec($zusammengesetzt, $ausgabe, $rueckgabewert);

	?> 	<div class="alert">
		<span class="closebtn" onclick="this.parentElement.style.display='none';">&times;</span> 
	<?php 

    foreach ($ausgabe as $bildschirmausgabe)
    {
		echo "<li>".$bildschirmausgabe."</li>";		
    }

	?> </div> <?php
}
function commandaufruf3(string $funktionsname, string $parameter2, string $parameter3)
{
    $ausgabe=null; $rueckgabewert=null;
	$datei="/opt/opensim.sh";
    $zusammengesetzt="$datei $funktionsname $parameter2 $parameter3";
    exec($zusammengesetzt, $ausgabe, $rueckgabewert);

	?> 	<div class="alert">
		<span class="closebtn" onclick="this.parentElement.style.display='none';">&times;</span> 
	<?php 

    foreach ($ausgabe as $bildschirmausgabe)
    {
		echo "<li>".$bildschirmausgabe."</li>";		
    }

	?> </div> <?php
}
function commandaufruf4(string $funktionsname, string $parameter2, string $parameter3, string $parameter4)
{
    $ausgabe=null; $rueckgabewert=null;
	$datei="/opt/opensim.sh";
    $zusammengesetzt="$datei $funktionsname $parameter2 $parameter3 $parameter4";
    exec($zusammengesetzt, $ausgabe, $rueckgabewert);

	?> 	<div class="alert">
		<span class="closebtn" onclick="this.parentElement.style.display='none';">&times;</span> 
	<?php 

    foreach ($ausgabe as $bildschirmausgabe)
    {
		echo "<li>".$bildschirmausgabe."</li>";		
    }

	?> </div> <?php
}
function commandaufruf5(string $funktionsname, string $parameter2, string $parameter3, string $parameter4, string $parameter5)
{
    $ausgabe=null; $rueckgabewert=null;
	$datei="/opt/opensim.sh";
    $zusammengesetzt="$datei $funktionsname $parameter2 $parameter3 $parameter4 $parameter5";
    exec($zusammengesetzt, $ausgabe, $rueckgabewert);

	?> 	<div class="alert">
		<span class="closebtn" onclick="this.parentElement.style.display='none';">&times;</span> 
	<?php 

    foreach ($ausgabe as $bildschirmausgabe)
    {
		echo "<li>".$bildschirmausgabe."</li>";		
    }

	?> </div> <?php
}
function commandaufruf6(string $funktionsname, string $parameter2, string $parameter3, string $parameter4, string $parameter5, string $parameter6)
{
    $ausgabe=null; $rueckgabewert=null;
	$datei="/opt/opensim.sh";
    $zusammengesetzt="$datei $funktionsname $parameter2 $parameter3 $parameter4 $parameter5 $parameter6";
    exec($zusammengesetzt, $ausgabe, $rueckgabewert);

	?> 	<div class="alert">
		<span class="closebtn" onclick="this.parentElement.style.display='none';">&times;</span> 
	<?php 

    foreach ($ausgabe as $bildschirmausgabe)
    {
		echo "<li>".$bildschirmausgabe."</li>";		
    }

	?> </div> <?php
}
function commandaufruf7(string $funktionsname, string $parameter2, string $parameter3, string $parameter4, string $parameter5, string $parameter6, string $parameter7)
{
    $ausgabe=null; $rueckgabewert=null;
	$datei="/opt/opensim.sh";
    $zusammengesetzt="$datei $funktionsname $parameter2 $parameter3 $parameter4 $parameter5 $parameter6 $parameter7";
    exec($zusammengesetzt, $ausgabe, $rueckgabewert);

	?> 	<div class="alert">
		<span class="closebtn" onclick="this.parentElement.style.display='none';">&times;</span> 
	<?php 

    foreach ($ausgabe as $bildschirmausgabe)
    {
		echo "<li>".$bildschirmausgabe."</li>";		
    }

	?> </div> <?php
}
function commandaufruf8(string $funktionsname, string $parameter2, string $parameter3, string $parameter4, string $parameter5, string $parameter6, string $parameter7, string $parameter8)
{
    $ausgabe=null; $rueckgabewert=null;
	$datei="/opt/opensim.sh";
    $zusammengesetzt="$datei $funktionsname $parameter2 $parameter3 $parameter4 $parameter5 $parameter6 $parameter7 $parameter8";
    exec($zusammengesetzt, $ausgabe, $rueckgabewert);

	?> 	<div class="alert">
		<span class="closebtn" onclick="this.parentElement.style.display='none';">&times;</span> 
	<?php 

    foreach ($ausgabe as $bildschirmausgabe)
    {
		echo "<li>".$bildschirmausgabe."</li>";		
    }

	?> </div> <?php
}
?>

<?php
//0
if ($_GET['start']) {commandaufruf("autostart");}
if ($_GET['stop']) {commandaufruf("autostop");}
if ($_GET['restart']) {commandaufruf("restart");}

if ($_GET['meineregionen']) {commandaufruf("meineregionen");}
if ($_GET['autologdel']) {commandaufruf("autologdel");}
if ($_GET['automapdel']) {commandaufruf("automapdel");}
if ($_GET['rostart']) {commandaufruf("rostart");}
if ($_GET['rostop']) {commandaufruf("rostop");}
if ($_GET['mostart']) {commandaufruf("mostart");}
if ($_GET['mostop']) {commandaufruf("mostop");}
if ($_GET['autosimstart']) {commandaufruf("autosimstart");}
if ($_GET['autosimstop']) {commandaufruf("autosimstop");}
if ($_GET['autoscreenstop']) {commandaufruf("autoscreenstop");}
if ($_GET['settings']) {commandaufruf("settings");}
if ($_GET['osupgrade']) {commandaufruf("osupgrade");}
if ($_GET['autoregionbackup']) {commandaufruf("autoregionbackup");}
if ($_GET['compilieren']) {commandaufruf("compilieren");}
if ($_GET['oscompi']) {commandaufruf("oscompi");}
if ($_GET['scriptcopy']) {commandaufruf("scriptcopy");}
if ($_GET['moneycopy']) {commandaufruf("moneycopy");}
if ($_GET['osdelete']) {commandaufruf("osdelete");}
if ($_GET['autoregionsiniteilen']) {commandaufruf("autoregionsiniteilen");}
if ($_GET['RegionListe']) {commandaufruf("RegionListe");}
if ($_GET['osgitholen']) {commandaufruf("osgitholen");}
if ($_GET['terminator']) {commandaufruf("terminator");}
if ($_GET['osgridcopy']) {commandaufruf("osgridcopy");}
if ($_GET['makeaot']) {commandaufruf("makeaot");}
if ($_GET['cleanaot']) {commandaufruf("cleanaot");}
if ($_GET['monoinstall']) {commandaufruf("monoinstall");}
if ($_GET['installationen']) {commandaufruf("installationen");}
if ($_GET['serverinstall']) {commandaufruf("serverinstall");}
if ($_GET['mysql_neustart']) {commandaufruf("mysql_neustart");}
if ($_GET['opensimholen']) {commandaufruf("opensimholen");}
if ($_GET['mysqleinstellen']) {commandaufruf("mysqleinstellen");}
if ($_GET['unlockexample']) {commandaufruf("unlockexample");}
if ($_GET['makeverzeichnisliste']) {commandaufruf("makeverzeichnisliste");}
if ($_GET['makeregionsliste']) {commandaufruf("makeregionsliste");}
if ($_GET['schreibeinfo']) {commandaufruf("schreibeinfo");}
if ($_GET['screenlist']) {commandaufruf("screenlist");}
if ($_GET['hilfe']) {commandaufruf("hilfe");}
if ($_GET['oscopyrobust']) {commandaufruf("oscopyrobust");}
if ($_GET['oscopysim']) {commandaufruf("oscopysim");}
if ($_GET['moneydelete']) {commandaufruf("moneydelete");}
if ($_GET['regionsinisuchen']) {commandaufruf("regionsinisuchen");}
if ($_GET['chrisoscopy']) {commandaufruf("chrisoscopy");}
if ($_GET['cleaninstall']) {commandaufruf("cleaninstall");}
if ($_GET['autoallclean']) {commandaufruf("autoallclean");}
if ($_GET['pythoncopy']) {commandaufruf("pythoncopy");}
if ($_GET['get_value_from_Region_key']) {commandaufruf("get_value_from_Region_key");}
if ($_GET['autorobustmapdel']) {commandaufruf("autorobustmapdel");}
if ($_GET['info']) {commandaufruf("info");}
if ($_GET['mutelistcopy']) {commandaufruf("mutelistcopy");}
if ($_GET['searchcopy']) {commandaufruf("searchcopy");}
if ($_GET['konsolenhilfe']) {commandaufruf("konsolenhilfe");}
if ($_GET['makewebmaps']) {commandaufruf("makewebmaps");}
if ($_GET['ipsetzen']) {commandaufruf("ipsetzen");}
if ($_GET['neuegridconfig']) {commandaufruf("neuegridconfig");}
if ($_GET['ramspeicher']) {commandaufruf("ramspeicher");}
if ($_GET['commandhelp']) {commandaufruf("commandhelp");}
if ($_GET['gridcommonini']) {commandaufruf("gridcommonini");}
if ($_GET['robustini']) {commandaufruf("robustini");}
if ($_GET['opensimini']) {commandaufruf("opensimini");}
if ($_GET['moneyserverini']) {commandaufruf("moneyserverini");}
if ($_GET['regionini']) {commandaufruf("regionini");}
if ($_GET['osslenableini']) {commandaufruf("osslenableini");}
if ($_GET['moneygitcopy']) {commandaufruf("moneygitcopy");}
if ($_GET['scriptgitcopy']) {commandaufruf("scriptgitcopy");}
if ($_GET['configurecopy']) {commandaufruf("configurecopy");}
if ($_GET['waslauft']) {commandaufruf("waslauft");}
if ($_GET['rebootdatum']) {commandaufruf("rebootdatum");}
if ($_GET['downloados']) {commandaufruf("downloados");}
if ($_GET['rologdel']) {commandaufruf("rologdel");}
if ($_GET['screenlistrestart']) {commandaufruf("screenlistrestart");}
if ($_GET['installmariadb18']) {commandaufruf("installmariadb18");}
if ($_GET['installmariadb22']) {commandaufruf("installmariadb22");}
if ($_GET['serverinstall22']) {commandaufruf("serverinstall22");}
if ($_GET['installbegin']) {commandaufruf("installbegin");}
if ($_GET['linuxupgrade']) {commandaufruf("linuxupgrade");}
if ($_GET['installubuntu22']) {commandaufruf("installubuntu22");}
if ($_GET['installmono22']) {commandaufruf("installmono22");}
if ($_GET['installphpmyadmin']) {commandaufruf("installphpmyadmin");}
if ($_GET['ufwset']) {commandaufruf("ufwset");}
if ($_GET['installfinish']) {commandaufruf("installfinish");}
if ($_GET['functionslist']) {commandaufruf("functionslist");}
if ($_GET['robustbackup']) {commandaufruf("robustbackup");}
if ($_GET['backupdatum']) {commandaufruf("backupdatum");}
if ($_GET['apacheerror']) {commandaufruf("apacheerror");}
if ($_GET['mysqldberror']) {commandaufruf("mysqldberror");}
if ($_GET['mariadberror']) {commandaufruf("mariadberror");}
if ($_GET['ufwlog']) {commandaufruf("ufwlog");}
if ($_GET['authlog']) {commandaufruf("authlog");}
if ($_GET['accesslog']) {commandaufruf("accesslog");}
if ($_GET['fpspeicher']) {commandaufruf("fpspeicher");}
if ($_GET['systeminformation']) {commandaufruf("systeminformation");}
if ($_GET['radiolist']) {commandaufruf("radiolist");}
if ($_GET['newregionini']) {commandaufruf("newregionini");}
if ($_GET['AutoInstall']) {commandaufruf("AutoInstall");}
if ($_GET['OpenSimConfig']) {commandaufruf("OpenSimConfig");}
if ($_GET['GridCommonConfig']) {commandaufruf("GridCommonConfig");}
if ($_GET['osslEnableConfig']) {commandaufruf("osslEnableConfig");}
if ($_GET['RegionsConfig']) {commandaufruf("RegionsConfig");}
if ($_GET['RobustConfig']) {commandaufruf("RobustConfig");}
if ($_GET['ScreenLog']) {commandaufruf("ScreenLog");}
if ($_GET['dotnetinfo']) {commandaufruf("dotnetinfo");}
//1
if ($_GET['finstall']) {commandaufruf("finstall $parameter2");}
if ($_GET['db_tablesplitt']) {commandaufruf("db_tablesplitt $parameter2");}
if ($_GET['ConfigSet']) {commandaufruf("ConfigSet $parameter2");}
if ($_GET['historylogclear']) {commandaufruf("historylogclear $parameter2");}
if ($_GET['osdauerstop']) {commandaufruf("osdauerstop $parameter2");}
if ($_GET['osstarteintrag']) {commandaufruf("osstarteintrag $parameter2");}
if ($_GET['osdauerstart']) {commandaufruf("osdauerstart $parameter2");}

if ($_GET['osstart']) {commandaufruf("osstart $parameter2");}
if ($_GET['osstart']) {commandaufruf("osstart $parameter2");}
//2
if ($_GET['regionbackup']) {commandaufruf("regionbackup $parameter2 $parameter3");}
if ($_GET['osstruktur']) {commandaufruf("osstruktur $parameter2 $parameter3");}
if ($_GET['regionsconfigdateiliste']) {commandaufruf("regionsconfigdateiliste $parameter3 $parameter2");}
if ($_GET['regionsiniteilen']) {commandaufruf("regionsiniteilen $parameter2 $parameter3");}
if ($_GET['db_benutzer_anzeigen']) {commandaufruf("db_benutzer_anzeigen $parameter2 $parameter3");}
if ($_GET['allrepair_db']) {commandaufruf("allrepair_db $parameter2 $parameter3");}
if ($_GET['landclear']) {commandaufruf("landclear $parameter2 $parameter3");}
if ($_GET['db_anzeigen_dialog']) {commandaufruf("db_anzeigen_dialog $parameter2 $parameter3");}
if ($_GET['installationhttps22']) {commandaufruf("installationhttps22 $parameter2 $parameter3");}
if ($_GET['default_master_connection']) {commandaufruf("default_master_connection $parameter2 $parameter3");}
if ($_GET['connection_name']) {commandaufruf("connection_name $parameter2 $parameter3");}
if ($_GET['MASTER_USER']) {commandaufruf("MASTER_USER $parameter2 $parameter3");}
if ($_GET['MASTER_PASSWORD']) {commandaufruf("MASTER_PASSWORD $parameter2 $parameter3");}
if ($_GET['MASTER_SSL']) {commandaufruf("MASTER_SSL $parameter2 $parameter3");}
if ($_GET['MASTER_SSL_CA']) {commandaufruf("MASTER_SSL_CA $parameter2 $parameter3");}
if ($_GET['MASTER_SSL_CAPATH']) {commandaufruf("MASTER_SSL_CAPATH $parameter2 $parameter3");}
if ($_GET['MASTER_SSL_CERT']) {commandaufruf("MASTER_SSL_CERT $parameter2 $parameter3");}
if ($_GET['MASTER_SSL_CRL']) {commandaufruf("MASTER_SSL_CRL $parameter2 $parameter3");}
if ($_GET['MASTER_SSL_CRLPATH']) {commandaufruf("MASTER_SSL_CRLPATH $parameter2 $parameter3");}
if ($_GET['MASTER_SSL_KEY']) {commandaufruf("MASTER_SSL_KEY $parameter2 $parameter3");}
if ($_GET['MASTER_SSL_CIPHER']) {commandaufruf("MASTER_SSL_CIPHER $parameter2 $parameter3");}
if ($_GET['MASTER_SSL_VERIFY_SERVER_CERT']) {commandaufruf("MASTER_SSL_VERIFY_SERVER_CERT $parameter2 $parameter3");}
if ($_GET['MASTER_USE_GTID']) {commandaufruf("MASTER_USE_GTID $parameter2 $parameter3");}
if ($_GET['DO_DOMAIN_IDS2']) {commandaufruf("DO_DOMAIN_IDS2 $parameter2 $parameter3");}
if ($_GET['db_tablextract']) {commandaufruf("db_tablextract $parameter2 $parameter3");}
if ($_GET['db_dbuser']) {commandaufruf("db_dbuser $parameter2 $parameter3");}
//3
if ($_GET['assetdel']) {commandaufruf("assetdel $parameter2 $parameter3 $parameter4");}
if ($_GET['oscommand']) {commandaufruf("oscommand $parameter2 $parameter3 $parameter4");}
if ($_GET['create_db']) {commandaufruf("create_db $parameter2 $parameter3 $parameter4");}
if ($_GET['delete_db']) {commandaufruf("delete_db $parameter2 $parameter3 $parameter4");}
if ($_GET['leere_db']) {commandaufruf("leere_db $parameter2 $parameter3 $parameter4");}
if ($_GET['db_sichern']) {commandaufruf("db_sichern $parameter2 $parameter3 $parameter4");}
if ($_GET['tabellenabfrage']) {commandaufruf("tabellenabfrage $parameter2 $parameter3 $parameter4");}
if ($_GET['regionsabfrage']) {commandaufruf("regionsabfrage $parameter2 $parameter3 $parameter4");}
if ($_GET['regionsuri']) {commandaufruf("regionsuri $parameter2 $parameter3 $parameter4");}
if ($_GET['regionsport']) {commandaufruf("regionsport $parameter2 $parameter3 $parameter4");}
if ($_GET['conf_delete']) {commandaufruf("conf_delete $parameter2 $parameter3 $parameter4");}
if ($_GET['conf_read']) {commandaufruf("conf_read $parameter2 $parameter3 $parameter4");}
if ($_GET['db_all_user']) {commandaufruf("db_all_user $parameter2 $parameter3 $parameter4");}
if ($_GET['db_all_uuid']) {commandaufruf("db_all_uuid $parameter2 $parameter3 $parameter4");}
if ($_GET['db_all_name']) {commandaufruf("db_all_name $parameter2 $parameter3 $parameter4");}
if ($_GET['db_false_email']) {commandaufruf("db_false_email $parameter2 $parameter3 $parameter4");}
if ($_GET['db_create']) {commandaufruf("db_create $parameter2 $parameter3 $parameter4");}
if ($_GET['db_dbuserrechte']) {commandaufruf("db_dbuserrechte $parameter2 $parameter3 $parameter4");}
if ($_GET['db_deldbuser']) {commandaufruf("db_deldbuser $parameter2 $parameter3 $parameter4");}
if ($_GET['db_anzeigen']) {commandaufruf("db_anzeigen $parameter2 $parameter3 $parameter4");}
if ($_GET['db_delete']) {commandaufruf("db_delete $parameter2 $parameter3 $parameter4");}
if ($_GET['db_empty']) {commandaufruf("db_empty $parameter2 $parameter3 $parameter4");}
if ($_GET['db_tables']) {commandaufruf("db_tables $parameter2 $parameter3 $parameter4");}
if ($_GET['db_tables_dialog']) {commandaufruf("db_tables_dialog $parameter2 $parameter3 $parameter4");}
if ($_GET['db_regions']) {commandaufruf("db_regions $parameter2 $parameter3 $parameter4");}
if ($_GET['db_regionsuri']) {commandaufruf("db_regionsuri $parameter2 $parameter3 $parameter4");}
if ($_GET['db_regionsport']) {commandaufruf("db_regionsport $parameter2 $parameter3 $parameter4");}
if ($_GET['db_email_setincorrectuseroff']) {commandaufruf("db_email_setincorrectuseroff $parameter2 $parameter3 $parameter4");}
if ($_GET['db_all_user_dialog']) {commandaufruf("db_all_user_dialog $parameter2 $parameter3 $parameter4");}
if ($_GET['db_all_uuid_dialog']) {commandaufruf("db_all_uuid_dialog $parameter2 $parameter3 $parameter4");}
if ($_GET['db_backuptabellen']) {commandaufruf("db_backuptabellen $parameter2 $parameter3 $parameter4");}
if ($_GET['MASTER_HOST']) {commandaufruf("MASTER_HOST $parameter2 $parameter3 $parameter4");}
if ($_GET['MASTER_CONNECT_RETRY']) {commandaufruf("MASTER_CONNECT_RETRY $parameter2 $parameter3 $parameter4");}
if ($_GET['MASTER_USE_GTID2']) {commandaufruf("MASTER_USE_GTID2 $parameter2 $parameter3 $parameter4");}
if ($_GET['IGNORE_SERVER_IDS']) {commandaufruf("IGNORE_SERVER_IDS $parameter2 $parameter3 $parameter4");}
if ($_GET['DO_DOMAIN_IDS']) {commandaufruf("DO_DOMAIN_IDS $parameter2 $parameter3 $parameter4");}
if ($_GET['IGNORE_DOMAIN_IDS']) {commandaufruf("IGNORE_DOMAIN_IDS $parameter2 $parameter3 $parameter4");}
if ($_GET['MASTER_DELAY']) {commandaufruf("MASTER_DELAY $parameter2 $parameter3 $parameter4");}
if ($_GET['Replica_Backup2']) {commandaufruf("Replica_Backup2 $parameter2 $parameter3 $parameter4");}
if ($_GET['db_tablextract_regex']) {commandaufruf("db_tablextract_regex $parameter2 $parameter3 $parameter4");}
//4
if ($_GET['oscommand2']) {commandaufruf("oscommand2 $parameter2 $parameter3 $parameter4 $parameter5");}
if ($_GET['create_db_user']) {commandaufruf("create_db_user $parameter2 $parameter3 $parameter4 $parameter5");}
if ($_GET['conf_write']) {commandaufruf("conf_write $parameter2 $parameter3 $parameter4 $parameter5");}
if ($_GET['loadinventar']) {commandaufruf("loadinventar $parameter2 $parameter3 $parameter4 $parameter5");}
if ($_GET['saveinventar']) {commandaufruf("saveinventar $parameter2 $parameter3 $parameter4 $parameter5");}
if ($_GET['db_create_new_dbuser']) {commandaufruf("db_create_new_dbuser $parameter2 $parameter3 $parameter4 $parameter5");}
if ($_GET['db_restorebackuptabellen']) {commandaufruf("db_restorebackuptabellen $parameter2 $parameter3 $parameter4 $parameter5");}
if ($_GET['MASTER_PORT']) {commandaufruf("MASTER_PORT $parameter2 $parameter3 $parameter4 $parameter5");}
if ($_GET['MASTER_LOG_FILE']) {commandaufruf("MASTER_LOG_FILE $parameter2 $parameter3 $parameter4 $parameter5");}
if ($_GET['MASTER_LOG_POS']) {commandaufruf("MASTER_LOG_POS $parameter2 $parameter3 $parameter4 $parameter5");}
if ($_GET['RELAY_LOG_FILE']) {commandaufruf("RELAY_LOG_FILE $parameter2 $parameter3 $parameter4 $parameter5");}
if ($_GET['RELAY_LOG_POS']) {commandaufruf("RELAY_LOG_POS $parameter2 $parameter3 $parameter4 $parameter5");}
if ($_GET['Replica_Backup']) {commandaufruf("Replica_Backup $parameter2 $parameter3 $parameter4 $parameter5");}
//5
if ($_GET['createuser']) {commandaufruf("createuser $parameter2 $parameter3 $parameter4 $parameter5 $parameter6");}
if ($_GET['setpartner']) {commandaufruf("setpartner $parameter2 $parameter3 $parameter4 $parameter5 $parameter6");}
if ($_GET['db_user_data']) {commandaufruf("db_user_data $parameter2 $parameter3 $parameter4 $parameter5 $parameter6");}
if ($_GET['db_user_infos']) {commandaufruf("db_user_infos $parameter2 $parameter3 $parameter4 $parameter5 $parameter6");}
if ($_GET['db_user_uuid']) {commandaufruf("db_user_uuid $parameter2 $parameter3 $parameter4 $parameter5 $parameter6");}
if ($_GET['db_all_userfailed']) {commandaufruf("db_all_userfailed $parameter2 $parameter3 $parameter4 $parameter5 $parameter6");}
if ($_GET['db_userdate']) {commandaufruf("db_userdate $parameter2 $parameter3 $parameter4 $parameter5 $parameter6");}
if ($_GET['db_setuserofline']) {commandaufruf("db_setuserofline $parameter2 $parameter3 $parameter4 $parameter5 $parameter6");}
if ($_GET['db_setuseronline']) {commandaufruf("db_setuseronline $parameter2 $parameter3 $parameter4 $parameter5 $parameter6");}
//6
if ($_GET['db_foldertyp_user']) {commandaufruf("db_foldertyp_user $parameter2 $parameter3 $parameter4 $parameter5 $parameter6 $parameter7");}
if ($_GET['set_empty_user']) {commandaufruf("set_empty_user $parameter2 $parameter3 $parameter4 $parameter5 $parameter6 $parameter7");}
//7
if ($_GET['ReplikatKoordinaten']) {commandaufruf("ReplikatKoordinaten $parameter2 $parameter3 $parameter4 $parameter5 $parameter6 $parameter7 $parameter8");}
?>


<div class="w3-container">
<!-- 0 -->
<p><a href="?start=true" class="w3-button w3-blue w3-hover-green">Grid Start</a> Startet das gesamte Grid.</p>
<p><a href="?stop=true" class="w3-button w3-blue w3-hover-green">Grid Stop</a> Stoppt das gesamte Grid.</p>
<p><a href="?restart=true" class="w3-button w3-blue w3-hover-green">Grid Restart</a> Das gesamte Grid neu starten.</p>

<p><a href="?meineregionen=true" class="w3-button w3-blue w3-hover-green">meineregionen</a> meineregionen.</p> 
<p><a href="?autologdel=true" class="w3-button w3-blue w3-hover-green">autologdel</a> autologdel.</p> 
<p><a href="?automapdel=true" class="w3-button w3-blue w3-hover-green">automapdel</a> automapdel.</p> 
<p><a href="?rostart=true" class="w3-button w3-blue w3-hover-green">rostart</a> rostart.</p> 
<p><a href="?rostop=true" class="w3-button w3-blue w3-hover-green">rostop</a> rostop.</p> 
<p><a href="?mostart=true" class="w3-button w3-blue w3-hover-green">mostart</a> mostart.</p> 
<p><a href="?mostop=true" class="w3-button w3-blue w3-hover-green">mostop</a> mostop.</p> 
<p><a href="?autosimstart=true" class="w3-button w3-blue w3-hover-green">autosimstart</a> autosimstart.</p> 
<p><a href="?autosimstop=true" class="w3-button w3-blue w3-hover-green">autosimstop</a> autosimstop.</p> 
<p><a href="?autoscreenstop=true" class="w3-button w3-blue w3-hover-green">autoscreenstop</a> autoscreenstop.</p> 
<p><a href="?settings=true" class="w3-button w3-blue w3-hover-green">settings</a> settings.</p> 
<p><a href="?osupgrade=true" class="w3-button w3-blue w3-hover-green">osupgrade</a> osupgrade.</p> 
<p><a href="?autoregionbackup=true" class="w3-button w3-blue w3-hover-green">autoregionbackup</a> autoregionbackup.</p> 
<p><a href="?compilieren=true" class="w3-button w3-blue w3-hover-green">compilieren</a> compilieren.</p> 
<p><a href="?oscompi=true" class="w3-button w3-blue w3-hover-green">oscompi</a> oscompi.</p> 
<p><a href="?scriptcopy=true" class="w3-button w3-blue w3-hover-green">scriptcopy</a> scriptcopy.</p> 
<p><a href="?moneycopy=true" class="w3-button w3-blue w3-hover-green">moneycopy</a> moneycopy.</p> 
<p><a href="?osdelete=true" class="w3-button w3-blue w3-hover-green">osdelete</a> osdelete.</p> 
<p><a href="?autoregionsiniteilen=true" class="w3-button w3-blue w3-hover-green">autoregionsiniteilen</a> autoregionsiniteilen.</p> 
<p><a href="?RegionListe=true" class="w3-button w3-blue w3-hover-green">RegionListe</a> RegionListe.</p> 
<p><a href="?osgitholen=true" class="w3-button w3-blue w3-hover-green">osgitholen</a> osgitholen.</p> 
<p><a href="?terminator=true" class="w3-button w3-blue w3-hover-green">terminator</a> terminator.</p> 
<p><a href="?osgridcopy=true" class="w3-button w3-blue w3-hover-green">osgridcopy</a> osgridcopy.</p> 
<p><a href="?makeaot=true" class="w3-button w3-blue w3-hover-green">makeaot</a> makeaot.</p> 
<p><a href="?cleanaot=true" class="w3-button w3-blue w3-hover-green">cleanaot</a> cleanaot.</p> 
<p><a href="?monoinstall=true" class="w3-button w3-blue w3-hover-green">monoinstall</a> monoinstall.</p> 
<p><a href="?installationen=true" class="w3-button w3-blue w3-hover-green">installationen</a> installationen.</p> 
<p><a href="?serverinstall=true" class="w3-button w3-blue w3-hover-green">serverinstall</a> serverinstall.</p> 
<p><a href="?mysql_neustart=true" class="w3-button w3-blue w3-hover-green">mysql_neustart</a> mysql_neustart.</p> 
<p><a href="?opensimholen=true" class="w3-button w3-blue w3-hover-green">opensimholen</a> opensimholen.</p> 
<p><a href="?mysqleinstellen=true" class="w3-button w3-blue w3-hover-green">mysqleinstellen</a> mysqleinstellen.</p> 
<p><a href="?unlockexample=true" class="w3-button w3-blue w3-hover-green">unlockexample</a> unlockexample.</p> 
<p><a href="?makeverzeichnisliste=true" class="w3-button w3-blue w3-hover-green">makeverzeichnisliste</a> makeverzeichnisliste.</p> 
<p><a href="?makeregionsliste=true" class="w3-button w3-blue w3-hover-green">makeregionsliste</a> makeregionsliste.</p> 
<p><a href="?schreibeinfo=true" class="w3-button w3-blue w3-hover-green">schreibeinfo</a> schreibeinfo.</p> 
<p><a href="?screenlist=true" class="w3-button w3-blue w3-hover-green">screenlist</a> screenlist.</p> 
<p><a href="?hilfe=true" class="w3-button w3-blue w3-hover-green">hilfe</a> hilfe.</p> 
<p><a href="?oscopyrobust=true" class="w3-button w3-blue w3-hover-green">oscopyrobust</a> oscopyrobust.</p> 
<p><a href="?oscopysim=true" class="w3-button w3-blue w3-hover-green">oscopysim</a> oscopysim.</p> 
<p><a href="?moneydelete=true" class="w3-button w3-blue w3-hover-green">moneydelete</a> moneydelete.</p> 
<p><a href="?regionsinisuchen=true" class="w3-button w3-blue w3-hover-green">regionsinisuchen</a> regionsinisuchen.</p> 
<p><a href="?chrisoscopy=true" class="w3-button w3-blue w3-hover-green">chrisoscopy</a> chrisoscopy.</p> 
<p><a href="?cleaninstall=true" class="w3-button w3-blue w3-hover-green">cleaninstall</a> cleaninstall.</p> 
<p><a href="?autoallclean=true" class="w3-button w3-blue w3-hover-green">autoallclean</a> autoallclean.</p> 
<p><a href="?pythoncopy=true" class="w3-button w3-blue w3-hover-green">pythoncopy</a> pythoncopy.</p> 
<p><a href="?get_value_from_Region_key=true" class="w3-button w3-blue w3-hover-green">get_value_from_Region_key</a> get_value_from_Region_key.</p> 
<p><a href="?autorobustmapdel=true" class="w3-button w3-blue w3-hover-green">autorobustmapdel</a> autorobustmapdel.</p> 
<p><a href="?info=true" class="w3-button w3-blue w3-hover-green">info</a> info.</p> 
<p><a href="?mutelistcopy=true" class="w3-button w3-blue w3-hover-green">mutelistcopy</a> mutelistcopy.</p> 
<p><a href="?searchcopy=true" class="w3-button w3-blue w3-hover-green">searchcopy</a> searchcopy.</p> 
<p><a href="?konsolenhilfe=true" class="w3-button w3-blue w3-hover-green">konsolenhilfe</a> konsolenhilfe.</p> 
<p><a href="?makewebmaps=true" class="w3-button w3-blue w3-hover-green">makewebmaps</a> makewebmaps.</p> 
<p><a href="?ipsetzen=true" class="w3-button w3-blue w3-hover-green">ipsetzen</a> ipsetzen.</p> 
<p><a href="?neuegridconfig=true" class="w3-button w3-blue w3-hover-green">neuegridconfig</a> neuegridconfig.</p> 
<p><a href="?ramspeicher=true" class="w3-button w3-blue w3-hover-green">ramspeicher</a> ramspeicher.</p> 
<p><a href="?commandhelp=true" class="w3-button w3-blue w3-hover-green">commandhelp</a> commandhelp.</p> 
<p><a href="?gridcommonini=true" class="w3-button w3-blue w3-hover-green">gridcommonini</a> gridcommonini.</p> 
<p><a href="?robustini=true" class="w3-button w3-blue w3-hover-green">robustini</a> robustini.</p> 
<p><a href="?opensimini=true" class="w3-button w3-blue w3-hover-green">opensimini</a> opensimini.</p> 
<p><a href="?moneyserverini=true" class="w3-button w3-blue w3-hover-green">moneyserverini</a> moneyserverini.</p> 
<p><a href="?regionini=true" class="w3-button w3-blue w3-hover-green">regionini</a> regionini.</p> 
<p><a href="?osslenableini=true" class="w3-button w3-blue w3-hover-green">osslenableini</a> osslenableini.</p> 
<p><a href="?moneygitcopy=true" class="w3-button w3-blue w3-hover-green">moneygitcopy</a> moneygitcopy.</p> 
<p><a href="?scriptgitcopy=true" class="w3-button w3-blue w3-hover-green">scriptgitcopy</a> scriptgitcopy.</p> 
<p><a href="?configurecopy=true" class="w3-button w3-blue w3-hover-green">configurecopy</a> configurecopy.</p> 
<p><a href="?waslauft=true" class="w3-button w3-blue w3-hover-green">waslauft</a> waslauft.</p> 
<p><a href="?rebootdatum=true" class="w3-button w3-blue w3-hover-green">rebootdatum</a> rebootdatum.</p> 
<p><a href="?downloados=true" class="w3-button w3-blue w3-hover-green">downloados</a> downloados.</p> 
<p><a href="?rologdel=true" class="w3-button w3-blue w3-hover-green">rologdel</a> rologdel.</p> 
<p><a href="?screenlistrestart=true" class="w3-button w3-blue w3-hover-green">screenlistrestart</a> screenlistrestart.</p> 
<p><a href="?installmariadb18=true" class="w3-button w3-blue w3-hover-green">installmariadb18</a> installmariadb18.</p> 
<p><a href="?installmariadb22=true" class="w3-button w3-blue w3-hover-green">installmariadb22</a> installmariadb22.</p> 
<p><a href="?serverinstall22=true" class="w3-button w3-blue w3-hover-green">serverinstall22</a> serverinstall22.</p> 
<p><a href="?installbegin=true" class="w3-button w3-blue w3-hover-green">installbegin</a> installbegin.</p> 
<p><a href="?linuxupgrade=true" class="w3-button w3-blue w3-hover-green">linuxupgrade</a> linuxupgrade.</p> 
<p><a href="?installubuntu22=true" class="w3-button w3-blue w3-hover-green">installubuntu22</a> installubuntu22.</p> 
<p><a href="?installmono22=true" class="w3-button w3-blue w3-hover-green">installmono22</a> installmono22.</p> 
<p><a href="?installphpmyadmin=true" class="w3-button w3-blue w3-hover-green">installphpmyadmin</a> installphpmyadmin.</p> 
<p><a href="?ufwset=true" class="w3-button w3-blue w3-hover-green">ufwset</a> ufwset.</p> 
<p><a href="?installfinish=true" class="w3-button w3-blue w3-hover-green">installfinish</a> installfinish.</p> 
<p><a href="?functionslist=true" class="w3-button w3-blue w3-hover-green">functionslist</a> functionslist.</p> 
<p><a href="?robustbackup=true" class="w3-button w3-blue w3-hover-green">robustbackup</a> robustbackup.</p> 
<p><a href="?backupdatum=true" class="w3-button w3-blue w3-hover-green">backupdatum</a> backupdatum.</p> 
<p><a href="?apacheerror=true" class="w3-button w3-blue w3-hover-green">apacheerror</a> apacheerror.</p> 
<p><a href="?mysqldberror=true" class="w3-button w3-blue w3-hover-green">mysqldberror</a> mysqldberror.</p> 
<p><a href="?mariadberror=true" class="w3-button w3-blue w3-hover-green">mariadberror</a> mariadberror.</p> 
<p><a href="?ufwlog=true" class="w3-button w3-blue w3-hover-green">ufwlog</a> ufwlog.</p> 
<p><a href="?authlog=true" class="w3-button w3-blue w3-hover-green">authlog</a> authlog.</p> 
<p><a href="?accesslog=true" class="w3-button w3-blue w3-hover-green">accesslog</a> accesslog.</p> 
<p><a href="?fpspeicher=true" class="w3-button w3-blue w3-hover-green">fpspeicher</a> fpspeicher.</p> 
<p><a href="?systeminformation=true" class="w3-button w3-blue w3-hover-green">systeminformation</a> systeminformation.</p> 
<p><a href="?radiolist=true" class="w3-button w3-blue w3-hover-green">radiolist</a> radiolist.</p> 
<p><a href="?newregionini=true" class="w3-button w3-blue w3-hover-green">newregionini</a> newregionini.</p> 
<p><a href="?AutoInstall=true" class="w3-button w3-blue w3-hover-green">AutoInstall</a> AutoInstall.</p> 
<p><a href="?OpenSimConfig=true" class="w3-button w3-blue w3-hover-green">OpenSimConfig</a> OpenSimConfig.</p> 
<p><a href="?GridCommonConfig=true" class="w3-button w3-blue w3-hover-green">GridCommonConfig</a> GridCommonConfig.</p> 
<p><a href="?osslEnableConfig=true" class="w3-button w3-blue w3-hover-green">osslEnableConfig</a> osslEnableConfig.</p> 
<p><a href="?RegionsConfig=true" class="w3-button w3-blue w3-hover-green">RegionsConfig</a> RegionsConfig.</p> 
<p><a href="?RobustConfig=true" class="w3-button w3-blue w3-hover-green">RobustConfig</a> RobustConfig.</p> 
<p><a href="?ScreenLog=true" class="w3-button w3-blue w3-hover-green">ScreenLog</a> ScreenLog.</p> 
<p><a href="?dotnetinfo=true" class="w3-button w3-blue w3-hover-green">dotnetinfo</a> dotnetinfo.</p> 
<!-- 2 -->
<p><a href="?checkfile=true" class="w3-button w3-blue w3-hover-green">checkfile</a>checkfile.</p> 
<p><a href="?osstop=true" class="w3-button w3-blue w3-hover-green">osstop</a>osstop.</p> 
<p><a href="?osstart=true" class="w3-button w3-blue w3-hover-green">osstart</a>osstart.</p> 
<p><a href="?works=true" class="w3-button w3-blue w3-hover-green">works</a>works.</p> 
<p><a href="?mapdel=true" class="w3-button w3-blue w3-hover-green">mapdel</a>mapdel.</p> 
<p><a href="?logdel=true" class="w3-button w3-blue w3-hover-green">logdel</a>logdel.</p> 
<p><a href="?osscreenstop=true" class="w3-button w3-blue w3-hover-green">osscreenstop</a>osscreenstop.</p> 
<p><a href="?configlesen=true" class="w3-button w3-blue w3-hover-green">configlesen</a>configlesen.</p> 
<p><a href="?osprebuild=true" class="w3-button w3-blue w3-hover-green">osprebuild</a>osprebuild.</p> 
<p><a href="?allclean=true" class="w3-button w3-blue w3-hover-green">allclean</a>allclean.</p> 
<p><a href="?simstats=true" class="w3-button w3-blue w3-hover-green">simstats</a>simstats.</p> 
<p><a href="?osbuilding=true" class="w3-button w3-blue w3-hover-green">osbuilding</a>osbuilding.</p> 
<p><a href="?oscopy=true" class="w3-button w3-blue w3-hover-green">oscopy</a>oscopy.</p> 
<p><a href="?passwdgenerator=true" class="w3-button w3-blue w3-hover-green">passwdgenerator</a>passwdgenerator.</p> 
<p><a href="?oswriteconfig=true" class="w3-button w3-blue w3-hover-green">oswriteconfig</a>oswriteconfig.</p> 
<p><a href="?finstall=true" class="w3-button w3-blue w3-hover-green">finstall</a>finstall.</p> 
<p><a href="?db_tablesplitt=true" class="w3-button w3-blue w3-hover-green">db_tablesplitt</a>db_tablesplitt.</p> 
<p><a href="?ConfigSet=true" class="w3-button w3-blue w3-hover-green">ConfigSet</a>ConfigSet.</p> 
<p><a href="?historylogclear=true" class="w3-button w3-blue w3-hover-green">historylogclear</a>historylogclear.</p> 
<p><a href="?osdauerstop=true" class="w3-button w3-blue w3-hover-green">osdauerstop</a>osdauerstop.</p> 
<p><a href="?osstarteintrag=true" class="w3-button w3-blue w3-hover-green">osstarteintrag</a>osstarteintrag.</p>
<p><a href="?osstop=true" class="w3-button w3-blue w3-hover-green">osstop</a>osstop.</p> 
<p><a href="?osstart=true" class="w3-button w3-blue w3-hover-green">osstart</a>osstart.</p>
<p><a href="?osdauerstart=true" class="w3-button w3-blue w3-hover-green">osdauerstart</a>osdauerstart.</p> 
<!-- 3 -->
<p><a href="?regionbackup=true" class="w3-button w3-blue w3-hover-green">regionbackup</a>regionbackup.</p> 
<p><a href="?osstruktur=true" class="w3-button w3-blue w3-hover-green">osstruktur</a>osstruktur.</p> 
<p><a href="?regionsconfigdateiliste=true" class="w3-button w3-blue w3-hover-green">regionsconfigdateiliste</a>regionsconfigdateiliste.</p> 
<p><a href="?regionsiniteilen=true" class="w3-button w3-blue w3-hover-green">regionsiniteilen</a>regionsiniteilen.</p> 
<p><a href="?db_benutzer_anzeigen=true" class="w3-button w3-blue w3-hover-green">db_benutzer_anzeigen</a>db_benutzer_anzeigen.</p> 
<p><a href="?allrepair_db=true" class="w3-button w3-blue w3-hover-green">allrepair_db</a>allrepair_db.</p> 
<p><a href="?landclear=true" class="w3-button w3-blue w3-hover-green">landclear</a>landclear.</p> 
<p><a href="?db_anzeigen_dialog=true" class="w3-button w3-blue w3-hover-green">db_anzeigen_dialog</a>db_anzeigen_dialog.</p> 
<p><a href="?installationhttps22=true" class="w3-button w3-blue w3-hover-green">installationhttps22</a>installationhttps22.</p> 
<p><a href="?default_master_connection=true" class="w3-button w3-blue w3-hover-green">default_master_connection</a>default_master_connection.</p> 
<p><a href="?connection_name=true" class="w3-button w3-blue w3-hover-green">connection_name</a>connection_name.</p> 
<p><a href="?MASTER_USER=true" class="w3-button w3-blue w3-hover-green">MASTER_USER</a>MASTER_USER.</p> 
<p><a href="?MASTER_PASSWORD=true" class="w3-button w3-blue w3-hover-green">MASTER_PASSWORD</a>MASTER_PASSWORD.</p> 
<p><a href="?MASTER_SSL=true" class="w3-button w3-blue w3-hover-green">MASTER_SSL</a>MASTER_SSL.</p> 
<p><a href="?MASTER_SSL_CA=true" class="w3-button w3-blue w3-hover-green">MASTER_SSL_CA</a>MASTER_SSL_CA.</p> 
<p><a href="?MASTER_SSL_CAPATH=true" class="w3-button w3-blue w3-hover-green">MASTER_SSL_CAPATH</a>MASTER_SSL_CAPATH.</p> 
<p><a href="?MASTER_SSL_CERT=true" class="w3-button w3-blue w3-hover-green">MASTER_SSL_CERT</a>MASTER_SSL_CERT.</p> 
<p><a href="?MASTER_SSL_CRL=true" class="w3-button w3-blue w3-hover-green">MASTER_SSL_CRL</a>MASTER_SSL_CRL.</p> 
<p><a href="?MASTER_SSL_CRLPATH=true" class="w3-button w3-blue w3-hover-green">MASTER_SSL_CRLPATH</a>MASTER_SSL_CRLPATH.</p> 
<p><a href="?MASTER_SSL_KEY=true" class="w3-button w3-blue w3-hover-green">MASTER_SSL_KEY</a>MASTER_SSL_KEY.</p> 
<p><a href="?MASTER_SSL_CIPHER=true" class="w3-button w3-blue w3-hover-green">MASTER_SSL_CIPHER</a>MASTER_SSL_CIPHER.</p> 
<p><a href="?MASTER_SSL_VERIFY_SERVER_CERT=true" class="w3-button w3-blue w3-hover-green">MASTER_SSL_VERIFY_SERVER_CERT</a>MASTER_SSL_VERIFY_SERVER_CERT.</p> 
<p><a href="?MASTER_USE_GTID=true" class="w3-button w3-blue w3-hover-green">MASTER_USE_GTID</a>MASTER_USE_GTID.</p> 
<p><a href="?DO_DOMAIN_IDS2=true" class="w3-button w3-blue w3-hover-green">DO_DOMAIN_IDS2</a>DO_DOMAIN_IDS2.</p> 
<p><a href="?db_tablextract=true" class="w3-button w3-blue w3-hover-green">db_tablextract</a>db_tablextract.</p> 
<p><a href="?db_dbuser=true" class="w3-button w3-blue w3-hover-green">db_dbuser</a>db_dbuser.</p> 
<!-- 4 -->
<p><a href="?assetdel=true" class="w3-button w3-blue w3-hover-green">assetdel</a>assetdel.</p> 
<p><a href="?oscommand=true" class="w3-button w3-blue w3-hover-green">oscommand</a>oscommand.</p> 
<p><a href="?create_db=true" class="w3-button w3-blue w3-hover-green">create_db</a>create_db.</p> 
<p><a href="?delete_db=true" class="w3-button w3-blue w3-hover-green">delete_db</a>delete_db.</p> 
<p><a href="?leere_db=true" class="w3-button w3-blue w3-hover-green">leere_db</a>leere_db.</p> 
<p><a href="?db_sichern=true" class="w3-button w3-blue w3-hover-green">db_sichern</a>db_sichern.</p> 
<p><a href="?tabellenabfrage=true" class="w3-button w3-blue w3-hover-green">tabellenabfrage</a>tabellenabfrage.</p> 
<p><a href="?regionsabfrage=true" class="w3-button w3-blue w3-hover-green">regionsabfrage</a>regionsabfrage.</p> 
<p><a href="?regionsuri=true" class="w3-button w3-blue w3-hover-green">regionsuri</a>regionsuri.</p> 
<p><a href="?regionsport=true" class="w3-button w3-blue w3-hover-green">regionsport</a>regionsport.</p> 
<p><a href="?conf_delete=true" class="w3-button w3-blue w3-hover-green">conf_delete</a>conf_delete.</p> 
<p><a href="?conf_read=true" class="w3-button w3-blue w3-hover-green">conf_read</a>conf_read.</p> 
<p><a href="?db_all_user=true" class="w3-button w3-blue w3-hover-green">db_all_user</a>db_all_user.</p> 
<p><a href="?db_all_uuid=true" class="w3-button w3-blue w3-hover-green">db_all_uuid</a>db_all_uuid.</p> 
<p><a href="?db_all_name=true" class="w3-button w3-blue w3-hover-green">db_all_name</a>db_all_name.</p> 
<p><a href="?db_false_email=true" class="w3-button w3-blue w3-hover-green">db_false_email</a>db_false_email.</p> 
<p><a href="?db_create=true" class="w3-button w3-blue w3-hover-green">db_create</a>db_create.</p> 
<p><a href="?db_dbuserrechte=true" class="w3-button w3-blue w3-hover-green">db_dbuserrechte</a>db_dbuserrechte.</p> 
<p><a href="?db_deldbuser=true" class="w3-button w3-blue w3-hover-green">db_deldbuser</a>db_deldbuser.</p> 
<p><a href="?db_anzeigen=true" class="w3-button w3-blue w3-hover-green">db_anzeigen</a>db_anzeigen.</p> 
<p><a href="?db_delete=true" class="w3-button w3-blue w3-hover-green">db_delete</a>db_delete.</p> 
<p><a href="?db_empty=true" class="w3-button w3-blue w3-hover-green">db_empty</a>db_empty.</p> 
<p><a href="?db_tables=true" class="w3-button w3-blue w3-hover-green">db_tables</a>db_tables.</p> 
<p><a href="?db_tables_dialog=true" class="w3-button w3-blue w3-hover-green">db_tables_dialog</a>db_tables_dialog.</p> 
<p><a href="?db_regions=true" class="w3-button w3-blue w3-hover-green">db_regions</a>db_regions.</p> 
<p><a href="?db_regionsuri=true" class="w3-button w3-blue w3-hover-green">db_regionsuri</a>db_regionsuri.</p> 
<p><a href="?db_regionsport=true" class="w3-button w3-blue w3-hover-green">db_regionsport</a>db_regionsport.</p> 
<p><a href="?db_email_setincorrectuseroff=true" class="w3-button w3-blue w3-hover-green">db_email_setincorrectuseroff</a>db_email_setincorrectuseroff.</p> 
<p><a href="?db_all_user_dialog=true" class="w3-button w3-blue w3-hover-green">db_all_user_dialog</a>db_all_user_dialog.</p> 
<p><a href="?db_all_uuid_dialog=true" class="w3-button w3-blue w3-hover-green">db_all_uuid_dialog</a>db_all_uuid_dialog.</p> 
<p><a href="?db_backuptabellen=true" class="w3-button w3-blue w3-hover-green">db_backuptabellen</a>db_backuptabellen.</p> 
<p><a href="?MASTER_HOST=true" class="w3-button w3-blue w3-hover-green">MASTER_HOST</a>MASTER_HOST.</p> 
<p><a href="?MASTER_CONNECT_RETRY=true" class="w3-button w3-blue w3-hover-green">MASTER_CONNECT_RETRY</a>MASTER_CONNECT_RETRY.</p> 
<p><a href="?MASTER_USE_GTID2=true" class="w3-button w3-blue w3-hover-green">MASTER_USE_GTID2</a>MASTER_USE_GTID2.</p> 
<p><a href="?IGNORE_SERVER_IDS=true" class="w3-button w3-blue w3-hover-green">IGNORE_SERVER_IDS</a>IGNORE_SERVER_IDS.</p> 
<p><a href="?DO_DOMAIN_IDS=true" class="w3-button w3-blue w3-hover-green">DO_DOMAIN_IDS</a>DO_DOMAIN_IDS.</p> 
<p><a href="?IGNORE_DOMAIN_IDS=true" class="w3-button w3-blue w3-hover-green">IGNORE_DOMAIN_IDS</a>IGNORE_DOMAIN_IDS.</p> 
<p><a href="?MASTER_DELAY=true" class="w3-button w3-blue w3-hover-green">MASTER_DELAY</a>MASTER_DELAY.</p> 
<p><a href="?Replica_Backup2=true" class="w3-button w3-blue w3-hover-green">Replica_Backup2</a>Replica_Backup2.</p> 
<p><a href="?db_tablextract_regex=true" class="w3-button w3-blue w3-hover-green">db_tablextract_regex</a>db_tablextract_regex.</p> 
<!-- 5 -->
<p><a href="?oscommand2=true" class="w3-button w3-blue w3-hover-green">oscommand2</a>oscommand2.</p> 
<p><a href="?create_db_user=true" class="w3-button w3-blue w3-hover-green">create_db_user</a>create_db_user.</p> 
<p><a href="?conf_write=true" class="w3-button w3-blue w3-hover-green">conf_write</a>conf_write.</p> 
<p><a href="?loadinventar=true" class="w3-button w3-blue w3-hover-green">loadinventar</a>loadinventar.</p> 
<p><a href="?saveinventar=true" class="w3-button w3-blue w3-hover-green">saveinventar</a>saveinventar.</p> 
<p><a href="?db_create_new_dbuser=true" class="w3-button w3-blue w3-hover-green">db_create_new_dbuser</a>db_create_new_dbuser.</p> 
<p><a href="?db_restorebackuptabellen=true" class="w3-button w3-blue w3-hover-green">db_restorebackuptabellen</a>db_restorebackuptabellen.</p> 
<p><a href="?MASTER_PORT=true" class="w3-button w3-blue w3-hover-green">MASTER_PORT</a>MASTER_PORT.</p> 
<p><a href="?MASTER_LOG_FILE=true" class="w3-button w3-blue w3-hover-green">MASTER_LOG_FILE</a>MASTER_LOG_FILE.</p> 
<p><a href="?MASTER_LOG_POS=true" class="w3-button w3-blue w3-hover-green">MASTER_LOG_POS</a>MASTER_LOG_POS.</p> 
<p><a href="?RELAY_LOG_FILE=true" class="w3-button w3-blue w3-hover-green">RELAY_LOG_FILE</a>RELAY_LOG_FILE.</p> 
<p><a href="?RELAY_LOG_POS=true" class="w3-button w3-blue w3-hover-green">RELAY_LOG_POS</a>RELAY_LOG_POS.</p> 
<p><a href="?Replica_Backup=true" class="w3-button w3-blue w3-hover-green">Replica_Backup</a>Replica_Backup.</p> 
<!-- 6 -->
<p><a href="?createuser=true" class="w3-button w3-blue w3-hover-green">createuser</a>createuser.</p> 
<p><a href="?setpartner=true" class="w3-button w3-blue w3-hover-green">setpartner</a>setpartner.</p> 
<p><a href="?db_user_data=true" class="w3-button w3-blue w3-hover-green">db_user_data</a>db_user_data.</p> 
<p><a href="?db_user_infos=true" class="w3-button w3-blue w3-hover-green">db_user_infos</a>db_user_infos.</p> 
<p><a href="?db_user_uuid=true" class="w3-button w3-blue w3-hover-green">db_user_uuid</a>db_user_uuid.</p> 
<p><a href="?db_all_userfailed=true" class="w3-button w3-blue w3-hover-green">db_all_userfailed</a>db_all_userfailed.</p> 
<p><a href="?db_userdate=true" class="w3-button w3-blue w3-hover-green">db_userdate</a>db_userdate.</p> 
<p><a href="?db_setuserofline=true" class="w3-button w3-blue w3-hover-green">db_setuserofline</a>db_setuserofline.</p> 
<p><a href="?db_setuseronline=true" class="w3-button w3-blue w3-hover-green">db_setuseronline</a>db_setuseronline.</p> 
<!-- 7 -->
<p><a href="?db_foldertyp_user=true" class="w3-button w3-blue w3-hover-green">db_foldertyp_user</a>db_foldertyp_user.</p> 
<p><a href="?set_empty_user=true" class="w3-button w3-blue w3-hover-green">set_empty_user</a>set_empty_user.</p> 
<!-- 8 -->
<p><a href="?ReplikatKoordinaten=true" class="w3-button w3-blue w3-hover-green">ReplikatKoordinaten</a>ReplikatKoordinaten.</p> 
</div>


<!-- Altes warscheinlich nicht mehr zu gebrauchendes -->
<?php
// Test
if ($_GET['home']) {
	# Dieser Code wird ausgefuehrt, wenn ?home=true gesetzt ist.
	?>
	 	<div class="alert">
		<span class="closebtn" onclick="this.parentElement.style.display='none';">&times;</span> 
		<li>Sie haben home ausgewählt.</li>
		<p>Klick auf das X zum scließen.</p>
		</div> 
	<?php
}
if ($_GET['more']) {
	# Dieser Code wird ausgefuehrt, wenn ?more=true gesetzt ist.
	?>
		<div class="alert">
		<span class="closebtn" onclick="this.parentElement.style.display='none';">&times;</span> 
		<li>Sie haben more ausgewählt.</li>
		<p>Klick auf das X zum scließen.</p>
		</div> 
	<?php
}
if ($_GET['filedownload']) {
	# Dieser Code wird ausgefuehrt, wenn ?filedownload=true gesetzt ist.
	?>
		<div class="alert">
		<span class="closebtn" onclick="this.parentElement.style.display='none';">&times;</span> 
		<li>Sie haben filedownload ausgewählt.</li>
		<p>Klick auf das X zum scließen.</p>
		</div> 
	<?php
}
if ($_GET['fileupload']) {
	# Dieser Code wird ausgefuehrt, wenn ?fileupload=true gesetzt ist.
	?>
		<div class="alert">
		<span class="closebtn" onclick="this.parentElement.style.display='none';">&times;</span> 
		<li>Sie haben fileupload ausgewählt.</li>
		<p>Klick auf das X zum scließen.</p>
		</div> 
	<?php
}
if ($_GET['storage']) {
	# Dieser Code wird ausgefuehrt, wenn ?storage=true gesetzt ist.
	?>
		<div class="alert">
		<span class="closebtn" onclick="this.parentElement.style.display='none';">&times;</span> 
		<li>Sie haben storage ausgewählt.</li>
		<p>Klick auf das X zum scließen.</p>
		</div> 
	<?php
}
if ($_GET['expert']) {
	# Dieser Code wird ausgefuehrt, wenn ?expert=true gesetzt ist.
	?>
		<div class="alert">
		<span class="closebtn" onclick="this.parentElement.style.display='none';">&times;</span> 
		<li>Sie haben expert ausgewählt.</li>
		<p>Klick auf das X zum scließen.</p>
		</div> 
	<?php
}