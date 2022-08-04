#!/bin/bash

### DATEIABSTAND:

### doppeltes Leerzeichen in einer Datei
function doppeltes_leerzeichen1() {
   sed G
}

### doppeltes Leerzeichen bei einer Datei, die bereits Leerzeilen enthaelt. 
# Ausgabedatei sollte nicht mehr als eine Leerzeile zwischen Textzeilen enthalten.
function doppeltes_leerzeichen2() {
   sed '/^$/d;G'
}
 
### Dreifaches Leerzeichen in einer Datei
function dreifaches_leerzeichen() {
   sed 'G;G'
}
 
### doppelten Zeilenabstand rueckgaengig machen (vorausgesetzt, Zeilen mit gerader Zahl sind immer leer)
function doppelten_zeilenabstand_back() {
   sed 'n;d'
}

### Fuege eine Leerzeile ueber jeder Zeile ein, die auf "regex" passt
function leerzeile_jede_zeile() {
   sed '/regex/{x;p;x;}'
}

### Fuegen Sie eine Leerzeile unter jeder Zeile ein, die auf "regex" passt 
function leerzeile_jede_zeile() {
   sed '/regex/G'
}

### Fuegen Sie eine Leerzeile ueber und unter jeder Zeile ein, die auf "regex" passt
function leerzeile_ueber_und_unter() {
   sed '/regex/{x;p;x;G;}'
}

### NUMMERIERUNG:

### Jede Zeile einer Datei nummerieren (einfache Linksausrichtung). 
# ueber eine Registerkarte (vgl Hinweis auf '\t' am Ende der Datei) 
# anstelle von Leerzeichen behaelt die Raender bei.
function datei_nummerieren_einfach_links() {
   sed=$(filename | sed 'N;s/\n/\t/')
}

### jede Zeile einer Datei nummerieren (Nummer links, rechtsbuendig)
 echo "$sed"
function datei_nummerieren_einfach_rechts() {
   sed=$(filename | sed 'N; s/^/     /; s/ *\(.\{6,\}\)\n/\1  /')
}

### Jede Zeile der Datei nummerieren, aber nur Zahlen ausgeben, wenn die Zeile nicht leer ist
function jede_zeile_nummerieren_nur_zahlen() {
   sed '/./=' filename | sed '/./N; s/\n/ /'
}

### Zeilen zaehlen (emuliert "wc -l")
function zeilen_zaehlen() {
   sed -n '$='
}

###TEXTKONVERTIERUNG UND ERSATZ:

### IN UNIX-UMGEBUNG: Konvertieren Sie DOS-Zeilenumbrueche (CR/LF) in das Unix-Format.
 #sed 's/.$//'              ### geht davon aus, dass alle Zeilen mit CR/LF enden
 #sed 's/^M$//'             ### Druecken Sie in bash/tcsh Strg-V und dann Strg-M
 #sed 's/\x0D$//'           ### Druecken Sie in bash/tcsh Strg-V und dann Strg-M

### IN UNIX-UMGEBUNG: Konvertieren Sie Unix-Zeilenumbrueche (LF) in das DOS-Format.
 #sed "s/$/'echo -e \\\r'/"           ### Kommandozeile unter ksh
 #sed 's/$'"/'echo \\\r'/"            ### Kommandozeile unter bash
 #sed "s/$/'echo \\\r'/"              ### Kommandozeile unter zsh
 #sed 's/$/\r/'                       ### Kommandozeile unter zsh

### IN DOS-UMGEBUNG: Konvertieren Sie Unix-Zeilenumbrueche (LF) in das DOS-Format.
 #sed "s/$//"                         ### Methode 1
 #sed -n p                            ### Methode 2

### IN DOS-UMGEBUNG: Konvertieren Sie DOS-Zeilenumbrueche (CR/LF) in das Unix-Format.
### Kann nur mit UnxUtils sed, Version 4.0.7 oder hoeher durchgefuehrt werden. Das
### UnxUtils-Version kann durch den benutzerdefinierten "--text"-Schalter identifiziert werden
 #, das erscheint, wenn Sie den "--help"-Schalter verwenden. Ansonsten wechseln
### DOS-Zeilenumbrueche zu Unix-Zeilenumbruechen koennen nicht mit sed in einem DOS ausgefuehrt werden
### Umgebung. Verwenden Sie stattdessen "tr".
 #sed "s/\r//" infile >outfile        ### UnxUtils sed v4.0.7 oder hoeher
 #tr -d r <infile >outfile            ### GNU tr Version 1.22 oder hoeher

### Fuehrende Leerzeichen (Leerzeichen, Tabulatoren) vor jeder Zeile loeschen
### richtet den gesamten Text linksbuendig aus
function Leerzeichen_vor_jeder_zeile_del() {
  ### siehe Hinweis zu '\t' am Ende der Datei
   sed 's/^[ \t]*//'
}

### Leerzeichen (Leerzeichen, Tabulatoren) am Ende jeder Zeile loeschen
function Leerzeichen_ende_jeder_zeile_del() {
  ### siehe Hinweis zu '\t' am Ende der Datei
   sed 's/[ \t]*$//'
}

### Loescht sowohl fuehrende als auch nachfolgende Leerzeichen aus jeder Zeile
function fuehrende_als_auch_nachfolgende_leerzeichen_del() {
   sed 's/^[ \t]*//;s/[ \t]*$//'                    
} 

### am Anfang jeder Zeile 5 Leerzeichen einfuegen (Seitenversatz machen)
function anfang_5_leerzeichen_einfuegen() {
   sed 's/^/     /'
}

### Richten Sie den gesamten Text rechtsbuendig auf einer Breite von 79 Spalten aus
function rechtsbuendig_ausrichten() {
  ### auf 78 plus 1 Leerzeichen gesetzt
   sed -e :a -e 's/^.\{1,78\}$/ &/;ta'
}   

### Zentrieren Sie den gesamten Text in der Mitte der 79-Spalten-Breite. Bei Methode 1
### Leerzeichen am Anfang der Zeile sind signifikant und nachgestellt
### Leerzeichen werden am Ende der Zeile angehaengt. In Methode 2 Leerzeichen bei
### der Zeilenanfang wird beim Zentrieren der Zeile verworfen, und
### Am Zeilenende erscheinen keine nachgestellten Leerzeichen.

### Zentrieren Sie den gesamten Text in der Mitte. Methode 1
function zentrieren_m1() {
  ### Methode 1
   sed  -e :a -e 's/^.\{1,77\}$/ & /;ta'
}
### Zentrieren Sie den gesamten Text in der Mitte. Methode 2
function zentrieren_m2() {
  ### Methode 2
   sed  -e :a -e 's/^.\{1,77\}$/ &/;ta' -e 's/\( *\)\1/\1/'
}

### "foo" in jeder Zeile durch "bar" ersetzen (suchen und ersetzen).
 function suchen_ersetzen1() {
  ### "foo" in jeder Zeile durch "bar" ersetzen (suchen und ersetzen).
  ### ersetzt nur die erste Instanz in einer Zeile
   #sed 's/foo/bar/'
   suchen=$1; ersetzen=$2;
   sed "s/$suchen/$ersetzen/"
}
function suchen_ersetzen2() {
  ### "foo" in jeder Zeile durch "bar" ersetzen (suchen und ersetzen).
  ### ersetzt nur die erste Instanz in einer Zeile
  ### ersetzt nur die vierte Instanz in einer Zeile
   #sed 's/foo/bar/4'
   suchen=$1; ersetzen=$2; instanz=$3;
   sed "s/$suchen/$ersetzen/$instanz"
}
function suchen_ersetzen3() {
  ### ersetzt ALLE Instanzen in einer Zeile
   #sed 's/foo/bar/g'
   suchen=$1; ersetzen=$2
   sed "s/$suchen/$ersetzen/g"
}
function suchen_ersetzen4() {
  ### ersetzt den vorletzten Fall
   #sed 's/\(.*\)foo\(.*foo\)/\1bar\2/'
   suchen=$1; ersetzen=$2;
   sed "s/\(.*\)$suchen\(.*$suchen\)/\1$ersetzen\2/"
}
function suchen_ersetzen5() {
  ### nur den letzten Fall ersetzen
   #sed 's/\(.*\)foo/\1bar/'
   suchen=$1; ersetzen=$2;
   sed "s/\(.*\)$suchen/\1$ersetzen/"
}

### „foo“ durch „bar“ ersetzen, NUR fuer Zeilen, die „baz“ enthalten
function suchen_ersetzen6() {
   suchen=$1; ersetzen=$2; ausser=$3;
   #sed '/baz/s/foo/bar/g'
   sed "/$ausser/s/$suchen/$ersetzen/g"
}

### „foo“ durch „bar“ ersetzen, AUSSER fuer Zeilen, die „baz“ enthalten
function suchen_ersetzen7() {
   suchen=$1; ersetzen=$2; ausser=$3;
   #sed '/baz/!s/foo/bar/g'
   sed "/$ausser/!s/$suchen/$ersetzen/g"

}

### "scarlet" oder "ruby" oder "puce" in "red" aendern 
function sworte_aendern1() {
   sed 's/scarlet/red/g;s/ruby/red/g;s/puce/red/g'  ### die meisten seds
}

function sworte_aendern2() {
   gsed 's/scarlet\|ruby\|puce/red/g'               ### Nur GNU sed
}

### umgekehrte Zeilenreihenfolge (emuliert "tac")
# Bug/Feature in HHsed v1.5 bewirkt, dass Leerzeilen geloescht werden
 function umgekehrte_Zeilenreihenfolge1() {
    sed '1!G;h;$!d'              ### Methode 1
}

 function umgekehrte_Zeilenreihenfolge2() {
   sed -n '1!G;h;$p'            ### Methode 2
}

### jedes Zeichen in der Zeile umkehren (emuliert "rev")
 function Zeile_umkehren() {
   sed '/\n/!G;s/\(.\)\(.*\n\)/&\2\1/;//D;s/.//'
}

### Linienpaare nebeneinander verbinden (wie "paste") 
function nebeneinander_verbinden() {
   sed '$!N;s/\n/ /'
}

### Wenn eine Zeile mit einem Backslash endet, haenge die naechste Zeile daran an
function Zeile_Backslash_endet() {
   sed -e :a -e '/\\$/N; s/\\\n//; ta'
}

### Wenn eine Zeile mit einem Gleichheitszeichen beginnt, 
# wird es an die vorherige Zeile angehaengt
# und ersetzen Sie das "=" durch ein einzelnes Leerzeichen
function Wenn_eine_Zeile() {
   sed -e :a -e '$!N;s/\n=/ /;ta' -e 'P;D'
}

### Kommas zu numerischen Zeichenfolgen hinzufuegen und "1234567" in "1.234.567" aendern 
function Kommas_zu_numerischen1() {
  ### GNU sed
   gsed ':a;s/\B[0-9]\{3\}\>/,&/;ta'
}

function Kommas_zu_numerischen2() {
  ### andere seds
   sed -e :a -e 's/\(.*[0-9]\)\([0-9]\{3\}\)/\1,\2/;ta'
}

### Kommas zu Zahlen mit Dezimalpunkten und Minuszeichen hinzufuegen (GNU sed) 
function Kommas_zu_DeziZahlen() {
   gsed -r ':a;s/(^|[^0-9.])([0-9]+)([0-9]{3})/\1\2,\3/g;ta'
}

### fuege alle 5 Zeilen eine Leerzeile hinzu (nach den Zeilen 5, 10, 15, 20 usw.)
function 5Zeilen_eine_Leerzeile1() {
  ### Nur GNU sed
   gsed '0~5G'
}
function 5Zeilen_eine_Leerzeile2() {
  ### andere seds
   sed 'n;n;n;n;G;'
}

##SELEKTIVER DRUCK BESTIMMTER LINIEN:

### die ersten 10 Zeilen der Datei drucken (emuliert das Verhalten von "head")
function 10Zeilen_drucken() {
   sed 10q
}

### Erste Zeile der Datei drucken (emuliert "head -1")
function Erste_Zeile_drucken() {
   sed q
}

### die letzten 10 Zeilen einer Datei ausgeben (emuliert "tail")
function letzten10Zeilen_ausgeben() {
   q=$1; D=$2;
   sed -e :a -e "$q;N;11,$D;ba"
}

### die letzten 2 Zeilen einer Datei ausgeben (emuliert "tail -2")
function letzten2Zeilen() {
   sed '$!N;$!D'
}

### die letzte Zeile einer Datei ausgeben (emuliert "tail -1")
function letzteZeile1() {
  ### Methode 1
   sed '$!d'
}
function letzteZeile2() {
  ### Methode 2
   sed -n '$p'
}

### die vorletzte Zeile einer Datei ausgeben
function vorletzteZeile1() {
   sed -e '$!{h;d;}' -e x             ### fuer 1-zeilige Dateien, drucke eine Leerzeile
}
function vorletzteZeile2() {
   sed -e "1{$q;}" -e "$!{h;d;}" -e x ### fuer 1-zeilige Dateien, drucke die Zeile
}
function vorletzteZeile3() {
   sed -e '1{$d;}' -e '$!{h;d;}' -e x ### fuer 1-zeilige Dateien, drucke nichts
}
### Nur Zeilen ausgeben, die mit regulaeren Ausdruecken uebereinstimmen (emuliert "grep")
function regulaerenAusdruecken1() {
   sed -n '/regexp/p'          ### Methode 1
}
function regulaerenAusdruecken2() {
   sed '/regexp/!d'            ### Methode 2
}
### Nur Zeilen ausgeben, die NICHT mit Regexp uebereinstimmen (emuliert "grep -v")
function NichtRegexpUebereinstimmen1() {
   sed -n '/regexp/!p'         ### Methode 1, entspricht oben
}
function NichtRegexpUebereinstimmen() {
   sed '/regexp/d'             ### Methode 2, einfachere Syntax
}

### die Zeile direkt vor einem regulaeren Ausdruck ausgeben, aber nicht die Zeile
# enthaelt den regulaeren Ausdruck
function VorRegulaerenAusdruck() {
   sed -n '/regexp/{g;1!p;};h'
}

### die Zeile direkt nach einem regulaeren Ausdruck ausgeben, aber nicht die Zeile
### enthaelt den regulaeren Ausdruck
function NachRegulaerenAusdruck() {
   sed -n '/regexp/{n;p;}'
}

### drucke 1 Kontextzeile vor und nach regexp, mit Zeilennummer
### gibt an, wo der regulaere Ausdruck aufgetreten ist (aehnlich wie "grep -A1 -B1")
function drucke1Kontextzeile() {
   sed -n -e '/regexp/{=;x;1!p;g;$!N;p;D;}' -e h
}

### grep fuer AAA und BBB und CCC (in beliebiger Reihenfolge)
function abcBeliebig() {
   sed '/AAA/!d; /BBB/!d; /CCC/!d'
}

### grep fuer AAA und BBB und CCC (in dieser Reihenfolge)
function abcReihenfolge() {
   sed '/AAA.*BBB.*CCC/!d'
}

### grep fuer AAA oder BBB oder CCC (emuliert „egrep“)
function abcEmuliert1() {
   sed -e '/AAA/b' -e '/BBB/b' -e '/CCC/b' -e d   ### die meisten seds
}
function abcEmuliert2() {
   gsed '/AAA\|BBB\|CCC/!d'                       ### Nur GNU sed
}
### Absatz drucken, wenn er AAA enthaelt (Leerzeilen trennen Absaetze)
# HHsed v1.5 muss ein 'G;' einfuegen nach 'x;' in den naechsten 3 Skripten unten
function AbsatzDrucken1() {
   sed -e '/./{H;$!d;}' -e 'x;/AAA/!d;'
}

### Absatz drucken, wenn er AAA und BBB und CCC enthaelt (in beliebiger Reihenfolge)
function AbsatzDrucken2() {
   sed -e '/./{H;$!d;}' -e 'x;/AAA/!d;/BBB/!d;/CCC/!d'
}

### Absatz drucken, wenn er AAA oder BBB oder CCC enthaelt
function AbsatzDrucken3() {
   sed -e '/./{H;$!d;}' -e 'x;/AAA/b' -e '/BBB/b' -e '/CCC/b' -e d
}
function AbsatzDrucken4() {
   gsed '/./{H;$!d;};x;/AAA\|BBB\|CCC/b;d'        ### Nur GNU sed
}

### Nur Zeilen mit 65 Zeichen oder mehr drucken
function 65ZeicheDrucken() {
   sed -n '/^.\{65\}/p'
}

### Nur Zeilen mit weniger als 65 Zeichen drucken
function weniger65ZeichenDrucken1() {
   sed -n '/^.\{65\}/!p'       ### Methode 1, entspricht oben
}
function weniger65ZeichenDrucken2() {
   sed '/^.\{65\}/d'           ### Methode 2, einfachere Syntax
}
### Abschnitt der Datei vom regulaeren Ausdruck bis zum Ende der Datei drucken
function AusdruckBisEnde() {
   sed -n '/regexp/,$p'
}

### Abschnitt der Datei basierend auf Zeilennummern drucken (Zeile 8-12, einschliesslich)
function ZeilennummernDrucken1() {
   sed -n '8,12p'              ### Methode 1
}
function ZeilennummernDrucken2() {
   sed '8,12!d'                ### Methode 2
}
### Zeile Nummer 52 drucken
function Zeile52Drucken1() {
   sed -n '52p'                ### Methode 1
}
function Zeile52Drucken2() {
   sed '52!d'                  ### Methode 2
}
function Zeile52Drucken3() {
   sed '52q;d'                 ### method 3, efficient on large files
}

### ab Zeile 3 jede 7. Zeile drucken

function Zeile3jede7ZeileDrucken1() {
   gsed -n '3~7p'              ### Nur GNU sed
}
function Zeile3jede7ZeileDrucken2() {
   # andere seds
   #sed -n '3,${p;n;n;n;n;n;n;}'
   sed -n "3,$(p;n;n;n;n;n;n;)"
}

### Abschnitt der Datei zwischen zwei regulaeren Ausdruecken (einschliesslich) drucken
function zwischenzweiregulaeren() {
   suchen=$1; ersetzen=$2;
   #sed -n '/Iowa/,/Montana/p'             ### Gross-/Kleinschreibung beachten
   sed -n "/$suchen/,/$ersetzen/p"
}

##SELEKTIVE LoeSCHUNG BESTIMMTER ZEILEN:

### Drucke die gesamte Datei AUSSER dem Abschnitt zwischen 2 regulaeren Ausdruecken
function AUSSERdemAbschnitt() {
   suchen=$1; ersetzen=$2;
   #sed '/Iowa/,/Montana/d'
   sed "/$suchen/,/$ersetzen/d"
}

### doppelte, aufeinanderfolgende Zeilen aus einer Datei loeschen (emuliert "uniq").
### Die erste Zeile in einem Satz doppelter Zeilen wird beibehalten, der Rest wird geloescht.
function doppelteaufeinanderfolgendeZeilen() {
   sed '$!N; /^\(.*\)\n\1$/!P; D'
}

### doppelte, nicht aufeinanderfolgende Zeilen aus einer Datei loeschen. Hueten Sie sich davor
### ueberlauf der Puffergroesse des Haltebereichs, oder verwenden Sie andernfalls GNU sed.
function doppeltenichtaufeinanderfolgendeZeilen() {
   sed -n 'G; s/\n/&&/; /^\([ -~]*\n\).*\n\1/d; s/\n//; h; P'
}

### alle Zeilen ausser doppelten Zeilen loeschen (emuliert "uniq -d").
function alleZeilenausserdoppeltenZeilenloeschen() {
   sed '$!N; s/^\(.*\)\n\1$/\1/; t; D'
}

### die ersten 10 Zeilen einer Datei loeschen
function dieersten10Zeilenloeschen() {
   sed '1,10d'
}

### die letzte Zeile einer Datei loeschen
function letzteZeileloeschen() {
   sed '$d'
}

### die letzten 2 Zeilen einer Datei loeschen
function letzten2Zeilenloeschen() {
   sed 'N;$!P;$!D;$d'
}

### die letzten 10 Zeilen einer Datei loeschen
function letzten10Zeilenloeschen1() {
   sed -e :a -e '$d;N;2,10ba' -e 'P;D'  ### Methode 1
}
function letzten10Zeilenloeschen2() {
   sed -n -e :a -e '1,10!{P;N;D;};N;ba' ### Methode 2
}

### jede 8. Zeile loeschen
function jede8Zeileloeschen1() {
   gsed '0~8d'                          ### Nur GNU sed
}
function jede8Zeileloeschen2() {
   sed 'n;n;n;n;n;n;n;d;'               ### andere seds
}

### Zeilen loeschen, die dem Muster entsprechen
function ZeilenLoeschenNachMuster() {
   pattern=$1
   #sed '/pattern/d'
   sed "/$pattern/d"
}

### ALLE Leerzeilen aus einer Datei loeschen (wie "grep '.' ")
function LeerzeilenausDateiloeschen1() {
   sed '/^$/d'                          ### Methode 1
}
function LeerzeilenausDateiloeschen2() {
   sed '/./!d'                          ### Methode 2
}

### alle aufeinanderfolgenden Leerzeilen ausser der ersten aus der Datei loeschen; Auch
### loescht alle Leerzeilen am Anfang und Ende der Datei (emuliert "cat -s")
function LeerzeilenausserersteausDateiloeschen1() {
   sed '/./,/^$/!d'         ### Methode 1, erlaubt 0 Leerzeichen oben, 1 bei EOF
}
function LeerzeilenausserersteausDateiloeschen2() {
   sed '/^$/N;/\n$/D'       ### Methode 2, erlaubt 1 Leerzeichen oben, 0 bei EOF
}

### loesche alle AUFEINANDERFOLGENDEN Leerzeilen aus der Datei ausser den ersten 2:
function AUFEINANDERFOLGENDENLeerzeilenloeschen() {
   sed '/^$/N;/\n$/N;//D'
}

### Alle fuehrenden Leerzeilen am Anfang der Datei loeschen
function fuehrendenLeerzeilenamAnfangderDateiloeschen() {
   sed '/./,$!d'
}

### Alle abschliessenden Leerzeilen am Dateiende loeschen
function beispiel1() {
   sed -e :a -e '/^\n*$/{$d;N;ba' -e '}' ### funktioniert auf allen seds
}
function beispiel2() {
   sed -e :a -e '/^\n*$/N;/\n$/ba'       ### dito, ausser fuer gsed 3.02.*
}

### die letzte Zeile jedes Absatzes loeschen
function beispiel3() {
   sed -n '/^$/{p;h;};/./{x;/./p;}'
}

##SPEZIELLE ANWENDUNGEN:

### Entferne nroff-ueberstreichungen (char, backspace) von Manpages. Das Echo'
### Der Befehl benoetigt moeglicherweise einen Schalter -e, wenn Sie Unix System V oder die Bash-Shell verwenden.
function beispiel4() {
   sed "s/.echo \\\b//g"   ### doppelte Anfuehrungszeichen fuer Unix-Umgebung erforderlich
}
function beispiel5() {
   sed 's/.^H//g'            ### in bash/tcsh, druecken Sie Strg-V und dann Strg-H
}
function beispiel6() {
   sed 's/.\x08//g'          ### Hex-Ausdruck fuer sed 1.5, GNU sed, ssed
}

### Kopfzeile der Usenet-/E-Mail-Nachricht abrufen
function beispiel7() {
   sed '/^$/q'               ### loescht alles nach der ersten Leerzeile
}

### Usenet-/E-Mail-Nachrichtentext abrufen
function beispiel8() {
   sed '1,/^$/d'             ### loescht alles bis zur ersten Leerzeile
}

### Betreff-Header abrufen, aber den anfaenglichen "Betreff: "-Teil entfernen
function beispiel9() {
   sed '/^Subject: */!d; s///;q'
}

### Header der Ruecksendeadresse abrufen
function beispiel10() {
   sed '/^Reply-To:/q; /^From:/h; /./d;g;q'
}

### parse die richtige Adresse. Zieht die E-Mail-Adresse von selbst heraus
### aus dem 1-zeiligen Absenderadressen-Header (siehe vorheriges Skript)
function beispiel11() {
   sed 's/ *(.*)//; s/>.*//; s/.*[:<] *//'
}

### Fuegen Sie jeder Zeile eine fuehrende spitze Klammer und ein Leerzeichen hinzu (Zitat einer Nachricht)
function beispiel12() {
   sed 's/^/> /'
}

### Fuehrende spitze Klammer und Leerzeichen aus jeder Zeile loeschen (Zitat einer Nachricht aufheben)
function beispiel13() {
   sed 's/^> //'
}

### entfernt die meisten HTML-Tags (ermoeglicht mehrzeilige Tags)
function beispiel14() {
   sed -e :a -e 's/<[^>]*>//g;/</N;//ba'
}

### Mehrteilige uu-codierte Binaerdateien extrahieren und ueberfluessige Header entfernen
### info, sodass nur der uuencodierte Teil uebrig bleibt. Dateien uebergeben an
### sed muss in der richtigen Reihenfolge uebergeben werden. Version 1 kann eingegeben werden
### von der Kommandozeile; Version 2 kann in eine ausfuehrbare Datei umgewandelt werden
### Unix-Shell-Skript. (Modifiziert nach einem Drehbuch von Rahul Dhesi.)

function beispiel15() {
   sed '/^end/,/^begin/d' file1 file2 ... fileX | uudecode  ### vers. 1
}
function beispiel16() {
   sed '/^end/,/^begin/d' "$@" | uudecode                   ### vers. 2
}

### Absaetze der Datei alphabetisch sortieren. Absaetze werden durch Leerzeichen getrennt
### Linien. GNU sed verwendet \v fuer vertikale Tabulatoren, oder jedes eindeutige Zeichen reicht aus.
function beispiel17() {
   sed '/./{H;d;};x;s/\n/={NL}=/g' file | sort | sed '1s/={NL}=//;s/={NL}=/\n/g'
}
function beispiel() {
   gsed '/./{H;d};x;y/\n/\v/' file | sort | sed '1s/\v//;y/\v/\n/'
}

### Jede .TXT-Datei einzeln komprimieren, die Quelldatei loeschen und
### Festlegen des Namens jeder .ZIP-Datei auf den Basisnamen der .TXT-Datei
### (unter DOS: der Schalter "dir /b" gibt blosse Dateinamen in Grossbuchstaben zurueck).
function beispiel18() {
   echo @echo off >zipup.bat
   dir /b ./*.txt | sed "s/^\(.*\)\.TXT/pkzip -mo \1 \1.TXT/" >>zipup.bat
}

# TYPISCHE VERWENDUNG: Sed nimmt einen oder mehrere Bearbeitungsbefehle und wendet alle an
# sie nacheinander zu jeder Eingabezeile. Nachdem alle Befehle haben
# an die erste Eingangsleitung angelegt wurde, wird diese Leitung ausgegeben und eine zweite
# Die Eingangsleitung wird zur Verarbeitung genommen und der Zyklus wiederholt sich. Das
# Die vorstehenden Beispiele gehen davon aus, dass die Eingabe von der Standardeingabe stammt
# Geraet (d. h. die Konsole, normalerweise ist dies eine Pipe-Eingabe). Eins oder
# Weitere Dateinamen koennen an die Befehlszeile angehaengt werden, wenn die Eingabe dies tut
# nicht von stdin kommen. Die Ausgabe wird an stdout (den Bildschirm) gesendet. Daher:
function beispiel19() {
   filename=$1
   cat < "$filename" | sed 10q       ### verwendet Piped Input
}
function beispiel20() {
   filename=$1
   sed '10q' "$filename"             ### gleicher Effekt, vermeidet ein nutzloses "cat"
}
function beispiel21() {
   filename=$1
   sed '10q' "$filename" > newfile   ### leitet die Ausgabe auf die Festplatte um
}

# Fuer zusaetzliche Syntaxanweisungen, einschliesslich der Methode zum Anwenden der Bearbeitung
# Befehle von einer Plattendatei statt von der Befehlszeile, konsultieren Sie "sed &
# awk, 2. Auflage“ von Dale Dougherty und Arnold Robbins (O’Reilly,
# 1997; http://www.ora.com), „UNIX Text Processing“ von Dale Dougherty
# und Tim O'Reilly (Hayden Books, 1987) oder die Tutorials von Mike Arst
# verteilt in U-SEDIT2.ZIP (viele Seiten). Um die Kraft voll auszuschoepfen
# von sed muss man "regulaere Ausdruecke" verstehen. Siehe dazu
# "Mastering Regular Expressions" von Jeffrey Friedl (O'Reilly, 1997).
# Die Handbuchseiten ("man") auf Unix-Systemen koennen hilfreich sein (versuchen Sie es mit "man
# sed", "man regexp" oder der Unterabschnitt ueber regulaere Ausdruecke in "man
# ed"), aber Handbuchseiten sind notorisch schwierig. Sie werden nicht beschrieben
# Bringen Sie Erstbenutzern die Verwendung von sed oder regexps bei, jedoch als Referenztext
# fuer diejenigen, die bereits mit diesen Tools vertraut sind.

# ZITATSYNTAX: Die vorangegangenen Beispiele verwenden einfache Anfuehrungszeichen ('...')
# anstelle von doppelten Anfuehrungszeichen ("..."), um Bearbeitungsbefehle einzuschliessen, da
# sed wird normalerweise auf einer Unix-Plattform verwendet. Einfache Anfuehrungszeichen verhindern die
# Unix-Shell vor der Interpretation des Dollarzeichens ($) und Backquotes
# (`...`), die von der Shell erweitert werden, wenn sie eingeschlossen sind
# Anfuehrungszeichen. Benutzer der "csh"-Shell und Derivate benoetigen ebenfalls
# das Ausrufezeichen (!) mit dem Backslash (also \!) zu zitieren
# Fuehren Sie die oben aufgefuehrten Beispiele ordnungsgemaess aus, sogar innerhalb einfacher Anfuehrungszeichen.
# Versionen von sed, die fuer DOS geschrieben wurden, erfordern ausnahmslos doppelte Anfuehrungszeichen
# ("...") anstelle von einfachen Anfuehrungszeichen, um Bearbeitungsbefehle einzuschliessen.

# VERWENDUNG VON „\t“ IN SED-SCHRIFTEN: Zur Verdeutlichung in der Dokumentation haben wir verwendet
# den Ausdruck '\t', um ein Tabulatorzeichen (0x09) in den Skripten anzugeben.
# Allerdings erkennen die meisten Versionen von sed die Abkuerzung '\t' nicht,
# Wenn Sie diese Skripte also ueber die Befehlszeile eingeben, sollten Sie druecken
# stattdessen die TAB-Taste. '\t' wird als regulaerer Ausdruck unterstuetzt
# Metazeichen in awk, perl und HHsed, sedmod und GNU sed v3.02.80.

# VERSIONEN VON SED: Versionen von sed unterscheiden sich, und einige geringfuegige Syntax
# Abwechslung ist zu erwarten. Insbesondere unterstuetzen die meisten nicht die
# Verwendung von Labels (:name) oder Verzweigungsanweisungen (b,t) innerhalb der Bearbeitung
# Befehle, ausser am Ende dieser Befehle. Wir haben die Syntax verwendet
# die fuer die meisten Benutzer von sed portierbar sein wird, obwohl die beliebte
# GNU-Versionen von sed erlauben eine praegnantere Syntax. Wenn der Leser sieht
# ein ziemlich langer Befehl wie dieser:
function beispiel22() {
   sed -e '/AAA/b' -e '/BBB/b' -e '/CCC/b' -e d
}

# Es ist ermutigend zu wissen, dass Sie es mit GNU sed reduzieren koennen auf:
function beispiel23() {
   sed '/AAA/b;/BBB/b;/CCC/b;d'     ### or even
}
function beispiel24() {
   sed '/AAA\|BBB\|CCC/b;d'
}

# Denken Sie ausserdem daran, dass zwar viele Versionen von sed einen Befehl akzeptieren
# wie "/one/ s/RE1/RE2/", einige erlauben NICHT "/one/! s/RE1/RE2/", was
# enthaelt Leerzeichen vor dem 's'. Lassen Sie das Leerzeichen weg, wenn Sie den Befehl eingeben.

# OPTIMIERUNG FueR GESCHWINDIGKEIT: Wenn die Ausfuehrungsgeschwindigkeit erhoeht werden muss (aufgrund von
# grosse Eingabedateien oder langsame Prozessoren oder Festplatten), die Substitution wird
# schneller ausgefuehrt werden, wenn vorher der "find"-Ausdruck angegeben wird
# Geben Sie die Anweisung "s/.../.../" ein. Daher:
function beispiel25() {
   sed 's/foo/bar/g' filename        ### Standard-Ersetzungsbefehl
}
function beispiel26() {
      sed '/foo/ s/foo/bar/g' filename  ### wird schneller ausgefuehrt
}
function beispiel27() {
   sed '/foo/ s//bar/g' filename     ### Abkuerzung fuer sed-Syntax
}

# Online-Zeilenauswahl oder -loeschung, bei der Sie nur Zeilen ausgeben muessen
# aus dem ersten Teil der Datei ein "quit"-Befehl (q) im Skript
# wird die Verarbeitungszeit fuer grosse Dateien drastisch reduzieren. Daher:
function beispiel28() {
sed -n '45,50p' filename          ### Zeilennummern drucken. 45-50 einer Datei
}
function beispiel29() {
   sed -n '51q;45,50p' filename      ### gleich, wird aber viel schneller ausgefuehrt
}

# Wenn Sie zusaetzliche Skripte beisteuern moechten oder wenn Sie Fehler finden
# in diesem Dokument senden Sie bitte eine E-Mail an den Compiler. Geben Sie die an
# Version von sed, die Sie verwendet haben, das Betriebssystem, fuer das es kompiliert wurde, und
# die Art des Problems. Um sich als Einzeiler zu qualifizieren, die Befehlszeile
# darf maximal 65 Zeichen lang sein. Verschiedene Skripte in dieser Datei wurden
# geschrieben oder beigetragen von:

#  Al Aab                  ### Gruender der „seders“-Liste
#  Edgar Allen             ### verschiedene
#  Yiorgos Adamopoulos     ### verschiedene
#  Dale Dougherty          ### Autor von „sed & awk“
#  Carlos Duarte           ### Autor von „mach es mit sed“
#  Eric Pement             ### Autor dieses Dokuments
#  Ken Pizzini             ### Autor von GNU sed v3.02
#  S.G. Ravenhall          ### grossartiges de-html-Skript
#  Greg Ubben              ### viele Beitraege & viel Hilfe
# -------------------------------------------------------------------------