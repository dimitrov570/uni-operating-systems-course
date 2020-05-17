#!/bin/bash

if [ $# -ne 2 ]; then
		echo "Wrong number of parameters" >&2;
		exit 1;
fi

if [ ! -f ${1} -o ! -r ${1} ]; then
		echo "File not regular or readabe" >&2;
		exit 2;
fi

if [ ! -r  ${2} -o ! -x ${2} ]; then
		echo "Directory doesn't exist or can't be accessed!" >&2;
		exit 3;
fi

fileHash=$(sha256sum ${1} | cut -d ' ' -f 1);

fileSize=$(stat ${1} -c "%s")

while read fName; do
	newHash=$(sha256sum ${fName} | cut -d ' ' -f 1);
	if [ ${fileHash} = ${newHash} ]; then
			echo "${fName}";
	fi
done < <(find ${2} -type f -size "${fileSize}c" ! -samefile "${1}" 2> /dev/null)
