# OpenSimulator Konfigurationen

Ich habe mal geschaut wie die Konfigurationen im Sourcecode des OpenSimulators aufgerufen werden, 
und zwar über den Wert "Include-" dahinter kann man anscheinend schreiben, was man will.

Wenn man eine Konfigurationsdatei namens Const.ini im /bin Verzeichniss 
des OpenSimulator/Robust erstellt kann man sie mit dem Befehl: 

### OpenSim.ini und Robust.ini
```
[Const]
Include-const = "Const.ini" 
```

### GridCommon.ini
```
[Const]
Include-const = "../Const.ini" 
```

nachladen.

## Die ganze Const.ini (Für alle Konfig´s) könnte dann so aussehen:
```
[Const]
	; this section defines constants for grid services
    ; to simplify other configuration files default settings

    ;# {BaseHostname} {} {BaseHostname} {"example.com" "127.0.0.1"} "127.0.0.1"
    BaseHostname = "MyGridName .de"

    ;# {BaseURL} {} {BaseURL} {"http://${Const|BaseHostname}} "http://${Const|BaseHostname}"
    BaseURL = http://${Const|BaseHostname}

    ; If you run a grid, several services should not be availble to world, access to them should be blocked on firewall
    ; PrivatePort should closed at the firewall.

    ;# {PublicPort} {} {PublicPort} {8002 9000} "8002"
    PublicPort = "8002"

    ; you can also have them on a diferent url / IP
    ;# {PrivURL} {} {PrivURL} {"http://${Const|BaseURL}} "${Const|BaseURL}"
    PrivURL = ${Const|BaseURL}

    ;grid default private port 8003, not used in standalone
    ;# {PrivatePort} {} {PrivatePort} {8003} "8003"
    ; port to access private grid services.
    ; grids that run all their regions should deny access to this port
    ; from outside their networks, using firewalls
    PrivatePort = "8003"

	;# {MoneyPort} {} {MoneyPort} {8008} "8008"
    MoneyPort = "8008"
	
	;# {SimulatorPort} {} {SimulatorPort} {${Const|SimulatorPort}} "${Const|SimulatorPort}"
	SimulatorPort = "9010"
	
	; If this is the robust configuration, the robust database is entered here.
	; If this is the OpenSim configuration, the OpenSim database is entered here.

	; The Database ${Const|MysqlDatabase} 
	MysqlDatabase = "databasename"
	
	; The User ${Const|MysqlUser}
    MysqlUser = "databaseUSERname"
	
	; The Password ${Const|MysqlPassword}
    MysqlPassword = "databasePasswd"
	
	; The Region Welcome ${Const|StartRegion}
    StartRegion = "Welcome"
	
	;# Grid name ${Const|Simulatorgridname}
	Simulatorgridname = "MyGridName"
	
	; The Simulator grid nick ${Const|Simulatorgridnick}
    Simulatorgridnick = "MGN"
```

## Die MySQL Bereiche von Robust.ini und GridCommon.ini sehen dann so aus:
```
StorageProvider = "OpenSim.Data.MySQL.dll"
ConnectionString = "Data Source=localhost;Database=${Const|MysqlDatabase};User ID=${Const|MysqlUser};Password=${Const|MysqlPassword};Old Guids=true;"
```

Der Rest ist eigentlich selbsterklärend.

Habs gerade laufen, funktioniert gut und für jeden weiteren Simulator, 
muss nur ganz wenig Konfigurationsarbeit gemacht werden.
Halt nur noch den Port und die Datenbanknamen ändern für jeden Simulator.

Wenn ich das ausgiebig durchgetestet habe, stelle ich diese zur Verfügung.

So ist es erst einmal experimentell.
