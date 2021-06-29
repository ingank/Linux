# Google Drive per grive2 synchronisieren

## grive2 installieren
```
sudo add-apt-repository ppa:nilarimogard/webupd8
sudo apt update
sudo apt install grive
sudo add-apt-repository -r ppa:nilarimogard/webupd8
sudo apt update
```

## Anwendung

Lokalen Ordner anlegen:
```
mkdir ~/Google-Drive
```

Lokalen Ordner als Wurzelordner anwählen:
```
cd ~/Google-Drive
```

Authentifizierungs-Token für Google-Drive im aktuellen lokalen Ordner erzeugen:
```
grive -a --dry-run
```

Kompletten Google-Drive synchronisieren:
```
grive
```

Einen bestimmten Google-Drive-Ordner synchronisieren:
```
grive -s ORDNER
```

Weitere Optionen anzeigen:
```
man grive
grive --help
```

## Verbindung von Google Drive zu grive2 aufheben
* Browse zu https://drive.google.com/
* Anmelden, wenn noch nicht geschehen
* Wähle _Einstellungen > Apps verwalten_
* Scrolle zu _grive2_
* Wähle _Optionen > Verbindung zu Google Drive aufheben_
* Klicke _Verbindung aufheben_

## Authentifizierungs-Token
* Das Token kann beliebig auf andere lokale Ordner angwandt werden - auch auf anderen Rechnern.
* Das birgt das Risiko eines Zugriffs von fremden Personen auf die Daten des Google Drive mit Hilfe eines gestohlenen Tokens.
* Bei Verdacht einer Kompromitierung des Tokens sollte dieses Token von Google Drive entbunden werden (siehe voriges Kapitel).
