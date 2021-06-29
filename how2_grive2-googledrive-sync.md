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
