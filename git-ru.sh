#!/bin/bash

echo "this is shell script"


if [$# -eq 0]; then
	message=$(date)
else
	message="$1"
fi

#dt=$(date)
#echo "$dt"
git add .
git commit -m "$message"
git push -u origin main
