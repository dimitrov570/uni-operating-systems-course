#!/bin/bash

if [[ $# != 1 ]]; then
		echo "Only one parameter expected!" >&2;
		exit 1;
fi

if [[ ! -f "${1}"  || ! -r "${1}" ]]; then
		echo "File not regular or readable!" >&2;
		exit 2;
fi

brackets=($(grep -oE "[{}]" "${1}" | tr -d ' '))   #extract only brackets from file and assign them to an array
brackets_size=${#brackets[@]}    #number of elements in array
openedBraces=0
maxNest=0

for i in $(seq 0 $((${brackets_size}-1))); do
	if [[ "${brackets[$i]}" == "{" ]]; then
		$((++openedBraces));
	elif [[ ${brackets[$i]} == "}" ]]; then
		if [[ ${openedBraces} > ${maxNest} ]]; then
				maxNest=${openedBraces};
		fi
		$((--openedBraces));
	fi
done

echo "${maxNest}"
