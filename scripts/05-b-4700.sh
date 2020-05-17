#!/bin/bash

delimeter=' '

if [ $# -gt 2 -o $# -lt 1 ]; then
		echo "Wrong number of arguments!" >&2;
		exit 1;
elif [[ ! "${1}" =~ ^[-]?[[:digit:]]+$ ]]; then
		echo "First argument is not an integer!" >&2;
		exit 2;
fi

if [ $# -eq 2 ]; then
		if [[ ${#2} == 1 ]]; then
				delimeter=${2}
		else
				echo "Delimeter must be of legnth 1" >&2;
				exit 2;
		fi
fi

NUMBER=$(echo "${1}" | sed -e "s/^[0]*//");
numberLength=${#NUMBER}
offset=0;
length=3;
output=

if [ ${NUMBER} -lt 0 ]; then
		output+="-";
		offset=1;
		((numberLength -= 1))
fi

leadingDigits=$((numberLength % 3))

if [ ${leadingDigits} -ne 0 ]; then
	output+="${NUMBER:${offset}:${leadingDigits}}"
	((offset+=${leadingDigits}))
fi

while [ ${offset} -lt ${numberLength} ]; do
	if [ ${offset} -eq 0 -o \( ${offset} -eq 1 -a ${NUMBER} -lt 0 \) ]; then		
		output+="${NUMBER:${offset}:${length}}";
	else
		output+="${delimeter}${NUMBER:${offset}:${length}}";
	fi
	((offset+=3));
done

echo "${output}"
