<?php
// Lizenz: Gemeinfrei nach deutschem Gesetz.
// Diese PHP Datei kann erhebliche Schäden verursachen.
// Ich, Manfred Zainhofer der Autor, übernimmt keinerlei Haftung.
// Des Weiteren hat dieses Programm keinerlei Schutzfunktionen.

// License: Public domain according to German law.
// This PHP file can cause significant damage.
// I, Manfred Zainhofer the author, assumes no liability.
// Furthermore, this program does not have any protective functions.

// Fehlerprotokoll auf dem Bildschirm aktivieren
// ini_set('display_errors', 1);
// error_reporting(E_ALL);

function uuid4() {
    /* 32 random HEX + space for 4 hyphens */
    $out = bin2hex(random_bytes(18));

    $out[8]  = "-";
    $out[13] = "-";
    $out[18] = "-";
    $out[23] = "-";

    /* UUID v4 */
    $out[14] = "4";
    
    /* variant 1 - 10xx */
    $out[19] = ["8", "9", "a", "b"][random_int(0, 3)];

    return $out;
}

$NewUUID = uuid4();

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $Region = $_POST['Region'];
    $RegionUUID = $_POST['RegionUUID'];
    $LocationX = $_POST['LocationX'];
    $LocationY = $_POST['LocationY'];
    $SizeX = $_POST['SizeX'];
    $SizeY = $_POST['SizeY'];
    $SizeZ = $_POST['SizeZ'];
    $InternalPort = $_POST['InternalPort'];
    $ExternalHostName = $_POST['ExternalHostName'];

    // Fallback
    if (empty($Region)) { $Region = 'Welcome'; }
    if (empty($RegionUUID)) { $RegionUUID = $NewUUID; }
    if (empty($LocationX)) { $LocationX = 1000; }
    if (empty($LocationY)) { $LocationY = 1000; }
    if (empty($SizeX)) { $SizeX = 256; }
    if (empty($SizeY)) { $SizeY = 256; }
    if (empty($SizeZ)) { $SizeZ = 256; }
    if (empty($InternalPort)) { $InternalPort = 9000; }
    if (empty($MaxPrims)) { $MaxPrims = 100000; }
    if (empty($MaxAgents)) { $MaxAgents = 50; }
    if (empty($MaptileRefresh)) { $MaptileRefresh = 0; }
    if (empty($MasterAvatarFirstName)) { $MasterAvatarFirstName = 'John'; }
    if (empty($MasterAvatarLastName)) { $MasterAvatarLastName = 'Doe'; }
    if (empty($MasterAvatarSandboxPassword)) { $MasterAvatarSandboxPassword = 'passwd'; }
    if (empty($ExternalHostName)) { $ExternalHostName = '127.0.0.1'; }
    if (empty($MaptileStaticUUID)) { $MaptileStaticUUID = $RegionUUID; }
    if (empty($ScopeID)) { $ScopeID = $RegionUUID; }

    // Erstelle die INI-Konfigurationsdatei
    $config = "[$Region]\n";
    $config .= "RegionUUID = $RegionUUID\n";
    $config .= "Location = $LocationX,$LocationY\n";
    $config .= "SizeX = $SizeX\n";
    $config .= "SizeY = $SizeY\n";
    $config .= "SizeZ = $SizeZ\n";
    $config .= "InternalAddress = 0.0.0.0\n";
    $config .= "InternalPort = $InternalPort\n";
    $config .= "ResolveAddress = False\n";
    $config .= "ExternalHostName = $ExternalHostName\n";
    $config .= "MaptileStaticUUID = $MaptileStaticUUID\n";
    $config .= ";DefaultLanding = <128,128,21>\n";
    $config .= ";MaxPrims = $MaxPrims\n";
    $config .= ";MaxAgents = $MaxAgents\n";
    $config .= ";MaxPrimsPerUser = -1\n";
    $config .= ";ScopeID = $ScopeID\n";
    $config .= ";RegionType = Mainland\n";
    $config .= ";MapImageModule = Warp3DImageModule\n";
    $config .= ";RenderMinHeight = -1\n";
    $config .= ";RenderMaxHeight = 100\n";
    $config .= ";TextureOnMapTile = true\n";
    $config .= ";DrawPrimOnMapTile = true\n";
    $config .= ";GenerateMaptiles = true\n";
    $config .= ";MaptileRefresh = $MaptileRefresh\n";
    $config .= ";MaptileStaticFile = $Region.png\n";
    $config .= ";MasterAvatarFirstName = $MasterAvatarFirstName\n";
    $config .= ";MasterAvatarLastName = $MasterAvatarLastName\n";
    $config .= ";MasterAvatarSandboxPassword = $MasterAvatarSandboxPassword\n";
    
    // Weitere Konfigurationsoptionen hier hinzufügen

    // Datei speichern
    file_put_contents("$Region.ini", $config, 0);

    // Datei zum Download anbieten
    header('Content-Type: application/octet-stream');
    header('Content-Disposition: attachment; filename="' . $Region . '.ini"');
    echo $config;
    exit;
}
?>

<!DOCTYPE html>
<html>
<style>
input[type=text], select {
  width: 95%;
  padding: 12px 20px;
  margin: 8px 0;
  display: inline-block;
  border: 1px solid #ccc;
  border-radius: 4px;
  box-sizing: border-box;
}

input[type=text].gray {
  background-color: #f2f2f2;
}

input[type=text].red {
  background-color: #ffe6e6;
}

input[type=text].green {
  background-color: #e6ffe6;
}

input[type=checkbox] {
  margin-right: 5px;
}

input[type=submit] {
  width: 95%;
  background-color: #4CAF50;
  color: white;
  padding: 14px 20px;
  margin: 8px 0;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

input[type=submit]:hover {
  background-color: #45a049;
}

div {
  width: 25%;
  border-radius: 5px;
  background-color: #f2f2f2;
  padding: 20px;
}
</style>
<head>
    <title>Regionskonfiguration</title>
</head>
<body>
    <h1>Regionskonfiguration</h1>
    <div>
    <form method="post" action="<?php echo $_SERVER['PHP_SELF']; ?>">
        <label for="Region">Region:</label>
        <input type="text" name="Region"><br>
        <label for="RegionUUID">RegionUUID:</label>
        <input type="text" name="RegionUUID"><br>
        <label for="LocationX">Location X:</label>
        <input type="text" name="LocationX"><br>
        <label for="LocationY">Location Y:</label>
        <input type="text" name="LocationY"><br>
        <label for="SizeX">Size X:</label>
        <input type="text" name="SizeX"><br>
        <label for="SizeY">Size Y:</label>
        <input type="text" name="SizeY"><br>
        <label for="SizeZ">Size Z:</label>
        <input type="text" name="SizeZ"><br>
        <label for="InternalPort">Internal Port:</label>
        <input type="text" name="InternalPort"><br>
        <label for="ExternalHostName">External Host Name:</label>
        <input type="text" name="ExternalHostName"><br>
        <!-- Weitere Eingabefelder für andere Konfigurationsoptionen hier hinzufügen -->
        </fieldset>

        <input type="submit" value="Konfigurationsdatei generieren">
    </form>
    </div>
</body>
</html>
