<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.css">
    <title>OpenSim User Assets</title>
</head>
<body>
    <?php
    error_reporting(E_ALL);
    ini_set('display_errors', 1);

    // Replace with your actual database connection details
    $servername = "localhost";
    $username = "your_username";
    $password = "your_password";
    $dbname = "your_database";

    // Replace 'user_id' with the user you want to list the inventory for
    $user_id = "00000000-0000-0000-0000-000000000000";

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

        echo "<h1>OpenSim User Assets</h1>";
        echo "<ul>";

        while ($row = $result->fetch_assoc()) {
            $assetName = $row["asset_name"];
            $assetType = $row["assetType"];
            $folderName = $row["folderName"];

            $iconClass = '';

            // Determine the Font Awesome icon based on assetType (you may need to adjust this)

            // if ($assetType == 0) {
            //     $iconClass = 'fa-file-image-o';  // Image icon
            // } elseif ($assetType == 2) {
            //     $iconClass = 'fa-file-text-o';   // Text icon
            // } else {
            //     $iconClass = 'fa-file-o';        // Generic file icon
            // }

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

            echo "<ul><i class='fa $iconClass'></i> $assetName - Folder: $folderName</ul>";
        }

        echo "</ul>";

        // Close the statement
        $stmt->close();
    } else {
        echo "Error: " . $conn->error;
    }

    // Close the database connection
    $conn->close();
    ?>
</body>
</html>