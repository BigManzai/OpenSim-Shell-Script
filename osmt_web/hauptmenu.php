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
	header('Location: hauptmenu.php'); // Zurueck zum Login.
	//exit ();
}
?>

<div class="w3-container w3-blue">
  <h1>opensimMultitool Hauptmenü</h1>
</div>

<?php include "./header.php" ?>
<?php include("osmtclass.php"); ?>

<?php
// Get abfrage

if ($_GET['hilfe']) {abfrage("hilfe");}
if ($_GET['restart']) {abfrage("restart");}
if ($_GET['start']) {abfrage("autostart");}
if ($_GET['stop']) {abfrage("autostop");}

if ($_GET['osstart']) {abfrage1("osstart", "Simulator Start", "Verzeichnis oder Screen Name des Simulators");}
if ($_GET['osstop']) {abfrage1("osstop", "Simulator Stoppen", "Verzeichnis oder Screen Name des Simulators");}

if ($_GET['createuser']) {abfrage5("createuser Max Mustermann 123456 email@email.de");}

if ($_GET['landclear']) {abfrage2("landclear", "Loescht alle Parzellen auf dem Land.", "Verzeichnis oder Screen Name:", "Regionsname:");}
if ($_GET['assetdel']) {abfrage3("assetdel", "Loescht ein Asset auf dem Land.", "Verzeichnis oder Screen Name:", "Regionsname:", "Asset Name:");}

if ($_GET['info']) {abfrage("info");}
if ($_GET['lastrebootdatum']) {abfrage("lastrebootdatum");}
if ($_GET['screenlist']) {abfrage("screenlist");}

if ($_GET['passgen']) {abfrage1("passgen", "Passwortgenerator", "Anzahl Zeichen des Passwortes:");}
?>

<!-- href im container -->
<div class="w3-container">
<!-- Hauptmenu -->
<p><a href="?restart=true" class="w3-button w3-blue w3-hover-green">Grid Restart</a> Das gesamte Grid neu starten.</p>
<p><a href="?start=true" class="w3-button w3-blue w3-hover-green">Grid Start</a> Startet das gesamte Grid.</p>
<p><a href="?stop=true" class="w3-button w3-blue w3-hover-green">Grid Stop</a> Stoppt das gesamte Grid.</p>

<p><a href="?osstart=true" class="w3-button w3-blue w3-hover-green">osstart</a> Einzelner Simulator Start.</p>
<p><a href="?osstop=true" class="w3-button w3-blue w3-hover-green">osstop</a> Einzelner Simulator Stop.</p>

<p><a href="?createuser=true" class="w3-button w3-blue w3-hover-green">createuser</a> Benutzer Account anlegen.</p>
<p><a href="?landclear=true" class="w3-button w3-blue w3-hover-green">landclear</a> Parzellen von der Region entfernen.</p>
<p><a href="?assetdel=true" class="w3-button w3-blue w3-hover-green">assetdel</a> Objekt von der Region entfernen.</p>

<p><a href="?info=true" class="w3-button w3-blue w3-hover-green">info</a> Informationen anzeigen.</p> 
<p><a href="?screenlist=true" class="w3-button w3-blue w3-hover-green">screenlist</a> Screen Liste anzeigen.</p> 
<p><a href="?lastrebootdatum=true" class="w3-button w3-blue w3-hover-green">Reboot Datum</a> Server laufzeit und Neustart.</p>
<p><a href="?passgen=true" class="w3-button w3-blue w3-hover-green">passwdgenerator</a> Passwortgenerator zeigt ein Passwort an.</p>

</div>

<?php include "./footer.php" ?>
