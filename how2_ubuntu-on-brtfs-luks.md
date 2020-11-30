# Ubuntu auf Btrfs mit LUKS verschlüsseln

## Systembeschreibung

Die Anleitung bezieht sich auf folgende Testumgebung:

* Rechnerarchitektur: x86-64
* Hypervisor: VirtualBox 6.1.16
* Host: Ubuntu 18.04.5 LTS
* Gast: Ubuntu 20.04.1 LTS
* Firmware-Schnittstelle: EFI
* Festplatten-Controller: SATA
* Partitionierungsschema: GPT
* Boot-Lader: GRUB 2

Im Anhang werden (geplant) folgende Sonderfälle aufgearbeitet:

* Firmware-Schnittstelle: BIOS
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

##### Installationsgerät ermitteln:
```
lsblk -p | grep disk
> /dev/sda     8:0     0     20G     0     disk
```
Ergebnis: Das Gerät hat die Bezeichnung */dev/sda*

## Quellen
* https://wiki.thoschworks.de/thoschwiki/linux/ubuntumatebtrfsencrypted
* https://www.mutschler.eu/linux/install-guides/ubuntu-btrfs/
* https://cryptsetup-team.pages.debian.net/cryptsetup/encrypted-boot.html
* https://wiki.ubuntuusers.de/Btrfs-Dateisystem/
* https://wiki.ubuntuusers.de/LUKS/
* https://wiki.ubuntuusers.de/GRUB_2/
