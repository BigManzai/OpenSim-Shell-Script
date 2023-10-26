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
$conn = new mysqli($hostname, $username, $password, $database);

// Überprüfen Sie die Verbindung auf Fehler
if ($conn->connect_error) {
    die("Verbindung zur Datenbank fehlgeschlagen: " . $conn->connect_error);
}

// Benutzer nach seiner UUID fragen
$uuid = readline("Bitte geben Sie Ihre UUID ein: ");

// Suchen Sie in der Tabelle #assets# #CreatorID# nach Einträgen mit der gegebenen UUID
$sql = "SELECT * FROM assets WHERE CreatorID = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("s", $uuid);
$stmt->execute();
$result = $stmt->get_result();

// Durchsuchen Sie die Ergebnisse und tragen Sie fehlende Einträge in #inventoryfolders# #Lost And Found# ein
while ($row = $result->fetch_assoc()) {
    $assetID = $row['AssetID'];

    // Überprüfen, ob der Eintrag bereits in #inventoryitems# vorhanden ist
    $checkSql = "SELECT * FROM inventoryitems WHERE AssetID = ?";
    $checkStmt = $conn->prepare($checkSql);
    $checkStmt->bind_param("s", $assetID);
    $checkStmt->execute();
    $checkResult = $checkStmt->get_result();

    if ($checkResult->num_rows == 0) {
        // Eintrag in #inventoryitems# nicht gefunden, fügen Sie ihn zu #inventoryfolders# #Lost And Found# hinzu
        $insertSql = "INSERT INTO inventoryfolders (AgentID, FolderName) VALUES (?, ?)";
        $insertStmt = $conn->prepare($insertSql);
        $lostAndFoundFolder = "Lost And Found";
        $insertStmt->bind_param("ss", $uuid, $lostAndFoundFolder);
        $insertStmt->execute();

        // Verknüpfen Sie das Asset mit dem #Lost And Found#-Ordner
        $folderID = $insertStmt->insert_id;
        $linkSql = "INSERT INTO inventoryitems (AssetID, FolderID, CreatorID) VALUES (?, ?, ?)";
        $linkStmt = $conn->prepare($linkSql);
        $linkStmt->bind_param("sss", $assetID, $folderID, $uuid);
        $linkStmt->execute();

        echo "Asset mit ID $assetID wurde zu Lost And Found hinzugefügt." . PHP_EOL;
    }
}

// Verbindung zur Datenbank schließen
$conn->close();
?>
