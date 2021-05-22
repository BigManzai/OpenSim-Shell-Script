# OpenSim-Shell-Script
![GitHub Logo](https://github.com/BigManzai/OpenSim-Shell-Script/blob/main/opensimMultitool.jpg)
opensimMULTITOOL, Shell Script Version 0.27.56

opensim.sh Basiert auf meinen Einzelscripten, an denen ich bereits 6 Jahre Arbeite und verbessere.

Da Server unterschiedlich sind, kann eine einwandfreie Funktion nicht gewährleistet werden, also bitte mit bedacht verwenden.

Die Benutzung dieses Scripts, oder deren Bestandteile, erfolgt auf eigene Gefahr!!!

Erstellt und getestet ist opensim.sh, auf verschiedenen Ubuntu 18.04 Servern, unter verschiedenen Server Anbietern (Contabo, Hetzner etc.).

Dieses Script läuft auf einem Grid mit 40 Simulatoren genauso, wie mit zum Beispiel OsGrid angebundenen Simulatoren.

Es wird automatisch eine DATUM-multitool.log angelegt um nachzuverfolgen ob alles ordnungsgemäß ausgeführt wurde.

## Konfiguration

Es werden zusätzlich bis zu 3 Konfigurationsdateien benötigt die für den automatischen Start, stopp und Backup benötigt werden. 

In der opensim.cnf werden zum Beispiel Verzeichnispfade voreingestellt zum Beispiel home oder opt als Hauptverzeichnis. 

Bei dem Neuerstellen über "opensim.sh osstruktur" wird nicht nur die Struktur für ein Grid erstellt sondern auch die SimulatorList.ini. 

Diese Dateien müssen am Ende eine Leerzeile haben. Die Startreihenfolge ergibt sich aus der Aufstellung.

Bitte beachtet der Verzeichnisname des OpenSimulator ist gleichzeitig der Screen Name.

Wird kein Robust oder Money Verzeichnis gefunden, werden diese auch nicht gestartet.

## Test
Ich teste gerade das automatische erstellen der Konfigurationsdatei RegionList.ini

## TODO
Backup Zickt.

## Funktionsübersicht
```
#Funktion:               Parameter:              Informationen:
hilfe                   - hat keine Parameter - Diese Hilfe.
restart                 - hat keine Parameter - Startet das gesammte Grid neu.
autostop                - hat keine Parameter - Stoppt das gesammte Grid.
autostart               - hat keine Parameter - Startet das gesammte Grid.
works                   - Verzeichnisname - Einzelne screens auf Existens prüfen.
##Erweiterte Funktionen
rostart                 - hat keine Parameter - Startet Robust Server.
rostop                  - hat keine Parameter - Stoppt Robust Server.
mostart                 - hat keine Parameter - Startet Money Server.
mostop                  - hat keine Parameter - Stoppt Money Server.
osstart                 - Verzeichnisname - Startet einzelnen Simulator.
osstop                  - Verzeichnisname - Stoppt einzelnen Simulator.
terminator              - hat keine Parameter - Killt alle laufenden Screens.
autoscreenstop          - hat keine Parameter - Killt alle OpenSim Screens.
autosimstart            - hat keine Parameter - Startet alle Regionen.
autosimstop             - hat keine Parameter - Beendet alle Regionen.
gridstart               - hat keine Parameter - Startet Robust und Money.
gridstop                - hat keine Parameter - Beendet Robust und Money.
configlesen             - Verzeichnisname - Alle Regionskonfigurationen im Verzeichnis anzeigen.
##Experten Funktionen
assetdel                - screen_name Regionsname Objektname - Einzelnes Asset löschen.
autologdel              - hat keine Parameter - Löscht alle Log Dateien.
automapdel              - hat keine Parameter - Löscht alle Map Karten.
logdel                  - Verzeichnisname - Löscht einzelne Simulator Log Dateien.
mapdel                  - Verzeichnisname - Löscht einzelne Simulator Map-Karten.
settings                - hat keine Parameter - setzt Linux Einstellungen.
osupgrade               - hat keine Parameter - Installiert eine neue OpenSim Version.
regionbackup            - Verzeichnisname Regionsname - Backup einer ausgewählten Region.
autoregionbackup        - hat keine Parameter - Backup aller Regionen.
oscopy                  - Verzeichnisname - Kopiert den Simulator.
osstruktur              - ersteSIM letzteSIM - Legt die Verzeichnisstruktur an.
compilieren             - hat keine Parameter - Kopiert fehlende Dateien und Kompiliert.
scriptcopy              - hat keine Parameter - Kopiert die Scripte in den Source.
moneycopy               - hat keine Parameter - Kopiert das Money in den Source.
osdelete                - hat keine Parameter - Löscht alte OpenSim Version.
oscompi                 - hat keine Parameter - Kompiliert einen neuen OpenSimulator.
oscommand               - screen_name Konsolenbefehl Parameter - OpenSim Konsolenbefehl senden.
```
