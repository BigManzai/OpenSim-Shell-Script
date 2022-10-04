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
	header('Location: dateimenu.php'); // Zurueck zum Login.
	//exit ();
}
?>

<div class="w3-container w3-blue">
  <h1>opensimMultitool Datei</h1>
</div>

<?php include "./header.php" ?>

<?php include("osmtclass.php"); ?>

<?php
// Get abfrage
if ($_GET['saveinventar']) {abfrage1("saveinventar", "Inventar speichern", "Inventar speichern");}
if ($_GET['loadinventar']) {abfrage1("loadinventar", "Inventar laden", "Inventar laden");}
if ($_GET['regionbackup']) {abfrage1("regionbackup", "Region OAR sichern", "Region OAR sichern");}
if ($_GET['autologdel']) {abfrage("autologdel");}
if ($_GET['automapdel']) {abfrage("automapdel");}
if ($_GET['autoassetcachedel']) {abfrage("autoassetcachedel");}
if ($_GET['assetdel']) {abfrage3("assetdel", "Simulator:", "Region:", "Asset:");}

if ($_GET['downloados']) {abfrage1("downloados", "OpenSim herunterladen", "OpenSim herunterladen");}
if ($_GET['moneygitcopy']) {abfrage1("moneygitcopy", "MoneyServer vom git kopieren", "MoneyServer vom git kopieren");}
if ($_GET['scriptgitcopy']) {abfrage1("scriptgitcopy", "OSSL Skripte vom git kopieren", "OSSL Skripte vom git kopieren");}
if ($_GET['configuregitcopy']) {abfrage1("configuregitcopy", "Configure vom git kopieren", "Configure vom git kopieren");}
if ($_GET['osgitholen']) {abfrage1("osgitholen", "Opensim vom Github holen", "Opensim vom Github holen");}

if ($_GET['osstruktur']) {abfrage1("osstruktur", "Verzeichnisstrukturen anlegen", "Verzeichnisstrukturen anlegen");}
if ($_GET['osstarteintrag']) {abfrage1("osstarteintrag", "Sim eintragen", "Sim eintragen");}
if ($_GET['osstarteintragdel']) {abfrage1("osstarteintragdel", "Sim austragen", "Sim austragen");}
if ($_GET['osdauerstart']) {abfrage1("osdauerstart", "Sim in Startkonfiguration einfuegen", "Sim Name: ");}
if ($_GET['osdauerstop']) {abfrage1("passgen", "Sim aus Startkonfiguration entfernen", "Sim Name: ");}
?>

<!-- href im container -->
<div class="w3-container">
<!-- Hauptmenu -->
<p><a href="?saveinventar=true" class="w3-button w3-blue w3-hover-green">Inventar speichern</a> Inventar speichern.</p>
<p><a href="?loadinventar=true" class="w3-button w3-blue w3-hover-green">Inventar laden</a> Inventar laden.</p>
<p><a href="?regionbackup=true" class="w3-button w3-blue w3-hover-green">Region OAR sichern</a> Region OAR sichern.</p>
<p><a href="?autologdel=true" class="w3-button w3-blue w3-hover-green">Log Dateien loeschen</a> Log Dateien loeschen.</p>
<p><a href="?automapdel=true" class="w3-button w3-blue w3-hover-green">Map Karten loeschen</a> Map Karten loeschen.</p>
<p><a href="?autoassetcachedel=true" class="w3-button w3-blue w3-hover-green">Asset Cache loeschen</a> Asset Cache loeschen.</p>
<p><a href="?assetdel=true" class="w3-button w3-blue w3-hover-green">Asset loeschen</a> Asset loeschen.</p>
<p><a href="?downloados=true" class="w3-button w3-blue w3-hover-green">OpenSim herunterladen</a> OpenSim herunterladen.</p>
<p><a href="?moneygitcopy=true" class="w3-button w3-blue w3-hover-green">MoneyServer vom git kopieren</a> MoneyServer vom git kopieren.</p>
<p><a href="?scriptgitcopy=true" class="w3-button w3-blue w3-hover-green">OSSL Skripte vom git kopieren</a> OSSL Skripte vom git kopieren.</p>
<p><a href="?configuregitcopy=true" class="w3-button w3-blue w3-hover-green">Configure vom git kopieren</a> Configure vom git kopieren.</p>
<p><a href="?osgitholen=true" class="w3-button w3-blue w3-hover-green">Opensim vom Github holen</a> Opensim vom Github holen.</p>

<p><a href="?osstruktur=true" class="w3-button w3-blue w3-hover-green">Verzeichnisstrukturen anlegen</a> Verzeichnisstrukturen anlegen.</p>
<p><a href="?osstarteintrag=true" class="w3-button w3-blue w3-hover-green">Sim eintragen</a> Sim eintragen.</p>
<p><a href="?osstarteintragdel=true" class="w3-button w3-blue w3-hover-green">Sim austragen</a> Sim austragen.</p>
<p><a href="?osdauerstart=true" class="w3-button w3-blue w3-hover-green">Sim in Startkonfiguration einfuegen</a> Sim in Startkonfiguration einfuegen.</p>
<p><a href="?osdauerstop=true" class="w3-button w3-blue w3-hover-green">Sim aus Startkonfiguration entfernen</a> Sim aus Startkonfiguration entfernen.</p>

</div>

<?php include "./footer.php" ?>