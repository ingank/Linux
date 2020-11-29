# Ubuntu auf Btrfs mit LUKS verschlüsseln

## Systembeschreibung
* VirtualBox 6.1.16
* Ubuntu 20.04.1 LTS (ISO)

## Installation

**Achtung:** folgende Schritte müssen nacheinander **ohne Reboot** ausgeführt werden.

---

* Sowohl mit EFI oder BIOS: Bootloader durchlaufen lassen
* Auf dem Willkommen-Bildschirm:
  * Sprache wählen
  * Klicken: *Ubuntu ausprobieren*
* Gehe zu:
  * Einstellungen
  * Region und Sprache
  * Eingabequellen
  * Tastatur hinzufügen: Deutsch (ohne Akzenttasten)
  * Tastatur entfernen: English (USA)
  * Einstellungen schließen
* Terminal öffnen: [STRG]+[ALT]+[T]

---

Nochmals prüfen, ob EFI oder BIOS:
```
mount | grep efivarfs
```
* Wenn keine Ausgabe: BIOS
* Wenn Ausgabe: EFI

---

Interaktive ROOT-Shell öffnen:
```
sudo -i
```

---

Installationsgerät ermitteln:
```
lsblk
```


## Quellen
* https://wiki.thoschworks.de/thoschwiki/linux/ubuntumatebtrfsencrypted
* https://www.mutschler.eu/linux/install-guides/ubuntu-btrfs/
* https://cryptsetup-team.pages.debian.net/cryptsetup/encrypted-boot.html
* https://wiki.ubuntuusers.de/Btrfs-Dateisystem/
* https://wiki.ubuntuusers.de/LUKS/
* https://wiki.ubuntuusers.de/GRUB_2/
