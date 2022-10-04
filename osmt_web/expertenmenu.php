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

<?php include("osmtclass.php"); ?>
<?php
// Get abfrage



?>

<!-- href im container -->
<div class="w3-container">
<!-- Menupunkte -->



</div>

<?php include "./footer.php" ?>