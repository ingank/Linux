# HP Laserjet 1022: Reinigungsseite drucken

Dieser Artikel beschreibt,
wie mit Hilfe von Escape-Zeichenfolgen ein HP LaserJet 1020/1022 Drucker
aus Ubuntu heraus so genannte Reinigungsseiten drucken kann.

## Fallbeschreibung

Druckertreiber für die USB- oder serielle Schnittstelle älterer Geräte
sind vor allem für die Produktivsysteme Microsoft Windows und Apple macOS direkt vom Hersteller verfügbar.
Aus Linux heraus können aktuelle Geräte mit Hilfe standartisierter Netzwerkprotokolle durchaus zufriedenstellend ihre Arbeit verrichten.
Für das Feintuning oder Wartungsarbeiten stehen dann zwar keine Benutzerschnittstellen auf Treiberebene zur Verfügung.
Was dort nicht geht, kann man jedoch per Direktzugriff auf die Gerätewebseite erledigen.

Ältere Drucker besitzen weder Netzwerkschnittstellen,
noch kommen Sie mit einer Weboberfläche daher.
Wartungsarbeiten am Drucker können sich schon mal als eher nichttrivial erweisen.

```
# Hard- und Software

# Drucker:        HP Laserjet 1022 per USB angeschlossen an
# Rechner:        Dell OptiPlex-780 4GB, Dual-Core CPU E5800 @ 3.20GHz × 2
# Betriebssystem: Ubuntu 18.10. 64 Bit
# Druckertreiber: Foomatic/foo2zjs-z1
```

Drucken kann man in dieser Konfiguration leidlich gut,
wenn keine Spielereien wie beispielsweise Duplexdruck gewünscht sind.

Über die Einstellungen des Druckers kann angeblich der Prozess *Druckköpfe reinigen* angestoßen werden.
Leider ist das nicht zielführend, denn was soll ich sagen, nach Betätigung des entsprechenden Buttons passiert nichts!

## Lösung in Sicht

Nach einigen Recherchen hat sich folgende, sehr einfache Lösung herauskristallisiert:

```
#!/bin/bash
#
### HP LaserJet 1022: eine Reinigungsseite drucken
#
echo -e -n '\e%-12345X@PJL\r\n@PJL CLEANPRINTER\r\n\e%-12345X' > /tmp/foo.bar
lpr -l /tmp/foo.bar
rm -f /tmp/foo.bar
```

Der Quellcode wird in einer beliebigen Textdatei gespeichert, mit
```
chmod +x foo
```

ausführbar gemacht und danach gestartet.

## Schablone für ähnliche Fälle

Grob gesagt war folgendes Vorgehen notwendig:

* Den Windows-Druckertreiber in einer (freien) Windows-VM installieren.
* Eine Reinigungsseite über das grafische Interface dieses Treibers drucken.
* gleichzeitig per Fireshark auf dem USB-Interface mithören.
* die Escape-Zeichenfolge für die Reinigungsseite aus dem Mitschnitt herausfiltern.
* Die Escape-Zeichenfolge mit lpr unter Linux an den Drucker senden.

## Quellen

### Zum Thema Escape-Sequenzen
* https://tosiek.pl/pjl-send-commands-to-printer-in-raw-bin-file/
* https://jacobsalmela.com/2015/03/12/send-commands-to-all-installed-printers/

### Zum Thema HP-Drucker
http://www.hp.com/ctg/Manual/bpl13210.pdf
http://h10032.www1.hp.com/ctg/Manual/bpl13208.pdf
https://support.hp.com/de-de/drivers/selfservice/hp-laserjet-1022-printer-series/439424/model/439431
http://h10032.www1.hp.com/ctg/Manual/c00264449.pdf
https://www.devenezia.com/docs/HP/index.html?2-esc-code

### Zum Thema Microsoft Windows VM
https://www.google.com/search?q=microsoft+developer+vm+Download+virtual+machines
