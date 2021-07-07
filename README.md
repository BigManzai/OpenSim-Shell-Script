# OpenSim-Shell-Script
![GitHub Logo](https://github.com/BigManzai/OpenSim-Shell-Script/blob/main/opensimMultitool.jpg)
opensimMULTITOOL, Shell Script, Version 0.41.137

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
allrepair_db	-  DBBENUTZER   DBPASSWORT   DATENBANKNAME  - Datenbanken Reparieren und Optimieren.
db_sichern	-  DBBENUTZER   DBPASSWORT   DATENBANKNAME  - Datenbank sichern.
mysql_neustart	- hat keine Parameter - MySQL neu starten.

```

```
  Der Verzeichnisname ist gleichzeitig auch der Screen Name!
```

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

```
Neu in 0.35.94
simstats screen_name funktioniert beim RobustServer, MoneyServer und allen Regionsserver.
Beispiel-Example: opensim.sh simstats sim1
erzeugt im Hauptverzeichnis eine Datei namens sim1.log in dieser Datei ist die Statistik für sim1 zu finden.
Diese Datei wird jetzt auch direkt angezeigt und die alte Datei wird gleichzeitig gelöscht.
```

```
In 0.35.97 Programmablaufbeschleunigung um etwa 30%.
Einige Fehler behoben
Einige doppelter Bildschirmausgaben entfernt.
```

```
In 0.35.98 vergessene Einstellungen aktiviert.
Mono Threads können jetzt in der Konfigurationsdatei eingestellt werden.
```

```
Version 0.35.103 aot geht jetzt über die Konfigurationsdatei.
Habe angefangen aufzuräumen und unnütze Sachen raus zu werfen.
```

```
Version 0.36.108 aot geht jetzt nur noch über die Konfigurationsdatei automatisch.
Habe aufgeräumt und unnütze Sachen raus geworfen.
Log Datei Einträge verringert.
```

```
Version 0.36.109
SC2027: The surrounding quotes actually unquote this. Remove or escape them.
SC2086: Double quote to prevent globbing and word splitting.
behoben
```

```
Neu in der Version 0.37.113
Vollautomatisches Upgrade aus einer OpenSimulator Dev Master Zip Datei.
Ihr kopiert den OpenSimulator von hier: "http://opensimulator.org/viewgit/?a=shortlog&p=opensim" 
in euer /opt Verzeichnis.

Der Name ist folgendermaßen aufgebaut opensim-0.9.2.0Dev-1187-gcf0b1b1.zip
opensim-0.9.2.0Dev wird in der Konfigurationsdatei angegeben und ändert sich nur ab und zu mal.
1187 ist die Versionsnummer die ihr angeben müsst und der Rest dahinter ist uns egal.
Bei opensim-0.9.2.0Dev-1183-g2c9f299.zip müssten wir also 1183 angeben.
Bei opensim-0.9.2.0Dev-1184-g2b6a869.zip müssten wir also 1184 angeben.

Gestartet wird das ganze so:
/opt/opensim.sh osbuilding 1187

Anschließend wird der alte OpenSimulator gesichert in opensim1, 
der neue OpenSimulator entpackt, 
umbenannt in opensim, 
die Versionsnummer eingestellt, 
Prebuild erstellt und Kompiliert.
Danach wenn alles ordnungsgemäß ausgeführt wurde, 
wird das Upgrade des Grids und/oder Simulatoren ausgeführt.

Meine Log Datei:

#######################################################
05.07.2021 15:40:47 OSBUILDING: Alten OpenSimulator sichern
05.07.2021 15:40:47 OSDELETE: Lösche altes opensim1 Verzeichnis
05.07.2021 15:40:48 OSDELETE: Umbenennen von opensim nach opensim1 zur sicherung
05.07.2021 15:40:48 OSBUILDING: Neuen OpenSimulator entpacken
05.07.2021 15:40:51 OSBUILDING: Neuen OpenSimulator umbenennen
05.07.2021 15:40:51 OSBUILDING: Prebuild des neuen OpenSimulator starten
05.07.2021 15:40:51 PREBUILD: Version umbenennen und Release einstellen
05.07.2021 15:40:51 OSBUILDING: Compilieren des neuen OpenSimulator
05.07.2021 15:40:51 COMPILIEREN: Bauen eines neuen OpenSimulators wird gestartet
05.07.2021 15:40:51 SCRIPTCOPY: Script Assets werden kopiert
05.07.2021 15:40:51 MONEYCOPY: Money Kopiervorgang gestartet
05.07.2021 15:40:51 PYTHONCOPY: Python wird nicht kopiert.
05.07.2021 15:40:51 OpenSimSearch: OpenSimSearch wird nicht kopiert.
05.07.2021 15:40:51 OpenSimMutelist: OpenSimMutelist wird nicht kopiert.
05.07.2021 15:40:51 CHRISOSCOPY: Chris.OS.Additions werden nicht kopiert.
05.07.2021 15:40:51 OSCOMPI: Kompilierungsvorgang startet
05.07.2021 15:40:51 OSCOMPI: Prebuildvorgang startet
05.07.2021 15:42:00 OSCOMPI: Kompilierung wurde durchgeführt
05.07.2021 15:42:00 OSBUILDING: Neuen OpenSimulator upgraden
05.07.2021 15:42:00 OSUPGRADE: Das Grid wird jetzt upgegradet
05.07.2021 15:42:00 OSUPGRADE: Alles Beenden
05.07.2021 15:42:02 AUTOSIMSTOP: Regionen OpenSimulator sim1 Beenden
05.07.2021 15:42:32 AUTOSIMSTOP: Regionen OpenSimulator sim2 Beenden
05.07.2021 15:43:02 AUTOSIMSTOP: Regionen OpenSimulator sim3 Beenden
05.07.2021 15:43:32 AUTOSIMSTOP: Regionen OpenSimulator sim4 Beenden
05.07.2021 15:44:02 AUTOSIMSTOP: Regionen OpenSimulator sim5 Beenden
05.07.2021 15:44:32 AUTOSIMSTOP: Regionen OpenSimulator sim6 Beenden
05.07.2021 15:45:02 AUTOSIMSTOP: Regionen OpenSimulator sim7 Beenden
05.07.2021 15:45:32 MOSTOP: Money Server Beenden
05.07.2021 15:46:22 ROSTOP: RobustServer Beenden
05.07.2021 15:46:54 WORKS: SIMs OFFLINE!
05.07.2021 15:46:54 WORKS: MONEY OFFLINE!
05.07.2021 15:46:54 WORKS: ROBUST OFFLINE!
05.07.2021 15:46:54 OSUPGRADE: Neue Version Installieren
05.07.2021 15:46:58 OSCOPY: Robust kopieren
05.07.2021 15:47:22 OSCOPY: OpenSim kopieren
05.07.2021 15:47:22 OSUPGRADE: Log Dateien loeschen!
05.07.2021 15:47:24 AUTOLOGDEL: OpenSimulator log sim1 geloescht
05.07.2021 15:47:26 AUTOLOGDEL: OpenSimulator log sim2 geloescht
05.07.2021 15:47:28 AUTOLOGDEL: OpenSimulator log sim3 geloescht
05.07.2021 15:47:30 AUTOLOGDEL: OpenSimulator log sim4 geloescht
05.07.2021 15:47:32 AUTOLOGDEL: OpenSimulator log sim5 geloescht
05.07.2021 15:47:34 AUTOLOGDEL: OpenSimulator log sim6 geloescht
05.07.2021 15:47:36 AUTOLOGDEL: OpenSimulator log sim7 geloescht
05.07.2021 15:47:38 OSUPGRADE: Das Grid wird jetzt gestartet
05.07.2021 15:47:38 OSSETTINGS: Setze die Einstellung: ulimit -s 1048576
05.07.2021 15:47:38 OSSETTINGS: Setze die Mono Threads auf 800
05.07.2021 15:47:38 OSSETTINGS: Setze die Einstellung: minor=split,promotion-age=14,nursery-size=64m
05.07.2021 15:47:39 ROSTART: RobustServer Start
05.07.2021 15:48:09 MOSTART: Money Server Start
05.07.2021 15:49:01 AUTOSIMSTART: Regionen OpenSimulator sim1 Starten
05.07.2021 15:49:11 AUTOSIMSTART: Regionen OpenSimulator sim2 Starten
05.07.2021 15:49:21 AUTOSIMSTART: Regionen OpenSimulator sim3 Starten
05.07.2021 15:49:31 AUTOSIMSTART: Regionen OpenSimulator sim4 Starten
05.07.2021 15:49:41 AUTOSIMSTART: Regionen OpenSimulator sim5 Starten
05.07.2021 15:49:51 AUTOSIMSTART: Regionen OpenSimulator sim6 Starten
05.07.2021 15:50:01 AUTOSIMSTART: Regionen OpenSimulator sim7 Starten
05.07.2021 15:50:11 SCREENLIST: Alle laufende Screens
There are screens on:
	10285.sim7	(07/05/2021 03:50:01 PM)	(Detached)
	10236.sim6	(07/05/2021 03:49:51 PM)	(Detached)
	10194.sim5	(07/05/2021 03:49:41 PM)	(Detached)
	10140.sim4	(07/05/2021 03:49:31 PM)	(Detached)
	10099.sim3	(07/05/2021 03:49:21 PM)	(Detached)
	10059.sim2	(07/05/2021 03:49:11 PM)	(Detached)
	10020.sim1	(07/05/2021 03:49:01 PM)	(Detached)
	9980.MO	(07/05/2021 03:48:09 PM)	(Detached)
	9951.RO	(07/05/2021 03:47:39 PM)	(Detached)
9 Sockets in /run/screen/S-root.
05.07.2021 15:50:11 AUTOSTART: Auto Start abgeschlossen
05.07.2021 15:50:11 opensimMULTITOOL wurde beendet.
#######################################################
```
