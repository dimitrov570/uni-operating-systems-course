#!/bin/bash

if [ $# -ne 1 ]; then
		echo "Wrong number of arguments!" >&2;
		exit 1;
fi

if [ ! -d "${1}" -o ! -r "${1}" -o ! -x "${1}" ]; then
		echo "Argument not directory or not accessible!" >&2;
		exit 2;
fi

oldHash=

while read hash name; do
		if [ "${hash}" = "${oldHash}" ]; then
				rm  "${name}";
		else
				oldHash="${hash}"
		fi
done < <(find "${1}" -type f -exec sha256sum {} ';' | sort)
