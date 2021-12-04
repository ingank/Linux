#!/bin/env bash

a=`git fetch`
while [ "$a" == "" ]; do
    sleep 10
    a=`git fetch`
    echo "git fetch"
done

git merge
echo "git merge"

bash ./README.build

git push
