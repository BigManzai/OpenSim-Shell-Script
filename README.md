# OpenSim-Shell-Script
![GitHub Logo](https://github.com/BigManzai/OpenSim-Shell-Script/blob/main/opensimMultitool.jpg)

opensim.sh Basiert auf meinen Einzelscripten, an denen ich bereits 6 Jahre Arbeite und verbessere.

Da Server unterschiedlich sind, kann eine einwandfreie Funktion nicht gewährleistet werden, also bitte mit bedacht verwenden.

Die Benutzung dieses Scripts, oder deren Bestandteile, erfolgt auf eigene Gefahr!!!

Erstellt und getestet ist opensim.sh, auf verschiedenen Ubuntu 18.04 Servern, unter verschiedenen Server Anbietern (Contabo, Hetzner etc.).

Dieses Script läuft auf einem Grid mit 40 Simulatoren genauso, wie mit zum Beispiel OsGrid angebundenen Simulatoren.

Es wird automatisch eine DATUM-multitool.log angelegt um nachzuverfolgen ob alles ordnungsgemäß ausgeführt wurde.

Eine Funktionsliste gibt es hier in der Wiki.

### Download OpenSimulator Testversion (Bitte die beiliegende opensim.sh und opensim.cfg verwenden):

https://www.mediafire.com/file/wrjd2n9024icc49/opensim-0.9.2.2.4.zip/file

## Hilfe

    /opt/opensim.sh
    
oder

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
mysqleinstellen	- hat keine Parameter - mySQL Konfiguration auf Server Einstellen und neu starten.
conf_write	- SUCHWORT ERSATZWORT PFAD DATEINAME - Konfigurationszeile schreiben.
conf_delete	- SUCHWORT PFAD DATEINAME - Konfigurationszeile löschen.
conf_read	- SUCHWORT PFAD DATEINAME - Konfigurationszeile lesen.

unlockexample - hat keine Parameter - Benennt alle example Dateien um.
passwdgenerator - Passwortstärke - Generiert ein Passwort zur weiteren verwendung.
```

```
  Der Verzeichnisname ist gleichzeitig auch der Screen Name!
```

## TODO und Informationen

```
Neue Menüstruktur es sind jetzt alle Menüs aus allen Menüs einfach mit der Maus erreichbar.
Die Menüstruktur ist komplett ausgetauscht worden.
Auch einige Strukturen wie das Installieren der Linux Pakete sind komplett ausgetauscht worden.
Auch ohne dialog kann das Grid zeitgesteuert, herauf und herunter gefahren, 
sowie neu gestartet werden. 
Es kann nun die Laufzeit des Servers angezeigt werden, 
sowie den Server mit einem klick Mausklick neu gestartet werden 
(Das Grid fährt hierbei vorher automatisch herunter). 
Das Dateimenü wurde eingefügt um die Menüs kleiner zu gestalten.
Unter Server Informationen ist auf einem blick alle wichtigen Infos zu sehen wie welche screens gerade laufen und mehr.
```

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
