# Debian: Von Hand installierte Pakete deinstallieren
Paket suchen:
```
dpkg -l '*paketname*'
```
Die mit 'ii' markierten Pakete sind auf dem System installiert.
Der Paketname steht direkt nach dem 'ii'.
Um nur das Paket zu deinstallieren:
```
sudo apt remove paketname
```
Um das Paket und seine nicht mehr genutzten Abhängigkeiten zu deinstallieren:
```
sudo apt autoremove paketname
```
