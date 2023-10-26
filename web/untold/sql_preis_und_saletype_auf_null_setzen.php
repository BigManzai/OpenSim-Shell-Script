<?php
// Lizenz: Gemeinfrei nach deutschem Gesetz.
// Diese PHP Datei kann erhebliche Schäden verursachen.
// Ich, Manfred Zainhofer der Autor, übernimmt keinerlei Haftung.
// Des Weiteren hat dieses Programm keinerlei Schutzfunktionen.

// License: Public domain according to German law.
// This PHP file can cause significant damage.
// I, Manfred Zainhofer the author, assumes no liability.
// Furthermore, this program does not have any protective functions.

// MySQL Verbindungsinformationen
$hostname = "localhost"; // Ändern Sie dies auf den MySQL-Servernamen
$username = "root"; // Ändern Sie dies auf Ihren MySQL-Benutzernamen
$password = "passwort"; // Ändern Sie dies auf Ihr MySQL-Passwort
$database = "meine_db"; // Ändern Sie dies auf den Namen Ihrer MySQL-Datenbank

// Verbindung zur Datenbank herstellen
$conn = mysqli_connect($hostname, $username, $password, $database);

// Überprüfen Sie die Verbindung auf Fehler
if (!$conn) {
    die("Verbindung zur Datenbank fehlgeschlagen: " . mysqli_connect_error());
}

// SQL-UPDATE-Anweisung, um salePrice und saleType auf 0 zu setzen, wenn sie 1 oder höher sind
$sql = "UPDATE inventoryitems SET salePrice = 0, saleType = 0 WHERE salePrice >= 1 OR saleType >= 1";
$result = mysqli_query($conn, $sql);

if ($result) {
    $affectedRows = mysqli_affected_rows($conn);
    echo "Es wurden $affectedRows Zeilen aktualisiert. salePrice und saleType wurden auf 0 gesetzt." . PHP_EOL;
} else {
    echo "Fehler beim Aktualisieren der Daten: " . mysqli_error($conn) . PHP_EOL;
}

// Verbindung zur Datenbank schließen
mysqli_close($conn);
?>
