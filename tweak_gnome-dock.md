# Aussehen und Handling des Gnome-Docks anpassen

## 1. Grundeinstellungen

Auf dem Desktop navigieren zu:

  * `Applications`
  * `-> Settings`
  * `-> Appearance`
  * `-> Dock`

Dort können die Grundeinstellungen des Docks eingesehen und verändert werden.

## 2. Gnome Shell Extensions

Gnome Shell Extensions installieren:

`sudo apt install gnome-shell-extensions`

Dann auf dem Desktop navigieren zu:

* `Applications`
* `-> Extensions`

In den _Extensions_ kann unter _Unbuntu Dock_ das Dock komplett deaktiviert oder aktiviert werden.

## 3. Dconf Editor

Dconf Editor installieren:

`sudo apt install dconf-editor`

Dconf Editor starten:

`dconf-editor /org/gnome/shell/extensions/dash-to-dock/`

In diesem Pfad können die erweiterten Einstellungen des Docks vorgenommen werden.

Beispiele:

|Key|Schlüssel|Wert|Verhalten|
|-|-|-|-|
|extended-height|Panelmodus: bis zur<br>Bildschirmkante ausdehen|ON|Dock über ganze Breite<br>oben/links-bündig
|extended-height|Panelmodus: bis zur<br>Bildschirmkante ausdehen|OFF|Dock so breit wie alle Icons<br>mittig vertikal oder horizontal