#!/bin/bash

# Aufruf Beispiel: ./macme.sh John Doe

# Author Manfred Aabye 2023 MIT Lizens

FIRSTNAME=$1; LASTNAME=$2;
DIELOGDATEI="/opt/robust/bin/Robust.log"; SPERRPORT=8002;

# Sperren auf der Netzwerkschicht
# Suchen wir nun den Angreifer, so können wir das Protokoll nach der MAC-Adresse durchsuchen:

echo "Suche nach: $FIRSTNAME"'.'"$LASTNAME" # Kontrollausgabe

ANGREIFERABFRAGE=$(cat $DIELOGDATEI | grep 'Login request' | grep "$FIRSTNAME"'.'"$LASTNAME" | awk -F ',' '{ print $5 }' | sort -u | sed 's/ //') # Den Nippel durch die Lasche ziehen
ANGREIFERERGEBNIS="${ANGREIFERABFRAGE:4}" # Nur die Mac Adresse.

# Abfrage ob Variable Leer ist
if [ -z "$ANGREIFERERGEBNIS" ]
then
    echo "Die Suche nach $FIRSTNAME"'.'"$LASTNAME ergab keine Treffer"
else
    echo "Mac Adresse des Angreifers entdeckt: $ANGREIFERERGEBNIS"
    # Jetzt, können wir ipt_stringmatch verwenden, 
    # um die MAC-Adresse zu erkennen und den Agenten zu verbieten:

    # Der --dport = 9000 oder 8002 oder welchen auch immer.
    #iptables -A INPUT -m string --string "$ANGREIFERERGEBNIS" --algo bm -p tcp --dport "$SPERRPORT" -j DROP

    # Nicht nur das, wir können den Benutzer auch sperren:

    #iptables -A INPUT -m string --string "$FIRSTNAME" --algo bm -m string --string "$LASTNAME" --algo bm -p tcp --dport "$SPERRPORT" -j DROP

    # Das Ergebnis ist, dass der Betrachter keine Verbindung herstellen kann und auf dem Anmeldebildschirm eine Zeitüberschreitung zeigt.
fi

