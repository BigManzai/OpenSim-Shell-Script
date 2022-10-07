<!DOCTYPE html>
<html>
<title>opensimMultitool</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
<link href="https://www.w3schools.com/icons/google_icons_intro.asp">
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
	header('Location: expertenmenu.php'); // Zurueck zum Login.
	//exit ();
}
?>

<div class="w3-container w3-blue">
  <h1>opensimMultitool Experten</h1>
</div>

<?php include "./header.php" ?>

<?php include("osmt2.class.php"); ?>

<?php
// Get abfrage

$unlockexampleparameter = array( "unlockexample" );
if ($_GET["unlockexample"]) {call_user_func_array("abfrage", array($unlockexampleparameter));}


$ossettingsparameter = array( "ossettings" );
if ($_GET["ossettings"]) {call_user_func_array("abfrage", array($ossettingsparameter));}


$osupgradeparameter = array( "osupgrade" );
if ($_GET["osupgrade"]) {call_user_func_array("abfrage", array($osupgradeparameter));}

// if ($_GET['oszipupgrade']) {abfrage1("oszipupgrade", "Opensimulator aus zip upgraden", "Opensimulator aus zip upgraden");}
// if ($_GET['osbuilding']) {abfrage1("osbuilding", "Opensimulator bauen und upgraden", "Opensimulator bauen und upgraden");}
// if ($_GET['compilieren']) {abfrage1("compilieren", "compilieren", "compilieren");}
// if ($_GET['oscompi']) {abfrage1("oscompi", "oscompi", "oscompi");}

$autoregionbackupparameter = array( "autoregionbackup" );
if ($_GET["autoregionbackup"]) {call_user_func_array("abfrage", array($autoregionbackupparameter));}

// if ($_GET['autoregionsiniteilen']) {abfrage1("autoregionsiniteilen", "autoregionsiniteilen", "autoregionsiniteilen");}


$RegionListeparameter = array( "RegionListe" );
if ($_GET["RegionListe"]) {call_user_func_array("abfrage", array($RegionListeparameter));}

// if ($_GET['serverinstall']) {abfrage1("serverinstall", "Server Installation", "Server Installation");}
// if ($_GET['installwordpress']) {abfrage1("installwordpress", "Server Installation fuer WordPress", "Server Installation fuer WordPress");}
// if ($_GET['installobensimulator']) {abfrage1("installobensimulator", "Server Installation ohne mono", "Server Installation ohne mono");}
// if ($_GET['monoinstall']) {abfrage1("monoinstall", "Mono Installation", "Mono Installation");}


$terminatorparameter = array( "terminator" );
if ($_GET["terminator"]) {call_user_func_array("abfrage", array($terminatorparameter));}

// if ($_GET['makeaot']) {abfrage1("makeaot", "makeaot", "makeaot");}
// if ($_GET['cleanaot']) {abfrage1("cleanaot", "cleanaot", "cleanaot");}


$installationenparameter = array( "installationen" );
if ($_GET["installationen"]) {call_user_func_array("abfrage", array($installationenparameter));}

// if ($_GET['oscommand']) {abfrage1("oscommand", "Kommando an OpenSim senden", "Kommando an OpenSim senden");}
?>

<!-- href im container -->
<div class="w3-container">
<!-- Hauptmenu -->
<p><a href="?unlockexample=true" class="w3-button w3-blue w3-hover-green">Example Dateien umbenennen</a> Example Dateien umbenennen.</p>
<p><a href="?ossettings=true" class="w3-button w3-blue w3-hover-green">Voreinstellungen setzen</a> Voreinstellungen setzen.</p>
<p><a href="?osupgrade=true" class="w3-button w3-blue w3-hover-green">Opensimulator upgraden</a> Opensimulator upgraden.</p>
<p><a href="?oszipupgrade=true" class="w3-button w3-blue w3-hover-green">Opensimulator aus zip upgraden</a> Opensimulator aus zip upgraden.</p>
<p><a href="?osbuilding=true" class="w3-button w3-blue w3-hover-green">Opensimulator bauen und upgraden</a> Opensimulator bauen und upgraden.</p>
<p><a href="?compilieren=true" class="w3-button w3-blue w3-hover-green">compilieren</a> compilieren.</p>
<p><a href="?oscompi=true" class="w3-button w3-blue w3-hover-green">oscompi</a> oscompi.</p>
<p><a href="?autoregionbackup=true" class="w3-button w3-blue w3-hover-green">Automatischer Regionsbackup</a> Automatischer Regionsbackup.</p>
<p><a href="?autoregionsiniteilen=true" class="w3-button w3-blue w3-hover-green">autoregionsiniteilen</a> autoregionsiniteilen.</p>
<p><a href="?RegionListe=true" class="w3-button w3-blue w3-hover-green">RegionListe</a> RegionListe.</p>
<p><a href="?serverinstall=true" class="w3-button w3-blue w3-hover-green">Server Installation</a> Server Installation.</p>
<p><a href="?installwordpress=true" class="w3-button w3-blue w3-hover-green">Server Installation fuer WordPress</a> Server Installation fuer WordPress.</p>
<p><a href="?installobensimulator=true" class="w3-button w3-blue w3-hover-green">Server Installation ohne mono</a> Server Installation ohne mono.</p>
<p><a href="?monoinstall=true" class="w3-button w3-blue w3-hover-green">Mono Installation</a> Mono Installation.</p>
<p><a href="?terminator=true" class="w3-button w3-blue w3-hover-green">terminator</a> Alle Screens Beeinden Killen!.</p>
<p><a href="?makeaot=true" class="w3-button w3-blue w3-hover-green">makeaot</a> makeaot.</p>
<p><a href="?cleanaot=true" class="w3-button w3-blue w3-hover-green">cleanaot</a> cleanaot.</p>
<p><a href="?installationen=true" class="w3-button w3-blue w3-hover-green">Installationen anzeigen</a> Installationen anzeigen.</p>
<p><a href="?oscommand=true" class="w3-button w3-blue w3-hover-green">Kommando an OpenSim senden</a> Kommando an OpenSim senden.</p>

</div>

<?php include "./footer.php" ?>
