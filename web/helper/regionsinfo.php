<!DOCTYPE html>
<html>
<title>Regionsinfo</title>
<h1>Regionsinfo</h1>
<body>

<?php
// Datenbankverbindung herstellen (passen Sie die Verbindungsdaten an)
$servername = "localhost";
$username = "username";
$password = "password";
$database = "database";

// Fehlerprotokoll auf dem Bildschirm aktivieren
ini_set('display_errors', 1);
error_reporting(E_ALL);

$conn = mysqli_connect($servername, $username, $password, $database);

if (!$conn) {
    die("Verbindung zur Datenbank fehlgeschlagen: " . mysqli_connect_error());
}

//$sql = "SELECT * FROM regions ORDER BY uuid ASC, regionHandle ASC, regionName ASC, regionRecvKey ASC, regionSendKey ASC, regionSecret ASC, regionDataURI ASC, serverIP ASC, serverPort ASC, serverURI ASC, locX ASC, locY ASC, locZ ASC, eastOverrideHandle ASC, westOverrideHandle ASC, southOverrideHandle ASC, northOverrideHandle ASC, regionAssetURI ASC, regionAssetRecvKey ASC, regionAssetSendKey ASC, regionUserURI ASC, regionUserRecvKey ASC, regionUserSendKey ASC, regionMapTexture ASC, serverHttpPort ASC, serverRemotingPort ASC, owner_uuid ASC, originUUID ASC, access ASC, ScopeID ASC, sizeX ASC, sizeY ASC, flags ASC, last_seen ASC, PrincipalID ASC, Token ASC, parcelMapTexture DESC";
$sql = "SELECT * FROM regions ORDER BY uuid, regionHandle, regionName, regionRecvKey, regionSendKey, regionSecret, regionDataURI, serverIP, serverPort, serverURI, locX, locY, locZ, eastOverrideHandle, westOverrideHandle, southOverrideHandle, northOverrideHandle, regionAssetURI, regionAssetRecvKey, regionAssetSendKey, regionUserURI, regionUserRecvKey, regionUserSendKey, regionMapTexture, serverHttpPort, serverRemotingPort, owner_uuid, originUUID, access, ScopeID, sizeX, sizeY, flags, last_seen, PrincipalID, Token, parcelMapTexture DESC";
$result = mysqli_query($conn, $sql);

if ($result) {
    if (mysqli_num_rows($result) > 0) {
        echo "<table border='1'>";
        echo "<tr><th>UUID</th><th>Region Handle</th><th>Region Name</th><th>Region Recv Key</th><th>Region Send Key</th><th>Region Secret</th><th>Region Data URI</th><th>Server IP</th><th>Server Port</th><th>Server URI</th><th>LocX</th><th>LocY</th><th>LocZ</th><th>East Override Handle</th><th>West Override Handle</th><th>South Override Handle</th><th>North Override Handle</th><th>Region Asset URI</th><th>Region Asset Recv Key</th><th>Region Asset Send Key</th><th>Region User URI</th><th>Region User Recv Key</th><th>Region User Send Key</th><th>Region Map Texture</th><th>Server Http Port</th><th>Server Remoting Port</th><th>Owner UUID</th><th>Origin UUID</th><th>Access</th><th>Scope ID</th><th>SizeX</th><th>SizeY</th><th>Flags</th><th>Last Seen</th><th>PrincipalID</th><th>Token</th><th>Parcel Map Texture</th></tr>";

        while ($row = mysqli_fetch_assoc($result)) {
            echo "<tr>";
            echo "<td>" . $row['uuid'] . "</td>";
            echo "<td>" . $row['regionHandle'] . "</td>";
            echo "<td>" . $row['regionName'] . "</td>";
            echo "<td>" . ($row['regionRecvKey'] ? $row['regionRecvKey'] : 'NULL') . "</td>";
            echo "<td>" . ($row['regionSendKey'] ? $row['regionSendKey'] : 'NULL') . "</td>";
            echo "<td>" . $row['regionSecret'] . "</td>";
            echo "<td>" . ($row['regionDataURI'] ? $row['regionDataURI'] : 'NULL') . "</td>";
            echo "<td>" . $row['serverIP'] . "</td>";
            echo "<td>" . $row['serverPort'] . "</td>";
            echo "<td>" . $row['serverURI'] . "</td>";
            echo "<td>" . ($row['locX'] ? $row['locX'] : 'NULL') . "</td>";
            echo "<td>" . ($row['locY'] ? $row['locY'] : 'NULL') . "</td>";
            echo "<td>" . ($row['locZ'] ? $row['locZ'] : 'NULL') . "</td>";
            echo "<td>" . ($row['eastOverrideHandle'] ? $row['eastOverrideHandle'] : 'NULL') . "</td>";
            echo "<td>" . ($row['westOverrideHandle'] ? $row['westOverrideHandle'] : 'NULL') . "</td>";
            echo "<td>" . ($row['southOverrideHandle'] ? $row['southOverrideHandle'] : 'NULL') . "</td>";
            echo "<td>" . ($row['northOverrideHandle'] ? $row['northOverrideHandle'] : 'NULL') . "</td>";
            echo "<td>" . ($row['regionAssetURI'] ? $row['regionAssetURI'] : 'NULL') . "</td>";
            echo "<td>" . ($row['regionAssetRecvKey'] ? $row['regionAssetRecvKey'] : 'NULL') . "</td>";
            echo "<td>" . ($row['regionAssetSendKey'] ? $row['regionAssetSendKey'] : 'NULL') . "</td>";
            echo "<td>" . ($row['regionUserURI'] ? $row['regionUserURI'] : 'NULL') . "</td>";
            echo "<td>" . ($row['regionUserRecvKey'] ? $row['regionUserRecvKey'] : 'NULL') . "</td>";
            echo "<td>" . ($row['regionUserSendKey'] ? $row['regionUserSendKey'] : 'NULL') . "</td>";
            echo "<td>" . ($row['regionMapTexture'] ? $row['regionMapTexture'] : 'NULL') . "</td>";
            echo "<td>" . ($row['serverHttpPort'] ? $row['serverHttpPort'] : 'NULL') . "</td>";
            echo "<td>" . ($row['serverRemotingPort'] ? $row['serverRemotingPort'] : 'NULL') . "</td>";
            echo "<td>" . ($row['owner_uuid'] ? $row['owner_uuid'] : 'NULL') . "</td>";
            echo "<td>" . ($row['originUUID'] ? $row['originUUID'] : 'NULL') . "</td>";
            echo "<td>" . ($row['access'] ? $row['access'] : 'NULL') . "</td>";
            echo "<td>" . ($row['ScopeID'] ? $row['ScopeID'] : 'NULL') . "</td>";
            echo "<td>" . ($row['sizeX'] ? $row['sizeX'] : 'NULL') . "</td>";
            echo "<td>" . ($row['sizeY'] ? $row['sizeY'] : 'NULL') . "</td>";
            echo "<td>" . ($row['flags'] ? $row['flags'] : 'NULL') . "</td>";
            echo "<td>" . ($row['last_seen'] ? $row['last_seen'] : 'NULL') . "</td>";
            echo "<td>" . ($row['PrincipalID'] ? $row['PrincipalID'] : 'NULL') . "</td>";
            echo "<td>" . ($row['Token'] ? $row['Token'] : 'NULL') . "</td>";
            echo "<td>" . ($row['parcelMapTexture'] ? $row['parcelMapTexture'] : 'NULL') . "</td>";
            echo "</tr>";
        }

        echo "</table>";
    } else {
        echo "Keine Regionsdaten gefunden.";
    }
} else {
    echo "Fehler beim Abrufen der Regionsdaten: " . mysqli_error($conn);
}

mysqli_close($conn);
?>
