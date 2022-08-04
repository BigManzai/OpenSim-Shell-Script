#!/bin/bash

# Konfigurationen so abaendern das sie maschinell weiterverarbeitet werden koennen.

datei=$1

#datei="OpenSim.ini"

#echo "Loesche $datei"
#rm $datei

echo "Loesche alle Zeilen mit ;"
#sed -i -e '/string/d' input
sed -i -e '/;/d' "$datei" #OK geht

echo "Fuehrende Leerzeichen (Leerzeichen, Tabulatoren) vor jeder Zeile loeschen"
sed -i -e 's/^[ \t]*//' "$datei"

echo "Loesche alle Zeilen mit Leerstellen"
sed -i -e '/^$/d' "$datei"

echo "Einstrich Sonderzeichen an den anfang und ende jeder Zeile haengen."
sed -i -e s/^/\'/ "$datei"
sed -i -e s/$/\'/g "$datei"
