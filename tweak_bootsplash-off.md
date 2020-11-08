# Deaktivierung des Bootsplash

Grafische Spielereien können während des Bootens wichtige Meldungen überdecken.

## Tweak

Bootmessages von Kernel und Init-System sollen angezeigt werden:

```
sudo nano /etc/default/grub
```

Zeile:
```
GRUB_CMDLINE_LINUX_DEFAULT=quiet splash
```

Ändern in:
```
GRUB_CMDLINE_LINUX_DEFAULT=noplymouth
```

Danach den Grub-Bootloader aktualisieren:
```
sudo update-grub
```
