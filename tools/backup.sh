#!/bin/sh

# Einfachstes Sichern der persönlichen Daten.
# Inspiriert durch:
# https://wiki.ubuntuusers.de/Skripte/Backup_mit_RSYNC/

quelle=/home/foo/
ziel=/media/foo/MEDIUM/Ordner
heute=$(date +%Y-%m-%d)

# aktuelle selbst installierte Pakete als Liste
comm -23 \
  <(apt-mark showmanual | sort -u) \
  <(gzip -dc /var/log/installer/initial-status.gz | sed -n 's/^Package: //p' | sort -u) \
  > ${quelle}my-packages.txt

# abschließendes '/' beim Ziel sicherstellen
if [ "${ziel:${#ziel}-1:1}" != "/" ]; then
  ziel=$ziel/
fi

rsync -avR --delete "${quelle}"  "${ziel}${heute}/" --link-dest="${ziel}last/"
ln -nsf "${ziel}${heute}" "${ziel}last"

exit 0
