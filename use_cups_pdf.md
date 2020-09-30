# Den CUPS PDF-Drucker nutzen

## Installation

Die folgenden Aktionen werden als Benutzer mit Root-Rechten ausgeführt:

```
> apt install printer-driver-cups-pdf

> lpinfo --make-and-model "CUPS-PDF" -m
lsb/usr/cups-pdf/CUPS-PDF_noopt.ppd Generic CUPS-PDF Printer (no options)
lsb/usr/cups-pdf/CUPS-PDF_opt.ppd Generic CUPS-PDF Printer (w/ options)
everywhere IPP Everywhere

> lpadmin -p MeinPDFDrucker -D "Ein Super PDF-Drucker" -L "foo" -m lsb/usr/cups-pdf/CUPS-PDF_opt.ppd -E
```
Wobei:
```
Option -p => Druckername
Option -D => nähere Beschreibung des Druckers
Option -L => Ort des Druckers (Beispielsweise der Name des Rechners)
Option -m => Ort der zu verknüpfenden ppd-Datei
Option -E => diesen Drucker in den Bereitschaftsmodus bringen
```
## Überprüfung der Installation
```
> lpstat -p | grep MeinPDFDrucker
Drucker MeinPDFDrucker ist im Leerlauf.  Aktiviert seit Mi 30 Sep 2020 12:18:38 CEST

> lpoptions -p MeinPDFDrucker
copies=1 device-uri=file:///dev/null finishings=3 job-cancel-after=10800 job-hold-until=no-hold job-priority=50 job-sheets=none,none marker-change-time=0 number-up=1 printer-commands=AutoConfigure,Clean,PrintSelfTestPage printer-info='Ein Super Printer' printer-is-accepting-jobs=true printer-is-shared=true printer-is-temporary=false printer-location=foo printer-make-and-model='Generic CUPS-PDF Printer (w/ options)' printer-state=3 printer-state-change-time=1601461118 printer-state-reasons=none printer-type=8450124 printer-uri-supported=ipp://localhost/printers/MeinPDFDrucker

> lpoptions -p MeinPDFDrucker -l
PageSize/Page Size: Custom.WIDTHxHEIGHT 11x14 11x17 13x19 16x20 16x24 2A 4A 8x10 8x12 A0 A1 A2 A3 *A4 A5 AnsiA AnsiB AnsiC AnsiD AnsiE ArchA ArchB ArchC ArchD ArchE C0 C1 C2 C3 C4 C5 Env10 EnvC5 EnvDL EnvMonarch Executive ISOB0 ISOB1 ISOB2 ISOB3 ISOB4 ISOB5 JISB0 JISB1 JISB2 JISB3 JISB4 JISB5 Ledger Legal Letter RA0 RA1 RA2 RA3 RA4 SRA0 SRA1 SRA2 SRA3 SRA4 SuperA SuperB TabloidExtra Tabloid
Resolution/Output Resolution: 150dpi *300dpi 600dpi 1200dpi 2400dpi
PDFVer/PDF version: 1.1 *1.2 1.3 1.4 1.5
Truncate/Truncate output filename to: 8 16 32 *64
Label/Label outputfiles: 0 1 *2
TitlePref/Prefer title from: *0 1
LogType/Log level: 1 3 *7
```
Diese Informationenann können auch in einem Browser über die Adresse ``http://localhost:631/printers/'' ermittelt werden.
