#!/bin/bash

read -p "Insert first file path: " file1
if [[ ! -f "${file1}" ]] || [[ ! -r "${file1}" ]]; then
	echo "File doesn't exist or is not readable" >&2;
	exit 1;
fi

read -p "Insert second file path: " file2
if [[ ! -f "${file2}" ]] || [[ ! -r "${file2}" ]]; then
	echo "File doesn't exist or is not readable" >&2;
	exit 2;
fi

read -p "Insert output file path: " output
if [[ ! -f "${output}" ]]; then
	echo "File "${output}" doesn't exist! It will be created! ";
elif [[ ! -w "${output}" ]]; then
	echo "File exists, but is not writable" >&2;
	exit 4;
fi

paste "${file1}" "${file2}" | sort -o "${output}"

