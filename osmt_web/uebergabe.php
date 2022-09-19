<!DOCTYPE html>
<html>
<title>opensimMultitool</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
<body>

<style>
.w3-button {width:250px;}
.w3-card-4 {width:450px;}
.alert {
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

<?php
function test()
{
?>
<div class="w3-card-4">
  <div class="w3-container w3-green">
    <h2>Eingabe erforderlich</h2>
  </div>
  <form class="w3-container" action="uebergabe.php" method="POST">
    <p>      
    <label class="w3-text-green"><b>Simulator auswählen:</b></label>
    <input class="w3-input w3-border w3-sand" type="text" name="parameter2"></input></p>


    <p><button class="w3-btn w3-green">Senden</button></p>
  </form>
</div>


<?php
}

test();

$uebergabeparameter2 =  $_POST['parameter2'];

echo $uebergabeparameter2;

?>