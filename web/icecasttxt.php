<!DOCTYPE html>
<html>
<head>
    <title>Icecast2 Sender Daten</title>
</head>
</html>
<?php

// Funktion zum Abrufen und Aktualisieren der JSON-Daten
function updateData() {
    $url = 'http://ec3.yesstreaming.net:3220/status-json.xsl';
    //$url = 'http://dein-icecast-server/stream/status-json.xsl';
    $jsonData = file_get_contents($url);
    echo "<h1>Icecast2 Sender Daten:</h1><br>";

    if ($jsonData !== false) {
        $data = json_decode($jsonData, true);

        if (json_last_error() === JSON_ERROR_NONE) {
            // Ausgabe aller Einträge in den JSON-Daten
            echo "<b>Admin: </b>" . $data['icestats']['admin'] . "<br>";
            echo "<b>Banned IPs: </b>" . $data['icestats']['banned_IPs'] . "<br>";
            echo "<b>Build: </b>" . $data['icestats']['build'] . "<br>";
            echo "<b>Host: </b>" . $data['icestats']['host'] . "<br>";
            echo "<b>Location: </b>" . $data['icestats']['location'] . "<br>";
            echo "<b>Outgoing Kbitrate: </b>" . $data['icestats']['outgoing_kbitrate'] . "<br>";
            echo "<b>Server ID: </b>" . $data['icestats']['server_id'] . "<br>";
            echo "<b>Server Start: </b>" . $data['icestats']['server_start'] . "<br>";
            echo "<b>Stream Kbytes Read: </b>" . $data['icestats']['stream_kbytes_read'] . "<br>";
            echo "<b>Stream Kbytes Sent: </b>" . $data['icestats']['stream_kbytes_sent'] . "<br>";
            echo "<b>Audio Info: </b>" . $data['icestats']['source']['audio_info'] . "<br>";
            echo "<b>Bitrate: </b>" . $data['icestats']['source']['bitrate'] . "<br>";
            echo "<b>Connected: </b>" . $data['icestats']['source']['connected'] . "<br>";
            echo "<b>Genre: </b>" . $data['icestats']['source']['genre'] . "<br>";
            echo "<b>Incoming Bitrate: </b>" . $data['icestats']['source']['incoming_bitrate'] . "<br>";
            echo "<b>Listener Peak: </b>" . $data['icestats']['source']['listener_peak'] . "<br>";
            echo "<b>Listeners: </b>" . $data['icestats']['source']['listeners'] . "<br>";
            echo "<b>Listen URL: </b>" . $data['icestats']['source']['listenurl'] . "<br>";
            echo "<b>Metadata Updated: </b>" . $data['icestats']['source']['metadata_updated'] . "<br>";
            echo "<b>Outgoing Kbitrate: </b>" . $data['icestats']['source']['outgoing_kbitrate'] . "<br>";
            echo "<b>Queue Size: </b>" . $data['icestats']['source']['queue_size'] . "<br>";
            echo "<b>Server Name: </b>" . $data['icestats']['source']['server_name'] . "<br>";
            echo "<b>Server Type: </b>" . $data['icestats']['source']['server_type'] . "<br>";
            echo "<b>Stream Start: </b>" . $data['icestats']['source']['stream_start'] . "<br>";
            echo "<b>Title: </b>" . $data['icestats']['source']['title'] . "<br>";
            echo "<b>Total Mbytes Sent: </b>" . $data['icestats']['source']['total_mbytes_sent'] . "<br>";
            echo "<b>YP Currently Playing: </b>" . $data['icestats']['source']['yp_currently_playing'] . "<br>";

        } else {
            echo "Fehler beim Decodieren der JSON-Daten: " . json_last_error_msg();
        }
    } else {
        echo "Fehler beim Abrufen der Daten von der URL.";
    }
}
updateData();

// Schleife, um die Daten alle 30 Sekunden zu aktualisieren
// while (true) {
//     updateData();
//     sleep(30); // Warten Sie 30 Sekunden, bevor Sie erneut aktualisieren
// }
?>
</body>
</html>