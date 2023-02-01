# OpenSimulator Konfigurationen

## Jetzt mit automatischen Konfigurator
Der Konfigurator erstellt mehrfach Verzeichnisse und die SimulatorList.ini, für die automatische installation mit dem ```opensimMULTITOOL```.

Anschließend kann das gesammte Grid mit der Funktion ```/opt/opensim.sh osupgrade``` installiert/vorbereitet werden.

OpenSimulator 0.9.2.2+ Konfigurationsdateien für ein Hypergrid angepasst.

Diese ersetzen die gleichnamigen Konfigurationen für Robust und OpenSim.

Die einzige Datei die bearbeitet werden muss ist die Const.ini Datei.

Hiermit wird das Erstellen eines Grid´s einfacher und schneller, 

da sich nur noch 2 Punkte für jeden weiteren OpenSimulator ändern.

Diese Punkte sind 
``` SimulatorPort = "9010" ``` und ``` MysqlDatabase = "MysqlDatabase" ``` 

in der Datei Const.ini im Verzeichnis config-include.


``` Jeder OpenSimulator benötigt einen freien SimulatorPort. ```

``` Jeder OpenSimulator sollte eine eigene Datenbank bekommen, diese bitte vor dem starten anlegen. ```
