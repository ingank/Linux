# Spracheinstellungen im Terminal

Die Spracheinstellungen eines GNU/Linux Debian Systems
können nicht ausschließlich innerhalb der GUI gewählt werden.
Die folgenden Befehle helfen im Terminal weiter.

## Tastaturlayout einstellen
```
sudo dpkg-reconfigure console-setup
```

oder
```
sudo dpkg-reconfigure keyboard-configuration
```

Wenn das Paket *console-setup* nicht installiert sein sollte:
```
sudo apt-get install console-setup
```

## Systemsprache einstellen

Hier geht es um die Darstellung von Uhrzeit und Datum,
sowie die Ausgabe von Hilfetexten in der Muttersprache.
```
sudo dpkg-reconfigure locales
```

Überprüfung der aktuellen Spracheinstellung:
```
locale
```
