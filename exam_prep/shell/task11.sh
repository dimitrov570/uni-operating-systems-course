#!/bin/bash

tmp=$(cat test_11.txt | grep "/home/SI" | cut -d ':' -f 1,5,6 | sed "s/,[^:]*:/:/")

echo -e "$tmp"

dirs=$(echo -e "$tmp" | cut -d ':' -f3)

echo -e "$dirs"

while read line; do
		dir=$(echo $line | cut -d ':' -f3)
		statCh=$(stat "%Z" $dir);
		if [ $statCh -gt 1551168000 -a $statCh -lt 1551176100 ]; then
				echo $line | cut -d ':' -f1,2 | cut -c 2- | tr ':' ' ';
		fi
done < <(echo -e "$tmp")
