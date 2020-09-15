#!/bin/bash

# README.make
# Dieses Skript erzeugt automatisch eine aktuelle README.md-Datei
# aus den Dateien im Hauptverzeichnis

FILE='./README.md'
LIST=(`ls *.md | grep -Ev README`)
DATE=`date`

echo "# Linux" > $FILE
echo >> $FILE
echo "Das Schweizer Taschenmesser für den Linuxalltag." >> $FILE
echo >> $FILE

for i in "${LIST[@]}";
do
  echo "* [$i]($i)" >> $FILE;
done

echo >> $FILE
echo "Aktualisiert am $DATE" >> $FILE

