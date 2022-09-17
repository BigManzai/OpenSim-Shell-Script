<!DOCTYPE html>
<html>

<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
<body>

<div class="w3-container w3-blue">
  <h1>opensimMultitool</h1>
</div>

<img src="opensimMultitool.jpg" alt="opensimMultitool" style="width:60%">

<style>
.w3-btn {width:150px;}
</style>

<div class="w3-container">
  <h2>opensimMultitool login</h2>
</div>

<?php
session_start();
if(isset($_POST['send']))
{
    $user = $_POST['user'];
    $pass = $_POST['pass'];
    
    $username = 'opensim'; //hier wird der Benutzer eingetragen den Ihr zum Login in die Seite verwenden wollt.
    $password = 'opensim';//hier wird das Passwort eingetragen den Ihr zum Login in die Seite verwenden wollt.
    
    if($user == $username && $pass == $password)
    {
        $_SESSION['userid'] = 1;
    }
    else
    {
        $error = true;
    }
}

if(isset($_SESSION['userid']))
{
    //weiterleiten
    header('Location: ostools.php');
    //session_destroy(); // Zum testen.
}
else
{
?>

<form class="w3-container" action="login.php" method="post">
  <p>
  <label>Benutzername:</label>
  <input class="w3-input w3-hover-green" type="text" name="user" style="width:20%"></p>
  <p>
  <label>Passwort:</label>
  <input class="w3-input w3-hover-green" type="password" name="pass" style="width:20%"></p>
  <input class="w3-btn w3-blue" type="submit" name="send" value="Einloggen">
</form>

<?php
}
if(isset($error) && $error == true)
{
    echo '<br>FEHLER: Da hat etwas nicht gestimmt!<br>';
}
?>

<br><div class="w3-container w3-green">
  <h5>opensimMultitool</h5>
</div>

</body>
</html>