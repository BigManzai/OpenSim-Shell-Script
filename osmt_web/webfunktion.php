<!DOCTYPE html>
<html>
<title>opensimMultitool</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
<body>

<?php
// Funktion zum aufruf von opensim.sh Funktionen.
function commandaufruf(string $funktionsname)
{
    $ausgabe=null; $rueckgabewert=null;
    $zusammengesetzt="/opt/opensim.sh $funktionsname";
    exec($zusammengesetzt, $ausgabe, $rueckgabewert);

    foreach ($ausgabe as $bildschirmausgabe)
    {
        echo "<li>$bildschirmausgabe</li>";        
    }
}
?>


<?php commandaufruf("info"); ?>
