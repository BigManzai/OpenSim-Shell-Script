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
// /helper/osmt/postings.php
/*
    <form method="post" action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]);?>">
    Beim Absenden des Formulars werden die Formulardaten mit method="post" gesendet.
    Was ist die $_SERVER["PHP_SELF"]-Variable?
    $_SERVER["PHP_SELF"] ist eine superglobale Variable, die den Dateinamen des aktuell ausgeführten Skripts zurückgibt.
    Der $_SERVER["PHP_SELF"] sendet also die gesendeten Formulardaten an die Seite selbst, anstatt zu einer anderen Seite zu springen. 
    Auf diese Weise erhält der Benutzer Fehlermeldungen auf derselben Seite wie das Formular.

    Die Funktion htmlspecialchars() verhindert Exploits.
    Ein Exploit (engl. to exploit: ausnutzen) ist ein kleines Schadprogramm (Malware) bzw. eine Befehlsfolge, 
    die Sicherheitslücken und Fehlfunktionen von Hilfs- oder Anwendungsprogrammen ausnutzt, 
    um sich programmtechnisch Möglichkeiten zur Manipulation von PC-Aktivitäten (Administratorenrechte usw.)

    Alle Superglobale:

    $GLOBALS
    $_SERVER
    $_GET
    $_POST
    $_FILES
    $_COOKIE
    $_SESSION
    $_REQUEST
    $_ENV

    $http_​response_​header
    $argc
    $argv
*/
?>

<?php
//abfrage1(string $funktionsname, string $Information1)
//abfrage2(string $funktionsname, string $Information1, string $Information2)
//abfrage3(string $funktionsname, string $Information1, string $Information2, string $Information3)
//abfrage4(string $funktionsname, string $Information1, string $Information2, string $Information3, string $Information4)
//abfrage5(string $funktionsname, string $Information1, string $Information2, string $Information3, string $Information4, string $Information5)
//abfrage6(string $funktionsname, string $Information1, string $Information2, string $Information3, string $Information4, string $Information5, string $Information6)
//abfrage7(string $funktionsname, string $Information1, string $Information2, string $Information3, string $Information4, string $Information5, string $Information6, string $Information7)
//abfrage8(string $funktionsname, string $Information1, string $Information2, string $Information3, string $Information4, string $Information5, string $Information6, string $Information7, string $Information8)
?>


<?php
// Abfrage mit Titel und Information. Status OK
function abfrage1($funktionsname, $Titel, $Information1)
{
?>
  <div class="w3-card-4"><div class="w3-container w3-green"><h2><?php echo $Titel; ?></h2></div>
    <p><form class="w3-container" method="post" action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]);?>">
    <?php echo $Information1; ?> <input class="w3-input w3-border w3-sand" type="text" name="ergebnisseingabe1"></p>
    <p><button class="w3-btn w3-green">Senden</button></p>
    </form>
  </div>

  <?php
  if ($_SERVER["REQUEST_METHOD"] == "POST") 
  {
      // Wert des Eingabefeldes sammeln.
      $ergebniss2 = $_POST['ergebnisseingabe1']; trim($ergebniss2);      
      if (empty($ergebniss2)) {
        ?>    
        <div class="w3-card-4 w3-sand">
        <h2>Bildschirmausgabe</h2>
        <span class="closebtn" onclick="this.parentElement.style.display='none';">&times;</span>
        <pre> Eingabe ist leer oder unvollständig!</pre></div>
        <?php
      } else {
      $ausgabe=null; $rueckgabewert=null;
      $datei="/opt/opensim.sh";
      $zusammengesetzt="$datei $funktionsname $ergebniss2";
      exec($zusammengesetzt, $ausgabe, $rueckgabewert);
      ?> 	
    
      <div class="w3-card-4 w3-sand">
      <h2>Bildschirmausgabe</h2>
      <span class="closebtn" onclick="this.parentElement.style.display='none';">&times;</span>
    
        <?php
          foreach ($ausgabe as $bildschirmausgabe)
          {
            echo "<pre>".$bildschirmausgabe."</pre>";
          }
        ?> 
    
      </div> 
    
    <?php
    }
  }
}
?>

<?php
// Abfrage mit Titel und Information. Status OK
function abfrage2($funktionsname, $Titel, $Information1, $Information2)
{
?>
  <div class="w3-card-4"><div class="w3-container w3-green"><h2><?php echo $Titel; ?></h2></div>
    <p><form class="w3-container" method="post" action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]);?>">
    <?php echo $Information1; ?> <input class="w3-input w3-border w3-sand" type="text" name="ergebnisseingabe1"></p><br/>    
    <?php echo $Information2; ?> <input class="w3-input w3-border w3-sand" type="text" name="ergebnisseingabe2">
    <p><button class="w3-btn w3-green">Senden</button></p>
    </form>
  </div>

  <?php
  if ($_SERVER["REQUEST_METHOD"] == "POST") 
  {
      // Wert des Eingabefeldes sammeln.
      $ergebniss2 = $_POST['ergebnisseingabe1']; trim($ergebniss2);
	    $ergebniss3 = $_POST['ergebnisseingabe2']; trim($ergebniss3);    
      if (empty($ergebniss2) or empty($ergebniss3)) {
        ?>    
        <div class="w3-card-4 w3-sand">
        <h2>Bildschirmausgabe</h2>
        <span class="closebtn" onclick="this.parentElement.style.display='none';">&times;</span>
        <pre> Eingabe ist leer oder unvollständig!</pre></div>
        <?php
      } else {
      $ausgabe=null; $rueckgabewert=null;
      $datei="/opt/opensim.sh";
      $zusammengesetzt="$datei $funktionsname $ergebniss2 $ergebniss3";
      exec($zusammengesetzt, $ausgabe, $rueckgabewert);
      ?> 	
    
      <div class="alert">
      <span class="closebtn" onclick="this.parentElement.style.display='none';">&times;</span>
    
        <?php
          foreach ($ausgabe as $bildschirmausgabe)
          {
            echo "<pre>".$bildschirmausgabe."</pre>";
          }
        ?> 
    
      </div> 
    
    <?php
      }
  }
}
?>
<?php

// * Test Start:

//abfrage1($funktionsname, $Titel, $Information)
abfrage1("passgen", "Passwortgenerator", "Anzahl Zeichen des Passwortes:")

//abfrage2($funktionsname, $Titel, $Information1, $Information2)
//abfrage2("allrepair_db", "Datenbanken Reparieren", "Benutzername:", "Passwort:");
?>

</body>
</html>

<?php include "./footer.php" ?>