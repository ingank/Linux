# Grundlagen der Linux-Benutzerverwaltung

Für ein Multiuser-Betriebssystem wie Linux ist eine transparente Benutzerverwaltung essenziell wichtig für die exakte und sichere Steuerung von erlaubten und verbotenen Aktionen bestimmter Benutzer oder Benutzergruppen.

## Komponenten

Diese Dokumentation bezieht sich auf folgende Pakete:

* core-utils
* shadow-utils
* sudo

Diese sollten im Vorfeld installiert werden.

## Kommandos zur Benutzerverwaltung

Benutzer- und Gruppeninformationen des aktuellen Benutzers ausgeben:

`id`

Benutzer- und Gruppeninformationen des Benutzers foo ausgeben:

`id foo`

Passwort des aktuellen Benutzers ändern:

`passwd`

Passwort des Benutzers foo ändern:

`sudo passwd foo`

Passwort-Login für root deaktivieren:

`sudo usermod -p '!' root`

Benutzeraccount für bar inklusive Benutzerverzeichnis /home/bar erstellen:

`sudo adduser bar`

Benutzer foo in die Benutzergruppe sudo aufnehmen:

`sudo usermod -a -G sudo foo`

Benutzer foo aus der Gruppe sudo entfernen:

`sudo deluser foo sudo`

Benutzeraccount und alle Gruppenzugehörigkeiten für foo löschen (/home/foo wird nicht gelöscht):

`sudo deluser foo`

Benutzeraccount und alle Gruppenzugehörigkeiten für foo löschen (/home/foo wird auch gelöscht):

`sudo deluser --remove-home foo`

Befehl als Benutzer bar ausführen:
```
# nicht interaktiv:
sudo -u bar Befehl

# interaktiv:
su bar -c Befehl
```

## Dokumentation zur Benutzerverwaltung
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
