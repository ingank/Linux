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

## Schritt für Schritt

**Achtung:** folgende Schritte müssen nacheinander **ohne Reboot** ausgeführt werden.

### Boot-Lader des Installationsmediums:
* keine Interaktion

### Auf dem Willkommen-Bildschirm:
* Sprache wählen: *Deutsch*
* Klicken: *Ubuntu ausprobieren*

### Tastaturlayout auf Deutsch umstellen:
* Gehe zu: *Einstellungen*
* Gehe zu: *Region und Sprache*
* Gehe zu: *Eingabequellen*
* Aktion: *Tastatur hinzufügen (+)*
* Wähle: *Deutsch (ohne Akzenttasten)*
* Aktion: *Tastatur entfernen* für *English (USA)*
* Schließe: *Einstellungen*

### Terminal öffnen:
* Tastenkombination: *[STRG]+[ALT]+[T]*

### Interaktive ROOT-Shell öffnen:
`sudo -i`

### Installationsziel ermitteln:
```
lsblk -p | grep disk
# /dev/sda     8:0     0     20G     0     disk
```

### Installationsziel partitionieren:
```
gdisk /dev/sda
```
Programm *gdisk* wird gestartet:
```
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

### EFI system partition formatieren
```
mkfs.fat -F32 /dev/sda2
```

### Linux Systempartition verschlüsseln
```
cryptsetup luksFormat --type=luks1 /dev/sda4

# WARNING!
# ========
# Hiermit werden die Daten auf »/dev/sda4« unwiderruflich überschrieben.
# 
# Are you sure? (Type uppercase yes): YES
# Geben Sie die Passphrase für »/dev/sda4« ein: *****
# Passphrase bestätigen: *****
```

### Linux Systempartition ins aktuelle System mappen
```
cryptsetup luksOpen /dev/sda4 rootfs
# Geben Sie die Passphrase für »/dev/sda4« ein: *****
```
Prüfen:
```
ls /dev/mapper/
# control rootfs
```

### Btrfs in der (gemappten) Linux Systempartition erzeugen
```
mkfs.btrfs /dev/mapper/rootfs
```

### Mount-Optionen an SSD-Spezifikation anpassen

Zwei Konfigurationsdateien mit Hilfe eines Texteditors anpassen:

|Datei|Patch|
|:-|:-|
|/usr/lib/partman/mount.d/70btrfs|[Diff](https://github.com/ingank/Linux/commit/81933004f6569f6afe7e1d60f145084b08f919e1)|
|/usr/lib/partman/fstab.d/btrfs|[Diff](https://github.com/ingank/Linux/commit/23a8349800f7cf8754fcf014652980668b15e509)|

Auf Hardware,
die etwas älter ist,
hilft eventuell das Weglassen der Option |*,compress=zstd*|
die Performanz positiv zu beeinflussen.

### Ubuntu installieren

Das Tool *Ubiquity* kann nun zur Installation des Betriebssystems gestartet werden.
Die Installation des GRUB 2 Bootladers wird später von Hand erledigt und wird
deshalb vorerst unterdrückt:
```
ubiquity --no-bootloader
```
* Willkommen: *Deutsch* auswählen // *Weiter*
* Tastaturbelegung: *German* | *German - German (no dead keys)* // *Weiter*
* Aktualisierungen und andere Software: nach den eigenen Vorstellungen // *Weiter*
* Installationsart: *Etwas Anderes* // *Weiter*
  * Laufwerk */dev/mapper/rootfs* | Zweite Zeile | *Ändern ...*
    * Benutzen als: *Btrfs-Journaling-Dateisystem*
    * Partition formatieren: [x]
    * Einbindungspunkt: */*
    * *OK*
  * Laufwerk */dev/sda3* | *Ändern ...*
    * Benutzen als: *Auslagerungsspeicher (Swap)*
  * *Jetzt Installieren*
  * *Weiter*
* Wo befinden Sie sich?: Standort Auswählen // *Weiter*
* Wer sind Sie?: Nutzerdaten und Passwort vergeben // *Weiter*
* **Installation wird durchgeführt**
* Dialogbox *Installation abgeschlossen*: *Ausprobieren fortsetzen*
* Wenn alles glatt lief, befinden wir uns wieder als root im Terminal

### chroot ins neue Betriebssystem
```
mount -o subvol=@,ssd,noatime,space_cache,commit=120,compress=zstd /dev/mapper/rootfs /mnt
mount -o subvol=@home,ssd,noatime,space_cache,commit=120,compress=zstd /dev/mapper/rootfs /mnt/home
```
**Beachte:** Wenn, wie im Kapitel *Mount-Optionen an SSD-Spezifikation anpassen* beschrieben,
die Option *compress=zstd* auf älterer Hardware aus Performanzgründen entfernt wurde,
so muss dies auch an dieser Stelle ebenfalls erfolgen.
```
for i in /dev /dev/pts /proc /sys /run; do sudo mount -B $i /mnt$i; done
cp /etc/resolv.conf /mnt/etc/
chroot /mnt
```
Inspektion der chroot-Umgebung:
```
mount -av
# /                        : ignoriert
# /boot/efi                : successfully mounted
# /home                    : bereits eingehängt
# none                     : ignoriert

btrfs subvolume list /
# ID 256 gen 146 top level 5 path @
# ID 257 gen 20 top level 5 path @home
```

### Blockgerät des root-Dateisystems in /etc/crypttab aufnehmen

Eintrag in /etc/crypttab:
```
echo "rootfs UUID=$(blkid -s UUID -o value /dev/sda4) none luks" >> /etc/crypttab
```

Kontrolle:
```
cat /etc/crypttab
# rootfs UUID=08b46b30-4d14-44d2-be97-8c021f172d29 none luks
```

### swap-Auslagerungsspeicher deaktivieren
```
swapoff /dev/sda3
```

### swap-Partition verschlüsseln
```
cryptsetup luksFormat --type=luks1 /dev/sda3
# WARNUNG: Gerät /dev/sda3 enthält bereits eine 'swap'-Superblock-Signatur.
#
# WARNING!
# ========
# Hiermit werden die Daten auf »/dev/sda3« unwiderruflich überschrieben.
#
# Are you sure? (Type uppercase yes): YES
# Geben Sie die Passphrase für »/dev/sda3« ein: *****
# Passphrase bestätigen: *****
```

### swap-Partition ins aktuelle System mappen
```
cryptsetup luksOpen /dev/sda3 swap
# Geben Sie die Passphrase für »/dev/sda3« ein: *****
```
Inspektion:
```
ls /dev/mapper
# control  rootfs  swap
```

### swap-Speicher neu formatieren
```
mkswap /dev/mapper/swap
# Auslagerungsbereich Version 1 wird angelegt, Größe = 8 GiB (8587833344 Bytes)
# keine Bezeichnung, UUID=6172916d-5d2e-4130-a964-5c6694aeccfb
```

### swap-Speicher in /etc/crypttab und /etc/fstab aufnehmen

UUID des swap-Blockgerätes ermitteln und der Variable *SWAP_UUID* zuweisen:
```
export SWAP_UUID=$(blkid -s UUID -o value /dev/sda3)
```

Eintrag in /etc/crypttab:
```
echo "swap ${SWAP_UUID} none luks" >> /etc/crypttab
```

Kontrolle:
```
cat /etc/crypttab
# rootfs UUID=08b46b30-4d14-44d2-be97-8c021f172d29 none luks
# swap UUID=6a4eb9d9-7a0f-4486-a4af-bc3e75c3cb38 none luks
```

Eintrag in /etc/fstab:
```
sed -i "s|UUID=${SWAP_UUID}|/dev/mapper/swap|" /etc/fstab
```

Kontrolle:
```
cat /etc/fstab | sed 's/[[:space:][:blank:]]/ /g;s/ \{2,\}/ /g;/^#/d;/^$/d'
# /dev/mapper/rootfs / btrfs defaults,subvol=@,ssd,noatime,space_cache,commit=120 0 0
# UUID=51DC-D19B /boot/efi vfat umask=0077 0 1
# /dev/mapper/rootfs /home btrfs defaults,subvol=@home,ssd,noatime,space_cache,commit=120 0 0
# /dev/mapper/swap none swap sw 0 0
```

### Schlüsseldatei erzeugen
```
mkdir /etc/luks
dd if=/dev/urandom of=/etc/luks/boot_os.keyfile bs=4096 count=1
chmod u=rx,go-rwx /etc/luks
chmod u=r,go-rwx /etc/luks/boot_os.keyfile
```

### Schlüsseldatei in Key-Slots einfügen

Für root-Dateisystem:
```
cryptsetup luksAddKey /dev/sda4 /etc/luks/boot_os.keyfile
# Geben Sie irgendeine bestehende Passphrase ein: *****
```

Für swap-Speicher:
```
cryptsetup luksAddKey /dev/sda3 /etc/luks/boot_os.keyfile
# Geben Sie irgendeine bestehende Passphrase ein: *****
```

### Key-Slots inspizieren

Für root-Dateisystem
```
cryptsetup luksDump /dev/sda4 | grep "Key Slot"
# Key Slot 0: ENABLED
# Key Slot 1: ENABLED
# Key Slot 2: DISABLED
# Key Slot 3: DISABLED
# Key Slot 4: DISABLED
# Key Slot 5: DISABLED
# Key Slot 6: DISABLED
# Key Slot 7: DISABLED
```

Für swap-Speicher:
```
cryptsetup luksDump /dev/sda3 | grep "Key Slot"
# Key Slot 0: ENABLED
# Key Slot 1: ENABLED
# Key Slot 2: DISABLED
# Key Slot 3: DISABLED
# Key Slot 4: DISABLED
# Key Slot 5: DISABLED
# Key Slot 6: DISABLED
# Key Slot 7: DISABLED
```

### Schlüsseldatei für initramfs zugänglich machen
```
echo "KEYFILE_PATTERN=/etc/luks/*.keyfile" >> /etc/cryptsetup-initramfs/conf-hook
echo "UMASK=0077" >> /etc/initramfs-tools/initramfs.conf
```
Siehe hierzu im Speziellen: [Direktlink](https://cryptsetup-team.pages.debian.net/cryptsetup/README.initramfs.html#storing-keyfiles-directly-in-the-initrd)

### Schlüsseldatei in /etc/crypttab aufnehmen

Alle Zeichenfolgen *none* durch */etc/luks/boot_os.keyfile* ersetzen:
```
sed -i "s|none|/etc/luks/boot_os.keyfile|" /etc/crypttab
```

Kontrolle:
```
cat /etc/crypttab
# rootfs UUID=08b46b30-4d14-44d2-be97-8c021f172d29 /etc/luks/boot_os.keyfile luks
# swap UUID=6a4eb9d9-7a0f-4486-a4af-bc3e75c3cb38 /etc/luks/boot_os.keyfile luks
```

### GRUB installieren

signierten EFI-GRUB installieren:
```
apt install -y --reinstall grub-efi-amd64-signed
```

GRUB soll auf verschlüsselte Festplatten zugreifen können:
```
echo "GRUB_ENABLE_CRYPTODISK=y" >> /etc/default/grub
```

GRUB konfigurieren und als Bootmanager installieren:
```
update-initramfs -c -k all
grub-install /dev/sda
update-grub
```

### Initial Ramdisk inspizieren

Zugriffsrechte für Initial Ramdisk prüfen:
```
stat -L -c "%A  %n" /boot/initrd.img
# -rw-------  /boot/initrd.img
```

Prüfen, ob Schlüsseldatei in der Ramdisk vorhanden ist:
```
lsinitramfs /boot/initrd.img | grep "^cryptroot/keyfiles/"
# cryptroot/keyfiles/rootfs.key
```

### Erster Reboot

Chroot-Umgebung verlassen:
```
exit
```

Reboot:
```
reboot now
```

## Quellen
* https://wiki.thoschworks.de/thoschwiki/linux/ubuntumatebtrfsencrypted
* https://www.mutschler.eu/linux/install-guides/ubuntu-btrfs/
* https://cryptsetup-team.pages.debian.net/cryptsetup/encrypted-boot.html
* https://wiki.ubuntuusers.de/Btrfs-Dateisystem/
* https://wiki.ubuntuusers.de/LUKS/
* https://wiki.ubuntuusers.de/GRUB_2/
* https://help-grub.gnu.narkive.com/tYopC4mg/grub2-possible-to-change-keyboard-layout-in-stage-1-5
* https://wiki.archlinux.org/index.php/EFI_system_partition#GPT_partitioned_disks
* https://blog.seibert-media.net/blog/2020/09/30/grub-2-0-ablauf-des-bootvorgangs/
