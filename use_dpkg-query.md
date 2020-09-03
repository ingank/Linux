# dpkg-query
```
NAME
       dpkg-query - a tool to query the dpkg database

SYNOPSIS
       dpkg-query [option...] command

DESCRIPTION
       dpkg-query is a tool to show information about packages listed in the dpkg database.
```
# Beispiele

### Paket für ein bestimmtes Programm finden
```
$ dpkg-query -S bin/mcomp
mtools: /usr/bin/mcomp
```
Ergebnis: das Programm `/usr/bin/mcomp` gehört zum Debian-Paket "mtools"
