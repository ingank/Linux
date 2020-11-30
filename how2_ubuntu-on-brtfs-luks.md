# Ubuntu auf Btrfs mit LUKS verschlüsseln

## Systembeschreibung

Die Anleitung bezieht sich auf folgende Testumgebung:

* Rechnerarchitektur: x86-64
* Hypervisor: VirtualBox 6.1.16
* Host: Ubuntu 18.04.5 LTS
* Gast: Ubuntu 20.04.1 LTS
* Firmware-Schnittstelle: EFI
* Festplatten-Hardware: HHD
* Festplatten-Controller: SATA
* Partitionierungsschema: GPT
* Boot-Lader: GRUB 2

Im Anhang werden (geplant) folgende Sonderfälle aufgearbeitet:

* Firmware-Schnittstelle: BIOS
* Festplatten-Hardware: SSD
* Festplatten-Controller: NVMe
* Partitionierungsschema: MBR

## Installation

**Achtung:** folgende Schritte müssen nacheinander **ohne Reboot** ausgeführt werden.

##### Boot-Lader des Installationsmediums:
*keine Interaktion*

##### Auf dem Willkommen-Bildschirm:
* Sprache *Deutsch* wählen
* Klicken: *Ubuntu ausprobieren*

##### Tastaturlayout auf Deutsch umstellen:
* Gehe zu: Einstellungen
* Gehe zu: Region und Sprache
* Gehe zu: Eingabequellen
* Aktion: Tastatur hinzufügen
* Wähle: *Deutsch (ohne Akzenttasten)*
* Aktion: Tastatur entfernen für *English (USA)*
* Schließe: Einstellungen

##### Terminal öffnen:
* Tastenkombination: *[STRG]+[ALT]+[T]*

##### Interaktive ROOT-Shell öffnen:
`sudo -i`

##### Installationsziel ermitteln:
```
lsblk -p | grep disk
> /dev/sda     8:0     0     20G     0     disk
```
Ergebnis: Das Gerät hat die Bezeichnung */dev/sda*

##### Installationsziel partitionieren:
```
gdisk /dev/sda
```
Swap-Partition anlegen:
```
Command (? for help): n
Partition number (1-128, default 1): 2
First sector (34-41943006, default = 2048) or {+-}size{KMGTP}: 2048
Last sector (2048-41943006, default = 41943006) or {+-}size{KMGTP}: +8G
Current type is 8300 (Linux filesystem)
Hex code or GUID (L to show codes, Enter = 8300): 8200
Changed type of partition to 'Linux swap'
```
Partition für GRUB 2 - Stage 1.5 anlegen:
```
Command (? for help): n
Partition number (1-128, default 1): 
First sector (34-41943006, default = 16779264) or {+-}size{KMGTP}: 1048
Last sector (1048-2047, default = 2047) or {+-}size{KMGTP}: 
Current type is 8300 (Linux filesystem)
Hex code or GUID (L to show codes, Enter = 8300): ef02
Changed type of partition to 'BIOS boot partition'
```
Partition für root-Filesystem (/) anlegen:
```
Command (? for help): n
Partition number (3-128, default 3): 
First sector (34-41943006, default = 16779264) or {+-}size{KMGTP}: 
Last sector (16779264-41943006, default = 41943006) or {+-}size{KMGTP}: 
Current type is 8300 (Linux filesystem)
Hex code or GUID (L to show codes, Enter = 8300): 
Changed type of partition to 'Linux filesystem'
```
GPT prüfen:
```
Command (? for help): p
Disk /dev/sda: 41943040 sectors, 20.0 GiB
Model: VBOX HARDDISK   
Sector size (logical/physical): 512/512 bytes
Disk identifier (GUID): 489B0ED7-E99A-4702-800E-FE63B2E8206E
Partition table holds up to 128 entries
Main partition table begins at sector 2 and ends at sector 33
First usable sector is 34, last usable sector is 41943006
Partitions will be aligned on 2048-sector boundaries
Total free space is 1014 sectors (507.0 KiB)

Number  Start (sector)    End (sector)  Size       Code  Name
   1            1048            2047   500.0 KiB   EF02  BIOS boot partition
   2            2048        16779263   8.0 GiB     8200  Linux swap
   3        16779264        41943006   12.0 GiB    8300  Linux filesystem
```
GPT schreiben:
```
Command (? for help): w

Final checks complete. About to write GPT data. THIS WILL OVERWRITE EXISTING
PARTITIONS!!

Do you want to proceed? (Y/N): y
OK; writing new GUID partition table (GPT) to /dev/sda.
The operation has completed successfully.
```


## Quellen
* https://wiki.thoschworks.de/thoschwiki/linux/ubuntumatebtrfsencrypted
* https://www.mutschler.eu/linux/install-guides/ubuntu-btrfs/
* https://cryptsetup-team.pages.debian.net/cryptsetup/encrypted-boot.html
* https://wiki.ubuntuusers.de/Btrfs-Dateisystem/
* https://wiki.ubuntuusers.de/LUKS/
* https://wiki.ubuntuusers.de/GRUB_2/
