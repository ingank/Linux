# Befehlszeilenparameter in Skripten
Die Übergabe von Parametern an Terminal-Skripte
kann deren Flexibilität steigern.
## Einfache Auswertung von Argumenten

__Die ersten drei Argumente der Kommandozeile ausgeben__
```
#!/bin/bash
echo $1
echo $2
echo $3
```
```
./script Eins Zwei Drei
Eins
Zwei
Drei
```
__Mit der Variablen $* alle Argumente in einer Zeichenkette zusammenfassen__
```
#!/bin/bash
echo $*
```
```
./script Das      sind   ein   paar            Argumente
Das sind ein paar Argumente
```
__Alle Argumente in einer Zeichenkette zusammenfassen<br>
und danach wieder in einzelne Werte splitten__
```
#!/bin/bash

for i in $*
    do
        echo $i
    done
```
```
./script Das      sind   ein   paar            Argumente
Das
sind
ein
paar
Argumente
```
__Mit der Variablen $# die Argumente zählen__
```
#!/bin/bash
# Mit der Variablen $# die Argumente zählen
echo "Das sind $# Argumente"
if [ $# -lt 4 ]
    then
    echo "Es sind mindestens vier Argumente erforderlich"
    exit 1
fi
echo "Anzahl der Argumente ist ausreichend"
```
```
./script Das      paar           Argumente
Das sind 3 Argumente
Es sind mindestens vier Argumente erforderlich

./script Das      sind   ein   paar            Argumente
Das sind 5 Argumente
Anzahl der Argumente ist ausreichend
```
## Einfache Optionen auswerten
## Fortgeschrittene Parametrierung
https://stackoverflow.com/questions/402377/using-getopts-to-process-long-and-short-command-line-options/7948533
