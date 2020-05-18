#!/bin/bash

if [ $# -eq 0 ]; then
		exit 1;
fi

read string;

if [ -z "${string}" ]; then
		exit 2;
fi

echo "----------------------------";

for arg; do			#equal to "for arg in "$@"
if [ -f "${arg}" -a -r "${arg}" ]; then
		echo "${arg}: $(fgrep "${string}" "${arg}" | wc -l) occurences";
else
		echo "${arg} can't be accessed!" >&2;
fi
done
