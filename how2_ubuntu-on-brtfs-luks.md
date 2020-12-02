# Ubuntu auf Btrfs mit LUKS verschlüsseln

## Systembeschreibung

Die Anleitung bezieht sich auf folgende Testumgebung:

* Rechnerarchitektur: x86-64
* Hypervisor: VirtualBox 6.1.16
* Host: Ubuntu 18.04.5 LTS
* Gast: Ubuntu 20.04.1 LTS
* Firmware-Schnittstelle: EFI
* Festplatten-Hardware: SSD
* Festplattengröße: 20 GiB
* Festplatten-Controller: SATA
* Partitionierungsschema: GPT
* Boot-Lader: GRUB 2

Im Anhang werden (geplant) folgende Sonderfälle aufgearbeitet:

* Veraltet:
  * Firmware-Schnittstelle: BIOS
  * Festplatten-Hardware: HDD
  * Partitionierungsschema: MBR
* Modern:
  * Festplatten-Controller: NVMe

## Installation

**Achtung:** folgende Schritte müssen nacheinander **ohne Reboot** ausgeführt werden.

##### Boot-Lader des Installationsmediums:
* keine Interaktion

##### Auf dem Willkommen-Bildschirm:
* Sprache wählen: *Deutsch*
* Klicken: *Ubuntu ausprobieren*

##### Tastaturlayout auf Deutsch umstellen:
* Gehe zu: *Einstellungen*
* Gehe zu: *Region und Sprache*
* Gehe zu: *Eingabequellen*
* Aktion: *Tastatur hinzufügen (+)*
* Wähle: *Deutsch (ohne Akzenttasten)*
* Aktion: *Tastatur entfernen* für *English (USA)*
* Schließe: *Einstellungen*

##### Terminal öffnen:
* Tastenkombination: *[STRG]+[ALT]+[T]*

##### Interaktive ROOT-Shell öffnen:
`sudo -i`

##### Installationsziel ermitteln:
```
lsblk -p | grep disk
```
Ausgabe:
```
/dev/sda     8:0     0     20G     0     disk
```

##### Installationsziel partitionieren:
```
root@ubuntu:~# gdisk /dev/sda
GPT fdisk (gdisk) version 1.0.5

Partition table scan:
  MBR: not present
  BSD: not present
  APM: not present
  GPT: not present

Creating new GPT entries in memory.
```
EFI System Partition anlegen:
```
Command (? for help): n
Partition number (1-128, default 1): 2
First sector (34-41943006, default = 2048) or {+-}size{KMGTP}: 
Last sector (2048-41943006, default = 41943006) or {+-}size{KMGTP}: +512M
Current type is 8300 (Linux filesystem)
Hex code or GUID (L to show codes, Enter = 8300): ef00
Changed type of partition to 'EFI system partition'
```
Partition für GRUB 2 coreimage anlegen:
```
Command (? for help): n
Partition number (1-128, default 1):  
First sector (34-41943006, default = 1050624) or {+-}size{KMGTP}: 1024
Last sector (1024-2047, default = 2047) or {+-}size{KMGTP}: 
Current type is 8300 (Linux filesystem)
Hex code or GUID (L to show codes, Enter = 8300): ef02
Changed type of partition to 'BIOS boot partition'
```
Swap-Partition anlegen:
```
Command (? for help): n
Partition number (3-128, default 3): 
First sector (34-41943006, default = 1050624) or {+-}size{KMGTP}: 
Last sector (1050624-41943006, default = 41943006) or {+-}size{KMGTP}: +8G
Current type is 8300 (Linux filesystem)
Hex code or GUID (L to show codes, Enter = 8300): 8200
Changed type of partition to 'Linux swap'
```
Linux Systempartition anlegen:
```
Command (? for help): n
Partition number (4-128, default 4): 
First sector (34-41943006, default = 17827840) or {+-}size{KMGTP}: 
Last sector (17827840-41943006, default = 41943006) or {+-}size{KMGTP}: 
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
Disk identifier (GUID): 3366BB62-51B3-4DE3-B9A3-4B779476FDA6
Partition table holds up to 128 entries
Main partition table begins at sector 2 and ends at sector 33
First usable sector is 34, last usable sector is 41943006
Partitions will be aligned on 2048-sector boundaries
Total free space is 990 sectors (495.0 KiB)

Number  Start (sector)    End (sector)  Size       Code  Name
   1            1024            2047   512.0 KiB   EF02  BIOS boot partition
   2            2048         1050623   512.0 MiB   EF00  EFI system partition
   3         1050624        17827839   8.0 GiB     8200  Linux swap
   4        17827840        41943006   11.5 GiB    8300  Linux filesystem
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

##### EFI System Partition formatieren
* FAT16

##### Linux Systempartition verschlüsseln
```
cryptsetup luksFormat --type=luks1 /dev/sda4

WARNING!
========
Hiermit werden die Daten auf »/dev/sda4« unwiderruflich überschrieben.

Are you sure? (Type uppercase yes): YES
Geben Sie die Passphrase für »/dev/sda4« ein:
Passphrase bestätigen:
```

##### Linux Systempartition ins aktuelle System mappen
```
cryptsetup luksOpen /dev/sda4 rootfs
Geben Sie die Passphrase für »/dev/sda4« ein:
```
Prüfen:
```
ls /dev/mapper/
```
Korrekte Ausgabe:
```
control rootfs
```

##### Btrfs in der Linux Systempartition erzeugen
```
mkfs.btrfs /dev/mapper/rootfs
```

##### Mount-Optionen an SSD-Spezifikation anpassen

Zwei Konfigurationsdateien anpassen:

* /usr/lib/partman/mount.d/70btrfs
  * [Original](https://github.com/ingank/Linux/blob/875642283fccee8b8dfd9832af427216b8584a30/files/usr%3Dlib%3Dpartman%3Dmount.d%3D70btrfs)
  * [Editiert](https://github.com/ingank/Linux/blob/master/files/usr%3Dlib%3Dpartman%3Dmount.d%3D70btrfs)
  * [Diff](https://github.com/ingank/Linux/commit/81933004f6569f6afe7e1d60f145084b08f919e1)

* /usr/lib/partman/fstab.d/btrfs
  * [Original](https://github.com/ingank/Linux/blob/f57240cd7ccaf787401624a018f62c1aea461f79/files/usr%3Dlib%3Dpartman%3Dfstab.d%3Dbtrfs)
  * [Editiert](https://github.com/ingank/Linux/blob/master/files/usr%3Dlib%3Dpartman%3Dfstab.d%3Dbtrfs)
  * [Diff](https://github.com/ingank/Linux/commit/23a8349800f7cf8754fcf014652980668b15e509)

##### Ubuntu installieren

Das Tool *Ubiquity* kann nun zur Installation des Betriebssystems gestartet werden.
Die Installation des GRUB 2 Bootladers wird später von Hand erledigt und wird
deshalb vorerst unterdrückt:
```
ubiquity --no-bootloader
```

## Quellen
* https://wiki.thoschworks.de/thoschwiki/linux/ubuntumatebtrfsencrypted
* https://www.mutschler.eu/linux/install-guides/ubuntu-btrfs/
* https://cryptsetup-team.pages.debian.net/cryptsetup/encrypted-boot.html
* https://wiki.ubuntuusers.de/Btrfs-Dateisystem/
* https://wiki.ubuntuusers.de/LUKS/
* https://wiki.ubuntuusers.de/GRUB_2/
* https://help-grub.gnu.narkive.com/tYopC4mg/grub2-possible-to-change-keyboard-layout-in-stage-1-5
