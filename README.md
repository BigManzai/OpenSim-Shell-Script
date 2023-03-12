# OpenSim-Shell-Script
![GitHub Logo](https://github.com/BigManzai/OpenSim-Shell-Script/blob/main/opensimMultitool.jpg)

Dieses opensimMULTITOOL Skript, ist in der Lage ein Komplettes Virtuelles Metaversum, auf einem Ubuntu Server zu erstellen. 

Es ist aufgebaut auf meinem 16 Jährigen wissen, über das Metaversum und dessen Betrieb. 

Bitte fallen sie nicht auf Virtuelle Brillen herein, es ist die Software die ein Virtuelles Metaversum erschafft, 

nicht ein Kopfmonitor (HMD head mounted device = Kopfmonitor).

Für diese VR Brillen, müssen sie im Viewer, die Joypad/Joystick Einstellung aktivieren 

und dieser kann dann mit den Virtual Reality Headset Controlern gesteuert werden, 

scrollen sie mit der Maus die nah Ansicht heran, bis sie sich nicht mehr selber sehen können.

## Aus opensim.sh wird nun osmtool.sh 

mit einer Automatisch erstellende Konfigurationsdatei nach ein paar abfragen.

osmtool.sh Basiert auf meinen Einzelscripten, an denen ich bereits 7 Jahre Arbeite und verbessere.

Da Linux Server unterschiedlich sind, kann eine einwandfreie Funktion nicht gewährleistet werden, also bitte mit bedacht verwenden.

Die Benutzung dieses Scripts, oder deren Bestandteile, erfolgt auf eigene Gefahr!!!

Erstellt und getestet ist osmtool.sh, auf verschiedenen Ubuntu 18.04 (jetzt auch 22.04) Servern, unter verschiedenen Server Anbietern (Contabo, Hetzner etc.).

Dieses Script läuft auf einem Grid mit 40 Simulatoren genauso, wie mit zum Beispiel OsGrid angebundenen Simulatoren.

Es kann automatisch eine DATUM-multitool.log angelegt um nachzuverfolgen ob alles ordnungsgemäß ausgeführt wurde.

### Download OpenSimulator Testversion für Ubuntu 18.04 und Ubuntu 22.04

https://www.mediafire.com/file/vnr3k7r5jaqj1jt/opensim-0.9.2.2.392.zip/file

## Vorbereitung des opensimMULITOOLS

Als erstes wird die Datei osmtool.sh auf den Server hochgeladen.

Ich empfehle das Verzeichnis /opt für Optionale Software.

Dies muss jetzt ausführbar gemacht werden mit:

     chmod +x /opt/osmtool.sh

Gestartet werden kann das nun mit:

     bash osmtool.sh

oder

     ./osmtool.sh

oder

     /opt/osmtool.sh

Beim erststart wird die Konfigurationsdatei osmtoolconfig.ini erstellt.

Dazu müssen sie ein paar fragen beantworten. 

(Durch löschen oder umbenennen der Datei osmtoolconfig.ini kann dies wiederholt werden.)

## Vorbereitung eines Ubuntu Server

Eine Server erstinstallation eines Ubuntu 18 oder 22 Servers kann mit folgender Funktion ausgelöst werden:

      /opt/osmtool.sh serverinstall

## Hilfe 

    /opt/osmtool.sh hilfe
    
dazu gibt es noch die Konsolenhilfe für Putty oder Bitvise-Xterm

    /opt/osmtool.sh konsolenhilfe
    
und die OpenSim Commands Hilfe in Deutsch

    /opt/osmtool.sh commandhelp

## Konfiguration

osmtools erstellt automatisch die erforderlichen Konfigurationen.

Manchmal ist es aber nötig diese von Hand einzustellen.

In der osmtoolconfig.ini werden unter anderem Verzeichnispfade voreingestellt zum Beispiel home oder opt als Hauptverzeichnis. 

Bei dem Neuerstellen über "/opt/osmtool.sh gridkonfiguration" wird nicht nur die Struktur für ein Grid erstellt, 
sondern auch die osmsimlist.ini sowie alle benötigten Datenbanken. 

Diese osmsimlist.ini Datei muss am Ende eine Leerzeile haben. Die Startreihenfolge ergibt sich aus der Aufstellung.

Bitte beachtet der Verzeichnisname des OpenSimulator ist gleichzeitig der Screen Name.

Wird kein Robust oder Money Verzeichnis gefunden, werden diese auch nicht gestartet.

## Informationen
Die Struktur baut sich folgendermaßen auf:

    robust (Robust Server und eventuell Money Server)
    sim1 (Welcome Region)
    sim2 (Weitere Regionen 1-15)
    sim3 (Weitere Regionen 1-15)
    ... (Alle weiteren Regionen)
    
Es sollten nicht mehr als 15 Regionen pro Sim betrieben werden, Ausnahme ist die Welcome Region, diese sollte einzeln laufen und möglichst klein gehalten werden.

Regionen die einzeln laufen sollten sind:

     Welcome (Einwahldaten)
     Club (Avatar Daten)
     Shop (Artikel Download)
     Sandbox (Absturzgefahr)

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

Format: Minute(0 - 59)-Stunde(0 - 23)-Tag(1 - 31)-Monat(1 - 12)-Wochentag(0 - 7) - Aktion/Program -

    # Restart um 6 Uhr
    0 6 * * * /opt/osmtool.sh restart

(Format: Minute=0, Stunde=6)

oder

    # Stoppen um 22 Uhr
    0 22 * * * /opt/osmtool.sh autostop

    # Starten um 9 Uhr
    0 9 * * * /opt/osmtool.shh autostart
    
(Format: Minute=0, Stunde=22)

(Format: Minute=0, Stunde=9)

**Crontab speichern:**

STRG o

Dateinamen mit Return bestätigen

STRG x zum beenden

Crontab zum prüfen noch einmal anzeigen:

     crontab -l

## Menü mit dialog
Ich habe eine Menüfunktion integriert diese schaut zuerst ob dialog installiert ist oder nicht.

Wenn ihr dialog installiert habt dann öffnet sich nach der Eingabe von ./osmtool.sh ein Menü.

In diesem Menü kann man einige Funktionen bequem aufrufen.

Bisher sind nur Funktionen im Menü die maximal 1 Übergabewert voraussetzen.

     Nachinstallieren von dialog mit:
     apt install dialog
     oder
     sudo apt-get install dialog

## TODO und Informationen
gridcachedelete
Aufruf: ./osmtool.sh gridcachedelete

Cache Dateien löschen aus einem Grid, so werden alte ungenutzte Dateien bereinigt.
Löscht die Verzeichnisse: assetcache, maptiles, ScriptEngines aus den Simulatoren.

Und aus Robust: bakes, maptiles

Es werden hierdurch neue leere Verzeichnisse angelegt und befüllt.

------

opensimMULTITOOL erstellt jetzt seine eigene Konfigurationsdatei.

------

Downgrade das zurücksetzen auf die vorherige Version des OpenSimulators ist jetzt möglich.

------

Vorbereitungen zum kompletten Installationsprozess (In Entwicklung)

     createmasteravatar
     
     createregionavatar
     
     firstinstallation
     
------

Status 24.02.2023 353 Funktionen.


## NEU
Regionskonfigurationen erstellen per zufall und direkt funktionsfähig.

    ./osmtool.sh regionconfig

------

mySQL Menü wurde aufgeräumt.

------

Alle Besucherlisten löschen:

     ./osmtool.sh clearuserlist
    
Verionsangabe angeglichen an den OpenSimulator VERSION="V0.9.2.2.759".

Aufgeräumt, Fehler entfernt und Hilfe erweitert.

Hilfe Übersicht:

     ./osmtool.sh  h

Remark neu gemacht, nach den Internationalen Programmierrichtlinien angeglichen.

Abgespeckt, alles was nicht mehr benötigt wird, wurde oder wird entfernt.
