# /etc/fstab automatisch generieren und formatieren

Das Programm *genfstab* aus dem Paket *arch-install-scripts* erzeugt aus den aktuell gemounteten Geräten eine *fstab*-Datei.

## fstab generieren

```
genfstab -U /

# /etc/fstab: static file system information.
#
# Use 'blkid' to print the universally unique identifier for a
# device; this may be used with UUID= as a more robust way to name devices
# that works even if disks are added and removed. See fstab(5).
#
# <file system=""><mount point=""><type><options><dump><pass>
# /dev/sdb2 LABEL=Ubuntu_18.04.3
UUID=5151eb20-3262-44de-aafc-0c977df2f6d5 /          ext4       rw,relatime,errors=remount-ro 0 1

# gvfsd-fuse
gvfsd-fuse           /run/user/1000/gvfs fuse.gvfsd-fuse rw,nosuid,nodev,user_id=1000,group_id=1000 0 0

# /dev/loop2
/dev/loop2           /snap/gnome-3-28-1804/110 squashfs   ro,nodev,relatime 0 0

# /dev/loop0
/dev/loop0           /snap/gnome-characters/375 squashfs   ro,nodev,relatime 0 0

# /dev/loop3
/dev/loop3           /snap/core18/1650 squashfs   ro,nodev,relatime 0 0

# /dev/loop1
/dev/loop1           /snap/gtk-common-themes/1353 squashfs   ro,nodev,relatime 0 0

# /dev/loop4
/dev/loop4           /snap/core/8592 squashfs   ro,nodev,relatime 0 0

# /dev/loop5
/dev/loop5           /snap/mp3splt-gtk/24 squashfs   ro,nodev,relatime 0 0

# /dev/loop6
/dev/loop6           /snap/gnome-calculator/544 squashfs   ro,nodev,relatime 0 0

# /dev/loop7
/dev/loop7           /snap/gnome-logs/81 squashfs   ro,nodev,relatime 0 0

# /dev/loop9
/dev/loop9           /snap/gnome-calculator/406 squashfs   ro,nodev,relatime 0 0

# /dev/loop10
/dev/loop10          /snap/gnome-logs/61 squashfs   ro,nodev,relatime 0 0

# /dev/loop8
/dev/loop8           /snap/gnome-3-28-1804/116 squashfs   ro,nodev,relatime 0 0

# /dev/loop11
/dev/loop11          /snap/vlc/1397 squashfs   ro,nodev,relatime 0 0

# /dev/loop12
/dev/loop12          /snap/gnome-characters/399 squashfs   ro,nodev,relatime 0 0

# /dev/loop13
/dev/loop13          /snap/gnome-system-monitor/127 squashfs   ro,nodev,relatime 0 0

# /dev/loop14
/dev/loop14          /snap/core/8268 squashfs   ro,nodev,relatime 0 0

# /dev/loop15
/dev/loop15          /snap/core18/1668 squashfs   ro,nodev,relatime 0 0

# /dev/loop16
/dev/loop16          /snap/gtk-common-themes/1440 squashfs   ro,nodev,relatime 0 0

# /dev/loop17
/dev/loop17          /snap/gnome-system-monitor/123 squashfs   ro,nodev,relatime 0 0

# /dev/sda1 LABEL=HOME
UUID=0ead98f2-5d92-4e0f-a19a-9bcf0b9d18ec /home      ext4       rw,nosuid,nodev,relatime,stripe=8191 0 2

# /dev/sda3 LABEL=DATA
UUID=6f7627ef-a414-48be-846c-f89bfd2a1684 /media/foo/DATA ext4       rw,nosuid,nodev,relatime,stripe=8191 0 2

# /dev/sda2 LABEL=VBOX
UUID=f8aa7d02-1668-4c05-b7ba-5f39c5fb368d /media/foo/VBOX ext4       rw,nosuid,nodev,relatime,stripe=8191 0 2

# /dev/sdb127
UUID=b0617ce8-7772-490c-ba8a-a6d5708ff3d8 none       swap       defaults,pri=-2 0 0
```

Unschwer zu erkennen ist der exessive Gebrauch von Tabulatoren, Zeilenumbrüchen, Kommentaren und nicht relevanten Einträgen.
Linux bietet natürlich das entsprechende Tool an, um diesem Umstand Rechnung zu tragen:

## generierte fstab mit sed formatieren und filtern

Die Ausgabe kann mit dem GNU-Tool *sed* sehr leicht in eine menschenlesbare Form gebracht werden:

```
genfstab -U / | sed 's/[[:space:][:blank:]]/ /g;s/ \{2,\}/ /g;/#/d;/^$/d;/UUID=/!d'

UUID=5151eb20-3262-44de-aafc-0c977df2f6d5 / ext4 rw,relatime,errors=remount-ro 0 1
UUID=0ead98f2-5d92-4e0f-a19a-9bcf0b9d18ec /home ext4 rw,nosuid,nodev,relatime,stripe=8191 0 2
UUID=6f7627ef-a414-48be-846c-f89bfd2a1684 /media/foo/DATA ext4 rw,nosuid,nodev,relatime,stripe=8191 0 2
UUID=f8aa7d02-1668-4c05-b7ba-5f39c5fb368d /media/foo/VBOX ext4 rw,nosuid,nodev,relatime,stripe=8191 0 2
UUID=b0617ce8-7772-490c-ba8a-a6d5708ff3d8 none swap defaults,pri=-2 0 0
```

Wobei:

* `genfstab -U / | sed`
  * Erzeuge den Text einer fstab-Datei aus den zur Zeit gemounteten Geräten und übergib diesen Text an den Befehl sed.
* `s/[[:space:][:blank:]]/ /g`
  * Wandle alle vertikalen und horizontalen Whitespaces in jeweils ein Leerzeichen um.
* `s/ \{2,\}/ /g`
  * Viele Leerzeichen in Folge durch eines ersetzen.
* `/#/d;/^$/d`
  * Lösche alle Kommentar- und Leerzeilen.
* `/UUID=/!d`
  * Zeige nur Zeilen mit UUID anstattdes Gerätepfades. Es werden dadurch jene Geräte ausgeblendet, die für den Bootvorgang keine Relevanz haben.

## Quellen:

* http://openbook.rheinwerk-verlag.de/shell_programmierung/shell_018_A_007.htm
* https://manpages.ubuntu.com/manpages/cosmic/man1/genfstab.1.html
