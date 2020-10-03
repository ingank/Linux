#!/bin/bash

# Einfachstes Sichern der persönlichen Daten.
# Inspiriert durch:
# https://wiki.ubuntuusers.de/Skripte/Backup_mit_RSYNC/

quelle=/home/foo/
ziel=/media/foo/Backup-Folder/
heute=$(date +%Y-%m-%d)

# abschließendes '/' beim Ziel sicherstellen
if [ "${ziel:${#ziel}-1:1}" != "/" ]; then
  ziel=$ziel/
fi

rsync -avR --delete "${quelle}"  "${ziel}${heute}/" --link-dest="${ziel}last/"
ln -nsf "${ziel}${heute}" "${ziel}last"

exit 0
