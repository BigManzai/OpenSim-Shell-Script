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
<html>
<title>Mute List Info</title>
<h1>Mute List Info</h1>
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

$sql = "SELECT * FROM MuteList ORDER BY AgentID ASC, MuteID ASC, MuteName ASC, MuteType ASC, MuteFlags ASC, Stamp ASC";
$result = mysqli_query($conn, $sql);

if ($result) {
    if (mysqli_num_rows($result) > 0) {
        echo "<table border='1'>";
        echo "<tr><th>Agent ID</th><th>Mute ID</th><th>Mute Name</th><th>Mute Type</th><th>Mute Flags</th><th>Stamp</th></tr>";

        while ($row = mysqli_fetch_assoc($result)) {
            echo "<tr>";
            echo "<td>" . $row['AgentID'] . "</td>";
            echo "<td>" . $row['MuteID'] . "</td>";
            echo "<td>" . $row['MuteName'] . "</td>";
            echo "<td>" . $row['MuteType'] . "</td>";
            echo "<td>" . $row['MuteFlags'] . "</td>";
            echo "<td>" . $row['Stamp'] . "</td>";
            echo "</tr>";
        }

        echo "</table>";
    } else {
        echo "Keine blockierten Benutzer gefunden.";
    }
} else {
    echo "Fehler beim Abrufen der blockierten Benutzer: " . mysqli_error($conn);
}

mysqli_close($conn);
?>
