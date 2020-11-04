# MBR (Master Boot Record) inspizieren

Der MBR (Master Boot Record) eines Boot-Gerätes für PC-Systeme besteht aus:

* Bootloader
  * 440 Bytes
  * Synonyme:
    * bootstrap loader
    * Urlader
    * Bootcode
    * Startprogramm
    * Stage 1
    * ...
* Datenträgersignatur
  * 4 Bytes
* 16-bit-NULL
  * 2 Bytes
* primäre Partitionstabelle
  * 64 Bytes
* Magic Word
  * 2 Bytes
  * Inhalt = HEX 55AA

## Inspektion vorbereiten

Dieses Kapitel befasst sich mit Lese- und Schreibzugriffen auf den MBR von Festplatten.
Lesezugriffe sind grundsätzlich ungefährlich für das Wohlergehen der Daten auf der Festplatte,
schreibender Zugriff birgt potenziell hohe Risiken für einen Totalverlust von wichtigen Daten.

Folgende Vorsichtsmaßnahme wird deshalb getroffen:
das anzusprechende Block-Device der Festplatte wird in einer Variable zwischengespeichert.
Die aufgeführten Kommandozeilenbefehle wiederum verwenden dann diese Variable für den Zugriff auf den MBR.
So ist sicher gestellt, dass einfaches copy&paste aus dem Artikel heraus auch auf vom Referenzsystem unterschiedlichen Plattformen sicher ausgeführt werden kann.

Mit Hilfe der folgenden Tools kann das richtige Block-Device ermittelt werden:

```
sudo fdisk -l
sudo lsblk
sudo blkid
```

Das Block-Device von Hot-Swap-Wechsellaufwerken (beispielweise USB-Memory-Sticks) kann durchaus auch mit Hilfe der Log-Datei `/var/log/syslog` ermittelt werden.
Sobald das Medium mit dem Rechner verbunden wird, erscheint im Terminal das entsprechende Block-Device:
```
sudo tail -fc0 /var/log/syslog | grep -e '[sd.]|[[:blank:]]sd.:'
```

Das ermittelte Block-Device wird in einer Variablen zwischengespeichert:
```
BLKDEV=/dev/sdX
```

Desweiteren ist es durchaus angebracht, den aktuellen MBR explizit in einer Binär-Datei zu sichern:

```
sudo dd if=$BLKDEV bs=1 count=512 status=none of=~/mbr.bin.bak
```

## MBR lesen

MBR hexadezimal ausgeben:
```
sudo dd if=$BLKDEV bs=1 count=512 status=none | od -A x -t x1z -v --endian=big | sed '$d'
```

Die Einzelteile des MBR können zur *Inspektion ohne Ablenkung*, wie im Folgenden aufgeführt, auch einzeln adressiert werden.

Bootloader hexadezimal:
```
sudo dd if=$BLKDEV bs=1 count=512 status=none | od -N440 -v -h -Ax --endian=big | sed '$d'
```

Bootloader disassembliert:
```
sudo dd if=$BLKDEV bs=1 count=440 status=none > /tmp/bootcode.bin && ndisasm /tmp/bootcode.bin && rm -f /tmp/bootcode.bin
```

Datenträgersignatur:
```
sudo dd if=$BLKDEV bs=1 count=512 status=none | od -j440 -N4 -v -h -Ax --endian=big | sed '$d'
```

Doppelnull:
```
sudo dd if=$BLKDEV bs=1 count=512 status=none | od -j444 -N2 -v -h -Ax --endian=big | sed '$d'
```

Partitionstabelle:
```
sudo dd if=$BLKDEV bs=1 count=512 status=none | od -j446 -N64 -v -h -Ax --endian=big | sed '$d'
```

Magic Word:
```
sudo dd if=$BLKDEV bs=1 count=512 status=none | od -j510 -N2 -v -h -Ax --endian=big | sed '$d'
```

## MBR schreiben

**Achtung:** Nach dem Löschen des MBR und einem Reboot, ist kein Zugriff auf die Partitionen mehr möglich.
Folgende Tätigkeiten können deshalb den Totalverlust von wichtigen Daten zur Folge haben.
Es wird eindringlich geraten, vorher ein Komplettbackup des Systems durchzuführen.

MBR komplett löschen (Inhalt auf NULL setzen):
```
sudo dd if=/dev/zero of=$BLKDEV bs=1 count=512 conv=notrunc
```

MBR aus einer Backup-Datei (`~/mbr.bin.bak`) wieder herstellen:
```
sudo dd if=~/mbr.bin.bak of=$BLKDEV bs=1 count=512 conv=notrunc
```
