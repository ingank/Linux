# Befehlszeilenparameter in Skripten
Die Übergabe von Parametern an Terminal-Skripte
kann deren Flexibilität steigern.
## Einfache Auswertung von Argumenten
```
#!/bin/bash
# Die ersten drei Argumente der Kommandozeile ausgeben
echo $1
echo $2
echo $3

---

./script Eins Zwei Drei
Eins
Zwei
Drei
```
```
#!/bin/bash
# Die Variable $* (Argumente in Zeichenkette zusammenfassen)
echo $*

---

./script Das      sind   ein   paar            Argumente
Das sind ein paar Argumente
```
```
#!/bin/bash
# Alle Argumente in einer Zeichenkette zusammenfassen
# und danach wieder in einzelne Werte splitten
for i in $*
    do
        echo $i
    done

---

./script Das      sind   ein   paar            Argumente
Das
sind
ein
paar
Argumente
```
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

---

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
