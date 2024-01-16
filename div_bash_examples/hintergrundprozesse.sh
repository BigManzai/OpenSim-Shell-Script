#!/bin/bash

# In Bash können Sie Funktionen im Hintergrund ausführen, indem Sie den Befehl & am Ende der Befehlszeile verwenden 
# oder die &-Notation innerhalb der Funktion selbst anwenden. Hier sind zwei Möglichkeiten:

# Funktion, die im Hintergrund läuft
background_function() {
    TEXT=$1
    sleep 10
    echo "$TEXT"
}

innerhalb_function() {
    background_function "Hintergrundfunktion innerhalb, abgeschlossen" &
}

# Methode 1: Verwenden des & am Ende der Befehlszeile

# Funktion im Hintergrund ausführen
background_function "Hintergrundfunktion 1, abgeschlossen" &

# Hauptprogramm
echo "Hauptprogramm 1, läuft weiter"

#Methode 2: Verwenden von & innerhalb der Funktion:

# Funktion im Hintergrund ausführen
#background_function "Hintergrundfunktion 2, abgeschlossen" &
innerhalb_function &
echo "Verwenden von & innerhalb der Funktion"

# Hauptprogramm
echo "Hauptprogramm 2, läuft weiter"

# Beachten Sie, dass das Hauptprogramm weiterläuft, während die Funktion im Hintergrund arbeitet. 
# Wenn Sie sicherstellen müssen, dass das Hauptprogramm auf das Ende der Hintergrundfunktion wartet, können Sie den Befehl wait verwenden:

# Funktion im Hintergrund ausführen
background_function "Hintergrundfunktion 3, abgeschlossen" &

# Warten auf das Ende der Hintergrundfunktion
wait

# Hauptprogramm
echo "Hauptprogramm läuft weiter bis zum Ende"

#Durch die Verwendung von wait wird das Hauptprogramm pausiert, bis alle Hintergrundprozesse beendet sind.
