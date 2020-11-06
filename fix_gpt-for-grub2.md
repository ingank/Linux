# GRUB 2 - GPT - EF02

Das ist doch die Situation hier:
```
sudo grub-install /dev/sda

Installing for i386-pc platform.
grub-install: warning: this GPT partition label contains no BIOS Boot Partition; embedding won't be possible.
grub-install: warning: Embedding is not possible.  GRUB can only be installed in this setup by using blocklists.  However, blocklists are UNRELIABLE and their use is discouraged..
grub-install: error: will not proceed with blocklists.
```

## Blocklisten verwenden (nicht empfohlen)

```
sudo grub-install /dev/sda --force

Installing for i386-pc platform.
grub-install: warning: this GPT partition label contains no BIOS Boot Partition; embedding won't be possible.
grub-install: warning: Embedding is not possible.  GRUB can only be installed in this setup by using blocklists.  However, blocklists are UNRELIABLE and their use is discouraged..
Installation finished. No error reported.
```

## Platz für den Stage 1.5 schaffen (empfohlen)

```
sudo gdisk /dev/sda

GPT fdisk (gdisk) version 1.0.3
Partition table scan:
  MBR: protective
  BSD: not present
  APM: not present
  GPT: present
Found valid GPT with protective MBR; using GPT.

Command (? for help): p

Disk /dev/sda: 976773168 sectors, 465.8 GiB
Model: Samsung SSD 860 
Sector size (logical/physical): 512/512 bytes
Disk identifier (GUID): 228FFF52-F156-4F8B-8E4F-713E6FD9966A
Partition table holds up to 128 entries
Main partition table begins at sector 2 and ends at sector 33
First usable sector is 34, last usable sector is 976773134
Partitions will be aligned on 2048-sector boundaries
Total free space is 825778157 sectors (393.8 GiB)
Number  Start (sector)    End (sector)  Size       Code  Name
   1            2048        16779263   8.0 GiB     8200  SSD01.01
   2        16779264       150996991   64.0 GiB    8300  SSD01.02

Command (? for help): n

Partition number (3-128, default 3): 128

First sector (34-976773134, default = 150996992) or {+-}size{KMGTP}: 1024

Last sector (1024-2047, default = 2047) or {+-}size{KMGTP}: 2047

Current type is 'Linux filesystem'
Hex code or GUID (L to show codes, Enter = 8300): ef02

Changed type of partition to 'BIOS boot partition'

Command (? for help): p

Disk /dev/sda: 976773168 sectors, 465.8 GiB
Model: Samsung SSD 860 
Sector size (logical/physical): 512/512 bytes
Disk identifier (GUID): 228FFF52-F156-4F8B-8E4F-713E6FD9966A
Partition table holds up to 128 entries
Main partition table begins at sector 2 and ends at sector 33
First usable sector is 34, last usable sector is 976773134
Partitions will be aligned on 2048-sector boundaries
Total free space is 825777133 sectors (393.8 GiB)
Number  Start (sector)    End (sector)  Size       Code  Name
   1            2048        16779263   8.0 GiB     8200  SSD01.01
   2        16779264       150996991   64.0 GiB    8300  SSD01.02
 128            1024            2047   512.0 KiB   EF02  BIOS boot partition

Command (? for help): w

Final checks complete. About to write GPT data. THIS WILL OVERWRITE EXISTING
PARTITIONS!!

Do you want to proceed? (Y/N): y

OK; writing new GUID partition table (GPT) to /dev/sda.
Warning: The kernel is still using the old partition table.
The new table will be used at the next reboot or after you
run partprobe(8) or kpartx(8)
The operation has completed successfully.
 
sudo grub-install /dev/sda
Installing for i386-pc platform.
Installation finished. No error reported.
```
