<!DOCTYPE html>
<html>
<title>opensimMultitool</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
<body>

<?php
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
//1
if ($_GET['finstall']) {commandaufruf("finstall $parameter2");}
if ($_GET['db_tablesplitt']) {commandaufruf("db_tablesplitt $parameter2");}
if ($_GET['ConfigSet']) {commandaufruf("ConfigSet $parameter2");}
if ($_GET['historylogclear']) {commandaufruf("historylogclear $parameter2");}
if ($_GET['osdauerstop']) {commandaufruf("osdauerstop $parameter2");}
if ($_GET['osstarteintrag']) {commandaufruf("osstarteintrag $parameter2");}
if ($_GET['osdauerstart']) {commandaufruf("osdauerstart $parameter2");}
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
