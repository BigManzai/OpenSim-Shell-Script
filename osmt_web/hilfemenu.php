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
	header('Location: hilfemenu.php'); // Zurueck zum Login.
	//exit ();
}
?>

<div class="w3-container w3-blue">
  <h1>opensimMultitool Hilfe</h1>
</div>

<?php include "./header.php" ?>

<?php include("osmtclass.php"); ?>
<?php

// Get abfrage
if ($_GET['hilfe']) {abfrage("hilfe");}

if ($_GET['konsolenhilfe']) {abfrage("konsolenhilfe");}
if ($_GET['commandhelp']) {abfrage("commandhelp");}
if ($_GET['oswriteconfig']) {abfrage("oswriteconfig");}
?>


<!-- href im container -->
<div class="w3-container">
<!-- Hauptmenu -->
<p><a href="?hilfe=true" class="w3-button w3-blue w3-hover-green">Hilfe</a> Zeigt eine Hilfe an.</p>

<p><a href="?konsolenhilfe=true" class="w3-button w3-blue w3-hover-green">Konsolenhilfe</a> Zeigt eine Konsolenhilfe an.</p>
<p><a href="?commandhelp=true" class="w3-button w3-blue w3-hover-green">Kommandohilfe</a> Zeigt eine Kommandohilfe an.</p>
<p><a href="?oswriteconfig=true" class="w3-button w3-blue w3-hover-green">Konfiguration lesen</a> Konfiguration lesen.</p>

</div>

<?php include "./footer.php" ?>