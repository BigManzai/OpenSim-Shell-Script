#!/bin/bash

# Aufruf Beispiel: ./attacker.sh John Doe

# Author Manfred Aabye 2023 MIT Lizens

FIRSTNAME=$1; LASTNAME=$2;
DIELOGDATEI="/opt/robust/bin/Robust.log";

# Suchen wir nun den Angreifer.

echo "Suche nach: $FIRSTNAME"'.'"$LASTNAME" # Kontrollausgabe

VIEWER2=$(cat $DIELOGDATEI | grep 'Login request' | grep "$FIRSTNAME"'.'"$LASTNAME" | awk -F ',' '{ print $3 }' | sort -u | sed 's/ //')
VIEWERERGEBNIS2="${VIEWER2:8}" # Nur der Viewer.
if [ -z "$VIEWERERGEBNIS2" ];then echo "Die Viewer Suche nach $FIRSTNAME"'.'"$LASTNAME ergab keine Treffer"
else echo "Der benutzte Viewer: $VIEWERERGEBNIS2"; fi

GENUTZTEIP=$(cat $DIELOGDATEI | grep 'Login request' | grep "$FIRSTNAME"'.'"$LASTNAME" | awk -F ',' '{ print $4 }' | sort -u | sed 's/ //')
GENUTZTEIPERGEBNIS="${GENUTZTEIP:3}" # Nur die IP Adresse.
if [ -z "$GENUTZTEIPERGEBNIS" ];then echo "Die IP Suche nach $FIRSTNAME"'.'"$LASTNAME ergab keine Treffer"
else echo "Die IP des Angreifers: $GENUTZTEIPERGEBNIS"; fi

ANGREIFERABFRAGEMAC=$(cat $DIELOGDATEI | grep 'Login request' | grep "$FIRSTNAME"'.'"$LASTNAME" | awk -F ',' '{ print $5 }' | sort -u | sed 's/ //')
ANGREIFERERGEBNISMAC="${ANGREIFERABFRAGEMAC:4:32}" # Nur die Mac Adresse.
if [ -z "$ANGREIFERERGEBNISMAC" ];then echo "Die MAC Suche nach $FIRSTNAME"'.'"$LASTNAME ergab keine Treffer"
else echo "Die MAC des Angreifers: $ANGREIFERERGEBNISMAC"; fi

ANGREIFERABFRAGEID=$(cat $DIELOGDATEI | grep 'Login request' | grep "$FIRSTNAME"'.'"$LASTNAME" | awk -F ',' '{ print $6 }' | sort -u | sed 's/ //')
ANGREIFERERGEBNISID="${ANGREIFERABFRAGEID:4:32}" # Nur die id0 Adresse.
if [ -z "$ANGREIFERERGEBNISID" ];then echo "Die ID0 Suche nach $FIRSTNAME"'.'"$LASTNAME ergab keine Treffer"
else echo "Die ID0 des Angreifers: $ANGREIFERERGEBNISID"; fi

GRIDADRESS=$(cat $DIELOGDATEI | grep 'Login request' | grep "$FIRSTNAME"'.'"$LASTNAME" | awk -F '@' '{ print $2 }'| sort -u | sed 's/ //')
DASENDE=$(echo "$GRIDADRESS"  | sed 's/\([^ ]*\) .*/\1/' | wc -c) # schauen wie viele Zeichen bis Leerzeichen.
GRIDADRESSERGEBNIS=${GRIDADRESS:0:$DASENDE} # Ausgabe bis zum Leerzeichen kuerzen.
if [ -z "$GRIDADRESSERGEBNIS" ];then echo "Die Grid Adress Suche nach $FIRSTNAME"'.'"$LASTNAME ergab keine Treffer"
else echo "Die Grid Adresse des Angreifers: $GRIDADRESSERGEBNIS"; fi
