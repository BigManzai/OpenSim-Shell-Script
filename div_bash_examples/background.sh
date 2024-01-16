#!/bin/bash

# Funktion, die im Hintergrund läuft und ihren Status überwacht
background_function() {
    echo "Hintergrundfunktion gestartet"
    
    # Simulieren von Aktivität in der Funktion
    sleep 10
    
    echo "Hintergrundfunktion abgeschlossen"
}

# Funktion im Hintergrund starten und PID speichern
background_function &

# PID der letzten gestarteten Hintergrundfunktion abrufen
pid=$!

# Überwachungsschleife
while kill -0 "$pid" 2>/dev/null; do
    echo "Hintergrundfunktion läuft noch..."
    sleep 1
done

# Benachrichtigung über das Ende der Hintergrundfunktion
echo "Hintergrundfunktion beendet"
