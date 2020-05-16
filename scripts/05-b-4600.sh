#!/bin/bash

if [[ $# != 3 ]]; then
 	echo "Wrong number of arguments";
	exit 4;
fi

if [[ "${1}" =~ ^[-]?[[:digit:]]+$ && "${2}" =~ ^[-]?[[:digit:]]+$ && "${3}" =~ ^[-]?[[:digit:]]+$ ]]; then
		if [[ ${2} -gt ${3} ]]; then
				exit 2;
		elif [[ ${1} -lt ${2} || ${1} -gt ${3} ]]; then
				exit 1;
		fi
else
		exit 3;
fi

