<!DOCTYPE html>
<html>
<title>opensimMultitool</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
<body>

<div class="w3-container w3-blue">
  <h1>opensimMultitool</h1>
</div>

<img src="opensimMultitool.jpg" alt="opensimMultitool" style="width:100%">

<style>
.w3-button {width:150px;}
</style>

<div class="w3-container">
  <p>opensimMultitool ist eine Sammlung von automatisierter aufgaben für den OpenSimulator.</p>
</div>

<?php
if ($_GET['start']) {
  # Dieser Code wird ausgefuehrt, wenn ?start=true gesetzt ist.
  exec("/opt/opensim.sh autostart");
}
if ($_GET['stop']) {
    # Dieser Code wird ausgefuehrt, wenn ?stop=true gesetzt ist.
    exec("/opt/opensim.sh autostop");
  }
if ($_GET['restart']) {
# Dieser Code wird ausgefuehrt, wenn ?restart=true gesetzt ist.
exec("/opt/opensim.sh restart");
}    
?>

<div class="w3-container">
  <!-- Dieser Link fuegt Ihrer URL ostools.php?start=true ?start=true hinzu -->
  <p><a href="?start=true" class="w3-button w3-blue w3-hover-green">Grid Start</a> Startet das gesamte Grid.</p>
  <!-- Dieser Link fuegt Ihrer URL ostools.php?stop=true ?stop=true hinzu -->
  <p><a href="?stop=true" class="w3-button w3-blue w3-hover-green">Grid Stop</a> Stoppt das gesamte Grid.</p>
  <!-- Dieser Link fuegt Ihrer URL ostools.php?restart=true ?restart=true hinzu -->
  <p><a href="?restart=true" class="w3-button w3-blue w3-hover-green">Grid Restart</a> Das gesamte Grid neu starten.</p>
</div>

<div class="w3-container w3-green">
  <h5>opensimMultitool</h5>
</div>

</body>
</html>