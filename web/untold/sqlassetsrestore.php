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

// Benutzer nach seiner UUID fragen
$uuid = readline("Bitte geben Sie Ihre UUID ein: ");

// Suchen Sie in der Tabelle #assets# #CreatorID# nach Einträgen mit der gegebenen UUID
$sql = "SELECT * FROM assets WHERE CreatorID = ?";
$stmt = mysqli_prepare($conn, $sql);
mysqli_stmt_bind_param($stmt, "s", $uuid);
mysqli_stmt_execute($stmt);
$result = mysqli_stmt_get_result($stmt);

// Durchsuchen Sie die Ergebnisse und tragen Sie fehlende Einträge in #inventoryfolders# #Lost And Found# ein
while ($row = mysqli_fetch_assoc($result)) {
    $assetID = $row['AssetID'];

    // Überprüfen, ob der Eintrag bereits in #inventoryitems# vorhanden ist
    $checkSql = "SELECT * FROM inventoryitems WHERE AssetID = ?";
    $checkStmt = mysqli_prepare($conn, $checkSql);
    mysqli_stmt_bind_param($checkStmt, "s", $assetID);
    mysqli_stmt_execute($checkStmt);
    $checkResult = mysqli_stmt_get_result($checkStmt);

    if (mysqli_num_rows($checkResult) == 0) {
        // Eintrag in #inventoryitems# nicht gefunden, fügen Sie ihn zu #inventoryfolders# #Lost And Found# hinzu
        $insertSql = "INSERT INTO inventoryfolders (AgentID, FolderName) VALUES (?, ?)";
        $insertStmt = mysqli_prepare($conn, $insertSql);
        $lostAndFoundFolder = "Lost And Found";
        mysqli_stmt_bind_param($insertStmt, "ss", $uuid, $lostAndFoundFolder);
        mysqli_stmt_execute($insertStmt);

        // Verknüpfen Sie das Asset mit dem #Lost And Found#-Ordner
        $folderID = mysqli_insert_id($conn);
        $linkSql = "INSERT INTO inventoryitems (AssetID, FolderID, CreatorID) VALUES (?, ?, ?)";
        $linkStmt = mysqli_prepare($conn, $linkSql);
        mysqli_stmt_bind_param($linkStmt, "sss", $assetID, $folderID, $uuid);
        mysqli_stmt_execute($linkStmt);

        echo "Asset mit ID $assetID wurde zu Lost And Found hinzugefügt." . PHP_EOL;
    }
}

// Verbindung zur Datenbank schließen
mysqli_close($conn);
?>
