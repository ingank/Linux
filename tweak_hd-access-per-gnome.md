# Zugriffsrechte auf Partitionen mit Gnome steuern

Nur privilegierte Benutzer können Partitionen erstellen und formatieren.
Dementsprechend können andere Nutzer nicht schreibend auf das Gerät zugreifen.
Wie können wir diesen Umstand mit Hilfe des Gnome Desktops ändern?

Folgendes Vorgehen hat sich als praxistauglich bezüglich GAU und Einfachheit erwiesen:

* In einem Terminal eingeben: `gnome-disks`
* Im Tool *gnome-disks* zur gewünschten Partition durchklicken
* wenn noch nicht geschehen, diese über das Symbol ▶️ ins Dateisystem einhängen.
* Über den blau eingefärbten Direktlink im Infobreich der Partition den Nautilus-Dateimanager öffnen
* Im neu geöffneten Dateimanager:
  * Rechtsklick ins Verzeichnis
  * Gehe zu *In Terminal öffnen*
* Im neu geöffneten Terminal: `sudo nautilus ./`
* Im neu geöffneten Dateimanager:
  * Rechtsklick ins Verzeichnis
  * Gehe zu *Eigenschaften*

Im sich öffnenden Dialog können jetzt die grundsätzlichen Zugriffsrechte
auf die Partition geregelt werden.
