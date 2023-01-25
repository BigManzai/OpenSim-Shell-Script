#!/bin/bash

### Dies ist als crudini ersatz gedacht 
## da crudini installiert werden muss 
## und keine Leerzeichen am Zeilenanfang akzeptiert.


#? Aufgaben:
# Sektion Name ändern
# Neue Sektion als erstes einfügen
# Neue Sektion einfügen nach Sektion List
# Neue Sektion als letzte anhängen

# Schlüssel ändern
# Wert ändern

# Listenwert an erster stelle einfügen
# Listenwert anhängen
# Listenwert nach Listenwert einfügen

# Kommentare: kommentieren und unkommentieren

#? Example.ini:
#! [Section Name]
# keyname1
# keyname2=value1
# keyname3 = value2
# keyname4="value3"
# keyname5 = "value4"
#     Space = 4
#   Tab = 1

#! [List]
# keyname1 = list_value1, list_value2, list_value3
# keyname2=list_value4, list_value5, list_value6 ;comment
# keyname3 = list_value7, list_value8, list_value9 ;comment
# keyname4 = list_value10|list_value11|list_valu12
#     keyname5 = "list_value13,list_value14,list_value15" ;comment
#   keyname6 = "list_value16|list_value17|list_value18"

#! [Comment]
# ;comment 1
# ; comment 2
# #comment 3
# # comment 4
# ;#comment 5
# ;# comment 6
#     ;##comment 7
#   ;## comment 8


# Kommentarzeichen und Leerzeichen
COMMENTR="\#"; COMMENTS="\;"; COMMENTSR="\;\#"; COMMENTSRR="\;\#\#"
COMMENTRSp="\#\ "; COMMENTSSp="\;\ "; COMMENTSRSp="\;\#\ "; COMMENTSRRSp="\;\#\#\ "
# Leerzeichen und Tabs
SPACES=4
TAB="\t"

#INIPATH="/opt/AutoConfig/Example.ini"

function silence_shellcheck()
{ echo "$COMMENTR"; echo "$COMMENTS"; echo "$COMMENTSR"; echo "$COMMENTSRR"; 
echo "$COMMENTRSp"; echo "$COMMENTSRSp"; echo "$COMMENTSRRSp"; echo "$SPACES"; echo "$TAB";}

echo "################### Anfang der Tests ########################"

# [SECTION]
# KEY=VALUE

#!##  Read value from [SECTION] KEY - Test 23.01.2023 OK.
function get_value2() {
SECTION=$1; 
KEY=$2; 
INIPATH=$3
sed -nr '/^\['"$SECTION"'\]/ { :l /^'"$KEY"'[ ]*=/ { s/[^=]*=[ ]*//; p; q;}; n; b l;}' "$INIPATH"
}
# Testing get_value2
#get_value2 "Section Name" keyname3 /opt/AutoConfig/Example.ini

#!##  Read value from [SECTION] KEY - Test 22.01.2023 OK.
# [section]
# ... key
function get_value1() {
    # Extrahiert alles hinter dem Gleichheitszeichen.    # Aufruf: get_value1 SECTION KEY INIPATH
    SECTION=$1
    KEY=$2
    INIPATH=$3
    sed -n '/^[ \t]*\['"$SECTION"'\]/,/\[/s/^[ \t]*'"$KEY"'[ \t]*=[ \t]*//p' "$INIPATH"
}
# Testing get_value1
#get_value1 "Section Name" keyname3 /opt/AutoConfig/Example.ini

#!## set_no_comment ### noch ohne Sektion
function set_no_comment() {
    echo "Test set_no_comment"
    COMMENTR="\#"; COMMENTS="\;"; COMMENTSR="\;\#"; COMMENTSRR="\;\#\#"
    COMMENTRSp="\#\ "; COMMENTSSp="\;\ "; COMMENTSRSp="\;\#\ "; COMMENTSRRSp="\;\#\#\ "

    KEY=$1
    COMMENT=$COMMENTSSp
    INIPATH=$2
    sed -i 's/'"$COMMENT$KEY"'/'"$KEY"'/g' "$INIPATH"
}
# Testing set_no_comment
#set_no_comment "keyname2=value1" "/opt/AutoConfig/Example.ini"

#!## set_comment ### noch ohne Sektion
function set_comment() {
    echo "Test set_comment"
    COMMENTR="\#"; COMMENTS="\;"; COMMENTSR="\;\#"; COMMENTSRR="\;\#\#"
    COMMENTRSp="\#\ "; COMMENTSSp="\;\ "; COMMENTSRSp="\;\#\ "; COMMENTSRRSp="\;\#\#\ ";

    KEY=$1
    COMMENT=$COMMENTSSp
    INIPATH=$2
    sed -i 's/'"$KEY"'/'"$COMMENT$KEY"'/g' "$INIPATH"
}
# Testing set_comment
#set_comment "keyname2=value1" "/opt/AutoConfig/Example.ini"

#!##
function get_comment() {
    echo "Test get_comment"
}

# [section]
# COMMENT key
#!##  Read Comment KEY from [SECTION] - Test 22.01.2023 OK.
function comment_key_section() {
    # Extrahiert alles hinter dem Gleichheitszeichen.    # Aufruf: comment_key_section SECTION KEY INIPATH
    COMMENT=$COMMENTSSp
    SECTION=$1
    KEY=$2
    INIPATH=$3
    sed -n '/^[ \t]*\['"$SECTION"'\]/,/\[/s/^[ \t]*'"$COMMENT"''"$KEY"'[ \t]*=[ \t]*//p' "$INIPATH"
}
# echo "comment_key_section:"
# comment_key_section "Section Name" "Section Name" "/opt/AutoConfig/Example.ini"

#!##
function set_ini_list() {
    echo "set Komma, Pipe, Space getrennte Liste"
}
#!##
function get_ini_list() {
    echo "get Komma, Pipe, Space getrennte Liste"
}
#!##
function add_ini_list() {
    echo "add Komma, Pipe, Space getrennte Liste"
}

#!##  List all [sections] of a .INI file - Test 22.01.2023 OK.
# [section1]
# [section2]
# [section3]
# ...
function list_all_sections() {
    # Listet alle Sektionen untereinander.    # Aufruf: list_all_sections INIPATH
    INIPATH=$1
    sed -n 's/^[ \t]*\[\(.*\)\].*/\1/p' "$INIPATH"
}
# echo "list_all_sections:"
# list_all_sections "/opt/AutoConfig/Example.ini"

#!##  Read all values from SECTION in a clean KEY=VALUE form - Test 22.01.2023 OK.
# [section]
# key = value
function read_values_section() {
    # Entfernt Leerzeichen.    # Aufruf: read_values_section SECTION INIPATH
    SECTION=$1
    INIPATH=$2
    sed -n '/^[ \t]*\['"$SECTION"'\]/,/\[/s/^[ \t]*\([^#; \t][^ \t=]*\).*=[ \t]*\(.*\)/\1=\2/p' "$INIPATH"
}
# echo "read_values_section:"
# read_values_section "Section Name" "/opt/AutoConfig/Example.ini"

#!##  Speichern einer Value Einstellung - Test 22.01.2023 OK.
# [section]
# key = value
function set_value() {
    SECTION=$1; KEY=$2; VALUE=$3; INIPATH=$4

    sed -i '/^\[[ \t]*'"$SECTION"'[ \t]*\]/,/^\[/s/^[ \t]*\('"$KEY"'[ \t]*=[ \t]*\)[^ \t;#]*/\1'"$VALUE"'/' "$INIPATH"
}

#!##  Speichern einer Value Einstellung - Test 22.01.2023 OK.
# [section]
# key = "value"
function set_value_marks() {
    SECTION=$1; KEY=$2; VALUE=$3; INIPATH=$4
    # "\"$Owner\""
    sed -i '/^\[[ \t]*'"$SECTION"'[ \t]*\]/,/^\[/s/^[ \t]*\('"$KEY"'[ \t]*=[ \t]*\)[^ \t;#]*/\1'"\"$VALUE\""'/' "$INIPATH"
}
#set_value_marks "Section Name" keyname3 "127.0.0.1" "/opt/AutoConfig/Example.ini"



# echo "#################### ENDE ################################"