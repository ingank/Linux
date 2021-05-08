# Netflix F7355 Error mit Firefox@Ubuntu

Auf einem aktuellen Ubuntu kann der Start von
Videos der Anbieter Netflix oder Amazon im Firefox-Browser fehlschlagen.

## Abhilfe

Bis auf weiteres hat folgendes geholfen:
```
sudo apt install libavcodec-dev
```

## Weitere Voraussetzungen

* Im Firefox-Browser muss die Wiedergabe von DRM-Inhalten zugelassen sein
* Im Firefox muss das Plugin _widevine_ installiert und immer aktiviert sein
