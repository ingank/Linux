# Debian: Pakete suchen und deinstallieren

Mit Hilfe einer RegEx nach einem Paket suchen:
```
dpkg -l '*paketname*'
```
* die mit 'ii' markierten Pakete sind auf dem System installiert
* der Paketname steht direkt nach dem 'ii'

---

Zu welchem Paket gehört ein bestimmtes Programm?
```
dpkg-query -S bin/mcomp
# mtools: /usr/bin/mcomp
```
* das Programm `/usr/bin/mcomp` gehört zum Debian-Paket "mtools"

---

Ein Paket deinstallieren:
```
sudo apt remove paketname
```

---

Ein Paket und seine nicht mehr genutzten Abhängigkeiten deinstallieren:
```
sudo apt autoremove paketname
```

---
