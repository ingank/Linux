# Der Befehl crontab

Systemweite, von *root* editierbare Konfigurationsdateien für den *cron*-Daemon werden unter /etc/crontab und /etc/cron* gespeichert.

Jeder Benutzer kann jedoch auch eigene (private) zeitgesteuerte Jobs von Linux ausführen lassen.
Das Programm *crontab* bietet mit der Option *-e* eine entsprechende Funktion.

(Private) crontab des derzeigigen Benutzers editieren:

```
crontab -e
```

Als Benutzer mit root-Rechten die crontab eines bestimmten Benutzers editieren:
```
sudo crontab -u foo -e
```

Die nutzerbasierten crontab-Dateien werden im Ordner */var/spool/cron/crontabs* gespeichert.

Lokale Administratoren haben die Möglichkeit,
den Zugriff auf die Funktionalität nutzerbasierter crontabs über die Dateien */etc/cron.allow* und */etc/cron.deny* zu steuern.
Hinweise zur richtigen Anwendung dieser Dateien liefert:
```
man crontab
```
