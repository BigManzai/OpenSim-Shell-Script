# OpenSim-Shell-Script
![GitHub Logo](https://github.com/BigManzai/OpenSim-Shell-Script/blob/main/opensimMultitool.jpg)

Dieses opensimMULTITOOL Skript, ist in der Lage ein Komplettes Virtuelles Metaversum, auf einem Ubuntu Server zu erstellen. 

Es ist aufgebaut auf meinem 16 Jährigen wissen, über das Metaversum und dessen Betrieb. 

Bitte fallen sie nicht auf Virtuelle Brillen herein, es ist die Software die ein Virtuelles Metaversum erschafft, 

nicht ein Kopfmonitor (HMD head mounted device = Kopfmonitor).

Für diese VR Brillen, müssen sie im Viewer, die Joypad/Joystick Einstellung aktivieren 

und dieser kann dann mit den Virtual Reality Headset Controlern gesteuert werden, 

scrollen sie mit der Maus die nah Ansicht heran, bis sie sich nicht mehr selber sehen können.

## Aus opensim.sh wird nun ostools.sh 

mit einer Automatisch erstellende Konfigurationsdatei nach ein paar abfragen.

ostools.sh Basiert auf meinen Einzelscripten, an denen ich bereits 7 Jahre Arbeite und verbessere.

Da Linux Server unterschiedlich sind, kann eine einwandfreie Funktion nicht gewährleistet werden, also bitte mit bedacht verwenden.

Die Benutzung dieses Scripts, oder deren Bestandteile, erfolgt auf eigene Gefahr!!!

Erstellt und getestet ist ostools.sh, auf verschiedenen Ubuntu 18.04 (jetzt auch 22.04) Servern, unter verschiedenen Server Anbietern (Contabo, Hetzner etc.).

Dieses Script läuft auf einem Grid mit 40 Simulatoren genauso, wie mit zum Beispiel OsGrid angebundenen Simulatoren.

Es kann automatisch eine DATUM-multitool.log angelegt um nachzuverfolgen ob alles ordnungsgemäß ausgeführt wurde.

### Download OpenSimulator Testversion für Ubuntu 18.04 und Ubuntu 22.04

(Bitte die beiliegende ostools.sh und opensim.cfg verwenden):

https://www.mediafire.com/file/i7a4vtdxzz160z1/opensim-0.9.2.2.386.zip/file

## Hilfe 

    /opt/ostools.sh hilfe
 
dazu gibt es noch die Konsolenhilfe für Putty oder Bitvise-Xterm

    /opt/ostools.sh konsolenhilfe
    
und die OpenSim Commands Hilfe in Deutsch

    /opt/ostools.sh commandhelp

## Konfiguration

In der opensim.cnf werden unter anderem Verzeichnispfade voreingestellt zum Beispiel home oder opt als Hauptverzeichnis. 

Bei dem Neuerstellen über "ostools.sh osstruktur" wird nicht nur die Struktur für ein Grid erstellt sondern auch die SimulatorList.ini. 

Diese Dateien müssen am Ende eine Leerzeile haben. Die Startreihenfolge ergibt sich aus der Aufstellung.

Bitte beachtet der Verzeichnisname des OpenSimulator ist gleichzeitig der Screen Name.

Wird kein Robust oder Money Verzeichnis gefunden, werden diese auch nicht gestartet.

Das Skript ausführbar machen mit "chmod +x ostools.sh" danach kann es mit "./ostools.sh" oder "/verzeichnis/ostools.sh" ausgeführt werden.

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
    0 6 * * * /opt/ostools.sh restart
    
oder

    # Stoppen um 22 Uhr
    0 22 * * * /opt/ostools.sh autostop

    # Starten um 9 Uhr
    0 9 * * * /opt/ostools.shh autostart
    
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

Wenn ihr dialog installiert habt dann öffnet sich nach der Eingabe von ./ostools.sh ein Menü.

In diesem Menü kann man einige Funktionen bequem aufrufen.

Bisher sind nur Funktionen im Menü die maximal 1 Übergabewert voraussetzen.

     Nachinstallieren von dialog mit:
     apt install dialog
     oder
     sudo apt-get install dialog

## TODO und Informationen
gridcachedelete
Aufruf: ./ostools.sh gridcachedelete

Cache Dateien löschen aus einem Grid, so werden alte ungenutzte Dateien bereinigt.
Löscht die Verzeichnisse: assetcache, maptiles, ScriptEngines aus den Simulatoren.

Und aus Robust: bakes, maptiles

Es werden hierdurch neue leere Verzeichnisse angelegt und befüllt.

------

Dowmgrade das zurücksetzen auf die vorherige Version des OpenSimulators ist jetzt möglich.
