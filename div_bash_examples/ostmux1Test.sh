#!/bin/bash

# Wechsel ins OpenSim bin Verzeichnis oder beenden falls nicht vorhanden
cd /home/maria/opensim/bin || exit

# Funktion zum Starten von OpenSimulator
start_opensim() {
  tmux new-session -d -s term -n OpenSim 'env LANG=C mono OpenSim.exe'
  echo "OpenSim wurde gestartet."
}

# Funktion zum Stoppen von OpenSimulator
stop_opensim() {
  tmux kill-session -t term
  echo "OpenSim wurde gestoppt."
}

# Funktion zum Neustarten von OpenSimulator
restart_opensim() {
  stop_opensim
  sleep 5 # Optional: kurze Verzögerung für den ordnungsgemäßen Abschluss
  start_opensim
}

# Überprüfen, ob der erforderliche Parameter vorhanden ist
if [ "$#" -ne 1 ]; then
  echo "Verwendung: $0 <start|stop|restart>"
  exit 1
fi

# Parameter zuweisen
action=$1

# Aktion basierend auf dem Parameter ausführen
case $action in
  start)
    start_opensim
    ;;
  stop)
    stop_opensim
    ;;
  restart)
    restart_opensim
    ;;
  *)
    echo "Ungültiger Parameter. Verwendung: $0 <start|stop|restart>"
    exit 1
    ;;
esac

exit 0
