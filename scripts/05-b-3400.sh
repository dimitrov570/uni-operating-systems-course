#!/bin/bash

read -p "Insert file path: " file
if [[ ! -f "${file}" ]] || [[ ! -r "${file}" ]]; then
	echo "File doesn't exist or is not readable" >&2;
	exit 1;
fi

read -p "Insert string: " str
if [[ -z "${str}" ]]; then
		echo "Empty string!" >&2;
		exit 1;
fi
fgrep -sq "${str}" "${file}";
exitStatus=$?;
echo "${exitStatus}";
