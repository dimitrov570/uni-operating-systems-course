#!/bin/bash

if [ $# -ne 1 ]; then
		echo "Wrong number of parameters!" >&2
		exit 1
fi

colorCode=
color="${1}"
while read line; do
	case "${color}" in	
		"-x")   echo "${line}";
				continue;
				;;
		"-r")	colorCode="\033[0;31m"
				color="-g"
				;;
		"-g")	colorCode="\033[0;32m"
				color="-b"
				;;
		"-b")	colorCode="\033[0;34m"
				color="-r"
				;;
		   *) 	echo "Unknown colour!"	
			  	exit 2
				;;
esac
			echo -e "${colorCode}${line}";
			echo -en "\033[0m";
done
