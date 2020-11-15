# Homeverzeichnis auf separate Partition verlagern

Dieses Mini-Howto beschreibt den Umzug des */home* - Verzeichnisses auf eine andere (beispielsweise externe) Partition.
Es wird davon ausgegangen, dass */home* **noch nicht** auf eine gemountete Partition verweist.

##  Partition erstellen

Derzeitige Größe des Verzeichnisses */home* ermitteln:
```
du -s -h /home
```

Mit Hilfe des GUI-Tools *GParted* wird eine leere Partition auf einer beliebigen Festplatte erzeugt.
Die vorher ermittelte Größe kann als Richtschnur für die Minimalgröße herangezogen werden.
Als Dateisystemformat kommt *ext4* zum Einsatz.

## Verzeichnisinhalt kopieren

Im GUI-Tool *Laufwerke* wird die neu erstellte Partition eingehangen.
Das Programm zeigt daraufhin praktischerweise den temporären Mountpoint
des Ziels blau-unterstrichen an.
In unserem Beispiel lautet er */mnt/tmp*.

Folgender Befehl führt testweise den Kopierprozess durch:
```
sudo rsync -axHn --stats /home/ /mnt/tmp
```
Wenn keine Fehlermeldungen ausgegeben wurden, können die Dateien physikalisch kopiert werden:
```
sudo rsync -axH --stats /home/ /mnt/tmp
```

# UNDER CONSTRUCTION #

## Partition testweise mounten

## Partition dauerhaft mounten
