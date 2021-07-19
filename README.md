# OpenSim-Shell-Script
![GitHub Logo](https://github.com/BigManzai/OpenSim-Shell-Script/blob/main/opensimMultitool.jpg)

opensimMULTITOOL, Shell Script

opensim.sh Basiert auf meinen Einzelscripten, an denen ich bereits 6 Jahre Arbeite und verbessere.

Da Server unterschiedlich sind, kann eine einwandfreie Funktion nicht gewährleistet werden, also bitte mit bedacht verwenden.

Die Benutzung dieses Scripts, oder deren Bestandteile, erfolgt auf eigene Gefahr!!!

Erstellt und getestet ist opensim.sh, auf verschiedenen Ubuntu 18.04 Servern, unter verschiedenen Server Anbietern (Contabo, Hetzner etc.).

Dieses Script läuft auf einem Grid mit 40 Simulatoren genauso, wie mit zum Beispiel OsGrid angebundenen Simulatoren.

Es wird automatisch eine DATUM-multitool.log angelegt um nachzuverfolgen ob alles ordnungsgemäß ausgeführt wurde.

Eine Funktionsliste gibt es hier in der Wiki.

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

Nachfolgende 2 Zeilen unten im mit "crontab -e" geöffneten Crontab einfügen.

    # Restart um 6 Uhr
    0 6 * * * /opt/opensim.sh restart
    
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

## Funktion:  -   Parameter:  -   Informationen:
```
hilfe                   - hat keine Parameter   - Diese Hilfe.
konsolenhilfe           - hat keine Parameter   - konsolenhilfe ist eine Hilfe für Putty oder Xterm.
restart                 - hat keine Parameter   - Startet das gesamte Grid neu.
autostop                - hat keine Parameter   - Stoppt das gesamte Grid.
autostart               - hat keine Parameter   - Startet das gesamte Grid.
works                   - Verzeichnisname       - Einzelne screens auf Existenz prüfen.
osstart                 - Verzeichnisname       - Startet einen einzelnen Simulator.
osstop                  - Verzeichnisname       - Stoppt einen einzelnen Simulator.
meineregionen           - hat keine Parameter   - listet alle Regionen aus den Konfigurationen auf.
autologdel              - hat keine Parameter   - Löscht alle Log Dateien.
automapdel              - hat keine Parameter   - Löscht alle Map Karten.
```
## Erweiterte Funktionen
```
regionbackup            - Verzeichnisname Regionsname - Backup einer ausgewählten Region.
assetdel                - screen_name Regionsname Objektname - Einzelnes Asset löschen.
oscommand               - Verzeichnisname Region Konsolenbefehl Parameter - Konsolenbefehl senden.
gridstart               - hat keine Parameter - Startet Robust und Money.
gridstop                - hat keine Parameter - Beendet Robust und Money.
rostart                 - hat keine Parameter - Startet Robust Server.
rostop                  - hat keine Parameter - Stoppt Robust Server.
mostart                 - hat keine Parameter - Startet Money Server.
mostop                  - hat keine Parameter - Stoppt Money Server.
autosimstart            - hat keine Parameter - Startet alle Regionen.
autosimstop             - hat keine Parameter - Beendet alle Regionen.
autoscreenstop          - hat keine Parameter - Killt alle OpenSim Screens.
logdel                  - Verzeichnisname     - Löscht alle Simulator Log Dateien im Verzeichnis.
mapdel                  - Verzeichnisname     - Löscht alle Simulator Map-Karten im Verzeichnis.
settings                - hat keine Parameter - setzt Linux Einstellungen.
configlesen             - Verzeichnisname     - Alle Regionskonfigurationen im Verzeichnis anzeigen.
```
## Experten Funktionen
```
osupgrade               - hat keine Parameter - Installiert eine neue OpenSim Version.
autoregionbackup        - hat keine Parameter - Backup aller Regionen.
oscopy                  - Verzeichnisname     - Kopiert den Simulator.
osstruktur              - ersteSIM letzteSIM  - Legt eine Verzeichnisstruktur an.
osprebuild              - Versionsnummer      - Aendert die Versionseinstellungen 0.9.2.XXXX
compilieren             - hat keine Parameter - Kopiert fehlende Dateien und Kompiliert.
oscompi                 - hat keine Parameter - Kompiliert einen neuen OpenSimulator ohne kopieren.
scriptcopy              - hat keine Parameter - Kopiert die Scripte in den Source.
moneycopy               - hat keine Parameter - Kopiert Money Source in den OpenSimulator Source.
osdelete                - hat keine Parameter - Löscht alte OpenSim Version.
regionsiniteilen        - Verzeichnisname Region - kopiert aus der Regions.ini eine Region heraus.
autoregionsiniteilen    - hat keine Parameter - aus allen Regions.ini alle Regionen vereinzeln.
RegionListe             - hat keine Parameter - Die RegionList.ini erstellen.
Regionsdateiliste       - -b Bildschirm oder -d Datei Verzeichnisname - Regionsdateiliste erstellen.
osgitholen              - hat keine Parameter - kopiert eine OpenSimulator Git Entwicklerversion.
terminator              - hat keine Parameter - Killt alle laufenden Screens.
```
## Ungetestete oder neue Funktionen die noch nicht ausreichend getestet sind
```
makeaot                 - hat keine Parameter - aot Dateien erstellen.
cleanaot                - hat keine Parameter - aot Dateien entfernen.
monoinstall             - hat keine Parameter - mono 6.x installation.
installationen          - hat keine Parameter - installationen aufisten.
serverinstall           - hat keine Parameter - alle benötigten Linux Pakete installieren.
osbuilding              - Versionsnummer      - Upgrade des OpenSimulator aus einer Source ZIP Datei.
createuser 		- Vorname, Nachname, Passwort, E-Mail - Grid Benutzer anlegen.

db_anzeigen	-  DBBENUTZER   DBDATENBANKNAME  - Alle Datenbanken anzeigen.
create_db	-  DBBENUTZER   DBDATENBANKNAME   DATENBANKNAME  - Datenbank anlegen.
delete_db	-  DBBENUTZER   DBPASSWORT   DATENBANKNAME  - Datenbank löschen.
leere_db	-  DBBENUTZER   DBPASSWORT   DATENBANKNAME  - Datenbank leeren.
allrepair_db	-  DBBENUTZER   DBPASSWORT  - Alle Datenbanken Reparieren und Optimieren.
db_sichern	-  DBBENUTZER   DBPASSWORT   DATENBANKNAME  - Datenbank sichern.
mysql_neustart	- hat keine Parameter - MySQL neu starten.
opensimholen	- hat keine Parameter - Lädt eine Reguläre OpenSimulator Version herunter.

```

```
  Der Verzeichnisname ist gleichzeitig auch der Screen Name!
```

## TODO

Neue Funktionen ausgiebig testen.

```
opensimMULTITOOL Version 0.41.137
Diverse neue mySQL Funktionen.
```

```
opensimMULTITOOL Version 0.43.145
Opensimholen holt aus dem Distributionsverzeichnis der opensimulator.org, 
die in der Konfigurationsdatei voreingestellte Version des OpenSimulator auf den Server, 
entpackt sie und benennt sie um in opensim.
```
