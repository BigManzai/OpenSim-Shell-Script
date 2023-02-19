<!DOCTYPE html><html><head><meta charset="utf-8">
<!--
* Copyright (c) Metropolis Metaversum [ http://hypergrid.org ]
*
* The MetroTools are BSD-licensed. For more infornmations about BSD-licensed
* Software use this link: http://www.wikipedia.org/BSD-License
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are met:
*     * Redistributions of source code must retain the above copyright
*       notice, this list of conditions and the following disclaimer.
*     * Redistributions in binary form must reproduce the above copyright
*       notice, this list of conditions and the following disclaimer in the
*       documentation and/or other materials provided with the distribution.
*     * Neither the name of the Metropolis Project nor the
*       names of its contributors may be used to endorse or promote products
*       derived from this software without specific prior written permission.-->

<link id="main" rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css" type="text/css" media="screen">
<link id="main" rel="stylesheet" href="./includes/map.css" type="text/css" media="screen">
<?php
// Konfiguration einbinden
include("./includes/config.php");
?>

<head>
<title>Map Karte carte mapa</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="http://www.w3schools.com/lib/w3.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>

<!-- theme color
w3-theme-dark-grey, w3-theme-red, w3-theme-pink 	
w3-theme-purple, w3-theme-deep-purple, w3-theme-indigo 	
w3-theme-blue, w3-theme-light-blue, w3-theme-cyan 	
w3-theme-teal, w3-theme-green, w3-theme-light-green 	
w3-theme-lime, w3-theme-khaki, w3-theme-yellow 	
w3-theme-amber, w3-theme-orange, w3-theme-deep-orange 	
w3-theme-blue-grey, w3-theme-brown, w3-theme-grey 	
w3-theme-dark-grey, w3-theme-black, w3-theme-w3schools more on w3school -->
<link rel="stylesheet" href="https://www.w3schools.com/lib/w3-theme-dark-grey.css">
<!-- theme color end -->
</head>

<body>
<div class="w3-container w3-theme">
<h1>Map Karte carte mapa</h1>
</div>

<div class="w3-container w3-card-4 ex3">
<li class="w3-theme-l1">

<?php
//<!-- Sprachen laden -->
$sprache = substr($_SERVER["HTTP_ACCEPT_LANGUAGE"],0,2);
switch($sprache) {
case 'de': include("./includes/de.php");break;
case 'fr': include("./includes/fr.php");break;
case 'es': include("./includes/es.php");break;
case 'ru': include("./includes/ru.php");break;
case 'nl': include("./includes/nl.php");break;
case 'jp': include("./includes/jp.php");break;
case 'cn': include("./includes/cn.php");break;
case 'en': include("./includes/en.php");break;
default: include("./includes/en.php");}
?>

<?php
//<!-- UUID Generator -->
function v4() 
	{
	return sprintf('%04x%04x-%04x-%04x-%04x-%04x%04x%04x',

	// 32 bits for "time_low"
	mt_rand(0, 0xffff), mt_rand(0, 0xffff),

	// 16 bits for "time_mid"
	mt_rand(0, 0xffff),

	// 16 bits for "time_hi_and_version",
	// four most significant bits holds version number 4
	mt_rand(0, 0x0fff) | 0x4000,

	// 16 bits, 8 bits for "clk_seq_hi_res",
	// 8 bits for "clk_seq_low",
	// two most significant bits holds zero and one for variant DCE1.1
	mt_rand(0, 0x3fff) | 0x8000,

	// 48 bits for "node"
	mt_rand(0, 0xffff), mt_rand(0, 0xffff), mt_rand(0, 0xffff)
		);
	}  
?>

<?php
//Koordinatenvariablen deklarieren.
$grid_x = 0;
$grid_y = 0;

// Nachricht mit Post abfragen wenn dies nicht geht dann Get nutzen.
if (isset($_POST['x']) && ($_POST['y']))
	{
		$grid_x = $_POST['x'];
		$grid_y = $_POST['y'];
	}
else
{
	if (isset($_GET['x']) && ($_GET['y']))
	{
		$grid_x = $_GET['x'];
		$grid_y = $_GET['y'];
	} 
}

// center informationen aus der config.php.
if ($grid_x == 0) {$grid_x = $CONF_center_coord_x;}
if ($grid_y == 0) {$grid_y = $CONF_center_coord_y;}

// Wenn grid x oder y kleiner als 30 ist mache 100 daraus.
if ($grid_y <= 30) {$grid_y = "100";}
if ($grid_x <= 30) {$grid_x = "100";}

// Wenn grid x oder y groesser als 99999 ist hole center informationen aus der config.php.
if ($grid_x >=99999) {$grid_x = $CONF_center_coord_x;}
if ($grid_y >=99999) {$grid_y = $CONF_center_coord_y;}

// Voreinstellung Kartengroesse
if ($CONF_map_with == 1) 
	{
	// Standartgroesse 1
	$start_x = $grid_x - 10;
	$start_y = $grid_y + 5;

	$end_x = $grid_x + 10;
	$end_y = $grid_y - 5;
	}
if ($CONF_map_with == 2) 
	{
		// Kartengroesse 2
	$start_x = $grid_x - 20;
	$start_y = $grid_y + 10;

	$end_x = $grid_x + 24;
	$end_y = $grid_y - 12;
	}
if ($CONF_map_with == 3) 
	{
		// Kartengroesse 3
	$start_x = $grid_x - 30;
	$start_y = $grid_y + 20;

	$end_x = $grid_x + 30;
	$end_y = $grid_y - 20;
	}
if ($CONF_map_with == 4) 
	{
	// Kartengroesse 4
	$start_x = $grid_x - 40;
	$start_y = $grid_y + 30;

	$end_x = $grid_x + 40;
	$end_y = $grid_y - 30;
	}
if ($CONF_map_with == 5) 
	{
	// Kartengroesse 5
	$start_x = $grid_x - 55;
	$start_y = $grid_y + 28;

	$end_x = $grid_x + 55;
	$end_y = $grid_y - 28;
	} 
// Voreinstellung Kartengroesse ende
	
// Datenbank anzapfen
$con = mysqli_connect($CONF_db_server,$CONF_db_user,$CONF_db_pass,$CONF_db_database);

// Datenbank abfragen
$db_regionsdaten = mysqli_query($con,"SELECT uuid,regionName,locX,locY,serverURI,sizeX,sizeY,owner_uuid FROM regions") or die("Error: " . mysqli_error($con));

/* Datenbank pruefen */
if (mysqli_connect_errno()) 
{
printf("Database Error: %s\n", mysqli_connect_error());
exit();
}

$xx = 0;
if ($region['sizeX'] == 0) {$region['sizeX'] = 256; }
if ($region['sizeY'] == 0) {$region['sizeY'] = 256; }

// ********************************************************

while($region=mysqli_fetch_array($db_regionsdaten))
{
if ((($region['sizeX'] == 256) && ($region['sizeY'] == 256)) || (($region['sizeX'] == 256) && ($region['sizeY'] == 0)))
{
$work_reg = $region['uuid'].";".$region['regionName'].";".$region['locX'].";".$region['locY'].";".$region['serverURI'].";".$region['sizeX'].";".$region['sizeY'].";".$region['owner_uuid'].";SingleRegion";
$region_sg[$xx] = $work_reg;
$xx++;
}
else
{
$varreg_locx = ($region['locX'] / 256);
$varreg_locy = ($region['locY'] / 256);
$varreg_start_x = $varreg_locx;
$varreg_start_y = $varreg_locy;
$varreg_end_x = $varreg_locx + (($region['sizeX'] / 256) - 1);
$varreg_end_y = $varreg_locy + (($region['sizeY'] / 256) - 1); 

$varreg_work_x = $varreg_start_x;
$varreg_work_y = $varreg_start_y;

// ********************************************************

while (($varreg_work_y <= $varreg_end_y)&& ($varreg_work_x <= $varreg_end_x))
{
$varreg_key = $varreg_work_x."-".$varreg_work_y;

$work_reg = $region['uuid'].";".$region['regionName'].";".$varreg_work_x.";".$varreg_work_y.";".$region['serverURI'].";".$region['sizeX'].";".$region['sizeY'].";".$region['owner_uuid'].";VarRegion";

$region_sg[$xx] = $work_reg;
$xx++;

if (($varreg_work_y == $varreg_end_y)&& ($varreg_work_x == $varreg_end_x))
{}

if ($varreg_work_y == $varreg_end_y)
{
$varreg_work_y = $varreg_start_y;
$varreg_work_x++;
}
else
{
$varreg_work_y++;
}
} 
} 

// ********************************************************
} 
?>



<!-- Koordinaten Pfeile -->
<table class="navi" border=0 cellpadding=0 cellspacing=1>
<tr>
<td valign=top align=center>
<br>
<table width=90 height=90 cellspacing=1 cellpadding=0 border=0>
<tr>
<td align=center>
<center>
<table class="w3-table" border=0 cellpadding=0 cellspacing=1>
<tr align=center>
<td><div id="spacer2"></td>
<td><a href="index.php?x=<?php  echo $grid_x;?>&y=<?php  echo $grid_y + 10; ?>" target=_self><img src=./img/oben.png width="50" height="50" border=0 alt="<?php  echo $CONF_txt_north;?>" title="<?php  echo $CONF_txt_north;?>"></a></td>
<td><div id="spacer2"></td>
</tr>
<tr>
<td><a href="index.php?x=<?php  print $grid_x - 10; ?>&y=<?php  print $grid_y; ?>" target=_self><img src=./img/links.png width="50" height="50" border=0 alt="<?php  echo $CONF_txt_west;?>" title="<?php  echo $CONF_txt_west;?>"></a></td>
<td><a href="index.php?x=<?php  echo $CONF_center_coord_x;?>&y=<?php  echo $CONF_center_coord_y;?>" target=_self><img src=./img/home.png width="50" height="50" border=0 alt="<?php  echo $CONF_txt_center;?>" title="<?php  echo $CONF_txt_center;?>"></a></td>
<td><a href="index.php?x=<?php  print $grid_x + 10; ?>&y=<?php  print $grid_y; ?>" target=_self><img src=./img/rechts.png width="50" height="50" border=0 alt="<?php  echo $CONF_txt_east;?>" title="<?php  echo $CONF_txt_east;?>"></a></td>

</tr>
<tr>
<td><div id="spacer2"></td>
<td><a href="index.php?x=<?php  print $grid_x; ?>&y=<?php  print $grid_y -10; ?>" target=_self><img src=./img/unten.png width="50" height="50" border=0 alt="<?php  echo $CONF_txt_south;?>" title="<?php  echo $CONF_txt_south;?>"></a></td>
<td><div id="spacer2"></td>
</tr>
</table>
</td>
</tr>
</table>
<!-- Koordinaten Pfeile Ende -->

<!-- Kartengroesse -->
<table class="w3-container w3-table">
		<tr><br><br>
		<td colspan=2 align=center>
		<form action="index.php" method="post">

        <!-- Radio buttons fuer Wahl der Groesse, checked = Vorauswahl -->
		<div class="container">
		<h3><?php echo $CONF_txt_map?></h3>
		<label class="container"><?php echo $CONF_txt_wight1?>
		  <input type="radio" name="Groesse" value="eins">
		  <span class="checkmark"></span>
		</label>
		<label class="container"><?php echo $CONF_txt_wight2?>
		  <input type="radio" name="Groesse" value="zwei">
		  <span class="checkmark"></span>
		</label>
		<label class="container"><?php echo $CONF_txt_wight3?>
		  <input type="radio" checked="checked" name="Groesse" value="drei">
		  <span class="checkmark"></span>
		</label>
		<label class="container"><?php echo $CONF_txt_wight4?>
		  <input type="radio" name="Groesse" value="vier">
		  <span class="checkmark"></span>
		</label>
		<label class="container"><?php echo $CONF_txt_wight5?>
		  <input type="radio" name="Groesse" value="fuenf">
		  <span class="checkmark"></span>
		</label>
		</td></tr>

        <!-- Button auswahl bestaetigen und Seitenrefresh -->
		<tr>
		<td colspan=2 align=center>
		<button class="w3-btn-block w3-green w3-content" type="submit" name="kartengroesse" value="kartengroesse"><?php echo $CONF_txt_refresh?></button>
		</td></tr>
    </form></table>
	
<?php
//mit isset wird geprueft ob einer Variablen bereits 
//ein Wert zugewiesen wurde
if (isset($_POST['kartengroesse']))
{
    if (isset ($_POST['Groesse']))
	{
        if ($_POST['Groesse']=="eins")
		{
		// Kartengroesse 1
		$start_x = $grid_x - 10;
		$start_y = $grid_y + 5;

		$end_x = $grid_x + 10;
		$end_y = $grid_y - 5;
        }
        if ($_POST['Groesse']=="zwei")
		{
		// Kartengroesse 2
		$start_x = $grid_x - 20;
		$start_y = $grid_y + 10;

		$end_x = $grid_x + 24;
		$end_y = $grid_y - 12;
        }
        if ($_POST['Groesse']=="drei")
		{
		// Kartengroesse 3
		$start_x = $grid_x - 30;
		$start_y = $grid_y + 20;

		$end_x = $grid_x + 30;
		$end_y = $grid_y - 20;

        }
		if ($_POST['Groesse']=="vier")
		{
		// Kartengroesse 4
		$start_x = $grid_x - 40;
		$start_y = $grid_y + 30;

		$end_x = $grid_x + 40;
		$end_y = $grid_y - 30;
        }
		if ($_POST['Groesse']=="fuenf")
		{
		// Kartengroesse 5
		$start_x = $grid_x - 60;
		$start_y = $grid_y + 40;

		$end_x = $grid_x + 60;
		$end_y = $grid_y - 40;
        }

    }
}
?> <!-- Kartengroesse Ende --> 

<!-- Koordinaten eingabe -->  
<br><br>
<table class="w3-table">
<tr>
<td align=center valign=middle>
<center><b><br><font color=White><?php  echo $CONF_txt_coords;?></font></b><font color=White><br><hr width=40%>
<table class="w3-table">
<tr>
<td align=right valign=middle border=0 width=40%>
<form name="submit" action="index.php" method="post">
<font color=White><b>X:</b></font>
<div id="spacer2"></td>
<td width=60% valign=middle border=1 align=left>
<input type="text" value="<?php print $grid_x;?>" name="x" size=4></td>
</tr>

<tr>
<td align=right valign=middle border=0 width=40%>
<form name="submit" action="index.php" method="post">
<font color=White><b>Y:</b></font>
<div id="spacer2"></td>
<td width=60% valign=middle border=1 align=left> 
<input type="text" value="<?php print $grid_y;?>" name="y" size=4></td>				   
</tr>

<tr>
<td colspan=2 align=center>
<br>
<button class="w3-btn-block w3-green" type="submit" name="submit" value="Installer"><?php echo $CONF_txt_search?></button>
<br><br>
</form>
</b></font></td>
</tr>
</table>
</td>
</tr>
</table></td>
<!-- Koordinaten eingabe Ende --> 

<!-- Zellenfarbe und abstand -->
<td><div id="spacer2"></td>
<td valign=top>
<br>    
<table class="w3-container w3-cell w3-card-4 ex3" cellpadding=0 cellspacing=0;>


<?php 
$y = $start_y;
$x = $start_x;

while ($y >= $end_y)
{
$x = $start_x;
?>

</td></tr><tr valign=middle><td valign=middle>
</div>

<?php 
while ($x <= $end_x)
{
if ($y == $start_y)
{
?>

</td>
</div>

<?php 
$x++; 
}
else
{
$count = count($region_sg);
for ($q = 0; $q < $count; $q++)
{
$region_value = $region_sg[$q];
$sim_new = 0;
list($region_uuid, $region_name, $region_locx, $region_locy, $region_serverip, $region_sizex, $region_sizey, $region_owner, $region_type) = explode(";",$region_value);

if ($region_sizey == 0) { $region_sizey = 256; }

if ($region_locx >= 100000)
{
$region_locx = $region_locx / 256;
$region_locy = $region_locy / 256;
}

if (($region_locx == $x) && ($region_locy == $y))
{ $sim_new = 1; break;}
}


$db_benutzerdaten=mysqli_query($con,"SELECT FirstName, LastName FROM UserAccounts where PrincipalID='$region_owner';") or die("Error: " . mysqli_error($con));

$owner=mysqli_fetch_array($db_benutzerdaten);
$firstname = $owner['FirstName'];
$lastname = $owner['LastName'];

if ($sim_new == 1)
{

if (($x == $CONF_center_coord_x) && ($y == $CONF_center_coord_y))
{
$region_dimension = ($region_sizex / 256)." x ".($region_sizey / 256)." Regions";
$region_total_size = $region_sizex * $region_sizey;
$region_total_size = number_format($region_total_size, 0, ",", ".")." sqm";    
?>

</td>
<!-- Center Region of Grid -->
<td>
<A>
<form action="index.php" method="post">
<button class="w3-container w3-button <?php print $CONF_color_center; ?>" type="submit" name="teleportwelcome" value="teleportwelcome"
id="zentrum" 
alt= "
<?php echo"$CONF_txt_region_name - $region_name
$CONF_txt_regiontype - $region_type
$region_dimension
$CONF_txt_total_size - $region_totalsize
$CONF_txt_x_Coord - $x
$CONF_txt_y_Coord - $y
$CONF_txt_status - $CONF_txt_occupied
$CONF_txt_owner - $firstname - $lastname";?>" 
title = "<?php echo"$CONF_txt_region_name -$region_name
$CONF_txt_regiontype - $region_type
$region_dimension
$CONF_txt_total_size - $region_totalsize
$CONF_txt_x_Coord - $x
$CONF_txt_y_Coord - $y
$CONF_txt_status - $CONF_txt_occupied
$CONF_txt_owner - $firstname - $lastname";?>"
</A>

<?php
if (isset($_POST['teleportwelcome']))
	{ 
	$teleportwelcomelink = "secondlife://http|!!" .  $CONF_sim_domain . "|" . $CONF_port . "+" . $region_name;
	//header("Location:$teleportwelcomelink");
	//echo $region_name;
	}
?>

<?php 
$x++;

}
else
{

if ($region_type == "SingleRegion")
{
$reg_colour = "sbesetzt";
$reg_colourx = "$CONF_color_occupied_single";
}
if ($region_type == "VarRegion")
{
$reg_colour = "vbesetzt";
$reg_colourx = "$CONF_color_occupied_var";
}

$region_dimension = ($region_sizex / 256)." x ".($region_sizey / 256)." Regions";
$region_totalsize = $region_sizex * $region_sizey;
$region_totalsize = number_format($region_totalsize, 0, ",", ".")." sqm"; 

?>

</td>
<!-- Regions of Grid -->
<td>
<A>
<form action="index.php" method="post">
<button class="w3-container w3-button <?php print $reg_colourx;?>" type="submit" name="teleportregion" value="teleportregion"
id='<?php print $reg_colour;?>' 
alt= "
<?php echo"$CONF_txt_region_name - $region_name
$CONF_txt_regiontype - $region_type
$region_dimension
$CONF_txt_total_size - $region_totalsize
$CONF_txt_x_Coord - $x
$CONF_txt_y_Coord - $y
$CONF_txt_status - $CONF_txt_occupied
$CONF_txt_owner - $firstname - $lastname";?>" 
title = "<?php echo"$CONF_txt_region_name -$region_name
$CONF_txt_regiontype - $region_type
$region_dimension
$CONF_txt_total_size - $region_totalsize
$CONF_txt_x_Coord - $x
$CONF_txt_y_Coord - $y
$CONF_txt_status - $CONF_txt_occupied
$CONF_txt_owner - $firstname - $lastname";?>"
</A>
<?php
if (isset($_POST['teleportregion']))
	{ 
	$teleportregionlink = "secondlife://http|!!" .  $CONF_sim_domain . "|" . $CONF_port . "+" . $region_name;
	//header("Location:$teleportregionlink");
	//echo $region_name;
	}
?>

<?php 
$x++;
}}    

else

{
?>

</td>
<!-- Free Regions of Grid -->
<td>
<A>
<form action="index.php" method="post">
<button class="w3-button <?php print $CONF_color_free_coord; ?>" type="submit" name="button1" value="button1"
id="water" 
alt= "
<?php echo"$CONF_txt_x_Coord $x 
$CONF_txt_y_Coord $y 
$CONF_txt_status $CONF_txt_free";?>"
title= " <?php echo"$CONF_txt_x_Coord $x
$CONF_txt_y_Coord $y
$CONF_txt_status $CONF_txt_free";?>

<?php $v4uuid = v4(); $intport = rand(9002, 9999);  echo "
;****** Region$x$y.ini ******
[Region$x$y]
RegionUUID = $v4uuid
Location = $x,$y
SizeX = 256
SizeY = 256
SizeZ = 256
InternalAddress = 0.0.0.0
InternalPort = $intport
AllowAlternatePorts = False
ExternalHostName = SYSTEMIP";?>"
</A>

<?php 
$x++; 

}
} 
}

$y--;

}

?>

</td>
</tr>
</table>

</tr>
</table>

<table class="w3-bar w3-content">
<tr><br>
<button class="w3-bar-item w3-button <?php print $CONF_color_free_coord; ?>" style="width:25%"><?php print $CONF_txt_free_coord; ?></button>
<button class="w3-bar-item w3-button <?php print $CONF_color_occupied_single; ?>" style="width:25%"><?php print $CONF_txt_occupied_single; ?></button>
<button class="w3-bar-item w3-button <?php print $CONF_color_occupied_var; ?>" style="width:25%"><?php print $CONF_txt_occupied_var; ?></button>
<button class="w3-bar-item w3-button <?php print $CONF_color_center; ?>" style="width:25%"><?php print $CONF_txt_center; ?></button>

</tr>
</table>

<?php
//Mit isset Button auswerten
if (isset($_POST['button1']))
	{ 
$v4uuid = v4(); $intport = rand(9002, 9999);  
echo "
;****** Region$x$y.ini ******</br>
[Region$x$y]</br>
RegionUUID = $v4uuid</br>
Location = $x,$y</br>
SizeX = 256</br>
SizeY = 256</br>
SizeZ = 256</br>
InternalAddress = 0.0.0.0</br>
InternalPort = $intport</br>
AllowAlternatePorts = False</br>
ExternalHostName = SYSTEMIP</br>
;End Region$x$y";
	}
?>



</li>	
</div>

</div>



</body>
</html>	
