<?php
// Es hat eine Weile gedauert, bis ich herausgefunden habe, wie man eine bestimmte Sitzung in PHP zerstört. 
// Hinweis Ich bin mir nicht sicher, ob die unten angegebene Lösung perfekt ist, aber es scheint für mich zu funktionieren. 
// Bitte zögern Sie nicht, einen einfacheren Weg zu posten, um eine bestimmte Sitzung zu zerstören. 
// Weil es sehr nützlich ist, um einen Benutzer offline zu zwingen.

// 1. Wenn Sie db oder memcached zum Verwalten von Sitzungen verwenden, können Sie diesen Sitzungseintrag jederzeit direkt aus db oder memcached löschen.

// 2. Verwendung generischer PHP-Sitzungsmethoden zum Löschen einer bestimmten Sitzung (nach Sitzungs-ID).

$session_id_to_destroy = 'nill2if998vhplq9f3pj08vjb1';

// 1. Sitzung festschreiben, falls sie gestartet wurde.
if (session_id()) {
    session_commit();
}

// 2. Aktuelle Sitzungs-ID speichern
session_start();
$current_session_id = session_id();
session_commit();

// 3. hijack Entführen und dann angegebene Sitzung zerstören.
session_id($session_id_to_destroy);
session_start();
session_destroy();
session_commit();

// 4. Aktuelle Sitzungs-ID wiederherstellen. Wenn Sie es nicht wiederherstellen, bezieht sich Ihre aktuelle Sitzung auf die Sitzung, die Sie gerade zerstört haben!
session_id($current_session_id);
session_start();
session_commit();
?>
