# Ubuntu mit Legacy GRUB als Bootloader

Aktuelle Distributionen setzen als Bootloader vorrangig auf GRUB 2.
Wer sein Praxiswissen über den in die Jahre gekommenen Legacy GRUB (v0.97) auffrischen möchte,
kann dies in einer VM gefahrlos tun.
Diese Anleitung beschreibt die Erzeugung einer solchen virtuellen Maschine.
Gleichzeitig kann sie auch als Blaupause für eine Installation auf echter Hardware dienen.

## Plattform

- Oracle VM Virtual Box 6.1
- Ubuntu 18.04 Server Installationsmedium
- SystemRescueCd 6.0.5 LiveCD
- Legacy GRUB 0.97.70

## VM erstellen

In Oracle VM Virtual Box:

- Gehe zu:
  - Maschine
  - Neu...
- Name: Ubuntu ...
- Typ: Linux
- Version: Ubuntu (64bit)
- Klicke [Weiter >]
- Klicke [Weiter >]
- Klicke [Erzeugen]
- Klicke [Weiter >]
- Klicke [Weiter >]
- Größe der virtuellen Festplatte: '64 GB' eingeben
- Klicke [Erzeugen]
- Gehe zu:
  - Maschine
  - Ändern...
  - Netzwerk
- Wähle:
  - Angeschlossen an: Netzwerkbrücke
- Gehe zu:
  - Sicherungspunkt
  - Erzeugen...
- Name des Sicherungspunktes vergeben, Beispiel 'PRE_INIT'
- Klicke [OK]

## Virtuelle Festplatte bearbeiten

Die oben erzeugte Festplatte muss noch an die Vorgaben des legacy GRUB angepasst werden.
Signalwörter in diesem Zusammenhang sind _Inode-Größe_ und _STAGE_1.5_

In Oracle VM Virtual Box:

- Gehe zu:
  - Maschine
  - Ändern...
  - Massenspeicher
  - Controller: IDE
  - leer
  - blaue CD bei 'Attribute'
  - Abbild auswählen...
- Wähle das ISO Abbild der SystemRescueCd
- Klicke [OK]
- Gehe zu:
  - Maschine
  - Starten

SystemRescueCd startet direkt in eine Root-Konsole.
Die nun folgenden Tätigkeiten werden in dieser Konsole ausgeführt.

Die Tastatur auf deutsch umstellen:
```
setkmap de-latin1
```

Block-Device der Festplatte ermitteln:
```
fdisk -l
```

Festplatte partitionieren, dabei für foo das ermittelte Block-Device eintragen:
```
fdisk /dev/foo
  Command (m for help): o <ENTER>
  Command (m for help): n <ENTER><ENTER><ENTER> +8G <ENTER>
  Command (m for help): n <ENTER><ENTER><ENTER> +1G <ENTER>
  Command (m for help): n <ENTER><ENTER><ENTER><ENTER>
  Command (m for help): t <ENTER> 1 <ENTER> 82 <ENTER>
  Command (m for help): w <ENTER>
```

Dateisysteme erstellen:
```
mkswap /dev/sdX1
mkfs.ext3 -I 128 /dev/sdX2
mkfs.ext3 -I 128 /dev/sdX3
```

Prüfen der Inode-Größe (inode size = 128?):
```
tune2fs -l /dev/sdX2
tune2fs -l /dev/sdX3
```

System anhalten:
```
halt
```

## Ubuntu in der VM installieren

Zurück in Oracle VM Virtual Box:

- Gehe zu:
  - Maschine
  - Ändern...
  - Massenspeicher
  - Controller: IDE
  - leer
  - blaue CD bei 'Attribute'
  - Abbild auswählen...
- Wähle das ISO Abbild des Ubuntu Server Installationsmediums
- Klicke [OK]
- Gehe zu:
  - Maschine
  - Starten

Ubuntu Server Installationsvorgang:

- Language = Deutsch
- F3 (Tastatur) = Deutsch
- F4 (Optionen) = Eine minimale virtuelle Maschine installieren
- Ubuntu Server installieren
- In der gewählen Sprache fortsetzen: JA
- Land oder Gebiet: Deutschland
- Rechnername eingeben
- Hauptbenutzer und Passwort einrichten
- Aktive Partitionen aushängen: NEIN
- Partitionierungsmethode: Manuell
  - Gehe zu: `Nr. 1  primär   8.6 GB`
  - <ENTER>
      - Benutzen als: Auslagerungsspeicher (Swap)
      - Anlegen der Partition beenden
  - Gehe zu: `Nr. 2  primär   1.1 GB`
  - <ENTER>
      - Benutzen als: Ext3-Journaling-Dateisystem
      - Einbindungspunkt: `/boot`
      - Anlegen der Partition beenden
  - Gehe zu: `Nr. 3  primär   59.1 GB`
  - <ENTER>
      - Benutzen als: Ext3-Journaling-Dateisystem
      - Einbindungspunkt: / (Wurzelverzeichnis)
      - Anlegen der Partition beenden
  - Gehe zu: Partitionierung beenden und Änderungen übernehmen
- Möchten Sie zum Partitionsmenü zurückkehren? NEIN
- Änderungen auf Festplatten schreiben? JA
- Proxy auswählen oder WEITER
- Wie Aktualisierungen verwalten? Keine automatischen Aktualisierungen
- Welche Software soll installiert werden? OpenSSH server
- GRUB-Bootloader in den MBR installieren? JA
- Installation abschließen: WEITER

Das System rebootet automatisch in Runlevel 3.

## Downgrade GRUB 2 auf Legacy GRUB

System aktualisieren:

```
sudo apt-get update
sudo apt-get upgrade
```

GRUB 2 deinstallieren. Dabei die Frage 'GRUB aus /boot/grub entfernen?' mit YES beantworten:
```
sudo apt-get purge grub* os-prober
```

Legacy GRUB downloaden:
```
wget http://ftp.de.debian.org/debian/pool/main/g/grub/grub-legacy_0.97-70_amd64.deb
```

Legacy GRUB in Ubuntu installieren:
```
sudo apt-get install ./grub-legacy_0.97-70_amd64.deb
```

GRUB-Menu erzeugen:
```
sudo update-grub
```

Legacy GRUB als Bootloader installieren:
```
sudo grub-install /dev/sda
```

Spuren der letzten Arbeiten verwischen:
```
echo | sudo tee /var/log/btmp | sudo tee /var/log/wtmp | sudo tee /var/log/lastlog
```

## Quellen

* https://www.gnu.org/software/grub/manual/legacy/grub.html
* https://www.gnu.org/software/grub/manual/grub/grub.html
* https://wiki.ubuntuusers.de/Grub_2_durch_Grub_ersetzen/
* https://manpages.ubuntu.com/manpages/trusty/en/man5/fs.5.html
* https://wiki.ubuntuusers.de/fdisk/
* https://www.cyberciti.biz/faq/howto-display-clear-last-login-information/
* http://www.system-rescue-cd.org/disk-partitioning/Introduction-to-disk-partitioning/
* http://www.system-rescue-cd.org/disk-partitioning/The-new-GPT-disk-layout/
* https://wiki.archlinux.org/index.php/GRUB_Legacy#GRUB_boot_disk
* https://wiki.archlinux.org/index.php/GRUB#GUID_Partition_Table_.28GPT.29_specific_instructions

