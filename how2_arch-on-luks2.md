# Arch Linux mit dm-crypt/LUKS2 verschlüsseln
Anleitung in einfacher Sprache ohne Ablenkung.

### Kurzbeschreibung des Systems
* die Rechner-Firmware ist EFI
* EFI Secure Boot ist ausgeschaltet
* die EFI-Systempartition ist unverschlüsselt
* Kernel und initramfs sind auf der EFI-Systempartition gespeichert
* bootctl oder GRUB ist der Bootloader
* rootfs und /home sind in einem dm-crypt/LUKS2-Container verschlüsselt
* als Dateisystem kommt ext4 zum Einsatz
* das Betriebssystem ist Arch-Linux

### Vorbereitung
* ISO-Datei des neuesten Arch Linux herunterladen
* ISO-Datei booten
* Konsole des Users `root` wird angezeigt

### deutsche Tastatur einstellen
```
loadkeys de-latin1
```

### Passwort für root ändern
```
passwd
```

### ip ermitteln
```
ip a sh
```

### Von einem beliebigen Rechner im Netzwerk weiterarbeiten
```
ssh root@<ip-addr>
```

### Blockgerätedatei für Systemfestplatte ermitteln und merken
```
lsblk -p
HD='/dev/sda'  # Beispiel
```

### Neue GPT auf Systemfestplatte erzeugen
```
sgdisk -o $HD
```

### Partitionen auf Systemfestplatte anlegen
```
sgdisk -n 0:0:+512M -t 0:ef00 -c 0:'EFI system partition'  $HD
sgdisk -n 0:0:0 -t 0:8300 -c 0:'Linux filesystem' $HD
```

### Partitionen prüfen
```
sgdisk -p $HD
```
```
>>>
Number  Start (sector)    End (sector)  Size       Code  Name
   1            2048         1050623   512.0 MiB   EF00  EFI system partition
   2         1050624        41943006   19.5 GiB    8300  Linux filesystem
<<<
```

### Blockgerätedateien für Partitionen ermitteln
```
lsblk -p
```

### Blockdateien für Partitionen merken (Beispiel)
```
EFI='/dev/sda1'
LUKS='/dev/sda2'
```
### LUKS-Container anlegen
```
cryptsetup luksFormat $LUKS
```

### LUKS-Container inspizieren
```
cryptsetup luksDump $LUKS
```

### LUKS-Container nach /dev/mapper/lvm mappen
```
cryptsetup luksOpen $LUKS lvm
```

### Schaubild beachten
https://wiki.archlinux.de/images/Partitionsschema_bei_uefi_mit_verschluesselung.png

### PV (LVM Physical Volume) erstellen
```
pvcreate /dev/mapper/lvm
```

### VG (LVM Volume Group) mit dem Namen 'main' erstellen
```
vgcreate main /dev/mapper/lvm
```

### LV (LVM Logical Volume) mit den Namen 'root' und 'home' erstellen
```
lvcreate -l 50%FREE -n root main
lvcreate -l 100%FREE -n home main
```

### PV/VG/LV (Mehrzahl) inspizieren
`lvdisplay, lvscan, lvs, vgscan, vgs, pvscan, pvs`

### Dateisysteme in '/', '/home' und EFI erstellen
```
mkfs.ext4 -L root /dev/mapper/main-root
mkfs.ext4 -L home /dev/mapper/main-home
mkfs.fat -F32 $EFI
```

### Partitionen für die Installation mounten (/, /home, /boot/efi)
```
mount /dev/mapper/main-root /mnt
mkdir /mnt/home
mount /dev/mapper/main-home /mnt/home
mkdir /mnt/boot
mount $EFI /mnt/boot
```

### Spiegelserverliste standortbezogen updaten (kann dauern)
```
reflector -c Germany -p http -p https --sort rate -n 5 > /etc/pacman.d/mirrorlist
```

### Basissystem installieren
```
pacstrap /mnt base base-devel linux linux-firmware \
    dosfstools gptfdisk lvm2 efibootmgr \
    dhcpcd dhclient networkmanager \
    nano man-db 
```

### /etc/fstab erzeugen
```
genfstab -Lp /mnt > /mnt/etc/fstab
```

### in das neue Betriebssystem wechseln
```
arch-chroot /mnt
```

### Rechnernamen festlegen
```
echo arch > /etc/hostname
```

### englische Lokalisierung
```
echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen
echo 'LANG=en_US.UTF-8' > /etc/locale.conf
locale-gen
```

### deutsche Konsolen-Tastatur
```
echo 'KEYMAP=de-latin1' > /etc/vconsole.conf
```

### Zeitzone auf Berlin einstellen
```
ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
```

### Hardwareuhr einstellen
```
hwclock --systohc
```

### initramfs vorbereiten
```
nano /etc/mkinitcpio.conf
```
```
>>>
MODULES=(ext4)
HOOKS=(base udev autodetect modconf block keyboard keymap encrypt lvm2 filesystems fsck shutdown)
<<<
```

### initramfs generieren
```
mkinitcpio -p linux
```

### root-Passwort festlegen
```
passwd
```

### bootctl als Bootloader
Vier Punkte.

#### Bootloader schreiben
```
bootctl install
```

#### Menüeintrag 'Arch Linux'
```
cat << EOT > /boot/loader/entries/arch.conf
title    Arch Linux
linux    /vmlinuz-linux
initrd   /initramfs-linux.img
options  cryptdevice=${LUKS}:main root=/dev/mapper/main-root rw init=/usr/lib/systemd/systemd
EOT
```
#### Menüeintrag 'Arch Linux Fallback'
```
cat << EOT > /boot/loader/entries/arch-fallback.conf
title    Arch Linux Fallback
linux    /vmlinuz-linux
initrd   /initramfs-linux-fallback.img
options  cryptdevice=${LUKS}:main root=/dev/mapper/main-root rw init=/usr/lib/systemd/systemd
EOT
```

#### bootctl - Grundeinstellungen
```
cat << EOT > /boot/loader/loader.conf
timeout 1
default arch.conf
EOT
```

### GRUB als Bootloader
Zwei Punkte.

#### GRUB - Grundeinstellungen
```
# /etc/default/grub
GRUB_CMDLINE_LINUX="cryptdevice=/dev/sda2:main init=/usr/lib/systemd/systemd"
```
#### Bootloader und Konfiguration schreiben 
```
grub-install --efi-directory=/boot
grub-mkconfig -o /boot/grub/grub.cfg
```

### System verlassen und neu starten
```
exit
umount /mnt/{boot,home,}
reboot
```
