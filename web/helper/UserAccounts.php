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
    <title>User Profile Editor</title>
</head>
<body>
    <h1>User Profile Editor</h1>

<?php
    // Datenbankverbindung herstellen
    $host = "localhost"; // Ihr Datenbankhost
    $username = "username"; // Ihr Datenbankbenutzername
    $password = "password"; // Ihr Datenbankpasswort
    $database = "your_database"; // Ihr Datenbankname

    $connection = new mysqli($host, $username, $password, $database);

    if ($connection->connect_error) {
        die("Verbindung zur Datenbank fehlgeschlagen: " . $connection->connect_error);
    }

    if ($_SERVER["REQUEST_METHOD"] == "POST") {
        // Benutzerdaten aus dem Formular erfassen
        $principalID = $_POST["principalID"];
        $scopeID = $_POST["scopeID"];
        $firstName = $_POST["firstName"];
        $lastName = $_POST["lastName"];
        $email = $_POST["email"];
        $serviceURLs = $_POST["serviceURLs"];
        $userLevel = $_POST["userLevel"];
        $userFlags = $_POST["userFlags"];
        $userTitle = $_POST["userTitle"];
        $active = isset($_POST["active"]) ? 1 : 0; // Checkbox "active" abfragen

        // SQL-Query zum Aktualisieren oder Einfügen von Daten in die Tabelle UserAccounts
        $sql = "INSERT INTO UserAccounts (PrincipalID, ScopeID, FirstName, LastName, Email, ServiceURLs, UserLevel, UserFlags, UserTitle, active)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                ON DUPLICATE KEY UPDATE
                ScopeID = VALUES(ScopeID),
                FirstName = VALUES(FirstName),
                LastName = VALUES(LastName),
                Email = VALUES(Email),
                ServiceURLs = VALUES(ServiceURLs),
                UserLevel = VALUES(UserLevel),
                UserFlags = VALUES(UserFlags),
                UserTitle = VALUES(UserTitle),
                active = VALUES(active)";
        
        $stmt = $connection->prepare($sql);
        $stmt->bind_param("ssssssiiis", $principalID, $scopeID, $firstName, $lastName, $email, $serviceURLs, $userLevel, $userFlags, $userTitle, $active);

        if ($stmt->execute()) {
            echo "Datensatz erfolgreich hinzugefügt/aktualisiert.";
        } else {
            echo "Fehler beim Hinzufügen/Aktualisieren des Datensatzes: " . $stmt->error;
        }

        $stmt->close();
    }

    $selectedPrincipalID = ""; // Hier wird die ausgewählte Principal ID gespeichert

    if (isset($_GET["selectedPrincipalID"])) {
        // Wenn eine Principal ID ausgewählt wurde, diese abrufen und Benutzerdaten vorfüllen
        $selectedPrincipalID = $_GET["selectedPrincipalID"];

        // SQL-Query, um Benutzerdaten abzurufen
        $select_sql = "SELECT * FROM UserAccounts WHERE PrincipalID = ?";
        $select_stmt = $connection->prepare($select_sql);
        $select_stmt->bind_param("s", $selectedPrincipalID);
        $select_stmt->execute();
        $result = $select_stmt->get_result();

        if ($result->num_rows == 1) {
            $row = $result->fetch_assoc();

            // Benutzerdaten in Variablen speichern
            $scopeID = $row["ScopeID"];
            $firstName = $row["FirstName"];
            $lastName = $row["LastName"];
            $email = $row["Email"];
            $serviceURLs = $row["ServiceURLs"];
            $userLevel = $row["UserLevel"];
            $userFlags = $row["UserFlags"];
            $userTitle = $row["UserTitle"];
            $active = $row["active"];
        }
        
        $select_stmt->close();
    }

    $connection->close();
?>
<div>
    <!-- Benutzer auswählen -->
    <form method="get" action="">
        <label for="selectedPrincipalID" title="The UUID of an avatar">Select user (Principal ID):</label>
        <input type="text" name="selectedPrincipalID">
        <input type="submit" value="READ IN DATA" title="Read data"><br><br>
    </form>

    <form method="post" action="">
        <label for="principalID" title="The UUID of an avatar">Principal ID:</label>
        <input type="text" name="principalID" value="<?php echo $selectedPrincipalID; ?>"><br>

        <label for="scopeID" title="Used if several Grids use this database, grid 1 has a scope ID of 00000000-0000-0000-0000-000000000000 and Grid two would have 00000000-0000-0000-0000-000000000001 or similar setup, default is 00000000-0000-0000-0000-000000000000 ">Scope ID:</label>
        <input type="text" name="scopeID" value="<?php echo $scopeID; ?>"><br>

        <label for="firstName" title="The first name of the avatar">First Name:</label>
        <input type="text" name="firstName" value="<?php echo $firstName; ?>"><br>

        <label for="lastName" title="The last name of the avatar">Last Name:</label>
        <input type="text" name="lastName" value="<?php echo $lastName; ?>"><br>

        <label for="email" title="A real world email address that can be used to contact the person behind the avatar and that can be used when forwarding offline instant messages">Email:</label>
        <input type="text" name="email" value="<?php echo $email; ?>"><br><br>

        <label for="serviceURLs" title="unknown">Service URLs:</label>
        <textarea name="serviceURLs"><?php echo $serviceURLs; ?></textarea><br><br>

        <label for="userLevel" title="The value is 0 for normal users. Values of 200 and up are for grid gods.">User Level:</label>
        <input type="number" name="userLevel" value="<?php echo $userLevel; ?>"><br><br>

        <label for="userFlags" title="This field consists of two different values. Bit 0-7 are a field of bit flags that define certain characteristics of the user. Bits 8-11 are the user account level, Bits 12-15 are not used. 

Account Types: 
0 = Normal user (Resident) 
1 = Trial Member 
2 = Charter Member 
3 = Linden Labs Employee ">User Flags:</label>
        <input type="number" name="userFlags" value="<?php echo $userFlags; ?>"><br><br>

        <label for="userTitle" title="The value of this field appears in a users Profile in the box under Account: It can be used to show text for grid staff such as Mentor, Tech. Support, Grid Owner, or other special avatars in a grid.">User Title:</label>
        <input type="text" name="userTitle" value="<?php echo $userTitle; ?>"><br><br>

        <label for="active" title="Indicates if the user account is active.">User Active:</label>
        <input type="checkbox" name="active" <?php echo $active == 1 ? "checked" : ""; ?>><br><br>

        <input type="submit" value="WRITE DATA" title="Write data">
    </form>
    </div>
</body>
</html>
