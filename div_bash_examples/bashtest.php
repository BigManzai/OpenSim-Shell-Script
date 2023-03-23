
<?php
//  Die Skripte phptest.sh und bashtest.php gehoeren zusammen.
echo "<h1>Dies ist ein PHP Skript und gehört in das html Verzeichnis.</h1>";
$output = shell_exec('/opt/phptest.sh');
echo "<pre><h1>$output</h1></pre>";
?>
