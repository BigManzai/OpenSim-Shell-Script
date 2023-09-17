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
    <title>User Accounts Editor</title>
</head>
<body>
    <h1>User Accounts Editor</h1>
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

    $connection->close();
    ?>
<div>
    <form method="post" action="">
        <label for="principalID">Principal ID:</label>
        <input type="text" name="principalID"><br>

        <label for="scopeID">Scope ID:</label>
        <input type="text" name="scopeID"><br>

        <label for="firstName">First Name:</label>
        <input type="text" name="firstName"><br>

        <label for="lastName">Last Name:</label>
        <input type="text" name="lastName"><br>

        <label for="email">Email:</label>
        <input type="text" name="email"><br><br>

        <label for="serviceURLs">Service URLs:</label>
        <textarea name="serviceURLs"></textarea><br><br><br>

        <label for="userLevel">User Level:</label>
        <input type="number" name="userLevel"><br><br>

        <label for="userFlags">User Flags:</label>
        <input type="number" name="userFlags"><br><br>

        <label for="userTitle">User Title:</label>
        <input type="text" name="userTitle"><br><br>

        <label for="active">Active:</label>
        <input type="checkbox" name="active"><br><br>

        <input type="submit" value="Speichern">
    </form>
    </div>
</body>
</html>
