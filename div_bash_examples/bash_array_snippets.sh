#!/bin/bash

# /opt/bash_array_snippets.sh

#! So deklarieren Sie ein Array von Zeichenfolgen in einem Bash-Skript
#? Bash-Skripte bieten Ihnen eine bequeme Möglichkeit, Befehlszeilenaufgaben zu automatisieren.

# Mit Bash können Sie viele der Dinge tun, die Sie auch in anderen Skript- oder Programmiersprachen tun würden. 
# Sie können Variablen erstellen und verwenden, Schleifen ausführen, 
# bedingte Logik verwenden und Daten in Arrays speichern.

# Während die Funktionalität sehr vertraut sein mag, kann die Syntax von Bash knifflig sein. 
# In diesem Artikel erfahren Sie, wie Sie Arrays deklarieren und dann in Ihrem Code verwenden.

#! So deklarieren Sie ein Array in Bash

# Das Deklarieren eines Arrays in Bash ist einfach, aber achten Sie auf die Syntax. 
# Wenn Sie es gewohnt sind, in anderen Sprachen zu programmieren, kommt Ihnen der Code vielleicht bekannt vor, 
# aber es gibt feine Unterschiede, die leicht zu übersehen sind.

# Gehen Sie folgendermaßen vor, um Ihr Array zu deklarieren:

#     1.Geben Sie Ihrem Array einen Namen
#     2.Folgen Sie diesem Variablennamen mit einem Gleichheitszeichen. 
#           Das Gleichheitszeichen sollte keine Leerzeichen enthalten.
#     3.Schließen Sie das Array in Klammern ein (keine Klammern wie in JavaScript)
#     4.Geben Sie Ihre Zeichenfolgen in Anführungszeichen ein, aber ohne Kommas dazwischen

# Ihre Array-Deklaration sieht in etwa so aus:

myArray=("cat" "dog" "mouse" "frog")

# Das ist es! So einfach ist das.

#! So greifen Sie in Bash auf ein Array zu

# Es gibt verschiedene Möglichkeiten, Ihr Array zu durchlaufen. 
# Sie können entweder die Elemente selbst durchlaufen oder die Indizes durchlaufen.

#! Wie man Array-Elemente durchschleift

# Um die Array-Elemente zu durchlaufen, muss Ihr Code in etwa so aussehen:

for str in "${myArray[@]}"; do
  echo "$str"
done

# Um das aufzuschlüsseln: Das ist so etwas wie die Verwendung forEachin JavaScript. 
# Geben Sie für jeden String (str) im Array (myArray) diesen String aus.

# Die Ausgabe dieser Schleife sieht so aus:

#* cat
#* dog
#* mouse
#* frog

#? Hinweis : Das Symbol in den eckigen Klammern zeigt an, dass Sie alle Elemente im Array @durchlaufen . 
# Wenn Sie das weglassen und einfach schreiben würden, würde nur die erste Zeichenfolge im Array ausgegeben.
# for str in ${myArray}

#! So durchlaufen Sie Array-Indizes

# Alternativ können Sie die Indizes des Arrays durchlaufen. Dies ist wie eine forSchleife in JavaScript und nützlich, wenn Sie auf den Index jedes Elements zugreifen möchten.

# Um diese Methode zu verwenden, muss Ihr Code etwa wie folgt aussehen:

for i in "${!myArray[@]}"; do
  echo "element $i is ${myArray[$i]}"
done

# Die Ausgabe wird wie folgt aussehen:

#* element 0 is cat
#* element 1 is dog
#* element 2 is mouse
#* element 3 is frog

#? Hinweis : Das Ausrufezeichen am Anfang der myArray Variablen zeigt an, 
# dass Sie auf die Indizes des Arrays und nicht auf die Elemente selbst zugreifen. 
# Dies kann verwirrend sein, wenn Sie an das Ausrufezeichen gewöhnt sind, das eine Verneinung anzeigt, 
# achten Sie also genau darauf.

#? Noch ein Hinweis : Bash benötigt normalerweise keine geschweiften Klammern für Variablen, aber für Arrays. 
# Sie werden also feststellen, dass Sie beim Verweisen auf ein Array die Syntax ${myArray}verwenden, 
# aber wenn Sie auf einen String oder eine Zahl verweisen, verwenden Sie einfach ein Dollarzeichen: $i.

#! Fazit

# Bash-Skripte sind nützlich, um automatisiertes Befehlszeilenverhalten zu erstellen, 
# und Arrays sind ein großartiges Werkzeug, mit dem Sie mehrere Datenelemente speichern können.

# Sie zu deklarieren und zu verwenden ist nicht schwer, unterscheidet sich aber von anderen Sprachen, 
# also achten Sie genau darauf, Fehler zu vermeiden.

#! Cheatsheet zur Verwendung von Bash-Arrays

#! Erstellen

# leer
myArray=()

# mit Elementen
myArray=("first" "second" "third item" "fourth")

myArray=(
	"first"
	"second"
	"third item"
	"fourth"
)

#! Elemente erhalten

# alle Elemente - durch Leerzeichen getrennt
# shellcheck disable=SC2068
echo ${myArray[@]}

# alle Elemente - getrennte Wörter 
echo "${myArray[@]}"

# alle Elemente - einzelnes Wort, getrennt durch das erste Zeichen von IFS 
IFS="-"
echo "${myArray[*]}"

# spezifisches Element 
echo "${myArray[1]}"

# zwei Elemente, beginnend beim zweiten Element 
echo "${myArray[@]:1:2}"

# Schlüssel (Indizes) eines Arrays 
echo "${!myArray[@]}"

#! Element anhängen

myArray=()
myArray+=("item")

#! Array-Länge

# Elementanzahl
echo "${#myArray[@]}"

# Länge des spezifischen Elements (Stringlänge) 
echo "${#myArray[1]}"

#! Wiederholung

for arrayItem in "${myArray[@]}"; do
	echo "$arrayItem"
done

#! Array an Funktion übergeben

#? Hinweis: Benannte Referenz auf eine andere Variable ( local -n) wird nur mit Bash 4.3.xoder höher unterstützt.

function myFunction {
	local -n givenList=$1
	echo "${givenList[@]}"
}
# shellcheck disable=SC2034
itemList=("first" "second" "third")
myFunction itemList