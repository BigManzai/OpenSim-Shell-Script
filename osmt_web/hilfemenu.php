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

if ($_GET['wiparameter0']) {abfrage("wiparameter0");}
if ($_GET['wiparameter1']) {abfrage("wiparameter1 test1");} 
if ($_GET['wiparameter2']) {abfrage("wiparameter2 test1 test2");}
if ($_GET['wiparameter3']) {abfrage("wiparameter3 test1 test2 test3");}
if ($_GET['wiparameter4']) {abfrage("wiparameter4 test1 test2 test3 test4");}
if ($_GET['wiparameter5']) {abfrage("wiparameter5 test1 test2 test3 test4 test5");}
if ($_GET['wiparameter6']) {abfrage("wiparameter6 test1 test2 test3 test4 test5 test6");}
if ($_GET['wiparameter7']) {abfrage("wiparameter7 test1 test2 test3 test4 test5 test6 test7");}
if ($_GET['wiparameter8']) {abfrage("wiparameter8 test1 test2 test3 test4 test5 test6 test7 test8");}
?>


<!-- href im container -->
<div class="w3-container">
<!-- Hauptmenu -->
<p><a href="?hilfe=true" class="w3-button w3-blue w3-hover-green">Hilfe</a> Zeigt eine Hilfe an.</p>

<p><a href="?konsolenhilfe=true" class="w3-button w3-blue w3-hover-green">Konsolenhilfe</a> Zeigt eine Konsolenhilfe an.</p>
<p><a href="?commandhelp=true" class="w3-button w3-blue w3-hover-green">Kommandohilfe</a> Zeigt eine Kommandohilfe an.</p>
<p><a href="?oswriteconfig=true" class="w3-button w3-blue w3-hover-green">Konfiguration lesen</a> Konfiguration lesen.</p>

<p><h3>Es folgen tests:</h3></p>

<p><a href="?wiparameter0=true" class="w3-button w3-blue w3-hover-green">wiparameter0</a> wiparameter 0 Test.</p>
<p><a href="?wiparameter1=true" class="w3-button w3-blue w3-hover-green">wiparameter1</a> wiparameter 1 Test.</p>
<p><a href="?wiparameter2=true" class="w3-button w3-blue w3-hover-green">wiparameter2</a> wiparameter 2 Test.</p>
<p><a href="?wiparameter3=true" class="w3-button w3-blue w3-hover-green">wiparameter3</a> wiparameter 3 Test.</p>
<p><a href="?wiparameter4=true" class="w3-button w3-blue w3-hover-green">wiparameter4</a> wiparameter 4 Test.</p>
<p><a href="?wiparameter5=true" class="w3-button w3-blue w3-hover-green">wiparameter5</a> wiparameter 5 Test.</p>
<p><a href="?wiparameter6=true" class="w3-button w3-blue w3-hover-green">wiparameter6</a> wiparameter 6 Test.</p>
<p><a href="?wiparameter7=true" class="w3-button w3-blue w3-hover-green">wiparameter7</a> wiparameter 7 Test.</p>
<p><a href="?wiparameter8=true" class="w3-button w3-blue w3-hover-green">wiparameter8</a> wiparameter 8 Test.</p>

</div>


<?php include "./footer.php" ?>