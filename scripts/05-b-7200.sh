#!/bin/bash

[ $# -eq 0 ] && exit 1;

for arg; do

if [ -f "${arg}" -a -r "${arg}" ]; then
	echo "File '${arg}' is readable!";
elif [ -d "${arg}" -a -r "${arg}" -a -x "${arg}" ]; then
	nrOfFiles=$(find "${arg}" -mindepth 1 -type f 2> /dev/null | wc -l)
	echo "Files in '${arg}' with size greater than ${nrOfFiles} bytes:";
	result="$(find "${arg}" -mindepth 1 -size -${nrOfFiles}c -printf "\t%p\n" 2> /dev/null)"
	if [ -n "${result}" ]; then
			echo "${result}";
	else
			echo -e "\t-No files found that match that criteria!";
	fi
	
else
	echo "'${arg}' can't be accessed!" >&2;
fi
done
