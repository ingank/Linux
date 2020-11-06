# Tastaturlayout der GRUB-2-Konsole anpassen

Die GRUB-2-Konsole (auch GRUB-2-CLI, GRUB-2-Terminal, ...)
nutzt voreingestellt das Tastaturlayout einer amerikanischen Tastatur.
Dementsprechend liegen verschiedene Sonderzeichen auf anderen Tasten als beschriftet (Auch \'z\' und \'y\' sind vertauscht).

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

## Quellen

* https://wiki.ubuntuusers.de/GRUB_2/Shell/
* https://askubuntu.com/questions/751259/how-to-change-grub-command-line-grub-shell-keyboard-layout
