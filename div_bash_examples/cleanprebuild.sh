#!/bin/bash

##
 #* cleanprebuild.
 # loeschen aller Prebuild Dateien, da sie von OpenSim Prebuild nicht geloescht werden.
 # 
 #? @param keine.
 #? @return nichts wird zurueckgegeben.
 # todo: nichts.
##
function cleanprebuild() {
	CPVERZEICHNIS=$1
	# Die if schleife prueft nur ob das Verzeichnis vorhanden ist.
	if [ ! -f "/$CPVERZEICHNIS/" ]; then
		# Verzeichnis wo geloescht werden soll.
		DIR="/$CPVERZEICHNIS"
		# Dateien mit Endung csproj und user loeschen.
		find "$DIR" -name '*.csproj' -exec rm -rv {} \;
		find "$DIR" -name '*.csproj.user' -exec rm -rv {} \;
		# Verzeichnisse obj loeschen
		find "$DIR" -name 'obj' -exec rm -rv {} \;
	else
		log error "$CPVERZEICHNIS Verzeichnis existiert nicht"
	fi
	return 0
}

# Main
cleanprebuild "opt/opensim/addon-modules"