<?php
// Lizenz: Gemeinfrei nach deutschem Gesetz.
// Diese PHP Datei kann erhebliche Schäden verursachen.
// Ich, Manfred Zainhofer der Autor, übernimmt keinerlei Haftung.
// Des Weiteren hat dieses Programm keinerlei Schutzfunktionen.

// License: Public domain according to German law.
// This PHP file can cause significant damage.
// I, Manfred Zainhofer the author, assumes no liability.
// Furthermore, this program does not have any protective functions.

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

$sql = "SELECT * FROM GridUser ORDER BY UserID ASC, HomeRegionID ASC, HomePosition ASC, HomeLookAt ASC, LastRegionID ASC, LastPosition ASC, LastLookAt ASC, Online ASC, Login ASC, Logout ASC";
$result = mysqli_query($conn, $sql);

if ($result) {
    if (mysqli_num_rows($result) > 0) {
        echo "<table border='1'>";
        //echo "<tr><th>User ID</th><th>Home Region ID</th><th>Home Position</th><th>Home LookAt</th><th>Last Region ID</th><th>Last Position</th><th>Last LookAt</th><th>Online</th><th>Login</th><th>Logout</th></tr>";
        echo "<tr><th>User ID</th><th>Last Region ID</th><th>Last Position</th><th>Last LookAt</th><th>Online</th><th>Login</th><th>Logout</th></tr>";

        while ($row = mysqli_fetch_assoc($result)) {
            echo "<tr>";
            echo "<td>" . $row['UserID'] . "</td>";
            //echo "<td>" . $row['HomeRegionID'] . "</td>";
            //echo "<td>" . $row['HomePosition'] . "</td>";
            //echo "<td>" . $row['HomeLookAt'] . "</td>";
            echo "<td>" . $row['LastRegionID'] . "</td>";
            echo "<td>" . $row['LastPosition'] . "</td>";
            echo "<td>" . $row['LastLookAt'] . "</td>";
            echo "<td>" . $row['Online'] . "</td>";
            echo "<td>" . $row['Login'] . "</td>";
            echo "<td>" . $row['Logout'] . "</td>";
            echo "</tr>";
        }

        echo "</table>";
    } else {
        echo "Keine Benutzer gefunden.";
    }
} else {
    echo "Fehler beim Abrufen der Benutzer: " . mysqli_error($conn);
}

mysqli_close($conn);
?>
