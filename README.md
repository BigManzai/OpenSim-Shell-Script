# OpenSim-Shell-Script
![GitHub Logo](https://github.com/BigManzai/OpenSim-Shell-Script/blob/main/opensimMultitool.jpg)
opensimMULTITOOL, Shell Script,  Version 0.30.68

opensim.sh Basiert auf meinen Einzelscripten, an denen ich bereits 6 Jahre Arbeite und verbessere.

Da Server unterschiedlich sind, kann eine einwandfreie Funktion nicht gewährleistet werden, also bitte mit bedacht verwenden.

Die Benutzung dieses Scripts, oder deren Bestandteile, erfolgt auf eigene Gefahr!!!

Erstellt und getestet ist opensim.sh, auf verschiedenen Ubuntu 18.04 Servern, unter verschiedenen Server Anbietern (Contabo, Hetzner etc.).

Dieses Script läuft auf einem Grid mit 40 Simulatoren genauso, wie mit zum Beispiel OsGrid angebundenen Simulatoren.

Es wird automatisch eine DATUM-multitool.log angelegt um nachzuverfolgen ob alles ordnungsgemäß ausgeführt wurde.

## Konfiguration

In der opensim.cnf werden unter anderem Verzeichnispfade voreingestellt zum Beispiel home oder opt als Hauptverzeichnis. 

Bei dem Neuerstellen über "opensim.sh osstruktur" wird nicht nur die Struktur für ein Grid erstellt sondern auch die SimulatorList.ini. 

Diese Dateien müssen am Ende eine Leerzeile haben. Die Startreihenfolge ergibt sich aus der Aufstellung.

Bitte beachtet der Verzeichnisname des OpenSimulator ist gleichzeitig der Screen Name.

Wird kein Robust oder Money Verzeichnis gefunden, werden diese auch nicht gestartet.

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

## Test
Ich teste gerade das automatische erstellen der Konfigurationsdatei RegionList.ini

## TODO
Backup Zickt.

RegionListe erstellen kann keine Regions.ini mit mehr als einer Region verarbeiten.

## Funktionsübersicht
```
#Funktion:               Parameter:              Informationen:
hilfe                   - hat keine Parameter - Diese Hilfe.
restart                 - hat keine Parameter - Startet das gesammte Grid neu.
autostop                - hat keine Parameter - Stoppt das gesammte Grid.
autostart               - hat keine Parameter - Startet das gesammte Grid.
works                   - Verzeichnisname - Einzelne screens auf Existens prüfen.
meineregionen           - hat keine Parameter - listet alle Regionen aus den Konfigurationen auf.
#Erweiterte Funktionen
rostart                 - hat keine Parameter - Startet Robust Server.
rostop                  - hat keine Parameter - Stoppt Robust Server.
mostart                 - hat keine Parameter - Startet Money Server.
mostop                  - hat keine Parameter - Stoppt Money Server.
osstart                 - Verzeichnisname - Startet einen einzelnen Simulator.
osstop                  - Verzeichnisname - Stoppt einen einzelnen Simulator.
terminator              - hat keine Parameter - Killt alle laufenden Screens.
autoscreenstop          - hat keine Parameter - Killt alle OpenSim Screens.
autosimstart            - hat keine Parameter - Startet alle Regionen.
autosimstop             - hat keine Parameter - Beendet alle Regionen.
gridstart               - hat keine Parameter - Startet Robust und Money.
gridstop                - hat keine Parameter - Beendet Robust und Money.
configlesen             - Verzeichnisname - Alle Regionskonfigurationen im Verzeichnis anzeigen.
RegionListe             - hat keine Parameter - Die RegionList.ini erstellen.
Regionsdateiliste       - -b Bildschirm oder -d Datei Verzeichnisname - Regionsdateiliste erstellen.
#Experten Funktionen
assetdel                - screen_name Regionsname Objektname - Einzelnes Asset löschen.
autologdel              - hat keine Parameter - Löscht alle Log Dateien.
automapdel              - hat keine Parameter - Löscht alle Map Karten.
logdel                  - Verzeichnisname - Löscht alle Simulator Log Dateien im Verzeichnis.
mapdel                  - Verzeichnisname - Löscht alle Simulator Map-Karten im Verzeichnis.
settings                - hat keine Parameter - setzt Linux Einstellungen.
osupgrade               - hat keine Parameter - Installiert eine neue OpenSim Version.
regionbackup            - Verzeichnisname Regionsname - Backup einer ausgewählten Region.
autoregionbackup        - hat keine Parameter - Backup aller Regionen.
oscopy                  - Verzeichnisname - Kopiert den Simulator.
osstruktur              - ersteSIM letzteSIM - Legt eine Verzeichnisstruktur an.
compilieren             - hat keine Parameter - Kopiert fehlende Dateien und Kompiliert.
scriptcopy              - hat keine Parameter - Kopiert die Scripte in den Source.
moneycopy               - hat keine Parameter - Kopiert Money Source in den OpenSimulator Source.
osdelete                - hat keine Parameter - Löscht alte OpenSim Version.
oscompi                 - hat keine Parameter - Kompiliert einen neuen OpenSimulator.
regionsiniteilen        - Verzeichnisname Region - kopiert aus der Regions.ini eine Region heraus.
autoregionsiniteilen    - hat keine Parameter - aus allen Regions.ini alle Regionen vereinzeln.
oscommand               - Verzeichnisname Region Konsolenbefehl Parameter - Konsolenbefehl senden.
```
