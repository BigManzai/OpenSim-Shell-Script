<?php
// Lizenz: Gemeinfrei nach deutschem Gesetz.
// Diese PHP Datei kann erhebliche Schäden verursachen.
// Ich, Manfred Zainhofer der Autor, übernimmt keinerlei Haftung.
// Des Weiteren hat dieses Programm keinerlei Schutzfunktionen.

// License: Public domain according to German law.
// This PHP file can cause significant damage.
// I, Manfred Zainhofer the author, assumes no liability.
// Furthermore, this program does not have any protective functions.
?>

<!DOCTYPE html>
  <!-- loginscreen Version 1.0.2 by Manfred Aabye Lizens MIT -->
  <html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="author" content="Manfred Aabye">
    <meta name="publisher" content="Manfred Aabye">
    <meta name="copyright" content="Manfred Aabye">
    <meta name="description" content="Welcome to the metaverse!">
    <meta name="keywords" content="OpenSimulator, OpenSim, Grid, Metaversum, Metavers, Virtual, Reality, 3D, CAD, Rendering, 3D-Rendering, realtime 3d visualization">
    <meta name="page-topic" content="Umwelt">
    <meta name="page-type" content="Karte Plan">
    <meta name="audience" content="Alle"><meta http-equiv="content-language" content="de">
    <meta name="robots" content="index, follow">
    <meta http-equiv="cache-control" content="no-cache">
    <link rel="shortcut icon" href="includes/favicon.ico"/>
    <title>loginscreen</title>
</head>

<?php
//
// Alle weiteren Einstellungen
//
// Logo anzeigen
$logoon = "ON";
// Text anzeigen
$texton = "ON";
// Logo ladeort
$logo = "includes/Metavers.png";
// Breite des Logos
$breite = "40%";
// Hoehe des Logos
$hoehe = "40%";
// Anzeigetext - Leerzeichen am Anfang = &nbsp;
$text = "<p> &nbsp; Welcome to the metaverse! </p>";
// Zeit zwischen den Bildern 1000 = 1 Sekunde
$ptime = '9000';
?>

<html>

  <head>
    <meta charset="UTF-8">

<style>
    body {
    margin: 0px;
    font-family: Arial, Verdana, sans-serif;
    font-size: 26px;
    background: #3A3A3A;}

    p {
    margin: 0px;
    font-family: Arial, Verdana, sans-serif;
    color: white;
    font-size: 48px;
    font-weight: bold;}

    a {
    color: #3A3A3A;}

    a:hover {
    color: red;}

    #main {
    width: 100%;
    height: 100%;
    position: relative;
    z-index: 1;}

    #background1 {
    position: fixed;
    top: 0px;
    margin: 0px;
    height: 100%;
    width: 100%;
    z-index: 0;}

    #stats1 {
    position: absolute; 
    right: 10px; 
    top: 23px;
    text-align: left;
    height: 90px;
    width: 250px;
    z-index: 3;}

    #stats2 {
    height:100%;
    margin: 0;
    padding: 0;
    font-family: Arial, Verdana, sans-serif;
    font-size: 14px;
    text-align: right;
    position: absolute;}

    fieldset {
    padding: 10px;
    border-radius: 8px;
    -webkit-border-radius: 8px;
    -moz-border-radius: 8px;}

    legend {
    color: FFF;}

    fieldset.grey {
    padding: 10px;
    height: 100%;
    border:3px;}

    fieldset.white {
    padding: 5px;
    height: 96%;
    border:3px solid #3A3A3A;}

    fieldset.white2 {
    padding: 5px;
    height: 96%;
    border:3px solid #3A3A3A;}
</style>



<body>
  <!-- PHP Script fuer alle Bilder aus einem Verzeichnis ANFANG -->
    <?php
    $ordner = "./images";
    $allebilder = scandir ( $ordner );
    ?>

  <div id="background1">

    <?php
    foreach ( $allebilder as $bild ) {
      $bildinfo = pathinfo ( $ordner . "/" . $bild );
      if (! ($bild == "." || $bild == ".." || $bild == "_notes" || $bildinfo ['basename'] == "Thumbs.db")) {
        $size = ceil ( filesize ( $ordner . "/" . $bild ) / 1024 );
        // PHP Script fuer alle Bilder aus einem Verzeichnis ENDE -->
        ?>
      <li><div id="background1"><img class="PictureSlider" src="<?php echo $ordner."/".$bild; ?>" style="width:100%;height:100%" alt="slide 1" /></div></li><?php
      }
    };
    ?>

  </div>





  <!-- Logo oder Begruessungstext -->
    <div id='main'><br>
    <table border="0" width="100%" height="100%' cellspacing="0" cellpadding="0">

            <tr>
                    <!-- Das Logo Bild -->
                    <!-- <img border="0" src="./img/logo.png" width="40%" height="40%"> -->
                    <?php if ($logoon == "ON") { echo "<img border=\"0\" src= $logo width= $breite height= $hoehe >"; } ?>

                    <!-- Der Begruessungstext -->
                    <!-- <p>Welcome to the metaverse!</p> -->
                    <?php if ($texton == "ON") { echo "$text"; } ?>
            </tr>

    </table>
    </div>

  <!-- Statistik rechts oben splash.css name stats1 -->
  <div id='stats1'>
  <fieldset class='grey'>

  <!-- Datenbankabfrage Statistik -->
      <?php
      include("./includes/config.php");
        
      $con = mysqli_connect($CONF_db_server,$CONF_db_user,$CONF_db_pass,$CONF_db_database);

      // Query the database and get the count
      $result1 = mysqli_query($con,"SELECT COUNT(*) FROM Presence") or die("Error: " . mysqli_error($con));
      list($totalUsers) = mysqli_fetch_row($result1);
      $result2 = mysqli_query($con,"SELECT COUNT(*) FROM regions") or die("Error: " . mysqli_error($con));
      list($totalRegions) = mysqli_fetch_row($result2);
      $result3 = mysqli_query($con,"SELECT COUNT(*) FROM UserAccounts") or die("Error: " . mysqli_error($con));
      list($totalAccounts) = mysqli_fetch_row($result3);
      $result4 = mysqli_query($con,"SELECT COUNT(*) FROM GridUser WHERE Login > (UNIX_TIMESTAMP() - (30*86400))") or die("Error: " . mysqli_error($con));
      list($activeUsers) = mysqli_fetch_row($result4);
      $result5 = mysqli_query($con,"SELECT COUNT(*) FROM GridUser") or die("Error: " . mysqli_error($con));
      list($totalGridAccounts) = mysqli_fetch_row($result5);

      // Display the results
      echo "<div id='stats2'><b><font color=#00FF00>Nutzer im Grid</font><font color=#FFFFFF> : ". $totalUsers ."<font color=#FFFFFF><br>";
      echo "<font color=#00FF00>Regionen</font> : ". $totalRegions ."<font #FFFFFF><br>";
      echo "<font color=#00FF00>Aktiv in den letzten 30 Tage</font> : ". $activeUsers ."<font color=#FFFFFF><br>";
      echo "<font color=#00FF00>InworldNutzer</font> : ". $totalAccounts ."<font color=#FFFFFF><br>";
      echo "<font color=#00FF00>HgGridNutzer</font> : ". $totalGridAccounts ."<font color=#FFFFFF><br>";
      echo "<font color=#00AA00>Grid is ONLINE</font></b><br></div>";
      ?>

  </fieldset>
  </div>

  <!-- Skript -->
  <script>
  var slideIndex = 0;
  carousel();

  function carousel() {
      var i;
      var x = document.getElementsByClassName("PictureSlider");
      for (i = 0; i < x.length; i++) {
        x[i].style.display = "none";
      }
      slideIndex++;
      if (slideIndex > x.length) {slideIndex = 1}
      x[slideIndex-1].style.display = "block";
      setTimeout(carousel, <?php echo "$ptime" ?>); // 1000 = 1 second slide 
  }
  </script> 

</body>
</html>
