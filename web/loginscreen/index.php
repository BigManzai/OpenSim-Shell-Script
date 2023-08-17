<!DOCTYPE html>
<html>

<style>
body {
margin: 0px;
font-family: Arial, Verdana, sans-serif;
font-size: 13px;
background: #FFF;;
}

p {
margin: 0px;
font-family: Arial, Verdana, sans-serif;
color: white;
font-size: 48px;
font-weight: bold;
}

a {
color: #FFF;
}

a:hover {
color: red;
}

#main {
width: 100%;
height: 100%;
position: relative;
z-index: 1;
}

#header {
position: absolute;
margin-top: 10px;
top: 10px;
background-image:url('header_background.png');
width: 95%;
height: 137px;
z-index: 2;
}

#background1 {
position: fixed;
top: 0px;
margin: 0px;
height: 100%;
width: 100%;
z-index: 0;
}

#canvas {
background-color: transparent;
position: fixed;
margin-top: 25%;
margin-left: 80%;
height: 25%;
width: 15%;
border:none;
z-index: 0;
}

#stats1 {
position: absolute; 
right: 10px; 
top: 23px;
text-align: left;
height: 90px;
width: 250px;
z-index: 3;
}

#stats2 {
height:100%;
margin: 0;
padding: 0;
font-family: Arial, Verdana, sans-serif;
font-size: 14px;
text-align: right;
position: absolute;
}

#regions1 {
position: absolute;
margin-top: 10px;
margin-left: 10px;
width: 175px;
z-index: 4;
font-family: Arial, Verdana, sans-serif;
font-size: 16px;
font-weight: bold;
}

#links {
position: absolute;
margin-top: 300px;
margin-left: 10px;
width: 175px;
z-index: 4;
font-family: Arial, Verdana, sans-serif;
font-size: 16px;
font-weight: bold;
}

#install {
position: absolute;
background-color: #C0C0C0;
margin-top: 150px;
margin-left: 150px;
width: 350px;
z-index: 4;
font-family: Arial, Verdana, sans-serif;
font-size: 16px;
text-align: center;
font-weight: bold;
}

#acindex1 {
position: absolute; 
right: 10px; 
top: 65px;
text-align: left;
height: 90px;
width: 50px;
z-index: 3;
}

#acindex2 {
height:100%;
margin: 0;
padding: 0;
font-family: Arial, Verdana, sans-serif;
font-size: 14px;
text-align: right;
position: absolute;
}

fieldset {
padding: 10px;
border-radius: 8px;
-webkit-border-radius: 8px;
-moz-border-radius: 8px;
}

legend {
color: FFF;
}

fieldset.grey {
padding: 10px;
height: 100%;
border:3px 
}

fieldset.white {
padding: 5px;
height: 96%;
border:3px solid #FFFFFF;

}

fieldset.white2 {
padding: 5px;
height: 96%;
border:3px solid #FFFFFF;

}
</style>

<title>loginscreen</title>
<link rel="shortcut icon" href="includes/favicon.ico" />
<meta name="viewport" content="width=device-width, initial-scale=1">

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
   <li><div id="background1"><img class="mySlides" src="<?php echo $ordner."/".$bild; ?>" style="width:100%;height:100%" alt="slide 1" /></div></li><?php
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
                <!-- Der Begruessungstext -->
                <p>Welcome to the metaverse!</p>
                </td>
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

<!-- Skripte -->
<script>
 var slideIndex = 0;
carousel();

function carousel() {
    var i;
    var x = document.getElementsByClassName("mySlides");
    for (i = 0; i < x.length; i++) {
      x[i].style.display = "none";
    }
    slideIndex++;
    if (slideIndex > x.length) {slideIndex = 1}
    x[slideIndex-1].style.display = "block";
    setTimeout(carousel, 9000); // 1000 = 1 second slide 
}
</script> 

</body>
</html>