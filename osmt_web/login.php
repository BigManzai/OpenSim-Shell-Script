<!DOCTYPE html>
<html>
<title>opensimMultitool</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
<link href="https://www.w3schools.com/icons/google_icons_intro.asp">
<body>

<div class="w3-container w3-blue">
  <h1>opensimMultitool Login</h1>
</div>

<?php include "./header.php" ?>

<div class="w3-container">
  <h2>opensimMultitool login</h2>
</div>

<?php
session_start();

if(isset($_POST['send']))
{
    $user = $_POST['user'];
    $pass = $_POST['pass'];
    
    //$username = 'opensim'; //hier wird der Benutzer eingetragen den Ihr zum Login in die Seite verwenden wollt.
    //$password = 'opensim';//hier wird das Passwort eingetragen den Ihr zum Login in die Seite verwenden wollt.
    include('config.php');
    
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
    header('Location: hauptmenu.php');
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
  ob_implicit_flush(true);
  ob_end_flush();

  $anmeldeversuch=30;
  echo '<br>FEHLER: Da hat etwas nicht gestimmt!<br>';
  echo '<br>Nächster anmeldeversuch erst in "'.$anmeldeversuch.'" Sekunden erlaubt!<br>';

  @ob_flush();
  sleep($anmeldeversuch);
}
?>

<?php include "./footer.php" ?>

</body>
</html>