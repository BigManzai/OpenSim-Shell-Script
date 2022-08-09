#!/bin/bash

# Eingabe Werte
echo "Geben sie eine Zahl fuer a ein:"; read -r a
echo "Geben sie eine Zahl fuer b ein:"; read -r b
# Standart Werte
if test -z "$a"; then a=1; fi
if test -z "$b"; then b=2; fi

f1="iffi.sh"
f2="sed_examples.sh"

### Compound-Vergleich

# -a 
# logisch und (and) 
# Aehnlich zu (&&)

# -o 
# logisch oder (or)
# Aehnlich zu ||


### Ganzzahliger Vergleich

# -eq ist gleich
if [ "$a" -eq "$b" ]; then echo "ist gleich"; fi

# -ne
# ist ungleich zu
if [ "$a" -ne "$b" ]; then echo "ist ungleich"; fi

# -gt
# ist groesser als
if [ "$a" -gt "$b" ]; then echo "ist groesser"; fi

# -ge
# groesser oder gleich
if [ "$a" -ge "$b" ]; then echo "groesser oder gleich"; fi

# -lt
# ist weniger als
if [ "$a" -lt "$b" ]; then echo "ist weniger als"; fi

# -le
# kleiner oder gleich
if [ "$a" -le "$b" ]; then echo "kleiner oder gleich"; fi

# <
# ist weniger als
# (in doppelten Klammern)
if (("$a" < "$b")); then echo "ist weniger als"; fi

# <=
# kleiner oder gleich ist
# (in doppelten Klammern)
if (("$a" <= "$b")); then echo "kleiner oder gleich"; fi

# >
# ist groesser als
# (in doppelten Klammern)
if (("$a" > "$b")); then echo "ist groesser als"; fi

# >=
# groesser oder gleich ist
# (in doppelten Klammern)
if (("$a" >= "$b")); then echo "groesser oder gleich"; fi

### String-Vergleich

# = 
# ist gleich

# ==
# Der Vergleichsoperator == verhaelt sich innerhalb eines Tests mit doppelten Klammern anders als innerhalb von einfachen Klammern.
if [[ $a == z* ]]; then echo " "; fi    # Wahr, wenn $a mit einem "z" beginnt (Mustervergleich). 
if [[ $a == "z*" ]]; then echo " "; fi  # Wahr, wenn $a gleich z* ist (Literaluebereinstimmung).

if [ $a == "z*" ]; then echo " "; fi      # File Globbing und Word Splitting finden statt. 
if [ "$a" == "z*" ]; then echo " "; fi  # Wahr, wenn $a gleich z* ist (Literaluebereinstimmung).

# !=
# ist ungleich zu
if [ "$a" != "$b" ]; then echo " "; fi
# Dieser Operator verwendet einen Mustervergleich innerhalb eines [[ ... ]]-Konstrukts.

# <
# ist kleiner als, in alphabetischer ASCII-Reihenfolge
# Beachten Sie, dass <innerhalb eines []-Konstrukts maskiert werden muss.
if  [[  " $a " < " $b "  ]] ; then echo " "; fi
if  [  " $a "  \<  " $b "  ]; then echo " "; fi

# >
# ist groesser als, in alphabetischer ASCII-Reihenfolge.
# Beachten Sie, dass >innerhalb eines []-Konstrukts maskiert werden muss.
if  [[  " $a "  >  " $b "  ]]; then echo " "; fi
if  [  " $a "  \>  " $b "  ]; then echo " "; fi

# -z
# Zeichenfolge ist null
# das heisst, hat eine Laenge von Null
if  [ -z "$s" ]; then echo " "; fi

# -n	
# Zeichenfolge ist nicht null.
if  [ -n  "$s" ]; then echo " "; fi

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
if [ "$f1" -nt "$f2" ]; then echo "Datei $f1 ist neuer als $f2"; fi

# -ot
# Datei f1 ist aelter als f2
if [ "$f1" -ot "$f2" ]; then echo "Datei $f1 ist aelter als $f2"; fi

# -ef
# Dateien f1 und f2 sind feste Links zu derselben Datei
if [ "$f1" -ef "$f2" ]; then echo "Dateien $f1 und $f2 sind feste Links zu derselben Datei"; fi

# !
# "not" - "nicht" kehrt den Sinn der obigen Tests um (gibt true zurueck, wenn die Bedingung nicht vorhanden ist).
