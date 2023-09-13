<!DOCTYPE html>
<html>
<title>User Info</title>
<h1>User Info</h1>
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

$sql = "SELECT * FROM userinfo ORDER BY user ASC, simip ASC, avatar ASC, pass ASC, type ASC, class ASC, serverurl ASC";
$result = mysqli_query($conn, $sql);

if ($result) {
    if (mysqli_num_rows($result) > 0) {
        echo "<table border='1'>";
        echo "<tr><th>User</th><th>Sim IP</th><th>Avatar</th><th>Pass</th><th>Type</th><th>Class</th><th>Server URL</th></tr>";

        while ($row = mysqli_fetch_assoc($result)) {
            echo "<tr>";
            echo "<td>" . $row['user'] . "</td>";
            echo "<td>" . $row['simip'] . "</td>";
            echo "<td>" . $row['avatar'] . "</td>";
            echo "<td>" . $row['pass'] . "</td>";
            echo "<td>" . $row['type'] . "</td>";
            echo "<td>" . $row['class'] . "</td>";
            echo "<td>" . $row['serverurl'] . "</td>";
            echo "</tr>";
        }

        echo "</table>";
    } else {
        echo "Keine Benutzerinformationen gefunden.";
    }
} else {
    echo "Fehler beim Abrufen der Benutzerinformationen: " . mysqli_error($conn);
}

mysqli_close($conn);
?>
