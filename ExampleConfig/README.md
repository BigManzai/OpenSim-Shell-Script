# Konfiguration
In diesen Konfigurationen braucht eigentlich nur das was im Bereich Const steht geändert werden 

um ein lauffähiges Grid ohne MoneyServer und ohne Voice zu erstellen.

Diese Einstellungen sind nach meinem Geschmack vorgenommen worden.

MoneyServer und Voice ist bereits voreingestellt aber deaktiviert.

Die Dateien die mit example enden sind die Original Dateien.

## Const einstellen OpenSim.ini:
BaseHostname = "127.0.0.1" Die Adresse 127.0.0.1 müst ihr gegen eure DNS also meinserver.de oder gegen eure externe IP austauschen.

SimulatorPort = "9010"  Jeder Simulator benötigt einen eigenen Port also für sim1 = 9010, sim2 = 9020, sim3 = 9030 und so weiter.

SimulatorXmlRpcPort = "20801" Jeder Simulator benötigt einen eigenen Port also für sim1 = 20811, sim2 = 20821, sim3 = 20831 und so weiter.

Simulatorgridname = "opensimMULTITOOL"  Hier kommt euer gewünschter Gridname rein.

## Const einstellen GridCommon.ini:

BaseHostname = "127.0.0.1" Die Adresse 127.0.0.1 müst ihr gegen eure DNS also meinserver.de oder gegen eure externe IP austauschen.

[DatabaseService] 
ConnectionString = "Data Source=localhost;Database=opensim;User ID=opensim;Password=opensim;Old Guids=true;"  

Jeder Simulator benötigt eine eigene Datenbank in dieser Zeile  bitte euren Datenbankzugang eintragen.

## Const einstellen Robust.ini:

BaseURL = "http://127.0.0.1"

MysqlDatabase = "robust"

MysqlUser = "opensim"

MysqlPassword = "opensim"

StartRegion = "Welcome"

Simulatorgridname = "opensimMULTITOOL"

Simulatorgridnick = "OMT"

Das ist eigentlich wie oben bereits beschrieben.

## MoneyServer.ini falls dieser installiert ist:

database = money

username = user

password = passwd 

MoneyScriptIPaddress = "153.412.335.204"

Es sind nur die 4 Zeilen die geändert werden müssen  MoneyScriptIPaddress ist die IP des Servers.
