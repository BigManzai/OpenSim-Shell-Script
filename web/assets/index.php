<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.css">
    <title>OpenSim User Assets</title>

<style>
li {  
  font-size: 60%;
  display: list-item;
    background-color:AliceBlue;
}
p {  
  font-size: 80%;
  font-weight: bold;
    background-color:AntiqueWhite;
}
</style>

</head>
<body>
    <h1>OpenSim User Assets</h1>
    <form method="post" action="">
        <label for="user_id">Enter User ID:</label>
        <input type="text" id="user_id" name="user_id" required>
        <button type="submit">Submit</button>
    </form>

    <?php
    // OpenSim User Assets V 1.0.6
    
    error_reporting(E_ALL);
    ini_set('display_errors', 1);

    // Check if the form is submitted
    if ($_SERVER["REQUEST_METHOD"] == "POST") {
        // Get the user_id from the form
        $user_id = $_POST["user_id"];

    // Replace with your actual database connection details
    $servername = "localhost";
    $username = "your_username";
    $password = "your_password";
    $dbname = "your_database";

    // Create a MySQLi connection
    $conn = new mysqli($servername, $username, $password, $dbname);

    // Check the connection
    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }

    // Query to retrieve assets and associated folders
    $sql = "SELECT a.name AS asset_name, a.assetType, f.folderName
            FROM assets AS a
            INNER JOIN inventoryitems AS i ON a.id = i.assetID
            INNER JOIN inventoryfolders AS f ON i.parentFolderID = f.folderID
            WHERE f.agentID = ?";

    // Prepare the SQL statement
    $stmt = $conn->prepare($sql);

    if ($stmt) {
        // Bind the user_id parameter
        $stmt->bind_param("s", $user_id);

        // Execute the query
        $stmt->execute();

        // Get the result set
        $result = $stmt->get_result();

        // Initialize an array to store folder contents
        $folderContents = [];

        while ($row = $result->fetch_assoc()) {
            $assetName = $row["asset_name"];
            $folderName = $row["folderName"];
            $assetType = $row["assetType"];

            // Determine the Font Awesome icon based on assetType (you may need to adjust this)
            $iconClass = '';
            if ($assetType == 0) {
                $iconClass = 'fa-file-image-o';     // Image icon
            } elseif ($assetType == -2) {
                $iconClass = 'fa-file-image-o';     // Material icon
            } elseif ($assetType == 1) {
                $iconClass = 'fa-file-sound-o';     // Sound icon
            } elseif ($assetType == 2) {
                $iconClass = 'fa-file-text-o';      // Calling Card icon
            } elseif ($assetType == 3) {
                $iconClass = 'fa-map-signs';        // Landmark icon
            } elseif ($assetType == 5) {
                $iconClass = 'fa-shopping-bag';     // Clothing icon
            } elseif ($assetType == 6) {
                $iconClass = 'fa fa-group';         // Object icon
            } elseif ($assetType == 7) {
                $iconClass = 'fa-file-text-o';      // Notecard icon
            } elseif ($assetType == 10) {
                $iconClass = 'fas fa-edit';        // script icon
            } elseif ($assetType == 13) {
                $iconClass = 'fa-shopping-bag';     // Body Part icon
            } elseif ($assetType == 20) {
                $iconClass = 'fa-navicon';          // Animation icon
            } elseif ($assetType == 21) {
                $iconClass = 'fa-coffee';           // Gesture icon
            } elseif ($assetType == 49) {
                $iconClass = 'fa-bitcoin';          // Mesh icon
            } elseif ($assetType == 56) {
                $iconClass = 'fa-gear';             // Setting icon
            } elseif ($assetType == 57) {
                $iconClass = 'fa-file-image-o';     // Material (PBR) icon
            } else {
                $iconClass = 'fa-file-o';           // Generic file icon
            }

            // Store the asset information in the folderContents array
            $folderContents[$folderName][] = ["name" => $assetName, "icon" => $iconClass];
        }

        // Close the statement
        $stmt->close();

        // Iterate through the folders and their contents and display them with icons
        echo "<h2>OpenSim User Assets</h2>";
        foreach ($folderContents as $folderName => $contents) {
            echo "<p>$folderName</p>";
            echo "<ul>";
            foreach ($contents as $content) {
                $assetName = $content["name"];
                $iconClass = $content["icon"];
                echo "<li><i class='fa $iconClass'></i> $assetName</li>";
            }
            echo "</ul>";
        }
    } else {
        echo "Error: " . $conn->error;
    }

    // Close the database connection
    $conn->close();
}
    ?>
</body>
</html>
