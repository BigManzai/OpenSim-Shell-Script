# OpenSimulator Konfigurationen
OpenSimulator 0.9.2.2+ Konfigurationsdateien sind für ein Hypergrid angepasst.

Diese ersetzen die gleichnamigen Konfigurationen für Robust und OpenSim.

Die einzige Datei die bearbeitet werden muss ist die Const.ini Datei.

Hiermit wird das Erstellen eines Grid´s einfacher und schneller, 

da sich nur noch 2 Punkte für jeden weiteren OpenSimulator ändern.

# Automatischer Linux Bash Konfigurator

Der Konfigurator erstellt Multi Verzeichnisse inklusive den Konfigurationen.
Dieses Skript legt folgende Verzeichnisse und Dateien an:

## Verzeichnis /robust/bin
* Robust.ini
* MoneyServer.ini
## Verzeichnis robust/bin/config-include
* const.ini
* GridCommon.ini
## Verzeichnis /simX/bin
* OpenSim.ini
## Verzeichnis /simX/bin/config-include
* Const.ini
* FlotsamCache.ini
* GridCommon.ini
* osslEnable.ini
## Verzeichnis /simX/bin/Regions
* Regions.ini

Mit den Optionen osslEnable.ini und Regions.ini zu aktivieren oder zu deaktivieren(Standard).
