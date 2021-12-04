#!/bin/env bash

a=`git fetch 2>&1`
while [ "$a" == "" ]; do
    sleep 10
    a=`git fetch 2>&1`
    echo "git fetch"
done

git merge
echo "git merge"

bash ./README.build

git add *
git commit -m "autoupdate README.md"
git push
