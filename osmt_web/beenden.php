
<?php
  // Löschen aller Session-Variablen.
  $_SESSION = array();

  // Session-Cookie löschen.
  if (ini_get("session.use_cookies")) {
      $params = session_get_cookie_params();
      setcookie(session_name(), '', time() - 42000, $params["path"],
          $params["domain"], $params["secure"], $params["httponly"]
      );
  }

  // Zum Schluß, löschen der Session.
  session_destroy();

  // Startseite aufrufen
  header('Location: login.php');
?>
