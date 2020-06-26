#!/bin/bash

if [ $(id -u) -ne 0 ]; then
		exit 100;
fi

if [ $# -ne 3 ]; then
		exit 1;
fi

[ -d "$1" -a -r "$1" -a -x "$1" ] || exit 2;

if [ $(find "$2" -type f | wc -l) -ne 0 ]; then
		exit 3;
fi

[ -d "$2" -a -r "$2" -a -x "$2" ] || exit 4;

TMP=$(find "$1" -type f -name "*$3*" -printf "%h:%f\n" 2> /dev/null | sed -E "s/^$1\///")

while read pName; do
	mkdir -p "${2}/${pName}" 2> /dev/null;
done < <(echo -e "$TMP" | cut -d ':' -f | sort -n | uniq)

while read pName fName; do
	cp "${1}/${pName}/${fName}" "${2}/${pName}/${fName}"
done < <(echo -e "$TMP" | tr ':' ' ')
