<html><head><style>
li {  
  font-size: 50%;
  display: list-item;
}
</style></head></html>

<?php
//error_reporting(E_ALL);
//ini_set('display_errors', 1);

// Replace with your actual database connection details
$servername = "localhost";
$username = "username";
$password = "password";
$dbname = "dbname";
// Replace 'user_id' with the user you want to list the inventory for
$user_id = "da35d22a-0000-0000-0000-60110ddff000";

// Create a connection
$conn = new mysqli($servername, $username, $password, $dbname);
// Check the connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Query the inventory for the specific user
//$sql = "SELECT item_name, item_type FROM inventory WHERE user_id = $user_id";
$sql = "SELECT inventoryName, assetType FROM inventoryitems WHERE avatarID = '$user_id'";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    echo "<h1>User Inventory</h1>";
    echo "<ul>";
    while ($row = $result->fetch_assoc()) {
        //echo "<li>Name: " . $row["item_name"] . " - Type: " . $row["item_type"] . "</li>";
        echo "<li>Name: " . $row["inventoryName"] . " - Type: " . $row["assetType"] . "</li>";
    }
    echo "</ul>";
} else {
    echo "No items found in the inventory.";
}

// Close the database connection
$conn->close();
?>
