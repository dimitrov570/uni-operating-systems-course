#!/bin/bash

if [ $# -ne 2 ]; then
		exit 1;
fi

if ! echo $1 | egrep -q "^[-]?[0-9]+$"; then
		exit 2;
elif ! echo $2 | egrep -q "^[-]?[0-9]+$"; then
		exit 3;
fi

if [ -d "a" -o -d "b" -o -d "c" ]; then
		exit 4;
fi

mkdir a b c

while read fileName; do
		lineNr=$(cat "${fileName}" | wc -l); 
		if [ ${lineNr} -lt $1 ]; then
				mv "${fileName}" a;
		elif [ ${lineNr} -le $2 ]; then
				mv "${fileName}" b;
		else
				mv "${fileName}" c;
		fi
done < <(find . -maxdepth 1 -type f 2> /dev/null)
