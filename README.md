# OpenSim-Shell-Script
![GitHub Logo](https://github.com/BigManzai/OpenSim-Shell-Script/blob/main/opensimMultitool.jpg)

[![Anurag's GitHub stats](https://github-readme-stats.vercel.app/api?username=anuraghazra)](https://github.com/anuraghazra/github-readme-stats)

Info: This is not for neuromusculoskeletal modeling and simulation. This is OpenSim Metaverse software.

:warning: **Durch die Umstellung von .NET und mono auf dotnet6 gibt es beim bauen mit mono 5/6 Probleme, da jetzt der Standard dotnet 6 ist.** <br>

:information_source: **Das erstellen des OpenSimulator mit den xxxx93 Funktionen des opensimMULTITOOL funktioniert aber noch.** <br>

:warning: **Fazit: Bitte versuchen Sie kein automatisches Upgrade der OpenSimulator Versionen für .NET4,6/4,8 mehr.** <br>

:information_source: **In der nächsten Version des opensimMULTITOOL werden alle mono Funktionen entfernt werden und nur noch dotnet ab Version 6 genutzt.**


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

https://www.mediafire.com/file/srom4d181slm1t1/opensim-0.9.2.2.398.zip/file

## Vorbereitung des opensimMULITOOLS

Als erstes wird die Datei osmtool.sh auf den Server hochgeladen.

Ich empfehle das Verzeichnis /opt für Optionale Software.

Dies sollte jetzt ausführbar gemacht werden mit:

     chmod +x /opt/osmtool.sh

Gestartet werden kann das aber auch direkt mit:

     bash osmtool.sh

oder (ausführbar gemacht)

     ./osmtool.sh

oder (ausführbar gemacht)

     /opt/osmtool.sh

Beim erststart wird die Konfigurationsdatei osmtoolconfig.ini erstellt.

Dazu müssen sie ein paar fragen beantworten. 

(Durch löschen oder umbenennen der Datei osmtoolconfig.ini kann dies wiederholt werden.)

## Vorbereitung eines Ubuntu Server

Eine Server erstinstallation eines Ubuntu 18 oder 22 Servers kann mit folgender Funktion ausgelöst werden:

Server Installation Ubuntu 18 mit mySQL

     bash osmtool.sh serverinstall
     
Server Installation Ubuntu 22 mit mariaDB

     bash osmtool.sh serverinstall22

## Hilfe

    bash osmtool.sh h
    
		Display Hilfe
		Syntax: osmtool.sh [h|hilfe|konsolenhilfe|dbhilfe|commandhelp|RobustCommands|OpenSimCommands|hda]
		Optionen:
		h                       Zeigt diese hilfe.
		hilfe                   Haupthilfefunktionen.
		konsolenhilfe           Konsolenhilfe dreht sich um Putty.
		dbhilfe                 Hilfe rund um die Datenbankmanipulation.
		commandhelp             OpenSimulator Kommandos in Deutsch.
		RobustCommands          Robust Kommandos.
		OpenSimCommands         OpenSimulator Kommandos.
		MoneyServerCommands     MoneyServer Kommandos.
		all                     Alle OpenSimulator Konsolenkommandos.
		hda                     Dialog Menue direktaufrufe.

## Dokumentation erstellen
Der Aufruf: bash osmtool.sh createmanual

erstellt eine Dokumentation des gesamten opensimMULTITOOL

siehe Testdatei Manual_DATUM.md

oder

Funktionsliste: https://github.com/BigManzai/OpenSim-Shell-Script/wiki/Funktionsliste

## Der Kommando aufruf:
 
     Beispiel: bash osmtool.sh oscommand sim1 Welcome "alert Hallo Welt"
     Beispiel: bash osmtool.sh osc sim1 Welcome "alert-user John Doe Hallo John Doe"
 
 Dies Sendet ein Kommando direkt in den Screen, ohne diesen öffnen und schließen zu müssen.
 Die abkürzung für oscommand ist osc.
 
## Konfiguration

osmtools erstellt automatisch die erforderlichen Konfigurationen.

Manchmal ist es aber nötig diese von Hand einzustellen.

In der osmtoolconfig.ini werden unter anderem Verzeichnispfade voreingestellt zum Beispiel home oder opt als Hauptverzeichnis. 

Bei dem Neuerstellen über "/opt/osmtool.sh gridkonfiguration" wird nicht nur die Struktur für ein Grid erstellt, 
sondern auch die osmsimlist.ini sowie alle benötigten Datenbanken. 

Diese osmsimlist.ini Datei muss am Ende eine Leerzeile haben. Die Startreihenfolge ergibt sich aus der Aufstellung.

Bitte beachtet der Verzeichnisname des OpenSimulator ist gleichzeitig der Screen Name.

Wird kein Robust oder Money Verzeichnis gefunden, werden diese auch nicht gestartet.

## Struktur
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
    # .net bis 4.8
    0 6 * * * bash /opt/osmtool.sh restart
    # dotnet 6
    0 6 * * * bash /opt/osmtool.sh autorestart93

(Format: Minute=0, Stunde=6)

oder

    # Stoppen um 22 Uhr
    0 22 * * * bash /opt/osmtool.sh autostop

    # Starten um 9 Uhr
    0 9 * * * bash /opt/osmtool.sh autostart
    
(Format: Minute=0, Stunde=22)

(Format: Minute=0, Stunde=9)

Beispiele:
     
     # Jede Minute
     * * * * * bash /opt/osmtool.sh oscommand sim1 Root "alert Hallo Welt es ist der: $(date +'%d.%m.%Y-%H:%M:%S')"
     # Jeden Tag um 22:30 Uhr
     30 22 * * * bash /opt/osmtool.sh oscommand sim1 Root "alert Hallo Welt es ist der: $(date +'%d.%m.%Y-%H:%M:%S')"
     # Jeden Montag um 16:00 Uhr
     0 16 * * 1 bash /opt/osmtool.sh oscommand sim1 Root "alert Hallo Welt es ist der: $(date +'%d.%m.%Y-%H:%M:%S')"
     # Jedes Jahr am 1. Januar um 12:00 Uhr
     0 0 1 1 * bash /opt/osmtool.sh oscommand sim1 Root "alert Hallo Welt es ist der: $(date +'%d.%m.%Y-%H:%M:%S')"
     # Der 1. jedes Monats um 12:00 Uhr
     0 0 1 * * bash /opt/osmtool.sh oscommand sim1 Root "alert Hallo Welt es ist der: $(date +'%d.%m.%Y-%H:%M:%S')"
     # Montags einmal pro Stunde
     0 * * * 1 bash /opt/osmtool.sh oscommand sim1 Root "alert Hallo Welt es ist der: $(date +'%d.%m.%Y-%H:%M:%S')"
     # Jede Minute 20 Stunden am Tag
     * 1-20 * * * bash /opt/osmtool.sh oscommand sim1 Root "alert Hallo Welt es ist der: $(date +'%d.%m.%Y-%H:%M:%S')"
     # Zweimal pro Stunde
     0,30 * * * * bash /opt/osmtool.sh oscommand sim1 Root "alert Hallo Welt es ist der: $(date +'%d.%m.%Y-%H:%M:%S')"
     # 5 mal am Tag
     0 1-5 * * * bash /opt/osmtool.sh oscommand sim1 Root "alert Hallo Welt es ist der: $(date +'%d.%m.%Y-%H:%M:%S')"
     # 5 Tage im Monat um 1:00 Uhr
     0 1 1-5 * * bash /opt/osmtool.sh oscommand sim1 Root "alert Hallo Welt es ist der: $(date +'%d.%m.%Y-%H:%M:%S')"
     # Alle 2 Minuten
     */2 * * * * bash /opt/osmtool.sh oscommand sim1 Root "alert Hallo Welt es ist der: $(date +'%d.%m.%Y-%H:%M:%S')"
     # Jede Minute alle 3 Stunden am 2. eines jeden Monats
     * 1/3 2 * * bash /opt/osmtool.sh oscommand sim1 Root "alert Hallo Welt es ist der: $(date +'%d.%m.%Y-%H:%M:%S')"
     # 3 Mal alle 5 Minuten
     1-3/5 * * * * bash /opt/osmtool.sh oscommand sim1 Root "alert Hallo Welt es ist der: $(date +'%d.%m.%Y-%H:%M:%S')"
     # Zweimal pro Stunde alle 2 Tage 2 Monate im Jahr um 12 Uhr
     1,2 0 */2 1,2 * bash /opt/osmtool.sh oscommand sim1 Root "alert Hallo Welt es ist der: $(date +'%d.%m.%Y-%H:%M:%S')"
     # Jeden Tag um 18:30 Uhr
     30 18 * * *, de bash /opt/osmtool.sh oscommand sim1 Root "alert Hallo Welt es ist der: $(date +'%d.%m.%Y-%H:%M:%S')"
     # Täglich um 18:30 Uhr
     30 18 * * *, de, true bash /opt/osmtool.sh oscommand sim1 Root "alert Hallo Welt es ist der: $(date +'%d.%m.%Y-%H:%M:%S')"

**Crontab speichern:**

STRG o

Dateinamen mit Return bestätigen

STRG x zum beenden

Crontab zum prüfen noch einmal anzeigen:

     crontab -l

## TODO und Informationen

VERSION 0.9.3.0.938

Wichtige Änderungen:

Autostart und Autorestart war vertauscht.

Translate Fehler behoben.

VERSION 0.9.3.0.927 KI AI Test.

Test 929 Fehlerkorrektur und erweiterung.

Dies ist eine Künstliche intelligenz (artificial intelligence) für Chats.

Kopieren sie die Datei "osmtool.sh", auf ihren Server

     https://github.com/BigManzai/OpenSim-Shell-Script

Schauen sie nach, ob alle installationen, gewünschte Werte aufweisen:

     bash osmtool.sh dalaiinstallinfos

Wenn nicht, Installieren sie alle Abhängigkeiten für Ihren KI AI Server nach:

     bash osmtool.sh dalaiserverinstall

Installieren sie, die KI AI Software 7B:

     bash osmtool.sh dalaiinstall

Starten oder stoppen sie die KI AI Software:

     bash osmtool.sh dalaistart
     bash osmtool.sh dalaistop

Der Zugang erfolgt über IhreIP:3000

------------------------------------------------

     09.07.2023 Translate test 126 Languages.
     delete old config
     start bash osmtool.sh
     open osmtoolconfig.ini
     OSMTRANSLATOR="ON" # ON/OFF
     OSMTRANS=":en" # Language
     ┌───────────────────────┬───────────────────────┬───────────────────────┐
     │ Afrikaans      -   af │ Hebrew         -   he │ Portuguese     -   pt │
     │ Albanian       -   sq │ Hill Mari      -  mrj │ Punjabi        -   pa │
     │ Amharic        -   am │ Hindi          -   hi │ Querétaro Otomi-  otq │
     │ Arabic         -   ar │ Hmong          -  hmn │ Romanian       -   ro │
     │ Armenian       -   hy │ Hmong Daw      -  mww │ Russian        -   ru │
     │ Azerbaijani    -   az │ Hungarian      -   hu │ Samoan         -   sm │
     │ Bashkir        -   ba │ Icelandic      -   is │ Scots Gaelic   -   gd │
     │ Basque         -   eu │ Igbo           -   ig │ Serbian (Cyr...-sr-Cyrl
     │ Belarusian     -   be │ Indonesian     -   id │ Serbian (Latin)-sr-Latn
     │ Bengali        -   bn │ Irish          -   ga │ Sesotho        -   st │
     │ Bosnian        -   bs │ Italian        -   it │ Shona          -   sn │
     │ Bulgarian      -   bg │ Japanese       -   ja │ Sindhi         -   sd │
     │ Cantonese      -  yue │ Javanese       -   jv │ Sinhala        -   si │
     │ Catalan        -   ca │ Kannada        -   kn │ Slovak         -   sk │
     │ Cebuano        -  ceb │ Kazakh         -   kk │ Slovenian      -   sl │
     │ Chichewa       -   ny │ Khmer          -   km │ Somali         -   so │
     │ Chinese Simp...- zh-CN│ Klingon        -  tlh │ Spanish        -   es │
     │ Chinese Trad...- zh-TW│ Klingon (pIqaD)tlh-Qaak Sundanese      -   su │
     │ Corsican       -   co │ Korean         -   ko │ Swahili        -   sw │
     │ Croatian       -   hr │ Kurdish        -   ku │ Swedish        -   sv │
     │ Czech          -   cs │ Kyrgyz         -   ky │ Tahitian       -   ty │
     │ Danish         -   da │ Lao            -   lo │ Tajik          -   tg │
     │ Dutch          -   nl │ Latin          -   la │ Tamil          -   ta │
     │ Eastern Mari   -  mhr │ Latvian        -   lv │ Tatar          -   tt │
     │ Emoji          -  emj │ Lithuanian     -   lt │ Telugu         -   te │
     │ English        -   en │ Luxembourgish  -   lb │ Thai           -   th │
     │ Esperanto      -   eo │ Macedonian     -   mk │ Tongan         -   to │
     │ Estonian       -   et │ Malagasy       -   mg │ Turkish        -   tr │
     │ Fijian         -   fj │ Malay          -   ms │ Udmurt         -  udm │
     │ Filipino       -   tl │ Malayalam      -   ml │ Ukrainian      -   uk │
     │ Finnish        -   fi │ Maltese        -   mt │ Urdu           -   ur │
     │ French         -   fr │ Maori          -   mi │ Uzbek          -   uz │
     │ Frisian        -   fy │ Marathi        -   mr │ Vietnamese     -   vi │
     │ Galician       -   gl │ Mongolian      -   mn │ Welsh          -   cy │
     │ Georgian       -   ka │ Myanmar        -   my │ Xhosa          -   xh │
     │ German         -   de │ Nepali         -   ne │ Yiddish        -   yi │
     │ Greek          -   el │ Norwegian      -   no │ Yoruba         -   yo │
     │ Gujarati       -   gu │ Papiamento     -  pap │ Yucatec Maya   -  yua │
     │ Haitian Creole -   ht │ Pashto         -   ps │ Zulu           -   zu │
     │ Hausa          -   ha │ Persian        -   fa │                       │
     │ Hawaiian       -  haw │ Polish         -   pl │                       │
     └───────────────────────┴───────────────────────┴───────────────────────┘

NEU

OpenSim 0.9.3.0 dotnet 6.
