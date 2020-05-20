#!/bin/bash

if [ $# -ne 2 ]; then
	echo "Wrong number of parameters!" >&2
	exit 1;
fi

for i in "${1}" "${2}"; do
	if [ ! -d "${i}" -o ! -r "${i}" -o ! -x "${i}" ]; then
		echo "${i}: Directory doesn't exist or is not accessible!" >&2
		exit 2;
	fi
done

extensions=$(find "${1}" -type f -name "*.*" -printf "%f\n" 2> /dev/null  | sed -E "/^\./d" | sed -E "s/^.*\.([^.]+)$/\1/" | sort | uniq)

while read ext; do
	mkdir -p "${2}/${ext}";
	find "${1}" -name "*.${ext}" -print0 | xargs -0 mv -t "${2}/${ext}"
done < <(echo "$extensions")
