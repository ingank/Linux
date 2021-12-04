# Live-ISO's mit GRUB-2 direkt starten

GRUB 2 ist in der Lage,
den Kernel und die initiale Ramdisk direkt aus einer ISO-Datei zu beziehen.
Diese Anleitung befasst sich anhand dreier gängiger Rescue-Live-Systeme
mit der Nutzung dieses nicen Gadgets ;)

## Testumgebung

* beliebige Linux-Distribution
* GPT als Partitionierungsschema
* GRUB 2 ist installiert und bootet von */dev/sdX*
* */dev/sdX* bezeichnet die erste Systemfestplatte

**Anmerkung:**
Das GPT-Schema wird in diesem Howto explizit dem MBR vorgezogen,
um der mittlerweile umfassenden Verbreitung Rechnung zu zollen.
Nichtdestotrotz dürfte eine Portierung der Beispiele
auf eine MBR-Partitionstabelle grundsätzlich keine größeren Hürden bereiten.

## Vorbereitung

Alle Live-ISO's werden auf einer gesonderten Partition gespeichert.
Diese sollte dementsprechend dimensioniert werden:

```
sudo gdisk /dev/sdX
```

* Taste *"n"*
  * neue Partition
  * Größe beispielsweise *32G*
  * Partitionstyp = 8300
* Taste *"c"*
  * Name (Label) der Partition festlegen
  * beispielsweise *isopart*
* Taste *"p"*
  * aktuelle Partitionstabelle ausgeben
* Taste *"w"*
  * Änderungen auf den Datenträger schreiben und Programm beenden

System rebooten:
```
sudo init 6
```

Dateisystem erstellen:
```
sudo mkfs.ext4 /dev/sdXY     # Y = GPT-Index der Partition
```

Wobei Y = GPT-Index der Partition.

UUID des Blockgerätes ermitteln und für später notieren:
```
sudo blkid -oudev /dev/sdXY

ID_FS_UUID=33756e2f-df43-4189-8552-6d3817dff551
ID_FS_UUID_ENC=33756e2f-df43-4189-8552-6d3817dff551
ID_FS_TYPE=ext4
ID_FS_PARTLABEL=isopart
ID_FS_PARTUUID=e5971507-b1eb-4282-bd26-567b44ef1478
```

UUID des Dateisystems prüfen und adhoc mounten:
```
sudo mount /dev/disk/by-uuid/33756e2f-df43-4189-8552-6d3817dff551 /mnt
```

## Beispiel 1: SystemRescueCd v6.0.0+

Die originale ISO-Datei (beispielsweise *systemrescuecd-6.0.5.iso*)
wird in den Ordner */mnt* kopiert und umbenannt in *systemrescuecd.iso*.
Auf diese Weise ist sicher gestellt,
dass neue Versionen der Distribution
in Zukunft einfach durch die Ersetzung dieser Datei eingespielt werden können.
Weiterer Vorteil:
Der GRUB 2 Bootlader muß für das Update nicht aktualisiert werden.

Jetzt wird der Datei */etc/grub.d/40_custom* folgender Bootmenüeintrag hinzugefügt:
```
menuentry SystemRescueCd (isoloop) {
 load_video
 insmod gzio
 insmod part_gpt
 insmod ext2
 set isofile=/systemrescuecd.iso
 search --no-floppy --set=root --fs-uuid 33756e2f-df43-4189-8552-6d3817dff551
 loopback loop ${isofile}
 echo 'Loading kernel ...'
 linux (loop)/sysresccd/boot/x86_64/vmlinuz img_dev=/dev/disk/by-uuid/33756e2f-df43-4189-8552-6d3817dff551 img_loop=${isofile} archisobasedir=sysresccd setkmap=de
 echo 'Loading initramfs ...'
 initrd (loop)/sysresccd/boot/x86_64/sysresccd.img
}
```

Neue Konfiguration dem GRUB 2 Bootloader bekannt geben:
```
sudo update-grub
```

Systemneustart:
```
sudo init 6
```

Durch Anwahl des Menüpunktes *SystemRescueCd (isoloop)* im Bootmenü
kann fortan die SystemRescueCd direkt von Festplatte gestartet werden.

## Beispiel 2: GParted Live v1.1.0

Die originale ISO-Datei (beispielsweise *gparted-live-1.1.0-1-amd64.iso*)
wird in den Ordner */mnt* kopiert und umbenannt in *gparted-live.iso*.
Auf diese Weise ist sicher gestellt,
dass neue Versionen der Distribution in Zukunft einfach durch
die Ersetzung dieser Datei eingespielt werden können.
Weiterer Vorteil: Der GRUB 2 Bootlader muß für das Update nicht aktualisiert werden.

Jetzt wird der Datei */etc/grub.d/40_custom* folgender Bootmenüeintrag hinzugefügt:
```
menuentry GParted Live (isoloop) {
 load_video
 insmod gzio
 insmod part_gpt
 insmod ext2
 gfxpayload=800x600x16,800x600
 set isofile=/gparted-live.iso
 search --no-floppy --set=root --fs-uuid 33756e2f-df43-4189-8552-6d3817dff551
 loopback loop ${isofile}
 echo 'Loading kernel ...'
 linux (loop)/live/vmlinuz boot=live config union=overlay username=user components noswap noeject ip= net.ifnames=0 toram=filesystem.squashfs findiso=${isofile}
 echo 'Loading initramfs ...'
 initrd (loop)/live/initrd.img
}
```

Neue Konfiguration dem GRUB 2 Bootloader bekannt geben:
```
sudo update-grub
```

Systemneustart:
```
sudo init 6
```

Durch Anwahl des Menüpunktes *GParted Live (isoloop)*
im Bootmenü kann fortan GParted Live direkt von Festplatte gestartet werden.

## Beispiel 3: grml v2018.12

Die originale ISO-Datei (beispielsweise *grml64-full_2018.12.iso*)
wird in den Ordner */mnt* kopiert und umbenannt in *grml64-full.iso*.
Auf diese Weise ist sicher gestellt,
dass neue Versionen der Distribution in Zukunft einfach durch die Ersetzung
dieser Datei eingespielt werden können.
Weiterer Vorteil: Der GRUB 2 Bootlader muß für das Update nicht aktualisiert werden.

Jetzt wird der Datei */etc/grub.d/40_custom* folgender Bootmenüeintrag hinzugefügt:
```
menuentry GRML-Full (isoloop) {
 load_video
 insmod gzio
 insmod part_gpt
 insmod ext2
 set isofile=/grml64-full.iso
 search --no-floppy --set=root --fs-uuid 33756e2f-df43-4189-8552-6d3817dff551
 loopback loop ${isofile}
 echo 'Loading kernel ...'
 linux (loop)/boot/grml64full/vmlinuz findiso=${isofile} live-media-path=/live/grml64-full/ ignore_bootid apm=power-off lang=de boot=live nomce noeject noprompt --
 echo 'Loading initramfs ...'
 initrd (loop)/boot/grml64full/initrd.img
}
```

Neue Konfiguration dem GRUB 2 Bootloader bekannt geben:
```
sudo update-grub
```

Systemneustart:
```
sudo init 6
```

Durch Anwahl des Menüpunktes *GRML-Full (isoloop)*
im Bootmenü kann fortan grml direkt von Festplatte gestartet werden.

## Beispiel 4: weitere ISO\'s

1. ISO herunterladen und auf ISO-Partition speichern.
1. Der ISO einen allgemeineren Namen geben (Versionsnummer löschen).
1. Der Datei */etc/grub.d/40_custom* ein Bootmenüeintrag nach folgender Schablone hinzufügen:

```
menuentry FooLiveDistro (isoloop) {
 load_video
 insmod gzio
 insmod part_gpt
 insmod ext2
 set isofile=/foo.iso
 search --no-floppy --set=root --fs-uuid 33756e2f-df43-4189-8552-6d3817dff551
 loopback loop ${isofile}
 echo 'Loading kernel ...'
 linux (loop)/path/to/vmlinuz foo=bar foo2=bar2
 echo 'Loading initramfs ...'
 initrd (loop)/path/to/initrd.img
}
```

4. Googlesuche: *FooLiveDistroTool Grub loopback loop kernel params*.
1. Die Optionen inerhalb der Datei */etc/grub.d/40_custom* entsprechend den gefundenen Informationen angleichen.
1. Grub neu konfigurieren:

```
sudo update-grub
```

## Quellen
* http://www.system-rescue-cd.org/manual/Installing_SystemRescueCd_on_the_disk
* https://gparted.org/livehd.php
* https://github.com/lorenzhs/usbmultiboot/blob/master/boot/grub/grub.cfg
