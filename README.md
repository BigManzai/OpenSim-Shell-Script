# OpenSim-Shell-Script
![GitHub Logo](https://github.com/BigManzai/OpenSim-Shell-Script/blob/main/opensimMultitool.jpg)
opensimMULTITOOL, Shell Script, Version 0.34.92

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

## Funktionsübersicht
```
#Funktion:               Parameter:              Informationen:
hilfe                   - hat keine Parameter   - Diese Hilfe.
restart                 - hat keine Parameter   - Startet das gesammte Grid neu.
autostop                - hat keine Parameter   - Stoppt das gesammte Grid.
autostart               - hat keine Parameter   - Startet das gesammte Grid.
works                   - Verzeichnisname       - Einzelne screens auf Existens prüfen.
osstart                 - Verzeichnisname       - Startet einen einzelnen Simulator.
osstop                  - Verzeichnisname       - Stoppt einen einzelnen Simulator.
meineregionen           - hat keine Parameter - listet alle Regionen aus den Konfigurationen auf.
autologdel              - hat keine Parameter   - Löscht alle Log Dateien.
automapdel              - hat keine Parameter   - Löscht alle Map Karten.
```

```
#Erweiterte Funktionen
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
logdel                  - Verzeichnisname - Löscht alle Simulator Log Dateien im Verzeichnis.
mapdel                  - Verzeichnisname - Löscht alle Simulator Map-Karten im Verzeichnis.
settings                - hat keine Parameter - setzt Linux Einstellungen.
configlesen             - Verzeichnisname - Alle Regionskonfigurationen im Verzeichnis anzeigen.
```

```
#Experten Funktionen
osupgrade               - hat keine Parameter - Installiert eine neue OpenSim Version.
autoregionbackup        - hat keine Parameter - Backup aller Regionen.
oscopy                  - Verzeichnisname - Kopiert den Simulator.
osstruktur              - ersteSIM letzteSIM - Legt eine Verzeichnisstruktur an.
osprebuild              - Versionsnummer - Aendert die Versionseinstellungen 0.9.2.XXXX
compilieren             - hat keine Parameter - Kopiert fehlende Dateien und Kompiliert.
oscompi                 - hat keine Parameter - Kompiliert einen neuen OpenSimulator ohne kopieren.
scriptcopy              - hat keine Parameter - Kopiert die Scripte in den Source.
moneycopy               - hat keine Parameter - Kopiert Money Source in den OpenSimulator Source.
osdelete                - hat keine Parameter - Löscht alte OpenSim Version.
regionsiniteilen        - Verzeichnisname Region - kopiert aus der Regions.ini eine Region heraus.
autoregionsiniteilen    - hat keine Parameter - aus allen Regions.ini alle Regionen vereinzeln.
RegionListe             - hat keine Parameter - Die RegionList.ini erstellen.
Regionsdateiliste       - -b Bildschirm oder -d Datei Verzeichnisname - Regionsdateiliste erstellen.
osgitholen              - hat keine Parameter - kopiert eine OpenSimulator Entwicklerversion.
terminator              - hat keine Parameter - Killt alle laufenden Screens.
```

```
#Ungetestete Funktionen
rostartaot		    - hat keine Parameter   - Startet Robust aot Server.
mostartaot		    - hat keine Parameter   - Startet Money aot Server.
gridstartaot		- hat keine Parameter   - Startet Robust und Money aot.
utostartaot		    - hat keine Parameter	- Startet das gesamte Grid aot.
autosimstartaot		- hat keine Parameter   - Startet alle Regionen aot.
compilierenaot		- hat keine Parameter   - Kopiert fehlende Dateien und Kompiliert aot.
oscompiaot	        - hat keine Parameter   - Kompiliert einen neuen OpenSimulator ohne kopieren mit aot.
makeaot	            - hat keine Parameter   - makeaot aot.
monoinstall		    - hat keine Parameter - mono install."
installationen		- hat keine Parameter - installationen aufisten."
serverinstall		- hat keine Parameter - serverinstall alle Pakete installieren."
```

Eine Funktionsliste aller Funktionen gibt es hier in der Wiki.

## TODO
Translation Deutsch, Englisch, Französisch, Spanisch einfügen.

Neue Funktionen ausgiebig testen.

```
Test Ubuntu Server 18.04
Installieren alle Pakete die für OpenSim benötigt werden, 
dazu mono 6.x vom mono-project, 
alle Webabhängigkeiten für eine Homepage 
und alles um den OpenSimulator zu kompilieren.
```
./opensim.sh serverinstall
