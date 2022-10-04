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
	header('Location: funktionenmenu.php'); // Zurueck zum Login.
	//exit ();
}
?>

<div class="w3-container w3-blue">
  <h1>opensimMultitool Funktionen</h1>
</div>

<?php include "./header.php" ?>

<?php include("osmtclass.php"); ?>

<?php
// Get abfrage
if ($_GET['gridstart']) {abfrage("gridstart", "Grid starten");}
if ($_GET['gridstop']) {abfrage("gridstop", "Grid stoppen");}

if ($_GET['rostart']) {abfrage("rostart", "Robust starten");}
if ($_GET['rostop']) {abfrage("rostop", "Grid stoppen");}
if ($_GET['mostart']) {abfrage("mostart", "Money starten");}
if ($_GET['mostop']) {abfrage("mostop", "Money stoppen");}

if ($_GET['autosimstart']) {abfrage("autosimstart", "Automatischer Sim start");}
if ($_GET['autosimstop']) {abfrage("autosimstop", "Automatischer Sim stop");}

if ($_GET['autoscreenstop']) {abfrage("autoscreenstop", "Automatischer Screen stop");}
if ($_GET['meineregionen']) {abfrage("meineregionen", "Regionen anzeigen");}
?>


<!-- href im container -->
<div class="w3-container">
<!-- Hauptmenu -->
<p><a href="?gridstart=true" class="w3-button w3-blue w3-hover-green">Grid starten</a> Grid starten.</p>
<p><a href="?gridstop=true" class="w3-button w3-blue w3-hover-green">Grid stoppen</a> Grid stoppen.</p>

<p><a href="?rostart=true" class="w3-button w3-blue w3-hover-green">Robust starten</a> Robust starten.</p>
<p><a href="?rostop=true" class="w3-button w3-blue w3-hover-green">Robust stoppen</a> Robust stoppen.</p>
<p><a href="?mostart=true" class="w3-button w3-blue w3-hover-green">Money starten</a> Money starten.</p>
<p><a href="?mostop=true" class="w3-button w3-blue w3-hover-green">Money stoppen</a> Money stoppen.</p>

<p><a href="?autosimstart=true" class="w3-button w3-blue w3-hover-green">Automatischer Sim start</a> Automatischer Sim start.</p>
<p><a href="?autosimstop=true" class="w3-button w3-blue w3-hover-green">Automatischer Sim stop</a> Automatischer Sim stop.</p>

<p><a href="?autoscreenstop=true" class="w3-button w3-blue w3-hover-green">Automatischer Screen stop</a> Automatischer Screen stop.</p>
<p><a href="?meineregionen=true" class="w3-button w3-blue w3-hover-green">Regionen anzeigen</a> Regionen anzeigen.</p>

</div>

<?php include "./footer.php" ?>