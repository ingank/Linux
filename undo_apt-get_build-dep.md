# Installation von "apt-get build-dep" verwerfen

Nach einer versehentlichen automatischen Installation
von Abhängigkeiten zu einem Quellpaket unter Debian ist es eher nicht trivial,
diese Abhängigkeiten wieder zu entfernen.

## Fix

Folgende zwei Kommandos entfernen alle mittels *apt-get build-deb foo*
installierten Abhängigkeiten zum Quell-Paket *foo*.

**Beachte:** Diese Kommandos müssen als *privilegierter Benutzer* ausgeführt werden.

```
aptitude markauto $(apt-cache showsrc foo | sed -e '/Build-Depends/!d;s/Build-Depends: \|,\|([^)]*),*\|\[[^]]*\]//g')
apt-get autoremove
```

## Voraussetzungen
```
apt install aptitude
```

## Quellen

* http://www.webupd8.org/2010/10/undo-apt-get-build-dep-remove-build.html
