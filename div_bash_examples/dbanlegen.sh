#!/bin/bash

# createdatabase DBNAME DBUSER DBPASSWD
function createdatabase(){
    # Übergabeparameter
    DBNAME=$1
    DBUSER=$2
    DBPASSWD=$3

    # Abbruch bei fehlender Parameterangabe.
    if [ "$DBNAME" = "" ]; then echo "Datenbankname fehlt"; exit 1; fi
    if [ "$DBUSER" = "" ]; then echo "Benutzername fehlt"; exit 1; fi
    if [ "$DBPASSWD" = "" ]; then echo "Datenbankpasswort fehlt"; exit 1; fi

    # Ausführung
    mysql -u "$DBUSER" -pDBPASSWD <<EOF
CREATE DATABASE ${DBNAME};
USE ${DBNAME};
EOF
    # Dadurch, dass der MySQL-Client im nicht-interaktiven Modus ausgeführt wird, 
    # kannst du die quit-Anweisung am Ende weglassen.
    return 0
}

# createdbuser ROOTUSER ROOTPASSWD NEWDBUSER NEWDBPASSWD
# ROOTPASSWD ist optional.
function createdbuser(){
    # Übergabeparameter
    ROOTUSER=$1
    ROOTPASSWD=$2
    NEWDBUSER=$3
    NEWDBPASSWD=$4


    # Abbruch bei fehlender Parameterangabe.
    if [ "$ROOTUSER" = "" ]; then echo "Root Datenbankbenutzername fehlt"; exit 1; fi
    if [ "$ROOTPASSWD" = "" ]; then echo "Root Datenbankpasswort fehlt"; exit 1; fi
    if [ "$NEWDBUSER" = "" ]; then echo "Neuer Benutzername fehlt"; exit 1; fi
    if [ "$NEWDBPASSWD" = "" ]; then echo "Neues Datenbankpasswort fehlt"; exit 1; fi
    

    # Ausführung
    mysql -u "$ROOTUSER" -pROOTPASSWD <<EOF
CREATE USER "${NEWDBUSER}"@"localhost" IDENTIFIED BY "${NEWDBPASSWD}";
GRANT ALL ON *.* to "${NEWDBUSER}"@"localhost";
EOF
    # Dadurch, dass der MySQL-Client im nicht-interaktiven Modus ausgeführt wird, 
    # kannst du die quit-Anweisung am Ende weglassen.
    return 0
}
