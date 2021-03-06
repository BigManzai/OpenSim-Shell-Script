# OpenSim-Shell-Script
![GitHub Logo](https://github.com/BigManzai/OpenSim-Shell-Script/blob/main/opensimMultitool.jpg)

opensim.sh Basiert auf meinen Einzelscripten, an denen ich bereits 6 Jahre Arbeite und verbessere.

Da Server unterschiedlich sind, kann eine einwandfreie Funktion nicht gewährleistet werden, also bitte mit bedacht verwenden.

Die Benutzung dieses Scripts, oder deren Bestandteile, erfolgt auf eigene Gefahr!!!

Erstellt und getestet ist opensim.sh, auf verschiedenen Ubuntu 18.04 (jetzt auch 22.04) Servern, unter verschiedenen Server Anbietern (Contabo, Hetzner etc.).

Dieses Script läuft auf einem Grid mit 40 Simulatoren genauso, wie mit zum Beispiel OsGrid angebundenen Simulatoren.

Es wird automatisch eine DATUM-multitool.log angelegt um nachzuverfolgen ob alles ordnungsgemäß ausgeführt wurde.

Eine Funktionsliste gibt es hier in der Wiki. 

### Download OpenSimulator Testversion für Ubuntu 18.04

(Bitte die beiliegende opensim.sh und opensim.cfg verwenden):

https://eu2.contabostorage.com/52253033fae547669ac2197e11daac60:bigmanzai/opensim-0.9.2.2.197.zip

### Download der NEUEN OpenSimulator Testversion für Ubuntu 22.04 

(Bitte die neue beiliegende opensim.sh und opensim.cfg verwenden):

https://www.mediafire.com/file/vhxpwexht08quiz/opensim-0.9.2.2.233.zip/file

## Hilfe 

    /opt/opensim.sh hilfe
 
dazu gibt es noch die Konsolenhilfe für Putty oder Bitvise-Xterm

    /opt/opensim.sh konsolenhilfe
    
und die OpenSim Commands Hilfe in Deutsch

    /opt/opensim.sh commandhelp

## Konfiguration

In der opensim.cnf werden unter anderem Verzeichnispfade voreingestellt zum Beispiel home oder opt als Hauptverzeichnis. 

Bei dem Neuerstellen über "opensim.sh osstruktur" wird nicht nur die Struktur für ein Grid erstellt sondern auch die SimulatorList.ini. 

Diese Dateien müssen am Ende eine Leerzeile haben. Die Startreihenfolge ergibt sich aus der Aufstellung.

Bitte beachtet der Verzeichnisname des OpenSimulator ist gleichzeitig der Screen Name.

Wird kein Robust oder Money Verzeichnis gefunden, werden diese auch nicht gestartet.

Das Skript ausführbar machen mit "chmod +x opensim.sh" danach kann es mit "./opensim.sh" oder "/verzeichnis/opensim.sh" ausgeführt werden.

## Informationen
Die Struktur baut sich folgendermaßen auf:

    robust (Robust Server und eventuell Money Server)
    sim1 (Welcome Region)
    sim2 (Weitere Regionen)
    sim3 (Weitere Regionen)
    ... (Alle weiteren Regionen)
    
Es sollten nicht mehr als 15 Regionen pro Sim betrieben werden, Ausnahme ist die Welcome Region, diese sollte einzeln laufen und möglichst klein gehalten werden.

**Systemvoraussetzungen** für den Betrieb des OpenSimulator: 

2 Core Prozessor, 2 GB RAM (1GB OpenSim + 1GB Datenbank) pro Sim zuzüglich eventuell robust und Money welches aber von der Anzahl der Regionen und Avatar Accounts abhängig ist.

Pro Avatar Account sollte man 20-50GB an Robust Datenbankvolumen einkalkulieren.

## Automatisch starten
Cron so geht es bei mir:

Crontab anzeigen:

    crontab -l
    
Crontab bearbeiten oder erstellen:

    crontab -e

Nachfolgende Zeilen unten im mit "crontab -e" geöffneten Crontab einfügen.

    # Restart um 6 Uhr
    0 6 * * * /opt/opensim.sh restart
    
oder

    # Stoppen um 22 Uhr
    0 22 * * * /opt/opensim.sh autostop

    # Starten um 9 Uhr
    0 9 * * * /opt/opensim.sh autostart
    
(Format: Minute=0, Stunde=6)

**Crontab speichern:**

STRG o

Dateinamen mit Return bestätigen

STRG x zum beenden

Crontab zum prüfen noch einmal anzeigen:

     crontab -l

## Ahead of Time compilation (AOT)
Muss man das haben?

Weis nicht ich hab das mal getestet aber bemerke da keine Geschwindigkeitszuwächse.

Aber wahrscheinlich ist da mein Grid zu klein für.

## Menü mit dialog
Ich habe eine Menüfunktion integriert diese schaut zuerst ob dialog installiert ist oder nicht.

Wenn ihr dialog installiert habt dann öffnet sich nach der Eingabe von ./opensim.sh ein Menü.

In diesem Menü kann man einige Funktionen bequem aufrufen.

Bisher sind nur Funktionen im Menü die maximal 1 Übergabewert voraussetzen.

     Nachinstallieren von dialog mit:
     apt install dialog
     oder
     sudo apt-get install dialog

## Status 27.07.2022 281 Funktionen.

.

## TODO und Informationen

V0.79.560

opensim.sh newregionini - Erstellt eine Regionskonfiguration entweder in das Hauptverzeichnis oder direkt in das Regions Verzeichnis.

V0.79.559

Radio Listen Tagesaktuell für Radio & DJ Board by Rebekka Revnik. 

./opensim.sh radiolist

Setup in opensim.cnf

V0.79.544

 mySQL Dump Backup Datei in Tabellen splitten.

sql Backup in einzelne Tabelle aus mySQL Dump extahieren.

sql Datenbank Tabellenweise sichern.

Einzelne Tabellen zu einer neuen OpenSim Datenbank zusammensetzen.

```
db_tablesplitt - Alle Tabellen aus einer SQL Datensicherung in ein gleichnamigen Verzeichnis extrahieren.
db_tablextract - Eine einzelne Tabelle aus einem SQL Datenbank Backup extrahieren.
db_backuptabellen - Backup, eine Datenbanken Tabellenweise speichern.
db_restorebackuptabellen - Backup Test, eine Datenbanken Tabellenweise wiederherstellen.
```

etc...


mariaDB Testfunktionen:

```
connection_name
MASTER_USER
MASTER_PASSWORD
MASTER_HOST
MASTER_PORT
MASTER_CONNECT_RETRY
MASTER_SSL
MASTER_SSL_CA
MASTER_SSL_CAPATH
MASTER_SSL_CERT
MASTER_SSL_CRL
MASTER_SSL_CRLPATH
MASTER_SSL_KEY
MASTER_SSL_CIPHER
MASTER_SSL_VERIFY_SERVER_CERT
MASTER_LOG_FILE
MASTER_LOG_POS
RELAY_LOG_FILE
RELAY_LOG_POS
MASTER_USE_GTID
MASTER_USE_GTID2
IGNORE_SERVER_IDS
DO_DOMAIN_IDS
DO_DOMAIN_IDS2
IGNORE_DOMAIN_IDS
MASTER_DELAY
Replica_Backup
Replica_Backup2
ReplikatKoordinaten
```

Neue Funktionen 29.06.2022

Ubuntu 22.04 Installer eingefügt so wie mariaDB 10.

```
function db_backuptabellen DB_Benutzername DB_Passwort Datenbankname
Datenbank Tabellenweise sichern im Verzeichnis Datenbankname
```

```
function db_restorebackuptabellen DB_Benutzername DB_Passwort AlterDatenbankname NeuerDatenbankname
Die Tabellenweise gesicherte Datenbank in einer neuen Datenbank zusammensetzen.
```

```
Wozu?
Hierdurch sind bei einem defekt nicht alle Datenbank Bereiche zerstört 
und es können auch Teile einer Datenbank, einfacher repariert werden.
```

V0.79.477

Leerzeichen Fehler in der SimulatorList.ini erstellung behoben.

Ubuntu 22 Installationen werden hinzugefügt.

```
Neue Menüstruktur es sind jetzt alle Menüs aus allen Menüs einfach mit der Maus erreichbar.
Die Menüstruktur ist komplett ausgetauscht worden.
Auch einige Strukturen wie das Installieren der Linux Pakete sind komplett ausgetauscht worden.
Auch ohne dialog kann das Grid zeitgesteuert, herauf und herunter gefahren, 
sowie neu gestartet werden. 
Es kann nun die Laufzeit des Servers angezeigt werden, 
sowie den Server mit einem Mausklick neu gestartet werden 
(Das Grid fährt hierbei vorher automatisch herunter). 
Das Dateimenü wurde eingefügt um die Menüs kleiner zu gestalten.
Unter Server Informationen ist auf einem blick alle wichtigen Infos zu sehen wie welche screens gerade laufen und mehr.
```
Version 0.78.421

Menü mySQL hat jetzt 11 neue Funktionen.

Version 0.77.392
```
db_create "$2" "$3" "$4"
db_dbuserrechte "$2" "$3" "$4"
db_deldbuser "$2" "$3" "$4"
db_create_new_dbuser "$2" "$3" "$4" "$5"
db_anzeigen "$2" "$3" "$4"
db_dbuser "$2" "$3"
db_delete "$2" "$3" "$4"
db_empty "$2" "$3" "$4"
db_tables "$2" "$3" "$4"
db_regions "$2" "$3" "$4"
db_regionsuri "$2" "$3" "$4"
db_regionsport "$2" "$3" "$4"
```

Version 0.77.388
```
opensim.sh db_anzeigen2 mysqlbenutzer mysqlpaswd griddatabase
opensim.sh db_all_user mysqlbenutzer mysqlpaswd griddatabase
opensim.sh db_all_uuid mysqlbenutzer mysqlpaswd griddatabase
opensim.sh db_all_name mysqlbenutzer mysqlpaswd griddatabase
opensim.sh db_user_data mysqlbenutzer mysqlpaswd griddatabase John Doe
opensim.sh db_user_infos mysqlbenutzer mysqlpaswd griddatabase John Doe
opensim.sh db_user_uuid mysqlbenutzer mysqlpaswd griddatabase John Doe
opensim.sh db_foldertyp_user mysqlbenutzer mysqlpaswd griddatabase John Doe 1
opensim.sh db_all_userfailed mysqlbenutzer mysqlpaswd griddatabase John Doe
opensim.sh db_userdate mysqlbenutzer mysqlpaswd griddatabase John Doe
opensim.sh db_false_email mysqlbenutzer mysqlpaswd griddatabase
opensim.sh set_empty_user mysqlbenutzer mysqlpaswd griddatabase Mustafas Schokolade "schokoladenprinz@prinz.de"
```

Version 0.77.386 - Neues Log System, es kann nun in der opensim.cnf die Log Funktionen aktiviert und deaktiviert werden.
Das Schreiben und löschen der Log´s kann nun ein- und ausgeschaltet werden. MySQL wird als nächstes eingefügt.

Version 0.61.225 - siehe multitool.png

Version 0.56.219 - Neu Passwortgenerator

Version 0.55.216 - Neu unlockexample benennt alle *.example Dateien um.

Version 0.54.213 - MoneyServer vom git kopieren - OSSL Skripte vom git kopieren, 
    sind die ZIP Dateien vorhanen werden sie automatisch eingebaut und mit kompiliert.

Neue Menü Funktionen, um diese nutzen zu können muss dialog nachinstalliert werden.

Ich habe jetzt Restart nach oben gesetzt und Informationen hinzugefügt.

Vom Kalender und den Informationen gelangt man wieder in das Hauptmenü.

Das Hilfemenü hat jetzt einen eigenen Button.
```
sudo apt-get install dialog
```

Neue Funktionen ausgiebig testen.

Leerzeichen aus SimulatorList.ini entfernt.

Test - Konfigurationsdateien automatisiert zu erstellen:
```
gridcommonini
robustini
opensimini
moneyserverini
regionini
osslenableini
```
