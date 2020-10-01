# Der CUPS PDF-Drucker

#### Installation und Konfiguration

Die folgenden Aktionen werden als Benutzer mit Root-Rechten in einem Terminal ausgeführt:

```
apt install printer-driver-cups-pdf
```

```
lpinfo --make-and-model "CUPS-PDF" -m
>> lsb/usr/cups-pdf/CUPS-PDF_noopt.ppd Generic CUPS-PDF Printer (no options)
>> lsb/usr/cups-pdf/CUPS-PDF_opt.ppd Generic CUPS-PDF Printer (w/ options)
>> everywhere IPP Everywhere
```

Der Pfad *lsb/usr/cups-pdf/CUPS-PDF_opt.ppd* verweist auf den PDF-Drucker-Treiber.
Dieser wird nun an einen neuen Drucker gebunden:

```
lpadmin -p MeinPDFDrucker \
  -D "Ein Super PDF-Drucker" \
  -L "foo" \
  -m lsb/usr/cups-pdf/CUPS-PDF_opt.ppd \
  -E
```

Wobei:

```
Option -p => Druckername
Option -D => nähere Beschreibung des Druckers
Option -L => Ort des Druckers (Beispielsweise der Name des Rechners)
Option -m => Ort der zu verknüpfenden ppd-Datei
Option -E => diesen Drucker in den Bereitschaftsmodus bringen
```

#### Überprüfung der Installation

Mit den folgenden Befehlen können aktuelle Informationen zum installierten PDF-Drucker ermittelt werden.

```
lpstat -p | grep MeinPDFDrucker
lpoptions -p MeinPDFDrucker
lpoptions -p MeinPDFDrucker -l
```
