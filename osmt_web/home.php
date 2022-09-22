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
	header('Location: home.php'); // Zurueck zum Login.
	//exit ();
}
?>

<div class="w3-container w3-blue">
  <h1>opensimMultitool HOME</h1>
</div>

<!-- Diese Links fuegen eine Navigation mit Google icons hinzu https://www.w3schools.com/icons/google_icons_intro.asp -->
<div class="w3-bar w3-green">
  <a href="home.php" class="w3-bar-item w3-button"><i class="material-icons">home</i></a>
  <a href="more.php" class="w3-bar-item w3-button"><i class="material-icons">cloud_queue</i></a>
  <a href="file.php" class="w3-bar-item w3-button"><i class="material-icons">file_download</i></a>
  <!--<a href="?fileupload=true" class="w3-bar-item w3-button"><i class="material-icons">file_upload</i></a>-->
  <a href="storage.php" class="w3-bar-item w3-button"><i class="material-icons">storage</i></a>
  <a href="expert.php" class="w3-bar-item w3-button"><i class="material-icons">devices_other</i></a>
</div>

<img src="opensimMultitool.jpg" alt="opensimMultitool" style="width:60%">

<style>
.w3-button {width:250px;}
.w3-input {width:250px;}
.w3-card-4 {width:450px;}
.alert {
    width:900px;
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
// Funktion zum aufruf von opensim.sh Funktionen mit mehreren Parametern.
function commandaufruf2(string $funktionsname, string $parameter2)
{
    $ausgabe=null; $rueckgabewert=null;
	$datei="/opt/opensim.sh";
    $zusammengesetzt="$datei $funktionsname $parameter2";
    echo $datei; echo $funktionsname; echo $parameter2; echo $_POST['parameter2'];
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
function abfrage1()
{
    // Abfrage Card einzelner Parameter.
    ?>
    <div class="w3-card-4">
      <div class="w3-container w3-green">
        <h2>Eingabe erforderlich</h2>
      </div>
      <form class="w3-container" action="home.php" method="POST">
        <p>      
        <label class="w3-text-green"><b>Simulator auswählen:</b></label>
        <input class="w3-input w3-border w3-sand" type="text" name="parameter2"></input></p>
    
    
        <p><button class="w3-btn w3-green">Senden</button></p>
      </form>
    </div>
        
    <?php
    $uebergabeparameter2 =  $_POST['parameter2'];
    echo $uebergabeparameter2;
}
?>

<?php
function testfunktion()
{
// Testfunktionen opensim.sh wiparameter0
// commandaufruf("wiparameter0");
// commandaufruf("wiparameter1 $2");
// commandaufruf("wiparameter2 $2 $3");
// commandaufruf("wiparameter3 $2 $3 $4");
// commandaufruf("wiparameter4 $2 $3 $4 $5");
// commandaufruf("wiparameter5 $2 $3 $4 $5 $6");
// commandaufruf("wiparameter6 $2 $3 $4 $5 $6 $7");
// commandaufruf("wiparameter7 $2 $3 $4 $5 $6 $7 $8");
// commandaufruf("wiparameter8 $2 $3 $4 $5 $6 $7 $8 $9");

  if ($_GET['wiparameter0']) {commandaufruf("wiparameter0");}
  if ($_GET['wiparameter1']) {commandaufruf("wiparameter1 $2");}
  if ($_GET['wiparameter2']) {commandaufruf("wiparameter2 $2 $3");}
  if ($_GET['wiparameter3']) {commandaufruf("wiparameter3 $2 $3 $4");}
  if ($_GET['wiparameter4']) {commandaufruf("wiparameter4 $2 $3 $4 $5");}
  if ($_GET['wiparameter5']) {commandaufruf("wiparameter5 $2 $3 $4 $5 $6");}
  if ($_GET['wiparameter6']) {commandaufruf("wiparameter6 $2 $3 $4 $5 $6 $7");}
  if ($_GET['wiparameter7']) {commandaufruf("wiparameter7 $2 $3 $4 $5 $6 $7 $8");}
  if ($_GET['wiparameter8']) {commandaufruf("wiparameter8 $2 $3 $4 $5 $6 $7 $8 $9");}

  // <p><a href="?wiparameter0=true" class="w3-button w3-blue w3-hover-green">Parameter0</a> Funktionsaufruf 0 Parameter.</p>
  // <p><a href="?wiparameter1=true" class="w3-button w3-blue w3-hover-green">Parameter1</a> Funktionsaufruf 1 Parameter.</p>
  // <p><a href="?wiparameter2=true" class="w3-button w3-blue w3-hover-green">Parameter2</a> Funktionsaufruf 2 Parameter.</p>
  // <p><a href="?wiparameter3=true" class="w3-button w3-blue w3-hover-green">Parameter3</a> Funktionsaufruf 3 Parameter.</p>
  // <p><a href="?wiparameter4=true" class="w3-button w3-blue w3-hover-green">Parameter4</a> Funktionsaufruf 4 Parameter.</p>
  // <p><a href="?wiparameter5=true" class="w3-button w3-blue w3-hover-green">Parameter5</a> Funktionsaufruf 5 Parameter.</p>
  // <p><a href="?wiparameter6=true" class="w3-button w3-blue w3-hover-green">Parameter6</a> Funktionsaufruf 6 Parameter.</p>
  // <p><a href="?wiparameter7=true" class="w3-button w3-blue w3-hover-green">Parameter7</a> Funktionsaufruf 7 Parameter.</p>

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
if ($_GET['osstart']) {abfrage1(); commandaufruf2("osstart " . $parameter2);}
if ($_GET['osstop']) {abfrage1(); commandaufruf2("osstop " . $_POST['parameter2']);}

$var2="Test1"; $var3="Test2"; $var4="Test3"; $var5="Test4"; $var6="Test5"; $var7="Test6"; $var8="Test7"; $var9="Test8";

if ($_GET['wiparameter0']) {commandaufruf("wiparameter0");}
if ($_GET['wiparameter1']) {commandaufruf("wiparameter1 $var2");}
if ($_GET['wiparameter2']) {commandaufruf("wiparameter2 $var2 $var3");}
if ($_GET['wiparameter3']) {commandaufruf("wiparameter3 $var2 $var3 $var4");}
if ($_GET['wiparameter4']) {commandaufruf("wiparameter4 $var2 $var3 $var4 $var5");}
if ($_GET['wiparameter5']) {commandaufruf("wiparameter5 $var2 $var3 $var4 $var5 $var6");}
if ($_GET['wiparameter6']) {commandaufruf("wiparameter6 $var2 $var3 $var4 $var5 $var6 $var7");}
if ($_GET['wiparameter7']) {commandaufruf("wiparameter7 $var2 $var3 $var4 $var5 $var6 $var7 $var8");}
if ($_GET['wiparameter8']) {commandaufruf("wiparameter8 $var2 $var3 $var4 $var5 $var6 $var7 $var8 $var9");}
?>

<!-- href im container -->
<div class="w3-container">
<p><a href="?hilfe=true" class="w3-button w3-blue w3-hover-green">Hilfe</a> Die Hilfeseite des opensimMULTITOOL anzeigen.</p>
<p><a href="?restart=true" class="w3-button w3-blue w3-hover-green">Grid Restart</a> Das gesamte Grid neu starten.</p>   
<p><a href="?start=true" class="w3-button w3-blue w3-hover-green">Grid Start</a> Startet das gesamte Grid.</p>
<p><a href="?stop=true" class="w3-button w3-blue w3-hover-green">Grid Stop</a> Stoppt das gesamte Grid.</p>

<p><a href="?osstart=true" class="w3-button w3-blue w3-hover-green">osstart</a> Ein einzelner Simulator Start.</p> 
<p><a href="?osstop=true" class="w3-button w3-blue w3-hover-green">osstop</a> Ein einzelner Simulator Stop.</p>

<p><a href="?wiparameter0=true" class="w3-button w3-blue w3-hover-green">Parameter0</a> Funktionsaufruf 0 Parameter.</p>
<p><a href="?wiparameter1=true" class="w3-button w3-blue w3-hover-green">Parameter1</a> Funktionsaufruf 1 Parameter.</p>
<p><a href="?wiparameter2=true" class="w3-button w3-blue w3-hover-green">Parameter2</a> Funktionsaufruf 2 Parameter.</p>
<p><a href="?wiparameter3=true" class="w3-button w3-blue w3-hover-green">Parameter3</a> Funktionsaufruf 3 Parameter.</p>
<p><a href="?wiparameter4=true" class="w3-button w3-blue w3-hover-green">Parameter4</a> Funktionsaufruf 4 Parameter.</p>
<p><a href="?wiparameter5=true" class="w3-button w3-blue w3-hover-green">Parameter5</a> Funktionsaufruf 5 Parameter.</p>
<p><a href="?wiparameter6=true" class="w3-button w3-blue w3-hover-green">Parameter6</a> Funktionsaufruf 6 Parameter.</p>
<p><a href="?wiparameter7=true" class="w3-button w3-blue w3-hover-green">Parameter7</a> Funktionsaufruf 7 Parameter.</p>
</div>

</body>
<div class="w3-container w3-green">
  <h5>opensimMultitool</h5>
</div>
</html>
