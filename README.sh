#!/bin/env bash
#
# README.sh
#
# Dieses Skript:
#
# aktualisiert über git pull das lokale Repository
# erzeugt automatisch eine aktuelle README.md
# lädt die Änderungen per git push in das remote Repository
# wird über den cron-Dienst bspw. fünf-minütlich getriggert:
# 5 * * * * /home/foo/Linux/README.sh

cd `dirname $0`

a=`date`
echo -e "$a :: this is README.sh" >> ../README.log

a=`ping -c1 github.com 2>&1`
if [ $? -ne 0 ]
then
    exit
fi

a=`git fetch 2>&1`
if [ "$a" == "" ]
then
    exit
fi

a=`date`
echo -e "$a :: perform README.md update" >> ../README.log
a=`git merge 2>&1`

FILE='./README.md'
DATE=`date`
MD='*.md'
echo -e "# \`Linux\`\n" > $FILE
echo -e "\`Das Schweizer Taschenmesser für den Linuxalltag.\`\n" >> $FILE
echo -e "#### \`HAUPTVERZEICHNIS\`\n" >> $FILE
LIST=(`ls | grep -E "${MD}" | grep -Ev README`)
for NAME in "${LIST[@]}"; do
  TRAILER=$(head -1 ./$NAME | sed 's/# //g')
  echo "[\`$TRAILER\`]($NAME)<br>" >> $FILE
done
DIRS=(`tree -fid --noreport`)
unset DIRS[0]
for DIR in "${DIRS[@]}"; do
  DIR=${DIR#./}
  echo -e "\n#### \`VERZEICHNIS: $DIR\`\n" >> $FILE
  LIST=(`ls $DIR`)
  DIR=${DIR#./}
  for NAME in "${LIST[@]}"; do
    echo "[\`$NAME\`]($DIR/$NAME)<br>" >> $FILE
  done
done
echo -e "\n---\n" >> $FILE
echo "\`Aktualisiert am $DATE\`" >> $FILE

a=`git add * 2>&1`
a=`git commit -m "README.md: cron-driven update" 2>&1`
a=`git push 2>&1`
a=`date`
echo -e "$a :: README.md update done" >> ../README.log
