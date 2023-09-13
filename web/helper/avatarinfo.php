<!DOCTYPE html>
<html>
<title>User Info</title>
<body>

<?php
// Datenbankverbindung herstellen (passen Sie die Verbindungsdaten an)
$servername = "localhost";
$username = "IhrBenutzername";
$password = "IhrPasswort";
$dbname = "IhreDatenbank";

// Fehlerprotokoll auf dem Bildschirm aktivieren
ini_set('display_errors', 1);
error_reporting(E_ALL);

// Benutzer nach der PrincipalID fragen
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $principalID = $_POST['principalID'];

    // Verbindung zur Datenbank herstellen
    $conn = new mysqli($servername, $username, $password, $dbname);

    // Überprüfen, ob die Verbindung erfolgreich hergestellt wurde
    if ($conn->connect_error) {
        die("Verbindung zur Datenbank fehlgeschlagen: " . $conn->connect_error);
    }

    // SQL-Abfrage für die 'Avatars'-Tabelle
    $query1 = "SELECT * FROM Avatars WHERE PrincipalID = '$principalID' ORDER BY PrincipalID, Name, Value";

    // Abfrage ausführen
    $result = $conn->query($query1);

    // Ergebnisse anzeigen
    if ($result->num_rows > 0) {
        echo "<h2>Avatar Informationen</h2>";
        echo "<table border='1'>
            <tr><th>PrincipalID</th><th>Name</th><th>Value</th></tr>";
        while ($row = $result->fetch_assoc()) {
            echo "<tr><td>".$row['PrincipalID']."</td><td>".$row['Name']."</td><td>".$row['Value']."</td></tr>";
        }
        echo "</table>";
    } else {
        echo "Keine Ergebnisse gefunden.";
    }

    // SQL-Abfrage für die 'Friends'-Tabelle
    $query2 = "SELECT * FROM Friends WHERE PrincipalID = '$principalID' ORDER BY PrincipalID, Friend, Flags, Offered";

    // Abfrage ausführen
    $result = $conn->query($query2);

    // Ergebnisse anzeigen
    if ($result->num_rows > 0) {
        echo "<h2>Friends Informationen</h2>";
        echo "<table border='1'>
            <tr><th>PrincipalID</th><th>Friend</th><th>Flags</th><th>Offered</th></tr>";
        while ($row = $result->fetch_assoc()) {
            echo "<tr><td>".$row['PrincipalID']."</td><td>".$row['Friend']."</td><td>".$row['Flags']."</td><td>".$row['Offered']."</td></tr>";
        }
        echo "</table>";
    } else {
        echo "Keine Ergebnisse gefunden.";
    }

    // SQL-Abfrage für die 'UserAccounts'-Tabelle
    $query3 = "SELECT * FROM UserAccounts WHERE PrincipalID = '$principalID' ORDER BY PrincipalID, ScopeID, FirstName, LastName, ServiceURLs, Created, UserLevel, UserFlags, UserTitle";

    // Abfrage ausführen
    $result = $conn->query($query3);

    // Ergebnisse anzeigen
    if ($result->num_rows > 0) {
        echo "<h2>UserAccounts Informationen</h2>";
        echo "<table border='1'>
            <tr><th>PrincipalID</th><th>ScopeID</th><th>FirstName</th><th>LastName</th><th>ServiceURLs</th><th>Created</th><th>UserLevel</th><th>UserFlags</th><th>UserTitle</th></tr>";
        while ($row = $result->fetch_assoc()) {
            echo "<tr><td>".$row['PrincipalID']."</td><td>".$row['ScopeID']."</td><td>".$row['FirstName']."</td><td>".$row['LastName']."</td><td>".$row['ServiceURLs']."</td><td>".$row['Created']."</td><td>".$row['UserLevel']."</td><td>".$row['UserFlags']."</td><td>".$row['UserTitle']."</td></tr>";
        }
        echo "</table>";
    } else {
        echo "Keine Ergebnisse gefunden.";
    }

    // SQL-Abfrage für die 'userinfo'-Tabelle
    $userinfoQuery = "SELECT * FROM userinfo WHERE user = '$principalID' ORDER BY user, simip, avatar, pass, type, class, serverurl";

    // Abfrage für 'userinfo' ausführen
    $userinfoResult = $conn->query($userinfoQuery);

    // Ergebnisse anzeigen
    

    // 'userinfo'-Ergebnisse anzeigen
    if ($userinfoResult->num_rows > 0) {
        echo "<h2>User Informationen</h2>";
        echo "<table border='1'>
            <tr><th>user</th><th>simip</th><th>avatar</th><th>type</th><th>class</th><th>serverurl</th></tr>";
        while ($row = $userinfoResult->fetch_assoc()) {
            echo "<tr><td>".$row['user']."</td><td>".$row['simip']."</td><td>".$row['avatar']."</td><td>".$row['type']."</td><td>".$row['class']."</td><td>".$row['serverurl']."</td></tr>";
        }
        echo "</table>";
    } else {
        echo "<p>Keine userinfo-Ergebnisse gefunden.</p>";
    }
    
    // Verbindung schließen
    $conn->close();
}
?>

<!-- HTML-Formular, um die PrincipalID vom Benutzer zu erhalten -->
<form method="post" action="<?php echo $_SERVER['PHP_SELF']; ?>">
    <label for="principalID">PrincipalID eingeben:</label>
    <input type="text" name="principalID" id="principalID" required>
    <input type="submit" value="Daten abrufen">
</form>
