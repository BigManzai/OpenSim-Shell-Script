#!/bin/bash

# Konfigurationen so abaendern das sie maschinell weiterverarbeitet werden koennen.


    datei=$1

    echo "Loesche $datei.ini.cnf"
    rm "$datei.ini.cnf"

    echo "Kopiere $datei.ini nach $datei.ini.cnf"
    cp "$datei.ini" "$datei.ini.cnf"

    echo "Loesche alle Zeilen mit ;"
    #sed -i -e '/string/d' input
    sed -i -e '/;/d' "$datei.ini.cnf"

    echo "Fuehrende Leerzeichen (Leerzeichen, Tabulatoren) vor jeder Zeile loeschen"
    sed -i -e 's/^[ \t]*//' "$datei.ini.cnf"

    echo "Loesche alle Zeilen mit Leerstellen"
    sed -i -e '/^$/d' "$datei.ini.cnf"

    echo "Ersetze alle doppelten Hochstriche gegen einfache."
    sed -i -e s/\"/\'/g "$datei.ini.cnf"

    echo "Einstrich Sonderzeichen an den anfang und ende jeder Zeile haengen."
    sed -i -e s/^/\"/ "$datei.ini.cnf"
    sed -i -e s/$/\"/g "$datei.ini.cnf"

    echo "Ein Array daraus machen."
    sed -i -e 1 i\$dateiConfigList=\( "$datei.ini.cnf"
    sed -i -e '$a)' "$datei.ini.cnf"
