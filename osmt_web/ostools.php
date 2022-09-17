<!DOCTYPE html>
<html>
<title>opensimMultitool</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
<body>

<?php
// Login
session_start();
if($_SESSION['userid'] === 1)
{
 // geschützer bereich
 echo " ";
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

<!-- Diese Links fuegen eine Navigation mit Google icons hinzu https://www.w3schools.com/icons/google_icons_intro.asp -->
<div class="w3-bar w3-green">
  <a href="?home=true" class="w3-bar-item w3-button"><i class="material-icons">home</i></a>
  <a href="?cloud=true" class="w3-bar-item w3-button"><i class="material-icons">cloud_queue</i></a>
  <a href="?filedownload=true" class="w3-bar-item w3-button"><i class="material-icons">file_download</i></a>
  <a href="?fileupload=true" class="w3-bar-item w3-button"><i class="material-icons">file_upload</i></a>
  <a href="?storage=true" class="w3-bar-item w3-button"><i class="material-icons">storage</i></a>
  <a href="?devicesother=true" class="w3-bar-item w3-button"><i class="material-icons">devices_other</i></a>
</div>

<img src="opensimMultitool.jpg" alt="opensimMultitool" style="width:60%">

<style>
.w3-button {width:250px;}
.alert {
  padding: 20px;
  background-color: #0F3C4E;
  color: white;}
.closebtn {
  margin-left: 15px;
  color: white;
  font-weight: bold;
  float: right;
  font-size: 22px;
  line-height: 20px;
  cursor: pointer;
  transition: 0.3s;}
.closebtn:hover {color: black;}
</style>

<div class="w3-container">
  <p>opensimMultitool ist eine Sammlung von automatisierter aufgaben für den OpenSimulator.</p>
</div>

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
?>

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
if ($_GET['cloud']) {
	# Dieser Code wird ausgefuehrt, wenn ?cloud=true gesetzt ist.
	?>
		<div class="alert">
		<span class="closebtn" onclick="this.parentElement.style.display='none';">&times;</span> 
		<li>Sie haben cloud ausgewählt.</li>
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
if ($_GET['devicesother']) {
	# Dieser Code wird ausgefuehrt, wenn ?devicesother=true gesetzt ist.
	?>
		<div class="alert">
		<span class="closebtn" onclick="this.parentElement.style.display='none';">&times;</span> 
		<li>Sie haben devicesother ausgewählt.</li>
		<p>Klick auf das X zum scließen.</p>
		</div> 
	<?php
}

// ####################################################################################################

if ($_GET['start']) {commandaufruf("autostart");}
if ($_GET['stop']) {commandaufruf("autostop");}
if ($_GET['restart']) {commandaufruf("restart");}

// NEU ################################################################

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

?>

<div class="w3-container">
  <!-- Dieser Link fuegt Ihrer URL ostools.php?start=true ?start=true hinzu -->
  <p><a href="?start=true" class="w3-button w3-blue w3-hover-green">Grid Start</a> Startet das gesamte Grid.</p>
  <!-- Dieser Link fuegt Ihrer URL ostools.php?stop=true ?stop=true hinzu -->
  <p><a href="?stop=true" class="w3-button w3-blue w3-hover-green">Grid Stop</a> Stoppt das gesamte Grid.</p>
  <!-- Dieser Link fuegt Ihrer URL ostools.php?restart=true ?restart=true hinzu -->
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

</div>

</body>
<div class="w3-container w3-green">
  <h5>opensimMultitool</h5>
</div>
</html>

<?php
// ##### Weitere moeglichkeiten aus der Hilfe: #####

	//"works 			- Verzeichnisname	- Einzelne screens auf Existenz pruefen."
	//"osstart 		    - Verzeichnisname	- Startet einen einzelnen Simulator."
	//"osstop 			- Verzeichnisname	- Stoppt einen einzelnen Simulator."

	//"newregionini		- $(tput setaf 4)hat Abfragen-Erstellt eine neue Regions.ini in ein Regions Verzeichnis."

	//"regionbackup 	- Verzeichnisname $(tput setab 4)Regionsname - Backup einer ausgewaehlten Region."
	//"assetdel 		- screen_name $(tput setab 4)Regionsname $(tput setab 2)Objektname - Einzelnes Asset loeschen."
	//"oscommand 		- Verzeichnisname $(tput setab 3)Region $(tput setab 4)Konsolenbefehl Parameter - Konsolenbefehl senden."

	//"logdel 			- Verzeichnisname     - Loescht alle Simulator Log Dateien im Verzeichnis."
	//"mapdel 			- Verzeichnisname     - Loescht alle Simulator Map-Karten im Verzeichnis."

	//"configlesen 		- Verzeichnisname     - Alle Regionskonfigurationen im Verzeichnis anzeigen."


	//"oscopy			- Verzeichnisname     - Kopiert den Simulator."
	//"osstruktur		- ersteSIM $(tput setab 4)letzteSIM  - Legt eine Verzeichnisstruktur an."
	//"osprebuild		- $(tput setab 2)Versionsnummer      - Aendert die Versionseinstellungen 0.9.2.XXXX"

	//"regionsiniteilen 	- Verzeichnisname $(tput setab 3)Region - kopiert aus der Regions.ini eine Region heraus."
	//"autoregionsiniteilen 	- hat keine Parameter - aus allen Regions.ini alle Regionen vereinzeln."

	//"Regionsdateiliste 	- $(tput setab 4)-b Bildschirm oder -d Datei Verzeichnisname - Regionsdateiliste erstellen."

	//"osbuilding		- Versionsnummer - Upgrade des OpenSimulator aus einer Source ZIP Datei."
	//"createuser 		-  Vorname  $(tput setab 4) Nachname  $(tput setab 2) Passwort  $(tput setab 3) E-Mail  - Grid Benutzer anlegen."

	//"db_anzeigen	    -  DBBENUTZER  $(tput setab 4) DBDATENBANKNAME  - Alle Datenbanken anzeigen."
	//"create_db	    -  DBBENUTZER  $(tput setab 4) DBPASSWORT  $(tput setab 2) DATENBANKNAME  - Datenbank anlegen."
	
	//"delete_db	    -  DBBENUTZER  $(tput setab 4) DBPASSWORT  $(tput setab 2) DATENBANKNAME  - Datenbank loeschen."
	//"leere_db	        -  DBBENUTZER  $(tput setab 4) DBPASSWORT  $(tput setab 2) DATENBANKNAME  - Datenbank leeren."
	//"allrepair_db	    -  DBBENUTZER  $(tput setab 4) DBPASSWORT  - Alle Datenbanken Reparieren und Optimieren."
	//"db_sichern	    -  DBBENUTZER  $(tput setab 4) DBPASSWORT  $(tput setab 2) DATENBANKNAME  - Datenbank sichern."

	//"regionsabfrage	-  DBBENUTZER  $(tput setab 4) DBPASSWORT  $(tput setab 2) DATENBANKNAME  - Regionsliste."
	//"regionsuri	    -  DBBENUTZER  $(tput setab 4) DBPASSWORT  $(tput setab 2) DATENBANKNAME  - URI pruefen sortiert nach URI."
	//"regionsport	    -  DBBENUTZER  $(tput setab 4) DBPASSWORT  $(tput setab 2) DATENBANKNAME  - Ports pruefen sortiert nach Ports."

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


	// ##### Alle moeglichkeiten kurz und knapp: #####

	// checkfile) checkfile "$2" ;;
	// osto | osstop) osstop "$2" ;;
	// osta | osstart) osstart "$2" ;;
	// w | works) works "$2" ;;
	// md | mapdel) mapdel "$2" ;;
	// ld | logdel) logdel "$2" ;;
	// ss | osscreenstop) osscreenstop "$2" ;;
	// asdel | assetdel) assetdel "$2" "$3" "$4" ;;
	// oscopy) oscopy "$2" ;;
	// rb | regionbackup) regionbackup "$2" "$3" ;;
	// os | osstruktur) osstruktur "$2" "$3" ;;
	// cl | configlesen) configlesen "$2" ;;
	// osc | com | oscommand) oscommand "$2" "$3" "$4" ;;
	// osc2 | com2 | oscommand2) oscommand2 "$2" "$3" "$4" "$5" ;;
	// rl | Regionsdateiliste | regionsconfigdateiliste) regionsconfigdateiliste "$3" "$2" ;;
	// rit | regionsiniteilen) regionsiniteilen "$2" "$3" ;;
	// osprebuild) osprebuild "$2" ;;
	// allclean) allclean "$2" ;;
	// simstats) simstats "$2" ;;
	// osbuilding) osbuilding "$2" ;;
	// createuser) createuser "$2" "$3" "$4" "$5" "$6" ;;
	// db_benutzer_anzeigen) db_benutzer_anzeigen "$2" "$3" ;;
	// create_db) create_db "$2" "$3" "$4" ;;
	// create_db_user) create_db_user "$2" "$3" "$4" "$5" ;;
	// delete_db) delete_db "$2" "$3" "$4" ;;
	// leere_db) leere_db "$2" "$3" "$4" ;;
	// allrepair_db) allrepair_db "$2" "$3" ;;
	// db_sichern) db_sichern "$2" "$3" "$4" ;;
	// tabellenabfrage) tabellenabfrage "$2" "$3" "$4" ;;
	// regionsabfrage) regionsabfrage "$2" "$3" "$4" ;;
	// regionsuri) regionsuri "$2" "$3" "$4" ;;
	// regionsport) regionsport "$2" "$3" "$4" ;;
	// setpartner) setpartner "$2" "$3" "$4" "$5" "$6" ;;
	// conf_write) conf_write "$2" "$3" "$4" "$5" ;;
	// conf_delete) conf_delete "$2" "$3" "$4" ;;
	// conf_read) conf_read "$2" "$3" "$4" ;;
	// landclear) landclear "$2" "$3" ;;
	// loadinventar) loadinventar "$2" "$3" "$4" "$5" ;;
	// saveinventar) saveinventar "$2" "$3" "$4" "$5" ;;
	// infodialog) infodialog ;;
	// fortschritsanzeige) fortschritsanzeige ;;
	// passwdgenerator) passwdgenerator "$2" ;;
	// oswriteconfig) oswriteconfig "$2" ;;
	// menuoswriteconfig) menuoswriteconfig "$2" ;;
	// finstall) finstall "$2" ;;
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
	// installationhttps22) installationhttps22 "$2" "$3" ;;

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

	// db_tablesplitt) db_tablesplitt "$2" ;;
	// db_tablextract) db_tablextract "$2" "$3" ;;
	// db_tablextract_regex) db_tablextract_regex "$2" "$3" "$4" ;;
	// ConfigSet) ConfigSet "$2" ;;

	// historylogclear) historylogclear "$2" ;;
	// osdauerstop) osdauerstop "$2" ;; # Test
	// osstarteintrag) osstarteintrag "$2" ;; # Test
	// menuosdauerstop) menuosdauerstop "$2" ;; # Test
	// osdauerstart) osdauerstart "$2" ;; # Test
	// menuosdauerstart) menuosdauerstart "$2" ;; # Test
	// osstarteintragdel) osstarteintragdel "$2" ;; # Test
    ?>