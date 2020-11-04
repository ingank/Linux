# Fix: initrd und swap unterbrechen Bootvorgang

## Problembeschreibung

Der Bootvorgang eines Ubuntu 18.04 friert nach ca. 10 Sekunden für 20-30 Sekunden bei folgender Meldung ein:

```
Begin: Running /scripts/local-premount
```

## Lösungsansatz
```
sudo update-initramfs -u
```
