# FreeBSD in Hypervisoren ausführen

## Ressourcen

FreeBSD wird für die wichtigsten Hypervisoren als Image zum Download angeboten.

* Zuordnung von Image-Dateiendung und Hypervisor:
  * https://download.freebsd.org/ftp/releases/VM-IMAGES/README.txt

* Direktlink zum Download verschiedener freeBSD-Versionen als VM-Image:
  * https://download.freebsd.org/ftp/releases/VM-IMAGES/

Die angebotenen Images sollten in die jeweiligen VM's ohne Probleme importiert werden können.
Wem dies nicht auf Anhieb gelingt, sollte sich den nachfolgenden Abschnitt näher anschauen.

## RAW-Image importieren

Anhand des Hypervisors Virtual Box wird in diesem Abschnitt beschrieben,
wie das RAW-Image genutzt werden kann.

Zuerst wird die Image-Datei in einen beliebigen Ordner herungtergeladen.

Im weiteren Verlauf wird davon ausgegangen,
dass ein Terminal im entsprechenden Pfad auf die Eingabe wartet.
```
vboxmanage convertdd foo.raw bar.vdi --format VDI
```

*foo.raw* ist das geladene RAW-Image, *bar.vdi* ist der Dateiname des zu erzeugenden VM-Images.
Die Größe des erstellten Virtuellen Datenträgers ist gerade so groß,
dass er gestartet werden kann.
Für ein Produktivsystem muss jedoch die Festplatte vergrößert werden:
```
vboxmanage modifyhd --resize 20000 'bar.vdi'
```

In diesem Beispiel wurde die virtuelle Festplatte auf 20000 MB vergrößert,
wobei dies nur die Größe ist,
die FreeBSD sieht.
Die physikalische Größe der Datei wird je nach Bedarf von VBox vergrößert
und dürfte sich in diesem Step nur unwesentlich verändert haben.

Das Abbild bar.vdi kann nun in Virtual Box zur Erstellung von Virtuellen Maschinen genutzt werden.

## Quellen

* https://download.freebsd.org/ftp/releases/VM-IMAGES/README.txt
* https://blog.sleeplessbeastie.eu/2012/04/29/virtualbox-convert-raw-image-to-vdi-and-otherwise/
