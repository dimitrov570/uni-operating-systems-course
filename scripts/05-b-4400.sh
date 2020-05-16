#!/bin/bash

if [[ $#<1 || $#>2 ]]; then
		echo "Wrong number of arguments!" >&2
		exit 1;
fi

if [[ ! -d "${1}" || ! -r "${1}" ]]; then
		echo "Directory doesn't exist or is not readable!" >&2;
		exit 2;
fi


if (( $# == 1 )); then
		outDir=$(date "+%H-%d-%m-%Y");
else
		outDir="${2}";
fi

if [[ ! -d "${outDir}" ]]; then
		mkdir "${outDir}";
fi

if [[ ! -w "${outDir}" ]]; then
		echo "Output directory not writable" >&2;
		exit 3;
fi

find "${1}" -type f -mmin -45 2> /dev/null -exec cp {} "${outDir}/" ';';

read -p "Do you want to archive directory? [y/n]" ans
if [[ ${ans} == "y" ]]; then
	tar -cvf "${outDir}.tar" "${outDir}";
fi

