<?php
// Datenbankverbindung herstellen
$servername = "localhost";
$username = "root";
$password = "password";
$dbname = "MoneyDatabase";
$receiverID = "123456789";
$UUID = "123456789";

// Fehlerprotokoll auf dem Bildschirm aktivieren
ini_set('display_errors', 1);
error_reporting(E_ALL);

// Fehlerprotokoll in eine Datei schreiben
ini_set('log_errors', 1);
ini_set('error_log', 'moneyerror.log');

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Verbindung zur Datenbank fehlgeschlagen: " . $conn->connect_error);
}

// Funktion, um das Guthaben eines Benutzers abzurufen
function getBalance($userID) {
    global $conn;
    $query = "SELECT balance FROM balances WHERE user = ?";
    
    if ($stmt = $conn->prepare($query)) {
        $stmt->bind_param("s", $userID);
        $stmt->execute();
        $stmt->bind_result($balance);
        $stmt->fetch();
        $stmt->close();
        return $balance;
    } else {
        die("Fehler beim Abfragen des Guthabens: " . $conn->error);
    }
}

// Funktion, um das Guthaben eines Benutzers zu aktualisieren
function updateBalance($userID, $amount) {
    global $conn;
    $query = "UPDATE balances SET balance = balance + ? WHERE user = ?";
    
    if ($stmt = $conn->prepare($query)) {
        $stmt->bind_param("is", $amount, $userID);
        $stmt->execute();
        $stmt->close();
    } else {
        die("Fehler beim Aktualisieren des Guthabens: " . $conn->error);
    }
}

// Funktion, um Geld an einen anderen Benutzer zu überweisen
function giveMoney($UUID, $receiverID, $amount) {
    global $conn;
    $conn->autocommit(false); // Transaktion starten
    
    // Geld vom Sender abziehen
    updateBalance($UUID, -$amount);
    
    // Geld zum Empfänger hinzufügen
    updateBalance($receiverID, $amount);
    
    // Transaktion hinzufügen
    $transactionData = [
        'UUID' => $UUID,
        'senderID' => $UUID,
        'receiverID' => $receiverID,
        'amount' => $amount,
        'status' => 1, // 1 für erfolgreich, 0 für ausstehend oder fehlgeschlagen
        'description' => 'Überweisung erfolgreich'
    ];
    addTransaction($transactionData);
    
    // Transaktion bestätigen
    $conn->commit();
    $conn->autocommit(true);
}

// Funktion, um eine Transaktion hinzuzufügen
function addTransaction($transactionData) {
    global $conn;
    $query = "INSERT INTO transactions (UUID, sender, receiver, amount, status, description) VALUES (?, ?, ?, ?, ?, ?)";
    
    if ($stmt = $conn->prepare($query)) {
        $stmt->bind_param("sssiis", $transactionData['UUID'], $transactionData['sender'], $transactionData['receiver'], $transactionData['amount'], $transactionData['status'], $transactionData['description']);
        //$stmt->execute();
        $stmt->close();
    } else {
        die("Fehler beim Hinzufügen der Transaktion: " . $conn->error);
    }
}

// Funktion, um den Status einer Transaktion zu aktualisieren
function updateTransactionStatus($UUID, $status, $description) {
    global $conn;
    $query = "UPDATE transactions SET status = ?, description = ? WHERE UUID = ?";
    
    if ($stmt = $conn->prepare($query)) {
        $stmt->bind_param("iss", $status, $description, $UUID);
        $stmt->execute();
        $stmt->close();
    } else {
        die("Fehler beim Aktualisieren des Transaktionsstatus: " . $conn->error);
    }
}

// Test

// Function to get balance status
function getBalanceStatus($userID) {
    // Assuming you have a table named 'balances' with a column 'status'
    global $conn;
    $query = "SELECT status FROM balances WHERE user = ?";
    
    if ($stmt = $conn->prepare($query)) {
        $stmt->bind_param("s", $userID);
        $stmt->execute();
        $stmt->bind_result($status);
        $stmt->fetch();
        $stmt->close();
        return $status;
    } else {
        die("Fehler beim Abfragen des Balance-Status: " . $conn->error);
    }
}

// Function to update balance status
function updateBalanceStatus($userID, $status) {
    global $conn;
    $query = "UPDATE balances SET status = ? WHERE user = ?";
    
    if ($stmt = $conn->prepare($query)) {
        $stmt->bind_param("is", $status, $userID);
        $stmt->execute();
        $stmt->close();
    } else {
        die("Fehler beim Aktualisieren des Balance-Status: " . $conn->error);
    }
}

// Function to withdraw money
function withdrawMoney($transactionID, $senderID, $amount) {
    // Assuming you have a table for transactions where you record withdrawals
    // and a table for balances to deduct the amount from the sender's balance
    global $conn;
    $conn->autocommit(false); // Start transaction
    
    // Deduct the amount from the sender's balance
    updateBalance($senderID, -$amount);
    
    // Add the transaction record
    $transactionData = [
        'UUID' => $transactionID,
        'senderID' => $senderID,
        'receiverID' => null, // You may update this depending on your transaction structure
        'amount' => $amount,
        'status' => 1, // Assuming 1 means successful withdrawal
        'description' => 'Withdrawal successful'
    ];
    addTransaction($transactionData);
    
    // Commit the transaction
    $conn->commit();
    $conn->autocommit(true);
}

// Function to fetch transaction UUID
function FetchTransactionUUID($transactionID) {
    // Assuming you have a table for transactions with UUIDs
    global $conn;
    $query = "SELECT UUID FROM transactions WHERE UUID = ?";
    
    if ($stmt = $conn->prepare($query)) {
        $stmt->bind_param("s", $transactionID);
        $stmt->execute();
        $stmt->bind_result($uuid);
        $stmt->fetch();
        $stmt->close();
        return $uuid;
    } else {
        die("Fehler beim Abrufen der Transaktions-UUID: " . $conn->error);
    }
}

// Funktion, um Transaktionen eines Benutzers abzurufen
function FetchTransaction($userID, $startTime, $endTime, $index, $retNum) {
    global $conn;
    $query = "SELECT * FROM transactions WHERE sender = ? AND timestamp >= ? AND timestamp <= ? LIMIT ?, ?";
    
    if ($stmt = $conn->prepare($query)) {
        $stmt->bind_param("siisi", $userID, $startTime, $endTime, $index, $retNum);
        $stmt->execute();
        $result = $stmt->get_result();
        $transactions = [];
        
        while ($row = $result->fetch_assoc()) {
            $transactions[] = $row;
        }
        
        $stmt->close();
        return $transactions;
    } else {
        die("Fehler beim Abrufen der Transaktionen: " . $conn->error);
    }
}

// Funktion, um Benutzerinformationen abzurufen
function fetchUserInfo($userID) {
    global $conn;
    $query = "SELECT * FROM user_info WHERE user_id = ?";
    
    if ($stmt = $conn->prepare($query)) {
        $stmt->bind_param("s", $userID);
        $stmt->execute();
        $result = $stmt->get_result();
        $user_info = $result->fetch_assoc();
        $stmt->close();
        return $user_info;
    } else {
        die("Fehler beim Abrufen von Benutzerinformationen: " . $conn->error);
    }
}

// Funktion, um die Anzahl der Transaktionen eines Benutzers abzurufen
function getTransactionNum($userID, $startTime, $endTime) {
    global $conn;
    $query = "SELECT COUNT(*) AS num_transactions FROM transactions WHERE sender = ? AND timestamp >= ? AND timestamp <= ?";
    
    if ($stmt = $conn->prepare($query)) {
        $stmt->bind_param("sii", $userID, $startTime, $endTime);
        $stmt->execute();
        $stmt->bind_result($num_transactions);
        $stmt->fetch();
        $stmt->close();
        return $num_transactions;
    } else {
        die("Fehler beim Abrufen der Transaktionsanzahl: " . $conn->error);
    }
}

// Funktion, um Transaktionen als abgelaufen zu markieren
function SetTransExpired($deadTime) {
    global $conn;
    $query = "UPDATE transactions SET status = 0 WHERE timestamp < ?";
    
    if ($stmt = $conn->prepare($query)) {
        $stmt->bind_param("i", $deadTime);
        $stmt->execute();
        $stmt->close();
    } else {
        die("Fehler beim Markieren von Transaktionen als abgelaufen: " . $conn->error);
    }
}

// Funktion, um eine Überweisung zu validieren
function ValidateTransfer($secureCode, $transactionID) {
    global $conn;
    // Annahme: In deiner Datenbank gibt es eine Tabelle namens "transactions"
    $query = "SELECT * FROM transactions WHERE UUID = ? AND secure_code = ?";
    
    if ($stmt = $conn->prepare($query)) {
        $stmt->bind_param("ss", $transactionID, $secureCode);
        $stmt->execute();
        $result = $stmt->get_result();
        
        if ($result->num_rows === 1) {
            // Die Transaktion wurde gefunden und ist gültig
            $row = $result->fetch_assoc();
            
            // Du kannst hier weitere Validierungslogik hinzufügen, wenn benötigt
            
            // Setze den Status der Transaktion auf erfolgreich (1)
            $status = 1;
            $description = "Überweisung erfolgreich validiert";
            updateTransactionStatus($transactionID, $status, $description);
            
            $stmt->close();
        } else {
            // Die Transaktion wurde nicht gefunden oder ist ungültig
            // Setze den Status der Transaktion auf fehlgeschlagen (0)
            $status = 0;
            $description = "Überweisung ungültig";
            updateTransactionStatus($transactionID, $status, $description);
        }
    } else {
        die("Fehler bei der Validierung der Überweisung: " . $conn->error);
    }
}

// Funktion, um Benutzerinformationen hinzuzufügen
function addUserInfo($user) {
    global $conn;
    // Annahme: In deiner Datenbank gibt es eine Tabelle namens "user_info"
    $query = "INSERT INTO user_info (user_id, username, email) VALUES (?, ?, ?)";
    
    if ($stmt = $conn->prepare($query)) {
        $stmt->bind_param("sss", $user['user_id'], $user['username'], $user['email']);
        $stmt->execute();
        $stmt->close();
    } else {
        die("Fehler beim Hinzufügen von Benutzerinformationen: " . $conn->error);
    }
}

// Funktion, um Benutzerinformationen zu aktualisieren
function updateUserInfo($user) {
    global $conn;
    // Annahme: In deiner Datenbank gibt es eine Tabelle namens "user_info"
    $query = "UPDATE user_info SET username = ?, email = ? WHERE user_id = ?";
    
    if ($stmt = $conn->prepare($query)) {
        $stmt->bind_param("sss", $user['username'], $user['email'], $user['user_id']);
        $stmt->execute();
        $stmt->close();
    } else {
        die("Fehler beim Aktualisieren von Benutzerinformationen: " . $conn->error);
    }
}
// Test Ende

// Überprüfen, ob das Formular gesendet wurde
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $userID = $_POST["userID"];
    $amount = $_POST["amount"];
    
    // Überprüfe, welche Checkboxen ausgewählt wurden und rufe die entsprechenden Funktionen auf
    if (isset($_POST["giveMoney"])) {
        // Implementiere diese Funktion entsprechend deiner Anforderungen
        // Füge die Ergebnisse der Abfrage in eine Variable ein, die du später ausgeben kannst
        giveMoney($UUID, $receiverID, $amount);
    }
    // Überprüfe, welche Checkboxen ausgewählt wurden und rufe die entsprechenden Funktionen auf
    if (isset($_POST["FetchTransactionUUID"])) {
        // Funktionsaufruf für FetchTransaction
        // Implementiere diese Funktion entsprechend deiner Anforderungen
        // Füge die Ergebnisse der Abfrage in eine Variable ein, die du später ausgeben kannst
        $fetchTransactionResult = FetchTransactionUUID($transactionID);
    }
    if (isset($_POST["getBalance"])) {
        // Implementiere diese Funktion entsprechend deiner Anforderungen
        // Füge die Ergebnisse der Abfrage in eine Variable ein, die du später ausgeben kannst
        $getBalanceResult = getBalance($userID);
    }
    if (isset($_POST["updateBalance"])) {
        // Implementiere diese Funktion entsprechend deiner Anforderungen
        // Füge die Ergebnisse der Abfrage in eine Variable ein, die du später ausgeben kannst
        $updateBalanceResult = updateBalance($userID, $amount);
    }
    if (isset($_POST["addTransaction"])) {
        // Implementiere diese Funktion entsprechend deiner Anforderungen
        // Füge die Ergebnisse der Abfrage in eine Variable ein, die du später ausgeben kannst
        $addTransactionResult = addTransaction($transactionData);
    }
    if (isset($_POST["updateTransactionStatus"])) {
        // Implementiere diese Funktion entsprechend deiner Anforderungen
        // Füge die Ergebnisse der Abfrage in eine Variable ein, die du später ausgeben kannst
        $updateTransactionStatusResult = updateTransactionStatus($UUID, $status, $description);
    }
    if (isset($_POST["getBalanceStatus"])) {
        // Implementiere diese Funktion entsprechend deiner Anforderungen
        // Füge die Ergebnisse der Abfrage in eine Variable ein, die du später ausgeben kannst
        $getBalanceStatusResult = getBalanceStatus($userID);
    }
    if (isset($_POST["updateBalanceStatus"])) {
        // Implementiere diese Funktion entsprechend deiner Anforderungen
        // Füge die Ergebnisse der Abfrage in eine Variable ein, die du später ausgeben kannst
        $updateBalanceStatusResult = updateBalanceStatus($userID, $status);
    }
    if (isset($_POST["withdrawMoney"])) {
        // Implementiere diese Funktion entsprechend deiner Anforderungen
        // Füge die Ergebnisse der Abfrage in eine Variable ein, die du später ausgeben kannst
        $withdrawMoneyResult = withdrawMoney($transactionID, $senderID, $amount);
    }
    if (isset($_POST["FetchTransaction"])) {
        // Implementiere diese Funktion entsprechend deiner Anforderungen
        // Füge die Ergebnisse der Abfrage in eine Variable ein, die du später ausgeben kannst
        $FetchTransactionResult = FetchTransaction($userID, $startTime, $endTime, $index, $retNum);
    }
    if (isset($_POST["fetchUserInfo"])) {
        // Implementiere diese Funktion entsprechend deiner Anforderungen
        // Füge die Ergebnisse der Abfrage in eine Variable ein, die du später ausgeben kannst
        $fetchUserInfoResult = fetchUserInfo($userID);
    }
    if (isset($_POST["getTransactionNum"])) {
        // Implementiere diese Funktion entsprechend deiner Anforderungen
        // Füge die Ergebnisse der Abfrage in eine Variable ein, die du später ausgeben kannst
        $getTransactionNumResult = getTransactionNum($userID, $startTime, $endTime);
    }
    if (isset($_POST["SetTransExpired"])) {
        // Implementiere diese Funktion entsprechend deiner Anforderungen
        // Füge die Ergebnisse der Abfrage in eine Variable ein, die du später ausgeben kannst
        $SetTransExpiredResult = SetTransExpired($deadTime);
    }
    if (isset($_POST["ValidateTransfer"])) {
        // Implementiere diese Funktion entsprechend deiner Anforderungen
        // Füge die Ergebnisse der Abfrage in eine Variable ein, die du später ausgeben kannst
        $ValidateTransferResult = ValidateTransfer($secureCode, $transactionID);
    }
    if (isset($_POST["addUserInfo"])) {
        // Implementiere diese Funktion entsprechend deiner Anforderungen
        // Füge die Ergebnisse der Abfrage in eine Variable ein, die du später ausgeben kannst
        $addUserInfoResult = addUserInfo($user);
    }
    if (isset($_POST["updateUserInfo"])) {
        // Implementiere diese Funktion entsprechend deiner Anforderungen
        // Füge die Ergebnisse der Abfrage in eine Variable ein, die du später ausgeben kannst
        $updateUserInfoResult = updateUserInfo($user);
    }

    $balance = getBalance($userID);
    echo "<br>Guthaben von Benutzer $userID:<br> $balance<br>";

    updateBalance($userID, $amount);
    echo "<br>Guthaben von Benutzer $userID <br> nach der Aktualisierung: <br>" . getBalance($userID) . "<br>";

    $transactionStatus = 1; // 1 für erfolgreich, 0 für ausstehend oder fehlgeschlagen
    $transactionDescription = "Überweisung erfolgreich";
    updateTransactionStatus($UUID, $transactionStatus, $transactionDescription);
}

$conn->close();
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
    <title>OpenSim Banking</title>
    <h1>OpenSim Banking</h1>
</head>
<body>
    <div>
    <h2>Geldüberweisung Spielwiese Experiment</h2>
    <form method="post" action="<?php echo $_SERVER['PHP_SELF']; ?>">
        
        <input type="checkbox" name="giveMoney" id="giveMoney" checked="checked">
        <label for="giveMoney">Geld an User senden</label><br>
        
        <input type="checkbox" name="FetchTransactionUUID" id="FetchTransactionUUID">
        <label for="FetchTransactionUUID">Transaktions-UUID abrufen</label><br>
        
        <input type="checkbox" name="getBalance" id="getBalance">
        <label for="getBalance">Kontostand abrufen</label><br>
        
        <input type="checkbox" name="updateBalance" id="updateBalance">
        <label for="updateBalance">Aktualisieren des Kontostandes</label><br>
        
        <input type="checkbox" name="addTransaction" id="addTransaction">
        <label for="addTransaction">Transaktion hinzufügen</label><br>
        
        <input type="checkbox" name="getBalanceStatus" id="getBalanceStatus">
        <label for="agetBalanceStatus">Kontostand holen</label><br>
        
        <input type="checkbox" name="updateBalanceStatus" id="updateBalanceStatus">
        <label for="updateBalanceStatus">Kontostand Aktualisieren</label><br>
        
        <input type="checkbox" name="withdrawMoney" id="withdrawMoney">
        <label for="withdrawMoney">Geld abheben</label><br>

        <input type="checkbox" name="FetchTransaction" id="FetchTransaction">
        <label for="FetchTransaction">Transaktion abrufen</label><br>

        <input type="checkbox" name="fetchUserInfo" id="fetchUserInfo">
        <label for="fetchUserInfo">UserInfo abrufen</label><br>

        <input type="checkbox" name="getTransactionNum" id="getTransactionNum">
        <label for="getTransactionNum">Transaktionsnummer holen</label><br>

        <input type="checkbox" name="SetTransExpired" id="SetTransExpired">
        <label for="SetTransExpired">Transaktion als abgelaufen eintragen</label><br>

        <input type="checkbox" name="ValidateTransfer" id="ValidateTransfer">
        <label for="ValidateTransfer">Übertragung validieren</label><br>

        <input type="checkbox" name="addUserInfo" id="addUserInfo">
        <label for="addUserInfo">Benutzerinformationen hinzufügen</label><br>

        <input type="checkbox" name="updateUserInfo" id="updateUserInfo">
        <label for="updateUserInfo">Benutzerinfo aktualisieren</label><br><br>

        <!-- Eingabefelder sollen je nachdem was gefordert ist Rot oder Grün sein. -->

        Benutzer-ID: <br><input type="text" name="userID" id="userID" class="green"><br>
        Betrag: <br><input type="text" name="amount" id="amount" class="green"><br>
        Transaktions-ID: <br><input type="text" name="transactionID" id="transactionID" class="red"><br>
        Sender-ID: <br><input type="text" name="senderID" id="senderID" class="red"><br>
        Status: <br><input type="text" name="status" id="status" class="red"><br>
        Beschreibung: <br><input type="text" name="description" id="description" class="red"><br>
        <input type="submit" value="Anwenden">
    </form>
</div>
</body>
</html>