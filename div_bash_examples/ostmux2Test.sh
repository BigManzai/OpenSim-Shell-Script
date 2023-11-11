#!/bin/bash

# Wechsel ins OpenSim bin Verzeichnis
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

# Funktion zum Senden eines Befehls an OpenSim in tmux
send_command_to_opensim() {
  if pgrep -x "OpenSim.exe" > /dev/null; then
    tmux send-keys -t term:0 "$@" C-m
    echo "Befehl '$*' an OpenSim gesendet."
  else
    echo "Fehler: OpenSim ist nicht aktiv."
  fi
}

# Überprüfen, ob der erforderliche Parameter vorhanden ist
if [ "$#" -ne 1 ]; then
  echo "Verwendung: $0 <start|stop|restart|command>"
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
  command)
    # Der Befehl, den Sie senden möchten.
    # Beispiel: command 'show info'
    #send_command_to_opensim "$2"
    # Führe die Funktion mit den verbleibenden Argumenten aus
    send_command_to_opensim "$@"
    ;;
  *)
    echo "Ungültiger Parameter. Verwendung: $0 <start|stop|restart|command>"
    exit 1
    ;;
esac

exit 0
