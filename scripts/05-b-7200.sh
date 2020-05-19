#!/bin/bash

[ $# -eq 0 ] && exit 1;

for arg; do

if [ -f "${arg}" -a -r "${arg}" ]; then
	echo "File '${arg}' is readable!";
elif [ -d "${arg}" -a -r "${arg}" -a -x "${arg}" ]; then
	nrOfFiles=$(find "${arg}" -mindepth 1 -type f 2> /dev/null | wc -l)
	echo "Files in '${arg}' with size greater than ${nrOfFiles} bytes:";
	find "${arg}" -mindepth 1 -size -${nrOfFiles}c -printf "\t%p\n" 2> /dev/null
else
	echo "'${arg}' can't be accessed!" >&2;
fi
done
