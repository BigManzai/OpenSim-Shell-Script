<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Mapslider</title>
<!-- include jQuery library -->
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.3/jquery.min.js"></script>
<!-- include Cycle plugin -->
<script type="text/javascript" src="http://cloud.github.com/downloads/malsup/cycle/jquery.cycle.all.latest.js"></script>
<script type="text/javascript">
$(document).ready(function() {
    $('#galerie').cycle({
		fx: 'fade' // choose your transition type, ex: fade, scrollUp, shuffle, etc...
	});
});
</script>

</head>

<body>    
<div id="galerie">
	<?php
    // Karten kopieren Verzeichnis /opt oder /home.
    shell_exec('/opt/osmtool.sh makewebmaps');
    //$ordner = "/var/www/html/maptiles"; // Der Ordnerpfad von diesem Skript aus gesehen, wenn das script im Verzeichnis /map ist.
    $ordner = "../maptiles";  

    $allebilder = scandir($ordner);
    foreach ($allebilder as $bild) {
	$bildinfo = pathinfo($ordner."/".$bild); 
	if ($bild != "." && $bild != ".."  && $bild != "_notes" && $bildinfo['basename'] != "Thumbs.db") { 
	?>
	<img src="<?php echo $bildinfo['dirname']."/".$bildinfo['basename'];?>" alt="Vorschau" />
<?php
	};
 };
?>      
</div> 
</body>
</html>