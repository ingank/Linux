# GRUB 2 - Hoheit zurückholen

Das Testen von Linux-Distributionen ist das Butter- und Brotgeschäft von Freunden Freier Software.
Nun, natürlich kann es vorkommen, dass nach der Installation eines solchen Linux'es der Bootvorgang,
respektive der Bootloader,
vom neuen System *gekapert* wurde.
Folgende kleine Helferlein werden in Nullkommanichts das Ruder wieder dem angestammten Betriebssystem übergeben.

Alle der folgenden Befehle werden als Benutzer mit root-Rechten ausgeführt.

## update-grub

Dieser Befehl erstellt eine neue Datei */boot/grub/grub.cfg* aus den systemweit gesammelten Informationen und Konfigurationsdateien:

```
update-grub
```

## grub-install

Wenn `update-grub` nicht zum Erfolg geführt hat, dann muss Grub neu installiert werden.
Folgender Befehl installiert den Bootloader im MBR des angegebenen Blockgeräts.
Für */dev/foo* muss die Bezeichnung des eigenen Bootgerätes eingesetzt werden ( Beispiel: */dev/sdx* ):

```
grub-install /dev/foo
```

## update-initramfs

Wenn der Bootvorgang zwar in das richtige Betriebssystem bootet, sich jedoch nach ca. 10 Sekunden deutlich verzögert,
kann es sein, dass die Installationsroutine der Testdistribution die Swap-Partition formatiert und damit eine neue UUID vergeben hat.
Folgender Befehl erzeugt neue initiale Ramdisks für jeden der installierten Kernel und verlinkt jeweils die Swap-Partition neu.

```
update-initramfs -c -k all
```

## Siehe auch:

* [fix_frozen-bootstrap.md](fix_frozen-bootstrap.md)
