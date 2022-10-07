<!DOCTYPE html>
<html>
<title>opensimMultitool</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
<link href="https://www.w3schools.com/icons/google_icons_intro.asp">
<body>

<?php
// Login
session_start();
if($_SESSION['userid'] === 1)
{
 // geschützer bereich
 echo " ";
}
else 
{
    //echo '<a href="login.php">Log dich bitte ein</a>';
	header('Location: mySQLmenu.php'); // Zurueck zum Login.
	//exit ();
}
?>

<div class="w3-container w3-blue">
  <h1>opensimMultitool MySQL</h1>
</div>

<?php include "./header.php" ?>

<?php include("osmt2.class.php"); ?>

<?php
// Get abfrage
// if ($_GET['db_anzeigen_dialog']) {abfrage1("db_anzeigen_dialog", "Alle Datenbanken anzeigen", "Alle Datenbanken anzeigen:");}
// if ($_GET['db_tables_dialog']) {abfrage1("db_tables_dialog", "Tabellen einer Datenbank", "Tabellen einer Datenbank:");}
// if ($_GET['db_all_user_dialog']) {abfrage1("db_all_user_dialog", "Alle Benutzerdaten der ROBUST Datenbank", "Alle Benutzerdaten der ROBUST Datenbank:");}
// if ($_GET['db_all_uuid_dialog']) {abfrage1("db_all_uuid_dialog", "UUID von allen Benutzern anzeigen", "UUID von allen Benutzern anzeigen:");}
// if ($_GET['db_all_name_dialog']) {abfrage1("db_all_name_dialog", "Alle Benutzernamen anzeigen", "Alle Benutzernamen anzeigen:");}
// if ($_GET['db_user_data_dialog']) {abfrage1("db_user_data_dialog", "Daten von einem Benutzer anzeigen", "ADaten von einem Benutzer anzeigen:");}
// if ($_GET['db_user_infos_dialog']) {abfrage1("db_user_infos_dialog", "UUID, Vor, Nachname, E-Mail vom Benutzer anzeigen", "UUID, Vor, Nachname, E-Mail vom Benutzer anzeigen:");}
// if ($_GET['db_user_uuid_dialog']) {abfrage1("db_user_uuid_dialog", "UUID von einem Benutzer anzeigen", "UUID von einem Benutzer anzeigen:");}
// if ($_GET['db_benutzer_anzeigen']) {abfrage1("db_benutzer_anzeigen", "mySQL Datenbankbenutzer anzeigen", "mySQL Datenbankbenutzer anzeigen:");}
// if ($_GET['db_regions']) {abfrage1("db_regions", "Alle Grid Regionen listen", "Alle Grid Regionen listen:");}
// if ($_GET['db_regionsuri']) {abfrage1("db_regionsuri", "Region URI pruefen sortiert nach URI", "Region URI pruefen sortiert nach URI:");}
// if ($_GET['db_regionsport']) {abfrage1("db_regionsport", "Ports pruefen sortiert nach Ports", "Ports pruefen sortiert nach Ports:");}
// if ($_GET['db_create']) {abfrage1("db_create", "Neue Datenbank erstellen", "Neue Datenbank erstellen:");}
// if ($_GET['db_all_userfailed']) {abfrage1("db_all_userfailed", "Benutzer inventoryfolders alles was type -1 ist anzeigen", "Benutzer inventoryfolders alles was type -1 ist anzeigen:");}
// if ($_GET['db_userdate']) {abfrage1("db_userdate", "Zeige Erstellungsdatum eines Users an", "Zeige Erstellungsdatum eines Users an:");}

// if ($_GET['db_false_email']) {abfrage1("db_false_email", "Finde falsche E-Mail Adressen", "Finde falsche E-Mail Adressen:");}
// if ($_GET['db_delete']) {abfrage1("db_delete", "Datenbank komplett loeschen", "Datenbank komplett loeschen:");}
// if ($_GET['db_empty']) {abfrage1("db_empty", "Datenbank leeren", "Datenbank leeren:");}
// if ($_GET['db_create_new_dbuser']) {abfrage1("db_create_new_dbuser", "Neuen Datenbankbenutzer anlegen", "Neuen Datenbankbenutzer anlegen:");}

// if ($_GET['db_dbuserrechte']) {abfrage1("db_dbuserrechte", "Listet alle erstellten Benutzerrechte auf", "Listet alle erstellten Benutzerrechte auf");}
// if ($_GET['db_deldbuser']) {abfrage1("db_deldbuser", "Loescht einen Datenbankbenutzer", "Loescht einen Datenbankbenutzer:");}
// if ($_GET['allrepair_db']) {abfrage1("allrepair_db", "Alle Datenbanken Checken, Reparieren und Optimieren", "Alle Datenbanken Checken, Reparieren und Optimieren:");}
// if ($_GET['install_mysqltuner']) {abfrage1("install_mysqltuner", "mysqlTuner herunterladen", "mysqlTuner herunterladen:");}
// if ($_GET['db_email_setincorrectuseroff_dialog']) {abfrage1("db_email_setincorrectuseroff_dialog", "Alle Benutzer mit inkorrekter EMail abschalten", "Alle Benutzer mit inkorrekter EMail abschalten:");}
// if ($_GET['db_setuserofline_dialog']) {abfrage1("db_setuserofline_dialog", "Benutzeracount abschalten", "Benutzeracount abschalten:");}
// if ($_GET['db_setuseronline_dialog']) {abfrage1("db_setuseronline_dialog", "Benutzeracount einschalten", "Benutzeracount einschalten:");}
?>

<!-- href im container -->
<div class="w3-container">
<!-- Hauptmenu -->
<p><a href="?db_anzeigen_dialog=true" class="w3-button w3-blue w3-hover-green">Alle Datenbanken anzeigen</a> Alle Datenbanken anzeigen.</p>
<p><a href="?db_tables_dialog=true" class="w3-button w3-blue w3-hover-green">Tabellen einer Datenbank</a> Tabellen einer Datenbank.</p>
<p><a href="?db_all_user_dialog=true" class="w3-button w3-blue w3-hover-green">Alle Benutzerdaten der ROBUST Datenbank</a> Alle Benutzerdaten der ROBUST Datenbank.</p>
<p><a href="?db_all_uuid_dialog=true" class="w3-button w3-blue w3-hover-green">UUID von allen Benutzern anzeigen</a> UUID von allen Benutzern anzeigen.</p>
<p><a href="?db_all_name_dialog=true" class="w3-button w3-blue w3-hover-green">Alle Benutzernamen anzeigen</a> Alle Benutzernamen anzeigen.</p>
<p><a href="?db_user_data_dialog=true" class="w3-button w3-blue w3-hover-green">Daten von einem Benutzer anzeigen</a> Daten von einem Benutzer anzeigen.</p>
<p><a href="?db_user_infos_dialog=true" class="w3-button w3-blue w3-hover-green">UUID, Vor, Nachname, E-Mail vom Benutzer anzeigen</a> UUID, Vor, Nachname, E-Mail vom Benutzer anzeigen.</p>
<p><a href="?db_user_uuid_dialog=true" class="w3-button w3-blue w3-hover-green">UUID von einem Benutzer anzeigen</a> UUID von einem Benutzer anzeigen.</p>
<p><a href="?db_benutzer_anzeigen=true" class="w3-button w3-blue w3-hover-green">mySQL Datenbankbenutzer anzeigen</a> mySQL Datenbankbenutzer anzeigen.</p>
<p><a href="?db_regions=true" class="w3-button w3-blue w3-hover-green">Alle Grid Regionen listen</a> Alle Grid Regionen listen.</p>
<p><a href="?db_regionsuri=true" class="w3-button w3-blue w3-hover-green">Region URI pruefen sortiert nach URI</a> Region URI pruefen sortiert nach URI.</p>
<p><a href="?db_regionsport=true" class="w3-button w3-blue w3-hover-green">db_regionsport</a> Ports pruefen sortiert nach Ports.</p>
<p><a href="?db_create=true" class="w3-button w3-blue w3-hover-green">db_create</a> Neue Datenbank erstellen.</p>
<p><a href="?db_all_userfailed=true" class="w3-button w3-blue w3-hover-green">Benutzer inventoryfolders alles was type -1 ist anzeigen</a> Benutzer inventoryfolders alles was type -1 ist anzeigen.</p>
<p><a href="?db_userdate=true" class="w3-button w3-blue w3-hover-green">Zeige Erstellungsdatum eines Users an</a> Zeige Erstellungsdatum eines Users an.</p>

<p><a href="?db_false_email=true" class="w3-button w3-blue w3-hover-green">Finde falsche E-Mail Adressen</a> Finde falsche E-Mail Adressen.</p>
<p><a href="?db_delete=true" class="w3-button w3-blue w3-hover-green">Datenbank komplett loeschen</a> Datenbank komplett loeschen.</p>
<p><a href="?db_empty=true" class="w3-button w3-blue w3-hover-green">Datenbank leeren</a> Datenbank leeren.</p>
<p><a href="?db_create_new_dbuser=true" class="w3-button w3-blue w3-hover-green">Neuen Datenbankbenutzer anlegen</a> Neuen Datenbankbenutzer anlegen.</p>

<p><a href="?db_dbuserrechte=true" class="w3-button w3-blue w3-hover-green">Listet alle erstellten Benutzerrechte auf</a> Listet alle erstellten Benutzerrechte auf.</p>
<p><a href="?db_deldbuser=true" class="w3-button w3-blue w3-hover-green">Loescht einen Datenbankbenutzer</a> Loescht einen Datenbankbenutzer.</p>
<p><a href="?allrepair_db=true" class="w3-button w3-blue w3-hover-green">Alle Datenbanken Checken, Reparieren und Optimieren</a> Alle Datenbanken Checken, Reparieren und Optimieren.</p>
<p><a href="?install_mysqltuner=true" class="w3-button w3-blue w3-hover-green">mysqlTuner herunterladen</a> mysqlTuner herunterladen.</p>
<p><a href="?db_email_setincorrectuseroff_dialog=true" class="w3-button w3-blue w3-hover-green">Alle Benutzer mit inkorrekter EMail abschalten</a> Alle Benutzer mit inkorrekter EMail abschalten.</p>
<p><a href="?db_setuserofline_dialog=true" class="w3-button w3-blue w3-hover-green">Benutzeracount abschalten</a> Benutzeracount abschalten.</p>
<p><a href="?db_setuseronline_dialog=true" class="w3-button w3-blue w3-hover-green">Benutzeracount einschalten</a> Benutzeracount einschalten.</p>

</div>

<?php include "./footer.php" ?>
