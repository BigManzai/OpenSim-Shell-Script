# osmtool für DOTNET 6
Dies befindet sich in der Entwicklung.

	# DOTNET 6 Installation entweder:
	# Ubuntu 18
	bash osmtool.sh dotnetubu18
	# Ubuntu 22
	bash osmtool.sh dotnetubu22

	# Deinstallation von mono falls nötig:
	bash osmtool.sh uninstall_mono

	# Herunterladen von source Dateien:
	# MoneyServer
	bash osmtool.sh moneygitcopy
	# ossl Skripte
	bash osmtool.sh scriptgitcopy

	# OpenSim stoppen:
	bash osmtool.sh autostop

	# Alte OpenSim installationen entfernen:
	bash osmtool.sh autoallclean

	# Jetzt eine neue Master Version als ZIP herunterladen von hier:
	# http://opensimulator.org/viewgit/?a=shortlog&p=opensim
	# Anschliessend auf den Server hochladen.

	# Neue OpenSim DOTNET 6 Version Kompilieren und Installieren:
	bash osmtool.sh osbuilding 202

Beispiel die OpenSim Version hat den Namen opensim-0.9.3.0Dev-202-ge0ee44c.zip dann ist die Nummer 202.

Es wird dann automatisch die Zip Datei entpackt mit MoneyServer und den Skripten zusammengebaut und Kompiliert.

Zuletzt wird dann alles upgegradet und neu gestartet.
