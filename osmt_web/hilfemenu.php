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
if($_SESSION["userid"] === 1)
{
 // geschützer bereich
 echo " ";
}
else 
{
	header("Location: hilfemenu.php"); // Zurueck zum Login.
}
?>

<div class="w3-container w3-blue">
  <h1>opensimMultitool Hilfe</h1>
</div>
<?php include "./header.php" ?>

<body>

<?php include("osmt2.class.php"); ?>
<?php

// Get abfrage
if ($_GET["hilfe"]) {abfrage("hilfe", "Überschrift");}
if ($_GET["konsolenhilfe"]) {abfrage("konsolenhilfe", "Überschrift");}
if ($_GET["commandhelp"]) {abfrage("commandhelp");}
if ($_GET["oswriteconfig"]) {abfrage("oswriteconfig");}

if ($_GET["testeingabe"]) {testeingabe();}

// testfunktionsname="wiparameterX";
$uparameter1="Dies-ist-Parameter-1!";
$uparameter2="Dies-ist-Parameter-2!";
$uparameter3="Dies-ist-Parameter-3!";
$uparameter4="Dies-ist-Parameter-4!";
$uparameter5="Dies-ist-Parameter-5!";
$uparameter6="Dies-ist-Parameter-6!";
$uparameter7="Dies-ist-Parameter-7!";
$uparameter8="Dies-ist-Parameter-8!";

$parameter0 = array( "wiparameter0" );
$parameter1 = array( "wiparameter1", $uparameter1);
$parameter2 = array( "wiparameter2", $uparameter1, $uparameter2);
$parameter3 = array( "wiparameter3", $uparameter1, $uparameter2, $uparameter3);
$parameter4 = array( "wiparameter4", $uparameter1, $uparameter2, $uparameter3, $uparameter4);
$parameter5 = array( "wiparameter5", $uparameter1, $uparameter2, $uparameter3, $uparameter4, $uparameter5);
$parameter6 = array( "wiparameter6", $uparameter1, $uparameter2, $uparameter3, $uparameter4, $uparameter5, $uparameter6);
$parameter7 = array( "wiparameter7", $uparameter1, $uparameter2, $uparameter3, $uparameter4, $uparameter5, $uparameter6, $uparameter7);
$parameter8 = array( "wiparameter8", $uparameter1, $uparameter2, $uparameter3, $uparameter4, $uparameter5, $uparameter6, $uparameter7, $uparameter8);

if ($_GET["wiparameter0"]) {call_user_func_array("abfrage", array($parameter0));}
if ($_GET["wiparameter1"]) {call_user_func_array("abfrage", array($parameter1));}
if ($_GET["wiparameter2"]) {call_user_func_array("abfrage", array($parameter2));}
if ($_GET["wiparameter3"]) {call_user_func_array("abfrage", array($parameter3));}
if ($_GET["wiparameter4"]) {call_user_func_array("abfrage", array($parameter4));}
if ($_GET["wiparameter5"]) {call_user_func_array("abfrage", array($parameter5));}
if ($_GET["wiparameter6"]) {call_user_func_array("abfrage", array($parameter6));}
if ($_GET["wiparameter7"]) {call_user_func_array("abfrage", array($parameter7));}
if ($_GET["wiparameter8"]) {call_user_func_array("abfrage", array($parameter8));}

// echo count($parameter8);

?>


<!-- href im container -->
<div class="w3-container">
<!-- Hauptmenu -->

<p><a href="?hilfe=true" class="w3-button w3-blue w3-hover-green">Hilfe</a> Zeigt eine Hilfe an.</p>
<p><a href="?konsolenhilfe=true" class="w3-button w3-blue w3-hover-green">Konsolenhilfe</a> Zeigt eine Konsolenhilfe an.</p>
<p><a href="?commandhelp=true" class="w3-button w3-blue w3-hover-green">Kommandohilfe</a> Zeigt eine Kommandohilfe an.</p>
<p><a href="?oswriteconfig=true" class="w3-button w3-blue w3-hover-green">Konfiguration lesen</a> Konfiguration lesen.</p>

<p><h3>Es folgen tests:</h3></p>

<p><a href="?testeingabe=true" class="w3-button w3-blue w3-hover-green">testeingabe</a> testeingabe.</p>

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
</body>

<?php include "./footer.php" ?>