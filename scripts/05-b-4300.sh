#!/bin/bash

if [[ $# != 2 ]]; then
		echo "Wrong number of parameters!" >&2;
		exit 1;
fi

if [[ ! -f "${1}" || ! -r "${1}" ]]; then
		echo "File not regular or readable!" >&2;
		exit 2;
fi

username=$(grep -E "${2}" "${1}" | cut -d ' ' -f2)

if [[ -z "${username}" ]]; then
		echo "User doesn't exist";
		exit 3;
else
		write "${username}";
fi
