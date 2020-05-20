#!/bin/bash

if [ $# -ne 2 ]; then
		echo "Wrong number of parameters" >&2;
		exit 1;
fi

if [ ! -d "${1}" -o ! -r "${1}" -o ! -x "${1}" ]; then
		echo "Directory doesn't exist or is not accessible!" >&2;
		exit 2;
fi

if [[ ! "${2}" =~ ^[[:digit:]]+$ ]]; then
		echo "Second argument is not number!" >&2;
		exit 3;
fi

sum=0;

while read size; do
		((sum += size));
done < <(find "${1}" -type f -size +${2}c -printf "%s\n" 2> /dev/null)

echo ${sum};
