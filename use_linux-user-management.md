# Die Linux Benutzerverwaltung

Für ein Multiuser-Betriebssystem wie Linux
ist eine transparente Benutzerverwaltung essenziell wichtig
für die exakte und sichere Steuerung
von erlaubten und verbotenen Aktionen bestimmter Benutzer oder Benutzergruppen.

Die Programme und Konfigurationsdateien der Benutzerverwaltung heutiger Linux-Systeme
sind grundsätzlich so alt und erprobt, wie Linux selbst.
Die mitgelieferte Dokumentation gewährt selbst Sicherheitsenthusiasten
einen tiefen Einblick in die beteiligten Komponenten.

## Komponenten

Damit alle Beispiele in der Praxis nachvollzogen werden können,
sollten folgende Komponenten im Vorfeld über die Paketverwaltung installiert werden,
wenn sie denn nicht standardmäßig vorhanden sind:

* core-utils
* shadow-utils
* sudo

## Kommandozeilenbefehle

In diesem Abschnitt sind häufig genutzte Befehle zur Benutzerverwaltung aufgeführt.
Befehle mit dem vorangestellten Kommando *sudo*
können nur von einem privilegierten Benutzer ausgeführt werden.

Benutzer- und Gruppeninformationen des aktuellen Benutzers ausgeben:
```
id
```

Benutzer- und Gruppeninformationen des Benutzers *foo* ausgeben:
```
id foo
```

Passwort des aktuellen Benutzers ändern:
```
passwd
```

Passwort des Benutzers *foo* ändern:
```
sudo passwd foo
```

Passwort-Login für *root* deaktivieren:
```
sudo usermod -p '!' root
```

Benutzeraccount für *bar* inklusive Benutzerverzeichnis `/home/bar` erstellen:
```
sudo adduser bar
```

Benutzer *foo* in die Benutzergruppe *sudo* aufnehmen:
```
sudo usermod -a -G sudo foo
```

Benutzer *foo* aus der Gruppe *sudo* entfernen:
```
sudo deluser foo sudo
```

Benutzeraccount und alle Gruppenzugehörigkeiten für *foo* löschen (`/home/foo` wird **nicht** gelöscht):
```
sudo deluser foo
```

Benutzeraccount und alle Gruppenzugehörigkeiten für *foo* löschen (`/home/foo` wird auch gelöscht):
```
sudo deluser --remove-home foo
```

*Befehl* als Benutzer *bar* nicht interaktiv ausführen:
```
sudo -u bar Befehl
```

*Befehl* als Benutzer *bar* interaktiv ausführen (Passwort des Benutzers *bar* wird abgefragt):
```
su bar -c Befehl 
```

## Weiterführende Dokumentation

```
man 5 passwd
man 5 shadow
man 5 group
man 5 gshadow
man passwd
man useradd
man userdel
man usermod
man adduser
man deluser
man login
man rlogin
```

## Quellen:

* https://www.opensuse-forum.de/thread/40397-su-oder-sudo-und-der-ganze-shell-und-login-wirrwarr/
