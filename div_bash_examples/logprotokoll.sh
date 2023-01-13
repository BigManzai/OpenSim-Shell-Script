#!/bin/bash

TAGEEINGABE=$1

if dpkg-query -s logwatch 2>/dev/null | grep -q installed; then
    # Alle Aktionen mit logwatch
    
    # Einen Kurzbericht für den gestrigen Tag ausgeben:
    if [ "$TAGEEINGABE" = "gestern" ]; then logwatch --detail low --range yesterday; fi

    # Einen Kurzbericht für 7 Tage ausgeben:
    if [ "$TAGEEINGABE" = "woche" ]; then logwatch --detail low --range 'between 7 days ago and yesterday'; fi

    # Einen Kurzbericht für den aktuellen Tag ausgeben:
    if [ -z "$TAGEEINGABE" ]; then logwatch --detail low --range today; fi
else
	# Alle Aktionen ohne logwatch

    # Logwatch installieren und
    apt-get -y install logwatch    
    # einen Kurzbericht für den aktuellen Tag ausgeben:
    logwatch --detail low --range today
fi
