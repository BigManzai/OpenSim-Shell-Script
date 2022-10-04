<!DOCTYPE html>
<html>
<title>opensimMultitool</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
<link href="https://www.w3schools.com/icons/google_icons_intro.asp">
<body>

<div class="w3-container w3-blue">
  <h1>opensimMultitool Test Postings</h1>
</div>

<?php include "./header.php" ?>



<?php
//require('osmtclass.php');
include("osmtclass.php"); 

// * Test Start:

//abfrage1($funktionsname, $Titel, $Information)
//$osmtclass = new abfrage1();
// $osmtclass->abfrage1();
//$osmtclass->
abfrage1("passgen", "Passwortgenerator", "Anzahl Zeichen des Passwortes:");

//abfrage2($funktionsname, $Titel, $Information1, $Information2)
//abfrage2("allrepair_db", "Datenbanken Reparieren", "Benutzername:", "Passwort:");
?>

</body>
</html>

<?php include "./footer.php" ?>