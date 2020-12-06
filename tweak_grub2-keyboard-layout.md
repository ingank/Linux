# Tastaturlayout der GRUB-2-Konsole anpassen

Die GRUB-2-Konsole (auch GRUB-2-CLI, GRUB-2-Terminal, ...)
nutzt voreingestellt das Tastaturlayout einer amerikanischen Tastatur.
Dementsprechend liegen verschiedene Sonderzeichen auf anderen Tasten als beschriftet (Auch die Tasten 'Z' und 'Y' sind vertauscht).

Dieses Mini-Howto beschreibt die Anpassung des GRUB-2-Tastaturlayouts an die eigene (deutsche) Hardware.

Bitte beachten, dass folgende Befehle als **Benutzer mit root-Rechten** ausgeführt werden!

## GRUB-2 Keyboard Layout - Datei erstellen

Mit Hilfe der Tastaturbeschreibungen unter */usr/share/X11/xkb/symbols/* kann für die lokale Tastatur (bspw. de) ein GRUB Keyboard Layout erstellt werden:

```
mkdir /boot/grub/layouts
grub-kbdcomp -o /boot/grub/layouts/de.gkb de
```

## Keyboard Layout in GRUB-2 einbinden

```
echo "insmod terminal" >> /etc/grub.d/40_custom
echo "terminal_output gfxterm" >> /etc/grub.d/40_custom
echo "insmod keylayouts" >> /etc/grub.d/40_custom
echo "insmod at_keyboard" >> /etc/grub.d/40_custom
echo "terminal_input at_keyboard" >> /etc/grub.d/40_custom
echo "keymap de" >> /etc/grub.d/40_custom
```

Die Datei */etc/grub.d/40_custom* sollte jetzt folgenden Inhalt haben:
```
#!/bin/sh
exec tail -n +3 $0
# This file provides an easy way to add custom menu entries.  Simply type the
# menu entries you want to add after this comment.  Be careful not to change
# the 'exec tail' line above.
insmod terminal
terminal_output gfxterm
insmod keylayouts
insmod at_keyboard
terminal_input at_keyboard
keymap de
```

Danach wird die GRUB-2 Konfiguration aktualisiert:
```
update-grub
```

Ab sofort kann in der GRUB-2-Konsole mit einer deutschen Tastatur gearbeitet werden.

## Spezialfall Cryptodisk

Dies ist eine Schritt-für-Schritt Kurzanleitung für den Fall,
dass GRUB zum Entschlüsseln einer LUKS-btrfs Systempartition
genutzt wird.

### Verzeichnis wechseln
```
cd /boot/efi/EFI/ubuntu
```

### Keyboard-Map erstellen
```
grub-kbdcomp -o de.gkb de
tar cf memdisk.tar de.gkb
```

### early-grub.cfg aus grub.cfg generieren
```
cp grub.cfg early-grub.cfg
nano early-grub.cfg
```
Inhalt Original:
```
cryptomount -u 08b46b304d1444d2be978c021f172d29
search.fs_uuid 3a3b8bdd-e950-4f8e-83a4-1119c4c489b0 root cryptouuid/08b46b304d1444d2be978c021f172d29 
set prefix=($root)'/@/boot/grub'
configfile $prefix/grub.cfg
```
Inhalt Neu:
```
set root=(memdisk)
set prefix=($root)/
terminal_input at_keyboard
keymap /de.gkb
cryptomount -u 08b46b304d1444d2be978c021f172d29
search.fs_uuid 3a3b8bdd-e950-4f8e-83a4-1119c4c489b0 root cryptouuid/08b46b304d1444d2be978c021f172d29 
set prefix=($root)'/@/boot/grub'
configfile $prefix/grub.cfg
```

### Neues GRUB core Image erzeugen
```
grub-mkimage \
-c ./early-grub.cfg \
-m ./memdisk.tar \
-o ./grubx64.efi.new \
-O x86_64-efi \
part_gpt \
cryptodisk \
luks \
gcry_rijndael \
gcry_sha256 \
btrfs \
memdisk \
tar \
at_keyboard \
usb_keyboard \
keylayouts \
configfile \
loadenv \
font \
test \
search \
echo \
linux \
search_fs_uuid \
reboot
```

### altes Image überschreiben
```
cp grubx64.efi.new grubx64.efi
```

## Quellen

* https://wiki.ubuntuusers.de/GRUB_2/Shell/
* https://askubuntu.com/questions/751259/how-to-change-grub-command-line-grub-shell-keyboard-layout
