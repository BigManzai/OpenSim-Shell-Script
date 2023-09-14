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

// Überprüfen, ob das Formular gesendet wurde
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $userID = $_POST["userID"];
    $amount = $_POST["amount"];
    
    // Rufen Sie hier die gewünschte Funktion auf, z.B. giveMoney($transactionID, $receiverID, $amount);
    // Beachten Sie, dass Sie das Überweisungsformular implementieren müssen.

    $balance = getBalance($userID);
    echo "<br>Guthaben von Benutzer $userID:<br> $balance<br>";

    updateBalance($userID, $amount);
    echo "<br>Guthaben von Benutzer $userID <br> nach der Aktualisierung: <br>" . getBalance($userID) . "<br>";

    // giveMoney($UUID, $receiverID, $amount); // Funktioniert noch nicht.
    // echo "<br>Guthaben von Benutzer $userID <br> nach der Überweisung: <br>" . getBalance($userID) . "<br>";

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
        <h2>Geldüberweisung</h2>
            <form method="post" action="<?php echo $_SERVER['PHP_SELF']; ?>">
                Benutzer-ID: <br><input type="text" name="userID" id="userID"><br><br>
                Betrag: <br><input type="text" name="amount" id="amount"><br><br>
                <input type="submit" value="Überweisen">
            </form>
    </div>
</body>
</html>
