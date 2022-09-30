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
$uebergabeparameter2 = "";
// abfrage1 geht nicht
function abfrage1()
{
    // Abfrage Card einzelner Parameter.
    ?>
    <div class="w3-card-4">
      <div class="w3-container w3-green">
        <h2>Eingabe erforderlich</h2>
      </div>
      <form class="w3-container" action="hauptmenu.php" method="POST">
        <p>      
        <label class="w3-text-green"><b>Simulator auswählen:</b></label>
        <input class="w3-input w3-border w3-sand" type="text" name="parameter2"></input></p>
    
    
        <p><button class="w3-btn w3-green">Senden</button></p>
      </form>
    </div>
        
    <?php
    $uebergabeparameter2 =  $_POST['parameter2'];
}
?>

<?php
$parameter2 = $_POST['parameter2'];

// Get commandaufruf
if ($_GET['hilfe']) {commandaufruf("hilfe");}
if ($_GET['restart']) {commandaufruf("restart");}
if ($_GET['start']) {commandaufruf("autostart");}
if ($_GET['stop']) {commandaufruf("autostop");}
// parameter2
if ($_GET['osstart']) {abfrage1(); commandaufruf2("osstart " . $parameter2);} //test
if ($_GET['osstop']) {abfrage1(); commandaufruf2("osstop " . $_POST['parameter2']);} //test
//neu

//if ($_GET['createuser']) {commandaufruf("createuser Max Mustermann 123456 email@email.de");} //6
//if ($_GET['landclear']) {commandaufruf("landclear sim3");} //3
//if ($_GET['assetdel']) {commandaufruf("assetdel sim3 Musterhausen stuhl");} //4


if ($_GET['info']) {commandaufruf("info");}
// if ($_GET['rebootdatum']) {commandaufruf("rebootdatum");} // geht nicht da es eine Menuefunktion ist!!!
if ($_GET['screenlist']) {commandaufruf("screenlist");}

//if ($_GET['passgen']) {commandaufruf("passgen 32");}
if ($_GET['passgen']) {abfrage1(); commandaufruf2("passgen " . $uebergabeparameter2);} //test
?>

<!-- href im container -->
<div class="w3-container">
<!-- Hauptmenu -->
<p><a href="?restart=true" class="w3-button w3-blue w3-hover-green">Grid Restart</a> Das gesamte Grid neu starten.</p> <!-- 1 -->
<p><a href="?start=true" class="w3-button w3-blue w3-hover-green">Grid Start</a> Startet das gesamte Grid.</p> <!-- 1 -->
<p><a href="?stop=true" class="w3-button w3-blue w3-hover-green">Grid Stop</a> Stoppt das gesamte Grid.</p> <!-- 1 -->

<p><a href="?osstart=true" class="w3-button w3-blue w3-hover-green">osstart</a> Einzelner Simulator Start.</p> <!-- 2 -->
<p><a href="?osstop=true" class="w3-button w3-blue w3-hover-green">osstop</a> Einzelner Simulator Stop.</p> <!-- 2 -->

<!-- <p><a href="?createuser=true" class="w3-button w3-blue w3-hover-green">createuser</a> Benutzer Account anlegen.</p> <!-- 6 -->
<!-- <p><a href="?landclear=true" class="w3-button w3-blue w3-hover-green">landclear</a> Parzellen von der Region entfernen.</p> <!-- 3 -->
<!-- <p><a href="?assetdel=true" class="w3-button w3-blue w3-hover-green">assetdel</a> Objekt von der Region entfernen.</p> <!-- 4 -->

<p><a href="?info=true" class="w3-button w3-blue w3-hover-green">info</a> Informationen anzeigen.</p> 
<p><a href="?screenlist=true" class="w3-button w3-blue w3-hover-green">screenlist</a> Screen Liste anzeigen.</p> 
<!-- <p><a href="?rebootdatum=true" class="w3-button w3-blue w3-hover-green">rebootdatum</a> Server laufzeit und Neustart.</p>  -->
<p><a href="?passgen=true" class="w3-button w3-blue w3-hover-green">passwdgenerator</a> Passwortgenerator zeigt ein Passwort an.</p>

</div>

<?php include "./footer.php" ?>
