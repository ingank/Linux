# Netflix/Amazon Videowiedergabe verlangt aktuellen Codec

Auf einem aktuellen Linux-Betriebssystem kann der Start von
Videos der Anbieter Netflix bzw. Amazon im Firefox-Browser fehlschlagen.

Die Fehlerbeschreibung verweist auf einen veralteten Wiedergabe-Codec.

## Abhilfe

Installation der Codec-Suite libav in der Entwicklerversion:
```
sudo apt install libavcodec-dev
```

## Weitere Voraussetzungen

* Im Firefox-Browser muss die Wiedergabe von DRM-Inhalten zugelassen sein
* Im Firefox muss das Plugin _widevine_ installiert und immer aktiviert sein (Amazon)
