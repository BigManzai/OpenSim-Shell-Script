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
        $useruuid = $_POST["useruuid"];

        // Überprüfen, ob die useruuid existiert, bevor Sie andere Spalten bearbeiten
        $check_sql = "SELECT * FROM userprofile WHERE useruuid = ?";
        $check_stmt = $connection->prepare($check_sql);
        $check_stmt->bind_param("s", $useruuid);
        $check_stmt->execute();
        $result = $check_stmt->get_result();

        if ($result->num_rows == 1) {
            // Die useruuid existiert, jetzt können Sie andere Spalten bearbeiten
            $profilePartner = $_POST["profilePartner"];
            $profileAllowPublish = isset($_POST["profileAllowPublish"]) ? 1 : 0;
            $profileMaturePublish = isset($_POST["profileMaturePublish"]) ? 1 : 0;
            $profileURL = $_POST["profileURL"];
            $profileWantToMask = $_POST["profileWantToMask"];
            $profileWantToText = $_POST["profileWantToText"];
            $profileSkillsMask = $_POST["profileSkillsMask"];
            $profileSkillsText = $_POST["profileSkillsText"];
            $profileLanguages = $_POST["profileLanguages"];
            $profileImage = $_POST["profileImage"];
            $profileAboutText = $_POST["profileAboutText"];
            $profileFirstImage = $_POST["profileFirstImage"];
            $profileFirstText = $_POST["profileFirstText"];

            // SQL-Query zum Aktualisieren der anderen Spalten basierend auf der useruuid
            $update_sql = "UPDATE userprofile SET 
                           profilePartner = ?, 
                           profileAllowPublish = ?, 
                           profileMaturePublish = ?, 
                           profileURL = ?, 
                           profileWantToMask = ?, 
                           profileWantToText = ?, 
                           profileSkillsMask = ?, 
                           profileSkillsText = ?, 
                           profileLanguages = ?, 
                           profileImage = ?, 
                           profileAboutText = ?, 
                           profileFirstImage = ?, 
                           profileFirstText = ?
                           WHERE useruuid = ?";
            
            $update_stmt = $connection->prepare($update_sql);
            $update_stmt->bind_param("sisssisssssssss", 
                $profilePartner, $profileAllowPublish, $profileMaturePublish, 
                $profileURL, $profileWantToMask, $profileWantToText, 
                $profileSkillsMask, $profileSkillsText, $profileLanguages, 
                $profileImage, $profileAboutText, $profileFirstImage, 
                $profileFirstText, $useruuid);

            if ($update_stmt->execute()) {
                echo "Datensatz erfolgreich aktualisiert.";
            } else {
                echo "Fehler beim Aktualisieren des Datensatzes: " . $update_stmt->error;
            }

            $update_stmt->close();
        } else {
            echo'<span style="color:RED;text-align:center;"><h1>Die angegebene useruuid wurde nicht gefunden!!!</h1></span>';
        }

        $check_stmt->close();
    }

    $connection->close();
    ?>
<div>
    <form method="post" action="">
        <label for="useruuid">User UUID:</label>
        <input type="text" name="useruuid"><br><br>

        <label for="profilePartner">Profile Partner:</label>
        <input type="text" name="profilePartner"><br><br>

        <label for="profileAllowPublish">Allow Publish:</label>
        <input type="checkbox" name="profileAllowPublish"><br><br>

        <label for="profileMaturePublish">Mature Publish:</label>
        <input type="checkbox" name="profileMaturePublish"><br><br>

        <label for="profileURL">Profile URL:</label>
        <input type="text" name="profileURL"><br><br>

        <label for="profileWantToMask">Want To Mask:</label>
        <input type="text" name="profileWantToMask"><br><br>

        <label for="profileWantToText">Want To Text:</label>
        <textarea name="profileWantToText"></textarea><br><br>

        <label for="profileSkillsMask">Skills Mask:</label>
        <input type="text" name="profileSkillsMask"><br><br>

        <label for="profileSkillsText">Skills Text:</label>
        <textarea name="profileSkillsText"></textarea><br><br>

        <label for="profileLanguages">Languages:</label>
        <textarea name="profileLanguages"></textarea><br><br>

        <label for="profileImage">Profile Image:</label>
        <input type="text" name="profileImage"><br><br>

        <label for="profileAboutText">About Text:</label>
        <textarea name="profileAboutText"></textarea><br><br>

        <label for="profileFirstImage">First Image:</label>
        <input type="text" name="profileFirstImage"><br><br>

        <label for="profileFirstText">First Text:</label>
        <textarea name="profileFirstText"></textarea><br><br>

        <input type="submit" value="Speichern">
    </form>
    </div>
</body>
</html>
