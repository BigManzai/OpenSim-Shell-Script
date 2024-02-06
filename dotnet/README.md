# osmtool für DOTNET 6
Dies befindet sich in der Entwicklung.

Im [BulletSim](https://github.com/BigManzai/BulletSim) Verzeichnis befindet sich eine Version die unter Ubuntu 18 und Ubuntu 22 gebaut wurde und im Test läuft.

:warning: Zuerst alte Konfigurationsdatei löschen (osmtoolconfig.ini) und neue anlegen lassen

	cd /Ort/des/osmtools_und_OpenSim
	bash osmtool.sh
 
	# Backup nicht vergessen, dieses Backup erstellt 4 Dateien für jede Region (Alle Backup möglichkeiten)
	bash osmtool.sh autoregionbackup
 
	# Bullet 3.2.1 Installationen sind automatisiert.
 	bash osmtool.sh dotnetubu18
 	# oder
 	bash osmtool.sh dotnetubu20
	# oder
 	bash osmtool.sh dotnetubu22
 
	# Herunterladen von source Dateien:
	# MoneyServer
	bash osmtool.sh moneygitcopy
	# ossl Skripte
	bash osmtool.sh scriptgitcopy
 	#BulletSim für Ubuntu 18 + 22 (Upgrade VERSION 0.9.3.0.1433+)
	bash osmtool.sh bulletgitcopy

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


:warning: **Bitte nicht die Datenbank Migrationen bei älteren OpenSim Versionen vergessen!**

:information_source: **Informationen:** [http://opensimulator.org/wiki/Upgrading/de] [http://opensimulator.org/wiki/0.9.0.0_Release/de]


	#Crontab anzeigen:
	crontab -l

	#Crontab bearbeiten oder erstellen:
	crontab -e

	#Nachfolgende Zeilen unten im mit "crontab -e" geöffneten Crontab einfügen.
	# Minute Stunde Tag Monat Jahr Kommando	
	# Restart um 6 Uhr und am 1. jeden Monats den ganzen Server um 5 Uhr 45 neu starten.
	45 5 1 * * bash /opt/osmtool.sh reboot
	0 6 * * * bash /opt/osmtool.sh autorestart

## **TODO**
* Erster Test des Ubuntu deb-Paket Builder.
* Besucherlisten Fehler: Nur der erste eintrag wird ausgegeben oder gespeichert, behoben. Es wird jetzt jeder gespeichert. Kontrollausgabe: bash osmtool.sh write_visitor_log.
* Grid Besucherlisten werden jetzt ordentlich gespeichert und ausgegeben.
* Logs werden jetzt komplett gelöscht.
* Nicht mehr funktionierende Menüs überarbeitet.
* Benutzerlisten überarbeitet diese werden jetzt in der Standart log Datei geschrieben.
* buildbullet - baut automatisch BulletSim 1.3 - Bullet Physic 3.26
* Falsche MoneyServer Version behoben. 
* Fehlende libgdiplus installation hinzugefügt. 
* Zuerst muss man natürlich den OpenSimulator herunterfahren bevor man mono deinstalliert. 
* MoneyServer wird jetzt direkt mitgebaut. 
* BulletSim für Ubuntu 18 + 22 wird jetzt automatisch eingefügt.
* bionic ist unter Linux nicht Bionic.
* Bullet Setup geändert.
* Bulletkopierfehler behoben.
