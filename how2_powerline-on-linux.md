# TP-Link Powerline Adapter per VM administrieren

Die Firma tp-link vertreibt eine eigene Produktlinie an Powerline-Adaptern.
Zur Administration der Geräte wird das so genannte *tpPLC_Utility* angeboten.
Mit diesem Tool können Firmware-Updates aufgespielt,
die MAC-Adressen oder die Netzwerkkennung der Powerline-Geräte geändert werden.
Einen kleinen Haken gibt es jedoch!
Das Programm ist ausschließlich für die neusten Windows- und MAC OS Plattformen erhältlich.

Dieser Artikel beschreibt einen unkomplizierten Weg,
TP-Link Powerline Adapter auch unter Linux zu managen.

## Setup

* Rechner
  * Dell OptiPlex-780 4GB
* Betriebssystem
  * Ubuntu 18.10. 64 Bit
* Powerlineadapter
  * TP-Link TL-PA7020P
  * TL-PA8010P

## Lösungsansatz

Microsoft veröffentlicht für Software-Entwickler in regelmäßigen Abständen
VM's *(vituelle Maschinen)* der aktuellen Entwicklungsumgebung für Anwendungen
oder Webbrowser-Tests inklusive eines aktuellen Microsoft Windows Betriebssystems.
In einer solchen VM kann auch das Tool *tpPLC_Utility* installiert werden,
um Zugriff auf die Konfiguration der Powerline-Adapter zu bekommen.

## System einrichten

In Kurzform hier die wichtigsten Tätigkeiten zum Start des *tpPLC_Utility*:

* Oracle Virtual Box installieren.
* VM von Microsoft downloaden:
  * [Anwendungsentwickler](https://developer.microsoft.com/de-de/windows/downloads/virtual-machines/)
  * [Web-Entwickler](https://developer.microsoft.com/en-us/microsoft-edge/tools/vms/)
* VM in Oracle Virtual Box importieren.
* Snapshot vor dem ersten Start erzeugen.
* VM starten.
* Gasterweiterung *(VM Guest Extensions)* auf der VM aktivieren und aktualisieren.
* Netzwerkeinstellungen der VM korrigieren:
  * Geräte
  * Netzwerk
  * Einstellungen Netzwerk...
  * Auswählen bei *Angeschlossen an:*
    * Netzwerkbrücke
  * *OK* klicken
* Mit dem Webbrowser der VM das *tpPLC_Utility* suchen und downloaden.
* *tpPLC_Utility* in der VM installieren.
* *tpPLC_Utility* starten.

Mit Hilfe des *tpPLC_Utility* können nun die Powerline-Adapter konfiguriert werden.
