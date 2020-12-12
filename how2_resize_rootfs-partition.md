# Das Root-Dateisystem (/) zur Laufzeit vergrößern

Ein Paar Informationen über das derzeitige Root-Dateisystem sammeln:
```
df /
# Filesystem     1K-blocks    Used Available Use% Mounted on
# /dev/sda2       31365948 5249140  24500424  18% /
```

Die Partition `/dev/sda2` ist die Nr. 2 des Blockgerätes `/dev/sda`.
Um sie zu vergrößern, kann das Tool `parted` verwendet werden.

In einer Terminalemulation beziehungsweise auf der Konsole werden mit *root-Rechten* folgende Befehle ausgeführt:

```
parted /dev/sda
# (parted) resizepart 2
# Warning: Partition /dev/sda2 is being used. Are you sure you want to continue?
# Yes/No? yes
# End?  [41.0GB]? 82GB
# (parted) q
# Information: You may need to update /etc/fstab.
```

Nachdem die Größe der Partition geändert wurde, muss auch die Dateisystemgröße angepasst werden:
```
resize2fs /dev/sda2
# resize2fs 1.45.5 (07-Jan-2020)
# Filesystem at /dev/sda2 is mounted on /; on-line resizing required
# old_desc_blocks = 4, new_desc_blocks = 9
# The filesystem on /dev/sda2 is now 18019403 (4k) blocks long.
```

Mit diesem Befehl werden die Änderungen überprüft:
```
df /
# Filesystem     1K-blocks    Used Available Use% Mounted on
# /dev/sda2       70817420 5253016  62349464   8% /
```