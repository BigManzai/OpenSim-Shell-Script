# OpenSim-Shell-Script
opensimMULTITOOL, Shell Script Version 0.16.53

opensim.sh Basiert auf meinen Einzelscripten, an denen ich bereits 6 Jahre Arbeite und verbessere.

Da Server unterschiedlich sind, kann eine einwandfreie Funktion nicht gewährleistet werden, also bitte mit bedacht verwenden.

Die Benutzung dieses Scripts, oder deren Bestandteile, erfolgt auf eigene Gefahr!!!

Erstellt und getestet ist opensim.sh, auf verschiedenen Ubuntu 18.04 Servern, unter verschiedenen Server Anbietern (Contabo, Hetzner ...).

## Konfiguration
Es werden zusätzlich 2 Konfigurationsdateien benötigt die für den automatischen Start und stopp benötigt werden.

Diese Dateien müssen am Ende eine Leerzeile haben. Die Startreihenfolge ergibt sich aus der Aufstellung.

Die Pfade sowie Wartezeiten können im Script einfach angepasst werden.

Bitte beachtet der Verzeichnisname des OpenSimulator ist gleichzeitig der Screen Name.

Wird kein Robust oder Money Verzeichnis gefunden, werden diese auch nicht gestartet.

## Test
Dieses Script läuft auf einem Grid mit 40 Simulatoren genauso wie mit an zum Beipiel OsGrid angebundenen Simulatoren.

## Funktionsübersicht
```
Funktion:               Parameter:              Informationen:
hilfe                   - hat keine Parameter - Diese Hilfe.
restart                 - hat keine Parameter - Startet das gesammte Grid neu.
autostop                - hat keine Parameter - Stoppt das gesammte Grid.
autostart               - hat keine Parameter - Startet das gesammte Grid.
works                   - Verzeichnisname - Einzelne screens auf Existens prüfen.
Erweiterte Funktionen
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
Experten Funktionen
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
