# Netzwerk-Sockets

## netstat
```
$ netstat --option
```
| Test | Test |
|------|------|
| Test | Test |

# hallo



| Option | Auswirkung |
|:-------|:-----------|
|`--inet`| IPv4 UDP/TCP Sockets zeigen|
|`--inet6`| IPv6 UDP/TCP Sockets zeigen|
|`--all` | Alle Statusarten ( HÖREND, VERBUNDEN, ... ) zeigen|
|`--listening` |Nur hörende Sockets zeigen|
|weder `--all` <br /> noch `--listening`|Nur verbundene Sockets anzeigen|
|`--numeric`|Keine Namensauflösung, Portnummer anstatt Protokollname|
|`--wide`|IPv6 Adressen werden nicht verkürzt dargestellt|

## lsof
Lsof zeigt geöffnete Dateien des Betriebssystems.  
Die Option -i zeigt nur die Dateien, die aktuell einem Netzwerk-Socket zugewiesen sind.
```
$ sudo apt install lsof
$ sudo lsof -i
```
