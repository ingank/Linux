# FM4 Audiostream als mp3 speichern und schneiden

Der Livestream und Sendungen der letzten sieben Tage sind auch bei FM4,
dem beliebten österreichischen Radiosender für Popkultur,
über den FM4-Webplayer abrufbar.

Dort bietet sich jedoch keine Möglichkeit,
das Musik- oder Informationsmaterial zu Archivierungszwecken direkt downzuloaden.
Mit Hilfe des Firefox-Browsers können jedoch alle notwendigen Informationen
zum Download gesammelt werden.

## Setup

* Ubuntu 18.10
* Firefox Webbrowser
* Wine
* mp3DirectCut
* ffmpeg

### Wine installieren
```
apt install wine-stable
```

### mp3DirectCut installieren
* Herstellerseite: https://mpesch3.de/index.html
* Direktdownload: https://www.heise.de/download/product/mp3directcut-14695/download
* Im Downloadordner:

```
wine ./mp3DCXXX.exe
```

* Wobei *XXX* die heruntergeladene aktuelle Version kennzeichnet.
* Mit Hilfe des gestarteten Installers mp3DirectCut mit allen voreingestellten Optionen in der Wine-Umgebung installieren.

### ffmpeg installieren
```
apt install ffmpeg
```

## Ermitteln der Informationen für den Download des Streams

* Im Firefox-Webbrowser den offiziellen Webplayer von FM4 öffnen.
  * Direkt-Link: https://fm4.orf.at/player/live
* Mit *[Strg]+[Umschalt]+[i]* die Entwicklerwerkzeuge öffnen.
* Reiter *Netzwerkanalyse* aktivieren.
* Das Mülleimersymbol links/oben innerhalb der Netzwerkanalyse klicken. Der Protokollverlauf müsste nun leer sein.
* In der Zeitleiste des Players einen Titel anklicken.
* Die Anforderung des Audiostreams wird im Protokollverlauf der Netzwerkanalyse angezeigt. In der Spalte *Datei* kann der Link auf den Einstieg in diesen Teil-Stream inspiziert werden.
* Rechtsklick auf Datei
  * ... Kopieren
  * ... Adresse kopieren.

## Stream downloaden

* Neues Browserfenster öffnen.
* In Adressleiste: Rechtsklick und Einfügen.
* Taste *ENTER*
* Es erscheint der Vorschauplayer von Firefox in dem der Teilaudiostream wiedergegeben wird.
* Pause klicken.
* Rechtsklick auf das Wiedergabe-Icon
  * ... Audio speichern unter ...
* Wenn Audiostream länger als der gewünschte Beitrag ist:
  * Download nach Gefühl pausieren.
* Im Download-Ordner nach der *richtigen* Datei suchen:
  * Wenn pausiert wurde: *foo.mpga.part*
  * Wenn Download komplett: *foo.mpga*
* Die *richtige* Datei umbenennen in *foo.mp3*

## Stream mit mp3DirectCut schneiden

* Terminal öffnen unter *~/.wine/drive_c/Program Files (x86)/mp3DirectCut*
* mp3DirectCut starten:
```
wine mp3DirectCut.exe
```
* In mp3DirectCut die Datei *foo.mp3* laden und nach Belieben schneiden und abspeichern.

## Metainformationen auffrischen

Durch den Abbruch des Downloads und die Bearbeitung mit mp3DirectCut können unter Umständen die angezeigte und tatsächliche Wiedergabezeit asynchron laufen.

In diesem Fall können die Metainformationen des mp3-Datenstroms mit ffmpeg neu berechnet werden:
```
ffmpeg -i lied.mp3 -acodec copy lied_neu.mp3
```

## Quellen
```
* https://askubuntu.com/questions/248811/how-can-i-fix-incorrect-mp3-duration
```
