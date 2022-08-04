#!/bin/bash

# xml mit grep
# grep -Po '(?<=<element name=")[^"]+' <file>
# oder
# grep -Po '<element name="\K[^"]+' <file>

ausgabeb30=""
ausgabeb31=""

function beispiel30() {
   datei=$2; # xml Datei
   name=$1; # xml Datei
   ausgabeb30=$(grep -Po '(?<=<'"$name"' name=")[^"]+' "$datei")
   echo "$ausgabeb30"
}

function beispiel31() {
   datei=$2; # xml Datei
   name=$1; # xml Datei
   ausgabeb31=$(grep -Po '<'"$name"' name="\K[^"]+' "$datei")
   echo "$ausgabeb31"
}

function beispielX() {
    echo ""
}

#beispiel30 "Reference" "/opt/config/prebuild.xml"
#beispiel31 "Reference" "/opt/config/prebuild.xml"
