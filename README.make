#!/bin/bash

# README.make
# Dieses Skript erzeugt automatisch eine aktuelle README.md-Datei
# aus den Dateien im Hauptverzeichnis

FILE='./README.md'
DATE=`date`

echo -e "# Linux\n" > $FILE
echo -e "Das Schweizer Taschenmesser für den Linuxalltag.\n" >> $FILE
echo -e "### HAUPTVERZEICHNIS\n" >> $FILE

LIST=(`ls | grep -E '*.md|*.txt|*.sh|*.pl' | grep -Ev README`)

for NAME in "${LIST[@]}"; do
  TRAILER=$(head -1 ./$NAME | sed 's/# //g')
  echo "* [$TRAILER]($NAME)" >> $FILE
done

DIRS=(`tree -fid --noreport`)
unset DIRS[0]

for DIR in "${DIRS[@]}"; do
  DIR=${DIR#./}
  echo -e "\n### VERZEICHNIS: $DIR\n" >> $FILE
  LIST=(`ls $DIR | grep -E '*.md' | grep -Ev README`)
  DIR=${DIR#./}
  for NAME in "${LIST[@]}"; do
    TRAILER=$(head -1 ./$DIR/$NAME | sed 's/# //g')
    echo "* [$TRAILER]($DIR/$NAME)" >> $FILE
  done
  LIST=(`ls $DIR | grep -E '*.txt|*.sh|*.pl' | grep -Ev README`)
  for NAME in "${LIST[@]}"; do
    echo "* [$NAME]($DIR/$NAME)" >> $FILE
  done
done

echo -e "\n---\n" >> $FILE
echo "##### Aktualisiert am $DATE" >> $FILE
