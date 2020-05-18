#!/bin/bash

if [ $# -ne 1 -a $# -ne 2 ]; then
		echo "Wrong number of arguments!" >&2;
		exit 1;
fi

if [ ! -d "${1}" -o ! -r "${1}" -o ! -x "${1}" ]; then
		echo "Directory doesn't exist or is not accessible!" >&2;
		exit 2;
fi

if [ $# -eq 2 -a ! "${2}" = "-a" ]; then
		echo "${2} is not a valid option!" >&2;
		exit 3;
fi

if [ "${2}" = "-a" ]; then
	while read name; do
			if [ -d "${name}" -a -r "${name}" -a -x "${name}" ]; then
				nrOfDirectories=$(find "${name}" -mindepth 1 2> /dev/null | wc -l);
				echo "${name} (${nrOfDirectories} entries)";
			elif [ -f "${name}" -a -r ${name} ]; then
				fileSize=$(stat "${name}" -c "%s");
				echo "${name} (${fileSize} bytes)";
			fi
	done < <(find "${1}" -mindepth 1 2> /dev/null) 
else
	while read name; do
			if [ -d "${name}" -a -r "${name}" -a -x "${name}" ]; then
				nrOfDirectories=$(find "${name}" -mindepth 1 2> /dev/null | wc -l);
				echo "${name} (${nrOfDirectories} entries)";
			elif [ -f "${name}" -a -r ${name} ]; then
				fileSize=$(stat "${name}" -c "%s");
				echo "${name} (${fileSize} bytes)";
			fi
	done < <(find "${1}" -mindepth 1 -not -regex '.*/\..*' 2> /dev/null) 
fi
