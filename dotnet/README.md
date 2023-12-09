# osmtool für DOTNET 6
Dies befindet sich in der Entwicklung.

:warning: **opensim-0.9.3.0Dev-203-g4a3cfd1 BulletSim Probleme bei Ubuntu 18!**

	# DOTNET 6 Installation entweder:
	# Ubuntu 18
	bash osmtool.sh dotnetubu18
 	# Ubuntu 20
	bash osmtool.sh dotnetubu20
	# Ubuntu 22 und 23
	bash osmtool.sh dotnetubu22
	# Herunterladen von source Dateien:
	# MoneyServer
	bash osmtool.sh moneygitcopy
	# ossl Skripte
	bash osmtool.sh scriptgitcopy

	# OpenSim stoppen:
	bash osmtool.sh autostop
 
 	# Deinstallation von mono falls nötig:
	bash osmtool.sh uninstall_mono

	# Alte OpenSim installationen entfernen (Konfigurationen, Einstellungen und Datenbanken sind nicht betroffen):
	bash osmtool.sh autoallclean

	# Jetzt eine neue Master Version als ZIP herunterladen von hier:
	# http://opensimulator.org/viewgit/?a=shortlog&p=opensim
	# Anschliessend auf den Server hochladen.

	# Neue OpenSim DOTNET 6 Version Kompilieren und Installieren:
	bash osmtool.sh osbuilding 202

Beispiel die OpenSim Version hat den Namen "opensim-0.9.3.0Dev-202-ge0ee44c.zip" dann ist die Nummer 202 anzugeben.

Es wird dann automatisch die Zip Datei entpackt mit MoneyServer und den Skripten zusammengebaut und Kompiliert.

Zuletzt wird dann alles upgegradet und neu gestartet.


:warning: **Bitte nicht die Datenbank Migrationen vergessen!**

:information_source: **Informationen:** [http://opensimulator.org/wiki/Upgrading/de] [http://opensimulator.org/wiki/0.9.0.0_Release/de]


	#Crontab ändern?
	#Crontab anzeigen:
	crontab -l

	#Crontab bearbeiten oder erstellen:
	crontab -e

	#Nachfolgende Zeilen unten im mit "crontab -e" geöffneten Crontab einfügen.
	Format: Minute(0 - 59)-Stunde(0 - 23)-Tag(1 - 31)-Monat(1 - 12)-Wochentag(0 - 7) - Aktion/Program -

	# Restart um 6 Uhr dotnet 6
	0 6 * * * bash /opt/osmtool.sh autorestart

## **TODO**
Falsche MoneyServer Version behoben. Fehlende libgdiplus installation hinzugefügt. Zuerst muss man natürlich den OpenSimulator herunterfahren bevor man mono deinstalliert.
