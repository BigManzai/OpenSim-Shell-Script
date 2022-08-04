#!/bin/bash

### Compound-Vergleich

# -a 
# logisch und (and) 
# Aehnlich zu (&&)

# -o 
# logisch oder (or)
# Aehnlich zu ||


### Ganzzahliger Vergleich

# -eq ist gleich
# if [ "$a" -eq "$b" ]

# -ne
# ist ungleich zu
# if [ "$a" -ne "$b" ]

# -gt
# ist groesser als
# if [ "$a" -gt "$b" ]

# -ge
# groesser oder gleich ist
# if [ "$a" -ge "$b" ]

# -lt
# ist weniger als
# if [ "$a" -lt "$b" ]

# -le
# kleiner oder gleich ist
# if [ "$a" -le "$b" ]

# <
# ist weniger als
# (in doppelten Klammern)
# (("$a" < "$b"))

# <=
# kleiner oder gleich ist
# (in doppelten Klammern)
# (("$a" <= "$b"))

# >
# ist groesser als
# (in doppelten Klammern)
# (("$a" > "$b"))

# >=
# groesser oder gleich ist
# (in doppelten Klammern)
# (("$a" >= "$b"))

### String-Vergleich

# = 
# ist gleich

# ==
# Der Vergleichsoperator == verhaelt sich innerhalb eines Tests mit doppelten Klammern anders als innerhalb von einfachen Klammern.
# [[  $a  == z *  ]]    # Wahr, wenn $a mit einem "z" beginnt (Mustervergleich). 
# [[  $a  ==  "z*"  ]]  # Wahr, wenn $a gleich z* ist (Literaluebereinstimmung).

# [  $a  == z *  ]      # File Globbing und Word Splitting finden statt. 
# [  " $a "  ==  "z*"  ]  # Wahr, wenn $a gleich z* ist (Literaluebereinstimmung).

# !=
# ist ungleich zu
# if [ "$a" != "$b" ]
# Dieser Operator verwendet einen Mustervergleich innerhalb eines [[ ... ]]-Konstrukts.

# <
# ist kleiner als, in alphabetischer ASCII-Reihenfolge
# Beachten Sie, dass <innerhalb eines []-Konstrukts maskiert werden muss.
# if  [[  " $a " < " $b "  ]] 
# if  [  " $a "  \<  " $b "  ]

# >
# ist groesser als, in alphabetischer ASCII-Reihenfolge.
# Beachten Sie, dass >innerhalb eines []-Konstrukts maskiert werden muss.
# if  [[  " $a "  >  " $b "  ]] 
# if  [  " $a "  \>  " $b "  ]

# -z
# Zeichenfolge ist null
# das heisst, hat eine Laenge von Null
# wenn  [  -z  " $s "  ]

# -n	
# Zeichenfolge ist nicht null.
# wenn  [  -n  " ​​$s "  ]

### Dateitestoperatoren

# -e
# Datei existiert

# -a
# ist veraltet und von seiner Verwendung wird abgeraten.

# -f
# Datei ist eine normale Datei (kein Verzeichnis oder Geraetedatei)

# -d
# Datei ist ein Verzeichnis

# -h
# -L
# (-h und -L) Datei ist ein symbolischer Link

# -b
# Datei ist ein Blockgeraet

# -c
# Datei ist ein Zeichengeraet

# -p
# Datei ist eine Pipe

# -S
# Datei ist ein Socket

# -s
# Datei ist nicht null Groesse

# -t
# Datei (Deskriptor) ist einem Endgeraet zugeordnet
# Diese Testoption kann verwendet werden, um zu pruefen, ob das stdin [ -t 0 ]oder stdout [ -t 1 ]in einem gegebenen Skript ein Terminal ist.

# -r
# Datei hat Leseberechtigung (fuer den Benutzer, der den Test ausfuehrt)

# -w
# Datei hat Schreibrechte (fuer den Benutzer, der den Test durchfuehrt)

# -x
# Datei hat Ausfuehrungsberechtigung (fuer den Benutzer, der den Test ausfuehrt)

# -g
# set-group-id (sgid) Flag auf Datei oder Verzeichnis gesetzt

# -u
# set-user-id (suid) Flag in der Datei gesetzt

# -k
# Sticky-Bit-Set

# -O
# Sie sind Eigentuemer der Datei

# -G
# Gruppen-ID der Datei identisch mit Ihrer

# -N
# Datei seit dem letzten Lesen geaendert

# -nt
# Datei f1 ist neuer als f2

# if [ "$f1" -nt "$f2" ]

# -ot
# Datei f1 ist aelter als f2

# if [ "$f1" -ot "$f2" ]

# -ef
# Dateien f1 und f2 sind feste Links zu derselben Datei
# if [ "$f1" -ef "$f2" ]

# !
# "not" - kehrt den Sinn der obigen Tests um (gibt true zurueck, wenn die Bedingung nicht vorhanden ist).
