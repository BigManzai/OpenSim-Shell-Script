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

// Benutzer nach UUID1 und UUID2 fragen
$uuid1 = readline("Bitte geben Sie ihre alte CreatorID ein: ");
$uuid2 = readline("Bitte geben Sie ihre neue CreatorID ein: ");

// SQL-UPDATE-Anweisung, um UUID1 durch UUID2 in der Tabelle assets zu ersetzen
$sql = "UPDATE assets SET CreatorID = ? WHERE CreatorID = ?";
$stmt = mysqli_prepare($conn, $sql);
mysqli_stmt_bind_param($stmt, "ss", $uuid2, $uuid1);

if (mysqli_stmt_execute($stmt)) {
    $affectedRows = mysqli_affected_rows($conn);
    echo "Es wurden $affectedRows Zeilen aktualisiert. alte CreatorID wurde durch neue CreatorID ersetzt." . PHP_EOL;
} else {
    echo "Fehler beim Aktualisieren der Daten: " . mysqli_error($conn) . PHP_EOL;
}

// Verbindung zur Datenbank schließen
mysqli_close($conn);
?>
